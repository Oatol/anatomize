//! 断面分层：切开一块肉，看见的是皮肤 / 脂肪 / 肌肉 / 骨。
//!
//! # 为什么不手绘断面
//!
//! 手绘断面和 `BodyPlan` 迟早会对不上——改了多边形、改了骨骼类型，贴图还是老的。
//! 这里从**同一份多边形**现场算：给一个像素，问"它在原部件轮廓里有多深"，
//! 深度映射到层。
//!
//! ```text
//! depth = 到部件边界的最近距离（凸多边形，O(边数)）
//!
//! 0 ────────── skin ────── fat ──────────── muscle ────────── bone ──┐
//!                                                                     │
//!                                                              max_depth
//! ```
//!
//! 于是**沿刀线采样**天然得到 `皮肤→脂肪→肌肉→骨→肌肉→脂肪→皮肤`：
//! 刀从一侧进、穿过中心、从另一侧出，深度就是先增后减。这不是特判出来的，
//! 是几何的必然。
//!
//! # 一个容易踩的坑
//!
//! 深度必须相对**原部件**轮廓算，不能相对碎片轮廓。切完之后的碎片多边形包含了
//! 新切出来的边，用碎片轮廓算的话，新切边上会再长出一圈皮肤——那看起来像
//! 每条切边都包了层皮。
//!
//! 碎片自己的局部坐标和原部件是同一套（切割不改坐标系），所以只要把原多边形
//! 一起传进来就行。

use anatomize_body::{BoneKind, Layer};
use anatomize_core::Vec2;

/// 一个部件在断面上暴露出来的层带规格（厘米）。
///
/// 三个厚度是**从几何推出来的**，不是每个部件手填的：
/// 大部件（躯干）皮肤 2.5mm、脂肪 1.6cm；小部件（前臂）皮肤 2mm、脂肪 5mm。
/// 骨半径按 `BoneKind` 查表——这是唯一需要解剖知识的地方，也是唯一该写死的地方。
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct SectionProfile {
    /// 皮肤层厚度（cm）。真皮+表皮约 2mm，这里稍厚一点，否则在 1080p 下看不见。
    pub skin_cm: f32,
    /// 皮下脂肪厚度（cm）。
    pub fat_cm: f32,
    /// 骨的等效半径（cm）。0 表示这块部件里没有骨（纯软组织）。
    pub bone_cm: f32,
    /// 最深处到边界的距离（cm）。等于内切圆半径。
    pub max_depth_cm: f32,
}

/// 各骨骼的等效半径（cm）。真实骨干半径的 1.5~2 倍——
/// 2D 侧视看到的是整根骨的投影，不是横截面，视觉上本来就粗一圈。
fn bone_radius(kind: BoneKind) -> f32 {
    match kind {
        BoneKind::Skull => 6.5,
        BoneKind::Spine => 1.8,
        BoneKind::Rib => 0.9,
        BoneKind::Pelvis => 5.5,
        BoneKind::Humerus => 1.2,
        BoneKind::Radius => 0.8,
        BoneKind::Femur => 1.5,
        BoneKind::Tibia => 1.1,
        BoneKind::None => 0.0,
    }
}

impl SectionProfile {
    /// 从部件的凸多边形与骨骼类型推出一套层带规格。
    pub fn for_part(bone: BoneKind, poly: &[Vec2]) -> Self {
        let max_depth_cm = max_depth(poly);

        // 皮肤：固定 0.22cm，但不超过最深处的一半（前臂这种细部件不能全是皮）
        let skin_cm = 0.22f32.min(max_depth_cm * 0.35);

        // 脂肪：按部件尺度走。躯干 max_depth ≈ 15cm → 1.6cm；
        // 前臂 ≈ 3.5cm → 0.5cm。真实的皮下脂肪就是这么分布的。
        let fat_cm = (max_depth_cm * 0.20).clamp(0.35, 1.6);

        // 骨：查表，但要给肌肉留够地方。
        // 骨半径 + 皮肤 + 脂肪 不能超过 max_depth - 0.8（至少 8mm 肌肉）
        let room = (max_depth_cm - skin_cm - fat_cm - 0.8).max(0.0);
        let bone_cm = bone_radius(bone).min(room);

        Self {
            skin_cm,
            fat_cm,
            bone_cm,
            max_depth_cm,
        }
    }

