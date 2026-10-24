//! L1 → L2 → L3 的耦合：一刀切下去，谁断了、谁断供了。
//!
//! 设计文档第 7.3 / 10 节的落地。一次切割在这里走完三步：
//!
//! ```text
//! 1. 结构判定（纯几何）  切面折线 × 血管折线 → 断了哪根、断在哪儿
//! 2. 下游断供（L3）      断端部件 → 子树 → 这些 texel 的 k0 = 0
//! 3. 创口写入（L2）      沿切面光栅化创口带 → p = 0，断端电导放大
//! ```
//!
//! 第 1 步在 `anatomize-cut`，第 2、3 步在 `anatomize-tissue`。这个模块只负责
//! 把三者串起来，并保证**坐标系一致**——`BodyPlan` 和血管折线是身体局部厘米，
//! 物理是世界米，转换只在这一层发生一次。
//!
//! 为什么放在 `anatomize-sim`：设计文档 4.1 里 `sim` 是唯一允许同时依赖
//! `cut` + `tissue` + `body` 的 crate。耦合点集中在一处，比散在各处好查。

use anatomize_body::{BodyPlan, BoneKind, Layer};
use anatomize_core::{PartId, Vec2};
use anatomize_cut::{CutSegment, StructureReport, cut_vessels};
use anatomize_tissue::{
    Shape, TissueConfig, TissueField, TissueKind, TissueSim, add_stump, apply_wound_path,
    rasterize, sever_supply_beyond,
};

/// 静息心输出量（mL/s）。5 L/min。
pub const NOMINAL_CARDIAC_OUTPUT_ML_S: f32 = 83.33;

/// 静息平均动脉压（mmHg）。和 `physio.ron` 的 `map_setpoint` 是同一个数。
pub const NOMINAL_MAP: f32 = 93.0;

/// 把 `BodyPlan` 的 `Layer` 映射到组织类型。
pub fn layer_kind(l: Layer) -> TissueKind {
    match l {
        Layer::Skin => TissueKind::Skin,
        Layer::Fat => TissueKind::Fat,
        Layer::Muscle => TissueKind::Muscle,
        Layer::Bone => TissueKind::Bone,
        Layer::Organ => TissueKind::Organ,
    }
}

/// 按 `BodyPlan` 烘焙一张组织场。
///
/// 部件多边形是"局部坐标 + offset"，这里统一转到身体局部坐标系，和血管折线
/// 同一套坐标。光栅化后皮肤是涌现的（谁挨着空气谁是皮肤），不需要作者画。
pub fn build_tissue(plan: &BodyPlan, cfg: &TissueConfig) -> TissueSim {
    // 先算好所有多边形：Shape 借用它们，所以必须活得比 shapes 长
    let polys: Vec<Vec<Vec2>> = plan
        .parts
        .iter()
        .map(|p| p.polygon.iter().map(|v| *v + p.offset).collect())
        .collect();

    let shapes: Vec<Shape> = plan
        .parts
        .iter()
        .zip(&polys)
        .map(|(p, poly)| Shape {
            polygon: poly,
            kind: layer_kind(p.layer),
            bone_core: p.bone != BoneKind::None,
        })
        .collect();

    let field = rasterize(&shapes, cfg, 1.0);
    TissueSim::new(field, cfg.clone())
}

/// 一次切割的完整后果。
#[derive(Debug, Clone)]
pub struct SeverOutcome {
    /// 结构判定：命中了哪些血管、断在哪儿。
    pub report: StructureReport,
    /// 断供的部件（子树展开、去重、按 PartId 排序）。
    pub starved: Vec<PartId>,
    /// 被标记成创口的 texel 数。
    pub wound_texels: usize,
    /// 断供的 texel 数。
    pub starved_texels: usize,
    /// 这一刀给断端摊上的总电导（mL/(s·mmHg)）。
    ///
    /// 它决定了"立刻"出多少血：`q ≈ c_stump · MAP`。几何创口通量只是毛细血管
    /// 那一层，和它并联。
    pub stump_conductance: f32,
}

impl SeverOutcome {
    /// 这一刀有没有造成"永久性"后果（断了血管或开了口子）。
    pub fn is_meaningful(&self) -> bool {
        self.wound_texels > 0 || !self.report.is_empty()
    }

    pub fn starved_names<'a>(&self, plan: &'a BodyPlan) -> Vec<&'a str> {
        self.starved
            .iter()
            .map(|id| plan.parts[id.index()].name.as_str())
            .collect()
    }
}

