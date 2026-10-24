//! UI：People Playground 式的三段布局。
//!
//! ```text
//! ┌────┬───────────────────────────────┬──────────┐
//! │ 工 │                               │          │
//! │ 具 │          世界（有边界）        │  物品栏   │
//! │ 栏 │                               │  + 属性   │
//! ├────┴───────────────────────────────┴──────────┤
//! │ 时间条：暂停 · 速度 · 回滚 · 保存/读取 · 新建    │
//! └───────────────────────────────────────────────┘
//! ```
//!
//! # 为什么是这个布局
//!
//! People Playground 的界面之所以好用，是因为**手一直在一个地方**：
//! 左边选工具，右边选物品，中间是世界，底部是时间。没有菜单层级，
//! 没有模态对话框（除了新建世界），所有操作都在一到两次点击之内。
//!
//! 我们的版本保留了这套骨架，但把"沙盒"该有的东西补齐了：
//! 世界尺寸可选、能存能读、道具能生成、选中能看属性。
//!
//! # egui 做骨架，关键控件自绘
//!
//! 布局、命中测试、hover、滚动全交给 egui；工具栏的图标和道具卡片自己画
//! （`icons.rs`）。egui 默认的按钮在沙盒里太"网页"，图标按钮才像工具。

use anatomize_body::JointState;
use anatomize_core::{HeatChannel, PartId, Vec2};
use anatomize_sim::{PieceId, PropKind, WorldBounds};
use egui::{Color32, RichText};

use crate::App;
use crate::icons;
use crate::tools::Tool;
use crate::view::c32;

const INK: [u8; 4] = [232, 230, 238, 255];
const DIM: [u8; 4] = [140, 137, 152, 255];
const FAINT: [u8; 4] = [104, 101, 114, 255];
const HOT: [u8; 4] = [232, 92, 92, 255];
const OK: [u8; 4] = [120, 200, 140, 255];
const WARN: [u8; 4] = [240, 190, 110, 255];

/// 新建世界对话框的状态。
#[derive(Default)]
pub struct NewWorldDialog {
    pub open: bool,
    pub width: f32,
    pub height: f32,
}

pub fn layout(ctx: &egui::Context, app: &mut App) {
    timeline(ctx, app);
    toolbar(ctx, app);
    spawn_panel(ctx, app);
    new_world_dialog(ctx, app);
    load_dialog(ctx, app);
}

/// 读取存档的列表。
fn load_dialog(ctx: &egui::Context, app: &mut App) {
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
        return;
    }
    if !open {
        app.load_menu = None;
    }
}

// ---------------------------------------------------------------------------
// 左侧工具栏
// ---------------------------------------------------------------------------

fn toolbar(ctx: &egui::Context, app: &mut App) {
    egui::SidePanel::left("tools")
        .exact_width(60.0)
        .resizable(false)
        .frame(egui::Frame::NONE.fill(c32([24, 23, 30, 255])))
        .show(ctx, |ui| {
            ui.add_space(10.0);
            ui.vertical_centered(|ui| {
                for t in Tool::ALL {
                    if icons::tool_button(ui, t, app.tool == t)
                        .on_hover_text(format!("{}（{}）", t.hint(), key_name(t)))
                        .clicked()
                    {
                        app.tool = t;
                    }
                    ui.add_space(4.0);
                }
            });
        });
}

fn key_name(t: Tool) -> &'static str {
    match t {
        Tool::Select => "Q",
        Tool::Hand => "1",
        Tool::Knife => "2",
        Tool::Hammer => "3",
        Tool::Freeze => "4",
        Tool::Delete => "5",
    }
}

// ---------------------------------------------------------------------------
// 底部时间条
// ---------------------------------------------------------------------------

