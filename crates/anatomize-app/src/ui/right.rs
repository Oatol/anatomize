//! 右栏：工具栏 + 检视入口。

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
            ui.vertical_centered(|ui| {
                for t in Tool::ALL {
                    if icons::tool_button(ui, t, app.tool == t)
                        .on_hover_text(format!("{}\n{}", t.name(), t.hint()))
                        .clicked()
                    {
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
}
