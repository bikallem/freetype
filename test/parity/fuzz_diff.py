#!/usr/bin/env python3

from __future__ import annotations

import argparse
import json
import random
import struct
import subprocess
import tempfile
from dataclasses import dataclass
from pathlib import Path

import exhaustive


REPO_ROOT = exhaustive.REPO_ROOT
ARTIFACT_DIR = REPO_ROOT / "test" / "parity" / "artifacts"
PROBE_CMD = ["moon", "run", "--target", "native", "src/parity_probe", "--"]
DIFF_CMD = ["moon", "run", "--target", "native", "src/parity_diff", "--"]
COMMAND_TIMEOUT_SEC = 20


@dataclass
class SeedConfig:
    name: str
    focus_tags: list[str]
    run: exhaustive.RunConfig


@dataclass
class ComparisonResult:
    status: str
    ft_ok: bool
    moon_ok: bool
    ft_stdout: str
    ft_stderr: str
    moon_stdout: str
    moon_stderr: str
    diff_stdout: str = ""
    diff_stderr: str = ""
    oracle_text: str = ""


def load_seeds(config_path: Path) -> list[SeedConfig]:
    data = json.loads(config_path.read_text(encoding="utf-8"))
    seeds: list[SeedConfig] = []
    for entry in data["seeds"]:
        run_cfg = exhaustive.RunConfig(**entry["run"])
        seeds.append(
            SeedConfig(
                name=entry["name"],
                focus_tags=entry["focus_tags"],
                run=run_cfg,
            )
        )
    return seeds


def run_capture(cmd: list[str], cwd: Path | None = None) -> subprocess.CompletedProcess[str]:
    try:
        return subprocess.run(
            cmd,
            cwd=cwd,
            text=True,
            capture_output=True,
            timeout=COMMAND_TIMEOUT_SEC,
        )
    except subprocess.TimeoutExpired as exc:
        stdout = exc.stdout if isinstance(exc.stdout, str) else ""
        stderr = exc.stderr if isinstance(exc.stderr, str) else ""
        timeout_msg = f"TIMEOUT after {COMMAND_TIMEOUT_SEC}s"
        if stderr:
            stderr = f"{stderr}\n{timeout_msg}"
        else:
            stderr = timeout_msg
        return subprocess.CompletedProcess(cmd, 124, stdout, stderr)


def parse_sfnt_tables(data: bytes) -> dict[str, dict[str, int]]:
    if len(data) < 12 or data[:4] not in {b"\x00\x01\x00\x00", b"OTTO"}:
        raise ValueError("seed is not a standard SFNT font")
    num_tables = struct.unpack(">H", data[4:6])[0]
    tables: dict[str, dict[str, int]] = {}
    for i in range(num_tables):
        record_offset = 12 + i * 16
        if record_offset + 16 > len(data):
            break
        tag = data[record_offset : record_offset + 4].decode("ascii", errors="replace")
        _, offset, length = struct.unpack(">III", data[record_offset + 4 : record_offset + 16])
        tables[tag] = {
            "record_offset": record_offset,
            "offset": offset,
            "length": length,
        }
    return tables


def preferred_tags(seed: SeedConfig, tables: dict[str, dict[str, int]]) -> list[str]:
    tags = [tag for tag in seed.focus_tags if tag in tables]
    return tags or list(tables)


def choose_body_offset(rng: random.Random, table: dict[str, int]) -> int:
    length = table["length"]
    if length <= 1:
        return 0
    start = 8 if length > 8 else 0
    return rng.randrange(start, length)


def choose_operation(
    rng: random.Random,
    seed: SeedConfig,
    tables: dict[str, dict[str, int]],
    aggressive: bool,
) -> dict:
    tag = rng.choice(preferred_tags(seed, tables))
    table = tables[tag]
    op_kinds = ["flip_byte", "zero_slice"]
    if aggressive:
        op_kinds += ["shrink_length", "shift_offset", "truncate_tail"]
    kind = rng.choice(op_kinds)

    if kind == "flip_byte":
        return {
            "kind": kind,
            "tag": tag,
            "offset": choose_body_offset(rng, table),
            "xor": rng.choice([0x01, 0x04, 0x10, 0x40, 0x80]),
        }
    if kind == "zero_slice":
        max_len = min(4, max(1, table["length"]))
        start = choose_body_offset(rng, table)
        return {
            "kind": kind,
            "tag": tag,
            "offset": start,
            "length": rng.randint(1, max_len),
        }
    if kind == "shrink_length":
        delta = rng.randint(1, min(4, max(1, table["length"] - 1)))
        return {"kind": kind, "tag": tag, "delta": delta}
    if kind == "shift_offset":
        delta = rng.choice([-8, -4, 4, 8])
        return {"kind": kind, "tag": tag, "delta": delta}
    delta = rng.randint(1, min(8, max(1, table["length"])))
    return {"kind": "truncate_tail", "delta": delta}


