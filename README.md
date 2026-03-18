# bikallem/freetype

Pure MoonBit port of the [FreeType](https://freetype.org/) font library. A full rewrite — not FFI bindings — targeting idiomatic MoonBit with GC-managed memory, no I/O, and a stateless API.

## Features

**Font format support:**

| Format | Extension | Status | Driver |
|--------|-----------|--------|--------|
| TrueType | `.ttf` | Full | `truetype/` — glyph loading, bytecode interpreter |
| OpenType/CFF | `.otf` | Full | `cff/` — CFF INDEX/DICT parsing, Type 2 charstrings |
| TrueType Collection | `.ttc` | Full | `sfnt/` — collection header, per-face loading |
| WOFF1 | `.woff` | Full | `sfnt/woff.mbt` — zlib decompression via `bikallem/compress` |
| WOFF2 | `.woff2` | Not yet | Blocked on Brotli in `bikallem/compress` ([ticket](https://github.com/bikallem/freetype)) |
| Type 1 (PFB/PFA) | `.pfb` `.pfa` | Full | `type1/` — PFB/PFA parsing, eexec, Type 1 charstrings |
| BDF (bitmap) | `.bdf` | Full | `bdf/` — header + glyph bitmap extraction |
| PCF (bitmap) | `.pcf` | Full | `pcf/` — TOC, properties, metrics, encodings, bitmaps |

Obsolete formats **not supported**: CID-keyed (standalone), Type 42, PFR (Bitstream), Windows FNT/FON.
CID-keyed fonts inside CFF/OpenType are supported through the CFF driver.

**Core capabilities:**

- Font loading from `Bytes` (in-memory, no file I/O)
- Character-to-glyph mapping (cmap formats 0, 4, 6, 12)
- Glyph outline loading (TrueType simple/composite, CFF charstrings)
- Pixel size scaling with proper 16.16 fixed-point math
- Kerning pair lookup
- TrueType bytecode interpreter (~40 opcodes: stack, arithmetic, comparison, logic, flow control, push, storage, CVT)
- PostScript Type 2 charstring interpreter (path operators, hints, subroutines, flex)
- PostScript Type 1 charstring interpreter (hsbw, closepath, callothersubr/Flex, seac)
- WOFF1 decompression (zlib via `bikallem/compress`)
- Format auto-detection from file header bytes

## What Is Not Ported

The following FreeType subsystems are **excluded** from this port:

| Subsystem | Reason |
|-----------|--------|
| **Rendering/rasterization** (`src/smooth/`, `src/raster/`, `src/sdf/`) | Out of scope — this library produces outlines, not pixels |
| **File I/O** (`ftsystem.c` file operations) | Accepts `Bytes` instead of file paths; no I/O or OS dependency |
| **SVG rendering** | Requires external SVG renderer |
| **WOFF2** | Requires Brotli decompression (not yet in `bikallem/compress`) |
| **FT_Library global state** | Eliminated — API is stateless, no initialization needed |
| **Memory allocator** (`FT_ALLOC`/`FT_FREE`/`FT_Memory`) | Eliminated — GC handles memory |
| **FT_Generic** (user data hooks) | Omitted — users wrap `Face` in their own struct |
| **TrueType hinting (full)** | Bytecode interpreter has ~40 of ~200 opcodes; point movement instructions (SHP, MIRP, etc.) not yet implemented |
| **PostScript hinting (full)** | Stem alignment and blue zone snapping implemented; full algorithm incomplete |
| **Auto-hinter (full)** | Segment/edge detection infrastructure present; full Latin/CJK fitting not complete |
| **Font variations (full)** | `fvar`/`gvar`/`avar` table structures defined; delta interpolation not implemented |

## API

### Load a font

```moonbit
let font_data : Bytes = ... // font file contents
let face = @freetype.from_bytes(font_data)

// Face metadata
println(face.family_name)     // "DejaVu Sans"
println(face.num_glyphs)      // 6253
println(face.units_per_em)    // 2048
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
@freetype.load_glyph(face, glyph_index, load_flags=@base.load_no_scale)
let outline = face.glyph.outline
println(outline.n_points())    // number of outline points
println(outline.n_contours())  // number of contours
println(outline.points[0].x)   // first point x coordinate

// Scaled to pixel size
@freetype.set_pixel_sizes(face, 0U, 16U)  // 16 ppem
@freetype.load_glyph(face, glyph_index)
println(face.glyph.metrics.hori_advance)   // advance width in 26.6
```

### Kerning

```moonbit
let (kern_x, kern_y) = @freetype.get_kerning(face, glyph_a, glyph_v)
```

### Format detection

```moonbit
let format = @base.detect_format(data)
// Returns: TrueType, CffOpenType, TrueTypeCollection, Woff1, Woff2,
//          Type1Pfb, Type1Pfa, Bdf, Pcf, WindowsFnt, Pfr, Unknown
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
  sfnt/                # SFNT parsing: table directory, head, hhea, maxp, hmtx, name,
                       #   OS/2, post, cmap (formats 0/4/6/12), kern, WOFF1
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
  bench/               # Benchmarks
```

## Build

```bash
make build     # Compile
make test      # Run unit tests (285 tests)
make parity    # Run parity tests against C FreeType golden data (91 tests)
make fmt       # Format code + regenerate .mbti files
make bench     # Run benchmarks
make clean     # Remove build artifacts
make all       # build + fmt + test + parity
```

## Parity Testing

Parity tests verify that the MoonBit port produces identical results to the vendored C FreeType library across all supported font formats. The test pipeline:

1. **Golden file generation** — A C program (`test/golden/generate/gen_golden.c`) links against vendored FreeType and dumps JSON per font: face metadata, charmap entries, glyph outlines at multiple sizes and load flags, and kerning pairs.

2. **Test generation** — A Python script (`test/parity/gen_parity_tests.py`) reads the golden JSON and generates MoonBit test files that load the same fonts through our port and compare every value.

3. **Font loading** — Tests read fonts from disk at runtime via `@fs.read_file_to_bytes()` (native target).

**Fonts tested** (all real-world production fonts):

| Font | Format | Glyphs | Source |
|------|--------|--------|--------|
| DejaVu Sans | TrueType | 6,253 | dejavu-fonts |
| Roboto Variable | TrueType | 1,326 | Google Fonts |
| Source Code Pro | CFF/OpenType | 1,568 | Adobe |
| Noto Sans JP | CFF/OpenType | 17,936 | Google Noto |
| DejaVu Sans | TTC | 6,253 × 2 | Converted from TTF |
| DejaVu Sans | WOFF1 | 6,253 | Converted from TTF |
| Source Code Pro | WOFF1 | 1,568 | Converted from OTF |
| Nimbus Sans | Type 1 PFB | 855 | URW base35 |
| GNU Unifont | BDF | 57,087 | unifoundry.com |

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
- TTC multi-face loading
- Kerning pair values (up to 20 pairs)

Run the parity report:

```bash
$ make parity

  PARITY REPORT: MoonBit FreeType Port vs C FreeType

  Total: 91 tests, 91 passed, 0 failed

  Format coverage:
     FULL  TrueType
     FULL  CFF/OpenType
     FULL  TrueType Collection
     FULL  WOFF1
     LOAD  Type 1 PFB
     LOAD  BDF Bitmap
```

## Dependencies

- [`bikallem/compress`](https://github.com/bikallem/compress) — zlib decompression for WOFF1 table extraction
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
| `src/gzip/`, `src/bzip2/` | `bikallem/compress` |

## License

Apache 2.0
