//! M1 验收演示：把人体切开，看碎片、面积守恒、结构求交。
//!
//! 用法：`cargo run -p anatomize-tools --bin cut_demo`
//!
//! 这个工具完全不碰物理引擎——切割是纯几何，这也是它能被 fuzz 的原因。

use anatomize_body::{ASSET_HUMAN_01, BodyPlan};
use anatomize_core::Vec2;
use anatomize_cut::{CutSegment, Line, SplitOutcome, split_convex};
use anatomize_tools::render::Canvas;

const W: u32 = 520;
const H: u32 = 620;
const WORLD_W: f32 = 1.2;
const CENTER_Y: f32 = -0.02;

const BG: [u8; 4] = [0xF4, 0xF1, 0xEA, 0xFF];
const OUTLINE: [u8; 4] = [0x6B, 0x3F, 0x38, 0xFF];
const VESSEL: [u8; 4] = [0xB3, 0x1D, 0x4E, 0xFF];
const HIT: [u8; 4] = [0xFF, 0xD2, 0x2E, 0xFF];

/// 碎片配色：刻意用跨色相，让"这里是断开的"一眼可见。
/// 组织色调（肉色系）反而看不出切痕，验收图需要的是可读性。
const PALETTE: [[u8; 4]; 6] = [
    [0x8F, 0xB8, 0xD0, 0xFF], // 天蓝
    [0xE8, 0xA8, 0x7C, 0xFF], // 蜜桃
    [0x9B, 0x8A, 0xC4, 0xFF], // 淡紫
    [0xD9, 0x8E, 0x9B, 0xFF], // 玫瑰
    [0x7F, 0xB0, 0x8E, 0xFF], // 鼠尾草
    [0xE0, 0xC0, 0x78, 0xFF], // 沙金
];

/// 一次切割，坐标写在**身体局部系（厘米）**，和 RON 一致。
struct Cut {
    part: &'static str,
    a: Vec2,
    b: Vec2,
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let plan = BodyPlan::from_ron(ASSET_HUMAN_01)?;

    let cuts = [
        Cut {
            part: "torso",
            a: Vec2::new(-22.0, 2.0),
            b: Vec2::new(18.0, 44.0),
        },
        Cut {
            part: "thigh_l",
            a: Vec2::new(-25.0, -25.0),
            b: Vec2::new(10.0, -25.0),
        },
        Cut {
            part: "upper_arm_r",
            a: Vec2::new(10.0, 33.0),
            b: Vec2::new(30.0, 20.0),
        },
    ];

    let mut canvas = Canvas::new(W, H, WORLD_W, CENTER_Y);
    canvas.clear(BG);

    println!("body_plan: {} | {} 部件", plan.id, plan.parts.len());

    let mut total_before = 0.0f32;
    let mut total_after = 0.0f32;
    let mut fragment_count = 0usize;

    for part in &plan.parts {
        // 部件局部多边形 → 迭代切开
        let mut frags: Vec<Vec<Vec2>> = vec![part.polygon.clone()];
        let mut applied = 0usize;

        for c in cuts.iter().filter(|c| c.part == part.name) {
            let a_local = c.a - part.offset;
            let b_local = c.b - part.offset;
            let Some(line) = Line::through(a_local, b_local) else {
                continue;
            };
            let mut next = Vec::with_capacity(frags.len() + 1);
            for f in frags {
                match split_convex(&f, &line) {
                    SplitOutcome::Split { left, right } => {
                        next.push(left);
                        next.push(right);
                    }
                    _ => next.push(f),
                }
            }
            frags = next;
            applied += 1;
        }

        let before: f32 = part.area;
        let after: f32 = frags
            .iter()
            .map(|f| anatomize_cut::signed_area(f).abs())
            .sum();

        if applied > 0 {
            println!(
                "  {:<12} 切 {:>2} 刀 -> {} 块 | 面积 {:.1} -> {:.1} cm²（误差 {:.4}%）",
                part.name,
                applied,
                frags.len(),
                before,
                after,
                ((after - before) / before).abs() * 100.0
            );
        }

        total_before += before;
        total_after += after;
        fragment_count += frags.len();

        // 画：碎片按调色板上色，位置回到身体坐标
        for (i, f) in frags.iter().enumerate() {
            let poly: Vec<Vec2> = f
                .iter()
                .map(|p| (*p + part.offset) * 0.01)
                .collect();
            canvas.fill_poly(&poly, PALETTE[i % PALETTE.len()]);
            canvas.stroke_poly(&poly, OUTLINE, 0);
        }
    }

    println!(
        "\n总计 {} 块碎片，整体面积 {:.1} -> {:.1} cm²（误差 {:.5}%）",
        fragment_count,
        total_before,
        total_after,
        ((total_after - total_before) / total_before).abs() * 100.0
    );

    // --- 结构求交：切口 × 血管折线 ---
    // 注意这里切到米制，和运行时一致
    let vessel = [
        Vec2::new(0.0, -0.05),
        Vec2::new(-0.08, -0.30),
        Vec2::new(-0.08, -0.62),
    ];
    let cut = CutSegment {
        a: Vec2::new(-0.25, -0.25),
        b: Vec2::new(0.10, -0.25),
        width: 0.002,
        speed: 1.0,
    };
    let hits = cut.crossings(&vessel);
    println!("\n结构求交：股动脉折线 vs 大腿切口 -> {} 处命中", hits.len());
    for h in &hits {
        println!(
            "  命中于段 {}  s={:.2}  ({:.3}, {:.3}) m",
            h.seg, h.s, h.point.x, h.point.y
        );
    }

    // 画血管与命中点（命中点先铺一圈深色底，再点亮色芯，保证任何底色上都看得见）
    for i in 0..vessel.len() - 1 {
        canvas.line(vessel[i], vessel[i + 1], VESSEL, 2);
    }
    for h in &hits {
        canvas.disc(h.point, 7.0, OUTLINE);
        canvas.disc(h.point, 4.5, HIT);
    }

    let path = std::path::Path::new("out/m1_cut.png");
    canvas.save(path)?;
    println!("\n-> {}", path.display());

    Ok(())
}