def apply_operation(data: bytearray, tables: dict[str, dict[str, int]], op: dict) -> bytearray:
    out = bytearray(data)
    kind = op["kind"]
    if kind == "truncate_tail":
        delta = min(op["delta"], max(1, len(out) - 1))
        del out[-delta:]
        return out

    table = tables[op["tag"]]
    record_offset = table["record_offset"]
    table_offset = table["offset"]
    table_length = table["length"]
    if kind == "flip_byte":
        pos = min(table_offset + op["offset"], len(out) - 1)
        out[pos] ^= op["xor"]
    elif kind == "zero_slice":
        start = min(table_offset + op["offset"], len(out))
        end = min(start + op["length"], table_offset + table_length, len(out))
        out[start:end] = b"\x00" * max(0, end - start)
    elif kind == "shrink_length":
        new_length = max(1, table_length - op["delta"])
        out[record_offset + 12 : record_offset + 16] = struct.pack(">I", new_length)
    elif kind == "shift_offset":
        new_offset = max(0, table_offset + op["delta"])
        out[record_offset + 8 : record_offset + 12] = struct.pack(">I", new_offset)
    else:
        raise ValueError(f"unsupported mutation kind: {kind}")
    return out


def apply_operations(data: bytes, ops: list[dict]) -> bytes:
    tables = parse_sfnt_tables(data)
    mutated = bytearray(data)
    for op in ops:
        mutated = apply_operation(mutated, tables, op)
    return bytes(mutated)


def compare_font(font_path: Path, run_cfg: exhaustive.RunConfig, tmpdir: Path) -> ComparisonResult:
    raw_oracle = tmpdir / "oracle.raw.ndjson"
    filtered_oracle = tmpdir / "oracle.ndjson"
    ft = run_capture(exhaustive.oracle_cmd(font_path, raw_oracle, run_cfg), cwd=REPO_ROOT)
    moon = run_capture([*PROBE_CMD, str(font_path)], cwd=REPO_ROOT)
    ft_ok = ft.returncode == 0
    moon_ok = moon.returncode == 0

    if ft_ok != moon_ok:
        return ComparisonResult(
            status="load-status-mismatch",
            ft_ok=ft_ok,
            moon_ok=moon_ok,
            ft_stdout=ft.stdout,
            ft_stderr=ft.stderr,
            moon_stdout=moon.stdout,
            moon_stderr=moon.stderr,
        )
    if not ft_ok and not moon_ok:
        return ComparisonResult(
            status="both-rejected",
            ft_ok=False,
            moon_ok=False,
            ft_stdout=ft.stdout,
            ft_stderr=ft.stderr,
            moon_stdout=moon.stdout,
            moon_stderr=moon.stderr,
        )

    kept = exhaustive.filter_oracle(raw_oracle, filtered_oracle, run_cfg)
    if kept == 0:
        return ComparisonResult(
            status="load-only-ok",
            ft_ok=True,
            moon_ok=True,
            ft_stdout=ft.stdout,
            ft_stderr=ft.stderr,
            moon_stdout=moon.stdout,
            moon_stderr=moon.stderr,
        )

    diff = run_capture([*DIFF_CMD, str(font_path), str(filtered_oracle)], cwd=REPO_ROOT)
    if diff.returncode != 0:
        return ComparisonResult(
            status="semantic-mismatch",
            ft_ok=True,
            moon_ok=True,
            ft_stdout=ft.stdout,
            ft_stderr=ft.stderr,
            moon_stdout=moon.stdout,
            moon_stderr=moon.stderr,
            diff_stdout=diff.stdout,
            diff_stderr=diff.stderr,
            oracle_text=filtered_oracle.read_text(encoding="utf-8"),
        )
    return ComparisonResult(
        status="ok",
        ft_ok=True,
        moon_ok=True,
        ft_stdout=ft.stdout,
        ft_stderr=ft.stderr,
        moon_stdout=moon.stdout,
        moon_stderr=moon.stderr,
    )


def reproduces_mismatch(base_data: bytes, ops: list[dict], seed: SeedConfig) -> bool:
    with tempfile.TemporaryDirectory(prefix="freetype-fuzz-min-") as tmp:
        tmpdir = Path(tmp)
        mutated_path = tmpdir / Path(seed.run.font).name
        mutated_path.write_bytes(apply_operations(base_data, ops))
        result = compare_font(mutated_path, seed.run, tmpdir)
        return result.status in {"load-status-mismatch", "semantic-mismatch"}


def minimize_ops(base_data: bytes, ops: list[dict], seed: SeedConfig) -> list[dict]:
    minimized = list(ops)
    changed = True
    while changed and len(minimized) > 1:
        changed = False
        for i in range(len(minimized)):
            candidate = minimized[:i] + minimized[i + 1 :]
            if reproduces_mismatch(base_data, candidate, seed):
                minimized = candidate
                changed = True
                break
    return minimized


