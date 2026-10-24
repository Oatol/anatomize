//! 中文字体：从系统里找一个能用的，塞进 egui。
//!
//! egui 自带的字体没有中日韩字形。不加载的话，界面上的中文全是豆腐块。
//! 字体文件**不进仓库**（雅黑 19 MB + 授权问题），运行时探测系统字体。
//!
//! 找不到就保持英文——画一堆方块比少一种语言更糟。这条和离线验收工具一致。

use std::sync::Arc;

/// 各平台的候选字体。按"字形覆盖 + 好看程度"排序。
const CANDIDATES: &[&str] = &[
    // Windows
    "C:/Windows/Fonts/msyh.ttc",
    "C:/Windows/Fonts/msyhl.ttc",
    "C:/Windows/Fonts/simhei.ttf",
    "C:/Windows/Fonts/simsun.ttc",
    "C:/Windows/Fonts/Deng.ttf",
    // macOS
    "/System/Library/Fonts/PingFang.ttc",
    "/System/Library/Fonts/STHeiti Medium.ttc",
    // Linux
    "/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc",
    "/usr/share/fonts/truetype/wqy/wqy-microhei.ttc",
];

/// 装好字体之后返回用了哪个文件。`None` 表示没找到，界面会退回英文。
pub fn install(ctx: &egui::Context) -> Option<String> {
    // 环境变量优先，方便换字体试效果
    let mut list: Vec<String> = Vec::new();
    if let Ok(p) = std::env::var("ANATOMIZE_FONT") {
        list.push(p);
    }
    list.extend(CANDIDATES.iter().map(|s| s.to_string()));

    for path in list {
        let Ok(bytes) = std::fs::read(&path) else {
            continue;
        };
        if bytes.len() < 1024 {
            continue;
        }
        let mut fonts = egui::FontDefinitions::default();
        fonts.font_data.insert(
            "cjk".to_owned(),
            Arc::new(egui::FontData::from_owned(bytes)),
        );
        // 放在比例字体的**最前面**：中文优先用系统字体，拉丁字符也用它
        // （雅黑的拉丁字形不差，混排不会跳）
        fonts
            .families
            .entry(egui::FontFamily::Proportional)
            .or_default()
            .insert(0, "cjk".to_owned());
        fonts
            .families
            .entry(egui::FontFamily::Monospace)
            .or_default()
            .push("cjk".to_owned());
        ctx.set_fonts(fonts);
        return Some(path);
    }
    None
}
