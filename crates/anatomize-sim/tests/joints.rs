//! M3 验收：关节三级状态机真的接到了物理约束上。
//!
//! 三件事必须成立：
//!
//! 1. 站着不动不会自己受伤（`impulse_threshold` 标定得对不对，全看这条）
//! 2. 受伤了状态会一路走下去，而且每一步都改了物理约束
//! 3. **脱位后肢体挂着而不是飞走**——这是 M3 唯一真正的验收标准，
//!    也是 v0.1 "直接 remove_joint" 最缺的中间态
//!
//! 这些测试跑在真实的 rapier 世界上，不是纯逻辑，所以慢一点（每个几百 tick）。

use anatomize_body::{ASSET_HUMAN_01, BodyPlan, JointState};
use anatomize_core::Vec2;
use anatomize_sim::{CM, Sim};

const GROUND_Y: f32 = -0.66;
const ORIGIN: Vec2 = Vec2::new(0.0, 0.35);

fn spawn() -> Sim {
    let plan = BodyPlan::from_ron(ASSET_HUMAN_01).expect("human_01 应该能编译");
    Sim::spawn(plan, ORIGIN, GROUND_Y)
}

fn part_center(sim: &Sim, name: &str) -> Vec2 {
    let id = sim.plan.part(name).expect("部件应该存在").id;
    let poly = sim.part_polygon(id);
    let n = poly.len() as f32;
    poly.iter().fold(Vec2::ZERO, |a, p| a + *p) / n
}

#[test]
fn standing_body_never_hurts_itself() {
    let mut sim = spawn();
    // 10 秒自由落体 + 落地 + 静止。落地那一下算轻微外伤，不在这里考察。
    for _ in 0..600 {
        sim.step();
    }
    let d = sim.diagnostics();
    println!(
        "落地后：gap(max)={:.3} mm  KE={:.4} J  vmax={:.3} m/s",
        d.max_joint_gap * 1000.0,
        d.kinetic_energy,
        d.max_speed
    );

    let settled: Vec<f32> = sim.body.joints.iter().map(|j| j.health.integrity).collect();
    let states_before: Vec<JointState> = sim.body.joints.iter().map(|j| j.state()).collect();
    assert!(
        states_before.iter().all(|s| *s == JointState::Intact),
        "落地摔一下不该摔出结构性损伤：{:?}",
        sim.injuries
    );

    // 再站 10 秒：完全静止的 ragdoll 不该继续变坏
    for _ in 0..600 {
        sim.step();
    }

    let mut worst = 0.0f32;
    for (i, j) in sim.body.joints.iter().enumerate() {
        let name = sim.joint_name(j.id);
        let load = sim.joint_load(i);
        println!(
            "  {:<11} {:>9}  integrity={:.4}  载荷冲量={:>7.2}  角={:>6.2}  限位=({:.2}, {:.2})",
            name,
            j.state().name(),
            j.health.integrity,
            load.impulse,
            load.angle,
            load.limits.0,
            load.limits.1
        );
        worst = worst.max((j.health.integrity - settled[i]).abs());
        assert_eq!(j.state(), JointState::Intact, "{name} 不该受伤");
    }

    println!("静止 10 秒，integrity 最大变化 {worst:.4}");
    assert!(
        worst < 0.005,
        "静止不动不该继续磨损，最大变化 {worst:.4}"
    );
}

#[test]
fn worn_joint_walks_intact_sprained_subluxed_dislocated_severed() {
    let mut sim = spawn();
    for _ in 0..120 {
        sim.step(); // 先站稳
    }

    let idx = sim.joint_index("hip_l").unwrap();
    let mut seen = vec![sim.body.joints[idx].state()];
    let note = |sim: &Sim, seen: &mut Vec<JointState>| {
        let s = sim.body.joints[idx].state();
        if seen.last() != Some(&s) {
            seen.push(s);
            println!(
                "  t={:>5.2}s  -> {:<10}  integrity={:.3}  tether={:.2}",
                sim.tick.0 as f32 * (1.0 / 60.0),
                s.name(),
                sim.body.joints[idx].health.integrity,
                sim.body.joints[idx].health.tether
            );
        }
    };

    // 阶段 1：反复猛拉，把结构一点点拉坏
    for _ in 0..12 {
        sim.wear_joint("hip_l", 0.08);
        for _ in 0..20 {
            sim.step();
            note(&sim, &mut seen);
        }
    }

    // 阶段 2：脱位之后肢体被绳子挂着，软组织自己会慢慢被拉断
    let t0 = sim.tick.0;
    while sim.body.joints[idx].state() != JointState::Severed && sim.tick.0 - t0 < 2400 {
        sim.step();
        note(&sim, &mut seen);
    }

    println!(
        "状态序列 {:?}",
        seen.iter().map(|s| s.name()).collect::<Vec<_>>()
    );
    assert!(seen.contains(&JointState::Sprained), "应先扭伤");
    assert!(seen.contains(&JointState::Subluxed), "应再半脱位");
    assert!(seen.contains(&JointState::Dislocated), "应再脱位");
    assert_eq!(
        sim.body.joints[idx].state(),
        JointState::Severed,
        "一直拉到底应离断"
    );

    // 迁移顺序必须单调：不允许从重往轻跳
    for w in seen.windows(2) {
        assert!(w[0] <= w[1], "状态只能单向恶化：{:?}", seen);
    }
}

