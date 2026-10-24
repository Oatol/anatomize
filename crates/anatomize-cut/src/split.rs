//! 凸多边形沿直线一分为二。
//!
//! 这是切割管线的第一步，也是唯一需要保证"面积守恒"的地方。
//! 凸多边形的切面天然闭合，所以不需要任何边界环恢复——这是选凸代理的核心红利。

use crate::line::Line;
use crate::decomp::signed_area;
use anatomize_core::Vec2;

const EPS: f32 = 1e-6;

#[derive(Debug, Clone, PartialEq)]
pub enum SplitOutcome {
    /// 完全在一侧，或切线与某条边重合。
    Miss,
    /// 只擦到一个点/一条边，或切出的碎片退化。
    Degenerate,
    Split { left: Vec<Vec2>, right: Vec<Vec2> },
}

/// 切割后的一块碎片。
#[derive(Debug, Clone)]
pub struct Fragment {
    /// 部件局部坐标下的多边形（逆时针）。
    pub polygon: Vec<Vec2>,
    pub area: f32,
    pub centroid: Vec2,
    /// 相对原部件的质量占比，等于面积占比。
    pub mass_share: f32,
    /// 该碎片的绝对质量（kg）。
    pub mass: f32,
}

/// 把一个凸多边形沿直线切开。
///
/// `left` 是直线正侧（`line.signed_distance > 0`）的部分，`right` 是负侧。
pub fn split_convex(poly: &[Vec2], line: &Line) -> SplitOutcome {
    let n = poly.len();
    if n < 3 {
        return SplitOutcome::Degenerate;
    }

    let d: Vec<f32> = poly.iter().map(|p| line.signed_distance(*p)).collect();
    let has_pos = d.iter().any(|x| *x > EPS);
    let has_neg = d.iter().any(|x| *x < -EPS);
    if !(has_pos && has_neg) {
        return SplitOutcome::Miss;
    }

    let mut left: Vec<Vec2> = Vec::with_capacity(n + 2);
    let mut right: Vec<Vec2> = Vec::with_capacity(n + 2);

    for i in 0..n {
        let j = (i + 1) % n;
        let (di, dj) = (d[i], d[j]);
        let (pi, pj) = (poly[i], poly[j]);

        if di >= -EPS {
            push_unique(&mut left, pi);
        }
        if di <= EPS {
            push_unique(&mut right, pi);
        }

        // 严格穿越才插交点；顶点正好在线上时已经在上面被两边收下了
        if (di > EPS && dj < -EPS) || (di < -EPS && dj > EPS) {
            let t = di / (di - dj);
            let p = pi + (pj - pi) * t;
            push_unique(&mut left, p);
            push_unique(&mut right, p);
        }
    }

    let left = clean(&left);
    let right = clean(&right);
    if left.len() < 3 || right.len() < 3 {
        return SplitOutcome::Degenerate;
    }

    SplitOutcome::Split { left, right }
}

/// 把一个部件切开，返回碎片列表。没切到时返回空。
pub fn split_part(poly: &[Vec2], mass: f32, line: &Line) -> Vec<Fragment> {
    let total = signed_area(poly).abs();
    match split_convex(poly, line) {
        SplitOutcome::Split { left, right } => {
            let mut out = Vec::with_capacity(2);
            for p in [left, right] {
                let a = signed_area(&p).abs();
                if a < EPS {
                    continue;
                }
                out.push(Fragment {
                    centroid: centroid(&p),
                    area: a,
                    mass_share: if total > EPS { a / total } else { 0.0 },
                    mass: 0.0,
                    polygon: p,
                });
            }
            if out.len() < 2 {
                return Vec::new();
            }
            let sum: f32 = out.iter().map(|f| f.mass_share).sum();
            for f in &mut out {
                f.mass_share /= sum;
                f.mass = mass * f.mass_share;
            }
            out
        }
        _ => Vec::new(),
    }
}

fn push_unique(dst: &mut Vec<Vec2>, p: Vec2) {
    if let Some(last) = dst.last() {
        if (*last - p).length() < 1e-7 {
            return;
        }
    }
    dst.push(p);
}

/// 去掉重复点、共线点，并统一成逆时针。
fn clean(poly: &[Vec2]) -> Vec<Vec2> {
    let mut out: Vec<Vec2> = Vec::with_capacity(poly.len());
    for &p in poly {
        if let Some(&last) = out.last() {
            if (last - p).length() < 1e-7 {
                continue;
            }
        }
        out.push(p);
    }
    // 首尾重合
    while out.len() > 1 {
        let first = out[0];
        let last = *out.last().unwrap();
        if (first - last).length() < 1e-7 {
            out.pop();
        } else {
            break;
        }
    }

    // 去掉共线点
    let mut changed = true;
    while changed && out.len() > 3 {
        changed = false;
        for i in 0..out.len() {
            let a = out[(i + out.len() - 1) % out.len()];
            let b = out[i];
            let c = out[(i + 1) % out.len()];
            let cross = (b - a).perp_dot(c - b);
            if cross.abs() < 1e-7 {
                out.remove(i);
                changed = true;
                break;
            }
        }
    }

    if signed_area(&out) < 0.0 {
        out.reverse();
    }
    out
}

