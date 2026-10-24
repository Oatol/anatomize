//! 线段求交。
//!
//! 结构判定的全部依据：切面折线 × 血管折线 / 神经折线。
//! 不用能量阈值，切口没碰到血管就是没碰到——玩家能学会"往哪切"。

use anatomize_core::Vec2;

/// 交点。
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Crossing {
    /// 折线上的第几段。
    pub seg: usize,
    /// 沿切割线段的参数 0..1。
    pub t: f32,
    /// 沿折线段的参数 0..1。
    pub s: f32,
    pub point: Vec2,
}

/// 两条线段求交。返回（沿 a 的参数，沿 b 的参数，交点）。
pub fn segment_segment(a1: Vec2, a2: Vec2, b1: Vec2, b2: Vec2) -> Option<(f32, f32, Vec2)> {
    let r = a2 - a1;
    let s = b2 - b1;
    let denom = r.perp_dot(s);
    if denom.abs() < 1e-9 {
        return None; // 平行或共线
    }
    let qp = b1 - a1;
    let t = qp.perp_dot(s) / denom;
    let u = qp.perp_dot(r) / denom;
    if !(-1e-6..=1.0 + 1e-6).contains(&t) || !(-1e-6..=1.0 + 1e-6).contains(&u) {
        return None;
    }
    Some((t.clamp(0.0, 1.0), u.clamp(0.0, 1.0), a1 + r * t))
}

/// 切割线段与一条折线的所有交点，按沿切线方向排序，去掉重复点。
pub fn segment_polyline(a: Vec2, b: Vec2, path: &[Vec2]) -> Vec<Crossing> {
    let mut out: Vec<Crossing> = Vec::new();
    if path.len() < 2 {
        return out;
    }
    for i in 0..path.len() - 1 {
        if let Some((t, s, point)) = segment_segment(a, b, path[i], path[i + 1]) {
            if let Some(last) = out.last() {
                if (last.point - point).length() < 1e-6 {
                    continue;
                }
            }
            out.push(Crossing {
                seg: i,
                t,
                s,
                point,
            });
        }
    }
    out.sort_by(|x, y| x.t.partial_cmp(&y.t).unwrap_or(std::cmp::Ordering::Equal));
    out
}

/// 点到线段的距离。刀口宽度判定用。
pub fn distance_point_segment(p: Vec2, a: Vec2, b: Vec2) -> f32 {
    let ab = b - a;
    let len2 = ab.length_squared();
    if len2 < 1e-12 {
        return (p - a).length();
    }
    let t = ((p - a).dot(ab) / len2).clamp(0.0, 1.0);
    (p - (a + ab * t)).length()
}

/// 折线是否被切割线段穿过。
pub fn polyline_hit(a: Vec2, b: Vec2, path: &[Vec2]) -> bool {
    !segment_polyline(a, b, path).is_empty()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn crosses() {
        let a1 = Vec2::new(-1.0, 0.0);
        let a2 = Vec2::new(1.0, 0.0);
        let b1 = Vec2::new(0.0, -1.0);
        let b2 = Vec2::new(0.0, 1.0);
        let (t, s, p) = segment_segment(a1, a2, b1, b2).unwrap();
        assert!((t - 0.5).abs() < 1e-6);
        assert!((s - 0.5).abs() < 1e-6);
        assert!(p.length() < 1e-6);
    }

    #[test]
    fn parallel_is_miss() {
        let a1 = Vec2::new(0.0, 0.0);
        let a2 = Vec2::new(1.0, 0.0);
        let b1 = Vec2::new(0.0, 1.0);
        let b2 = Vec2::new(1.0, 1.0);
        assert!(segment_segment(a1, a2, b1, b2).is_none());
    }

    #[test]
    fn polyline_sorted_and_deduped() {
        // 一条折线折回来，切线应该只留下一个交点
        let path = vec![
            Vec2::new(0.0, -2.0),
            Vec2::new(0.0, 2.0),
            Vec2::new(1.0, 2.0),
        ];
        let hits = segment_polyline(
            Vec2::new(-1.0, 0.0),
            Vec2::new(1.0, 0.0),
            &path,
        );
        assert_eq!(hits.len(), 1);
        assert!(hits[0].point.length() < 1e-6);
    }

    #[test]
    fn distance() {
        let d = distance_point_segment(
            Vec2::new(0.0, 1.0),
            Vec2::new(-1.0, 0.0),
            Vec2::new(1.0, 0.0),
        );
        assert!((d - 1.0).abs() < 1e-6);
    }
}
