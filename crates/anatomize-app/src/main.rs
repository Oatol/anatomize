//! 主程序：窗口、主循环、输入、HUD。
//!
//! # 为什么宿主是 eframe 而不是 Bevy
//!
//! 设计文档 v0.2 写的是 Bevy，实际做窗口版时改成了 eframe（egui）。理由：
//!
//! 1. **这个游戏只需要三件事**：窗口、2D 绘制、输入。egui 全都有，
//!    而且 `Shape::convex_polygon` 正好对上"凸多边形 + 单色填充"的需求。
//! 2. **不需要 ECS**。`Sim` 已经是自己的世界（刚体、关节、组织场、生理），
//!    再套一层 ECS 只是多一层同步。
//! 3. **immediate mode 天然适合这种场景**：每帧重建 20~40 块多边形，没有
//!    sprite 缓存要失效、没有 mesh 要重建，改了 `Sim` 下一帧就是新的。
//! 4. 首次编译 3 分钟（Bevy 5~8 分钟）。
//!
//! 核心 5 个 crate 都不依赖宿主，所以将来要 3D / 音频 / 粒子时换成 Bevy，
//! **只改这一个 crate**。见 ADR-028。

mod camera;
mod fonts;
mod icons;
mod shot;
mod tools;
mod ui;
mod view;

use anatomize_body::{ASSET_HUMAN_01, BodyPlan};
use anatomize_core::{DT, HeatChannel, Vec2};
use anatomize_cut::CutSegment;
use anatomize_sim::{PieceId, Sim, WorldBounds};
use anatomize_tissue::TissueConfig;
use camera::Camera;
use tools::{Drag, Tool};

/// 拖动太短就当误触：小于 4 个像素不切。
const MIN_CUT_PX: f32 = 4.0;

pub struct App {
    sim: Sim,
    cam: Camera,
    tool: Tool,
    drag: Option<Drag>,
    paused: bool,
    time_scale: f32,
    /// 固定步长累加器。
    acc: f32,
    /// 热力图叠加。
    heat: Option<HeatChannel>,
    /// 调试叠加：血管 + 关节。
    debug: bool,
    /// 上次操作的提示（HUD 底部显示几秒）。
    toast: Option<(String, f32)>,
    /// 有没有中文字形（没有的话提示用户装字体）。
    pub has_cjk: bool,
    /// 截图计划（`--shot`）。`None` = 正常交互模式。
    shot: Option<shot::ShotPlan>,
    /// 当前选中的块（选择工具点的）。
    pub selected: Option<PieceId>,
    /// 新建世界对话框。
    pub new_world: ui::NewWorldDialog,
    /// 读取菜单：`Some(list)` 时打开。
    pub load_menu: Option<Vec<String>>,
    /// 平滑后的帧率。
    pub fps: f32,
    /// 道具卡片的色相抖动（暂时没用，留给以后）。
    pub prop_hue: f32,
}

impl App {
    fn new(cc: &eframe::CreationContext<'_>) -> Self {
        let font = fonts::install(&cc.egui_ctx);
        let has_cjk = font.is_some();
        if font.is_none() {
            eprintln!("没找到中文字体，界面退回英文。设 ANATOMIZE_FONT 可以指定。");
        }
        // 强制深色：eframe 默认跟随系统主题，Windows 浅色下侧栏会是白的
        cc.egui_ctx
            .options_mut(|o| o.theme_preference = egui::ThemePreference::Dark);
        cc.egui_ctx.set_visuals(egui::Visuals::dark());

        let plan = BodyPlan::from_ron(ASSET_HUMAN_01).expect("内置人体计划解析失败");
        // 地面在 y = 0，人站在上面（脚约 -0.7，头约 +0.7）。
        //
        // 别学离线 demo 用 y = 40 / 地面 -80：那是为了留出下落空间，
        // 结果身体在 120 帧里自由落体了 20 米，窗口里根本看不到人。
        let world = WorldBounds::default();
        let mut sim = Sim::spawn_in(plan, Vec2::new(0.0, world.stand_height()), world);
        sim.attach_tissue(&TissueConfig::asset());
        sim.enable_posture();

        // 落地站稳：让关节在下垂之后稳定下来，再交给玩家
        for _ in 0..120 {
            sim.step();
        }

        Self {
            sim,
            cam: Camera::default(),
            tool: Tool::Knife,
            drag: None,
            paused: false,
            time_scale: 1.0,
            acc: 0.0,
            heat: None,
            debug: false,
            toast: None,
            has_cjk,
            shot: shot::ShotPlan::from_args(),
            selected: None,
            new_world: ui::NewWorldDialog::default(),
            load_menu: None,
            fps: 60.0,
            prop_hue: 0.0,
        }
    }

