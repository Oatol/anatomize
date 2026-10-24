//! 中文文字渲染。
//!
//! 内置的 5×7 点阵字体只够写 ASCII，验收图里的中文必须靠真字体光栅化。
//! 这里用 `fontdue`（纯 Rust、零系统依赖）读一份**系统 CJK 字体**，
//! 找不到就退回点阵字体并把语言强制成英文——**宁可少一种语言，也不要画一堆方块**。
//!
//! 字体路径按平台顺序探测，也可以用 `ANATOMIZE_FONT=/path/to/font.ttc` 指定。
//! 字体文件不进仓库（微软雅黑 19 MB），这是刻意的：仓库不该背一份字体授权。

use crate::render::Canvas;

/// 依次尝试的字体路径。第一个能读的胜出。
const CANDIDATES: &[&str] = &[
    // Windows
    "C:/Windows/Fonts/msyh.ttc",
    "C:/Windows/Fonts/msyhl.ttc",
    "C:/Windows/Fonts/simhei.ttf",
    "C:/Windows/Fonts/Deng.ttf",
    // macOS
    "/System/Library/Fonts/PingFang.ttc",
    "/System/Library/Fonts/STHeiti Medium.ttc",
    "/Library/Fonts/Arial Unicode.ttf",
    // Linux
    "/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc",
    "/usr/share/fonts/noto-cjk/NotoSansCJK-Regular.ttc",
    "/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc",
    "/usr/share/fonts/truetype/arphic/uming.ttc",
];

/// 文本渲染器。有字体时用字体，没字体时退回 5×7 点阵。
pub struct TextRenderer {
    font: Option<fontdue::Font>,
    /// 实际用的字体路径（日志用）。
    pub source: String,
}

impl TextRenderer {
    /// 探测系统字体。找不到也不失败，只是 `has_cjk()` 为假。
    pub fn system() -> Self {
        let mut paths: Vec<String> = Vec::new();
        if let Ok(p) = std::env::var("ANATOMIZE_FONT") {
            paths.push(p);
        }
        paths.extend(CANDIDATES.iter().map(|s| s.to_string()));

        for p in paths {
            let Ok(bytes) = std::fs::read(&p) else {
                continue;
            };
            // .ttc 是字体集合，取第 0 个字重
            let settings = fontdue::FontSettings {
                collection_index: 0,
                ..Default::default()
            };
            if let Ok(font) = fontdue::Font::from_bytes(bytes, settings) {
                return Self {
                    font: Some(font),
                    source: p,
                };
            }
        }
        Self {
            font: None,
            source: "(none)".into(),
        }
    }

    /// 能不能画中文。
    pub fn has_cjk(&self) -> bool {
        self.font.is_some()
    }

    /// 字符串在 `px` 字号下的宽度（像素）。
    pub fn width(&self, s: &str, px: f32) -> i32 {
        match &self.font {
            Some(f) => {
                let mut w = 0.0f32;
                for ch in s.chars() {
                    w += f.metrics(ch, px).advance_width;
                }
                w.ceil() as i32
            }
            None => Canvas::text_width(s, bitmap_scale(px)),
        }
    }

    /// 行高（像素），用来排版多行。
    pub fn line_height(&self, px: f32) -> i32 {
        match &self.font {
            Some(f) => f
                .horizontal_line_metrics(px)
                .map(|m| (m.ascent - m.descent + m.line_gap).ceil() as i32)
                .unwrap_or((px * 1.4) as i32),
            None => 7 * bitmap_scale(px) + 4,
        }
    }

    /// 在像素坐标 `(x, y)` 画一行字。`y` 是**行顶**，不是基线。
    ///
    /// 返回这行字的宽度。颜色带 alpha，会和画布上已有的像素混合。
    pub fn draw(
        &self,
        cv: &mut Canvas,
        x: i32,
        y: i32,
        s: &str,
        px: f32,
        color: [u8; 4],
    ) -> i32 {
        let Some(f) = &self.font else {
            cv.text(x, y, s, bitmap_scale(px), color);
            return Canvas::text_width(s, bitmap_scale(px));
        };

        let ascent = f
            .horizontal_line_metrics(px)
            .map(|m| m.ascent)
            .unwrap_or(px * 0.8);
        let baseline = y as f32 + ascent;
        let mut pen = x as f32;

        for ch in s.chars() {
            let (m, bitmap) = f.rasterize(ch, px);
            if m.width > 0 && m.height > 0 {
                let ox = pen as i32 + m.xmin;
                let oy = baseline as i32 - (m.height as i32 + m.ymin);
                for row in 0..m.height {
                    for col in 0..m.width {
                        let a = bitmap[row * m.width + col];
                        if a > 8 {
                            cv.blend(ox + col as i32, oy + row as i32, color, a);
                        }
                    }
                }
            }
            pen += m.advance_width;
        }
        (pen - x as f32).ceil() as i32
    }

    /// 画一行并水平居中于 `[x0, x1)`。
    #[allow(clippy::too_many_arguments)]
    pub fn draw_centered(
        &self,
        cv: &mut Canvas,
        x0: i32,
        x1: i32,
        y: i32,
        s: &str,
        px: f32,
        color: [u8; 4],
    ) {
        let w = self.width(s, px);
        self.draw(cv, (x0 + x1 - w) / 2, y, s, px, color);
    }

    /// 右对齐到 `x_right`。
    pub fn draw_right(
        &self,
        cv: &mut Canvas,
        x_right: i32,
        y: i32,
        s: &str,
        px: f32,
        color: [u8; 4],
    ) {
        let w = self.width(s, px);
        self.draw(cv, x_right - w, y, s, px, color);
    }
}

/// 点阵字体只有 5×7，把想要的像素字号折成放大倍数。
fn bitmap_scale(px: f32) -> i32 {
    ((px / 7.0).round() as i32).clamp(1, 4)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn renderer_always_constructs() {
        // 没有字体的机器上也不能 panic，只是画不出中文
        let tr = TextRenderer::system();
        println!(
            "字体：{}（CJK {}）",
            tr.source,
            if tr.has_cjk() { "可用" } else { "不可用" }
        );
        assert!(tr.line_height(16.0) >= 7);
    }

    #[test]
    fn width_is_monotone_in_length() {
        let tr = TextRenderer::system();
        let a = tr.width("血", 16.0);
        let b = tr.width("血压", 16.0);
        assert!(b > a, "两个字应该比一个字宽：{a} vs {b}");
    }
}
