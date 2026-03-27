#!/bin/bash
# Download and prepare test fonts for FreeType MoonBit port parity testing.
# Every font format uses real production font data.
# All fonts are freely licensed (Apache 2.0, OFL, or equivalent).
set -euo pipefail

FONT_DIR="$(cd "$(dirname "$0")" && pwd)"

download() {
  local url="$1" dest="$2"
  if [ -f "$dest" ]; then
    echo "  [skip] $(basename "$dest")"
    return 0
  fi
  echo "  [download] $(basename "$dest")"
  curl -fsSL --connect-timeout 15 --retry 2 -o "$dest" "$url" 2>/dev/null || {
    echo "  [FAILED] $(basename "$dest")"
    rm -f "$dest"
    return 1
  }
}

echo "Downloading test fonts..."
echo ""

# ── TrueType (.ttf) ─────────────────────────────────────────────────
echo "=== TrueType (.ttf) ==="
# DejaVu Sans — 6253 glyphs, 158 kerning pairs, complex hinting
download \
  "https://github.com/dejavu-fonts/dejavu-fonts/releases/download/version_2_37/dejavu-fonts-ttf-2.37.tar.bz2" \
  "$FONT_DIR/dejavu-fonts.tar.bz2"
if [ ! -f "$FONT_DIR/DejaVuSans.ttf" ] && [ -f "$FONT_DIR/dejavu-fonts.tar.bz2" ]; then
  echo "  [extract] DejaVuSans.ttf"
  tar -xjf "$FONT_DIR/dejavu-fonts.tar.bz2" -C "$FONT_DIR" --strip-components=2 \
    "dejavu-fonts-ttf-2.37/ttf/DejaVuSans.ttf" 2>/dev/null || true
fi
# Roboto variable — multi-axis (wdth+wght) variable TrueType (Google Fonts)
download \
  "https://github.com/google/fonts/raw/main/ofl/roboto/Roboto%5Bwdth%2Cwght%5D.ttf" \
  "$FONT_DIR/Roboto[wdth,wght].ttf"
# Nabla — real-world COLR v1 variable color font with gradients (Google Fonts)
download \
  "https://github.com/google/fonts/raw/main/ofl/nabla/Nabla%5BEDPT%2CEHLT%5D.ttf" \
  "$FONT_DIR/Nabla[EDPT,EHLT].ttf"

echo ""

# ── CFF/OpenType (.otf) ─────────────────────────────────────────────
echo "=== CFF/OpenType (.otf) ==="
# Source Code Pro — 1568 CFF glyphs, monospaced (Adobe)
download \
  "https://github.com/adobe-fonts/source-code-pro/raw/release/OTF/SourceCodePro-Regular.otf" \
  "$FONT_DIR/SourceCodePro-Regular.otf"
# Noto Sans JP — 17936 CJK CFF glyphs (Google Noto)
download \
  "https://github.com/notofonts/noto-cjk/raw/main/Sans/SubsetOTF/JP/NotoSansJP-Regular.otf" \
  "$FONT_DIR/NotoSansJP-Regular.otf" || true

echo ""

# ── Type 1 PFB (.pfb) ───────────────────────────────────────────────
echo "=== Type 1 (.pfb) ==="
# Nimbus Sans — URW Helvetica clone, 855 glyphs
download \
  "https://github.com/ArtifexSoftware/urw-base35-fonts/raw/master/fonts/NimbusSans-Regular.t1" \
  "$FONT_DIR/NimbusSans-Regular.pfb" || true

echo ""

# ── BDF Bitmap (.bdf) ───────────────────────────────────────────────
echo "=== BDF Bitmap (.bdf) ==="
# GNU Unifont — 57087 glyphs covering most of Unicode
download \
  "https://unifoundry.com/pub/unifont/unifont-16.0.02/font-builds/unifont-16.0.02.bdf.gz" \
  "$FONT_DIR/unifont.bdf.gz"
if [ ! -f "$FONT_DIR/unifont.bdf" ] && [ -f "$FONT_DIR/unifont.bdf.gz" ]; then
  echo "  [extract] unifont.bdf"
  gunzip -k "$FONT_DIR/unifont.bdf.gz" 2>/dev/null || true
fi

echo ""

# ── TTC + WOFF (converted from real fonts) ───────────────────────────
echo "=== TTC + WOFF (converted from downloaded fonts) ==="
# WOFF1 is a dead format — Google Fonts dropped it entirely, servers
# only serve WOFF2 now. TTC files from Google are 16-120MB.
# We create valid TTC/WOFF by re-packaging the real downloaded fonts:
#   DejaVuSans.woff = WOFF1(DejaVuSans.ttf) — 6253 real glyphs, zlib
#   DejaVuSans.ttc  = TTC(DejaVuSans.ttf × 2) — 6253 real glyphs
#   SourceCodePro-Regular.woff = WOFF1(SourceCodePro.otf) — 1568 CFF glyphs
# This is exactly how WOFF1/TTC files are produced in practice.
python3 "$FONT_DIR/convert_formats.py"

echo ""

# ── Summary ──────────────────────────────────────────────────────────
echo "=== Available fonts ==="
for f in "$FONT_DIR"/*.ttf "$FONT_DIR"/*.otf "$FONT_DIR"/*.ttc "$FONT_DIR"/*.bdf "$FONT_DIR"/*.pfb "$FONT_DIR"/*.woff; do
  [ -f "$f" ] && printf "  %-45s %s\n" "$(basename "$f")" "$(du -h "$f" | cut -f1)"
done
echo ""
echo "See LICENSES.md for details."
