//! 世界编排：把 [`BodyPlan`] 组装成 rapier2d 的刚体 + 关节，并按固定步长推进。
//!
//! 单位约定：**内部一律用米**。RON 里写的是厘米，装载时统一 ×0.01。
//! 这样 rapier 的默认容差（毫米级）才是合理的。
//!
//! 本 crate 依赖 rapier2d，但不依赖 Bevy —— 渲染是别人的事。

pub mod actions;
pub mod connect;
pub mod creature;
pub mod edit;
pub mod fracture;
pub mod grab;
pub mod items;
pub mod props;
pub mod rewind;
pub mod save;
pub mod sever;

pub use connect::{Conn, ConnKind};
pub use creature::Creature;
pub use fracture::{FractureConfig, SliceReport};
pub use grab::Grab;
pub use items::{Category, ItemCatalog, ItemDef, Shape};
pub use rewind::{Rewind, Snapshot};
pub use save::{SAVE_VERSION, SaveFile};
pub use sever::{SeverOutcome, apply_cut, build_tissue, layer_kind};

use anatomize_body::{BodyPlan, JointHealth, JointLoad, JointParams, JointState};
use anatomize_core::time::dt_of;
use anatomize_core::{DT, JointId, PartId, TISSUE_HZ, Tick, Vec2};
use anatomize_physio::{Physio, PhysioInput};
use anatomize_tissue::{TissueConfig, TissueSim};
use rapier2d::prelude::*;

/// RON 用厘米，物理用米。
pub const CM: f32 = 0.01;

/// 世界的大小（米）。地面在 `y = 0`，顶在 `y = height`。
///
/// 沙盒需要一个**有边界**的世界：不然碎片会飞到无穷远，相机找不到它们，
/// 存档也没法定义"这个世界有多大"。P0 默认 4×3 米（一个人 + 周围一点空间），
/// 以后可以按需求建更大的。
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct WorldBounds {
    pub width: f32,
    pub height: f32,
}

impl Default for WorldBounds {
    fn default() -> Self {
        Self {
            width: 4.0,
            height: 3.0,
        }
    }
}

impl WorldBounds {
    pub const fn new(width: f32, height: f32) -> Self {
        Self { width, height }
    }

    pub fn half_w(&self) -> f32 {
        self.width * 0.5
    }

    /// 人站在地面上时，骨盆大概该放多高（米）。
    pub fn stand_height(&self) -> f32 {
        (self.height * 0.25).clamp(0.7, 1.2)
    }
}

/// rapier 0.36 已从 nalgebra 迁到 glam，这里显式别名，避免和 `anatomize_core::Vec2` 混淆。
type RVec2 = rapier2d::math::Vec2;

#[inline]
fn rv(v: Vec2) -> RVec2 {
    RVec2::new(v.x, v.y)
}

pub struct Physics {
    gravity: RVec2,
    integration: IntegrationParameters,
    pipeline: PhysicsPipeline,
    pub(crate) islands: IslandManager,
    broad_phase: BroadPhaseBvh,
    narrow_phase: NarrowPhase,
    // 碎片系统（`fracture.rs`）要直接建删刚体，所以这些字段在 crate 内可见。
    pub(crate) bodies: RigidBodySet,
    pub(crate) colliders: ColliderSet,
    pub(crate) impulse_joints: ImpulseJointSet,
    pub(crate) multibody_joints: MultibodyJointSet,
    soft_bodies: SoftBodySet,
    ccd: CCDSolver,
}

impl Default for Physics {
    fn default() -> Self {
        Self::new()
    }
}

impl Physics {
    pub fn new() -> Self {
        let mut integration = IntegrationParameters::default();
        integration.dt = DT;
        // ragdoll 的链式约束比刚体堆叠更难收敛，8 次是手感的甜点
        integration.num_solver_iterations = 8;

        Self {
            gravity: RVec2::new(0.0, -9.81),
            integration,
            pipeline: PhysicsPipeline::new(),
            islands: IslandManager::new(),
            broad_phase: BroadPhaseBvh::new(),
            narrow_phase: NarrowPhase::new(),
            bodies: RigidBodySet::new(),
            colliders: ColliderSet::new(),
            impulse_joints: ImpulseJointSet::new(),
            multibody_joints: MultibodyJointSet::new(),
            soft_bodies: SoftBodySet::new(),
            ccd: CCDSolver::new(),
        }
    }

    fn step(&mut self) {
        self.pipeline.step(
            self.gravity,
            &self.integration,
            &mut self.islands,
            &mut self.broad_phase,
            &mut self.narrow_phase,
            &mut self.bodies,
            &mut self.colliders,
            &mut self.impulse_joints,
            &mut self.multibody_joints,
            &mut self.soft_bodies,
            &mut self.ccd,
            &(),
            &(),
        );
    }
}

pub struct PartInstance {
    pub id: PartId,
    pub body: RigidBodyHandle,
    pub collider: ColliderHandle,
}

pub struct JointInstance {
    pub id: JointId,
    pub a: PieceId,
    pub b: PieceId,
    /// 硬约束（revolute）。`Dislocated` 之后被移除，handle 失效。
    pub handle: ImpulseJointHandle,
    /// 两端锚点，各自在**部件局部厘米**坐标系（不是块局部）。
    ///
    /// 存部件局部而不是块局部，是因为切开之后锚点可能落到新的那块上——
    /// 换算成块局部只需要减一次 `Piece::centroid`，反过来要存两套。
    pub anchor_a: Vec2,
    pub anchor_b: Vec2,
    /// 解剖活动度（弧度），来自 `BodyPlan`，**永不改变**。
    /// 关节坏了以后 rapier 那边的限位会放宽，但"正常的活动度"这个参照系不能动，
    /// 否则 `JointHealth` 会拿放宽后的限位去比，越伤越不疼。
    pub rest_limits: (f32, f32),
    /// 关节健康四量 + 状态机。
    pub health: JointHealth,
    /// 脱位后的软约束（rope）。`Intact` 时为 None。
    pub tether: Option<ImpulseJointHandle>,
    /// tether 的静止长度（米），= 装配时两锚点的间距。
    pub tether_rest: f32,
    /// 属于哪一具生物。
    pub creature: u16,
    /// 这一刀能不能把它切断。
    ///
    /// 抄 MaD2 的 `jointUserData.cuttable`：装甲、武器挂架、自动关节那些
    /// "结构件"是 `false`——不然玩家一刀扫过去，枪就从手上掉下来了。
    /// 解剖关节全部是 `true`（切到膝盖就该断）。
    ///
    /// **暂停时可以切**：MaD2 的条件是
    /// `if(!(!cuttable && TimeLord.speed != 0))` —— 时间停住的时候，
    /// 连不可断的关节也能断。那是个"编辑模式"的口子。
    pub cuttable: bool,
}

impl JointInstance {
    pub fn state(&self) -> JointState {
        self.health.state
    }
}

/// 一块刚体的编号。
///
/// 解剖上的一"部件"（`PartId`）和物理上的一"块"（`PieceId`）不是一回事：
/// 大腿切开之后还是一个 `thigh_l` 部件，但变成了两块刚体，一块还连着髋、
/// 一块还连着膝。所以关节挂的是 `PieceId`，不是 `PartId`。
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, PartialOrd, Ord)]
pub struct PieceId(pub u32);

impl PieceId {
    pub fn index(self) -> usize {
        self.0 as usize
    }
}

