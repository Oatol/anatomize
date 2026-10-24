//! 界面语言。
//!
//! 只有两个值，但值得单独放一层：HUD、验收图、日志、报错都要用它，
//! 而且它必须是**可配置**的——外置在 `assets/config/ui.ron`，改一行就换语言，
//! 不用重编译，也不用在代码里到处写 `if lang == ...`。
//!
//! 真正把字符串集中起来的是 `anatomize-tools` 的 `i18n` 模块（`Key` + `t()`）。
//! 这里只定义"有哪几种语言"，因为存档、配置、宿主 UI 都需要这个类型，
//! 而那些东西不该依赖 `tools`。

use serde::Deserialize;

pub const ASSET_UI_CONFIG: &str = include_str!("../../../assets/config/ui.ron");

/// 界面语言。
#[derive(Debug, Clone, Copy, PartialEq, Eq, Default, Deserialize)]
pub enum Lang {
    /// 简体中文。
    #[default]
    Zh,
    /// English.
    En,
}

impl Lang {
    pub const ALL: [Lang; 2] = [Lang::Zh, Lang::En];

    /// 从 `"zh"` / `"en"` / `"zh-CN"` 这类字符串解析。大小写不敏感。
    pub fn parse(s: &str) -> Option<Self> {
        let head = s.split(['-', '_']).next().unwrap_or(s).to_ascii_lowercase();
        match head.as_str() {
            "zh" | "cn" | "chs" | "chinese" | "中文" => Some(Lang::Zh),
            "en" | "eng" | "english" => Some(Lang::En),
            _ => None,
        }
    }

    /// 语言标签，`zh` / `en`。
    pub fn tag(self) -> &'static str {
        match self {
            Lang::Zh => "zh",
            Lang::En => "en",
        }
    }

    /// 用该语言写的语言名（切换菜单里显示用）。
    pub fn native_name(self) -> &'static str {
        match self {
            Lang::Zh => "中文",
            Lang::En => "English",
        }
    }
}

/// 界面配置。目前只有语言，以后加主题 / 单位制 / 字号都放这里。
#[derive(Debug, Clone, Copy, Deserialize)]
#[serde(default)]
pub struct UiConfig {
    pub lang: Lang,
}

impl Default for UiConfig {
    fn default() -> Self {
        Self { lang: Lang::Zh }
    }
}

impl UiConfig {
    pub fn from_ron(src: &str) -> Result<Self, ron::error::SpannedError> {
        ron::from_str(src)
    }

    /// 内置默认配置（`assets/config/ui.ron`）。
    pub fn asset() -> Self {
        Self::from_ron(ASSET_UI_CONFIG).expect("内置 ui.ron 必须能解析")
    }

    /// 按优先级决定语言：命令行 `--lang` > 环境变量 `ANATOMIZE_LANG` > `ui.ron`。
    ///
    /// 命令行参数用 `--lang zh` / `--lang=en` 两种写法都认。
    pub fn resolve() -> Lang {
        let args: Vec<String> = std::env::args().collect();
        for (i, a) in args.iter().enumerate() {
            let v = if let Some(rest) = a.strip_prefix("--lang=") {
                Some(rest)
            } else if a == "--lang" {
                args.get(i + 1).map(|s| s.as_str())
            } else {
                None
            };
            if let Some(l) = v.and_then(Lang::parse) {
                return l;
            }
        }
        if let Ok(v) = std::env::var("ANATOMIZE_LANG")
            && let Some(l) = Lang::parse(&v)
        {
            return l;
        }
        Self::asset().lang
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn asset_config_parses() {
        let ui = UiConfig::asset();
        assert_eq!(ui.lang, Lang::Zh);
    }

    #[test]
    fn tags_and_names_round_trip() {
        for l in Lang::ALL {
            assert_eq!(Lang::parse(l.tag()), Some(l));
            assert!(!l.native_name().is_empty());
        }
    }

    #[test]
    fn accepts_locale_variants() {
        assert_eq!(Lang::parse("zh-CN"), Some(Lang::Zh));
        assert_eq!(Lang::parse("zh_TW"), Some(Lang::Zh));
        assert_eq!(Lang::parse("EN"), Some(Lang::En));
        assert_eq!(Lang::parse("fr"), None);
    }
}
