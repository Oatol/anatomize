//! M2 验收：组织场求解器。
//!
//! 设计文档第 13 节 M2 的验收标准是「给定创口，出血速率随 MAP 线性变化，与解析解
//! 误差 <10%」。这里把它拆成一组能真正跑起来的断言，外加几条守恒与定性检查。

use anatomize_core::Vec2;
use anatomize_tissue::{
    PressureSolver, Shape, TissueConfig, TissueField, TissueKind, TissueSim, arterial_inflow,
    rasterize, venous_return, wound_flux,
};

// ---------------------------------------------------------------------------
// 夹具
// ---------------------------------------------------------------------------

fn slab(w_cm: f32, h_cm: f32, kind: TissueKind) -> TissueField {
    let poly = vec![
        Vec2::new(0.0, 0.0),
        Vec2::new(w_cm, 0.0),
        Vec2::new(w_cm, h_cm),
        Vec2::new(0.0, h_cm),
    ];
    let shapes = [Shape {
        polygon: &poly,
        kind,
        bone_core: false,
    }];
    let cfg = TissueConfig::default();
    rasterize(&shapes, &cfg, 1.0)
}

/// 一条 1×N 的均匀条带，左端钉 MAP、右端钉 0，且**关掉所有血管床耦合**，
/// 只留组织间连通——这样它退化成一道纯 Laplace 问题，才有解析解可比。
///
/// 注意不能走 `TissueSim::new`：它会用配置重算电导，把手工设的值盖掉。
fn strip(n: u32, k: f32) -> (TissueField, TissueConfig) {
    let cfg = TissueConfig::default();

    let mut f = TissueField::new(n, 3, 0.5, Vec2::ZERO);
    for x in 0..n {
        let i = f.idx(x, 1);
        f.kind[i] = TissueKind::Muscle;
    }
    // 手工铺电导：只有组织间连通，没有血管床
    for i in 0..f.len() {
        let on = f.kind[i] == TissueKind::Muscle;
        f.conductance[i] = if on { k } else { 0.0 };
        f.k0[i] = 0.0;
        f.bed[i] = 0.0;
        f.c_art[i] = 0.0;
        f.c_ven[i] = 0.0;
    }
    let a = f.idx(0, 1);
    let b = f.idx(n - 1, 1);
    f.inlet[a] = true;
    f.wound[b] = true;
    (f, cfg)
}

// ---------------------------------------------------------------------------
// 解析解
// ---------------------------------------------------------------------------

/// 均匀条带，两端狄利克雷，稳态达西流是一维线性压力剖面。
///
/// 解析解：`p(x) = MAP·(1 - x/L)`，创口面通量 `Q = K·MAP/L`。
/// 离散步进 `L = (n-1)·dx`，面流量 `Q = K·(Δp/dx)·dx = K·MAP/(n-1)`。
#[test]
fn analytic_1d_laplace() {
    let k = 0.02;
    let n = 32u32;
    let map = 93.0f32;
    let (mut f, cfg) = strip(n, k);

    let mut solver = PressureSolver::new(f.len());
    solver.solve(&mut f, &cfg, map, 8000);
    println!("预热后最大逐点变化 {:.3e}", solver.last_delta);

    let expect = k * map / (n - 1) as f32;
    let got = wound_flux(&f, map);
    let err = ((got - expect) / expect).abs() * 100.0;
    println!("解析解 Q = {expect:.6} mL/s，实测 {got:.6} mL/s，误差 {err:.3}%");
    assert!(
        err < 10.0,
        "与解析解误差应 <10%，实际 {err:.3}%（期望 {expect}, 实测 {got}）"
    );
}

/// 解析解同时给出压力剖面形状：应该是等距线性下降。
#[test]
fn analytic_1d_profile_is_linear() {
    let k = 0.02;
    let n = 32u32;
    let map = 100.0f32;
    let (mut f, cfg) = strip(n, k);

    let mut solver = PressureSolver::new(f.len());
    solver.solve(&mut f, &cfg, map, 8000);

    for x in 0..n {
        let want = map * (1.0 - x as f32 / (n - 1) as f32);
        let got = f.pressure[f.idx(x, 1)];
        assert!(
            (got - want).abs() < 0.5,
            "x={x} 处压力应为 {want:.2}，实际 {got:.2}"
        );
    }
}

