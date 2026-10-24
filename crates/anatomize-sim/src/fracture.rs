//! 碎片：把一刀变成两块刚体。
//!
//! # 为什么这一层不能省
//!
//! 前面五个里程碑都在算"切开之后身体会发生什么"——断供、出血、休克。
//! 但**身体本身没被切开**：`Sim::cut` 只写组织场，几何还是完整的一条腿。
//! 玩家看到的是"腿上多了条红线，然后人开始失血"，不是"腿断成两截"。
//! M6 补的就是这一刀。
//!
//! # 三个必须做对的地方
//!
//! ## 1. 速度要按质心传递，不能直接抄
//!
//! 切开一块旋转中的大腿，两个碎片的质心速度不一样：`v = v_cm + ω × r`。
//! 直接抄父块速度的话，快速旋转时切出来的两半会同时朝一个方向平移，
//! 看起来像"整条腿平移了一下才分开"。
//!
//! ## 2. 关节要跟着锚点走
//!
//! 大腿切两半，髋关节的锚点在上半块、膝关节的锚点在下半块。两个关节分别
//! 挂到不同的块上，于是上半段还连着髋、下半段还连着膝——**这才是"切开"
//! 而不是"断开"**。如果偷懒让两个关节都留在同一块，另一块就会直接飞走。
//!
//! ## 3. 删刚体会连带删关节
//!
//! `RigidBodySet::remove` 会把挂在这个刚体上的所有 `ImpulseJoint` 一起删掉。
//! 所以重挂必须"先记信息、再删、再建"，不能边删边查。
//!
//! # 冻结
//!
//! 碎片是预算制：默认 32 块，静止 10 秒后冻结。冻结 = 从物理世界摘掉，
//! 只留位姿给渲染。1000 个碎片的场景里，真正在算的永远只有几十个——
//! 这是验收标准 7（1080p / 60fps）能过的唯一原因。

use anatomize_core::{PartId, Vec2};
use anatomize_cut::{CutSegment, Line, split_part};
use rapier2d::prelude::*;

use crate::{CM, JointState, Piece, PieceId, RVec2, Sim, rv};

/// 碎片预算与冻结参数。
#[derive(Debug, Clone, Copy)]
pub struct FractureConfig {
    /// 最多允许存在多少块（不含冻结的）。
    pub max_live_pieces: usize,
    /// 一块碎片静止多久之后冻结（秒）。
    pub freeze_after_s: f32,
    /// 判定"静止"的线速度阈值（m/s）。
    pub still_linvel: f32,
    /// 判定"静止"的角速度阈值（rad/s）。
    pub still_angvel: f32,
    /// 速度钳制（m/s）。超过这个值的碎片会被按住——不是为了物理正确，
    /// 是为了"不会有东西以 300 m/s 飞出屏幕"（验收标准 8）。
    pub max_speed: f32,
    /// 一刀最多能切出几块。防止一条极长的刀线穿过整个身体时瞬间爆掉。
    pub max_pieces_per_cut: usize,
}

impl Default for FractureConfig {
    fn default() -> Self {
        Self {
            max_live_pieces: 32,
            freeze_after_s: 10.0,
            still_linvel: 0.06,
            still_angvel: 0.25,
            max_speed: 60.0,
            max_pieces_per_cut: 4,
        }
    }
}

/// 一刀切完的几何后果。
#[derive(Debug, Clone, Default)]
pub struct SliceReport {
    /// 真正被切开的部件名。
    pub cut_parts: Vec<String>,
    /// 新增的块数。
    pub new_pieces: usize,
    /// 因为预算不足被拒绝的部件。
    pub skipped: Vec<String>,
    /// 重挂了几条关节。
    pub rewired_joints: usize,
}

/// 点是否在凸多边形内（含边界）。
fn point_in_convex(poly: &[Vec2], p: Vec2) -> bool {
    let n = poly.len();
    if n < 3 {
        return false;
    }
    for i in 0..n {
        let a = poly[i];
        let b = poly[(i + 1) % n];
        // 逆时针多边形内部在左侧
        if (b - a).perp_dot(p - a) < -1e-4 {
            return false;
        }
    }
    true
}

