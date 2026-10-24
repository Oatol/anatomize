//! 玩家连出来的东西：焊接、钉住、绳、铰链、活塞。
//!
//! # 为什么和解剖关节分开放
//!
//! `body.joints` 里那套东西有健康四量（`JointHealth`）、状态机、解剖活动度，
//! 索引还要和 `Posture.targets` 一一对齐——它是**身体的一部分**。
//!
//! 玩家用工具连出来的东西不是：它没有"扭伤/脱位"这种中间状态，只有"连着"
//! 和"断了"。混进 `body.joints` 会让姿态控制去追一个不存在的目标角，
//! 存档也要为它编一套假的健康值。所以单独一张表。
//!
//! # 抄 MaD2 的哪几个
//!
//! `Joints.as` 里有 `Revolution` / `Prismatic` / `Distance` / `Weld` / `Pin`
//! 五种，工具里对应 `JOINT` / `PISTON` / `ROPE` / `WELD` / `PIN`。
//! 我们全都要：
//!
//! | 工具 | MaD2 | rapier |
//! |---|---|---|
//! | 焊接 | `b2WeldJoint` | `FixedJoint` |
//! | 钉住 | `b2MouseJoint` 钉在固定点上 | `FixedJoint` → 静态锚点刚体 |
//! | 绳 | `b2DistanceJoint` | `RopeJoint`（只限最长，不推） |
//! | 铰链 | `b2RevoluteJoint` | `RevoluteJoint` |
//! | 活塞 | `b2PrismaticJoint` + 电机 | `PrismaticJoint` + `motor_velocity` |
//!
//! # 一个细节：钉住为什么用静态刚体
//!
//! MaD2 的 Pin 是 `b2MouseJoint`，它的"另一端"是一个虚拟的世界点。Box2D 的
//! mouse joint 允许这样；rapier 的关节两端必须是真刚体。所以钉住 = 在世界点
//! 建一个**静态刚体**，再用 `FixedJoint` 把块焊上去。效果一样，代价是每根钉子
//! 多一个刚体（无质量、不参与碰撞）。

use anatomize_core::Vec2;
use anatomize_cut::CutSegment;
use rapier2d::prelude::*;

use crate::{CM, JointState, PieceId, RVec2, Sim, rv};

/// 玩家能连的五种东西。
#[derive(Debug, Clone, Copy, PartialEq, Eq, serde::Serialize, serde::Deserialize)]
pub enum ConnKind {
    /// 刚性焊接：两块变成一个刚体（相对位姿锁死）。
    Weld,
    /// 钉住：一块被钉在世界上的某个点，能绕钉子转。
    Pin,
    /// 绳：只限制最远距离，能推近（布/绳都这样）。
    Rope,
    /// 铰链：能绕一个点自由转。
    Hinge,
    /// 活塞：只能沿一个轴伸缩，带电机。
    Piston,
}

impl ConnKind {
    pub const ALL: [ConnKind; 5] = [
        ConnKind::Weld,
        ConnKind::Pin,
        ConnKind::Rope,
        ConnKind::Hinge,
        ConnKind::Piston,
    ];

    pub fn name(self) -> &'static str {
        match self {
            ConnKind::Weld => "焊接",
            ConnKind::Pin => "钉住",
            ConnKind::Rope => "绳",
            ConnKind::Hinge => "铰链",
            ConnKind::Piston => "活塞",
        }
    }

    /// 需要点两块吗（钉住只要一块）。
    pub fn needs_two(self) -> bool {
        !matches!(self, ConnKind::Pin)
    }

    /// 画线用的颜色。
    pub fn color(self) -> [u8; 4] {
        match self {
            ConnKind::Weld => [190, 200, 215, 220],
            ConnKind::Pin => [240, 200, 120, 230],
            ConnKind::Rope => [200, 180, 130, 210],
            ConnKind::Hinge => [140, 210, 230, 220],
            ConnKind::Piston => [230, 150, 110, 230],
        }
    }
}

