//! 结构求交：一刀切下去，断了哪根血管。
//!
//! 设计文档 6.4 / 7.3 的核心：血管是**折线**，不是图论里的抽象边。所以
//! "你切断了股动脉的哪一段"是可以精确回答的，而且是纯几何，几十行。
//!
//! # 为什么不用能量阈值
//!
//! "切割能量够大就断血管"会让玩家发现"轻轻划一刀把股动脉划断了"。用折线求交，
//! 切口没碰到血管就是没碰到，玩家能学会"往哪切"。这是本作可玩性的地基。
//!
//! # 两级而不是一级
//!
//! 只有"断/没断"会让擦伤变成不可能。这里分两级：
//!
//! | 判定 | 几何条件 | 后果 |
//! |---|---|---|
//! | `Severed` | 切面**穿过**血管中心线 | 下游断供 + 大出血 |
//! | `Nicked` | 切面擦到血管壁（距离 < 半径），没穿过 | 只出血，下游还通 |
//!
//! 于是"贴着股动脉划一刀"变成一个真实的、有意义的操作：血在流，腿还是好的。
//!
//! # 坐标系
//!
//! 全部在**身体局部厘米**坐标系里算，和 `BodyPlan` 一致。世界米制的切线段要
//! 先用 [`CutSegment::to_body_frame`] 转过来。

use anatomize_body::{BodyPlan, Vessel};
use anatomize_core::{PartId, VesselId, Vec2};

use crate::intersect::{closest_point_on_segment, distance_segment_segment, segment_polyline};
use crate::CutSegment;

/// 一根血管在一次切割里受的伤。
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum VesselDamage {
    /// 切面穿过中心线。血管断开，下游断供。
    Severed,
    /// 刀口擦到血管壁。出血，但血流还通。
    Nicked,
}

impl VesselDamage {
    pub fn name(self) -> &'static str {
        match self {
            VesselDamage::Severed => "severed",
            VesselDamage::Nicked => "nicked",
        }
    }

    /// 这次损伤会不会让下游断供。
    pub fn starves_downstream(self) -> bool {
        self == VesselDamage::Severed
    }
}

/// 一次命中。
#[derive(Debug, Clone)]
pub struct VesselHit {
    pub vessel: VesselId,
    /// 冗余存一份名字：日志和 HUD 都要它，每次回查 `BodyPlan` 太啰嗦。
    pub name: String,
    /// 折线上的第几段（0 起）。
    pub seg: usize,
    /// 沿该段的参数 0..1。合起来就是"断在股动脉的哪一段"。
    pub s: f32,
    /// 命中点，身体局部厘米。
    pub point: Vec2,
    pub damage: VesselDamage,
    pub radius_mm: f32,
    pub arterial: bool,
}

impl VesselHit {
    /// 命中点在整条血管上的归一化位置 0..1。用来写"断在近端 30%"这种描述。
    pub fn along(&self, vessel: &Vessel) -> f32 {
        let total: f32 = vessel
            .path
            .windows(2)
            .map(|w| (w[1] - w[0]).length())
            .sum();
        if total <= 0.0 {
            return 0.0;
        }
        let mut acc = 0.0;
        for i in 0..self.seg.min(vessel.path.len().saturating_sub(1)) {
            acc += (vessel.path[i + 1] - vessel.path[i]).length();
        }
        let seg_len = vessel
            .path
            .get(self.seg + 1)
            .map(|p| (*p - vessel.path[self.seg]).length())
            .unwrap_or(0.0);
        ((acc + seg_len * self.s) / total).clamp(0.0, 1.0)
    }

    /// 血管在命中处的**流向**（单位向量，从心端指向远端）。
    ///
    /// 它定义了"断口的远端半空间"：`dot(p - point, tangent) > 0` 的组织在断口
    /// 下游，会因为这一刀断供。这是"断在近端还是远端"能变成不同后果的关键——
    /// 切股动脉近端整条腿坏死，切远端只有小腿坏死。
    pub fn tangent(&self, vessel: &Vessel) -> Vec2 {
        let n = vessel.path.len();
        if n < 2 {
            return Vec2::new(0.0, -1.0);
        }
        let i = self.seg.min(n - 2);
        (vessel.path[i + 1] - vessel.path[i]).normalize_or_zero()
    }
}

