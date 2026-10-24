//! 存档：把整个世界写成一个 RON 文件，再读回来。
//!
//! # 存什么、不存什么
//!
//! rapier 的 `RigidBodySet` / `ImpulseJointSet` 不能序列化——它们是带内部
//! 索引和缓存的数据结构，直接 dump 出来也没有意义。所以存的是**语义状态**：
//!
//! | 存 | 不存 |
//! |---|---|
//! | 每块的解剖部件、多边形、质心、质量 | rapier 的 handle |
//! | 每块的位姿与速度 | rapier 的 island / broad-phase |
//! | 每条关节的两端、锚点、健康四量、状态 | 约束求解器的累积冲量 |
//! | 生理总线全部字段 | 上一帧的临时量 |
//! | 组织场全部通道 | — |
//!
//! 读档时重建世界：按 `plan_id` 重新装配骨架，然后**覆盖**成存档里的块划分
//! 和位姿。这样"切了一半的腿"能原样恢复，而不是恢复成一具完整的人。
//!
//! # 验收标准 10
//!
//! "所有生理量误差 < 1e-3"。生理量是 f32，RON 用十进制浮点写出再读回，
//! 精度远高于 1e-3，所以这条要求真正难的地方不在精度，而在**完整**：
//! 漏存一个字段（比如 `sympathetic_tone`）会让读档后的轨迹立刻分叉。
//! 测试用"存 → 读 → 再跑 10 秒 → 比较"来抓这种漏。

use serde::{Deserialize, Serialize};

use anatomize_body::{ASSET_HUMAN_01, BodyPlan, JointHealth, JointState};
use anatomize_core::{PartId, Vec2};
use anatomize_physio::{Physio, PhysioBus};
use anatomize_tissue::{TissueConfig, TissueField, TissueSim};
use rapier2d::prelude::*;

use crate::{CM, FractureConfig, Piece, PieceId, Sim, rv};

