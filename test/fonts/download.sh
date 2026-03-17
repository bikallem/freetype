#!/bin/bash
# Download comprehensive test fonts for FreeType MoonBit port.
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
  if curl -fsSL --connect-timeout 10 -o "$dest" "$url"; then
    return 0
  else
    echo "  [FAILED] $(basename "$dest")"
    rm -f "$dest"
    return 1
  fi
}

echo "Downloading test fonts to $FONT_DIR..."
echo ""

# ── TrueType (.ttf) ─────────────────────────────────────────────────
echo "TrueType:"
# DejaVu Sans — large charset, kerning-heavy, well-hinted
download \
  "https://github.com/dejavu-fonts/dejavu-fonts/releases/download/version_2_37/dejavu-fonts-ttf-2.37.tar.bz2" \
  "$FONT_DIR/dejavu-fonts.tar.bz2"
if [ ! -f "$FONT_DIR/DejaVuSans.ttf" ] && [ -f "$FONT_DIR/dejavu-fonts.tar.bz2" ]; then
  echo "  [extract] DejaVuSans.ttf"
  tar -xjf "$FONT_DIR/dejavu-fonts.tar.bz2" -C "$FONT_DIR" --strip-components=2 \
    "dejavu-fonts-ttf-2.37/ttf/DejaVuSans.ttf" 2>/dev/null || true
fi

# Roboto variable — multi-axis variable TrueType
download \
  "https://github.com/google/fonts/raw/main/ofl/roboto/Roboto%5Bwdth%2Cwght%5D.ttf" \
  "$FONT_DIR/Roboto[wdth,wght].ttf"

echo ""

# ── CFF/OpenType (.otf) ─────────────────────────────────────────────
echo "CFF/OpenType:"
# Source Code Pro — monospaced CFF outlines, well-structured
download \
  "https://github.com/adobe-fonts/source-code-pro/raw/release/OTF/SourceCodePro-Regular.otf" \
  "$FONT_DIR/SourceCodePro-Regular.otf"

echo ""

# ── BDF Bitmap ───────────────────────────────────────────────────────
echo "BDF Bitmap:"
# GNU Unifont — comprehensive BDF with thousands of glyphs
download \
  "https://unifoundry.com/pub/unifont/unifont-16.0.02/font-builds/unifont-16.0.02.bdf.gz" \
  "$FONT_DIR/unifont.bdf.gz"
if [ ! -f "$FONT_DIR/unifont.bdf" ] && [ -f "$FONT_DIR/unifont.bdf.gz" ]; then
  echo "  [extract] unifont.bdf"
  gunzip -k "$FONT_DIR/unifont.bdf.gz" 2>/dev/null || true
fi

echo ""

# ── Type 1 PFB ───────────────────────────────────────────────────────
echo "Type 1 PFB:"
# URW base fonts (Nimbus Sans = Helvetica equivalent) — real Type 1
download \
  "https://github.com/ArtifexSoftware/urw-base35-fonts/raw/master/fonts/NimbusSans-Regular.t1" \
  "$FONT_DIR/NimbusSans-Regular.pfb" || true

echo ""

echo "Done. Available fonts:"
for f in "$FONT_DIR"/*.ttf "$FONT_DIR"/*.otf "$FONT_DIR"/*.bdf "$FONT_DIR"/*.pfb "$FONT_DIR"/*.woff "$FONT_DIR"/*.ttc; do
  [ -f "$f" ] && printf "  %-40s %s\n" "$(basename "$f")" "$(du -h "$f" | cut -f1)"
done
echo ""
echo "See LICENSES.md for details."
