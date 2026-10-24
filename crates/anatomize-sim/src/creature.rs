//! 生物：一具身体 = 一堆块 + 一套生理 + 一张组织场 + 一个姿态控制器。
//!
//! # 为什么"块"不在 `Creature` 里
//!
//! `Sim` 里有两类东西：
//!
//! - **世界的**：`physics`（rapier 世界）、`body.pieces`（所有刚体块）、
//!   `body.joints`（所有解剖关节）、`conns`（玩家连的东西）、`catalog`
//! - **一具生物的**：它的 `primary`（每个部件现在由哪块代表）、
//!   `physio`（0D 生理）、`tissue`（组织场）、`posture`（姿态目标）
//!
//! 块和关节**不放进 `Creature`**，因为物理世界只有一个：两具身体的碎块要
//! 互相碰撞、一把刀要能同时切到两具。所以块是全局的，只挂一个
//! `Piece::creature` 标签说明"我属于谁"。
//!
//! 这个划分不是洁癖，是为了让改动可做：`PieceId` 保持全局唯一，切割、
//! 冻结、删除、拾取、渲染**一行都不用改**——它们本来就只认块。
//! 需要按生物区分的只有生理、组织场、姿态、以及"哪块代表这个部件"。
//!
//! # 为什么不能给 `Sim` 加一个 `fn body(&self) -> &BodyInstance`
//!
//! 加不了。`self.physics` 和 `self.body` 是两个字段，所以能同时
//! `&mut self.physics` + `&self.body`；一旦访问器返回 `&BodyInstance`，
//! 它借的是**整个 `self`**，之后任何 `&mut self.physics` 都会被 borrowck 拒绝。
//! 所以所有访问都写成 `self.creatures[i].field` 这种**字段路径**，
//! 让借用检查器能按字段拆分。

use crate::{Physio, PieceId, Posture, TissueSim};

/// 一具生物。
pub struct Creature {
    /// 名字。HUD / 检视窗口用（"人偶 1"）。
    pub name: String,
    /// 每个 `PartId` 的代表块。切开之后一个部件会变成好几块，
    /// "代表块"是含原质心的那块——骨画在它上面，关节优先挂它。
    pub primary: Vec<PieceId>,
    /// 每个部件的刚体/碰撞体句柄。`strike_part` 按名字找部件时用。
    pub parts: Vec<crate::PartInstance>,
    /// 组织场。`None` = 纯 ragdoll（不出血、不缺氧、不降温）。
    pub tissue: Option<TissueSim>,
    /// 0D 生理。
    pub physio: Physio,
    /// 环境温度（°C）。写进组织场的边界条件。
    pub ambient_c: f32,
    /// 组织场的**基准**代谢产热（K/s）。
    pub(crate) tissue_metab_base: f32,
    /// 姿态控制。`None` = 全软 ragdoll。
    pub posture: Option<Posture>,
}

impl Creature {
    /// 一个空壳（`add_creature` 填内容）。
    pub(crate) fn empty(name: String) -> Self {
        Self {
            name,
            primary: Vec::new(),
            parts: Vec::new(),
            tissue: None,
            physio: Physio::asset(),
            ambient_c: 22.0,
            tissue_metab_base: 0.0,
            posture: None,
        }
    }

    /// 这块是不是这具身体的代表块。
    pub fn is_primary(&self, id: PieceId) -> bool {
        self.primary.contains(&id)
    }
}
