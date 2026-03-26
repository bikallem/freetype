#!/usr/bin/env python3

import os
import subprocess
import sys
import tempfile
from pathlib import Path


SUPPORTED_EXTENSIONS = {
    ".ttf",
    ".otf",
    ".ttc",
    ".woff",
    ".woff2",
    ".cff",
    ".pfb",
    ".pfa",
    ".bdf",
    ".pcf",
    ".fnt",
    ".fon",
}


def run(cmd: list[str], cwd: Path | None = None) -> None:
    subprocess.run(cmd, cwd=cwd, check=True)


def stage_fonts(font_dir: Path, staging_dir: Path, repo_root: Path) -> None:
    for entry in sorted(font_dir.iterdir()):
        if not entry.is_file() or entry.suffix not in SUPPORTED_EXTENSIONS:
            continue
        staged = staging_dir / entry.name
        if entry.suffix == ".woff2":
            run(
                [
                    "moon",
                    "run",
                    "--target",
                    "native",
                    "src/golden_woff2",
                    "--",
                    str(entry),
                    str(staged),
                ],
                cwd=repo_root,
            )
        else:
            os.symlink(entry.resolve(), staged)


def main() -> int:
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <font_dir> <output_dir>", file=sys.stderr)
        return 1

    font_dir = Path(sys.argv[1]).resolve()
    output_dir = Path(sys.argv[2]).resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    script_dir = Path(__file__).resolve().parent
    repo_root = script_dir.parents[2]
    with tempfile.TemporaryDirectory(prefix="gen_golden_fonts_") as tmp_dir:
        staging_dir = Path(tmp_dir)
        stage_fonts(font_dir, staging_dir, repo_root)
        run([str(script_dir / "gen_golden"), str(staging_dir), str(output_dir)])

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
