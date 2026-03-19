#!/usr/bin/env python3
"""
Benchmark comparison report: MoonBit FreeType port vs C FreeType.

Runs C FreeType benchmark (bench_c) and MoonBit benchmark (moon bench),
parses both outputs, and generates a per-font comparison report.
"""

import json
import os
import re
import subprocess
import sys

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BENCH_DIR = os.path.join(PROJECT_DIR, "bench")
FONT_DIR = os.path.join(PROJECT_DIR, "test", "fonts")

# Map moon bench test names to (font_key, operation)
# bench test names: bench/{format}/{operation}
BENCH_NAME_MAP = {
    "ttf": "DejaVuSans.ttf",
    "ttc": "DejaVuSans.ttc",
    "woff": "DejaVuSans.woff",
    "cff": "SourceCodePro-Regular.otf",
    "cjk": "NotoSansJP-Regular.otf",
    "variable": "Roboto[wdth,wght].ttf",
    "type1": "NimbusSans-Regular.pfb",
    "bdf": "unifont.bdf",
}

FONT_FORMAT = {
    "DejaVuSans.ttf": "TrueType",
    "DejaVuSans.ttc": "TrueType Collection",
    "DejaVuSans.woff": "WOFF1",
    "SourceCodePro-Regular.otf": "CFF/OpenType",
    "NotoSansJP-Regular.otf": "CFF/OpenType CJK",
    "Roboto[wdth,wght].ttf": "Variable TrueType",
    "NimbusSans-Regular.pfb": "Type 1 PFB",
    "unifont.bdf": "BDF Bitmap",
}

FONT_ORDER = [
    "DejaVuSans.ttf",
    "DejaVuSans.ttc",
    "DejaVuSans.woff",
    "Roboto[wdth,wght].ttf",
    "SourceCodePro-Regular.otf",
    "NotoSansJP-Regular.otf",
    "NimbusSans-Regular.pfb",
    "unifont.bdf",
]


def run_c_bench():
    """Build and run the C FreeType benchmark, return parsed JSON."""
    bench_c = os.path.join(BENCH_DIR, "bench_c")
    if not os.path.exists(bench_c):
        sys.stderr.write("Building C benchmark...\n")
        r = subprocess.run(
            ["make", "-C", BENCH_DIR, "bench_c"],
            capture_output=True,
            text=True,
        )
        if r.returncode != 0:
            sys.stderr.write(f"C benchmark build failed:\n{r.stderr}\n")
            return None

    sys.stderr.write("Running C FreeType benchmark...\n")
    result = subprocess.run([bench_c, FONT_DIR], capture_output=True, text=True)
    try:
        return json.loads(result.stdout)
    except (json.JSONDecodeError, ValueError):
        sys.stderr.write(f"C benchmark output parse failed:\n{result.stdout}\n")
        return None


def parse_moon_bench_output(output):
    """Parse moon bench output into {(font, op): mean_us} dict.

    Expected format per benchmark:
    [bikallem/freetype] bench benchmarks/foo_bench.mbt:NN ("bench/fmt/op") ok
    time (mean ± σ)         range (min … max)
      36.94 ms ± 302.91 µs    36.50 ms …  37.41 ms  in 10 ×      3 runs
    """
    results = {}

    # Match: ("bench/FORMAT/OPERATION") ok
    # Followed by timing line with mean value
    bench_re = re.compile(r'\("bench/([^/]+)/([^"]+)"\)\s+ok')
    # Match timing: leading whitespace, then value + unit
    time_re = re.compile(
        r"^\s+"
        r"(\d+(?:\.\d+)?)\s+(µs|ms|ns|s)"
        r"\s+±",
    )

    lines = output.split("\n")
    i = 0
    while i < len(lines):
        m = bench_re.search(lines[i])
        if m:
            fmt_key = m.group(1)
            op = m.group(2)
            font = BENCH_NAME_MAP.get(fmt_key)
            # Find the timing line (skip the header line)
            for j in range(i + 1, min(i + 4, len(lines))):
                tm = time_re.match(lines[j])
                if tm:
                    value = float(tm.group(1))
                    unit = tm.group(2)
                    # Convert to microseconds
                    if unit == "ns":
                        value /= 1000
                    elif unit == "ms":
                        value *= 1000
                    elif unit == "s":
                        value *= 1_000_000
                    # unit == "µs" is already in µs
                    if font:
                        results[(font, op)] = value
                    break
            i += 3
        else:
            i += 1

    return results


def run_moon_bench():
    """Run moon bench and parse the output."""
    sys.stderr.write("Running MoonBit benchmark (moon bench --release --target native)...\n")
    result = subprocess.run(
        [
            "moon",
            "bench",
            "-p",
            "bikallem/freetype/benchmarks",
            "--release",
            "--target",
            "native",
        ],
        capture_output=True,
        text=True,
        cwd=PROJECT_DIR,
    )
    output = result.stdout + result.stderr
    return parse_moon_bench_output(output)


