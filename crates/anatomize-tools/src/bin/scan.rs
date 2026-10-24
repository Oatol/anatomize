//! 批量实验：扫参数、跑场景、出 CSV。
//!
//! 这是设计文档 12.2 里"批量实验 CLI"那一条。它存在的理由很具体：
//!
//! **这个项目里几乎每个数字都是标定出来的，不是推导出来的。** 压力反射增益、
//! 失代偿斜率、寒战阈值、胰岛素摄取上限——每一个都是"调到看起来对"。
//! 调参时最怕的是"改了这个，那个坏了"，而单次跑一个 demo 看不出来。
//!
//! 所以这里把"跑一个场景"抽成纯函数，外面套一层参数笛卡尔积。
//!
//! ```text
//! anatomize-scan --scenario bleed-aorta --param baroreflex_gain=0.6:2.0:0.2
//!
//! gain  map_min  hr_max  t_map45  t_coma  bleed0
//! 0.6    38.2     118    71.5     78.3    63.9
//! 0.8    35.1     126    62.0     69.4    63.9
//! ...
//! ```
//!
//! # 为什么不开窗口
//!
//! 核心 crate 不依赖 Bevy，所以这个 CLI 能在没有 GPU 的机器上跑满 CPU。
//! 一次 5×6 的二维扫描大约 30 组，每组 2 分钟生理时间——单核几十秒。

use anatomize_body::{ASSET_HUMAN_01, BodyPlan, DamageConfig, JointParams};
use anatomize_core::Vec2;
use anatomize_cut::CutSegment;
use anatomize_physio::PhysioConfig;
use anatomize_sim::Sim;
use anatomize_tissue::TissueConfig;

const GROUND: f32 = -80.0;

fn main() {
    let args: Vec<String> = std::env::args().skip(1).collect();
    if args.iter().any(|a| a == "--help" || a == "-h") {
        usage();
        return;
    }

    let mut scenario = "bleed-aorta".to_string();
    let mut params: Vec<Param> = Vec::new();
    let mut out: Option<String> = None;
    let mut fast = false;

    let mut i = 0;
    while i < args.len() {
        match args[i].as_str() {
            "--scenario" => {
                i += 1;
                scenario = args.get(i).cloned().unwrap_or_else(|| {
                    eprintln!("--scenario 后面要跟名字");
                    std::process::exit(2);
                });
            }
            "--param" => {
                i += 1;
                let Some(spec) = args.get(i) else {
                    eprintln!("--param 后面要跟 name=start:end:step");
                    std::process::exit(2);
                };
                match Param::parse(spec) {
                    Ok(p) => params.push(p),
                    Err(e) => {
                        eprintln!("参数解析失败：{e}");
                        std::process::exit(2);
                    }
                }
            }
            "--out" => {
                i += 1;
                out = args.get(i).cloned();
            }
            "--fast" => fast = true,
            other => {
                eprintln!("不认识的参数 {other}");
                usage();
                std::process::exit(2);
            }
        }
        i += 1;
    }

    let Some(kind) = Scenario::parse(&scenario) else {
        eprintln!("未知场景 {scenario}");
        usage();
        std::process::exit(2);
    };

    // 笛卡尔积
    let mut combos: Vec<Vec<f32>> = vec![Vec::new()];
    for p in &params {
        let mut next = Vec::with_capacity(combos.len() * p.values.len());
        for c in &combos {
            for v in &p.values {
                let mut c2 = c.clone();
                c2.push(*v);
                next.push(c2);
            }
        }
        combos = next;
    }

    println!(
        "场景 {} · {} 组参数 · 每组 {} 秒生理时间{}",
        kind.name(),
        combos.len(),
        kind.duration_s(),
        if fast {
            "（快速模式：组织场冻结）"
        } else {
            ""
        }
    );

    // 表头：参数列 + 指标列
    let metric_names = kind.metric_names();
    let mut header: Vec<String> = params.iter().map(|p| p.name.clone()).collect();
    header.extend(metric_names.iter().map(|s| s.to_string()));
    let mut lines = vec![header.join(",")];

    let t0 = std::time::Instant::now();
    for (n, combo) in combos.iter().enumerate() {
        let metrics = kind.run(&params, combo, fast);
        let mut row: Vec<String> = combo.iter().map(|v| format!("{v:.4}")).collect();
        row.extend(metrics.iter().map(|v| {
            if v.is_finite() {
                format!("{v:.4}")
            } else {
                "nan".into()
            }
        }));
        lines.push(row.join(","));
        eprint!("\r  {}/{}", n + 1, combos.len());
    }
    eprintln!("  用时 {:.1}s", t0.elapsed().as_secs_f64());

    let csv = lines.join("\n") + "\n";
    match out {
        Some(path) => {
            std::fs::write(&path, &csv).expect("写 CSV 失败");
            println!("已写出 {path}");
        }
        None => print!("{csv}"),
    }
}

