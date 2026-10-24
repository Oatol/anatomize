//! 多 ragdoll：两具身体共用一个物理世界，但生理 / 组织场 / 姿态各管各的。
//!
//! 这组测试盯的是"**没有串味**"：
//!
//! - 切一具，另一具的块数、生理、组织场不能动
//! - 两具各流各的血（出血速率相加，但血容量各自掉）
//! - 一具昏迷，另一具的肌张力不受影响
//! - 删掉一具，另一具照常站着
//! - 存档 / 读档 / 回溯要带回所有具

use anatomize_body::{ASSET_HUMAN_01, BodyPlan};
use anatomize_core::Vec2;
use anatomize_sim::{PieceId, Sim, WorldBounds};

/// 两具人偶，并排放，都站着。
fn two_bodies() -> Sim {
    let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
    let w = WorldBounds::default();
    let stand = plan.stand_height();
    let mut sim = Sim::spawn_in(plan, Vec2::new(-0.55, stand), w);
    sim.attach_tissue(&anatomize_tissue::TissueConfig::asset());
    sim.stand();
    // 第二具：右边
    sim.add_creature(Vec2::new(0.55, stand));
    sim.attach_tissue(&anatomize_tissue::TissueConfig::asset());
    sim.stand();
    for _ in 0..90 {
        sim.step();
    }
    sim
}

#[test]
fn two_bodies_share_the_world_but_not_their_state() {
    let sim = two_bodies();
    println!(
        "生物 {} 具，块 {} 块（{} + {}），关节 {} 条",
        sim.creatures.len(),
        sim.body.pieces.len(),
        sim.creature_pieces(0),
        sim.creature_pieces(1),
        sim.body.joints.len()
    );
    assert_eq!(sim.creatures.len(), 2);
    // 每具都是完整的 11 块
    assert_eq!(sim.creature_pieces(0), sim.plan.parts.len());
    assert_eq!(sim.creature_pieces(1), sim.plan.parts.len());
    assert_eq!(sim.body.joints.len(), sim.plan.joints.len() * 2);
    // 块不共享
    let p0: Vec<PieceId> = sim.creatures[0].primary.clone();
    let p1: Vec<PieceId> = sim.creatures[1].primary.clone();
    assert!(p0.iter().all(|a| !p1.contains(a)), "两具身体的块重号了");
    // 两具都在
    assert_eq!(sim.living_creatures(), 2);
}

/// 切第一具的大腿，第二具一块都不能少。
#[test]
fn cutting_one_body_does_not_touch_the_other() {
    let mut sim = two_bodies();
    let before_1 = sim.creature_pieces(1);
    let thigh = sim
        .plan
        .parts
        .iter()
        .position(|p| p.name == "thigh_l")
        .unwrap();
    // 第一具的左大腿
    let id = sim.creatures[0].primary[thigh];
    let (pos, _) = sim.piece_pose(id);
    let cut = anatomize_cut::CutSegment {
        a: pos - Vec2::new(0.06, 0.0),
        b: pos + Vec2::new(0.06, 0.0),
        width: 0.005,
        speed: 2.0,
    };
    let r = sim.slice(&cut);
    println!(
        "切了 {} 块；第一具 {} 块，第二具 {} 块",
        r.new_pieces,
        sim.creature_pieces(0),
        sim.creature_pieces(1)
    );
    assert_eq!(r.new_pieces, 1);
    assert_eq!(sim.creature_pieces(0), sim.plan.parts.len() + 1);
    assert_eq!(sim.creature_pieces(1), before_1, "切第一具时把第二具也切了");
}

