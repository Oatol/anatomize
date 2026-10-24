//! Anatomize 的基础类型层。
//!
//! 这里只放不依赖任何引擎、物理库或 IO 的东西：ID、时间、确定性随机数、伤害事件。
//! 所有上层 crate 都可以依赖它，它不依赖任何人。

pub mod ids;
pub mod injury;
pub mod lang;
pub mod rng;
pub mod time;

pub use glam::Vec2;
pub use ids::*;
pub use injury::*;
pub use lang::{ASSET_UI_CONFIG, Lang, UiConfig};
pub use rng::Rng;
pub use time::*;
