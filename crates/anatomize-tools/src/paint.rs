//! 断面着色：把 `BodyPlan` 的多边形画成一张解剖剖面。
//!
//! 没有贴图，没有精灵，全部现场算：每个像素问一次"你在原部件里有多深"，
//! 深度决定层，层决定颜色。所以切开大腿时，新露出来的那一面**自动**是
//! 皮肤→脂肪→肌肉→骨的同心带——因为刀线穿过中心，深度先增后减。
//!
//! 这条链路和验收标准 6 是同一个东西：`section::measure_bands` 量的是
//! 这条链路的数值版本，`paint` 量的是它的像素版本。两者用的是同一个
//! `SectionProfile`，所以不可能对不上。

use anatomize_body::Layer;
use anatomize_core::Vec2;
use anatomize_cut::{SectionProfile, signed_depth};
use anatomize_sim::{PieceId, Sim};

use crate::render::Canvas;

/// 断面配色。偏"教科书插图"而不是照片——这是给玩家读结构的，不是给玩家害怕的。
pub fn layer_color(l: Layer) -> [u8; 4] {
    match l {
        Layer::Skin => [230, 178, 146, 255],
        Layer::Fat => [240, 214, 136, 255],
        Layer::Muscle => [166, 54, 54, 255],
        Layer::Bone => [238, 232, 212, 255],
        Layer::Organ => [136, 68, 104, 255],
    }
}

/// 层的英文名（图例用）。
pub fn layer_name(l: Layer) -> &'static str {
    match l {
        Layer::Skin => "SKIN",
        Layer::Fat => "FAT",
        Layer::Muscle => "MUSCLE",
        Layer::Bone => "BONE",
        Layer::Organ => "ORGAN",
    }
}

/// 画所有块。`outline` 为真时给每块描一圈深色边，切开的地方才看得出来。
pub fn paint_pieces(cv: &mut Canvas, sim: &Sim, outline: bool) {
    for i in 0..sim.body.pieces.len() {
        let id = PieceId(i as u32);
        paint_piece(cv, sim, id, outline);
    }
}

/// 画一块。
///
/// 逐像素的做法在 1080p 下当然跑不动，但这是离线验收图——一次只画几帧，
/// 慢一点无所谓，换来的是"断面和几何绝对一致"。
pub fn paint_piece(cv: &mut Canvas, sim: &Sim, id: PieceId, outline: bool) {
    let piece = &sim.body.pieces[id.index()];
    let part = &sim.plan.parts[piece.part.index()];
    let profile = SectionProfile::for_part(part.bone, &part.polygon);

    let poly = sim.piece_polygon(id);
    if poly.len() < 3 {
        return;
    }
    let (pos, rot) = sim.piece_pose(id);
    let (sin, cos) = rot.sin_cos();

    // 包围盒（世界米）
    let (mut lo, mut hi) = (Vec2::splat(f32::INFINITY), Vec2::splat(f32::NEG_INFINITY));
    for p in &poly {
        lo = lo.min(*p);
        hi = hi.max(*p);
    }
    // 注意 y 轴翻转：世界 y 最小的一角对应**屏幕 y 最大**的一角。
    // 直接拿 (lo → px0, hi → px1) 当循环上下界会得到一个空区间。
    let (ax, ay) = cv.world_to_px(lo);
    let (bx, by) = cv.world_to_px(hi);
    let px0 = ax.min(bx).floor() as i32 - 1;
    let px1 = ax.max(bx).ceil() as i32 + 1;
    let py0 = ay.min(by).floor() as i32 - 1;
    let py1 = ay.max(by).ceil() as i32 + 1;

    for py in py0..=py1 {
        for px in px0..=px1 {
            let w = cv.px_to_world(px as f32 + 0.5, py as f32 + 0.5);
            // 世界米 → 块局部米 → 部件局部厘米
            let d = w - pos;
            let local_m = Vec2::new(d.x * cos + d.y * sin, -d.x * sin + d.y * cos);
            let local_cm = local_m * 100.0 + piece.centroid;

            let depth = signed_depth(&part.polygon, local_cm);
            if depth < 0.0 {
                continue;
            }
            cv.put(px, py, layer_color(profile.layer_at(depth)));
        }
    }

    if outline {
        // 描边必须是**半透明**的。断面就是切口那条线，而切口两侧的边都属于
        // 块多边形——实心描边会整条盖上去，14 倍放大下看到的是一根黑线，
        // 不是四层色带。踩过这个坑。
        for i in 0..poly.len() {
            let a = poly[i];
            let b = poly[(i + 1) % poly.len()];
            let (x1, y1) = cv.world_to_px(a);
            let (x2, y2) = cv.world_to_px(b);
            let steps = ((x2 - x1).abs().max((y2 - y1).abs())).ceil() as i32;
            for k in 0..=steps.max(1) {
                let t = k as f32 / steps.max(1) as f32;
                let x = (x1 + (x2 - x1) * t) as i32;
                let y = (y1 + (y2 - y1) * t) as i32;
                cv.blend(x, y, [10, 8, 12, 255], 96);
            }
        }
    }
}