fn usage() {
    println!(
        r#"anatomize-scan — 批量参数实验

用法：
  anatomize-scan [--scenario NAME] [--param NAME=START:END:STEP]... [--out FILE.csv]

场景：
  bleed-aorta     横断主动脉（躯干一刀，切到颈动脉 + 双肱动脉）
  bleed-femoral   横断股动脉（左大腿一刀）
  cold            5°C 裸露 30 分钟
  feed            喂 500 kcal，观察 2 小时
  hammer          锤左膝 5 次（过伸方向）

可扫参数（生理）：
  baroreflex_gain  baroreflex_vol_gain  baroreflex_tau  map_setpoint
  tone_base  tone_min  tone_max  blood_volume_ml  pms_base
  hr_base  hr_gain  svr_base  svr_gain  rvr_base  rvr_gain
  contract_flat  contract_floor
  heat_loss_w_per_k  shiver_gain  shiver_boost  insulin_uptake
  gastric_tau  glucose_use  temp_tau  consciousness_tau  insensible_ml_s

注意：不是所有参数都同样敏感。tone 一旦被 clamp 到 tone_max 就饱和，
所以 baroreflex_gain 在**重度失血**场景里几乎不起作用（它只决定多快饱和）。
真正改变失血结局的是 tone_max / svr_gain / rvr_gain / blood_volume_ml。
扫描的价值之一就是**发现哪个参数其实是死的**。

--fast：把组织场降到 1Hz（默认 20Hz）。扫描快 10 倍，代价是出血速率
每 50ms 更新一次，t_map45 之类的时刻会偏几秒。验验收标准时不要用它。

可扫参数（损伤）：
  impulse_threshold  sprain_at  sublux_at  dislocate_at  wear_rate

例子：
  anatomize-scan --scenario bleed-aorta --param baroreflex_gain=0.6:2.0:0.2
  anatomize-scan --scenario bleed-femoral \
      --param baroreflex_gain=0.8:1.6:0.4 --param baroreflex_vol_gain=0:6:3 \
      --out fem.csv
"#
    );
}

// ---------------------------------------------------------------------------
// 参数
// ---------------------------------------------------------------------------

struct Param {
    name: String,
    values: Vec<f32>,
}