/// 关节被切开前的快照。删刚体之前必须先存下来。
struct JointSnapshot {
    idx: usize,
    a: PieceId,
    b: PieceId,
    anchor_a: Vec2,
    anchor_b: Vec2,
    rest_limits: (f32, f32),
    rom: f32,
    tether: Option<ImpulseJointHandle>,
    tether_rest: f32,
    state: JointState,
}

impl Sim {
    /// 切开一个部件：几何分割 + 换刚体 + 重挂关节。
    ///
    /// `cut` 在**世界米**坐标系里。内部对每一块做"世界 → 块局部"的变换，
    /// 而不是用 `Part::offset` 反推——`offset` 是装配时的静态值，身体在重力下
    /// 会下垂，`offset` 早就不等于"部件中心现在在哪儿"了。踩过这个坑：
    /// 切大腿时刀线算到了 y=-13（当时的实际位置）却按 y=-27（静态偏移）去切，
    /// 结果一块都没切中，而且**静默**返回 0 块。
    ///
    /// 这个函数只管几何；组织场那边是 [`Sim::cut`] 的事，两个一起调才是完整的一刀。
    pub fn slice(&mut self, cut: &CutSegment) -> SliceReport {
        let mut report = SliceReport::default();
        if cut.length() < 1e-6 {
            return report;
        }
        self.slices += 1;

        // 候选：所有还没冻结的块。冻结的块是背景，不该再被切。
        let candidates: Vec<PieceId> = self
            .body
            .pieces
            .iter()
            .enumerate()
            .filter(|(_, p)| !p.is_frozen())
            .map(|(i, _)| PieceId(i as u32))
            .collect();

        for pid in candidates {
            if report.new_pieces >= self.fracture.max_pieces_per_cut {
                break;
            }
            if self.live_pieces() >= self.fracture.max_live_pieces {
                break;
            }
            if self.slice_piece(pid, cut, &mut report) {
                report.new_pieces += 1;
            }
        }
        report
    }

    /// 用**身体局部厘米**的刀线切（`Sim::cut` 用的是同一套坐标）。
    ///
    /// 内部靠 `body_origin_world()` 把它换成世界米。身体局部坐标系的旋转取骨盆
    /// 的朝向——ragdoll 会倒，但"身体的坐标系"是跟着骨盆转的。
    pub fn slice_body_local(&mut self, cut: &CutSegment) -> SliceReport {
        let Some(origin) = self.body_origin_world() else {
            return SliceReport::default();
        };
        let rot = self
            .plan
            .parts
            .iter()
            .position(|p| p.name == "pelvis")
            .map(|i| self.piece_pose(self.body.primary[i]).1)
            .unwrap_or(0.0);
        let (sin, cos) = rot.sin_cos();
        let to_world = |p: Vec2| {
            let m = p * CM;
            origin + Vec2::new(m.x * cos - m.y * sin, m.x * sin + m.y * cos)
        };
        let world = CutSegment {
            a: to_world(cut.a),
            b: to_world(cut.b),
            width: cut.width * CM,
            speed: cut.speed,
        };
        self.slice(&world)
    }

