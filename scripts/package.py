#!/usr/bin/env python3
"""打包**可玩的程序**到 dist/。

注意：这里只打 `anatomize.exe`（窗口版，双击就能切人）。
离线验收工具（m3_demo / m6_demo / scan …）**不进发行包**——那些是开发工具，
玩家不需要，而且会把 20 MB 的包撑到 60 MB。

产物：

    dist/anatomize-<版本>-win64/
        anatomize.exe
        assets/          # 配置（tissue.ron / damage.ron / physio.ron / ui.ron）
        README.txt
    dist/anatomize-<版本>-win64.zip

`dist/` 在 `.gitignore` 里，不上传。

用法：

    python scripts/package.py              # 先 cargo build --release，再打包
    python scripts/package.py --no-build
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
    for line in (ROOT / "Cargo.toml").read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if line.startswith("version") and "=" in line:
            return line.split("=", 1)[1].strip().strip('"')
    return "0.0.0"


def build() -> None:
    print("[1/4] cargo build --release ...")
    r = subprocess.run(
        ["cargo", "build", "--release", "-p", "anatomize-app"],
        cwd=ROOT,
        text=True,
    )
    if r.returncode != 0:
        sys.exit("构建失败，停止打包")


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

    exe_name = "anatomize.exe" if sys.platform == "win32" else "anatomize"
    exe = TARGET / exe_name
    if not exe.exists():
        sys.exit(f"找不到 {exe}，先构建")

    print(f"[2/4] 清理 {stage} ...")
    if stage.exists():
        shutil.rmtree(stage)
    stage.mkdir(parents=True)

    print("[3/4] 复制程序 + assets ...")
    shutil.copy2(exe, stage / exe_name)
    shutil.copytree(ROOT / "assets", stage / "assets")

    size = exe.stat().st_size
    readme = f"""Anatomize {ver}
==================================================

2D 解剖沙盒。构建时间：{dt.datetime.now():%Y-%m-%d %H:%M}

双击 anatomize.exe 就能玩。不开控制台，不需要安装。

操作
--------------------------------------------------
  鼠标左键拖动      用当前工具
  鼠标右键拖动      平移视角
  滚轮              缩放
  空格              暂停 / 继续
  Q                 选择（点一下看属性）
  1 / 2 / 3 / 4 / 5 手 / 刀 / 锤 / 冻结 / 删除
  R                 视角复位
  F1                显示血管和关节
  F2                循环切换组织场热力图

界面
--------------------------------------------------
  左侧   工具栏
  中间   世界（有边界墙）
  右侧   生成道具 / 生理 / 关节 / 环境 / 显示 / 选中属性
  底部   时间控制 · 回滚 · 新建世界 · 保存 · 读取

存档在程序目录的 saves/ 下，RON 格式，可以直接用文本编辑器看。

中文字体
--------------------------------------------------
界面从系统字体读中文字形（Windows 的微软雅黑 / macOS 苹方 / Linux Noto CJK）。
找不到就退回英文，并在右侧面板顶上提示。
要指定字体：set ANATOMIZE_FONT=D:\fonts\msyh.ttc

配置
--------------------------------------------------
  assets/config/tissue.ron    组织场
  assets/config/damage.ron    关节损伤
  assets/config/physio.ron    生理
  assets/config/ui.ron        界面语言

体积
--------------------------------------------------
  程序 {size / 1024 / 1024:.1f} MB
"""
    (stage / "README.txt").write_text(readme, encoding="utf-8")

    zip_path = DIST / f"{name}.zip"
    print(f"[4/4] 打包 {zip_path.name} ...")
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for f in sorted(stage.rglob("*")):
            if f.is_file():
                z.write(f, f.relative_to(DIST))

    total = sum(f.stat().st_size for f in stage.rglob("*") if f.is_file())
    print()
    print(f"  {stage}")
    print(f"    解包 {total / 1024 / 1024:.1f} MB")
    print(f"  {zip_path}")
    print(f"    {zip_path.stat().st_size / 1024 / 1024:.1f} MB")
    print()
    print("dist/ 已被 .gitignore 排除，不会上传。")


if __name__ == "__main__":
    main()
