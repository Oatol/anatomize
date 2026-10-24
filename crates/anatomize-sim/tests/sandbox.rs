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

/// 切掉的肢体必须在场里变成 Outside。
///
/// 不这么做的话，F1 热力图会在原位置继续画那块已经飞走的肉——
/// 看起来就是"贴了张图"，和身体的动作完全脱节。
#[test]
fn a_detached_piece_leaves_the_field() {
    let mut sim = world();
    let before = outside_count(&sim);

    // 在左大腿中间切一刀
    let thigh = sim
        .plan
        .parts
        .iter()
        .position(|p| p.name == "thigh_l")
        .unwrap();
    let (pos, _) = sim.piece_pose(sim.body.primary[thigh]);
    let cut = anatomize_cut::CutSegment {
        a: pos - Vec2::new(0.06, 0.0),
        b: pos + Vec2::new(0.06, 0.0),
        width: 0.005,
        speed: 2.0,
    };
    sim.slice(&cut);
    let after = outside_count(&sim);

    let cleared = after.saturating_sub(before);
    println!("切一刀：场里 Outside 从 {before} 涨到 {after}（+{cleared} texel）");
    assert!(
        cleared > 500,
        "切开之后应该有一片区域变成 Outside，实际只多了 {cleared}"
    );

    // 飞走那半的位置应该真的不在场里了
    let pieces = sim.body.pieces.len();
    assert!(pieces > 11, "应该多了一块");
}

fn outside_count(sim: &Sim) -> usize {
    sim.tissue
        .as_ref()
        .map(|t| {
            t.field
                .kind
                .iter()
                .filter(|k| **k == anatomize_tissue::TissueKind::Outside)
                .count()
        })
        .unwrap_or(0)
}

/// 爆炸：半径内的块被掀飞，自己消失。
#[test]
fn a_grenade_throws_nearby_pieces() {
    let mut sim = world();
    let near = sim.spawn_item_by_id("crate", Vec2::new(0.6, 0.6)).unwrap();
    let far = sim.spawn_item_by_id("crate", Vec2::new(-1.6, 0.6)).unwrap();
    let grenade = sim.spawn_item_by_id("grenade", Vec2::new(0.5, 0.5)).unwrap();
    for _ in 0..20 {
        sim.step();
    }
    let v_far = sim.piece_velocity(far);
    let n = sim.detonate(grenade, 1.6, 140.0);
    println!("炸了 {n} 块");
    assert!(sim.body.pieces[grenade.index()].deleted, "手雷应该没了");
    sim.step();
    let v_near = sim.piece_velocity(near);
    let v_far2 = sim.piece_velocity(far);
    println!("近处 {v_far:?} → {v_near:?}，远处 {v_far:?} → {v_far2:?}");
    assert!(v_near.length() > 1.0, "近处的块应该被掀飞");
    assert!(
        (v_far2 - v_far).length() < 1.0,
        "半径外的块不该受影响"
    );
}

/// 开火：射线打中身体就切一刀。
#[test]
fn firing_a_gun_cuts_what_it_hits() {
    let mut sim = world();
    let thigh = sim
        .plan
        .parts
        .iter()
        .position(|p| p.name == "thigh_l")
        .unwrap();
    let (target, _) = sim.piece_pose(sim.body.primary[thigh]);
    // 枪放在目标左边 1.5m，朝右
    let gun = sim
        .spawn_item_by_id("pistol", target - Vec2::new(1.5, 0.0))
        .unwrap();
    for _ in 0..20 {
        sim.step();
    }
    let pieces_before = sim.body.pieces.len();
    let hit = sim.fire(gun, 12.0);
    let pieces_after = sim.body.pieces.len();
    println!("开火命中 {hit:?}，块数 {pieces_before} → {pieces_after}");
    assert!(hit.is_some(), "应该打中点什么");
    assert!(
        pieces_after > pieces_before,
        "打中身体应该切出新块"
    );
}
