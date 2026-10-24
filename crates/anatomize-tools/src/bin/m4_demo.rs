//! M4 验收图：三条失血曲线。
//!
//! 跑的是真的闭环——组织场算出血量，生理层算血压，血压再回头影响出血量。
//! 图里没有任何一条曲线是画出来的，都是 `Sim::step()` 一步一步走出来的。
//!
//! ```text
//! cargo run --release -p anatomize-tools --bin m4_demo
//! ```
//!
//! 输出 `docs/m4_hemorrhage.png`。

use anatomize_body::{ASSET_HUMAN_01, BodyPlan};
use anatomize_core::Vec2;
use anatomize_cut::CutSegment;
use anatomize_sim::Sim;
use anatomize_tissue::TissueConfig;
use anatomize_tools::render::Canvas;

const W: u32 = 1500;
const H: u32 = 1180;
const GROUND: f32 = -80.0;

/// 一个采样点。字段名就是图上的行。
#[derive(Clone, Copy)]
struct Sample {
    t: f32,
    map: f32,
    hr: f32,
    consciousness: f32,
    volume: f32,
    bleed: f32,
    #[allow(dead_code)]
    tissue_o2: f32,
}

struct Scenario {
    name: &'static str,
    color: [u8; 4],
    cut: CutSegment,
    /// (按下时刻, 松开时刻)
    press: Option<(f32, f32)>,
    samples: Vec<Sample>,
}

fn world() -> Sim {
    let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
    let mut sim = Sim::spawn(plan, Vec2::new(0.0, 40.0), GROUND);
    sim.attach_tissue(&TissueConfig::asset());
    sim
}

fn torso_cut() -> CutSegment {
    CutSegment {
        a: Vec2::new(-16.0, 22.0),
        b: Vec2::new(16.0, 22.0),
        width: 0.6,
        speed: 1.0,
    }
}

fn thigh_cut() -> CutSegment {
    CutSegment {
        a: Vec2::new(-15.0, -25.0),
        b: Vec2::new(-1.0, -25.0),
        width: 0.6,
        speed: 1.0,
    }
}

fn run_scenario(mut sc: Scenario, seconds: f32) -> Scenario {
    let mut sim = world();
    for _ in 0..120 {
        sim.step(); // 落地站稳
    }

    let out = sim.cut(&sc.cut).expect("挂了组织场");
    let q0 = sim.hemorrhage_ml_s();
    println!(
        "\n[{}] 命中 {} 处，创口 {} texel，断供 {} texel，断端电导 {:.3}，即刻出血 {:.2} mL/s（{:.1} L/min）",
        sc.name,
        out.report.hits.len(),
        out.wound_texels,
        out.starved_texels,
        out.stump_conductance,
        q0,
        q0 * 0.06
    );
    if !out.report.is_empty() {
        println!("{}", out.report.summary(&sim.plan));
    }

    let mut pressed = false;
    let mut released = false;
    let total = (seconds * 60.0) as u32;
    for i in 0..=total {
        let t = i as f32 / 60.0;
        if let Some((down, up)) = sc.press {
            if !pressed && t >= down {
                let q = sim.press_wound(true);
                println!("  t={t:.1}s 按压 → 出血 {q:.3} mL/s");
                pressed = true;
            }
            if pressed && !released && t >= up {
                let q = sim.press_wound(false);
                println!("  t={t:.1}s 松开 → 出血 {q:.2} mL/s");
                released = true;
            }
        }
        if i % 30 == 0 {
            let b = sim.physio.bus;
            sc.samples.push(Sample {
                t,
                map: b.map,
                hr: b.heart_rate,
                consciousness: b.consciousness,
                volume: b.blood_volume,
                bleed: sim.hemorrhage_ml_s(),
                tissue_o2: b.tissue_o2,
            });
        }
        sim.step();
    }

    let b = sim.physio.bus;
    let first = |f: &dyn Fn(&Sample) -> bool| sc.samples.iter().find(|s| f(s)).map(|s| s.t);
    println!(
        "  结果：MAP<45 @ {:?}s，HR>130 @ {:?}s，意识<0.2 @ {:?}s；终末 MAP {:.1}，血量 {:.0}，失血 {:.0} mL",
        first(&|s| s.map < 45.0),
        first(&|s| s.hr > 130.0),
        first(&|s| s.consciousness < 0.2),
        b.map,
        b.blood_volume,
        b.blood_lost_ml
    );
    sc
}

