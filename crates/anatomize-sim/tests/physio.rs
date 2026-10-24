//! M4 验收：切断血管之后，人是不是按生理学的样子死。
//!
//! 这里跑的是**真的闭环**：`Sim` 里组织场和 0D 生理每 tick 互相喂数，
//! 没有一处"每秒失血 X mL"的常数。
//!
//! 两个场景：
//!
//! - **主动脉离断**：出血速率接近整个心输出量，几十秒内失代偿。这是验收标准 1。
//! - **股动脉离断**：出血速率约 4 mL/s，按临床是几十分钟的事。验收标准 1 原文
//!   写的是"股动脉 + 20 秒"，物理上做不到——20 秒内丢掉 45% 血容量需要的出血
//!   速率超过心输出量本身。见 `doc` 里的说明和 `femoral_bleed_is_slow_but_fatal`。

use anatomize_body::{ASSET_HUMAN_01, BodyPlan};
use anatomize_core::Vec2;
use anatomize_cut::CutSegment;
use anatomize_sim::Sim;
use anatomize_tissue::TissueConfig;

const GROUND: f32 = -80.0;

fn world() -> Sim {
    let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
    let mut sim = Sim::spawn(plan, Vec2::new(0.0, 40.0), GROUND);
    sim.attach_tissue(&TissueConfig::asset());
    sim
}

/// 让 ragdoll 落地站稳，再开始实验。落地那一下会磨掉一点关节完整性，
/// 但那不影响生理量。
fn settle(sim: &mut Sim, seconds: f32) {
    for _ in 0..(seconds * 60.0) as u32 {
        sim.step();
    }
}

/// 一刀横断躯干（主动脉），一刀横断大腿（股动脉）。坐标是身体局部厘米。
fn torso_cut() -> CutSegment {
    CutSegment {
        a: Vec2::new(-16.0, 22.0),
        b: Vec2::new(16.0, 22.0),
        width: 0.6,
        speed: 1.0,
    }
}

fn thigh_cut() -> CutSegment {
    CutSegment {
        a: Vec2::new(-15.0, -25.0),
        b: Vec2::new(-1.0, -25.0),
        width: 0.6,
        speed: 1.0,
    }
}

struct Trace {
    /// 每个采样点的 (秒, MAP, HR, 意识, 血容量, 出血速率)
    points: Vec<(f32, f32, f32, f32, f32, f32)>,
}

impl Trace {
    fn first_where(&self, f: impl Fn(&(f32, f32, f32, f32, f32, f32)) -> bool) -> Option<f32> {
        self.points.iter().find(|p| f(p)).map(|p| p.0)
    }
}

/// 跑一段，每 `every` 秒采一个点。`press_at` 到了就按压创口。
fn run(sim: &mut Sim, seconds: f32, every: f32, press_at: Option<f32>) -> Trace {
    let mut points = Vec::new();
    let mut pressed = false;
    let total = (seconds * 60.0) as u32;
    let stride = (every * 60.0).max(1.0) as u32;
    for i in 0..=total {
        let t = i as f32 / 60.0;
        if let Some(pt) = press_at
            && !pressed
            && t >= pt
        {
            let q = sim.press_wound(true);
            println!("  t={t:.1}s 按压创口 → 出血 {q:.3} mL/s");
            pressed = true;
        }
        if i % stride == 0 {
            let b = sim.physio.bus;
            points.push((
                t,
                b.map,
                b.heart_rate,
                b.consciousness,
                b.blood_volume,
                sim.hemorrhage_ml_s(),
            ));
        }
        sim.step();
    }
    Trace { points }
}

fn print_trace(name: &str, tr: &Trace) {
    println!("\n=== {name} ===");
    println!("    t(s)    MAP     HR   意识   血量(mL)  出血(mL/s)");
    for p in tr.points.iter() {
        println!(
            "  {:6.1}  {:6.1}  {:5.0}  {:5.2}  {:8.0}  {:8.2}",
            p.0, p.1, p.2, p.3, p.4, p.5
        );
    }
}

#[test]
fn aortic_transection_kills_within_a_minute() {
    let mut sim = world();
    settle(&mut sim, 2.0);

    let out = sim.cut_body_local(&torso_cut()).expect("挂了组织场");
    println!("{}", out.report.summary(&sim.plan));
    let q0 = sim.hemorrhage_ml_s();
    println!(
        "主动脉离断：创口 {} texel，断供 {} texel，即刻出血 {q0:.2} mL/s（{:.1} L/min）",
        out.wound_texels,
        out.starved_texels,
        q0 * 0.06
    );
    assert!(q0 > 5.0, "主动脉离断必须大出血，实际 {q0:.2} mL/s");

    let tr = run(&mut sim, 120.0, 5.0, None);
    print_trace("主动脉离断", &tr);

    let map45 = tr.first_where(|p| p.1 < 45.0);
    let hr130 = tr.first_where(|p| p.2 > 130.0);
    let coma = tr.first_where(|p| p.3 < 0.2);

    println!(
        "\nMAP<45 在 {:?}s，HR>130 在 {:?}s，意识<0.2 在 {:?}s",
        map45, hr130, coma
    );

    let map45 = map45.expect("主动脉离断必须把 MAP 打下来");
    assert!(map45 < 60.0, "MAP<45 用了 {map45:.1}s，太慢");
    assert!(hr130.is_some(), "心率必须顶上去");
    let coma = coma.expect("主动脉离断必须晕过去");
    assert!(coma < 90.0, "意识<0.2 用了 {coma:.1}s，太慢");
}

