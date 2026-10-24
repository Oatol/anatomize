//! 相机：世界米 ↔ 屏幕像素。
//!
//! 只有两个量：**中心**和**缩放**。2D 沙盒不需要旋转——摄像头跟着人转会让
//! 玩家分不清上下，而这个游戏里"上下"是有意义的（重力、头在哪边）。

use anatomize_core::Vec2;
use egui::{Pos2, Rect};

/// 米 → 像素。默认 420 px/m：一个 1.4 m 的人占 590 px，在 800 高的窗口里
/// 上下留一指宽——再大就看不到地面，再小就分不清断面层次。
pub const DEFAULT_ZOOM: f32 = 420.0;

#[derive(Debug, Clone, Copy)]
pub struct Camera {
    /// 屏幕中心对应的世界坐标（米）。
    pub center: Vec2,
    /// 每米多少像素。
    pub zoom: f32,
}

impl Default for Camera {
    fn default() -> Self {
        Self {
            center: Vec2::new(0.0, 0.75),
            zoom: DEFAULT_ZOOM,
        }
    }
}

impl Camera {
    pub fn to_screen(&self, world: Vec2, view: Rect) -> Pos2 {
        Pos2::new(
            view.center().x + (world.x - self.center.x) * self.zoom,
            // 屏幕 y 向下，世界 y 向上
            view.center().y - (world.y - self.center.y) * self.zoom,
        )
    }

    pub fn to_world(&self, screen: Pos2, view: Rect) -> Vec2 {
        Vec2::new(
            self.center.x + (screen.x - view.center().x) / self.zoom,
            self.center.y - (screen.y - view.center().y) / self.zoom,
        )
    }

    /// 世界长度（米）→ 像素长度。
    pub fn px(&self, meters: f32) -> f32 {
        meters * self.zoom
    }

    /// 像素长度 → 世界长度（米）。
    pub fn meters(&self, px: f32) -> f32 {
        px / self.zoom
    }

    /// 滚轮缩放，以鼠标位置为锚点。
    ///
    /// 不做锚定的话，放大时画面会"跑"，玩家要重新找刚才在看的那个关节。
    pub fn zoom_at(&mut self, screen: Pos2, view: Rect, factor: f32) {
        let before = self.to_world(screen, view);
        self.zoom = (self.zoom * factor).clamp(40.0, 1200.0);
        let after = self.to_world(screen, view);
        self.center += before - after;
    }

    /// 把某个世界点放到屏幕中心（切一刀之后跟随用）。
    #[allow(dead_code)]
    pub fn look_at(&mut self, world: Vec2) {
        self.center = world;
    }
}
