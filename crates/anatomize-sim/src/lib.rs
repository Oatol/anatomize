//! 世界编排：把 [`BodyPlan`] 组装成 rapier2d 的刚体 + 关节，并按固定步长推进。
//!
//! 单位约定：**内部一律用米**。RON 里写的是厘米，装载时统一 ×0.01。
//! 这样 rapier 的默认容差（毫米级）才是合理的。
//!
//! 本 crate 依赖 rapier2d，但不依赖 Bevy —— 渲染是别人的事。

pub mod actions;
pub mod edit;
pub mod items;
pub mod fracture;
pub mod props;
pub mod rewind;
pub mod save;
pub mod sever;

pub use fracture::{FractureConfig, SliceReport};
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
    pub parts: Vec<PartInstance>,
    pub joints: Vec<JointInstance>,
    /// 所有物理块。切开一次就多一块。
    pub pieces: Vec<Piece>,
    /// 每个 `PartId` 的代表块（下标按 `PartId`）。`part_polygon` 之类读它。
    ///
    /// 代表块 = 切完之后包含**原部件质心**的那一块。选它是因为那是玩家
    /// 心理上"这条腿还在原地"的那一半。
    pub primary: Vec<PieceId>,
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
    /// 关节损伤参数（来自 `assets/config/damage.ron`）。
    pub damage: JointParams,
    /// 累计发生过的状态迁移，按发生顺序。HUD / 日志 / 验收图都读它。
    pub injuries: Vec<(JointId, JointState, f32)>,
    /// 组织场。`None` 表示这具身体没挂场（纯 ragdoll，不会出血也不会缺氧）。
    pub tissue: Option<TissueSim>,
    /// 0D 生理。
    pub physio: Physio,
    /// 环境温度（°C）。写进组织场的边界条件，是"冷"这件事的唯一入口。
    pub ambient_c: f32,
    /// 组织场的**基准**代谢产热（K/s）。实际产热 = 这个值 × `physio.bus.metab_scale`。
    pub(crate) tissue_metab_base: f32,
    /// 姿态控制（M5）。`None` 表示这具身体是全软的 ragdoll。
    pub posture: Option<Posture>,
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
    /// 刚度（N·m/rad）。
    pub stiffness: f32,
    /// 阻尼（N·m·s/rad）。
    pub damping: f32,
}