def save_artifact(
    artifact_dir: Path,
    case_id: str,
    seed: SeedConfig,
    mutated_bytes: bytes,
    ops: list[dict],
    result: ComparisonResult,
) -> None:
    out_dir = artifact_dir / case_id
    out_dir.mkdir(parents=True, exist_ok=True)
    (out_dir / Path(seed.run.font).name).write_bytes(mutated_bytes)
    (out_dir / "manifest.json").write_text(
        json.dumps(
            {
                "seed": seed.name,
                "font": seed.run.font,
                "status": result.status,
                "operations": ops,
                "run": seed.run.__dict__,
            },
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )
    (out_dir / "ft.stdout.txt").write_text(result.ft_stdout, encoding="utf-8")
    (out_dir / "ft.stderr.txt").write_text(result.ft_stderr, encoding="utf-8")
    (out_dir / "moon.stdout.txt").write_text(result.moon_stdout, encoding="utf-8")
    (out_dir / "moon.stderr.txt").write_text(result.moon_stderr, encoding="utf-8")
    if result.diff_stdout:
        (out_dir / "diff.stdout.txt").write_text(result.diff_stdout, encoding="utf-8")
    if result.diff_stderr:
        (out_dir / "diff.stderr.txt").write_text(result.diff_stderr, encoding="utf-8")
    if result.oracle_text:
        (out_dir / "oracle.ndjson").write_text(result.oracle_text, encoding="utf-8")


def run_case(
    rng: random.Random,
    index: int,
    seed: SeedConfig,
    aggressive: bool,
    max_ops: int,
    artifact_dir: Path,
) -> str:
    base_path = (REPO_ROOT / seed.run.font).resolve()
    base_data = base_path.read_bytes()
    tables = parse_sfnt_tables(base_data)
    op_count = rng.randint(1, max_ops)
    ops = [choose_operation(rng, seed, tables, aggressive) for _ in range(op_count)]
    mutated_bytes = apply_operations(base_data, ops)

    with tempfile.TemporaryDirectory(prefix="freetype-fuzz-case-") as tmp:
        tmpdir = Path(tmp)
        mutated_path = tmpdir / base_path.name
        mutated_path.write_bytes(mutated_bytes)
        result = compare_font(mutated_path, seed.run, tmpdir)

    if result.status not in {"load-status-mismatch", "semantic-mismatch"}:
        return result.status

    minimized_ops = minimize_ops(base_data, ops, seed)
    minimized_bytes = apply_operations(base_data, minimized_ops)
    case_id = f"{index:03d}-{seed.name}-{result.status}"
    with tempfile.TemporaryDirectory(prefix="freetype-fuzz-save-") as tmp:
        tmpdir = Path(tmp)
        minimized_path = tmpdir / base_path.name
        minimized_path.write_bytes(minimized_bytes)
        minimized_result = compare_font(minimized_path, seed.run, tmpdir)
        artifact_result = (
            minimized_result
            if minimized_result.status in {"load-status-mismatch", "semantic-mismatch"}
            else result
        )
        save_artifact(
            artifact_dir,
            case_id,
            seed,
            minimized_bytes,
            minimized_ops,
            artifact_result,
        )
    return result.status


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Run repeatable generated/mutational differentials against vendored FreeType."
    )
    parser.add_argument(
        "--config",
        default="test/parity/fuzz_seeds.json",
        help="Seed config JSON path relative to repo root",
    )
    parser.add_argument("--seed", type=int, default=20260403)
    parser.add_argument("--cases", type=int, default=8)
    parser.add_argument("--max-ops", type=int, default=2)
    parser.add_argument("--aggressive", action="store_true")
    parser.add_argument(
        "--artifact-dir",
        default="test/parity/artifacts",
        help="Directory for minimized repro artifacts",
    )
    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    exhaustive.ensure_oracle_binary()
    seeds = load_seeds(REPO_ROOT / args.config)
    artifact_dir = REPO_ROOT / args.artifact_dir
    artifact_dir.mkdir(parents=True, exist_ok=True)
    rng = random.Random(args.seed)

    summary: dict[str, int] = {
        "ok": 0,
        "both-rejected": 0,
        "load-only-ok": 0,
        "load-status-mismatch": 0,
        "semantic-mismatch": 0,
    }
    for index in range(args.cases):
        seed_cfg = rng.choice(seeds)
        status = run_case(
            rng,
            index,
            seed_cfg,
            args.aggressive,
            args.max_ops,
            artifact_dir,
        )
        summary[status] = summary.get(status, 0) + 1
        print(f"[fuzz] case={index:03d} seed={seed_cfg.name} status={status}", flush=True)

    print(json.dumps(summary, indent=2))
    return 1 if summary["load-status-mismatch"] or summary["semantic-mismatch"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
