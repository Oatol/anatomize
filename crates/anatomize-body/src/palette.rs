//! 断面分层色。
//!
//! 放在 body 里而不是渲染器里：宿主和离线验收工具必须画得一样。
//! 之前色板写在 `anatomize-tools::paint` 里，做窗口版时就得复制一份——
//! 两份色板迟早会漂移，那时候截图和窗口里的断面就对不上了。

use crate::Layer;

/// 断面分层色。偏"教科书插图"而不是照片——这是给玩家读结构的，不是吓人的。
pub fn layer_color(l: Layer) -> [u8; 4] {
    match l {
        Layer::Skin => [230, 178, 146, 255],
        Layer::Fat => [240, 214, 136, 255],
        Layer::Muscle => [166, 54, 54, 255],
        Layer::Bone => [238, 232, 212, 255],
        Layer::Organ => [136, 68, 104, 255],
    }
}

pub fn layer_name(l: Layer) -> &'static str {
    match l {
        Layer::Skin => "皮肤",
        Layer::Fat => "脂肪",
        Layer::Muscle => "肌肉",
        Layer::Bone => "骨",
        Layer::Organ => "器官",
    }
}