def fmt_us(us):
    """Format microseconds to human-readable string."""
    if us == 0:
        return "--"
    if us >= 1_000_000:
        return f"{us / 1_000_000:.2f}s"
    if us >= 1000:
        return f"{us / 1000:.1f}ms"
    if us >= 1:
        return f"{us:.1f}µs"
    return f"{us * 1000:.0f}ns"


def main():
    # Run both benchmarks
    c_data = run_c_bench()
    mb_data = run_moon_bench()

    if not c_data:
        print("ERROR: C FreeType benchmark failed to run.")
        return 1

    if not mb_data:
        print("ERROR: MoonBit benchmark produced no results.")
        return 1

    c_by_font = {r["font"]: r for r in c_data["results"]}

    # Print report
    print()
    print("=" * 100)
    print("  BENCHMARK REPORT: MoonBit FreeType Port vs C FreeType")
    print("=" * 100)
    print()

    ops = ["face_load", "cmap_lookup", "glyph_load_no_scale", "glyph_load_hinted"]
    # BDF has different op names
    bdf_ops = ["face_load", "cmap_lookup", "glyph_load"]
    c_op_keys = ["face_load_ns", "cmap_lookup_ns", "glyph_noscale_ns", "glyph_hinted_ns"]

    header = f"  {'Font':<32s} {'Operation':<22s} {'C FreeType':>12s} {'MoonBit':>12s} {'Ratio':>8s}"
    print(header)
    print("  " + "-" * 96)

    for font in FONT_ORDER:
        c_r = c_by_font.get(font)
        if not c_r:
            continue

        fmt = FONT_FORMAT.get(font, "?")
        font_ops = bdf_ops if font == "unifont.bdf" else ops

        print(f"  {font} ({fmt})")

        for op in font_ops:
            # Get C time in µs
            if op == "face_load":
                c_us = c_r["face_load_ns"] / 1000
            elif op == "cmap_lookup":
                c_us = c_r["cmap_lookup_ns"] / 1000
            elif op in ("glyph_load_no_scale", "glyph_load"):
                c_us = c_r["glyph_noscale_ns"] / 1000
            elif op == "glyph_load_hinted":
                c_us = c_r["glyph_hinted_ns"] / 1000
            else:
                c_us = 0

            # Get MoonBit time in µs
            mb_us = mb_data.get((font, op), 0)

            ratio_str = "--"
            if c_us > 0 and mb_us > 0:
                ratio = mb_us / c_us
                ratio_str = f"{ratio:.1f}x"

            print(
                f"    {'':28s} {op:<22s} {fmt_us(c_us):>12s} {fmt_us(mb_us):>12s} {ratio_str:>8s}"
            )

        print()

    # Summary
    print("  " + "-" * 96)
    print()
    print("  SUMMARY BY FORMAT")
    print()
    print(f"    {'Font':<32s} {'C total':>12s} {'MB total':>12s} {'Ratio':>8s}")
    print("    " + "-" * 66)

    c_grand = 0
    mb_grand = 0

    for font in FONT_ORDER:
        c_r = c_by_font.get(font)
        if not c_r:
            continue

        font_ops = bdf_ops if font == "unifont.bdf" else ops

        c_total = 0
        mb_total = 0
        for op in font_ops:
            if op == "face_load":
                c_total += c_r["face_load_ns"] / 1000
            elif op == "cmap_lookup":
                c_total += c_r["cmap_lookup_ns"] / 1000
            elif op in ("glyph_load_no_scale", "glyph_load"):
                c_total += c_r["glyph_noscale_ns"] / 1000
            elif op == "glyph_load_hinted":
                c_total += c_r["glyph_hinted_ns"] / 1000

            mb_total += mb_data.get((font, op), 0)

        c_grand += c_total
        mb_grand += mb_total
        ratio = mb_total / c_total if c_total > 0 else 0
        print(f"    {font:<32s} {fmt_us(c_total):>12s} {fmt_us(mb_total):>12s} {ratio:>7.1f}x")

    print("    " + "-" * 66)
    total_ratio = mb_grand / c_grand if c_grand > 0 else 0
    print(f"    {'TOTAL':<32s} {fmt_us(c_grand):>12s} {fmt_us(mb_grand):>12s} {total_ratio:>7.1f}x")
    print()
    print("  Notes:")
    print("    - C times: average over 100 iterations (1000 for glyph ops)")
    print("    - MoonBit times: mean from moon bench (auto-calibrated iterations)")
    print("    - Ratio = MoonBit / C (lower is better, 1.0x = parity)")
    print()
    print("=" * 100)

    return 0


if __name__ == "__main__":
    sys.exit(main())