/// 物理上的一块肉。
///
/// `polygon` 和 `centroid` 都在**部件局部厘米**坐标系里——和 `BodyPlan` 一致，
/// 也和断面分层（`anatomize_cut::section`）一致。只有这样，切开之后每一块
/// 还能回答"我这个像素在原部件里有多深"，断面色带才不会跟着碎。
#[derive(Debug, Clone)]
pub struct Piece {
    /// 这块属于哪个解剖部件。组织场、血管、层色都按它查。
    pub part: PartId,
    pub body: RigidBodyHandle,
    pub collider: ColliderHandle,
    /// 部件局部厘米坐标下的多边形（逆时针）。
    pub polygon: Vec<Vec2>,
    /// 这块的质心，部件局部厘米。刚体的世界位置 = 部件位姿 × centroid。
    pub centroid: Vec2,
    pub mass: f32,
    /// 连续静止了多久（秒）。到了阈值就冻结。
    pub still_s: f32,
    /// 冻结后的位姿（世界米 + 弧度）。冻结的块已经从物理世界摘掉，
    /// 没有刚体可查，但渲染还要画它。
    pub frozen_pose: Option<(Vec2, f32)>,
    /// 物品目录里的下标。`None` = 身体的一部分（走解剖分层渲染）。
    pub item: Option<u16>,
    /// 这块自己的 4×4 组织快照（灌注 / 氧 / 温度 / 损伤）。
    ///
    /// 场钉在身体坐标系里，块飞走之后就不能再查场了。所以切开的那一刻把
    /// 这块采样成 4×4 存下来，之后**热力图跟着块走**——一块肉一层色，
    /// 色跟着肉飞，块内还有梯度。
    ///
    /// `None` = 主块（它还在场里，每帧现采样）。
    pub heat: Option<anatomize_tissue::HeatGrid>,
    /// 属于哪一具生物（`Sim::creatures` 的下标）。
    ///
    /// 道具是 `u16::MAX`（不属于任何一具）。有了这个标签，切割 / 冻结 /
    /// 删除 / 拾取 / 渲染全都不用改——它们只认块，需要按生物区分的
    /// 只有生理、组织场、姿态。
    pub creature: u16,
    /// 被删除工具移除。刚体已经没了，渲染也跳过。
    ///
    /// 不做 `Vec::remove` 是因为 `PieceId` 就是下标——删一个会让后面所有
    /// 引用（关节、选中、回滚快照）全部错位。墓碑便宜得多。
    pub deleted: bool,
}

impl Piece {
    pub fn is_frozen(&self) -> bool {
        self.frozen_pose.is_some()
    }
}

/// 一具装在物理世界里的人。
pub struct BodyInstance {
    /// **所有生物**的解剖关节。`JointInstance::creature` 标归属。
    pub joints: Vec<JointInstance>,
    /// **所有生物**的物理块。切开一次就多一块。
    ///
    /// 全局一张表而不是每具一份：两具身体的碎块要互相碰撞，一把刀要能同时
    /// 切到两具。`PieceId` 全局唯一，所以切割 / 冻结 / 删除 / 拾取 / 渲染
    /// 都不用知道"生物"这个概念。
    pub pieces: Vec<Piece>,
}

impl BodyInstance {
    /// 空世界（还没装生物）。
    pub fn empty() -> Self {
        Self {
            joints: Vec::new(),
            pieces: Vec::new(),
        }
    }
}

pub struct Sim {
    pub physics: Physics,
    pub plan: BodyPlan,
    pub body: BodyInstance,
    pub tick: Tick,
    pub ground: ColliderHandle,
    /// 地面高度（米）。渲染画地面线用。
    ground_y: f32,
    /// 世界大小（米）。边界墙按它建。
    pub world: WorldBounds,
    /// 物品目录（外置 RON）。道具的渲染颜色、名字、分类都查它。
    pub catalog: ItemCatalog,
    /// 每帧最多切几块（MaD2 的 "Max Cuts / Frame"，默认 12）。
    ///
    /// 这是**防冻屏**的护栏：一刀扫过整具身体最多产生十几块，再多的块会让
    /// 求解器在一帧里解不完。MaD2 的默认值是 10，`Cutter` 里的静态值是 12。
    pub cut_limit: u32,
    /// 本帧已经切了几块。`step()` 每帧清零。
    pub cuts_this_frame: u32,
    /// 手正在抓着的东西。
    ///
    /// 存**抓取点**而不是"整块的线速度"：力作用在偏离质心的点上才会产生力矩，
    /// 抓着一只手拖的时候身体才会翻转。见 `grab.rs`。
    grab_state: Option<Grab>,
    /// 玩家连出来的东西（焊接 / 钉住 / 绳 / 铰链 / 活塞）。
    ///
    /// 和解剖关节（`body.joints`）分开放：那套有健康四量、状态机、姿态目标，
    /// 索引还要和 `Posture.targets` 对齐。玩家的连接没有健康——它只有"断没断"。
    pub conns: Vec<crate::connect::Conn>,
    /// 关节损伤参数（来自 `assets/config/damage.ron`）。
    pub damage: JointParams,
    /// 累计发生过的状态迁移，按发生顺序。HUD / 日志 / 验收图都读它。
    pub injuries: Vec<(JointId, JointState, f32)>,
    /// **所有生物**。每具带自己的生理、组织场、姿态目标。
    ///
    /// 块和关节**不在这里**——它们挂在 `body` 上，用 `Piece::creature` /
    /// `JointInstance::creature` 标归属。理由见 `creature.rs` 的模块注释。
    pub creatures: Vec<Creature>,
    /// 当前操作的那一具（切割、喂食、检视、相机都跟着它）。
    pub active: usize,
    /// 碎片预算与冻结（M6）。
    pub fracture: FractureConfig,
    /// 累计切了几刀。验收标准 8 的"连续断裂 100 次"按它计数。
    pub slices: u32,
    /// 5 秒回溯的环形缓冲。
    pub rewind: Rewind,
}

/// 姿态控制：往一组目标关节角上做 PD 拉。
///
/// 为什么不用 rapier 的关节电机：0.36 的 motor API 只作用在单个 DOF 上，
/// 而且要先切 `MotorModel`，跨版本不稳。直接给两个刚体施加一对反向力矩，
/// 语义更清楚，也和设计文档 9.3 的 `apply_tone` 一一对应。
///
/// **肌张力 = 意识 × 交感张力**，再乘一个疼痛保护系数。所以一个人失血到昏迷时
/// 会软下去、伤了的关节会护着——这两件事走的是同一个数。
pub struct Posture {
    /// 每个关节的目标角（弧度），按 `body.joints` 的顺序。
    pub targets: Vec<f32>,
    /// 全局刚度**倍率**。真正的刚度在 `BodyPlan` 的每条关节上
    /// （髋 1500、膝 1200、肘 400 …）。这里是整体缩放：1.0 = 按解剖值。
    pub stiffness: f32,
    /// 全局阻尼倍率。同上。
    pub damping: f32,
    /// 平衡辅助的强度（0 = 关）。
    ///
    /// # 为什么不是"把刚度调大"
    ///
    /// 试过：刚度 26 → 600 → 1500。**越大越糟**——1500 的时候骨盆角速度抖到
    /// 359 rad/s，人直接翻过去。因为 PD 是显式积分，刚度上去之后
    /// `k·dt²/I > 1`，每一步都过冲。
    ///
    /// 而且方向就不对：站起来需要的是**绕地面接触点**的力矩，而 PD 施加的是
    /// 绕**关节**的力矩。关节再硬，脚下没有踝关节，整个人还是一根倒立摆。
    ///
    /// 所以平衡单独做：看质心投影落在两脚之间没有，偏了就在骨盆上推一把。
    /// 这是真的"重心修正"，不是硬顶。
    pub balance: f32,
}

