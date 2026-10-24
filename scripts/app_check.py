#!/usr/bin/env python3
"""窗口版的自动验收：启动 → 截图 → 数像素。

窗口版是唯一"必须用眼睛看"的产物，但写它的人和验证它的工具都看不到屏幕。
所以走这条路：程序自己截图（`--shot`），这里再数像素。

检查三件事：

1. **身体画出来了**：断面四层色都要有像素，加起来占画面 3% 以上。
2. **切开会变**：`--after cut` 和原图的逐像素差异 > 5%。
3. **热力图会变**：`--after heat` 的差异 > 1%。

用法：

    python scripts/app_check.py                    # debug 构建
    python scripts/app_check.py --release          # release 构建
    python scripts/app_check.py --exe path/to.exe
"""

from __future__ import annotations

import argparse
import collections
import subprocess
import sys
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    sys.exit("需要 Pillow：pip install Pillow")

ROOT = Path(__file__).resolve().parent.parent

# 断面分层色（和 anatomize-body::palette 一致）
LAYERS = {
    "皮肤": (230, 178, 146),
    "脂肪": (240, 214, 136),
    "肌肉": (166, 54, 54),
    "骨": (238, 232, 212),
}
BG = (18, 17, 22)


def shoot(exe: Path, out: Path, action: str | None) -> None:
    cmd = [str(exe), "--shot", str(out)]
    if action:
        cmd += ["--after", action]
    r = subprocess.run(cmd, capture_output=True, text=True, timeout=60)
    if r.returncode != 0:
        sys.exit(f"启动失败（rc={r.returncode}）：\n{r.stderr[-1500:]}")
    if not out.exists():
        sys.exit(f"没有生成 {out}\n{r.stdout[-800:]}")


def hist(path: Path) -> tuple[dict[tuple[int, int, int], int], int]:
    im = Image.open(path).convert("RGBA")
    w, h = im.size
    px = im.load()
    c: collections.Counter = collections.Counter()
    for y in range(h):
        for x in range(w):
            c[px[x, y][:3]] += 1
    return c, w * h


def diff(a: Path, b: Path) -> float:
    ia = Image.open(a).convert("RGBA")
    ib = Image.open(b).convert("RGBA")
    if ia.size != ib.size:
        sys.exit("两张图尺寸不同")
    w, h = ia.size
    pa, pb = ia.load(), ib.load()
    n = 0
    for y in range(h):
        for x in range(w):
            if pa[x, y] != pb[x, y]:
                n += 1
    return n / (w * h)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--release", action="store_true")
    ap.add_argument("--exe")
    args = ap.parse_args()

    if args.exe:
        exe = Path(args.exe)
    else:
        prof = "release" if args.release else "debug"
        exe = ROOT / "target" / prof / ("anatomize.exe" if sys.platform == "win32" else "anatomize")
    if not exe.exists():
        sys.exit(f"找不到 {exe}，先 cargo build -p anatomize-app")

    out = ROOT / "out"
    out.mkdir(exist_ok=True)
    base = out / "app.png"
    cut = out / "app-cut.png"
    heat = out / "app-heat.png"

    print("[1/4] 正常画面 …")
    shoot(exe, base, None)
    h, total = hist(base)
    for name, c in LAYERS.items():
        n = h.get(c, 0)
        print(f"  {name:4} {n:>7} px  {n * 100 / total:5.2f}%")
    body = sum(h.get(c, 0) for c in LAYERS.values())
    share = body / total
    missing = [n for n, c in LAYERS.items() if h.get(c, 0) == 0]
    if missing:
        sys.exit(f"断面缺了这些层：{missing}")
    if share < 0.03:
        sys.exit(f"身体只占 {share * 100:.2f}%，画布中心或缩放错了")
    print(f"  身体合计 {share * 100:.2f}%")

    # UI 三块面板必须都有东西（不是纯背景）
    im = Image.open(base).convert("RGBA")
    w, h = im.size
    px = im.load()

    def painted(x0, y0, x1, y1):
        n = 0
        for y in range(y0, y1, 3):
            for x in range(x0, x1, 3):
                if px[x, y][:3] != BG:
                    n += 1
        return n / max(1, len(range(y0, y1, 3)) * len(range(x0, x1, 3)))

    left = painted(0, 0, 60, h - 46)
    right = painted(w - 232, 0, w, h - 46)
    bottom = painted(60, h - 46, w - 232, h)
    print(f"  工具栏 {left * 100:.1f}% · 物品栏 {right * 100:.1f}% · 时间条 {bottom * 100:.1f}%")
    for name, v in [("工具栏", left), ("物品栏", right), ("时间条", bottom)]:
        if v < 0.3:
            sys.exit(f"{name}几乎是空的（{v * 100:.1f}%），UI 没画出来")

    print("[2/5] 切开 …")
    shoot(exe, cut, "cut")
    d = diff(base, cut)
    print(f"  和原图差 {d * 100:.2f}%")
    if d < 0.05:
        sys.exit(f"切开之后画面几乎没变（{d * 100:.2f}%），切片没生效？")

    print("[3/5] 热力图 …")
    shoot(exe, heat, "heat")
    d2 = diff(base, heat)
    print(f"  和原图差 {d2 * 100:.2f}%")
    if d2 < 0.01:
        sys.exit(f"热力图叠加没生效（{d2 * 100:.2f}%）")

    print("[4/5] 道具 …")
    props = out / "app-props.png"
    shoot(exe, props, "props")
    d3 = diff(base, props)
    print(f"  和原图差 {d3 * 100:.2f}%")
    if d3 < 0.05:
        sys.exit(f"生成道具之后画面几乎没变（{d3 * 100:.2f}%）")

    print("[5/5] 通过")
    for p in (base, cut, heat, props):
        print(f"  {p.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