    fn say(&mut self, msg: impl Into<String>) {
        self.toast = Some((msg.into(), 2.5));
    }

    /// 时间步进：固定 60Hz，最多补 8 步。
    ///
    /// 补步上限是必须的：卡一下之后如果按实际时间补 100 步，会卡得更久，
    /// 然后补更多步——雪崩。宁可让游戏时间慢一点，也不能卡死。
    fn advance(&mut self, dt: f32) {
        if self.paused {
            return;
        }
        self.acc += dt.min(0.1) * self.time_scale;
        let mut n = 0;
        while self.acc >= DT && n < 8 {
            self.sim.step();
            self.acc -= DT;
            n += 1;
        }
        if n == 8 {
            self.acc = 0.0;
        }
    }

    /// 松开鼠标：执行工具动作。
    fn release(&mut self, drag: &Drag) {
        match self.tool {
            Tool::Knife => {
                let px = drag.length() * self.cam.zoom;
                if px < MIN_CUT_PX {
                    return;
                }
                let seg = CutSegment {
                    a: drag.from,
                    b: drag.to,
                    // 刀宽 4mm：组织场的创口带大约 1 个 texel
                    width: 0.004,
                    speed: drag.length() * 60.0,
                };
                let report = self.sim.slice(&seg);
                let out = self.sim.cut(&seg);
                let mut msg = String::new();
                if report.new_pieces > 0 {
                    msg.push_str(&format!("切开 {} 块", report.new_pieces));
                }
                if let Some(o) = out {
                    if !o.report.hits.is_empty() {
                        if !msg.is_empty() {
                            msg.push_str("，");
                        }
                        msg.push_str(&o.report.summary(&self.sim.plan));
                    }
                    if !o.starved.is_empty() {
                        msg.push_str(&format!("；{} 处断供", o.starved.len()));
                    }
                }
                if msg.is_empty() {
                    msg = "没切到什么".into();
                }
                self.say(msg);
            }
            Tool::Hammer => {
                if let Some(i) = self.piece_at(drag.from) {
                    let part = self.sim.body.pieces[i].part;
                    let name = self.sim.plan.parts[part.index()].name.clone();
                    let (pos, _) = self.sim.piece_pose(PieceId(i as u32));
                    let off = drag.from - pos;
                    // 冲量方向 = 从鼠标指向部件中心（"往里砸"）
                    let dir = (pos - drag.from).normalize_or_zero();
                    let impulse = dir * 60.0;
                    self.sim.strike_part(&name, impulse, off * 100.0);
                    self.say(format!("砸了 {name} 一下"));
                }
            }
            Tool::Hand | Tool::Select => {
                // 选择：点一下看属性
                self.selected = self.piece_at(drag.from).map(|i| PieceId(i as u32));
            }
            Tool::Freeze => {
                if let Some(i) = self.piece_at(drag.from) {
                    let id = PieceId(i as u32);
                    let now = self.sim.body.pieces[i].is_frozen();
                    let after = self.sim.set_frozen(id, !now);
                    self.say(if after { "冻结" } else { "解冻" });
                }
            }
            Tool::Delete => {
                if let Some(i) = self.piece_at(drag.from) {
                    self.sim.delete_piece(PieceId(i as u32));
                    self.selected = None;
                    self.say("已删除");
                }
            }
        }
    }

