//! 组织场热力图的通道定义与配色。
//!
//! 放在 core 里：宿主（窗口版）和离线工具（`paint_heatmap`）要画同一套颜色，
//! 归一化范围也要一致，否则同一个身体在两边看起来不一样。

/// 组织场热力图的通道。
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum HeatChannel {
    Perfusion,
    Oxygen,
    Temperature,
    Damage,
}

impl HeatChannel {
    pub const ALL: [HeatChannel; 4] = [
        HeatChannel::Perfusion,
        HeatChannel::Oxygen,
        HeatChannel::Temperature,
        HeatChannel::Damage,
    ];

    pub fn name(self) -> &'static str {
        match self {
            HeatChannel::Perfusion => "灌注",
            HeatChannel::Oxygen => "氧分压",
            HeatChannel::Temperature => "温度",
            HeatChannel::Damage => "损伤",
        }
    }

    /// 把某个通道的原始值归一化到 0..1。量程是"生理上说得通"的范围，
    /// 不是自动拉伸——自动拉伸会让一个几乎全黑的场看起来花里胡哨。
    pub fn normalize(self, v: f32) -> f32 {
        match self {
            HeatChannel::Perfusion => (v / 0.02).clamp(0.0, 1.0),
            HeatChannel::Oxygen => (v / 60.0).clamp(0.0, 1.0),
            HeatChannel::Temperature => ((v - 20.0) / 20.0).clamp(0.0, 1.0),
            HeatChannel::Damage => v.clamp(0.0, 1.0),
        }
    }

    /// 0..1 → 颜色。
    pub fn color(self, v: f32) -> [u8; 4] {
        let v = v.clamp(0.0, 1.0);
        match self {
            // 灌注：黑 → 青 → 白。低灌注是黑的，一眼看出来。
            HeatChannel::Perfusion => [
                (40.0 + 215.0 * v * v) as u8,
                (30.0 + 225.0 * v) as u8,
                (60.0 + 195.0 * v) as u8,
                255,
            ],
            // 氧：深紫 → 亮红
            HeatChannel::Oxygen => [
                (60.0 + 195.0 * v) as u8,
                (20.0 + 90.0 * v) as u8,
                (90.0 - 50.0 * v) as u8,
                255,
            ],
            // 温度：蓝 → 红
            HeatChannel::Temperature => [
                (30.0 + 225.0 * v) as u8,
                (60.0 + 120.0 * (1.0 - (v - 0.5).abs() * 2.0).max(0.0)) as u8,
                (200.0 - 170.0 * v) as u8,
                255,
            ],
            // 损伤：暗 → 亮黄
            HeatChannel::Damage => [
                (255.0 * v + 40.0 * (1.0 - v)) as u8,
                (220.0 * v + 40.0 * (1.0 - v)) as u8,
                (40.0 * (1.0 - v)) as u8,
                255,
            ],
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn every_channel_is_opaque_and_bounded() {
        for ch in HeatChannel::ALL {
            for i in 0..=10 {
                let c = ch.color(i as f32 / 10.0);
                assert_eq!(c[3], 255);
            }
            assert_eq!(ch.normalize(-1e9), 0.0);
            assert_eq!(ch.normalize(1e9), 1.0);
        }
    }
}
