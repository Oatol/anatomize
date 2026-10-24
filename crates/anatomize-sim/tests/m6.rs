//! M6 验收：碎片、冻结、护栏，以及验收标准 6–9。

use anatomize_body::{ASSET_HUMAN_01, BodyPlan};
use anatomize_core::{PartId, Vec2};
use anatomize_cut::{CutSegment, SectionProfile, measure_bands, signed_depth};
use anatomize_sim::{FractureConfig, Sim};
use anatomize_tissue::TissueConfig;

fn world() -> Sim {
    let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
    let mut sim = Sim::spawn(plan, Vec2::new(0.0, 40.0), -80.0);
    sim.attach_tissue(&TissueConfig::asset());
    // 吊着，别让重力把姿态搞乱
    sim.set_part_fixed("head", true);
    for _ in 0..180 {
        sim.step();
    }
    sim
}

fn part(sim: &Sim, name: &str) -> PartId {
    sim.plan.parts.iter().find(|p| p.name == name).unwrap().id
}

/// 横切某个部件，`dy` 是相对它**当前**中心的偏移（米）。
///
/// 不能用 `BodyPlan` 里的静态 offset：身体吊在头上会下垂十几厘米，
/// 按装配坐标切会切到隔壁的小腿上去。
fn cut_at(sim: &Sim, name: &str, dy: f32) -> CutSegment {
    let i = sim.plan.parts.iter().position(|p| p.name == name).unwrap();
    let (pos, _) = sim.piece_pose(sim.creatures[sim.active].primary[i]);
    CutSegment {
        a: Vec2::new(pos.x - 0.06, pos.y + dy),
        b: Vec2::new(pos.x + 0.06, pos.y + dy),
        width: 0.005,
        speed: 2.0,
    }
}

/// 横切左大腿中部。
fn thigh_cut(sim: &Sim) -> CutSegment {
    cut_at(sim, "thigh_l", 0.0)
}

#[test]
fn a_cut_through_the_thigh_makes_two_pieces() {
    let mut sim = world();
    let thigh = part(&sim, "thigh_l");
    let before = sim.body.pieces.len();
    let mass_before: f32 = sim
        .body
        .pieces
        .iter()
        .filter(|p| p.part == thigh)
        .map(|p| p.mass)
        .sum();

    let r = sim.slice(&thigh_cut(&sim));
    println!(
        "切中 {:?}，新增 {} 块，重挂 {} 条关节",
        r.cut_parts, r.new_pieces, r.rewired_joints
    );
    assert_eq!(r.new_pieces, 1, "只该切中左大腿一块");
    assert_eq!(sim.body.pieces.len(), before + 1);

    let mass_after: f32 = sim
        .body
        .pieces
        .iter()
        .filter(|p| p.part == thigh)
        .map(|p| p.mass)
        .sum();
    println!("左大腿质量 {mass_before:.2} → {mass_after:.2} kg");
    assert!(
        (mass_after - mass_before).abs() < 1e-3,
        "切开不该改变总质量"
    );
}