// ---------------------------------------------------------------------------
// 验收核心：出血随 MAP 线性
// ---------------------------------------------------------------------------

/// 在真实的二维场里，把 MAP 从 40 扫到 140，看创口通量是不是随 MAP 线性。
///
/// 静脉压置 0 时系统对 MAP 严格线性，`Q/MAP` 应是常数。
#[test]
fn wound_flux_is_linear_in_map() {
    let mut cfg = TissueConfig::default();
    cfg.p_venous = 0.0;
    cfg.jacobi_iters = 400;

    let mut f = slab(40.0, 20.0, TissueKind::Muscle);
    // 一条竖直创口，从中间切开
    for i in 0..f.len() {
        let c = f.center_of(i);
        if (c.x - 20.0).abs() <= 0.6 && f.kind[i].is_vascular() {
            f.wound[i] = true;
        }
    }
    assert!(f.wound.iter().filter(|w| **w).count() > 10, "创口太小");

    let mut sim = TissueSim::new(f, cfg);
    let mut ratios = Vec::new();
    for map in [40.0f32, 60.0, 80.0, 93.0, 110.0, 140.0] {
        sim.warmup(map);
        let q = sim.wound_flux(map);
        println!("MAP {map:>6.1} -> Q {q:.4} mL/s   Q/MAP {:.6}", q / map);
        assert!(q > 0.0, "MAP {map} 时应有出血");
        ratios.push(q / map);
    }

    let mean = ratios.iter().sum::<f32>() / ratios.len() as f32;
    for (i, r) in ratios.iter().enumerate() {
        let dev = ((r - mean) / mean).abs() * 100.0;
        assert!(
            dev < 1.0,
            "第 {i} 个 MAP 点的 Q/MAP 偏离均值 {dev:.3}%，应 <1%（非线性）"
        );
    }
    println!("Q/MAP 恒为 {mean:.6}，最大偏差 <1%");
}

/// 静脉压不为 0 时，Q 是 MAP 的仿射函数（`Q = a·MAP + b`），仍是一条直线。
#[test]
fn wound_flux_affine_with_venous_pressure() {
    let cfg = TissueConfig::default();
    let mut f = slab(40.0, 20.0, TissueKind::Muscle);
    for i in 0..f.len() {
        let c = f.center_of(i);
        if (c.x - 20.0).abs() <= 0.6 && f.kind[i].is_vascular() {
            f.wound[i] = true;
        }
    }
    let mut sim = TissueSim::new(f, cfg);

    let maps = [50.0f32, 70.0, 90.0, 110.0, 130.0];
    let mut qs = Vec::new();
    for map in maps {
        sim.warmup(map);
        qs.push(sim.wound_flux(map));
    }

    // 最小二乘拟合 Q = a·map + b
    let n = maps.len() as f32;
    let sx: f32 = maps.iter().sum();
    let sy: f32 = qs.iter().sum();
    let sxx: f32 = maps.iter().map(|m| m * m).sum();
    let sxy: f32 = maps.iter().zip(&qs).map(|(m, q)| m * q).sum();
    let a = (n * sxy - sx * sy) / (n * sxx - sx * sx);
    let b = (sy - a * sx) / n;

    let mut worst = 0.0f32;
    for (m, q) in maps.iter().zip(&qs) {
        let fit = a * m + b;
        let dev = ((q - fit) / fit).abs() * 100.0;
        worst = worst.max(dev);
        println!("MAP {m:>6.1} -> Q {q:.4}（拟合 {fit:.4}）");
    }
    println!("拟合 Q = {a:.6}·MAP + {b:.6}，最大偏差 {worst:.3}%");
    assert!(a > 0.0, "斜率必须为正：MAP 越高出血越快");
    assert!(worst < 1.0, "与直线的最大偏差应 <1%，实际 {worst:.3}%");
}