impl Posture {
    /// 用当前关节角当目标（"保持现状"）。
    pub fn holding(sim: &Sim) -> Self {
        let targets = (0..sim.body.joints.len())
            .map(|i| sim.joint_load(i).angle)
            .collect();
        Self {
            targets,
            stiffness: 0.5,
            damping: 0.5,
            balance: 1.0,
        }
    }

    /// 站姿：目标角全 0（= 装配姿态），平衡辅助开满。
    ///
    /// 和 `holding` 的区别：`holding` 是"保持现在这个样子"（可能是躺着的），
    /// 这个是"站直"。刚生成的时候必须用这个——用 `holding` 的话，
    /// 装配姿态下沉 9cm 之后再取目标，人就定在了一个含胸驼背的姿势上。
    ///
    /// `targets` 按**全局关节下标**索引（不是每具一份）。多具生物时用不到的
    /// 那些位置一直是 0，无害——`apply_posture` 只碰自己那具的关节。
    pub fn standing(sim: &Sim) -> Self {
        Self {
            targets: vec![0.0; sim.body.joints.len()],
            stiffness: 0.5,
            damping: 0.5,
            balance: 1.0,
        }
    }
}

impl Sim {
    /// 建世界 + 一具人体。`origin` 是身体局部原点在世界中的位置（米）。
    pub fn spawn(plan: BodyPlan, origin: Vec2, ground_y: f32) -> Self {
        let damage = anatomize_body::DamageConfig::asset().joint;
        Self::spawn_with(plan, origin, ground_y, damage)
    }

    /// 同上，但显式指定损伤参数（测试与参数扫描用）。
    ///
    /// 注意这里给的是**很大的世界**：老 API 的语义是"地面之上是无限空间"，
    /// 突然给一个 4×3 米的盒子会让从 y=40 掉下来的身体撞到天花板，
    /// 落地冲量从 0.6 涨到 2.6，把 M3 的标定全部推翻。
    pub fn spawn_with(plan: BodyPlan, origin: Vec2, ground_y: f32, damage: JointParams) -> Self {
        Self::spawn_in_world(
            plan,
            origin,
            ground_y,
            damage,
            WorldBounds::new(60.0, 200.0),
        )
    }

    /// 在一个指定大小的世界里建身体。
    pub fn spawn_in(plan: BodyPlan, origin: Vec2, world: WorldBounds) -> Self {
        let damage = anatomize_body::DamageConfig::asset().joint;
        Self::spawn_in_world(plan, origin, 0.0, damage, world)
    }

    /// 最底层那个：世界尺寸、地面高度、损伤参数全都显式给。
    ///
    /// 只建**世界**（地面 + 四面墙），然后 `add_creature` 装上第一具。
    /// 第二具以后直接调 `add_creature`，走的是同一条路。
    pub fn spawn_in_world(
        plan: BodyPlan,
        origin: Vec2,
        ground_y: f32,
        damage: JointParams,
        world: WorldBounds,
    ) -> Self {
        let mut sim = Self::spawn_empty(plan, ground_y, damage, world);
        sim.add_creature(origin);
        sim
    }

    /// 只建世界（地面 + 四面墙），**不装任何生物**。
    ///
    /// 读档用：存档里已经有完整的块/关节/生物列表，不需要先装一具再拆掉。
    pub fn spawn_empty(
        plan: BodyPlan,
        ground_y: f32,
        damage: JointParams,
        world: WorldBounds,
    ) -> Self {
        let mut physics = Physics::new();

        // 四面墙。没有墙的话碎片会飞出去，然后永远找不到。
        let ground = physics.colliders.insert(
            ColliderBuilder::cuboid(world.half_w() + 0.2, 0.05)
                .translation(RVec2::new(0.0, ground_y - 0.05))
                .friction(0.9)
                .build(),
        );
        for sx in [-1.0f32, 1.0] {
            physics.colliders.insert(
                ColliderBuilder::cuboid(0.05, world.height * 0.5 + 1.0)
                    .translation(RVec2::new(
                        sx * (world.half_w() + 0.05),
                        ground_y + world.height * 0.5,
                    ))
                    .friction(0.6)
                    .build(),
            );
        }
        physics.colliders.insert(
            ColliderBuilder::cuboid(world.half_w() + 0.2, 0.05)
                .translation(RVec2::new(0.0, ground_y + world.height + 0.05))
                .friction(0.6)
                .build(),
        );

        Self {
            physics,
            plan,
            body: BodyInstance::empty(),
            creatures: Vec::new(),
            active: 0,
            tick: Tick(0),
            ground,
            ground_y,
            world,
            catalog: ItemCatalog::asset(),
            cut_limit: 12,
            cuts_this_frame: 0,
            grab_state: None,
            conns: Vec::new(),
            damage,
            injuries: Vec::new(),
            fracture: FractureConfig::default(),
            slices: 0,
            rewind: Rewind::default_5s(),
        }
    }

    /// 往世界里再装一具身体，返回它的下标（同时设为 `active`）。
    ///
    /// 这是多 ragdoll 的**唯一入口**：块、关节、部件句柄、生理、组织场、
    /// 姿态控制器全在这里一次性建好。`spawn_in_world` 也走它，
    /// 所以"第一具"和"第十具"没有两套代码。
    pub fn add_creature(&mut self, origin: Vec2) -> usize {
        let index = self.creatures.len() as u16;
        let mut parts = Vec::with_capacity(self.plan.parts.len());
        let mut handles: Vec<RigidBodyHandle> = Vec::with_capacity(self.plan.parts.len());
        let mut primary = Vec::with_capacity(self.plan.parts.len());

        // 块号 = 追加到**全局**块表里的下标。先算出来，关节要用它。
        let base = self.body.pieces.len() as u32;

        for part in &self.plan.parts {
            let center = origin + part.offset * CM;

            let rb = RigidBodyBuilder::dynamic()
                .translation(rv(center))
                .linear_damping(0.15)
                .angular_damping(0.5)
                .build();
            let handle = self.physics.bodies.insert(rb);

            let pts: Vec<RVec2> = part
                .polygon
                .iter()
                .map(|v| RVec2::new(v.x * CM, v.y * CM))
                .collect();

            let collider = ColliderBuilder::convex_hull(&pts)
                .expect("BodyPlan 已校验为凸多边形")
                // 面积单位是 m²，密度 = kg/m²
                .density(part.mass / (part.area * CM * CM))
                .friction(0.85)
                .restitution(0.02)
                .build();

            let collider = self.physics.colliders.insert_with_parent(
                collider,
                handle,
                &mut self.physics.bodies,
            );

            handles.push(handle);
            parts.push(PartInstance {
                id: part.id,
                body: handle,
                collider,
            });
        }

        // 关节
        for j in &self.plan.joints {
            let a = handles[j.a.index()];
            let b = handles[j.b.index()];
            let (anchor_a, anchor_b) = (j.anchor_a, j.anchor_b);

            let joint = RevoluteJointBuilder::new()
                .local_anchor1(rv(anchor_a * CM))
                .local_anchor2(rv(anchor_b * CM))
                .limits([j.limits.0, j.limits.1])
                // 相邻部件本来就有体积重叠（肩、髋、颈），必须关掉它们之间的碰撞，
                // 否则接触力会和关节约束对拉，能量越积越多
                .contacts_enabled(false)
                .build();

            let handle = self.physics.impulse_joints.insert(a, b, joint, true);
            let (wa, wb) = {
                let pa = self.physics.bodies[a]
                    .position()
                    .transform_point(rv(anchor_a * CM));
                let pb = self.physics.bodies[b]
                    .position()
                    .transform_point(rv(anchor_b * CM));
                (pa, pb)
            };
            self.body.joints.push(JointInstance {
                id: j.id,
                a: PieceId(base + j.a.0 as u32),
                b: PieceId(base + j.b.0 as u32),
                handle,
                anchor_a,
                anchor_b,
                rest_limits: j.limits,
                health: JointHealth::default(),
                tether: None,
                tether_rest: (wa - wb).length().max(1e-4),
                cuttable: true,
                creature: index,
            });
        }

        // 块：一个部件 = 一块
        for (i, part) in self.plan.parts.iter().enumerate() {
            self.body.pieces.push(Piece {
                part: part.id,
                body: handles[i],
                collider: parts[i].collider,
                polygon: part.polygon.clone(),
                centroid: Vec2::ZERO,
                mass: part.mass,
                still_s: 0.0,
                frozen_pose: None,
                item: None,
                heat: None,
                creature: index,
                deleted: false,
            });
            primary.push(PieceId(base + i as u32));
        }

        let mut c = Creature::empty(format!("人偶 {}", self.creatures.len() + 1));
        c.parts = parts;
        c.primary = primary;
        self.creatures.push(c);
        self.active = self.creatures.len() - 1;
        self.active
    }

