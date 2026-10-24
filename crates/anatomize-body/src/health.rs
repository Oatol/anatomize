//! 关节健康与三级状态机。
//!
//! 这一层是**纯逻辑**：没有任何引擎依赖，也不碰刚体。它只回答"这个关节现在处于
//! 什么状态、四个健康量是多少"，至于"状态怎么变成物理约束"是 `anatomize-sim` 的事。
//! 这样状态机可以脱离物理世界单独测。
//!
//! # 为什么是四量而不是一个 health
//!
//! - `integrity` —— 会不会断
//! - `inflammation` —— 断了以后好不好使（肿、僵）
//! - `pain` —— 他会怎么动（护着伤处）
//! - `rom_scale` —— 能弯到多少度（扭伤后松弛）
//!
//! 一个数只能表达"坏了多少"，四个量能表达"坏了之后是什么状态"。
//!
//! # 状态机
//!
//! ```text
//! Intact ──integrity<0.70──► Sprained ──integrity<0.35──► Subluxed
//!                                                             │
//!                                              integrity<0.15 ▼
//!                                                        Dislocated
//!                                                             │ tether 断
//!                                                             ▼
//!                                                         Severed
//! ```
//!
//! **Dislocated 不是"没有约束"，而是"软约束"**——肢体还挂着，会甩、会拉、会痛，
//! 但不会飞走。这是"手感真实"的来源，也是 v0.1 直接 `remove_joint` 最缺的中间态。

use serde::{Deserialize, Serialize};

/// 损伤参数资产。`include_str!` 进二进制，和 `human_01.ron` 一样的做法。
pub const ASSET_DAMAGE_CONFIG: &str = include_str!("../../../assets/config/damage.ron");

/// `damage.ron` 的根。以后会加 `bone` / `soft_tissue` 块。
#[derive(Debug, Clone, Copy, Default, Deserialize)]
#[serde(default)]
pub struct DamageConfig {
    pub joint: JointParams,
}

impl DamageConfig {
    pub fn from_ron(src: &str) -> Result<Self, ron::error::SpannedError> {
        ron::from_str(src)
    }

    /// 加载内置资产。资产坏了是开发者的错，直接 panic 比静默降级好。
    pub fn asset() -> Self {
        Self::from_ron(ASSET_DAMAGE_CONFIG).expect("assets/config/damage.ron 解析失败")
    }
}

/// 关节状态。顺序有意义：`Ord` 越大越严重。
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Serialize, Deserialize)]
pub enum JointState {
    Intact,
    Sprained,
    Subluxed,
    Dislocated,
    Severed,
}

impl JointState {
    pub fn name(self) -> &'static str {
        match self {
            JointState::Intact => "intact",
            JointState::Sprained => "sprained",
            JointState::Subluxed => "subluxed",
            JointState::Dislocated => "dislocated",
            JointState::Severed => "severed",
        }
    }

    /// 这个状态下关节还用不用硬约束。
    pub fn uses_hard_constraint(self) -> bool {
        self <= JointState::Subluxed
    }

    /// 这个状态下关节还连着没有。
    pub fn is_connected(self) -> bool {
        self != JointState::Severed
    }
}

/// 关节健康四量 + 状态 + tether 余量。
#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct JointHealth {
    /// 0..1 结构完整（韧带 / 关节囊 / 骨端）。
    pub integrity: f32,
    /// 0..1 炎症：抬高刚度、产生疼痛。
    pub inflammation: f32,
    /// 0..1 伤害感受输出。
    pub pain: f32,
    /// 0..1 活动度缩放，1 = 正常，>1 = 松弛。
    pub rom_scale: f32,
    /// 脱位后仍连着的软组织（皮肤 / 韧带 / 血管束）的完整度，0 即离断。
    pub tether: f32,
    pub state: JointState,
    /// 连续超限的计时（秒）。
    pub overrun_timer: f32,
    /// 累计受过的损伤（0..∞），用于 HUD 和调参。
    pub accumulated: f32,
}

impl Default for JointHealth {
    fn default() -> Self {
        Self {
            integrity: 1.0,
            inflammation: 0.0,
            pain: 0.0,
            rom_scale: 1.0,
            tether: 1.0,
            state: JointState::Intact,
            overrun_timer: 0.0,
            accumulated: 0.0,
        }
    }
}

/// 一个 tick 里这个关节承受的载荷。全部由 `anatomize-sim` 从物理世界读出。
#[derive(Debug, Clone, Copy, Default)]
pub struct JointLoad {
    /// 当前关节角（弧度）。
    pub angle: f32,
    /// 解剖活动度上下限（弧度）。
    pub limits: (f32, f32),
    /// 本 tick 关节施加的角冲量（N·m·s）。用 rapier 的 `joint.impulses.z`。
    pub impulse: f32,
    /// 脱位后软约束被拉伸了多少（米，超出静止长度的部分）。
    pub tether_stretch: f32,
}