impl Param {
    /// `name=start:end:step` 或 `name=value1,value2,...`
    fn parse(spec: &str) -> Result<Self, String> {
        let (name, rest) = spec
            .split_once('=')
            .ok_or_else(|| format!("{spec} 里没有 ="))?;
        let name = name.trim().to_string();
        if name.is_empty() {
            return Err("参数名为空".into());
        }

        let values: Vec<f32> = if rest.contains(',') {
            rest.split(',')
                .map(|s| s.trim().parse::<f32>())
                .collect::<Result<_, _>>()
                .map_err(|e| format!("{rest} 解析失败：{e}"))?
        } else if rest.contains(':') {
            let parts: Vec<f32> = rest
                .split(':')
                .map(|s| s.trim().parse::<f32>())
                .collect::<Result<_, _>>()
                .map_err(|e| format!("{rest} 解析失败：{e}"))?;
            if parts.len() != 3 {
                return Err(format!("{rest} 应该是 start:end:step"));
            }
            let (start, end, step) = (parts[0], parts[1], parts[2]);
            if step == 0.0 || (end - start) / step < 0.0 {
                return Err(format!("步长 {step} 走不到 {end}"));
            }
            let n = ((end - start) / step).round() as i32;
            (0..=n).map(|i| start + step * i as f32).collect()
        } else {
            vec![
                rest.trim()
                    .parse::<f32>()
                    .map_err(|e| format!("{rest} 解析失败：{e}"))?,
            ]
        };

        if values.is_empty() {
            return Err(format!("{name} 没有取值"));
        }
        Ok(Self { name, values })
    }
}

/// 生理参数表。
///
/// 手写而不是反射：Rust 没有反射，而且**能被扫的参数应该是刻意挑过的**——
/// 把所有 `pub` 字段都暴露出去只会让人扫一堆没有意义的组合。
fn set_physio(cfg: &mut PhysioConfig, name: &str, v: f32) -> bool {
    match name {
        "baroreflex_gain" => cfg.baroreflex_gain = v,
        "baroreflex_vol_gain" => cfg.baroreflex_vol_gain = v,
        "baroreflex_tau" => cfg.baroreflex_tau = v,
        "map_setpoint" => cfg.map_setpoint = v,
        "tone_base" => cfg.tone_base = v,
        "tone_min" => cfg.tone_min = v,
        "tone_max" => cfg.tone_max = v,
        "blood_volume_ml" => cfg.blood_volume_ml = v,
        "pms_base" => cfg.pms_base = v,
        "contract_floor" => cfg.contract_floor = v,
        "insensible_ml_s" => cfg.insensible_ml_s = v,
        "hr_base" => cfg.hr_base = v,
        "hr_gain" => cfg.hr_gain = v,
        "svr_base" => cfg.svr_base = v,
        "svr_gain" => cfg.svr_gain = v,
        "rvr_base" => cfg.rvr_base = v,
        "rvr_gain" => cfg.rvr_gain = v,
        "contract_flat" => cfg.contract_flat = v,
        "heat_loss_w_per_k" => cfg.heat_loss_w_per_k = v,
        "shiver_gain" => cfg.shiver_gain = v,
        "shiver_boost" => cfg.shiver_boost = v,
        "insulin_uptake" => cfg.insulin_uptake = v,
        "gastric_tau" => cfg.gastric_tau = v,
        "glucose_use" => cfg.glucose_use = v,
        "temp_tau" => cfg.temp_tau = v,
        "consciousness_tau" => cfg.consciousness_tau = v,
        _ => return false,
    }
    true
}

fn set_damage(p: &mut JointParams, name: &str, v: f32) -> bool {
    match name {
        "impulse_threshold" => p.impulse_threshold = v,
        "sprain_at" => p.sprain_at = v,
        "sublux_at" => p.sublux_at = v,
        "dislocate_at" => p.dislocate_at = v,
        "wear_rate" => p.wear_rate = v,
        "overrun_ratio" => p.overrun_ratio = v,
        _ => return false,
    }
    true
}

// ---------------------------------------------------------------------------
// 场景
// ---------------------------------------------------------------------------

#[derive(Clone, Copy)]
enum Scenario {
    BleedAorta,
    BleedFemoral,
    Cold,
    Feed,
    Hammer,
}

impl Scenario {
    fn parse(s: &str) -> Option<Self> {
        Some(match s {
            "bleed-aorta" => Scenario::BleedAorta,
            "bleed-femoral" => Scenario::BleedFemoral,
            "cold" => Scenario::Cold,
            "feed" => Scenario::Feed,
            "hammer" => Scenario::Hammer,
            _ => return None,
        })
    }