/// 存档格式版本。加字段就 +1，读旧档时按版本迁移。
pub const SAVE_VERSION: u32 = 1;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PieceSave {
    pub part: PartId,
    /// 部件局部厘米。
    pub polygon: Vec<Vec2>,
    pub centroid: Vec2,
    pub mass: f32,
    /// 世界米。
    pub pos: Vec2,
    pub rot: f32,
    pub linvel: Vec2,
    pub angvel: f32,
    /// 已冻结的块没有刚体，位姿就在 `pos/rot` 里。
    pub frozen: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct JointSave {
    pub a: u32,
    pub b: u32,
    /// 部件局部厘米。
    pub anchor_a: Vec2,
    pub anchor_b: Vec2,
    pub rest_limits: (f32, f32),
    pub tether_rest: f32,
    pub health: JointHealth,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SaveFile {
    pub version: u32,
    /// 身体计划的 id。P0 只有 `human_01`，按 id 从内置资产重建。
    pub plan_id: String,
    pub tick: u64,
    pub ambient_c: f32,
    pub tissue_metab_base: f32,
    pub bus: PhysioBus,
    pub pieces: Vec<PieceSave>,
    /// 每个 `PartId` 的代表块下标。
    pub primary: Vec<u32>,
    pub joints: Vec<JointSave>,
    pub tissue: Option<TissueField>,
    /// 累计切割次数与损伤记录（HUD 与回放用）。
    pub slices: u32,
    pub injuries: Vec<(u16, JointState, f32)>,
}

impl SaveFile {
    /// 序列化成 RON。组织场占了 99% 的体积，所以这个函数慢是正常的。
    pub fn to_ron(&self) -> String {
        ron::ser::to_string_pretty(self, ron::ser::PrettyConfig::default())
            .expect("SaveFile 只含可序列化字段")
    }

    pub fn from_ron(src: &str) -> Result<Self, Box<dyn std::error::Error>> {
        let s: SaveFile = ron::from_str(src)?;
        if s.version > SAVE_VERSION {
            return Err(format!(
                "存档版本 {} 比程序支持的 {} 还新，拒绝读取",
                s.version, SAVE_VERSION
            )
            .into());
        }
        Ok(s)
    }
}

impl Sim {
    /// 拍一张存档。
    pub fn save(&self) -> SaveFile {
        let mut pieces = Vec::with_capacity(self.body.pieces.len());
        for i in 0..self.body.pieces.len() {
            let p = &self.body.pieces[i];
            let (pos, rot) = self.piece_pose(PieceId(i as u32));
            let (linvel, angvel) = if p.is_frozen() {
                (Vec2::ZERO, 0.0)
            } else {
                let rb = &self.physics.bodies[p.body];
                let v = rb.linvel();
                (Vec2::new(v.x, v.y), rb.angvel())
            };
            pieces.push(PieceSave {
                part: p.part,
                polygon: p.polygon.clone(),
                centroid: p.centroid,
                mass: p.mass,
                pos,
                rot,
                linvel,
                angvel,
                frozen: p.is_frozen(),
            });
        }

        let joints = self
            .body
            .joints
            .iter()
            .map(|j| JointSave {
                a: j.a.0,
                b: j.b.0,
                anchor_a: j.anchor_a,
                anchor_b: j.anchor_b,
                rest_limits: j.rest_limits,
                tether_rest: j.tether_rest,
                health: j.health,
            })
            .collect();

        SaveFile {
            version: SAVE_VERSION,
            plan_id: self.plan.id.clone(),
            tick: self.tick.0,
            ambient_c: self.ambient_c,
            tissue_metab_base: self.tissue_metab_base,
            bus: self.physio.bus,
            pieces,
            primary: self.body.primary.iter().map(|p| p.0).collect(),
            joints,
            tissue: self.tissue.as_ref().map(|t| t.field.clone()),
            slices: self.slices,
            injuries: self
                .injuries
                .iter()
                .map(|(id, st, t)| (id.0, *st, *t))
                .collect(),
        }
    }

    /// 从存档重建一个世界。
    ///
    /// 关键在顺序：先把骨架按 `plan_id` 装出来（这样 `plan`、地面、
    /// 初始刚体都在），再**整体替换**成存档里的块与关节。不这么做的话，
    /// 切过的腿读回来会变回完整的一条。
    pub fn load(save: &SaveFile, ground_y: f32) -> Result<Self, Box<dyn std::error::Error>> {
        let plan_src = match save.plan_id.as_str() {
            "human_01" => ASSET_HUMAN_01,
            other => return Err(format!("未知的身体计划 {other}").into()),
        };
        let plan = BodyPlan::from_ron(plan_src)?;

        // 先按标准骨架装一遍，拿到 `plan` / `ground` / 生理默认值
        let mut sim = Self::spawn(plan, Vec2::new(0.0, 40.0), ground_y);
        sim.tick = anatomize_core::Tick(save.tick);
        sim.ambient_c = save.ambient_c;
        sim.tissue_metab_base = save.tissue_metab_base;
        sim.slices = save.slices;
        sim.injuries = save
            .injuries
            .iter()
            .map(|(id, st, t)| (anatomize_core::JointId(*id), *st, *t))
            .collect();

        // 清空所有刚体与关节，按存档重建
        let handles: Vec<RigidBodyHandle> = sim.body.pieces.iter().map(|p| p.body).collect();
        for h in handles {
            sim.physics.bodies.remove(
                h,
                &mut sim.physics.islands,
                &mut sim.physics.colliders,
                &mut sim.physics.impulse_joints,
                &mut sim.physics.multibody_joints,
                &mut sim.physics.soft_bodies,
                true,
            );
        }
        sim.body.pieces.clear();
        sim.body.joints.clear();

        for ps in &save.pieces {
            let id = PieceId(sim.body.pieces.len() as u32);
            if ps.frozen {
                // 冻结的块不建刚体，只留一个占位 handle
                sim.body.pieces.push(Piece {
                    part: ps.part,
                    body: RigidBodyHandle::invalid(),
                    collider: ColliderHandle::invalid(),
                    polygon: ps.polygon.clone(),
                    centroid: ps.centroid,
                    mass: ps.mass,
                    still_s: 0.0,
                    frozen_pose: Some((ps.pos, ps.rot)),
                });
                let _ = id;
                continue;
            }

            let rb = RigidBodyBuilder::dynamic()
                .translation(rv(ps.pos))
                .rotation(ps.rot)
                .linvel(rv(ps.linvel))
                .angvel(ps.angvel)
                .linear_damping(0.15)
                .angular_damping(0.5)
                .build();
            let handle = sim.physics.bodies.insert(rb);
            let pts: Vec<rapier2d::math::Vec2> = ps
                .polygon
                .iter()
                .map(|v| rv((*v - ps.centroid) * CM))
                .collect();
            let area_m2 = (polygon_area(&ps.polygon) * CM * CM).max(1e-6);
            let collider = ColliderBuilder::convex_hull(&pts)
                .unwrap_or_else(|| ColliderBuilder::ball(0.01))
                .density(ps.mass / area_m2)
                .friction(0.85)
                .restitution(0.02)
                .build();
            let collider =
                sim.physics
                    .colliders
                    .insert_with_parent(collider, handle, &mut sim.physics.bodies);
            sim.body.pieces.push(Piece {
                part: ps.part,
                body: handle,
                collider,
                polygon: ps.polygon.clone(),
                centroid: ps.centroid,
                mass: ps.mass,
                still_s: 0.0,
                frozen_pose: None,
            });
        }

        sim.body.primary = save.primary.iter().map(|i| PieceId(*i)).collect();
        // `PartInstance` 的 handle 指向代表块
        for (i, inst) in sim.body.parts.iter_mut().enumerate() {
            if let Some(p) = sim.body.primary.get(i) {
                let piece = &sim.body.pieces[p.index()];
                inst.body = piece.body;
                inst.collider = piece.collider;
            }
        }

        // 关节
        for js in &save.joints {
            let a = PieceId(js.a);
            let b = PieceId(js.b);
            let ca = sim.body.pieces[a.index()].centroid;
            let cb = sim.body.pieces[b.index()].centroid;
            let la = rv((js.anchor_a - ca) * CM);
            let lb = rv((js.anchor_b - cb) * CM);
            let ha = sim.body.pieces[a.index()].body;
            let hb = sim.body.pieces[b.index()].body;

            let mut handle = ImpulseJointHandle::invalid();
            let mut tether = None;
            match js.health.state {
                JointState::Severed => {}
                JointState::Dislocated => {
                    let rope = RopeJointBuilder::new(js.tether_rest + 0.06)
                        .local_anchor1(la)
                        .local_anchor2(lb)
                        .contacts_enabled(false)
                        .build();
                    tether = Some(sim.physics.impulse_joints.insert(ha, hb, rope, true));
                }
                _ => {
                    let j = RevoluteJointBuilder::new()
                        .local_anchor1(la)
                        .local_anchor2(lb)
                        .limits([
                            js.rest_limits.0 * js.health.rom_scale,
                            js.rest_limits.1 * js.health.rom_scale,
                        ])
                        .contacts_enabled(false)
                        .build();
                    handle = sim.physics.impulse_joints.insert(ha, hb, j, true);
                }
            }
            let id = sim
                .plan
                .joints
                .iter()
                .find(|p| {
                    p.a == sim.body.pieces[a.index()].part && p.b == sim.body.pieces[b.index()].part
                })
                .map(|p| p.id)
                .unwrap_or(anatomize_core::JointId(0));

            sim.body.joints.push(crate::JointInstance {
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
            });
        }

        // 生理与组织场
        sim.physio = Physio::new(anatomize_physio::PhysioConfig::asset());
        sim.physio.bus = save.bus;
        if let Some(field) = &save.tissue {
            let mut t = TissueSim::new(field.clone(), TissueConfig::asset());
            t.warmup(sim.physio.bus.map);
            sim.tissue = Some(t);
        }
        sim.fracture = FractureConfig::default();
        Ok(sim)
    }
}

fn polygon_area(poly: &[Vec2]) -> f32 {
    let n = poly.len();
    if n < 3 {
        return 0.0;
    }
    let mut a = 0.0;
    for i in 0..n {
        let p = poly[i];
        let q = poly[(i + 1) % n];
        a += p.perp_dot(q);
    }
    (a * 0.5).abs()
}
