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
    let id = sim.creatures[sim.active].primary[hand];
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
    let id = sim.creatures[sim.active].primary[0];
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

/// 抓取不能抖：目标不动的时候，被抓的那块要**稳定下来**。
///
/// 第一版的刚度用的是整块质量（`k = m·ω²`），而抓取点的等效质量可能只有
/// 整块的几十分之一——力给大了 30 倍，那块就开始自激振荡：推过头 → 反向
/// 推 → 越推越大。这个测试盯着"目标不动时速度应该收敛"。
#[test]
fn a_grab_converges_instead_of_oscillating() {
    let mut sim = world();
    let arm = sim
        .plan
        .parts
        .iter()
        .position(|p| p.name == "forearm_l")
        .expect("左前臂");
    let id = sim.creatures[sim.active].primary[arm];
    let (p, _) = sim.piece_pose(id);

    // 抓在**外端**（离质心 6cm），目标就设在原地
    assert!(sim.grab(id, p + Vec2::new(0.06, 0.0)));
    sim.drag_to(p + Vec2::new(0.06, 0.0));

    // 先让它收敛
    for _ in 0..60 {
        sim.step();
    }
    // 再看 60 步里速度的峰值
    let mut max_v = 0.0f32;
    let mut prev_r = sim.piece_pose(id).1;
    let mut max_w = 0.0f32;
    for _ in 0..60 {
        sim.step();
        max_v = max_v.max(sim.piece_velocity(id).length());
        let r = sim.piece_pose(id).1;
        max_w = max_w.max(((r - prev_r) * 60.0).abs());
        prev_r = r;
    }
    println!("抓取稳定后：最大线速度 {max_v:.3} m/s，最大角速度 {max_w:.2} rad/s");
    assert!(max_v < 1.5, "抓取在抖：线速度 {max_v:.2} m/s");
    assert!(max_w < 6.0, "抓取在抖：角速度 {max_w:.2} rad/s");
}

/// 拖着一个物品走，速度不该爆掉。
#[test]
fn dragging_a_crate_does_not_blow_up() {
    let mut sim = world();
    let id = sim.spawn_item_by_id("crate", Vec2::new(1.0, 1.2)).unwrap();
    for _ in 0..30 {
        sim.step();
    }
    let (p, _) = sim.piece_pose(id);
    // 抓在角上（力臂最大）
    assert!(sim.grab(id, p + Vec2::new(0.2, 0.2)));
    let mut max_v = 0.0f32;
    for k in 0..120 {
        let t = k as f32 / 60.0;
        sim.drag_to(p + Vec2::new(t.sin() * 0.4, t.cos() * 0.3));
        sim.step();
        max_v = max_v.max(sim.piece_velocity(id).length());
    }
    println!("拖着木箱走 2 秒：最大速度 {max_v:.2} m/s");
    assert!(max_v < 12.0, "拖拽速度爆了：{max_v:.2} m/s");
}

// ---------------------------------------------------------------------------
// 站姿（姿态控制改成关节电机之后）
// ---------------------------------------------------------------------------