/// 切第一具的组织场，第二具的场一个 texel 都不能变。
///
/// 这条比"血容量"更直接：场是钉在**身体坐标系**里的一张图，两具各一张。
/// 串味的话，第二具身上会出现凭空多出来的创口。
#[test]
fn cutting_one_body_does_not_wound_the_other() {
    let mut sim = two_bodies();
    let v1 = sim.creatures[1].physio.bus.blood_volume;

    // 横切第一具的躯干（走组织场那条路）
    let torso = sim
        .plan
        .parts
        .iter()
        .position(|p| p.name == "torso")
        .unwrap();
    let id = sim.creatures[0].primary[torso];
    let (pos, _) = sim.piece_pose(id);
    let cut = anatomize_cut::CutSegment {
        a: pos - Vec2::new(0.12, 0.0),
        b: pos + Vec2::new(0.12, 0.0),
        width: 0.02,
        speed: 2.0,
    };
    sim.slice(&cut);
    sim.cut(&cut);
    for _ in 0..180 {
        sim.step();
    }

    let w0 = sim.creatures[0]
        .tissue
        .as_ref()
        .unwrap()
        .field
        .wound
        .iter()
        .filter(|w| **w)
        .count();
    let d1 = sim.creatures[1]
        .tissue
        .as_ref()
        .unwrap()
        .field
        .damage
        .iter()
        .filter(|d| **d > 0.0)
        .count();
    let v1b = sim.creatures[1].physio.bus.blood_volume;
    println!("第一具创口 texel {w0}；第二具受损 texel {d1}；第二具血容量 {v1:.1} → {v1b:.1}");
    assert!(w0 > 0, "被切的那具应该有创口");
    assert_eq!(d1, 0, "没被切的那具身上出现了损伤：{d1} 个 texel");
    // 没被切的那具只有正常的体液蒸发，几毫升量级
    assert!(
        (v1b - v1).abs() < 5.0,
        "没被切的那具血容量变化太大：{v1:.1} → {v1b:.1}"
    );
}

/// 一具昏迷，另一具照常用力。
#[test]
fn one_body_going_unconscious_does_not_weaken_the_other() {
    let mut sim = two_bodies();
    // 把第一具打昏
    sim.creatures[0].physio.bus.consciousness = 0.0;
    let tone0 = sim.muscle_tone_of(0);
    let tone1 = sim.muscle_tone_of(1);
    println!("肌张力：第一具 {tone0:.3}，第二具 {tone1:.3}");
    assert!(tone0 < 0.05, "昏迷的那具应该软下去");
    assert!(tone1 > 0.5, "另一具不该跟着软：{tone1:.3}");

    // 再跑 5 秒，第二具还站着
    for _ in 0..300 {
        sim.step();
    }
    let (p1, r1) = sim.piece_pose(sim.creatures[1].primary[0]);
    println!(
        "5 秒后第二具骨盆 ({:.3}, {:.3})，倾角 {:.1}°",
        p1.x,
        p1.y,
        r1.to_degrees()
    );
    assert!(r1.abs() < 0.4, "第二具倒了：{:.1}°", r1.to_degrees());
    assert!(p1.x > 0.2, "第二具滑到左边去了：x = {:.2}", p1.x);
}

/// 删掉一具，另一具不受影响。
#[test]
fn deleting_one_body_leaves_the_other_standing() {
    let mut sim = two_bodies();
    let ids: Vec<PieceId> = (0..sim.body.pieces.len())
        .filter(|&i| {
            let p = &sim.body.pieces[i];
            !p.deleted && p.creature == 0
        })
        .map(|i| PieceId(i as u32))
        .collect();
    for id in ids {
        sim.delete_piece(id);
    }
    for _ in 0..120 {
        sim.step();
    }
    println!(
        "删完第一具：活着 {} 具，第二具 {} 块",
        sim.living_creatures(),
        sim.creature_pieces(1)
    );
    assert_eq!(sim.living_creatures(), 1);
    assert_eq!(sim.creature_pieces(1), sim.plan.parts.len());
    let (p, r) = sim.piece_pose(sim.creatures[1].primary[0]);
    assert!(r.abs() < 0.4, "第二具倒了：{:.1}°", r.to_degrees());
    let _ = p;
}

