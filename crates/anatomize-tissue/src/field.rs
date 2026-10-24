//! 逐 texel 的组织场。
//!
//! SoA 布局：每个 pass 只扫一两个通道，缓存局部性好一个数量级，也方便以后
//! 每通道一个 storage buffer 搬上 GPU。
//!
//! 坐标系：**身体局部坐标系（cm）**，不随肢体旋转。`origin` 是场左下角。
//! 场不跟着碎片走——碎片飞出去后，场里对应区域变成 `Outside`（组织已死）。
//! 这条取舍见设计文档 5.6 与 ADR。

use crate::TissueKind;
use crate::config::TissueConfig;
use anatomize_core::Vec2;

#[derive(Debug, Clone)]
pub struct TissueField {
    /// texel 边长（cm）。
    pub texel_cm: f32,
    pub w: u32,
    pub h: u32,
    /// 场左下角在身体局部坐标里的位置（cm）。
    pub origin: Vec2,

    // --- 静态层（建体时烘焙一次） ---
    pub kind: Vec<TissueKind>,
    /// 基础血管床电导（不含损伤衰减）。决定灌注与出血。
    pub k0: Vec<f32>,

    // --- 边界 ---
    /// 创口 texel：压力钉死在 0（通向大气）。
    pub wound: Vec<bool>,
    /// 动脉入口 texel：压力钉死在 MAP。M3 的动脉树会用它。
    pub inlet: Vec<bool>,

    // --- 动态层 ---
    /// 组织内血液驱动压（mmHg）。
    pub pressure: Vec<f32>,
    /// 血管床电导，`k_bed = k0·(1-damage)^n`。决定灌注与出血。
    pub bed: Vec<f32>,
    /// 组织间连通电导，`K = k_bed·k_inter_ratio`。决定压力的空间分布。
    pub conductance: Vec<f32>,
    /// 与动脉端的耦合，`c_art = k_bed·arterial_share`。
    pub c_art: Vec<f32>,
    /// 与静脉端的耦合。创口处为 0（静脉断端也敞着，不回血）。
    pub c_ven: Vec<f32>,
    /// 单位体积灌注率（mL/(s·cm³)）。
    pub perfusion: Vec<f32>,
    /// 组织氧分压（mmHg）。
    pub o2: Vec<f32>,
    /// 温度（°C）。
    pub temp: Vec<f32>,
    /// 损伤 0..1。
    pub damage: Vec<f32>,
    /// 积血量（mL），皮下 / 体腔。
    pub pooled: Vec<f32>,
}

impl TissueField {
    pub fn new(w: u32, h: u32, texel_cm: f32, origin: Vec2) -> Self {
        let n = (w * h) as usize;
        Self {
            texel_cm,
            w,
            h,
            origin,
            kind: vec![TissueKind::Outside; n],
            k0: vec![0.0; n],
            wound: vec![false; n],
            inlet: vec![false; n],
            pressure: vec![0.0; n],
            bed: vec![0.0; n],
            conductance: vec![0.0; n],
            c_art: vec![0.0; n],
            c_ven: vec![0.0; n],
            perfusion: vec![0.0; n],
            o2: vec![0.0; n],
            temp: vec![37.0; n],
            damage: vec![0.0; n],
            pooled: vec![0.0; n],
        }
    }

    #[inline]
    pub fn idx(&self, x: u32, y: u32) -> usize {
        (y * self.w + x) as usize
    }

    #[inline]
    pub fn xy(&self, i: usize) -> (u32, u32) {
        ((i as u32) % self.w, (i as u32) / self.w)
    }

    pub fn len(&self) -> usize {
        (self.w * self.h) as usize
    }

    pub fn is_empty(&self) -> bool {
        self.len() == 0
    }

    /// texel 中心的身体局部坐标（cm）。
    pub fn center_of(&self, i: usize) -> Vec2 {
        let (x, y) = self.xy(i);
        self.origin
            + Vec2::new(
                (x as f32 + 0.5) * self.texel_cm,
                (y as f32 + 0.5) * self.texel_cm,
            )
    }

    /// 世界坐标（身体局部 cm）→ texel 索引，越界返回 None。
    pub fn texel_at(&self, p: Vec2) -> Option<usize> {
        let lx = (p.x - self.origin.x) / self.texel_cm;
        let ly = (p.y - self.origin.y) / self.texel_cm;
        if lx < 0.0 || ly < 0.0 || lx >= self.w as f32 || ly >= self.h as f32 {
            return None;
        }
        Some(self.idx(lx as u32, ly as u32))
    }