/// 在身体局部厘米坐标里切一刀，把后果写进组织场。
///
/// `cut` 必须已经是**身体局部厘米**（用 [`CutSegment::to_body_frame`] 转）。
/// 四步顺序是硬约束：
///
/// 1. 结构判定（先知道断了什么、断在哪儿）
/// 2. 开创口（沿切面光栅化，`p = 0`）
/// 3. 断端电导（`c_stump = flow_share·CO/MAP`，摊在断口附近的创口 texel 上）
/// 4. 下游断供（`k0 = 0`，只清断口**远端**那一半，且跳过创口 texel）
///
/// 第 2 步必须在第 4 步之前：`sever_supply` 会跳过 `wound` texel（断端接的是
/// 动脉侧），所以得先把创口标出来，否则整条刀口连断端一起被清零，结果是
/// "腿断了却不流血"。
///
/// 第 4 步只清远端：断口近端的组织还连着心、还灌着血。清整块会丢掉"断在
/// 近端还是远端"这个区别——而那正是折线血管建模的收益所在。
///
/// 注意这个函数**不解压力场**：它只把后果写进场里（`wound` 标志、`k0`、`stump`）。
/// 想立刻知道"流多少血"，得接着调 `TissueSim::warmup(map)` 再读
/// `wound_flux`——不预热直接读，读到的是上一帧的解，数值差两个数量级。
pub fn apply_cut(plan: &BodyPlan, field: &mut TissueField, cut: &CutSegment) -> SeverOutcome {
    apply_cut_scaled(plan, field, cut, NOMINAL_CARDIAC_OUTPUT_ML_S / NOMINAL_MAP)
}

