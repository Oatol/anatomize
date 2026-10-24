//! 手抓：拖拽的物理实现。
//!
//! # 为什么不是"把速度设成 (鼠标位置 − 位置) / 0.1"
//!
//! 之前就是这么干的（`pull_piece`）。问题是**它只改线速度**：
//! 抓住一只手拖，整具身体会平移过去，不会绕着肩膀转。看起来像"提着一个人偶
//! 的纸片"。
//!
//! MaD2 的手工具（`Tool.DRAG`）用的是 **`b2MouseJoint`**：弹簧挂在**抓取点**上，
//! 力也作用在抓取点上。所以抓住一只手拖，身体会绕着那只手翻转、腿会甩——
//! 那才是 ragdoll 该有的手感。
//!
//! rapier 没有 mouse joint，但它的等价物是**在抓取点施加弹簧力**：
//!
//! ```text
//! F = k · (鼠标 − 抓取点) − c · v_抓取点
//! ```
//!
//! `v_抓取点 = v_cm + ω × r`——**这一项就是关键**。力作用在偏离质心的点上，
//! 自然产生力矩，身体就转起来了。
//!
//! 参数按"临界阻尼"取：`k = m·ω²`、`c = 2mω`，`ω = 22 rad/s`（约 0.05 秒到位）。
//! 用质量缩放而不是固定刚度，这样拖 300kg 的水泥块和拖 0.4kg 的手感一致。

use crate::{PieceId, RVec2, Sim, rv};
use anatomize_core::Vec2;

/// 一次抓取。
#[derive(Debug, Clone, Copy)]
pub struct Grab {
    pub id: PieceId,
    /// 抓取点，**块局部米**（相对块质心）。
    pub local: Vec2,
    /// 鼠标在哪（世界米）。每帧由 UI 更新。
    pub target: Vec2,
}

impl Sim {
    /// 抓住一块的某个点。`world` 是鼠标按下的世界位置。
    pub fn grab(&mut self, id: PieceId, world: Vec2) -> bool {
        let p = &self.body.pieces[id.index()];
        if p.deleted || p.is_frozen() {
            return false;
        }
        let Some(rb) = self.physics.bodies.get(p.body) else {
            return false;
        };
        let local = rb.position().inverse().transform_point(rv(world));
        self.grab_state = Some(Grab {
            id,
            local: Vec2::new(local.x, local.y),
            target: world,
        });
        true
    }

    /// 更新鼠标位置。抓着的时候每帧调。
    pub fn drag_to(&mut self, target: Vec2) {
        if let Some(g) = &mut self.grab_state {
            g.target = target;
        }
    }

    pub fn release_grab(&mut self) {
        self.grab_state = None;
    }

    pub fn grabbed(&self) -> Option<Grab> {
        self.grab_state
    }

    /// 每物理步施加一次弹簧力。由 `step()` 调。
    ///
    /// 用**力**而不是冲量：力会在这一步内被积分，稳定；冲量会在低速时抖。
    pub(crate) fn apply_grab(&mut self) {
        let Some(g) = self.grab_state else {
            return;
        };
        let p = &self.body.pieces[g.id.index()];
        if p.deleted || p.is_frozen() {
            self.grab_state = None;
            return;
        }
        let Some(rb) = self.physics.bodies.get(p.body) else {
            self.grab_state = None;
            return;
        };
        let pose = *rb.position();
        let point = pose.transform_point(rv(g.local));
        let v = rb.linvel();
        let w = rb.angvel();
        let r = point - pose.translation;
        // 抓取点的速度：v_cm + ω × r（2D 里 ω × r = (-ω·r.y, ω·r.x)）
        let vp = v + RVec2::new(-w * r.y, w * r.x);
        let m = rb.mass().max(0.05);

        let omega = 22.0f32;
        let k = m * omega * omega;
        let c = 2.0 * m * omega;
        let err = rv(g.target) - point;
        let force = err * k - vp * c;

        // 限幅：别把 300kg 的水泥块一瞬间拉出 100 m/s。
        // 上限按"加速度不超过 60 m/s²"取。
        let max_f = m * 60.0;
        let f = if force.length() > max_f {
            force.normalize() * max_f
        } else {
            force
        };
        if let Some(rb) = self.physics.bodies.get_mut(p.body) {
            rb.add_force_at_point(f, point, true);
        }
    }
}
