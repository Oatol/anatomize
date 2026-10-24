//! M5 验收图：冷、饿、疼。
//!
//! 三个场景，三种时间尺度，三条不同的驱动链：
//!
//! - **冷** 环境 5°C → 组织场算皮肤温度 → L4 算热平衡 → 寒战 → 代谢率↑
//! - **饿** 500 kcal → 胃 → 小肠 → 血糖 → 胰岛素 → 摄取
//! - **疼** 冲量 → 关节过伸 → 磨损 → 疼痛 → 肌张力↓ → 姿态变形
//!
//! ```text
//! cargo run --release -p anatomize-tools --bin m5_demo
//! cargo run --release -p anatomize-tools --bin m5_demo -- --lang en
//! ```
//!
//! 输出 `docs/m5_cold_food_pain.png`。

use anatomize_body::{ASSET_HUMAN_01, BodyPlan};
use anatomize_core::{Lang, Tick, UiConfig, Vec2};
use anatomize_physio::{Physio, PhysioInput};
use anatomize_sim::{Sim, build_tissue};
use anatomize_tissue::{TissueConfig, TissueSim};
use anatomize_tools::i18n::{Key, t};
use anatomize_tools::render::Canvas;
use anatomize_tools::text::TextRenderer;

const W: u32 = 1500;
const H: u32 = 1150;
const GROUND: f32 = -80.0;

const INK: [u8; 4] = [232, 236, 244, 255];
const DIM: [u8; 4] = [138, 148, 166, 255];
const FAINT: [u8; 4] = [92, 100, 118, 255];
const GRID: [u8; 4] = [44, 49, 60, 255];

const COLD: [u8; 4] = [110, 180, 255, 255];
const WARM: [u8; 4] = [235, 120, 90, 255];
const FOOD: [u8; 4] = [250, 190, 70, 255];
const PAIN: [u8; 4] = [235, 82, 82, 255];

/// 一行采样。三个场景各填自己关心的字段。
#[derive(Clone, Copy, Default)]
struct Row {
    t: f32,
    core: f32,
    skin: f32,
    shiver: f32,
    glucose: f32,
    insulin: f32,
    knee: f32,
    knee_target: f32,
    pain: f32,
}

struct Scene {
    name: Key,
    x_max: f32,
    rows: Vec<Row>,
}

// ---------------------------------------------------------------------------
// 场景 A：冷
// ---------------------------------------------------------------------------

fn scene_cold() -> Scene {
    let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
    let cfg = TissueConfig::asset();
    let mut tissue = build_tissue(&plan, &cfg);
    let mut physio = Physio::asset();
    tissue.warmup(physio.bus.map);
    let metab_base = tissue.cfg.metab_heat;
    let ambient = 5.0;

    let mut tick = Tick(0);
    let mut rows = Vec::new();
    let step = |tissue: &mut TissueSim, physio: &mut Physio, tick: &mut Tick| {
        tissue.cfg.ambient_c = ambient;
        tissue.cfg.metab_heat = metab_base * physio.bus.metab_scale;
        tissue.cfg.blood_c = physio.bus.temp_core;
        tissue.step(physio.bus.map, 1.0);
        let input = PhysioInput {
            hemorrhage_ml_s: 0.0,
            tissue_o2: Some(tissue.step.mean_o2),
            skin_temp: Some(tissue.step.skin_temp),
            ambient_c: ambient,
        };
        for _ in 0..60 {
            tick.advance();
            physio.step(input, *tick);
        }
    };

    for s in 0..=1800 {
        step(&mut tissue, &mut physio, &mut tick);
        if s % 10 == 0 {
            let b = physio.bus;
            rows.push(Row {
                t: s as f32,
                core: b.temp_core,
                skin: tissue.step.skin_temp,
                shiver: b.shiver,
                ..Row::default()
            });
        }
    }

    let b = physio.bus;
    println!(
        "[冷] 5°C 30 分钟：核心 {:.2}°C，皮肤 {:.2}°C，寒战 {:.2}，代谢率 ×{:.2}，热平衡 {:.0} W",
        b.temp_core, tissue.step.skin_temp, b.shiver, b.metab_scale, b.heat_balance_w
    );
    Scene {
        name: Key::SceneColdName,
        x_max: 1800.0,
        rows,
    }
}

// ---------------------------------------------------------------------------
// 场景 B：饿
// ---------------------------------------------------------------------------