/// 切大腿中部：髋关节在上半块、膝关节在下半块。
///
/// 这是"切开"和"断开"的分界线——如果两个关节都留在同一块，另一块会直接掉下去。
#[test]
fn the_hip_follows_the_upper_half_and_the_knee_the_lower_half() {
    let mut sim = world();
    let thigh = part(&sim, "thigh_l");
    let hip = sim.joint_index("hip_l").unwrap();
    let knee = sim.joint_index("knee_l").unwrap();

    let r = sim.slice(&thigh_cut(&sim));
    assert_eq!(r.new_pieces, 1);

    // 大腿这一部件的两块
    let halves: Vec<_> = sim
        .body
        .pieces
        .iter()
        .enumerate()
        .filter(|(_, p)| p.part == thigh)
        .map(|(i, p)| (anatomize_sim::PieceId(i as u32), p.centroid))
        .collect();
    assert_eq!(halves.len(), 2);

    // 髋关节是 pelvis→thigh，膝关节是 thigh→shin，所以各取靠大腿的那一端
    let (hip_upper, knee_lower) = (sim.body.joints[hip].b, sim.body.joints[knee].a);
    assert_eq!(sim.body.pieces[hip_upper.index()].part, thigh);
    assert_eq!(sim.body.pieces[knee_lower.index()].part, thigh);
    println!(
        "髋挂块 {:?}（质心 {:?}），膝挂块 {:?}（质心 {:?}）",
        hip_upper,
        halves.iter().find(|h| h.0 == hip_upper).map(|h| h.1),
        knee_lower,
        halves.iter().find(|h| h.0 == knee_lower).map(|h| h.1)
    );
    assert_ne!(
        hip_upper, knee_lower,
        "髋和膝必须挂在不同的一半上，否则这条腿没被真正切开"
    );

    // 上半块质心在切口之上，下半块在切口之下（y 向下为负）
    let cy_hip = halves.iter().find(|h| h.0 == hip_upper).unwrap().1.y;
    let cy_knee = halves.iter().find(|h| h.0 == knee_lower).unwrap().1.y;
    assert!(cy_hip > cy_knee, "髋侧应该在膝侧上方");

    // 两半都还在物理世界里，跑一会儿不该爆
    for _ in 0..120 {
        sim.step();
    }
    assert!(sim.diagnostics().max_joint_gap < 0.5);
}

/// 旋转中切开，两半的质心速度必须不同（v = v_cm + ω × r）。
#[test]
fn pieces_inherit_velocity_through_their_centroid() {
    let mut sim = world();
    let thigh = part(&sim, "thigh_l");
    // 让整条腿转起来
    sim.set_part_velocity("thigh_l", Vec2::new(0.0, 1.5));
    sim.step();

    let r = sim.slice(&thigh_cut(&sim));
    assert_eq!(r.new_pieces, 1);

    let halves: Vec<_> = (0..sim.body.pieces.len())
        .map(|i| anatomize_sim::PieceId(i as u32))
        .filter(|id| sim.body.pieces[id.index()].part == thigh)
        .collect();

    let v0 = sim.piece_velocity(halves[0]);
    let v1 = sim.piece_velocity(halves[1]);
    println!("上半速度 {v0:?}，下半速度 {v1:?}");

    // 两半的竖直速度都不为零（继承了父块），且方向/大小有差异
    assert!(v0.length() > 0.1 && v1.length() > 0.1, "速度没传下来");
    assert!(
        (v0 - v1).length() > 1e-3,
        "两半速度应该不同（质心不同），实际 {v0:?} / {v1:?}"
    );
}

/// 冻结：静止够久就摘出物理世界，但位姿还在。
#[test]
fn frozen_pieces_leave_the_physics_world() {
    let mut sim = world();
    sim.fracture = FractureConfig {
        freeze_after_s: 0.5,
        ..FractureConfig::default()
    };
    sim.slice(&thigh_cut(&sim));
    // 冻结的前提是"这块已经不属于身体了"。还连着关节的块永远不冻结——
    // 摘掉刚体会连带删掉关节，之后读关节就是读一个死 handle。
    sim.sever_joint("knee_l");
    let live_before = sim.live_pieces();

    let mut frozen_total = 0;
    for _ in 0..600 {
        sim.step();
        frozen_total += sim.update_freeze();
    }
    println!(
        "冻结 {frozen_total} 块，活跃块 {live_before} → {}",
        sim.live_pieces()
    );
    assert!(frozen_total > 0, "小腿掉到地上静止 10 秒后应该冻结");
    assert_eq!(sim.live_pieces(), live_before - frozen_total);

    // 冻结的块仍然能报出位姿
    let id = sim
        .body
        .pieces
        .iter()
        .position(|p| p.is_frozen())
        .map(|i| anatomize_sim::PieceId(i as u32))
        .expect("至少有一块被冻结");
    let (pos, _rot) = sim.piece_pose(id);
    assert!(pos.x.is_finite() && pos.y.is_finite());
    assert!(!sim.piece_polygon(id).is_empty(), "冻结后还要能画");
}

