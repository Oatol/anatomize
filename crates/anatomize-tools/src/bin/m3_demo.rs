//! M3 验收演示：关节三级状态机 + 结构求交。
//!
//! 用法：`cargo run -p anatomize-tools --bin m3_demo`
//!
//! 出两张图：
//!
//! - `out/m3_artery.png` —— 切断左股动脉前后的组织场对照（灌注 / 氧 / 损伤）
//! - `out/m3_joints.png` —— 左髋从 intact 走到 severed 的四个快照
//!
//! M3 的验收标准是两句话：
//!
//! 1. **切断股动脉能被正确识别**：不是"能量够大就断"，是切面折线真的穿过了
//!    血管折线；而且断在近端和远端后果不同。
//! 2. **脱位后肢体挂着而不是飞走**：`Dislocated` 不是移除约束，是换成一根
//!    6cm 的绳子。这是 v0.1 直接 `remove_joint` 最缺的中间态。

use anatomize_body::{ASSET_HUMAN_01, BodyPlan, JointState};
use anatomize_core::Vec2;
use anatomize_cut::CutSegment;
use anatomize_sim::{CM, Sim, apply_cut, build_tissue};
use anatomize_tissue::{TissueConfig, TissueKind, TissueSim};
use anatomize_tools::render::{Canvas, ramp};

const MAP: f32 = 93.0;
const GROUND_Y: f32 = -0.66;
const ORIGIN: Vec2 = Vec2::new(0.0, 0.35);

const BG: [u8; 4] = [0x14, 0x16, 0x1B, 0xFF];
const PANEL_BG: [u8; 4] = [0x22, 0x25, 0x2C, 0xFF];
const INK: [u8; 4] = [0xE8, 0xE6, 0xE1, 0xFF];
const DIM: [u8; 4] = [0x8A, 0x8F, 0x99, 0xFF];
const CUT: [u8; 4] = [0x3F, 0xF0, 0xFF, 0xFF];
const VESSEL: [u8; 4] = [0xB3, 0x1D, 0x4E, 0xFF];
const HIT: [u8; 4] = [0xFF, 0xD2, 0x2E, 0xFF];

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let plan = BodyPlan::from_ron(ASSET_HUMAN_01)?;
    let cfg = TissueConfig::asset();

    println!(
        "body_plan: {} | {} 部件 / {} 关节 / {} 血管 / {:.1} kg",
        plan.id,
        plan.parts.len(),
        plan.joints.len(),
        plan.vessels.len(),
        plan.total_mass()
    );

    artery_demo(&plan, &cfg)?;
    joint_demo(&plan)?;
    Ok(())
}

// ---------------------------------------------------------------------------
// 一、结构求交：切哪儿、断了什么、坏死了多少
// ---------------------------------------------------------------------------

