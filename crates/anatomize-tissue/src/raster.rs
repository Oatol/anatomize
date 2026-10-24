//! 光栅化：把几何变成组织场。
//!
//! 这个模块只认多边形，不认 `BodyPlan`——`anatomize-tissue` 的依赖里不允许出现
//! `anatomize-body`（设计文档 4.1）。适配层在 `anatomize-tools` / `anatomize-sim`。
//!
//! 烘焙顺序（顺序有意义）：
//!
//! 1. 逐部件按 `kind` 填多边形
//! 2. 有骨的部件收缩出**骨芯**，覆盖成 Bone
//! 3. 所有紧贴 `Outside` 的组织 texel 改成 Skin
//!
//! 第 3 步是"涌现的皮肤"：不靠作者画，靠"谁挨着空气谁是皮肤"。这样接缝
//! （躯干与骨盆之间）不会莫名多出一层皮。

use crate::TissueField;
use crate::TissueKind;
use crate::config::TissueConfig;
use anatomize_core::Vec2;

/// 一个待光栅化的凸多边形。
pub struct Shape<'a> {
    pub polygon: &'a [Vec2],
    pub kind: TissueKind,
    /// 是否在这个部件里生成骨芯。
    pub bone_core: bool,
}

/// 点是否在凸多边形内（含边界）。局部实现，避免把 `anatomize-body` 拖进来。
fn point_in_convex(poly: &[Vec2], p: Vec2) -> bool {
    let mut sign = 0.0f32;
    for i in 0..poly.len() {
        let a = poly[i];
        let b = poly[(i + 1) % poly.len()];
        let cross = (b - a).perp_dot(p - a);
        if cross.abs() < 1e-6 {
            continue;
        }
        if sign == 0.0 {
            sign = cross.signum();
        } else if cross.signum() != sign {
            return false;
        }
    }
    true
}

fn centroid(poly: &[Vec2]) -> Vec2 {
    let mut c = Vec2::ZERO;
    for p in poly {
        c += *p;
    }
    c / poly.len() as f32
}

/// 把多边形朝质心收缩 `ratio`（0..1），得到骨芯轮廓。
fn shrink(poly: &[Vec2], ratio: f32) -> Vec<Vec2> {
    let c = centroid(poly);
    poly.iter().map(|p| c + (*p - c) * ratio).collect()
}

/// 按形状列表烘焙一张组织场。`margin_cm` 是包围盒外扩，给皮肤留空间。
pub fn rasterize(shapes: &[Shape], cfg: &TissueConfig, margin_cm: f32) -> TissueField {
    let dx = cfg.texel_cm;

    let mut lo = Vec2::splat(f32::INFINITY);
    let mut hi = Vec2::splat(f32::NEG_INFINITY);
    for s in shapes {
        for p in s.polygon {
            lo = lo.min(*p);
            hi = hi.max(*p);
        }
    }
    lo -= Vec2::splat(margin_cm);
    hi += Vec2::splat(margin_cm);
    // 对齐到 texel 网格，方便反查
    let origin = Vec2::new((lo.x / dx).floor() * dx, (lo.y / dx).floor() * dx);
    let w = (((hi.x - origin.x) / dx).ceil() as u32).max(1);
    let h = (((hi.y - origin.y) / dx).ceil() as u32).max(1);

    let mut f = TissueField::new(w, h, dx, origin);

    for s in shapes {
        // 部件包围盒 → texel 范围
        let mut slo = Vec2::splat(f32::INFINITY);
        let mut shi = Vec2::splat(f32::NEG_INFINITY);
        for p in s.polygon {
            slo = slo.min(*p);
            shi = shi.max(*p);
        }
        let x0 = (((slo.x - origin.x) / dx).floor() as i64).clamp(0, w as i64 - 1) as u32;
        let x1 = (((shi.x - origin.x) / dx).ceil() as i64).clamp(0, w as i64 - 1) as u32;
        let y0 = (((slo.y - origin.y) / dx).floor() as i64).clamp(0, h as i64 - 1) as u32;
        let y1 = (((shi.y - origin.y) / dx).ceil() as i64).clamp(0, h as i64 - 1) as u32;

        for y in y0..=y1 {
            for x in x0..=x1 {
                let c = origin + Vec2::new((x as f32 + 0.5) * dx, (y as f32 + 0.5) * dx);
                if point_in_convex(s.polygon, c) {
                    let i = f.idx(x, y);
                    f.kind[i] = s.kind;
                }
            }
        }
    }

    // 骨芯
    if cfg.bone_core_ratio > 0.0 {
        for s in shapes.iter().filter(|s| s.bone_core) {
            let core = shrink(s.polygon, cfg.bone_core_ratio);
            let mut clo = Vec2::splat(f32::INFINITY);
            let mut chi = Vec2::splat(f32::NEG_INFINITY);
            for p in &core {
                clo = clo.min(*p);
                chi = chi.max(*p);
            }
            let x0 = (((clo.x - origin.x) / dx).floor() as i64).clamp(0, w as i64 - 1) as u32;
            let x1 = (((chi.x - origin.x) / dx).ceil() as i64).clamp(0, w as i64 - 1) as u32;
            let y0 = (((clo.y - origin.y) / dx).floor() as i64).clamp(0, h as i64 - 1) as u32;
            let y1 = (((chi.y - origin.y) / dx).ceil() as i64).clamp(0, h as i64 - 1) as u32;
            for y in y0..=y1 {
                for x in x0..=x1 {
                    let c = origin + Vec2::new((x as f32 + 0.5) * dx, (y as f32 + 0.5) * dx);
                    if point_in_convex(&core, c) {
                        let i = f.idx(x, y);
                        f.kind[i] = TissueKind::Bone;
                    }
                }
            }
        }
    }

    // 涌现的皮肤：贴着空气的那一圈
    let mut skin = Vec::new();
    for i in 0..f.len() {
        if matches!(f.kind[i], TissueKind::Outside | TissueKind::Air) {
            continue;
        }
        let (x, y) = f.xy(i);
        let edge = x == 0
            || y == 0
            || x + 1 >= f.w
            || y + 1 >= f.h
            || f.kind[i + 1] == TissueKind::Outside
            || f.kind[i - 1] == TissueKind::Outside
            || f.kind[i + f.w as usize] == TissueKind::Outside
            || f.kind[i - f.w as usize] == TissueKind::Outside;
        if edge {
            skin.push(i);
        }
    }
    for i in skin {
        f.kind[i] = TissueKind::Skin;
    }

    f.bake_k0(cfg);
    f.fill_temp(cfg.blood_c);
    f.fill_o2(cfg.p_arterial_o2 * 0.42);
    f
}

