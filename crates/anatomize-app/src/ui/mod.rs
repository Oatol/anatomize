//! UI 入口：三个界面 + 游戏内的三段布局。
//!
//! # 三个界面
//!
//! ```text
//! 主菜单  ──开始游戏──▶  选世界  ──进入──▶  游戏
//!   ▲                    │                  │
//!   └────────ESC─────────┴──────────────────┘
//! ```
//!
//! # 游戏内的布局
//!
//! ```text
//! ┌──── 分类 tab ─────┬───────────────────────────────────┐
//! │  [ 搜索栏 ]        │                                   │
//! ├───────────────────┤                                   │
//! │  物品网格          │              世界                  │
//! │  ┌──┐┌──┐┌──┐     │                                   │
//! │  └──┘└──┘└──┘     │                          ┌────┐   │
//! │                   │                          │ 工 │   │
//! ├───────────────────┤                          │ 具 │   │
//! │ 设置  世界设置      │                          │ 栏 │   │
//! │ 清除一切 清除生物   │                          └────┘   │
//! │ 清除碎片           │                                   │
//! └───────────────────┴───────────────────────────────────┘
//! ```
//!
//! 生理数据**不在左栏**——以后会有很多 ragdoll，把"这一个的身体状况"钉在
//! 常驻面板上是错的。检视单独开一个窗口（`ui/inspect.rs`）。

pub mod dialogs;
pub mod inspect;
pub mod left;
pub mod right;

use anatomize_core::HeatChannel;
use egui::RichText;

use crate::App;
use crate::view::c32;

// 配色：全局共用，避免每个文件各写一份
pub const INK: [u8; 4] = [232, 230, 238, 255];
pub const DIM: [u8; 4] = [140, 137, 152, 255];
pub const FAINT: [u8; 4] = [104, 101, 114, 255];
pub const HOT: [u8; 4] = [232, 92, 92, 255];
pub const OK: [u8; 4] = [120, 200, 140, 255];
pub const WARN: [u8; 4] = [240, 190, 110, 255];
pub const PANEL_BG: [u8; 4] = [24, 23, 30, 255];
pub const CARD_BG: [u8; 4] = [32, 31, 40, 255];
pub const CARD_HOVER: [u8; 4] = [46, 44, 56, 255];

/// 新建 / 世界设置对话框的状态。
#[derive(Default)]
pub struct NewWorldDialog {
    pub open: bool,
    pub width: f32,
    pub height: f32,
}

/// 现在在哪个界面。
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Screen {
    MainMenu,
    WorldSelect,
    InGame,
}

/// 主入口：按界面分发。
pub fn layout(ctx: &egui::Context, app: &mut App) {
    match app.screen {
        Screen::MainMenu => menu(ctx, app),
        Screen::WorldSelect => world_select(ctx, app),
        Screen::InGame => in_game(ctx, app),
    }
    dialogs::all(ctx, app);
}

// ---------------------------------------------------------------------------
// 主菜单
// ---------------------------------------------------------------------------

fn menu(ctx: &egui::Context, app: &mut App) {
    egui::CentralPanel::default()
        .frame(egui::Frame::NONE.fill(c32([18, 17, 22, 255])))
        .show(ctx, |ui| {
            let h = ui.available_height();
            ui.add_space(h * 0.20);
            ui.vertical_centered(|ui| {
                ui.label(
                    RichText::new("ANATOMIZE")
                        .size(54.0)
                        .strong()
                        .color(c32(INK)),
                );
                ui.add_space(4.0);
                ui.label(
                    RichText::new("2D 解剖沙盒 · 切开一个人，看他还剩什么")
                        .size(14.0)
                        .color(c32(DIM)),
                );
                ui.add_space(38.0);

                if big_button(ui, "开始游戏").clicked() {
                    app.screen = Screen::WorldSelect;
                    app.refresh_world_list();
                }
                ui.add_space(10.0);
                if big_button(ui, "设置").clicked() {
                    app.settings_open = true;
                }
                ui.add_space(10.0);
                if big_button(ui, "退出").clicked() {
                    ctx.send_viewport_cmd(egui::ViewportCommand::Close);
                }
            });

            ui.with_layout(egui::Layout::bottom_up(egui::Align::Center), |ui| {
                ui.add_space(18.0);
                ui.label(
                    RichText::new("v0.1 · MIT OR Apache-2.0")
                        .size(10.0)
                        .color(c32(FAINT)),
                );
            });
        });
}