/// 一条连接。
#[derive(Debug, Clone)]
pub struct Conn {
    pub kind: ConnKind,
    pub a: PieceId,
    /// 钉住时是 `None`（另一端是世界锚点）。
    pub b: Option<PieceId>,
    /// 两端锚点，各自在**刚体局部米**（rapier 的 `local_anchor`）。
    pub local_a: Vec2,
    pub local_b: Vec2,
    pub handle: ImpulseJointHandle,
    /// 钉住用的静态刚体。别的种类是 `None`。
    pub anchor_body: Option<RigidBodyHandle>,
    /// 绳的静止长度 / 活塞的行程（米）。
    pub rest: f32,
    /// 活塞电机的目标速度（m/s）。0 = 不推。
    pub motor: f32,
    /// 活塞方向（+1 伸出 / -1 收回）。
    pub dir: f32,
    /// 活塞的轴，在 `a` 的**刚体局部**坐标系里（单位向量）。
    ///
    /// 渲染要用：活塞两端的锚点是**重合**的（建的时候就是同一个世界点），
    /// 所以"画一条 a→b 的线"会得到零长度，什么都看不见。得沿轴画一根杆。
    pub axis: Vec2,
    /// 断了没有。断了就不画、不参与。
    pub broken: bool,
}

impl Sim {
    /// 刚体局部米 → 世界米。读档 / 回滚重建连接时用。
    pub fn conn_world_point(&self, id: PieceId, local: Vec2) -> Option<Vec2> {
        let p = &self.body.pieces[id.index()];
        if p.deleted {
            return None;
        }
        if let Some((pos, rot)) = p.frozen_pose {
            let w = Rot2::from_angle(rot) * rv(local) + rv(pos);
            return Some(Vec2::new(w.x, w.y));
        }
        let rb = self.physics.bodies.get(p.body)?;
        let w = rb.position().transform_point(rv(local));
        Some(Vec2::new(w.x, w.y))
    }

    /// 一条连接的两端现在在世界哪儿（米）。渲染用。
    pub fn conn_points(&self, c: &Conn) -> Option<(Vec2, Vec2)> {
        let pa = &self.body.pieces[c.a.index()];
        let wa = match self.physics.bodies.get(pa.body) {
            Some(rb) => rb.position().transform_point(rv(c.local_a)),
            None => match pa.frozen_pose {
                Some((pos, rot)) => Rot2::from_angle(rot) * rv(c.local_a) + rv(pos),
                None => return None,
            },
        };
        let wb = match c.b {
            Some(b) => {
                let pb = &self.body.pieces[b.index()];
                match self.physics.bodies.get(pb.body) {
                    Some(rb) => rb.position().transform_point(rv(c.local_b)),
                    None => match pb.frozen_pose {
                        Some((pos, rot)) => Rot2::from_angle(rot) * rv(c.local_b) + rv(pos),
                        None => return None,
                    },
                }
            }
            None => c
                .anchor_body
                .and_then(|h| self.physics.bodies.get(h))?
                .position()
                .transform_point(rv(c.local_b)),
        };
        Some((Vec2::new(wa.x, wa.y), Vec2::new(wb.x, wb.y)))
    }

    /// 连两块，关节放在 `at`（世界米）。两端的锚点都是这一个点。
    ///
    /// 返回新连接的编号。参数不合法（块删了、冻了、同一块）返回 `None`。
    pub fn connect(
        &mut self,
        kind: ConnKind,
        a: PieceId,
        b: Option<PieceId>,
        at: Vec2,
    ) -> Option<usize> {
        self.connect_at(kind, a, b, at, None)
    }

