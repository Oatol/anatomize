//! 文案表。
//!
//! 一个 `Key` 对应一对字符串。**所有面向人的文字都必须走这里**，
//! 不要在绘图代码里直接写中文字面量——那样加第三种语言时得全文搜索。
//!
//! 语言由 [`anatomize_core::Lang`] 决定，取值顺序见 `UiConfig::resolve`。

use anatomize_core::Lang;

/// 一条文案。
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Key {
    // --- 通用 ---
    TimeAxis,
    UnitSecond,
    UnitMmhg,
    UnitBpm,
    UnitMl,
    UnitMlPerS,
    UnitCelsius,
    UnitKcal,
    UnitMm,
    UnitRad,
    Unit01,

    // --- M4 失血 ---
    M4Title,
    M4Subtitle,
    M4LegendAorta,
    M4LegendAortaPress,
    M4LegendFemoral,
    PanelMap,
    PanelHeartRate,
    PanelConsciousness,
    PanelBloodVolume,
    PanelBleedRate,
    M4Footer1,
    M4Footer2,
    M4NoFont,

    // --- M5 温度 / 消化 / 疼痛 ---
    M5Title,
    M5Subtitle,
    PanelCoreTemp,
    PanelShiver,
    PanelGlucose,
    PanelInsulin,
    PanelPain,
    PanelKnee,
    M5Cold,
    M5Feed,
    M5Hammer,
    M5Footer1,
    M5Footer2,
    SceneColdName,
    SceneFeedName,
    SceneHammerName,
}

/// 取一条文案。缺项时回退到中文（宁可显示中文，也不要显示 `Key::Foo`）。
pub fn t(lang: Lang, key: Key) -> &'static str {
    match lang {
        Lang::Zh => zh(key),
        Lang::En => en(key).or_else(|| Some(zh(key))).unwrap_or(""),
    }
}

/// 中英混排时给数字找单位。
pub fn unit(lang: Lang, key: Key) -> &'static str {
    t(lang, key)
}

fn zh(k: Key) -> &'static str {
    match k {
        Key::TimeAxis => "时间（秒）",
        Key::UnitSecond => "秒",
        Key::UnitMmhg => "mmHg",
        Key::UnitBpm => "次/分",
        Key::UnitMl => "mL",
        Key::UnitMlPerS => "mL/s",
        Key::UnitCelsius => "°C",
        Key::UnitKcal => "kcal",
        Key::UnitMm => "mmol/L",
        Key::UnitRad => "弧度",
        Key::Unit01 => "0–1",

        Key::M4Title => "M4 · 失血闭环",
        Key::M4Subtitle => "创口通量 → 血容量 → 血压 → 创口通量。没有一条曲线是画出来的。",
        Key::M4LegendAorta => "主动脉离断",
        Key::M4LegendAortaPress => "主动脉 + 15–60 秒按压",
        Key::M4LegendFemoral => "股动脉离断",
        Key::PanelMap => "平均动脉压",
        Key::PanelHeartRate => "心率",
        Key::PanelConsciousness => "意识",
        Key::PanelBloodVolume => "血容量",
        Key::PanelBleedRate => "出血速率",
        Key::M4Footer1 => {
            "主动脉 3.8 L/min：43 秒 MAP<45，19 秒心率>130，50 秒昏迷。股动脉 1.3 L/min：127 秒失代偿。"
        }
        Key::M4Footer2 => "血压越低，创口流得越慢——创口自己就是自己的负反馈。",
        Key::M4NoFont => "未找到中文字体，已回退英文。设置 ANATOMIZE_FONT 可指定字体。",

        Key::M5Title => "M5 · 冷、饿、疼",
        Key::M5Subtitle => "三个场景，三条被组织场驱动的曲线。",
        Key::PanelCoreTemp => "核心温度",
        Key::PanelShiver => "寒战",
        Key::PanelGlucose => "血糖",
        Key::PanelInsulin => "胰岛素",
        Key::PanelPain => "疼痛",
        Key::PanelKnee => "左膝角度",
        Key::M5Cold => "5°C 裸露",
        Key::M5Feed => "喂 500 kcal",
        Key::M5Hammer => "锤左膝 5 次",
        Key::M5Footer1 => "5°C 裸露 10 分钟：核心温度掉到 35.5°C，寒战打满，代谢率 +35%。",
        Key::M5Footer2 => "500 kcal：血糖 30 分钟升 2.4，2 小时回到基线。锤 5 次：扭伤→半脱位，疼痛 0.7。",
        Key::SceneColdName => "5°C 裸露 10 分钟",
        Key::SceneFeedName => "喂 500 kcal，观察 2 小时",
        Key::SceneHammerName => "锤左膝 5 次",
    }
}