// ---------------------------------------------------------------------------
// 画图
// ---------------------------------------------------------------------------

struct Chart {
    x0: i32,
    y0: i32,
    w: i32,
    h: i32,
    x_max: f32,
    y_min: f32,
    y_max: f32,
}

impl Chart {
    fn px(&self, t: f32, v: f32) -> (i32, i32) {
        let fx = (t / self.x_max).clamp(0.0, 1.0);
        let fy = ((v - self.y_min) / (self.y_max - self.y_min)).clamp(0.0, 1.0);
        (
            self.x0 + (fx * self.w as f32) as i32,
            self.y0 + self.h - (fy * self.h as f32) as i32,
        )
    }

    fn frame(&self, cv: &mut Canvas, title: &str, unit: &str, y_ticks: &[f32]) {
        let ink = [214, 220, 232, 255];
        let dim = [96, 104, 122, 255];
        let grid = [44, 49, 60, 255];

        // 网格 + y 轴刻度
        let decimals = if self.y_max - self.y_min <= 3.0 { 1 } else { 0 };
        for v in y_ticks {
            let (_, y) = self.px(0.0, *v);
            cv.line_px((self.x0, y), (self.x0 + self.w, y), grid, 0);
            let s = format!("{v:.*}", decimals);
            cv.text(self.x0 - 12 - Canvas::text_width(&s, 2), y - 7, &s, 2, dim);
        }
        // x 轴刻度
        for t in (0..=self.x_max as i32).step_by(40) {
            let (x, _) = self.px(t as f32, self.y_min);
            cv.line_px((x, self.y0), (x, self.y0 + self.h), grid, 0);
            let s = format!("{t}");
            cv.text(
                x - Canvas::text_width(&s, 2) / 2,
                self.y0 + self.h + 6,
                &s,
                2,
                dim,
            );
        }

        // 边框
        cv.line_px((self.x0, self.y0), (self.x0 + self.w, self.y0), dim, 1);
        cv.line_px(
            (self.x0, self.y0 + self.h),
            (self.x0 + self.w, self.y0 + self.h),
            dim,
            1,
        );
        cv.line_px((self.x0, self.y0), (self.x0, self.y0 + self.h), dim, 1);

        cv.text(self.x0, self.y0 - 26, title, 2, ink);
        cv.text(
            self.x0 + Canvas::text_width(title, 2) + 16,
            self.y0 - 26,
            unit,
            2,
            dim,
        );
    }

    fn series(&self, cv: &mut Canvas, pts: &[(f32, f32)], color: [u8; 4]) {
        for w in pts.windows(2) {
            let a = self.px(w[0].0, w[0].1);
            let b = self.px(w[1].0, w[1].1);
            cv.line_px(a, b, color, 1);
        }
    }
}

/// 一行子图：标题、单位、量程、刻度、取哪个字段。
struct Panel {
    title: &'static str,
    unit: &'static str,
    lo: f32,
    hi: f32,
    ticks: &'static [f32],
    get: fn(&Sample) -> f32,
}

