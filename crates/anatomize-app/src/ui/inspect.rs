//! 检视：单独一个窗口看"这一个生物"。
//!
//! # 为什么不在左栏
//!
//! 左栏是**世界的**（造什么、清什么）。生物的身体状况是**某一个对象的**，
//! 而且以后会有很多 ragdoll——把"当前这具"钉在常驻面板上，第二具出现时就崩了。
//!
//! 所以检视是一个独立的、可关闭的窗口：点右栏的「检视」或者按 Tab 打开。
//!
//! # 三个部分
//!
//! 1. **总生命值**：一个 0..1 的数 + 一句话（"失血性休克" / "缺氧" …）
//! 2. **躯体图**：把当前所有块按位姿画成一个小人，颜色 = 那块的状态
//! 3. **器官**：脑 / 心 / 肺 / 肝 / 胃 / 肾，每个一个条
//!
//! 器官在 `BodyPlan` 里没有对应部件（P0 的人体只有 11 块），所以这里用
//! **生理指标反推**：脑看意识和组织氧、心看 MAP 和心输出量、肺看 SaO2……
//! 这是有损的，但它诚实地反映了"这具身体的哪个环节在崩"。

use anatomize_core::PartId;
use egui::{Color32, RichText};

use super::{DIM, FAINT, HOT, INK, OK, PANEL_BG, WARN};
use crate::App;
use crate::view::c32;

pub fn window(ctx: &egui::Context, app: &mut App) {
    if !app.inspect {
        return;
    }
    let mut open = true;
    egui::Window::new("检视")
        .open(&mut open)
        .default_width(340.0)
        .default_pos([360.0, 80.0])
        .resizable(true)
        .frame(
            egui::Frame::NONE
                .fill(c32(PANEL_BG))
                .inner_margin(egui::Margin::same(10)),
        )
        .show(ctx, |ui| {
            creature_tabs(ui, app);
            headline(ui, app);
            ui.separator();
            body_map(ui, app);
            ui.separator();
            organs(ui, app);
            ui.separator();
            detail(ui, app);
        });
    if !open {
        app.inspect = false;
    }
}

/// 顶部：切换看哪一具。
///
/// 只有一具的时候不显示（省地方）；两具以上才出现一排小标签。
fn creature_tabs(ui: &mut egui::Ui, app: &mut App) {
    if app.sim.creatures.len() <= 1 {
        return;
    }
    let mut pick = None;
    ui.horizontal_wrapped(|ui| {
        for i in 0..app.sim.creatures.len() {
            let alive = app.sim.creature_alive(i);
            let label = if alive {
                app.sim.creatures[i].name.clone()
            } else {
                format!("{}（没了）", app.sim.creatures[i].name)
            };
            let mut txt = RichText::new(label).size(11.0);
            if i == app.sim.active {
                txt = txt.strong().color(c32(HOT));
            } else if !alive {
                txt = txt.color(c32(FAINT));
            }
            if ui.selectable_label(i == app.sim.active, txt).clicked() {
                pick = Some(i);
            }
        }
    });
    if let Some(i) = pick {
        app.sim.set_active(i);
    }
    ui.add_space(4.0);
}

/// 总生命值 + 一句话死因。
fn headline(ui: &mut egui::Ui, app: &App) {
    let b = app.sim.creatures[app.sim.active].physio.bus;
    let v = vitality(&b);
    let (word, col) = if v > 0.75 {
        ("状态良好", OK)
    } else if v > 0.45 {
        ("受损", WARN)
    } else if v > 0.15 {
        ("危重", HOT)
    } else {
        ("濒死", HOT)
    };
    ui.horizontal(|ui| {
        ui.label(RichText::new("人偶").size(16.0).strong().color(c32(INK)));
        ui.with_layout(egui::Layout::right_to_left(egui::Align::Center), |ui| {
            ui.label(RichText::new(word).size(12.0).color(c32(col)));
        });
    });

    // 生命值条
    let (rect, _) =
        ui.allocate_exact_size(egui::vec2(ui.available_width(), 16.0), egui::Sense::hover());
    let p = ui.painter();
    p.rect_filled(rect, 3.0, c32([16, 15, 20, 255]));
    let mut fill = rect;
    fill.set_width(rect.width() * v.clamp(0.0, 1.0));
    p.rect_filled(fill, 3.0, c32(col));
    p.text(
        rect.center(),
        egui::Align2::CENTER_CENTER,
        format!("{:.0}%", v * 100.0),
        egui::FontId::proportional(11.0),
        Color32::from_rgb(12, 11, 14),
    );
}

