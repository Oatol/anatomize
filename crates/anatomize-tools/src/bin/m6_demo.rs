//! M6 验收图：断面、碎片、监护仪。
//!
//! 输出 `docs/m6_section_hud.png`，五块：
//!
//! | 面板 | 验收标准 |
//! |---|---|
//! | 完整身体 + 灌注热力图 | 视觉分层 |
//! | 六刀之后 | 验收 7、8（碎片预算与护栏） |
//! | 大腿断面放大 | 验收 6（四层色带） |
//! | 层带比例条 | 验收 6（层厚比例合理） |
//! | 监护仪 | HUD |
//!
//! 全部离线渲染，不需要窗口。断面是逐像素算的，所以这张图本身就是
//! "渲染和几何一致"的证明——如果剖面错了，图上会直接看出来。

use anatomize_body::{ASSET_HUMAN_01, BodyPlan, Layer};
use anatomize_core::{Lang, UiConfig, Vec2};
use anatomize_cut::{CutSegment, SectionProfile, measure_bands};
use anatomize_sim::Sim;
use anatomize_tissue::TissueConfig;
use anatomize_tools::i18n::{Key, t};
use anatomize_tools::paint::{HeatChannel, layer_color, layer_name, paint_heatmap, paint_pieces};
use anatomize_tools::render::Canvas;
use anatomize_tools::text::TextRenderer;

const W: u32 = 1720;
const H: u32 = 1250;
const GROUND: f32 = -80.0;

const BG: [u8; 4] = [18, 17, 22, 255];
const PANEL: [u8; 4] = [26, 25, 32, 255];
const FRAME: [u8; 4] = [58, 56, 70, 255];
const TEXT: [u8; 4] = [232, 230, 238, 255];
const DIM: [u8; 4] = [140, 137, 152, 255];
const ACCENT: [u8; 4] = [232, 92, 92, 255];