    /// 切一块。成功返回 true（新增了一块）。
    fn slice_piece(&mut self, pid: PieceId, cut: &CutSegment, report: &mut SliceReport) -> bool {
        let piece = &self.body.pieces[pid.index()];
        if piece.is_frozen() || piece.polygon.len() < 3 {
            return false;
        }

        // 世界米 → 部件局部厘米。块局部 = 相对块质心、部件轴向的向量；
        // 加上 `centroid` 就是部件局部。这一步每块都不同，不能提到循环外。
        let (pos, rot) = self.piece_pose(pid);
        let (sin, cos) = rot.sin_cos();
        let centroid = piece.centroid;
        let to_local = |p: Vec2| {
            let d = p - pos;
            let lm = Vec2::new(d.x * cos + d.y * sin, -d.x * sin + d.y * cos);
            lm * 100.0 + centroid
        };
        let a = to_local(cut.a);
        let b = to_local(cut.b);
        let Some(local_line) = Line::through(a, b) else {
            return false;
        };

        // 刀是**线段**不是直线。`Line` 是无限长的，直接拿它切会把
        // "从左腿划到左腿"的一刀同时切中右腿——因为它只在 x 上限定范围，
        // 无限直线两边都穿。所以先做一次线段 × 包围盒的粗筛。
        let (t0, t1) = (0.0f32, (b - a).length());
        let mut lo = f32::INFINITY;
        let mut hi = f32::NEG_INFINITY;
        for v in &piece.polygon {
            let t = local_line.project(*v);
            lo = lo.min(t);
            hi = hi.max(t);
        }
        if hi.min(t1) - lo.max(t0) <= 1e-6 {
            return false;
        }

        let frags = split_part(&piece.polygon, piece.mass, &local_line);
        if frags.len() != 2 {
            return false;
        }

        // --- 1. 快照：旧刚体的位姿、速度，以及挂在它上面的关节 ---
        let old_handle = piece.body;
        let (old_pos, old_rot, old_linvel, old_angvel) = {
            let rb = &self.physics.bodies[old_handle];
            let p = *rb.position();
            (p.translation, p.rotation.angle(), rb.linvel(), rb.angvel())
        };
        let part = piece.part;
        let old_centroid = piece.centroid;

        let mut snaps: Vec<JointSnapshot> = Vec::new();
        for (idx, j) in self.body.joints.iter().enumerate() {
            if j.a != pid && j.b != pid {
                continue;
            }
            snaps.push(JointSnapshot {
                idx,
                a: j.a,
                b: j.b,
                anchor_a: j.anchor_a,
                anchor_b: j.anchor_b,
                rest_limits: j.rest_limits,
                rom: j.health.rom_scale,
                tether: j.tether,
                tether_rest: j.tether_rest,
                state: j.health.state,
            });
        }

        // --- 2. 拆掉旧刚体（连带它的碰撞体和关节） ---
        self.physics.bodies.remove(
            old_handle,
            &mut self.physics.islands,
            &mut self.physics.colliders,
            &mut self.physics.impulse_joints,
            &mut self.physics.multibody_joints,
            &mut self.physics.soft_bodies,
            true,
        );

        // --- 3. 建两块新刚体 ---
        let mut new_ids: Vec<PieceId> = Vec::with_capacity(2);
        for frag in &frags {
            // 世界位置 = 部件位姿 × 部件局部质心
            let local_m = rv(frag.centroid * CM);
            let world = Rot2::from_angle(old_rot) * local_m + old_pos;
            // 速度按质心传递：v = v_cm + ω × r
            let r = world - old_pos;
            let v = old_linvel + RVec2::new(-old_angvel * r.y, old_angvel * r.x);

            let rb = RigidBodyBuilder::dynamic()
                .translation(world)
                .rotation(old_rot)
                .linvel(v)
                .angvel(old_angvel)
                .linear_damping(0.15)
                .angular_damping(0.5)
                .build();
            let handle = self.physics.bodies.insert(rb);

            let pts: Vec<RVec2> = frag
                .polygon
                .iter()
                .map(|v| rv((*v - frag.centroid) * CM))
                .collect();
            let area_m2 = (frag.area * CM * CM).max(1e-6);
            let collider = ColliderBuilder::convex_hull(&pts)
                .unwrap_or_else(|| ColliderBuilder::ball(0.01))
                .density(frag.mass / area_m2)
                .friction(0.85)
                .restitution(0.02)
                .build();
            let collider = self.physics.colliders.insert_with_parent(
                collider,
                handle,
                &mut self.physics.bodies,
            );

            let id = if new_ids.is_empty() {
                // 复用原槽位，这样没被切到的关节不用改索引
                let p = &mut self.body.pieces[pid.index()];
                p.body = handle;
                p.collider = collider;
                p.polygon = frag.polygon.clone();
                p.centroid = frag.centroid;
                p.mass = frag.mass;
                p.still_s = 0.0;
                pid
            } else {
                let id = PieceId(self.body.pieces.len() as u32);
                self.body.pieces.push(Piece {
                    part,
                    body: handle,
                    collider,
                    polygon: frag.polygon.clone(),
                    centroid: frag.centroid,
                    mass: frag.mass,
                    still_s: 0.0,
                    frozen_pose: None,
                });
                id
            };
            new_ids.push(id);
        }

        // --- 4. 代表块 = 含原部件质心的那一块 ---
        let primary = new_ids
            .iter()
            .copied()
            .find(|id| {
                let p = &self.body.pieces[id.index()];
                point_in_convex(&p.polygon, old_centroid)
            })
            .unwrap_or(new_ids[0]);
        self.body.primary[part.index()] = primary;
        // 主块换了刚体，`PartInstance` 也要跟着换
        self.body.parts[part.index()].body = self.body.pieces[primary.index()].body;
        self.body.parts[part.index()].collider = self.body.pieces[primary.index()].collider;

        // --- 5. 重挂关节：锚点落在哪块就挂哪块 ---
        for s in snaps {
            let side_a = self.resolve_anchor_piece(s.a, pid, &new_ids, s.anchor_a);
            let side_b = self.resolve_anchor_piece(s.b, pid, &new_ids, s.anchor_b);
            self.rebuild_joint(s, side_a, side_b);
            report.rewired_joints += 1;
        }

        report
            .cut_parts
            .push(self.plan.parts[part.index()].name.clone());
        true
    }