/// 一次切割的结构判定结果。
#[derive(Debug, Clone, Default)]
pub struct StructureReport {
    pub hits: Vec<VesselHit>,
}

impl StructureReport {
    pub fn is_empty(&self) -> bool {
        self.hits.is_empty()
    }

    pub fn severed(&self) -> impl Iterator<Item = &VesselHit> {
        self.hits
            .iter()
            .filter(|h| h.damage == VesselDamage::Severed)
    }

    pub fn nicked(&self) -> impl Iterator<Item = &VesselHit> {
        self.hits
            .iter()
            .filter(|h| h.damage == VesselDamage::Nicked)
    }

    /// 因为这一刀而断供的部件（按子树展开、去重、排序）。
    ///
    /// 只有 `Severed` 的动脉会出现在这里。注意粒度是**部件级**：切断股动脉的
    /// 远端，整条大腿 + 小腿一起断供。这是有意的粗粒度——M3 的组织场还没有
    /// 逐血管床的分区掩码，先让"这条腿死了"这件事成立。
    pub fn starved_parts(&self, plan: &BodyPlan) -> Vec<PartId> {
        let mut out: Vec<PartId> = Vec::new();
        for hit in self.severed() {
            let Some(v) = plan.vessels.iter().find(|v| v.id == hit.vessel) else {
                continue;
            };
            if !v.arterial {
                continue;
            }
            let Some(to) = v.to_part else { continue };
            for p in plan.subtree(to) {
                if !out.contains(&p) {
                    out.push(p);
                }
            }
        }
        out.sort();
        out
    }

    /// 一份给人看的摘要，一行一个命中。
    pub fn summary(&self, plan: &BodyPlan) -> String {
        if self.hits.is_empty() {
            return "  未命中任何血管".to_string();
        }
        let mut s = String::new();
        for h in &self.hits {
            let Some(v) = plan.vessels.iter().find(|v| v.id == h.vessel) else {
                continue;
            };
            s.push_str(&format!(
                "  {:<12} {:<9} 段 {}  s={:.2}  全长 {:.0}%  半径 {:.1}mm  在 ({:.1}, {:.1}) cm\n",
                h.name,
                h.damage.name(),
                h.seg,
                h.s,
                h.along(v) * 100.0,
                h.radius_mm,
                h.point.x,
                h.point.y
            ));
        }
        s
    }
}

/// 判定一次切割对一组血管做了什么。
///
/// `cut` 必须在**身体局部厘米**坐标系里（见 [`CutSegment::to_body_frame`]）。
pub fn cut_vessels(cut: &CutSegment, vessels: &[Vessel]) -> StructureReport {
    let mut hits = Vec::new();
    for v in vessels {
        if v.path.len() < 2 {
            continue;
        }

        // --- 1. 穿过中心线 → 断 ---
        let xs = segment_polyline(cut.a, cut.b, &v.path);
        if let Some(c) = xs.first() {
            hits.push(VesselHit {
                vessel: v.id,
                name: v.name.clone(),
                seg: c.seg,
                s: c.s,
                point: c.point,
                damage: VesselDamage::Severed,
                radius_mm: v.radius_mm,
                arterial: v.arterial,
            });
            continue;
        }

        // --- 2. 擦过血管壁 → 破口 ---
        // 半径在 RON 里是毫米，这里全用厘米。
        let r_cm = v.radius_mm * 0.1;
        if r_cm <= 0.0 {
            continue;
        }
        let mut best = (f32::INFINITY, 0usize, Vec2::ZERO);
        for i in 0..v.path.len() - 1 {
            let (a, b) = (v.path[i], v.path[i + 1]);
            let d = distance_segment_segment(cut.a, cut.b, a, b);
            if d < best.0 {
                // 取血管侧离刀口最近的那个点作为破口位置
                let p_on_vessel = closest_point_on_segment(cut.a, a, b);
                let p_alt = closest_point_on_segment(cut.b, a, b);
                let point = if (p_on_vessel - cut.a).length() <= (p_alt - cut.a).length() {
                    p_on_vessel
                } else {
                    p_alt
                };
                best = (d, i, point);
            }
        }
        if best.0 <= r_cm {
            hits.push(VesselHit {
                vessel: v.id,
                name: v.name.clone(),
                seg: best.1,
                s: 0.0,
                point: best.2,
                damage: VesselDamage::Nicked,
                radius_mm: v.radius_mm,
                arterial: v.arterial,
            });
        }
    }

    StructureReport { hits }
}

