//! 循环系统：血容量 → 静脉回流 → 心输出量 → 动脉压，外加压力反射。
//!
//! # 为什么不是 `map = co·svr·20 + 2`
//!
//! 设计文档 8.2 的那一版把 `co` 和 `svr` 都写成交感张力的单调升函数，于是
//! **失血会升高血压**：血量掉到 70% 时 `sv = 49`，但 `hr` 涨到 127、`svr` 涨到
//! 2 倍，`map` 反而从 93 冲到 180 以上。那不是一个"补偿到极限然后崩溃"的系统，
//! 而是一个永远稳在设定点、然后突然断崖的开关。
//!
//! 这里换成 Guyton 的静脉回流框架，多了两个关键项：
//!
//! ```text
//! Pms = pms_base · vol/vol0            平均体循环充盈压，正比于血容量
//! RVR = rvr_base · (1 + rvr_gain·Δtone)  静脉回流阻力
//! CO  = (Pms - CVP) / RVR · contractility
//! SVR = svr_base · (1 + svr_gain·Δtone)
//! MAP = CO · SVR + CVP
//! ```
//!
//! 于是交感兴奋**同时**升压和降压：`SVR↑` 抬 MAP，`RVR↑` 减少静脉回流、拉低 CO。
//! 净效果是"能顶住，但顶不住太多"——这正是失血性休克的真实形状。
//!
//! # 失代偿为什么是正反馈
//!
//! `contractility` 随 MAP 下降（冠脉灌注不足）。于是：
//! `MAP↓ → 收缩力↓ → CO↓ → MAP↓`。这是一个正反馈环，环增益必须 < 1，
//! 否则人在 MAP = 60 的那一刻直接从"有点低"跳到"心停"。
//! 环增益 ≈ `co_raw·SVR·(1-floor)/(full-flat)`，默认参数下约 0.68。
//! 改 `contract_flat`/`contract_full` 之前先算这个数。

use crate::PhysioBus;
use crate::config::PhysioConfig;
use crate::ramp;