/// 综合生命值：取最差的那个环节，不加权。
///
/// 生理上没有"血压很低但氧很足所以还活着"这回事——任何一环断掉人就倒了。
fn vitality(b: &anatomize_physio::PhysioBus) -> f32 {
    let map = (b.map / 93.0).clamp(0.0, 1.0);
    let o2 = (b.tissue_o2 / 40.0).clamp(0.0, 1.0);
    let vol = (b.blood_volume / 5000.0).clamp(0.0, 1.0);
    let temp = 1.0 - ((b.temp_core - 37.0).abs() / 4.0).clamp(0.0, 1.0);
    let glucose = (b.glucose / 4.0).clamp(0.0, 1.0);
    let consc = b.consciousness.clamp(0.0, 1.0);
    [map, o2, vol, temp, glucose, consc]
        .into_iter()
        .fold(1.0f32, f32::min)
}

/// 躯体图：把每块按当前位姿画出来，颜色表示状态。
fn body_map(ui: &mut egui::Ui, app: &App) {
    let size = egui::vec2(ui.available_width(), 210.0);
    let (rect, _) = ui.allocate_exact_size(size, egui::Sense::hover());
    let p = ui.painter();
    p.rect_filled(rect, 4.0, c32([16, 15, 20, 255]));

    // 世界 → 图内：按世界高度铺满
    let w = app.sim.world;
    let scale = (rect.height() * 0.86 / w.height).min(rect.width() * 0.9 / w.width);
    let cx = rect.center().x;
    let ground = rect.bottom() - 14.0;
    let to_map = |v: anatomize_core::Vec2| egui::pos2(cx + v.x * scale, ground - v.y * scale);

    // 地面
    p.line_segment(
        [
            egui::pos2(rect.left() + 8.0, ground),
            egui::pos2(rect.right() - 8.0, ground),
        ],
        egui::Stroke::new(1.0_f32, c32([60, 57, 70, 255])),
    );

    for i in 0..app.sim.body.pieces.len() {
        let piece = &app.sim.body.pieces[i];
        if piece.deleted {
            continue;
        }
        let id = anatomize_sim::PieceId(i as u32);
        let poly = app.sim.piece_polygon(id);
        if poly.len() < 3 {
            continue;
        }
        let pts: Vec<egui::Pos2> = poly.iter().map(|v| to_map(*v)).collect();
        let col = piece_color(app, i, piece.part);
        p.add(egui::Shape::convex_polygon(pts, col, egui::Stroke::NONE));
    }

    // 图例
    p.text(
        rect.left_top() + egui::vec2(8.0, 6.0),
        egui::Align2::LEFT_TOP,
        "躯体",
        egui::FontId::proportional(10.0),
        c32(FAINT),
    );
}

/// 一块的颜色：身体部件按损伤/断供，道具按物品色。
fn piece_color(app: &App, idx: usize, part: PartId) -> Color32 {
    let piece = &app.sim.body.pieces[idx];
    if part == PartId::NONE {
        let c = app
            .sim
            .item_of(anatomize_sim::PieceId(idx as u32))
            .map(|d| d.rgba())
            .unwrap_or([120, 120, 130, 255]);
        return Color32::from_rgba_unmultiplied(c[0], c[1], c[2], 200);
    }
    // 组织场里这一块的区域平均损伤
    let dmg = app.sim.creatures[app.sim.active]
        .tissue
        .as_ref()
        .map(|t| {
            let offset = app.sim.plan.parts[part.index()].offset;
            let poly: Vec<anatomize_core::Vec2> =
                piece.polygon.iter().map(|v| *v + offset).collect();
            mean_damage_in(&t.field, &poly)
        })
        .unwrap_or(0.0);
    let frozen = piece.is_frozen();
    let base = if frozen {
        [90, 88, 100]
    } else {
        match dmg {
            d if d > 0.6 => [200, 60, 60],
            d if d > 0.3 => [210, 130, 70],
            d if d > 0.08 => [200, 175, 90],
            _ => [170, 60, 60],
        }
    };
    Color32::from_rgba_unmultiplied(base[0], base[1], base[2], 220)
}