    /// 同上，但可以给**第二端**单独一个锚点。
    ///
    /// 只有绳需要这个：绳是"两端各挂一个点、限最远距离"，两个锚点分开才拉得开。
    /// 焊接 / 铰链 / 活塞的两端必须**重合在同一个世界点**，不然关节一建出来
    /// 就会把两块往一起拽，看着像"啪"地吸过去。
    pub fn connect_at(
        &mut self,
        kind: ConnKind,
        a: PieceId,
        b: Option<PieceId>,
        at: Vec2,
        at_b: Option<Vec2>,
    ) -> Option<usize> {
        let pa = &self.body.pieces[a.index()];
        if pa.deleted || pa.is_frozen() {
            return None;
        }
        let ha = pa.body;
        if let Some(b) = b {
            if a == b {
                return None;
            }
            let pb = &self.body.pieces[b.index()];
            if pb.deleted || pb.is_frozen() {
                return None;
            }
        }

        // 绳的两端各挂一个点；其余种类两端重合成一个点。
        let pa_world = at;
        let pb_world = if kind == ConnKind::Rope {
            at_b.unwrap_or(at)
        } else {
            at
        };

        // 世界点 → 两端各自的局部锚点
        let local_a = {
            let rb = self.physics.bodies.get(ha)?;
            let inv = rb.position().inverse();
            inv.transform_point(rv(pa_world))
        };

        // 钉住：建一个静态锚点刚体
        let mut anchor_body = None;
        let local_b = if let Some(b) = b {
            let hb = self.body.pieces[b.index()].body;
            let rb = self.physics.bodies.get(hb)?;
            rb.position().inverse().transform_point(rv(pb_world))
        } else {
            let rb = RigidBodyBuilder::fixed().translation(rv(pb_world)).build();
            let h = self.physics.bodies.insert(rb);
            anchor_body = Some(h);
            RVec2::ZERO
        };

        let hb = match b {
            Some(b) => self.body.pieces[b.index()].body,
            None => anchor_body?,
        };

        // 活塞的轴：a 指向 b，转到 a 的局部坐标系。
        // 放在 match 之前算，因为渲染也要用（`Conn::axis`）。
        let axis_local = {
            let rot = self
                .physics
                .bodies
                .get(ha)
                .map(|r| r.position().rotation)
                .unwrap_or_else(Rotation::identity);
            let world_axis = match b {
                Some(b) => {
                    let pa2 = &self.body.pieces[a.index()];
                    let pb = &self.body.pieces[b.index()];
                    match (
                        self.physics.bodies.get(pa2.body),
                        self.physics.bodies.get(pb.body),
                    ) {
                        (Some(ra), Some(rb)) => {
                            let d = rb.position().translation - ra.position().translation;
                            if d.length() < 1e-4 {
                                RVec2::X
                            } else {
                                d.normalize()
                            }
                        }
                        _ => RVec2::X,
                    }
                }
                None => RVec2::X,
            };
            rot.inverse_transform_vector(world_axis)
        };

        let joint: GenericJoint = match kind {
            ConnKind::Weld | ConnKind::Pin => FixedJointBuilder::new()
                .local_anchor1(local_a)
                .local_anchor2(local_b)
                .contacts_enabled(false)
                .build()
                .into(),
            ConnKind::Hinge => RevoluteJointBuilder::new()
                .local_anchor1(local_a)
                .local_anchor2(local_b)
                .contacts_enabled(false)
                .build()
                .into(),
            ConnKind::Rope => {
                // 绳长 = **两个锚点**的世界距离。不能拿刚体中心的距离：
                // 绳是挂在两个点上的，锚点重合的话长度就是 0，两块会被焊在一起。
                let dist = (pb_world - pa_world).length().max(0.05);
                RopeJointBuilder::new(dist)
                    .local_anchor1(local_a)
                    .local_anchor2(local_b)
                    .contacts_enabled(false)
                    .build()
                    .into()
            }
            ConnKind::Piston => PrismaticJointBuilder::new(axis_local)
                .local_anchor1(local_a)
                .local_anchor2(local_b)
                .limits([-0.05, 0.35])
                .motor_model(MotorModel::ForceBased)
                .motor_velocity(0.0, 0.5)
                .motor_max_force(900.0)
                .contacts_enabled(false)
                .build()
                .into(),
        };

        let handle = self.physics.impulse_joints.insert(ha, hb, joint, true);
        let rest = (pb_world - pa_world).length();
        let idx = self.conns.len();
        self.conns.push(Conn {
            kind,
            a,
            b,
            local_a: Vec2::new(local_a.x, local_a.y),
            local_b: Vec2::new(local_b.x, local_b.y),
            handle,
            anchor_body,
            rest,
            motor: 0.0,
            dir: 1.0,
            axis: if kind == ConnKind::Piston {
                Vec2::new(axis_local.x, axis_local.y)
            } else {
                Vec2::ZERO
            },
            broken: false,
        });
        Some(idx)
    }

