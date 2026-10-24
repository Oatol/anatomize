//! 生理参数。全部外置为 RON。
//!
//! 标定基准（静息、仰卧、室温 22°C、血容量 5000 mL）：
//!
//! | 量 | 目标 | 由谁决定 |
//! |---|---|---|
//! | MAP | 93 mmHg | `svr_base` = 18.2，`co` = 5.0 |
//! | CO | 5.0 L/min | `pms_base` = 8、`cvp` = 2、`rvr_base` = 1.2 |
//! | HR | 72 bpm | `hr_base`，`tone = tone_base` 时增益为 0 |
//! | SV | 69.4 mL | 导出量 `co·1000/hr`，不独立配置 |
//! | SaO2 | 0.97 | Hill(n=2.7, p50=26.6) 在 PaO2=95 处的值 |
//! | DO2 | ~980 mL/min | `co·1.34·Hb·10·SaO2` |
//!
//! **注意 `svr_base` 与 `rvr_base` 不是自由参数。** 它们由"静息 CO 必须是 5 L/min、
//! MAP 必须是 93"这两个约束反解出来的，改一个必须重算另一个，否则一具健康的人
//! 会一开始就高血压或者低血压。`tests::resting_state_is_nominal` 守着这条。

use serde::Deserialize;

pub const ASSET_PHYSIO_CONFIG: &str = include_str!("../../../assets/config/physio.ron");

/// 循环、呼吸、神经、代谢的全部参数。
#[derive(Debug, Clone, Copy, Deserialize)]
#[serde(default)]
pub struct PhysioConfig {
    // --- 容量 ---
    /// 正常血容量（mL）。
    pub blood_volume_ml: f32,
    /// 血红蛋白（g/dL）。
    pub hemoglobin: f32,
    /// 不显性失水（mL/s）：呼吸 + 皮肤蒸发 + 尿。约 1 L/天。
    pub insensible_ml_s: f32,

    // --- 压力反射 ---
    /// 压力反射的设定点（mmHg）。
    pub map_setpoint: f32,
    /// 静息交感张力。
    pub tone_base: f32,
    /// 压力反射增益：MAP 偏离设定点 100% 时张力的变化量。
    pub baroreflex_gain: f32,
    /// 容量反射增益：血容量偏离 100% 时张力的变化量。
    ///
    /// 这条通道对应**心肺压力感受器**（心房、肺动脉的低压感受器）。它按容量
    /// 而不是按压力工作，所以失血早期 MAP 还稳在 93 的时候心率就已经上去了
    /// —— 这是失血性休克最重要的早期体征，只靠 MAP 那一路做不出来。
    pub baroreflex_vol_gain: f32,
    /// 压力反射时间常数（s）。交感神经的真实响应就是这个量级。
    pub baroreflex_tau: f32,
    pub tone_min: f32,
    pub tone_max: f32,

    // --- 效应器 ---
    /// 静息心率（bpm）。
    pub hr_base: f32,
    /// 心率对交感张力的增益（相对 `tone_base`）。
    pub hr_gain: f32,
    /// 心率对体温的增益：每偏离 1°C 心率变化的比例。
    pub hr_temp_gain: f32,
    /// 体循环阻力基准（mmHg·min/L）。
    pub svr_base: f32,
    /// 体循环阻力对交感张力的增益。
    pub svr_gain: f32,
    /// 静脉回流阻力基准（mmHg·min/L）。
    pub rvr_base: f32,
    /// 静脉回流阻力对交感张力的增益。
    ///
    /// 这个值必须**远小于** `svr_gain`。静脉收缩会提高充盈压（好事），但同时
    /// 提高回流阻力（坏事）；如果两者等量，交感兴奋就变成"越代偿越没血回来"。
    pub rvr_gain: f32,
    /// 平均体循环充盈压（mmHg）。正常约 8，直接正比于血容量。
    pub pms_base: f32,
    /// 中心静脉压（mmHg）。
    pub cvp: f32,
    /// 心肌收缩力对 MAP 的依赖下限/上限（mmHg）。
    ///
    /// 冠脉灌注压就是 MAP 减去左室压，MAP 掉到 60 以下冠脉开始缺血，收缩力下降，
    /// CO 再降，MAP 再降 —— 这就是"失代偿"的正反馈。两个数定义它的斜坡。
    pub contract_flat: f32,
    pub contract_full: f32,
    /// 收缩力地板。0 会让循环在某个点上直接跳变到死，留一点余量更平滑。
    pub contract_floor: f32,

    // --- 呼吸 ---
    /// 室内空气下的动脉氧分压（mmHg）。
    pub pao2_room: f32,
    /// Hill 曲线指数。
    pub hill_n: f32,
    /// Hill 曲线半饱和分压（mmHg）。
    pub hill_p50: f32,
    /// 静息耗氧（mL/min）。
    pub vo2_base: f32,
    /// 无氧代谢阈值：氧摄取率超过它就开始产生氧债。
    pub ero2_anaerobic: f32,

    // --- 神经 ---
    /// 意识的一阶滞后时间常数（s）。
    pub consciousness_tau: f32,
    /// 组织氧：低于 `flat` 完全无意识，高于 `wake` 完全清醒（mmHg）。
    pub pto2_flat: f32,
    pub pto2_wake: f32,
    /// MAP：同上（mmHg）。
    pub map_flat: f32,
    pub map_wake: f32,
    /// 血糖：同上（mmol/L）。
    pub glucose_flat: f32,
    pub glucose_wake: f32,
    /// 核心温度：同上（°C）。
    pub temp_flat: f32,
    pub temp_wake: f32,