#[test]
fn compressing_the_wound_stops_the_bleeding_and_the_pressure() {
    let mut sim = world();
    settle(&mut sim, 2.0);

    sim.cut_body_local(&torso_cut()).expect("挂了组织场");
    let q0 = sim.hemorrhage_ml_s();
    println!("离断即刻出血 {q0:.2} mL/s");

    // 先流 15 秒，让它真的开始掉血压
    let before = run(&mut sim, 15.0, 5.0, None);
    print_trace("按压前 15s", &before);
    let map_before = sim.physio.bus.map;

    let q_pressed = sim.press_wound(true);
    println!("按压 → 出血 {q_pressed:.3} mL/s");
    assert!(q_pressed < 0.1, "按住之后还流血：{q_pressed:.3} mL/s");

    let after = run(&mut sim, 30.0, 5.0, None);
    print_trace("按压后 30s", &after);

    let map_after = sim.physio.bus.map;
    println!("MAP：按压时 {map_before:.1} → 30s 后 {map_after:.1}");
    // 按压之后 MAP 不再往下掉（允许 1 mmHg 的数值抖动）
    assert!(
        map_after > map_before - 1.0,
        "按压后 MAP 还在掉：{map_before:.1} → {map_after:.1}"
    );

    // 松开就重新开始流
    let q_release = sim.press_wound(false);
    println!("松开 → 出血 {q_release:.2} mL/s");
    assert!(
        q_release > 1.0,
        "松开必须重新出血，实际 {q_release:.2} mL/s"
    );
}

#[test]
fn femoral_bleed_is_slow_but_fatal() {
    // 股动脉：临床上是几十分钟的事。这里跑 60 秒确认方向对：
    // 出血在，血压在缓慢下降，心率在升，但远没到崩溃。
    let mut sim = world();
    settle(&mut sim, 2.0);

    let out = sim.cut_body_local(&thigh_cut()).expect("挂了组织场");
    println!("{}", out.report.summary(&sim.plan));
    let q0 = sim.hemorrhage_ml_s();
    println!(
        "股动脉离断：创口 {} texel，即刻出血 {q0:.2} mL/s（{:.0} mL/min）",
        out.wound_texels,
        q0 * 60.0
    );
    assert!(q0 > 1.0, "股动脉离断必须出血，实际 {q0:.2} mL/s");

    let tr = run(&mut sim, 60.0, 10.0, None);
    print_trace("股动脉离断 60s", &tr);

    let b = sim.physio.bus;
    println!(
        "60s 后：失血 {:.0} mL（{:.1}%），MAP {:.1}，HR {:.0}",
        b.blood_lost_ml,
        b.blood_lost_ml / 50.0,
        b.map,
        b.heart_rate
    );
    // 60 秒只掉不到 300 mL，MAP 基本还在代偿区
    assert!(b.map > 80.0, "股动脉 60 秒不该失代偿，MAP = {}", b.map);
    assert!(b.heart_rate > 72.0, "心率必须开始升，实际 {}", b.heart_rate);
}

/// 断端电导是并联上去的，不能凭空造出血液。
///
/// 这条守恒是整套耦合的地基：`动脉流入 = 静脉回流 + 创口出血`。断端那一份血
/// 必须是从上游动脉真流过来的，否则"砍断血管"就变成了一个负血容量作弊器。
#[test]
fn the_wound_does_not_create_blood_from_nothing() {
    let mut sim = world();
    settle(&mut sim, 2.0);

    sim.cut_body_local(&thigh_cut()).expect("挂了组织场");
    let t = sim.tissue.as_ref().unwrap();
    let s = t.step;
    println!(
        "动脉流入 {:.3} = 静脉回流 {:.3} + 创口 {:.3}（残差 {:.3e}）",
        s.arterial_inflow,
        s.venous_return,
        s.wound_flux,
        s.arterial_inflow - s.venous_return - s.wound_flux
    );
    let residual = (s.arterial_inflow - s.venous_return - s.wound_flux).abs();
    assert!(
        residual < s.arterial_inflow * 0.02,
        "血流不守恒：残差 {residual:.4} 超过 2%"
    );
}

#[test]
fn a_cut_that_misses_every_vessel_does_not_bleed_much() {
    let mut sim = world();
    settle(&mut sim, 2.0);

    // 右臂外侧一道浅划，不碰血管
    let cut = CutSegment {
        a: Vec2::new(22.0, 30.0),
        b: Vec2::new(19.0, 28.0),
        width: 0.4,
        speed: 1.0,
    };
    let out = sim.cut_body_local(&cut).expect("挂了组织场");
    assert!(out.report.is_empty());
    let q = sim.hemorrhage_ml_s();
    println!("浅划出血 {q:.3} mL/s（{:.0} mL/min）", q * 60.0);
    assert!(q < 1.0, "浅划不该大出血，实际 {q:.3} mL/s");

    let tr = run(&mut sim, 20.0, 10.0, None);
    print_trace("浅划 20s", &tr);
    assert!(sim.physio.bus.map > 90.0, "浅划不该影响血压");
}
