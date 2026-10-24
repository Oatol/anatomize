//! 道具：不属于解剖结构的东西。
//!
//! 沙盒不能只有一个人。箱子、球、板子——玩家需要能造东西、挡东西、砸东西。
//! 这些刚体没有 `PartId`（它们不是身体的一部分），所以 `Piece::part` 用
//! `PartId::NONE` 标记。
//!
//! # 为什么复用 `Piece` 而不是另开一套
//!
//! 碎片和道具在物理上没有区别：都是凸多边形刚体，都能被切、被冻结、被拖。
//! 另开一套 `Prop` 意味着渲染、切割、冻结、存档全都要写两遍——而它们本来
//! 就该走同一条路径。唯一的差别是**渲染时没有解剖层**，那一个 `if` 就够了。

use anatomize_core::{PartId, Vec2};
use rapier2d::prelude::*;

use crate::{CM, Piece, PieceId, RVec2, Sim, rv};

/// 能生成的道具。
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PropKind {
    /// 木箱：1×1 米，轻，好推。
    Crate,
    /// 铁球：半径 0.3 米，重，砸得动关节。
    Ball,
    /// 长板：2×0.15 米，能搭桥也能当刀下垫板。
    Plank,
    /// 水泥块：1.2×1.2 米，非常重，基本不动。
    Block,
}

impl PropKind {
    pub const ALL: [PropKind; 4] = [
        PropKind::Crate,
        PropKind::Ball,
        PropKind::Plank,
        PropKind::Block,
    ];

    pub fn name(self) -> &'static str {
        match self {
            PropKind::Crate => "木箱",
            PropKind::Ball => "铁球",
            PropKind::Plank => "长板",
            PropKind::Block => "水泥块",
        }
    }

    /// 质量（kg）。
    pub fn mass(self) -> f32 {
        match self {
            PropKind::Crate => 12.0,
            PropKind::Ball => 80.0,
            PropKind::Plank => 8.0,
            PropKind::Block => 300.0,
        }
    }

    /// 渲染色。道具没有断面分层，一个颜色到底。
    pub fn color(self) -> [u8; 4] {
        match self {
            PropKind::Crate => [150, 110, 70, 255],
            PropKind::Ball => [140, 145, 155, 255],
            PropKind::Plank => [170, 135, 95, 255],
            PropKind::Block => [120, 120, 125, 255],
        }
    }

    /// 部件局部厘米坐标下的多边形。
    fn polygon(self) -> Vec<Vec2> {
        match self {
            PropKind::Crate => rect(50.0, 50.0),
            PropKind::Ball => circle(30.0, 12),
            PropKind::Plank => rect(100.0, 7.5),
            PropKind::Block => rect(60.0, 60.0),
        }
    }
}

fn rect(hw: f32, hh: f32) -> Vec<Vec2> {
    vec![
        Vec2::new(-hw, -hh),
        Vec2::new(hw, -hh),
        Vec2::new(hw, hh),
        Vec2::new(-hw, hh),
    ]
}

fn circle(r: f32, n: usize) -> Vec<Vec2> {
    (0..n)
        .map(|i| {
            let a = std::f32::consts::TAU * i as f32 / n as f32;
            Vec2::new(a.cos() * r, a.sin() * r)
        })
        .collect()
}

impl Sim {
    /// 在世界里生成一个道具。`at` 是中心（世界米）。
    ///
    /// 返回新块的编号。超出世界边界会被夹回去——沙盒里"点了一下没反应"
    /// 比"生成了但看不见"更让人困惑。
    pub fn spawn_prop(&mut self, kind: PropKind, at: Vec2) -> PieceId {
        let hw = self.world.half_w();
        let margin = 0.35;
        let at = Vec2::new(
            at.x.clamp(-hw + margin, hw - margin),
            at.y.clamp(0.1, self.world.height - margin),
        );

        let polygon = kind.polygon();
        let area_cm2: f32 = {
            let mut a = 0.0;
            for i in 0..polygon.len() {
                a += polygon[i].perp_dot(polygon[(i + 1) % polygon.len()]);
            }
            (a * 0.5).abs()
        };

        let rb = RigidBodyBuilder::dynamic()
            .translation(rv(at))
            .linear_damping(0.1)
            .angular_damping(0.4)
            .build();
        let handle = self.physics.bodies.insert(rb);

        let pts: Vec<RVec2> = polygon.iter().map(|v| rv(*v * CM)).collect();
        let collider = ColliderBuilder::convex_hull(&pts)
            .expect("道具多边形是凸的")
            .density(kind.mass() / (area_cm2 * CM * CM))
            .friction(0.8)
            .restitution(0.05)
            .build();
        let collider =
            self.physics
                .colliders
                .insert_with_parent(collider, handle, &mut self.physics.bodies);

        let id = PieceId(self.body.pieces.len() as u32);
        self.body.pieces.push(Piece {
            // NONE = 不是解剖结构的一部分
            part: PartId::NONE,
            body: handle,
            collider,
            polygon,
            centroid: Vec2::ZERO,
            mass: kind.mass(),
            still_s: 0.0,
            frozen_pose: None,
            deleted: false,
        });
        id
    }

    /// 这块是不是道具（不是身体的一部分）。
    pub fn is_prop(&self, id: PieceId) -> bool {
        self.body.pieces[id.index()].part == PartId::NONE
    }

    /// 道具种类（按多边形顶点数和质量反推）。渲染用。
    ///
    /// 反推而不是存字段，是因为 `Piece` 是切割/物理的核心类型，
    /// 加一个只给渲染用的字段会让它变脏。四个道具的形状差别够大。
    pub fn prop_kind(&self, id: PieceId) -> Option<PropKind> {
        let p = &self.body.pieces[id.index()];
        if p.part != PartId::NONE {
            return None;
        }
        Some(if p.polygon.len() > 6 {
            PropKind::Ball
        } else if p.mass > 200.0 {
            PropKind::Block
        } else if p.mass < 10.0 {
            PropKind::Plank
        } else {
            PropKind::Crate
        })
    }
}