fn scene_feed() -> Scene {
    let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
    let cfg = TissueConfig::asset();
    let mut tissue = build_tissue(&plan, &cfg);
    let mut physio = Physio::asset();
    tissue.warmup(physio.bus.map);

    let mut tick = Tick(0);
    let mut rows = Vec::new();
    let advance = |physio: &mut Physio, tick: &mut Tick| {
        let input = PhysioInput {
            hemorrhage_ml_s: 0.0,
            tissue_o2: Some(40.0),
            skin_temp: Some(32.0),
            ambient_c: 22.0,
        };
        for _ in 0..60 {
            tick.advance();
            physio.step(input, *tick);
        }
    };

    // 先空腹 10 分钟稳住基线
    for _ in 0..600 {
        advance(&mut physio, &mut tick);
    }
    let base = physio.bus.glucose;
    let mmol = physio.feed(500.0);
    println!("[饿] 500 kcal → {mmol:.0} mmol 葡萄糖当量，基线 {base:.2} mmol/L");

    let mut peak = base;
    let mut peak_at = 0.0f32;
    for s in 0..=7200 {
        advance(&mut physio, &mut tick);
        let b = physio.bus;
        if b.glucose > peak {
            peak = b.glucose;
            peak_at = s as f32;
        }
        if s % 30 == 0 {
            rows.push(Row {
                t: s as f32,
                glucose: b.glucose,
                insulin: b.insulin,
                ..Row::default()
            });
        }
    }
    let at30 = rows
        .iter()
        .find(|r| r.t >= 1800.0)
        .map(|r| r.glucose)
        .unwrap_or(f32::NAN);
    println!(
        "[饿] 峰值 {peak:.2} @ {:.0} 分钟，30 分钟 {at30:.2}，120 分钟 {:.2}",
        peak_at / 60.0,
        physio.bus.glucose
    );

    Scene {
        name: Key::SceneFeedName,
        x_max: 7200.0,
        rows,
    }
}

// ---------------------------------------------------------------------------
// 场景 C：疼
// ---------------------------------------------------------------------------

fn scene_hammer() -> Scene {
    let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
    let mut sim = Sim::spawn(plan, Vec2::new(0.0, 40.0), GROUND);
    sim.attach_tissue(&TissueConfig::asset());
    sim.set_part_fixed("head", true);
    for _ in 0..240 {
        sim.step();
    }

    sim.enable_posture();
    for _ in 0..240 {
        sim.step();
    }
    let knee = sim.joint_index("knee_l").unwrap();
    let targets = sim.creatures[sim.active].posture.as_ref().unwrap().targets.clone();
    let knee_target = targets[knee];
    sim.disable_posture();

    let mut rows = Vec::new();
    let mut frame = 0u32;
    let record = |sim: &Sim, t: f32, rows: &mut Vec<Row>| {
        rows.push(Row {
            t,
            knee: sim.joint_load(knee).angle,
            knee_target,
            pain: sim.body.joints[knee].health.pain,
            ..Row::default()
        });
    };

    // 前 1 秒不碰它，画一条基线
    for _ in 0..60 {
        sim.step();
        frame += 1;
        record(&sim, frame as f32 / 60.0, &mut rows);
    }

    let mut log = Vec::new();
    for _ in 0..5 {
        sim.strike_part("shin_l", Vec2::new(70.0, 0.0), Vec2::new(0.0, -20.0));
        for _ in 0..120 {
            sim.step();
            frame += 1;
            record(&sim, frame as f32 / 60.0, &mut rows);
        }
        let h = &sim.body.joints[knee].health;
        log.push(format!(
            "{:?}/i={:.2}/p={:.2}",
            h.state, h.integrity, h.pain
        ));
    }
    println!("[疼] 锤 5 次：{}", log.join(" → "));

    // 受伤后把姿态控制器打开、套回健康时的目标，看它拉不拉得住
    sim.enable_posture();
    sim.creatures[sim.active].posture.as_mut().unwrap().targets = targets;
    for _ in 0..240 {
        sim.step();
        frame += 1;
        record(&sim, frame as f32 / 60.0, &mut rows);
    }

    let h = sim.body.joints[knee].health;
    let tilt = sim.part_angle("torso").unwrap_or(0.0).to_degrees();
    println!(
        "[疼] 终态 {:?}，integrity {:.2}，疼痛 {:.2}，躯干倾角 {tilt:.1}°",
        h.state, h.integrity, h.pain
    );

    Scene {
        name: Key::SceneHammerName,
        x_max: (frame as f32 / 60.0).ceil(),
        rows,
    }
}

