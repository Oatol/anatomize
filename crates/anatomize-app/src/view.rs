//! 渲染：把 `Sim` 画成一幅解剖剖面。
//!
//! 全部走 egui 的 immediate mode painter——每帧重建所有 `Shape`。
//! 这在这种规模（20~40 块、每块 4 层）下完全够，换来的是"没有状态要同步"：
//! 没有 sprite 缓存要失效，没有 mesh 要重建，改了 `Sim` 下一帧就是新的。
//!
//! # 断面怎么画
//!
//! 不是贴图，是**内缩**：把一块的多边形按层厚一层层缩进去，每层填一个颜色。
//!
//! ```text
//! 皮肤（原多边形）
//!   内缩 skin_cm → 脂肪
//!     内缩 fat_cm → 肌肉
//!       骨（圆，半径 bone_cm）
//! ```
//!
//! 因为凸多边形的内缩还是凸的，可以直接喂给 `Shape::convex_polygon`。
//! 这套和 `anatomize-cut::section`（离线验收用的深度场）是**同一组层厚**，
//! 所以窗口里的断面和 `m6_section_hud.png` 里的对得上。

use anatomize_body::{Layer, layer_color};
use anatomize_core::geom::{inset_convex, polygon_centroid, ui};
use anatomize_core::{HeatChannel, Vec2};
use anatomize_sim::{PieceId, Sim};
use egui::{Color32, Painter, Pos2, Rect, Shape, Stroke};

use crate::camera::Camera;

pub fn c32(c: [u8; 4]) -> Color32 {
    Color32::from_rgba_unmultiplied(c[0], c[1], c[2], c[3])
}

pub fn c32a(c: [u8; 4], a: u8) -> Color32 {
    Color32::from_rgba_unmultiplied(c[0], c[1], c[2], a)
}

/// 画整个场景。
pub struct View<'a> {
    pub sim: &'a Sim,
    pub cam: &'a Camera,
    /// 热力图叠加（`None` = 只画断面）。
    pub heat: Option<HeatChannel>,
    /// 调试：画血管折线和关节锚点。
    pub debug: bool,
}