    // --- 代谢 ---
    /// 静息血糖（mmol/L）。
    pub glucose_base: f32,
    /// 基础血糖消耗（mmol/(L·s)）。5 mmol/L 的 5L 循环池，约 2 小时用完。
    pub glucose_use: f32,
    /// 血糖分布容积（L）。葡萄糖溶在全身细胞外液里，不是只溶在血浆里。
    pub glucose_volume_l: f32,
    /// 体温设定点（°C）。
    pub temp_setpoint: f32,
    /// 核心温度跟随组织场的时间常数（s）。
    pub temp_tau: f32,

    // --- 体温调节 ---
    /// 基础代谢产热（W）。70kg 成人静息约 85~100 W。
    pub bmr_watt: f32,
    /// 整体散热系数（W/K）。`Q_loss = k·(T_skin − T_amb)`。
    ///
    /// 22°C 室温下皮肤约 32°C、散热约 100 W，所以 k ≈ 10。
    /// 这个数同时决定了"多冷才算冷"：k 越大，同样的环境温度掉得越快。
    pub heat_loss_w_per_k: f32,
    /// 全身热容（kJ/K）。70kg × 3.5 kJ/(kg·K) = 245。
    pub body_heat_capacity_kj_per_k: f32,
    /// 开始寒战的深部温度（°C）。
    pub shiver_onset: f32,
    /// 每低 1°C 增加多少寒战强度。
    pub shiver_gain: f32,
    /// 寒战打满时代谢率的相对增幅。真实值可达 4~5 倍，这里取小值：
    /// 大数值会让"冷"这个场景在几十秒内自愈，看不出失温。
    pub shiver_boost: f32,
    /// 开始出汗的深部温度（°C）。
    pub sweat_onset: f32,
    /// 每高 1°C 增加多少出汗强度。
    pub sweat_gain: f32,
    /// 出汗打满时代谢散热相对基准的增幅。
    pub sweat_boost: f32,

    // --- 消化 ---
    /// 1 kcal 折算成多少 mmol 葡萄糖当量。
    ///
    /// 真实混合膳食约 60% 热量来自碳水，1 mmol 葡萄糖 = 0.686 kcal
    /// → `0.6 / 0.686 ≈ 0.875`。脂肪和蛋白也会通过糖异生变成糖，所以不按纯碳水算。
    pub kcal_to_mmol: f32,
    /// 胃排空时间常数（s）。
    pub gastric_tau: f32,
    /// 小肠吸收时间常数（s）。两个腔室串联给出 15~20 分钟的滞后相。
    pub intestine_tau: f32,
    /// 胰岛素对血糖偏差的增益（1/(mmol/L)）。
    pub insulin_gain: f32,
    /// 胰岛素时间常数（s）。
    pub insulin_tau: f32,
    /// 胰岛素介导的葡萄糖摄取上限（mmol/s）。
    pub insulin_uptake: f32,
    /// 肝糖原输出增益（1/s）。
    pub hepatic_gain: f32,

    // --- 死亡 ---
    /// 心输出量归零持续多久判定死亡（s）。
    pub arrest_death_s: f32,
}

impl Default for PhysioConfig {
    fn default() -> Self {
        Self {
            blood_volume_ml: 5000.0,
            hemoglobin: 15.0,
            insensible_ml_s: 0.012,

            map_setpoint: 93.0,
            tone_base: 0.30,
            baroreflex_gain: 1.2,
            baroreflex_vol_gain: 4.0,
            baroreflex_tau: 3.0,
            tone_min: 0.0,
            tone_max: 1.0,

            hr_base: 72.0,
            hr_gain: 1.20,
            hr_temp_gain: 0.35,
            svr_base: 18.2,
            svr_gain: 0.857,
            rvr_base: 1.2,
            rvr_gain: 0.15,
            pms_base: 8.0,
            cvp: 2.0,
            contract_flat: 20.0,
            contract_full: 55.0,
            contract_floor: 0.5,

            pao2_room: 95.0,
            hill_n: 2.7,
            hill_p50: 26.6,
            vo2_base: 250.0,
            ero2_anaerobic: 0.60,

            consciousness_tau: 6.0,
            pto2_flat: 8.0,
            pto2_wake: 25.0,
            map_flat: 40.0,
            map_wake: 65.0,
            glucose_flat: 1.5,
            glucose_wake: 3.0,
            temp_flat: 30.0,
            temp_wake: 34.0,

            glucose_base: 5.0,
            glucose_use: 0.004,
            glucose_volume_l: 15.0,
            temp_setpoint: 37.0,
            temp_tau: 5.0,

            bmr_watt: 100.0,
            heat_loss_w_per_k: 10.0,
            body_heat_capacity_kj_per_k: 245.0,
            shiver_onset: 36.5,
            shiver_gain: 3.0,
            shiver_boost: 0.35,
            sweat_onset: 37.2,
            sweat_gain: 3.0,
            sweat_boost: 0.6,

            kcal_to_mmol: 0.875,
            gastric_tau: 1500.0,
            intestine_tau: 1200.0,
            insulin_gain: 0.6,
            insulin_tau: 600.0,
            insulin_uptake: 0.075,
            hepatic_gain: 0.02,

            arrest_death_s: 60.0,
        }
    }
}

impl PhysioConfig {
    pub fn from_ron(src: &str) -> Result<Self, ron::error::SpannedError> {
        ron::from_str(src)
    }

    /// 内置默认配置（`assets/config/physio.ron`）。
    pub fn asset() -> Self {
        Self::from_ron(ASSET_PHYSIO_CONFIG).expect("内置 physio.ron 必须能解析")
    }
}
