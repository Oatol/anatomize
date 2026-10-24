//! 粒子：切割、爆炸、出血时的视觉反馈。
//!
//! # 为什么需要它
//!
//! 参考 MaD2（`Cutter.as` 第 956 行）：切割时
//! `particles.addParticles(x, y, 1, "sparkle", vx, vy)`——每一刀都在切口
//! 喷东西。没有粒子的话，切开一个人是**静悄悄**的：数值上在流血，画面上
//! 什么都没发生。
//!
//! # 三种粒子
//!
//! | 来源 | 颜色 | 初速 |
//! |---|---|---|
//! | 切割 | 暗红 | 沿切口法线，带随机散布 |
//! | 爆炸 | 橙黄 | 径向，快 |
//! | 出血 | 暗红 | 从创口向上，慢 |
//!
//! 落地之后变成**血迹**（不消失，有上限），这样切过的地方会留下痕迹。

use anatomize_core::Vec2;
use egui::{Painter, Rect};

use crate::camera::Camera;
use crate::view::c32a;

/// 一颗粒子。
#[derive(Debug, Clone)]
pub struct Particle {
    pub pos: Vec2,
    pub vel: Vec2,
    pub life: f32,
    pub max_life: f32,
    pub color: [u8; 4],
    pub size: f32,
    /// 已经落地（不再模拟，只画）
    pub settled: bool,
}

/// 粒子池 + 血迹。
pub struct Particles {
    pub items: Vec<Particle>,
    /// 落地之后留下的血迹（永久，有上限）。
    pub stains: Vec<(Vec2, f32, [u8; 4])>,
    rng: u32,
}

const MAX_ITEMS: usize = 900;
const MAX_STAINS: usize = 260;

impl Default for Particles {
    fn default() -> Self {
        Self {
            items: Vec::with_capacity(MAX_ITEMS),
            stains: Vec::with_capacity(MAX_STAINS),
            rng: 0x9E37_79B9,
        }
    }
}

impl Particles {
    /// 一个便宜但够用的伪随机（xorshift）。
    fn rand(&mut self) -> f32 {
        let mut x = self.rng;
        x ^= x << 13;
        x ^= x >> 17;
        x ^= x << 5;
        self.rng = x;
        (x >> 8) as f32 / 16_777_216.0
    }

    fn push(&mut self, p: Particle) {
        if self.items.len() >= MAX_ITEMS {
            self.items.swap_remove(0);
        }
        self.items.push(p);
    }

    /// 切割：沿切口两侧喷血。
    ///
    /// `dir` 是刀面法线——血从切口往两边溅，不是沿刀线走。
    /// `amount` 大概等于这一刀的出血速率（mL/s），用它决定粒子数。
    pub fn cut(&mut self, a: Vec2, b: Vec2, dir: Vec2, amount: f32) {
        let n = ((amount * 1.6) as usize).clamp(3, 26);
        let len = (b - a).length();
        for _ in 0..n {
            let t = self.rand();
            let at = a + (b - a) * t;
            let side = if self.rand() < 0.5 { 1.0 } else { -1.0 };
            let jitter = (self.rand() - 0.5) * 0.9;
            let v =
                dir * side * (0.5 + self.rand() * 1.6) + Vec2::new(jitter, 0.4 + self.rand() * 1.2);
            let life = 0.35 + self.rand() * 0.7;
            let size = 0.006 + self.rand() * 0.010;
            let vel = v * (0.6 + len * 0.4);
            self.push(Particle {
                pos: at,
                vel,
                life,
                max_life: life,
                color: [150, 20, 24, 235],
                size,
                settled: false,
            });
        }
    }

    /// 爆炸：径向的橙色碎片。
    pub fn burst(&mut self, at: Vec2, power: f32) {
        let n = (power * 0.35) as usize;
        for _ in 0..n {
            let a = self.rand() * std::f32::consts::TAU;
            let sp = 2.0 + self.rand() * 7.0;
            let life = 0.25 + self.rand() * 0.5;
            let size = 0.008 + self.rand() * 0.016;
            let vel = Vec2::new(a.cos(), a.sin()) * sp;
            self.push(Particle {
                pos: at,
                vel,
                life,
                max_life: life,
                color: [250, 170, 70, 240],
                size,
                settled: false,
            });
        }
    }

    /// 持续出血：从创口慢慢冒。
    pub fn ooze(&mut self, at: Vec2, amount: f32, dt: f32) {
        // 每秒 `amount` 颗，按 dt 累积
        let n = (amount * dt * 22.0) as usize;
        for _ in 0..n.min(3) {
            let j = Vec2::new((self.rand() - 0.5) * 0.02, (self.rand() - 0.5) * 0.02);
            let life = 0.5 + self.rand() * 0.8;
            let vx = (self.rand() - 0.5) * 0.25;
            let vy = -0.15 - self.rand() * 0.4;
            let size = 0.005 + self.rand() * 0.008;
            self.push(Particle {
                pos: at + j,
                vel: Vec2::new(vx, vy),
                life,
                max_life: life,
                color: [130, 16, 20, 220],
                size,
                settled: false,
            });
        }
    }

    /// 更新：重力、阻尼、落地变血迹。
    pub fn update(&mut self, dt: f32, ground: f32) {
        let g = -9.8;
        for p in &mut self.items {
            if p.settled {
                continue;
            }
            p.life -= dt;
            p.vel.y += g * dt;
            p.vel *= 0.995;
            p.pos += p.vel * dt;
            if p.pos.y <= ground {
                p.pos.y = ground;
                p.settled = true;
                p.life = 1e9; // 血迹不消失
                if self.stains.len() >= MAX_STAINS {
                    self.stains.remove(0);
                }
                self.stains.push((p.pos, p.size * 1.8, p.color));
            }
        }
        self.items.retain(|p| p.life > 0.0);
    }

    pub fn clear(&mut self) {
        self.items.clear();
        self.stains.clear();
    }

    pub fn draw(&self, painter: &Painter, cam: &Camera, view: Rect) {
        // 血迹在下，粒子在上
        for (pos, r, c) in &self.stains {
            let s = cam.to_screen(*pos, view);
            painter.circle_filled(s, cam.px(*r).max(1.0), c32a(*c, 120));
        }
        for p in &self.items {
            let s = cam.to_screen(p.pos, view);
            let a = (p.life / p.max_life).clamp(0.0, 1.0);
            let alpha = if p.settled { 120 } else { (a * 235.0) as u8 };
            painter.circle_filled(s, cam.px(p.size).max(1.0), c32a(p.color, alpha));
        }
    }
}