/// 组织场热力图：把某个通道叠成半透明色块。
///
/// 场固定在**身体坐标系**（ADR-003），所以要先找到身体原点在世界里的位置。
/// 这里用躯干块的位置反推——P0 只有一具身体，够用。
pub fn paint_heatmap(cv: &mut Canvas, sim: &Sim, channel: HeatChannel, alpha: u8) {
    let Some(t) = sim.tissue.as_ref() else {
        return;
    };
    let f = &t.field;
    let Some(anchor) = sim.body_origin_world() else {
        return;
    };

    let texel = f.texel_cm * 0.01;
    for y in 0..f.h {
        for x in 0..f.w {
            let i = (y * f.w + x) as usize;
            if f.kind[i] == anatomize_tissue::TissueKind::Outside {
                continue;
            }
            let v = match channel {
                HeatChannel::Perfusion => (f.perfusion[i] / 0.02).clamp(0.0, 1.0),
                HeatChannel::Oxygen => (f.o2[i] / 60.0).clamp(0.0, 1.0),
                HeatChannel::Temperature => ((f.temp[i] - 20.0) / 20.0).clamp(0.0, 1.0),
                HeatChannel::Damage => f.damage[i].clamp(0.0, 1.0),
            };
            let c = heat_color(channel, v);
            // texel 左下角在身体局部的厘米坐标
            let wx = f.origin.x * 0.01 + x as f32 * texel;
            let wy = f.origin.y * 0.01 + y as f32 * texel;
            let p0 = anchor + Vec2::new(wx, wy);
            let p1 = p0 + Vec2::new(texel, texel);
            let (a, b) = cv.world_to_px(p0);
            let (c2, d) = cv.world_to_px(p1);
            for py in (b as i32)..=(d as i32) {
                for px in (a as i32)..=(c2 as i32) {
                    cv.blend(px, py, c, alpha);
                }
            }
        }
    }
}

/// 热力图通道。
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum HeatChannel {
    Perfusion,
    Oxygen,
    Temperature,
    Damage,
}

impl HeatChannel {
    pub fn name(self) -> &'static str {
        match self {
            HeatChannel::Perfusion => "PERFUSION",
            HeatChannel::Oxygen => "OXYGEN",
            HeatChannel::Temperature => "TEMPERATURE",
            HeatChannel::Damage => "DAMAGE",
        }
    }
}

fn heat_color(ch: HeatChannel, v: f32) -> [u8; 4] {
    let v = v.clamp(0.0, 1.0);
    match ch {
        // 灌注：黑 → 青 → 白（低灌注是黑的，一眼看出来）
        HeatChannel::Perfusion => [
            (40.0 + 215.0 * v * v) as u8,
            (30.0 + 225.0 * v) as u8,
            (60.0 + 195.0 * v) as u8,
            255,
        ],
        // 氧：深紫 → 亮红
        HeatChannel::Oxygen => [
            (60.0 + 195.0 * v) as u8,
            (20.0 + 90.0 * v) as u8,
            (90.0 - 50.0 * v) as u8,
            255,
        ],
        // 温度：蓝 → 红
        HeatChannel::Temperature => [
            (30.0 + 225.0 * v) as u8,
            (60.0 + 120.0 * (1.0 - (v - 0.5).abs() * 2.0).max(0.0)) as u8,
            (200.0 - 170.0 * v) as u8,
            255,
        ],
        // 损伤：透明感 → 亮黄
        HeatChannel::Damage => [
            (255.0 * v + 40.0 * (1.0 - v)) as u8,
            (220.0 * v + 40.0 * (1.0 - v)) as u8,
            (40.0 * (1.0 - v)) as u8,
            255,
        ],
    }
}