impl View<'_> {
    pub fn paint(&self, painter: &Painter, view: Rect) {
        painter.rect_filled(view, 0.0, c32(ui::BG));
        self.paint_grid(painter, view);
        self.paint_ground(painter, view);
        if let Some(ch) = self.heat {
            self.paint_heat(painter, view, ch);
            self.paint_piece_heat(painter, view, ch);
        }
        self.paint_body(painter, view);
        if self.debug {
            self.paint_vessels(painter, view);
            self.paint_joints(painter, view);
        }
    }

    /// 半米一格的暗网格。给"这东西多大"一个参照。
    fn paint_grid(&self, painter: &Painter, view: Rect) {
        let step = 0.5;
        let lo = self.cam.to_world(view.left_top(), view);
        let hi = self.cam.to_world(view.right_bottom(), view);
        let stroke = Stroke::new(1.0_f32, c32(ui::GRID));
        let mut x = (lo.x / step).floor() * step;
        while x <= hi.x {
            let s = self.cam.to_screen(Vec2::new(x, 0.0), view);
            painter.line_segment(
                [Pos2::new(s.x, view.top()), Pos2::new(s.x, view.bottom())],
                stroke,
            );
            x += step;
        }
        let mut y = (lo.y / step).floor() * step;
        while y <= hi.y {
            let s = self.cam.to_screen(Vec2::new(0.0, y), view);
            painter.line_segment(
                [Pos2::new(view.left(), s.y), Pos2::new(view.right(), s.y)],
                stroke,
            );
            y += step;
        }
    }

    /// 地面 + 世界边界。
    ///
    /// 边界必须画出来：沙盒里"东西为什么飞不过去"得有个看得见的理由。
    fn paint_ground(&self, painter: &Painter, view: Rect) {
        let w = self.sim.world;
        let gy = self.sim.ground_y();
        let hw = w.half_w();
        // 地面
        let a = self.cam.to_screen(Vec2::new(-hw, gy), view);
        let b = self.cam.to_screen(Vec2::new(hw, gy), view);
        painter.line_segment([a, b], Stroke::new(2.0_f32, c32([96, 90, 106, 255])));
        // 左右墙 + 顶
        let wall = Stroke::new(1.0_f32, c32([58, 55, 68, 255]));
        for sx in [-hw, hw] {
            let p0 = self.cam.to_screen(Vec2::new(sx, gy), view);
            let p1 = self.cam.to_screen(Vec2::new(sx, gy + w.height), view);
            painter.line_segment([p0, p1], wall);
        }
        let t0 = self.cam.to_screen(Vec2::new(-hw, gy + w.height), view);
        let t1 = self.cam.to_screen(Vec2::new(hw, gy + w.height), view);
        painter.line_segment([t0, t1], wall);
    }

    /// 组织场热力图：每个 texel 一个小方块。
    ///
    /// 24672 个 texel 全画会拖慢 egui，所以按 2×2 合并（约 6000 个矩形）。
    /// 只在打开叠加时画——默认关闭。
    fn paint_heat(&self, painter: &Painter, view: Rect, ch: HeatChannel) {
        let Some(t) = self.sim.tissue.as_ref() else {
            return;
        };
        let Some(anchor) = self.sim.body_origin_world() else {
            return;
        };
        let f = &t.field;
        let step = 2usize;
        let texel = f.texel_cm * 0.01;
        let cell = texel * step as f32;
        // 场钉在**身体坐标系**里，所以画的时候要跟着身体转。
        // 不转的话人躺下了、热力图还竖着——那就是"贴了张图"。
        let rot = self.sim.body_rotation();
        let (sin, cos) = rot.sin_cos();
        let to_world =
            |lx: f32, ly: f32| anchor + Vec2::new(lx * cos - ly * sin, lx * sin + ly * cos);

        for y in (0..f.h as usize).step_by(step) {
            for x in (0..f.w as usize).step_by(step) {
                let i = y * f.w as usize + x;
                if f.kind[i] == anatomize_tissue::TissueKind::Outside {
                    continue;
                }
                let v = match ch {
                    HeatChannel::Perfusion => f.perfusion[i],
                    HeatChannel::Oxygen => f.o2[i],
                    HeatChannel::Temperature => f.temp[i],
                    HeatChannel::Damage => f.damage[i],
                };
                let c = ch.color(ch.normalize(v));
                let lx = f.origin.x * 0.01 + x as f32 * texel;
                let ly = f.origin.y * 0.01 + y as f32 * texel;
                // 四个角都转，不然方块会跟着转成平行四边形
                let s0 = self.cam.to_screen(to_world(lx, ly), view);
                let s2 = self.cam.to_screen(to_world(lx + cell, ly + cell), view);
                if !view.intersects(Rect::from_two_pos(s0, s2)) {
                    continue;
                }
                painter.add(Shape::convex_polygon(
                    vec![
                        s0,
                        self.cam.to_screen(to_world(lx + cell, ly), view),
                        s2,
                        self.cam.to_screen(to_world(lx, ly + cell), view),
                    ],
                    c32a(c, 150),
                    Stroke::NONE,
                ));
            }
        }
    }

    /// 碎片的"滤镜层"：一块肉一层色，色跟着肉飞。
    ///
    /// 场钉在身体坐标系里，块飞走之后就不能再查场了。所以切开的那一刻把
    /// 这块的平均值抄下来（`Piece::heat`），之后热力图跟着块走。
    ///
    /// 这就是用户要的效果：不是"在 ragdoll 后面贴一张图"，而是**每块自带一层**。
    fn paint_piece_heat(&self, painter: &Painter, view: Rect, ch: HeatChannel) {
        for i in 0..self.sim.body.pieces.len() {
            let p = &self.sim.body.pieces[i];
            if p.deleted {
                continue;
            }
            let Some(h) = p.heat else {
                continue;
            };
            let v = match ch {
                HeatChannel::Perfusion => h[0],
                HeatChannel::Oxygen => h[1],
                HeatChannel::Temperature => h[2],
                HeatChannel::Damage => h[3],
            };
            let poly = self.sim.piece_polygon(PieceId(i as u32));
            if poly.len() < 3 {
                continue;
            }
            let pts: Vec<Pos2> = poly.iter().map(|q| self.cam.to_screen(*q, view)).collect();
            painter.add(Shape::convex_polygon(
                pts,
                c32a(ch.color(ch.normalize(v)), 150),
                Stroke::NONE,
            ));
        }
    }

    fn paint_body(&self, painter: &Painter, view: Rect) {
        for i in 0..self.sim.body.pieces.len() {
            self.paint_piece(painter, view, PieceId(i as u32));
        }
    }

    fn paint_piece(&self, painter: &Painter, view: Rect, id: PieceId) {
        let piece = &self.sim.body.pieces[id.index()];
        if piece.deleted {
            return;
        }
        let world_poly = self.sim.piece_polygon(id);
        if world_poly.len() < 3 {
            return;
        }
        let alpha = if piece.is_frozen() { 120 } else { 255 };

        // 道具：没有解剖层，一个颜色到底
        if piece.part == anatomize_core::PartId::NONE {
            let c = self
                .sim
                .item_of(id)
                .map(|d| d.rgba())
                .unwrap_or([140, 140, 145, 255]);
            self.fill(painter, view, &world_poly, c, alpha);
            let mut closed: Vec<Pos2> = world_poly
                .iter()
                .map(|p| self.cam.to_screen(*p, view))
                .collect();
            closed.push(closed[0]);
            painter.add(Shape::line(
                closed,
                Stroke::new(1.2_f32, c32a([20, 16, 14, 255], 160)),
            ));
            return;
        }

        let part = &self.sim.plan.parts[piece.part.index()];
        let prof = anatomize_cut::SectionProfile::for_part(part.bone, &part.polygon);

        // 层厚有**最小屏幕宽度**。
        //
        // 真实的皮肤只有 2.2mm，260 px/m 下是 0.57 像素——直接按物理值画，
        // 抗锯齿会把它整个吃掉，整个身体就只剩肌肉和骨。解剖图里皮肤也总是
        // 画粗一点的，这不是妥协，是"让人读得出来"。
        let min_px = |m: f32, floor: f32| -> f32 {
            let px = self.cam.px(m);
            if px >= floor {
                m
            } else {
                self.cam.meters(floor)
            }
        };

        let mut cur = world_poly.clone();
        // 皮肤
        self.fill(painter, view, &cur, layer_color(Layer::Skin), alpha);
        // 脂肪
        let skin = min_px(prof.skin_cm * 0.01, 1.6);
        if let Some(p) = inset_convex(&cur, skin) {
            self.fill(painter, view, &p, layer_color(Layer::Fat), alpha);
            cur = p;
        } else {
            return;
        }
        // 肌肉
        let fat = min_px(prof.fat_cm * 0.01, 2.0);
        if let Some(p) = inset_convex(&cur, fat) {
            self.fill(painter, view, &p, layer_color(Layer::Muscle), alpha);
            cur = p;
        } else {
            return;
        }
        // 骨：用圆。真实的骨截面是圆/椭圆，用内缩多边形画出来是个方块，不像。
        if prof.bone_cm > 0.02 {
            let c = polygon_centroid(&cur);
            let s = self.cam.to_screen(c, view);
            painter.circle_filled(
                s,
                self.cam.px(prof.bone_cm * 0.01).max(2.0),
                c32a(layer_color(Layer::Bone), alpha),
            );
        }

        // 描边：半透明，不然会把断面盖住（M6 踩过这个坑）
        let pts: Vec<Pos2> = world_poly
            .iter()
            .map(|p| self.cam.to_screen(*p, view))
            .collect();
        let mut closed = pts.clone();
        closed.push(pts[0]);
        painter.add(Shape::line(
            closed,
            Stroke::new(1.0_f32, c32a([10, 8, 12, 255], 110)),
        ));
    }

    fn fill(&self, painter: &Painter, view: Rect, poly: &[Vec2], c: [u8; 4], alpha: u8) {
        let pts: Vec<Pos2> = poly.iter().map(|p| self.cam.to_screen(*p, view)).collect();
        if pts.len() < 3 {
            return;
        }
        painter.add(Shape::convex_polygon(pts, c32a(c, alpha), Stroke::NONE));
    }

    /// 调试：血管折线。看"这一刀到底切到哪根血管"时最有用。
    fn paint_vessels(&self, painter: &Painter, view: Rect) {
        let Some(origin) = self.sim.body_origin_world() else {
            return;
        };
        let rot = self.sim.body_rotation();
        let (sin, cos) = rot.sin_cos();
        let to_world = |p: Vec2| {
            let m = p * 0.01;
            origin + Vec2::new(m.x * cos - m.y * sin, m.x * sin + m.y * cos)
        };
        for v in &self.sim.plan.vessels {
            let pts: Vec<Vec2> = v.path.iter().map(|p| to_world(*p)).collect();
            for w in pts.windows(2) {
                let a = self.cam.to_screen(w[0], view);
                let b = self.cam.to_screen(w[1], view);
                let c = if v.arterial {
                    [200, 70, 80, 190]
                } else {
                    [80, 110, 190, 190]
                };
                painter.line_segment([a, b], Stroke::new(1.5_f32, c32(c)));
            }
        }
    }

    fn paint_joints(&self, painter: &Painter, view: Rect) {
        for j in &self.sim.body.joints {
            // 连着已删除块的关节不画——它的锚点已经失效了
            if self.sim.body.pieces[j.a.index()].deleted
                || self.sim.body.pieces[j.b.index()].deleted
            {
                continue;
            }
            let (pa, _) = self.sim.joint_world_anchors(j);
            let s = self.cam.to_screen(pa, view);
            let c = match j.health.state {
                anatomize_body::JointState::Intact => [90, 200, 130, 255],
                anatomize_body::JointState::Sprained => [230, 210, 110, 255],
                anatomize_body::JointState::Subluxed => [240, 160, 80, 255],
                anatomize_body::JointState::Dislocated => [230, 90, 90, 255],
                anatomize_body::JointState::Severed => [110, 100, 120, 255],
            };
            painter.circle_stroke(s, 4.0, Stroke::new(1.5_f32, c32(c)));
        }
    }
}
