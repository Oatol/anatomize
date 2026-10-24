//! M2 验收演示：组织场求解器。
//!
//! 用法：`cargo run -p anatomize-tools --bin tissue_demo`
//!
//! 做四件事：
//! 1. 把 human_01 光栅化成组织场，检查 texel 数与组织分布
//! 2. 预热压力场，报告无创口稳态（组织压 / 全身动脉流入 / 组织氧 / 核心温度）
//! 3. 在大腿上开一条贯通创口，扫 MAP 看出血量是不是线性
//! 4. 跑 90 秒生理演化，输出四联热力图
//!
//! 这个工具同样不碰物理引擎——组织场是纯场求解，跟刚体无关。

use anatomize_body::{ASSET_HUMAN_01, BodyPlan, BoneKind, Layer};
use anatomize_core::Vec2;
use anatomize_tissue::{
    Shape, TissueConfig, TissueKind, TissueSim, apply_wound, rasterize, venous_return, wound_flux,
};
use anatomize_tools::render::{Canvas, ramp};

const MAP: f32 = 93.0;
const DT: f32 = 1.0 / 20.0;

const BG: [u8; 4] = [0x14, 0x16, 0x1B, 0xFF];
const PANEL_BG: [u8; 4] = [0x22, 0x25, 0x2C, 0xFF];
const INK: [u8; 4] = [0xE8, 0xE6, 0xE1, 0xFF];
const DIM: [u8; 4] = [0x8A, 0x8F, 0x99, 0xFF];
const CUT: [u8; 4] = [0x3F, 0xF0, 0xFF, 0xFF];

