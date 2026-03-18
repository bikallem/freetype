#!/bin/bash
# Run benchmarks for both C FreeType and MoonBit port, then compare.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
FONT_DIR="$PROJECT_DIR/test/fonts"

echo "============================================================"
echo "  BENCHMARK: MoonBit FreeType Port vs C FreeType"
echo "============================================================"
echo ""

# Build C benchmark
echo "Building C benchmark..."
make -C "$SCRIPT_DIR" bench_c 2>/dev/null || {
  echo "FAILED: Cannot build C benchmark (vendored FreeType not compiled?)"
  echo "Run: make -C vendor/freetype-c"
  exit 1
}
echo ""

# Build MoonBit benchmark
echo "Building MoonBit benchmark..."
cd "$PROJECT_DIR"
moon build --target native 2>/dev/null
echo ""

# Run C benchmark
echo "Running C FreeType benchmark..."
echo "------------------------------------------------------------"
C_OUT=$(/usr/bin/time -f "%e" "$SCRIPT_DIR/bench_c" "$FONT_DIR" 2>&1)
C_TIME=$(echo "$C_OUT" | tail -1)
C_JSON=$(echo "$C_OUT" | head -n -1)
echo "$C_JSON" > /tmp/bench_c.json
echo "C FreeType total: ${C_TIME}s"
echo ""

# Run MoonBit benchmark
echo "Running MoonBit benchmark..."
echo "------------------------------------------------------------"
MB_START=$(date +%s%N)
moon run src/bench --target native 2>/dev/null
MB_END=$(date +%s%N)
MB_MS=$(( (MB_END - MB_START) / 1000000 ))
echo ""
echo "MoonBit total: ${MB_MS}ms"
echo ""

# Parse and display comparison
echo "============================================================"
echo "  COMPARISON REPORT"
echo "============================================================"
echo ""
printf "%-35s %12s %12s %8s\n" "Font" "C (ms)" "MoonBit (ms)" "Ratio"
echo "------------------------------------------------------------"

# Parse C JSON results
python3 << PYEOF
import json, sys

try:
    c_data = json.load(open("/tmp/bench_c.json"))
except:
    print("Could not parse C benchmark results")
    sys.exit(0)

for r in c_data.get("results", []):
    name = r["font"][:33]
    c_face = r["face_load_ns"] / 1_000_000
    c_cmap = r["cmap_lookup_ns"] / 1_000_000
    fmt = r["format"]
    print(f"  {name:<33s} {fmt}")
    print(f"    face_load:    {c_face:>8.2f} ms")
    print(f"    cmap_lookup:  {c_cmap:>8.2f} ms")
    if r["glyph_noscale_ns"] > 0:
        c_glyph = r["glyph_noscale_ns"] / 1_000
        print(f"    glyph(noscl): {c_glyph:>8.2f} us")
    if r["glyph_hinted_ns"] > 0:
        c_hint = r["glyph_hinted_ns"] / 1_000
        print(f"    glyph(hint):  {c_hint:>8.2f} us")
    print()
PYEOF

echo ""
echo "Note: MoonBit timing is wall-clock for all operations combined."
echo "      C timing is per-operation (averaged over iterations)."
echo "      For precise per-op MoonBit timing, MoonBit needs a high-res clock API."
echo "============================================================"