    /// 深度 → 层。`depth` 是到边界的距离（cm），0 在皮肤表面。
    pub fn layer_at(&self, depth_cm: f32) -> Layer {
        if depth_cm <= self.skin_cm {
            return Layer::Skin;
        }
        if depth_cm <= self.skin_cm + self.fat_cm {
            return Layer::Fat;
        }
        if self.bone_cm > 0.0 && depth_cm >= self.max_depth_cm - self.bone_cm {
            return Layer::Bone;
        }
        Layer::Muscle
    }

    /// 这条剖面一共多厚（cm）。等于内切圆半径。
    pub fn thickness_cm(&self) -> f32 {
        self.max_depth_cm
    }

    /// 各层占整条剖面的比例。HUD 与验收都用它。
    pub fn band_shares(&self) -> [(Layer, f32); 4] {
        let d = self.max_depth_cm.max(1e-6);
        let skin = self.skin_cm;
        let fat = self.fat_cm.min(d - skin).max(0.0);
        let bone = self.bone_cm.min(d - skin - fat).max(0.0);
        let muscle = (d - skin - fat - bone).max(0.0);
        [
            (Layer::Skin, skin / d),
            (Layer::Fat, fat / d),
            (Layer::Muscle, muscle / d),
            (Layer::Bone, bone / d),
        ]
    }
}

/// 点到凸多边形边界的最近距离（内部为正，外部为负）。
///
/// 凸多边形的符号：所有边的 `cross(edge, p - a)` 同号即为内部。逆时针多边形
/// 内部是左侧，`cross > 0`。
pub fn signed_depth(poly: &[Vec2], p: Vec2) -> f32 {
    let n = poly.len();
    if n < 3 {
        return -1.0;
    }
    let mut min_d = f32::INFINITY;
    let mut inside = true;
    for i in 0..n {
        let a = poly[i];
        let b = poly[(i + 1) % n];
        let e = b - a;
        let cross = e.perp_dot(p - a);
        if cross < 0.0 {
            inside = false;
        }
        let len = e.length();
        if len > 1e-9 {
            // 取绝对值：外部点会有一条边给出负的 cross，直接参与 min 会
            // 把"最近边"算成"最远边"，符号也跟着翻。
            min_d = min_d.min(cross.abs() / len);
        }
    }
    if inside { min_d } else { -min_d }
}

/// 内切圆半径的估计：重心到最近边的距离。
///
/// 凸多边形的重心一定在内部，所以这是一个下界；对接近正多边形的部件误差 < 5%，
/// 对细长部件（前臂 7×24cm）重心到长边的距离正好是半径，也准。
pub fn max_depth(poly: &[Vec2]) -> f32 {
    if poly.len() < 3 {
        return 0.0;
    }
    let c = crate::split::centroid(poly);
    signed_depth(poly, c).max(0.0)
}

/// 沿一条线段采样，返回每一站的层。
///
/// 用于验收与调试：切大腿时这条序列必须是从皮肤进、到骨、再从皮肤出。
/// `n` 是采样点数，至少 2。
pub fn scan_layers(
    poly: &[Vec2],
    profile: &SectionProfile,
    a: Vec2,
    b: Vec2,
    n: usize,
) -> Vec<(f32, Layer)> {
    let n = n.max(2);
    let mut out = Vec::with_capacity(n);
    for i in 0..n {
        let t = i as f32 / (n - 1) as f32;
        let p = a + (b - a) * t;
        let d = signed_depth(poly, p);
        out.push((d, profile.layer_at(d.max(0.0))));
    }
    out
}

