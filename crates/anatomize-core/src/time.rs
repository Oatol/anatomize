//! 固定步长的时间。整个模拟只有一个时钟：60Hz。

/// 物理与伤害判定的频率。
pub const TICK_HZ: u32 = 60;

/// 单步时长（秒）。
pub const DT: f32 = 1.0 / TICK_HZ as f32;

/// 组织场的频率（每 3 个物理 tick 更新一次）。
pub const TISSUE_HZ: u32 = 20;

/// 自世界创建以来的 tick 数。
#[derive(Debug, Clone, Copy, Default, PartialEq, Eq, PartialOrd, Ord)]
pub struct Tick(pub u64);

impl Tick {
    pub fn advance(&mut self) -> u64 {
        self.0 += 1;
        self.0
    }

    pub fn seconds(self) -> f64 {
        self.0 as f64 * DT as f64
    }

    /// 组织场是否该在这一 tick 更新。
    pub fn tissue_due(self) -> bool {
        self.0 % (TICK_HZ / TISSUE_HZ) as u64 == 0
    }
}
