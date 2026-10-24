//! 道具：不属于解剖结构的东西。
//!
//! 沙盒不能只有一个人。箱子、球、刀、枪、油桶——玩家需要能造东西、挡东西、砸东西。
//! 这些刚体没有 `PartId`（它们不是身体的一部分），所以 `Piece::part` 用
//! `PartId::NONE` 标记，`Piece::item` 记它在物品目录里的下标。
//!
//! # 为什么复用 `Piece` 而不是另开一套
//!
//! 碎片和道具在物理上没有区别：都是凸多边形刚体，都能被切、被冻结、被拖。
//! 另开一套 `Prop` 意味着渲染、切割、冻结、存档全都要写两遍——而它们本来
//! 就该走同一条路径。唯一的差别是**渲染时没有解剖层**，那一个 `if` 就够了。

use anatomize_core::{PartId, Vec2};
use rapier2d::prelude::*;

use crate::items::{ItemCatalog, ItemDef};
use crate::{CM, Piece, PieceId, RVec2, Sim, rv};

impl Sim {
    /// 在世界里生成一个物品。`at` 是中心（世界米）。
    ///
    /// 超出世界边界会被夹回去——沙盒里"点了一下没反应"比"生成了但看不见"
    /// 更让人困惑。
    pub fn spawn_item(&mut self, def: &ItemDef, at: Vec2) -> PieceId {
        let hw = self.world.half_w();
        let margin = 0.35;
        let at = Vec2::new(
            at.x.clamp(-hw + margin, hw - margin),
            at.y.clamp(0.1, self.world.height - margin),
        );

        let polygon = def.shape.polygon();
        let area_cm2 = anatomize_core::polygon_area(&polygon).abs().max(1.0);

        let rb = RigidBodyBuilder::dynamic()
            .translation(rv(at))
            .linear_damping(0.1)
            .angular_damping(0.4)
            .build();
        let handle = self.physics.bodies.insert(rb);

        let pts: Vec<RVec2> = polygon.iter().map(|v| rv(*v * CM)).collect();
        let collider = ColliderBuilder::convex_hull(&pts)
            .expect("物品形状已经凸包化")
            .density(def.mass / (area_cm2 * CM * CM))
            .friction(0.8)
            .restitution(0.05)
            .build();
        let collider =
            self.physics
                .colliders
                .insert_with_parent(collider, handle, &mut self.physics.bodies);

        // 目录下标：按 id 查，查不到就当没有（说明目录变了）
        let index = self
            .catalog
            .items
            .iter()
            .position(|d| d.id == def.id)
            .map(|i| i as u16);

        let id = PieceId(self.body.pieces.len() as u32);
        self.body.pieces.push(Piece {
            // NONE = 不是解剖结构的一部分
            part: PartId::NONE,
            body: handle,
            collider,
            polygon,
            centroid: Vec2::ZERO,
            mass: def.mass,
            still_s: 0.0,
            frozen_pose: None,
            item: index,
            deleted: false,
        });
        id
    }

    /// 按 id 生成（UI 用）。
    pub fn spawn_item_by_id(&mut self, id: &str, at: Vec2) -> Option<PieceId> {
        let def = self.catalog.get(id)?.clone();
        Some(self.spawn_item(&def, at))
    }

    /// 这块是不是道具（不是身体的一部分）。
    pub fn is_prop(&self, id: PieceId) -> bool {
        self.body.pieces[id.index()].part == PartId::NONE
    }

    /// 这块对应的物品定义。身体部件返回 `None`。
    pub fn item_of(&self, id: PieceId) -> Option<&ItemDef> {
        let idx = self.body.pieces[id.index()].item? as usize;
        self.catalog.items.get(idx)
    }

    /// 这块的显示名（道具查目录，身体部件查 plan）。
    pub fn piece_name(&self, id: PieceId) -> &str {
        let p = &self.body.pieces[id.index()];
        if p.part == PartId::NONE {
            self.item_of(id).map(|d| d.name.as_str()).unwrap_or("道具")
        } else {
            &self.plan.parts[p.part.index()].name
        }
    }

    /// 目录里第一个分类下的第一个物品（测试与默认生成用）。
    pub fn first_item(&self) -> Option<&ItemDef> {
        self.catalog.items.first()
    }

    /// 换一本目录（读档后按 id 重新对齐用）。
    pub fn reload_catalog(&mut self) {
        self.catalog = ItemCatalog::asset();
    }
}
