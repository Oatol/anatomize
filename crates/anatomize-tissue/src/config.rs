//! 组织场参数。全部外置为 RON，改参数不重编译。
//!
//! 这里的数值不是"随便填的"，但也不是临床标定级——设计文档第 15 节明确：
//! 只要求**定性正确 + 量级合理**。每个系数在 `tests::` 里都有对应的回归断言，
//! 改动前先看断言为什么是那个数。

use crate::TissueKind;
use serde::Deserialize;

pub const ASSET_TISSUE_CONFIG: &str = include_str!("../../../assets/config/tissue.ron");

/// 按组织类型查表。字段名和 [`TissueKind`] 一一对应。
#[derive(Debug, Clone, Copy, Deserialize)]
#[serde(default)]
pub struct KindTable {
    pub outside: f32,
    pub skin: f32,
    pub fat: f32,
    pub muscle: f32,
    pub bone: f32,
    pub organ: f32,
    pub air: f32,
}

impl Default for KindTable {
    fn default() -> Self {
        Self {
            outside: 0.0,
            skin: 0.0,
            fat: 0.0,
            muscle: 0.0,
            bone: 0.0,
            organ: 0.0,
            air: 0.0,
        }
    }
}

impl KindTable {
    #[inline]
    pub fn get(&self, k: TissueKind) -> f32 {
        match k {
            TissueKind::Outside => self.outside,
            TissueKind::Skin => self.skin,
            TissueKind::Fat => self.fat,
            TissueKind::Muscle => self.muscle,
            TissueKind::Bone => self.bone,
            TissueKind::Organ => self.organ,
            TissueKind::Air => self.air,
        }
    }
}

/// 组织场 + 生理耦合的全部参数。
#[derive(Debug, Clone, Deserialize)]
#[serde(default)]
pub struct TissueConfig {
    // --- 几何 ---
    /// texel 边长（cm）。0.5 时一具 64×140cm 的人体约 3.6 万 texel。
    pub texel_cm: f32,
    /// Jacobi 迭代次数。CPU 8 次，GPU 可上 16。不追残差。
    pub jacobi_iters: u32,

    // --- 压力 / 灌注 ---
    /// 基础**血管床**电导（mL/(s·mmHg)），按组织类型。
    /// 它决定灌注和出血，是这张表里最重要的数。
    pub k0: KindTable,
    /// 组织间连通电导相对血管床的比例。
    ///
    /// 物理上组织间液流动比毛细血管流小几个数量级，所以这里远小于 1。
    /// 它的作用只是给压力场一个"空间尺度"：缺血区和创口周围的低压能扩散多远。
    pub k_inter_ratio: f32,
    /// 动脉端在血管床耦合里占的比例。0.45 → 无创口稳态 `p ≈ 0.45·MAP + 0.55·p_ven`。
    pub arterial_share: f32,
    /// 静脉端压力（mmHg）。
    pub p_venous: f32,
    /// 创口处动脉侧电导的放大倍数。
    ///
    /// 一刀砍断大血管，断端敞在大气里，其电导远高于被它供血的毛细血管床——
    /// 所以这一刀流失的不只是创口那几个 texel 的血，而是整条下游区域的血。
    /// M2 用统一倍数近似；M3 会按解剖图里的 `VesselEdge` 逐根给值。
    pub wound_vessel_boost: f32,

    // --- 氧 ---
    /// 动脉血氧分压（mmHg）。
    pub p_arterial_o2: f32,
    /// 灌注带氧的增益。`dO2/dt = o2_gain·perfusion·(p_art_o2 - o2)`。
    pub o2_gain: f32,
    /// 耗氧速率（mmHg/s），按组织类型。
    pub vo2: KindTable,

    // --- 热 ---
    /// 组织热扩散率（cm²/s）。
    pub thermal_alpha: f32,
    /// 血流带热系数，乘 perfusion。
    pub thermal_blood: f32,
    /// 代谢产热（K/s），每 texel。
    pub metab_heat: f32,
    /// 皮肤与环境的换热系数（1/s）。
    pub env_coupling: f32,
    /// 环境温度（°C）。
    pub ambient_c: f32,
    /// 动脉血温（°C），由 L4 的 t_core 写回。
    pub blood_c: f32,

    // --- 损伤 ---
    /// 缺氧损伤速率（1/s），按 `max(0, o2_threshold - o2)/o2_threshold` 缩放。
    pub hypoxia_damage: f32,
    /// 低于这个氧分压才开始累积缺氧损伤（mmHg）。
    pub o2_threshold: f32,
    /// 过冷损伤速率（1/s），按 `max(0, 28 - T)/28` 缩放。
    pub cold_damage: f32,
    /// 过热损伤速率（1/s），按 `max(0, T - 42)/5` 缩放。
    pub heat_damage: f32,
    /// 电导衰减指数：`K = K0·(1-d)^n`。
    pub conductance_falloff: f32,

    // --- 光栅化 ---
    /// 骨芯相对部件多边形的收缩比（0 = 不生成骨芯）。
    /// 真实骨几何在 M3 由解剖图给出，这里只是占位。
    pub bone_core_ratio: f32,
    /// 创口带半径（cm）。
    pub wound_radius_cm: f32,
}

impl Default for TissueConfig {
    fn default() -> Self {
        Self {
            texel_cm: 0.5,
            jacobi_iters: 8,

            k0: KindTable {
                outside: 0.0,
                skin: 6.0e-5,
                fat: 4.0e-5,
                muscle: 2.3e-4,
                bone: 1.5e-5,
                organ: 1.2e-3,
                air: 2.0e-6,
            },
            k_inter_ratio: 0.1,
            arterial_share: 0.45,
            p_venous: 5.0,
            wound_vessel_boost: 20.0,

            p_arterial_o2: 95.0,
            o2_gain: 0.03,
            vo2: KindTable {
                outside: 0.0,
                skin: 0.020,
                fat: 0.010,
                muscle: 0.030,
                bone: 0.005,
                organ: 0.100,
                air: 0.0,
            },

            thermal_alpha: 0.0013,
            thermal_blood: 0.5,
            metab_heat: 3.6e-4,
            env_coupling: 7.0e-4,
            ambient_c: 22.0,
            blood_c: 37.0,

            hypoxia_damage: 0.004,
            o2_threshold: 10.0,
            cold_damage: 0.001,
            heat_damage: 0.02,
            conductance_falloff: 2.0,

            bone_core_ratio: 0.45,
            wound_radius_cm: 0.6,
        }
    }
}

impl TissueConfig {
    pub fn from_ron(src: &str) -> Result<Self, ron::error::SpannedError> {
        ron::from_str(src)
    }

    /// 内置默认配置（`assets/config/tissue.ron`）。
    pub fn asset() -> Self {
        Self::from_ron(ASSET_TISSUE_CONFIG).expect("内置 tissue.ron 必须能解析")
    }
}