    /// 这具生物还剩几块（没删的）。
    pub fn creature_pieces(&self, c: usize) -> usize {
        self.body
            .pieces
            .iter()
            .filter(|p| p.creature as usize == c && !p.deleted)
            .count()
    }

    /// 这具生物还有活块吗。
    pub fn creature_alive(&self, c: usize) -> bool {
        self.creature_pieces(c) > 0
    }

    /// 还有几具活着的生物。
    pub fn living_creatures(&self) -> usize {
        (0..self.creatures.len())
            .filter(|&c| self.creature_alive(c))
            .count()
    }

    /// 这块属于哪一具生物（道具返回 `None`）。
    pub fn creature_of(&self, id: PieceId) -> Option<usize> {
        let p = &self.body.pieces[id.index()];
        if p.item.is_some() || p.part == PartId::NONE {
            return None;
        }
        Some(p.creature as usize)
    }

    /// 换一个操作对象。下标越界返回 false。
    pub fn set_active(&mut self, c: usize) -> bool {
        if c < self.creatures.len() {
            self.active = c;
            true
        } else {
            false
        }
    }

    /// 给躯干一个初速度，打破"完美对称所以永远站着"的数值平衡。
    pub fn nudge(&mut self, v: Vec2) {
        let torso = self
            .plan
            .parts
            .iter()
            .position(|p| p.name == "torso")
            .expect("human_01 一定有 torso");
        let rb = &mut self.physics.bodies[self.creatures[self.active].parts[torso].body];
        rb.set_linvel(RVec2::new(v.x, v.y), true);
    }

    /// 给某个部件一个速度（测试 / 外力打击用）。
    pub fn set_part_velocity(&mut self, part: &str, v: Vec2) {
        let Some(p) = self.plan.parts.iter().position(|p| p.name == part) else {
            return;
        };
        let rb = &mut self.physics.bodies[self.creatures[self.active].parts[p].body];
        rb.set_linvel(RVec2::new(v.x, v.y), true);
    }

    /// 把某个部件钉死在世界里（`Fixed` 刚体）。
    ///
    /// 玩法上相当于"用钩子挂住"：验收图里把人体吊起来，腿才能真的垂下来、
    /// 才能看出脱位后是"挂着"还是"飞走"。地面上的 ragdoll 只会瘫成一堆，
    /// 什么都看不出来。
    pub fn set_part_fixed(&mut self, part: &str, fixed: bool) {
        let Some(p) = self.plan.parts.iter().position(|p| p.name == part) else {
            return;
        };
        let rb = &mut self.physics.bodies[self.creatures[self.active].parts[p].body];
        rb.set_body_type(
            if fixed {
                RigidBodyType::Fixed
            } else {
                RigidBodyType::Dynamic
            },
            true,
        );
    }

    pub fn step(&mut self) {
        self.check_grab();
        self.apply_balance();
        self.apply_posture();
        self.physics.step();
        // 载荷必须在刚解完的这一步读，否则读到的是上一帧的约束冲量
        self.update_joint_health();
        self.tick.advance();
        self.step_physio();
        // 活塞电机：每帧把目标速度刷到关节上（rapier 的电机速度是建关节时设的）
        self.update_pistons();
        // 切割预算每帧回满。MaD2 是 `Cutter.cutLimit = Vars.cutlimit`，
        // 在主循环里每帧设一次——同一个位置。
        self.cuts_this_frame = 0;
        // 回溯快照：内部按 stride 跳，不是每帧都存
        self.capture_rewind();
    }

    // -----------------------------------------------------------------------
    // L2 组织场 ↔ L4 生理：M4 的那条闭环
    // -----------------------------------------------------------------------

    /// 给这具身体挂一张组织场，并按当前 MAP 预热。
    ///
    /// 不预热会得到一整套假数：`p = 0` 冷启动时 8 次 Jacobi 只把边界信息推进
    /// 8 个 texel，第一秒的灌注和出血都是错的。
    pub fn attach_tissue(&mut self, cfg: &TissueConfig) {
        let mut sim = build_tissue(&self.plan, cfg);
        sim.warmup(self.creatures[self.active].physio.bus.map);
        self.creatures[self.active].tissue_metab_base = sim.cfg.metab_heat;
        self.creatures[self.active].ambient_c = sim.cfg.ambient_c;
        self.creatures[self.active].tissue = Some(sim);
    }

    /// 改环境温度。这是"冷"的唯一入口——玩家靠近温箱、走进冷库，都调这里。
    pub fn set_ambient(&mut self, c: f32) {
        self.creatures[self.active].ambient_c = c;
    }

    /// 吃一顿（kcal）。食物在 P0 里没有咀嚼和吞咽，判定"进了嘴"之后直接调这里。
    pub fn feed(&mut self, kcal: f32) -> f32 {
        self.creatures[self.active].physio.feed(kcal)
    }

    /// 用冲量打某个部件。
    ///
    /// `impulse` 和 `at_cm` 都在**部件局部坐标系**里（厘米）——和 `BodyPlan` 的
    /// 几何量同一套坐标。用局部坐标而不是世界坐标，是因为"打小腿中段"这件事
    /// 不随身体姿态变化：身体躺下了，小腿中段还是小腿中段。
    ///
    /// 打击点**离关节越远**，杠杆越长，关节承受的角冲量越大——这就是"打小腿
    /// 会伤膝盖"的物理来源，不需要额外规则。
    pub fn strike_part(&mut self, part: &str, impulse: Vec2, at_cm: Vec2) -> bool {
        let Some(p) = self.plan.parts.iter().position(|p| p.name == part) else {
            return false;
        };
        let handle = self.creatures[self.active].parts[p].body;
        let rb = &mut self.physics.bodies[handle];
        // 局部 → 世界：偏移和冲量都要跟着刚体转
        let at = rb
            .position()
            .transform_point(RVec2::new(at_cm.x * CM, at_cm.y * CM));
        let rot = *rb.rotation();
        let imp = rot * RVec2::new(impulse.x, impulse.y);
        rb.apply_impulse_at_point(imp, at, true);
        true
    }

