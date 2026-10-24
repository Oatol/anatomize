//! 组织场（tissue field）。
//!
//! 一具身体 = 一张 texel 标量场。血液不是血条，而是这张场上的一股达西流：
//! 动脉端给压、静脉端回血、创口是通向大气的零压边界。于是
//!
//! **出血速率 = 创口边界的达西通量**，它是解出来的，不是写死的常数。
//!
//! # 单位约定
//!
//! 生理量沿用临床习惯单位，几何量用厘米（和 `BodyPlan` 一致）。二维场取
//! 1cm 厚度，所以面积即体积、体积即容积：
//!
//! | 量 | 单位 | 说明 |
//! |---|---|---|
//! | `p` | mmHg | 组织内血液驱动压 |
//! | `dx` | cm | texel 边长 |
//! | `K` | mL/(s·mmHg) | 面电导（= 材料电导率，二维下 `A/L = dx/dx = 1`） |
//! | `Q` | mL/s | 流量 |
//! | `perfusion` | mL/(s·cm³) = 1/s | 单位体积灌注率 |
//!
//! 关键推导（这一步是整套系统的地基，改动前先看这里）：
//!
//! ```text
//! 达西通量    q = K·(Δp/dx)                  [mL/(s·cm²)]
//! 面流量      Q = q·dx = K·Δp                [mL/s]     ← A/L = dx/dx = 1
//! texel 灌注  = Σ_face K·|Δp| / (2·dx²)      [1/s]
//! ```
//!
//! 注意 `Q = K·p` 里的 `p` 是**创口相邻组织**的压，不是创口自身的压——创口
//! texel 被钉死在 0，用它的压算出来永远是 0。这个坑踩过一次。
//!
//! # 更新顺序
//!
//! 每个组织 tick（20Hz）严格按这个顺序走，顺序是硬约束：
//!
//! ```text
//! 1. apply_boundary      创口 p=0、动脉入口 p=MAP
//! 2. solve_pressure      Jacobi，五点格式
//! 3. derive_perfusion    J = K·|∇p|
//! 4. transport_o2        灌注带氧、组织耗氧
//! 5. thermal             传导 + 血流带热 + 代谢产热 + 环境散热
//! 6. accumulate_damage   缺氧 / 过冷 / 过热 → damage↑
//! 7. update_conductance  K = K0·(1-d)^n
//! 8. readout             聚合，写 L4
//! ```
//!
//! 第 7 步的结果在第 2 步（下一 tick）才生效——**故意留一个 tick 的延迟**，
//! 打断"损伤 ↔ 灌注"的循环依赖。这是显式耦合，不是 bug。
//!
//! # 一个已知的取舍
//!
//! 场挂在**身体局部坐标系**上，不随肢体旋转，碎片也不各带一张场。代价是飞出去
//! 的断肢不再有独立的灌注演化（它已经死了，无所谓）。见设计文档 5.6。

pub mod config;
pub mod damage;
pub mod field;
pub mod pressure;
pub mod raster;
pub mod transport;

pub use config::{ASSET_TISSUE_CONFIG, KindTable, TissueConfig};
pub use damage::time_to_hypoxia;
pub use field::TissueField;
pub use pressure::{PressureSolver, arterial_inflow, venous_return, wound_flux};
pub use raster::{Shape, apply_wound, apply_wound_path, rasterize, set_inlet};

/// 每个 texel 的组织类型。建体时烘焙一次，之后不变。
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
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

impl TissueKind {
    pub const ALL: [TissueKind; 7] = [
        TissueKind::Outside,
        TissueKind::Skin,
        TissueKind::Fat,
        TissueKind::Muscle,
        TissueKind::Bone,
        TissueKind::Organ,
        TissueKind::Air,
    ];

    #[inline]
    pub fn index(self) -> usize {
        self as usize
    }

    pub fn name(self) -> &'static str {
        match self {
            TissueKind::Outside => "outside",
            TissueKind::Skin => "skin",
            TissueKind::Fat => "fat",
            TissueKind::Muscle => "muscle",
            TissueKind::Bone => "bone",
            TissueKind::Organ => "organ",
            TissueKind::Air => "air",
        }
    }

    /// 是不是"有血管、会出血"的组织。
    #[inline]
    pub fn is_vascular(self) -> bool {
        matches!(
            self,
            TissueKind::Skin | TissueKind::Fat | TissueKind::Muscle | TissueKind::Organ
        )
    }
}