fn timeline(ctx: &egui::Context, app: &mut App) {
    egui::TopBottomPanel::bottom("timeline")
        .exact_height(46.0)
        .frame(
            egui::Frame::NONE
                .fill(c32([24, 23, 30, 255]))
                .inner_margin(8),
        )
        .show(ctx, |ui| {
            ui.horizontal_centered(|ui| {
                // 暂停 / 继续
                let label = if app.paused { "▶" } else { "⏸" };
                if ui
                    .add(
                        egui::Button::new(RichText::new(label).size(17.0))
                            .min_size(egui::vec2(38.0, 30.0)),
                    )
                    .on_hover_text("空格")
                    .clicked()
                {
                    app.paused = !app.paused;
                }
                ui.add_space(6.0);

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

                ui.separator();

                if ui
                    .button("回滚 3s")
                    .on_hover_text("退回 3 秒前（切错了按这个）")
                    .clicked()
                {
                    match app.sim.rewind(3.0) {
                        Some(back) => app.say(format!("退回 {back:.2} 秒")),
                        None => app.say("缓冲里还没有快照"),
                    }
                }
                ui.label(
                    RichText::new(format!("{:.1}s", app.sim.rewind.span_s()))
                        .size(10.0)
                        .color(c32(FAINT)),
                );

                ui.separator();

                if ui.button("新建世界").clicked() {
                    app.new_world.open = true;
                    app.new_world.width = app.sim.world.width;
                    app.new_world.height = app.sim.world.height;
                }
                if ui.button("保存").clicked() {
                    app.save_world();
                }
                if ui.button("读取").clicked() {
                    app.open_load_menu();
                }

                // 右侧：状态
                ui.with_layout(egui::Layout::right_to_left(egui::Align::Center), |ui| {
                    ui.label(
                        RichText::new(format!(
                            "{:.1}×{:.1} m · {} 块 · {:.0} fps",
                            app.sim.world.width,
                            app.sim.world.height,
                            app.sim.body.pieces.iter().filter(|p| !p.deleted).count(),
                            app.fps
                        ))
                        .size(11.0)
                        .color(c32(FAINT)),
                    );
                });
            });
        });
}

// ---------------------------------------------------------------------------
// 右侧物品栏
// ---------------------------------------------------------------------------

fn spawn_panel(ctx: &egui::Context, app: &mut App) {
    egui::SidePanel::right("spawn")
        .exact_width(232.0)
        .resizable(false)
        .frame(
            egui::Frame::NONE
                .fill(c32([24, 23, 30, 255]))
                .inner_margin(10),
        )
        .show(ctx, |ui| {
            egui::ScrollArea::vertical().show(ui, |ui| {
                ui.label(RichText::new("生成").size(13.0).strong());
                ui.add_space(4.0);
                ui.horizontal_wrapped(|ui| {
                    for k in PropKind::ALL {
                        if prop_card(ui, k, app.prop_hue).clicked() {
                            // 生成在视野中心偏下，落在玩家正在看的地方
                            let at = app.cam.center + Vec2::new(0.0, -0.4);
                            app.sim.spawn_prop(k, at);
                            app.say(format!("生成了{}", k.name()));
                        }
                    }
                });

                if !app.has_cjk {
                    ui.label(
                        RichText::new("没找到中文字体，设 ANATOMIZE_FONT 指定")
                            .size(10.0)
                            .color(c32(HOT)),
                    );
                }

                ui.add_space(10.0);
                ui.separator();
                ui.label(RichText::new("生理").size(13.0).strong());
                vitals(ui, app);

                ui.add_space(8.0);
                ui.separator();
                ui.label(RichText::new("关节").size(13.0).strong());
                joints(ui, app);

                ui.add_space(8.0);
                ui.separator();
                ui.label(RichText::new("环境").size(13.0).strong());
                environment(ui, app);

                ui.add_space(8.0);
                ui.separator();
                ui.label(RichText::new("显示").size(13.0).strong());
                display(ui, app);

                if let Some(sel) = app.selected {
                    ui.add_space(8.0);
                    ui.separator();
                    ui.label(RichText::new("选中").size(13.0).strong());
                    selected_info(ui, app, sel);
                }
            });
        });
}

/// 一张道具卡片：自绘图标 + 名字 + 质量。
fn prop_card(ui: &mut egui::Ui, k: PropKind, _hue: f32) -> egui::Response {
    let (rect, resp) = ui.allocate_exact_size(egui::vec2(100.0, 62.0), egui::Sense::click());
    let p = ui.painter();
    let bg = if resp.hovered() {
        c32([44, 43, 54, 255])
    } else {
        c32([32, 31, 40, 255])
    };
    p.rect_filled(rect, 5.0, bg);
    icons::prop_icon(
        p,
        egui::Rect::from_min_size(rect.min + egui::vec2(6.0, 6.0), egui::vec2(28.0, 28.0)),
        k,
    );
    p.text(
        rect.min + egui::vec2(40.0, 8.0),
        egui::Align2::LEFT_TOP,
        k.name(),
        egui::FontId::proportional(13.0),
        c32(INK),
    );
    p.text(
        rect.min + egui::vec2(40.0, 26.0),
        egui::Align2::LEFT_TOP,
        format!("{:.0} kg", k.mass()),
        egui::FontId::proportional(10.0),
        c32(FAINT),
    );
    resp
}