    /// 直接打某一块（道具和身体部件都能打）。
    ///
    /// `strike_part` 是按**名字**找部件，道具没有名字（`part == NONE`），
    /// 所以工具层需要这个按编号的入口。
    pub fn strike_piece(&mut self, id: PieceId, impulse: Vec2, at_world: Vec2) -> bool {
        let p = &self.body.pieces[id.index()];
        if p.deleted || p.is_frozen() {
            return false;
        }
        let Some(rb) = self.physics.bodies.get_mut(p.body) else {
            return false;
        };
        // 冲量已经是世界方向；作用点用世界坐标
        rb.apply_impulse_at_point(rv(impulse), rv(at_world), true);
        true
    }

    /// 打开姿态控制，目标取当前姿态（"保持住"）。
    pub fn enable_posture(&mut self) {
        self.creatures[self.active].posture = Some(Posture::holding(self));
    }

    /// 站起来：目标 = 装配姿态 + 平衡辅助。
    pub fn stand(&mut self) {
        self.creatures[self.active].posture = Some(Posture::standing(self));
    }

    /// 重新取目标角 = 现在这个样子。落地稳定之后调一次，
    /// 免得 PD 一直追一个"还没下沉"的目标。
    pub fn retarget_posture(&mut self) {
        let n = self.body.joints.len();
        let angles: Vec<f32> = (0..n).map(|i| self.joint_load(i).angle).collect();
        if let Some(p) = self.creatures[self.active].posture.as_mut() {
            for (t, a) in p.targets.iter_mut().zip(angles) {
                *t = a;
            }
        }
    }

    /// 关掉姿态控制，回到全软 ragdoll。
    ///
    /// **必须把电机关掉**：电机是挂在关节上的约束，`posture = None` 只是
    /// 不再更新它，电机还在按上一次的刚度出力。不关的话"关掉姿态控制"
    /// 等于没关——M5 的锤击测试就是这么暴露出来的：锤了五下关节纹丝不动。
    pub fn disable_posture(&mut self) {
        self.creatures[self.active].posture = None;
        self.clear_joint_motors();
    }

    /// 把每条关节的电机制动力归零。
    fn clear_joint_motors(&mut self) {
        let handles: Vec<_> = self.body.joints.iter().map(|j| j.handle).collect();
        for h in handles {
            if let Some(j) = self.physics.impulse_joints.get_mut(h, true) {
                j.data.set_motor_max_force(JointAxis::AngX, 0.0);
                j.data.set_motor_position(JointAxis::AngX, 0.0, 0.0, 0.0);
            }
        }
    }

    /// 设置某个关节的目标角（弧度）。名字不存在时返回 false。
    pub fn set_pose_target(&mut self, joint: &str, angle: f32) -> bool {
        let Some(i) = self.joint_index(joint) else {
            return false;
        };
        if let Some(p) = self.creatures[self.active].posture.as_mut() {
            p.targets[i] = angle;
            true
        } else {
            false
        }
    }

    /// 当前肌张力 0..1：意识 × 交感张力，再乘疼痛保护系数。
    ///
    /// 这是设计文档 9.3 里那条"只允许写三个东西"的第一条。昏迷 → 0，
    /// 所以人会软下去；关节疼 → 该关节的保护系数掉下来，所以会护着。
    pub fn muscle_tone(&self) -> f32 {
        self.muscle_tone_of(self.active)
    }

    /// 某一具的肌张力。**每具各算各的**——一具昏迷不该让另一具也软下去。
    pub fn muscle_tone_of(&self, c: usize) -> f32 {
        let b = &self.creatures[c].physio.bus;
        b.consciousness * (0.3 + 0.7 * b.sympathetic_tone)
    }

    /// 平衡辅助：把质心的水平投影拉回两脚之间。
    ///
    /// # 为什么需要它
    ///
    /// 这具身体**没有踝关节**（`human_01` 只有髋、膝）。没有踝，站着就是一根
    /// 倒立摆：质心只要偏出支撑面一点点，重力矩就会把它越推越远。
    /// 关节 PD 帮不上——它施加的是绕关节的力矩，而站起来需要的是绕**地面
    /// 接触点**的力矩。
    ///
    /// 所以这里做的是最朴素的重心修正：算质心、算两脚中点，偏了就在骨盆上
    /// 推一把。推的是**水平力**，不是力矩——和真人靠踝/髋策略站住是同一个
    /// 思路，只是我们把它外置了。
    ///
    /// 三条边界：
    ///
    /// 1. 只在**站着**的时候生效（质心高于地面 0.35 m）。躺下、被拎起来、
    ///    被炸飞的时候不管——那时候"平衡"没有意义。
    /// 2. 力有上限（体重的 40%）。所以用力推还是会倒，只是不会一碰就倒。
    /// 3. 只修水平方向。垂直方向交给物理。
    fn apply_balance(&mut self) {
        // **每具各算各的**：各自看自己的质心落在自己两只脚之间没有。
        for ci in 0..self.creatures.len() {
            self.balance_one(ci);
        }
    }

    fn balance_one(&mut self, ci: usize) {
        let Some(p) = &self.creatures[ci].posture else {
            return;
        };
        if p.balance <= 0.0 {
            return;
        }
        let strength = p.balance;

        // 质心 + 支撑点（只看这一具的块）
        let mut com = Vec2::ZERO;
        let mut total_m = 0.0f32;
        let mut feet_x = 0.0f32;
        let mut feet_n = 0.0f32;
        let mut lowest = f32::INFINITY;
        for i in 0..self.body.pieces.len() {
            let piece = &self.body.pieces[i];
            if piece.deleted || piece.creature as usize != ci {
                continue;
            }
            let (pos, _) = self.piece_pose(PieceId(i as u32));
            let m = piece.mass.max(1e-4);
            com += pos * m;
            total_m += m;
            lowest = lowest.min(pos.y);
        }
        if total_m <= 0.0 {
            return;
        }
        com /= total_m;

        // 支撑点 = 最低的那几块（两只脚）的水平中点
        for i in 0..self.body.pieces.len() {
            let piece = &self.body.pieces[i];
            if piece.deleted || piece.creature as usize != ci {
                continue;
            }
            let (pos, _) = self.piece_pose(PieceId(i as u32));
            if pos.y < lowest + 0.12 {
                feet_x += pos.x;
                feet_n += 1.0;
            }
        }
        if feet_n < 1.0 {
            return;
        }
        let support = feet_x / feet_n;

        // 站着才管
        if com.y - self.ground_y < 0.35 {
            return;
        }

        // 质心速度（用骨盆近似就够——这一项只是阻尼）
        let pelvis = self.creatures[ci].primary.first().copied();
        let Some(pelvis) = pelvis else { return };
        if self.body.pieces[pelvis.index()].deleted {
            return;
        }
        let vx = self.piece_velocity(pelvis).x;

        let err = com.x - support;
        // kp = 25 /s²、kd = 9 /s。70kg 的人偏 5cm → 87 N，约体重的 13%。
        let mut f = -(err * 25.0 + vx * 9.0) * total_m * strength;
        let max_f = total_m * 9.8 * 0.4;
        f = f.clamp(-max_f, max_f);

        let handle = self.body.pieces[pelvis.index()].body;
        let Some(rb) = self.physics.bodies.get_mut(handle) else {
            return;
        };
        rb.add_force(rv(Vec2::new(f, 0.0)), true);
    }

