//! 几何切割。
//!
//! **状态：M1 实现。** 这里先定下切段的表示，因为它是 L1 与 L2/L3 之间的契约。
//!
//! 设计要点见 `设计文档-v0.2.md` 第 7 节：
//! - 只裁凸多边形，切面天然闭合（2D 没有"水密"问题，只有闭合环）
//! - 切面折线同时是"创口"的几何定义，也是结构求交的输入
//! - 结构判定用**几何求交**，不用能量阈值

use anatomize_core::Vec2;

/// 一次切割。由刀具（或机械臂）在某一帧产生。
#[derive(Debug, Clone)]
pub struct CutSegment {
    pub a: Vec2,
    pub b: Vec2,
    /// 刀口宽度（米）。决定组织场创口带的 texel 数。
    pub width: f32,
    /// 沿切向的速度（m/s），影响撕裂长度与阻力。
    pub speed: f32,
}

impl CutSegment {
    pub fn length(&self) -> f32 {
        (self.b - self.a).length()
    }

    pub fn dir(&self) -> Vec2 {
        (self.b - self.a).normalize_or_zero()
    }
}
