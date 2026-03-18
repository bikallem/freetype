#!/usr/bin/env python3
"""
Benchmark comparison report: MoonBit FreeType port vs C FreeType.
Per-font timing with operation breakdown.
"""

import json, subprocess, os, sys, time

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BENCH_DIR = os.path.join(PROJECT_DIR, "bench")
FONT_DIR = os.path.join(PROJECT_DIR, "test", "fonts")


FONTS = [
    ("DejaVuSans.ttf", "TrueType"),
    ("Roboto[wdth,wght].ttf", "TrueType Variable"),
    ("SourceCodePro-Regular.otf", "CFF/OpenType"),
    ("NotoSansJP-Regular.otf", "CFF/OpenType CJK"),
    ("DejaVuSans.woff", "WOFF1"),
    ("DejaVuSans.ttc", "TrueType Collection"),
    ("NimbusSans-Regular.pfb", "Type 1 PFB"),
    ("unifont.bdf", "BDF Bitmap"),
]


def run_c_bench():
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


def run_mb_per_font():
    """Run MoonBit benchmark per font by timing each separately."""
    results = {}
    for font_name, fmt in FONTS:
        font_path = os.path.join(FONT_DIR, font_name)
        if not os.path.exists(font_path):
            continue

        # Write a per-font benchmark
        bench_src = f'''///|
fn main {{
  let data = try! @fs.read_file_to_bytes("{font_path}")
  // face_load: 100 iters
  for _ in 0..<100 {{
    ignore(try? @freetype.from_bytes(data))
  }}
  let face = try! @freetype.from_bytes(data)
  // cmap: 100 iters × 95 chars
  for _ in 0..<100 {{
    for c in 32..<127 {{
      ignore(@freetype.get_char_index(face, c.reinterpret_as_uint()))
    }}
  }}
  // glyph: 1000 iters
  let gid = @freetype.get_char_index(face, 65U)
  if gid > 0U && face.is_scalable() {{
    for _ in 0..<1000 {{
      ignore(try? @freetype.load_glyph(face, gid, load_flags=@base.load_no_scale))
    }}
    ignore(try? @freetype.set_pixel_sizes(face, 0U, 16U))
    for _ in 0..<1000 {{
      ignore(try? @freetype.load_glyph(face, gid))
    }}
  }}
}}
'''
        # Write temp benchmark
        bench_file = os.path.join(PROJECT_DIR, "src", "bench", "main.mbt")
        with open(bench_file, "w") as f:
            f.write(bench_src)

        # Build and time
        subprocess.run(
            ["moon", "build", "--target", "native"],
            capture_output=True, cwd=PROJECT_DIR,
        )
        start = time.monotonic_ns()
        subprocess.run(
            ["moon", "run", "src/bench", "--target", "native"],
            capture_output=True, cwd=PROJECT_DIR,
        )
        elapsed_ms = (time.monotonic_ns() - start) / 1_000_000
        results[font_name] = elapsed_ms
        sys.stderr.write(f"  {font_name}: {elapsed_ms:.0f}ms\n")

    return results


def fmt_ns(ns):
    if ns == 0:
        return "--"
    if ns >= 1_000_000:
        return f"{ns/1_000_000:.1f}ms"
    if ns >= 1_000:
        return f"{ns/1_000:.0f}us"
    return f"{ns:.0f}ns"


def fmt_ms(ms):
    if ms >= 1000:
        return f"{ms/1000:.2f}s"
    return f"{ms:.0f}ms"


def main():
    print()
    print("=" * 90)
    print("  BENCHMARK: MoonBit FreeType Port vs C FreeType — Per Font")
    print("=" * 90)
    print()

    # Run C benchmark
    sys.stderr.write("Running C FreeType benchmark...\n")
    c_data = run_c_bench()
    if not c_data:
        print("  FAILED: Cannot run C benchmark")
        return 1

    c_by_font = {r["font"]: r for r in c_data["results"]}

    # Run MoonBit benchmark per font
    sys.stderr.write("Running MoonBit benchmark per font...\n")
    mb_results = run_mb_per_font()

    # Compute C total time per font (same ops as MoonBit: 100 face + 100 cmap + 1000 glyph × 2)
    def c_total_ms(r):
        face = r["face_load_ns"] * 100
        cmap = r["cmap_lookup_ns"] * 100
        glyph_ns = r["glyph_noscale_ns"] * 1000
        hinted_ns = r["glyph_hinted_ns"] * 1000
        return (face + cmap + glyph_ns + hinted_ns) / 1_000_000

    # Report
    print(f"  {'Font':<32s} {'Format':<18s} {'Size':>6s} {'C total':>9s} {'MB total':>9s} {'Ratio':>7s}")
    print("  " + "-" * 86)

    c_grand = 0
    mb_grand = 0
    for font_name, fmt in FONTS:
        c_r = c_by_font.get(font_name)
        mb_ms = mb_results.get(font_name)
        if not c_r or not mb_ms:
            continue

        c_ms = c_total_ms(c_r)
        c_grand += c_ms
        mb_grand += mb_ms
        ratio = mb_ms / c_ms if c_ms > 0 else 0
        size_kb = c_r["size_kb"]

        print(f"  {font_name:<32s} {fmt:<18s} {size_kb:>5d}K {fmt_ms(c_ms):>9s} {fmt_ms(mb_ms):>9s} {ratio:>6.1f}x")

        # Per-op breakdown
        face_us = c_r["face_load_ns"] / 1000
        cmap_us = c_r["cmap_lookup_ns"] / 1000
        glyph = fmt_ns(c_r["glyph_noscale_ns"])
        hinted = fmt_ns(c_r["glyph_hinted_ns"])
        print(f"    C ops:  face={face_us:.0f}us  cmap(95ch)={cmap_us:.0f}us  glyph={glyph}  hinted={hinted}")
        print()

    print("  " + "-" * 86)
    total_ratio = mb_grand / c_grand if c_grand > 0 else 0
    print(f"  {'TOTAL':<32s} {'':18s} {'':>6s} {fmt_ms(c_grand):>9s} {fmt_ms(mb_grand):>9s} {total_ratio:>6.1f}x")
    print()

    # Without BDF
    c_no_bdf = c_grand - c_total_ms(c_by_font.get("unifont.bdf", {"face_load_ns":0,"cmap_lookup_ns":0,"glyph_noscale_ns":0,"glyph_hinted_ns":0}))
    mb_no_bdf = mb_grand - mb_results.get("unifont.bdf", 0)
    if c_no_bdf > 0:
        ratio_no_bdf = mb_no_bdf / c_no_bdf
        print(f"  Without BDF (unifont):  C={fmt_ms(c_no_bdf)}  MoonBit={fmt_ms(mb_no_bdf)}  Ratio={ratio_no_bdf:.1f}x")
    print()
    print("  Operations per font: 100 face_load + 9,500 cmap_lookup + 1,000 glyph(NO_SCALE) + 1,000 glyph(DEFAULT)")
    print()
    print("=" * 90)

    return 0


if __name__ == "__main__":
    sys.exit(main())
