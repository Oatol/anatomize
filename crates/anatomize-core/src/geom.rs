//! 多边形几何：宿主画断面时用。

use crate::Vec2;

/// 凸多边形向内等距收缩 `d`（和输入同一单位）。
///
/// 断面分层的核心：把一块肉按层厚一层层缩进去，每层填一个颜色。
/// 因为凸多边形的内缩还是凸的，可以直接喂给 `Shape::convex_polygon`。
///
/// 收缩过头（多边形退化）返回 `None`——调用方就停在上一层，不要画出一个
/// 反向的多边形（那会让整块变成黑色）。
pub fn inset_convex(poly: &[Vec2], d: f32) -> Option<Vec<Vec2>> {
    let n = poly.len();
    if n < 3 {
        return None;
    }
    if d <= 0.0 {
        return Some(poly.to_vec());
    }

    // 每条边：向内平移 d 之后，用一个点 + 方向表示
    let mut edges: Vec<(Vec2, Vec2)> = Vec::with_capacity(n);
    for i in 0..n {
        let a = poly[i];
        let b = poly[(i + 1) % n];
        let e = b - a;
        let len = e.length();
        if len < 1e-9 {
            return None;
        }
        let dir = e / len;
        // 逆时针多边形内部在左侧，所以内法线是 dir 的逆时针垂线
        let nrm = Vec2::new(-dir.y, dir.x);
        edges.push((a + nrm * d, dir));
    }

    // 相邻两条边的交点就是新顶点
    let mut out = Vec::with_capacity(n);
    for i in 0..n {
        let (p1, d1) = edges[(i + n - 1) % n];
        let (p2, d2) = edges[i];
        let denom = d1.perp_dot(d2);
        if denom.abs() < 1e-6 {
            return None;
        }
        let t = (p2 - p1).perp_dot(d2) / denom;
        out.push(p1 + d1 * t);
    }

    // 退化检查：新面积必须**小于**原面积。
    //
    // 只判"面积 > 0"是不够的：内缩量超过内切半径之后，四条边会交叉成一个
    // 反向的多边形，它的面积还是正的——而且可能比原多边形还大。
    // 那个多边形画出来会把整块盖成一层皮。
    let mut area = 0.0;
    for i in 0..n {
        area += out[i].perp_dot(out[(i + 1) % n]);
    }
    let new_area = area * 0.5;
    let old_area = polygon_area(poly).abs();
    if new_area <= 1e-9 || new_area >= old_area {
        return None;
    }
    Some(out)
}

/// 凸多边形裁剪（Sutherland–Hodgman）：`subject` 被 `clip` 裁掉一部分。
///
/// 两个都必须是逆时针凸多边形。返回交集（可能为空）。
///
/// 热力图滤镜要"在块内部按 4×4 显示梯度"，每个格子是一个矩形，但块本身
/// 不是矩形——所以每个格子都要和块求一次交。凸-凸裁剪是这个操作的最小实现。
pub fn clip_convex(subject: &[Vec2], clip: &[Vec2]) -> Vec<Vec2> {
    let mut out: Vec<Vec2> = subject.to_vec();
    let n = clip.len();
    if n < 3 || out.len() < 3 {
        return Vec::new();
    }
    for i in 0..n {
        let a = clip[i];
        let b = clip[(i + 1) % n];
        let edge = b - a;
        // 内部在左侧：cross(edge, p - a) >= 0
        let inside = |p: Vec2| edge.perp_dot(p - a) >= -1e-6;

        let input = std::mem::take(&mut out);
        if input.is_empty() {
            return Vec::new();
        }
        let m = input.len();
        for j in 0..m {
            let cur = input[j];
            let prev = input[(j + m - 1) % m];
            let ci = inside(cur);
            let pi = inside(prev);
            if ci {
                if !pi {
                    if let Some(p) = line_cross(prev, cur, a, edge) {
                        out.push(p);
                    }
                }
                out.push(cur);
            } else if pi
                && let Some(p) = line_cross(prev, cur, a, edge)
            {
                out.push(p);
            }
        }
    }
    // 去掉重复点和共线点。
    //
    // 裁剪出来的多边形经常带着"三个点共线"（格子边正好压在块边上时）。
    // egui 的 `convex_polygon` 会因为这种点判定"不是严格凸"而**整块丢弃**，
    // 表现就是热力图大部分不显示。
    let mut clean: Vec<Vec2> = Vec::with_capacity(out.len());
    for p in out {
        if clean
            .last()
            .is_none_or(|q: &Vec2| (*q - p).length() > 1e-7)
        {
            clean.push(p);
        }
    }
    if clean.len() >= 3 && (clean[0] - clean[clean.len() - 1]).length() < 1e-7 {
        clean.pop();
    }
    if clean.len() < 3 {
        return Vec::new();
    }
    let m = clean.len();
    let mut res: Vec<Vec2> = Vec::with_capacity(m);
    for i in 0..m {
        let a = clean[(i + m - 1) % m];
        let b = clean[i];
        let c = clean[(i + 1) % m];
        if (b - a).perp_dot(c - b).abs() > 1e-7 {
            res.push(b);
        }
    }
    res
}

/// 线段 `p→q` 与直线（过 `o`、方向 `d`）的交点。
fn line_cross(p: Vec2, q: Vec2, o: Vec2, d: Vec2) -> Option<Vec2> {
    let seg = q - p;
    let denom = seg.perp_dot(d);
    if denom.abs() < 1e-9 {
        return None;
    }
    let t = (o - p).perp_dot(d) / denom;
    Some(p + seg * t)
}