    /// 锚点原来在 `owner` 上，`owner` 被切成两块之后，它该跟哪块走。
    fn resolve_anchor_piece(
        &self,
        owner: PieceId,
        split: PieceId,
        halves: &[PieceId],
        anchor_cm: Vec2,
    ) -> PieceId {
        if owner != split {
            return owner;
        }
        for &h in halves {
            if point_in_convex(&self.body.pieces[h.index()].polygon, anchor_cm) {
                return h;
            }
        }
        // 锚点正好压在刀线上（数值上两侧都不算"在内部"）：跟最近的那块。
        let mut best = halves[0];
        let mut best_d = f32::INFINITY;
        for &h in halves {
            let c = self.body.pieces[h.index()].centroid;
            let d = (c - anchor_cm).length();
            if d < best_d {
                best_d = d;
                best = h;
            }
        }
        best
    }

    /// 用快照重建一条关节（旧的 handle 已经随刚体一起被删了）。
    fn rebuild_joint(&mut self, s: JointSnapshot, a: PieceId, b: PieceId) {
        let ha = self.body.pieces[a.index()].body;
        let hb = self.body.pieces[b.index()].body;
        let ca = self.body.pieces[a.index()].centroid;
        let cb = self.body.pieces[b.index()].centroid;
        // 锚点是部件局部厘米，块局部 = 部件局部 − 块质心
        let la = rv((s.anchor_a - ca) * CM);
        let lb = rv((s.anchor_b - cb) * CM);

        let (handle, tether) = match s.state {
            JointState::Severed => (ImpulseJointHandle::invalid(), None),
            JointState::Dislocated => {
                let len = s.tether_rest + self.damage.tether_len_cm * CM;
                let rope = RopeJointBuilder::new(len)
                    .local_anchor1(la)
                    .local_anchor2(lb)
                    .contacts_enabled(false)
                    .build();
                (
                    ImpulseJointHandle::invalid(),
                    Some(self.physics.impulse_joints.insert(ha, hb, rope, true)),
                )
            }
            _ => {
                let j = RevoluteJointBuilder::new()
                    .local_anchor1(la)
                    .local_anchor2(lb)
                    .limits([s.rest_limits.0 * s.rom, s.rest_limits.1 * s.rom])
                    .contacts_enabled(false)
                    .build();
                (
                    self.physics.impulse_joints.insert(ha, hb, j, true),
                    s.tether,
                )
            }
        };

        {
            let inst = &mut self.body.joints[s.idx];
            inst.a = a;
            inst.b = b;
            inst.handle = handle;
            inst.tether = tether;
        }
        // 绳长跟着新锚点重算：切完之后两锚点的世界距离变了
        let (pa, pb) = self.joint_world_anchors(&self.body.joints[s.idx]);
        self.body.joints[s.idx].tether_rest = (pa - pb).length().max(1e-4);
    }