    fn name(self) -> &'static str {
        match self {
            Scenario::BleedAorta => "bleed-aorta",
            Scenario::BleedFemoral => "bleed-femoral",
            Scenario::Cold => "cold",
            Scenario::Feed => "feed",
            Scenario::Hammer => "hammer",
        }
    }

    fn duration_s(self) -> f32 {
        match self {
            Scenario::BleedAorta => 180.0,
            Scenario::BleedFemoral => 300.0,
            Scenario::Cold => 1800.0,
            Scenario::Feed => 7200.0,
            Scenario::Hammer => 20.0,
        }
    }

    fn metric_names(self) -> &'static [&'static str] {
        match self {
            Scenario::BleedAorta | Scenario::BleedFemoral => &[
                "bleed0",  // 初始出血 mL/s
                "map_min", // 全程最低 MAP
                "hr_max",  // 峰值心率
                "t_map45", // MAP 跌破 45 的时刻（s），没跌破为 -1
                "t_coma",  // 意识跌破 0.2 的时刻，没跌破为 -1
                "vol_end", // 末了血容量
            ],
            Scenario::Cold => &[
                "core_end",
                "core_min",
                "shiver_end",
                "metab_end",
                "heat_end", // 热平衡 W
                "skin_end",
            ],
            Scenario::Feed => &["glu_base", "glu_peak", "glu_t30", "glu_t120", "ins_peak"],
            Scenario::Hammer => &[
                "integrity",
                "pain",
                "state", // 0 Intact .. 4 Severed
                "tilt_deg",
                "knee_err",
            ],
        }
    }

    fn run(self, params: &[Param], combo: &[f32], fast: bool) -> Vec<f32> {
        // 先把参数套上去
        let mut physio = PhysioConfig::asset();
        let mut damage = DamageConfig::asset().joint;
        for (p, v) in params.iter().zip(combo) {
            let ok = set_physio(&mut physio, &p.name, *v) || set_damage(&mut damage, &p.name, *v);
            if !ok {
                eprintln!("\n未知参数 {}（会被忽略）", p.name);
            }
        }

        match self {
            Scenario::BleedAorta | Scenario::BleedFemoral => {
                self.bleed(physio, damage, matches!(self, Scenario::BleedAorta), fast)
            }
            Scenario::Cold => cold(physio, damage, fast),
            Scenario::Feed => feed(physio, damage, fast),
            Scenario::Hammer => hammer(physio, damage),
        }
    }

    fn bleed(self, physio: PhysioConfig, damage: JointParams, aorta: bool, fast: bool) -> Vec<f32> {
        let mut sim = world(physio, damage, fast);
        let cut = if aorta { aorta_cut() } else { femoral_cut() };
        sim.cut_body_local(&cut).expect("组织场");

        let bleed0 = sim.hemorrhage_ml_s();
        let mut map_min = f32::INFINITY;
        let mut hr_max = 0.0f32;
        let mut t_map45 = -1.0;
        let mut t_coma = -1.0;

        let total = (self.duration_s() * 60.0) as u32;
        for i in 0..total {
            sim.step();
            let b = sim.physio.bus;
            let t = i as f32 / 60.0;
            map_min = map_min.min(b.map);
            hr_max = hr_max.max(b.heart_rate);
            if t_map45 < 0.0 && b.map < 45.0 {
                t_map45 = t;
            }
            if t_coma < 0.0 && b.consciousness < 0.2 {
                t_coma = t;
            }
        }
        vec![
            bleed0,
            map_min,
            hr_max,
            t_map45,
            t_coma,
            sim.physio.bus.blood_volume,
        ]
    }
}

fn cold(physio: PhysioConfig, damage: JointParams, fast: bool) -> Vec<f32> {
    let mut sim = world(physio, damage, fast);
    sim.set_ambient(5.0);
    let mut core_min = f32::INFINITY;
    let total = (1800.0 * 60.0) as u32;
    for _ in 0..total {
        sim.step();
        core_min = core_min.min(sim.physio.bus.temp_core);
    }
    let b = sim.physio.bus;
    let skin = sim.tissue.as_ref().map_or(0.0, |t| t.step.skin_temp);
    vec![
        b.temp_core,
        core_min,
        b.shiver,
        b.metab_scale,
        b.heat_balance_w,
        skin,
    ]
}

