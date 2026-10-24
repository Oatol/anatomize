//! 物品目录：外置 RON，按分类组织。
//!
//! # 为什么物品是数据不是代码
//!
//! 沙盒游戏里物品会一直加。如果每个物品都是 Rust 里一个 `match` 分支，
//! 加到三十个就开始互相打架：碰撞体、质量、颜色、分类全散在几处。
//!
//! 所以物品定义全在 `assets/items.ron` 里，Rust 只负责：
//!
//! 1. 读目录（`ItemCatalog::asset`）
//! 2. 按 `shape` 建碰撞体
//! 3. 按 `category` 分组给 UI
//!
//! 加一个物品 = 加一条 RON。以后接行为（开火、爆炸、吃）就挂 `tag`，
//! 目录本身保持纯数据——**它不该知道子弹怎么飞**。
//!
//! # 单位
//!
//! 和 `BodyPlan` 一致：厘米、千克。`Box` 的 `w`/`h` 是**半长**。

use anatomize_core::Vec2;
use serde::Deserialize;

pub const ASSET_ITEMS: &str = include_str!("../../../assets/items.ron");

/// 一个物品分类。
#[derive(Debug, Clone, Deserialize)]
pub struct Category {
    pub id: String,
    pub name: String,
    #[serde(default = "default_cat_color")]
    pub color: (u8, u8, u8),
}

fn default_cat_color() -> (u8, u8, u8) {
    (140, 140, 150)
}

/// 形状。尺寸都是厘米，`Box` 的 `w`/`h` 是半长。
#[derive(Debug, Clone, Deserialize)]
pub enum Shape {
    Box { w: f32, h: f32 },
    Ball { r: f32, sides: u32 },
    Poly { points: Vec<(f32, f32)> },
}

impl Shape {
    /// 部件局部厘米坐标下的多边形（逆时针、**凸**）。
    ///
    /// # 为什么一律凸包化
    ///
    /// 物理和渲染都只吃凸多边形：rapier 的 `convex_hull` 要求凸，egui 的
    /// `Shape::convex_polygon` 也要求凸。而真实的物品形状是凹的（手枪的握把、
    /// 工字梁的腹板）。
    ///
    /// 所以这里对 `Poly` 求凸包。代价是细节丢失——手枪变成一块楔形。
    /// 收益是**任何形状都能用**，加物品时不用操心凸性。
    ///
    /// 想要真正的凹形，正确做法是"一个物品 = 多个凸块 + 关节"（以后做机器
    /// 的时候会需要），那是另一套东西。
    pub fn polygon(&self) -> Vec<Vec2> {
        match self {
            Shape::Box { w, h } => vec![
                Vec2::new(-w, -h),
                Vec2::new(*w, -h),
                Vec2::new(*w, *h),
                Vec2::new(-w, *h),
            ],
            Shape::Ball { r, sides } => {
                let n = (*sides).max(6) as usize;
                (0..n)
                    .map(|i| {
                        let a = std::f32::consts::TAU * i as f32 / n as f32;
                        Vec2::new(a.cos() * r, a.sin() * r)
                    })
                    .collect()
            }
            Shape::Poly { points } => {
                let pts: Vec<Vec2> = points.iter().map(|(x, y)| Vec2::new(*x, *y)).collect();
                let hull = anatomize_cut::convex_hull(&pts);
                if hull.len() >= 3 { hull } else { pts }
            }
        }
    }
}

/// 一个物品的定义。
#[derive(Debug, Clone, Deserialize)]
pub struct ItemDef {
    pub id: String,
    pub name: String,
    pub category: String,
    pub shape: Shape,
    /// 质量（kg）。
    pub mass: f32,
    pub color: (u8, u8, u8),
    #[serde(default)]
    pub desc: String,
    /// 行为标签。宿主按它分发（`explosive` / `gun` / `food` …）。
    ///
    /// 目录不实现行为，只声明"我是什么"。这样加物品和加行为可以分开做。
    ///
    /// 用空字符串表示"没有行为"而不是 `Option`：RON 里 `Option` 要写成
    /// `Some("gun")`，多一层括号容易写错；空串在 RON 里就是 `tag: ""`。
    #[serde(default)]
    pub tag: String,
}

impl ItemDef {
    pub fn rgba(&self) -> [u8; 4] {
        [self.color.0, self.color.1, self.color.2, 255]
    }
}

/// 整本目录。
#[derive(Debug, Clone, Deserialize)]
pub struct ItemCatalog {
    pub categories: Vec<Category>,
    pub items: Vec<ItemDef>,
}

impl Default for ItemCatalog {
    fn default() -> Self {
        Self::asset()
    }
}

impl ItemCatalog {
    /// 内置目录。解析失败会 panic——那是构建期错误，不该拖到运行期。
    pub fn asset() -> Self {
        ron::from_str(ASSET_ITEMS).expect("assets/items.ron 解析失败")
    }

    pub fn get(&self, id: &str) -> Option<&ItemDef> {
        self.items.iter().find(|i| i.id == id)
    }

    pub fn by_index(&self, idx: usize) -> Option<&ItemDef> {
        self.items.get(idx)
    }

    /// 某个分类下的物品。
    pub fn in_category<'a>(&'a self, cat: &'a str) -> impl Iterator<Item = &'a ItemDef> + 'a {
        self.items.iter().filter(move |i| i.category == cat)
    }

    pub fn category_of(&self, id: &str) -> Option<&Category> {
        let item = self.get(id)?;
        self.categories.iter().find(|c| c.id == item.category)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn the_catalog_parses_and_every_item_has_a_category() {
        let c = ItemCatalog::asset();
        assert!(c.items.len() >= 10, "物品太少：{}", c.items.len());
        assert!(c.categories.len() >= 4);
        for it in &c.items {
            assert!(
                c.categories.iter().any(|k| k.id == it.category),
                "{} 的分类 {} 不存在",
                it.id,
                it.category
            );
            assert!(it.mass > 0.0, "{} 质量非正", it.id);
        }
    }

    #[test]
    fn every_shape_makes_a_convex_polygon_with_area() {
        let c = ItemCatalog::asset();
        for it in &c.items {
            let poly = it.shape.polygon();
            assert!(poly.len() >= 3, "{} 顶点不足", it.id);
            let area = anatomize_core::polygon_area(&poly).abs();
            assert!(area > 1.0, "{} 面积只有 {area} cm²", it.id);
            // 逆时针
            assert!(
                anatomize_core::polygon_area(&poly) > 0.0,
                "{} 的多边形不是逆时针",
                it.id
            );
            // 凸性：相邻边叉积同号
            let n = poly.len();
            for i in 0..n {
                let a = poly[i];
                let b = poly[(i + 1) % n];
                let cc = poly[(i + 2) % n];
                assert!(
                    (b - a).perp_dot(cc - b) >= -1e-3,
                    "{} 在第 {i} 个顶点不凸",
                    it.id
                );
            }
        }
    }

    #[test]
    fn item_ids_are_unique() {
        let c = ItemCatalog::asset();
        let mut seen = std::collections::HashSet::new();
        for it in &c.items {
            assert!(seen.insert(it.id.clone()), "重复的物品 id：{}", it.id);
        }
    }
}
