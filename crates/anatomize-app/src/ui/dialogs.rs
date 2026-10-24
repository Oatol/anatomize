//! 对话框：设置 / 新建世界 / 读取。

use egui::RichText;

use super::{DIM, FAINT, HOT};
use crate::App;
use crate::view::c32;

pub fn all(ctx: &egui::Context, app: &mut App) {
    settings(ctx, app);
    new_world(ctx, app);
    load_menu(ctx, app);
}

fn settings(ctx: &egui::Context, app: &mut App) {
    if !app.settings_open {
        return;
    }
    let mut open = true;
    egui::Window::new("设置")
        .open(&mut open)
        .collapsible(false)
        .resizable(false)
        .anchor(egui::Align2::CENTER_CENTER, [0.0, 0.0])
        .show(ctx, |ui| {
            ui.label(RichText::new("显示").size(12.0).strong());
            ui.checkbox(
                &mut app.debug,
                RichText::new("血管 + 关节（F1）").size(12.0),
            );
            ui.horizontal(|ui| {
                super::heat_buttons(ui, app);
            });
            ui.add_space(8.0);
            ui.label(RichText::new("时间").size(12.0).strong());
            ui.horizontal(|ui| {
                for s in [0.25f32, 0.5, 1.0, 2.0] {
                    let sel = (app.time_scale - s).abs() < 1e-3;
                    let txt = if s == 1.0 {
                        "1x".to_string()
                    } else {
                        format!("{s}x")
                    };
                    if ui.selectable_label(sel, txt).clicked() {
                        app.time_scale = s;
                    }
                }
            });
            ui.add_space(8.0);
            ui.label(RichText::new("界面").size(12.0).strong());
            if app.has_cjk {
                ui.label(RichText::new("中文字形已加载").size(11.0).color(c32(DIM)));
            } else {
                ui.label(
                    RichText::new("没找到中文字体，设 ANATOMIZE_FONT 指定路径")
                        .size(11.0)
                        .color(c32(HOT)),
                );
            }
            ui.add_space(8.0);
            ui.horizontal(|ui| {
                if ui.button("回到主菜单").clicked() {
                    app.screen = super::Screen::MainMenu;
                    app.settings_open = false;
                }
                ui.label(
                    RichText::new(format!(
                        "{:.0} fps · {} 块",
                        app.fps,
                        app.sim.body.pieces.len()
                    ))
                    .size(10.0)
                    .color(c32(FAINT)),
                );
            });
        });
    if !open {
        app.settings_open = false;
    }
}

fn new_world(ctx: &egui::Context, app: &mut App) {
    if !app.new_world.open {
        return;
    }
    let mut open = true;
    egui::Window::new("世界设置")
        .open(&mut open)
        .collapsible(false)
        .resizable(false)
        .anchor(egui::Align2::CENTER_CENTER, [0.0, 0.0])
        .show(ctx, |ui| {
            ui.label(RichText::new("世界大小（米）").size(11.0).color(c32(DIM)));
            ui.add(
                egui::Slider::new(&mut app.new_world.width, 1.5..=20.0)
                    .text("宽")
                    .fixed_decimals(1),
            );
            ui.add(
                egui::Slider::new(&mut app.new_world.height, 1.5..=14.0)
                    .text("高")
                    .fixed_decimals(1),
            );
            ui.label(
                RichText::new(format!(
                    "{} × {} 米 = {:.1} 平方米",
                    app.new_world.width,
                    app.new_world.height,
                    app.new_world.width * app.new_world.height
                ))
                .size(10.0)
                .color(c32(FAINT)),
            );
            ui.add_space(8.0);
            ui.horizontal(|ui| {
                if ui.button("创建").clicked() {
                    let w =
                        anatomize_sim::WorldBounds::new(app.new_world.width, app.new_world.height);
                    app.reset_world(w);
                    app.new_world.open = false;
                    app.screen = super::Screen::InGame;
                }
                if ui.button("取消").clicked() {
                    app.new_world.open = false;
                }
            });
            ui.label(
                RichText::new("创建会清空当前世界。要保留就先保存。")
                    .size(10.0)
                    .color(c32([200, 120, 120, 255])),
            );
        });
    if !open {
        app.new_world.open = false;
    }
}

fn load_menu(ctx: &egui::Context, app: &mut App) {
    let Some(list) = app.load_menu.clone() else {
        return;
    };
    let mut open = true;
    let mut pick: Option<String> = None;
    egui::Window::new("读取世界")
        .open(&mut open)
        .collapsible(false)
        .resizable(false)
        .anchor(egui::Align2::CENTER_CENTER, [0.0, 0.0])
        .show(ctx, |ui| {
            ui.label(RichText::new("saves/").size(11.0).color(c32(DIM)));
            egui::ScrollArea::vertical()
                .max_height(260.0)
                .show(ui, |ui| {
                    for name in &list {
                        if ui.selectable_label(false, name).clicked() {
                            pick = Some(name.clone());
                        }
                    }
                });
        });
    if let Some(name) = pick {
        app.load_world(&name);
        app.load_menu = None;
        app.screen = super::Screen::InGame;
        return;
    }
    if !open {
        app.load_menu = None;
    }
}