fn mean_damage_in(f: &anatomize_tissue::TissueField, poly: &[anatomize_core::Vec2]) -> f32 {
    let mut sum = 0.0;
    let mut n = 0usize;
    for y in 0..f.h {
        for x in 0..f.w {
            let i = (y * f.w + x) as usize;
            if f.kind[i] == anatomize_tissue::TissueKind::Outside {
                continue;
            }
            let p = anatomize_core::Vec2::new(
                f.origin.x + (x as f32 + 0.5) * f.texel_cm,
                f.origin.y + (y as f32 + 0.5) * f.texel_cm,
            );
            let inside = {
                let n = poly.len();
                let mut ok = true;
                for k in 0..n {
                    let a = poly[k];
                    let b = poly[(k + 1) % n];
                    if (b - a).perp_dot(p - a) < 0.0 {
                        ok = false;
                        break;
                    }
                }
                ok
            };
            if inside {
                sum += f.damage[i];
                n += 1;
            }
        }
    }
    if n == 0 { 0.0 } else { sum / n as f32 }
}

/// 器官：从生理指标反推。
fn organs(ui: &mut egui::Ui, app: &App) {
    let b = app.sim.creatures[app.sim.active].physio.bus;
    let items: [(&str, f32, &str); 6] = [
        (
            "脑",
            (b.consciousness.min((b.tissue_o2 / 25.0).clamp(0.0, 1.0))),
            "意识 / 组织氧",
        ),
        (
            "心",
            ((b.map / 93.0).min(b.cardiac_output / 5.0)).clamp(0.0, 1.0),
            "MAP / 心输出量",
        ),
        ("肺", (b.sao2 - 0.6).max(0.0) / 0.37, "血氧饱和度"),
        (
            "肝",
            ((b.glucose / 4.0).min(1.0 - (b.temp_core - 37.0).abs() / 4.0)).clamp(0.0, 1.0),
            "血糖 / 体温",
        ),
        (
            "胃",
            (1.0 - (b.stomach_mmol / 500.0).clamp(0.0, 1.0) * 0.5).clamp(0.0, 1.0),
            "胃内容物",
        ),
        (
            "肾",
            ((b.blood_volume / 5000.0) * (b.map / 93.0)).clamp(0.0, 1.0),
            "血容量 / 灌注压",
        ),
    ];

    ui.label(RichText::new("器官").size(11.0).color(c32(DIM)));
    for (name, v, hint) in items {
        let col = if v > 0.7 {
            OK
        } else if v > 0.35 {
            WARN
        } else {
            HOT
        };
        ui.horizontal(|ui| {
            ui.label(RichText::new(name).size(12.0).color(c32(INK)));
            let (rect, _) = ui.allocate_exact_size(
                egui::vec2(ui.available_width() - 70.0, 10.0),
                egui::Sense::hover(),
            );
            let p = ui.painter();
            p.rect_filled(rect, 2.0, c32([18, 17, 22, 255]));
            let mut fill = rect;
            fill.set_width(rect.width() * v.clamp(0.0, 1.0));
            p.rect_filled(fill, 2.0, c32(col));
            ui.label(
                RichText::new(format!("{:.0}%", v * 100.0))
                    .size(10.0)
                    .color(c32(col)),
            );
        })
        .response
        .on_hover_text(hint);
    }
}

/// 数值细节。
fn detail(ui: &mut egui::Ui, app: &App) {
    let b = app.sim.creatures[app.sim.active].physio.bus;
    egui::Grid::new("detail")
        .num_columns(2)
        .spacing([10.0, 2.0])
        .show(ui, |ui| {
            super::stat_row(ui, "血压", &format!("{:.0} mmHg", b.map), c32(INK));
            super::stat_row(ui, "心率", &format!("{:.0} bpm", b.heart_rate), c32(INK));
            super::stat_row(
                ui,
                "血容量",
                &format!("{:.0} mL", b.blood_volume),
                if b.blood_volume < 3500.0 {
                    c32(HOT)
                } else {
                    c32(INK)
                },
            );
            super::stat_row(ui, "体温", &format!("{:.1} °C", b.temp_core), c32(WARN));
            super::stat_row(ui, "血糖", &format!("{:.1} mmol/L", b.glucose), c32(INK));
            super::stat_row(
                ui,
                "组织氧",
                &format!("{:.0} mmHg", b.tissue_o2),
                if b.tissue_o2 < 15.0 {
                    c32(HOT)
                } else {
                    c32(INK)
                },
            );
            super::stat_row(
                ui,
                "出血",
                &format!("{:.2} mL/s", app.sim.hemorrhage_ml_s()),
                if app.sim.hemorrhage_ml_s() > 1.0 {
                    c32(HOT)
                } else {
                    c32(FAINT)
                },
            );
        });
}