fn feed(physio: PhysioConfig, damage: JointParams, fast: bool) -> Vec<f32> {
    let mut sim = world(physio, damage, fast);
    let base = sim.physio.bus.glucose;
    sim.feed(500.0);
    let mut peak = base;
    let mut ins_peak = 0.0f32;
    let (mut at30, mut at120) = (base, base);
    let total = (7200.0 * 60.0) as u32;
    for i in 0..total {
        sim.step();
        let b = sim.physio.bus;
        peak = peak.max(b.glucose);
        ins_peak = ins_peak.max(b.insulin);
        let s = i as f32 / 60.0;
        if s >= 1800.0 && at30 == base {
            at30 = b.glucose;
        }
        if s >= 7200.0 {
            at120 = b.glucose;
        }
    }
    vec![base, peak, at30, at120, ins_peak]
}

fn hammer(physio: PhysioConfig, damage: JointParams) -> Vec<f32> {
    let mut sim = world(physio, damage, true);
    let knee = sim.joint_index("knee_l").unwrap();
    sim.enable_posture();
    for _ in 0..240 {
        sim.step();
    }
    let targets = sim.posture.as_ref().unwrap().targets.clone();
    let knee_target = targets[knee];

    // 锤击时必须关掉姿态控制：带着主动力矩，关节过不了伸，也就打不伤
    sim.disable_posture();
    for _ in 0..5 {
        // 打小腿中段，方向朝过伸
        let (pos, _) = sim.piece_pose(
            sim.body.primary[sim
                .plan
                .parts
                .iter()
                .position(|p| p.name == "shin_l")
                .unwrap()],
        );
        let _ = pos;
        sim.strike_part("shin_l", Vec2::new(70.0, 0.0), Vec2::new(0.0, -20.0));
        for _ in 0..120 {
            sim.step();
        }
    }
    sim.enable_posture();
    sim.posture.as_mut().unwrap().targets = targets;
    for _ in 0..240 {
        sim.step();
    }

    let h = sim.body.joints[knee].health;
    let tilt = sim.part_angle("torso").unwrap_or(0.0).to_degrees();
    let err = (sim.joint_load(knee).angle - knee_target).abs();
    vec![h.integrity, h.pain, h.state as u8 as f32, tilt, err]
}

// ---------------------------------------------------------------------------
// 世界
// ---------------------------------------------------------------------------

fn world(physio: PhysioConfig, damage: JointParams, fast: bool) -> Sim {
    let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
    let mut sim = Sim::spawn_with(plan, Vec2::new(0.0, 40.0), GROUND, damage);
    sim.physio = anatomize_physio::Physio::new(physio);
    sim.attach_tissue(&TissueConfig::asset());
    sim.set_part_fixed("head", true);
    for _ in 0..180 {
        sim.step();
    }
    if fast {
        // 1Hz 解场：出血速率的变化是秒级的，20Hz 是浪费。
        // 不能完全冻结——那样"血压降 → 出血变慢"的负反馈会消失，
        // 扫描会得到一条线性下降的 MAP，和真实轨迹差 20 秒。
        if let Some(t) = sim.tissue.as_mut() {
            t.stride = 20;
        }
    }
    sim
}

/// 躯干一刀，同时切到颈动脉 + 双肱动脉。
fn aorta_cut() -> CutSegment {
    CutSegment {
        a: Vec2::new(-16.0, 22.0),
        b: Vec2::new(16.0, 22.0),
        width: 0.6,
        speed: 1.0,
    }
}

fn femoral_cut() -> CutSegment {
    CutSegment {
        a: Vec2::new(-15.0, -25.0),
        b: Vec2::new(-1.0, -25.0),
        width: 0.6,
        speed: 1.0,
    }
}
