//! 回溯：把世界退回几秒前。
//!
//! # 为什么沙盒需要这个
//!
//! 这个游戏的核心动词是"切"。切是一个**不可逆**的操作：一刀下去，血管断了、
//! 下游开始坏死、人开始失血。但玩家在学会"往哪切"之前会切错很多次。
//! 没有回溯的话，每次切错都要重开一局——那不是"残酷"，那是"操作不友好"。
//!
//! 5 秒是一个刻意选的长度：够退回"刚才那一刀"，又不够退回"半分钟前的决定"。
//! 它保护的是手滑，不是后悔。
//!
//! # 存什么
//!
//! 全存的话 5 秒就是几百 MB。这里靠一个观察把体积砍掉一个数量级：
//!
//! **组织场里的压力不是状态，是解。**
//!
//! | 通道 | 性质 | 存？ |
//! |---|---|---|
//! | `k0` / `stump` / `wound` / `clamped` / `inlet` | 切割造成的**永久**改变 | 存 |
//! | `damage` / `pooled` | **累积**量，不能重算 | 存 |
//! | `o2` / `temp` | 慢变量，时间常数几十秒 | 存 |
//! | `pressure` / `bed` / `conductance` / `c_art` / `c_ven` / `perfusion` | 由上面那些**解出来**的 | 不存 |
//!
//! 回滚之后调一次 `warmup()`，压力场和灌注场就回来了——它们本来就只依赖
//! `k0` + `wound` + 当前的 MAP。省下的正是最大的一块。
//!
//! # 采样
//!
//! 每 0.25 秒存一帧（60Hz 下每 15 帧）。5 秒 = 20 帧。
//! 回滚粒度 250ms，对手滑来说足够——人按下去的那一下精度本来也就这样。

use std::collections::VecDeque;

use anatomize_core::{DT, Vec2};
use anatomize_physio::PhysioBus;

use crate::save::{JointSave, PieceSave};
use crate::{PieceId, Sim};

/// 组织场的可逆/不可逆拆分。
#[derive(Debug, Clone)]
pub struct TissueSnapshot {
    /// 基础血管床电导。断供会把它清零，所以必须存。
    pub k0: Vec<f32>,
    /// 断端电导。切割写入。
    pub stump: Vec<f32>,
    pub wound: Vec<bool>,
    pub clamped: Vec<bool>,
    pub inlet: Vec<bool>,
    /// 累积量。
    pub damage: Vec<f32>,
    pub pooled: Vec<f32>,
    /// 慢变量。
    pub o2: Vec<f32>,
    pub temp: Vec<f32>,
}

impl TissueSnapshot {
    pub fn bytes(&self) -> usize {
        let n = self.k0.len();
        n * (4 * 5) + n * 3 + n
    }
}

/// 一帧完整状态。
#[derive(Debug, Clone)]
/// 一具生物在快照里的状态。
pub struct CreatureSnapshot {
    pub primary: Vec<u32>,
    pub bus: PhysioBus,
    pub ambient_c: f32,
    pub tissue_metab_base: f32,
    pub tissue: Option<TissueSnapshot>,
}

#[derive(Debug, Clone)]
pub struct Snapshot {
    pub tick: u64,
    pub pieces: Vec<PieceSave>,
    pub joints: Vec<JointSave>,
    /// 玩家连接。快照不带的话，回滚 5 秒会把刚搭好的机器拆散。
    pub conns: Vec<crate::save::ConnSave>,
    /// 所有生物（每具一份生理 + 组织场）。
    pub creatures: Vec<CreatureSnapshot>,
    pub slices: u32,
    pub injuries: Vec<(anatomize_core::JointId, crate::JointState, f32)>,
}

