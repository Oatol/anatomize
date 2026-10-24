//! 手抓：用**弹簧关节**拉，不是外部施力。
//!
//! # 为什么不能用"每帧加一个力"
//!
//! 第一版是每物理步 `add_force_at_point`。抓**自由物体**（木箱）还行，但抓
//! **连在身上的肢体**就会炸：抓力是外力，关节是硬约束，两者在求解器里互相顶。
//! 实测抓前臂画圈，那块转到了 **370 rad/s**（每秒 59 圈）——看起来就是
//! "不受控制地摆动"。
//!
//! 根因：外力在一步内只被积分一次，而关节约束会用冲量把它抵消掉；下一帧
//! 外力再来一次、再被抵消……净效果是约束把冲量变成了旋转。力臂越长越糟。
//!
//! # 正确做法：把它变成一条**约束**
//!
//! MaD2 的 `Joints.Pin` 用的是 `b2MouseJoint`：
//!
//! ```as3
//! _loc5_.body1 = Physics.world.GetGroundBody();   // 静态锚点
//! _loc5_.body2 = param2;                          // 被拖的块
//! _loc5_.target.Set(x, y);
//! _loc5_.maxForce = 900000 * param2.GetMass();
//! ```
//!
//! Box2D 的 mouse joint 本质是"到静态锚点的软约束"（默认 5 Hz、阻尼比 0.7）。
//! rapier 没有 mouse joint，但 `SpringJoint` 就是同一个东西：
//!
//! ```text
//! 运动学锚点刚体（每帧挪到鼠标位置） ← 弹簧 → 被拖的块
//! ```
//!
//! 好处是**它进同一个求解器**：抓力、肘关节、肩关节、接触力一起解，
//! 不会互相打架。这也是"抓着一只手拖，身体会跟着转"能自然发生的原因。
//!
//! 参数照 MaD2：5 Hz、阻尼比 0.7。`k = m·ω²`、`c = 2·ζ·ω·m`，`ω = 2π·5`。

use anatomize_core::Vec2;
use rapier2d::prelude::*;

use crate::{PieceId, RVec2, Sim, rv};

/// 一次抓取。
pub struct Grab {
    pub id: PieceId,
    /// 抓取点，**块局部米**（相对块质心）。
    pub local: Vec2,
    /// 鼠标在哪（世界米）。
    pub target: Vec2,
    /// 运动学锚点刚体。每帧挪到 `target`。
    anchor: RigidBodyHandle,
    /// 弹簧关节。
    joint: ImpulseJointHandle,
}

impl Grab {
    pub fn target(&self) -> Vec2 {
        self.target
    }
}

/// MaD2 的鼠标关节：5 Hz、阻尼比 0.7。
const FREQ_HZ: f32 = 5.0;
const DAMPING_RATIO: f32 = 0.7;

impl Sim {
    /// 抓住一块的某个点。`world` 是鼠标按下的世界位置。
    pub fn grab(&mut self, id: PieceId, world: Vec2) -> bool {
        self.release_grab();
        let p = &self.body.pieces[id.index()];
        if p.deleted || p.is_frozen() {
            return false;
        }
        let Some(rb) = self.physics.bodies.get(p.body) else {
            return false;
        };
        let local = rb.position().inverse().transform_point(rv(world));
        let mass = rb.mass().max(0.05);
        let handle = p.body;

        // 运动学锚点：没有质量、不参与碰撞，只提供一个"目标位置"
        let anchor_rb = RigidBodyBuilder::kinematic_position_based()
            .translation(rv(world))
            .build();
        let anchor = self.physics.bodies.insert(anchor_rb);

        let omega = std::f32::consts::TAU * FREQ_HZ;
        let stiffness = mass * omega * omega;
        let damping = 2.0 * DAMPING_RATIO * omega * mass;
        // 距离弹簧：静止长度 0 = "抓取点要跟锚点重合"
        let mut spring = SpringJointBuilder::new(0.0, stiffness, damping)
            .local_anchor1(local)
            .local_anchor2(RVec2::ZERO)
            .contacts_enabled(false)
            .build();
        // 力的上限：MaD2 是 900000 × 质量（基本等于无限），这里给
        // m·4000（约 400 g 的加速度）——够用，又不至于把刚体瞬间打飞。
        spring
            .data
            .set_motor_max_force(JointAxis::LinX, mass * 4000.0);
        let joint = self
            .physics
            .impulse_joints
            .insert(anchor, handle, spring, true);

        self.grab_state = Some(Grab {
            id,
            local: Vec2::new(local.x, local.y),
            target: world,
            anchor,
            joint,
        });
        true
    }

    /// 更新鼠标位置。抓着的时候每帧调。
    pub fn drag_to(&mut self, target: Vec2) {
        let Some(g) = &mut self.grab_state else {
            return;
        };
        g.target = target;
        if let Some(rb) = self.physics.bodies.get_mut(g.anchor) {
            rb.set_translation(rv(target), true);
        }
    }

    pub fn release_grab(&mut self) {
        let Some(g) = self.grab_state.take() else {
            return;
        };
        self.physics.impulse_joints.remove(g.joint, true);
        self.physics.bodies.remove(
            g.anchor,
            &mut self.physics.islands,
            &mut self.physics.colliders,
            &mut self.physics.impulse_joints,
            &mut self.physics.multibody_joints,
            &mut self.physics.soft_bodies,
            true,
        );
    }

    pub fn grabbed(&self) -> Option<&Grab> {
        self.grab_state.as_ref()
    }

    /// 抓住的那块还在不在。被删掉 / 冻住就自动松手。
    pub(crate) fn check_grab(&mut self) {
        let Some(g) = &self.grab_state else {
            return;
        };
        let p = &self.body.pieces[g.id.index()];
        if p.deleted || p.is_frozen() {
            self.release_grab();
        }
    }
}