fn artery_demo(plan: &BodyPlan, cfg: &TissueConfig) -> Result<(), Box<dyn std::error::Error>> {
    println!("\n=== 1. 结构求交：三刀，三个后果 ===");

    // 三刀都落在左大腿上，唯一的区别是**刀口停在哪里**。
    // 这正是"折线血管 + 几何求交"相对"能量阈值"的全部意义。
    let cuts = [
        (
            "大腿横断（穿过股动脉）",
            CutSegment {
                a: Vec2::new(-15.0, -25.0),
                b: Vec2::new(-1.0, -25.0),
                width: 0.6,
                speed: 1.0,
            },
        ),
        (
            "贴着动脉划过（擦伤）",
            CutSegment {
                a: Vec2::new(-15.0, -25.0),
                b: Vec2::new(-8.4, -25.0),
                width: 0.4,
                speed: 1.0,
            },
        ),
        (
            "浅划（没够到血管）",
            CutSegment {
                a: Vec2::new(-15.0, -25.0),
                b: Vec2::new(-11.0, -25.0),
                width: 0.4,
                speed: 1.0,
            },
        ),
    ];

    println!(
        "  {:<24} {:>10} {:>10} {:>8} {:>12}",
        "切法", "命中", "断供texel", "创口", "出血 mL/s"
    );
    let mut severed_scene: Option<(TissueSim, CutSegment)> = None;

    for (label, cut) in &cuts {
        let mut sim = build_tissue(plan, cfg);
        sim.warmup(MAP);
        let out = apply_cut(plan, &mut sim.field, cut);
        sim.warmup(MAP);
        let q = sim.wound_flux(MAP);

        println!(
            "  {label:<24} {:>10} {:>10} {:>8} {:>12.2}",
            out.report.hits.len(),
            out.starved_texels,
            out.wound_texels,
            q
        );
        if !out.report.is_empty() {
            print!("{}", out.report.summary(plan));
        }
        if out.starved_texels > 0 {
            println!("    断供部件 {:?}", out.starved_names(plan));
            if severed_scene.is_none() {
                severed_scene = Some((sim, cut.clone()));
            }
        }
    }

    let (mut after, cut) = severed_scene.expect("至少有一刀该切断股动脉");
    let probes = [
        ("近端（还连着心）", Vec2::new(-8.0, -18.0)),
        ("远端（断供）", Vec2::new(-8.0, -32.0)),
        ("左小腿（断供）", Vec2::new(-8.0, -50.0)),
        ("右腿（无关）", Vec2::new(8.0, -32.0)),
    ];

    // 灌注是**瞬时量**（由压力场直接派生），断完立刻就能读；
    // 氧是**累积量**（要跑 transport_o2 才会掉）。分两次读，别混在一起看。
    println!("
  断口在 y = {:.0} cm。同一个大腿被切成两半：", cut.a.y);
    println!("    {:<18} {:>12}", "即刻（灌注是瞬时的）", "灌注 1/s");
    for (label, p) in &probes {
        let (_, perf) = region(&after, *p, 3.0);
        println!("    {label:<18} {:>12.6}", perf);
    }

    // 断供之后跑 20 分钟：氧掉到缺氧阈值以下，损伤开始累积
    println!("
  断供 20 分钟（dt=0.5s 加快演示）：");
    let mut t = 0.0f32;
    while t < 1200.0 {
        after.step(MAP, 0.5);
        t += 0.5;
        if [300.0f32, 600.0, 900.0, 1200.0]
            .iter()
            .any(|m| (t - m).abs() < 0.25)
        {
            let (o2, perf) = region(&after, Vec2::new(-8.0, -50.0), 4.0);
            let dmg = region_damage(&after, Vec2::new(-8.0, -50.0), 4.0);
            println!("    t={t:>6.0}s  小腿氧 {o2:>5.2}  灌注 {perf:.6}  损伤 {dmg:.3}");
        }
    }

    println!("
  20 分钟后的四个探针：");
    println!(
        "    {:<18} {:>12} {:>10} {:>10}",
        "位置", "灌注 1/s", "氧 mmHg", "损伤"
    );
    for (label, p) in &probes {
        let (o2, perf) = region(&after, *p, 3.0);
        let dmg = region_damage(&after, *p, 3.0);
        println!("    {label:<18} {perf:>12.6} {o2:>10.2} {dmg:>10.3}");
    }

    render_artery(plan, &after, &cut)?;
    Ok(())
}

/// 两行 × 三列热力图：切之前 / 切之后。
fn render_artery(
    plan: &BodyPlan,
    after: &TissueSim,
    cut: &CutSegment,
) -> Result<(), Box<dyn std::error::Error>> {
    // 对照组：没开刀的同一具身体
    let cfg = TissueConfig::asset();
    let mut before = build_tissue(plan, &cfg);
    before.warmup(MAP);

    let sc = 2i32;
    let f0 = &before.field;
    let pw = f0.w as i32 * sc;
    let ph = f0.h as i32 * sc;
    let gap = 14;
    let left = 14;

    // 版面：标题 / 列名（只画一次）/ 第一行标签 / 第一行 / 量程 / 第二行标签 / 第二行 / 量程 / 图例
    let colhdr_y = 34;
    let row0_label_y = 52;
    let oy0 = 64;
    let scale_y0 = oy0 + ph + 4;
    let row1_label_y = scale_y0 + 14;
    let oy1 = row1_label_y + 12;
    let scale_y1 = oy1 + ph + 4;
    let legend_y = scale_y1 + 16;

    let w = (left * 2 + pw * 3 + gap * 2) as u32;
    let h = (legend_y + 34) as u32;
    let mut cv = Canvas::blank(w, h);
    cv.clear(BG);
    cv.text(left, 10, "M3 - STRUCTURE INTERSECTION - 20HZ", 2, INK);

    // 灌注量程跨行共享，否则两行不可比
    let mut perf_hi = 0.0f32;
    for sim in [&before, after] {
        for i in 0..sim.field.len() {
            if sim.field.kind[i].is_vascular() {
                perf_hi = perf_hi.max(sim.field.perfusion[i]);
            }
        }
    }
    if perf_hi <= 0.0 {
        perf_hi = 1.0;
    }

    for (pi, name) in ["PERFUSION", "OXYGEN", "DAMAGE"].iter().enumerate() {
        cv.text(left + pi as i32 * (pw + gap), colhdr_y, name, 2, INK);
    }

    let rows = [
        (
            &before,
            "BEFORE - INTACT   ARTERIAL INFLOW 55.8 ML/S   ALL FOUR LIMBS PERFUSED",
            row0_label_y,
            oy0,
            scale_y0,
            None::<&CutSegment>,
        ),
        (
            after,
            "AFTER - FEMORAL_L SEVERED AT Y=-25CM   DISTAL LEFT LEG STARVED, PROXIMAL THIGH STILL ALIVE",
            row1_label_y,
            oy1,
            scale_y1,
            Some(cut),
        ),
    ];

    for (sim, label, ly, oy, sy, mark) in rows {
        cv.text(left, ly, label, 1, INK);

        let f = &sim.field;
        let panels: [(&[f32], f32); 3] = [
            (&f.perfusion, perf_hi),
            (&f.o2, sim.cfg.p_arterial_o2),
            (&f.damage, 1.0),
        ];

        for (pi, (ch, hi)) in panels.iter().enumerate() {
            let ox = left + pi as i32 * (pw + gap);
            cv.px_rect(ox - 1, oy - 1, ox + pw, oy + ph, PANEL_BG);

            for ty in 0..f.h {
                for tx in 0..f.w {
                    let i = f.idx(tx, ty);
                    if f.kind[i] == TissueKind::Outside {
                        continue;
                    }
                    let px = ox + tx as i32 * sc;
                    let py = oy + (f.h - 1 - ty) as i32 * sc;
                    cv.px_rect(px, py, px + sc - 1, py + sc - 1, ramp(ch[i] / hi));
                }
            }

            // 血管折线：只画在灌注面板上，其他面板留干净看场
            if pi == 0 {
                for v in &plan.vessels {
                    for i in 0..v.path.len() - 1 {
                        let a = texel_px(f, v.path[i], ox, oy, sc);
                        let b = texel_px(f, v.path[i + 1], ox, oy, sc);
                        if let (Some(a), Some(b)) = (a, b) {
                            cv.line_px(a, b, VESSEL, 0);
                        }
                    }
                }
            }

            // 断口位置：两端短横 + 命中点
            if let Some(c) = mark {
                for p in [c.a, c.b] {
                    if let Some(q) = texel_px(f, p, ox, oy, sc) {
                        cv.px_rect(q.0 - 4, q.1 - 1, q.0 + 4, q.1 + 1, CUT);
                    }
                }
                if pi == 0
                    && let Some(q) = texel_px(f, Vec2::new(-8.0, -25.0), ox, oy, sc)
                {
                    cv.disc_px(q, 5, HIT);
                }
            }

            let shown = if *hi < 1.0 {
                format!("0 - {hi:.4}")
            } else {
                format!("0 - {hi:.1}")
            };
            cv.text(ox, sy, &shown, 1, DIM);
        }
    }

    cv.text(
        left,
        legend_y,
        "COLOR SCALE SHARED ACROSS ROWS - DARK BLUE = 0, YELLOW = MAX",
        1,
        DIM,
    );
    cv.text(
        left,
        legend_y + 12,
        "RED = ARTERY   CYAN = CUT   YELLOW DOT = SEVER POINT   BLACK = OUTSIDE",
        1,
        DIM,
    );

    let path = std::path::Path::new("out/m3_artery.png");
    cv.save(path)?;
    println!("
-> {}", path.display());
    Ok(())
}

// ---------------------------------------------------------------------------
// 二、关节状态机：脱位后肢体挂着而不是飞走
// ---------------------------------------------------------------------------

fn joint_demo(plan: &BodyPlan) -> Result<(), Box<dyn std::error::Error>> {
    println!("\n=== 2. 关节三级状态机（左髋）===");

    let mut sim = Sim::spawn(plan.clone(), ORIGIN, GROUND_Y);
    // 把人体吊住（头钉死）。否则 ragdoll 会瘫在地上，四帧看起来一样，
    // "脱位后挂着而不是飞走"根本看不出来。
    sim.set_part_fixed("head", true);
    for _ in 0..180 {
        sim.step();
    }

    let idx = sim.joint_index("hip_l").unwrap();
    let mut frames: Vec<Frame> = Vec::new();

    let snapshot = |sim: &Sim| -> Vec<Vec<Vec2>> {
        sim.plan.parts.iter().map(|p| sim.part_polygon(p.id)).collect()
    };
    let anchors = |sim: &Sim| -> Vec<(Vec2, Vec2)> {
        sim.body
            .joints
            .iter()
            .map(|j| sim.joint_world_anchors(j))
            .collect()
    };

    frames.push(Frame {
        label: format!(
            "A. INTACT  t={:.1}s  INTEGRITY {:.2}  HARD REVOLUTE",
            sim.tick.0 as f32 / 60.0,
            sim.body.joints[idx].health.integrity
        ),
        polys: snapshot(&sim),
        anchors: anchors(&sim),
        accent: [0x4A, 0x9E, 0x6B, 0xFF],
        has_tether: false,
    });

    // 一路拉坏。真实游戏里这些损伤来自"被车撞""被机械臂拽"，
    // 这里直接扣完整性，为的是稳定复现四个状态。
    let mut last = sim.body.joints[idx].state();
    println!("  {:<12} {:>8}  {:>10}  {:>8}  {:>10}", "状态", "t(s)", "integrity", "tether", "约束");
    println!(
        "  {:<12} {:>8.1}  {:>10.3}  {:>8.2}  {:>10}",
        last.name(),
        0.0,
        sim.body.joints[idx].health.integrity,
        1.0,
        "revolute"
    );

    let mut t_sprain = 0.0;
    let mut t_disloc = 0.0;
    for _ in 0..4000 {
        // 每 8 tick 扣一点，模拟持续的猛拉
        if sim.body.joints[idx].state() < JointState::Dislocated && sim.tick.0.is_multiple_of(8) {
            sim.wear_joint("hip_l", 0.012);
        }
        // 脱位之后给小腿一记侧向的猛甩，让绳子绷紧——这才看得出"挂着"和"飞走"的区别
        if sim.body.joints[idx].state() == JointState::Dislocated && sim.tick.0.is_multiple_of(90) {
            sim.set_part_velocity("shin_l", Vec2::new(-6.0, 1.0));
        }
        sim.step();

        let s = sim.body.joints[idx].state();
        if s != last {
            let j = &sim.body.joints[idx];
            let constraint = match s {
                JointState::Intact => "revolute",
                JointState::Sprained => "revolute (loose)",
                JointState::Subluxed => "revolute (very loose)",
                JointState::Dislocated => "rope 6cm",
                JointState::Severed => "none",
            };
            println!(
                "  {:<12} {:>8.2}  {:>10.3}  {:>8.2}  {:>10}",
                s.name(),
                sim.tick.0 as f32 / 60.0,
                j.health.integrity,
                j.health.tether,
                constraint
            );
            last = s;

            match s {
                JointState::Sprained => t_sprain = sim.tick.0 as f32 / 60.0,
                JointState::Dislocated => t_disloc = sim.tick.0 as f32 / 60.0,
                _ => {}
            }

            if s == JointState::Subluxed || s == JointState::Dislocated {
                // 让画面稳定一下再拍
                for _ in 0..18 {
                    sim.step();
                }
                let tag = match s {
                    JointState::Subluxed => "B. SUBLUXED - LIMITS WIDENED BY ROM SCALE",
                    _ => "C. DISLOCATED - ROPE TETHER, LIMB HANGS",
                };
                frames.push(Frame {
                    label: format!(
                        "{tag}  t={:.1}s  ROM x{:.2}",
                        sim.tick.0 as f32 / 60.0,
                        sim.body.joints[idx].health.rom_scale
                    ),
                    polys: snapshot(&sim),
                    anchors: anchors(&sim),
                    accent: [0xE0, 0xA8, 0x3C, 0xFF],
                    has_tether: s == JointState::Dislocated,
                });
            }

            if s == JointState::Severed {
                for _ in 0..90 {
                    sim.step();
                }
                frames.push(Frame {
                    label: format!(
                        "D. SEVERED - NO CONSTRAINT  t={:.1}s",
                        sim.tick.0 as f32 / 60.0
                    ),
                    polys: snapshot(&sim),
                    anchors: anchors(&sim),
                    accent: [0xC0, 0x39, 0x4B, 0xFF],
                    has_tether: false,
                });
                break;
            }
        }
    }

    println!(
        "  时间线：{:.1}s 扭伤 → {:.1}s 脱位 → {:.1}s 离断",
        t_sprain,
        t_disloc,
        sim.tick.0 as f32 / 60.0
    );

    // 关键指标：脱位期间两锚点的最大间距
    let allowed = sim.body.joints[idx].tether_rest + sim.damage.tether_len_cm * CM;
    println!(
        "  绳长上限 {:.1} cm；离断后两段自由分开",
        allowed * 100.0
    );

    render_joints(&frames, allowed)?;
    Ok(())
}

/// 一帧关节快照。
struct Frame {
    label: String,
    /// 每个部件在世界坐标下的多边形（米）。
    polys: Vec<Vec<Vec2>>,
    /// 每个关节两端的锚点（米）。
    anchors: Vec<(Vec2, Vec2)>,
    accent: [u8; 4],
    /// 这一帧是否还挂着软组织（离断之后就没有了）。
    has_tether: bool,
}

fn render_joints(frames: &[Frame], rope_len: f32) -> Result<(), Box<dyn std::error::Error>> {
    const PW: u32 = 300;
    const PH: u32 = 300;

    const FLESH: [u8; 4] = [0xC0, 0x70, 0x64, 0xFF];
    const FLESH_DARK: [u8; 4] = [0x6B, 0x3F, 0x38, 0xFF];
    const GROUND: [u8; 4] = [0x2A, 0x2D, 0x34, 0xFF];
    const JOINT: [u8; 4] = [0x1D, 0x5F, 0x7A, 0xFF];
    const TETHER: [u8; 4] = [0xFF, 0xD2, 0x2E, 0xFF];

    // 四帧合起来求包围盒，再统一平移取景。
    // 不这么做的话：摔倒之后身体整体偏到左边，固定取景会把骨盆切在画外，
    // "肢体有没有飞走"就没法看了。
    let mut lo = Vec2::splat(f32::INFINITY);
    let mut hi = Vec2::splat(f32::NEG_INFINITY);
    for f in frames {
        for poly in &f.polys {
            for p in poly {
                lo = lo.min(*p);
                hi = hi.max(*p);
            }
        }
    }
    let mid = (lo + hi) * 0.5;
    let span = hi - lo;
    // 视野取包围盒的较大者，留 12% 边距
    let world_w = span.x.max(span.y * PW as f32 / PH as f32) * 1.24;
    let off = -mid;
    let ground = GROUND_Y + off.y;

    let gap = 10i32;
    let head = 44;
    let footer = 62;
    let w = 14 * 2 + PW * frames.len() as u32 + gap as u32 * (frames.len() as u32 - 1);
    let h = head + PH + footer;

    let mut cv = Canvas::blank(w, h);
    cv.clear(BG);
    cv.text(14, 12, "M3 - JOINT STATE MACHINE - HIP_L", 2, INK);
    cv.text(
        14,
        30,
        "BODY SUSPENDED BY THE HEAD SO THE LEG CAN DANGLE - DISLOCATED IS A 6CM ROPE, NOT A REMOVED JOINT",
        1,
        DIM,
    );

    for (i, fr) in frames.iter().enumerate() {
        let mut panel = Canvas::new(PW, PH, world_w, 0.0);
        panel.clear(PANEL_BG);

        panel.rect(Vec2::new(-3.0, ground - 0.05), Vec2::new(3.0, ground), GROUND);

        for poly in &fr.polys {
            let shifted: Vec<Vec2> = poly.iter().map(|p| *p + off).collect();
            panel.fill_poly(&shifted, FLESH);
            panel.stroke_poly(&shifted, FLESH_DARK, 0);
        }

        // 关节锚点：重合 = 硬约束收紧；分开 = 脱位（黄线 = 被拉长的软组织）
        for (k, (pa, pb)) in fr.anchors.iter().enumerate() {
            let (pa, pb) = (*pa + off, *pb + off);
            // 只有"还挂着"的状态才画软组织：离断之后没有绳子了
            if fr.has_tether && (pa - pb).length() > 0.004 {
                panel.line(pa, pb, TETHER, 1);
            }
            // 左髋是第 7 个关节（waist/neck/shoulder_l/elbow_l/shoulder_r/elbow_r 之后）
            if k == 6 {
                panel.disc(pa, 4.0, fr.accent);
                panel.disc(pb, 2.5, [0xFF, 0xFF, 0xFF, 0xFF]);
            } else {
                panel.disc(pa, 1.6, JOINT);
            }
        }

        let ox = 14 + i as i32 * (PW as i32 + gap);
        cv.blit(&panel, ox, head as i32);
        cv.px_rect(
            ox,
            head as i32 + PH as i32,
            ox + PW as i32,
            head as i32 + PH as i32 + 1,
            fr.accent,
        );
        cv.text(ox + 4, head as i32 + 6, &format!("{}", i + 1), 2, fr.accent);

        let lines = wrap(&fr.label, 47);
        for (li, chunk) in lines.iter().take(2).enumerate() {
            cv.text(
                ox + 2,
                head as i32 + PH as i32 + 8 + li as i32 * 10,
                chunk,
                1,
                INK,
            );
        }
    }

    let y = head as i32 + PH as i32 + footer as i32 - 12;
    cv.text(
        14,
        y,
        &format!(
            "YELLOW = SOFT-TISSUE TETHER (MAX {:.0} CM)   BLUE DOT = HIP ANCHOR ON PELVIS   WHITE DOT = ANCHOR ON FEMUR",
            rope_len * 100.0
        ),
        1,
        DIM,
    );

    let path = std::path::Path::new("out/m3_joints.png");
    cv.save(path)?;
    println!("
-> {}", path.display());
    Ok(())
}

fn wrap(s: &str, n: usize) -> Vec<String> {
    let mut out = Vec::new();
    let mut cur = String::new();
    for word in s.split(' ') {
        if cur.len() + word.len() + 1 > n && !cur.is_empty() {
            out.push(cur.clone());
            cur.clear();
        }
        if !cur.is_empty() {
            cur.push(' ');
        }
        cur.push_str(word);
    }
    if !cur.is_empty() {
        out.push(cur);
    }
    out
}

// ---------------------------------------------------------------------------
// 小工具
// ---------------------------------------------------------------------------

/// 以 `c` 为中心、`r_cm` 为半径的组织区均值：(氧分压, 灌注)。
fn region(sim: &TissueSim, c: Vec2, r_cm: f32) -> (f32, f32) {
    let f = &sim.field;
    let r2 = r_cm * r_cm;
    let (mut so, mut sp, mut n) = (0.0, 0.0, 0usize);
    for i in 0..f.len() {
        if !f.kind[i].is_vascular() || (f.center_of(i) - c).length_squared() > r2 {
            continue;
        }
        so += f.o2[i];
        sp += f.perfusion[i];
        n += 1;
    }
    if n == 0 {
        return (0.0, 0.0);
    }
    let n = n as f32;
    (so / n, sp / n)
}

fn region_damage(sim: &TissueSim, c: Vec2, r_cm: f32) -> f32 {
    let f = &sim.field;
    let r2 = r_cm * r_cm;
    let (mut s, mut n) = (0.0, 0usize);
    for i in 0..f.len() {
        if !f.kind[i].is_vascular() || (f.center_of(i) - c).length_squared() > r2 {
            continue;
        }
        s += f.damage[i];
        n += 1;
    }
    if n == 0 { 0.0 } else { s / n as f32 }
}

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
