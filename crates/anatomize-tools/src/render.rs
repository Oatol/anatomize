//! 一个够用就好的软件光栅器：只为了在 headless 环境里看一眼 ragdoll 长什么样。
//! 不追求抗锯齿，不追求性能，追求"零依赖、能出 PNG"。

use anatomize_core::Vec2;
use std::fs::File;
use std::io::BufWriter;
use std::path::Path;

pub struct Canvas {
    pub w: u32,
    pub h: u32,
    px: Vec<u8>,
    scale: f32,
    center_y: f32,
}

impl Canvas {
    pub fn new(w: u32, h: u32, world_width: f32, center_y: f32) -> Self {
        Self {
            w,
            h,
            px: vec![0; (w * h * 4) as usize],
            scale: w as f32 / world_width,
            center_y,
        }
    }

    #[inline]
    fn to_px(&self, p: Vec2) -> (f32, f32) {
        (
            self.w as f32 * 0.5 + p.x * self.scale,
            self.h as f32 * 0.5 - (p.y - self.center_y) * self.scale,
        )
    }

    pub fn clear(&mut self, c: [u8; 4]) {
        for chunk in self.px.chunks_exact_mut(4) {
            chunk.copy_from_slice(&c);
        }
    }

    #[inline]
    pub fn put(&mut self, x: i32, y: i32, c: [u8; 4]) {
        if x < 0 || y < 0 || x >= self.w as i32 || y >= self.h as i32 {
            return;
        }
        let i = ((y as u32 * self.w + x as u32) * 4) as usize;
        self.px[i..i + 4].copy_from_slice(&c);
    }

    pub fn fill_poly(&mut self, poly: &[Vec2], c: [u8; 4]) {
        if poly.len() < 3 {
            return;
        }
        let pts: Vec<(f32, f32)> = poly.iter().map(|p| self.to_px(*p)).collect();
        let ymin = pts
            .iter()
            .map(|p| p.1)
            .fold(f32::INFINITY, f32::min)
            .floor()
            .max(0.0) as i32;
        let ymax = pts
            .iter()
            .map(|p| p.1)
            .fold(f32::NEG_INFINITY, f32::max)
            .ceil()
            .min(self.h as f32 - 1.0) as i32;

        let mut xs: Vec<f32> = Vec::with_capacity(8);
        for y in ymin..=ymax {
            let yc = y as f32 + 0.5;
            xs.clear();
            for i in 0..pts.len() {
                let (x1, y1) = pts[i];
                let (x2, y2) = pts[(i + 1) % pts.len()];
                if (y1 <= yc && y2 > yc) || (y2 <= yc && y1 > yc) {
                    let t = (yc - y1) / (y2 - y1);
                    xs.push(x1 + t * (x2 - x1));
                }
            }
            xs.sort_by(|a, b| a.partial_cmp(b).unwrap_or(std::cmp::Ordering::Equal));
            for pair in xs.chunks_exact(2) {
                let x0 = pair[0].round() as i32;
                let x1 = pair[1].round() as i32;
                for x in x0..=x1 {
                    self.put(x, y, c);
                }
            }
        }
    }

    pub fn line(&mut self, a: Vec2, b: Vec2, c: [u8; 4], t: i32) {
        let (x1, y1) = self.to_px(a);
        let (x2, y2) = self.to_px(b);
        let steps = ((x2 - x1).abs().max((y2 - y1).abs())).ceil() as i32;
        let steps = steps.max(1);
        for i in 0..=steps {
            let t01 = i as f32 / steps as f32;
            let x = x1 + (x2 - x1) * t01;
            let y = y1 + (y2 - y1) * t01;
            for dy in -t..=t {
                for dx in -t..=t {
                    self.put(x as i32 + dx, y as i32 + dy, c);
                }
            }
        }
    }

    pub fn stroke_poly(&mut self, poly: &[Vec2], c: [u8; 4], t: i32) {
        for i in 0..poly.len() {
            self.line(poly[i], poly[(i + 1) % poly.len()], c, t);
        }
    }

    pub fn disc(&mut self, p: Vec2, r_px: f32, c: [u8; 4]) {
        let (cx, cy) = self.to_px(p);
        let r = r_px.ceil() as i32;
        for dy in -r..=r {
            for dx in -r..=r {
                if (dx * dx + dy * dy) as f32 <= r_px * r_px {
                    self.put(cx as i32 + dx, cy as i32 + dy, c);
                }
            }
        }
    }

    /// 世界坐标的矩形（左下角 + 右上角）。
    pub fn rect(&mut self, lo: Vec2, hi: Vec2, c: [u8; 4]) {
        let (x0, y1) = self.to_px(lo);
        let (x1, y0) = self.to_px(hi);
        let xa = x0.min(x1) as i32;
        let xb = x0.max(x1) as i32;
        let ya = y0.min(y1) as i32;
        let yb = y0.max(y1) as i32;
        for y in ya..=yb {
            for x in xa..=xb {
                self.put(x, y, c);
            }
        }
    }

    pub fn save(&self, path: &Path) -> Result<(), Box<dyn std::error::Error>> {
        if let Some(dir) = path.parent() {
            std::fs::create_dir_all(dir)?;
        }
        let file = File::create(path)?;
        let mut enc = png::Encoder::new(BufWriter::new(file), self.w, self.h);
        enc.set_color(png::ColorType::Rgba);
        enc.set_depth(png::BitDepth::Eight);
        let mut writer = enc.write_header()?;
        writer.write_image_data(&self.px)?;
        Ok(())
    }
}
