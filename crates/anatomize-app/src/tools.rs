//! 工具：玩家手里拿什么。
//!
//! # 为什么"手"要单独一个工具
//!
//! 拖拽是沙盒最基本的动词：把人从地上拎起来、把断掉的腿挪开、把两块碎片叠在一起。
//! 没有它，切开之后你只能看着，不能碰。
//!
//! 拖拽用的是**弹簧**而不是"把刚体位置直接设成鼠标位置"：直接设位置会让被拖的
//! 那块穿透别的东西、也不会带动关节。弹簧是给一个朝鼠标的力，物理照常解算——
//! 拎起一条腿的时候整条腿会跟着晃，那才对。

use anatomize_core::Vec2;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Tool {
    /// 选择：点一下看属性，不改变世界。
    Select,
    /// 手：按住拖拽部件。
    Hand,
    /// 刀：按住拖一条线，松开就切。
    Knife,
    /// 锤：点一下打一下。
    Hammer,
    /// 冻结：点一下把那块从物理世界摘掉（或放回去）。
    Freeze,
    /// 删除：点一下把那块移除。
    Delete,
}

impl Tool {
    pub const ALL: [Tool; 6] = [
        Tool::Select,
        Tool::Hand,
        Tool::Knife,
        Tool::Hammer,
        Tool::Freeze,
        Tool::Delete,
    ];

    #[allow(dead_code)]
    pub fn name(self) -> &'static str {
        match self {
            Tool::Select => "选择",
            Tool::Hand => "手",
            Tool::Knife => "刀",
            Tool::Hammer => "锤",
            Tool::Freeze => "冻结",
            Tool::Delete => "删除",
        }
    }

    pub fn hint(self) -> &'static str {
        match self {
            Tool::Select => "点一下看这块的属性",
            Tool::Hand => "按住拖动搬运 · 拖着时按 F 使用",
            Tool::Knife => "按住拖动划一刀",
            Tool::Hammer => "点一下打一下",
            Tool::Freeze => "点一下冻结 / 解冻",
            Tool::Delete => "点一下删除",
        }
    }

    pub fn key(self) -> egui::Key {
        match self {
            Tool::Select => egui::Key::Q,
            Tool::Hand => egui::Key::Num1,
            Tool::Knife => egui::Key::Num2,
            Tool::Hammer => egui::Key::Num3,
            Tool::Freeze => egui::Key::Num4,
            Tool::Delete => egui::Key::Num5,
        }
    }
}

/// 一次拖拽的状态。
#[derive(Debug, Clone)]
pub struct Drag {
    /// 起点（世界米）。
    pub from: Vec2,
    /// 当前点（世界米）。
    pub to: Vec2,
    /// 抓住的块（手工具用）。
    pub grabbed: Option<usize>,
}

impl Drag {
    pub fn new(from: Vec2) -> Self {
        Self {
            from,
            to: from,
            grabbed: None,
        }
    }

    /// 这条线有多长（米）。太短就当成误触，不切。
    pub fn length(&self) -> f32 {
        (self.to - self.from).length()
    }
}
