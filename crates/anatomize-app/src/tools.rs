//! 工具：玩家手里拿什么。
//!
//! # 工具清单（对齐 MaD2 的 `Tool.setTool`）
//!
//! MaD2 有二十来个工具（`CUT` / `DRAG` / `DELETE` / `SELECT` / `TRIGGER` /
//! `LINK` / `JOINT` / `PISTON` / `ROPE` / `WELD` / `PIN` / `DOLL` / `DETAIL` /
//! `LAUNCH` / `SWING` / `STAB` / `AIM` / `ROTATE` / `SCALE` / `CAMERA`）。
//! 我们取其中对"解剖 + 造机器"有用的那些，其余的（`DOLL` 生成人偶、
//! `DETAIL` 改细节、`SWING`/`STAB` 近战动画）以后再说。
//!
//! 分两类：
//!
//! **改身体**：选择 / 手 / 刀 / 锤 / 冻结 / 删除
//! **造结构**：焊接 / 钉住 / 绳 / 铰链 / 活塞 / 发射
//!
//! # 为什么"手"要单独一个工具
//!
//! 拖拽是沙盒最基本的动词：把人从地上拎起来、把断掉的腿挪开、把两块碎片叠在一起。
//! 没有它，切开之后你只能看着，不能碰。
//!
//! 拖拽用的是**抓取点上的弹簧力**而不是"把线速度设成朝鼠标"：前者力作用在
//! 偏离质心的点上，会产生力矩——抓着一只手拖，身体会翻转。后者只会平移。
//! 详见 `anatomize_sim::grab`。

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
    /// 焊接：点两块，把它们焊成一个刚体。
    Weld,
    /// 钉住：点一块，把它钉在世界的那个点上。
    Pin,
    /// 绳：点两块，用一根绳连起来。
    Rope,
    /// 铰链：点两块，装一个能自由转的轴。
    Hinge,
    /// 活塞：点两块，装一个能伸缩的直线电机。
    Piston,
    /// 发射：点一块，把它朝鼠标方向甩出去。
    Launch,
}

impl Tool {
    pub const ALL: [Tool; 12] = [
        Tool::Select,
        Tool::Hand,
        Tool::Knife,
        Tool::Hammer,
        Tool::Freeze,
        Tool::Delete,
        Tool::Weld,
        Tool::Pin,
        Tool::Rope,
        Tool::Hinge,
        Tool::Piston,
        Tool::Launch,
    ];

    pub fn name(self) -> &'static str {
        match self {
            Tool::Select => "选择",
            Tool::Hand => "手",
            Tool::Knife => "刀",
            Tool::Hammer => "锤",
            Tool::Freeze => "冻结",
            Tool::Delete => "删除",
            Tool::Weld => "焊接",
            Tool::Pin => "钉住",
            Tool::Rope => "绳",
            Tool::Hinge => "铰链",
            Tool::Piston => "活塞",
            Tool::Launch => "发射",
        }
    }

    pub fn hint(self) -> &'static str {
        match self {
            Tool::Select => "点一下看这块的属性",
            Tool::Hand => "按住拖动搬运 · 拖着时按 F 使用",
            Tool::Knife => "按住拖动划一刀（切到关节会断）",
            Tool::Hammer => "点一下打一下",
            Tool::Freeze => "点一下冻结 / 解冻",
            Tool::Delete => "点一下删除",
            Tool::Weld => "点两块，焊死（刚性连接）",
            Tool::Pin => "点一块，钉在这个点上",
            Tool::Rope => "点两块，拉一根绳",
            Tool::Hinge => "点两块，装一个转轴",
            Tool::Piston => "点两块装活塞；点已有的活塞切换伸出/收回/停",
            Tool::Launch => "点一块，朝鼠标方向甩出去",
        }
    }

    /// 需要点两下吗（钉住只要一下）。
    pub fn needs_two(self) -> bool {
        matches!(self, Tool::Weld | Tool::Rope | Tool::Hinge | Tool::Piston)
    }

    /// 是不是"造结构"这一类（工具栏里分两段显示）。
    pub fn is_build(self) -> bool {
        matches!(
            self,
            Tool::Weld | Tool::Pin | Tool::Rope | Tool::Hinge | Tool::Piston | Tool::Launch
        )
    }

    pub fn key(self) -> egui::Key {
        match self {
            Tool::Select => egui::Key::Q,
            Tool::Hand => egui::Key::Num1,
            Tool::Knife => egui::Key::Num2,
            Tool::Hammer => egui::Key::Num3,
            Tool::Freeze => egui::Key::Num4,
            Tool::Delete => egui::Key::Num5,
            Tool::Weld => egui::Key::Num6,
            Tool::Pin => egui::Key::Num7,
            Tool::Rope => egui::Key::Num8,
            Tool::Hinge => egui::Key::Num9,
            Tool::Piston => egui::Key::Num0,
            Tool::Launch => egui::Key::L,
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

/// 需要点两下的工具，第一次点完之后挂在这里。
///
/// 放 `App` 里而不是 `Drag` 里：它要跨两次点击活下来，而 `Drag` 一松手就没了。
#[derive(Debug, Clone, Copy)]
pub struct Pending {
    pub piece: usize,
    pub at: Vec2,
}