/// 损伤参数，对应 `assets/config/damage.ron` 的 `joint` 块。
#[derive(Debug, Clone, Copy, Deserialize)]
#[serde(default)]
pub struct JointParams {
    /// integrity 低于这些阈值就迁移状态。
    pub sprain_at: f32,
    pub sublux_at: f32,
    pub dislocate_at: f32,
    /// 超限判定：掰过活动度这个倍数、并持续 `overrun_time` 秒 → 记一次重伤。
    pub overrun_ratio: f32,
    pub overrun_time: f32,
    /// 超限死区，占活动度的比例。
    ///
    /// 关节"压在限位上"是正常姿态（坐着时髋屈到极限、手肘自然弯到底），
    /// 不该算受伤。没有死区的话，一个静止的 ragdoll 会因为浮点误差在限位附近
    /// 来回抖，几十秒内把 integrity 磨掉 5%——**实测踩到过**。
    pub overrun_deadband: f32,
    /// 角冲量超过这个值开始磨损（N·m·s）。
    pub impulse_threshold: f32,
    /// 持续磨损速率（1/s），乘超限比例。
    pub wear_rate: f32,
    /// 脱位后 tether 的磨损速率（1/s）。
    pub tether_wear: f32,
    /// 脱位后软组织能拉出多长（厘米）才绷紧。
    ///
    /// 这是"脱位"和"离断"的手感分界线：太小 → 肢体像被钢筋焊住；
    /// 太大 → 飞出去半米才被拉住。6cm 大约等于"关节面完全错开之后，
    /// 皮肤和韧带还能给出的余量"。逐关节细分留给 M5 的软组织数据。
    pub tether_len_cm: f32,
    /// 愈合速率（1/s）。默认 0：P0 不做愈合，见设计文档开放问题 1。
    pub heal_rate: f32,
    /// 受伤后炎症的上升速率（1/s）。
    pub inflammation_gain: f32,
    /// 炎症消退时间常数（秒）。
    pub inflammation_tau: f32,
}

impl Default for JointParams {
    fn default() -> Self {
        Self {
            sprain_at: 0.70,
            sublux_at: 0.35,
            dislocate_at: 0.15,
            overrun_ratio: 1.15,
            overrun_time: 0.20,
            overrun_deadband: 0.05,
            impulse_threshold: 40.0,
            wear_rate: 1.6,
            tether_wear: 0.25,
            tether_len_cm: 6.0,
            heal_rate: 0.0,
            inflammation_gain: 0.5,
            inflammation_tau: 20.0,
        }
    }
}

impl JointHealth {
    /// 喂一个 tick 的载荷。返回**发生迁移时的目标状态**，没迁移返回 None。
    ///
    /// 调用方拿到 Some 之后要负责把它变成物理动作：
    /// `Dislocated` → 换软约束，`Severed` → 彻底移除约束。
    pub fn update(&mut self, load: JointLoad, p: &JointParams, dt: f32) -> Option<JointState> {
        if self.state == JointState::Severed {
            return None;
        }

        let (lo, hi) = load.limits;
        let span = (hi - lo).abs().max(1e-3);

        // --- 1. 超限程度 ---
        // 死区：压在限位上不算超限（见 `overrun_deadband` 的注释）
        let tol = p.overrun_deadband * span;
        let over = if load.angle > hi + tol {
            load.angle - hi
        } else if load.angle < lo - tol {
            lo - load.angle
        } else {
            0.0
        };
        let ratio = over / span;
        if over > 0.0 {
            self.overrun_timer += dt;
        } else {
            self.overrun_timer = 0.0;
        }

        // --- 2. 磨损 ---
        let mut wear = 0.0f32;
        if over > 0.0 {
            // 持续掰过头，按超限比例线性磨损
            wear += p.wear_rate * ratio;
        }
        if load.impulse > p.impulse_threshold {
            // 单次猛冲：冲量越大扣得越快
            wear += p.wear_rate * (load.impulse / p.impulse_threshold - 1.0) * 0.5;
        }
        if ratio > p.overrun_ratio && self.overrun_timer > p.overrun_time {
            // 掰到 1.15 倍活动度还持续 0.2 秒 → 一次重伤
            wear += p.wear_rate * 4.0;
        }
        if wear > 0.0 {
            self.integrity = (self.integrity - wear * dt).max(0.0);
            self.accumulated += wear * dt;
            self.inflammation = (self.inflammation + p.inflammation_gain * dt).min(1.0);
        }

        // --- 3. 脱位后的 tether 磨损 ---
        if self.state == JointState::Dislocated {
            // 拉得越狠，软组织断得越快
            let pull = (load.impulse / p.impulse_threshold).clamp(0.25, 4.0);
            let stretch = (load.tether_stretch * 20.0).clamp(0.0, 4.0);
            self.tether =
                (self.tether - p.tether_wear * pull * (1.0 + stretch) * dt).max(0.0);
        }

        // --- 4. 炎症消退 / 疼痛 / 松弛度 ---
        self.inflammation = (self.inflammation - self.inflammation / p.inflammation_tau * dt)
            .clamp(0.0, 1.0);
        self.pain = ((1.0 - self.integrity) * 0.6 + self.inflammation * 0.4).clamp(0.0, 1.0);
        self.rom_scale = 1.0 + (1.0 - self.integrity) * 0.35;

        // --- 5. 愈合（默认关闭） ---
        if p.heal_rate > 0.0 && self.state != JointState::Dislocated {
            self.integrity = (self.integrity + p.heal_rate * dt).min(1.0);
        }

        // --- 6. 状态迁移 ---
        let next = match self.state {
            JointState::Intact if self.integrity < p.sprain_at => JointState::Sprained,
            JointState::Sprained if self.integrity < p.sublux_at => JointState::Subluxed,
            JointState::Subluxed if self.integrity < p.dislocate_at => JointState::Dislocated,
            JointState::Dislocated if self.tether <= 0.0 => JointState::Severed,
            s => s,
        };

        if next != self.state {
            // 进入脱位时，软组织开始承担全部载荷
            if next == JointState::Dislocated {
                self.tether = 1.0;
                self.inflammation = (self.inflammation + 0.3).min(1.0);
            }
            self.state = next;
            return Some(next);
        }
        None
    }

