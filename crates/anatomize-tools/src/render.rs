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

    /// 纯像素画布：不建世界坐标系，只用 `px_*` / `text` 这些方法。
    /// 热力图、图例、多联图都用它。
    pub fn blank(w: u32, h: u32) -> Self {
        Self {
            w,
            h,
            px: vec![0; (w * h * 4) as usize],
            scale: 1.0,
            center_y: 0.0,
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

    /// 像素坐标的实心矩形（含两端）。
    pub fn px_rect(&mut self, x0: i32, y0: i32, x1: i32, y1: i32, c: [u8; 4]) {
        for y in y0.min(y1)..=y0.max(y1) {
            for x in x0.min(x1)..=x0.max(x1) {
                self.put(x, y, c);
            }
        }
    }

    /// 像素坐标的实心圆。
    pub fn disc_px(&mut self, c: (i32, i32), r_px: i32, col: [u8; 4]) {
        for dy in -r_px..=r_px {
            for dx in -r_px..=r_px {
                if dx * dx + dy * dy <= r_px * r_px {
                    self.put(c.0 + dx, c.1 + dy, col);
                }
            }
        }
    }

    /// 像素坐标的直线，`t` 是半宽。
    pub fn line_px(&mut self, a: (i32, i32), b: (i32, i32), c: [u8; 4], t: i32) {
        let (x1, y1) = (a.0 as f32, a.1 as f32);
        let (x2, y2) = (b.0 as f32, b.1 as f32);
        let steps = (x2 - x1).abs().max((y2 - y1).abs()).ceil() as i32;
        let steps = steps.max(1);
        for i in 0..=steps {
            let u = i as f32 / steps as f32;
            let x = (x1 + (x2 - x1) * u) as i32;
            let y = (y1 + (y2 - y1) * u) as i32;
            for dy in -t..=t {
                for dx in -t..=t {
                    self.put(x + dx, y + dy, c);
                }
            }
        }
    }

    /// 把另一张画布贴到像素坐标 (ox, oy)，超出部分裁掉。
    pub fn blit(&mut self, src: &Canvas, ox: i32, oy: i32) {
        for y in 0..src.h as i32 {
            for x in 0..src.w as i32 {
                let i = ((y as u32 * src.w + x as u32) * 4) as usize;
                let c = [
                    src.px[i],
                    src.px[i + 1],
                    src.px[i + 2],
                    src.px[i + 3],
                ];
                self.put(ox + x, oy + y, c);
            }
        }
    }

    /// 5×7 点阵文字。`scale` 是放大倍数（1 = 5×7 像素）。
    ///
    /// 为什么自己写点阵：headless 环境没有字体栈，而验收图没有标签就没法看。
    /// 60 行数据换掉一整个字体依赖，划算。
    pub fn text(&mut self, x: i32, y: i32, s: &str, scale: i32, c: [u8; 4]) {
        let k = scale.max(1);
        let mut cx = x;
        for ch in s.chars() {
            let Some(g) = glyph(ch) else {
                cx += 6 * k;
                continue;
            };
            for (row, bits) in g.iter().enumerate() {
                for col in 0..5 {
                    if bits & (1 << (4 - col)) != 0 {
                        self.px_rect(
                            cx + col * k,
                            y + row as i32 * k,
                            cx + col * k + k - 1,
                            y + row as i32 * k + k - 1,
                            c,
                        );
                    }
                }
            }
            cx += 6 * k;
        }
    }

    /// 文字宽度（像素）。
    pub fn text_width(s: &str, scale: i32) -> i32 {
        s.chars().count() as i32 * 6 * scale.max(1)
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

// ---------------------------------------------------------------------------
// 5×7 点阵字体
// ---------------------------------------------------------------------------

/// 每个字形 7 行，每行低 5 位，最高位（bit4）是最左列。
#[rustfmt::skip]
fn glyph(c: char) -> Option<[u8; 7]> {
    let g = match c.to_ascii_uppercase() {
        'A' => [0b01110,0b10001,0b10001,0b11111,0b10001,0b10001,0b10001],
        'B' => [0b11110,0b10001,0b10001,0b11110,0b10001,0b10001,0b11110],
        'C' => [0b01110,0b10001,0b10000,0b10000,0b10000,0b10001,0b01110],
        'D' => [0b11110,0b10001,0b10001,0b10001,0b10001,0b10001,0b11110],
        'E' => [0b11111,0b10000,0b10000,0b11110,0b10000,0b10000,0b11111],
        'F' => [0b11111,0b10000,0b10000,0b11110,0b10000,0b10000,0b10000],
        'G' => [0b01110,0b10001,0b10000,0b10111,0b10001,0b10001,0b01111],
        'H' => [0b10001,0b10001,0b10001,0b11111,0b10001,0b10001,0b10001],
        'I' => [0b01110,0b00100,0b00100,0b00100,0b00100,0b00100,0b01110],
        'J' => [0b00111,0b00010,0b00010,0b00010,0b00010,0b10010,0b01100],
        'K' => [0b10001,0b10010,0b10100,0b11000,0b10100,0b10010,0b10001],
        'L' => [0b10000,0b10000,0b10000,0b10000,0b10000,0b10000,0b11111],
        'M' => [0b10001,0b11011,0b10101,0b10101,0b10001,0b10001,0b10001],
        'N' => [0b10001,0b11001,0b10101,0b10011,0b10001,0b10001,0b10001],
        'O' => [0b01110,0b10001,0b10001,0b10001,0b10001,0b10001,0b01110],
        'P' => [0b11110,0b10001,0b10001,0b11110,0b10000,0b10000,0b10000],
        'Q' => [0b01110,0b10001,0b10001,0b10001,0b10101,0b10010,0b01101],
        'R' => [0b11110,0b10001,0b10001,0b11110,0b10100,0b10010,0b10001],
        'S' => [0b01111,0b10000,0b10000,0b01110,0b00001,0b00001,0b11110],
        'T' => [0b11111,0b00100,0b00100,0b00100,0b00100,0b00100,0b00100],
        'U' => [0b10001,0b10001,0b10001,0b10001,0b10001,0b10001,0b01110],
        'V' => [0b10001,0b10001,0b10001,0b10001,0b10001,0b01010,0b00100],
        'W' => [0b10001,0b10001,0b10001,0b10101,0b10101,0b11011,0b10001],
        'X' => [0b10001,0b10001,0b01010,0b00100,0b01010,0b10001,0b10001],
        'Y' => [0b10001,0b10001,0b01010,0b00100,0b00100,0b00100,0b00100],
        'Z' => [0b11111,0b00001,0b00010,0b00100,0b01000,0b10000,0b11111],
        '0' => [0b01110,0b10001,0b10011,0b10101,0b11001,0b10001,0b01110],
        '1' => [0b00100,0b01100,0b00100,0b00100,0b00100,0b00100,0b01110],
        '2' => [0b01110,0b10001,0b00001,0b00010,0b00100,0b01000,0b11111],
        '3' => [0b11111,0b00010,0b00100,0b00010,0b00001,0b10001,0b01110],
        '4' => [0b00010,0b00110,0b01010,0b10010,0b11111,0b00010,0b00010],
        '5' => [0b11111,0b10000,0b11110,0b00001,0b00001,0b10001,0b01110],
        '6' => [0b00110,0b01000,0b10000,0b11110,0b10001,0b10001,0b01110],
        '7' => [0b11111,0b00001,0b00010,0b00100,0b01000,0b01000,0b01000],
        '8' => [0b01110,0b10001,0b10001,0b01110,0b10001,0b10001,0b01110],
        '9' => [0b01110,0b10001,0b10001,0b01111,0b00001,0b00010,0b01100],
        '.' => [0b00000,0b00000,0b00000,0b00000,0b00000,0b01100,0b01100],
        ',' => [0b00000,0b00000,0b00000,0b00000,0b01100,0b01100,0b11000],
        '-' => [0b00000,0b00000,0b00000,0b11111,0b00000,0b00000,0b00000],
        '+' => [0b00000,0b00100,0b00100,0b11111,0b00100,0b00100,0b00000],
        '%' => [0b11001,0b11010,0b00010,0b00100,0b01000,0b01011,0b10011],
        '/' => [0b00001,0b00010,0b00010,0b00100,0b01000,0b01000,0b10000],
        '(' => [0b00010,0b00100,0b01000,0b01000,0b01000,0b00100,0b00010],
        ')' => [0b01000,0b00100,0b00010,0b00010,0b00010,0b00100,0b01000],
        ':' => [0b00000,0b01100,0b01100,0b00000,0b01100,0b01100,0b00000],
        ' ' => [0; 7],
        _ => return None,
    };
    Some(g)
}

// ---------------------------------------------------------------------------
// 色带
// ---------------------------------------------------------------------------

/// 五段 inferno 风格色带，`t ∈ [0,1]`。热力图用。
pub fn ramp(t: f32) -> [u8; 4] {
    const STOPS: [[f32; 3]; 5] = [
        [13.0, 8.0, 60.0],
        [84.0, 15.0, 109.0],
        [187.0, 55.0, 84.0],
        [249.0, 142.0, 9.0],
        [252.0, 255.0, 164.0],
    ];
    let t = t.clamp(0.0, 1.0) * (STOPS.len() - 1) as f32;
    let i = (t.floor() as usize).min(STOPS.len() - 2);
    let f = t - i as f32;
    let a = STOPS[i];
    let b = STOPS[i + 1];
    [
        (a[0] + (b[0] - a[0]) * f) as u8,
        (a[1] + (b[1] - a[1]) * f) as u8,
        (a[2] + (b[2] - a[2]) * f) as u8,
        0xFF,
    ]
}