/// 点到线段的距离。
fn dist_point_segment(p: Vec2, a: Vec2, b: Vec2) -> f32 {
    let ab = b - a;
    let len2 = ab.length_squared();
    if len2 <= 1e-12 {
        return (p - a).length();
    }
    let t = ((p - a).dot(ab) / len2).clamp(0.0, 1.0);
    (p - (a + ab * t)).length()
}

/// 沿一条折线开一条创口带，返回被标记的 texel 数。
///
/// `radius_cm` 是刀具半宽。只有组织 texel 会被标记——已经空掉的地方
/// 再切一刀不该凭空出现一个出血点。
pub fn apply_wound_path(f: &mut TissueField, path: &[Vec2], radius_cm: f32) -> usize {
    if path.len() < 2 {
        return 0;
    }
    let mut n = 0;
    for i in 0..f.len() {
        if f.wound[i] || matches!(f.kind[i], TissueKind::Outside | TissueKind::Air) {
            continue;
        }
        let c = f.center_of(i);
        let mut hit = false;
        for s in 0..path.len() - 1 {
            if dist_point_segment(c, path[s], path[s + 1]) <= radius_cm {
                hit = true;
                break;
            }
        }
        if hit {
            f.wound[i] = true;
            f.pressure[i] = 0.0;
            n += 1;
        }
    }
    n
}

/// 单段创口。
pub fn apply_wound(f: &mut TissueField, a: Vec2, b: Vec2, radius_cm: f32) -> usize {
    apply_wound_path(f, &[a, b], radius_cm)
}

/// 把所有动脉入口 texel 的压力钉到 `map`（M3 的动脉树会用它）。
pub fn set_inlet(f: &mut TissueField, path: &[Vec2], radius_cm: f32) -> usize {
    let mut n = 0;
    for i in 0..f.len() {
        if matches!(f.kind[i], TissueKind::Outside | TissueKind::Air) {
            continue;
        }
        let c = f.center_of(i);
        for s in 0..path.len().saturating_sub(1) {
            if dist_point_segment(c, path[s], path[s + 1]) <= radius_cm {
                f.inlet[i] = true;
                n += 1;
                break;
            }
        }
    }
    n
}

