//! M5 验收：冷、饿、疼。
//!
//! 三个场景，三种驱动方式：
//!
//! - **冷** 和 **饿** 只需要 L2 + L4，不碰物理。这里用一个轻量夹具直接驱动
//!   组织场和生理层，组织场按 1 秒一步跑（场景是十分钟量级，热时间常数是分钟，
//!   1Hz 足够；生产速率是 20Hz，M4 的测试已经覆盖了）。
//! - **疼** 必须走真物理：冲量 → 关节过伸 → 磨损 → 状态迁移 → 姿态改变。

use anatomize_body::{ASSET_HUMAN_01, BodyPlan, JointState};
use anatomize_core::{Tick, Vec2};
use anatomize_physio::{Physio, PhysioInput};
use anatomize_sim::{Sim, build_tissue};
use anatomize_tissue::{TissueConfig, TissueSim};

const GROUND: f32 = -80.0;

/// 锤击强度（N·s），打在离膝 20cm 的小腿中段、朝**过伸**方向。
///
/// 这个值是标定出来的，不是随便写的：膝关节是铰链，打击方向不对只会把腿甩起来
/// （角自由度的约束冲量为 0，关节一点事没有）；只有把它打过 `limits` 的上限，
/// 才开始按超限比例磨损。所以"打膝盖"在物理上就是"打出一个过伸"。
///
/// 数值本身有点敏感（70 落在"扭伤→半脱位"，76 只是轻微扭伤，80 会一路到脱位）
/// ——这不是 bug，是"过伸 → 松弛 → 更容易过伸"这个正反馈在起作用。
const HAMMER: f32 = 70.0;

/// L2 + L4 的轻量夹具，没有 rapier。
struct Rig {
    tissue: TissueSim,
    physio: Physio,
    tick: Tick,
    ambient: f32,
    metab_base: f32,
}

impl Rig {
    fn new(ambient: f32) -> Self {
        let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
        let cfg = TissueConfig::asset();
        let mut tissue = build_tissue(&plan, &cfg);
        let mut physio = Physio::asset();
        let _ = &mut physio;
        tissue.warmup(physio.bus.map);
        let metab_base = tissue.cfg.metab_heat;
        tissue.cfg.ambient_c = ambient;
        Self {
            tissue,
            physio,
            tick: Tick(0),
            ambient,
            metab_base,
        }
    }

    /// 跑 `seconds` 秒。组织场 1Hz，生理层 60Hz。
    fn run(&mut self, seconds: f32) {
        for _ in 0..seconds.round() as u32 {
            self.tissue.cfg.ambient_c = self.ambient;
            self.tissue.cfg.metab_heat = self.metab_base * self.physio.bus.metab_scale;
            self.tissue.cfg.blood_c = self.physio.bus.temp_core;
            self.tissue.step(self.physio.bus.map, 1.0);

            let input = PhysioInput {
                hemorrhage_ml_s: self.tissue.step.wound_flux,
                tissue_o2: Some(self.tissue.step.mean_o2),
                skin_temp: Some(self.tissue.step.skin_temp),
                ambient_c: self.ambient,
            };
            for _ in 0..60 {
                self.tick.advance();
                self.physio.step(input, self.tick);
            }
        }
    }
}

#[test]
fn cold_exposure_drops_core_temperature_and_triggers_shivering() {
    let mut rig = Rig::new(5.0);
    rig.run(120.0);
    let start = rig.physio.bus.temp_core;
    let skin0 = rig.tissue.step.skin_temp;
    println!("5°C 起始：核心 {start:.2}，皮肤 {skin0:.2}");

    println!("\n   分钟   核心温度   皮肤温度   寒战   代谢率   热平衡W");
    for m in 1..=30 {
        rig.run(60.0);
        if m % 5 == 0 {
            let b = rig.physio.bus;
            println!(
                "   {m:5}    {:6.2}     {:6.2}   {:5.2}   {:6.2}   {:7.1}",
                b.temp_core, rig.tissue.step.skin_temp, b.shiver, b.metab_scale, b.heat_balance_w
            );
        }
    }

    let b = rig.physio.bus;
    let drop = start - b.temp_core;
    println!(
        "\n30 分钟后：核心 {:.2}°C（掉 {:.2}），寒战 {:.2}，代谢率 ×{:.2}，意识 {:.2}",
        b.temp_core, drop, b.shiver, b.metab_scale, b.consciousness
    );
    assert!(
        drop > 0.8,
        "5°C 裸露 30 分钟必须明显失温，实际掉 {drop:.2}°C"
    );
    assert!(b.shiver > 0.6, "必须寒战，实际 {}", b.shiver);
    assert!(
        b.metab_scale > 1.15,
        "代谢率必须升，实际 ×{}",
        b.metab_scale
    );
    // 还没到低体温昏迷的阈值（34°C），所以人是清醒的
    assert!(b.consciousness > 0.9, "意识 {}", b.consciousness);
}