impl Snapshot {
    pub fn bytes(&self) -> usize {
        let tissue: usize = self
            .creatures
            .iter()
            .map(|c| c.tissue.as_ref().map_or(0, |t| t.bytes()))
            .sum();
        let pieces: usize = self.pieces.iter().map(|p| p.polygon.len() * 8 + 64).sum();
        tissue
            + pieces
            + self.joints.len() * 96
            + self.conns.len() * 64
            + self.creatures.len() * 128
            + 256
    }
}

/// 环形缓冲。
pub struct Rewind {
    frames: VecDeque<Snapshot>,
    capacity: usize,
    /// 每隔多少 tick 存一帧。
    pub stride: u64,
}

impl Rewind {
    /// `seconds` 秒、`stride` 个 tick 一帧。
    pub fn new(seconds: f32, stride: u64) -> Self {
        let stride = stride.max(1);
        let capacity = ((seconds / (stride as f32 * DT)).round() as usize).max(1);
        Self {
            frames: VecDeque::with_capacity(capacity),
            capacity,
            stride,
        }
    }

    /// 默认：5 秒，每 15 tick（0.25s）一帧。
    pub fn default_5s() -> Self {
        Self::new(5.0, 15)
    }

    pub fn len(&self) -> usize {
        self.frames.len()
    }

    pub fn is_empty(&self) -> bool {
        self.frames.is_empty()
    }

    pub fn capacity(&self) -> usize {
        self.capacity
    }

    /// 缓冲里存了多长时间（秒）。
    pub fn span_s(&self) -> f32 {
        self.frames.len() as f32 * self.stride as f32 * DT
    }

    pub fn bytes(&self) -> usize {
        self.frames.iter().map(|s| s.bytes()).sum()
    }

    pub fn clear(&mut self) {
        self.frames.clear();
    }

    /// 塞一帧进去。满了就挤掉最老的。
    pub fn push(&mut self, snap: Snapshot) {
        if self.frames.len() == self.capacity {
            self.frames.pop_front();
        }
        self.frames.push_back(snap);
    }

    /// 这一 tick 该不该存。
    pub fn due(&self, tick: u64) -> bool {
        tick.is_multiple_of(self.stride)
    }

    /// 退回到 `seconds` 秒前。返回实际退了多少秒。
    ///
    /// 找不到够老的帧就退到缓冲里最老的那一帧。
    pub fn rewind(&mut self, sim: &mut Sim, seconds: f32) -> Option<f32> {
        if self.frames.len() < 2 {
            return None;
        }
        let want = (seconds / (self.stride as f32 * DT)).round() as usize;
        let want = want.clamp(1, self.frames.len() - 1);
        let idx = self.frames.len() - 1 - want;
        let snap = self.frames[idx].clone();
        let back = (sim.tick.0.saturating_sub(snap.tick)) as f32 * DT;

        sim.restore(&snap);
        // 回滚之后，"未来"那几帧就作废了——不然再按一次回溯会退到一个
        // 已经不存在的分支上。
        self.frames.truncate(idx + 1);
        Some(back)
    }
}

impl Sim {
    /// 该存就存一帧。
    ///
    /// 拆成"判断 → 拍 → 塞"三步而不是一个 `Rewind::capture(&self)`，
    /// 是因为后者要同时可变借用 `self.rewind` 和不可变借用 `self`。
    pub fn capture_rewind(&mut self) {
        if !self.rewind.due(self.tick.0) {
            return;
        }
        let snap = self.snapshot();
        self.rewind.push(snap);
    }

