//! M0 验收工具：headless 跑一具 ragdoll，打印稳定性指标，并渲染若干帧。
//!
//! 用法：
//!     cargo run -p anatomize-tools --bin ragdoll
//!
//! 输出：`out/ragdoll_<tick>.png`，以及终端的关节间隙/能量/速度统计。

mod render;

use anatomize_body::{ASSET_HUMAN_01, BodyPlan};
use anatomize_core::Vec2;
use anatomize_sim::Sim;
use render::Canvas;

const W: u32 = 480;
const H: u32 = 480;
const WORLD_WIDTH: f32 = 2.0; // 视野 2 米宽
const GROUND_Y: f32 = -0.66;

const BG: [u8; 4] = [0xF4, 0xF1, 0xEA, 0xFF];
const GROUND: [u8; 4] = [0xD3, 0xD1, 0xC7, 0xFF];
const GROUND_LINE: [u8; 4] = [0x88, 0x87, 0x80, 0xFF];
const FLESH: [u8; 4] = [0xC0, 0x70, 0x64, 0xFF];
const FLESH_DARK: [u8; 4] = [0x7A, 0x4A, 0x42, 0xFF];
const JOINT: [u8; 4] = [0x1D, 0x5F, 0x7A, 0xFF];

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let plan = BodyPlan::from_ron(ASSET_HUMAN_01)?;
    println!(
        "body_plan: {} | {} 部件 / {} 关节 / {:.1} kg",
        plan.id,
        plan.parts.len(),
        plan.joints.len(),
        plan.total_mass()
    );

    let mut sim = Sim::spawn(plan, Vec2::new(0.0, 0.35), GROUND_Y);
    sim.nudge(Vec2::new(0.6, 0.0));

    let shots = [0u64, 15, 30, 60, 120, 300, 600];
    let mut canvas = Canvas::new(W, H, WORLD_WIDTH, 0.15);

    for tick in 0..=600u64 {
        if shots.contains(&tick) {
            draw(&mut canvas, &sim);
            let path = format!("out/ragdoll_{tick:04}.png");
            canvas.save(std::path::Path::new(&path))?;
            println!("  frame {tick:>4} -> {path}");
        }
        if tick % 60 == 0 {
            let d = sim.diagnostics();
            println!(
                "t={:>4}  gap(max)={:>8.4} mm  gap(mean)={:>7.4} mm  KE={:>8.3} J  vmax={:>6.3} m/s  nan={}",
                d.tick,
                d.max_joint_gap * 1000.0,
                d.mean_joint_gap * 1000.0,
                d.kinetic_energy,
                d.max_speed,
                d.nan
            );
        }
        sim.step();
    }

    let d = sim.diagnostics();
    println!("\n=== M0 判定 ===");
    println!(
        "关节最大间隙 {:.3} mm（阈值 2.0 mm）-> {}",
        d.max_joint_gap * 1000.0,
        if d.max_joint_gap < 0.002 {
            "PASS"
        } else {
            "FAIL"
        }
    );
    println!(
        "末态动能 {:.4} J（阈值 0.05 J，说明已静止）-> {}",
        d.kinetic_energy,
        if d.kinetic_energy < 0.05 {
            "PASS"
        } else {
            "FAIL"
        }
    );
    println!("无 NaN -> {}", if d.nan { "FAIL" } else { "PASS" });
    println!(
        "最大速度 {:.3} m/s（阈值 50 m/s）-> {}",
        d.max_speed,
        if d.max_speed < 50.0 { "PASS" } else { "FAIL" }
    );

    Ok(())
}

fn draw(canvas: &mut Canvas, sim: &Sim) {
    canvas.clear(BG);

    // 地面
    canvas.rect(
        Vec2::new(-1.0, GROUND_Y - 0.06),
        Vec2::new(1.0, GROUND_Y),
        GROUND,
    );
    canvas.line(
        Vec2::new(-1.0, GROUND_Y),
        Vec2::new(1.0, GROUND_Y),
        GROUND_LINE,
        0,
    );

    // 部件
    for part in &sim.plan.parts {
        let poly = sim.part_polygon(part.id);
        canvas.fill_poly(&poly, FLESH);
        canvas.stroke_poly(&poly, FLESH_DARK, 0);
    }

    // 关节：两端锚点各画一个点，重合说明约束收紧
    for j in &sim.body.joints {
        let (pa, pb) = sim.joint_world_anchors(j);
        canvas.disc(pa, 2.0, JOINT);
        canvas.disc(pb, 1.2, [0xFF, 0xFF, 0xFF, 0xFF]);
    }
}
