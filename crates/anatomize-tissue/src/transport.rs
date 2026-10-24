//! 氧输运与热传导。
//!
//! 两个都是显式欧拉，网格是 texel。稳定性由 `dt·α/dx²` 决定，20Hz 下远低于
//! 0.25 的上限，不需要隐式。

use crate::TissueKind;
use crate::TissueField;
use crate::config::TissueConfig;

/// 第 4 步：组织氧。
///
/// ```text
/// dO2/dt = o2_gain·perfusion·(p_art_o2 - O2) - VO2(tissue)
/// ```
///
/// 灌注为 0 时只剩消耗项，氧分压线性掉到 0——这就是"断血之后多久坏死"的由来。
/// 不同组织的 `VO2` 不同，所以脑先死、肌肉后死，不需要额外写规则。
///
/// M2 不做氧的扩散：局部缺血区边缘的"救回来一点"要等 P1 再加。
pub fn transport_o2(f: &mut TissueField, cfg: &TissueConfig, dt: f32) {
    let p_art = cfg.p_arterial_o2;
    for i in 0..f.len() {
        let k = f.kind[i];
        if matches!(k, TissueKind::Outside | TissueKind::Air) {
            f.o2[i] = 0.0;
            continue;
        }
        let supply = cfg.o2_gain * f.perfusion[i] * (p_art - f.o2[i]);
        let demand = cfg.vo2.get(k);
        let o2 = f.o2[i] + (supply - demand) * dt;
        f.o2[i] = o2.clamp(0.0, p_art);
    }
}

/// 第 5 步：热。
///
/// ```text
/// dT/dt = α·∇²T + c_blood·perfusion·(T_blood - T) + q_metab - k_env·(T - T_amb)·[skin]
/// ```
///
/// - 传导：组织内热扩散，边界绝热（没有邻居 = 没有热流）
/// - 血流带热：这是"肢体冰凉"的来源——灌注掉了，这块组织就带不走动脉的 37°C
/// - 代谢产热：每 texel 一个常数
/// - 环境散热：只有皮肤 texel 与环境换热
pub fn thermal(f: &mut TissueField, cfg: &TissueConfig, dt: f32, scratch: &mut [f32]) {
    let w = f.w as usize;
    let h = f.h as usize;
    let inv_dx2 = 1.0 / (f.texel_cm * f.texel_cm);

    for i in 0..f.len() {
        let k = f.kind[i];
        if matches!(k, TissueKind::Outside | TissueKind::Air) {
            scratch[i] = f.temp[i];
            continue;
        }
        let (x, y) = f.xy(i);
        let t = f.temp[i];

        // 绝热边界：缺失或 Outside 的邻居用自己的温度（零梯度）
        let mut lap = 0.0;
        lap += if x + 1 < w as u32 && f.kind[i + 1] != TissueKind::Outside {
            f.temp[i + 1]
        } else {
            t
        };
        lap += if x > 0 && f.kind[i - 1] != TissueKind::Outside {
            f.temp[i - 1]
        } else {
            t
        };
        lap += if y + 1 < h as u32 && f.kind[i + w] != TissueKind::Outside {
            f.temp[i + w]
        } else {
            t
        };
        lap += if y > 0 && f.kind[i - w] != TissueKind::Outside {
            f.temp[i - w]
        } else {
            t
        };
        lap = (lap - 4.0 * t) * inv_dx2;

        let mut d = cfg.thermal_alpha * lap;
        d += cfg.thermal_blood * f.perfusion[i] * (cfg.blood_c - t);
        d += cfg.metab_heat;
        if k == TissueKind::Skin {
            d -= cfg.env_coupling * (t - cfg.ambient_c);
        }
        scratch[i] = t + d * dt;
    }

    let n = f.len();
    f.temp.copy_from_slice(&scratch[..n]);
}
