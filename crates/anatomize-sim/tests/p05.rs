//! P0.5 验收：5 秒回溯。
//!
//! 核心断言只有一句：**退回去之后，世界应该和当初一模一样**。
//! 分四个角度验：
//!
//! 1. 切割撤销（组织场的 `k0` / `wound` 回滚 → 出血归零）
//! 2. 生理回滚（血容量、MAP 回到当初的值）
//! 3. 几何回滚（块数、位姿）
//! 4. 缓冲行为（容量、采样粒度、退过头）

use anatomize_body::{ASSET_HUMAN_01, BodyPlan};
use anatomize_core::Vec2;
use anatomize_cut::CutSegment;
use anatomize_sim::Sim;
use anatomize_tissue::TissueConfig;

fn world() -> Sim {
    let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
    let mut sim = Sim::spawn(plan, Vec2::new(0.0, 40.0), -80.0);
    sim.attach_tissue(&TissueConfig::asset());
    sim.set_part_fixed("head", true);
    for _ in 0..180 {
        sim.step();
    }
    sim
}

fn femoral_cut() -> CutSegment {
    CutSegment {
        a: Vec2::new(-15.0, -25.0),
        b: Vec2::new(-1.0, -25.0),
        width: 0.6,
        speed: 1.0,
    }
}

#[test]
fn the_buffer_holds_five_seconds() {
    let mut sim = world();
    // world() 只跑了 3 秒（180 帧 → 12 帧快照），再跑 3 秒才存满
    for _ in 0..200 {
        sim.step();
    }
    println!(
        "缓冲：{} 帧 / 容量 {} / 跨度 {:.2}s / 占用 {:.1} MB",
        sim.rewind.len(),
        sim.rewind.capacity(),
        sim.rewind.span_s(),
        sim.rewind.bytes() as f32 / 1024.0 / 1024.0
    );
    assert_eq!(sim.rewind.capacity(), 20, "5 秒 / 0.25 秒 = 20 帧");
    assert_eq!(sim.rewind.len(), 20, "跑满之后应该正好 20 帧");
    assert!((sim.rewind.span_s() - 5.0).abs() < 0.3);

    // 存满 20 帧 × 组织场快照，体积得在几十 MB 以内，否则没法每帧跑
    let mb = sim.rewind.bytes() as f32 / 1024.0 / 1024.0;
    assert!(mb < 60.0, "回溯缓冲 {mb:.1} MB 太胖");
}

/// 切一刀、流两秒血、退回去——出血必须归零，血容量必须回来。
#[test]
fn rewinding_undoes_the_cut() {
    let mut sim = world();
    let vol_before = sim.creatures[sim.active].physio.bus.blood_volume;
    let pieces_before = sim.body.pieces.len();
    assert_eq!(sim.hemorrhage_ml_s(), 0.0, "还没切，不该出血");

    // 切完再跑 2 秒，让快照覆盖到"切之前"
    sim.cut_body_local(&femoral_cut()).expect("组织场");
    let bleed = sim.hemorrhage_ml_s();
    println!("切完出血 {bleed:.2} mL/s");
    assert!(bleed > 5.0);

    for _ in 0..120 {
        sim.step();
    }
    let vol_after = sim.creatures[sim.active].physio.bus.blood_volume;
    let lost = vol_before - vol_after;
    println!("2 秒流掉 {lost:.1} mL，血容量 {vol_before:.0} → {vol_after:.0}");
    assert!(lost > 20.0, "2 秒应该流掉几十毫升");

    let back = sim.rewind(2.5).expect("缓冲里应该有 2.5 秒前的帧");
    println!("退回 {back:.2} 秒");

    let bleed_now = sim.hemorrhage_ml_s();
    let vol_now = sim.creatures[sim.active].physio.bus.blood_volume;
    println!(
        "退回去之后：出血 {bleed_now:.3} mL/s，血容量 {vol_now:.1}（切之前 {vol_before:.1}），{} 块",
        sim.body.pieces.len()
    );

    // 1. 出血必须归零——k0 和 wound 都回滚了
    assert!(
        bleed_now < 0.01,
        "退回之后不该还在流血，实际 {bleed_now:.3} mL/s"
    );
    // 2. 血容量回到切之前
    assert!(
        (vol_now - vol_before).abs() < 1.0,
        "血容量没回来：{vol_now:.1} vs {vol_before:.1}"
    );
    // 3. 几何也回去了（这一刀没切到刚体，所以块数不变，但位姿要回去）
    assert_eq!(sim.body.pieces.len(), pieces_before);
}

/// 切割 + 几何碎片一起回滚。
#[test]
fn rewinding_undoes_the_slicing_too() {
    let mut sim = world();
    let before = sim.body.pieces.len();
    let thigh = sim
        .plan
        .parts
        .iter()
        .position(|p| p.name == "thigh_l")
        .unwrap();
    let (pos, _) = sim.piece_pose(sim.creatures[sim.active].primary[thigh]);
    let cut = CutSegment {
        a: pos - Vec2::new(0.06, 0.0),
        b: pos + Vec2::new(0.06, 0.0),
        width: 0.005,
        speed: 2.0,
    };

    for _ in 0..30 {
        sim.step();
    }
    sim.slice(&cut);
    sim.cut(&cut);
    for _ in 0..120 {
        sim.step();
    }
    let after = sim.body.pieces.len();
    println!(
        "切开：{before} → {after} 块，出血 {:.2} mL/s",
        sim.hemorrhage_ml_s()
    );
    assert!(after > before);

    let back = sim.rewind(2.5).expect("有快照");
    println!(
        "退回 {back:.2}s：{} 块，出血 {:.3} mL/s",
        sim.body.pieces.len(),
        sim.hemorrhage_ml_s()
    );
    assert_eq!(sim.body.pieces.len(), before, "碎片必须消失");
    assert!(sim.hemorrhage_ml_s() < 0.01);
}

/// 退得比缓冲还远时，退到最老的那一帧，不 panic。
#[test]
fn asking_for_too_much_rewinds_to_the_oldest_frame() {
    let mut sim = world();
    // 跑满缓冲（5 秒以上）才谈得上"退到最老"
    for _ in 0..360 {
        sim.step();
    }
    let back = sim.rewind(999.0).expect("有快照");
    println!("要退 999 秒，实际退了 {back:.2} 秒");
    assert!(back > 4.0 && back < 5.5, "应该退到缓冲最老的一帧：{back}");
}

/// 回滚之后继续跑，世界不能卡死或爆掉。
#[test]
fn the_world_keeps_running_after_a_rewind() {
    let mut sim = world();
    sim.cut_body_local(&femoral_cut()).expect("组织场");
    for _ in 0..240 {
        sim.step();
    }
    sim.rewind(3.0).expect("有快照");
    for _ in 0..600 {
        sim.step();
        sim.clamp_velocities();
    }
    let d = sim.diagnostics();
    println!(
        "回滚后再跑 10 秒：MAP {:.1}，血容量 {:.0}，最大速度 {:.2} m/s，NaN {}",
        sim.creatures[sim.active].physio.bus.map, sim.creatures[sim.active].physio.bus.blood_volume, d.max_speed, d.nan
    );
    assert!(!d.nan);
    assert!(d.max_speed < 100.0);
    assert!(sim.creatures[sim.active].physio.bus.map.is_finite());
    // 退回去再流一遍，还是会失血——回溯不是治疗
    assert!(sim.creatures[sim.active].physio.bus.blood_volume < 5000.0);
}