fn vitals(ui: &mut egui::Ui, app: &mut App) {
    let b = app.sim.physio.bus;
    let map_col = if b.map < 45.0 {
        c32(HOT)
    } else if b.map < 70.0 {
        c32(WARN)
    } else {
        c32(OK)
    };
    egui::Grid::new("vitals")
        .num_columns(2)
        .spacing([8.0, 2.0])
        .show(ui, |ui| {
            row(ui, "血压", &format!("{:.0}", b.map), map_col);
            row(ui, "心率", &format!("{:.0}", b.heart_rate), c32(INK));
            row(
                ui,
                "意识",
                &format!("{:.2}", b.consciousness),
                if b.consciousness < 0.2 {
                    c32(HOT)
                } else {
                    c32(INK)
                },
            );
            row(ui, "体温", &format!("{:.1}", b.temp_core), c32(WARN));
            row(
                ui,
                "血糖",
                &format!("{:.1}", b.glucose),
                c32([200, 160, 240, 255]),
            );
            row(ui, "血量", &format!("{:.0}", b.blood_volume), c32(INK));
            let bleed = app.sim.hemorrhage_ml_s();
            row(
                ui,
                "出血",
                &format!("{bleed:.2}"),
                if bleed > 1.0 { c32(HOT) } else { c32(FAINT) },
            );
        });
}

fn joints(ui: &mut egui::Ui, app: &mut App) {
    let mut counts = [0usize; 5];
    for j in &app.sim.body.joints {
        counts[j.health.state as usize] += 1;
    }
    let names = ["完好", "扭伤", "半脱位", "脱位", "离断"];
    let cols = [
        c32(OK),
        c32([230, 210, 110, 255]),
        c32([240, 160, 80, 255]),
        c32(HOT),
        c32([110, 100, 120, 255]),
    ];
    ui.horizontal_wrapped(|ui| {
        for i in 0..5 {
            if counts[i] == 0 {
                continue;
            }
            ui.label(
                RichText::new(format!("{} {}", names[i], counts[i]))
                    .size(11.0)
                    .color(cols[i]),
            );
        }
    });
    if let Some((i, j)) = app
        .sim
        .body
        .joints
        .iter()
        .enumerate()
        .max_by(|a, b| a.1.health.pain.total_cmp(&b.1.health.pain))
        && j.health.pain > 0.05
    {
        let name = &app.sim.plan.joints[app.sim.body.joints[i].id.index()].name;
        ui.label(
            RichText::new(format!("最疼 {} {:.2}", name, j.health.pain))
                .size(11.0)
                .color(c32([240, 160, 80, 255])),
        );
    }
}

fn environment(ui: &mut egui::Ui, app: &mut App) {
    ui.horizontal(|ui| {
        ui.label(RichText::new("室温").size(11.0).color(c32(DIM)));
        let mut t = app.sim.ambient_c;
        if ui
            .add(
                egui::Slider::new(&mut t, 5.0..=40.0)
                    .suffix("°")
                    .fixed_decimals(0),
            )
            .changed()
        {
            app.sim.set_ambient(t);
        }
    });
    ui.horizontal(|ui| {
        if ui.button("喂食").clicked() {
            let mmol = app.sim.feed(500.0);
            app.say(format!("喂了 500 kcal（{mmol:.0} mmol）"));
        }
        if ui.button("压创口").clicked() {
            let q = app.sim.press_wound(true);
            app.say(format!("压住，出血 {q:.2} mL/s"));
        }
        if ui.button("松开").clicked() {
            let q = app.sim.press_wound(false);
            app.say(format!("松开，出血 {q:.2} mL/s"));
        }
    });
}

fn display(ui: &mut egui::Ui, app: &mut App) {
    ui.horizontal_wrapped(|ui| {
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
    });
    ui.checkbox(
        &mut app.debug,
        RichText::new("血管 + 关节（F1）").size(11.0),
    );
}