    /// 把姿态控制变成**关节电机**。必须在 `physics.step()` 之前调。
    ///
    /// # 为什么不是"给两块各加一个反向力矩"
    ///
    /// M5 里就是这么写的：`τ = k·err − c·dw`，然后 `add_torque` 给两端。
    /// 问题出在 `k` 上。`assets/body_plans/human_01.ron` 给每条关节都写了
    /// 刚度（髋 1500、膝 1200、腰 1200、肘 400），但那些数**从来没被读过**——
    /// 姿态控制用的是全局的 26。
    ///
    /// 26 N·m/rad 是什么概念：70kg 的人站着，髋要扛 `m·g·d ≈ 40·9.8·0.05
    /// = 20 N·m`，26 的刚度需要 **0.77 弧度（44°）**的误差才够。所以人站不住，
    /// 会慢慢跪下去。而把 26 直接改成 1500 又会炸：显式积分的稳定条件是
    /// `ω·dt < 2`，`ω = √(k/I) = √(1500/0.4) ≈ 61 rad/s`，`61/60 ≈ 1.0`——
    /// 一步就过冲，两步发散。实测骨盆角速度抖到 372 rad/s。
    ///
    /// # 所以改用 rapier 的关节电机
    ///
    /// 电机是**隐式约束**：它和关节限位、接触力进同一个求解器，刚度多高都稳。
    /// 而且 plan 里那些刚度值本来就是为这个准备的（单位 N·m/rad）。
    ///
    /// `muscle_tone` 依然乘在刚度上——昏迷 → 0 就是"电机断电"，人会软下去；
    /// 关节疼 → `guard` 把那条关节的刚度压到 15%，就是"护着不敢用力"。
    fn apply_posture(&mut self) {
        // **每具各用自己的姿态目标**：按关节的 `creature` 标签去查。
        for i in 0..self.body.joints.len() {
            let j = &self.body.joints[i];
            // 脱位 / 离断的关节没有硬约束了（`handle` 失效），这一帧不发力
            let Some(spec) = self.plan.joints.get(j.id.index()) else {
                continue;
            };
            // 这条关节属于哪一具 → 用哪一具的肌张力和姿态目标
            let ci = j.creature as usize;
            let Some(p) = self.creatures.get(ci).and_then(|c| c.posture.as_ref()) else {
                continue;
            };
            let tone = self.muscle_tone_of(ci);
            let k_scale = p.stiffness * tone;
            let d_scale = p.damping * (0.4 + 0.6 * tone);
            let guard = 1.0 - 0.85 * j.health.pain;
            let k = spec.stiffness * k_scale * guard;
            let d = spec.damping * d_scale * guard;
            let target = p.targets.get(i).copied().unwrap_or(0.0);
            let handle = j.handle;

            let Some(joint) = self.physics.impulse_joints.get_mut(handle, true) else {
                continue;
            };
            joint
                .data
                .set_motor_model(JointAxis::AngX, MotorModel::ForceBased);
            joint
                .data
                .set_motor_position(JointAxis::AngX, target, k.max(1.0), d.max(0.5));
            // 力矩上限：刚度 × 0.35 弧度（20°）——够扛住体重，又不至于
            // 把一条卡死的关节变成液压钳。
            joint
                .data
                .set_motor_max_force(JointAxis::AngX, (k * 0.35).max(20.0));
        }
    }

    /// 切一刀（**世界米**），把后果写进组织场并立刻重解压力场。
    ///
    /// 和 [`Sim::slice`] 用同一套坐标——交互层只该认识一个坐标系。
    /// 返回 `None` 表示这具身体没挂组织场——那样切割只是几何操作，不出血。
    pub fn cut(&mut self, cut: &anatomize_cut::CutSegment) -> Option<SeverOutcome> {
        // **对每一具有组织场的身体各切一刀。**
        //
        // 一个世界只有一把刀：刀扫过谁就切谁。每具的身体坐标系不同，
        // 所以要各自转一次坐标——拿 active 的转完套到别人身上，刀会切到空气里。
        //
        // `apply_cut` 只在刀线真的穿过组织的地方留下创口，所以"全都切一遍"
        // 不会误伤：没被扫到的那具，场里一个 texel 都不会变。
        let mut best: Option<SeverOutcome> = None;
        for ci in 0..self.creatures.len() {
            if self.creatures[ci].tissue.is_none() {
                continue;
            }
            let Some(body_cut) = self.cut_to_body_of(ci, cut) else {
                continue;
            };
            let map = self.creatures[ci].physio.bus.map;
            let Some(tissue) = self.creatures[ci].tissue.as_mut() else {
                continue;
            };
            let out = apply_cut(&self.plan, &mut tissue.field, &body_cut);
            tissue.warmup(map);
            // 留"伤得最重"那一具的结果给 UI 报
            let hits = out.report.hits.len();
            if best.as_ref().is_none_or(|b| hits > b.report.hits.len()) {
                best = Some(out);
            }
        }
        best
    }

    /// 切一刀，刀线在**身体局部厘米**。
    ///
    /// 结构判定（血管折线）和组织场都在身体局部坐标里，所以这是真正干活的那个。
    /// 返回 `None` 表示这具身体没挂组织场。
    pub fn cut_body_local(&mut self, cut: &anatomize_cut::CutSegment) -> Option<SeverOutcome> {
        let map = self.creatures[self.active].physio.bus.map;
        let tissue = self.creatures[self.active].tissue.as_mut()?;
        let out = apply_cut(&self.plan, &mut tissue.field, cut);
        tissue.warmup(map);
        Some(out)
    }

    /// 按压 / 松开创口。返回按压后的出血速率（mL/s）。
    pub fn press_wound(&mut self, on: bool) -> f32 {
        let map = self.creatures[self.active].physio.bus.map;
        match self.creatures[self.active].tissue.as_mut() {
            Some(t) => t.set_wound_clamped(on, map),
            None => 0.0,
        }
    }

    /// 当前创口出血速率（mL/s）。没有组织场时为 0。
    pub fn hemorrhage_ml_s(&self) -> f32 {
        // **所有生物加起来**：两具都在流血时，屏幕上该看到总和。
        self.creatures
            .iter()
            .filter_map(|c| c.tissue.as_ref())
            .map(|t| t.step.wound_flux)
            .sum()
    }

    /// 某一具的出血速率。
    pub fn hemorrhage_of(&self, c: usize) -> f32 {
        self.creatures
            .get(c)
            .and_then(|c| c.tissue.as_ref())
            .map_or(0.0, |t| t.step.wound_flux)
    }

    /// 一个物理 tick 的 L2 → L4 → L2 闭环。
    ///
    /// 顺序是硬约束：
    ///
    /// ```text
    /// 1. 组织场用上一 tick 的 MAP 解压力场      （L4 → L2）
    /// 2. 读出创口通量 / 组织氧 / 核心温度        （L2 → L4）
    /// 3. 生理层推进，算出新的 MAP                （L4 内部）
    /// ```
    ///
    /// 环路延迟恰好一个组织 tick（50ms），而环里最慢的时间常数是压力反射的 3s，
    /// 所以不会振铃。**反过来写（先算生理再解场）会引入两个 tick 的延迟，
    /// 在失血后期表现为 MAP 和出血速率互相追着抖。**
    fn step_physio(&mut self) {
        let tick = self.tick;
        let due = tick.tissue_due();
        // **每具生物各跑一遍**。它们共享同一个 tick，但生理和组织场是各自的。
        for ci in 0..self.creatures.len() {
            let mut input = PhysioInput::none();
            // 先把要用的标量抄出来：`tissue.as_mut()` 会独占借 `self.creatures`，
            // 之后再读同一具的 `physio` 就借不到了。
            let ambient = self.creatures[ci].ambient_c;
            let metab_scale = self.creatures[ci].physio.bus.metab_scale;
            let metab_base = self.creatures[ci].tissue_metab_base;
            let blood_c = self.creatures[ci].physio.bus.temp_core;
            let map = self.creatures[ci].physio.bus.map;

            if let Some(t) = self.creatures[ci].tissue.as_mut() {
                if due {
                    // 三条 L4 → L2 的写回。**体温闭环全靠这三行**：
                    // 环境温度是边界，代谢产热是寒战的执行器，血温是深部温度的载体。
                    // 少写任何一条，"冷"就变成了一具不会回温也不会失温的模型。
                    t.cfg.ambient_c = ambient;
                    t.cfg.metab_heat = metab_base * metab_scale;
                    t.cfg.blood_c = blood_c;
                    t.maybe_step(map, dt_of(TISSUE_HZ));
                }
                input.hemorrhage_ml_s = t.step.wound_flux;
                input.tissue_o2 = Some(t.step.mean_o2);
                input.skin_temp = Some(t.step.skin_temp);
                input.ambient_c = ambient;
            }
            self.creatures[ci].physio.step(input, tick);
        }
    }

