//! 人体定义。
//!
//! 解剖常量全部外置为 RON，代码里不写死任何数字。这里负责把作者友好的
//! 文本（用名字引用父部件和关节）编译成用 [`PartId`] 索引的紧凑结构，
//! 并在编译期做一轮不变量校验。
//!
//! 本 crate 不依赖物理引擎：它描述的是"人体是什么"，不是"人体怎么动"。

use anatomize_core::{JointId, PartId, Vec2};
use serde::Deserialize;

pub const ASSET_HUMAN_01: &str = include_str!("../../../assets/body_plans/human_01.ron");

// ---------------------------------------------------------------------------
// 原始 schema（直接对应 RON）
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, Deserialize)]
pub struct RawPlan {
    pub id: String,
    pub bounds: [[f32; 2]; 2],
    pub parts: Vec<RawPart>,
    pub joints: Vec<RawJoint>,
}

#[derive(Debug, Clone, Deserialize)]
pub struct RawPart {
    pub name: String,
    pub parent: Option<String>,
    pub offset: [f32; 2],
    pub mass: f32,
    pub polygon: Vec<[f32; 2]>,
    pub bone: BoneKind,
    pub layer: Layer,
}

#[derive(Debug, Clone, Deserialize)]
pub struct RawJoint {
    pub name: String,
    pub a: String,
    pub b: String,
    pub anchor_a: [f32; 2],
    pub anchor_b: [f32; 2],
    pub limits: [f32; 2],
    pub stiffness: f32,
    pub damping: f32,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum BoneKind {
    Skull,
    Spine,
    Rib,
    Pelvis,
    Humerus,
    Radius,
    Femur,
    Tibia,
    None,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum Layer {
    Skin,
    Fat,
    Muscle,
    Bone,
    Organ,
}

// ---------------------------------------------------------------------------
// 编译后的结构
// ---------------------------------------------------------------------------

#[derive(Debug, Clone)]
pub struct BodyPlan {
    pub id: String,
    pub bounds: (Vec2, Vec2),
    pub parts: Vec<Part>,
    pub joints: Vec<Joint>,
}

#[derive(Debug, Clone)]
pub struct Part {
    pub id: PartId,
    pub name: String,
    pub parent: Option<PartId>,
    /// 部件中心在身体局部坐标中的位置（cm，y 向上）。
    pub offset: Vec2,
    /// 以部件中心为原点的局部多边形（cm，逆时针）。
    pub polygon: Vec<Vec2>,
    pub mass: f32,
    /// 多边形面积（cm²），由 shoelace 算出。
    pub area: f32,
    /// 质量密度（kg/cm²），建碰撞体时用。
    pub density: f32,
    pub bone: BoneKind,
    pub layer: Layer,
}

#[derive(Debug, Clone)]
pub struct Joint {
    pub id: JointId,
    pub name: String,
    pub a: PartId,
    pub b: PartId,
    pub anchor_a: Vec2,
    pub anchor_b: Vec2,
    /// 活动度限制（弧度）。
    pub limits: (f32, f32),
    pub stiffness: f32,
    pub damping: f32,
}

impl BodyPlan {
    pub fn from_ron(src: &str) -> Result<Self, BodyError> {
        let raw: RawPlan = ron::from_str(src)?;
        Self::compile(raw)
    }

    pub fn compile(raw: RawPlan) -> Result<Self, BodyError> {
        let mut parts = Vec::with_capacity(raw.parts.len());
        let mut index = std::collections::HashMap::new();

        for (i, p) in raw.parts.iter().enumerate() {
            if index.insert(p.name.clone(), i).is_some() {
                return Err(BodyError::DuplicatePart(p.name.clone()));
            }
        }

        for (i, p) in raw.parts.iter().enumerate() {
            let parent = match &p.parent {
                None => None,
                Some(name) => Some(PartId(
                    *index
                        .get(name)
                        .ok_or_else(|| BodyError::UnknownPart(name.clone()))?
                        as u16,
                )),
            };

            if p.polygon.len() < 3 {
                return Err(BodyError::DegeneratePolygon(p.name.clone()));
            }
            let polygon: Vec<Vec2> = p.polygon.iter().map(|v| Vec2::new(v[0], v[1])).collect();
            let area = signed_area(&polygon);
            if area.abs() < 1e-6 {
                return Err(BodyError::DegeneratePolygon(p.name.clone()));
            }
            // 统一成逆时针
            let polygon = if area < 0.0 {
                let mut v = polygon;
                v.reverse();
                v
            } else {
                polygon
            };
            let area = area.abs();

            if !is_convex(&polygon) {
                return Err(BodyError::NonConvex(p.name.clone()));
            }
            if p.mass <= 0.0 {
                return Err(BodyError::BadMass(p.name.clone()));
            }

            parts.push(Part {
                id: PartId(i as u16),
                name: p.name.clone(),
                parent,
                offset: Vec2::new(p.offset[0], p.offset[1]),
                polygon,
                mass: p.mass,
                area,
                density: p.mass / area,
                bone: p.bone,
                layer: p.layer,
            });
        }

        // 父链无环
        for p in &parts {
            let mut cur = p.parent;
            let mut hops = 0;
            while let Some(parent) = cur {
                hops += 1;
                if hops > parts.len() {
                    return Err(BodyError::ParentCycle(p.name.clone()));
                }
                cur = parts[parent.index()].parent;
            }
        }

        let mut joints = Vec::with_capacity(raw.joints.len());
        for (i, j) in raw.joints.iter().enumerate() {
            let a = *index
                .get(&j.a)
                .ok_or_else(|| BodyError::UnknownPart(j.a.clone()))?;
            let b = *index
                .get(&j.b)
                .ok_or_else(|| BodyError::UnknownPart(j.b.clone()))?;
            if a == b {
                return Err(BodyError::SelfJoint(j.name.clone()));
            }
            let anchor_a = Vec2::new(j.anchor_a[0], j.anchor_a[1]);
            let anchor_b = Vec2::new(j.anchor_b[0], j.anchor_b[1]);

            // 锚点必须落在各自部件内部，否则关节一建立就被拉开
            if !point_in_convex(&parts[a].polygon, anchor_a) {
                return Err(BodyError::AnchorOutside {
                    joint: j.name.clone(),
                    part: parts[a].name.clone(),
                });
            }
            if !point_in_convex(&parts[b].polygon, anchor_b) {
                return Err(BodyError::AnchorOutside {
                    joint: j.name.clone(),
                    part: parts[b].name.clone(),
                });
            }
            if j.limits[0] >= j.limits[1] {
                return Err(BodyError::BadLimits(j.name.clone()));
            }

            joints.push(Joint {
                id: JointId(i as u16),
                name: j.name.clone(),
                a: PartId(a as u16),
                b: PartId(b as u16),
                anchor_a,
                anchor_b,
                limits: (j.limits[0], j.limits[1]),
                stiffness: j.stiffness,
                damping: j.damping,
            });
        }

        Ok(Self {
            id: raw.id,
            bounds: (
                Vec2::new(raw.bounds[0][0], raw.bounds[0][1]),
                Vec2::new(raw.bounds[1][0], raw.bounds[1][1]),
            ),
            parts,
            joints,
        })
    }

    pub fn total_mass(&self) -> f32 {
        self.parts.iter().map(|p| p.mass).sum()
    }

    pub fn part(&self, name: &str) -> Option<&Part> {
        self.parts.iter().find(|p| p.name == name)
    }

    /// 部件在身体局部坐标下的包围盒角点。
    pub fn part_world_polygon(&self, part: &Part) -> Vec<Vec2> {
        part.polygon.iter().map(|v| *v + part.offset).collect()
    }
}

// ---------------------------------------------------------------------------
// 错误
// ---------------------------------------------------------------------------

#[derive(Debug, thiserror::Error)]
pub enum BodyError {
    #[error("RON 解析失败: {0}")]
    Ron(#[from] ron::error::SpannedError),
    #[error("重复的部件名: {0}")]
    DuplicatePart(String),
    #[error("引用了不存在的部件: {0}")]
    UnknownPart(String),
    #[error("部件多边形退化（少于 3 点或面积为零）: {0}")]
    DegeneratePolygon(String),
    #[error("部件多边形不是凸的（M0 只支持凸多边形）: {0}")]
    NonConvex(String),
    #[error("部件质量必须为正: {0}")]
    BadMass(String),
    #[error("部件父链存在环: {0}")]
    ParentCycle(String),
    #[error("关节两端是同一个部件: {0}")]
    SelfJoint(String),
    #[error("关节 {joint} 的锚点落在部件 {part} 外面")]
    AnchorOutside { joint: String, part: String },
    #[error("关节活动度上下限颠倒: {0}")]
    BadLimits(String),
}

// ---------------------------------------------------------------------------
// 几何工具
// ---------------------------------------------------------------------------

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
        if cross.abs() < 1e-6 {
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

pub fn point_in_convex(poly: &[Vec2], p: Vec2) -> bool {
    let mut sign = 0.0f32;
    for i in 0..poly.len() {
        let a = poly[i];
        let b = poly[(i + 1) % poly.len()];
        let cross = (b - a).perp_dot(p - a);
        if cross.abs() < 1e-6 {
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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn human_01_compiles() {
        let plan = BodyPlan::from_ron(ASSET_HUMAN_01).expect("human_01.ron 应该能编译");
        assert_eq!(plan.parts.len(), 11);
        assert_eq!(plan.joints.len(), 10);
        let m = plan.total_mass();
        assert!((m - 80.0).abs() < 5.0, "总质量应在 80kg 附近，实际 {m}");
    }

    #[test]
    fn rejects_unknown_parent() {
        let src = r#"(
            id: "t",
            bounds: ((-10.0,-10.0),(10.0,10.0)),
            parts: [(name: "a", parent: Some("ghost"), offset: (0.0,0.0), mass: 1.0,
                     polygon: [(0.0,0.0),(1.0,0.0),(1.0,1.0)], bone: none, layer: muscle)],
            joints: [],
        )"#;
        assert!(matches!(
            BodyPlan::from_ron(src),
            Err(BodyError::UnknownPart(_))
        ));
    }

    #[test]
    fn convexity_check() {
        let square = vec![
            Vec2::new(0.0, 0.0),
            Vec2::new(1.0, 0.0),
            Vec2::new(1.0, 1.0),
            Vec2::new(0.0, 1.0),
        ];
        assert!(is_convex(&square));
        let arrow = vec![
            Vec2::new(0.0, 0.0),
            Vec2::new(2.0, 0.0),
            Vec2::new(1.0, 0.5),
            Vec2::new(2.0, 1.0),
            Vec2::new(0.0, 1.0),
        ];
        assert!(!is_convex(&arrow));
    }
}
