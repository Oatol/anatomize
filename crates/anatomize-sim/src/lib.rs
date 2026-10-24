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
        self.tissue = Some(sim);
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
                t.step(self.physio.bus.map, dt_of(TISSUE_HZ));
            }
            input.hemorrhage_ml_s = t.step.wound_flux;
            input.tissue_o2 = Some(t.step.mean_o2);
            input.core_temp = Some(t.step.core_temp);
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