/// 验收标准 8：连续断裂 100 次，无 NaN、无速度 > 100 m/s、无刚体飞出包围盒。
#[test]
fn a_hundred_cuts_never_produce_nan_or_escape() {
    let mut sim = world();
    let mut worst_speed = 0.0f32;
    let mut worst_pos = 0.0f32;
    let mut total_new = 0usize;

    // 一条从左上到右下的斜线，每次下移 1.4cm —— 100 刀刚好扫过整具身体
    for i in 0..100 {
        // 从头顶上方 30cm 开始，每刀下移 1.4cm，扫过整具身体。
        // 起点要用**身体现在的位置**，不能用世界原点——身体挂在 (0, 40)。
        let top = sim.body_origin_world().unwrap().y + 0.75;
        let y = top - i as f32 * 0.014;
        let cut = CutSegment {
            a: Vec2::new(-0.30, y + 0.06),
            b: Vec2::new(0.30, y - 0.06),
            width: 0.004,
            speed: 3.0,
        };
        let r = sim.slice(&cut);
        total_new += r.new_pieces;

        sim.step();
        sim.clamp_velocities();
        for i in 0..sim.body.pieces.len() {
            let id = anatomize_sim::PieceId(i as u32);
            if sim.body.pieces[i].is_frozen() {
                continue;
            }
            let v = sim.piece_velocity(id);
            assert!(v.x.is_finite() && v.y.is_finite(), "第 {i} 块出现 NaN 速度");
            worst_speed = worst_speed.max(v.length());
            let (pos, _) = sim.piece_pose(id);
            // 身体挂在 (0, 40)，所以看"离身体原点多远"而不是离世界原点
            worst_pos = worst_pos.max((pos - Vec2::new(0.0, 40.0)).length());
        }
    }

    println!(
        "100 刀：新增 {total_new} 块，共 {} 块（活跃 {}），最大速度 {worst_speed:.1} m/s，最远 {worst_pos:.1} m",
        sim.body.pieces.len(),
        sim.live_pieces()
    );
    assert!(
        worst_speed <= sim.fracture.max_speed + 1e-3,
        "速度超限 {worst_speed}"
    );
    assert!(
        worst_speed < 100.0,
        "速度必须 < 100 m/s，实际 {worst_speed}"
    );
    assert!(worst_pos < 30.0, "刚体飞出包围盒：{worst_pos} m");
    assert!(
        sim.live_pieces() <= sim.fracture.max_live_pieces,
        "活跃块 {} 超预算",
        sim.live_pieces()
    );
}

/// 验收标准 6：切割大腿，断面出现皮肤 / 脂肪 / 肌肉 / 骨四层色带。
///
/// 这一条测的是**几何**，不依赖渲染：切完之后，沿刀线从一侧走到另一侧，
/// 每一站问"你在原大腿里有多深"，深度映射出的层序列必须是
/// 皮肤 → 脂肪 → 肌肉 → 骨 → 肌肉 → 脂肪 → 皮肤。
#[test]
fn a_thigh_section_shows_four_layers() {
    let sim = world();
    let thigh = &sim.plan.parts[part(&sim, "thigh_l").index()];
    let prof = SectionProfile::for_part(thigh.bone, &thigh.polygon);

    // 刀线在身体局部 y = -27，换算成大腿局部
    let local_y = -27.0 - thigh.offset.y;
    let a = Vec2::new(-5.5, local_y);
    let b = Vec2::new(5.5, local_y);

    let bands = measure_bands(&thigh.polygon, &prof, a, b, 1024);
    println!(
        "大腿剖面（{:.1} cm 厚）：{}",
        prof.thickness_cm() * 2.0,
        bands
            .iter()
            .map(|b| format!("{:?} {:.2}cm/{:.0}%", b.layer, b.cm, b.share * 100.0))
            .collect::<Vec<_>>()
            .join("  ")
    );

    let names: Vec<_> = bands.iter().map(|b| b.layer).collect();
    assert_eq!(names.len(), 4, "必须四层都在，实际 {names:?}");
    assert_eq!(names[0], anatomize_body::Layer::Skin);
    assert_eq!(names[1], anatomize_body::Layer::Fat);
    assert_eq!(names[2], anatomize_body::Layer::Muscle);
    assert_eq!(names[3], anatomize_body::Layer::Bone);

    // 层厚比例：皮肤薄（<10%）、肌肉最多（>40%）、骨占 15~45%
    let share = |l: anatomize_body::Layer| bands.iter().find(|b| b.layer == l).unwrap().share;
    assert!(share(anatomize_body::Layer::Skin) < 0.10);
    assert!(share(anatomize_body::Layer::Muscle) > 0.40);
    let bone = share(anatomize_body::Layer::Bone);
    assert!(bone > 0.15 && bone < 0.45, "骨比例 {bone}");

    // 对称性：中点是骨，两端是皮肤
    assert!(signed_depth(&thigh.polygon, Vec2::new(0.0, local_y)) > prof.max_depth_cm - 0.01);
}