#[cfg(test)]
mod tests {
    use super::*;
    use anatomize_body::ASSET_HUMAN_01;

    fn cut(a: (f32, f32), b: (f32, f32)) -> CutSegment {
        CutSegment {
            a: Vec2::new(a.0, a.1),
            b: Vec2::new(b.0, b.1),
            width: 0.2,
            speed: 1.0,
        }
    }

    #[test]
    fn cutting_the_thigh_severs_the_femoral_artery() {
        let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
        // 左大腿 y = -25 横断。股动脉在 x = -8 处垂直经过这一行。
        let r = cut_vessels(&cut((-15.0, -25.0), (-1.0, -25.0)), &plan.vessels);
        println!("{}", r.summary(&plan));

        let names: Vec<&str> = r.severed().map(|h| h.name.as_str()).collect();
        assert_eq!(names, vec!["femoral_l"], "只该切断左股动脉，实际 {names:?}");

        let starved: Vec<&str> = r
            .starved_parts(&plan)
            .iter()
            .map(|id| plan.parts[id.index()].name.as_str())
            .collect();
        assert_eq!(starved, vec!["thigh_l", "shin_l"], "整条左腿该断供");
    }

    #[test]
    fn short_slash_that_stops_short_of_the_artery_hits_nothing() {
        let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
        // 从外侧切进来，停在 x = -11 —— 股动脉在 -8，没够着
        let r = cut_vessels(&cut((-15.0, -25.0), (-11.0, -25.0)), &plan.vessels);
        assert!(r.is_empty(), "刀口没到血管就不该有命中: {:?}", r.hits.len());
    }

    #[test]
    fn grazing_the_wall_nicks_but_does_not_sever() {
        let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
        // 股动脉半径 7mm = 0.7cm，中心线在 x = -8。
        // 刀口停在 x = -8.9（离中心线 0.9cm，在半径外）→ 不该命中
        let far = cut_vessels(&cut((-15.0, -25.0), (-8.9, -25.0)), &plan.vessels);
        assert!(far.is_empty(), "0.9cm 之外不该算擦到");

        // 停在 x = -8.4（离中心线 0.4cm，在 0.7cm 半径内）→ 破口
        let near = cut_vessels(&cut((-15.0, -25.0), (-8.4, -25.0)), &plan.vessels);
        println!("{}", near.summary(&plan));
        assert_eq!(near.hits.len(), 1);
        assert_eq!(near.hits[0].damage, VesselDamage::Nicked);
        assert!(near.starved_parts(&plan).is_empty(), "擦伤不该断供");
    }

    #[test]
    fn cutting_the_arm_severs_the_brachial() {
        let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
        // 左臂：brachial_l 折线是 (0,20)->(-12,24)->(-19,26)->(-19,20)
        let r = cut_vessels(&cut((-26.0, 23.0), (-10.0, 23.0)), &plan.vessels);
        println!("{}", r.summary(&plan));
        let names: Vec<&str> = r.severed().map(|h| h.name.as_str()).collect();
        assert!(names.contains(&"brachial_l"), "该切断左肱动脉，实际 {names:?}");
        assert!(
            !names.contains(&"femoral_l"),
            "上半身的刀不该伤到腿上的动脉"
        );
    }

    #[test]
    fn severed_reports_where_along_the_vessel() {
        let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
        let r = cut_vessels(&cut((-15.0, -25.0), (-1.0, -25.0)), &plan.vessels);
        let h = r.severed().next().unwrap();
        let v = plan.vessel("femoral_l").unwrap();
        let along = h.along(v);
        println!("断在股动脉全长 {:.1}% 处（seg {} s={:.2}）", along * 100.0, h.seg, h.s);
        assert!(along > 0.5, "y=-25 已经过了大腿中段");
        assert!(along < 1.0);
    }
}