/// 在断口附近的**创口 texel** 上摊一份断端电导（mL/(s·mmHg)）。
///
/// `point` 是血管断口的位置（身体局部 cm），`radius_cm` 是搜索半径。
/// 只有**开放创口** texel 会分到——创口没开到这里就说明这一刀其实没断到血管
/// （正常情况下不会发生，因为 `point` 来自切面与血管折线的交点）。
///
/// 分摊而不是全塞给最近的那一个 texel：一个 texel 只有 0.25 cm²，把主动脉的
/// 全部流量压在它身上会让那个点的压力解算变成单点奇异，`wound_flux` 倒是对的，
/// 但周围组织的压力场会被拽歪。
///
/// 返回分到电导的 texel 数。
pub fn add_stump(f: &mut TissueField, point: Vec2, radius_cm: f32, total_c: f32) -> usize {
    if total_c <= 0.0 {
        return 0;
    }
    let mut hits: Vec<(f32, usize)> = Vec::new();
    for i in 0..f.len() {
        if !f.is_open_wound(i) {
            continue;
        }
        let d = (f.center_of(i) - point).length();
        if d <= radius_cm {
            hits.push((d, i));
        }
    }
    if hits.is_empty() {
        // 兜底：取最近的开放创口 texel。半径给小了也不至于"断了却不流血"。
        let mut best: Option<(f32, usize)> = None;
        for i in 0..f.len() {
            if !f.is_open_wound(i) {
                continue;
            }
            let d = (f.center_of(i) - point).length();
            if best.is_none_or(|(bd, _)| d < bd) {
                best = Some((d, i));
            }
        }
        let Some((_, i)) = best else { return 0 };
        f.stump[i] += total_c;
        return 1;
    }
    let share = total_c / hits.len() as f32;
    for (_, i) in &hits {
        f.stump[*i] += share;
    }
    hits.len()
}

/// 切断一片区域的血供：把落在区域内的组织 texel 的 `k0` 清零。
///
/// `k0` 是血管床的基础电导，清零之后该 texel 的 `bed` / `conductance` /
/// `c_art` / `c_ven` 全为 0（下一 tick 的 `update_conductance` 会一并刷新），
/// 于是它既拿不到动脉血、也排不回静脉，灌注归零，氧只出不进，损伤开始累积。
///
/// `polygons` 一般来自 `BodyPlan::subtree_polygons(断端部件)`。整块清零是最粗
/// 的一档；要区分"断在近端还是远端"用 [`sever_supply_beyond`]。
///
/// 返回受影响的 texel 数。
pub fn sever_supply(f: &mut TissueField, polygons: &[Vec<Vec2>]) -> usize {
    sever_supply_impl(f, polygons, None)
}

/// 切断一片区域里**位于某个半空间内**的血供。
///
/// 比 [`sever_supply`] 精确一档：血管在 `point` 处断开，`distal_dir` 是断口之后
/// 的流向，于是只有 `dot(texel - point, distal_dir) > 0` 的那一半断供。
///
/// 这条区分不是装饰。股动脉在髋部断 → 整条腿坏死；在膝上断 → 只有小腿坏死，
/// 大腿还活着，还流血。设计文档 6.4 说"血管是折线，所以能精确回答断在哪一段"，
/// 这里就是那句话的实际收益。
pub fn sever_supply_beyond(
    f: &mut TissueField,
    polygons: &[Vec<Vec2>],
    point: Vec2,
    distal_dir: Vec2,
) -> usize {
    if distal_dir.length_squared() < 1e-12 {
        return 0;
    }
    sever_supply_impl(f, polygons, Some((point, distal_dir)))
}

fn sever_supply_impl(
    f: &mut TissueField,
    polygons: &[Vec<Vec2>],
    half_space: Option<(Vec2, Vec2)>,
) -> usize {
    if polygons.is_empty() {
        return 0;
    }
    let mut n = 0;
    for i in 0..f.len() {
        if matches!(f.kind[i], TissueKind::Outside | TissueKind::Air) {
            continue;
        }
        // 创口 texel 永远不划进断供区：断端敞在大气里，它接的是**动脉侧**
        // （这就是 `wound_vessel_boost` 的物理含义）。把断端也清成 k0=0，
        // 会得到"腿断了却不流血"——踩过一次，1cm texel 分辨不出 0.3cm 的刀口。
        if f.wound[i] {
            continue;
        }
        let c = f.center_of(i);
        if let Some((point, dir)) = half_space {
            if (c - point).dot(dir) <= 0.0 {
                continue;
            }
        }
        if polygons.iter().any(|poly| point_in_convex(poly, c)) {
            f.k0[i] = 0.0;
            n += 1;
        }
    }
    n
}
