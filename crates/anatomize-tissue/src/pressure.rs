//! 压力求解：稳态达西流的五点格式 Jacobi 迭代。
//!
//! # 离散方程
//!
//! 对每个 texel 写有限体积平衡（体积 `dx²·1 cm³`，厚度 1cm）：
//!
//! ```text
//! Σ_face K_f·(p_j - p_i) + c_art·(p_art - p_i) + c_ven·(p_ven - p_i) = 0
//! ```
//!
//! 解出：
//!
//! ```text
//! p_i = ( Σ_face K_f·p_j + c_art·p_art + c_ven·p_ven ) / ( Σ_face K_f + c_art + c_ven )
//! ```
//!
//! 这里 `c_art`/`c_ven` 是**耦合电导**而不是源项。设计文档 5.4 写的 `q_art[i]`
//! 是纯源项，纯源项在离散式里只进分子不进分母，量纲和稳定性都不对；改成
//! 电导形式后方程恒有界（解必落在 `[p_ven, p_art]` 之间），且物理意义更直白：
//! `c_art` 就是这块组织接到动脉端的粗细。
//!
//! # 面电导
//!
//! 两种组织交界（比如肌肉挨着骨）用**调和平均**，不用算术平均：
//!
//! ```text
//! K_f = 2·K_i·K_j / (K_i + K_j)
//! ```
//!
//! 调和平均保证"骨那侧 K→0 时通量也→0"，算术平均会让血从骨头里漏过去。
//! 这是串联电阻的正确串法。
//!
//! # 边界
//!
//! - 创口 texel：`p = 0`（狄利克雷）
//! - 动脉入口 texel：`p = MAP`（狄利克雷），M3 的动脉树会用它
//! - 场边界：零通量（没有邻居 = 没有面）

use crate::TissueField;
use crate::config::TissueConfig;

#[inline]
fn harmonic(a: f32, b: f32) -> f32 {
    let s = a + b;
    if s <= 0.0 { 0.0 } else { 2.0 * a * b / s }
}

/// 求解器的暂存区。反复复用，避免每 tick 分配。
pub struct PressureSolver {
    /// x 方向面电导，`fx[i]` 是 texel i 与 i+1 之间的面。
    fx: Vec<f32>,
    /// y 方向面电导，`fy[i]` 是 texel i 与 i+w 之间的面。
    fy: Vec<f32>,
    next: Vec<f32>,
    /// 上一次求解的迭代次数与最大逐点变化（收敛性的粗略指标）。
    pub iters: u32,
    pub last_delta: f32,
}

impl PressureSolver {
    pub fn new(n: usize) -> Self {
        Self {
            fx: vec![0.0; n],
            fy: vec![0.0; n],
            next: vec![0.0; n],
            iters: 0,
            last_delta: 0.0,
        }
    }

    /// 重算面电导。电导只在 `update_conductance` 之后变化，所以每个组织 tick 一次。
    fn prepare(&mut self, f: &TissueField) {
        let w = f.w as usize;
        let h = f.h as usize;
        for y in 0..h {
            for x in 0..w {
                let i = y * w + x;
                self.fx[i] = if x + 1 < w {
                    harmonic(f.conductance[i], f.conductance[i + 1])
                } else {
                    0.0
                };
                self.fy[i] = if y + 1 < h {
                    harmonic(f.conductance[i], f.conductance[i + w])
                } else {
                    0.0
                };
            }
        }
    }

    /// 解一次压力场。`map` 是平均动脉压（mmHg），写进所有动脉入口。
    ///
    /// `iters` 是最大迭代次数。稳态运行时给 8（靠上一帧的解作初值），冷启动
    /// 或预热时给几千——**8 次从零开始是远远不够的**，见 [`crate::TissueSim::warmup`]。
    pub fn solve(&mut self, f: &mut TissueField, cfg: &TissueConfig, map: f32, iters: u32) {
        self.prepare(f);

        let w = f.w as usize;
        let h = f.h as usize;
        let n = w * h;
        let p_ven = cfg.p_venous;

        let mut delta = 0.0f32;
        for it in 0..iters {
            for y in 0..h {
                for x in 0..w {
                    let i = y * w + x;
                    if f.is_open_wound(i) {
                        self.next[i] = 0.0;
                        continue;
                    }
                    if f.inlet[i] {
                        self.next[i] = map;
                        continue;
                    }
                    let ca = f.c_art[i];
                    let cv = f.c_ven[i];
                    let mut sum = ca * map + cv * p_ven;
                    let mut den = ca + cv;

                    if x + 1 < w {
                        let k = self.fx[i];
                        sum += k * f.pressure[i + 1];
                        den += k;
                    }
                    if x > 0 {
                        let k = self.fx[i - 1];
                        sum += k * f.pressure[i - 1];
                        den += k;
                    }
                    if y + 1 < h {
                        let k = self.fy[i];
                        sum += k * f.pressure[i + w];
                        den += k;
                    }
                    if y > 0 {
                        let k = self.fy[i - w];
                        sum += k * f.pressure[i - w];
                        den += k;
                    }

                    self.next[i] = if den > 0.0 { sum / den } else { f.pressure[i] };
                }
            }

            delta = 0.0;
            for i in 0..n {
                let d = (self.next[i] - f.pressure[i]).abs();
                if d > delta {
                    delta = d;
                }
            }
            std::mem::swap(&mut f.pressure, &mut self.next);
            self.iters = it + 1;
            if delta < 1e-5 {
                break;
            }
        }
        self.last_delta = delta;
    }
}