/// 存档 → 读档：两具都要回来，各带自己的生理。
#[test]
fn a_save_keeps_every_creature() {
    let mut sim = two_bodies();
    // 让第二具失点血，读档后要能看出来
    sim.creatures[1].physio.bus.blood_volume -= 400.0;
    let save = sim.save();
    let mut back = Sim::load(&save, 0.0).expect("读档");
    println!(
        "读档：{} 具，块 {} 块，关节 {} 条",
        back.creatures.len(),
        back.body.pieces.len(),
        back.body.joints.len()
    );
    assert_eq!(back.creatures.len(), 2);
    assert_eq!(back.creature_pieces(0), sim.plan.parts.len());
    assert_eq!(back.creature_pieces(1), sim.plan.parts.len());
    assert!(
        (back.creatures[1].physio.bus.blood_volume - (5000.0 - 400.0)).abs() < 1.0,
        "第二具的血容量没读回来：{}",
        back.creatures[1].physio.bus.blood_volume
    );
    // 跑一段不能崩
    for _ in 0..120 {
        back.step();
    }
}

/// 5 秒回溯要带回所有具。
#[test]
fn a_rewind_restores_every_creature() {
    let mut sim = two_bodies();
    // 切第一具，让状态不一样
    let thigh = sim
        .plan
        .parts
        .iter()
        .position(|p| p.name == "thigh_l")
        .unwrap();
    let id = sim.creatures[0].primary[thigh];
    let (pos, _) = sim.piece_pose(id);
    let cut = anatomize_cut::CutSegment {
        a: pos - Vec2::new(0.06, 0.0),
        b: pos + Vec2::new(0.06, 0.0),
        width: 0.005,
        speed: 2.0,
    };
    sim.slice(&cut);
    sim.cut(&cut);
    for _ in 0..120 {
        sim.step();
    }
    let after = sim.creature_pieces(0);
    // 切割发生在 2 秒前，要退到切割之前得退 3 秒
    let back = sim.rewind(3.0).expect("有快照");
    for _ in 0..30 {
        sim.step();
    }
    println!(
        "回滚 {back:.2} 秒：第一具 {} → {} 块，活着 {} 具",
        after,
        sim.creature_pieces(0),
        sim.living_creatures()
    );
    assert_eq!(
        sim.creature_pieces(0),
        sim.plan.parts.len(),
        "回滚之后该恢复成完整身体"
    );
    assert_eq!(sim.living_creatures(), 2);
}

/// `active` 决定"喂谁""给谁挂场"，不能串。
#[test]
fn the_active_creature_is_the_one_you_operate_on() {
    let mut sim = two_bodies();
    assert_eq!(sim.active, 1, "刚加的那具应该是 active");

    let before = (
        sim.creatures[0].physio.bus.stomach_mmol,
        sim.creatures[1].physio.bus.stomach_mmol,
    );
    sim.feed(500.0);
    for _ in 0..60 {
        sim.step();
    }
    let after = (
        sim.creatures[0].physio.bus.stomach_mmol,
        sim.creatures[1].physio.bus.stomach_mmol,
    );
    println!(
        "喂食：第一具 {:.1}→{:.1}，第二具 {:.1}→{:.1}",
        before.0, after.0, before.1, after.1
    );
    assert!(after.1 > before.1, "active 那具应该吃到东西");
    assert!(
        (after.0 - before.0).abs() < 1e-3,
        "另一具不该被喂到：{} → {}",
        before.0,
        after.0
    );

    // 切到第一具，再喂一次
    assert!(sim.set_active(0));
    sim.feed(500.0);
    for _ in 0..60 {
        sim.step();
    }
    assert!(
        sim.creatures[0].physio.bus.stomach_mmol > after.0,
        "切到第一具之后应该能喂到它"
    );
}