    /// 鼠标位置下最上层的块。
    fn piece_at(&self, world: Vec2) -> Option<usize> {
        // 倒序：后画的在上面
        for i in (0..self.sim.body.pieces.len()).rev() {
            let poly = self.sim.piece_polygon(PieceId(i as u32));
            if point_in_poly(&poly, world) {
                return Some(i);
            }
        }
        None
    }

    /// 手工具：把抓住的那块往鼠标处拉。
    fn drag_piece(&mut self, world: Vec2) {
        let Some(d) = &self.drag else { return };
        let Some(i) = d.grabbed else { return };
        self.sim.pull_piece(PieceId(i as u32), world, 1.0);
    }
}

impl App {
    /// 截图模式：倒计时 → 请求 → 收到 → 存盘 → 退出。
    ///
    /// 每次只借 `self.shot` 一小段——把 `&mut self.shot` 拿着去调
    /// `self.run_shot_action()` 会和整个 `self` 的可变借用打架。
    fn tick_shot(&mut self, ctx: &egui::Context) {
        if self.shot.is_none() {
            return;
        }

        // 1. 动作在倒数到一半时执行，留出时间让物理跑开
        let due = self.shot.as_ref().is_some_and(|p| p.countdown == 60);
        let action = self.shot.as_ref().and_then(|p| p.action);
        if due && let Some(a) = action {
            self.run_shot_action(a);
        }

        // 2. 倒计时 + 请求
        let mut done_request = false;
        {
            let plan = self.shot.as_mut().unwrap();
            if !plan.requested {
                plan.countdown = plan.countdown.saturating_sub(1);
                if plan.countdown == 0 {
                    done_request = true;
                    plan.requested = true;
                }
            }
        }
        if done_request {
            ctx.send_viewport_cmd(egui::ViewportCommand::Screenshot(Default::default()));
        }
        if !self.shot.as_ref().is_some_and(|p| p.requested) {
            return;
        }

        // 3. 收图
        let img = ctx.input(|i| {
            for e in &i.events {
                if let egui::Event::Screenshot { image, .. } = e {
                    return Some(image.clone());
                }
            }
            None
        });
        if let Some(img) = img {
            let path = self.shot.as_ref().unwrap().path.clone();
            match shot::save(&img, &path) {
                Ok(()) => println!("已写出 {path}（{}×{}）", img.size[0], img.size[1]),
                Err(e) => eprintln!("写 PNG 失败：{e}"),
            }
            self.shot = None;
            ctx.send_viewport_cmd(egui::ViewportCommand::Close);
        }
    }

    fn run_shot_action(&mut self, a: shot::Action) {
        match a {
            shot::Action::Cut => {
                for (part, dy) in [("thigh_l", 0.0), ("torso", 0.06)] {
                    if let Some(seg) = self.cut_at(part, dy) {
                        self.sim.slice(&seg);
                        self.sim.cut(&seg);
                    }
                }
                // 只切不断的话，两半被关节夹在原地，画面上和没切一样
                self.sim.sever_joint("knee_l");
                self.sim.sever_joint("hip_r");
            }
            shot::Action::Heat => self.heat = Some(HeatChannel::Perfusion),
            shot::Action::Feed => {
                self.sim.feed(500.0);
            }
            shot::Action::Sever => {
                self.sim.sever_joint("knee_l");
                self.sim.sever_joint("hip_r");
            }
            shot::Action::Props => {
                use anatomize_sim::PropKind;
                let c = self.cam.center;
                self.sim
                    .spawn_prop(PropKind::Crate, c + Vec2::new(0.9, -0.4));
                self.sim
                    .spawn_prop(PropKind::Ball, c + Vec2::new(-0.9, -0.3));
                self.sim
                    .spawn_prop(PropKind::Plank, c + Vec2::new(0.0, 0.4));
                self.sim
                    .spawn_prop(PropKind::Block, c + Vec2::new(1.3, -0.4));
                self.selected = Some(anatomize_sim::PieceId(
                    (self.sim.body.pieces.len() - 1) as u32,
                ));
            }
        }
    }

