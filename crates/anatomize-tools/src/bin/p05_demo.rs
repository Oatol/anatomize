//! P0.5 验收图：回溯 + 参数扫描。
//!
//! 输出 `docs/p05_rewind_scan.png`：
//!
//! | 面板 | 内容 |
//! |---|---|
//! | 上排三帧 | 切之前 → 两刀之后 3 秒 → 回滚 3 秒 |
//! | 左下 | 二维扫描热图（tone_max × 血容量 → 失代偿时刻） |
//! | 右下 | 关键数字 |
//!
//! 上排三帧的说服力在于：**第 3 帧和第 1 帧应该长得一模一样**。
//! 如果回滚只是把数值抄回去、组织场没跟着回去，第 3 帧会带着第 2 帧的创口。

use anatomize_body::{ASSET_HUMAN_01, BodyPlan};
use anatomize_core::{Lang, UiConfig, Vec2};
use anatomize_cut::CutSegment;
use anatomize_sim::Sim;
use anatomize_tissue::TissueConfig;
use anatomize_tools::i18n::{Key, t};
use anatomize_tools::paint::{HeatChannel, paint_heatmap, paint_pieces};
use anatomize_tools::render::Canvas;
use anatomize_tools::text::TextRenderer;

const W: u32 = 1720;
const H: u32 = 1240;
const GROUND: f32 = -80.0;

const BG: [u8; 4] = [18, 17, 22, 255];
const PANEL: [u8; 4] = [26, 25, 32, 255];
const FRAME: [u8; 4] = [58, 56, 70, 255];
const TEXT: [u8; 4] = [232, 230, 238, 255];
const DIM: [u8; 4] = [140, 137, 152, 255];
const HOT: [u8; 4] = [232, 92, 92, 255];

