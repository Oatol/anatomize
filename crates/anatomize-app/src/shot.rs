//! 截图：让 GUI 也能被程序化验证。
//!
//! # 为什么需要这个
//!
//! 窗口版是唯一一个"必须用眼睛看"的产物。但写代码的人（和验证它的模型）
//! 看不到屏幕——只能看日志。没有截图，就等于在盲写 GUI：改了渲染，
//! 不知道画面变成什么样。
//!
//! 所以加一条 `--shot <path>`：跑几十帧、请求一次 viewport 截图、存 PNG、退出。
//! 这样窗口版和离线 demo 一样可以"跑一次、看结果"。
//!
//! ```text
//! anatomize.exe --shot docs/app.png
//! anatomize.exe --shot docs/app-cut.png --after cut
//! ```

use std::fs::File;
use std::io::BufWriter;

/// 截图计划。
pub struct ShotPlan {
    pub path: String,
    /// 还差多少帧就截。
    pub countdown: u32,
    /// 已经发出截图请求。
    pub requested: bool,
    /// 截图前要执行的动作。
    pub action: Option<Action>,
    /// 拍主菜单而不是游戏内。
    pub menu: bool,
    /// 打开检视窗口。
    pub inspect: bool,
    /// 打开灌注热力图。
    pub heat: bool,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Action {
    /// 切一刀（左大腿 + 躯干）
    Cut,
    /// 打开灌注热力图
    Heat,
    /// 喂一顿
    Feed,
    /// 断两条关节
    Sever,
    /// 生成几个道具
    Props,
    /// 生成手雷并引爆
    Boom,
}

impl ShotPlan {
    /// 从命令行参数解析。没有 `--shot` 就返回 `None`。
    pub fn from_args() -> Option<Self> {
        let args: Vec<String> = std::env::args().collect();
        let path = args
            .iter()
            .position(|a| a == "--shot")
            .and_then(|i| args.get(i + 1))
            .cloned()?;
        let action = args
            .iter()
            .position(|a| a == "--after")
            .and_then(|i| args.get(i + 1))
            .and_then(|s| match s.as_str() {
                "cut" => Some(Action::Cut),
                "heat" => Some(Action::Heat),
                "feed" => Some(Action::Feed),
                "sever" => Some(Action::Sever),
                "props" => Some(Action::Props),
                "boom" => Some(Action::Boom),
                _ => None,
            });
        Some(Self {
            path,
            countdown: 90,
            requested: false,
            action,
            menu: args.iter().any(|a| a == "--menu"),
            inspect: args.iter().any(|a| a == "--inspect"),
            heat: args.iter().any(|a| a == "--heat"),
        })
    }
}

/// 把 egui 的 `ColorImage` 写成 PNG。
pub fn save(img: &egui::ColorImage, path: &str) -> Result<(), Box<dyn std::error::Error>> {
    let (w, h) = (img.size[0] as u32, img.size[1] as u32);
    let mut buf: Vec<u8> = Vec::with_capacity((w * h * 4) as usize);
    for p in &img.pixels {
        buf.extend_from_slice(&[p.r(), p.g(), p.b(), p.a()]);
    }
    let file = File::create(path)?;
    let mut enc = png::Encoder::new(BufWriter::new(file), w, h);
    enc.set_color(png::ColorType::Rgba);
    enc.set_depth(png::BitDepth::Eight);
    enc.write_header()?.write_image_data(&buf)?;
    Ok(())
}
