#!/usr/bin/env python3
"""把 release 产物打包到 dist/。

约定（见 `.workbuddy-ai/memory/MEMORY.md`）：

- 每次完成任务都跑一遍，产物放 `dist/`，**不进版本库**（`.gitignore` 已排除）。
- `dist/` 里同时留一份解包好的目录（能直接双击跑）和一个 zip（能发给别人）。

用法：

    python scripts/package.py              # 先 cargo build --release，再打包
    python scripts/package.py --no-build   # 用现有的 target/release 直接打包

产物：

    dist/anatomize-<版本>-win64/
        *.exe
        assets/
        README.txt
    dist/anatomize-<版本>-win64.zip
"""

from __future__ import annotations

import argparse
import datetime as dt
import shutil
import subprocess
import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DIST = ROOT / "dist"
TARGET = ROOT / "target" / "release"


def version() -> str:
    """从 workspace 的 Cargo.toml 读版本号。"""
    for line in (ROOT / "Cargo.toml").read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if line.startswith("version") and "=" in line:
            return line.split("=", 1)[1].strip().strip('"')
    return "0.0.0"


def build() -> None:
    print("[1/4] cargo build --release ...")
    r = subprocess.run(
        ["cargo", "build", "--release", "--workspace"],
        cwd=ROOT,
        text=True,
    )
    if r.returncode != 0:
        sys.exit("构建失败，停止打包")


def collect_bins() -> list[Path]:
    """只收真正的可执行文件。

    `target/release/` 里还有一堆 `.d` / `.pdb` / 无后缀的增量文件，按
    "无后缀即程序"筛会混进来。
    """
    if sys.platform == "win32":
        bins = sorted(TARGET.glob("*.exe"))
    else:
        bins = [
            p
            for p in sorted(TARGET.glob("*"))
            if p.is_file() and p.suffix == "" and p.stat().st_mode & 0o111
        ]
    if not bins:
        sys.exit("target/release 里没有可执行文件，先构建")
    return bins


def copy_tree(src: Path, dst: Path) -> None:
    if src.is_dir():
        shutil.copytree(src, dst)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--no-build", action="store_true", help="跳过 cargo build")
    args = ap.parse_args()

    ver = version()
    name = f"anatomize-{ver}-win64"
    stage = DIST / name

    if not args.no_build:
        build()
    else:
        print("[1/4] 跳过构建")

    print(f"[2/4] 清理 {stage} ...")
    if stage.exists():
        shutil.rmtree(stage)
    stage.mkdir(parents=True)

    bins = collect_bins()
    print(f"[3/4] 复制 {len(bins)} 个可执行文件 + assets ...")
    for b in bins:
        shutil.copy2(b, stage / b.name)
    copy_tree(ROOT / "assets", stage / "assets")
    copy_tree(ROOT / "docs", stage / "docs")

    total = sum(f.stat().st_size for f in stage.rglob("*") if f.is_file())
    readme = f"""Anatomize {ver}
==================================================

2D 解剖沙盒。构建时间：{dt.datetime.now():%Y-%m-%d %H:%M}

所有程序都是**离线验收工具**：不开窗口，直接跑出 PNG 和数字。
这是刻意的——核心 crate 不依赖 Bevy，所以能在没有 GPU 的环境里跑参数扫描。

可执行文件
--------------------------------------------------
  p05_demo.exe    5 秒回溯 + 参数扫描      -> docs/p05_rewind_scan.png
  m6_demo.exe     断面分层 + 碎片 + 监护仪  -> docs/m6_section_hud.png
  m5_demo.exe     冷、饿、疼               -> docs/m5_cold_food_pain.png
  m4_demo.exe     失血闭环                 -> docs/m4_hemorrhage.png
  m3_demo.exe     关节状态机 + 断供        -> docs/m3-*.png
  cut_demo.exe    多边形切割
  tissue_demo.exe 组织场四个通道
  ragdoll.exe     M0 的 ragdoll 落地
  scan.exe        批量参数实验（CSV 输出）

批量实验
--------------------------------------------------
  scan.exe --scenario bleed-femoral --param tone_max=0.3:1.0:0.175 --fast
  scan.exe --help

用法
--------------------------------------------------
  m6_demo.exe                 # 中文（默认）
  m6_demo.exe --lang en       # 英文
  set ANATOMIZE_LANG=en && m6_demo.exe
  set ANATOMIZE_FONT=D:\\fonts\\msyh.ttc && m6_demo.exe

中文字形从系统字体读（Windows 的微软雅黑 / macOS 苹方 / Linux Noto CJK），
字体文件不进发行包。找不到就自动退回英文。

配置
--------------------------------------------------
  assets/config/tissue.ron    组织场
  assets/config/damage.ron    关节损伤
  assets/config/physio.ron    生理
  assets/config/ui.ron        界面语言

体积
--------------------------------------------------
  解包后 {total / 1024 / 1024:.1f} MB
"""
    (stage / "README.txt").write_text(readme, encoding="utf-8")

    zip_path = DIST / f"{name}.zip"
    print(f"[4/4] 打包 {zip_path.name} ...")
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for f in sorted(stage.rglob("*")):
            if f.is_file():
                z.write(f, f.relative_to(DIST))

    zsize = zip_path.stat().st_size
    print()
    print(f"  {stage}")
    print(f"    解包 {total / 1024 / 1024:.1f} MB，{len(bins)} 个可执行文件")
    print(f"  {zip_path}")
    print(f"    {zsize / 1024 / 1024:.1f} MB")
    print()
    print("dist/ 已被 .gitignore 排除，不会上传。")


if __name__ == "__main__":
    main()