    /// 右/上/左/下的邻居索引，越界或越出场边界返回 None。
    #[inline]
    pub fn neighbor(&self, i: usize, dir: usize) -> Option<usize> {
        let (x, y) = self.xy(i);
        match dir {
            0 => (x + 1 < self.w).then(|| self.idx(x + 1, y)),
            1 => (y + 1 < self.h).then(|| self.idx(x, y + 1)),
            2 => (x > 0).then(|| self.idx(x - 1, y)),
            _ => (y > 0).then(|| self.idx(x, y - 1)),
        }
    }

    /// 组织 texel 数（不含 Outside / Air）。
    pub fn tissue_texels(&self) -> usize {
        self.kind
            .iter()
            .filter(|k| !matches!(k, TissueKind::Outside | TissueKind::Air))
            .count()
    }

    /// 各组织类型的 texel 计数，按 [`TissueKind::ALL`] 顺序。
    pub fn histogram(&self) -> [usize; 7] {
        let mut out = [0usize; 7];
        for k in &self.kind {
            out[k.index()] += 1;
        }
        out
    }

    /// 某个通道在组织 texel 上的均值。
    pub fn mean(&self, ch: &[f32]) -> f32 {
        let mut sum = 0.0;
        let mut n = 0usize;
        for i in 0..self.len() {
            if self.kind[i] != TissueKind::Outside && self.kind[i] != TissueKind::Air {
                sum += ch[i];
                n += 1;
            }
        }
        if n == 0 { 0.0 } else { sum / n as f32 }
    }

    /// 某个通道在**核心区**（离皮肤超过 `depth_cm`）的均值，用来当 `t_core`。
    pub fn core_mean(&self, ch: &[f32], depth_cm: f32) -> f32 {
        let r = (depth_cm / self.texel_cm).round() as i32;
        let mut sum = 0.0;
        let mut n = 0usize;
        for i in 0..self.len() {
            if !self.is_core(i, r) {
                continue;
            }
            sum += ch[i];
            n += 1;
        }
        if n == 0 { 0.0 } else { sum / n as f32 }
    }

    fn is_core(&self, i: usize, r: i32) -> bool {
        if matches!(self.kind[i], TissueKind::Outside | TissueKind::Air) {
            return false;
        }
        // 半径 r 内出现 Outside 就不算核心
        let (x, y) = self.xy(i);
        for dy in -r..=r {
            for dx in -r..=r {
                let nx = x as i32 + dx;
                let ny = y as i32 + dy;
                if nx < 0 || ny < 0 || nx >= self.w as i32 || ny >= self.h as i32 {
                    return false;
                }
                if self.kind[self.idx(nx as u32, ny as u32)] == TissueKind::Outside {
                    return false;
                }
            }
        }
        true
    }

    /// 用配置重算 `k0`（组织类型已定好时调用一次）。
    pub fn bake_k0(&mut self, cfg: &TissueConfig) {
        for i in 0..self.len() {
            self.k0[i] = cfg.k0.get(self.kind[i]);
        }
        self.update_conductance(cfg);
    }

    /// 第 7 步：`k_bed = K0·(1-d)^n`，同时刷新组织间连通、动脉/静脉耦合。
    ///
    /// 结果在**下一 tick 的** `solve_pressure` 才生效——故意的，打断
    /// "损伤 ↔ 灌注"的循环依赖。
    ///
    /// 创口 texel 特殊处理：血管断端敞在大气里，它的**动脉侧电导被放大**
    /// （`wound_vessel_boost`，代表"这一刀砍断的是一根大血管，不是一片毛细血管"），
    /// **静脉侧归零**（断端不回血）。这样"动脉流入 = 静脉回流 + 出血"这条
    /// 守恒式才能成立——放大的那部分血来自上游动脉，不是凭空出现的。
    pub fn update_conductance(&mut self, cfg: &TissueConfig) {
        let n = cfg.conductance_falloff;
        let share = cfg.arterial_share;
        let boost = cfg.wound_vessel_boost;
        for i in 0..self.len() {
            let k = self.k0[i] * (1.0 - self.damage[i].clamp(0.0, 1.0)).powf(n);
            self.bed[i] = k;
            self.conductance[i] = k * cfg.k_inter_ratio;
            if self.wound[i] {
                self.c_art[i] = k * share * boost;
                self.c_ven[i] = 0.0;
            } else {
                self.c_art[i] = k * share;
                self.c_ven[i] = k * (1.0 - share);
            }
        }
    }

    /// 把初始温度铺成体温（建体时调用）。
    pub fn fill_temp(&mut self, t: f32) {
        self.temp.fill(t);
    }

    /// 把初始氧分压铺成组织正常值（建体时调用）。
    pub fn fill_o2(&mut self, o2: f32) {
        for i in 0..self.len() {
            self.o2[i] = if self.kind[i] == TissueKind::Outside {
                0.0
            } else {
                o2
            };
        }
    }
}