// ---------------------------------------------------------------------------
// 画图
// ---------------------------------------------------------------------------

/// 把任意步长凑成 1/2/5 × 10^n。坐标轴上一堆 3.25 这种刻度是没法看的。
fn nice_step(raw: f32) -> f32 {
    let raw = raw.max(1.0);
    let mag = 10f32.powf(raw.log10().floor());
    let n = raw / mag;
    let m = if n <= 1.0 {
        1.0
    } else if n <= 2.0 {
        2.0
    } else if n <= 5.0 {
        5.0
    } else {
        10.0
    };
    m * mag
}

struct Line {
    color: [u8; 4],
    get: fn(&Row) -> f32,
}

struct Panel {
    title: Key,
    unit: Key,
    lo: f32,
    hi: f32,
    ticks: &'static [f32],
    lines: &'static [Line],
}

struct Chart<'a> {
    x0: i32,
    y0: i32,
    w: i32,
    h: i32,
    scene: &'a Scene,
}

impl Chart<'_> {
    fn px(&self, t: f32, v: f32, lo: f32, hi: f32) -> (i32, i32) {
        let fx = (t / self.scene.x_max).clamp(0.0, 1.0);
        let fy = ((v - lo) / (hi - lo)).clamp(0.0, 1.0);
        (
            self.x0 + (fx * self.w as f32) as i32,
            self.y0 + self.h - (fy * self.h as f32) as i32,
        )
    }

    fn draw(&self, cv: &mut Canvas, tr: &TextRenderer, lang: Lang, p: &Panel) {
        let decimals = if p.hi - p.lo <= 3.0 { 1 } else { 0 };
        for v in p.ticks {
            let (_, y) = self.px(0.0, *v, p.lo, p.hi);
            cv.line_px((self.x0, y), (self.x0 + self.w, y), GRID, 0);
            tr.draw_right(
                cv,
                self.x0 - 10,
                y - 8,
                &format!("{v:.*}", decimals),
                13.0,
                DIM,
            );
        }
        // x 轴：挑一个"好看"的步长（1/2/5 × 10^n），大约 5 个刻度
        let step = nice_step(self.scene.x_max / 5.0);
        let mut x = 0.0;
        while x <= self.scene.x_max + 0.5 {
            let (px, _) = self.px(x, p.lo, p.lo, p.hi);
            cv.line_px((px, self.y0), (px, self.y0 + self.h), GRID, 0);
            let s = format!("{x:.0}");
            let w = tr.width(&s, 13.0);
            tr.draw(cv, px - w / 2, self.y0 + self.h + 6, &s, 13.0, DIM);
            x += step;
        }

        cv.line_px((self.x0, self.y0), (self.x0 + self.w, self.y0), FAINT, 1);
        cv.line_px(
            (self.x0, self.y0 + self.h),
            (self.x0 + self.w, self.y0 + self.h),
            FAINT,
            1,
        );
        cv.line_px((self.x0, self.y0), (self.x0, self.y0 + self.h), FAINT, 1);

        tr.draw(cv, self.x0, self.y0 - 24, t(lang, p.title), 15.0, INK);
        let tw = tr.width(t(lang, p.title), 15.0);
        tr.draw(
            cv,
            self.x0 + tw + 12,
            self.y0 - 22,
            t(lang, p.unit),
            12.0,
            DIM,
        );

        for line in p.lines {
            for w in self.scene.rows.windows(2) {
                let a = self.px(w[0].t, (line.get)(&w[0]), p.lo, p.hi);
                let b = self.px(w[1].t, (line.get)(&w[1]), p.lo, p.hi);
                cv.line_px(a, b, line.color, 1);
            }
        }
    }
}

const LINES_CORE: [Line; 2] = [
    Line {
        color: WARM,
        get: |r| r.core,
    },
    Line {
        color: COLD,
        get: |r| r.skin,
    },
];
const LINES_SHIVER: [Line; 1] = [Line {
    color: COLD,
    get: |r| r.shiver,
}];
const LINES_GLUCOSE: [Line; 1] = [Line {
    color: FOOD,
    get: |r| r.glucose,
}];
const LINES_INSULIN: [Line; 1] = [Line {
    color: FOOD,
    get: |r| r.insulin,
}];
const LINES_KNEE: [Line; 2] = [
    Line {
        color: PAIN,
        get: |r| r.knee,
    },
    Line {
        color: FAINT,
        get: |r| r.knee_target,
    },
];
const LINES_PAIN: [Line; 1] = [Line {
    color: PAIN,
    get: |r| r.pain,
}];

