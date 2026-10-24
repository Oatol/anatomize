//! 代谢：体温调节、血糖、消化。
//!
//! 这一层是 M5 的"慢变量"。三条曲线的时间常数差三个数量级：
//!
//! | 过程 | 时间常数 | 谁在驱动 |
//! |---|---|---|
//! | 寒战 / 出汗 | 秒 | 深部温度偏差 |
//! | 血糖 | 分钟 | 胃排空 + 胰岛素 |
//! | 核心温度 | 十分钟 | 组织场的传导 + 血流 |
//!
//! # 体温是一个热平衡，不是一次滤波
//!
//! ```text
//! C_body·dT_core/dt = BMR·metab_scale − k·(T_skin − T_amb)
//! ```
//!
//! **M5 第一版写错了**：让 `temp_core` 一阶跟随组织场的核心温度。跑出来核心温度
//! 反而**升高**了 0.24°C——因为组织场的核心区只有代谢产热、没有散热路径，
//! 而 `blood_c` 又被写成"跟随核心温度"，于是产热把整个系统一路推高。
//!
//! 错在把"核心温度"当成了一个被动的观测量。它其实是一个**状态**，由产热和散热
//! 的差额决定；而散热发生在皮肤，皮肤温度由组织场算（它知道环境温度、血流带热、
//! 组织传导）。所以分工是：
//!
//! - **L2 出皮肤温度**（空间、局部、可视化）
//! - **L4 出核心温度**（集总、能量守恒）
//! - **L4 把核心温度写回 `blood_c`**，组织场的核心区就被钉在这个值上
//!
//! 这才是一条闭合的链：环境冷 → 皮肤冷 → 散热大 → 核心掉 → 血温掉 → 皮肤更冷。
//!
//! # 血糖
//!
//! 两个胃（胃 → 小肠）+ 一个胰岛素，四个方程：
//!
//! ```text
//! dS/dt   = -S / tau_gastric                     胃排空（mmol）
//! dJ/dt   =  S/tau_gastric - J/tau_intestine      小肠转运
//! absorb  =  J / tau_intestine                    吸收入血（mmol/s）
//! dI/dt   = (gain·(G - G_base) - I) / tau_ins     胰岛素（相对值）
//! dG/dt   = (absorb - uptake + hepatic - basal) / V
//! ```
//!
//! **为什么要两个腔室。** 单腔室（一阶排空）的吸收入血速率在 t=0 就是最大值，
//! 于是血糖 9 分钟就冲到峰值、20 分钟就落回来——实测踩到过（峰值 8.5 @ 9 分钟）。
//! 真实的固体胃排空有 15~20 分钟的**滞后相**，血糖峰值在 30~45 分钟。
//! 串一个腔室，峰值自然往后推，不需要写"延迟"这种特判。
//!
//! 关键在 `V`：葡萄糖溶在**全身细胞外液**（约 15 L）里，不是只溶在血浆里。
//! 用 5 L 算的话，一顿饭能把血糖顶到 30 mmol/L——那是糖尿病酮症酸中毒的数值，
//! 不是一顿饭。

use crate::PhysioBus;
use crate::config::PhysioConfig;

/// 一个代谢 tick 从组织场拿到的热学边界。
#[derive(Debug, Clone, Copy, Default)]
pub struct ThermalInput {
    /// 皮肤平均温度（°C）。`None` 表示没有组织场。
    pub skin_temp: Option<f32>,
    /// 环境温度（°C）。
    pub ambient_c: f32,
}

