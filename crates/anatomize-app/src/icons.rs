//! 自绘图标。
//!
//! egui 的默认按钮是文字 + 圆角底。沙盒的工具栏要的是**图标**：一眼看出
//! 手里拿的是什么，不占地方。所以按钮的框和背景交给 egui（布局、命中测试、
//! hover 都是它的强项），**图形自己画**——这是"egui 做骨架 + 关键控件自绘"。
//!
//! 每个图标都在一个 24×24 的逻辑格里画，按 `rect` 缩放。

use egui::{Color32, Painter, Pos2, Rect, Response, Sense, Shape, Stroke, Ui, Vec2};

use crate::tools::Tool;

/// 一个图标按钮：自绘图形 + egui 的命中测试。
pub fn tool_button(ui: &mut Ui, tool: Tool, selected: bool) -> Response {
    let size = Vec2::splat(44.0);
    let (rect, resp) = ui.allocate_exact_size(size, Sense::click());
    let p = ui.painter();

    // 背景：选中 = 暗红，hover = 稍亮
    let bg = if selected {
        Color32::from_rgb(74, 42, 46)
    } else if resp.hovered() {
        Color32::from_rgb(44, 43, 54)
    } else {
        Color32::from_rgb(30, 29, 37)
    };
    p.rect_filled(rect, 4.0, bg);
    if selected {
        p.rect_stroke(
            rect,
            4.0,
            Stroke::new(1.0_f32, Color32::from_rgb(200, 90, 90)),
            egui::StrokeKind::Inside,
        );
    }

    let ink = if selected {
        Color32::from_rgb(240, 200, 200)
    } else if resp.hovered() {
        Color32::from_rgb(232, 230, 238)
    } else {
        Color32::from_rgb(170, 167, 180)
    };
    draw_tool(p, rect.shrink(9.0), tool, ink);
    resp
}

/// 在 `r` 里画一个工具的图标。
fn draw_tool(p: &Painter, r: Rect, tool: Tool, c: Color32) {
    let w = Stroke::new(1.8_f32, c);
    // 把 0..1 的坐标映射到 r
    let pt = |x: f32, y: f32| Pos2::new(r.left() + x * r.width(), r.top() + y * r.height());
    let line = |a: (f32, f32), b: (f32, f32)| p.line_segment([pt(a.0, a.1), pt(b.0, b.1)], w);

    match tool {
        // 选择：虚线框 + 中心十字
        Tool::Select => {
            let frame = Rect::from_min_max(pt(0.1, 0.1), pt(0.9, 0.9));
            dashed_rect(p, frame, c);
            line((0.5, 0.35), (0.5, 0.65));
            line((0.35, 0.5), (0.65, 0.5));
        }
        // 手：掌心 + 四指
        Tool::Hand => {
            let palm = Rect::from_min_max(pt(0.28, 0.45), pt(0.72, 0.92));
            p.rect_filled(palm, 2.0, c);
            for i in 0..4 {
                let x = 0.32 + i as f32 * 0.12;
                line((x, 0.15 + i as f32 * 0.02), (x, 0.5));
            }
        }
        // 刀：斜刃 + 柄
        Tool::Knife => {
            let blade = vec![pt(0.75, 0.1), pt(0.9, 0.25), pt(0.35, 0.8), pt(0.2, 0.65)];
            p.add(Shape::convex_polygon(blade, c, Stroke::NONE));
            line((0.2, 0.8), (0.08, 0.92));
        }
        // 锤：方头 + 斜柄
        Tool::Hammer => {
            let head = Rect::from_min_max(pt(0.45, 0.1), pt(0.9, 0.42));
            p.rect_filled(head, 2.0, c);
            line((0.55, 0.42), (0.15, 0.92));
        }
        // 冻结：雪花（三条交叉线）
        Tool::Freeze => {
            for k in 0..3 {
                let a = std::f32::consts::PI * k as f32 / 3.0;
                let (s, co) = a.sin_cos();
                line(
                    (0.5 - co * 0.4, 0.5 - s * 0.4),
                    (0.5 + co * 0.4, 0.5 + s * 0.4),
                );
            }
        }
        // 删除：叉
        Tool::Delete => {
            line((0.18, 0.18), (0.82, 0.82));
            line((0.82, 0.18), (0.18, 0.82));
        }
    }
}

fn dashed_rect(p: &Painter, r: Rect, c: Color32) {
    let w = Stroke::new(1.4_f32, c);
    let corners = [
        r.left_top(),
        r.right_top(),
        r.right_bottom(),
        r.left_bottom(),
    ];
    for i in 0..4 {
        let a = corners[i];
        let b = corners[(i + 1) % 4];
        let n = 4;
        for k in 0..n {
            let t0 = k as f32 / n as f32;
            let t1 = t0 + 0.5 / n as f32;
            let pa = Pos2::new(a.x + (b.x - a.x) * t0, a.y + (b.y - a.y) * t0);
            let pb = Pos2::new(a.x + (b.x - a.x) * t1, a.y + (b.y - a.y) * t1);
            p.line_segment([pa, pb], w);
        }
    }
}

/// 道具的小图标（物品栏用）。48×48 的框里画一个形状。
pub fn prop_icon(p: &Painter, r: Rect, kind: anatomize_sim::PropKind) {
    let c = Color32::from_rgba_unmultiplied(kind.color()[0], kind.color()[1], kind.color()[2], 255);
    let pt = |x: f32, y: f32| Pos2::new(r.left() + x * r.width(), r.top() + y * r.height());
    match kind {
        anatomize_sim::PropKind::Crate => {
            p.rect_filled(Rect::from_min_max(pt(0.15, 0.15), pt(0.85, 0.85)), 2.0, c);
            let ink = Stroke::new(1.2_f32, Color32::from_rgb(40, 30, 22));
            p.line_segment([pt(0.15, 0.15), pt(0.85, 0.85)], ink);
            p.line_segment([pt(0.85, 0.15), pt(0.15, 0.85)], ink);
        }
        anatomize_sim::PropKind::Ball => {
            p.circle_filled(pt(0.5, 0.5), r.width() * 0.36, c);
            p.circle_stroke(
                pt(0.5, 0.5),
                r.width() * 0.36,
                Stroke::new(1.2_f32, Color32::from_rgb(40, 42, 46)),
            );
        }
        anatomize_sim::PropKind::Plank => {
            p.rect_filled(Rect::from_min_max(pt(0.05, 0.38), pt(0.95, 0.62)), 2.0, c);
        }
        anatomize_sim::PropKind::Block => {
            p.rect_filled(Rect::from_min_max(pt(0.12, 0.22), pt(0.88, 0.82)), 2.0, c);
            let ink = Stroke::new(1.0_f32, Color32::from_rgb(70, 70, 74));
            for i in 1..3 {
                let y = 0.22 + i as f32 * 0.2;
                p.line_segment([pt(0.12, y), pt(0.88, y)], ink);
            }
        }
    }
}
