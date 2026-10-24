//! 0D 腔室生理：循环、呼吸、神经、代谢。
//!
//! 设计要点见 `设计文档-v0.2.md` 第 8 节：
//!
//! - 器官之间不互相引用，只读写 [`PhysioBus`]
//! - 耦合关系体现为"谁写哪个字段、谁读哪个字段"
//! - 多速率：循环 20Hz / 呼吸 10Hz / 神经 10Hz / 代谢 1Hz（见 [`anatomize_core::time`]）
//!
//! # 依赖方向
//!
//! ```text
//! 循环 → 呼吸 → 神经
//!  ↑            ↓
//!  └── 代谢 ←───┘
//! ```
//!
//! 箭头只表示"读的是上一 tick 的值"，没有隐式顺序。真正的闭环是**跨层**的：
//!
//! ```text
//! L2 组织场：创口通量 Q → L4 血容量 → MAP → L2 压力场 → Q
//! ```
//!
//! 这个环由 `anatomize-sim` 每 tick 走一圈，环路延迟 50ms（一个组织 tick），
//! 而环里最慢的时间常数是 3 秒（压力反射），所以稳定。
//!
//! # 一条必须守住的纪律
//!
//! **出血速率只能从组织场来。** 任何"每秒失血 X mL"的常数都是血条游戏的开始，
//! 也是设计文档第 13 节把 M2 排在 M4 前面的原因。

pub mod circulation;
pub mod config;
pub mod metab;
pub mod neuro;
pub mod respiration;

pub use config::{ASSET_PHYSIO_CONFIG, PhysioConfig};
pub use respiration::{arterial_o2_content, hill_saturation, tissue_o2_from_extraction};

use anatomize_core::time::dt_of;
use anatomize_core::{DT, METAB_HZ, NEURO_HZ, PHYSIO_HZ, RESP_HZ, Tick};

/// 线性斜坡：`x ≤ lo` 给 0，`x ≥ hi` 给 1，中间线性。
#[inline]
pub fn ramp(x: f32, lo: f32, hi: f32) -> f32 {
    if hi <= lo {
        return if x >= hi { 1.0 } else { 0.0 };
    }
    ((x - lo) / (hi - lo)).clamp(0.0, 1.0)
}

/// 意识当前被哪个环节卡住。HUD 直接显示这个，比显示四个数有用。
#[derive(Debug, Clone, Copy, PartialEq, Eq, Default)]
pub enum LimitingFactor {
    #[default]
    Oxygen,
    Pressure,
    Glucose,
    Temperature,
}

impl LimitingFactor {
    pub fn name(self) -> &'static str {
        match self {
            LimitingFactor::Oxygen => "o2",
            LimitingFactor::Pressure => "map",
            LimitingFactor::Glucose => "glucose",
            LimitingFactor::Temperature => "temp",
        }
    }
}

/// 跨器官共享的状态。所有系统都只读写它。
#[derive(Debug, Clone, Copy)]
pub struct PhysioBus {
    // --- 容量与压力 ---
    /// 血容量，mL。
    pub blood_volume: f32,
    /// 累计失血，mL。验收与 HUD 用。
    pub blood_lost_ml: f32,
    /// 当前创口出血速率，mL/s。**由 L2 组织场写，不在这里算。**
    pub hemorrhage_ml_s: f32,
    /// 平均动脉压，mmHg。
    pub map: f32,
    /// 平均体循环充盈压，mmHg。正比于血容量，是静脉回流的驱动力。
    pub pms: f32,
    /// 体循环阻力，mmHg·min/L。
    pub svr: f32,

    // --- 心脏 ---
    /// 心率，bpm。
    pub heart_rate: f32,
    /// 每搏量，mL。导出量 `CO·1000/HR`。
    pub stroke_volume: f32,
    /// 心输出量，L/min。
    pub cardiac_output: f32,
    /// 心肌收缩力 0..1。随 MAP 下降（冠脉缺血），是失代偿的正反馈来源。
    pub contractility: f32,