    // -----------------------------------------------------------------------
    // 关节健康 ↔ 物理约束
    // -----------------------------------------------------------------------

    /// 读一个关节本 tick 的载荷。
    ///
    /// 三个来源：
    /// - `angle`：两刚体相对转角（`Rot2` 相乘取角，和 rapier 判限位用的是同一个量）
    /// - `impulse`：角向 DOF 冲量，以及限位约束自己的冲量，取较大者
    /// - `tether_stretch`：脱位后两锚点被拉开的距离
    pub fn joint_load(&self, idx: usize) -> JointLoad {
        let inst = &self.body.joints[idx];
        // 冻结的块已经从物理世界摘掉了，但关节还记着它。离断之后这条关节
        // 本来也没有载荷可言，直接返回零比到处判空干净。
        let (Some(rb_a), Some(rb_b)) = (
            self.physics
                .bodies
                .get(self.body.pieces[inst.a.index()].body),
            self.physics
                .bodies
                .get(self.body.pieces[inst.b.index()].body),
        ) else {
            return JointLoad {
                angle: 0.0,
                limits: inst.rest_limits,
                impulse: 0.0,
                tether_stretch: 0.0,
            };
        };
        let angle = (rb_a.rotation().inverse() * *rb_b.rotation()).angle();

        let mut impulse = 0.0f32;
        if let Some(j) = self.physics.impulse_joints.get(inst.handle) {
            let angular = j.impulses.z.abs();
            let limit = j
                .data
                .limits(JointAxis::AngX)
                .map(|l| l.impulse.abs())
                .unwrap_or(0.0);
            impulse = angular.max(limit);
        }

        let mut tether_stretch = 0.0f32;
        if let Some(h) = inst.tether {
            let (pa, pb) = self.joint_world_anchors(inst);
            tether_stretch = ((pa - pb).length() - inst.tether_rest).max(0.0);
            if let Some(j) = self.physics.impulse_joints.get(h) {
                let pull = j
                    .data
                    .limits(JointAxis::LinX)
                    .map(|l| l.impulse.abs())
                    .unwrap_or(0.0);
                impulse = impulse.max(pull);
            }
        }

        JointLoad {
            angle,
            limits: inst.rest_limits,
            impulse,
            tether_stretch,
        }
    }

    /// 推进所有关节的健康状态机，返回本 tick 发生的迁移。
    ///
    /// 迁移一旦发生就立刻改物理约束——延迟一帧会让"脱位"看起来像"突然断了"。
    pub fn update_joint_health(&mut self) -> Vec<(JointId, JointState)> {
        let mut changed = Vec::new();
        for i in 0..self.body.joints.len() {
            // 断掉的关节不再磨损——它已经是历史了
            if self.body.joints[i].health.state == JointState::Severed {
                continue;
            }
            let load = self.joint_load(i);
            let params = self.damage;
            let Some(next) = self.body.joints[i].health.update(load, &params, DT) else {
                continue;
            };
            let id = self.body.joints[i].id;
            self.apply_joint_state(i, next);
            self.injuries.push((id, next, self.tick.0 as f32 * DT));
            changed.push((id, next));
        }
        changed
    }

    /// 把状态机的结论变成物理动作。
    ///
    /// 这是 M3 最关键的一段：**Dislocated 不是"移除约束"，而是"换成软约束"**。
    /// 直接 `remove_joint` 会让小腿带着惯性飞出去，那是 v0.1 最大的手感缺陷。
    fn apply_joint_state(&mut self, idx: usize, state: JointState) {
        let inst = &self.body.joints[idx];
        let (ha, hb) = (
            self.body.pieces[inst.a.index()].body,
            self.body.pieces[inst.b.index()].body,
        );
        let (anchor_a, anchor_b) = (inst.anchor_a, inst.anchor_b);
        let ca = self.body.pieces[inst.a.index()].centroid;
        let cb = self.body.pieces[inst.b.index()].centroid;
        let la = rv((anchor_a - ca) * CM);
        let lb = rv((anchor_b - cb) * CM);
        let rest = inst.rest_limits;
        let rom = inst.health.rom_scale;
        let tether_rest = inst.tether_rest;
        let hard = inst.handle;
        let old_tether = inst.tether;
        // 绳长 = 装配时的间隙 + 软组织余量。不能只用间隙——装配正确的关节
        // 间隙接近 0，那样绳子等于零长度，脱位后会变回完全刚性。
        let tether_len = tether_rest + self.damage.tether_len_cm * CM;

        match state {
            // 扭伤 / 半脱位：还连着，只是限位被拉松了
            JointState::Intact | JointState::Sprained | JointState::Subluxed => {
                if let Some(j) = self.physics.impulse_joints.get_mut(hard, true) {
                    j.data
                        .set_limits(JointAxis::AngX, [rest.0 * rom, rest.1 * rom]);
                }
            }
            // 脱位：硬约束换成绳子。肢体还挂着，会甩、会痛，但不会飞走。
            JointState::Dislocated => {
                self.physics.impulse_joints.remove(hard, true);
                let rope = RopeJointBuilder::new(tether_len)
                    .local_anchor1(la)
                    .local_anchor2(lb)
                    .contacts_enabled(false)
                    .build();
                let h = self.physics.impulse_joints.insert(ha, hb, rope, true);
                self.body.joints[idx].tether = Some(h);
            }
            // 离断：绳子也没了，两个 island 彻底分开
            JointState::Severed => {
                if let Some(h) = old_tether {
                    self.physics.impulse_joints.remove(h, true);
                }
                // 防御性：正常流程里硬约束在 Dislocated 就已经移除，但如果状态
                // 是外部直接置到 Severed 的（调试 / 存档恢复），这里得补一刀。
                // `remove` 对已移除的 handle 返回 None，重复调用无害。
                self.physics.impulse_joints.remove(hard, true);
                self.body.joints[idx].tether = None;
            }
        }
    }

    /// 直接扣一个关节的完整性（调试 / 演示 / 测试用）。
    ///
    /// 真实路径永远是"受载荷 → 磨损 → integrity 下降"，这个入口绕过了物理，
    /// 只该出现在 `m3_demo` 和测试里。
    pub fn wear_joint(&mut self, name: &str, amount: f32) {
        let Some(i) = self
            .body
            .joints
            .iter()
            .position(|j| self.plan.joints[j.id.index()].name == name)
        else {
            return;
        };
        let h = &mut self.body.joints[i].health;
        h.integrity = (h.integrity - amount).max(0.0);
        h.accumulated += amount;
    }

