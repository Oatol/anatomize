//! 组织场。
//!
//! **状态：M2 实现。** 这里先把数据结构定下来，求解器（压力 / 灌注 / 氧 / 热 / 损伤）
//! 在 M2 补上。定结构的目的是让上层现在就能按正确的形状思考，而不是等 M2 再返工。
//!
//! 设计要点见 `设计文档-v0.2.md` 第 5 节：
//! - 场挂在**身体局部坐标系**上，不随肢体旋转
//! - 创口 = 狄利克雷边界 `p = 0`
//! - 出血速率 = 创口边界的达西通量（涌现，不是常数）

/// 每个 texel 的组织类型。建体时烘焙一次，之后不变。
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(u8)]
pub enum TissueKind {
    Outside = 0,
    Skin = 1,
    Fat = 2,
    Muscle = 3,
    Bone = 4,
    Organ = 5,
    Air = 6,
}

/// 逐 texel 的组织场。SoA 布局：每个 pass 只扫一两个通道，缓存局部性好。
#[derive(Debug, Clone)]
pub struct TissueField {
    /// texel 边长（米）。
    pub texel: f32,
    pub w: u32,
    pub h: u32,

    // 静态层
    pub kind: Vec<TissueKind>,
    pub k0: Vec<f32>,

    // 动态层
    pub pressure: Vec<f32>,
    pub conductance: Vec<f32>,
    pub perfusion: Vec<f32>,
    pub o2: Vec<f32>,
    pub temp: Vec<f32>,
    pub damage: Vec<f32>,
    pub pooled: Vec<f32>,

    /// 创口标志位：`p` 强制为 0。
    pub wound: Vec<bool>,
}

impl TissueField {
    pub fn new(w: u32, h: u32, texel: f32) -> Self {
        let n = (w * h) as usize;
        Self {
            texel,
            w,
            h,
            kind: vec![TissueKind::Outside; n],
            k0: vec![0.0; n],
            pressure: vec![0.0; n],
            conductance: vec![0.0; n],
            perfusion: vec![0.0; n],
            o2: vec![0.0; n],
            temp: vec![37.0; n],
            damage: vec![0.0; n],
            pooled: vec![0.0; n],
            wound: vec![false; n],
        }
    }

    #[inline]
    pub fn idx(&self, x: u32, y: u32) -> usize {
        (y * self.w + x) as usize
    }

    pub fn len(&self) -> usize {
        (self.w * self.h) as usize
    }

    pub fn is_empty(&self) -> bool {
        self.len() == 0
    }
}