#[test]
fn dislocated_limb_hangs_instead_of_flying_away() {
    let mut sim = spawn();
    for _ in 0..120 {
        sim.step();
    }

    // 直接把左髋打到脱位
    sim.wear_joint("hip_l", 0.90);
    for _ in 0..20 {
        sim.step();
    }
    let idx = sim.joint_index("hip_l").unwrap();
    assert_eq!(
        sim.body.joints[idx].state(),
        JointState::Dislocated,
        "扣 0.90 完整性应该直接脱位"
    );
    assert!(
        sim.body.joints[idx].tether.is_some(),
        "脱位后必须挂上软约束（绳子），不是移除约束"
    );

    // 给左小腿一记狠的，看它会不会飞出去
    sim.set_part_velocity("shin_l", Vec2::new(-12.0, 6.0));

    let mut max_gap = 0.0f32;
    for _ in 0..180 {
        sim.step();
        let (pa, pb) = sim.joint_world_anchors(&sim.body.joints[idx]);
        max_gap = max_gap.max((pa - pb).length());
    }

    let allowed = sim.body.joints[idx].tether_rest + sim.damage.tether_len_cm * CM;
    println!(
        "甩了 3 秒：两锚点最大间距 {:.1} cm（绳长 {:.1} cm）",
        max_gap * 100.0,
        allowed * 100.0
    );
    println!(
        "  左小腿中心 {:?}  左大腿中心 {:?}",
        part_center(&sim, "shin_l"),
        part_center(&sim, "thigh_l")
    );

    // 绳长 + 一点数值余量（绳子是硬的，但求解器有容差）
    assert!(
        max_gap < allowed * 1.6 + 0.02,
        "脱位后肢体必须被拉住：间距 {:.1}cm 超过绳长 {:.1}cm 太多",
        max_gap * 100.0,
        allowed * 100.0
    );
    // 还该在身体附近，而不是飞出画面
    let shin_c = part_center(&sim, "shin_l");
    assert!(
        (shin_c - ORIGIN).length() < 1.2,
        "小腿跑到 {shin_c:?}，已经飞了"
    );
    assert_eq!(
        sim.body.joints[idx].state(),
        JointState::Dislocated,
        "只甩一下不该直接离断"
    );
}

#[test]
fn severed_joint_releases_the_limb() {
    let mut sim = spawn();
    for _ in 0..120 {
        sim.step();
    }

    let idx = sim.joint_index("knee_l").unwrap();
    // 先把软组织磨没，再让它离断
    sim.body.joints[idx].health.integrity = 0.05;
    sim.body.joints[idx].health.state = JointState::Dislocated;
    sim.body.joints[idx].health.tether = 0.0;
    sim.step();
    assert_eq!(
        sim.body.joints[idx].state(),
        JointState::Severed,
        "tether 归零应直接离断"
    );
    assert!(
        sim.body.joints[idx].tether.is_none(),
        "离断后软约束也该被移除"
    );

    // 离断后小腿可以自由落体到地面
    sim.set_part_velocity("shin_l", Vec2::new(-3.0, 2.0));
    for _ in 0..240 {
        sim.step();
    }
    let gap = {
        let (pa, pb) = sim.joint_world_anchors(&sim.body.joints[idx]);
        (pa - pb).length()
    };
    println!("离断 4 秒后膝关节两锚点间距 {:.1} cm", gap * 100.0);
    assert!(gap > 0.05, "离断后两段应该分开，实际 {:.1} cm", gap * 100.0);
}

#[test]
fn impulse_threshold_is_far_above_standing_load() {
    // damage.ron 里 impulse_threshold 的标定依据：静载的实测值。
    let mut sim = spawn();
    let mut peak_drop = 0.0f32;
    for _ in 0..300 {
        sim.step();
        for i in 0..sim.body.joints.len() {
            peak_drop = peak_drop.max(sim.joint_load(i).impulse);
        }
    }
    let mut peak_rest = 0.0f32;
    for _ in 0..120 {
        sim.step();
        for i in 0..sim.body.joints.len() {
            peak_rest = peak_rest.max(sim.joint_load(i).impulse);
        }
    }
    let thr = sim.damage.impulse_threshold;
    println!("下落/落地峰值冲量 {peak_drop:.2} N·m·s，静止峰值 {peak_rest:.2}，阈值 {thr:.1}");
    assert!(
        thr > peak_drop * 3.0,
        "阈值 {thr} 离落地峰值 {peak_drop} 太近，摔一下就会受伤"
    );
    assert!(
        thr > peak_rest * 10.0,
        "阈值 {thr} 离静载 {peak_rest} 太近，站着就会受伤"
    );
}