/// 切刚体不该影响组织场——两件事是解耦的（ADR-003：场固定在身体坐标系）。
#[test]
fn slicing_geometry_does_not_disturb_the_blood_flow() {
    let mut sim = world();
    // 先用 M4 的路径切一刀（只写组织场）
    let out = sim.cut(&thigh_cut(&sim)).expect("有组织场");
    let bleed_after_field = sim.hemorrhage_ml_s();
    println!(
        "组织场切完：出血 {bleed_after_field:.2} mL/s，断供 {:?}",
        out.starved
    );

    // 再做几何切割
    let r = sim.slice(&thigh_cut(&sim));
    assert!(r.new_pieces > 0);
    let bleed_after_geom = sim.hemorrhage_ml_s();
    println!("几何切完：出血 {bleed_after_geom:.2} mL/s");
    assert!(
        (bleed_after_geom - bleed_after_field).abs() < 1e-4,
        "几何切割不该改变出血速率"
    );
}

/// 验收标准 10：存档 → 读档，所有生理量误差 < 1e-3。
///
/// 只比数值是不够的——漏存一个字段时，读档瞬间的数值可能碰巧对得上，
/// 但**轨迹**会立刻分叉。所以这里比三件事：
///
/// 1. 读档瞬间的每个生理字段（误差 < 1e-3）
/// 2. 块数与关节数、每块的质量与位姿
/// 3. 各跑 10 秒之后的生理字段（轨迹不分叉）
#[test]
fn save_and_load_loses_nothing() {
    let mut sim = world();
    // 制造一个有历史的世界：切一刀、断一条关节、喂一顿饭
    sim.cut(&thigh_cut(&sim));
    sim.slice(&thigh_cut(&sim));
    sim.sever_joint("knee_l");
    sim.feed(500.0);
    for _ in 0..300 {
        sim.step();
    }

    let save = sim.save();
    let ron = save.to_ron();
    println!(
        "存档 {:.1} KB，{} 块，{} 条关节",
        ron.len() as f32 / 1024.0,
        save.pieces.len(),
        save.joints.len()
    );

    let back = anatomize_sim::SaveFile::from_ron(&ron).expect("读档失败");
    let mut sim2 = Sim::load(&back, -80.0).expect("重建失败");

    // --- 1. 瞬时生理量 ---
    let a = sim.creatures[sim.active].physio.bus;
    let b = sim2.creatures[sim2.active].physio.bus;
    let fields: [(&str, f32, f32); 12] = [
        ("血容量", a.blood_volume, b.blood_volume),
        ("MAP", a.map, b.map),
        ("心率", a.heart_rate, b.heart_rate),
        ("心输出量", a.cardiac_output, b.cardiac_output),
        ("PaO2", a.pao2, b.pao2),
        ("SaO2", a.sao2, b.sao2),
        ("组织氧", a.tissue_o2, b.tissue_o2),
        ("核心温度", a.temp_core, b.temp_core),
        ("血糖", a.glucose, b.glucose),
        ("意识", a.consciousness, b.consciousness),
        ("交感张力", a.sympathetic_tone, b.sympathetic_tone),
        ("失血量", a.blood_lost_ml, b.blood_lost_ml),
    ];
    for (name, x, y) in fields {
        let err = (x - y).abs();
        assert!(err < 1e-3, "{name} 误差 {err}（{x} vs {y}）");
    }

    // --- 2. 几何 ---
    assert_eq!(sim.body.pieces.len(), sim2.body.pieces.len(), "块数不一致");
    assert_eq!(
        sim.body.joints.len(),
        sim2.body.joints.len(),
        "关节数不一致"
    );
    for (i, p) in sim.body.pieces.iter().enumerate() {
        let q = &sim2.body.pieces[i];
        assert_eq!(p.part, q.part);
        assert!((p.mass - q.mass).abs() < 1e-4);
        let (pa, _) = sim.piece_pose(anatomize_sim::PieceId(i as u32));
        let (pb, _) = sim2.piece_pose(anatomize_sim::PieceId(i as u32));
        assert!(
            (pa - pb).length() < 1e-3,
            "第 {i} 块位置差 {} m",
            (pa - pb).length()
        );
    }
    for (i, j) in sim.body.joints.iter().enumerate() {
        assert_eq!(
            j.health.state, sim2.body.joints[i].health.state,
            "第 {i} 条关节状态"
        );
        assert!((j.health.integrity - sim2.body.joints[i].health.integrity).abs() < 1e-5);
    }

    // --- 3. 轨迹：各跑 10 秒 ---
    for _ in 0..600 {
        sim.step();
        sim2.step();
    }
    let a = sim.creatures[sim.active].physio.bus;
    let b = sim2.creatures[sim2.active].physio.bus;
    println!(
        "10 秒后：MAP {:.4} / {:.4}，HR {:.4} / {:.4}，意识 {:.4} / {:.4}",
        a.map, b.map, a.heart_rate, b.heart_rate, a.consciousness, b.consciousness
    );
    assert!((a.map - b.map).abs() < 1e-3, "MAP 轨迹分叉");
    assert!((a.heart_rate - b.heart_rate).abs() < 1e-3, "心率轨迹分叉");
    assert!(
        (a.consciousness - b.consciousness).abs() < 1e-3,
        "意识轨迹分叉"
    );
    assert!(
        (a.blood_volume - b.blood_volume).abs() < 1e-2,
        "血容量轨迹分叉"
    );
}

