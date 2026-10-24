//! 0D 腔室生理。
//!
//! **状态：M4 实现。** 这里先定下总线字段，因为 L1/L2 的接口形状取决于它。
//!
//! 设计要点见 `设计文档-v0.2.md` 第 8 节：
//! - 器官之间不互相引用，只读写 [`PhysioBus`]
//! - 耦合关系体现为"谁写哪个字段、谁读哪个字段"

/// 跨器官共享的状态。所有系统都只读写它。
#[derive(Debug, Clone, Copy)]
pub struct PhysioBus {
    /// 血容量，mL。
    pub blood_volume: f32,
    /// 平均动脉压，mmHg。
    pub map: f32,
    /// 心率，bpm。
    pub heart_rate: f32,
    /// 每搏量，mL。
    pub stroke_volume: f32,
    /// 心输出量，L/min。
    pub cardiac_output: f32,
    /// 动脉氧分压，mmHg。
    pub pao2: f32,
    /// 动脉氧饱和度，0..1。
    pub sao2: f32,
    /// 组织氧分压，mmHg。
    pub tissue_o2: f32,
    /// 核心温度，°C。
    pub temp_core: f32,
    /// 血糖，mmol/L。
    pub glucose: f32,
    /// 意识，0..1。
    pub consciousness: f32,
    /// 交感张力，0..1。
    pub sympathetic_tone: f32,
}

impl Default for PhysioBus {
    fn default() -> Self {
        Self {
            blood_volume: 5000.0,
            map: 93.0,
            heart_rate: 72.0,
            stroke_volume: 70.0,
            cardiac_output: 5.0,
            pao2: 95.0,
            sao2: 0.97,
            tissue_o2: 40.0,
            temp_core: 37.0,
            glucose: 5.0,
            consciousness: 1.0,
            sympathetic_tone: 0.3,
        }
    }
}