    /// 拆掉一条连接。
    pub fn disconnect(&mut self, idx: usize) -> bool {
        if idx >= self.conns.len() || self.conns[idx].broken {
            return false;
        }
        let c = self.conns[idx].clone();
        self.physics.impulse_joints.remove(c.handle, true);
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
        self.conns[idx].broken = true;
        true
    }

    /// 活塞：翻转方向（F 键）。
    ///
    /// 有连接就推，没连接就停——不是"开/关"，是"伸出/收回/停"三态循环。
    pub fn toggle_piston(&mut self, idx: usize) -> Option<String> {
        if idx >= self.conns.len() {
            return None;
        }
        let c = &mut self.conns[idx];
        if c.kind != ConnKind::Piston || c.broken {
            return None;
        }
        if c.motor == 0.0 {
            c.motor = 0.35;
            c.dir = 1.0;
        } else if c.dir > 0.0 {
            c.dir = -1.0;
        } else {
            c.motor = 0.0;
            c.dir = 1.0;
        }
        let state = if c.motor == 0.0 {
            "停".to_string()
        } else if c.dir > 0.0 {
            "伸出".to_string()
        } else {
            "收回".to_string()
        };
        Some(format!("活塞{state}"))
    }

    /// 每帧把活塞电机的目标速度刷到关节上。
    ///
    /// rapier 的 `motor_velocity` 是建关节时设的，改了要重新设一遍。
    pub(crate) fn update_pistons(&mut self) {
        for i in 0..self.conns.len() {
            let (broken, kind, motor, dir, handle) = {
                let c = &self.conns[i];
                (c.broken, c.kind, c.motor, c.dir, c.handle)
            };
            if broken || kind != ConnKind::Piston {
                continue;
            }
            let Some(j) = self.physics.impulse_joints.get_mut(handle, true) else {
                continue;
            };
            j.data.set_motor_velocity(JointAxis::LinX, motor * dir, 0.5);
        }
    }

    /// 切到关节就断掉它 —— MaD2 的 `Cutter.CutJoints`。
    ///
    /// # 抄了什么
    ///
    /// 1. **判据是"刀线穿过两个锚点连成的那条线"**，不是"刀线穿过关节的圆心"。
    ///    Box2D 里关节没有半径，MaD2 拿 `GetAnchor1()` / `GetAnchor2()` 连线，
    ///    再用 `checkLineCollision2` 判交（还正反各判一次，因为那个函数不保证对称）。
    /// 2. **一刀最多断一条**：循环里 `DestroyJoint` 之后直接 `return`。
    /// 3. **不可断的关节在暂停时也能断**：`if(!(!cuttable && TimeLord.speed != 0))`。
    /// 4. **短绳不切**：`name == "rag"` 且两锚点距离 < 0.2 时跳过。绳子绷直时
    ///    两锚点离得远，切中间才算切到；松弛时锚点几乎重合，切它没意义。
    ///
    /// 返回被切断的那条的名字（给玩家看）。
    pub fn cut_joints_on(&mut self, cut: &CutSegment, paused: bool) -> Option<String> {
        // 解剖关节
        let mut victim: Option<usize> = None;
        for i in 0..self.body.joints.len() {
            let j = &self.body.joints[i];
            if j.health.state == JointState::Severed {
                continue;
            }
            if !j.cuttable && !paused {
                continue;
            }
            let wa = self.piece_point(j.a, j.anchor_a);
            let wb = self.piece_point(j.b, j.anchor_b);
            if cut_hits_joint(cut, wa, wb) {
                victim = Some(i);
                break;
            }
        }
        if let Some(i) = victim {
            let name = self.joint_name(self.body.joints[i].id).to_string();
            self.body.joints[i].health.integrity = 0.0;
            self.body.joints[i].health.state = JointState::Severed;
            self.apply_joint_state(i, JointState::Severed);
            self.injuries
                .push((self.body.joints[i].id, JointState::Severed, 0.0));
            return Some(name);
        }

        // 玩家连接
        let mut victim: Option<usize> = None;
        for i in 0..self.conns.len() {
            let c = &self.conns[i];
            if c.broken {
                continue;
            }
            let Some((wa, wb)) = self.conn_points(c) else {
                continue;
            };
            // 短绳不切
            if c.kind == ConnKind::Rope && (wa - wb).length() < 0.2 {
                continue;
            }
            if cut_hits_joint(cut, wa, wb) {
                victim = Some(i);
                break;
            }
        }
        if let Some(i) = victim {
            let name = self.conns[i].kind.name().to_string();
            self.disconnect(i);
            return Some(name);
        }
        None
    }