fn main() {
    let lang = UiConfig::resolve();
    let tr = TextRenderer::system();
    let lang = if !tr.has_cjk() && lang == Lang::Zh {
        Lang::En
    } else {
        lang
    };

    let mut cv = Canvas::blank(W, H);
    cv.clear(BG);

    // ------------------------------------------------------------ 上排三帧
    let mut sim = world();
    let vol_before = sim.creatures[sim.active].physio.bus.blood_volume;
    let pieces_before = sim.body.pieces.len();

    // 帧 1：切之前
    let frame1 = shot(&sim, 1.55);
    // 两刀 + 断两条关节。
    //
    // **只切不断是看不出散架的**：切开大腿之后，上半块还连着髋、下半块还连着膝，
    // 两个 revolute 关节把它们夹在原地，只能错开几毫米——实测像素差 0.25%，
    // 图上几乎看不出区别。这不是 bug，是正确的物理：切开 ≠ 散架。
    // 所以这里同时断掉两条关节，让小腿真的掉下去。
    cut(&mut sim, "thigh_l", 0.0);
    cut(&mut sim, "torso", 0.06);
    sim.sever_joint("knee_l");
    sim.sever_joint("hip_r");
    // 跑 4 秒（缓冲 5 秒，退 4 秒还能退到切之前）
    for _ in 0..240 {
        sim.step();
    }
    let bleed_after = sim.hemorrhage_ml_s();
    let vol_after = sim.creatures[sim.active].physio.bus.blood_volume;
    let pieces_after = sim.body.pieces.len();
    let frame2 = shot(&sim, 1.55);

    // 回滚 4 秒
    let back = sim.rewind(4.0).expect("缓冲里应该有 4 秒前的帧");
    let bleed_back = sim.hemorrhage_ml_s();
    let vol_back = sim.creatures[sim.active].physio.bus.blood_volume;
    let pieces_back = sim.body.pieces.len();
    let frame3 = shot(&sim, 1.55);

    for (i, (f, key)) in [
        (&frame1, Key::P05FrameBefore),
        (&frame2, Key::P05FrameAfter),
        (&frame3, Key::P05FrameRewound),
    ]
    .iter()
    .enumerate()
    {
        let x = 40 + i as i32 * 560;
        cv.blit(f, x, 130);
        border(&mut cv, x, 130, 540, 640);
        tr.draw(&mut cv, x + 14, 140, t(lang, *key), 15.0, TEXT);
    }

    // 帧下面的数字
    let notes = [
        format!("{pieces_before} 块 · 出血 0.00 · {vol_before:.0} mL"),
        format!("{pieces_after} 块 · 出血 {bleed_after:.1} · {vol_after:.0} mL"),
        format!("{pieces_back} 块 · 出血 {bleed_back:.2} · {vol_back:.0} mL"),
    ];
    for (i, s) in notes.iter().enumerate() {
        tr.draw(
            &mut cv,
            40 + i as i32 * 560 + 14,
            778,
            s,
            13.0,
            if i == 2 { HOT } else { DIM },
        );
    }

    // ------------------------------------------------------------ 扫描热图
    let sx = 40;
    let sy = 848;
    let (cells, x_vals, y_vals) = scan();
    let (nrows, ncols) = (y_vals.len(), x_vals.len());
    let cw = 96;
    let ch = 48;

    tr.draw(&mut cv, sx, sy - 36, t(lang, Key::P05PanelScan), 15.0, TEXT);

    // 值域：失代偿时刻，越大越"晚"
    let flat: Vec<f32> = cells.iter().copied().filter(|v| v.is_finite()).collect();
    let lo = flat.iter().copied().fold(f32::INFINITY, f32::min);
    let hi = flat.iter().copied().fold(f32::NEG_INFINITY, f32::max);

    for (r, _) in y_vals.iter().enumerate() {
        for (c, _) in x_vals.iter().enumerate() {
            let v = cells[r * ncols + c];
            let x = sx + 70 + c as i32 * cw;
            let y = sy + (nrows - 1 - r) as i32 * ch;
            let frac = if hi > lo { (v - lo) / (hi - lo) } else { 0.5 };
            cv.px_rect(x, y, x + cw - 2, y + ch - 2, heat(frac));
            let s = format!("{v:.0}");
            let tw = Canvas::text_width(&s, 2);
            cv.text(
                x + (cw - 2 - tw) / 2,
                y + ch / 2 - 9,
                &s,
                2,
                [16, 14, 18, 255],
            );
        }
    }
    // 轴标签
    for (r, v) in y_vals.iter().enumerate() {
        let y = sy + (nrows - 1 - r) as i32 * ch + ch / 2 - 8;
        cv.text(sx + 8, y, &format!("{v:.2}"), 2, DIM);
    }
    tr.draw(
        &mut cv,
        sx + 70,
        sy + nrows as i32 * ch + 6,
        t(lang, Key::P05ScanAxisX),
        12.0,
        DIM,
    );
    for (c, v) in x_vals.iter().enumerate() {
        let s = format!("{v:.0}");
        let tw = Canvas::text_width(&s, 2);
        cv.text(
            sx + 70 + c as i32 * cw + (cw - tw) / 2,
            sy + nrows as i32 * ch + 24,
            &s,
            2,
            DIM,
        );
    }
    tr.draw(
        &mut cv,
        sx + 8,
        sy - 14,
        t(lang, Key::P05ScanAxisY),
        12.0,
        DIM,
    );
    tr.draw(
        &mut cv,
        sx + 70,
        sy + nrows as i32 * ch + 44,
        t(lang, Key::P05Note),
        12.0,
        DIM,
    );

    // 色带图例
    let lx = sx + 70 + ncols as i32 * cw + 24;
    for i in 0..40 {
        let f = i as f32 / 39.0;
        let yy = sy + (40 - i) * 3;
        cv.px_rect(lx, yy, lx + 18, yy + 3, heat(f));
    }
    tr.draw(
        &mut cv,
        lx + 24,
        sy + 30,
        t(lang, Key::P05ScanLow),
        12.0,
        DIM,
    );
    tr.draw(
        &mut cv,
        lx + 24,
        sy + 96,
        t(lang, Key::P05ScanHigh),
        12.0,
        DIM,
    );

    // ------------------------------------------------------------ 右下：数字
    let nx = 720;
    let ny = 890;
    let lines = [
        format!(
            "{}  {:.2}s",
            if lang == Lang::Zh {
                "实际回滚"
            } else {
                "REWOUND"
            },
            back
        ),
        format!(
            "{}  {:.1} → {:.2} mL/s",
            if lang == Lang::Zh { "出血" } else { "BLEED" },
            bleed_after,
            bleed_back
        ),
        format!(
            "{}  {:.0} → {:.0} mL",
            if lang == Lang::Zh {
                "血容量"
            } else {
                "VOLUME"
            },
            vol_after,
            vol_back
        ),
        format!(
            "{}  {} → {}",
            if lang == Lang::Zh { "块数" } else { "PIECES" },
            pieces_after,
            pieces_back
        ),
        format!(
            "{}  {:.1} MB / {} 帧",
            if lang == Lang::Zh { "缓冲" } else { "BUFFER" },
            sim.rewind.bytes() as f32 / 1024.0 / 1024.0,
            sim.rewind.len()
        ),
    ];
    tr.draw(
        &mut cv,
        nx,
        ny - 30,
        if lang == Lang::Zh {
            "回滚结果"
        } else {
            "REWIND RESULT"
        },
        15.0,
        TEXT,
    );
    for (i, s) in lines.iter().enumerate() {
        tr.draw(
            &mut cv,
            nx,
            ny + i as i32 * 30,
            s,
            14.0,
            if i == 1 { HOT } else { TEXT },
        );
    }

    // ------------------------------------------------------------ 页眉页脚
    tr.draw(&mut cv, 40, 26, t(lang, Key::P05Title), 34.0, TEXT);
    tr.draw(&mut cv, 40, 86, t(lang, Key::P05Subtitle), 15.0, DIM);
    tr.draw(
        &mut cv,
        40,
        H as i32 - 56,
        t(lang, Key::P05Footer1),
        14.0,
        DIM,
    );
    tr.draw(
        &mut cv,
        40,
        H as i32 - 32,
        t(lang, Key::P05Footer2),
        14.0,
        DIM,
    );

    // ------------------------------------------------------------ 版面自检
    for (s, px) in [
        (t(lang, Key::P05Title), 34.0),
        (t(lang, Key::P05Subtitle), 15.0),
        (t(lang, Key::P05Footer1), 14.0),
        (t(lang, Key::P05Footer2), 14.0),
    ] {
        let w = tr.width(s, px);
        println!("版面自检：{w}px / {}px  {s}", W - 80);
        assert!(w <= W as i32 - 80, "文案超出画布宽");
    }

    // ------------------------------------------------------------ 断言
    println!(
        "\n回滚：{back:.2}s · 出血 {bleed_after:.2} → {bleed_back:.2} mL/s · \
         血容量 {vol_after:.0} → {vol_back:.0} · 块数 {pieces_after} → {pieces_back}"
    );
    assert!(bleed_back < 0.01, "回滚后不该还在流血");
    assert!((vol_back - vol_before).abs() < 1.0, "血容量没回来");
    assert_eq!(pieces_back, pieces_before, "块数没回来");
    println!("扫描：{} 格，失代偿 {lo:.0}~{hi:.0}s", cells.len());

    // 图像自检：headless 看不到图，只能比像素。
    // 第 1 帧和第 3 帧应该**几乎逐像素相同**——回滚如果只把数值抄回去、
    // 组织场没跟着回去，第 3 帧会带着第 2 帧的创口，差异立刻上去了。
    let diff = |a: i32, b: i32| -> f32 {
        let mut d = 0usize;
        let mut n = 0usize;
        for y in 140..760 {
            for x in 14..530 {
                if cv.get(a + x, y) != cv.get(b + x, y) {
                    d += 1;
                }
                n += 1;
            }
        }
        d as f32 / n as f32
    };
    let d13 = diff(40, 40 + 2 * 560);
    let d12 = diff(40, 40 + 560);
    println!(
        "像素差：帧1↔帧3 {:.2}%，帧1↔帧2 {:.2}%",
        d13 * 100.0,
        d12 * 100.0
    );
    // 回滚之后应该几乎和切之前一致（不是完全一致：`warmup` 会重解压力场，
    // 热力图的边缘会有亚像素级差异）
    assert!(
        d13 < 0.005,
        "回滚之后应该和切之前一致，实际差 {:.2}%",
        d13 * 100.0
    );
    // 切开之后必须比回滚之后差得多——否则说明"回滚"根本没起作用
    assert!(
        d12 > d13 * 1.2,
        "切开({:.2}%) 应该明显比回滚后({:.2}%) 差",
        d12 * 100.0,
        d13 * 100.0
    );

    let path = std::path::Path::new("docs/p05_rewind_scan.png");
    cv.save(path).expect("写 PNG 失败");
    println!("已写出 {}", path.display());
}