/// 主菜单那种大按钮：自绘底 + 居中文字。
fn big_button(ui: &mut egui::Ui, label: &str) -> egui::Response {
    let size = egui::vec2(260.0, 46.0);
    let (rect, resp) = ui.allocate_exact_size(size, egui::Sense::click());
    let p = ui.painter();
    let bg = if resp.hovered() {
        c32([58, 40, 44, 255])
    } else {
        c32(CARD_BG)
    };
    p.rect_filled(rect, 6.0, bg);
    p.rect_stroke(
        rect,
        6.0,
        egui::Stroke::new(
            1.0_f32,
            if resp.hovered() {
                c32([200, 90, 90, 255])
            } else {
                c32([58, 56, 70, 255])
            },
        ),
        egui::StrokeKind::Inside,
    );
    p.text(
        rect.center(),
        egui::Align2::CENTER_CENTER,
        label,
        egui::FontId::proportional(19.0),
        if resp.hovered() { c32(INK) } else { c32(DIM) },
    );
    resp
}

// ---------------------------------------------------------------------------
// 选世界
// ---------------------------------------------------------------------------

fn world_select(ctx: &egui::Context, app: &mut App) {
    egui::CentralPanel::default()
        .frame(
            egui::Frame::NONE
                .fill(c32([18, 17, 22, 255]))
                .inner_margin(40),
        )
        .show(ctx, |ui| {
            ui.horizontal(|ui| {
                if ui.button("← 返回").clicked() {
                    app.screen = Screen::MainMenu;
                }
                ui.add_space(12.0);
                ui.label(
                    RichText::new("选择一个世界")
                        .size(24.0)
                        .strong()
                        .color(c32(INK)),
                );
            });
            ui.add_space(16.0);

            egui::ScrollArea::vertical().show(ui, |ui| {
                if world_card(ui, "＋ 新建世界", "选尺寸，从一具完整的人开始", true).clicked()
                {
                    app.new_world.open = true;
                    app.new_world.width = 4.0;
                    app.new_world.height = 3.0;
                }
                ui.add_space(8.0);

                if app.world_list.is_empty() {
                    ui.label(
                        RichText::new("还没有存档。新建一个世界，或者先玩一局再保存。")
                            .size(12.0)
                            .color(c32(FAINT)),
                    );
                }
                for name in app.world_list.clone() {
                    if world_card(ui, &name, "saves/", false).clicked() {
                        app.load_world(&name);
                        app.screen = Screen::InGame;
                    }
                }
            });
        });
}

fn world_card(ui: &mut egui::Ui, title: &str, sub: &str, accent: bool) -> egui::Response {
    let w = ui.available_width().min(560.0);
    let (rect, resp) = ui.allocate_exact_size(egui::vec2(w, 62.0), egui::Sense::click());
    let p = ui.painter();
    let bg = if resp.hovered() {
        c32(CARD_HOVER)
    } else {
        c32(CARD_BG)
    };
    p.rect_filled(rect, 6.0, bg);
    if accent {
        p.rect_stroke(
            rect,
            6.0,
            egui::Stroke::new(1.0_f32, c32([90, 60, 64, 255])),
            egui::StrokeKind::Inside,
        );
    }
    p.text(
        rect.min + egui::vec2(16.0, 12.0),
        egui::Align2::LEFT_TOP,
        title,
        egui::FontId::proportional(16.0),
        if accent {
            c32([240, 200, 200, 255])
        } else {
            c32(INK)
        },
    );
    p.text(
        rect.min + egui::vec2(16.0, 36.0),
        egui::Align2::LEFT_TOP,
        sub,
        egui::FontId::proportional(11.0),
        c32(FAINT),
    );
    resp
}

// ---------------------------------------------------------------------------
// 游戏内
// ---------------------------------------------------------------------------

fn in_game(ctx: &egui::Context, app: &mut App) {
    left::panel(ctx, app);
    right::panel(ctx, app);

    egui::CentralPanel::default()
        .frame(egui::Frame::NONE.fill(c32([18, 17, 22, 255])))
        .show(ctx, |ui| crate::world_view(ui, app));

    inspect::window(ctx, app);
}

// ---------------------------------------------------------------------------
// 公共
// ---------------------------------------------------------------------------

/// 一行"标签 + 数值"，检视面板用。
pub fn stat_row(ui: &mut egui::Ui, label: &str, value: &str, col: egui::Color32) {
    ui.label(RichText::new(label).size(11.0).color(c32(DIM)));
    ui.label(RichText::new(value).size(12.0).monospace().color(col));
    ui.end_row();
}

/// 热力图通道按钮组。
pub fn heat_buttons(ui: &mut egui::Ui, app: &mut App) {
    let mut on = app.heat.is_some();
    if ui
        .checkbox(&mut on, RichText::new("热力图").size(11.0))
        .changed()
    {
        app.heat = if on {
            Some(HeatChannel::Perfusion)
        } else {
            None
        };
    }
    if let Some(cur) = app.heat {
        for ch in HeatChannel::ALL {
            if ui
                .selectable_label(cur == ch, RichText::new(ch.name()).size(10.0))
                .clicked()
            {
                app.heat = Some(ch);
            }
        }
    }
}
