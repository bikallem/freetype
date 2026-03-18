#!/usr/bin/env python3
"""
Generate a benchmark comparison report: MoonBit port vs C FreeType.
Runs both benchmarks and produces a formatted report.
"""

import json, subprocess, os, sys, time

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BENCH_DIR = os.path.join(PROJECT_DIR, "bench")
FONT_DIR = os.path.join(PROJECT_DIR, "test", "fonts")


def run_c_bench():
    """Run C FreeType benchmark, return parsed JSON."""
    bench_c = os.path.join(BENCH_DIR, "bench_c")
    if not os.path.exists(bench_c):
        subprocess.run(["make", "-C", BENCH_DIR, "bench_c"], capture_output=True)
    if not os.path.exists(bench_c):
        return None
    result = subprocess.run([bench_c, FONT_DIR], capture_output=True, text=True)
    try:
        return json.loads(result.stdout)
    except:
        return None


def run_moonbit_bench():
    """Run MoonBit benchmark, return wall-clock time per font."""
    # We'll measure each font individually by running the benchmark
    # and parsing the output. Since MoonBit doesn't have per-op timing,
    # we measure the total time for all operations on all fonts.
    start = time.monotonic_ns()
    result = subprocess.run(
        ["moon", "run", "src/bench", "--target", "native"],
        capture_output=True, text=True, cwd=PROJECT_DIR,
    )
    end = time.monotonic_ns()
    total_ms = (end - start) / 1_000_000
    return total_ms, result.stdout


def main():
    print()
    print("=" * 78)
    print("  BENCHMARK REPORT: MoonBit FreeType Port vs C FreeType")
    print("=" * 78)
    print()

    # Run C benchmark
    print("Running C FreeType benchmark...")
    c_start = time.monotonic_ns()
    c_data = run_c_bench()
    c_total = (time.monotonic_ns() - c_start) / 1_000_000
    if not c_data:
        print("  FAILED: Could not run C benchmark")
        print("  Build vendored FreeType: make -C vendor/freetype-c")
        return 1

    # Run MoonBit benchmark
    print("Running MoonBit benchmark...")
    mb_total, mb_output = run_moonbit_bench()

    print()
    print("-" * 78)
    print()

    # Per-font C results
    print(f"  {'Font':<30s} {'Format':<20s} {'Size':>6s}")
    print("  " + "-" * 60)
    for r in c_data["results"]:
        print(f"  {r['font']:<30s} {r['format']:<20s} {r['size_kb']:>5d}KB")
    print()

    # Detailed C timing
    print("  C FreeType per-operation timing (averaged over 100 iterations):")
    print("  " + "-" * 74)
    print(f"  {'Font':<30s} {'face_load':>12s} {'cmap(95ch)':>12s} {'glyph(ns)':>12s} {'hinted(ns)':>12s}")
    print("  " + "-" * 74)
    for r in c_data["results"]:
        face_us = f"{r['face_load_ns']/1000:.0f}us"
        cmap_us = f"{r['cmap_lookup_ns']/1000:.0f}us"
        glyph = f"{r['glyph_noscale_ns']}ns" if r['glyph_noscale_ns'] > 0 else "--"
        hinted = f"{r['glyph_hinted_ns']}ns" if r['glyph_hinted_ns'] > 0 else "--"
        print(f"  {r['font']:<30s} {face_us:>12s} {cmap_us:>12s} {glyph:>12s} {hinted:>12s}")
    print()

    # Summary
    print("  Performance summary:")
    print("  " + "-" * 74)
    print(f"  C FreeType total benchmark time:     {c_total:>8.0f} ms")
    print(f"  MoonBit port total benchmark time:   {mb_total:>8.0f} ms")
    if c_total > 0:
        ratio = mb_total / c_total
        print(f"  Ratio (MoonBit / C):                {ratio:>8.1f}x")
    print()

    # Breakdown analysis
    print("  Analysis:")
    print("  " + "-" * 74)

    # Find heaviest C operations
    c_total_face = sum(r['face_load_ns'] for r in c_data['results'])
    c_heaviest = max(c_data['results'], key=lambda r: r['face_load_ns'])
    print(f"  C: heaviest face_load: {c_heaviest['font']} ({c_heaviest['face_load_ns']/1_000_000:.1f}ms)")
    print(f"  C: total face_load across all fonts: {c_total_face/1_000_000:.1f}ms")

    total_glyphs = sum(1 for r in c_data['results'] if r['glyph_noscale_ns'] > 0)
    if total_glyphs > 0:
        avg_glyph = sum(r['glyph_noscale_ns'] for r in c_data['results'] if r['glyph_noscale_ns'] > 0) / total_glyphs
        print(f"  C: avg glyph load (NO_SCALE): {avg_glyph:.0f}ns")

    print()
    print("  Notes:")
    print("  - C timing is per-operation (high-res clock_gettime)")
    print("  - MoonBit timing is wall-clock total (no per-op clock available)")
    print("  - MoonBit benchmark: 100 face_load + 100 cmap + 1000 glyph per font")
    print("  - WOFF1 includes zlib decompression in face_load")
    print("  - BDF/unifont (9MB) dominates both benchmarks")
    print()
    print("=" * 78)

    return 0


if __name__ == "__main__":
    sys.exit(main())