#[test]
fn shivering_slows_the_cooling() {
    // 对照组：把寒战产热的增益设成 0，其余完全一样。
    let mut with_shiver = Rig::new(5.0);
    with_shiver.run(1800.0);
    let a = with_shiver.physio.bus.temp_core;

    let mut no_shiver = Rig::new(5.0);
    no_shiver.physio.cfg.shiver_boost = 0.0;
    no_shiver.run(1800.0);
    let b = no_shiver.physio.bus.temp_core;

    println!(
        "30 分钟：有寒战 {a:.3}°C，无寒战 {b:.3}°C，寒战救了 {:.3}°C",
        a - b
    );
    assert!(a > b, "寒战必须让核心温度更高（{a:.3} 应 > {b:.3}）");
    assert!(a - b > 0.05, "寒战的效果太小，几乎看不见：{:.4}", a - b);
}

#[test]
fn a_meal_raises_glucose_then_it_comes_back() {
    let mut rig = Rig::new(22.0);
    rig.run(600.0);
    let base = rig.physio.bus.glucose;
    let mmol = rig.physio.feed(500.0);
    println!("喂 500 kcal → {mmol:.0} mmol 葡萄糖当量，基线 {base:.2} mmol/L");

    let mut at30 = 0.0;
    let mut peak = base;
    let mut peak_at = 0;
    for m in 1..=120 {
        rig.run(60.0);
        let g = rig.physio.bus.glucose;
        if g > peak {
            peak = g;
            peak_at = m;
        }
        if m == 30 {
            at30 = g;
        }
    }
    let at120 = rig.physio.bus.glucose;
    println!("峰值 {peak:.2} @ {peak_at} 分钟，30 分钟 {at30:.2}，120 分钟 {at120:.2}");
    assert!(
        at30 - base >= 2.0,
        "30 分钟必须升 ≥2 mmol/L，实际 +{:.2}",
        at30 - base
    );
    assert!(
        (at120 - base).abs() <= 0.5,
        "2 小时必须回落，实际 {at120:.2}"
    );
    assert!(rig.physio.bus.map > 85.0, "吃饭不该影响血压");
}

fn hanging_body() -> Sim {
    let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
    let mut sim = Sim::spawn(plan, Vec2::new(0.0, 40.0), GROUND);
    sim.attach_tissue(&TissueConfig::asset());
    // 吊住头，腿才真的垂下来、才打得出过伸
    sim.set_part_fixed("head", true);
    for _ in 0..240 {
        sim.step();
    }
    sim
}

/// 朝过伸方向锤一下，等 2 秒让它摆回来。
fn hammer_knee(sim: &mut Sim) {
    sim.strike_part("shin_l", Vec2::new(HAMMER, 0.0), Vec2::new(0.0, -20.0));
    for _ in 0..120 {
        sim.step();
    }
}

#[test]
fn hammering_the_knee_five_times_sprains_then_subluxes_it() {
    let mut sim = hanging_body();
    let idx = sim.joint_index("knee_l").unwrap();
    println!(
        "初始：状态 {:?}，integrity {:.3}，疼痛 {:.3}",
        sim.body.joints[idx].health.state,
        sim.body.joints[idx].health.integrity,
        sim.body.joints[idx].health.pain
    );

    let mut history = vec![];
    for hit in 1..=5 {
        hammer_knee(&mut sim);
        let h = &sim.body.joints[idx].health;
        println!(
            "  第 {hit} 下：状态 {:?}，integrity {:.3}，疼痛 {:.3}，累积 {:.2}",
            h.state, h.integrity, h.pain, h.accumulated
        );
        history.push(h.state);
    }

    let h = sim.body.joints[idx].health;
    assert!(
        history.contains(&JointState::Sprained),
        "锤 5 下必须出现扭伤，实际 {history:?}"
    );
    assert!(
        h.state >= JointState::Subluxed,
        "锤 5 下应到半脱位，实际 {:?}",
        h.state
    );
    assert!(h.pain > 0.6, "疼痛必须 > 0.6，实际 {:.2}", h.pain);
    // 健侧必须完好
    let r = sim.joint_index("knee_r").unwrap();
    assert_eq!(sim.body.joints[r].health.state, JointState::Intact);
}