/// 同上，但显式给"每单位 flow_share 对应多少断端电导"（mL/(s·mmHg)）。
///
/// 标定值 `CO_静息/MAP_静息 = 83.33/93 ≈ 0.896`。这样六根动脉全断时总断端
/// 电导对应 `1.0 × CO`——出血速率不可能超过心输出量，这条守恒是白送的。
pub fn apply_cut_scaled(
    plan: &BodyPlan,
    field: &mut TissueField,
    cut: &CutSegment,
    c_per_flow_share: f32,
) -> SeverOutcome {
    let report = cut_vessels(cut, &plan.vessels);

    // 2. 创口：半径取刀具半宽，最少 1 个 texel
    let r_cm = (cut.width * 0.5).max(field.texel_cm * 0.5);
    let wound_texels = apply_wound_path(field, &[cut.a, cut.b], r_cm);

    // 3. 断端电导：每根断掉的动脉，在断口附近摊上它自己的口径
    let mut stump_conductance = 0.0f32;
    for hit in report.severed() {
        let Some(v) = plan.vessels.iter().find(|v| v.id == hit.vessel) else {
            continue;
        };
        if !v.arterial {
            continue;
        }
        let c = v.flow_share.max(0.0) * c_per_flow_share;
        if c <= 0.0 {
            continue;
        }
        // 搜索半径：刀具半宽 + 一个 texel，刚好覆盖断口那一段创口带
        let r = r_cm + field.texel_cm;
        add_stump(field, hit.point, r, c);
        stump_conductance += c;
    }

    // 4. 下游断供：每根断掉的动脉，沿它的流向清掉断口之后的组织
    let mut starved: Vec<PartId> = Vec::new();
    let mut starved_texels = 0;
    for hit in report.severed() {
        let Some(v) = plan.vessels.iter().find(|v| v.id == hit.vessel) else {
            continue;
        };
        if !v.arterial {
            continue;
        }
        let Some(to) = v.to_part else { continue };
        let polys = plan.subtree_polygons(to);
        starved_texels += sever_supply_beyond(field, &polys, hit.point, hit.tangent(v));
        for p in plan.subtree(to) {
            if !starved.contains(&p) {
                starved.push(p);
            }
        }
    }
    starved.sort();

    SeverOutcome {
        report,
        starved,
        wound_texels,
        starved_texels,
        stump_conductance,
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use anatomize_body::ASSET_HUMAN_01;

    const MAP: f32 = 93.0;

    fn thigh_cut(y: f32) -> CutSegment {
        CutSegment {
            a: Vec2::new(-15.0, y),
            b: Vec2::new(-1.0, y),
            width: 0.6,
            speed: 1.0,
        }
    }

    #[test]
    fn severing_the_femoral_artery_starves_only_the_distal_half() {
        let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
        let cfg = TissueConfig::asset();
        let mut sim = build_tissue(&plan, &cfg);
        sim.warmup(MAP);

        let before = region_o2(&sim, Vec2::new(-8.0, -40.0), 5.0);
        assert!(before > 20.0, "正常小腿不该缺氧，实际 {before:.1}");

        let out = apply_cut(&plan, &mut sim.field, &thigh_cut(-25.0));
        println!(
            "命中 {} 处，断供 {} texel，创口 {} texel",
            out.report.hits.len(),
            out.starved_texels,
            out.wound_texels
        );
        println!("{}", out.report.summary(&plan));
        assert_eq!(out.starved_names(&plan), vec!["thigh_l", "shin_l"]);
        assert!(out.wound_texels > 0);

        sim.warmup(MAP);
        let q = sim.wound_flux(MAP);
        println!("断股动脉后出血 {q:.2} mL/s（{:.0} mL/min）", q * 60.0);
        assert!(q > 1.0, "断了股动脉必须大出血，实际 {q:.3} mL/s");

        // 断口远端（小腿）：灌注归零
        let distal = region_perfusion(&sim, Vec2::new(-8.0, -45.0), 4.0);
        println!("断口远端（小腿）灌注 {distal:.6}");
        assert!(distal < 1e-6, "远端必须断供，实际 {distal}");

        // 断口近端（大腿上段）：还连着心，还灌着血
        let proximal = region_perfusion(&sim, Vec2::new(-8.0, -18.0), 4.0);
        println!("断口近端（大腿上段）灌注 {proximal:.6}");
        assert!(proximal > 1e-4, "近端不该断供，实际 {proximal}");

        // 右腿完全不受影响
        let healthy = region_perfusion(&sim, Vec2::new(8.0, -40.0), 4.0);
        assert!(healthy > 1e-4, "右腿不该受影响，实际 {healthy}");
    }

    #[test]
    fn cutting_higher_up_kills_more() {
        // 断在髋部 vs 断在大腿中段：断得越近，坏死的组织越多。
        // （股动脉折线只画到大腿下端 y = -30，再往下就没有可断的段了。）
        let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
        let cfg = TissueConfig::asset();

        let mut near_hip = build_tissue(&plan, &cfg);
        let a = apply_cut(&plan, &mut near_hip.field, &thigh_cut(-18.0));

        let mut mid_thigh = build_tissue(&plan, &cfg);
        let b = apply_cut(&plan, &mut mid_thigh.field, &thigh_cut(-28.0));

        println!(
            "髋部下方断供 {} texel，大腿中段断供 {} texel",
            a.starved_texels, b.starved_texels
        );
        assert!(
            a.starved_texels > b.starved_texels,
            "断得越近，坏死越多：{} 应 > {}",
            a.starved_texels,
            b.starved_texels
        );
    }

    #[test]
    fn nick_bleeds_but_keeps_the_leg_alive() {
        let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
        let cfg = TissueConfig::asset();
        let mut sim = build_tissue(&plan, &cfg);
        sim.warmup(MAP);

        // 刀口停在血管壁里，没穿过中心线
        let cut = CutSegment {
            a: Vec2::new(-15.0, -25.0),
            b: Vec2::new(-8.4, -25.0),
            width: 0.4,
            speed: 1.0,
        };
        let out = apply_cut(&plan, &mut sim.field, &cut);
        println!("{}", out.report.summary(&plan));
        assert!(out.starved.is_empty(), "擦伤不该断供");
        assert!(out.wound_texels > 0, "擦伤还是得出血");

        sim.warmup(MAP);
        let perf = region_perfusion(&sim, Vec2::new(-8.0, -40.0), 5.0);
        assert!(perf > 1e-4, "擦伤后下游还得有灌注，实际 {perf}");
    }

    #[test]
    fn cutting_far_from_any_vessel_only_makes_a_wound() {
        let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
        let cfg = TissueConfig::asset();
        let mut sim = build_tissue(&plan, &cfg);
        sim.warmup(MAP);

        // 右臂外侧的一小道口子，不碰血管
        let cut = CutSegment {
            a: Vec2::new(22.0, 30.0),
            b: Vec2::new(19.0, 28.0),
            width: 0.4,
            speed: 1.0,
        };
        let out = apply_cut(&plan, &mut sim.field, &cut);
        assert!(out.report.is_empty(), "不该命中血管");
        assert!(out.starved.is_empty());
    }

    fn region_o2(sim: &TissueSim, c: Vec2, r: f32) -> f32 {
        let f = &sim.field;
        let (mut s, mut n) = (0.0, 0usize);
        for i in 0..f.len() {
            if !f.kind[i].is_vascular() || (f.center_of(i) - c).length() > r {
                continue;
            }
            s += f.o2[i];
            n += 1;
        }
        if n == 0 { 0.0 } else { s / n as f32 }
    }

    fn region_perfusion(sim: &TissueSim, c: Vec2, r: f32) -> f32 {
        let f = &sim.field;
        let (mut s, mut n) = (0.0, 0usize);
        for i in 0..f.len() {
            if !f.kind[i].is_vascular() || (f.center_of(i) - c).length() > r {
                continue;
            }
            s += f.perfusion[i];
            n += 1;
        }
        if n == 0 { 0.0 } else { s / n as f32 }
    }
}