// ---------------------------------------------------------------------------
// 守恒
// ---------------------------------------------------------------------------

/// 稳态下「动脉流入 = 静脉回流 + 创口出血」。这条成立才说明通量公式和求解器
/// 是同一个物理，而不是各算各的。
#[test]
fn conservation_inflow_equals_return_plus_bleed() {
    let cfg = TissueConfig::default();
    let mut f = slab(40.0, 20.0, TissueKind::Muscle);
    for i in 0..f.len() {
        let c = f.center_of(i);
        if (c.x - 20.0).abs() <= 0.6 && f.kind[i].is_vascular() {
            f.wound[i] = true;
        }
    }
    let mut sim = TissueSim::new(f, cfg);
    sim.warmup(93.0);

    let map = 93.0;
    let p_ven = sim.cfg.p_venous;
    let inflow = arterial_inflow(&sim.field, map);
    let ret = venous_return(&sim.field, p_ven);
    let bleed = wound_flux(&sim.field, 93.0);
    let err = ((inflow - ret - bleed) / inflow).abs() * 100.0;
    println!("流入 {inflow:.4} = 回流 {ret:.4} + 出血 {bleed:.4}，误差 {err:.4}%");
    assert!(err < 2.0, "守恒误差应 <2%，实际 {err:.4}%");
}

/// 没有创口就不该出血。
#[test]
fn no_wound_no_bleed() {
    let cfg = TissueConfig::default();
    let f = slab(30.0, 20.0, TissueKind::Muscle);
    let mut sim = TissueSim::new(f, cfg);
    sim.warmup(93.0);
    assert_eq!(sim.wound_flux(93.0), 0.0);
    assert!(sim.step.mean_pressure > 10.0, "无创口时组织压应正常");
}

/// 创口越长出血越多，且近似成比例。
#[test]
fn longer_wound_bleeds_more() {
    let cfg = TissueConfig::default();

    let mk = |half_len: f32| {
        let mut f = slab(40.0, 40.0, TissueKind::Muscle);
        for i in 0..f.len() {
            let c = f.center_of(i);
            if (c.x - 20.0).abs() <= 0.6
                && (c.y - 20.0).abs() <= half_len
                && f.kind[i].is_vascular()
            {
                f.wound[i] = true;
            }
        }
        let n = f.wound.iter().filter(|w| **w).count();
        let mut sim = TissueSim::new(f, cfg.clone());
        sim.warmup(93.0);
        (n, sim.wound_flux(93.0))
    };

    let (n1, q1) = mk(5.0);
    let (n2, q2) = mk(10.0);
    println!("创口 {n1} texel -> {q1:.3} mL/s；{n2} texel -> {q2:.3} mL/s");
    assert!(q2 > q1 * 1.5, "创口翻倍，出血应显著增加（{q1} -> {q2}）");
}

/// 同样长度的创口，切在骨头上出血必须远小于切在肌肉上。
///
/// 断言用相对值而不是绝对值：骨的 `k0` 是肌肉的 1/20，但创口面和周围肌肉之间
/// 用调和平均，通量被周围组织"抬"起来一点。所以骨创口不是 0，只是少一个量级。
#[test]
fn bone_bleeds_far_less_than_muscle() {
    let cfg = TissueConfig::default();

    let mk = |kind: TissueKind| {
        let mut f = slab(30.0, 20.0, TissueKind::Muscle);
        for i in 0..f.len() {
            let c = f.center_of(i);
            if (c.x - 15.0).abs() <= 0.6 {
                f.kind[i] = kind;
                f.wound[i] = true;
            }
        }
        f.bake_k0(&cfg);
        let mut sim = TissueSim::new(f, cfg.clone());
        sim.warmup(93.0);
        sim.wound_flux(93.0)
    };

    let q_bone = mk(TissueKind::Bone);
    let q_muscle = mk(TissueKind::Muscle);
    println!("同长度创口：肌肉 {q_muscle:.3} mL/s，骨 {q_bone:.3} mL/s");
    assert!(q_muscle > 1.0, "肌肉创口应该明显出血，实际 {q_muscle}");
    assert!(
        q_bone < q_muscle * 0.25,
        "骨创口应低于肌肉的 25%（骨 {q_bone:.3} vs 肌肉 {q_muscle:.3}）"
    );
}