/// 跑一个代谢 tick（1Hz）。
pub fn step(bus: &mut PhysioBus, cfg: &PhysioConfig, dt: f32, thermal: ThermalInput) {
    // --- 1. 核心温度：能量守恒 ---
    //
    // 没有组织场时没有皮肤温度可用，退化成"维持在设定点"——这是给纯生理单元
    // 测试用的兜底，不是玩法路径。
    match thermal.skin_temp {
        Some(skin) => {
            let q_metab = cfg.bmr_watt * bus.metab_scale; // W
            let q_loss = cfg.heat_loss_w_per_k * (skin - thermal.ambient_c); // W
            let c_body = cfg.body_heat_capacity_kj_per_k * 1000.0; // J/K
            bus.temp_core += (q_metab - q_loss) / c_body * dt;
            bus.temp_core = bus.temp_core.clamp(20.0, 43.0);
            bus.heat_balance_w = q_metab - q_loss;
        }
        None => {
            bus.temp_core += (cfg.temp_setpoint - bus.temp_core) * (dt / cfg.temp_tau).min(1.0);
            bus.heat_balance_w = 0.0;
        }
    }

    // --- 2. 体温调节：寒战与出汗 ---
    // 两个都是"偏离设定点越远越强"，方向相反，而且都饱和。
    bus.shiver = ((cfg.shiver_onset - bus.temp_core) * cfg.shiver_gain).clamp(0.0, 1.0);
    bus.sweat = ((bus.temp_core - cfg.sweat_onset) * cfg.sweat_gain).clamp(0.0, 1.0);
    // 代谢率倍率：寒战产热、出汗散热。
    bus.metab_scale =
        (1.0 + cfg.shiver_boost * bus.shiver - cfg.sweat_boost * bus.sweat).clamp(0.2, 2.5);

    // --- 3. 消化：胃 → 小肠 → 血 ---
    let empty = bus.stomach_mmol / cfg.gastric_tau;
    bus.stomach_mmol = (bus.stomach_mmol - empty * dt).max(0.0);
    bus.intestine_mmol += (empty - bus.intestine_mmol / cfg.intestine_tau) * dt;
    bus.intestine_mmol = bus.intestine_mmol.max(0.0);
    let absorb = bus.intestine_mmol / cfg.intestine_tau; // mmol/s

    // --- 4. 胰岛素：血糖高才分泌，有滞后 ---
    let above = (bus.glucose - cfg.glucose_base).max(0.0);
    let i_target = cfg.insulin_gain * above;
    let ki = (dt / cfg.insulin_tau).min(1.0);
    bus.insulin += (i_target - bus.insulin) * ki;
    bus.insulin = bus.insulin.max(0.0);

    // --- 5. 摄取、肝输出、基础消耗 ---
    let uptake = cfg.insulin_uptake * bus.insulin;
    let deficit = (cfg.glucose_base - bus.glucose).max(0.0);
    let hepatic = deficit * cfg.hepatic_gain * cfg.glucose_volume_l;
    // 基础消耗（脑、红细胞，不依赖胰岛素）
    let basal = cfg.glucose_use
        * (0.7 + 0.6 * bus.sympathetic_tone)
        * cfg.glucose_volume_l
        * (1.0 + 3.0 * bus.oxygen_debt);

    let dg = (absorb - uptake + hepatic - basal) / cfg.glucose_volume_l;
    bus.glucose = (bus.glucose + dg * dt).clamp(0.0, 40.0);
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::Physio;

    /// 用固定皮肤温度 + 环境温度驱动（`None` = 没有组织场）。
    fn run(physio: &mut Physio, seconds: f32, skin: Option<f32>) {
        run_at(physio, seconds, skin, 22.0);
    }

    fn run_at(physio: &mut Physio, seconds: f32, skin: Option<f32>, ambient: f32) {
        let t = ThermalInput {
            skin_temp: skin,
            ambient_c: ambient,
        };
        for _ in 0..seconds.round() as u32 {
            step(&mut physio.bus, &physio.cfg, 1.0, t);
        }
    }

    #[test]
    fn fasting_glucose_settles_just_below_the_baseline() {
        let cfg = PhysioConfig::default();
        let mut physio = Physio::new(cfg);
        run(&mut physio, 3600.0, None);
        println!("1 小时后血糖 {:.2} mmol/L", physio.bus.glucose);
        assert!(
            (4.3..5.0).contains(&physio.bus.glucose),
            "空腹血糖应该稳在 4.3~5.0，实际 {}",
            physio.bus.glucose
        );
    }

    #[test]
    fn a_meal_raises_then_lowers_glucose() {
        let cfg = PhysioConfig::default();
        let mut physio = Physio::new(cfg);
        run(&mut physio, 1200.0, None);
        let base = physio.bus.glucose;

        physio.feed(500.0);
        println!("喂 500 kcal → 胃里 {:.0} mmol", physio.bus.stomach_mmol);

        let mut peak = base;
        let mut peak_at = 0.0f32;
        let mut at30 = 0.0f32;
        let mut at120 = 0.0f32;
        let mut peak_absorb = 0.0f32;
        for m in 1..=120 {
            run(&mut physio, 60.0, None);
            let g = physio.bus.glucose;
            if g > peak {
                peak = g;
                peak_at = m as f32;
            }
            peak_absorb = peak_absorb.max(physio.bus.intestine_mmol / physio.cfg.intestine_tau);
            if m == 30 {
                at30 = g;
            }
            if m == 120 {
                at120 = g;
            }
        }
        println!(
            "基线 {base:.2}，峰值 {peak:.2} @ {peak_at:.0} 分钟，30 分钟 {at30:.2}，120 分钟 {at120:.2}；峰值吸收 {:.3} mmol/s",
            peak_absorb
        );
        assert!(at30 - base >= 2.0, "30 分钟必须升 ≥2 mmol/L，实际 +{:.2}", at30 - base);
        assert!((at120 - base).abs() <= 0.5, "2 小时必须回落到 ±0.5，实际 {at120:.2}");
    }

    /// 皮肤 32°C / 环境 22°C 是标定基准：散热 10·10 = 100 W = BMR，
    /// 于是核心温度应该稳在 37 附近不动。
    #[test]
    fn a_warm_body_holds_its_temperature() {
        let cfg = PhysioConfig::default();
        let mut physio = Physio::new(cfg);
        run(&mut physio, 600.0, Some(32.0));
        println!(
            "皮肤 32 / 环境 22：核心 {:.3}°C，热平衡 {:.1} W",
            physio.bus.temp_core, physio.bus.heat_balance_w
        );
        assert!((physio.bus.temp_core - 37.0).abs() < 0.15, "核心 {}", physio.bus.temp_core);
        assert!(physio.bus.shiver < 0.01);
        assert!(physio.bus.sweat < 0.01);
    }

    /// 皮肤掉到 26°C：散热 160 W，净失 60 W → 每小时掉约 0.9°C。
    #[test]
    fn a_cold_skin_makes_the_core_fall_and_triggers_shivering() {
        let cfg = PhysioConfig::default();
        let mut physio = Physio::new(cfg);
        run_at(&mut physio, 1800.0, Some(26.0), 5.0);
        println!(
            "皮肤 26 / 环境 5：核心 {:.2}°C，寒战 {:.2}，代谢率 ×{:.2}，热平衡 {:.0} W",
            physio.bus.temp_core, physio.bus.shiver, physio.bus.metab_scale, physio.bus.heat_balance_w
        );
        assert!(physio.bus.temp_core < 36.8, "核心 {}", physio.bus.temp_core);
        assert!(physio.bus.shiver > 0.8, "寒战 {}", physio.bus.shiver);
        assert!(physio.bus.metab_scale > 1.25, "代谢率 {}", physio.bus.metab_scale);
    }

    #[test]
    fn sweating_kicks_in_when_the_core_overheats() {
        let cfg = PhysioConfig::default();
        let mut physio = Physio::new(cfg);
        run_at(&mut physio, 1800.0, Some(38.0), 35.0);
        println!(
            "皮肤 38 / 环境 35：核心 {:.2}°C，出汗 {:.2}，代谢率 ×{:.2}",
            physio.bus.temp_core, physio.bus.sweat, physio.bus.metab_scale
        );
        assert!(physio.bus.sweat > 0.5, "出汗 {}", physio.bus.sweat);
        assert!(physio.bus.metab_scale < 0.8, "代谢率 {}", physio.bus.metab_scale);
        assert!(physio.bus.temp_core > 37.3, "核心 {}", physio.bus.temp_core);
    }
}