    /// 删掉一块时，把连着它的连接一起拆掉。
    pub(crate) fn drop_conns_of(&mut self, id: PieceId) {
        for i in 0..self.conns.len() {
            let c = &self.conns[i];
            if c.broken {
                continue;
            }
            if c.a == id || c.b == Some(id) {
                self.disconnect(i);
            }
        }
    }

    /// 离某块最近的连接（工具点选 / F 键用）。
    pub fn conn_near(&self, at: Vec2, radius_m: f32) -> Option<usize> {
        let mut best: Option<(usize, f32)> = None;
        for i in 0..self.conns.len() {
            let c = &self.conns[i];
            if c.broken {
                continue;
            }
            let Some((wa, wb)) = self.conn_points(c) else {
                continue;
            };
            let d = point_seg_dist(at, wa, wb);
            if d <= radius_m && best.is_none_or(|(_, bd)| d < bd) {
                best = Some((i, d));
            }
        }
        best.map(|(i, _)| i)
    }
}

/// 这一刀算不算切到了这条关节。
///
/// # 为什么分两种情况
///
/// 解剖关节是 revolute（转轴），两个锚点**重合**——它们之间那条"线段"长度是 0。
/// 直接拿它做线段相交会永远判不中（分母为 0）。MaD2 的 `checkLineCollision2`
/// 也面对同一个问题，它的做法是对退化线段退化成"点在线上"。
///
/// 所以：
///
/// - 两锚点距离 < 5cm（转轴、铰链）→ 刀线到锚点的距离 < 1.2cm 就算切中
/// - 两锚点离得远（绳、焊接）→ 刀线要真的**穿过**它们之间的那条线
fn cut_hits_joint(cut: &CutSegment, wa: Vec2, wb: Vec2) -> bool {
    let span = (wb - wa).length();
    if span < 0.05 {
        // 转轴：判"刀过没过这个点"。1.2cm 大约是半个刀宽 + 一点手感容差。
        return point_seg_dist(wa, cut.a, cut.b) < 0.012;
    }
    segments_cross(cut.a, cut.b, wa, wb)
}

/// 两条线段相交吗（含端点接触）。
fn segments_cross(a0: Vec2, a1: Vec2, b0: Vec2, b1: Vec2) -> bool {
    let d1 = a1 - a0;
    let d2 = b1 - b0;
    let denom = d1.perp_dot(d2);
    // 平行：不判（MaD2 也是靠 checkLineCollision2，平行时它返回 false）
    if denom.abs() < 1e-9 {
        return false;
    }
    let t = (b0 - a0).perp_dot(d2) / denom;
    let u = (b0 - a0).perp_dot(d1) / denom;
    (0.0..=1.0).contains(&t) && (0.0..=1.0).contains(&u)
}

fn point_seg_dist(p: Vec2, a: Vec2, b: Vec2) -> f32 {
    let ab = b - a;
    let l2 = ab.length_squared();
    if l2 < 1e-12 {
        return (p - a).length();
    }
    let t = ((p - a).dot(ab) / l2).clamp(0.0, 1.0);
    (p - (a + ab * t)).length()
}

/// `CM` 在这个文件里只用于文档说明，留着防止有人以为锚点是厘米。
const _: f32 = CM;
