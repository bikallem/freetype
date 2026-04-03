# bikallem/freetype

MoonBit FreeType-compatible font engine with pure MoonBit drivers.

## Table of Contents

- [Features](#features)
- [What Is Not Ported](#what-is-not-ported)
- [Compatibility Target](#compatibility-target)
- [API](#api)
- [Project Structure](#project-structure)
- [Build](#build)
- [Parity Testing](#parity-testing)
- [Performance](#performance)
- [Dependencies](#dependencies)
- [C-to-MoonBit Design Decisions](#c-to-moonbit-design-decisions)
- [License](#license)

## Overview

- Font loading from `Bytes` (in-memory, no file I/O)
- Character-to-glyph mapping (cmap formats 0, 2, 4, 6, 8, 10, 12, 13)
- Glyph outline loading (TrueType simple/composite, CFF charstrings)
- Glyph rendering (`render_glyph`, `LOAD_RENDER`) in normal, light, mono,
  LCD, LCD_V, color BGRA, and SDF modes
- Pixel size scaling with proper 16.16 fixed-point math
- Kerning pair lookup
- TrueType bytecode hinting (~160 opcodes: point movement, zones, projection vectors, rounding, deltas)
- PostScript hinting (stem fitting, blue zone alignment, point interpolation)
- Auto-hinter (script-aware segment/edge/stem detection, pixel grid fitting)
- PostScript Type 2 charstring interpreter (path operators, hints, subroutines, flex)
- PostScript Type 1 charstring interpreter (hsbw, closepath, callothersubr/Flex, seac)
- Font variations API (`set_var_design_coordinates`, `fvar`/`avar`/`gvar`/`HVAR`)
- WOFF1 decompression (zlib via `bikallem/compress`)
- WOFF2 decompression (Brotli via `bikallem/compress`) with glyf/loca and hmtx transform reconstruction, including collections
- Standalone CFF font loading (bare CFF without SFNT container)
- Format auto-detection from file header bytes

## Features

**Font format support:**

| Format | Extension | Status | Driver |
|--------|-----------|--------|--------|
| TrueType | `.ttf` | Full | `truetype/` — glyph loading, bytecode interpreter |
| OpenType/CFF (CFF1) | `.otf` | Full | `cff/` — CFF INDEX/DICT parsing, Type 2 charstrings |
| OpenType/CFF2 | `.otf` | Full | `cff/` + `sfnt/` — pure MoonBit CFF2 parsing, charstrings, variations, and SFNT integration |
| TrueType Collection | `.ttc` | Full | `sfnt/` — collection header, per-face loading |
| WOFF1 | `.woff` | Full | `sfnt/woff.mbt` — zlib decompression via `bikallem/compress` |
| WOFF2 | `.woff2` | Full | `sfnt/woff2.mbt` — Brotli decompression, glyf/loca + hmtx transform reconstruction, collections |
| Standalone CFF | `.cff` | Full | `cff_loader.mbt` — bare CFF without SFNT container, PS hinting |
| Type 1 (PFB/PFA) | `.pfb` `.pfa` | Full | `type1/` — pure MoonBit single-master + Multiple Master parsing, hinting, and AFM/PFM-backed metrics/kerning |
| BDF (bitmap) | `.bdf` | Full | `bdf/` — header + glyph bitmap extraction |
| PCF (bitmap) | `.pcf` | Full | `pcf/` — TOC, properties, metrics, encodings, bitmaps |
| Color glyphs | `COLR`/`CPAL`, `sbix`, `CBDT`/`CBLC` | Full | `color/` — MoonBit COLR/sbix/CBDT path |

Obsolete formats **not supported**: CID-keyed (standalone), Type 42, PFR (Bitstream), Windows FNT/FON.
CID-keyed fonts inside CFF/OpenType are supported through the CFF driver.

## What Is Not Ported

The following FreeType subsystems are **excluded** from this port:

| Subsystem | Reason |
|-----------|--------|
| **File I/O** (`ftsystem.c` file operations) | Accepts `Bytes` instead of file paths; no I/O or OS dependency |
| **FT_Library global state** | Eliminated — API is stateless, no initialization needed |
| **Memory allocator** (`FT_ALLOC`/`FT_FREE`/`FT_Memory`) | Eliminated — GC handles memory |
| **FT_Generic** (user data hooks) | Omitted — users wrap `Face` in their own struct |
| **OT-SVG renderer** (`SVG ` table rendering) | Not implemented — the runtime exposes SVG table metadata and `FACE_FLAG_SVG`, but `LOAD_COLOR` still falls back to outline/grayscale rendering because no SVG glyph loader or rasterizer is shipped |

## Compatibility Target

Compatibility claims in this repository are pinned to the vendored FreeType
2.14.2 snapshot in `vendor/freetype-c`, not to a floating upstream idea of
"current FreeType". The MoonBit runtime is expected to match that vendored
oracle for the supported surface, with explicit exclusions such as the missing
OT-SVG glyph-document/render path.

The full decision record, allowed wording, and exclusion list live in
[`docs/compatibility.md`](docs/compatibility.md).

## API

### Load a font

```moonbit
let font_data : Bytes = ... // font file contents
let face = @freetype.from_bytes(font_data)

// Face metadata
println(face.family_name())    // "DejaVu Sans"
println(face.num_glyphs())     // 6253
println(face.units_per_em())   // 2048
println(face.is_scalable())   // true
println(face.has_kerning())   // true
```

No `Library` object, no initialization, no cleanup. The API is stateless and concurrency-safe.

### Character to glyph mapping

```moonbit
let glyph_index = @freetype.get_char_index(face, 65U) // 'A' → glyph index
```

### Load glyph outlines

```moonbit
// Font units (no scaling)
@freetype.load_glyph(face, glyph_index, load_flags=@base.LOAD_NO_SCALE)
let outline = face.glyph().outline()
println(outline.n_points())    // number of outline points
println(outline.n_contours())  // number of contours
println(outline.points()[0].x())  // first point x coordinate

// Scaled to pixel size
@freetype.set_pixel_sizes(face, 0U, 16U)  // 16 ppem
@freetype.load_glyph(face, glyph_index)
println(face.glyph().metrics().hori_advance())  // advance width in 26.6
```

### Render glyph bitmaps

```moonbit
@freetype.set_pixel_sizes(face, 0U, 16U)
@freetype.load_glyph(face, glyph_index, load_flags=@base.LOAD_RENDER)
println(face.glyph().bitmap().width())
println(face.glyph().bitmap().rows())

// Or render after a separate load_glyph call.
@freetype.load_glyph(face, glyph_index, load_flags=@base.LOAD_NO_HINTING)
@freetype.render_glyph(face)
println(face.glyph().bitmap_left())
println(face.glyph().bitmap_top())

// Explicit render modes.
@freetype.render_glyph(face, mode=Mono)
@freetype.render_glyph(face, mode=Lcd)
@freetype.render_glyph(face, mode=Sdf)

// LOAD_RENDER also honors FreeType-style load targets.
@freetype.load_glyph(
  face,
  glyph_index,
  load_flags=@base.LOAD_RENDER | @base.LOAD_TARGET_LCD,
)

// Color glyphs opt in through LOAD_COLOR and render to BGRA.
@freetype.load_glyph(face, glyph_index, load_flags=@base.LOAD_COLOR)
println(face.glyph().bitmap().pixel_mode()) // Bgra
```

### Kerning

```moonbit
let (kern_x, kern_y) = @freetype.get_kerning(face, glyph_a, glyph_v)
```

### Format detection

```moonbit
let format = @base.detect_format(data)
// Returns: TrueType, CffOpenType, TrueTypeCollection, Woff1, Woff2,
//          Type1Pfb, Type1Pfa, CffStandalone, Bdf, Pcf, WindowsFnt, Pfr, Unknown
```

## Project Structure

```
src/
  lib.mbt              # Public API: from_bytes, get_char_index, load_glyph,
                       #   set_pixel_sizes, get_kerning
  error/               # FTError enum (~80 error codes)
  fixed/               # Fixed-point math: 16.16, 26.6, 2.14, CORDIC trig, matrix ops
  types/               # Shared types: Vector, BBox, Outline, Bitmap, GlyphMetrics, tags
  stream/              # ByteReader: position-tracked Bytes reader
  base/                # FaceRec, GlyphSlot, GlyphLoader, outline ops, format detection
  smooth/              # Outline rasterizer: gray, mono, LCD, LCD_V bitmap emission
  color/               # Color font table parsing, BGRA surfaces, bitmap decode helpers
  sdf/                 # Signed-distance-field rasterization
  sfnt/                # SFNT parsing: table directory, head, hhea, maxp, hmtx, name,
                       #   OS/2, post, cmap (formats 0/2/4/6/8/10/12/13/14), kern,
                       #   WOFF1, WOFF2
  truetype/            # TrueType: glyph loading, loca, bytecode interpreter
  cff/                 # CFF: INDEX/DICT parsing, charstring loading
  psaux/               # PostScript charstring interpreter (Type 2)
  pshinter/            # PostScript hinting: stem alignment, blue zones
  psnames/             # Glyph name ↔ Unicode mapping
  type1/               # Type 1 PFB: segment parsing, eexec decryption
  autofit/             # Auto-hinter: script detection, segment/edge analysis
  bdf/, pcf/           # Bitmap font drivers
  cache/               # Glyph/charmap LRU cache
  otvalid/, gxvalid/   # OpenType and GX/AAT table validation
  parity/              # Parity tests (read fonts from disk, compare with C FreeType)
  bench/               # C FreeType comparison benchmark + report
  benchmarks/          # MoonBit benchmarks (moon bench)
  blit/                # Fast byte-level blit operations (memcpy/memset FFI)
```

## Build

```bash
make build     # Compile
make test      # Run unit tests
make parity    # Run parity tests against C FreeType golden data
make fmt       # Format code + regenerate .mbti files
make bench     # Run C vs MoonBit benchmark comparison
make clean     # Remove build artifacts
make all       # build + fmt + test + parity
```

## Parity Testing

Parity tests verify that the MoonBit port produces identical results to the vendored C FreeType library across all supported font formats. The test pipeline:

1. **Golden file generation** — A Python wrapper (`test/golden/generate/generate.py`) stages the font corpus, using the repo's MoonBit WOFF2 decompressor for `.woff2` files, then invokes a C program (`test/golden/generate/gen_golden.c`) linked against vendored FreeType to dump JSON per font: face metadata, charmap entries, glyph outlines at multiple sizes and load flags, and kerning pairs.

2. **Test generation** — A Python script (`test/parity/gen_parity_tests.py`) reads the golden JSON and generates MoonBit test files that load the same fonts through our port and compare every value.

3. **Font loading** — Tests read fonts from disk at runtime via `@fs.read_file_to_bytes()` (native target).

**Fonts tested** (real corpus plus synthetic edge-case fixtures):

| Font | Format | Glyphs | Source |
|------|--------|--------|--------|
| DejaVu Sans | TrueType | 6,253 | dejavu-fonts |
| Roboto Variable | TrueType | 1,326 | Google Fonts |
| Source Code Pro | CFF/OpenType | 1,568 | Adobe |
| Noto Sans JP | CFF/OpenType | 17,936 | Google Noto |
| DejaVu Sans | TTC | 6,253 × 2 | Converted from TTF |
| DejaVu Sans | WOFF1 | 6,253 | Converted from TTF |
| Source Code Pro | WOFF1 | 1,568 | Converted from OTF |
| DejaVu Sans | WOFF2 | 6,253 | Converted from TTF |
| minimal | WOFF2 (CFF) | 3 | Converted from OTF |
| minimal collection | WOFF2 TTC | 3 × 2 | Synthetic collection reconstruction fixture |
| Source Code Pro | Standalone CFF | 1,568 | Extracted CFF table |
| minimal | Standalone CFF | 3 | Extracted CFF table |
| Nimbus Sans | Type 1 PFB | 855 | URW base35 |
| GNU Unifont | BDF | 57,087 | unifoundry.com |
| Nabla | TrueType / COLR v1 | 3,655 | Google Fonts real-world COLR v1 gradient fixture |
| minimal SBIX / CBDT / COLR | Color TrueType | 3-6 | Synthetic BGRA, COLR v0/v1, and bitmap-format edge-case fixtures |
| uvs / mvar | TrueType | 4-5 | Synthetic UVS and metric-variation fixtures |

**What's verified per font:**

- Format detection
- Font loading without error
- Face metadata: family name, glyph count, units per em, ascender, descender, height, underline
- Bounding box: xMin, yMin, xMax, yMax
- Face flags: scalable, sfnt, horizontal, kerning
- Charmap count and platform/encoding IDs
- Character-to-glyph mapping (up to 50 charcodes per font)
- Glyph outlines in font units: point count, contour count, point coordinates
- Glyph metrics at 16 ppem: horizontal advance
- Rendered bitmap parity: pixel mode, dimensions, bearings, buffer bytes
- TTC multi-face loading
- Kerning pair values (up to 20 pairs)

Run the parity report:

```bash
$ make parity

  PARITY REPORT: MoonBit FreeType Port vs C FreeType

  Total: 536 tests, 536 passed, 0 failed

  Format coverage:
     FULL  TrueType                  .ttf
     FULL  CFF/OpenType              .otf
     FULL  TrueType Collection       .ttc
     FULL  WOFF1                     .woff
     FULL  WOFF2                     .woff2
     FULL  Standalone CFF            .cff
     FULL  Type 1 PFB                .pfb
     FULL  BDF Bitmap                .bdf
     FULL  PCF Bitmap                .pcf
```

## Performance

The MoonBit port achieves near-parity or better performance compared to C FreeType across most font formats. Benchmarks run with `moon bench --release --target native` against C FreeType compiled with `-O2`.

| Font | Format | MoonBit / C Ratio |
|------|--------|-------------------|
| DejaVuSans.ttf | TrueType | **0.5x** (faster) |
| DejaVuSans.ttc | TrueType Collection | **0.8x** (faster) |
| SourceCodePro-Regular.otf | CFF/OpenType | **0.7x** (faster) |
| NotoSansJP-Regular.otf | CFF/OpenType CJK | **0.1x** (faster) |
| NimbusSans-Regular.pfb | Type 1 PFB | **0.5x** (faster) |
| Roboto[wdth,wght].ttf | Variable TrueType | **1.5x** |
| unifont.bdf | BDF Bitmap | 2.3x |
| DejaVuSans.woff | WOFF1 | 9.9x (zlib overhead) |

Run benchmarks:

```bash
make bench    # Runs C FreeType + MoonBit benchmarks and generates comparison report
```

## Dependencies

- [`bikallem/compress`](https://github.com/bikallem/compress) — zlib decompression (WOFF1) and Brotli decompression (WOFF2)
- [`moonbitlang/x`](https://mooncakes.io/docs/#/moonbitlang/x/) — file I/O for parity tests (native target only)

## C-to-MoonBit Design Decisions

| C FreeType | MoonBit Port |
|------------|--------------|
| `FT_Library` (global state) | Eliminated — stateless API |
| `FT_ALLOC`/`FT_FREE` | GC handles memory |
| `FT_Stream` (file I/O) | `ByteReader` over `Bytes` |
| `FT_Fixed` (32-bit signed long) | `Int64` newtype (avoids overflow) |
| `FT_ListRec` (linked list) | `Array[T]` |
| `FT_Hash` | `Map[K, V]` |
| `FT_Driver_ClassRec` (fn ptr table) | Closure-based `SfntOps` / `Type1Ops` |
| `FT_CMap_ClassRec` (fn ptr table) | `CmapLookup` enum with per-format structs |
| `FT_Generic` (user data) | Omitted — users wrap `Face` |
| `src/gzip/`, `src/bzip2/`, Brotli | `bikallem/compress` (zlib + brotli) |

## License

Apache 2.0