    /// 拍一帧回溯快照。
    pub fn snapshot(&self) -> Snapshot {
        let mut pieces = Vec::with_capacity(self.body.pieces.len());
        for i in 0..self.body.pieces.len() {
            let p = &self.body.pieces[i];
            let (pos, rot) = self.piece_pose(PieceId(i as u32));
            // 冻结和删除的块都没有刚体
            let (linvel, angvel) = if p.is_frozen() || p.deleted {
                (Vec2::ZERO, 0.0)
            } else {
                match self.physics.bodies.get(p.body) {
                    Some(rb) => {
                        let v = rb.linvel();
                        (Vec2::new(v.x, v.y), rb.angvel())
                    }
                    None => (Vec2::ZERO, 0.0),
                }
            };
            pieces.push(PieceSave {
                creature: p.creature,
                part: p.part,
                polygon: p.polygon.clone(),
                centroid: p.centroid,
                mass: p.mass,
                pos,
                rot,
                linvel,
                angvel,
                item: p.item,
                frozen: p.is_frozen(),
            });
        }

        let joints = self
            .body
            .joints
            .iter()
            .map(|j| JointSave {
                creature: j.creature,
                a: j.a.0,
                b: j.b.0,
                anchor_a: j.anchor_a,
                anchor_b: j.anchor_b,
                rest_limits: j.rest_limits,
                tether_rest: j.tether_rest,
                health: j.health,
                cuttable: j.cuttable,
            })
            .collect();

        let creatures = self
            .creatures
            .iter()
            .map(|c| CreatureSnapshot {
                primary: c.primary.iter().map(|p| p.0).collect(),
                bus: c.physio.bus,
                ambient_c: c.ambient_c,
                tissue_metab_base: c.tissue_metab_base,
                tissue: c.tissue.as_ref().map(|t| TissueSnapshot {
                    k0: t.field.k0.clone(),
                    stump: t.field.stump.clone(),
                    wound: t.field.wound.clone(),
                    clamped: t.field.clamped.clone(),
                    inlet: t.field.inlet.clone(),
                    damage: t.field.damage.clone(),
                    pooled: t.field.pooled.clone(),
                    o2: t.field.o2.clone(),
                    temp: t.field.temp.clone(),
                }),
            })
            .collect();

        Snapshot {
            conns: self
                .conns
                .iter()
                .filter(|c| !c.broken)
                .map(|c| crate::save::ConnSave {
                    kind: c.kind,
                    a: c.a.0,
                    b: c.b.map(|b| b.0),
                    local_a: c.local_a,
                    local_b: c.local_b,
                    rest: c.rest,
                    motor: c.motor,
                    dir: c.dir,
                })
                .collect(),
            tick: self.tick.0,
            pieces,
            joints,
            creatures,
            slices: self.slices,
            injuries: self.injuries.clone(),
        }
    }

