//! 物品行为：爆炸、开火、吃。
//!
//! # 为什么行为在 Rust 里，物品在 RON 里
//!
//! 物品目录（`items.ron`）只声明"我是什么"：形状、质量、`tag`。
//! **行为在这里**——因为行为要碰物理、碰组织场、碰生理，那些是 Rust 的事。
//!
//! 加一个新物品（换个颜色、换个形状）不用碰这个文件；加一种**新行为**
//! 才在这里加一个 `match` 分支。这两件事的节奏不一样，不该混在一起。
//!
//! # 现在有什么
//!
//! | tag | 行为 |
//! |---|---|
//! | `explosive` | 以自己为中心，半径内所有块受到径向冲量；自己消失 |
//! | `gun` | 从枪口沿朝向打一条线，命中身体就切一刀 |
//! | `food` | 直接喂给最近的人（暂时不管"是不是在嘴里"） |
//!
//! 都是**第一版**：爆炸没有火球和破片，开火没有子弹实体，吃东西不分食物种类。
//! 但接口是对的——`use_item` 一个入口，按 tag 分发。

use anatomize_core::Vec2;

use crate::{PieceId, Sim};

/// 用一下某个物品。返回一句给玩家看的话。
pub fn use_item(sim: &mut Sim, id: PieceId) -> Option<String> {
    let def = sim.item_of(id)?.clone();
    let tag = def.tag.as_str();
    match tag {
        "explosive" => {
            let n = sim.detonate(id, 1.6, 140.0);
            Some(format!("{} 炸了（{} 块被掀飞）", def.name, n))
        }
        "gun" => {
            let hit = sim.fire(id, 12.0);
            Some(match hit {
                Some(what) => format!("{} 开火，打中了{}", def.name, what),
                None => format!("{} 开火，打空了", def.name),
            })
        }
        "food" => {
            let mmol = sim.feed(500.0);
            sim.delete_piece(id);
            Some(format!("吃掉{}（{mmol:.0} mmol）", def.name))
        }
        _ => Some(format!("{} 没什么可用的", def.name)),
    }
}

impl Sim {
    /// 爆炸：以这块为中心，半径内的块受径向冲量，自己消失。
    ///
    /// 冲量会让关节超限——这正是我们要的：爆炸不需要"爆炸伤害"这种规则，
    /// 它只需要**把力给对**，剩下的由 M3 的关节磨损自己算。
    pub fn detonate(&mut self, id: PieceId, radius_m: f32, power: f32) -> usize {
        let (center, _) = self.piece_pose(id);
        self.delete_piece(id);

        let mut n = 0;
        for i in 0..self.body.pieces.len() {
            let pid = PieceId(i as u32);
            let p = &self.body.pieces[i];
            if p.deleted || p.is_frozen() {
                continue;
            }
            let (pos, _) = self.piece_pose(pid);
            let d = (pos - center).length();
            if d > radius_m {
                continue;
            }
            let dir = (pos - center).normalize_or_zero();
            // 距离衰减：贴脸的吃满，边缘只吃一点
            let falloff = 1.0 - (d / radius_m).clamp(0.0, 1.0);
            let imp = dir * power * falloff * falloff;
            if self.strike_piece(pid, imp, pos) {
                n += 1;
            }
        }
        n
    }

    /// 开火：从这块的"枪口"沿朝向打一条线，命中身体就切一刀。
    ///
    /// 枪口取多边形在朝向方向上最远的顶点——这样不同形状的枪自动有对的枪口。
    pub fn fire(&mut self, id: PieceId, range_m: f32) -> Option<String> {
        let (pos, rot) = self.piece_pose(id);
        let poly = self.piece_polygon(id);
        if poly.len() < 3 {
            return None;
        }
        let dir = Vec2::new(rot.cos(), rot.sin());
        // 枪口 = 多边形上沿 dir 最远的点
        let muzzle = poly
            .iter()
            .copied()
            .max_by(|a, b| a.dot(dir).total_cmp(&b.dot(dir)))?;
        let from = muzzle;
        let to = muzzle + dir * range_m;

        // 这条线穿过哪些块？取最近的
        let mut best: Option<(usize, f32)> = None;
        for i in 0..self.body.pieces.len() {
            let pid = PieceId(i as u32);
            let p = &self.body.pieces[i];
            if p.deleted || pid == id {
                continue;
            }
            let target = self.piece_polygon(pid);
            if let Some(t) = segment_hits_poly(from, to, &target) {
                if best.is_none_or(|(_, bt)| t < bt) {
                    best = Some((i, t));
                }
            }
        }

        let Some((idx, _)) = best else {
            return None;
        };
        let hit = PieceId(idx as u32);
        let what = self.piece_name(hit).to_string();
        let is_body = self.body.pieces[idx].part != anatomize_core::PartId::NONE;

        // 子弹在身体上切一刀：这就是"枪伤"——和刀用的是同一个 `cut`
        if is_body {
            let seg = anatomize_cut::CutSegment {
                a: from,
                b: to,
                width: 0.004,
                speed: 400.0,
            };
            self.slice(&seg);
            self.cut(&seg);
        } else {
            // 打道具就只给冲量
            let imp = dir * 60.0;
            self.strike_piece(hit, imp, from + dir * 0.2);
        }
        let _ = pos;
        Some(what)
    }
}

/// 线段 × 凸多边形求交，返回最近的参数 t（0..1）。
fn segment_hits_poly(a: Vec2, b: Vec2, poly: &[Vec2]) -> Option<f32> {
    let n = poly.len();
    if n < 3 {
        return None;
    }
    let d = b - a;
    let mut best: Option<f32> = None;
    for i in 0..n {
        let p = poly[i];
        let q = poly[(i + 1) % n];
        let e = q - p;
        let denom = d.perp_dot(e);
        if denom.abs() < 1e-9 {
            continue;
        }
        let t = (p - a).perp_dot(e) / denom;
        let u = (p - a).perp_dot(d) / denom;
        if (0.0..=1.0).contains(&t) && (0.0..=1.0).contains(&u) {
            best = Some(best.map_or(t, |bt: f32| bt.min(t)));
        }
    }
    best
}
