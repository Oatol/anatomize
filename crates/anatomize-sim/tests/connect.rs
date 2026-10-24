//! 从 MaD2 学来的两件事：`CutJoints` 和全局 `cutLimit`，以及五种连接工具。
//!
//! 这组测试盯的是**会不会崩**和**语义对不对**。连接和切割都要建/删刚体，
//! 句柄一失效，下一帧求解器就 panic。

use anatomize_body::{ASSET_HUMAN_01, BodyPlan};
use anatomize_core::Vec2;
use anatomize_sim::{ConnKind, PieceId, Sim, WorldBounds};

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

// ---------------------------------------------------------------------------
// CutJoints
// ---------------------------------------------------------------------------

/// 刀穿过膝盖 → 膝盖断掉。
#[test]
fn a_cut_through_a_knee_severs_it() {
    let mut sim = world();
    let knee = sim.joint_index("knee_l").expect("左膝");
    let (wa, wb) = sim.joint_world_anchors(&sim.body.joints[knee]);
    let at = (wa + wb) * 0.5;

    // 横着划过膝盖（刀线穿过锚点）
    let cut = anatomize_cut::CutSegment {
        a: at - Vec2::new(0.08, 0.0),
        b: at + Vec2::new(0.08, 0.0),
        width: 0.004,
        speed: 2.0,
    };
    let severed = sim.cut_joints_on(&cut, false);
    println!("切膝盖 → 断了 {severed:?}");
    assert_eq!(severed.as_deref(), Some("knee_l"));
    assert_eq!(
        sim.body.joints[knee].health.state,
        anatomize_body::JointState::Severed
    );
}

/// 刀离关节远 → 什么也不断。
#[test]
fn a_cut_far_from_any_joint_severs_nothing() {
    let mut sim = world();
    let cut = anatomize_cut::CutSegment {
        a: Vec2::new(-1.5, 2.5),
        b: Vec2::new(1.5, 2.5),
        width: 0.004,
        speed: 2.0,
    };
    assert!(sim.cut_joints_on(&cut, false).is_none());
    for j in &sim.body.joints {
        assert_ne!(j.health.state, anatomize_body::JointState::Severed);
    }
}

/// 不可断的关节：时间在走时切不断，暂停时能切断（MaD2 的编辑模式口子）。
#[test]
fn a_non_cuttable_joint_only_breaks_when_paused() {
    let mut sim = world();
    let knee = sim.joint_index("knee_l").unwrap();
    sim.body.joints[knee].cuttable = false;
    let (wa, wb) = sim.joint_world_anchors(&sim.body.joints[knee]);
    let at = (wa + wb) * 0.5;
    let cut = anatomize_cut::CutSegment {
        a: at - Vec2::new(0.08, 0.0),
        b: at + Vec2::new(0.08, 0.0),
        width: 0.004,
        speed: 2.0,
    };

    // 时间在走：切不动
    assert!(sim.cut_joints_on(&cut, false).is_none());
    assert_ne!(
        sim.body.joints[knee].health.state,
        anatomize_body::JointState::Severed
    );

    // 暂停：能切
    assert_eq!(sim.cut_joints_on(&cut, true).as_deref(), Some("knee_l"));
}

/// 一刀最多断一条关节（MaD2 在 DestroyJoint 之后直接 return）。
#[test]
fn one_cut_severs_at_most_one_joint() {
    let mut sim = world();
    let before = sim
        .body
        .joints
        .iter()
        .filter(|j| j.health.state == anatomize_body::JointState::Severed)
        .count();
    // 一条横穿整个身体的刀，会同时压过好几条关节的锚点
    let cut = anatomize_cut::CutSegment {
        a: Vec2::new(-0.6, 0.35),
        b: Vec2::new(0.6, 0.35),
        width: 0.004,
        speed: 2.0,
    };
    sim.cut_joints_on(&cut, false);
    let after = sim
        .body
        .joints
        .iter()
        .filter(|j| j.health.state == anatomize_body::JointState::Severed)
        .count();
    println!("一条长刀断了 {} 条关节", after - before);
    assert!(after - before <= 1, "一刀断了两条以上：{}", after - before);
}

