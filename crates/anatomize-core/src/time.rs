//! 固定步长的时间。整个模拟只有一个时钟：60Hz。
//!
//! 上层系统按各自的频率"抽头"：物理每 tick 都跑，组织场每 3 tick，生理每 3 tick，
//! 呼吸/神经每 6 tick，代谢每 60 tick。**所有频率都必须整除 60**，否则会出现
//! 一个 tick 里跑两次、下一个 tick 里不跑的抖动，生理量的曲线会开始锯齿。

/// 物理与伤害判定的频率。
pub const TICK_HZ: u32 = 60;

/// 单步时长（秒）。
pub const DT: f32 = 1.0 / TICK_HZ as f32;

/// 组织场的频率（每 3 个物理 tick 更新一次）。
pub const TISSUE_HZ: u32 = 20;

/// 循环系统的频率（压力反射、CO、MAP）。
pub const PHYSIO_HZ: u32 = 20;

/// 呼吸系统的频率（气体交换、PaO2、DO2）。
pub const RESP_HZ: u32 = 10;

/// 神经系统的频率（意识、疼痛整合）。
pub const NEURO_HZ: u32 = 10;

/// 代谢的频率（血糖、乳酸、体温调定点）。
pub const METAB_HZ: u32 = 1;

/// 自世界创建以来的 tick 数。
#[derive(Debug, Clone, Copy, Default, PartialEq, Eq, PartialOrd, Ord)]
pub struct Tick(pub u64);

impl Tick {
    pub fn advance(&mut self) -> u64 {
        self.0 += 1;
        self.0
    }

    pub fn seconds(self) -> f64 {
        self.0 as f64 * DT as f64
    }

    /// 以 `hz` 运行的子系统是否该在这一 tick 更新。
    ///
    /// 频率不整除 [`TICK_HZ`] 时退化成"每 tick 都跑"——宁可多算，也不要漏算。
    pub fn due(self, hz: u32) -> bool {
        let stride = TICK_HZ / hz.max(1);
        if stride <= 1 {
            return true;
        }
        self.0.is_multiple_of(stride as u64)
    }

    /// 组织场是否该在这一 tick 更新。
    pub fn tissue_due(self) -> bool {
        self.due(TISSUE_HZ)
    }

    /// 循环系统是否该在这一 tick 更新。
    pub fn physio_due(self) -> bool {
        self.due(PHYSIO_HZ)
    }

    /// 呼吸系统是否该在这一 tick 更新。
    pub fn resp_due(self) -> bool {
        self.due(RESP_HZ)
    }

    /// 神经系统是否该在这一 tick 更新。
    pub fn neuro_due(self) -> bool {
        self.due(NEURO_HZ)
    }

    /// 代谢是否该在这一 tick 更新。
    pub fn metab_due(self) -> bool {
        self.due(METAB_HZ)
    }
}

/// 某个频率下的单步时长（秒）。子系统用这个而不是 [`DT`]。
#[inline]
pub fn dt_of(hz: u32) -> f32 {
    1.0 / hz.max(1) as f32
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn every_subsystem_frequency_divides_the_tick_rate() {
        for hz in [TISSUE_HZ, PHYSIO_HZ, RESP_HZ, NEURO_HZ, METAB_HZ] {
            assert_eq!(TICK_HZ % hz, 0, "{hz}Hz 不整除 {TICK_HZ}Hz");
        }
    }

    #[test]
    fn rates_are_nested_so_a_slow_system_never_runs_alone() {
        // 1Hz 的代谢只该在 10Hz 的神经也跑的 tick 上跑，否则一帧里会出现
        // "只更新了代谢、没更新神经"的中间态
        for t in 0..600u64 {
            let tick = Tick(t);
            if tick.metab_due() {
                assert!(tick.neuro_due() && tick.resp_due() && tick.physio_due());
            }
            if tick.resp_due() {
                assert!(tick.physio_due());
            }
            if tick.physio_due() {
                assert!(tick.tissue_due());
            }
        }
    }

    #[test]
    fn counts_match_the_declared_frequencies() {
        let n = 600u64; // 10 秒
        let count = |f: fn(Tick) -> bool| (0..n).filter(|t| f(Tick(*t))).count();
        assert_eq!(count(Tick::tissue_due), (TISSUE_HZ * 10) as usize);
        assert_eq!(count(Tick::physio_due), (PHYSIO_HZ * 10) as usize);
        assert_eq!(count(Tick::resp_due), (RESP_HZ * 10) as usize);
        assert_eq!(count(Tick::metab_due), (METAB_HZ * 10) as usize);
    }

    #[test]
    fn dt_of_matches_the_rate() {
        assert!((dt_of(PHYSIO_HZ) - 0.05).abs() < 1e-6);
        assert!((dt_of(METAB_HZ) - 1.0).abs() < 1e-6);
    }
}