    /// 直接断掉一条关节（跳过磨损过程）。
    ///
    /// 真实路径永远是"受载荷 → 磨损 → 离断"，这个入口是给调试、演示、
    /// 存档恢复用的——和 [`Sim::wear_joint`] 一样，只该出现在工具与测试里。
    pub fn sever_joint(&mut self, name: &str) -> bool {
        let Some(i) = self.joint_index(name) else {
            return false;
        };
        if self.body.joints[i].health.state == JointState::Severed {
            return false;
        }
        self.body.joints[i].health.integrity = 0.0;
        self.body.joints[i].health.state = JointState::Severed;
        self.apply_joint_state(i, JointState::Severed);
        self.injuries
            .push((self.body.joints[i].id, JointState::Severed, 0.0));
        true
    }

    /// 按名字找关节下标。
    pub fn joint_index(&self, name: &str) -> Option<usize> {
        self.body
            .joints
            .iter()
            .position(|j| self.plan.joints[j.id.index()].name == name)
    }

    /// 关节名字（日志用）。
    pub fn joint_name(&self, id: JointId) -> &str {
        &self.plan.joints[id.index()].name
    }

    /// 地面在世界里的 y（米）。渲染画地面线用。
    pub fn ground_y(&self) -> f32 {
        self.ground_y
    }

    /// 身体坐标系的朝向（弧度）。取骨盆的旋转。
    pub fn body_rotation(&self) -> f32 {
        self.plan
            .parts
            .iter()
            .position(|p| p.name == "pelvis")
            .map(|i| self.piece_pose(self.creatures[self.active].primary[i]).1)
            .unwrap_or(0.0)
    }

    /// 身体局部坐标系原点在世界里的位置（米）。
    ///
    /// 组织场钉在**身体坐标系**里（ADR-003），所以画热力图、把世界坐标的刀
    /// 转成身体局部厘米，都要先知道这个原点。锚在骨盆上——它是最不容易被
    /// 切碎的那块，也是解剖学上的"躯干中心"。
    pub fn body_origin_world(&self) -> Option<Vec2> {
        self.body_origin_world_of(self.active)
    }

    /// 指定某一具的身体原点（世界米）。
    pub fn body_origin_world_of(&self, c: usize) -> Option<Vec2> {
        let i = self.plan.parts.iter().position(|p| p.name == "pelvis")?;
        let id = *self.creatures.get(c)?.primary.get(i)?;
        let piece = &self.body.pieces[id.index()];
        let (pos, rot) = self.piece_pose(id);
        let w =
            Rot2::from_angle(rot) * rv((self.plan.parts[i].offset - piece.centroid) * CM) + rv(pos);
        Some(Vec2::new(w.x, w.y))
    }

    /// 世界坐标下的刀 → 身体局部厘米。交互层只需要这一个入口。
    pub fn cut_to_body(
        &self,
        cut: &anatomize_cut::CutSegment,
    ) -> Option<anatomize_cut::CutSegment> {
        self.cut_to_body_of(self.active, cut)
    }

    /// 同上，指定哪一具。**多 ragdoll 必须按生物各转一次**：
    /// 每具的身体坐标系原点/朝向都不一样，用 active 的转完再套到别人身上，
    /// 刀就切到空气里去了。
    pub fn cut_to_body_of(
        &self,
        c: usize,
        cut: &anatomize_cut::CutSegment,
    ) -> Option<anatomize_cut::CutSegment> {
        let o = self.body_origin_world_of(c)?;
        let i = self.plan.parts.iter().position(|p| p.name == "pelvis")?;
        let (_, rot) = self.piece_pose(self.creatures[c].primary[i]);
        Some(cut.to_body_frame(o, rot))
    }

    /// 部件在世界坐标下的多边形顶点（米）。
    pub fn part_polygon(&self, part: PartId) -> Vec<Vec2> {
        let inst = &self.creatures[self.active].parts[part.index()];
        let rb = &self.physics.bodies[inst.body];
        let pose = rb.position();
        self.plan.parts[part.index()]
            .polygon
            .iter()
            .map(|v| {
                let p = pose.transform_point(RVec2::new(v.x * CM, v.y * CM));
                Vec2::new(p.x, p.y)
            })
            .collect()
    }

    /// 部件在世界坐标下的朝向（弧度）。
    pub fn part_angle(&self, part: &str) -> Option<f32> {
        let p = self.plan.parts.iter().position(|p| p.name == part)?;
        Some(
            self.physics.bodies[self.creatures[self.active].parts[p].body]
                .rotation()
                .angle(),
        )
    }

    /// 部件在世界坐标下的质心位置（米）。
    pub fn part_center(&self, part: &str) -> Option<Vec2> {
        let p = self.plan.parts.iter().position(|p| p.name == part)?;
        let t = self.physics.bodies[self.creatures[self.active].parts[p].body]
            .position()
            .translation;
        Some(Vec2::new(t.x, t.y))
    }

    /// 关节两端锚点的世界坐标（米）。装配正确时两者应该重合。
    pub fn joint_world_anchors(&self, j: &JointInstance) -> (Vec2, Vec2) {
        (
            self.piece_point(j.a, j.anchor_a),
            self.piece_point(j.b, j.anchor_b),
        )
    }

    /// 部件局部厘米 → 世界米。
    ///
    /// 关节锚点存的是**部件局部**坐标（切完之后同一个锚点可能落在不同块上），
    /// 所以要经过"减块质心"这一步才能落到块局部。冻结的块没有刚体，读快照。
    pub fn piece_point(&self, id: PieceId, part_local_cm: Vec2) -> Vec2 {
        let p = &self.body.pieces[id.index()];
        let local_m = rv((part_local_cm - p.centroid) * CM);
        let w = match p.frozen_pose {
            Some((pos, rot)) => Rot2::from_angle(rot) * local_m + rv(pos),
            // 删除的块没有刚体也没有位姿。返回零向量，调用方（渲染、诊断）
            // 会画在原点——难看，但不会把整个程序崩掉。
            None => match self.physics.bodies.get(p.body) {
                Some(rb) => rb.position().transform_point(local_m),
                None => RVec2::ZERO,
            },
        };
        Vec2::new(w.x, w.y)
    }

    pub fn diagnostics(&self) -> Diag {
        let mut max_gap = 0.0f32;
        let mut sum_gap = 0.0f32;
        for j in &self.body.joints {
            let (pa, pb) = self.joint_world_anchors(j);
            let gap = (pa - pb).length();
            max_gap = max_gap.max(gap);
            sum_gap += gap;
        }

        let mut ke = 0.0f32;
        let mut max_speed = 0.0f32;
        let mut nan = false;
        // 冻结的块已经不在物理世界里了（刚体被摘掉），读它就会越界。
        // 它们的速度是 0，对动能和最大速度都没有贡献，直接跳过。
        for p in self
            .body
            .pieces
            .iter()
            .filter(|p| !p.is_frozen() && !p.deleted)
        {
            let rb = &self.physics.bodies[p.body];
            let v = rb.linvel().length();
            ke += 0.5 * rb.mass() * v * v;
            max_speed = max_speed.max(v);
            if !v.is_finite() || !rb.position().translation.x.is_finite() {
                nan = true;
            }
        }

        Diag {
            max_joint_gap: max_gap,
            mean_joint_gap: sum_gap / self.body.joints.len().max(1) as f32,
            kinetic_energy: ke,
            max_speed,
            nan,
            tick: self.tick.0,
        }
    }
}

#[derive(Debug, Clone, Copy)]
pub struct Diag {
    /// 关节两端锚点的最大间距（米）。稳定时应 < 1mm。
    pub max_joint_gap: f32,
    pub mean_joint_gap: f32,
    pub kinetic_energy: f32,
    pub max_speed: f32,
    pub nan: bool,
    pub tick: u64,
}