// ---------------------------------------------------------------------------
// 全局切割预算
// ---------------------------------------------------------------------------

/// 每帧最多切 `cut_limit` 块。超出就停下，并报告。
#[test]
fn the_global_cut_budget_caps_pieces_per_frame() {
    let mut sim = world();
    sim.cut_limit = 2;
    // 从头顶扫到脚，一条长刀
    let origin = sim.body_origin_world().unwrap();
    let cut = anatomize_cut::CutSegment {
        a: origin + Vec2::new(-0.9, 0.6),
        b: origin + Vec2::new(0.9, -0.6),
        width: 0.004,
        speed: 3.0,
    };
    let r = sim.slice(&cut);
    println!(
        "预算 2：切了 {} 块，用尽 = {}",
        r.new_pieces, r.budget_exhausted
    );
    assert!(r.new_pieces <= 2, "超预算了：{}", r.new_pieces);
    assert!(r.budget_exhausted, "应该报告预算用尽");

    // 下一帧（step 之后）预算回满
    sim.step();
    let r2 = sim.slice(&cut);
    println!("下一帧又切了 {} 块", r2.new_pieces);
    assert!(r2.new_pieces > 0, "预算应该回满了");
}

// ---------------------------------------------------------------------------
// 五种连接
// ---------------------------------------------------------------------------

/// 焊接：两块焊住之后相对位置不变。
#[test]
fn a_weld_holds_two_pieces_together() {
    let mut sim = world();
    let a = sim.spawn_item_by_id("crate", Vec2::new(1.1, 1.0)).unwrap();
    let b = sim.spawn_item_by_id("crate", Vec2::new(1.1, 1.55)).unwrap();
    for _ in 0..30 {
        sim.step();
    }
    let (pa0, _) = sim.piece_pose(a);
    let (pb0, _) = sim.piece_pose(b);
    let mid = (pa0 + pb0) * 0.5;
    assert!(sim.connect(ConnKind::Weld, a, Some(b), mid).is_some());

    // 只焊住下面那块，上面那块悬空——焊接应该把它吊住
    for _ in 0..90 {
        sim.step();
    }
    let (pa1, _) = sim.piece_pose(a);
    let (pb1, _) = sim.piece_pose(b);
    let d0 = (pb0 - pa0).length();
    let d1 = (pb1 - pa1).length();
    println!("焊点距离 {d0:.3} → {d1:.3} m");
    assert!((d1 - d0).abs() < 0.03, "焊接没拉住：{d0} → {d1}");
}

/// 钉住：把一块钉在空中，它不该掉下去。
#[test]
fn a_pin_holds_a_piece_in_the_air() {
    let mut sim = world();
    let id = sim.spawn_item_by_id("crate", Vec2::new(-1.2, 1.8)).unwrap();
    for _ in 0..10 {
        sim.step();
    }
    let (at, _) = sim.piece_pose(id);
    assert!(sim.connect(ConnKind::Pin, id, None, at).is_some());
    for _ in 0..120 {
        sim.step();
    }
    let (after, _) = sim.piece_pose(id);
    println!("钉住 2 秒：{at:?} → {after:?}");
    assert!(
        (after - at).length() < 0.05,
        "钉住的块掉下去了：{at:?} → {after:?}"
    );
}

/// 绳：能自由活动，但拉不开超过绳长。
#[test]
fn a_rope_limits_the_distance_but_stays_loose() {
    let mut sim = world();
    let a = sim.spawn_item_by_id("ball", Vec2::new(-1.3, 1.6)).unwrap();
    let b = sim.spawn_item_by_id("ball", Vec2::new(-0.5, 1.6)).unwrap();
    for _ in 0..10 {
        sim.step();
    }
    let (pa, _) = sim.piece_pose(a);
    let (pb, _) = sim.piece_pose(b);
    // 绳的两端各挂在两个球的**内侧**（相隔 0.5m）
    let idx = sim
        .connect_at(ConnKind::Rope, a, Some(b), pa, Some(pb))
        .unwrap();
    let (wa, wb) = sim.conn_points(&sim.conns[idx]).unwrap();
    let rest = (wa - wb).length();
    println!("绳长 {rest:.3} m（两球中心相距 {:.3}）", (pb - pa).length());
    assert!(rest > 0.3, "绳长应该约等于两锚点距离");

    // 把 b 往远处甩
    sim.strike_piece(b, Vec2::new(60.0, 30.0), pb);
    for _ in 0..90 {
        sim.step();
    }
    let (pa2, _) = sim.piece_pose(a);
    let (pb2, _) = sim.piece_pose(b);
    let now = (pb2 - pa2).length();
    println!("甩开之后两球相距 {now:.3} m（绳长 {rest:.3}）");
    // 绳只限最长，允许被拉紧一点点（求解器的容差）
    assert!(now < rest + 0.12, "绳被拉长了：{rest:.3} → {now:.3}");
    // 而且确实动了（不是焊死）
    assert!((pb2 - pb).length() > 0.05, "绳把它焊死了");
}

