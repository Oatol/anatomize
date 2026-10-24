//! 沙盒编辑操作：生成 / 冻结 / 删除 / 击打。
//!
//! 这四个是窗口版最容易崩的地方——它们都要**建/删刚体**，而刚体句柄
//! 一旦失效，任何还指着它的地方（关节、渲染、诊断）都会 panic。
//! 这组测试就是盯着这条线。

use anatomize_body::{ASSET_HUMAN_01, BodyPlan};
use anatomize_core::Vec2;
use anatomize_sim::{PieceId, Sim, WorldBounds};

fn world() -> Sim {
    let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
    let w = WorldBounds::default();
    let mut sim = Sim::spawn_in(plan, Vec2::new(0.0, w.stand_height()), w);
    sim.attach_tissue(&anatomize_tissue::TissueConfig::asset());
    for _ in 0..120 {
        sim.step();
    }
    sim
}

#[test]
fn spawning_items_adds_pieces_with_catalog_entries() {
    let mut sim = world();
    let before = sim.body.pieces.len();
    let id = sim
        .spawn_item_by_id("crate", Vec2::new(1.0, 0.5))
        .expect("木箱应该在目录里");
    assert_eq!(sim.body.pieces.len(), before + 1);
    assert!(sim.is_prop(id));
    assert_eq!(sim.piece_name(id), "木箱");
    assert!(sim.item_of(id).is_some());
    println!(
        "生成木箱：{} 块，质量 {:.1} kg",
        sim.body.pieces.len(),
        sim.body.pieces[id.index()].mass
    );
}

/// 冻结 / 解冻 / 删除：每一步之后都要能继续跑，不能崩。
#[test]
fn freeze_unfreeze_delete_never_crashes() {
    let mut sim = world();
    let id = sim.spawn_item_by_id("ball", Vec2::new(1.0, 1.0)).unwrap();
    for _ in 0..30 {
        sim.step();
    }

    // 冻结
    assert!(sim.set_frozen(id, true));
    assert!(sim.body.pieces[id.index()].is_frozen());
    for _ in 0..30 {
        sim.step();
    }
    // 冻结的块位姿还能读到
    let (pos, _) = sim.piece_pose(id);
    assert!(pos.x.is_finite());

    // 解冻
    assert!(!sim.set_frozen(id, false));
    assert!(!sim.body.pieces[id.index()].is_frozen());
    for _ in 0..30 {
        sim.step();
    }

    // 删除
    assert!(sim.delete_piece(id));
    for _ in 0..60 {
        sim.step();
        // 渲染路径要能跳过它
        let _ = sim.piece_polygon(id);
        let _ = sim.diagnostics();
    }
    assert!(sim.body.pieces[id.index()].deleted);
    println!("冻结 → 解冻 → 删除，全程 {} 帧无 panic", 150);
}

/// 冻结**身体的一块**（有关节连着）也不能崩。
#[test]
fn freezing_a_body_part_does_not_break_joints() {
    let mut sim = world();
    let thigh = sim
        .plan
        .parts
        .iter()
        .position(|p| p.name == "thigh_l")
        .unwrap();
    let id = sim.body.primary[thigh];
    assert!(sim.set_frozen(id, true));
    for _ in 0..60 {
        sim.step();
        // 关节还在读这块的锚点——必须能容错
        for j in 0..sim.body.joints.len() {
            let _ = sim.joint_load(j);
        }
        let _ = sim.diagnostics();
    }
    println!("冻结左大腿 60 帧无 panic");
}

/// 击打道具：速度要真的变。
#[test]
fn striking_a_prop_changes_its_velocity() {
    let mut sim = world();
    let id = sim.spawn_item_by_id("crate", Vec2::new(0.0, 1.5)).unwrap();
    for _ in 0..20 {
        sim.step();
    }
    let v0 = sim.piece_velocity(id);
    let (pos, _) = sim.piece_pose(id);
    assert!(sim.strike_piece(id, Vec2::new(60.0, 20.0), pos));
    sim.step();
    let v1 = sim.piece_velocity(id);
    println!("砸之前 {v0:?}，砸之后 {v1:?}");
    assert!((v1 - v0).length() > 0.5, "冲量没起作用");
}

/// 击打冻结的块要安全失败（不能 panic，也不能把它打飞）。
#[test]
fn striking_a_frozen_piece_is_a_no_op() {
    let mut sim = world();
    let id = sim.spawn_item_by_id("crate", Vec2::new(0.0, 1.5)).unwrap();
    sim.set_frozen(id, true);
    let (pos, _) = sim.piece_pose(id);
    assert!(!sim.strike_piece(id, Vec2::new(500.0, 0.0), pos));
    for _ in 0..10 {
        sim.step();
    }
    let (pos2, _) = sim.piece_pose(id);
    assert!((pos2 - pos).length() < 1e-4, "冻结的块不该动");
}