/// 多边形面积（逆时针为正）。
pub fn polygon_area(poly: &[Vec2]) -> f32 {
    let n = poly.len();
    if n < 3 {
        return 0.0;
    }
    let mut a = 0.0;
    for i in 0..n {
        a += poly[i].perp_dot(poly[(i + 1) % n]);
    }
    a * 0.5
}

/// 多边形质心。
pub fn polygon_centroid(poly: &[Vec2]) -> Vec2 {
    let a = polygon_area(poly);
    if a.abs() < 1e-9 {
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
        c += (p + q) * p.perp_dot(q);
    }
    c / (6.0 * a)
}

/// 界面配色。深色主题，和离线验收图一致。
pub mod ui {
    pub const BG: [u8; 4] = [18, 17, 22, 255];
    pub const PANEL: [u8; 4] = [26, 25, 32, 255];
    pub const GRID: [u8; 4] = [36, 34, 44, 255];
    pub const INK: [u8; 4] = [232, 230, 238, 255];
    pub const DIM: [u8; 4] = [140, 137, 152, 255];
    pub const HOT: [u8; 4] = [232, 92, 92, 255];
    pub const OK: [u8; 4] = [120, 200, 140, 255];
    pub const WARN: [u8; 4] = [240, 190, 110, 255];
}

#[cfg(test)]
mod tests {
    use super::*;

    fn square() -> Vec<Vec2> {
        vec![
            Vec2::new(-1.0, -1.0),
            Vec2::new(1.0, -1.0),
            Vec2::new(1.0, 1.0),
            Vec2::new(-1.0, 1.0),
        ]
    }

    #[test]
    fn insetting_a_square_shrinks_every_side_equally() {
        let p = inset_convex(&square(), 0.25).unwrap();
        for v in &p {
            assert!((v.x.abs() - 0.75).abs() < 1e-5, "x = {}", v.x);
            assert!((v.y.abs() - 0.75).abs() < 1e-5, "y = {}", v.y);
        }
    }

    #[test]
    fn insetting_too_far_gives_up() {
        assert!(inset_convex(&square(), 1.0).is_none());
        assert!(inset_convex(&square(), 2.0).is_none());
    }

    #[test]
    fn a_rectangle_keeps_its_aspect() {
        // 11 × 26 的大腿：内缩 0.5 之后应该还是 10 × 25
        let p = vec![
            Vec2::new(-5.5, -13.0),
            Vec2::new(5.5, -13.0),
            Vec2::new(5.5, 13.0),
            Vec2::new(-5.5, 13.0),
        ];
        let q = inset_convex(&p, 0.5).unwrap();
        let (mut lo, mut hi) = (Vec2::splat(f32::INFINITY), Vec2::splat(f32::NEG_INFINITY));
        for v in &q {
            lo = lo.min(*v);
            hi = hi.max(*v);
        }
        assert!(((hi.x - lo.x) - 10.0).abs() < 1e-5);
        assert!(((hi.y - lo.y) - 25.0).abs() < 1e-5);
    }

    #[test]
    fn centroid_of_a_square_is_the_origin() {
        let c = polygon_centroid(&square());
        assert!(c.length() < 1e-6);
    }
}

#[cfg(test)]
mod clip_tests {
    use super::*;

    fn square(c: Vec2, r: f32) -> Vec<Vec2> {
        vec![
            Vec2::new(c.x - r, c.y - r),
            Vec2::new(c.x + r, c.y - r),
            Vec2::new(c.x + r, c.y + r),
            Vec2::new(c.x - r, c.y + r),
        ]
    }

    #[test]
    fn clipping_a_square_by_itself_keeps_it() {
        let s = square(Vec2::ZERO, 1.0);
        let c = clip_convex(&s, &s);
        assert!((polygon_area(&c).abs() - 4.0).abs() < 1e-4);
    }

    #[test]
    fn clipping_half_overlapping_squares_keeps_the_quarter() {
        // 两个 2×2 的正方形，中心差 (1,1) → 交集是 1×1 = 1
        let a = square(Vec2::ZERO, 1.0);
        let b = square(Vec2::new(1.0, 1.0), 1.0);
        let c = clip_convex(&a, &b);
        assert!((polygon_area(&c).abs() - 1.0).abs() < 1e-4, "面积 {}", polygon_area(&c));
    }

    #[test]
    fn clipping_disjoint_squares_gives_nothing() {
        let a = square(Vec2::ZERO, 1.0);
        let b = square(Vec2::new(5.0, 0.0), 1.0);
        assert!(clip_convex(&a, &b).is_empty());
    }

    #[test]
    fn clipping_by_a_rotated_square_still_has_area() {
        // 45° 转的正方形裁一个轴对齐正方形，面积在 0 和 4 之间
        let a = square(Vec2::ZERO, 1.0);
        let r = 1.2f32;
        let b: Vec<Vec2> = (0..4)
            .map(|i| {
                let t = std::f32::consts::TAU * i as f32 / 4.0 + 0.4;
                Vec2::new(t.cos() * r, t.sin() * r)
            })
            .collect();
        let c = clip_convex(&a, &b);
        let area = polygon_area(&c).abs();
        assert!(area > 0.5 && area < 4.0, "面积 {area}");
    }
}