    // --- 气体 ---
    /// 动脉氧分压，mmHg。
    pub pao2: f32,
    /// 动脉氧饱和度，0..1。
    pub sao2: f32,
    /// 组织氧分压，mmHg。有组织场时是场里的均值，没有时由供需比推算。
    pub tissue_o2: f32,
    /// 氧输送，mL/min。
    pub do2: f32,
    /// 耗氧，mL/min。
    pub vo2: f32,
    /// 氧摄取率 `VO2/DO2`。静息 0.25，>0.6 开始无氧代谢。
    pub ero2: f32,
    /// 氧债（无量纲累积量）。M5 用它驱动乳酸与呼吸性酸中毒。
    pub oxygen_debt: f32,

    // --- 代谢与神经 ---
    /// 核心温度，°C。
    pub temp_core: f32,
    /// 血糖，mmol/L。
    pub glucose: f32,
    /// 意识，0..1。
    pub consciousness: f32,
    /// 交感张力，0..1。
    pub sympathetic_tone: f32,
    /// 意识当前被哪个环节卡住。
    pub limiting_factor: LimitingFactor,
}

impl Default for PhysioBus {
    fn default() -> Self {
        Self {
            blood_volume: 5000.0,
            blood_lost_ml: 0.0,
            hemorrhage_ml_s: 0.0,
            map: 93.0,
            pms: 8.0,
            svr: 18.2,

            heart_rate: 72.0,
            stroke_volume: 69.4,
            cardiac_output: 5.0,
            contractility: 1.0,

            pao2: 95.0,
            sao2: 0.97,
            tissue_o2: 40.0,
            do2: 975.0,
            vo2: 250.0,
            ero2: 0.26,
            oxygen_debt: 0.0,

            temp_core: 37.0,
            glucose: 5.0,
            consciousness: 1.0,
            sympathetic_tone: 0.30,
            limiting_factor: LimitingFactor::Oxygen,
        }
    }
}

/// 一个 tick 从 L1/L2 拿到的输入。
#[derive(Debug, Clone, Copy, Default)]
pub struct PhysioInput {
    /// 创口出血速率（mL/s）。来自组织场 `TissueStep::wound_flux`。
    pub hemorrhage_ml_s: f32,
    /// 组织平均氧分压（mmHg）。来自组织场，`None` 表示没有场。
    pub tissue_o2: Option<f32>,
    /// 核心温度（°C）。来自组织场。
    pub core_temp: Option<f32>,
}

impl PhysioInput {
    /// 没有组织场时的输入：不出血、无氧温数据（由供需比推算）。
    pub fn none() -> Self {
        Self::default()
    }

    pub fn with_hemorrhage(ml_s: f32) -> Self {
        Self {
            hemorrhage_ml_s: ml_s,
            ..Self::default()
        }
    }
}

/// 一整套生理系统。持有总线、参数和死亡判定。
pub struct Physio {
    pub bus: PhysioBus,
    pub cfg: PhysioConfig,
    /// 累计仿真时间（s）。
    pub elapsed: f32,
    /// 心输出量归零已经持续了多久（s）。
    pub arrest_for: f32,
    /// 判定死亡后为 `true`：一切主动过程停止，组织场进入"死后均匀降温"。
    pub dead: bool,
    /// `true` 表示 `bus.tissue_o2` 来自组织场；`false` 表示是供需比推算的。
    pub o2_from_field: bool,
}

impl Physio {
    pub fn new(cfg: PhysioConfig) -> Self {
        Self {
            bus: PhysioBus::default(),
            cfg,
            elapsed: 0.0,
            arrest_for: 0.0,
            dead: false,
            o2_from_field: false,
        }
    }

    /// 内置默认参数。
    pub fn asset() -> Self {
        Self::new(PhysioConfig::asset())
    }

