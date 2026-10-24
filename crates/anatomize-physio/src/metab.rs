//! 代谢：血糖与核心温度。
//!
//! M4 只做**守恒**，不做调控：体温不产热、不寒战（M5），血糖只有消耗和肝糖原
//! 输出。这一层的职责是"别让意识因为血糖莫名其妙地掉下去"，以及把组织场算出来的
//! 核心温度接到生理总线上。
//!
//! 血糖的稳态不是靠常数维持的，而是靠两个方向相反的项：
//!
//! ```text
//! 消耗   = 基础速率 · 交感系数 · (1 + 3·氧债)     无氧糖解，效率低但能续命
//! 肝输出 = (基线 - 血糖) · k                     低于基线才补，高了不补
//! ```
//!
//! 后者就是糖原分解的粗略形状：它把血糖拉回基线，但**不会把吃进去的糖按回去**。
//! M5 加胰岛素之后，"喂 500 kcal → 血糖冲高 → 2 小时回落"这条曲线才会完整。

use crate::PhysioBus;
use crate::config::PhysioConfig;

/// 跑一个代谢 tick（1Hz）。
pub fn step(bus: &mut PhysioBus, cfg: &PhysioConfig, dt: f32, core_temp: Option<f32>) {
    // 核心温度跟随组织场。没有场的时候停在设定点。
    if let Some(t) = core_temp {
        let k = (dt / cfg.temp_tau).min(1.0);
        bus.temp_core += (t - bus.temp_core) * k;
    }

    // 血糖：消耗 - 肝输出
    let demand =
        cfg.glucose_use * (0.7 + 0.6 * bus.sympathetic_tone) * (1.0 + 3.0 * bus.oxygen_debt);
    let hepatic = if bus.glucose < cfg.glucose_base {
        (cfg.glucose_base - bus.glucose) * 0.02
    } else {
        0.0
    };
    bus.glucose = (bus.glucose + (hepatic - demand) * dt).clamp(0.0, 40.0);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn fasting_glucose_settles_just_below_the_baseline() {
        let cfg = PhysioConfig::default();
        let mut bus = PhysioBus::default();
        for _ in 0..3600 {
            step(&mut bus, &cfg, 1.0, None);
        }
        println!("1 小时后血糖 {:.2} mmol/L", bus.glucose);
        assert!(
            (4.5..5.0).contains(&bus.glucose),
            "空腹血糖应该稳在 4.5~5.0，实际 {}",
            bus.glucose
        );
    }

    #[test]
    fn a_sugar_load_is_not_absorbed_back_down() {
        // 喂进去的糖只能被消耗掉，肝输出不会把它按回去
        let cfg = PhysioConfig::default();
        let mut bus = PhysioBus {
            glucose: 8.0,
            ..PhysioBus::default()
        };
        for _ in 0..600 {
            step(&mut bus, &cfg, 1.0, None);
        }
        println!("10 分钟后血糖 {:.2} mmol/L", bus.glucose);
        assert!(
            bus.glucose > 5.0 && bus.glucose < 8.0,
            "血糖 {}",
            bus.glucose
        );
    }

    #[test]
    fn core_temperature_follows_the_tissue_field() {
        let cfg = PhysioConfig::default();
        let mut bus = PhysioBus::default();
        for _ in 0..60 {
            step(&mut bus, &cfg, 1.0, Some(34.0));
        }
        println!("1 分钟后核心温度 {:.2} °C", bus.temp_core);
        assert!((bus.temp_core - 34.0).abs() < 0.2, "温度 {}", bus.temp_core);
    }
}