/// 渲染一帧身体到独立画布。
fn shot(sim: &Sim, world_width: f32) -> Canvas {
    // 画布中心跟着身体走。身体挂在 (0, 40)，中心留在 (0, 0) 的话
    // `put` 的越界检查会把每个像素都丢掉——图上空白，且不报错。
    let center = sim.body_origin_world().unwrap_or(Vec2::new(0.0, 40.0)) + Vec2::new(0.0, 0.15);
    let mut c = Canvas::new_at(540, 640, world_width, center);
    c.clear(PANEL);
    paint_heatmap(&mut c, sim, HeatChannel::Perfusion, 110);
    paint_pieces(&mut c, sim, true);
    c
}

fn cut(sim: &mut Sim, part: &str, dy: f32) {
    let i = sim.plan.parts.iter().position(|p| p.name == part).unwrap();
    let (pos, _) = sim.piece_pose(sim.creatures[sim.active].primary[i]);
    let at = pos + Vec2::new(0.0, dy);
    let seg = CutSegment {
        a: at - Vec2::new(0.07, 0.0),
        b: at + Vec2::new(0.07, 0.0),
        width: 0.005,
        speed: 3.0,
    };
    sim.slice(&seg);
    sim.cut(&seg);
}

fn world() -> Sim {
    let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
    let mut sim = Sim::spawn(plan, Vec2::new(0.0, 40.0), GROUND);
    sim.attach_tissue(&TissueConfig::asset());
    sim.set_part_fixed("head", true);
    for _ in 0..180 {
        sim.step();
    }
    sim
}

