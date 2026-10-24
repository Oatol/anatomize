//! 几何切割。
//!
//! 设计要点见 `设计文档-v0.2.md` 第 7 节：
//! - 只裁凸多边形，切面天然闭合（2D 没有"水密"问题，只有闭合环）
//! - 切面折线同时是"创口"的几何定义，也是结构求交的输入
//! - 结构判定用**几何求交**，不用能量阈值
//!
//! 这个 crate 是纯几何，不依赖物理引擎，可以脱离世界跑 fuzz。

pub mod decomp;
pub mod intersect;
pub mod line;
pub mod split;

pub use decomp::{convex_decompose, convex_hull, signed_area, triangulate};
pub use intersect::{Crossing, segment_polyline, segment_segment};
pub use line::Line;
pub use split::{Fragment, SplitOutcome, split_convex, split_part};

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

    pub fn line(&self) -> Option<Line> {
        Line::through(self.a, self.b)
    }

    /// 切线与一条折线的所有交点，按沿切线的参数排序。
    pub fn crossings(&self, path: &[Vec2]) -> Vec<Crossing> {
        segment_polyline(self.a, self.b, path)
    }
}