/// 创口总出血量（mL/s）。
///
/// **这是整套系统的灵魂。** 不是 `常数 × 伤口大小`，而是把创口每个 texel 当成
/// 一个通向大气的零压汇，算它的净流入：
///
/// ```text
/// Q = Σ_{创口 texel i} [ c_art_i·(MAP - 0) + c_ven_i·(p_ven - 0)
///                      + Σ_{相邻组织 j} K_face(i,j)·(p_j - 0) ]
/// ```
///
/// 两项的物理含义不同：
///
/// - `c_art·MAP`：**断端喷血**。创口 texel 的血管断端敞着，直接连到动脉。
///   这一项由 `wound_vessel_boost` 放大，代表"砍断的是血管不是毛细血管"。
/// - `Σ K_face·p_j`：**创面渗血**。周围组织的压力把血从断面挤出来，量小但持续。
///
/// 因为创口 texel 的 `p` 被钉死在 0，所以 `p_i` 不出现——**要用邻居的压**。
/// 用创口自己的压算出来永远是 0，这个坑踩过一次。
///
/// 于是自动获得：创口越大 → 越大；MAP 越高 → 越大；失血让 MAP 降 → 自动变小；
/// 按压创口（把 p 抬回组织压）→ 归零；砍在骨头上（k0 极小）→ 几乎不出血。
pub fn wound_flux(f: &TissueField, map: f32) -> f32 {
    let w = f.w as usize;
    let h = f.h as usize;
    let mut q = 0.0f32;
    for y in 0..h {
        for x in 0..w {
            let i = y * w + x;
            // 被压闭的创口不是零压汇，一分钱也不漏
            if !f.is_open_wound(i) {
                continue;
            }
            q += f.c_art[i] * map;
            let k = f.conductance[i];
            if x + 1 < w && !f.is_open_wound(i + 1) {
                q += harmonic(k, f.conductance[i + 1]) * f.pressure[i + 1];
            }
            if x > 0 && !f.is_open_wound(i - 1) {
                q += harmonic(k, f.conductance[i - 1]) * f.pressure[i - 1];
            }
            if y + 1 < h && !f.is_open_wound(i + w) {
                q += harmonic(k, f.conductance[i + w]) * f.pressure[i + w];
            }
            if y > 0 && !f.is_open_wound(i - w) {
                q += harmonic(k, f.conductance[i - w]) * f.pressure[i - w];
            }
        }
    }
    q
}

/// 动脉端总流入（mL/s）。稳态下应等于 `venous_return + wound_flux`。
///
/// 创口 texel 也算在内——它们的 `c_art` 被放大了，那部分血正是从上游动脉
/// 直接喷出去的量。
pub fn arterial_inflow(f: &TissueField, map: f32) -> f32 {
    let mut s = 0.0;
    for i in 0..f.len() {
        s += f.c_art[i] * (map - f.pressure[i]);
    }
    s
}

/// 静脉端总回流（mL/s）。只有真正穿过毛细血管床的血才回得来。
pub fn venous_return(f: &TissueField, p_ven: f32) -> f32 {
    let mut s = 0.0;
    for i in 0..f.len() {
        s += f.c_ven[i] * (f.pressure[i] - p_ven);
    }
    s
}

/// 第 3 步：由压力场导出灌注率（mL/(s·cm³)）。
///
/// ```text
/// perfusion_i = c_ven_i·(p_i - p_ven) / dx²
/// ```
///
/// **定义成静脉回流量而不是压力梯度**，这是踩过坑之后的改法。用梯度定义时，
/// 没有创口的组织压力场是均匀的 → 梯度为 0 → 灌注为 0 → 正常组织也会慢慢缺氧，
/// 显然是错的。静脉回流才是"真正穿过毛细血管床的血"，没有创口时它不为零，
/// 而创口把血短路掉时它会掉下来——两种情况都对。
pub fn derive_perfusion(f: &mut TissueField, cfg: &TissueConfig) {
    let inv_v = 1.0 / (f.texel_cm * f.texel_cm);
    for i in 0..f.len() {
        let p = f.c_ven[i] * (f.pressure[i] - cfg.p_venous) * inv_v;
        f.perfusion[i] = if p > 0.0 { p } else { 0.0 };
    }
}
