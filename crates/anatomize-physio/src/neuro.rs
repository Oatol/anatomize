//! 神经系统：意识。
//!
//! 意识不是一个自由变量，它是**四个"能撑住脑子"的条件里最差的那个**：
//!
//! | 条件 | 阈值 | 为什么 |
//! |---|---|---|
//! | 组织氧分压 | 25 → 8 mmHg | 缺氧 10 秒就晕 |
//! | 平均动脉压 | 65 → 40 mmHg | 脑灌注压 = MAP − 颅压，低于 40 就缺血 |
//! | 血糖 | 3.0 → 1.5 mmol/L | 低血糖昏迷 |
//! | 核心温度 | 34 → 30 °C | 低体温抑制中枢 |
//!
//! 取 `min` 而不是加权和，因为生理上没有"血压很低但氧很足所以还清醒"这回事——
//! 任何一个环节断掉，人就倒了。
//!
//! 一阶滞后的时间常数取 6 秒：这是"从坐着到晕倒"的临床观察量级。

use crate::PhysioBus;
use crate::config::PhysioConfig;
use crate::ramp;

/// 跑一个神经 tick（10Hz）。
pub fn step(bus: &mut PhysioBus, cfg: &PhysioConfig, dt: f32) {
    let f_o2 = ramp(bus.tissue_o2, cfg.pto2_flat, cfg.pto2_wake);
    let f_map = ramp(bus.map, cfg.map_flat, cfg.map_wake);
    let f_glucose = ramp(bus.glucose, cfg.glucose_flat, cfg.glucose_wake);
    let f_temp = ramp(bus.temp_core, cfg.temp_flat, cfg.temp_wake);

    let target = f_o2.min(f_map).min(f_glucose).min(f_temp);
    let k = (dt / cfg.consciousness_tau).min(1.0);
    bus.consciousness += (target - bus.consciousness) * k;
    bus.consciousness = bus.consciousness.clamp(0.0, 1.0);

    // 记下最弱的那个环节，HUD 和调试图直接显示"为什么晕"
    bus.limiting_factor = if target >= f_o2 {
        crate::LimitingFactor::Oxygen
    } else if target >= f_map {
        crate::LimitingFactor::Pressure
    } else if target >= f_glucose {
        crate::LimitingFactor::Glucose
    } else {
        crate::LimitingFactor::Temperature
    };
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn a_healthy_person_is_fully_awake() {
        let cfg = PhysioConfig::default();
        let mut bus = PhysioBus::default();
        for _ in 0..200 {
            step(&mut bus, &cfg, 0.1);
        }
        assert!(bus.consciousness > 0.99, "意识 = {}", bus.consciousness);
        assert_eq!(bus.limiting_factor, crate::LimitingFactor::Oxygen);
    }

    #[test]
    fn hypoxia_and_hypotension_both_knock_you_out() {
        let cfg = PhysioConfig::default();

        let mut low_o2 = PhysioBus {
            tissue_o2: 6.0,
            ..PhysioBus::default()
        };
        for _ in 0..600 {
            step(&mut low_o2, &cfg, 0.1);
        }
        println!("缺氧：意识 {:.2}", low_o2.consciousness);
        assert!(low_o2.consciousness < 0.02);
        assert_eq!(low_o2.limiting_factor, crate::LimitingFactor::Oxygen);

        let mut low_map = PhysioBus {
            map: 35.0,
            ..PhysioBus::default()
        };
        for _ in 0..600 {
            step(&mut low_map, &cfg, 0.1);
        }
        println!("低血压：意识 {:.2}", low_map.consciousness);
        assert!(low_map.consciousness < 0.02);
        assert_eq!(low_map.limiting_factor, crate::LimitingFactor::Pressure);
    }

    #[test]
    fn the_worst_factor_wins_not_the_average() {
        // 血压很好、血糖很好、体温很好，只有氧很低 → 必须晕
        let cfg = PhysioConfig::default();
        let mut bus = PhysioBus {
            map: 120.0,
            glucose: 6.0,
            temp_core: 37.0,
            tissue_o2: 5.0,
            ..PhysioBus::default()
        };
        for _ in 0..600 {
            step(&mut bus, &cfg, 0.1);
        }
        assert!(bus.consciousness < 0.02, "意识 = {}", bus.consciousness);
    }
}