fn main() {
    let lang = UiConfig::resolve();
    let tr = TextRenderer::system();
    let lang = if !tr.has_cjk() && lang == Lang::Zh {
        println!("警告：{}", t(Lang::Zh, Key::M4NoFont));
        Lang::En
    } else {
        lang
    };
    println!("界面语言：{}（字体 {}）\n", lang.native_name(), tr.source);

    println!("=== M5：冷、饿、疼 ===");
    let cold = scene_cold();
    let feed = scene_feed();
    let pain = scene_hammer();

    let mut cv = Canvas::blank(W, H);
    cv.clear([18, 20, 26, 255]);
    tr.draw(&mut cv, 40, 24, t(lang, Key::M5Title), 26.0, INK);
    tr.draw(&mut cv, 40, 66, t(lang, Key::M5Subtitle), 15.0, DIM);

    // 场景名 + 两个子图
    let bands = [&cold, &feed, &pain];
    let specs: [[Panel; 2]; 3] = [
        [
            Panel {
                title: Key::PanelCoreTemp,
                unit: Key::UnitCelsius,
                lo: 34.8,
                hi: 37.6,
                ticks: &[35.0, 36.0, 37.0],
                lines: &LINES_CORE,
            },
            Panel {
                title: Key::PanelShiver,
                unit: Key::Unit01,
                lo: 0.0,
                hi: 1.05,
                ticks: &[0.0, 0.5, 1.0],
                lines: &LINES_SHIVER,
            },
        ],
        [
            Panel {
                title: Key::PanelGlucose,
                unit: Key::UnitMm,
                lo: 4.0,
                hi: 8.0,
                ticks: &[4.0, 5.0, 6.0, 7.0],
                lines: &LINES_GLUCOSE,
            },
            Panel {
                title: Key::PanelInsulin,
                unit: Key::Unit01,
                lo: 0.0,
                hi: 1.6,
                ticks: &[0.0, 0.5, 1.0, 1.5],
                lines: &LINES_INSULIN,
            },
        ],
        [
            Panel {
                title: Key::PanelKnee,
                unit: Key::UnitRad,
                lo: -0.3,
                hi: 0.9,
                ticks: &[-0.2, 0.2, 0.6],
                lines: &LINES_KNEE,
            },
            Panel {
                title: Key::PanelPain,
                unit: Key::Unit01,
                lo: 0.0,
                hi: 1.05,
                ticks: &[0.0, 0.5, 1.0],
                lines: &LINES_PAIN,
            },
        ],
    ];

    let band_h = 232;
    let gap = 74;
    let top = 152;
    for (i, scene) in bands.iter().enumerate() {
        let y = top + i as i32 * (band_h + gap);
        tr.draw(&mut cv, 40, y + band_h / 2 - 10, t(lang, scene.name), 16.0, INK);

        for (j, panel) in specs[i].iter().enumerate() {
            let ch = Chart {
                x0: 240 + j as i32 * 610,
                y0: y,
                w: 560,
                h: band_h,
                scene,
            };
            ch.draw(&mut cv, &tr, lang, panel);
        }
    }

    // 底部说明
    let y = H as i32 - 56;
    tr.draw(&mut cv, 40, y, t(lang, Key::M5Footer1), 14.0, DIM);
    tr.draw(&mut cv, 40, y + 24, t(lang, Key::M5Footer2), 14.0, DIM);

    let avail = W as i32 - 80;
    println!(
        "\n版面自检（可用宽度 {avail}px）：标题 {} 副标题 {} 底注 {} {}",
        tr.width(t(lang, Key::M5Title), 26.0),
        tr.width(t(lang, Key::M5Subtitle), 15.0),
        tr.width(t(lang, Key::M5Footer1), 14.0),
        tr.width(t(lang, Key::M5Footer2), 14.0),
    );
    for k in [Key::M5Footer1, Key::M5Footer2, Key::M5Subtitle] {
        let w = tr.width(t(lang, k), 14.0);
        assert!(w < avail, "{k:?} 超宽：{w} > {avail}");
    }

    let path = std::path::Path::new("docs/m5_cold_food_pain.png");
    cv.save(path).expect("写 PNG 失败");
    println!("\n已写出 {}", path.display());
}