    /// 重开一个世界（指定尺寸）。
    pub fn reset_world(&mut self, world: WorldBounds) {
        let plan = BodyPlan::from_ron(ASSET_HUMAN_01).expect("内置人体计划解析失败");
        let mut sim = Sim::spawn_in(plan, Vec2::new(0.0, world.stand_height()), world);
        sim.attach_tissue(&TissueConfig::asset());
        sim.enable_posture();
        for _ in 0..120 {
            sim.step();
        }
        self.sim = sim;
        self.selected = None;
        self.cam = Camera {
            center: Vec2::new(0.0, world.height * 0.45),
            zoom: (720.0 / world.height).clamp(120.0, 600.0),
        };
        self.say(format!("新世界 {}×{} 米", world.width, world.height));
    }

    /// 存档目录。
    fn save_dir() -> std::path::PathBuf {
        std::path::PathBuf::from("saves")
    }

    pub fn save_world(&mut self) {
        let dir = Self::save_dir();
        let n = std::fs::read_dir(&dir)
            .map(|d| d.filter_map(|e| e.ok()).count())
            .unwrap_or(0);
        let path = dir.join(format!("world-{:03}.ron", n + 1));
        match self.sim.save_to(&path) {
            Ok(bytes) => self.say(format!(
                "已保存 {}（{:.1} MB）",
                path.display(),
                bytes as f32 / 1024.0 / 1024.0
            )),
            Err(e) => self.say(format!("保存失败：{e}")),
        }
    }

    /// 读一个存档。
    pub fn load_world(&mut self, name: &str) {
        let path = Self::save_dir().join(name);
        match Sim::load_from(&path) {
            Ok(sim) => {
                let w = sim.world;
                self.sim = sim;
                self.selected = None;
                self.cam = Camera {
                    center: Vec2::new(0.0, w.height * 0.45),
                    zoom: (720.0 / w.height).clamp(120.0, 600.0),
                };
                self.say(format!("读入 {name}"));
            }
            Err(e) => self.say(format!("读取失败：{e}")),
        }
    }

    pub fn open_load_menu(&mut self) {
        let dir = Self::save_dir();
        let mut list: Vec<String> = std::fs::read_dir(&dir)
            .map(|d| {
                d.filter_map(|e| e.ok())
                    .filter(|e| e.path().extension().is_some_and(|x| x == "ron"))
                    .map(|e| e.file_name().to_string_lossy().to_string())
                    .collect()
            })
            .unwrap_or_default();
        list.sort();
        if list.is_empty() {
            self.say("saves/ 里还没有存档");
        } else {
            self.load_menu = Some(list);
        }
    }

    /// 在某个部件当前中心横切一刀。
    fn cut_at(&self, part: &str, dy: f32) -> Option<CutSegment> {
        let i = self.sim.plan.parts.iter().position(|p| p.name == part)?;
        let (pos, _) = self.sim.piece_pose(self.sim.body.primary[i]);
        let at = pos + Vec2::new(0.0, dy);
        Some(CutSegment {
            a: at - Vec2::new(0.07, 0.0),
            b: at + Vec2::new(0.07, 0.0),
            width: 0.004,
            speed: 3.0,
        })
    }
}

fn point_in_poly(poly: &[Vec2], p: Vec2) -> bool {
    let n = poly.len();
    if n < 3 {
        return false;
    }
    for i in 0..n {
        let a = poly[i];
        let b = poly[(i + 1) % n];
        if (b - a).perp_dot(p - a) < 0.0 {
            return false;
        }
    }
    true
}

