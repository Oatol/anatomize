//! 编辑操作：冻结 / 解冻 / 删除。
//!
//! 这三个是沙盒的基本动词，和"切"同级。放在单独文件里是因为它们都要
//! **建/删刚体**，和 `fracture.rs` 一样是物理层的写操作。

use anatomize_core::Vec2;
use rapier2d::prelude::*;

use crate::{CM, PieceId, RVec2, Sim, rv};

impl Sim {
    /// 冻结 / 解冻一块。返回操作之后是否处于冻结状态。
    ///
    /// 冻结 = 从物理世界摘掉，只留位姿。解冻 = 按存档里的多边形重建刚体。
    /// 已删除的块不能操作。
    pub fn set_frozen(&mut self, id: PieceId, frozen: bool) -> bool {
        if self.body.pieces[id.index()].deleted {
            return false;
        }
        let now = self.body.pieces[id.index()].is_frozen();
        if now == frozen {
            return now;
        }

        if frozen {
            // 冻结：记位姿，删刚体
            let body = self.body.pieces[id.index()].body;
            let pose = self.physics.bodies.get(body).map(|rb| {
                let p = *rb.position();
                (
                    Vec2::new(p.translation.x, p.translation.y),
                    p.rotation.angle(),
                )
            });
            let Some(pose) = pose else { return false };
            self.body.pieces[id.index()].frozen_pose = Some(pose);
            self.physics.bodies.remove(
                body,
                &mut self.physics.islands,
                &mut self.physics.colliders,
                &mut self.physics.impulse_joints,
                &mut self.physics.multibody_joints,
                &mut self.physics.soft_bodies,
                true,
            );
            true
        } else {
            // 解冻：按多边形重建
            let (pose, polygon, centroid, mass) = {
                let p = &self.body.pieces[id.index()];
                let Some(pose) = p.frozen_pose else {
                    return false;
                };
                (pose, p.polygon.clone(), p.centroid, p.mass)
            };
            let (pos, rot) = pose;
            let rb = RigidBodyBuilder::dynamic()
                .translation(rv(pos))
                .rotation(rot)
                .linear_damping(0.15)
                .angular_damping(0.5)
                .build();
            let handle = self.physics.bodies.insert(rb);

            let pts: Vec<RVec2> = polygon.iter().map(|v| rv((*v - centroid) * CM)).collect();
            let area_m2 = (crate::save::polygon_area(&polygon) * CM * CM).max(1e-6);
            let collider = ColliderBuilder::convex_hull(&pts)
                .unwrap_or_else(|| ColliderBuilder::ball(0.02))
                .density(mass / area_m2)
                .friction(0.85)
                .restitution(0.02)
                .build();
            let collider = self.physics.colliders.insert_with_parent(
                collider,
                handle,
                &mut self.physics.bodies,
            );

            let p = &mut self.body.pieces[id.index()];
            p.body = handle;
            p.collider = collider;
            p.frozen_pose = None;
            p.still_s = 0.0;
            false
        }
    }

    /// 删除一块。刚体立刻从物理世界消失，渲染也跳过。
    ///
    /// 用墓碑而不是 `Vec::remove`：`PieceId` 就是下标，删一个会让后面所有
    /// 引用（关节、选中、回滚快照）错位。
    pub fn delete_piece(&mut self, id: PieceId) -> bool {
        let p = &mut self.body.pieces[id.index()];
        if p.deleted {
            return false;
        }
        p.deleted = true;
        let body = p.body;
        if !p.is_frozen() {
            self.physics.bodies.remove(
                body,
                &mut self.physics.islands,
                &mut self.physics.colliders,
                &mut self.physics.impulse_joints,
                &mut self.physics.multibody_joints,
                &mut self.physics.soft_bodies,
                true,
            );
        }
        // 挂着它的关节一起断掉——不然关节会指着一个不存在的刚体
        for j in &mut self.body.joints {
            if (j.a == id || j.b == id) && j.health.state != crate::JointState::Severed {
                j.health.state = crate::JointState::Severed;
                j.health.integrity = 0.0;
                if let Some(h) = j.tether {
                    self.physics.impulse_joints.remove(h, true);
                }
                self.physics.impulse_joints.remove(j.handle, true);
                j.tether = None;
            }
        }
        true
    }

    /// 统计：还剩多少块是活着的（没删、没冻）。
    pub fn alive_pieces(&self) -> usize {
        self.body
            .pieces
            .iter()
            .filter(|p| !p.deleted && !p.is_frozen())
            .count()
    }
}