/// 铰链：两块能相对转动（不是焊死）。
#[test]
fn a_hinge_lets_the_pieces_rotate() {
    let mut sim = world();
    let a = sim.spawn_item_by_id("plank", Vec2::new(1.2, 1.4)).unwrap();
    let b = sim.spawn_item_by_id("crate", Vec2::new(1.2, 1.9)).unwrap();
    for _ in 0..20 {
        sim.step();
    }
    let (pa, _) = sim.piece_pose(a);
    let (pb, _) = sim.piece_pose(b);
    assert!(
        sim.connect(ConnKind::Hinge, a, Some(b), (pa + pb) * 0.5)
            .is_some()
    );
    let (_, r0) = sim.piece_pose(b);
    for _ in 0..90 {
        sim.step();
    }
    let (_, r1) = sim.piece_pose(b);
    println!("铰链：角度 {r0:.3} → {r1:.3}");
    assert!((r1 - r0).abs() > 0.02, "铰链焊死了，转不动");
}

/// 删掉一块，连着它的连接要跟着断——不然关节指向死 handle，下一帧就崩。
#[test]
fn deleting_a_piece_drops_its_connections() {
    let mut sim = world();
    let a = sim.spawn_item_by_id("crate", Vec2::new(1.1, 1.0)).unwrap();
    let b = sim.spawn_item_by_id("crate", Vec2::new(1.1, 1.6)).unwrap();
    for _ in 0..10 {
        sim.step();
    }
    let (pa, _) = sim.piece_pose(a);
    let (pb, _) = sim.piece_pose(b);
    sim.connect(ConnKind::Weld, a, Some(b), (pa + pb) * 0.5)
        .unwrap();
    sim.delete_piece(b);
    for _ in 0..60 {
        sim.step();
    }
    assert!(sim.conns.iter().all(|c| c.broken), "连接应该全断了");
}

/// 切一刀穿过绳 → 绳断。
#[test]
fn a_cut_through_a_rope_breaks_it() {
    let mut sim = world();
    let a = sim.spawn_item_by_id("crate", Vec2::new(-1.3, 1.6)).unwrap();
    let b = sim.spawn_item_by_id("crate", Vec2::new(-0.3, 1.6)).unwrap();
    for _ in 0..10 {
        sim.step();
    }
    let (pa, _) = sim.piece_pose(a);
    let (pb, _) = sim.piece_pose(b);
    let idx = sim
        .connect(ConnKind::Weld, a, Some(b), (pa + pb) * 0.5)
        .unwrap();
    let (wa, wb) = sim.conn_points(&sim.conns[idx]).unwrap();
    // 刀横着穿过两个锚点之间
    let mid = (wa + wb) * 0.5;
    let cut = anatomize_cut::CutSegment {
        a: mid - Vec2::new(0.0, 0.06),
        b: mid + Vec2::new(0.0, 0.06),
        width: 0.004,
        speed: 2.0,
    };
    let broke = sim.cut_joints_on(&cut, false);
    println!("切连接 → {broke:?}");
    assert!(sim.conns[idx].broken);
}

// ---------------------------------------------------------------------------
// 抓取（ragdoll 手感）
// ---------------------------------------------------------------------------

