//! 多边形工具：面积、三角化、凸分解、凸包。
//!
//! 凸分解用耳切（ear clipping）先三角化，再用 Hertel–Mehlhorn 合并相邻三角形。
//! 对凸输入它会退化成"原样返回"，所以凸部件走的是快路径。

use anatomize_core::Vec2;

const EPS: f32 = 1e-7;

/// 有符号面积，逆时针为正。
pub fn signed_area(poly: &[Vec2]) -> f32 {
    let mut a = 0.0;
    for i in 0..poly.len() {
        let p = poly[i];
        let q = poly[(i + 1) % poly.len()];
        a += p.x * q.y - q.x * p.y;
    }
    a * 0.5
}

pub fn is_convex(poly: &[Vec2]) -> bool {
    if poly.len() < 3 {
        return false;
    }
    let mut sign = 0.0f32;
    for i in 0..poly.len() {
        let a = poly[i];
        let b = poly[(i + 1) % poly.len()];
        let c = poly[(i + 2) % poly.len()];
        let cross = (b - a).perp_dot(c - b);
        if cross.abs() < EPS {
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

/// 耳切三角化，返回顶点索引三元组（逆时针）。
pub fn triangulate(poly: &[Vec2]) -> Vec<[usize; 3]> {
    let n = poly.len();
    if n < 3 {
        return Vec::new();
    }
    let ccw = signed_area(poly) > 0.0;
    let mut idx: Vec<usize> = (0..n).collect();
    if !ccw {
        idx.reverse();
    }

    let mut out = Vec::with_capacity(n.saturating_sub(2));
    let mut guard = 0;
    while idx.len() > 3 {
        let m = idx.len();
        let mut clipped = false;
        for i in 0..m {
            let ia = idx[(i + m - 1) % m];
            let ib = idx[i];
            let ic = idx[(i + 1) % m];
            let (a, b, c) = (poly[ia], poly[ib], poly[ic]);

            let cross = (b - a).perp_dot(c - b);
            if cross <= EPS {
                continue; // 凹点或退化，不是耳朵
            }
            // 没有其他顶点落在这个三角形内
            let mut blocked = false;
            for &k in &idx {
                if k == ia || k == ib || k == ic {
                    continue;
                }
                if point_in_triangle(poly[k], a, b, c) {
                    blocked = true;
                    break;
                }
            }
            if blocked {
                continue;
            }
            out.push([ia, ib, ic]);
            idx.remove(i);
            clipped = true;
            break;
        }
        guard += 1;
        if !clipped || guard > n * n {
            // 退化输入：放弃，返回已切出的部分
            break;
        }
    }
    if idx.len() == 3 {
        out.push([idx[0], idx[1], idx[2]]);
    }
    out
}

fn point_in_triangle(p: Vec2, a: Vec2, b: Vec2, c: Vec2) -> bool {
    let d1 = (b - a).perp_dot(p - a);
    let d2 = (c - b).perp_dot(p - b);
    let d3 = (a - c).perp_dot(p - c);
    let has_neg = d1 < -EPS || d2 < -EPS || d3 < -EPS;
    let has_pos = d1 > EPS || d2 > EPS || d3 > EPS;
    !(has_neg && has_pos)
}

/// 凸分解。凸输入直接原样返回；凹输入走"三角化 + 合并"。
pub fn convex_decompose(poly: &[Vec2]) -> Vec<Vec<Vec2>> {
    if poly.len() < 3 {
        return Vec::new();
    }
    if is_convex(poly) {
        return vec![poly.to_vec()];
    }

    let tris = triangulate(poly);
    let mut parts: Vec<Vec<Vec2>> = tris
        .iter()
        .map(|t| vec![poly[t[0]], poly[t[1]], poly[t[2]]])
        .collect();

    // Hertel–Mehlhorn：能合并就合并
    let mut merged = true;
    while merged {
        merged = false;
        'outer: for i in 0..parts.len() {
            for j in (i + 1)..parts.len() {
                if let Some(u) = merge_convex(&parts[i], &parts[j]) {
                    parts[i] = u;
                    parts.remove(j);
                    merged = true;
                    break 'outer;
                }
            }
        }
    }
    parts
}

/// 若两块共享一条边且并集是凸的，返回并集。
fn merge_convex(a: &[Vec2], b: &[Vec2]) -> Option<Vec<Vec2>> {
    let na = a.len();
    let nb = b.len();
    for i in 0..na {
        let a1 = a[i];
        let a2 = a[(i + 1) % na];
        for j in 0..nb {
            let b1 = b[j];
            let b2 = b[(j + 1) % nb];
            // 共享边方向相反
            if (a1 - b2).length() > 1e-6 || (a2 - b1).length() > 1e-6 {
                continue;
            }
            let mut u: Vec<Vec2> = Vec::with_capacity(na + nb - 2);
            for k in 0..na {
                u.push(a[(i + 1 + k) % na]);
            }
            for k in 0..nb {
                u.push(b[(j + 1 + k) % nb]);
            }
            let cleaned = dedup(&u);
            if cleaned.len() >= 3 && is_convex(&cleaned) {
                return Some(cleaned);
            }
        }
    }
    None
}

fn dedup(poly: &[Vec2]) -> Vec<Vec2> {
    let mut out: Vec<Vec2> = Vec::with_capacity(poly.len());
    for &p in poly {
        if let Some(&last) = out.last() {
            if (last - p).length() < 1e-6 {
                continue;
            }
        }
        out.push(p);
    }
    while out.len() > 1 && (out[0] - *out.last().unwrap()).length() < 1e-6 {
        out.pop();
    }
    if signed_area(&out) < 0.0 {
        out.reverse();
    }
    out
}

/// 单调链凸包（逆时针）。碎片建碰撞体时会用到。
pub fn convex_hull(points: &[Vec2]) -> Vec<Vec2> {
    if points.len() < 3 {
        return points.to_vec();
    }
    let mut pts = points.to_vec();
    pts.sort_by(|a, b| {
        a.x.partial_cmp(&b.x)
            .unwrap_or(std::cmp::Ordering::Equal)
            .then(a.y.partial_cmp(&b.y).unwrap_or(std::cmp::Ordering::Equal))
    });
    pts.dedup_by(|a, b| (*a - *b).length() < 1e-9);

    let mut lower: Vec<Vec2> = Vec::new();
    for &p in &pts {
        while lower.len() >= 2 {
            let a = lower[lower.len() - 2];
            let b = lower[lower.len() - 1];
            if (b - a).perp_dot(p - a) <= 1e-9 {
                lower.pop();
            } else {
                break;
            }
        }
        lower.push(p);
    }

    let mut upper: Vec<Vec2> = Vec::new();
    for &p in pts.iter().rev() {
        while upper.len() >= 2 {
            let a = upper[upper.len() - 2];
            let b = upper[upper.len() - 1];
            if (b - a).perp_dot(p - a) <= 1e-9 {
                upper.pop();
            } else {
                break;
            }
        }
        upper.push(p);
    }

    lower.pop();
    upper.pop();
    lower.extend(upper);
    lower
}

#[cfg(test)]
mod tests {
    use super::*;

    fn square() -> Vec<Vec2> {
        vec![
            Vec2::new(0.0, 0.0),
            Vec2::new(1.0, 0.0),
            Vec2::new(1.0, 1.0),
            Vec2::new(0.0, 1.0),
        ]
    }

    #[test]
    fn area_of_square() {
        assert!((signed_area(&square()) - 1.0).abs() < 1e-6);
    }

    #[test]
    fn triangulate_preserves_area() {
        let poly = square();
        let tris = triangulate(&poly);
        assert_eq!(tris.len(), 2);
        let sum: f32 = tris
            .iter()
            .map(|t| signed_area(&[poly[t[0]], poly[t[1]], poly[t[2]]]).abs())
            .sum();
        assert!((sum - 1.0).abs() < 1e-6);
    }

    #[test]
    fn decompose_concave_l_shape() {
        // L 形：6 个顶点，1 个凹角
        let l = vec![
            Vec2::new(0.0, 0.0),
            Vec2::new(2.0, 0.0),
            Vec2::new(2.0, 1.0),
            Vec2::new(1.0, 1.0),
            Vec2::new(1.0, 2.0),
            Vec2::new(0.0, 2.0),
        ];
        assert!(!is_convex(&l));
        let parts = convex_decompose(&l);
        assert!(parts.len() >= 2);
        let sum: f32 = parts.iter().map(|p| signed_area(p).abs()).sum();
        assert!((sum - 3.0).abs() < 1e-5, "面积应守恒 3.0，实际 {sum}");
        for p in &parts {
            assert!(is_convex(p), "分解结果必须都是凸的");
        }
    }

    #[test]
    fn hull_of_square_with_interior_point() {
        let mut pts = square();
        pts.push(Vec2::new(0.5, 0.5));
        let h = convex_hull(&pts);
        assert_eq!(h.len(), 4);
        assert!((signed_area(&h) - 1.0).abs() < 1e-6);
    }
}
