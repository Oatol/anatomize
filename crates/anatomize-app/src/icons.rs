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
        // 焊接：两道焊缝 + 火花
        Tool::Weld => {
            line((0.1, 0.75), (0.55, 0.2));
            line((0.45, 0.85), (0.9, 0.3));
            for k in 0..4 {
                let a = std::f32::consts::PI * (0.2 + k as f32 * 0.25);
                let (s, co) = a.sin_cos();
                line((0.5, 0.5), (0.5 + co * 0.3, 0.5 + s * 0.3));
            }
        }
        // 钉住：钉子（头 + 尖）
        Tool::Pin => {
            let head = Rect::from_min_max(pt(0.34, 0.08), pt(0.66, 0.22));
            p.rect_filled(head, 1.0, c);
            line((0.5, 0.22), (0.5, 0.72));
            let tip = vec![pt(0.4, 0.72), pt(0.6, 0.72), pt(0.5, 0.95)];
            p.add(Shape::convex_polygon(tip, c, Stroke::NONE));
        }
        // 绳：一根波浪
        Tool::Rope => {
            let mut prev = pt(0.08, 0.5);
            for i in 1..=10 {
                let t = i as f32 / 10.0;
                let y = 0.5 + (t * std::f32::consts::TAU * 1.5).sin() * 0.18;
                let cur = pt(0.08 + t * 0.84, y);
                p.line_segment([prev, cur], w);
                prev = cur;
            }
        }
        // 铰链：两个圆 + 轴
        Tool::Hinge => {
            p.circle_stroke(pt(0.3, 0.5), r.width() * 0.16, w);
            p.circle_stroke(pt(0.7, 0.5), r.width() * 0.16, w);
            p.circle_filled(pt(0.5, 0.5), r.width() * 0.05, c);
            line((0.46, 0.5), (0.54, 0.5));
        }
        // 活塞：缸体 + 伸出的杆 + 箭头
        Tool::Piston => {
            let body = Rect::from_min_max(pt(0.12, 0.36), pt(0.5, 0.64));
            p.rect_filled(body, 1.5, c);
            line((0.5, 0.5), (0.8, 0.5));
            line((0.68, 0.38), (0.85, 0.5));
            line((0.68, 0.62), (0.85, 0.5));
        }
        // 发射：箭头从底下冲上去
        Tool::Launch => {
            line((0.3, 0.9), (0.7, 0.25));
            line((0.7, 0.25), (0.5, 0.32));
            line((0.7, 0.25), (0.72, 0.48));
            line((0.14, 0.86), (0.34, 0.66));
            line((0.24, 0.94), (0.44, 0.74));
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

/// 物品的小图标：按它的实际形状画一个轮廓。
///
/// 不画贴图，因为物品是数据驱动的（`assets/items.ron`）——加了新物品
/// 不用配图标，形状就是图标。
pub fn item_icon(p: &Painter, r: Rect, def: &anatomize_sim::ItemDef) {
    let c = Color32::from_rgba_unmultiplied(def.color.0, def.color.1, def.color.2, 255);
    let poly = def.shape.polygon();
    if poly.len() < 3 {
        return;
    }
    // 归一化到 r 里，保持长宽比
    let (mut lo, mut hi) = (
        egui::pos2(f32::INFINITY, f32::INFINITY),
        egui::pos2(f32::NEG_INFINITY, f32::NEG_INFINITY),
    );
    for v in &poly {
        lo.x = lo.x.min(v.x);
        lo.y = lo.y.min(v.y);
        hi.x = hi.x.max(v.x);
        hi.y = hi.y.max(v.y);
    }
    let (w, h) = ((hi.x - lo.x).max(1.0), (hi.y - lo.y).max(1.0));
    let scale = (r.width() / w).min(r.height() / h) * 0.86;
    let cx = (lo.x + hi.x) * 0.5;
    let cy = (lo.y + hi.y) * 0.5;
    let pts: Vec<Pos2> = poly
        .iter()
        .map(|v| {
            Pos2::new(
                r.center().x + (v.x - cx) * scale,
                // 物品坐标 y 向上，屏幕 y 向下
                r.center().y - (v.y - cy) * scale,
            )
        })
        .collect();
    p.add(Shape::convex_polygon(
        pts.clone(),
        c,
        Stroke::new(1.0_f32, Color32::from_rgb(24, 22, 28)),
    ));
}