    /// 恢复到一帧快照。
    ///
    /// 和 [`Sim::load`] 的差别：**不重建 `plan`**，只换块与关节。
    /// 回溯是同一个世界往后退，不是读一个新档。
    pub fn restore(&mut self, snap: &Snapshot) {
        // 1. 清掉现有刚体（连带碰撞体与关节）
        let handles: Vec<_> = self.body.pieces.iter().map(|p| p.body).collect();
        for h in handles {
            self.physics.bodies.remove(
                h,
                &mut self.physics.islands,
                &mut self.physics.colliders,
                &mut self.physics.impulse_joints,
                &mut self.physics.multibody_joints,
                &mut self.physics.soft_bodies,
                true,
            );
        }
        self.body.pieces.clear();
        self.body.joints.clear();
        // 玩家连接也要清：它们指着刚被删掉的刚体
        for c in std::mem::take(&mut self.conns) {
            if let Some(h) = c.anchor_body {
                self.physics.bodies.remove(
                    h,
                    &mut self.physics.islands,
                    &mut self.physics.colliders,
                    &mut self.physics.impulse_joints,
                    &mut self.physics.multibody_joints,
                    &mut self.physics.soft_bodies,
                    true,
                );
            }
        }
        self.release_grab();

        // 2. 按快照重建块
        for ps in &snap.pieces {
            if ps.frozen {
                self.body.pieces.push(crate::Piece {
                    part: ps.part,
                    body: rapier2d::prelude::RigidBodyHandle::invalid(),
                    collider: rapier2d::prelude::ColliderHandle::invalid(),
                    polygon: ps.polygon.clone(),
                    centroid: ps.centroid,
                    mass: ps.mass,
                    still_s: 0.0,
                    frozen_pose: Some((ps.pos, ps.rot)),
                    item: ps.item,
                    heat: None,
                    creature: ps.creature,
                    deleted: false,
                });
                continue;
            }
            let rb = rapier2d::prelude::RigidBodyBuilder::dynamic()
                .translation(rapier2d::math::Vec2::new(ps.pos.x, ps.pos.y))
                .rotation(ps.rot)
                .linvel(rapier2d::math::Vec2::new(ps.linvel.x, ps.linvel.y))
                .angvel(ps.angvel)
                .linear_damping(0.15)
                .angular_damping(0.5)
                .build();
            let handle = self.physics.bodies.insert(rb);
            let pts: Vec<rapier2d::math::Vec2> = ps
                .polygon
                .iter()
                .map(|v| {
                    rapier2d::math::Vec2::new(
                        (v.x - ps.centroid.x) * crate::CM,
                        (v.y - ps.centroid.y) * crate::CM,
                    )
                })
                .collect();
            let area_m2 = (polygon_area(&ps.polygon) * crate::CM * crate::CM).max(1e-6);
            let collider = rapier2d::prelude::ColliderBuilder::convex_hull(&pts)
                .unwrap_or_else(|| rapier2d::prelude::ColliderBuilder::ball(0.01))
                .density(ps.mass / area_m2)
                .friction(0.85)
                .restitution(0.02)
                .build();
            let collider = self.physics.colliders.insert_with_parent(
                collider,
                handle,
                &mut self.physics.bodies,
            );
            self.body.pieces.push(crate::Piece {
                part: ps.part,
                body: handle,
                collider,
                polygon: ps.polygon.clone(),
                centroid: ps.centroid,
                mass: ps.mass,
                still_s: 0.0,
                frozen_pose: None,
                item: ps.item,
                heat: None,
                creature: ps.creature,
                deleted: false,
            });
        }

        // 每具生物的代表块 + 部件句柄 + 生理 + 组织场
        for (ci, cs) in snap.creatures.iter().enumerate() {
            if ci >= self.creatures.len() {
                break;
            }
            let c = &mut self.creatures[ci];
            c.primary = cs.primary.iter().map(|i| PieceId(*i)).collect();
            c.physio.bus = cs.bus;
            c.ambient_c = cs.ambient_c;
            c.tissue_metab_base = cs.tissue_metab_base;
            let prim: Vec<PieceId> = c.primary.clone();
            for (i, inst) in c.parts.iter_mut().enumerate() {
                if let Some(p) = prim.get(i) {
                    let piece = &self.body.pieces[p.index()];
                    inst.body = piece.body;
                    inst.collider = piece.collider;
                }
            }
            // 组织场就地覆盖：长度对不上就说明场换了尺寸，跳过
            if let (Some(ts), Some(t)) = (cs.tissue.as_ref(), c.tissue.as_mut())
                && t.field.k0.len() == ts.k0.len()
            {
                t.field.k0.copy_from_slice(&ts.k0);
                t.field.stump.copy_from_slice(&ts.stump);
                t.field.wound.copy_from_slice(&ts.wound);
                t.field.clamped.copy_from_slice(&ts.clamped);
                t.field.inlet.copy_from_slice(&ts.inlet);
                t.field.damage.copy_from_slice(&ts.damage);
                t.field.pooled.copy_from_slice(&ts.pooled);
                t.field.o2.copy_from_slice(&ts.o2);
                t.field.temp.copy_from_slice(&ts.temp);
                // 压力场不用恢复——它本来就是从 k0/wound/MAP 解出来的
                t.warmup(cs.bus.map);
            }
        }

        // 3. 关节
        for js in &snap.joints {
            let a = PieceId(js.a);
            let b = PieceId(js.b);
            let ca = self.body.pieces[a.index()].centroid;
            let cb = self.body.pieces[b.index()].centroid;
            let la = rapier2d::math::Vec2::new(
                (js.anchor_a.x - ca.x) * crate::CM,
                (js.anchor_a.y - ca.y) * crate::CM,
            );
            let lb = rapier2d::math::Vec2::new(
                (js.anchor_b.x - cb.x) * crate::CM,
                (js.anchor_b.y - cb.y) * crate::CM,
            );
            let ha = self.body.pieces[a.index()].body;
            let hb = self.body.pieces[b.index()].body;

            let mut handle = rapier2d::prelude::ImpulseJointHandle::invalid();
            let mut tether = None;
            match js.health.state {
                crate::JointState::Severed => {}
                crate::JointState::Dislocated => {
                    let rope = rapier2d::prelude::RopeJointBuilder::new(
                        js.tether_rest + self.damage.tether_len_cm * crate::CM,
                    )
                    .local_anchor1(la)
                    .local_anchor2(lb)
                    .contacts_enabled(false)
                    .build();
                    tether = Some(self.physics.impulse_joints.insert(ha, hb, rope, true));
                }
                _ => {
                    let j = rapier2d::prelude::RevoluteJointBuilder::new()
                        .local_anchor1(la)
                        .local_anchor2(lb)
                        .limits([
                            js.rest_limits.0 * js.health.rom_scale,
                            js.rest_limits.1 * js.health.rom_scale,
                        ])
                        .contacts_enabled(false)
                        .build();
                    handle = self.physics.impulse_joints.insert(ha, hb, j, true);
                }
            }

            let id = self
                .plan
                .joints
                .iter()
                .find(|p| {
                    p.a == self.body.pieces[a.index()].part
                        && p.b == self.body.pieces[b.index()].part
                })
                .map(|p| p.id)
                .unwrap_or(anatomize_core::JointId(0));

            self.body.joints.push(crate::JointInstance {
                id,
                a,
                b,
                handle,
                anchor_a: js.anchor_a,
                anchor_b: js.anchor_b,
                rest_limits: js.rest_limits,
                health: js.health,
                tether,
                tether_rest: js.tether_rest,
                cuttable: js.cuttable,
                creature: js.creature,
            });
        }

        // 3.5 玩家连接：和读档同一条路径（局部锚点 → 世界点 → connect_at）
        for c in &snap.conns {
            let a = crate::PieceId(c.a);
            if a.index() >= self.body.pieces.len() {
                continue;
            }
            let Some(wa) = self.conn_world_point(a, c.local_a) else {
                continue;
            };
            let wb = match c.b {
                Some(b) => {
                    let b = crate::PieceId(b);
                    if b.index() >= self.body.pieces.len() {
                        continue;
                    }
                    self.conn_world_point(b, c.local_b)
                }
                None => Some(wa),
            };
            let Some(wb) = wb else { continue };
            if let Some(idx) = self.connect_at(c.kind, a, c.b.map(crate::PieceId), wa, Some(wb)) {
                self.conns[idx].motor = c.motor;
                self.conns[idx].dir = c.dir;
            }
        }

        // 4. 生理 + 组织场：每具已经在上面按快照恢复了
        self.tick = anatomize_core::Tick(snap.tick);
        self.slices = snap.slices;
        self.injuries = snap.injuries.clone();
    }

    /// 退回到 `seconds` 秒前。返回实际退了多少秒。
    pub fn rewind(&mut self, seconds: f32) -> Option<f32> {
        let mut rw = std::mem::replace(&mut self.rewind, Rewind::default_5s());
        let out = rw.rewind(self, seconds);
        self.rewind = rw;
        out
    }
}

fn polygon_area(poly: &[Vec2]) -> f32 {
    let n = poly.len();
    if n < 3 {
        return 0.0;
    }
    let mut a = 0.0;
    for i in 0..n {
        a += poly[i].perp_dot(poly[(i + 1) % n]);
    }
    (a * 0.5).abs()
}
