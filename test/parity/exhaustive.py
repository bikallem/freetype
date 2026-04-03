#!/usr/bin/env python3

from __future__ import annotations

import argparse
import json
import os
import subprocess
import tempfile
from dataclasses import dataclass
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[2]
GOLDEN_DIR = REPO_ROOT / "test" / "golden" / "generate"
ORACLE_BIN = GOLDEN_DIR / "gen_diff_oracle"


@dataclass
class RunConfig:
    font: str
    dimensions: list[str]
    glyph_sizes: list[int] | None = None
    render_sizes: list[int] | None = None
    glyph_load_flags: list[str] | None = None
    render_load_flags: list[str] | None = None
    render_modes: list[str] | None = None
    face_index: int = 0
    kerning_max_glyphs: int = 128
    variation: str = "default"
    name: str | None = None


def run(cmd: list[str], cwd: Path | None = None) -> None:
    subprocess.run(cmd, cwd=cwd, check=True)


def ensure_oracle_binary() -> None:
    if ORACLE_BIN.exists():
        return
    run(["make", "-C", "test/golden/generate", "gen_diff_oracle"], cwd=REPO_ROOT)


def stage_font(font_path: Path, staging_dir: Path) -> Path:
    staging_dir.mkdir(parents=True, exist_ok=True)
    staged = staging_dir / font_path.name
    if font_path.suffix == ".woff2":
        run(
            [
                "moon",
                "run",
                "--target",
                "native",
                "src/golden_woff2",
                "--",
                str(font_path),
                str(staged),
            ],
            cwd=REPO_ROOT,
        )
    else:
        os.symlink(font_path.resolve(), staged)
    return staged


def parse_runs(args: argparse.Namespace) -> list[RunConfig]:
    if args.config:
        data = json.loads(Path(args.config).read_text(encoding="utf-8"))
        return [RunConfig(**entry) for entry in data["runs"]]

    if not args.font:
        raise SystemExit("provide --config or at least one --font")

    dimensions = args.dimensions.split(",")
    glyph_sizes = [int(v) for v in args.glyph_sizes.split(",")] if args.glyph_sizes else None
    render_sizes = [int(v) for v in args.render_sizes.split(",")] if args.render_sizes else None
    glyph_load_flags = (
        args.glyph_load_flags.split(",") if args.glyph_load_flags else None
    )
    render_load_flags = (
        args.render_load_flags.split(",") if args.render_load_flags else None
    )
    render_modes = args.render_modes.split(",") if args.render_modes else None
    return [
        RunConfig(
            font=font,
            dimensions=dimensions,
            glyph_sizes=glyph_sizes,
            render_sizes=render_sizes,
            glyph_load_flags=glyph_load_flags,
            render_load_flags=render_load_flags,
            render_modes=render_modes,
            face_index=args.face_index,
            kerning_max_glyphs=args.kerning_max_glyphs,
            variation=args.variation,
        )
        for font in args.font
    ]


def oracle_cmd(staged_font: Path, oracle_path: Path, cfg: RunConfig) -> list[str]:
    cmd = [
        str(ORACLE_BIN),
        str(staged_font),
        str(oracle_path),
        "--face-index",
        str(cfg.face_index),
        "--dimensions",
        ",".join(cfg.dimensions),
        "--kerning-max-glyphs",
        str(cfg.kerning_max_glyphs),
        "--variation",
        cfg.variation,
    ]
    if cfg.glyph_sizes:
        cmd += ["--glyph-sizes", ",".join(str(v) for v in cfg.glyph_sizes)]
    if cfg.render_sizes:
        cmd += ["--render-sizes", ",".join(str(v) for v in cfg.render_sizes)]
    return cmd


def should_keep_case(obj: dict, cfg: RunConfig) -> bool:
    kind = obj["kind"]
    if kind in {"header", "charmap_meta", "charmap_entry", "kerning"}:
        return True
    if kind in {"glyph_outline", "glyph_bitmap"} and cfg.glyph_load_flags:
        return obj.get("load_flags") in set(cfg.glyph_load_flags)
    if kind == "render_bitmap":
        if cfg.render_load_flags and obj.get("load_flags") not in set(cfg.render_load_flags):
            return False
        if cfg.render_modes and obj.get("render_mode") not in set(cfg.render_modes):
            return False
        return True
    return True


def filter_oracle(raw_oracle: Path, filtered_oracle: Path, cfg: RunConfig) -> int:
    kept = 0
    with raw_oracle.open("r", encoding="utf-8") as src, filtered_oracle.open(
        "w", encoding="utf-8"
    ) as dst:
        for line in src:
            if not line.strip():
                continue
            obj = json.loads(line)
            if should_keep_case(obj, cfg):
                dst.write(json.dumps(obj, separators=(",", ":")) + "\n")
                if obj["kind"] != "header":
                    kept += 1
    return kept


def run_one(cfg: RunConfig) -> None:
    font_path = (REPO_ROOT / cfg.font).resolve()
    if not font_path.exists():
        raise FileNotFoundError(font_path)

    label = cfg.name or font_path.name
    print(f"[exhaustive] {label}", flush=True)
    with tempfile.TemporaryDirectory(prefix="freetype-exhaustive-") as tmp:
        tmpdir = Path(tmp)
        staged_font = stage_font(font_path, tmpdir / "staged")
        raw_oracle = tmpdir / "oracle.raw.ndjson"
        filtered_oracle = tmpdir / "oracle.ndjson"

        run(oracle_cmd(staged_font, raw_oracle, cfg), cwd=REPO_ROOT)
        kept = filter_oracle(raw_oracle, filtered_oracle, cfg)
        if kept == 0:
            raise RuntimeError(f"oracle filter removed all cases for {label}")

        run(
            [
                "moon",
                "run",
                "--target",
                "native",
                "src/parity_diff",
                "--",
                str(font_path),
                str(filtered_oracle),
            ],
            cwd=REPO_ROOT,
        )


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Run whole-font or selected-dimension differential sweeps against vendored FreeType."
    )
    parser.add_argument("--config", help="JSON file containing a runs array")
    parser.add_argument("--font", action="append", help="Font path relative to repo root")
    parser.add_argument("--dimensions", default="charmaps,glyphs,render,kerning")
    parser.add_argument("--glyph-sizes")
    parser.add_argument("--render-sizes")
    parser.add_argument("--glyph-load-flags")
    parser.add_argument("--render-load-flags")
    parser.add_argument("--render-modes")
    parser.add_argument("--face-index", type=int, default=0)
    parser.add_argument("--kerning-max-glyphs", type=int, default=128)
    parser.add_argument("--variation", default="default", choices=["default", "non-default"])
    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    runs = parse_runs(args)
    ensure_oracle_binary()
    for cfg in runs:
        run_one(cfg)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