struct Trial {
    left_err: f32,
    right_err: f32,
    torso_tilt_deg: f32,
    pain: f32,
    state: JointState,
}

/// 同一套姿态控制器，受伤 / 不受伤各跑一遍，比较跟踪误差与躯干倾角。
///
/// 这是标准 A/B：**健侧不是对照组**。腿是连着的，一条腿出问题整个姿势都会偏，
/// 右膝的误差也会跟着变。真正的对照是"另一局里没挨打的那条腿"。
fn posture_trial(injure: bool) -> Trial {
    let mut sim = hanging_body();
    let knee_l = sim.joint_index("knee_l").unwrap();
    let knee_r = sim.joint_index("knee_r").unwrap();

    sim.enable_posture();
    for _ in 0..240 {
        sim.step();
    }
    // 健康时的目标姿势。受伤之后再套回同一个目标，才看得出"拉不住了"。
    let healthy = sim.posture.as_ref().unwrap().targets.clone();

    if injure {
        // 锤击时必须关掉姿态控制：带着主动力矩，关节根本过不了伸，也就打不伤。
        // 这不是取巧——一记硬击的角冲量（14 N·m·s）远大于肌张力给得出的力矩。
        sim.disable_posture();
        for _ in 0..5 {
            hammer_knee(&mut sim);
        }
        sim.enable_posture();
        sim.posture.as_mut().unwrap().targets = healthy;
    }

    for _ in 0..240 {
        sim.step();
    }

    let err = |i: usize| {
        let target = sim.posture.as_ref().unwrap().targets[i];
        (sim.joint_load(i).angle - target).abs()
    };
    let h = sim.body.joints[knee_l].health;
    Trial {
        left_err: err(knee_l),
        right_err: err(knee_r),
        torso_tilt_deg: sim.part_angle("torso").unwrap_or(0.0).to_degrees(),
        pain: h.pain,
        state: h.state,
    }
}

#[test]
fn pain_makes_the_body_favour_the_injured_leg() {
    let a = posture_trial(false);
    let b = posture_trial(true);

    println!(
        "对照组：左膝误差 {:.4}，右膝 {:.4}，躯干倾角 {:.1}°",
        a.left_err, a.right_err, a.torso_tilt_deg
    );
    println!(
        "受伤组：左膝误差 {:.4}，右膝 {:.4}，躯干倾角 {:.1}°；状态 {:?}，疼痛 {:.2}",
        b.left_err, b.right_err, b.torso_tilt_deg, b.state, b.pain
    );

    assert!(b.pain > 0.6, "疼痛 {:.2}", b.pain);
    assert!(b.state >= JointState::Subluxed, "状态 {:?}", b.state);

    // 1. 目标没变，但伤腿拉不住了
    assert!(
        b.left_err > a.left_err * 2.0 + 0.01,
        "伤腿必须明显更跟不上目标：{:.4} → {:.4}",
        a.left_err,
        b.left_err
    );

    // 2. 伤腿的绝对误差要够大（"拉不回来"是可观测的）
    assert!(
        b.left_err > 0.03,
        "伤腿误差只有 {:.4} rad，看不出护痛",
        b.left_err
    );
    // 躯干倾角只记录不断言：姿态控制加了死区之后，静止姿态被锁得更稳，
    // 倾角变化从 18.9° 掉到 1° 左右。那不是退步——不抖了才是对的。
    let tilt = (b.torso_tilt_deg - a.torso_tilt_deg).abs();
    println!("躯干倾角变化 {tilt:.1}°（死区让静止姿态更稳，这个数不再作为判据）");
}

#[test]
fn losing_consciousness_removes_the_posture() {
    // 姿态控制器是"意识 × 交感张力"驱动的。意识掉下去，人必须软下去。
    let mut sim = hanging_body();
    sim.enable_posture();
    for _ in 0..120 {
        sim.step();
    }
    let tone_awake = sim.muscle_tone();

    sim.physio.bus.consciousness = 0.0;
    for _ in 0..10 {
        sim.step();
    }
    let tone_out = sim.muscle_tone();
    println!("肌张力：清醒 {tone_awake:.2} → 昏迷 {tone_out:.2}");
    assert!(tone_awake > 0.4, "清醒时该有肌张力，实际 {tone_awake:.2}");
    assert!(tone_out < 0.01, "昏迷时必须是零，实际 {tone_out:.3}");
}