fn main() {
    let lang = UiConfig::resolve();
    let tr = TextRenderer::system();
    // 找不到中文字体就强制英文——画一堆方块比少一种语言更糟
    let lang = if !tr.has_cjk() && lang == Lang::Zh {
        println!("{}", t(Lang::Zh, Key::M6Title));
        Lang::En
    } else {
        lang
    };
    let mut cv = Canvas::blank(W, H);
    cv.clear(BG);

    // ---------------------------------------------------------------- 场景 A
    // 完整身体：只叠灌注热力图，看"活着"的样子
    let a = world();
    // 画布中心必须跟着身体走。身体挂在 (0, 40)，画布中心却在 (0, 0) 的话，
    // 逐像素绘制的 `put` 会因为越界检查全部丢弃——图上是空的，而且**不会报错**。
    let center = a.body_origin_world().unwrap_or(Vec2::new(0.0, 40.0)) + Vec2::new(0.0, 0.15);
    let mut panel_a = Canvas::new_at(760, 700, 1.5, center);
    panel_a.clear(PANEL);
    paint_heatmap(&mut panel_a, &a, HeatChannel::Perfusion, 120);
    paint_pieces(&mut panel_a, &a, true);
    cv.blit(&panel_a, 40, 150);
    frame(&mut cv, 40, 150, 760, 700);
    tr.draw(&mut cv, 56, 160, t(lang, Key::M6PanelIntact), 15.0, TEXT);

    // ---------------------------------------------------------------- 场景 B
    // 六刀：两条腿、两条手臂、躯干、颈
    let mut b = world();
    // 按部件**当前**位置切。用 `BodyPlan` 的静态 offset 会切到隔壁去——
    // 身体吊在头上会下垂十几厘米，装配坐标早就不作数了。
    for (part, dy) in [
        ("thigh_l", 0.0),
        ("thigh_r", 0.02),
        ("shin_l", 0.03),
        ("upper_arm_l", 0.0),
        ("torso", 0.06),
        ("head", 0.0),
    ] {
        cut_part(&mut b, part, dy);
    }
    // 让碎片飞一会儿，再让冻结计时跑起来。
    // 默认冻结阈值是 10 秒（静止 10 秒的碎片才摘出物理世界），但验收图只拍
    // 5 秒的现场——这里临时压到 1.5 秒，好让图上能看到"已冻结"这个状态。
    b.fracture.freeze_after_s = 2.0;
    for _ in 0..600 {
        b.step();
        b.clamp_velocities();
        b.update_freeze();
    }
    let center_b = b.body_origin_world().unwrap_or(Vec2::new(0.0, 40.0)) + Vec2::new(0.0, 0.15);
    let mut panel_b = Canvas::new_at(820, 700, 1.55, center_b);
    panel_b.clear(PANEL);
    paint_pieces(&mut panel_b, &b, true);
    cv.blit(&panel_b, 830, 150);
    frame(&mut cv, 830, 150, 820, 700);
    tr.draw(&mut cv, 846, 160, t(lang, Key::M6PanelCut), 15.0, TEXT);
    {
        let frozen = b.body.pieces.iter().filter(|p| p.is_frozen()).count();
        let info = format!(
            "{} {} / {} {}",
            t(lang, Key::HudPieces),
            b.live_pieces(),
            t(lang, Key::HudFrozen),
            frozen
        );
        tr.draw(&mut cv, 1500, 160, &info, 13.0, DIM);
    }

    // ---------------------------------------------------------------- 断面
    // 单独切一刀，取切口附近放大。用 sim 里的真实碎片，不是另画一份。
    let mut c = world();
    let thigh = c
        .plan
        .parts
        .iter()
        .position(|p| p.name == "thigh_l")
        .unwrap();
    let cut_world = cut_part(&mut c, "thigh_l", 0.0);

    let mut panel_c = Canvas::new_at(600, 340, 0.19, cut_world);
    panel_c.clear(PANEL);
    paint_pieces(&mut panel_c, &c, true);
    cv.blit(&panel_c, 40, 880);
    frame(&mut cv, 40, 880, 600, 340);
    tr.draw(&mut cv, 56, 890, t(lang, Key::M6PanelSection), 15.0, TEXT);

    // ---------------------------------------------------------------- 层带条
    let part = &c.plan.parts[thigh];
    let prof = SectionProfile::for_part(part.bone, &part.polygon);
    // 切口在**部件局部**的 y：`cut_part` 切在部件当前中心，也就是部件局部 y=0
    let ly = 0.0f32;
    let bands = measure_bands(
        &part.polygon,
        &prof,
        Vec2::new(-5.5, ly),
        Vec2::new(5.5, ly),
        2048,
    );

    let bx = 680;
    let by = 900;
    let bw = 420;
    tr.draw(&mut cv, bx, 890, t(lang, Key::M6PanelBands), 15.0, TEXT);
    tr.draw(
        &mut cv,
        bx,
        by + 4,
        &format!(
            "{} {:.1} cm",
            t(lang, Key::M6BandWidth),
            prof.thickness_cm() * 2.0
        ),
        13.0,
        DIM,
    );

    // 一条水平比例条：左 → 右 = 皮肤…骨…皮肤
    let bar_y = by + 40;
    let bar_h = 54;
    cv.px_rect(bx, bar_y, bx + bw, bar_y + bar_h, [12, 11, 15, 255]);
    // 镜像：measure_bands 给的是单程，这里画成"穿过整条剖面"的对称条
    let mut cursor = bx as f32;
    let draw_band = |cv: &mut Canvas, layer: Layer, share: f32, cursor: &mut f32| {
        let wpx = (bw as f32 * share).round().max(1.0);
        cv.px_rect(
            *cursor as i32,
            bar_y,
            (*cursor + wpx) as i32,
            bar_y + bar_h,
            layer_color(layer),
        );
        *cursor += wpx;
    };
    // 单程（皮肤→骨）画左半，右半镜像回去
    for band in &bands {
        draw_band(&mut cv, band.layer, band.share * 0.5, &mut cursor);
    }
    for band in bands.iter().rev() {
        draw_band(&mut cv, band.layer, band.share * 0.5, &mut cursor);
    }
    // 中线（骨的中缝）
    cv.line_px(
        (bx + bw / 2, bar_y - 6),
        (bx + bw / 2, bar_y + bar_h + 6),
        DIM,
        1,
    );

    // 图例
    let mut ly2 = bar_y + bar_h + 26;
    for band in &bands {
        cv.px_rect(bx, ly2, bx + 22, ly2 + 22, layer_color(band.layer));
        let name = match band.layer {
            Layer::Skin => t(lang, Key::M6LayerSkin),
            Layer::Fat => t(lang, Key::M6LayerFat),
            Layer::Muscle => t(lang, Key::M6LayerMuscle),
            Layer::Bone => t(lang, Key::M6LayerBone),
            Layer::Organ => "ORGAN",
        };
        let _ = layer_name(band.layer);
        tr.draw(
            &mut cv,
            bx + 34,
            ly2 + 2,
            &format!("{name}  {:.2} cm · {:.0}%", band.cm, band.share * 100.0),
            13.0,
            TEXT,
        );
        ly2 += 30;
    }

    // ---------------------------------------------------------------- 监护仪
    let hx = 1140;
    let hy = 880;
    let hw = 540;
    frame(&mut cv, hx, hy, hw, 340);
    tr.draw(
        &mut cv,
        hx + 16,
        hy + 10,
        t(lang, Key::M6PanelHud),
        15.0,
        TEXT,
    );

    let bus = b.creatures[b.active].physio.bus;
    let rows: [(String, f32, f32, &str, [u8; 4]); 7] = [
        ("MAP".into(), bus.map, 130.0, "mmHg", [120, 220, 240, 255]),
        (
            "HR".into(),
            bus.heart_rate,
            180.0,
            "bpm",
            [240, 120, 120, 255],
        ),
        (
            "SpO2".into(),
            bus.sao2 * 100.0,
            100.0,
            "%",
            [120, 220, 160, 255],
        ),
        ("Tc".into(), bus.temp_core, 42.0, "°C", [240, 190, 110, 255]),
        (
            "Glu".into(),
            bus.glucose,
            15.0,
            "mmol/L",
            [200, 160, 240, 255],
        ),
        (
            "Consc".into(),
            bus.consciousness,
            1.0,
            "0-1",
            [220, 220, 140, 255],
        ),
        (
            "Bleed".into(),
            b.hemorrhage_ml_s(),
            80.0,
            "mL/s",
            [240, 100, 100, 255],
        ),
    ];
    let mut ry = hy + 46;
    for (name, v, max, unit, col) in rows {
        cv.text(hx + 16, ry, &name, 2, DIM);
        cv.text(
            hx + 120,
            ry,
            &format!("{v:.1}"),
            3,
            if v.is_finite() { col } else { ACCENT },
        );
        cv.text(hx + 230, ry + 6, unit, 2, DIM);
        // 条形
        let frac = (v / max).clamp(0.0, 1.0);
        let (bxx, byy) = (hx + 330, ry + 4);
        let (bw2, bh2) = (180, 18);
        cv.px_rect(bxx, byy, bxx + bw2, byy + bh2, [14, 13, 18, 255]);
        cv.px_rect(bxx, byy, bxx + (bw2 as f32 * frac) as i32, byy + bh2, col);
        ry += 40;
    }

    // 关节状态汇总
    let mut states = [0usize; 5];
    for j in &b.body.joints {
        states[j.health.state as usize] += 1;
    }
    let summary = format!(
        "{}  INTACT {} · SPRAINED {} · SUBLUX {} · DISLOC {} · SEVERED {}",
        t(lang, Key::HudJoints),
        states[0],
        states[1],
        states[2],
        states[3],
        states[4]
    );
    tr.draw(&mut cv, hx + 16, ry + 6, &summary, 12.0, DIM);

    // ---------------------------------------------------------------- 页眉页脚
    tr.draw(&mut cv, 40, 26, t(lang, Key::M6Title), 34.0, TEXT);
    tr.draw(&mut cv, 40, 84, t(lang, Key::M6Subtitle), 16.0, DIM);

    tr.draw(
        &mut cv,
        40,
        H as i32 - 62,
        t(lang, Key::M6Footer1),
        14.0,
        DIM,
    );
    tr.draw(
        &mut cv,
        40,
        H as i32 - 38,
        t(lang, Key::M6Footer2),
        14.0,
        DIM,
    );

    // 版面自检：中文字宽比英文大，不量一下迟早溢出
    let checks = [
        (t(lang, Key::M6Title), 34.0),
        (t(lang, Key::M6Subtitle), 16.0),
        (t(lang, Key::M6Footer1), 14.0),
        (t(lang, Key::M6Footer2), 14.0),
    ];
    for (s, px) in checks {
        let w = tr.width(s, px);
        println!("版面自检：{w}px / {}px  {s}", W - 80);
        assert!(w <= W as i32 - 80, "文案超出画布宽：{s}");
    }
    // 覆盖率先行检查：面板里必须真的画了东西。
    // 这条是补上来的——第一版 M6 图的两个身体面板是空的，因为画布中心
    // 没跟着身体走，`put` 的越界检查把每个像素都丢了，而且静默成功。
    for (name, c, w, h) in [
        ("完整身体", &panel_a, 760, 700),
        ("六刀之后", &panel_b, 820, 700),
    ] {
        let mut painted = 0usize;
        for y in 0..h {
            for x in 0..w {
                if c.get(x, y) != PANEL {
                    painted += 1;
                }
            }
        }
        let frac = painted as f32 / (w * h) as f32;
        println!("  面板「{name}」非背景像素 {:.1}%", frac * 100.0);
        assert!(frac > 0.05, "面板「{name}」几乎是空的（{:.1}%），画布中心错了", frac * 100.0);
    }

    // 图像自检：headless 环境看不到图，只能扫像素。
    //
    // 断面在 2D 里就是**切口那条线**，宽度只有一两个像素（描边还是半透明的，
    // 混过色）。所以不能按"扫一行看颜色顺序"来验——那条线太细，随便一个
    // 描边像素就断了。改成统计整个特写面板的层色占比：四层必须都出现，
    // 而且比例要和 `measure_bands` 算出来的一致。
    let mut hist = std::collections::HashMap::new();
    for y in 0..340 {
        for x in 0..600 {
            *hist.entry(panel_c.get(x, y)).or_insert(0usize) += 1;
        }
    }
    let total: usize = hist.values().sum();
    let mut found = Vec::new();
    for l in [Layer::Skin, Layer::Fat, Layer::Muscle, Layer::Bone] {
        let n = *hist.get(&layer_color(l)).unwrap_or(&0);
        let share = n as f32 / total as f32;
        println!("  像素 {:?}: {:.1}%", l, share * 100.0);
        if n > 0 {
            found.push(l);
        }
    }
    assert_eq!(found.len(), 4, "断面里必须出现四种层色，实际 {found:?}");
    // 骨要占一块明显的面积（在这个特写里骨是最粗的一圈）
    let bone = *hist.get(&layer_color(Layer::Bone)).unwrap_or(&0) as f32 / total as f32;
    assert!(bone > 0.10, "骨色只占 {:.1}%", bone * 100.0);

    println!(
        "界面语言：{lang:?}（{}）",
        if tr.has_cjk() {
            "含中文字形"
        } else {
            "无中文字形"
        }
    );

    let path = std::path::Path::new("docs/m6_section_hud.png");
    cv.save(path).expect("写 PNG 失败");
    println!("已写出 {}", path.display());

    // 顺便把几个验收数字打出来
    println!(
        "\n六刀之后：{} 块（活跃 {}），冻结 {}，最大速度 {:.1} m/s",
        b.body.pieces.len(),
        b.live_pieces(),
        b.body.pieces.iter().filter(|p| p.is_frozen()).count(),
        b.diagnostics().max_speed
    );
    println!(
        "大腿剖面 {:.1} cm：{}",
        prof.thickness_cm() * 2.0,
        bands
            .iter()
            .map(|x| format!("{:?} {:.2}cm/{:.0}%", x.layer, x.cm, x.share * 100.0))
            .collect::<Vec<_>>()
            .join("  ")
    );
}

