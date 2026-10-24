//! 左栏：分类 · 搜索 · 物品网格 · 底部操作。
//!
//! 布局照抄用户给的那张图：
//!
//! ```text
//! ┌──── 分类 ─────────┐
//! │ [ 搜索栏 ]         │
//! ├───────────────────┤
//! │  物品网格（滚动）    │
//! ├───────────────────┤
//! │ 设置   世界设置     │
//! │ 清除一切 清除生物    │
//! │ 清除碎片           │
//! └───────────────────┘
//! ```

use egui::RichText;

use super::{CARD_BG, CARD_HOVER, DIM, FAINT, INK, PANEL_BG};
use crate::App;
use crate::icons;
use crate::view::c32;

pub fn panel(ctx: &egui::Context, app: &mut App) {
    egui::SidePanel::left("items")
        .exact_width(300.0)
        .resizable(false)
        .frame(
            egui::Frame::NONE
                .fill(c32(PANEL_BG))
                .inner_margin(egui::Margin::same(8)),
        )
        .show(ctx, |ui| {
            categories(ui, app);
            ui.add_space(4.0);
            search(ui, app);
            ui.add_space(4.0);
            ui.separator();
            grid(ui, app);
            ui.separator();
            actions(ui, app);
        });
}

/// 分类 tab。横向滚动——以后分类会变多。
fn categories(ui: &mut egui::Ui, app: &mut App) {
    let cats = app.sim.catalog.categories.clone();
    egui::ScrollArea::horizontal()
        .id_salt("cats")
        .max_height(26.0)
        .show(ui, |ui| {
            ui.horizontal(|ui| {
                for (i, cat) in cats.iter().enumerate() {
                    let sel = app.item_category == i;
                    let n = app.sim.catalog.in_category(&cat.id).count();
                    let txt = RichText::new(format!("{} {n}", cat.name)).size(11.0);
                    if ui.selectable_label(sel, txt).clicked() {
                        app.item_category = i;
                    }
                }
            });
        });
}

fn search(ui: &mut egui::Ui, app: &mut App) {
    ui.horizontal(|ui| {
        ui.label(RichText::new("🔍").size(11.0).color(c32(FAINT)));
        let resp = ui.add(
            egui::TextEdit::singleline(&mut app.search)
                .hint_text(RichText::new("搜索物品").size(11.0))
                .desired_width(f32::INFINITY),
        );
        if resp.changed() {
            // 搜索时不分分类——找东西的时候"它在哪个分类"是干扰
        }
        if !app.search.is_empty() && ui.small_button("×").clicked() {
            app.search.clear();
        }
    });
}

fn grid(ui: &mut egui::Ui, app: &mut App) {
    let q = app.search.trim().to_lowercase();
    let cats = app.sim.catalog.categories.clone();
    let items: Vec<anatomize_sim::ItemDef> = if q.is_empty() {
        let cat = cats
            .get(app.item_category)
            .map(|c| c.id.clone())
            .unwrap_or_default();
        app.sim.catalog.in_category(&cat).cloned().collect()
    } else {
        app.sim
            .catalog
            .items
            .iter()
            .filter(|d| {
                d.name.to_lowercase().contains(&q)
                    || d.id.to_lowercase().contains(&q)
                    || d.desc.to_lowercase().contains(&q)
            })
            .cloned()
            .collect()
    };

    egui::ScrollArea::vertical()
        .id_salt("items")
        .auto_shrink([false, false])
        .max_height(ui.available_height() - 96.0)
        .show(ui, |ui| {
            ui.horizontal_wrapped(|ui| {
                for def in &items {
                    if card(ui, def).clicked() {
                        app.spawn_at_cursor(&def.id);
                    }
                }
            });
            if items.is_empty() {
                ui.label(
                    RichText::new(if q.is_empty() {
                        "这个分类还没有物品"
                    } else {
                        "没找到"
                    })
                    .size(11.0)
                    .color(c32(FAINT)),
                );
            }
        });
}

/// 一张物品卡片：形状图标 + 名字 + 质量。
fn card(ui: &mut egui::Ui, def: &anatomize_sim::ItemDef) -> egui::Response {
    let (rect, resp) = ui.allocate_exact_size(egui::vec2(88.0, 74.0), egui::Sense::click());
    let p = ui.painter();
    p.rect_filled(
        rect,
        5.0,
        c32(if resp.hovered() { CARD_HOVER } else { CARD_BG }),
    );
    icons::item_icon(
        p,
        egui::Rect::from_min_size(rect.min + egui::vec2(26.0, 6.0), egui::vec2(36.0, 36.0)),
        def,
    );
    p.text(
        rect.center_bottom() - egui::vec2(0.0, 24.0),
        egui::Align2::CENTER_CENTER,
        &def.name,
        egui::FontId::proportional(11.0),
        c32(INK),
    );
    p.text(
        rect.center_bottom() - egui::vec2(0.0, 10.0),
        egui::Align2::CENTER_CENTER,
        format!("{:.1}kg", def.mass),
        egui::FontId::proportional(9.0),
        c32(FAINT),
    );
    resp.on_hover_text(format!("{}\n{}", def.name, def.desc))
}

/// 底部操作。
fn actions(ui: &mut egui::Ui, app: &mut App) {
    ui.add_space(4.0);
    ui.horizontal(|ui| {
        if ui.small_button("设置").clicked() {
            app.settings_open = true;
        }
        if ui.small_button("世界设置").clicked() {
            app.new_world.open = true;
            app.new_world.width = app.sim.world.width;
            app.new_world.height = app.sim.world.height;
        }
    });
    ui.horizontal(|ui| {
        if ui.small_button("清除一切").clicked() {
            let w = app.sim.world;
            app.reset_world(w);
            app.say("已清空世界");
        }
        if ui.small_button("清除生物").clicked() {
            let n = app.clear_creatures();
            app.say(format!("清除了 {n} 块身体"));
        }
    });
    ui.horizontal(|ui| {
        if ui.small_button("清除碎片").clicked() {
            let n = app.clear_debris();
            app.say(format!("清除了 {n} 块碎片"));
        }
        ui.label(
            RichText::new(format!(
                "{} 块",
                app.sim.body.pieces.iter().filter(|p| !p.deleted).count()
            ))
            .size(10.0)
            .color(c32(DIM)),
        );
    });
}