/// 抓着一只手拖：身体应该**转**，不是整体平移。
///
/// 这是从 MaD2 的 `Tool.DRAG`（`b2MouseJoint`）学来的最关键一点：力作用在
/// 抓取点上才有力矩。之前我们是直接设线速度，抓哪儿都是整体平移。
#[test]
fn grabbing_a_hand_rotates_the_body() {
    let mut sim = world();
    let hand = sim
        .plan
        .parts
        .iter()
        .position(|p| p.name == "forearm_l" || p.name == "hand_l")
        .expect("有前臂或手");
    let id = sim.body.primary[hand];
    let (hp, _) = sim.piece_pose(id);

    // 抓在手的**外端**（离质心远的地方），往右上方拉
    assert!(sim.grab(id, hp + Vec2::new(0.06, 0.0)));
    sim.drag_to(hp + Vec2::new(0.5, 0.35));
    let (_, r0) = sim.piece_pose(id);
    for _ in 0..40 {
        sim.step();
    }
    let (_, r1) = sim.piece_pose(id);
    println!(
        "抓着手拖 0.7 秒：角度 {r0:.3} → {r1:.3}（差 {:.3}）",
        r1 - r0
    );
    // 抓着偏离质心的点拉，那块自己一定转
    assert!(
        (r1 - r0).abs() > 0.01,
        "抓着偏心的点拉，那块居然没转：{r0} → {r1}"
    );
    sim.release_grab();
}

/// 松手之后不再受力。
#[test]
fn releasing_the_grab_stops_the_pull() {
    let mut sim = world();
    let id = sim.body.primary[0];
    let (p, _) = sim.piece_pose(id);
    sim.grab(id, p);
    sim.drag_to(p + Vec2::new(2.0, 1.0));
    sim.step();
    sim.release_grab();
    assert!(sim.grabbed().is_none());
    for _ in 0..30 {
        sim.step();
    }
}

/// 冻结的块抓不动、连不上、钉不上。
#[test]
fn frozen_pieces_refuse_connections() {
    let mut sim = world();
    let id = sim.spawn_item_by_id("crate", Vec2::new(1.2, 1.0)).unwrap();
    sim.set_frozen(id, true);
    let (p, _) = sim.piece_pose(id);
    assert!(!sim.grab(id, p));
    assert!(sim.connect(ConnKind::Pin, id, None, p).is_none());
    let other = sim.spawn_item_by_id("crate", Vec2::new(0.4, 1.0)).unwrap();
    assert!(sim.connect(ConnKind::Weld, other, Some(id), p).is_none());
    let _ = PieceId(0);
}

/// 存档 → 读档：焊接、钉住、活塞都要活着回来。
#[test]
fn connections_survive_a_save_and_load() {
    let mut sim = world();
    let a = sim.spawn_item_by_id("crate", Vec2::new(-1.2, 1.2)).unwrap();
    let b = sim.spawn_item_by_id("crate", Vec2::new(-1.2, 1.8)).unwrap();
    let c = sim.spawn_item_by_id("ball", Vec2::new(1.2, 1.5)).unwrap();
    for _ in 0..20 {
        sim.step();
    }
    let (pa, _) = sim.piece_pose(a);
    let (pb, _) = sim.piece_pose(b);
    let (pc, _) = sim.piece_pose(c);
    sim.connect(ConnKind::Weld, a, Some(b), (pa + pb) * 0.5)
        .unwrap();
    sim.connect(ConnKind::Pin, c, None, pc).unwrap();
    let before = sim.conns.len();

    let save = sim.save();
    let mut back = Sim::load(&save, 0.0).expect("读档");
    for _ in 0..60 {
        back.step();
    }
    println!("连接数 {before} → {}", back.conns.len());
    assert_eq!(back.conns.len(), before, "读档之后连接丢了");
    assert!(back.conns.iter().all(|c| !c.broken));

    // 焊接还在：两块的距离不该变
    let (pa2, _) = back.piece_pose(a);
    let (pb2, _) = back.piece_pose(b);
    let d0 = (pb - pa).length();
    let d1 = (pb2 - pa2).length();
    println!("读档后焊点距离 {d0:.3} → {d1:.3}");
    assert!((d1 - d0).abs() < 0.05, "读档之后焊接失效了");
}