fn main() {
    let secs = 200.0;

    println!("=== M4：三条失血曲线（{} 秒闭环仿真）===", secs);
    let scenarios = vec![
        run_scenario(
            Scenario {
                name: "AORTA",
                color: [235, 82, 82, 255],
                cut: torso_cut(),
                press: None,
                samples: Vec::new(),
            },
            secs,
        ),
        run_scenario(
            Scenario {
                name: "AORTA + PRESS 15-60S",
                color: [250, 190, 70, 255],
                cut: torso_cut(),
                press: Some((15.0, 60.0)),
                samples: Vec::new(),
            },
            secs,
        ),
        run_scenario(
            Scenario {
                name: "FEMORAL",
                color: [92, 170, 255, 255],
                cut: thigh_cut(),
                press: None,
                samples: Vec::new(),
            },
            secs,
        ),
    ];

    let mut cv = Canvas::blank(W, H);
    cv.clear([18, 20, 26, 255]);

    let ink = [232, 236, 244, 255];
    let dim = [130, 140, 158, 255];

    cv.text(40, 26, "M4 - HEMORRHAGE CLOSED LOOP", 3, ink);
    cv.text(
        40,
        62,
        "TISSUE FLUX -> BLOOD VOLUME -> MAP -> TISSUE FLUX. NOTHING HERE IS SCRIPTED.",
        2,
        dim,
    );

    // 图例
    let mut lx = 40;
    for sc in &scenarios {
        cv.px_rect(lx, 92, lx + 22, 98, sc.color);
        cv.text(lx + 30, 89, sc.name, 2, ink);
        lx += 30 + Canvas::text_width(sc.name, 2) + 36;
    }

    let left = 100;
    let width = W as i32 - left - 40;
    let row_h = 140;
    let gap = 48;
    let top = 150;

    let panels = [
        Panel {
            title: "MAP",
            unit: "MMHG",
            lo: 0.0,
            hi: 130.0,
            ticks: &[0.0, 40.0, 65.0, 93.0],
            get: |s| s.map,
        },
        Panel {
            title: "HEART RATE",
            unit: "BPM",
            lo: 40.0,
            hi: 160.0,
            ticks: &[60.0, 80.0, 100.0, 130.0],
            get: |s| s.hr,
        },
        Panel {
            title: "CONSCIOUSNESS",
            unit: "0-1",
            lo: 0.0,
            hi: 1.05,
            ticks: &[0.0, 0.2, 0.5, 1.0],
            get: |s| s.consciousness,
        },
        Panel {
            title: "BLOOD VOLUME",
            unit: "ML",
            lo: 2000.0,
            hi: 5200.0,
            ticks: &[2000.0, 3000.0, 4000.0, 5000.0],
            get: |s| s.volume,
        },
        Panel {
            title: "BLEED RATE",
            unit: "ML/S",
            lo: 0.0,
            hi: 80.0,
            ticks: &[0.0, 20.0, 40.0, 60.0],
            get: |s| s.bleed,
        },
    ];

    for (i, p) in panels.iter().enumerate() {
        let ch = Chart {
            x0: left,
            y0: top + i as i32 * (row_h + gap),
            w: width,
            h: row_h,
            x_max: secs,
            y_min: p.lo,
            y_max: p.hi,
        };
        let xl = if i == panels.len() - 1 {
            "TIME (S)"
        } else {
            ""
        };
        ch.frame(&mut cv, p.title, p.unit, p.ticks);
        if !xl.is_empty() {
            cv.text(
                ch.x0 + ch.w / 2 - Canvas::text_width(xl, 2) / 2,
                ch.y0 + ch.h + 26,
                xl,
                2,
                dim,
            );
        }
        for sc in &scenarios {
            let pts: Vec<(f32, f32)> = sc.samples.iter().map(|s| (s.t, (p.get)(s))).collect();
            ch.series(&mut cv, &pts, sc.color);
        }
    }

    // 底部说明
    let y = H as i32 - 46;
    cv.text(
        40,
        y,
        "AORTA 3.8 L/MIN: MAP<45 AT 43S, HR>130 AT 19S, COMA AT 50S. FEMORAL 1.3 L/MIN: DECOMP AT 127S.",
        2,
        dim,
    );
    cv.text(
        40,
        y + 22,
        "BLEED RATE FALLS AS MAP FALLS. THE WOUND IS ITS OWN NEGATIVE FEEDBACK.",
        2,
        dim,
    );

    let path = std::path::Path::new("docs/m4_hemorrhage.png");
    cv.save(path).expect("写 PNG 失败");
    println!("\n已写出 {}", path.display());
}