/// 一条剖面上每一层累计的厚度（cm），按沿线段的实际长度算。
///
/// 和 [`SectionProfile::band_shares`] 的区别：那个是"沿半径的理论比例"，
/// 这个是"沿你实际切的这一刀量出来的厚度"。验收标准 6 用后者。
#[derive(Debug, Clone, PartialEq)]
pub struct Band {
    pub layer: Layer,
    /// 这一段占整条剖面的长度（cm）。
    pub cm: f32,
    /// 占整条剖面的比例。
    pub share: f32,
}

/// 量一条剖面的层带分布。`steps` 是采样数，256 足够。
pub fn measure_bands(
    poly: &[Vec2],
    profile: &SectionProfile,
    a: Vec2,
    b: Vec2,
    steps: usize,
) -> Vec<Band> {
    let steps = steps.max(8);
    let total = (b - a).length();
    if total < 1e-6 {
        return Vec::new();
    }
    let seg = total / steps as f32;

    // 按层累加，保持 Skin→Fat→Muscle→Bone 的固定顺序
    let mut acc = [0.0f32; 4];
    let idx = |l: Layer| match l {
        Layer::Skin => 0,
        Layer::Fat => 1,
        Layer::Muscle | Layer::Organ => 2,
        Layer::Bone => 3,
    };
    for i in 0..steps {
        let t = (i as f32 + 0.5) / steps as f32;
        let p = a + (b - a) * t;
        let d = signed_depth(poly, p).max(0.0);
        acc[idx(profile.layer_at(d))] += seg;
    }

    let order = [Layer::Skin, Layer::Fat, Layer::Muscle, Layer::Bone];
    order
        .iter()
        .zip(acc)
        .filter(|(_, cm)| *cm > 0.0)
        .map(|(layer, cm)| Band {
            layer: *layer,
            cm,
            share: cm / total,
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    /// 大腿：11 × 26 cm 的矩形，股骨。
    fn thigh() -> Vec<Vec2> {
        vec![
            Vec2::new(-5.5, -13.0),
            Vec2::new(5.5, -13.0),
            Vec2::new(5.5, 13.0),
            Vec2::new(-5.5, 13.0),
        ]
    }

    #[test]
    fn depth_is_zero_on_the_boundary_and_max_at_the_centre() {
        let p = thigh();
        let d0 = signed_depth(&p, Vec2::new(-5.5, 0.0));
        assert!(d0.abs() < 1e-4, "边界上深度应为 0，实际 {d0}");

        let dc = signed_depth(&p, Vec2::ZERO);
        assert!((dc - 5.5).abs() < 1e-4, "中心深度应为半宽 5.5，实际 {dc}");

        let out = signed_depth(&p, Vec2::new(10.0, 0.0));
        assert!(out < 0.0, "外部深度应为负，实际 {out}");
    }

    #[test]
    fn a_thigh_profile_has_four_layers_in_the_right_order() {
        let p = thigh();
        let prof = SectionProfile::for_part(BoneKind::Femur, &p);
        println!(
            "大腿剖面：皮肤 {:.2} 脂肪 {:.2} 骨 {:.2}，总深 {:.2} cm",
            prof.skin_cm, prof.fat_cm, prof.bone_cm, prof.max_depth_cm
        );

        // 沿水平方向横穿大腿中心
        let bands = measure_bands(&p, &prof, Vec2::new(-5.5, 0.0), Vec2::new(5.5, 0.0), 512);
        let names: Vec<&str> = bands
            .iter()
            .map(|b| match b.layer {
                Layer::Skin => "皮肤",
                Layer::Fat => "脂肪",
                Layer::Muscle => "肌肉",
                Layer::Bone => "骨",
                Layer::Organ => "器官",
            })
            .collect();
        println!("层带顺序：{names:?}");
        for b in &bands {
            println!(
                "  {:<4} {:.2} cm  {:.1}%",
                format!("{:?}", b.layer),
                b.cm,
                b.share * 100.0
            );
        }

        assert_eq!(bands.len(), 4, "必须有 4 层");
        assert_eq!(bands[0].layer, Layer::Skin);
        assert_eq!(bands[1].layer, Layer::Fat);
        assert_eq!(bands[2].layer, Layer::Muscle);
        assert_eq!(bands[3].layer, Layer::Bone);

        // 皮肤两边加起来约 0.44cm（占 11cm 的 4%），脂肪约 2.4cm，骨约 3cm
        assert!(
            bands[0].share > 0.02 && bands[0].share < 0.10,
            "皮肤比例 {}",
            bands[0].share
        );
        assert!(
            bands[1].share > 0.10 && bands[1].share < 0.35,
            "脂肪比例 {}",
            bands[1].share
        );
        assert!(
            bands[3].share > 0.15 && bands[3].share < 0.45,
            "骨比例 {}",
            bands[3].share
        );
        assert!(
            bands[2].share > 0.25,
            "肌肉应该最多，实际 {}",
            bands[2].share
        );
    }

    #[test]
    fn scanning_from_one_side_to_the_other_is_symmetric() {
        let p = thigh();
        let prof = SectionProfile::for_part(BoneKind::Femur, &p);
        let scan = scan_layers(&p, &prof, Vec2::new(-5.5, 0.0), Vec2::new(5.5, 0.0), 101);

        assert_eq!(scan[0].1, Layer::Skin);
        assert_eq!(scan[100].1, Layer::Skin);
        assert_eq!(scan[50].1, Layer::Bone, "中心必须是骨");

        // 关于中点对称
        for i in 0..=50 {
            assert_eq!(scan[i].1, scan[100 - i].1, "第 {i} 站不对称");
        }
    }

    #[test]
    fn a_thin_limb_still_gets_a_bone_instead_of_all_skin() {
        // 前臂 7 × 24cm，半径 3.5cm
        let p = vec![
            Vec2::new(-3.5, -12.0),
            Vec2::new(3.5, -12.0),
            Vec2::new(3.5, 12.0),
            Vec2::new(-3.5, 12.0),
        ];
        let prof = SectionProfile::for_part(BoneKind::Radius, &p);
        println!(
            "前臂：皮肤 {:.2} 脂肪 {:.2} 骨 {:.2}，总深 {:.2}",
            prof.skin_cm, prof.fat_cm, prof.bone_cm, prof.max_depth_cm
        );
        assert!(prof.bone_cm > 0.5, "前臂必须还有骨，实际 {}", prof.bone_cm);
        assert!(
            prof.skin_cm + prof.fat_cm + prof.bone_cm < prof.max_depth_cm,
            "三层加起来不能超过半径"
        );
    }

    #[test]
    fn no_bone_means_no_bone_band() {
        let p = thigh();
        let prof = SectionProfile::for_part(BoneKind::None, &p);
        assert_eq!(prof.bone_cm, 0.0);
        let bands = measure_bands(&p, &prof, Vec2::new(-5.5, 0.0), Vec2::new(5.5, 0.0), 512);
        assert!(bands.iter().all(|b| b.layer != Layer::Bone));
    }

    /// 沿长轴切（纵向）不该看到骨——深度一直很小。
    #[test]
    fn a_longitudinal_cut_through_the_middle_stays_deep() {
        let p = thigh();
        let prof = SectionProfile::for_part(BoneKind::Femur, &p);
        let scan = scan_layers(&p, &prof, Vec2::new(0.0, -13.0), Vec2::new(0.0, 13.0), 51);
        // 首尾两站落在边界上（皮肤），中间整条都在中心线上，深度恒为 5.5 → 骨
        assert_eq!(scan[0].1, Layer::Skin, "起点在边界上");
        assert_eq!(scan[50].1, Layer::Skin, "终点在边界上");
        // 骨区长 3cm（上下各 1.5），对应 |y| < 9，即 t ∈ (0.154, 0.846)
        // 避开这段边界过渡之后，中间应该全在骨里
        assert!(
            scan[10..41].iter().all(|s| s.1 == Layer::Bone),
            "纵向中线中段应全程在骨里，实际 {:?}",
            scan[10..41].iter().map(|s| s.1).collect::<Vec<_>>()
        );
    }
}