pub fn centroid(poly: &[Vec2]) -> Vec2 {
    let a = signed_area(poly);
    if a.abs() < EPS {
        let mut s = Vec2::ZERO;
        for p in poly {
            s += *p;
        }
        return s / poly.len().max(1) as f32;
    }
    let mut c = Vec2::ZERO;
    for i in 0..poly.len() {
        let p = poly[i];
        let q = poly[(i + 1) % poly.len()];
        let cross = p.perp_dot(q);
        c += (p + q) * cross;
    }
    c / (6.0 * a)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::decomp::{convex_hull, is_convex};
    use anatomize_core::Rng;

    fn random_convex(rng: &mut Rng, n: usize) -> Vec<Vec2> {
        let pts: Vec<Vec2> = (0..n)
            .map(|_| Vec2::new(rng.range(-1.0, 1.0), rng.range(-1.0, 1.0)))
            .collect();
        convex_hull(&pts)
    }

    #[test]
    fn split_square_in_half() {
        let sq = vec![
            Vec2::new(-1.0, -1.0),
            Vec2::new(1.0, -1.0),
            Vec2::new(1.0, 1.0),
            Vec2::new(-1.0, 1.0),
        ];
        let line = Line::through(Vec2::new(0.0, -2.0), Vec2::new(0.0, 2.0)).unwrap();
        match split_convex(&sq, &line) {
            SplitOutcome::Split { left, right } => {
                assert!((signed_area(&left).abs() - 2.0).abs() < 1e-5);
                assert!((signed_area(&right).abs() - 2.0).abs() < 1e-5);
            }
            other => panic!("应该切开，实际 {other:?}"),
        }
    }

    #[test]
    fn miss_when_line_outside() {
        let sq = vec![
            Vec2::new(-1.0, -1.0),
            Vec2::new(1.0, -1.0),
            Vec2::new(1.0, 1.0),
            Vec2::new(-1.0, 1.0),
        ];
        let line = Line::through(Vec2::new(0.0, 5.0), Vec2::new(1.0, 5.0)).unwrap();
        assert_eq!(split_convex(&sq, &line), SplitOutcome::Miss);
    }

    /// M1 验收：一万次随机切割，面积守恒误差 < 0.1%，且碎片仍是凸的。
    #[test]
    fn fuzz_area_conservation() {
        let mut rng = Rng::new(2026);
        let mut splits = 0usize;
        for _ in 0..10_000 {
            let poly = random_convex(&mut rng, 6);
            if poly.len() < 3 {
                continue;
            }
            let a = Vec2::new(rng.range(-1.2, 1.2), rng.range(-1.2, 1.2));
            let b = Vec2::new(rng.range(-1.2, 1.2), rng.range(-1.2, 1.2));
            let Some(line) = Line::through(a, b) else {
                continue;
            };
            let total = signed_area(&poly).abs();
            if total < 1e-6 {
                continue;
            }
            if let SplitOutcome::Split { left, right } = split_convex(&poly, &line) {
                splits += 1;
                let l = signed_area(&left).abs();
                let r = signed_area(&right).abs();
                let err = ((l + r) - total).abs() / total;
                assert!(err < 1e-3, "面积误差 {err} 超过 0.1%");
                assert!(is_convex(&left), "左碎片不是凸的");
                assert!(is_convex(&right), "右碎片不是凸的");
            }
        }
        assert!(splits > 3000, "命中率过低，只有 {splits} 次切开");
    }

    #[test]
    fn mass_shares_sum_to_one() {
        let sq = vec![
            Vec2::new(-1.0, -1.0),
            Vec2::new(1.0, -1.0),
            Vec2::new(1.0, 1.0),
            Vec2::new(-1.0, 1.0),
        ];
        let line = Line::through(Vec2::new(0.3, -2.0), Vec2::new(0.3, 2.0)).unwrap();
        let frags = split_part(&sq, 10.0, &line);
        assert_eq!(frags.len(), 2);
        let sum: f32 = frags.iter().map(|f| f.mass_share).sum();
        assert!((sum - 1.0).abs() < 1e-5);
        let area_sum: f32 = frags.iter().map(|f| f.area).sum();
        assert!((area_sum - 4.0).abs() < 1e-4);
    }
}
