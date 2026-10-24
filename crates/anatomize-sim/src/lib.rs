//! 世界编排：把 [`BodyPlan`] 组装成 rapier2d 的刚体 + 关节，并按固定步长推进。
//!
//! 单位约定：**内部一律用米**。RON 里写的是厘米，装载时统一 ×0.01。
//! 这样 rapier 的默认容差（毫米级）才是合理的。
//!
//! 本 crate 依赖 rapier2d，但不依赖 Bevy —— 渲染是别人的事。

pub mod sever;

pub use sever::{SeverOutcome, apply_cut, build_tissue, layer_kind};

use anatomize_body::{BodyPlan, JointHealth, JointLoad, JointParams, JointState};
use anatomize_core::time::dt_of;
use anatomize_core::{DT, JointId, PartId, TISSUE_HZ, Tick, Vec2};
use anatomize_physio::{Physio, PhysioInput};
use anatomize_tissue::{TissueConfig, TissueSim};
use rapier2d::prelude::*;

/// RON 用厘米，物理用米。
pub const CM: f32 = 0.01;

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
    islands: IslandManager,
    broad_phase: BroadPhaseBvh,
    narrow_phase: NarrowPhase,
    bodies: RigidBodySet,
    colliders: ColliderSet,
    impulse_joints: ImpulseJointSet,
    multibody_joints: MultibodyJointSet,
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
    pub a: PartId,
    pub b: PartId,
    /// 硬约束（revolute）。`Dislocated` 之后被移除，handle 失效。
    pub handle: ImpulseJointHandle,
    /// 两端锚点，各自在部件局部坐标系（米）。
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

/// 一具装在物理世界里的人。
pub struct BodyInstance {
    pub parts: Vec<PartInstance>,
    pub joints: Vec<JointInstance>,
}

pub struct Sim {
    pub physics: Physics,
    pub plan: BodyPlan,
    pub body: BodyInstance,
    pub tick: Tick,
    pub ground: ColliderHandle,
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
    tissue_metab_base: f32,
    /// 姿态控制（M5）。`None` 表示这具身体是全软的 ragdoll。
    pub posture: Option<Posture>,
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
    pub fn spawn_with(plan: BodyPlan, origin: Vec2, ground_y: f32, damage: JointParams) -> Self {
        let mut physics = Physics::new();

        // 地面
        let ground = physics.colliders.insert(
            ColliderBuilder::cuboid(3.0, 0.05)
                .translation(RVec2::new(0.0, ground_y - 0.05))
                .friction(0.9)
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
            let anchor_a = j.anchor_a * CM;
            let anchor_b = j.anchor_b * CM;

            let joint = RevoluteJointBuilder::new()
                .local_anchor1(rv(anchor_a))
                .local_anchor2(rv(anchor_b))
                .limits([j.limits.0, j.limits.1])
                // 相邻部件本来就有体积重叠（肩、髋、颈），必须关掉它们之间的碰撞，
                // 否则接触力会和关节约束对拉，能量越积越多
                .contacts_enabled(false)
                .build();

            let handle = physics.impulse_joints.insert(a, b, joint, true);
            let (wa, wb) = {
                let pa = physics.bodies[a].position().transform_point(rv(anchor_a));
                let pb = physics.bodies[b].position().transform_point(rv(anchor_b));
                (pa, pb)
            };
            joints.push(JointInstance {
                id: j.id,
                a: j.a,
                b: j.b,
                handle,
                anchor_a,
                anchor_b,
                rest_limits: j.limits,
                health: JointHealth::default(),
                tether: None,
                tether_rest: (wa - wb).length().max(1e-4),
            });
        }

        Self {
            physics,
            plan,
            body: BodyInstance { parts, joints },
            tick: Tick(0),
            ground,
            damage,
            injuries: Vec::new(),
            tissue: None,
            physio: Physio::asset(),
            ambient_c: 22.0,
            tissue_metab_base: 0.0,
            posture: None,
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
                self.body.parts[self.body.joints[i].a.index()].body,
                self.body.parts[self.body.joints[i].b.index()].body,
            );
            // 疼的关节主动放弃发力：`pain = 1` 时只剩 15% 的力矩
            let guard = 1.0 - 0.85 * self.body.joints[i].health.pain;
            let load = self.joint_load(i);
            let err = p.targets[i] - load.angle;
            let (wa, wb) = (
                self.physics.bodies[ha].angvel(),
                self.physics.bodies[hb].angvel(),
            );
            let tau = (stiff * err - damp * (wb - wa)) * guard;
            if !tau.is_finite() {
                continue;
            }
            self.physics.bodies[ha].add_torque(-tau, true);
            self.physics.bodies[hb].add_torque(tau, true);
        }
    }

    /// 切一刀（身体局部厘米坐标），把后果写进组织场并立刻重解压力场。
    ///
    /// 返回 `None` 表示这具身体没挂组织场——那样切割只是几何操作，不出血。
    pub fn cut(&mut self, cut: &anatomize_cut::CutSegment) -> Option<SeverOutcome> {
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
                t.step(self.physio.bus.map, dt_of(TISSUE_HZ));
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
        let rb_a = &self.physics.bodies[self.body.parts[inst.a.index()].body];
        let rb_b = &self.physics.bodies[self.body.parts[inst.b.index()].body];
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
            self.body.parts[inst.a.index()].body,
            self.body.parts[inst.b.index()].body,
        );
        let (anchor_a, anchor_b) = (inst.anchor_a, inst.anchor_b);
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
                    .local_anchor1(rv(anchor_a))
                    .local_anchor2(rv(anchor_b))
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
        let a = &self.physics.bodies[self.body.parts[j.a.index()].body];
        let b = &self.physics.bodies[self.body.parts[j.b.index()].body];
        let pa = a.position().transform_point(rv(j.anchor_a));
        let pb = b.position().transform_point(rv(j.anchor_b));
        (Vec2::new(pa.x, pa.y), Vec2::new(pb.x, pb.y))
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
        for p in &self.body.parts {
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