/// 二维扫描：tone_max × 血容量 → 失代偿时刻。
///
/// 这一格一格跑，用 1Hz 的组织场（`stride = 20`）。**这里不能用完整 20Hz**：
/// 25 组 × 300 秒 × 20Hz 要跑十几分钟，而失代偿时刻的精度只需要秒级。
fn scan() -> (Vec<f32>, Vec<f32>, Vec<f32>) {
    let x_vals: Vec<f32> = vec![3500.0, 4000.0, 4500.0, 5000.0, 5500.0];
    let y_vals: Vec<f32> = vec![0.3, 0.475, 0.65, 0.825, 1.0];
    let mut cells = Vec::with_capacity(x_vals.len() * y_vals.len());

    for &tv in &y_vals {
        for &bv in &x_vals {
            let mut physio = anatomize_physio::PhysioConfig::asset();
            physio.tone_max = tv;
            physio.blood_volume_ml = bv;

            let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
            let mut sim = Sim::spawn(plan, Vec2::new(0.0, 40.0), GROUND);
            sim.creatures[sim.active].physio = anatomize_physio::Physio::new(physio);
            sim.attach_tissue(&TissueConfig::asset());
            sim.set_part_fixed("head", true);
            for _ in 0..180 {
                sim.step();
            }
            if let Some(t) = sim.creatures[sim.active].tissue.as_mut() {
                t.stride = 20;
            }
            // 股动脉横断
            let i = sim
                .plan
                .parts
                .iter()
                .position(|p| p.name == "thigh_l")
                .unwrap();
            let (pos, _) = sim.piece_pose(sim.creatures[sim.active].primary[i]);
            let seg = CutSegment {
                a: pos - Vec2::new(0.06, 0.0),
                b: pos + Vec2::new(0.06, 0.0),
                width: 0.005,
                speed: 2.0,
            };
            sim.cut(&seg);

            let mut t45 = 300.0f32;
            for k in 0..(300 * 60) {
                sim.step();
                if sim.creatures[sim.active].physio.bus.map < 45.0 {
                    t45 = k as f32 / 60.0;
                    break;
                }
            }
            cells.push(t45);
        }
        eprint!(".");
    }
    eprintln!();
    (cells, x_vals, y_vals)
}

fn heat(f: f32) -> [u8; 4] {
    let f = f.clamp(0.0, 1.0);
    // 深蓝 → 青 → 黄 → 红：越红越晚失代偿（代偿越强）
    let r = (40.0 + 215.0 * (f * 1.6 - 0.35).clamp(0.0, 1.0)) as u8;
    let g = (50.0 + 200.0 * (f * 1.9 - 0.15).clamp(0.0, 1.0) * (1.0 - f * 0.25)) as u8;
    let b = (140.0 - 120.0 * f) as u8;
    [r, g, b, 255]
}

fn border(cv: &mut Canvas, x: i32, y: i32, w: i32, h: i32) {
    cv.px_rect(x, y, x + w, y + 1, FRAME);
    cv.px_rect(x, y + h - 1, x + w, y + h, FRAME);
    cv.px_rect(x, y, x + 1, y + h, FRAME);
    cv.px_rect(x + w - 1, y, x + w, y + h, FRAME);
}
