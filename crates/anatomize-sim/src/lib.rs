//! 世界编排：把 [`BodyPlan`] 组装成 rapier2d 的刚体 + 关节，并按固定步长推进。
//!
//! 单位约定：**内部一律用米**。RON 里写的是厘米，装载时统一 ×0.01。
//! 这样 rapier 的默认容差（毫米级）才是合理的。
//!
//! 本 crate 依赖 rapier2d，但不依赖 Bevy —— 渲染是别人的事。

use anatomize_body::BodyPlan;
use anatomize_core::{DT, JointId, PartId, Tick, Vec2};
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
    pub handle: ImpulseJointHandle,
    /// 两端锚点，各自在部件局部坐标系（米）。
    pub anchor_a: Vec2,
    pub anchor_b: Vec2,
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
}

impl Sim {
    /// 建世界 + 一具人体。`origin` 是身体局部原点在世界中的位置（米）。
    pub fn spawn(plan: BodyPlan, origin: Vec2, ground_y: f32) -> Self {
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
            joints.push(JointInstance {
                id: j.id,
                a: j.a,
                b: j.b,
                handle,
                anchor_a,
                anchor_b,
            });
        }

        Self {
            physics,
            plan,
            body: BodyInstance { parts, joints },
            tick: Tick(0),
            ground,
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

    pub fn step(&mut self) {
        self.physics.step();
        self.tick.advance();
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