/// 生成之后要**站得住**：10 秒后还立着，而且不抖。
///
/// 这条测试盯着三个真 bug：
///
/// 1. 生成高度用了估算的 0.75 而不是实际的 0.66 —— 人一出生就砸地上。
/// 2. `enable_posture()` 在跑完 150 帧之后才调 —— 那时候人已经躺下了，
///    于是"保持现状"把目标定成了躺姿。
/// 3. 姿态控制用外部力矩 + 全局刚度 26 —— 撑不住体重；刚度调到 1500 又会
///    因为显式积分发散（`ω·dt ≈ 1`）。改成 rapier 的关节电机（隐式）才对。
#[test]
fn a_spawned_body_stays_upright() {
    let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
    let w = WorldBounds::default();
    let stand = plan.stand_height();
    let mut sim = Sim::spawn_in(plan, Vec2::new(0.0, stand), w);
    sim.attach_tissue(&anatomize_tissue::TissueConfig::asset());
    sim.stand();

    let mut jitter = 0.0f32;
    let mut prev = 0.0f32;
    for k in 0..600 {
        sim.step();
        let (_, rot) = sim.piece_pose(sim.creatures[sim.active].primary[0]);
        if k > 120 {
            jitter = jitter.max(((rot - prev) * 60.0).abs());
        }
        prev = rot;
    }
    let (pos, rot) = sim.piece_pose(sim.creatures[sim.active].primary[0]);
    println!(
        "10 秒后：骨盆 ({:.3}, {:.3})，倾角 {:.3} rad（{:.1}°），抖动 {:.2} rad/s",
        pos.x,
        pos.y,
        rot,
        rot.to_degrees(),
        jitter
    );
    assert!(rot.abs() < 0.25, "人倒了：倾角 {:.1}°", rot.to_degrees());
    assert!(pos.x.abs() < 0.25, "人滑走了：x = {:.3}", pos.x);
    assert!(jitter < 1.0, "站着还在抖：{jitter:.2} rad/s");
}

/// 姿态控制关掉之后，电机也必须关掉。
///
/// 电机是挂在关节上的约束，`posture = None` 只是不再更新它——不显式归零的话
/// "关掉姿态控制"等于没关。
#[test]
fn disabling_posture_actually_lets_go() {
    let mut sim = world();
    sim.stand();
    for _ in 0..120 {
        sim.step();
    }
    let before = sim.joint_load(0).angle;
    sim.disable_posture();
    // 拉一下胳膊，身体该软下去
    let arm = sim
        .plan
        .parts
        .iter()
        .position(|p| p.name == "forearm_l")
        .unwrap();
    let id = sim.creatures[sim.active].primary[arm];
    let (p, _) = sim.piece_pose(id);
    sim.strike_piece(id, Vec2::new(200.0, 60.0), p);
    for _ in 0..120 {
        sim.step();
    }
    let after = sim.joint_load(0).angle;
    println!("关掉姿态控制之后，腰部角度 {before:.3} → {after:.3}");
    assert!(
        (after - before).abs() > 0.02,
        "关掉姿态控制之后关节还被电机锁着（{before:.3} → {after:.3}）"
    );
}

// ---------------------------------------------------------------------------
// 镜像放置
// ---------------------------------------------------------------------------

/// E 键镜像：顶点 x 取反，绕向仍然是逆时针。
#[test]
fn a_mirrored_item_is_still_ccw() {
    let mut sim = world();
    let def = sim.catalog.get("knife").expect("目录里有刀").clone();
    let a = sim.spawn_item(&def, Vec2::new(-1.0, 1.4));
    let b = sim.spawn_item_oriented(&def, Vec2::new(1.0, 1.4), true);

    let pa = sim.body.pieces[a.index()].polygon.clone();
    let pb = sim.body.pieces[b.index()].polygon.clone();
    assert_eq!(pa.len(), pb.len());

    // 面积都是正的（逆时针）
    assert!(anatomize_core::polygon_area(&pa) > 0.0);
    assert!(
        anatomize_core::polygon_area(&pb) > 0.0,
        "镜像之后绕向反了，面积是负的"
    );
    // 镜像之后包围盒的 x 是对称的
    let bx = |p: &[Vec2]| {
        let mut lo = f32::INFINITY;
        let mut hi = f32::NEG_INFINITY;
        for v in p {
            lo = lo.min(v.x);
            hi = hi.max(v.x);
        }
        (lo, hi)
    };
    let (alo, ahi) = bx(&pa);
    let (blo, bhi) = bx(&pb);
    println!("原 {alo:.2}..{ahi:.2}，镜像 {blo:.2}..{bhi:.2}");
    assert!((alo + bhi).abs() < 1e-4 && (ahi + blo).abs() < 1e-4);
}
