#!/bin/bash
# Download test fonts for FreeType MoonBit port.
# All fonts are Apache 2.0 or SIL Open Font License (OFL) licensed.
# Run: bash test/fonts/download.sh
set -euo pipefail

FONT_DIR="$(cd "$(dirname "$0")" && pwd)"

download() {
  local url="$1" dest="$2"
  if [ -f "$dest" ]; then
    echo "  [skip] $(basename "$dest") (already exists)"
    return
  fi
  echo "  [download] $(basename "$dest")"
  curl -fsSL -o "$dest" "$url"
}

echo "Downloading test fonts to $FONT_DIR..."

# --- TrueType ---

# Roboto (Apache 2.0) — from Google Fonts GitHub
download \
  "https://github.com/google/fonts/raw/main/ofl/roboto/Roboto%5Bwdth%2Cwght%5D.ttf" \
  "$FONT_DIR/Roboto[wdth,wght].ttf"

# DejaVu Sans (Bitstream Vera + Arev, permissive) — kerning-heavy
download \
  "https://github.com/dejavu-fonts/dejavu-fonts/releases/download/version_2_37/dejavu-fonts-ttf-2.37.tar.bz2" \
  "$FONT_DIR/dejavu-fonts.tar.bz2"
if [ ! -f "$FONT_DIR/DejaVuSans.ttf" ] && [ -f "$FONT_DIR/dejavu-fonts.tar.bz2" ]; then
  echo "  [extract] DejaVuSans.ttf"
  tar -xjf "$FONT_DIR/dejavu-fonts.tar.bz2" -C "$FONT_DIR" --strip-components=2 \
    "dejavu-fonts-ttf-2.37/ttf/DejaVuSans.ttf" 2>/dev/null || true
fi

# --- OpenType/CFF ---

# Source Code Pro (OFL) — monospaced CFF
download \
  "https://github.com/adobe-fonts/source-code-pro/releases/download/2.042R-u%2F1.062R-i%2F1.026R-vf/OTF/SourceCodePro-Regular.otf" \
  "$FONT_DIR/SourceCodePro-Regular.otf"

# --- Variable fonts ---

# Recursive (OFL) — multi-axis variable TT
download \
  "https://github.com/arrowtype/recursive/releases/download/v1.085/Recursive_Desktop-1.085.zip" \
  "$FONT_DIR/Recursive.zip"

echo ""
echo "Done. See LICENSES.md for font license details."
echo "Note: Some fonts require manual extraction from archives."