// ---------------------------------------------------------------------------
// 生理演化
// ---------------------------------------------------------------------------

/// 零灌注区应该缺氧、累积损伤，最后坏死。
///
/// 用器官组织（`VO2 = 0.10`）而不是肌肉（0.03）：肌肉耐缺血几小时，
/// 器官几分钟就开始坏死——这个差别是 `vo2` 表自动带来的，没有额外规则。
#[test]
fn ischemia_kills_tissue() {
    let mut cfg = TissueConfig::default();
    cfg.k0.muscle = 0.0; // 完全断血
    cfg.k0.organ = 0.0;
    cfg.k0.skin = 0.0;

    let poly = vec![
        Vec2::new(0.0, 0.0),
        Vec2::new(20.0, 0.0),
        Vec2::new(20.0, 10.0),
        Vec2::new(0.0, 10.0),
    ];
    let shapes = [Shape {
        polygon: &poly,
        kind: TissueKind::Organ,
        bone_core: false,
    }];
    let f = rasterize(&shapes, &cfg, 1.0);
    let mut sim = TissueSim::new(f, cfg);
    sim.field.fill_o2(40.0);

    let dt = 1.0 / 20.0;
    let mut t = 0.0f32;
    let mut marks = Vec::new();
    while t < 900.0 {
        sim.step(93.0, dt);
        t += dt;
        for at in [120.0, 300.0, 600.0] {
            if (t - at).abs() < dt * 0.5 {
                marks.push((at, sim.step.mean_o2, sim.step.mean_damage));
            }
        }
    }
    for (t, o2, d) in &marks {
        println!("t={t:>5.0}s  平均 O2 {o2:>6.2} mmHg  损伤 {d:.3}");
    }
    println!(
        "t=900s  平均 O2 {:.2} mmHg  损伤 {:.3}",
        sim.step.mean_o2, sim.step.mean_damage
    );
    assert!(sim.step.mean_o2 < 5.0, "断血 15 分钟后氧应接近 0");
    assert!(
        sim.step.mean_damage > 0.5,
        "断血 15 分钟后损伤应过半，实际 {:.3}",
        sim.step.mean_damage
    );
}

/// 正常灌注下，组织氧应该停在生理区间，不会掉到 0 也不会满血。
#[test]
fn normal_perfusion_keeps_o2_in_range() {
    let cfg = TissueConfig::default();
    let f = slab(40.0, 20.0, TissueKind::Muscle);
    let mut sim = TissueSim::new(f, cfg);

    let dt = 1.0 / 20.0;
    for _ in 0..(120.0 / dt) as usize {
        sim.step(93.0, dt);
    }
    println!(
        "正常灌注 120s：平均 O2 {:.2} mmHg，平均灌注 {:.5} 1/s，核心温度 {:.2}°C，损伤 {:.4}",
        sim.step.mean_o2, sim.step.mean_perfusion, sim.step.core_temp, sim.step.mean_damage
    );
    assert!(
        (10.0..90.0).contains(&sim.step.mean_o2),
        "组织氧应在 10–90 mmHg，实际 {:.2}",
        sim.step.mean_o2
    );
    assert!(
        sim.step.mean_damage < 0.02,
        "正常灌注不该累积损伤，实际 {:.4}",
        sim.step.mean_damage
    );
}

/// 正常灌注下核心温度应稳定在 37 附近。
#[test]
fn core_temp_is_stable() {
    let cfg = TissueConfig::default();
    let f = slab(40.0, 30.0, TissueKind::Muscle);
    let mut sim = TissueSim::new(f, cfg);
    let dt = 1.0 / 20.0;
    for _ in 0..(120.0 / dt) as usize {
        sim.step(93.0, dt);
    }
    println!("120s 后核心温度 {:.3}°C", sim.step.core_temp);
    assert!(
        (36.0..38.0).contains(&sim.step.core_temp),
        "核心温度应稳定在 36–38°C，实际 {:.3}",
        sim.step.core_temp
    );
}