/// 一个组织 tick 的输出。全部是标量，直接喂给 L4 生理层。
#[derive(Debug, Clone, Copy, Default)]
pub struct TissueStep {
    /// 创口总出血（mL/s）。稳态下等于动脉流入减去静脉回流。
    pub wound_flux: f32,
    /// 组织平均压（mmHg）。
    pub mean_pressure: f32,
    /// 组织平均灌注（1/s）。
    pub mean_perfusion: f32,
    /// 组织平均氧分压（mmHg）。
    pub mean_o2: f32,
    /// 核心温度（°C，离皮肤 >2cm 的区域）。
    pub core_temp: f32,
    /// 组织平均损伤（0..1）。
    pub mean_damage: f32,
    /// 动脉端总流入（mL/s）。
    pub arterial_inflow: f32,
}

/// 组织场 + 求解器 + 步进逻辑的封装。
pub struct TissueSim {
    pub field: TissueField,
    pub cfg: TissueConfig,
    solver: PressureSolver,
    thermal_scratch: Vec<f32>,
    pub step: TissueStep,
}

impl TissueSim {
    pub fn new(field: TissueField, cfg: TissueConfig) -> Self {
        let n = field.len();
        let mut sim = Self {
            field,
            cfg,
            solver: PressureSolver::new(n),
            thermal_scratch: vec![0.0; n],
            step: TissueStep::default(),
        };
        sim.field.update_conductance(&sim.cfg);
        sim
    }

    /// 从形状列表直接建体。
    pub fn from_shapes(shapes: &[Shape], cfg: TissueConfig) -> Self {
        let f = rasterize(shapes, &cfg, 1.0);
        Self::new(f, cfg)
    }

    /// 跑一个组织 tick。`map` 是当前平均动脉压（mmHg），`dt` 是秒。
    pub fn step(&mut self, map: f32, dt: f32) {
        let cfg = self.cfg.clone();

        // 1. 边界（创口/入口由求解器内联处理）
        // 2. 压力
        self.solver
            .solve(&mut self.field, &cfg, map, cfg.jacobi_iters);
        // 3. 灌注
        pressure::derive_perfusion(&mut self.field, &cfg);
        // 4. 氧
        transport::transport_o2(&mut self.field, &cfg, dt);
        // 5. 热
        transport::thermal(&mut self.field, &cfg, dt, &mut self.thermal_scratch);
        // 6. 损伤
        damage::accumulate_damage(&mut self.field, &cfg, dt);
        // 7. 电导（下一 tick 生效）
        self.field.update_conductance(&cfg);

        // 8. 读出
        self.refresh_readout(map);
    }

    /// 建体后预热：把压力场解到收敛。
    ///
    /// **必须有这一步。** 稳态运行给 8 次 Jacobi 是够的，因为初值是上一帧的解；
    /// 但从 `p = 0` 冷启动时 8 次只够把边界信息传进 8 个 texel，算出来的组织压
    /// 严重偏低，第一秒的灌注/出血全是假的。
    ///
    /// 返回最后一次的最大逐点变化，用于判断有没有真的收敛。
    pub fn warmup(&mut self, map: f32) -> f32 {
        let cfg = self.cfg.clone();
        // 先重算电导：开完创口之后创口的断端放大、静脉侧归零都要在这里生效，
        // 否则解出来的还是"没开刀"的压力场。
        self.field.update_conductance(&cfg);
        self.solver.solve(&mut self.field, &cfg, map, 4000);
        pressure::derive_perfusion(&mut self.field, &cfg);
        self.refresh_readout(map);
        self.solver.last_delta
    }

    /// 只解压力，不做生理演化。测试和"改了 MAP 想立刻看通量"时用。
    pub fn settle_pressure(&mut self, map: f32, rounds: u32) {
        let cfg = self.cfg.clone();
        let iters = cfg.jacobi_iters;
        self.field.update_conductance(&cfg);
        for _ in 0..rounds {
            self.solver.solve(&mut self.field, &cfg, map, iters);
        }
        pressure::derive_perfusion(&mut self.field, &cfg);
        self.refresh_readout(map);
    }

    fn refresh_readout(&mut self, map: f32) {
        self.step = TissueStep {
            wound_flux: wound_flux(&self.field, map),
            mean_pressure: self.field.mean(&self.field.pressure),
            mean_perfusion: self.field.mean(&self.field.perfusion),
            mean_o2: self.field.mean(&self.field.o2),
            core_temp: self.field.core_mean(&self.field.temp, 2.0),
            mean_damage: self.field.mean(&self.field.damage),
            arterial_inflow: arterial_inflow(&self.field, map),
        };
    }

    pub fn wound_flux(&self, map: f32) -> f32 {
        wound_flux(&self.field, map)
    }

    pub fn solver_delta(&self) -> f32 {
        self.solver.last_delta
    }
}