    /// 推进冻结计时，把静止够久的碎片摘出物理世界。
    ///
    /// 返回本 tick 冻结了几块。
    pub fn update_freeze(&mut self) -> usize {
        let cfg = self.fracture;
        let mut frozen = 0;
        for i in 0..self.body.pieces.len() {
            if self.body.pieces[i].is_frozen() {
                continue;
            }
            let h = self.body.pieces[i].body;
            let (lv, av) = {
                let rb = &self.physics.bodies[h];
                (rb.linvel().length(), rb.angvel().abs())
            };
            // 还挂着关节的块不能冻结：摘掉刚体会连带删掉关节，之后
            // `joint_load` 去读一个已经不存在的 handle 就直接 panic。
            // 吊在身上的肢体本来也不该冻结——玩家随时可能切它。
            let id = PieceId(i as u32);
            let attached = self
                .body
                .joints
                .iter()
                .any(|j| (j.a == id || j.b == id) && j.health.state.is_connected());
            let still = lv < cfg.still_linvel && av < cfg.still_angvel && !attached;
            let p = &mut self.body.pieces[i];
            p.still_s = if still { p.still_s + crate::DT } else { 0.0 };
            if p.still_s >= cfg.freeze_after_s {
                let rb = &self.physics.bodies[h];
                let pos = *rb.position();
                let pose = (
                    Vec2::new(pos.translation.x, pos.translation.y),
                    pos.rotation.angle(),
                );
                self.body.pieces[i].frozen_pose = Some(pose);
                self.physics.bodies.remove(
                    h,
                    &mut self.physics.islands,
                    &mut self.physics.colliders,
                    &mut self.physics.impulse_joints,
                    &mut self.physics.multibody_joints,
                    &mut self.physics.soft_bodies,
                    true,
                );
                frozen += 1;
            }
        }
        frozen
    }

    /// 钳制所有碎片的速度。NaN 直接归零。
    ///
    /// 这不是物理，是护栏：数值爆掉的碎片会以几百 m/s 飞出去，然后
    /// 下一次碰撞把它弹回来砸穿整个场景。验收标准 8 要求"无速度 > 100 m/s"。
    pub fn clamp_velocities(&mut self) -> usize {
        let max = self.fracture.max_speed;
        let mut clamped = 0;
        for p in &self.body.pieces {
            if p.is_frozen() {
                continue;
            }
            let rb = &mut self.physics.bodies[p.body];
            let mut v = rb.linvel();
            let mut w = rb.angvel();
            let mut dirty = false;

            if !v.x.is_finite() || !v.y.is_finite() {
                v = RVec2::ZERO;
                dirty = true;
            }
            if !w.is_finite() {
                w = 0.0;
                dirty = true;
            }
            let speed = v.length();
            if speed > max {
                v *= max / speed;
                dirty = true;
            }
            // 角速度也用同一个上限（rad/s）。半径 20cm 的碎片转 60 rad/s
            // 边缘线速度已经 12 m/s，够快了。
            if w.abs() > max {
                w = max * w.signum();
                dirty = true;
            }
            if dirty {
                rb.set_linvel(v, true);
                rb.set_angvel(w, true);
                clamped += 1;
            }
        }
        clamped
    }

    /// 一块碎片在世界坐标下的多边形顶点（米）。
    pub fn piece_polygon(&self, id: PieceId) -> Vec<Vec2> {
        let p = &self.body.pieces[id.index()];
        let (pos, rot) = self.piece_pose(id);
        let r = Rot2::from_angle(rot);
        p.polygon
            .iter()
            .map(|v| {
                let w = r * rv((*v - p.centroid) * CM) + rv(pos);
                Vec2::new(w.x, w.y)
            })
            .collect()
    }

    /// 一块碎片的世界位姿（米 / 弧度）。冻结的读快照。
    pub fn piece_pose(&self, id: PieceId) -> (Vec2, f32) {
        let p = &self.body.pieces[id.index()];
        if let Some(pose) = p.frozen_pose {
            return pose;
        }
        let rb = &self.physics.bodies[p.body];
        let pos = *rb.position();
        (
            Vec2::new(pos.translation.x, pos.translation.y),
            pos.rotation.angle(),
        )
    }

    /// 一块碎片的世界线速度（m/s）。冻结的返回零。
    pub fn piece_velocity(&self, id: PieceId) -> Vec2 {
        let p = &self.body.pieces[id.index()];
        if p.is_frozen() {
            return Vec2::ZERO;
        }
        let v = self.physics.bodies[p.body].linvel();
        Vec2::new(v.x, v.y)
    }

    /// 部件的主块。
    pub fn primary_piece(&self, part: PartId) -> PieceId {
        self.body.primary[part.index()]
    }

    /// 还没冻结的块数。
    pub fn live_pieces(&self) -> usize {
        self.body.pieces.iter().filter(|p| !p.is_frozen()).count()
    }

    /// 一块碎片属于哪个部件名（渲染与调试用）。
    pub fn piece_part_name(&self, id: PieceId) -> &str {
        &self.plan.parts[self.body.pieces[id.index()].part.index()].name
    }
}
