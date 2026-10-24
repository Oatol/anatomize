//! 伤害语义。
//!
//! 物理层只负责产出 [`Injury`]，生理层只负责消费它。
//! 加新武器、新器官都不需要同时改两边。

use crate::ids::{JointId, OrganId, PartId};
use serde::{Deserialize, Serialize};

/// 被破坏的结构，按位组合。
#[derive(Debug, Clone, Copy, PartialEq, Eq, Default, Serialize, Deserialize)]
pub struct Structures(pub u8);

impl Structures {
    pub const SKIN: Structures = Structures(1 << 0);
    pub const MUSCLE: Structures = Structures(1 << 1);
    pub const BONE: Structures = Structures(1 << 2);
    pub const VESSEL: Structures = Structures(1 << 3);
    pub const NERVE: Structures = Structures(1 << 4);

    pub const fn empty() -> Self {
        Self(0)
    }

    pub const fn union(self, other: Self) -> Self {
        Self(self.0 | other.0)
    }

    pub const fn contains(self, other: Self) -> bool {
        self.0 & other.0 == other.0
    }

    pub const fn is_empty(self) -> bool {
        self.0 == 0
    }
}

/// 伤害机制。决定组织场的写入方式与生理层的响应曲线。
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum Mechanism {
    /// 钝击：能量高、面积大，主要造成挫伤与骨折。
    Impact,
    /// 剪切：刀具、玻璃，切面干净。
    Shear,
    /// 挤压：重物压住，缺血为主。
    Crush,
    /// 切割：明确的切面折线。
    Cut,
    /// 牵拉：关节超限、肢体被拽。
    Traction,
    /// 热：烧伤、冻伤。
    Thermal,
}

/// 伤害发生在哪里。
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum InjurySite {
    Part(PartId),
    Joint(JointId),
    Organ(OrganId),
}

/// 一条伤害事件。物理层写，生理层读，不回头。
#[derive(Debug, Clone, Copy, PartialEq, Serialize, Deserialize)]
pub struct Injury {
    pub site: InjurySite,
    pub mechanism: Mechanism,
    /// 输入能量，焦耳。
    pub energy_j: f32,
    pub structures: Structures,
}