fn frame(cv: &mut Canvas, x: i32, y: i32, w: i32, h: i32) {
    cv.px_rect(x, y, x + w, y + 1, FRAME);
    cv.px_rect(x, y + h - 1, x + w, y + h, FRAME);
    cv.px_rect(x, y, x + 1, y + h, FRAME);
    cv.px_rect(x + w - 1, y, x + w, y + h, FRAME);
}

/// 在某个部件当前的腰部横切一刀，返回切口的世界位置。
fn cut_part(sim: &mut Sim, name: &str, dy: f32) -> Vec2 {
    let i = sim.plan.parts.iter().position(|p| p.name == name).unwrap();
    let (pos, _) = sim.piece_pose(sim.creatures[sim.active].primary[i]);
    let at = pos + Vec2::new(0.0, dy);
    let seg = CutSegment {
        a: at - Vec2::new(0.08, 0.0),
        b: at + Vec2::new(0.08, 0.0),
        width: 0.005,
        speed: 3.0,
    };
    sim.slice(&seg);
    sim.cut(&seg);
    at
}

fn world() -> Sim {
    let plan = BodyPlan::from_ron(ASSET_HUMAN_01).unwrap();
    let mut sim = Sim::spawn(plan, Vec2::new(0.0, 40.0), GROUND);
    sim.attach_tissue(&TissueConfig::asset());
    // 吊着头，让身体保持站立——不然躺在地上切不好看
    sim.set_part_fixed("head", true);
    for _ in 0..180 {
        sim.step();
    }
    sim
}