    /// 是否已经废了（用不了、也感觉不到）。
    pub fn is_dead(&self) -> bool {
        self.state == JointState::Severed
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn load(angle: f32, impulse: f32) -> JointLoad {
        JointLoad {
            angle,
            limits: (-0.5, 0.5),
            impulse,
            tether_stretch: 0.0,
        }
    }

    #[test]
    fn fresh_joint_is_intact() {
        let h = JointHealth::default();
        assert_eq!(h.state, JointState::Intact);
        assert_eq!(h.integrity, 1.0);
        assert_eq!(h.rom_scale, 1.0);
    }

    #[test]
    fn within_limits_never_wears() {
        let p = JointParams::default();
        let mut h = JointHealth::default();
        for _ in 0..1000 {
            assert!(h.update(load(0.3, 1.0), &p, 0.05).is_none());
        }
        assert_eq!(h.integrity, 1.0);
        assert_eq!(h.state, JointState::Intact);
    }

    #[test]
    fn sustained_overrun_walks_down_all_states() {
        let p = JointParams::default();
        let mut h = JointHealth::default();
        // 掰到 3 倍活动度，一直掰
        let mut seen = vec![h.state];
        for _ in 0..4000 {
            if let Some(s) = h.update(load(1.5, 0.0), &p, 0.05) {
                seen.push(s);
            }
            if h.state == JointState::Severed {
                break;
            }
        }
        println!("状态序列 {:?}", seen.iter().map(|s| s.name()).collect::<Vec<_>>());
        assert!(seen.contains(&JointState::Sprained), "应先扭伤");
        assert!(seen.contains(&JointState::Subluxed), "应再半脱位");
        assert!(seen.contains(&JointState::Dislocated), "应再脱位");
        assert_eq!(h.state, JointState::Severed, "一直掰到底应离断");
    }

    #[test]
    fn impulse_spike_sprains_immediately() {
        let p = JointParams::default();
        let mut h = JointHealth::default();
        // 角度在限内，但冲量是阈值的 8 倍
        let mut transitioned = None;
        for _ in 0..200 {
            if let Some(s) = h.update(load(0.0, p.impulse_threshold * 8.0), &p, 0.05) {
                transitioned = Some(s);
                break;
            }
        }
        println!("冲量尖峰后状态 {:?}，integrity {:.3}", transitioned, h.integrity);
        assert_eq!(transitioned, Some(JointState::Sprained));
    }

    #[test]
    fn dislocated_but_still_connected() {
        let p = JointParams::default();
        let mut h = JointHealth::default();
        h.integrity = 0.10;
        h.state = JointState::Subluxed;
        // 一次超限触发迁移
        h.update(load(0.0, p.impulse_threshold * 20.0), &p, 0.05);
        assert_eq!(h.state, JointState::Dislocated);
        assert!(h.state.is_connected(), "脱位后肢体还应该连着");
        assert!(!h.state.uses_hard_constraint(), "脱位后不该再用硬约束");
        assert_eq!(h.tether, 1.0);
    }

    #[test]
    fn rom_scale_grows_with_damage() {
        let p = JointParams::default();
        let mut h = JointHealth::default();
        h.integrity = 0.5;
        h.update(load(0.0, 0.0), &p, 0.05);
        println!("integrity 0.5 -> rom_scale {:.3}", h.rom_scale);
        assert!((h.rom_scale - 1.175).abs() < 1e-4);
    }
}