fn layer_kind(l: Layer) -> TissueKind {
    match l {
        Layer::Skin => TissueKind::Skin,
        Layer::Fat => TissueKind::Fat,
        Layer::Muscle => TissueKind::Muscle,
        Layer::Bone => TissueKind::Bone,
        Layer::Organ => TissueKind::Organ,
    }
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let plan = BodyPlan::from_ron(ASSET_HUMAN_01)?;
    let cfg = TissueConfig::asset();

    // --- 1. 光栅化 ---
    // 部件多边形在身体局部坐标里（cm），直接喂给光栅器。
    let polys: Vec<Vec<Vec2>> = plan
        .parts
        .iter()
        .map(|p| p.polygon.iter().map(|v| *v + p.offset).collect())
        .collect();
    let shapes: Vec<Shape> = plan
        .parts
        .iter()
        .zip(&polys)
        .map(|(p, poly)| Shape {
            polygon: poly,
            kind: layer_kind(p.layer),
            bone_core: p.bone != BoneKind::None,
        })
        .collect();

    let field = rasterize(&shapes, &cfg, 1.0);
    let hist = field.histogram();
    println!(
        "组织场 {}×{} = {} texel（texel {:.2} cm），其中组织 texel {}",
        field.w,
        field.h,
        field.len(),
        field.texel_cm,
        field.tissue_texels()
    );
    print!("  分布：");
    for k in TissueKind::ALL {
        let n = hist[k.index()];
        if n > 0 {
            print!("{} {}  ", k.name(), n);
        }
    }
    println!();

    let mut sim = TissueSim::new(field.clone(), cfg.clone());

    // --- 2. 无创口稳态 ---
    let t0 = std::time::Instant::now();
    let delta = sim.warmup(MAP);
    let warm_ms = t0.elapsed().as_secs_f32() * 1000.0;
    println!(
        "\n预热完成（{warm_ms:.0} ms，最大逐点变化 {delta:.2e}）"
    );
    println!("  无创口稳态：");
    println!("    组织平均压      {:.2} mmHg", sim.step.mean_pressure);
    println!("    全身动脉流入    {:.2} mL/s（{:.1} L/min）", sim.step.arterial_inflow, sim.step.arterial_inflow * 0.06);
    println!("    组织平均灌注    {:.5} 1/s", sim.step.mean_perfusion);
    println!("    组织平均氧分压  {:.2} mmHg", sim.step.mean_o2);
    println!("    核心温度        {:.2} °C", sim.step.core_temp);

    // --- 3. 开一条贯通创口 ---
    // 左大腿横断：身体坐标 y = -25，从外侧切到内侧。
    let a = Vec2::new(-14.5, -25.0);
    let b = Vec2::new(-1.5, -25.0);
    let n = apply_wound(&mut sim.field, a, b, cfg.wound_radius_cm);
    println!("\n左大腿横断：标记 {} 个创口 texel", n);

    let mut rows = Vec::new();
    println!("\n出血随 MAP 变化（纯流体，无代偿、无凝血）：");
    println!("  {:>6}  {:>10}  {:>12}", "MAP", "Q (mL/s)", "Q/MAP");
    for map in [40.0f32, 60.0, 80.0, 93.0, 110.0, 140.0] {
        sim.warmup(map);
        let q = wound_flux(&sim.field, map);
        rows.push((map, q));
        println!("  {map:>6.1}  {q:>10.4}  {:>12.6}", q / map);
    }
    // Q 是 MAP 的仿射函数（截距来自静脉压 5 mmHg），拟合一条直线看偏离
    let n = rows.len() as f32;
    let sx: f32 = rows.iter().map(|r| r.0).sum();
    let sy: f32 = rows.iter().map(|r| r.1).sum();
    let sxx: f32 = rows.iter().map(|r| r.0 * r.0).sum();
    let sxy: f32 = rows.iter().map(|r| r.0 * r.1).sum();
    let ka = (n * sxy - sx * sy) / (n * sxx - sx * sx);
    let kb = (sy - ka * sx) / n;
    let worst = rows
        .iter()
        .map(|(m, q)| ((q - (ka * m + kb)) / q).abs() * 100.0)
        .fold(0.0f32, f32::max);
    println!("  拟合 Q = {ka:.6}·MAP + {kb:.6}，最大偏离 {worst:.3}%");

    // 回到 MAP 93 再读一次，避免上面循环把场留在 140
    sim.warmup(MAP);
    let q93 = wound_flux(&sim.field, MAP);
    let ret = venous_return(&sim.field, cfg.p_venous);
    println!(
        "  MAP 93：出血 {:.2} mL/s（{:.0} mL/min），静脉回流 {:.1} mL/s",
        q93,
        q93 * 60.0,
        ret
    );

    // --- 4. 生理演化 ---
    // 全身均值会被健康组织稀释，看不出创口的局部后果，所以额外报一个
    // "创口周围 3cm" 的区域读数。
    let center = (a + b) * 0.5;
    println!("\n生理演化（MAP 固定 93，创口不闭合）：");
    sim.warmup(MAP);
    let mut marks = Vec::new();
    let mut t = 0.0f32;
    while t < 90.0 {
        sim.step(MAP, DT);
        t += DT;
        for at in [10.0f32, 30.0, 60.0, 90.0] {
            if (t - at).abs() < DT * 0.5 {
                let (lo2, lperf, ldmg) = region(&sim, center, 3.0);
                marks.push((at, lo2, lperf, ldmg, sim.step.core_temp));
            }
        }
    }
    println!(
        "  {:>5}  {:>12}  {:>12}  {:>10}  {:>10}",
        "t(s)", "局部O2", "局部灌注", "局部损伤", "核心温"
    );
    for (t, o2, perf, dmg, temp) in &marks {
        println!("  {t:>5.0}  {o2:>12.2}  {perf:>12.5}  {dmg:>10.4}  {temp:>10.2}");
    }
    let (lo2, lperf, ldmg) = region(&sim, center, 3.0);
    println!(
        "  全身：O2 {:.2} mmHg，灌注 {:.5} 1/s，损伤 {:.4}",
        sim.step.mean_o2, sim.step.mean_perfusion, sim.step.mean_damage
    );
    println!("  创口周围 3cm：O2 {lo2:.2} mmHg，灌注 {lperf:.5} 1/s，损伤 {ldmg:.4}");

    // --- 5. 对照：如果这条腿的血供被切断 ---
    // M2 没有血管图，切一刀只是局部泄压，不会让整条腿缺血——那是 M3 的事。
    // 这里手工把左腿的血管床电导清零，模拟"M3 判定股动脉离断、下游断供"，
    // 用来验证缺血 → 缺氧 → 坏死这条链在真实人体几何上跑得通。
    println!("\n对照：左腿血供切断（模拟 M3 的动脉离断）");
    let mut sim2 = TissueSim::new(field.clone(), cfg.clone());
    let mut cut_off = 0usize;
    for i in 0..sim2.field.len() {
        let c = sim2.field.center_of(i);
        if c.x < -2.0 && c.y < -14.0 {
            sim2.field.k0[i] = 0.0;
            cut_off += 1;
        }
    }
    sim2.warmup(MAP);
    println!("  断供 texel {cut_off} 个");

    // 演示用 dt 放宽到 0.5s：显式欧拉在这个参数下依然稳定，只是精度差一点。
    let dt2 = 0.5f32;
    let mut t = 0.0f32;
    let leg = Vec2::new(-8.0, -30.0);
    println!(
        "  {:>6}  {:>10}  {:>10}  {:>12}",
        "t(s)", "患腿O2", "患腿损伤", "患腿灌注"
    );
    while t < 1200.0 {
        sim2.step(MAP, dt2);
        t += dt2;
        for at in [60.0f32, 300.0, 600.0, 900.0, 1200.0] {
            if (t - at).abs() < dt2 * 0.5 {
                let (o2, perf, dmg) = region(&sim2, leg, 6.0);
                println!("  {t:>6.0}  {o2:>10.2}  {dmg:>10.4}  {perf:>12.6}");
            }
        }
    }
    let (lo2, lperf, ldmg) = region(&sim2, leg, 6.0);
    println!("  1200s 后患腿：O2 {lo2:.2} mmHg，灌注 {lperf:.6} 1/s，损伤 {ldmg:.4}");
    println!(
        "  解析：肌肉从 40 mmHg 掉到缺氧阈值 10 mmHg 需 {:.0} s（器官快 3 倍）",
        anatomize_tissue::time_to_hypoxia(&cfg, TissueKind::Muscle, 40.0)
    );

    // --- 6. 两行对照热力图 ---
    let rows = [
        (
            &sim,
            format!(
                "WOUNDED THIGH - T+90S    Q={:.2} ML/S   ARTERIAL INFLOW={:.1} ML/S",
                sim.step.wound_flux, sim.step.arterial_inflow
            ),
            vec![(a, b)],
        ),
        (
            &sim2,
            format!("LEFT LEG ARTERY CUT - T+1200S    LEG O2={lo2:.1}   DAMAGE={ldmg:.2}"),
            vec![],
        ),
    ];
    let path = std::path::Path::new("out/m2_tissue.png");
    render(&rows, path)?;
    println!("\n-> {}", path.display());

    Ok(())
}