impl eframe::App for App {
    fn update(&mut self, ctx: &egui::Context, _frame: &mut eframe::Frame) {
        let dt = ctx.input(|i| i.stable_dt);
        if dt > 0.0 {
            self.fps += (1.0 / dt - self.fps) * 0.1;
        }
        self.advance(dt);

        if let Some((_, t)) = &mut self.toast {
            *t -= dt;
            if *t <= 0.0 {
                self.toast = None;
            }
        }

        // ---- 全局快捷键 ----
        ctx.input(|i| {
            if i.key_pressed(egui::Key::Space) {
                self.paused = !self.paused;
            }
            for t in Tool::ALL {
                if i.key_pressed(t.key()) {
                    self.tool = t;
                }
            }
            if i.key_pressed(egui::Key::R) {
                self.cam = Camera::default();
            }
            if i.key_pressed(egui::Key::F1) {
                self.debug = !self.debug;
            }
            if i.key_pressed(egui::Key::F2) {
                self.heat = match self.heat {
                    None => Some(HeatChannel::Perfusion),
                    Some(HeatChannel::Perfusion) => Some(HeatChannel::Oxygen),
                    Some(HeatChannel::Oxygen) => Some(HeatChannel::Temperature),
                    Some(HeatChannel::Temperature) => Some(HeatChannel::Damage),
                    Some(HeatChannel::Damage) => None,
                };
            }
        });

        self.tick_shot(ctx);

        ui::layout(ctx, self);

        egui::CentralPanel::default()
            .frame(egui::Frame::NONE.fill(view::c32(anatomize_core::geom::ui::BG)))
            .show(ctx, |ui| {
                let (resp, painter) =
                    ui.allocate_painter(ui.available_size(), egui::Sense::click_and_drag());
                let view_rect = resp.rect;

                // ---- 相机 ----
                let hover = ctx.input(|i| i.pointer.hover_pos());
                if let Some(p) = hover
                    && view_rect.contains(p)
                {
                    let scroll = ctx.input(|i| i.raw_scroll_delta.y);
                    if scroll.abs() > 0.0 {
                        self.cam.zoom_at(p, view_rect, (scroll * 0.0015).exp());
                    }
                }
                if resp.dragged_by(egui::PointerButton::Secondary) {
                    let d = resp.drag_delta();
                    self.cam.center += Vec2::new(-d.x, d.y) / self.cam.zoom;
                }

                // ---- 交互 ----
                let pointer = ctx.input(|i| i.pointer.interact_pos());
                if resp.drag_started_by(egui::PointerButton::Primary)
                    && let Some(p) = pointer
                {
                    let w = self.cam.to_world(p, view_rect);
                    let mut d = Drag::new(w);
                    if self.tool == Tool::Hand {
                        d.grabbed = self.piece_at(w);
                    }
                    self.drag = Some(d);
                }
                if resp.dragged_by(egui::PointerButton::Primary)
                    && let Some(p) = pointer
                    && let Some(d) = &mut self.drag
                {
                    d.to = self.cam.to_world(p, view_rect);
                }
                if resp.drag_stopped_by(egui::PointerButton::Primary)
                    && let Some(d) = self.drag.take()
                {
                    self.release(&d);
                }
                if self.tool == Tool::Hand
                    && resp.dragged_by(egui::PointerButton::Primary)
                    && let Some(p) = pointer
                {
                    let w = self.cam.to_world(p, view_rect);
                    self.drag_piece(w);
                }

                // ---- 渲染 ----
                let v = view::View {
                    sim: &self.sim,
                    cam: &self.cam,
                    heat: self.heat,
                    debug: self.debug,
                };
                v.paint(&painter, view_rect);

                // 刀线预览
                if self.tool == Tool::Knife
                    && let Some(d) = &self.drag
                {
                    let a = self.cam.to_screen(d.from, view_rect);
                    let b = self.cam.to_screen(d.to, view_rect);
                    painter.line_segment(
                        [a, b],
                        egui::Stroke::new(2.0_f32, view::c32([255, 90, 90, 230])),
                    );
                    painter.circle_filled(a, 3.0, view::c32([255, 90, 90, 255]));
                    painter.circle_filled(b, 3.0, view::c32([255, 90, 90, 255]));
                }

                ui::overlay(self, &painter, view_rect);
            });

        // 让时间流动起来（不请求重绘的话，暂停时窗口不刷新）
        ctx.request_repaint();
    }
}

fn main() -> eframe::Result<()> {
    let opts = eframe::NativeOptions {
        viewport: egui::ViewportBuilder::default()
            .with_inner_size([1280.0, 800.0])
            .with_min_inner_size([900.0, 600.0])
            .with_title("Anatomize"),
        ..Default::default()
    };
    eframe::run_native("Anatomize", opts, Box::new(|cc| Ok(Box::new(App::new(cc)))))
}