// ---------------------------------------------------------------------------
// 光栅化与配置
// ---------------------------------------------------------------------------

/// 皮肤是涌现的：紧贴 Outside 的一圈才是皮肤，接缝处不会。
#[test]
fn skin_rim_is_emergent() {
    let f = slab(20.0, 20.0, TissueKind::Muscle);
    let hist = f.histogram();
    println!("组织直方图 {:?}", hist);

    // 中间那一格必须是肌肉
    let mid = f.idx(f.w / 2, f.h / 2);
    assert_eq!(f.kind[mid], TissueKind::Muscle, "中心应是肌肉");

    // 中间那一行最靠左的组织 texel 必须是皮肤（再往左是 Outside 边距）
    let row = f.h / 2;
    let leftmost = (0..f.w)
        .map(|x| f.idx(x, row))
        .find(|i| f.kind[*i] != TissueKind::Outside)
        .expect("这一行应该有组织");
    assert_eq!(f.kind[leftmost], TissueKind::Skin, "表面应是皮肤");

    // 往里一格必须已经是肌肉（皮肤只有一层）
    let inner = leftmost + 1;
    assert_eq!(f.kind[inner], TissueKind::Muscle, "皮肤只应有一层");

    // 皮肤数量约等于周长，不随面积增长
    let perim = 2 * (f.w + f.h) as usize;
    assert!(
        hist[TissueKind::Skin.index()] < perim * 2,
        "皮肤 texel 数 {} 应约等于周长 {}",
        hist[TissueKind::Skin.index()],
        perim
    );
    assert_eq!(hist[TissueKind::Bone.index()], 0, "没开骨芯就不该有骨");
}

/// 骨芯在部件内部生成。
#[test]
fn bone_core_is_inside() {
    let poly = vec![
        Vec2::new(0.0, 0.0),
        Vec2::new(10.0, 0.0),
        Vec2::new(10.0, 30.0),
        Vec2::new(0.0, 30.0),
    ];
    let shapes = [Shape {
        polygon: &poly,
        kind: TissueKind::Muscle,
        bone_core: true,
    }];
    let cfg = TissueConfig::default();
    let f = rasterize(&shapes, &cfg, 1.0);
    let hist = f.histogram();
    println!("带骨芯的直方图 {:?}", hist);
    assert!(hist[TissueKind::Bone.index()] > 0, "应该有骨");
    let mid = f.idx(f.w / 2, f.h / 2);
    assert_eq!(f.kind[mid], TissueKind::Bone, "中心应是骨");
}

/// 内置配置能解析，且和 `Default` 一致——防止两处漂移。
#[test]
fn asset_config_matches_default() {
    let a = TissueConfig::asset();
    let d = TissueConfig::default();
    assert_eq!(a.texel_cm, d.texel_cm);
    assert_eq!(a.jacobi_iters, d.jacobi_iters);
    assert_eq!(a.k0.muscle, d.k0.muscle);
    assert_eq!(a.vo2.organ, d.vo2.organ);
    assert_eq!(a.arterial_share, d.arterial_share);
    assert_eq!(a.conductance_falloff, d.conductance_falloff);
}

/// 损伤必须让电导下降。
#[test]
fn damage_reduces_conductance() {
    let cfg = TissueConfig::default();
    let mut f = slab(10.0, 10.0, TissueKind::Muscle);
    let mid = f.idx(f.w / 2, f.h / 2);
    let k0 = f.conductance[mid];
    f.damage[mid] = 0.5;
    f.update_conductance(&cfg);
    let k1 = f.conductance[mid];
    println!("损伤 0 -> 0.5，电导 {k0:.5} -> {k1:.5}");
    assert!(k1 < k0 * 0.4, "损伤 50% 时电导应降到约 25%");
}
