//! 右栏：工具栏 + 检视入口。
//!
//! # 为什么分两段
//!
//! 工具从 6 个涨到 12 个，一列排下去已经超过一屏了。分两段不是为了整齐，
//! 是因为它们**动词不一样**：
//!
//! - 上半：**改身体**（选择 / 手 / 刀 / 锤 / 冻结 / 删除）
//! - 下半：**造结构**（焊接 / 钉住 / 绳 / 铰链 / 活塞 / 发射）
//!
//! 玩家脑子里的切换点就是这条线：要么在拆一个人，要么在搭一台机器。
//! 混在一列里会一直点错。
//!
//! 面板本身可滚动（用户要求的），窗口再矮也点得到最下面那个。

use egui::RichText;

use super::{FAINT, PANEL_BG};
use crate::App;
use crate::icons;
use crate::tools::Tool;
use crate::view::c32;

pub fn panel(ctx: &egui::Context, app: &mut App) {
    egui::SidePanel::right("tools")
        .exact_width(62.0)
        .resizable(false)
        .frame(
            egui::Frame::NONE
                .fill(c32(PANEL_BG))
                .inner_margin(egui::Margin::symmetric(6, 8)),
        )
        .show(ctx, |ui| {
            egui::ScrollArea::vertical()
                .auto_shrink([false, false])
                .show(ui, |ui| {
                    ui.vertical_centered(|ui| {
                        let mut last_build = false;
                        for t in Tool::ALL {
                            // 从"改身体"切到"造结构"的地方插一条分隔线
                            if t.is_build() && !last_build {
                                ui.add_space(4.0);
                                ui.separator();
                                ui.add_space(4.0);
                            }
                            last_build = t.is_build();

                            let waiting = t.needs_two() && app.pending.is_some() && app.tool == t;
                            let mut hint = format!("{}\n{}", t.name(), t.hint());
                            if waiting {
                                hint.push_str("\n（已选第一块，再点第二块）");
                            }
                            let resp = icons::tool_button(ui, t, app.tool == t);
                            // 有东西挂着等第二块时，在按钮上打个记号
                            if waiting {
                                ui.painter().circle_filled(
                                    resp.rect.right_top() + egui::vec2(-7.0, 7.0),
                                    3.0,
                                    c32([240, 200, 120, 255]),
                                );
                            }
                            if resp.on_hover_text(hint).clicked() {
                                if app.tool != t {
                                    app.pending = None;
                                }
                                app.tool = t;
                            }
                            ui.add_space(3.0);
                        }

                        ui.add_space(8.0);
                        ui.separator();
                        ui.add_space(8.0);

                        // 检视：单独一个窗口，不占左栏
                        let on = app.inspect;
                        let label = RichText::new("检视").size(10.0).color(if on {
                            c32([240, 200, 120, 255])
                        } else {
                            c32(FAINT)
                        });
                        if ui
                            .add(egui::Button::new(label).min_size(egui::vec2(48.0, 26.0)))
                            .clicked()
                        {
                            app.toggle_inspect();
                        }
                    });
                });
        });
}