fn selected_info(ui: &mut egui::Ui, app: &mut App, sel: PieceId) {
    if sel.index() >= app.sim.body.pieces.len() {
        app.selected = None;
        return;
    }
    // 先把要显示的东西抄出来，再画——否则 `&app.sim` 和 `&mut app` 打架
    let (deleted, frozen, mass, verts, is_prop, part) = {
        let p = &app.sim.body.pieces[sel.index()];
        (
            p.deleted,
            p.is_frozen(),
            p.mass,
            p.polygon.len(),
            p.part == PartId::NONE,
            p.part,
        )
    };
    if deleted {
        app.selected = None;
        return;
    }
    let name = if is_prop {
        app.sim
            .prop_kind(sel)
            .map(|k| k.name().to_string())
            .unwrap_or_else(|| "道具".into())
    } else {
        app.sim.plan.parts[part.index()].name.clone()
    };
    ui.label(RichText::new(name).size(12.0).color(c32(INK)));
    ui.label(
        RichText::new(format!(
            "质量 {:.1} kg · {verts} 顶点 · {}",
            mass,
            if frozen { "已冻结" } else { "活动" }
        ))
        .size(10.0)
        .color(c32(FAINT)),
    );
    ui.horizontal(|ui| {
        if ui.button(if frozen { "解冻" } else { "冻结" }).clicked() {
            app.sim.set_frozen(sel, !frozen);
        }
        if ui.button("删除").clicked() {
            app.sim.delete_piece(sel);
            app.selected = None;
        }
    });
}

fn row(ui: &mut egui::Ui, label: &str, value: &str, col: Color32) {
    ui.label(RichText::new(label).size(11.0).color(c32(DIM)));
    ui.label(RichText::new(value).size(12.0).monospace().color(col));
    ui.end_row();
}

// ---------------------------------------------------------------------------
// 新建世界
// ---------------------------------------------------------------------------

fn new_world_dialog(ctx: &egui::Context, app: &mut App) {
    if !app.new_world.open {
        return;
    }
    let mut open = true;
    egui::Window::new("新建世界")
        .open(&mut open)
        .collapsible(false)
        .resizable(false)
        .anchor(egui::Align2::CENTER_CENTER, [0.0, 0.0])
        .show(ctx, |ui| {
            ui.label(RichText::new("世界大小（米）").size(12.0).color(c32(DIM)));
            ui.add(
                egui::Slider::new(&mut app.new_world.width, 1.5..=16.0)
                    .text("宽")
                    .fixed_decimals(1),
            );
            ui.add(
                egui::Slider::new(&mut app.new_world.height, 1.5..=12.0)
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
                .size(11.0)
                .color(c32(FAINT)),
            );
            ui.add_space(8.0);
            ui.horizontal(|ui| {
                if ui.button("创建").clicked() {
                    app.reset_world(WorldBounds::new(app.new_world.width, app.new_world.height));
                    app.new_world.open = false;
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

/// 屏幕上的叠加：提示条、暂停角标、选中高亮。
pub fn overlay(app: &App, painter: &egui::Painter, view: egui::Rect) {
    if let Some((msg, t)) = &app.toast {
        let alpha = (t / 0.6).clamp(0.0, 1.0);
        let pos = egui::pos2(view.center().x, view.bottom() - 40.0);
        let galley =
            painter.layout_no_wrap(msg.clone(), egui::FontId::proportional(14.0), c32(INK));
        let rect = egui::Align2::CENTER_CENTER.anchor_size(pos, galley.size());
        painter.rect_filled(
            rect.expand2(egui::vec2(12.0, 6.0)),
            6.0,
            c32([26, 25, 32, (alpha * 235.0) as u8]),
        );
        painter.galley(rect.min, galley, c32(INK));
    }

    if app.paused {
        painter.text(
            view.right_top() + egui::vec2(-14.0, 12.0),
            egui::Align2::RIGHT_TOP,
            "已暂停",
            egui::FontId::proportional(13.0),
            c32([240, 190, 110, 220]),
        );
    }

    // 选中高亮
    if let Some(sel) = app.selected
        && sel.index() < app.sim.body.pieces.len()
    {
        let poly = app.sim.piece_polygon(sel);
        if poly.len() >= 3 {
            let mut pts: Vec<egui::Pos2> =
                poly.iter().map(|p| app.cam.to_screen(*p, view)).collect();
            pts.push(pts[0]);
            painter.add(egui::Shape::line(
                pts,
                egui::Stroke::new(1.6_f32, c32([240, 200, 120, 230])),
            ));
        }
    }
}

/// 关节状态名（给属性面板用）。
#[allow(dead_code)]
pub fn joint_state_name(s: JointState) -> &'static str {
    match s {
        JointState::Intact => "完好",
        JointState::Sprained => "扭伤",
        JointState::Subluxed => "半脱位",
        JointState::Dislocated => "脱位",
        JointState::Severed => "离断",
    }
}
