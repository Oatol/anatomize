//! 呼吸系统：氧合、氧输送、氧摄取率。
//!
//! M4 只做"肺是好的、气道是通的"这一档：PaO2 就是室内空气值，唯一会变的是
//! 血红蛋白氧饱和度（Hill 曲线）和**氧输送**——因为 DO2 正比于 CO，而 CO 会崩。
//!
//! ```text
//! SaO2 = p^n / (p^n + p50^n)
//! DO2  = CO · 1.34 · Hb · 10 · SaO2      [mL/min]
//! VO2  = 静息耗氧 · 需求系数
//! ERO2 = VO2 / DO2                       [氧摄取率]
//! ```
//!
//! 静息时 ERO2 ≈ 0.25，静脉血还留着 75% 的氧。ERO2 超过 0.6 说明组织已经在
//! 榨取每一滴氧，再往上就只能无氧代谢——那正是"意识开始模糊"的时刻。

use crate::PhysioBus;
use crate::config::PhysioConfig;

/// Hill 曲线：氧分压 → 血红蛋白氧饱和度。
pub fn hill_saturation(p: f32, n: f32, p50: f32) -> f32 {
    let p = p.max(0.0);
    let pn = p.powf(n);
    let half = p50.powf(n);
    if pn + half <= 0.0 {
        return 0.0;
    }
    pn / (pn + half)
}

/// 动脉血氧含量（mL O2 / L 血）。
pub fn arterial_o2_content(hemoglobin: f32, sao2: f32) -> f32 {
    1.34 * hemoglobin * 10.0 * sao2
}

/// 没有组织场时，从供需比反推组织氧分压（mmHg）。
///
/// 这不是生理方程，是一条**单调、量级正确**的拟合：`ERO2 = 0.25` 时给 40 mmHg
/// （正常组织氧），`ERO2 → 1` 时给 0。有组织场的时候不用它——场里的
/// `mean_o2` 才是真值。
pub fn tissue_o2_from_extraction(ero2: f32) -> f32 {
    let x = (1.0 - ero2.clamp(0.0, 1.0)).max(0.0);
    60.0 * x * x
}

/// 跑一个呼吸 tick（10Hz）。
pub fn step(bus: &mut PhysioBus, cfg: &PhysioConfig, dt: f32) {
    let _ = dt; // 气体交换本身没有惯性，M5 加气道梗阻时才会有

    bus.pao2 = cfg.pao2_room;
    bus.sao2 = hill_saturation(bus.pao2, cfg.hill_n, cfg.hill_p50);

    // 氧输送：CO(L/min) × 血氧含量(mL/L)
    bus.do2 = bus.cardiac_output * arterial_o2_content(cfg.hemoglobin, bus.sao2);

    // 耗氧：静息值，交感兴奋时略微上升（心肌做功增加）
    bus.vo2 = cfg.vo2_base * (1.0 + 0.25 * bus.sympathetic_tone);

    bus.ero2 = if bus.do2 > 1e-3 {
        (bus.vo2 / bus.do2).clamp(0.0, 1.0)
    } else {
        1.0
    };

    // 氧债：摄取率超过无氧阈值的部分累积
    let debt_rate = (bus.ero2 - cfg.ero2_anaerobic).max(0.0);
    bus.oxygen_debt = (bus.oxygen_debt + debt_rate * dt * 10.0).clamp(0.0, 10.0);
    // 氧债会还：供氧恢复后按比例消退
    if debt_rate <= 0.0 {
        bus.oxygen_debt = (bus.oxygen_debt - dt * 0.5).max(0.0);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn hill_curve_hits_the_published_points() {
        // p50 = 26.6 mmHg 时饱和度必须是 50%
        let s = hill_saturation(26.6, 2.7, 26.6);
        assert!((s - 0.5).abs() < 1e-5, "p50 处饱和度 {s}");

        // PaO2 = 95（室内空气）→ 0.97 左右
        let s = hill_saturation(95.0, 2.7, 26.6);
        println!("PaO2 95 → SaO2 {s:.4}");
        assert!((s - 0.97).abs() < 0.01, "SaO2 = {s}");

        // PaO2 = 40（混合静脉）→ 0.75 左右
        let s = hill_saturation(40.0, 2.7, 26.6);
        println!("PaO2 40 → SaO2 {s:.4}");
        assert!((s - 0.75).abs() < 0.05, "SaO2 = {s}");
    }

    #[test]
    fn oxygen_delivery_at_rest_is_about_one_litre_per_minute() {
        let cfg = PhysioConfig::default();
        let mut bus = PhysioBus {
            cardiac_output: 5.0,
            ..PhysioBus::default()
        };
        step(&mut bus, &cfg, 0.1);
        println!(
            "DO2 {:.0} mL/min，VO2 {:.0} mL/min，ERO2 {:.2}",
            bus.do2, bus.vo2, bus.ero2
        );
        assert!((bus.do2 - 975.0).abs() < 40.0, "DO2 = {}", bus.do2);
        assert!((bus.ero2 - 0.26).abs() < 0.05, "ERO2 = {}", bus.ero2);
    }

    #[test]
    fn extraction_rises_when_output_falls() {
        let cfg = PhysioConfig::default();
        let mut bus = PhysioBus {
            cardiac_output: 1.5,
            ..PhysioBus::default()
        };
        step(&mut bus, &cfg, 0.1);
        println!(
            "CO 1.5 时 ERO2 {:.2}，氧债 {:.2}",
            bus.ero2, bus.oxygen_debt
        );
        assert!(bus.ero2 > 0.7, "低心输出必须高摄取，实际 {}", bus.ero2);
    }
}