impl Posture {
    /// 用当前关节角当目标（"保持现状"）。
    pub fn holding(sim: &Sim) -> Self {
        let targets = (0..sim.body.joints.len())
            .map(|i| sim.joint_load(i).angle)
            .collect();
        Self {
            targets,
            stiffness: 26.0,
            damping: 3.2,
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
    pub fn spawn_in_world(
        plan: BodyPlan,
        origin: Vec2,
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
                    .translation(RVec2::new(sx * (world.half_w() + 0.05), ground_y + world.height * 0.5))
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

        let mut parts = Vec::with_capacity(plan.parts.len());
        let mut handles: Vec<RigidBodyHandle> = Vec::with_capacity(plan.parts.len());

        for part in &plan.parts {
            let center = origin + part.offset * CM;

            let rb = RigidBodyBuilder::dynamic()
                .translation(rv(center))
                .linear_damping(0.15)
                .angular_damping(0.5)
                .build();
            let handle = physics.bodies.insert(rb);

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

            let collider =
                physics
                    .colliders
                    .insert_with_parent(collider, handle, &mut physics.bodies);

            handles.push(handle);
            parts.push(PartInstance {
                id: part.id,
                body: handle,
                collider,
            });
        }

        let mut joints = Vec::with_capacity(plan.joints.len());
        for j in &plan.joints {
            let a = handles[j.a.index()];
            let b = handles[j.b.index()];
            let anchor_a = j.anchor_a;
            let anchor_b = j.anchor_b;

            let joint = RevoluteJointBuilder::new()
                .local_anchor1(rv(anchor_a * CM))
                .local_anchor2(rv(anchor_b * CM))
                .limits([j.limits.0, j.limits.1])
                // 相邻部件本来就有体积重叠（肩、髋、颈），必须关掉它们之间的碰撞，
                // 否则接触力会和关节约束对拉，能量越积越多
                .contacts_enabled(false)
                .build();

            let handle = physics.impulse_joints.insert(a, b, joint, true);
            let (wa, wb) = {
                let pa = physics.bodies[a]
                    .position()
                    .transform_point(rv(anchor_a * CM));
                let pb = physics.bodies[b]
                    .position()
                    .transform_point(rv(anchor_b * CM));
                (pa, pb)
            };
            joints.push(JointInstance {
                id: j.id,
                a: PieceId(j.a.0 as u32),
                b: PieceId(j.b.0 as u32),
                handle,
                anchor_a,
                anchor_b,
                rest_limits: j.limits,
                health: JointHealth::default(),
                tether: None,
                tether_rest: (wa - wb).length().max(1e-4),
            });
        }

        // 开局：一个部件 = 一块
        let pieces: Vec<Piece> = plan
            .parts
            .iter()
            .map(|p| Piece {
                part: p.id,
                body: handles[p.id.index()],
                collider: parts[p.id.index()].collider,
                polygon: p.polygon.clone(),
                centroid: Vec2::ZERO,
                mass: p.mass,
                still_s: 0.0,
                frozen_pose: None,
                item: None,
                deleted: false,
            })
            .collect();
        let primary = (0..plan.parts.len()).map(|i| PieceId(i as u32)).collect();

        Self {
            physics,
            plan,
            body: BodyInstance {
                parts,
                joints,
                pieces,
                primary,
            },
            tick: Tick(0),
            ground,
            ground_y,
            world,
            catalog: ItemCatalog::asset(),
            damage,
            injuries: Vec::new(),
            tissue: None,
            physio: Physio::asset(),
            ambient_c: 22.0,
            tissue_metab_base: 0.0,
            posture: None,
            fracture: FractureConfig::default(),
            slices: 0,
            rewind: Rewind::default_5s(),
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
        let rb = &mut self.physics.bodies[self.body.parts[torso].body];
        rb.set_linvel(RVec2::new(v.x, v.y), true);
    }

    /// 给某个部件一个速度（测试 / 外力打击用）。
    pub fn set_part_velocity(&mut self, part: &str, v: Vec2) {
        let Some(p) = self.plan.parts.iter().position(|p| p.name == part) else {
            return;
        };
        let rb = &mut self.physics.bodies[self.body.parts[p].body];
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
        let rb = &mut self.physics.bodies[self.body.parts[p].body];
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
        self.apply_posture();
        self.physics.step();
        // 载荷必须在刚解完的这一步读，否则读到的是上一帧的约束冲量
        self.update_joint_health();
        self.tick.advance();
        self.step_physio();
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
        sim.warmup(self.physio.bus.map);
        self.tissue_metab_base = sim.cfg.metab_heat;
        self.ambient_c = sim.cfg.ambient_c;
        self.tissue = Some(sim);
    }

    /// 改环境温度。这是"冷"的唯一入口——玩家靠近温箱、走进冷库，都调这里。
    pub fn set_ambient(&mut self, c: f32) {
        self.ambient_c = c;
    }

    /// 吃一顿（kcal）。食物在 P0 里没有咀嚼和吞咽，判定"进了嘴"之后直接调这里。
    pub fn feed(&mut self, kcal: f32) -> f32 {
        self.physio.feed(kcal)
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
        let handle = self.body.parts[p].body;
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
        self.posture = Some(Posture::holding(self));
    }

    /// 关掉姿态控制，回到全软 ragdoll。
    pub fn disable_posture(&mut self) {
        self.posture = None;
    }

    /// 设置某个关节的目标角（弧度）。名字不存在时返回 false。
    pub fn set_pose_target(&mut self, joint: &str, angle: f32) -> bool {
        let Some(i) = self.joint_index(joint) else {
            return false;
        };
        if let Some(p) = self.posture.as_mut() {
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
        let b = &self.physio.bus;
        b.consciousness * (0.3 + 0.7 * b.sympathetic_tone)
    }

    /// 把姿态控制变成力矩。**必须在 `physics.step()` 之前调**。
    fn apply_posture(&mut self) {
        let Some(p) = &self.posture else { return };
        let tone = self.muscle_tone();
        let stiff = p.stiffness * tone;
        let damp = p.damping * (0.4 + 0.6 * tone);

        for i in 0..self.body.joints.len() {
            let (ha, hb) = (
                self.body.pieces[self.body.joints[i].a.index()].body,
                self.body.pieces[self.body.joints[i].b.index()].body,
            );
            // 疼的关节主动放弃发力：`pain = 1` 时只剩 15% 的力矩
            let guard = 1.0 - 0.85 * self.body.joints[i].health.pain;
            let load = self.joint_load(i);
            let err = p.targets[i] - load.angle;
            let (wa, wb) = (
                self.physics.bodies[ha].angvel(),
                self.physics.bodies[hb].angvel(),
            );
            let dw = wb - wa;
            // 死区：误差和角速度都很小的时候不出力。
            //
            // 没有死区的话，PD 会一直追着浮点级别的残差推，而关节限位一直在
            // 往回拉 —— 两边对推的结果就是静止的 ragdoll 肉眼可见地抖。
            if err.abs() < 0.010 && dw.abs() < 0.06 {
                continue;
            }
            let tau = (stiff * err - damp * dw) * guard;
            if !tau.is_finite() {
                continue;
            }
            self.physics.bodies[ha].add_torque(-tau, true);
            self.physics.bodies[hb].add_torque(tau, true);
        }
    }

    /// 切一刀（**世界米**），把后果写进组织场并立刻重解压力场。
    ///
    /// 和 [`Sim::slice`] 用同一套坐标——交互层只该认识一个坐标系。
    /// 返回 `None` 表示这具身体没挂组织场——那样切割只是几何操作，不出血。
    pub fn cut(&mut self, cut: &anatomize_cut::CutSegment) -> Option<SeverOutcome> {
        let body_cut = self.cut_to_body(cut)?;
        self.cut_body_local(&body_cut)
    }

    /// 切一刀，刀线在**身体局部厘米**。
    ///
    /// 结构判定（血管折线）和组织场都在身体局部坐标里，所以这是真正干活的那个。
    /// 返回 `None` 表示这具身体没挂组织场。
    pub fn cut_body_local(&mut self, cut: &anatomize_cut::CutSegment) -> Option<SeverOutcome> {
        let map = self.physio.bus.map;
        let tissue = self.tissue.as_mut()?;
        let out = apply_cut(&self.plan, &mut tissue.field, cut);
        tissue.warmup(map);
        Some(out)
    }

    /// 按压 / 松开创口。返回按压后的出血速率（mL/s）。
    pub fn press_wound(&mut self, on: bool) -> f32 {
        let map = self.physio.bus.map;
        match self.tissue.as_mut() {
            Some(t) => t.set_wound_clamped(on, map),
            None => 0.0,
        }
    }

    /// 当前创口出血速率（mL/s）。没有组织场时为 0。
    pub fn hemorrhage_ml_s(&self) -> f32 {
        self.tissue.as_ref().map_or(0.0, |t| t.step.wound_flux)
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
        let mut input = PhysioInput::none();
        if let Some(t) = self.tissue.as_mut() {
            if self.tick.tissue_due() {
                // 三条 L4 → L2 的写回。**体温闭环全靠这三行**：
                // 环境温度是边界，代谢产热是寒战的执行器，血温是深部温度的载体。
                // 少写任何一条，"冷"就变成了一具不会回温也不会失温的模型。
                t.cfg.ambient_c = self.ambient_c;
                t.cfg.metab_heat = self.tissue_metab_base * self.physio.bus.metab_scale;
                t.cfg.blood_c = self.physio.bus.temp_core;
                t.maybe_step(self.physio.bus.map, dt_of(TISSUE_HZ));
            }
            input.hemorrhage_ml_s = t.step.wound_flux;
            input.tissue_o2 = Some(t.step.mean_o2);
            input.skin_temp = Some(t.step.skin_temp);
            input.ambient_c = self.ambient_c;
        }
        self.physio.step(input, self.tick);
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
            self.physics.bodies.get(self.body.pieces[inst.a.index()].body),
            self.physics.bodies.get(self.body.pieces[inst.b.index()].body),
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
            .map(|i| self.piece_pose(self.body.primary[i]).1)
            .unwrap_or(0.0)
    }

    /// 身体局部坐标系原点在世界里的位置（米）。
    ///
    /// 组织场钉在**身体坐标系**里（ADR-003），所以画热力图、把世界坐标的刀
    /// 转成身体局部厘米，都要先知道这个原点。锚在骨盆上——它是最不容易被
    /// 切碎的那块，也是解剖学上的"躯干中心"。
    pub fn body_origin_world(&self) -> Option<Vec2> {
        let i = self.plan.parts.iter().position(|p| p.name == "pelvis")?;
        let id = self.body.primary[i];
        let piece = &self.body.pieces[id.index()];
        let (pos, rot) = self.piece_pose(id);
        let w = Rot2::from_angle(rot) * rv((self.plan.parts[i].offset - piece.centroid) * CM)
            + rv(pos);
        Some(Vec2::new(w.x, w.y))
    }

    /// 世界坐标下的刀 → 身体局部厘米。交互层只需要这一个入口。
    pub fn cut_to_body(&self, cut: &anatomize_cut::CutSegment) -> Option<anatomize_cut::CutSegment> {
        let o = self.body_origin_world()?;
        let i = self.plan.parts.iter().position(|p| p.name == "pelvis")?;
        let (_, rot) = self.piece_pose(self.body.primary[i]);
        Some(cut.to_body_frame(o, rot))
    }

    /// 部件在世界坐标下的多边形顶点（米）。
    pub fn part_polygon(&self, part: PartId) -> Vec<Vec2> {
        let inst = &self.body.parts[part.index()];
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
        Some(self.physics.bodies[self.body.parts[p].body].rotation().angle())
    }

    /// 部件在世界坐标下的质心位置（米）。
    pub fn part_center(&self, part: &str) -> Option<Vec2> {
        let p = self.plan.parts.iter().position(|p| p.name == part)?;
        let t = self.physics.bodies[self.body.parts[p].body]
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