/// 以 `c` 为中心、`r_cm` 为半径的组织区均值：(氧分压, 灌注, 损伤)。
fn region(sim: &TissueSim, c: Vec2, r_cm: f32) -> (f32, f32, f32) {
    let f = &sim.field;
    let r2 = r_cm * r_cm;
    let (mut so, mut sp, mut sd, mut n) = (0.0, 0.0, 0.0, 0usize);
    for i in 0..f.len() {
        if !f.kind[i].is_vascular() {
            continue;
        }
        if (f.center_of(i) - c).length_squared() > r2 {
            continue;
        }
        so += f.o2[i];
        sp += f.perfusion[i];
        sd += f.damage[i];
        n += 1;
    }
    if n == 0 {
        return (0.0, 0.0, 0.0);
    }
    let n = n as f32;
    (so / n, sp / n, sd / n)
}

/// 每行一个场景，四列固定是：压力 / 灌注 / 氧 / 损伤。
///
/// 量程全部从 0 起，压力和氧用物理上限（MAP / 动脉氧分压）而不是自适应：
/// 自适应会把 44.8–44.9 拉满整条色带，创口的低压坑就看不见了，跨行也没法比。
fn render(
    rows: &[(&TissueSim, String, Vec<(Vec2, Vec2)>)],
    path: &std::path::Path,
) -> Result<(), Box<dyn std::error::Error>> {
    let sc = 2i32; // 每 texel 的像素数
    let f0 = &rows[0].0.field;
    let pw = f0.w as i32 * sc;
    let ph = f0.h as i32 * sc;
    let gap = 16;
    let left = 14;
    let head = 40;

    let w = (left * 2 + pw * 4 + gap * 3) as u32;
    let h = (head + 34 + ph + 24 + 12 + ph + 24 + 40) as u32;
    let mut cv = Canvas::blank(w, h);
    cv.clear(BG);
    cv.text(left, 12, "TISSUE FIELD - 20HZ - JACOBI 8 ITER", 2, INK);

    // 灌注没有物理上限，取所有行里组织 texel 的最大值——跨行共享，
    // 否则两行的色带不可比，"这条腿灌注掉了"就看不出来。
    let mut perf_hi = 0.0f32;
    for (sim, _, _) in rows {
        let f = &sim.field;
        for i in 0..f.len() {
            if f.kind[i].is_vascular() {
                perf_hi = perf_hi.max(f.perfusion[i]);
            }
        }
    }
    if perf_hi <= 0.0 {
        perf_hi = 1.0;
    }

    let mut y = head;
    for (ri, (sim, label, cuts)) in rows.iter().enumerate() {
        let f = &sim.field;
        cv.text(left, y, label, 1, INK);
        let mut oy = y + 12;
        if ri == 0 {
            // 列标题只画第一行
            for (pi, name) in ["PRESSURE", "PERFUSION", "OXYGEN", "DAMAGE"]
                .iter()
                .enumerate()
            {
                cv.text(left + pi as i32 * (pw + gap), y + 16, name, 2, INK);
            }
            oy = y + 34;
        }

        let panels: [(&str, &[f32], f32); 4] = [
            ("MMHG", &f.pressure, MAP),
            ("1/S", &f.perfusion, perf_hi),
            ("MMHG", &f.o2, sim.cfg.p_arterial_o2),
            ("0-1", &f.damage, 1.0),
        ];

        for (pi, (unit, ch, fixed_hi)) in panels.iter().enumerate() {
            let ox = left + pi as i32 * (pw + gap);

            let hi = *fixed_hi;

            cv.px_rect(ox - 1, oy - 1, ox + pw, oy + ph, PANEL_BG);

            for ty in 0..f.h {
                for tx in 0..f.w {
                    let i = f.idx(tx, ty);
                    if f.kind[i] == TissueKind::Outside {
                        continue;
                    }
                    let c = ramp(ch[i] / hi);
                    // texel 的 y 向上，画布 y 向下
                    let px = ox + tx as i32 * sc;
                    let py = oy + (f.h - 1 - ty) as i32 * sc;
                    cv.px_rect(px, py, px + sc - 1, py + sc - 1, c);
                }
            }

            // 创口位置：只画两端的小标记，不画整条线——整条线会把创口自己的
            // 低压坑盖掉，而那个坑正是压力面板上唯一有信息量的地方。
            for (a, b) in cuts {
                for (p, dir) in [(*a, -1.0f32), (*b, 1.0f32)] {
                    if let Some(q) = texel_px(f, p, ox, oy, sc) {
                        let tick = (dir * 7.0) as i32;
                        cv.px_rect(q.0 + tick.min(0), q.1 - 1, q.0 + tick.max(0), q.1 + 1, CUT);
                    }
                }
            }

            let shown = if hi < 1.0 {
                format!("0 - {hi:.4} {unit}")
            } else {
                format!("0 - {hi:.1} {unit}")
            };
            cv.text(ox, oy + ph + 4, &shown, 1, DIM);
        }

        y = oy + ph + 24;
    }

    // 底部图例
    let ly = y;
    for x in 0..240 {
        cv.px_rect(left + x, ly, left + x, ly + 8, ramp(x as f32 / 239.0));
    }
    cv.text(left, ly + 14, "LOW", 1, DIM);
    cv.text(left + 210, ly + 14, "HIGH", 1, DIM);
    cv.text(
        left + 270,
        ly,
        "CYAN TICKS = CUT   BLACK = OUTSIDE   BONE CORES = LOW PERFUSION",
        1,
        DIM,
    );
    cv.text(
        left + 270,
        ly + 12,
        "PRESSURE IS NEARLY UNIFORM BY DESIGN - TISSUE CONDUCTION IS 10X WEAKER THAN BED COUPLING",
        1,
        DIM,
    );

    cv.save(path)
}

/// 身体局部坐标（cm）→ 面板像素坐标。
fn texel_px(
    f: &anatomize_tissue::TissueField,
    p: Vec2,
    ox: i32,
    oy: i32,
    sc: i32,
) -> Option<(i32, i32)> {
    let lx = (p.x - f.origin.x) / f.texel_cm;
    let ly = (p.y - f.origin.y) / f.texel_cm;
    if lx < 0.0 || ly < 0.0 || lx >= f.w as f32 || ly >= f.h as f32 {
        return None;
    }
    Some((ox + lx as i32 * sc, oy + (f.h as f32 - ly) as i32 * sc))
}