    /// 推进一个物理 tick。各子系统按自己的频率抽头。
    pub fn step(&mut self, input: PhysioInput, tick: Tick) {
        self.bus.hemorrhage_ml_s = input.hemorrhage_ml_s;
        self.elapsed += DT;

        // 1. 循环（20Hz）
        if tick.physio_due() {
            circulation::step(&mut self.bus, &self.cfg, dt_of(PHYSIO_HZ));
        }

        // 2. 呼吸（10Hz）——同时决定组织氧的来源
        if tick.resp_due() {
            respiration::step(&mut self.bus, &self.cfg, dt_of(RESP_HZ));
            match input.tissue_o2 {
                Some(o2) => {
                    self.bus.tissue_o2 = o2;
                    self.o2_from_field = true;
                }
                None => {
                    self.bus.tissue_o2 = tissue_o2_from_extraction(self.bus.ero2);
                    self.o2_from_field = false;
                }
            }
        }

        // 3. 神经（10Hz）
        if tick.neuro_due() {
            neuro::step(&mut self.bus, &self.cfg, dt_of(NEURO_HZ));
        }

        // 4. 代谢（1Hz）
        if tick.metab_due() {
            metab::step(&mut self.bus, &self.cfg, dt_of(METAB_HZ), input.core_temp);
        }

        self.update_death();
    }

    fn update_death(&mut self) {
        if self.bus.cardiac_output < 0.05 {
            self.arrest_for += DT;
        } else {
            self.arrest_for = 0.0;
        }
        if !self.dead && self.arrest_for >= self.cfg.arrest_death_s {
            self.dead = true;
        }
        if self.dead {
            // 死人不会醒，也不会再出血：MAP 已经降到 CVP，创口通量自然归零。
            self.bus.consciousness = 0.0;
        }
    }

    /// 推进 `seconds` 秒（按 60Hz 的 tick 走），忽略组织场。测试与标定用。
    pub fn run_seconds(&mut self, seconds: f32, input: PhysioInput) {
        let n = (seconds / DT).round() as u64;
        let start = (self.elapsed / DT).round() as u64;
        for i in 0..n {
            self.step(input, Tick(start + i));
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn asset_config_parses() {
        let cfg = PhysioConfig::asset();
        assert!((cfg.blood_volume_ml - 5000.0).abs() < 1e-3);
        assert!((cfg.map_setpoint - 93.0).abs() < 1e-3);
    }

    #[test]
    fn a_body_with_no_field_still_has_plausible_blood_gases() {
        let mut p = Physio::asset();
        p.run_seconds(30.0, PhysioInput::none());
        let b = p.bus;
        println!(
            "无组织场 30s：MAP {:.1}，CO {:.2}，DO2 {:.0}，组织氧 {:.1}，意识 {:.2}",
            b.map, b.cardiac_output, b.do2, b.tissue_o2, b.consciousness
        );
        assert!(b.consciousness > 0.95, "健康人必须清醒");
        assert!(!p.o2_from_field);
    }

    #[test]
    fn sustained_hemorrhage_eventually_kills() {
        let mut p = Physio::asset();
        // 直接灌一个恒定出血（不走组织场，这是测试不是玩法）
        p.run_seconds(120.0, PhysioInput::with_hemorrhage(60.0));
        let b = p.bus;
        println!(
            "60 mL/s 出血 120s：血容量 {:.0}，MAP {:.1}，HR {:.0}，意识 {:.2}，死 {}",
            b.blood_volume, b.map, b.heart_rate, b.consciousness, p.dead
        );
        assert!(b.blood_volume < 2500.0, "血量 {}", b.blood_volume);
        assert!(b.map < 60.0, "MAP {}", b.map);
        assert!(b.consciousness < 0.3, "意识 {}", b.consciousness);
    }

    #[test]
    fn stopping_the_bleed_stops_the_decline() {
        let mut p = Physio::asset();
        p.run_seconds(60.0, PhysioInput::with_hemorrhage(60.0));
        let map_at_stop = p.bus.map;
        // 止血之后，血容量不再下降，MAP 由压力反射慢慢拉回来一点
        p.run_seconds(30.0, PhysioInput::none());
        println!(
            "止血时 MAP {:.1} → 30s 后 {:.1}（血量 {:.0}）",
            map_at_stop, p.bus.map, p.bus.blood_volume
        );
        assert!(p.bus.map >= map_at_stop - 0.5, "止血后 MAP 不该继续掉");
    }
}