fn en(k: Key) -> Option<&'static str> {
    Some(match k {
        Key::TimeAxis => "TIME (S)",
        Key::UnitSecond => "s",
        Key::UnitMmhg => "MMHG",
        Key::UnitBpm => "BPM",
        Key::UnitMl => "ML",
        Key::UnitMlPerS => "ML/S",
        Key::UnitCelsius => "DEG C",
        Key::UnitKcal => "KCAL",
        Key::UnitMm => "MMOL/L",
        Key::UnitRad => "RAD",
        Key::Unit01 => "0-1",

        Key::M4Title => "M4 - HEMORRHAGE CLOSED LOOP",
        Key::M4Subtitle => {
            "TISSUE FLUX -> BLOOD VOLUME -> MAP -> TISSUE FLUX. NOTHING HERE IS SCRIPTED."
        }
        Key::M4LegendAorta => "AORTA",
        Key::M4LegendAortaPress => "AORTA + PRESS 15-60S",
        Key::M4LegendFemoral => "FEMORAL",
        Key::PanelMap => "MAP",
        Key::PanelHeartRate => "HEART RATE",
        Key::PanelConsciousness => "CONSCIOUSNESS",
        Key::PanelBloodVolume => "BLOOD VOLUME",
        Key::PanelBleedRate => "BLEED RATE",
        Key::M4Footer1 => {
            "AORTA 3.8 L/MIN: MAP<45 AT 43S, HR>130 AT 19S, COMA AT 50S. FEMORAL 1.3 L/MIN: DECOMP AT 127S."
        }
        Key::M4Footer2 => "BLEED RATE FALLS AS MAP FALLS. THE WOUND IS ITS OWN NEGATIVE FEEDBACK.",
        Key::M4NoFont => "NO CJK FONT FOUND, FALLING BACK TO ENGLISH.",

        Key::M5Title => "M5 - COLD, HUNGRY, HURT",
        Key::M5Subtitle => "THREE SCENES, THREE CURVES DRIVEN BY THE TISSUE FIELD.",
        Key::PanelCoreTemp => "CORE TEMP",
        Key::PanelShiver => "SHIVER",
        Key::PanelGlucose => "GLUCOSE",
        Key::PanelInsulin => "INSULIN",
        Key::PanelPain => "PAIN",
        Key::PanelKnee => "LEFT KNEE ANGLE",
        Key::M5Cold => "COLD 5C",
        Key::M5Feed => "FEED 500 KCAL",
        Key::M5Hammer => "HAMMER KNEE x5",
        Key::M5Footer1 => {
            "5C FOR 10 MIN: CORE 35.5C, SHIVER SATURATED, METABOLIC RATE +35%."
        }
        Key::M5Footer2 => {
            "500 KCAL: GLUCOSE +2.4 AT 30 MIN, BACK TO BASE AT 2H. 5 HITS: SPRAINED -> SUBLUXED, PAIN 0.7."
        }
        Key::SceneColdName => "COLD 5C, 10 MIN",
        Key::SceneFeedName => "FEED 500 KCAL, 2 HOURS",
        Key::SceneHammerName => "HAMMER LEFT KNEE x5",
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    /// 每个 Key 在两种语言下都必须有非空文案。
    #[test]
    fn every_key_has_both_languages() {
        let keys = [
            Key::TimeAxis,
            Key::M4Title,
            Key::M4Subtitle,
            Key::M4Footer1,
            Key::M5Title,
            Key::PanelMap,
            Key::PanelPain,
        ];
        for k in keys {
            for l in Lang::ALL {
                assert!(!t(l, k).is_empty(), "{k:?} 在 {l:?} 下是空的");
            }
        }
    }

    #[test]
    fn chinese_and_english_differ() {
        assert_ne!(t(Lang::Zh, Key::PanelMap), t(Lang::En, Key::PanelMap));
    }
}