/// 跑一个循环 tick（20Hz）。
pub fn step(bus: &mut PhysioBus, cfg: &PhysioConfig, dt: f32) {
    // 1. 容量：创口出血 + 不显性失水。血容量不能为负。
    let loss = (bus.hemorrhage_ml_s + cfg.insensible_ml_s).max(0.0) * dt;
    let lost = loss.min(bus.blood_volume);
    bus.blood_volume -= lost;
    bus.blood_lost_ml += lost;

    // 2. 压力反射：一阶滞后。用上一 tick 的 MAP 算目标，天然带 50ms 延迟，
    //    和真实压力反射的神经传导时间同量级。
    //
    //    两路输入：高压感受器看 MAP，低压感受器看容量。少了后一路，失血早期
    //    MAP 还稳在 93 的时候心率就不会动，而临床上那正是第一个体征。
    let map_err = (cfg.map_setpoint - bus.map) / cfg.map_setpoint;
    let vol_err = 1.0 - bus.blood_volume / cfg.blood_volume_ml;
    let target =
        (cfg.tone_base + cfg.baroreflex_gain * map_err + cfg.baroreflex_vol_gain * vol_err)
            .clamp(cfg.tone_min, cfg.tone_max);
    let k = (dt / cfg.baroreflex_tau).min(1.0);
    bus.sympathetic_tone += (target - bus.sympathetic_tone) * k;
    let d_tone = bus.sympathetic_tone - cfg.tone_base;

    // 3. 心率：交感张力 + 体温。低体温会让心率掉下来（M5 的寒战会在这里反打）。
    let temp_factor =
        (1.0 + cfg.hr_temp_gain * (bus.temp_core - cfg.temp_setpoint)).clamp(0.35, 1.5);
    bus.heart_rate = (cfg.hr_base * (1.0 + cfg.hr_gain * d_tone) * temp_factor).max(0.0);

    // 4. 静脉回流 → 心输出量
    let pms = cfg.pms_base * (bus.blood_volume / cfg.blood_volume_ml);
    bus.pms = pms;
    let rvr = cfg.rvr_base * (1.0 + cfg.rvr_gain * d_tone);
    let contractility = cfg.contract_floor
        + (1.0 - cfg.contract_floor) * ramp(bus.map, cfg.contract_flat, cfg.contract_full);
    bus.contractility = contractility;
    bus.cardiac_output = ((pms - cfg.cvp).max(0.0) / rvr * contractility).max(0.0);

    // 5. 每搏量是导出量，不是独立状态
    bus.stroke_volume = if bus.heart_rate > 1.0 {
        bus.cardiac_output * 1000.0 / bus.heart_rate
    } else {
        0.0
    };

    // 6. 动脉压
    bus.svr = cfg.svr_base * (1.0 + cfg.svr_gain * d_tone);
    bus.map = bus.cardiac_output * bus.svr + cfg.cvp;
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::Physio;

    fn run(physio: &mut Physio, seconds: f32) {
        let dt = 1.0 / 20.0;
        for _ in 0..(seconds / dt).round() as u32 {
            step(&mut physio.bus, &physio.cfg, dt);
        }
    }

    #[test]
    fn resting_state_is_nominal() {
        let cfg = PhysioConfig::default();
        let mut physio = Physio::new(cfg);
        run(&mut physio, 60.0);

        let b = physio.bus;
        assert!(
            (b.cardiac_output - 5.0).abs() < 0.05,
            "CO = {}",
            b.cardiac_output
        );
        assert!((b.map - 93.0).abs() < 0.5, "MAP = {}", b.map);
        assert!((b.heart_rate - 72.0).abs() < 0.5, "HR = {}", b.heart_rate);
        assert!(
            (b.stroke_volume - 69.4).abs() < 1.0,
            "SV = {}",
            b.stroke_volume
        );
        assert!(
            (b.sympathetic_tone - 0.30).abs() < 0.01,
            "tone = {}",
            b.sympathetic_tone
        );
    }

    #[test]
    fn losing_thirty_percent_of_blood_is_compensated_not_fatal() {
        let cfg = PhysioConfig::default();
        let mut physio = Physio::new(cfg);
        // 一次性抽掉 1500 mL（30%）
        physio.bus.blood_volume = 3500.0;
        run(&mut physio, 60.0);

        let b = physio.bus;
        println!(
            "失血 30%：MAP {:.1}，HR {:.0}，CO {:.2}，tone {:.2}",
            b.map, b.heart_rate, b.cardiac_output, b.sympathetic_tone
        );
        // 代偿期：MAP 还活着，但已经明显低于 93；心率顶到 132，张力打满
        assert!(b.map > 65.0 && b.map < 90.0, "MAP = {}", b.map);
        assert!(b.heart_rate > 125.0, "HR = {}", b.heart_rate);
        // 张力打满说明交感储备已经用光——再流下去就是失代偿
        assert!(b.sympathetic_tone > 0.98, "tone = {}", b.sympathetic_tone);
    }

    #[test]
    fn losing_half_the_blood_collapses_the_pressure() {
        let cfg = PhysioConfig::default();
        let mut physio = Physio::new(cfg);
        physio.bus.blood_volume = 2500.0;
        run(&mut physio, 60.0);

        let b = physio.bus;
        println!(
            "失血 50%：MAP {:.1}，HR {:.0}，CO {:.2}，收缩力 {:.2}",
            b.map, b.heart_rate, b.cardiac_output, b.contractility
        );
        assert!(b.map < 55.0, "失血一半必须失代偿，实际 MAP = {}", b.map);
        assert!(b.cardiac_output < 2.0, "CO = {}", b.cardiac_output);
    }

    #[test]
    fn decompensation_is_monotone_not_a_cliff() {
        // 血量从 5000 线性降到 1500，MAP 的形状必须是：
        // 先被代偿顶住（略升）→ 张力打满 → 单调下降 → 没有断崖
        let cfg = PhysioConfig::default();
        let mut curve = Vec::new();
        for i in 0..=70 {
            let vol = 5000.0 - i as f32 * 50.0;
            let mut physio = Physio::new(cfg);
            physio.bus.blood_volume = vol;
            run(&mut physio, 40.0);
            curve.push((vol, physio.bus.map, physio.bus.sympathetic_tone));
        }

        // 1. 代偿期血压略升是真实的（失血 10% 左右交感兴奋会顶出 5~8 mmHg），
        //    但不能冲成高血压——那说明张力增益写反了或者太大
        let peak = curve.iter().map(|c| c.1).fold(0.0f32, f32::max);
        println!("MAP 峰值 {peak:.1}（基线 93.0）");
        assert!(peak < 103.0, "代偿期血压冲得太高：{peak:.1}");

        // 2. 张力打满之后必须单调下降，且没有断崖
        let mut worst_jump = 0.0f32;
        let mut prev: Option<f32> = None;
        for (vol, map, tone) in &curve {
            if *tone < 0.99 {
                prev = None;
                continue;
            }
            if let Some(p) = prev {
                assert!(*map <= p + 1e-3, "血量 {vol} 时 MAP 反弹：{p} → {map}");
                worst_jump = worst_jump.max(p - map);
            }
            prev = Some(*map);
        }
        println!("相邻 50mL 血量之间最大 MAP 落差 {worst_jump:.1} mmHg");
        assert!(worst_jump < 12.0, "MAP 有断崖，落差 {worst_jump:.1} mmHg");
    }

    #[test]
    fn hemorrhage_at_the_rate_of_the_whole_cardiac_output_is_fatal_in_about_a_minute() {
        // 物理上限：出血速率不可能超过心输出量（5 L/min = 83 mL/s）。
        // 用这个上限灌，看多久死。
        let cfg = PhysioConfig::default();
        let mut physio = Physio::new(cfg);
        physio.bus.hemorrhage_ml_s = 80.0;

        let dt = 1.0 / 20.0;
        let mut t = 0.0f32;
        let mut map45_at = None;
        while t < 180.0 {
            step(&mut physio.bus, &physio.cfg, dt);
            t += dt;
            if map45_at.is_none() && physio.bus.map < 45.0 {
                map45_at = Some(t);
            }
            if physio.bus.cardiac_output < 0.05 {
                break;
            }
        }
        println!(
            "以 CO 上限出血：MAP<45 在 {:.1}s，心跳停止在 {:.1}s，失血 {:.0} mL",
            map45_at.unwrap_or(f32::NAN),
            t,
            physio.bus.blood_lost_ml
        );
        let at = map45_at.expect("以最大可能速率出血必须失代偿");
        assert!(
            (15.0..60.0).contains(&at),
            "MAP<45 出现在 {at:.1}s，标定跑偏"
        );
    }
}
