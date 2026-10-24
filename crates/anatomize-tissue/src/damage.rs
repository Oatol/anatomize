//! 损伤累积。
//!
//! 三种来源，都是"越偏离正常越加速"，且互不排斥：
//!
//! - **缺氧**：氧分压低于阈值，`hypoxia_damage` 缩放
//! - **过冷**：低于 28°C 开始累积（冻伤 / 长时间缺血）
//! - **过热**：高于 42°C 开始累积（烧伤）
//!
//! 损伤有正反馈：`K = K0·(1-d)^n` → 灌注更低 → 更缺氧 → 损伤更快。这是
//! 设计文档 5.1 里"缺血坏死正反馈"的实现，不需要额外的状态机。

use crate::TissueKind;
use crate::TissueField;
use crate::config::TissueConfig;

/// 第 6 步：累积损伤。
pub fn accumulate_damage(f: &mut TissueField, cfg: &TissueConfig, dt: f32) {
    let o2_thresh = cfg.o2_threshold.max(1e-6);
    for i in 0..f.len() {
        if matches!(f.kind[i], TissueKind::Outside | TissueKind::Air) {
            continue;
        }
        let o2 = f.o2[i];
        let t = f.temp[i];

        let mut d = 0.0;
        if o2 < o2_thresh {
            d += cfg.hypoxia_damage * (o2_thresh - o2) / o2_thresh;
        }
        if t < 28.0 {
            d += cfg.cold_damage * (28.0 - t) / 28.0;
        }
        if t > 42.0 {
            d += cfg.heat_damage * (t - 42.0) / 5.0;
        }
        if d > 0.0 {
            f.damage[i] = (f.damage[i] + d * dt).min(1.0);
        }
    }
}

/// 单块组织在零灌注下"多久坏死"的解析估计（秒），用来给测试定参照。
///
/// 从 `o2_0` 线性掉到 `o2_threshold` 所需时间，忽略损伤对电导的反馈。
pub fn time_to_hypoxia(cfg: &TissueConfig, kind: TissueKind, o2_0: f32) -> f32 {
    let vo2 = cfg.vo2.get(kind);
    if vo2 <= 0.0 {
        return f32::INFINITY;
    }
    ((o2_0 - cfg.o2_threshold).max(0.0)) / vo2
}
