//! 无限直线：切割的判定基准。

use anatomize_core::Vec2;

#[derive(Debug, Clone, Copy)]
pub struct Line {
    pub origin: Vec2,
    /// 单位方向。
    pub dir: Vec2,
}

impl Line {
    pub fn through(a: Vec2, b: Vec2) -> Option<Self> {
        let d = b - a;
        let len = d.length();
        if len < 1e-9 {
            return None;
        }
        Some(Self {
            origin: a,
            dir: d / len,
        })
    }

    /// 点到直线的有符号距离。正 = 左侧（沿 `dir` 看）。
    pub fn signed_distance(&self, p: Vec2) -> f32 {
        self.dir.perp_dot(p - self.origin)
    }

    /// 点沿直线的参数（用于排序交点）。
    pub fn project(&self, p: Vec2) -> f32 {
        self.dir.dot(p - self.origin)
    }

    pub fn normal(&self) -> Vec2 {
        Vec2::new(-self.dir.y, self.dir.x)
    }
}