/// 验收标准 9：组织场单帧耗时。
///
/// 预算表写的是"20Hz 摊到每帧 0.7ms"，也就是单个组织 tick 3.5ms 以内
/// （60fps 下每 3 帧跑一次）。这里量的是单次 `TissueSim::step`。
#[test]
fn a_tissue_tick_fits_the_frame_budget() {
    let mut sim = world();
    // 切几刀，让场里有一部分是创口（创口路径比干净场慢）
    for i in 0..3 {
        let y = 20.0 - i as f32 * 20.0;
        sim.cut_body_local(&CutSegment {
            a: Vec2::new(-30.0, y),
            b: Vec2::new(30.0, y - 4.0),
            width: 0.05,
            speed: 2.0,
        });
    }

    let map = sim.creatures[sim.active].physio.bus.map;
    let tissue = sim.creatures[sim.active].tissue.as_mut().unwrap();
    // 预热
    for _ in 0..20 {
        tissue.step(map, 1.0 / 20.0);
    }
    let t0 = std::time::Instant::now();
    let n = 200;
    for _ in 0..n {
        tissue.step(map, 1.0 / 20.0);
    }
    let per = t0.elapsed().as_secs_f64() * 1000.0 / n as f64;
    let n_texel = tissue.field.len();
    println!(
        "{n_texel} texel，单次组织 tick {per:.3} ms（预算 3.5ms），摊到每帧 {:.3} ms",
        per / 3.0
    );
    // debug 构建比 release 慢 5~10 倍。预算 3.5ms 是给 release 定的，
    // 这里按构建类型分档，免得测试在开发机上永远红着。
    let budget = if cfg!(debug_assertions) { 8.0 } else { 3.5 };
    assert!(per < budget, "组织场单帧 {per:.3} ms 超预算 {budget} ms");
}
