#!/usr/bin/env python3
"""
generate_test_fonts.py — Generate minimal synthetic test fonts for FreeType testing.

Generates:
  minimal.ttf  — Minimal TrueType font (3 glyphs: .notdef, space, A)
  mvar.ttf     — Minimal variable TrueType font with MVAR face-metric deltas
  uvs.ttf      — Minimal TrueType font with cmap format 14 variation selectors
  minimal.otf  — Minimal CFF/OpenType font (OTTO signature)
  minimal.bdf  — Minimal BDF bitmap font
  minimal.pfb  — Minimal Type 1 PFB font
  minimal.woff — Minimal WOFF1 wrapping of the TTF
  minimal.ttc  — TrueType Collection containing two faces

Note: minimal.pcf is not generated because it requires the bdftopcf tool.
      To create one: bdftopcf minimal.bdf > minimal.pcf
"""

import struct
import zlib
import os
import sys
import datetime

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))


# ---------------------------------------------------------------------------
# Utility helpers
# ---------------------------------------------------------------------------

def pad4(data: bytes) -> bytes:
    """Pad data to 4-byte boundary with zero bytes."""
    r = len(data) % 4
    return data + b'\x00' * ((4 - r) % 4)


def calc_checksum(data: bytes) -> int:
    """Calculate OpenType table checksum (sum of 32-bit big-endian words)."""
    padded = pad4(data)
    total = 0
    for i in range(0, len(padded), 4):
        total += struct.unpack('>I', padded[i:i+4])[0]
    return total & 0xFFFFFFFF


def calc_head_checksum_adjustment(font_data: bytes) -> int:
    """Calculate checksumAdjustment for head table."""
    whole = calc_checksum(font_data)
    return (0xB1B0AFBA - whole) & 0xFFFFFFFF


def make_tag(s: str) -> bytes:
    return s.encode('ascii')


def search_range(n: int) -> tuple:
    """Compute searchRange, entrySelector, rangeShift for n tables."""
    import math
    entry_sel = int(math.floor(math.log2(n))) if n > 0 else 0
    search_rng = (2 ** entry_sel) * 16
    range_shift = n * 16 - search_rng
    return search_rng, entry_sel, range_shift


# ---------------------------------------------------------------------------
# Table builders for TTF
# ---------------------------------------------------------------------------

def build_head_table(*, units_per_em=1000, x_min=0, y_min=0, x_max=500, y_max=700,
                     index_to_loc_format=0) -> bytes:
    """Build a 'head' table. checksumAdjustment is set to 0 and patched later."""
    created = modified = 3600 * 24 * (datetime.date(2025, 1, 1) - datetime.date(1904, 1, 1)).days
    return struct.pack('>HH'   # majorVersion, minorVersion (1.0)
                       'I'     # fontRevision (16.16 fixed)
                       'I'     # checksumAdjustment (placeholder)
                       'I'     # magicNumber
                       'H'     # flags
                       'H'     # unitsPerEm
                       'q'     # created
                       'q'     # modified
                       'hhhh'  # xMin, yMin, xMax, yMax
                       'H'     # macStyle
                       'H'     # lowestRecPPEM
                       'h'     # fontDirectionHint
                       'h'     # indexToLocFormat
                       'h',    # glyphDataFormat
                       1, 0,
                       0x00010000,  # fontRevision = 1.0
                       0,  # checksumAdjustment placeholder
                       0x5F0F3CF5,
                       0x000B,  # flags: baseline at y=0, lsb at x=0, etc.
                       units_per_em,
                       created, modified,
                       x_min, y_min, x_max, y_max,
                       0,  # macStyle
                       8,  # lowestRecPPEM
                       2,  # fontDirectionHint
                       index_to_loc_format,  # 0=short, 1=long
                       0)  # glyphDataFormat


def build_hhea_table(*, ascent=800, descent=-200, num_hmetrics=3,
                     advance_width_max=600) -> bytes:
    return struct.pack('>HH'   # version (1.0)
                       'h'     # ascent
                       'h'     # descent
                       'h'     # lineGap
                       'H'     # advanceWidthMax
                       'h'     # minLeftSideBearing
                       'h'     # minRightSideBearing
                       'h'     # xMaxExtent
                       'h'     # caretSlopeRise
                       'h'     # caretSlopeRun
                       'h'     # caretOffset
                       'hhhh'  # reserved
                       'h'     # metricDataFormat
                       'H',    # numOfLongHorMetrics
                       1, 0,
                       ascent, descent, 0,
                       advance_width_max,
                       0, 0, advance_width_max,
                       1, 0, 0,
                       0, 0, 0, 0,
                       0,
                       num_hmetrics)


def build_maxp_table(*, num_glyphs=3, max_points=3, max_contours=1) -> bytes:
    return struct.pack('>I'    # version (1.0)
                       'H'     # numGlyphs
                       'H'     # maxPoints
                       'H'     # maxContours
                       'H'     # maxCompositePoints
                       'H'     # maxCompositeContours
                       'H'     # maxZones
                       'H'     # maxTwilightPoints
                       'H'     # maxStorage
                       'H'     # maxFunctionDefs
                       'H'     # maxInstructionDefs
                       'H'     # maxStackElements
                       'H'     # maxSizeOfInstructions
                       'H'     # maxComponentElements
                       'H',    # maxComponentDepth
                       0x00010000,
                       num_glyphs,
                       max_points, max_contours,
                       0, 0,
                       2, 0, 0, 0, 0, 64, 0, 0, 0)


def build_os2_table(*, units_per_em=1000) -> bytes:
    """Build a minimal OS/2 table (version 4)."""
    # panose: 10 bytes of zeros
    # ulUnicodeRange: 4 x uint32
    # achVendID: 4 bytes
    # fsSelection, usFirstCharIndex, usLastCharIndex
    # sTypoAscender, sTypoDescender, sTypoLineGap
    # usWinAscent, usWinDescent
    # ulCodePageRange: 2 x uint32
    # sxHeight, sCapHeight, usDefaultChar, usBreakChar, usMaxContext
    data = struct.pack('>H'    # version
                       'h'     # xAvgCharWidth
                       'H'     # usWeightClass
                       'H'     # usWidthClass
                       'H'     # fsType
                       'h'     # ySubscriptXSize
                       'h'     # ySubscriptYSize
                       'h'     # ySubscriptXOffset
                       'h'     # ySubscriptYOffset
                       'h'     # ySuperscriptXSize
                       'h'     # ySuperscriptYSize
                       'h'     # ySuperscriptXOffset
                       'h'     # ySuperscriptYOffset
                       'h'     # yStrikeoutSize
                       'h'     # yStrikeoutPosition
                       'h',    # sFamilyClass
                       4,      # version 4
                       500, 400, 5, 0,
                       650, 600, 0, 75,
                       650, 600, 0, 350,
                       50, 300, 0)
    # panose (10 bytes)
    data += b'\x00' * 10
    # ulUnicodeRange1-4
    data += struct.pack('>IIII', 1, 0, 0, 0)  # Basic Latin
    # achVendID
    data += b'TEST'
    # fsSelection (bit 6 = REGULAR)
    data += struct.pack('>H', 0x0040)
    # usFirstCharIndex, usLastCharIndex
    data += struct.pack('>HH', 32, 65)
    # sTypoAscender, sTypoDescender, sTypoLineGap
    data += struct.pack('>hhh', 800, -200, 0)
    # usWinAscent, usWinDescent
    data += struct.pack('>HH', 800, 200)
    # ulCodePageRange1-2
    data += struct.pack('>II', 1, 0)
    # sxHeight, sCapHeight, usDefaultChar, usBreakChar, usMaxContext
    data += struct.pack('>hhHHH', 500, 700, 0, 32, 0)
    return data


def build_name_table(*, family='Minimal', style='Regular') -> bytes:
    """Build a 'name' table with platform 3 (Windows), encoding 1 (Unicode BMP)."""
    names = {
        0: 'Copyright 2025 Test',
        1: family,
        2: style,
        3: f'{family}-{style}',
        4: f'{family} {style}',
        5: 'Version 1.0',
        6: f'{family}-{style}',
    }

    records = []
    string_data = b''
    for name_id in sorted(names.keys()):
        encoded = names[name_id].encode('utf-16-be')
        records.append(struct.pack('>HHHHHH',
                                   3,  # platformID (Windows)
                                   1,  # encodingID (Unicode BMP)
                                   0x0409,  # languageID (English US)
                                   name_id,
                                   len(encoded),
                                   len(string_data)))
        string_data += encoded

    count = len(records)
    string_offset = 6 + count * 12
    header = struct.pack('>HHH', 0, count, string_offset)
    return header + b''.join(records) + string_data


def build_cmap_table() -> bytes:
    """Build a 'cmap' table with format 4 subtable mapping space(32) and A(65)."""
    # Format 4 subtable
    # Segments: [32-32], [65-65], [0xFFFF-0xFFFF]
    seg_count = 3
    seg_count_x2 = seg_count * 2

    import math
    entry_sel = int(math.floor(math.log2(seg_count)))
    search_rng = (2 ** entry_sel) * 2
    range_shift = seg_count_x2 - search_rng

    # endCode: 32, 65, 0xFFFF
    end_codes = struct.pack('>HHH', 32, 65, 0xFFFF)
    # reservedPad
    reserved = struct.pack('>H', 0)
    # startCode: 32, 65, 0xFFFF
    start_codes = struct.pack('>HHH', 32, 65, 0xFFFF)
    # idDelta: glyph_index - charcode. space=gid1 -> 1-32=-31, A=gid2 -> 2-65=-63
    # For 0xFFFF segment: delta=1 so glyph = 0xFFFF+1 = 0 (mod 65536)
    id_deltas = struct.pack('>hhh', 1 - 32, 2 - 65, 1)
    # idRangeOffset: all 0
    id_range_offsets = struct.pack('>HHH', 0, 0, 0)

    subtable_data = (end_codes + reserved + start_codes +
                     id_deltas + id_range_offsets)
    subtable_length = 14 + len(subtable_data)  # format4 header is 14 bytes

    subtable = struct.pack('>HHHHHHH',
                           4,  # format
                           subtable_length,
                           0,  # language
                           seg_count_x2,
                           search_rng,
                           entry_sel,
                           range_shift)
    subtable += subtable_data

    # cmap header: version=0, numTables=1
    header = struct.pack('>HH', 0, 1)
    # Encoding record: platformID=3, encodingID=1, offset to subtable
    enc_record = struct.pack('>HHI', 3, 1, 4 + 8)  # header=4, record=8
    return header + enc_record + subtable


def build_cmap_table_uvs() -> bytes:
    """Build a cmap with a base Unicode BMP subtable and a format 14 UVS table."""
    import math

    seg_count = 3
    seg_count_x2 = seg_count * 2
    entry_sel = int(math.floor(math.log2(seg_count)))
    search_rng = (2 ** entry_sel) * 2
    range_shift = seg_count_x2 - search_rng

    end_codes = struct.pack('>HHH', 32, 65, 0xFFFF)
    reserved = struct.pack('>H', 0)
    start_codes = struct.pack('>HHH', 32, 65, 0xFFFF)
    id_deltas = struct.pack('>hhh', 1 - 32, 2 - 65, 1)
    id_range_offsets = struct.pack('>HHH', 0, 0, 0)
    format4_body = end_codes + reserved + start_codes + id_deltas + id_range_offsets
    format4 = struct.pack(
        '>HHHHHHH',
        4,
        14 + len(format4_body),
        0,
        seg_count_x2,
        search_rng,
        entry_sel,
        range_shift,
    ) + format4_body

    selector = 0xFE0F
    default_uvs = (
        struct.pack('>I', 1) +
        bytes([0x00, 0x00, 0x20, 0x00])
    )
    non_default_uvs = (
        struct.pack('>I', 1) +
        bytes([0x00, 0x00, 0x41]) +
        struct.pack('>H', 3)
    )
    format14_header_len = 10
    selector_record_len = 11
    default_off = format14_header_len + selector_record_len
    non_default_off = default_off + len(default_uvs)
    format14 = (
        struct.pack('>H', 14) +
        struct.pack('>I', format14_header_len + selector_record_len +
                    len(default_uvs) + len(non_default_uvs)) +
        struct.pack('>I', 1) +
        bytes([(selector >> 16) & 0xFF, (selector >> 8) & 0xFF, selector & 0xFF]) +
        struct.pack('>I', default_off) +
        struct.pack('>I', non_default_off) +
        default_uvs +
        non_default_uvs
    )

    header = struct.pack('>HH', 0, 2)
    format4_offset = 4 + 2 * 8
    format14_offset = format4_offset + len(format4)
    records = (
        struct.pack('>HHI', 3, 1, format4_offset) +
        struct.pack('>HHI', 0, 5, format14_offset)
    )
    return header + records + format4 + format14


def build_post_table() -> bytes:
    """Build a minimal 'post' table (format 3 — no glyph names)."""
    return struct.pack('>I'    # format (3.0)
                       'I'     # italicAngle (16.16 fixed)
                       'h'     # underlinePosition
                       'h'     # underlineThickness
                       'I',    # isFixedPitch
                       0x00030000,
                       0,
                       -100,
                       50,
                       0)


def png_chunk(tag: bytes, payload: bytes) -> bytes:
    return (
        struct.pack(">I", len(payload))
        + tag
        + payload
        + struct.pack(">I", zlib.crc32(tag + payload) & 0xFFFFFFFF)
    )


def pack_png_samples(samples: list[int], bit_depth: int) -> bytes:
    if bit_depth == 8:
        return bytes(samples)
    if bit_depth == 16:
        out = bytearray()
        for sample in samples:
            out.extend(struct.pack(">H", sample))
        return bytes(out)
    if bit_depth not in (1, 2, 4):
        raise ValueError(f"unsupported packed PNG bit depth {bit_depth}")
    max_sample = (1 << bit_depth) - 1
    out = bytearray()
    acc = 0
    bits = 0
    for sample in samples:
        if not 0 <= sample <= max_sample:
            raise ValueError(f"sample {sample} out of range for bit depth {bit_depth}")
        acc = (acc << bit_depth) | sample
        bits += bit_depth
        if bits == 8:
            out.append(acc)
            acc = 0
            bits = 0
    if bits:
        out.append(acc << (8 - bits))
    return bytes(out)


def build_png_from_packed_rows(
    width: int,
    height: int,
    color_type: int,
    bit_depth: int,
    packed_rows: list[bytes],
    *,
    palette: list[tuple[int, int, int]] | None = None,
    transparency: bytes | None = None,
    interlace: int = 0,
) -> bytes:
    assert len(packed_rows) == height
    raw = bytearray()
    for row in packed_rows:
        raw.append(0)
        raw.extend(row)
    ihdr = struct.pack(">IIBBBBB", width, height, bit_depth, color_type, 0, 0, interlace)
    chunks = [png_chunk(b"IHDR", ihdr)]
    if palette is not None:
        plte = bytearray()
        for red, green, blue in palette:
            plte.extend(bytes([red, green, blue]))
        chunks.append(png_chunk(b"PLTE", bytes(plte)))
    if transparency is not None:
        chunks.append(png_chunk(b"tRNS", transparency))
    chunks.append(png_chunk(b"IDAT", zlib.compress(bytes(raw))))
    chunks.append(png_chunk(b"IEND", b""))
    return b"\x89PNG\r\n\x1a\n" + b"".join(chunks)


def build_rgba_png(width: int, height: int, pixels: bytes) -> bytes:
    """Build a tiny non-interlaced RGBA PNG."""
    assert len(pixels) == width * height * 4
    rows = [
        pixels[y * width * 4:(y + 1) * width * 4]
        for y in range(height)
    ]
    return build_png_from_packed_rows(width, height, 6, 8, rows)


def build_graya_png(width: int, height: int, pixels: bytes) -> bytes:
    assert len(pixels) == width * height * 2
    rows = [
        pixels[y * width * 2:(y + 1) * width * 2]
        for y in range(height)
    ]
    return build_png_from_packed_rows(width, height, 4, 8, rows)


def build_gray_png(width: int, height: int, values: list[int], bit_depth: int = 8) -> bytes:
    assert len(values) == width * height
    rows = [
        pack_png_samples(values[y * width:(y + 1) * width], bit_depth)
        for y in range(height)
    ]
    return build_png_from_packed_rows(width, height, 0, bit_depth, rows)


def build_indexed_png(
    width: int,
    height: int,
    indexes: list[int],
    palette: list[tuple[int, int, int]],
    *,
    alphas: list[int] | None = None,
    bit_depth: int = 8,
) -> bytes:
    assert len(indexes) == width * height
    rows = [
        pack_png_samples(indexes[y * width:(y + 1) * width], bit_depth)
        for y in range(height)
    ]
    transparency = None if alphas is None else bytes(alphas)
    return build_png_from_packed_rows(
        width,
        height,
        3,
        bit_depth,
        rows,
        palette=palette,
        transparency=transparency,
    )


def build_interlaced_rgba_png(width: int, height: int, pixels: bytes) -> bytes:
    assert len(pixels) == width * height * 4
    passes = [
        (0, 0, 8, 8),
        (4, 0, 8, 8),
        (0, 4, 4, 8),
        (2, 0, 4, 4),
        (0, 2, 2, 4),
        (1, 0, 2, 2),
        (0, 1, 1, 2),
    ]
    raw = bytearray()
    for start_x, start_y, step_x, step_y in passes:
        cols = list(range(start_x, width, step_x))
        rows = list(range(start_y, height, step_y))
        if not cols or not rows:
            continue
        for y in rows:
            raw.append(0)
            for x in cols:
                off = (y * width + x) * 4
                raw.extend(pixels[off:off + 4])
    ihdr = struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 1)
    return (
        b"\x89PNG\r\n\x1a\n"
        + png_chunk(b"IHDR", ihdr)
        + png_chunk(b"IDAT", zlib.compress(bytes(raw)))
        + png_chunk(b"IEND", b"")
    )


def build_minimal_sbix_png() -> bytes:
    """Generate a 6x6 RGBA bitmap with a simple diagonal slash."""
    width, height = 6, 6
    pixels = bytearray(width * height * 4)
    for y in range(height):
        for x in range(width):
            off = (y * width + x) * 4
            if x == y or x == y - 1 or x == y + 1:
                pixels[off:off + 4] = bytes([0xE0, 0x40, 0x20, 0xFF])  # RGBA
            else:
                pixels[off:off + 4] = bytes([0x00, 0x00, 0x00, 0x00])
    return build_rgba_png(width, height, bytes(pixels))


def build_sbix_table(num_glyphs: int, png_data: bytes) -> bytes:
    """Build a minimal sbix table with one strike and a PNG for glyph 2."""
    strike_offset = 8 + 4
    strike_header = struct.pack(">HH", 16, 72)
    offsets_base = 4 + (num_glyphs + 1) * 4
    glyph2 = struct.pack(">hh4s", 0, 0, b"png ") + png_data
    glyph_offsets = [offsets_base, offsets_base, offsets_base, offsets_base + len(glyph2)]
    strike = strike_header + b"".join(struct.pack(">I", off) for off in glyph_offsets) + glyph2
    return struct.pack(">HHI", 1, 3, 1) + struct.pack(">I", strike_offset) + strike


def build_cbdt_png_glyph(png_data: bytes) -> bytes:
    """Build a CBDT format 17 glyph record."""
    return bytes([6, 6, 0, 6, 8]) + struct.pack(">I", len(png_data)) + png_data


def build_cbdt_table(png_data: bytes) -> bytes:
    glyph = build_cbdt_png_glyph(png_data)
    return struct.pack(">I", 0x00020000) + glyph


def build_cblc_table(png_data: bytes) -> bytes:
    """Build a minimal CBLC table with one strike and one PNG glyph."""
    glyph = build_cbdt_png_glyph(png_data)
    header_size = 8
    bitmap_size_table_offset = header_size
    bitmap_size_table_size = 48
    array_offset = bitmap_size_table_offset + bitmap_size_table_size
    array_size = 8
    index_subtable_offset = array_size
    index_subtable = (
        struct.pack(">HHI", 1, 17, 4) +
        struct.pack(">II", 0, len(glyph))
    )
    index_tables_size = array_size + len(index_subtable)
    bitmap_size_table = (
        struct.pack(">I", array_offset) +
        struct.pack(">I", index_tables_size) +
        struct.pack(">I", 1) +  # numberOfIndexSubTables
        struct.pack(">I", 0) +  # colorRef
        b"\x00" * 24 +         # hori + vert line metrics
        struct.pack(">HH", 2, 2) +
        bytes([16, 16, 32, 1])
    )
    index_subtable_array = struct.pack(">HHI", 2, 2, index_subtable_offset)
    return (
        struct.pack(">II", 0x00020000, 1) +
        bitmap_size_table +
        index_subtable_array +
        index_subtable
    )


def build_small_metrics_bytes(
    width: int,
    height: int,
    hori_bearing_x: int,
    hori_bearing_y: int,
    hori_advance: int,
) -> bytes:
    return bytes([
        width & 0xFF,
        height & 0xFF,
        hori_bearing_x & 0xFF,
        hori_bearing_y & 0xFF,
        hori_advance & 0xFF,
    ])


def build_big_metrics_bytes(
    width: int,
    height: int,
    hori_bearing_x: int,
    hori_bearing_y: int,
    hori_advance: int,
    vert_bearing_x: int,
    vert_bearing_y: int,
    vert_advance: int,
) -> bytes:
    return bytes([
        width & 0xFF,
        height & 0xFF,
        hori_bearing_x & 0xFF,
        hori_bearing_y & 0xFF,
        hori_advance & 0xFF,
        vert_bearing_x & 0xFF,
        vert_bearing_y & 0xFF,
        vert_advance & 0xFF,
    ])


def pack_sbit_pixels(
    width: int,
    height: int,
    bit_depth: int,
    values: list[int],
    *,
    byte_aligned: bool,
) -> bytes:
    assert len(values) == width * height
    if byte_aligned:
        rows = []
        for y in range(height):
            rows.append(pack_png_samples(values[y * width:(y + 1) * width], bit_depth))
        return b"".join(rows)
    return pack_png_samples(values, bit_depth)


def build_cbdt_sbit_glyph(
    image_format: int,
    width: int,
    height: int,
    bit_depth: int,
    values: list[int],
    *,
    hori_bearing_x: int = 0,
    hori_bearing_y: int | None = None,
    hori_advance: int | None = None,
    vert_bearing_x: int = 0,
    vert_bearing_y: int = 0,
    vert_advance: int | None = None,
) -> tuple[bytes, bytes | None]:
    if hori_bearing_y is None:
        hori_bearing_y = height
    if hori_advance is None:
        hori_advance = width + 1
    if vert_advance is None:
        vert_advance = height + 2
    if image_format in (1, 2):
        data = build_small_metrics_bytes(
            width, height, hori_bearing_x, hori_bearing_y, hori_advance,
        )
        data += pack_sbit_pixels(width, height, bit_depth, values, byte_aligned=(image_format == 1))
        return data, None
    if image_format == 5:
        big = build_big_metrics_bytes(
            width,
            height,
            hori_bearing_x,
            hori_bearing_y,
            hori_advance,
            vert_bearing_x,
            vert_bearing_y,
            vert_advance,
        )
        data = pack_sbit_pixels(width, height, bit_depth, values, byte_aligned=False)
        return data, big
    if image_format in (6, 7):
        data = build_big_metrics_bytes(
            width,
            height,
            hori_bearing_x,
            hori_bearing_y,
            hori_advance,
            vert_bearing_x,
            vert_bearing_y,
            vert_advance,
        )
        data += pack_sbit_pixels(width, height, bit_depth, values, byte_aligned=(image_format == 6))
        return data, None
    raise ValueError(f"unsupported CBDT sbit format {image_format}")


def build_cbdt_compound_glyph(
    image_format: int,
    width: int,
    height: int,
    components: list[tuple[int, int, int]],
    *,
    hori_bearing_x: int = 0,
    hori_bearing_y: int | None = None,
    hori_advance: int | None = None,
    vert_bearing_x: int = 0,
    vert_bearing_y: int = 0,
    vert_advance: int | None = None,
) -> bytes:
    if hori_bearing_y is None:
        hori_bearing_y = height
    if hori_advance is None:
        hori_advance = width + 1
    if vert_advance is None:
        vert_advance = height + 2
    comp = struct.pack(">H", len(components))
    for glyph_id, dx, dy in components:
        comp += struct.pack(">Hbb", glyph_id, dx, dy)
    if image_format == 8:
        return (
            build_small_metrics_bytes(width, height, hori_bearing_x, hori_bearing_y, hori_advance)
            + b"\x00"
            + comp
        )
    if image_format == 9:
        return (
            build_big_metrics_bytes(
                width,
                height,
                hori_bearing_x,
                hori_bearing_y,
                hori_advance,
                vert_bearing_x,
                vert_bearing_y,
                vert_advance,
            )
            + comp
        )
    raise ValueError(f"unsupported CBDT compound format {image_format}")


def build_cbdt_all_tables(records: list[dict], *, num_glyphs: int, bit_depth: int = 4, ppem: int = 16) -> tuple[bytes, bytes]:
    cbdt = bytearray(struct.pack(">I", 0x00020000))
    glyph_offsets = {}
    for record in records:
        glyph_offsets[record["glyph_id"]] = len(cbdt)
        cbdt.extend(record["data"])

    header_size = 8
    bitmap_size_table_offset = header_size
    bitmap_size_table_size = 48
    array_offset = bitmap_size_table_offset + bitmap_size_table_size
    array_size = len(records) * 8
    subtable_base = array_offset + array_size

    subtables = []
    for record in records:
        image_offset = glyph_offsets[record["glyph_id"]]
        image_size = len(record["data"])
        if record["index_format"] == 1:
            subtable = (
                struct.pack(">HHI", 1, record["image_format"], image_offset) +
                struct.pack(">II", 0, image_size)
            )
        elif record["index_format"] == 2:
            assert record.get("fallback_metrics") is not None
            subtable = (
                struct.pack(">HHI", 2, record["image_format"], image_offset) +
                struct.pack(">I", image_size) +
                record["fallback_metrics"]
            )
        elif record["index_format"] == 5:
            assert record.get("fallback_metrics") is not None
            subtable = (
                struct.pack(">HHI", 5, record["image_format"], image_offset) +
                struct.pack(">I", image_size) +
                record["fallback_metrics"] +
                struct.pack(">I", 1) +
                struct.pack(">H", record["glyph_id"])
            )
        else:
            raise ValueError(f"unsupported index format {record['index_format']}")
        subtables.append(subtable)

    array_entries = bytearray()
    subtable_offset = array_size
    for record, subtable in zip(records, subtables):
        array_entries.extend(struct.pack(">HHI", record["glyph_id"], record["glyph_id"], subtable_offset))
        subtable_offset += len(subtable)

    bitmap_size_table = (
        struct.pack(">I", array_offset) +
        struct.pack(">I", array_size + sum(len(subtable) for subtable in subtables)) +
        struct.pack(">I", len(records)) +
        struct.pack(">I", 0) +
        b"\x00" * 24 +
        struct.pack(">HH", min(record["glyph_id"] for record in records), max(record["glyph_id"] for record in records)) +
        bytes([ppem, ppem, bit_depth, 1])
    )

    cblc = bytearray(struct.pack(">II", 0x00020000, 1))
    cblc.extend(bitmap_size_table)
    cblc.extend(array_entries)
    for subtable in subtables:
        cblc.extend(subtable)
    return bytes(cbdt), bytes(cblc)


def build_cmap_table_pairs(mapping: dict[int, int]) -> bytes:
    """Build a format 4 cmap for sparse BMP mappings."""
    import math

    codes = sorted(mapping.keys())
    seg_count = len(codes) + 1
    seg_count_x2 = seg_count * 2
    entry_sel = int(math.floor(math.log2(seg_count)))
    search_rng = (2 ** entry_sel) * 2
    range_shift = seg_count_x2 - search_rng

    end_codes = codes + [0xFFFF]
    start_codes = codes + [0xFFFF]
    id_deltas = [mapping[code] - code for code in codes] + [1]
    id_range_offsets = [0] * seg_count

    subtable_data = (
        struct.pack(">" + "H" * seg_count, *end_codes) +
        struct.pack(">H", 0) +
        struct.pack(">" + "H" * seg_count, *start_codes) +
        struct.pack(">" + "h" * seg_count, *id_deltas) +
        struct.pack(">" + "H" * seg_count, *id_range_offsets)
    )
    subtable = struct.pack(
        ">HHHHHHH",
        4,
        14 + len(subtable_data),
        0,
        seg_count_x2,
        search_rng,
        entry_sel,
        range_shift,
    ) + subtable_data
    return struct.pack(">HH", 0, 1) + struct.pack(">HHI", 3, 1, 12) + subtable


def build_simple_glyph(points: list[tuple[int, int]]) -> bytes:
    if not points:
        return pad4(struct.pack(">h", 0) + struct.pack(">hhhh", 0, 0, 0, 0))
    xs = [p[0] for p in points]
    ys = [p[1] for p in points]
    x_min, x_max = min(xs), max(xs)
    y_min, y_max = min(ys), max(ys)
    flags = bytes([0x01] * len(points))
    x_deltas = []
    y_deltas = []
    prev_x = 0
    prev_y = 0
    for x, y in points:
        x_deltas.append(x - prev_x)
        y_deltas.append(y - prev_y)
        prev_x = x
        prev_y = y
    data = (
        struct.pack(">h", 1) +
        struct.pack(">hhhh", x_min, y_min, x_max, y_max) +
        struct.pack(">H", len(points) - 1) +
        struct.pack(">H", 0) +
        flags +
        struct.pack(">" + "h" * len(points), *x_deltas) +
        struct.pack(">" + "h" * len(points), *y_deltas)
    )
    return pad4(data)


def build_glyf_and_loca_from_glyphs(glyphs: list[bytes]) -> tuple[bytes, bytes]:
    glyf_data = b"".join(glyphs)
    offsets = [0]
    pos = 0
    for glyph in glyphs:
        pos += len(glyph)
        offsets.append(pos)
    loca_data = b"".join(struct.pack(">H", offset // 2) for offset in offsets)
    return glyf_data, loca_data


def build_hmtx_table_entries(entries: list[tuple[int, int]]) -> bytes:
    return b"".join(struct.pack(">Hh", advance, lsb) for advance, lsb in entries)


def build_cpal_table(palettes: list[list[tuple[int, int, int, int]]]) -> bytes:
    num_palette_entries = len(palettes[0])
    num_palettes = len(palettes)
    flat_records: list[tuple[int, int, int, int]] = []
    color_record_indices = []
    for palette in palettes:
        assert len(palette) == num_palette_entries
        color_record_indices.append(len(flat_records))
        flat_records.extend(palette)
    color_records_offset = 12 + 2 * num_palettes
    data = struct.pack(
        ">HHHHI",
        0,
        num_palette_entries,
        num_palettes,
        len(flat_records),
        color_records_offset,
    )
    data += b"".join(struct.pack(">H", index) for index in color_record_indices)
    for blue, green, red, alpha in flat_records:
        data += bytes([blue, green, red, alpha])
    return data


def build_colr_v0_table(base_glyph_id: int, layers: list[tuple[int, int]]) -> bytes:
    base_offset = 14
    layer_offset = base_offset + 6
    data = struct.pack(">H", 0)
    data += struct.pack(">H", 1)  # numBaseGlyphRecords
    data += struct.pack(">I", base_offset)
    data += struct.pack(">I", layer_offset)
    data += struct.pack(">H", len(layers))
    data += struct.pack(">HHH", base_glyph_id, 0, len(layers))
    for glyph_id, palette_index in layers:
        data += struct.pack(">HH", glyph_id, palette_index)
    return data


def pack_u24(value: int) -> bytes:
    return bytes([(value >> 16) & 0xFF, (value >> 8) & 0xFF, value & 0xFF])


def patch_u24(buf: bytearray, offset: int, value: int) -> None:
    buf[offset:offset + 3] = pack_u24(value)


def build_colr_v1_table() -> bytes:
    """Build a small COLR v1 table using PaintGlyph, ColrGlyph, Translate, and Scale."""
    root4 = bytes([1, 2]) + struct.pack(">I", 0)  # PaintColrLayers, 2 layers
    layer0 = bytes([10]) + pack_u24(6) + struct.pack(">H", 2)
    layer0_solid = bytes([2]) + struct.pack(">Hh", 0xFFFF, 0x4000)
    layer1 = bytes([14]) + pack_u24(8) + struct.pack(">hh", 60, 0)
    layer1_colrglyph = bytes([11]) + struct.pack(">H", 5)
    root5 = bytes([16]) + pack_u24(8) + struct.pack(">hh", 0x3000, 0x3000)
    root5_glyph = bytes([10]) + pack_u24(6) + struct.pack(">H", 3)
    root5_solid = bytes([2]) + struct.pack(">Hh", 1, 0x4000)

    header = (
        struct.pack(">H", 1) +
        struct.pack(">H", 0) +
        struct.pack(">I", 0) +
        struct.pack(">I", 0) +
        struct.pack(">H", 0)
    )
    base_v1_offset = 34
    layer_v1_offset = base_v1_offset + 4 + 2 * 6
    paints_start = layer_v1_offset + 4 + 2 * 4
    root4_offset = paints_start
    layer0_offset = root4_offset + len(root4)
    layer0_solid_offset = layer0_offset + len(layer0)
    layer1_offset = layer0_solid_offset + len(layer0_solid)
    layer1_colrglyph_offset = layer1_offset + len(layer1)
    root5_offset = layer1_colrglyph_offset + len(layer1_colrglyph)
    root5_glyph_offset = root5_offset + len(root5)
    root5_solid_offset = root5_glyph_offset + len(root5_glyph)

    root4 = bytes([1, 2]) + struct.pack(">I", 0)
    layer0 = bytes([10]) + pack_u24(layer0_solid_offset - layer0_offset) + struct.pack(">H", 2)
    layer1 = bytes([14]) + pack_u24(layer1_colrglyph_offset - layer1_offset) + struct.pack(">hh", 60, 0)
    root5 = bytes([16]) + pack_u24(root5_glyph_offset - root5_offset) + struct.pack(">hh", 0x3000, 0x3000)
    root5_glyph = bytes([10]) + pack_u24(root5_solid_offset - root5_glyph_offset) + struct.pack(">H", 3)

    data = header
    data += struct.pack(">I", base_v1_offset)
    data += struct.pack(">I", layer_v1_offset)
    data += struct.pack(">III", 0, 0, 0)
    data += struct.pack(">I", 2)
    data += struct.pack(">HI", 4, root4_offset - base_v1_offset)
    data += struct.pack(">HI", 5, root5_offset - base_v1_offset)
    data += struct.pack(">I", 2)
    data += struct.pack(">I", layer0_offset - layer_v1_offset)
    data += struct.pack(">I", layer1_offset - layer_v1_offset)
    data += root4 + layer0 + layer0_solid + layer1 + layer1_colrglyph + root5 + root5_glyph + root5_solid
    return data


def build_color_line(stops: list[tuple[int, int, int]], extend: int = 0) -> bytes:
    data = bytearray([extend])
    data.extend(struct.pack(">H", len(stops)))
    for stop_offset, palette_index, alpha in stops:
        data.extend(struct.pack(">hHh", stop_offset, palette_index, alpha))
    return bytes(data)


def build_colr_v1_gradients_table() -> bytes:
    items: dict[str, bytearray] = {
        "root4": bytearray(bytes([1, 2]) + struct.pack(">I", 0)),
        "layer4a": bytearray(bytes([10]) + b"\x00\x00\x00" + struct.pack(">H", 2)),
        "layer4b": bytearray(bytes([14]) + b"\x00\x00\x00" + struct.pack(">hh", 48, 0)),
        "linear": bytearray(bytes([4]) + b"\x00\x00\x00" + struct.pack(">hhhhhh", 50, 0, 450, 0, 50, 400)),
        "glyph3_radial": bytearray(bytes([10]) + b"\x00\x00\x00" + struct.pack(">H", 3)),
        "radial": bytearray(bytes([6]) + b"\x00\x00\x00" + struct.pack(">hhhhhh", 220, 220, 40, 250, 250, 220)),
        "root5": bytearray(bytes([32]) + b"\x00\x00\x00" + bytes([23]) + b"\x00\x00\x00"),
        "source_rotate": bytearray(bytes([26]) + b"\x00\x00\x00" + struct.pack(">hhh", 0x1000, 250, 300)),
        "source_skew": bytearray(bytes([30]) + b"\x00\x00\x00" + struct.pack(">hhhh", 0x0800, 0, 250, 250)),
        "source_glyph": bytearray(bytes([10]) + b"\x00\x00\x00" + struct.pack(">H", 3)),
        "sweep": bytearray(bytes([8]) + b"\x00\x00\x00" + struct.pack(">hhhh", 250, 250, 0, 0x4000)),
        "backdrop_scale": bytearray(bytes([22]) + b"\x00\x00\x00" + struct.pack(">hhh", 0x3800, 250, 250)),
        "backdrop_colrglyph": bytearray(bytes([11]) + struct.pack(">H", 4)),
        "linear_line": bytearray(build_color_line([(0, 0, 0x4000), (0x2000, 1, 0x4000), (0x4000, 2, 0x4000)])),
        "radial_line": bytearray(build_color_line([(0, 1, 0x4000), (0x4000, 0, 0x4000)])),
        "sweep_line": bytearray(build_color_line([(0, 2, 0x4000), (0x2000, 1, 0x3000), (0x4000, 0, 0x4000)], extend=1)),
    }
    order = list(items.keys())

    header = (
        struct.pack(">H", 1) +
        struct.pack(">H", 0) +
        struct.pack(">I", 0) +
        struct.pack(">I", 0) +
        struct.pack(">H", 0)
    )
    base_v1_offset = 34
    layer_v1_offset = base_v1_offset + 4 + 2 * 6
    paints_start = layer_v1_offset + 4 + 2 * 4
    offsets = {}
    pos = paints_start
    for name in order:
        offsets[name] = pos
        pos += len(items[name])

    patch_u24(items["layer4a"], 1, offsets["linear"] - offsets["layer4a"])
    patch_u24(items["layer4b"], 1, offsets["glyph3_radial"] - offsets["layer4b"])
    patch_u24(items["linear"], 1, offsets["linear_line"] - offsets["linear"])
    patch_u24(items["glyph3_radial"], 1, offsets["radial"] - offsets["glyph3_radial"])
    patch_u24(items["radial"], 1, offsets["radial_line"] - offsets["radial"])
    patch_u24(items["root5"], 1, offsets["source_rotate"] - offsets["root5"])
    patch_u24(items["root5"], 5, offsets["backdrop_scale"] - offsets["root5"])
    patch_u24(items["source_rotate"], 1, offsets["source_skew"] - offsets["source_rotate"])
    patch_u24(items["source_skew"], 1, offsets["source_glyph"] - offsets["source_skew"])
    patch_u24(items["source_glyph"], 1, offsets["sweep"] - offsets["source_glyph"])
    patch_u24(items["sweep"], 1, offsets["sweep_line"] - offsets["sweep"])
    patch_u24(items["backdrop_scale"], 1, offsets["backdrop_colrglyph"] - offsets["backdrop_scale"])

    clip_list_offset = pos
    clip_box_offset = clip_list_offset + 5 + 7
    clip_list = (
        bytes([1]) +
        struct.pack(">I", 1) +
        struct.pack(">HH", 5, 5) +
        pack_u24(clip_box_offset - clip_list_offset)
    )
    clip_box = bytes([1]) + struct.pack(">hhhh", 100, 80, 400, 560)

    data = bytearray(header)
    data.extend(struct.pack(">I", base_v1_offset))
    data.extend(struct.pack(">I", layer_v1_offset))
    data.extend(struct.pack(">I", clip_list_offset))
    data.extend(struct.pack(">II", 0, 0))
    data.extend(struct.pack(">I", 2))
    data.extend(struct.pack(">HI", 4, offsets["root4"] - base_v1_offset))
    data.extend(struct.pack(">HI", 5, offsets["root5"] - base_v1_offset))
    data.extend(struct.pack(">I", 2))
    data.extend(struct.pack(">I", offsets["layer4a"] - layer_v1_offset))
    data.extend(struct.pack(">I", offsets["layer4b"] - layer_v1_offset))
    for name in order:
        data.extend(items[name])
    data.extend(clip_list)
    data.extend(clip_box)
    return bytes(data)


def build_item_var_store_short(deltas: list[int]) -> bytes:
    region_list = (
        struct.pack(">HH", 1, 1) +
        struct.pack(">hhh", 0, 0x4000, 0x4000)
    )
    item_data = (
        struct.pack(">HHH", len(deltas), 1, 1) +
        struct.pack(">H", 0) +
        b"".join(struct.pack(">h", delta) for delta in deltas)
    )
    return (
        struct.pack(">HIH", 1, 12, 1) +
        struct.pack(">I", 12 + len(region_list)) +
        region_list +
        item_data
    )


def build_colr_v1_var_table() -> bytes:
    root = bytearray(bytes([15]) + b"\x00\x00\x00" + struct.pack(">hhI", 0, 0, 0))
    glyph = bytearray(bytes([10]) + b"\x00\x00\x00" + struct.pack(">H", 2))
    solid = bytearray(bytes([2]) + struct.pack(">Hh", 0, 0x4000))
    header = (
        struct.pack(">H", 1) +
        struct.pack(">H", 0) +
        struct.pack(">I", 0) +
        struct.pack(">I", 0) +
        struct.pack(">H", 0)
    )
    base_v1_offset = 34
    layer_v1_offset = base_v1_offset + 4 + 1 * 6
    paints_start = layer_v1_offset + 4
    root_offset = paints_start
    glyph_offset = root_offset + len(root)
    solid_offset = glyph_offset + len(glyph)
    patch_u24(root, 1, glyph_offset - root_offset)
    patch_u24(glyph, 1, solid_offset - glyph_offset)
    item_var_store_offset = solid_offset + len(solid)
    item_var_store = build_item_var_store_short([120, 0])

    data = bytearray(header)
    data.extend(struct.pack(">I", base_v1_offset))
    data.extend(struct.pack(">I", layer_v1_offset))
    data.extend(struct.pack(">III", 0, 0, item_var_store_offset))
    data.extend(struct.pack(">I", 1))
    data.extend(struct.pack(">HI", 4, root_offset - base_v1_offset))
    data.extend(struct.pack(">I", 0))
    data.extend(root)
    data.extend(glyph)
    data.extend(solid)
    data.extend(item_var_store)
    return bytes(data)


def build_colr_glyph_set() -> tuple[bytes, bytes, bytes, bytes]:
    glyphs = [
        build_simple_glyph([]),  # .notdef
        build_simple_glyph([]),  # space
        build_simple_glyph([(50, 0), (250, 700), (450, 0)]),
        build_simple_glyph([(150, 100), (250, 500), (350, 100)]),
        build_simple_glyph([(50, 0), (250, 700), (450, 0)]),
        build_simple_glyph([(150, 100), (250, 500), (350, 100)]),
    ]
    glyf_data, loca_data = build_glyf_and_loca_from_glyphs(glyphs)
    hmtx = build_hmtx_table_entries([
        (500, 0),
        (250, 0),
        (500, 50),
        (500, 150),
        (500, 50),
        (500, 150),
    ])
    cmap = build_cmap_table_pairs({32: 1, 65: 4})
    return glyf_data, loca_data, hmtx, cmap


def build_glyf_and_loca():
    """Build glyf and loca tables for 3 glyphs: .notdef (empty), space (empty), A (triangle)."""
    glyphs = []

    # Glyph 0: .notdef — empty glyph (0 contours)
    notdef = struct.pack('>h', 0)  # numberOfContours = 0
    notdef += struct.pack('>hhhh', 0, 0, 0, 0)  # xMin, yMin, xMax, yMax
    glyphs.append(pad4(notdef))

    # Glyph 1: space — empty glyph (0 contours)
    space = struct.pack('>h', 0)
    space += struct.pack('>hhhh', 0, 0, 0, 0)
    glyphs.append(pad4(space))

    # Glyph 2: A — triangle outline
    # Triangle: (50,0), (250,700), (450,0)
    num_contours = 1
    x_min, y_min, x_max, y_max = 50, 0, 450, 700
    # endPtsOfContours
    end_pts = struct.pack('>H', 2)  # one contour ending at point index 2
    # instruction length
    instr_len = struct.pack('>H', 0)

    # Flags: all points are on-curve (bit 0 = 1), pack coordinates with appropriate bits
    # Point 0: (50, 0)
    # Point 1: (250, 700)
    # Point 2: (450, 0)

    # We'll use full 16-bit coordinates via flags
    # Flag bits: bit0=onCurve, bit1=xShort, bit2=yShort, bit3=xSameOrPositive, bit4=ySameOrPositive
    # For 16-bit coords: bits 1,3 = 0 (not short, value is signed 16-bit delta)
    # For point 0 (first point): x=50, y=0
    # For point 1: dx=200, dy=700
    # For point 2: dx=200, dy=-700

    # Flag for on-curve, full 16-bit x and y: 0x01
    # Actually, if bit1=0 and bit3=0, x is a 16-bit signed delta
    # If bit2=0 and bit4=0, y is a 16-bit signed delta
    flags = bytes([0x01, 0x01, 0x01])

    # X coordinates as deltas: 50, 200, 200
    x_coords = struct.pack('>hhh', 50, 200, 200)
    # Y coordinates as deltas: 0, 700, -700
    y_coords = struct.pack('>hhh', 0, 700, -700)

    a_glyph = struct.pack('>h', num_contours)
    a_glyph += struct.pack('>hhhh', x_min, y_min, x_max, y_max)
    a_glyph += end_pts + instr_len + flags + x_coords + y_coords
    glyphs.append(pad4(a_glyph))

    # Build glyf table
    glyf_data = b''.join(glyphs)

    # Build loca table (short format: offsets / 2, uint16)
    offsets = [0]
    pos = 0
    for g in glyphs:
        pos += len(g)
        offsets.append(pos)
    # Short loca: each entry is offset/2 as uint16
    loca_data = b''
    for o in offsets:
        loca_data += struct.pack('>H', o // 2)

    return glyf_data, loca_data


def build_glyf_and_loca_uvs():
    """Build glyf/loca for .notdef, space, A, and A.alt."""
    glyphs = []

    notdef = struct.pack('>h', 0) + struct.pack('>hhhh', 0, 0, 0, 0)
    glyphs.append(pad4(notdef))

    space = struct.pack('>h', 0) + struct.pack('>hhhh', 0, 0, 0, 0)
    glyphs.append(pad4(space))

    a_glyph = (
        struct.pack('>h', 1) +
        struct.pack('>hhhh', 50, 0, 450, 700) +
        struct.pack('>H', 2) +
        struct.pack('>H', 0) +
        bytes([0x01, 0x01, 0x01]) +
        struct.pack('>hhh', 50, 200, 200) +
        struct.pack('>hhh', 0, 700, -700)
    )
    glyphs.append(pad4(a_glyph))

    a_alt = (
        struct.pack('>h', 1) +
        struct.pack('>hhhh', 50, 0, 450, 700) +
        struct.pack('>H', 3) +
        struct.pack('>H', 0) +
        bytes([0x01, 0x01, 0x01, 0x01]) +
        struct.pack('>hhhh', 50, 0, 400, 0) +
        struct.pack('>hhhh', 0, 700, 0, -700)
    )
    glyphs.append(pad4(a_alt))

    glyf_data = b''.join(glyphs)
    offsets = [0]
    pos = 0
    for glyph in glyphs:
        pos += len(glyph)
        offsets.append(pos)
    loca_data = b''.join(struct.pack('>H', offset // 2) for offset in offsets)
    return glyf_data, loca_data


def build_hmtx_table() -> bytes:
    """Build hmtx for 3 glyphs. Each has advanceWidth and lsb."""
    # .notdef: advance=500, lsb=0
    # space: advance=250, lsb=0
    # A: advance=500, lsb=50
    data = struct.pack('>Hh', 500, 0)   # .notdef
    data += struct.pack('>Hh', 250, 0)  # space
    data += struct.pack('>Hh', 500, 50) # A
    return data


def build_hmtx_table_uvs() -> bytes:
    """Build hmtx for .notdef, space, A, and A.alt."""
    data = struct.pack('>Hh', 500, 0)
    data += struct.pack('>Hh', 250, 0)
    data += struct.pack('>Hh', 500, 50)
    data += struct.pack('>Hh', 550, 50)
    return data


def build_fvar_table() -> bytes:
    """Build a minimal fvar table with a single wght axis and no instances."""
    axis = struct.pack(
        '>4siiiHH',
        b'wght',
        100 << 16,
        400 << 16,
        900 << 16,
        0,
        256,
    )
    return struct.pack(
        '>HHHHHHHH',
        1,   # majorVersion
        0,   # minorVersion
        16,  # axesArrayOffset
        2,   # reserved
        1,   # axisCount
        20,  # axisSize
        0,   # instanceCount
        4,   # instanceSize
    ) + axis


def build_mvar_table() -> bytes:
    """Build an MVAR table that adjusts face metrics at max weight."""
    value_records = b''.join([
        struct.pack('>4sHH', b'hasc', 0, 0),
        struct.pack('>4sHH', b'hdsc', 0, 1),
        struct.pack('>4sHH', b'hlgp', 0, 2),
        struct.pack('>4sHH', b'undo', 0, 3),
        struct.pack('>4sHH', b'unds', 0, 4),
    ])

    region_list = (
        struct.pack('>HH', 1, 1) +
        struct.pack('>hhh', 0, 0x4000, 0x4000)
    )
    item_data = (
        struct.pack('>HHH', 5, 1, 1) +
        struct.pack('>H', 0) +
        struct.pack('>hhhhh', 50, -20, 30, -10, 8)
    )
    item_store = (
        struct.pack('>HIH', 1, 12, 1) +
        struct.pack('>I', 12 + len(region_list)) +
        region_list +
        item_data
    )

    return (
        struct.pack('>HHHHHH', 1, 0, 0, 8, 5, 12 + len(value_records)) +
        value_records +
        item_store
    )


def assemble_sfnt(tables: dict, sfnt_version: bytes = b'\x00\x01\x00\x00') -> bytes:
    """Assemble an SFNT (TrueType/OpenType) from a dict of {tag: data}."""
    num_tables = len(tables)
    sr, es, rs = search_range(num_tables)
    header = struct.pack('>4sHHHH', sfnt_version, num_tables, sr, es, rs)

    # Table directory: sorted by tag
    sorted_tags = sorted(tables.keys())
    offset = 12 + num_tables * 16  # after header + directory

    directory = b''
    table_data = b''
    table_offsets = {}
    for tag in sorted_tags:
        raw = tables[tag]
        padded = pad4(raw)
        cs = calc_checksum(raw)
        directory += struct.pack('>4sIII', make_tag(tag), cs, offset, len(raw))
        table_offsets[tag] = offset
        table_data += padded
        offset += len(padded)

    font = header + directory + table_data

    # Patch checksumAdjustment in head table
    head_offset = table_offsets['head']
    adj = calc_head_checksum_adjustment(font)
    font = font[:head_offset + 8] + struct.pack('>I', adj) + font[head_offset + 12:]

    return font


# ---------------------------------------------------------------------------
# Generate minimal.ttf
# ---------------------------------------------------------------------------

def generate_ttf() -> bytes:
    glyf_data, loca_data = build_glyf_and_loca()
    tables = {
        'head': build_head_table(x_min=0, y_min=0, x_max=450, y_max=700,
                                 index_to_loc_format=0),
        'hhea': build_hhea_table(num_hmetrics=3, advance_width_max=500),
        'maxp': build_maxp_table(num_glyphs=3, max_points=3, max_contours=1),
        'OS/2': build_os2_table(),
        'name': build_name_table(family='Minimal', style='Regular'),
        'cmap': build_cmap_table(),
        'post': build_post_table(),
        'glyf': glyf_data,
        'loca': loca_data,
        'hmtx': build_hmtx_table(),
    }
    return assemble_sfnt(tables, sfnt_version=b'\x00\x01\x00\x00')


def generate_sbix_ttf() -> bytes:
    glyf_data, loca_data = build_glyf_and_loca()
    tables = {
        'head': build_head_table(x_min=0, y_min=0, x_max=450, y_max=700,
                                 index_to_loc_format=0),
        'hhea': build_hhea_table(num_hmetrics=3, advance_width_max=500),
        'maxp': build_maxp_table(num_glyphs=3, max_points=3, max_contours=1),
        'OS/2': build_os2_table(),
        'name': build_name_table(family='Minimal SBIX', style='Regular'),
        'cmap': build_cmap_table(),
        'post': build_post_table(),
        'glyf': glyf_data,
        'loca': loca_data,
        'hmtx': build_hmtx_table(),
        'sbix': build_sbix_table(3, build_minimal_sbix_png()),
    }
    return assemble_sfnt(tables, sfnt_version=b'\x00\x01\x00\x00')


def generate_cbdt_ttf() -> bytes:
    glyf_data, loca_data = build_glyf_and_loca()
    png = build_minimal_sbix_png()
    tables = {
        'head': build_head_table(x_min=0, y_min=0, x_max=450, y_max=700,
                                 index_to_loc_format=0),
        'hhea': build_hhea_table(num_hmetrics=3, advance_width_max=500),
        'maxp': build_maxp_table(num_glyphs=3, max_points=3, max_contours=1),
        'OS/2': build_os2_table(),
        'name': build_name_table(family='Minimal CBDT', style='Regular'),
        'cmap': build_cmap_table(),
        'post': build_post_table(),
        'glyf': glyf_data,
        'loca': loca_data,
        'hmtx': build_hmtx_table(),
        'CBDT': build_cbdt_table(png),
        'CBLC': build_cblc_table(png),
    }
    return assemble_sfnt(tables, sfnt_version=b'\x00\x01\x00\x00')


def build_empty_glyph_font(num_glyphs: int) -> tuple[bytes, bytes]:
    glyphs = [build_simple_glyph([]) for _ in range(num_glyphs)]
    return build_glyf_and_loca_from_glyphs(glyphs)


def generate_cbdt_all_ttf() -> bytes:
    bit_depth = 4
    png_gray = build_gray_png(
        4,
        4,
        [
            0x0, 0x5, 0xA, 0xF,
            0xF, 0xA, 0x5, 0x0,
            0x0, 0x5, 0xA, 0xF,
            0xF, 0xA, 0x5, 0x0,
        ],
        bit_depth=4,
    )
    png_indexed = build_indexed_png(
        4,
        4,
        [
            0, 1, 2, 3,
            3, 2, 1, 0,
            0, 1, 2, 3,
            3, 2, 1, 0,
        ],
        palette=[
            (0x00, 0x00, 0x00),
            (0xE0, 0x40, 0x20),
            (0x20, 0xA0, 0xE0),
            (0xF0, 0xE0, 0x20),
        ],
        alphas=[0x00, 0xFF, 0xC0, 0xFF],
        bit_depth=2,
    )
    interlace_pixels = bytearray(4 * 4 * 4)
    for y in range(4):
        for x in range(4):
            off = (y * 4 + x) * 4
            if x == y or x + y == 3:
                interlace_pixels[off:off + 4] = bytes([0x10, 0xA0, 0xF0, 0xFF])
            else:
                interlace_pixels[off:off + 4] = bytes([0x00, 0x00, 0x00, 0x00])
    png_interlaced = build_interlaced_rgba_png(4, 4, bytes(interlace_pixels))

    grayscale_values = [
        0x0, 0x4, 0x8, 0xC,
        0xC, 0x8, 0x4, 0x0,
        0x0, 0x4, 0x8, 0xC,
        0xC, 0x8, 0x4, 0x0,
    ]
    grayscale_alt = [
        0x0, 0xF, 0x0, 0xF,
        0x4, 0xB, 0x4, 0xB,
        0x8, 0x7, 0x8, 0x7,
        0xC, 0x3, 0xC, 0x3,
    ]
    grayscale_bar = [
        0x0, 0x0, 0xF, 0xF,
        0x0, 0x0, 0xF, 0xF,
        0xF, 0xF, 0x0, 0x0,
        0xF, 0xF, 0x0, 0x0,
    ]

    records = []
    records.append({
        "glyph_id": 2,
        "index_format": 1,
        "image_format": 17,
        "data": build_cbdt_png_glyph(png_gray),
    })
    format18 = build_big_metrics_bytes(4, 4, 0, 4, 5, 0, 0, 6) + struct.pack(">I", len(png_indexed)) + png_indexed
    records.append({
        "glyph_id": 3,
        "index_format": 1,
        "image_format": 18,
        "data": format18,
    })
    records.append({
        "glyph_id": 4,
        "index_format": 2,
        "image_format": 19,
        "data": struct.pack(">I", len(png_interlaced)) + png_interlaced,
        "fallback_metrics": build_big_metrics_bytes(4, 4, 0, 4, 5, 0, 0, 6),
    })
    data1, _ = build_cbdt_sbit_glyph(1, 4, 4, bit_depth, grayscale_values)
    records.append({"glyph_id": 5, "index_format": 1, "image_format": 1, "data": data1})
    data2, _ = build_cbdt_sbit_glyph(2, 4, 4, bit_depth, grayscale_alt)
    records.append({"glyph_id": 6, "index_format": 1, "image_format": 2, "data": data2})
    data5, metrics5 = build_cbdt_sbit_glyph(5, 4, 4, bit_depth, grayscale_bar)
    records.append({
        "glyph_id": 7,
        "index_format": 5,
        "image_format": 5,
        "data": data5,
        "fallback_metrics": metrics5,
    })
    data6, _ = build_cbdt_sbit_glyph(6, 4, 4, bit_depth, grayscale_values)
    records.append({"glyph_id": 8, "index_format": 1, "image_format": 6, "data": data6})
    data7, _ = build_cbdt_sbit_glyph(7, 4, 4, bit_depth, grayscale_alt)
    records.append({"glyph_id": 9, "index_format": 1, "image_format": 7, "data": data7})
    data8 = build_cbdt_compound_glyph(8, 4, 4, [(5, 0, 0), (6, 0, 0)])
    records.append({"glyph_id": 10, "index_format": 1, "image_format": 8, "data": data8})
    data9 = build_cbdt_compound_glyph(9, 4, 4, [(8, 0, 0), (9, 0, 0)])
    records.append({"glyph_id": 11, "index_format": 1, "image_format": 9, "data": data9})

    glyf_data, loca_data = build_empty_glyph_font(12)
    hmtx = build_hmtx_table_entries([(500, 0)] * 12)
    cmap = build_cmap_table_pairs({
        65: 2,
        66: 3,
        67: 4,
        68: 5,
        69: 6,
        97: 7,
        98: 8,
        99: 9,
        100: 10,
        101: 11,
    })
    cbdt_table, cblc_table = build_cbdt_all_tables(records, num_glyphs=12, bit_depth=bit_depth)
    tables = {
        'head': build_head_table(x_min=0, y_min=0, x_max=4, y_max=4, index_to_loc_format=0),
        'hhea': build_hhea_table(num_hmetrics=12, advance_width_max=500),
        'maxp': build_maxp_table(num_glyphs=12, max_points=0, max_contours=0),
        'OS/2': build_os2_table(),
        'name': build_name_table(family='Minimal CBDT All', style='Regular'),
        'cmap': cmap,
        'post': build_post_table(),
        'glyf': glyf_data,
        'loca': loca_data,
        'hmtx': hmtx,
        'CBDT': cbdt_table,
        'CBLC': cblc_table,
    }
    return assemble_sfnt(tables, sfnt_version=b'\x00\x01\x00\x00')


def generate_colr_v0_ttf() -> bytes:
    glyf_data, loca_data, hmtx, cmap = build_colr_glyph_set()
    palettes = [
        [(0x00, 0x00, 0xFF, 0xFF), (0xFF, 0x00, 0x00, 0xFF)],  # red, blue
        [(0x00, 0xFF, 0x00, 0xFF), (0x00, 0xFF, 0xFF, 0xFF)],  # green, yellow
    ]
    tables = {
        'head': build_head_table(x_min=0, y_min=0, x_max=450, y_max=700,
                                 index_to_loc_format=0),
        'hhea': build_hhea_table(num_hmetrics=6, advance_width_max=500),
        'maxp': build_maxp_table(num_glyphs=6, max_points=3, max_contours=1),
        'OS/2': build_os2_table(),
        'name': build_name_table(family='Minimal COLR V0', style='Regular'),
        'cmap': cmap,
        'post': build_post_table(),
        'glyf': glyf_data,
        'loca': loca_data,
        'hmtx': hmtx,
        'CPAL': build_cpal_table(palettes),
        'COLR': build_colr_v0_table(4, [(2, 0), (3, 1)]),
    }
    return assemble_sfnt(tables, sfnt_version=b'\x00\x01\x00\x00')


def generate_colr_v1_ttf() -> bytes:
    glyf_data, loca_data, hmtx, cmap = build_colr_glyph_set()
    palettes = [
        [(0x00, 0x00, 0xFF, 0xFF), (0xFF, 0x00, 0x00, 0xFF)],
        [(0x00, 0xFF, 0x00, 0xFF), (0x00, 0xFF, 0xFF, 0xFF)],
    ]
    tables = {
        'head': build_head_table(x_min=0, y_min=0, x_max=450, y_max=700,
                                 index_to_loc_format=0),
        'hhea': build_hhea_table(num_hmetrics=6, advance_width_max=500),
        'maxp': build_maxp_table(num_glyphs=6, max_points=3, max_contours=1),
        'OS/2': build_os2_table(),
        'name': build_name_table(family='Minimal COLR V1', style='Regular'),
        'cmap': cmap,
        'post': build_post_table(),
        'glyf': glyf_data,
        'loca': loca_data,
        'hmtx': hmtx,
        'CPAL': build_cpal_table(palettes),
        'COLR': build_colr_v1_table(),
    }
    return assemble_sfnt(tables, sfnt_version=b'\x00\x01\x00\x00')


def generate_colr_v1_gradients_ttf() -> bytes:
    glyf_data, loca_data, hmtx, _ = build_colr_glyph_set()
    cmap = build_cmap_table_pairs({32: 1, 65: 4, 97: 5})
    palettes = [
        [
            (0x00, 0x00, 0xFF, 0xFF),
            (0x00, 0xFF, 0x00, 0xFF),
            (0xFF, 0x00, 0x00, 0xFF),
        ],
        [
            (0xFF, 0xFF, 0x00, 0xFF),
            (0xFF, 0x00, 0xFF, 0xFF),
            (0x00, 0xFF, 0xFF, 0xFF),
        ],
    ]
    tables = {
        'head': build_head_table(x_min=0, y_min=0, x_max=450, y_max=700, index_to_loc_format=0),
        'hhea': build_hhea_table(num_hmetrics=6, advance_width_max=500),
        'maxp': build_maxp_table(num_glyphs=6, max_points=3, max_contours=1),
        'OS/2': build_os2_table(),
        'name': build_name_table(family='Minimal COLR V1 Gradients', style='Regular'),
        'cmap': cmap,
        'post': build_post_table(),
        'glyf': glyf_data,
        'loca': loca_data,
        'hmtx': hmtx,
        'CPAL': build_cpal_table(palettes),
        'COLR': build_colr_v1_gradients_table(),
    }
    return assemble_sfnt(tables, sfnt_version=b'\x00\x01\x00\x00')


def generate_colr_v1_var_ttf() -> bytes:
    glyf_data, loca_data, hmtx, _ = build_colr_glyph_set()
    cmap = build_cmap_table_pairs({32: 1, 65: 4})
    palettes = [[(0x00, 0x00, 0xFF, 0xFF)]]
    tables = {
        'head': build_head_table(x_min=0, y_min=0, x_max=450, y_max=700, index_to_loc_format=0),
        'hhea': build_hhea_table(num_hmetrics=6, advance_width_max=500),
        'maxp': build_maxp_table(num_glyphs=6, max_points=3, max_contours=1),
        'OS/2': build_os2_table(),
        'name': build_name_table(family='Minimal COLR V1 Var', style='Regular'),
        'cmap': cmap,
        'post': build_post_table(),
        'glyf': glyf_data,
        'loca': loca_data,
        'hmtx': hmtx,
        'fvar': build_fvar_table(),
        'CPAL': build_cpal_table(palettes),
        'COLR': build_colr_v1_var_table(),
    }
    return assemble_sfnt(tables, sfnt_version=b'\x00\x01\x00\x00')


def generate_uvs_ttf() -> bytes:
    glyf_data, loca_data = build_glyf_and_loca_uvs()
    tables = {
        'head': build_head_table(x_min=0, y_min=0, x_max=450, y_max=700,
                                 index_to_loc_format=0),
        'hhea': build_hhea_table(num_hmetrics=4, advance_width_max=550),
        'maxp': build_maxp_table(num_glyphs=4, max_points=4, max_contours=1),
        'OS/2': build_os2_table(),
        'name': build_name_table(family='UVS', style='Regular'),
        'cmap': build_cmap_table_uvs(),
        'post': build_post_table(),
        'glyf': glyf_data,
        'loca': loca_data,
        'hmtx': build_hmtx_table_uvs(),
    }
    return assemble_sfnt(tables, sfnt_version=b'\x00\x01\x00\x00')


def generate_mvar_ttf() -> bytes:
    glyf_data, loca_data = build_glyf_and_loca()
    tables = {
        'head': build_head_table(x_min=0, y_min=0, x_max=450, y_max=700,
                                 index_to_loc_format=0),
        'hhea': build_hhea_table(num_hmetrics=3, advance_width_max=500),
        'maxp': build_maxp_table(num_glyphs=3, max_points=3, max_contours=1),
        'OS/2': build_os2_table(),
        'name': build_name_table(family='MVAR', style='Regular'),
        'cmap': build_cmap_table(),
        'post': build_post_table(),
        'glyf': glyf_data,
        'loca': loca_data,
        'hmtx': build_hmtx_table(),
        'fvar': build_fvar_table(),
        'MVAR': build_mvar_table(),
    }
    return assemble_sfnt(tables, sfnt_version=b'\x00\x01\x00\x00')


# ---------------------------------------------------------------------------
# Generate minimal.otf (CFF-based OpenType)
# ---------------------------------------------------------------------------

def encode_cff_int(val: int) -> bytes:
    """Encode an integer in CFF format."""
    if -107 <= val <= 107:
        return bytes([val + 139])
    elif 108 <= val <= 1131:
        val -= 108
        return bytes([247 + (val >> 8), val & 0xFF])
    elif -1131 <= val <= -108:
        val = -val - 108
        return bytes([251 + (val >> 8), val & 0xFF])
    elif -32768 <= val <= 32767:
        return bytes([28]) + struct.pack('>h', val)
    else:
        return bytes([29]) + struct.pack('>i', val)


def build_cff_index(items: list) -> bytes:
    """Build a CFF INDEX structure."""
    count = len(items)
    if count == 0:
        return struct.pack('>H', 0)

    # Determine offSize
    total = sum(len(item) for item in items)
    if total + 1 <= 0xFF:
        off_size = 1
    elif total + 1 <= 0xFFFF:
        off_size = 2
    elif total + 1 <= 0xFFFFFF:
        off_size = 3
    else:
        off_size = 4

    data = struct.pack('>HB', count, off_size)
    offset = 1
    for item in items:
        data += offset.to_bytes(off_size, 'big')
        offset += len(item)
    data += offset.to_bytes(off_size, 'big')
    for item in items:
        data += item
    return data


def build_cff_table() -> bytes:
    """Build a minimal CFF table with .notdef, space, and A glyphs."""
    # Header
    header = bytes([1, 0, 4, 1])  # major=1, minor=0, hdrSize=4, offSize=1

    # Name INDEX
    font_name = b'Minimal-Regular'
    name_index = build_cff_index([font_name])

    # Top DICT
    # We'll build it after we know offsets, using a two-pass approach.
    # For now, build other structures first and compute offsets.

    # String INDEX (empty — use standard strings only)
    string_index = build_cff_index([])

    # Global Subr INDEX (empty)
    gsubr_index = build_cff_index([])

    # CharStrings INDEX
    # .notdef: endchar
    notdef_cs = bytes([14])  # endchar
    # space: endchar
    space_cs = bytes([14])   # endchar
    # A: triangle outline using CFF charstring operators
    # rmoveto(50, 0), rlineto(200, 700), rlineto(200, -700), endchar
    a_cs = (encode_cff_int(50) + encode_cff_int(0) + bytes([21]) +    # rmoveto
            encode_cff_int(200) + encode_cff_int(700) + bytes([5]) +   # rlineto
            encode_cff_int(200) + encode_cff_int(-700) + bytes([5]) +  # rlineto
            bytes([14]))  # endchar

    charstrings_index = build_cff_index([notdef_cs, space_cs, a_cs])

    # Charset (format 0): .notdef is implicit (gid 0), then list SIDs for remaining glyphs
    # space = SID 1 (standard string), A = SID 34 (standard string)
    charset = bytes([0]) + struct.pack('>HH', 1, 34)  # format 0, SID for gid 1 and gid 2

    # Private DICT
    private_dict = b''
    # defaultWidthX = 0
    private_dict = encode_cff_int(0) + bytes([20])  # defaultWidthX = 0

    # Now compute the Top DICT.
    # We need to know the offsets of charset, encoding, charstrings, private dict
    # within the CFF data. Let's do a two-pass.

    def build_top_dict(charset_off, charstrings_off, private_size, private_off):
        d = b''
        # charset (operator 15)
        d += encode_cff_int(charset_off) + bytes([15])
        # charstrings (operator 17)
        d += encode_cff_int(charstrings_off) + bytes([17])
        # Private (operator 18) = size offset
        d += encode_cff_int(private_size) + encode_cff_int(private_off) + bytes([18])
        return d

    # First pass: estimate sizes to compute offsets
    # Layout: header | name_index | top_dict_index | string_index | gsubr_index | charset | charstrings | private
    base = len(header) + len(name_index)
    # top_dict_index size depends on top_dict content, which depends on offsets...
    # Use iterative approach
    top_dict_data = build_top_dict(0, 0, len(private_dict), 0)
    top_dict_index = build_cff_index([top_dict_data])

    for _ in range(5):  # converge
        after_gsubr = base + len(top_dict_index) + len(string_index) + len(gsubr_index)
        charset_off = after_gsubr
        charstrings_off = charset_off + len(charset)
        private_off = charstrings_off + len(charstrings_index)
        top_dict_data = build_top_dict(charset_off, charstrings_off,
                                       len(private_dict), private_off)
        top_dict_index = build_cff_index([top_dict_data])

    cff = header + name_index + top_dict_index + string_index + gsubr_index
    cff += charset + charstrings_index + private_dict
    return cff


def generate_otf() -> bytes:
    tables = {
        'head': build_head_table(x_min=0, y_min=0, x_max=450, y_max=700,
                                 index_to_loc_format=0),
        'hhea': build_hhea_table(num_hmetrics=3, advance_width_max=500),
        'maxp': build_maxp_table_cff(num_glyphs=3),
        'OS/2': build_os2_table(),
        'name': build_name_table(family='MinimalCFF', style='Regular'),
        'cmap': build_cmap_table_otf(),
        'post': build_post_table(),
        'CFF ': build_cff_table(),
        'hmtx': build_hmtx_otf(),
    }
    return assemble_sfnt(tables, sfnt_version=b'OTTO')


def build_maxp_table_cff(*, num_glyphs=2) -> bytes:
    """maxp for CFF fonts is version 0.5 with just numGlyphs."""
    return struct.pack('>IH', 0x00005000, num_glyphs)


def build_cmap_table_otf() -> bytes:
    """cmap for OTF: map space (32) to gid 1 and A (65) to gid 2."""
    import math
    seg_count = 3  # [32-32], [65-65], [0xFFFF]
    seg_count_x2 = seg_count * 2
    entry_sel = int(math.floor(math.log2(seg_count)))
    search_rng = (2 ** entry_sel) * 2
    range_shift = seg_count_x2 - search_rng

    end_codes = struct.pack('>HHH', 32, 65, 0xFFFF)
    reserved = struct.pack('>H', 0)
    start_codes = struct.pack('>HHH', 32, 65, 0xFFFF)
    id_deltas = struct.pack('>hhh', 1 - 32, 2 - 65, 1)
    id_range_offsets = struct.pack('>HHH', 0, 0, 0)

    subtable_data = end_codes + reserved + start_codes + id_deltas + id_range_offsets
    subtable_length = 14 + len(subtable_data)
    subtable = struct.pack('>HHHHHHH',
                           4, subtable_length, 0,
                           seg_count_x2, search_rng, entry_sel, range_shift)
    subtable += subtable_data

    header = struct.pack('>HH', 0, 1)
    enc_record = struct.pack('>HHI', 3, 1, 12)
    return header + enc_record + subtable


def build_hmtx_otf() -> bytes:
    """hmtx for 3 glyphs."""
    data = struct.pack('>Hh', 500, 0)   # .notdef
    data += struct.pack('>Hh', 250, 0)  # space
    data += struct.pack('>Hh', 500, 50) # A
    return data


# ---------------------------------------------------------------------------
# Generate minimal.bdf
# ---------------------------------------------------------------------------

def generate_bdf() -> str:
    return """\
STARTFONT 2.1
FONT -Test-Medium-R-Normal--8-80-75-75-C-80-ISO8859-1
SIZE 8 75 75
FONTBOUNDINGBOX 8 8 0 0
STARTPROPERTIES 2
FONT_ASCENT 7
FONT_DESCENT 1
ENDPROPERTIES
CHARS 2
STARTCHAR space
ENCODING 32
SWIDTH 500 0
DWIDTH 8 0
BBX 8 8 0 0
BITMAP
00
00
00
00
00
00
00
00
ENDCHAR
STARTCHAR A
ENCODING 65
SWIDTH 500 0
DWIDTH 8 0
BBX 8 8 0 0
BITMAP
18
24
42
7E
42
42
42
00
ENDCHAR
ENDFONT
"""


# ---------------------------------------------------------------------------
# Generate minimal.pfb
# ---------------------------------------------------------------------------

def generate_pfb() -> bytes:
    """Generate a minimal Type 1 font in PFB format."""
    # ASCII segment: header portion of Type 1 font
    ascii_part = """%!PS-AdobeFont-1.0: Minimal 001.000
%%Title: Minimal
%%CreationDate: 2025-01-01
10 dict begin
/FontInfo 3 dict dup begin
  /FamilyName (Minimal) readonly def
  /FullName (Minimal) readonly def
  /isFixedPitch false def
end readonly def
/FontName /Minimal def
/FontType 1 def
/FontMatrix [0.001 0 0 0.001 0 0] readonly def
/FontBBox {0 -200 500 800} readonly def
/Encoding 256 array
0 1 255 {1 index exch /.notdef put} for
dup 32 /space put
dup 65 /A put
readonly def
/PaintType 0 def
currentdict end
currentfile eexec
"""

    # Binary segment: eexec-encrypted portion
    # We need to create charstrings and encrypt them
    # The eexec encryption uses cipher with R=55665, c1=52845, c2=22719
    # CharString encryption uses R=4330

    def charstring_encrypt(plaintext: bytes) -> bytes:
        """Encrypt charstring data with lenIV=4."""
        import random
        # 4 random bytes prepended
        r = 4330
        c1, c2 = 52845, 22719
        result = []
        # 4 random prefix bytes
        prefix = bytes([0, 0, 0, 0])
        for b in prefix:
            cipher = (b ^ (r >> 8)) & 0xFF
            result.append(cipher)
            r = ((cipher + r) * c1 + c2) & 0xFFFF
        for b in plaintext:
            cipher = (b ^ (r >> 8)) & 0xFF
            result.append(cipher)
            r = ((cipher + r) * c1 + c2) & 0xFFFF
        return bytes(result)

    def eexec_encrypt(plaintext: bytes) -> bytes:
        """Encrypt with eexec."""
        r = 55665
        c1, c2 = 52845, 22719
        result = []
        # 4 random prefix bytes
        prefix = bytes([0, 0, 0, 0])
        for b in prefix:
            cipher = (b ^ (r >> 8)) & 0xFF
            result.append(cipher)
            r = ((cipher + r) * c1 + c2) & 0xFFFF
        for b in plaintext:
            cipher = (b ^ (r >> 8)) & 0xFF
            result.append(cipher)
            r = ((cipher + r) * c1 + c2) & 0xFFFF
        return bytes(result)

    # Type 1 charstring commands:
    # hsbw: dx dy hsbw (opcode 13)
    # endchar: opcode 14
    # rmoveto: dx dy rmoveto (opcode 21)
    # rlineto: dx dy rlineto (opcode 5)

    def cs_encode_int(val: int) -> bytes:
        """Encode integer for Type 1 charstrings."""
        if -107 <= val <= 107:
            return bytes([val + 139])
        elif 108 <= val <= 1131:
            val -= 108
            return bytes([247 + (val >> 8), val & 0xFF])
        elif -1131 <= val <= -108:
            val = -val - 108
            return bytes([251 + (val >> 8), val & 0xFF])
        else:
            # Use 5-byte encoding
            return bytes([255]) + struct.pack('>i', val)

    # .notdef charstring: width=500, sbw lsb=0
    # hsbw: lsb width hsbw
    notdef_plain = cs_encode_int(0) + cs_encode_int(500) + bytes([13])  # hsbw
    notdef_plain += bytes([14])  # endchar
    notdef_enc = charstring_encrypt(notdef_plain)

    # space charstring
    space_plain = cs_encode_int(0) + cs_encode_int(250) + bytes([13])
    space_plain += bytes([14])
    space_enc = charstring_encrypt(space_plain)

    # A charstring: triangle
    a_plain = cs_encode_int(50) + cs_encode_int(500) + bytes([13])  # hsbw: lsb=50, width=500
    a_plain += cs_encode_int(0) + cs_encode_int(0) + bytes([21])    # rmoveto to (50,0) - relative to lsb
    a_plain += cs_encode_int(200) + cs_encode_int(700) + bytes([5])  # rlineto
    a_plain += cs_encode_int(200) + cs_encode_int(-700) + bytes([5]) # rlineto
    a_plain += bytes([9])  # closepath
    a_plain += bytes([14]) # endchar
    a_enc = charstring_encrypt(a_plain)

    clear_text = f"""dup /Private 5 dict dup begin
/RD {{string currentfile exch readstring pop}} executeonly def
/ND {{noaccess def}} executeonly def
/NP {{noaccess put}} executeonly def
/lenIV 4 def
/password 5839 def
2 index /CharStrings 3 dict dup begin
/.notdef {len(notdef_enc)} RD """

    clear_bytes = clear_text.encode('latin-1')
    clear_bytes += notdef_enc
    clear_bytes += b" ND\n"

    space_line = f"/space {len(space_enc)} RD "
    clear_bytes += space_line.encode('latin-1')
    clear_bytes += space_enc
    clear_bytes += b" ND\n"

    a_line = f"/A {len(a_enc)} RD "
    clear_bytes += a_line.encode('latin-1')
    clear_bytes += a_enc
    clear_bytes += b" ND\n"

    clear_bytes += b"end\nend\nreadonly put\nnoaccess put\ndup /FontName get exch definefont pop\nmark currentfile closefile\n"

    encrypted = eexec_encrypt(clear_bytes)

    # 512 zeros + cleartomark
    zeros = b'0' * 512 + b'\n'
    cleartomark = b'cleartomark\n'

    # PFB segments
    ascii_data = ascii_part.encode('latin-1')
    binary_data = encrypted
    # The trailing ASCII section
    trailing_ascii = zeros + cleartomark

    pfb = b''
    # Segment 1: ASCII
    pfb += struct.pack('<BBi', 0x80, 1, len(ascii_data))
    pfb += ascii_data
    # Segment 2: Binary
    pfb += struct.pack('<BBi', 0x80, 2, len(binary_data))
    pfb += binary_data
    # Segment 3: ASCII (trailing)
    pfb += struct.pack('<BBi', 0x80, 1, len(trailing_ascii))
    pfb += trailing_ascii
    # EOF marker
    pfb += struct.pack('<BB', 0x80, 3)

    return pfb


# ---------------------------------------------------------------------------
# Generate minimal.woff
# ---------------------------------------------------------------------------

def generate_woff(ttf_data: bytes) -> bytes:
    """Wrap a TTF font in WOFF1 format."""
    # Parse the TTF to get table directory
    sfnt_version = ttf_data[0:4]
    num_tables = struct.unpack('>H', ttf_data[4:6])[0]

    tables = []
    for i in range(num_tables):
        offset = 12 + i * 16
        tag = ttf_data[offset:offset+4]
        checksum, tbl_offset, tbl_length = struct.unpack('>III', ttf_data[offset+4:offset+16])
        raw = ttf_data[tbl_offset:tbl_offset+tbl_length]
        tables.append((tag, checksum, raw))

    # WOFF header is 44 bytes
    # WOFF table directory entry is 20 bytes each
    woff_header_size = 44
    woff_dir_size = 20 * num_tables
    data_offset = woff_header_size + woff_dir_size

    # Compress each table and build directory
    woff_dir = b''
    woff_table_data = b''
    current_offset = data_offset

    for tag, checksum, raw in tables:
        compressed = zlib.compress(raw)
        # Only use compressed if smaller
        if len(compressed) >= len(raw):
            compressed = raw
            comp_length = len(raw)
        else:
            comp_length = len(compressed)

        woff_dir += struct.pack('>4sIIII',
                                tag,
                                current_offset,
                                comp_length,
                                len(raw),
                                checksum)
        padded = pad4(compressed)
        woff_table_data += padded
        current_offset += len(padded)

    total_size = data_offset + len(woff_table_data)

    woff_header = struct.pack('>4s'    # signature
                              '4s'     # flavor (sfnt version)
                              'I'      # length
                              'H'      # numTables
                              'H'      # reserved
                              'I'      # totalSfntSize
                              'H'      # majorVersion
                              'H'      # minorVersion
                              'I'      # metaOffset
                              'I'      # metaLength
                              'I'      # metaOrigLength
                              'I'      # privOffset
                              'I',     # privLength
                              b'wOFF',
                              sfnt_version,
                              total_size,
                              num_tables,
                              0,       # reserved
                              12 + num_tables * 16 + sum(((len(t[2]) + 3) & ~3) for t in tables),
                              1, 0,
                              0, 0, 0,
                              0, 0)

    return woff_header + woff_dir + woff_table_data


# ---------------------------------------------------------------------------
# Generate minimal.ttc
# ---------------------------------------------------------------------------

def generate_ttc(ttf_data: bytes) -> bytes:
    """Create a TTC with 2 faces, both pointing to the same table directory."""
    # TTC header: 'ttcf', version 1.0, numFonts=2, offsets
    ttc_header_size = 12 + 2 * 4  # tag + version + numFonts + 2 offsets = 20 bytes

    # Both faces point to the same offset (right after TTC header)
    face_offset = ttc_header_size

    header = struct.pack('>4sIIII',
                         b'ttcf',
                         0x00010000,  # version 1.0
                         2,           # numFonts
                         face_offset,
                         face_offset)

    # We need to adjust all offsets in the TTF table directory
    # Parse original TTF
    num_tables = struct.unpack('>H', ttf_data[4:6])[0]

    # Rebuild the SFNT with adjusted offsets
    # The table data starts after the TTC header + SFNT header + table directory
    sfnt_header_size = 12 + num_tables * 16

    # Read original tables
    tables_info = []
    for i in range(num_tables):
        rec_off = 12 + i * 16
        tag = ttf_data[rec_off:rec_off+4]
        checksum, tbl_offset, tbl_length = struct.unpack('>III', ttf_data[rec_off+4:rec_off+16])
        raw = ttf_data[tbl_offset:tbl_offset+tbl_length]
        tables_info.append((tag, checksum, raw))

    # Build new SFNT with offsets shifted by ttc_header_size
    new_data_start = face_offset + sfnt_header_size
    new_sfnt_header = ttf_data[0:12]  # copy sfnt version, numTables etc.

    new_dir = b''
    new_table_data = b''
    current_offset = new_data_start
    head_abs_offset = None

    for tag, checksum, raw in tables_info:
        if tag == b'head':
            head_abs_offset = current_offset
        new_dir += struct.pack('>4sIII', tag, checksum, current_offset, len(raw))
        new_table_data += pad4(raw)
        current_offset += len(pad4(raw))

    result = header + new_sfnt_header + new_dir + new_table_data

    # Patch checksumAdjustment in head table
    if head_abs_offset is not None:
        adj = calc_head_checksum_adjustment(result)
        result = result[:head_abs_offset + 8] + struct.pack('>I', adj) + result[head_abs_offset + 12:]

    return result


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    os.makedirs(SCRIPT_DIR, exist_ok=True)

    # TTF
    print("Generating minimal.ttf...")
    ttf_data = generate_ttf()
    ttf_path = os.path.join(SCRIPT_DIR, 'minimal.ttf')
    with open(ttf_path, 'wb') as f:
        f.write(ttf_data)
    print(f"  Written {len(ttf_data)} bytes to {ttf_path}")

    print("Generating minimal_sbix.ttf...")
    sbix_data = generate_sbix_ttf()
    sbix_path = os.path.join(SCRIPT_DIR, 'minimal_sbix.ttf')
    with open(sbix_path, 'wb') as f:
      f.write(sbix_data)
    print(f"  Written {len(sbix_data)} bytes to {sbix_path}")

    print("Generating minimal_cbdt.ttf...")
    cbdt_data = generate_cbdt_ttf()
    cbdt_path = os.path.join(SCRIPT_DIR, 'minimal_cbdt.ttf')
    with open(cbdt_path, 'wb') as f:
        f.write(cbdt_data)
    print(f"  Written {len(cbdt_data)} bytes to {cbdt_path}")

    print("Generating minimal_cbdt_all.ttf...")
    cbdt_all_data = generate_cbdt_all_ttf()
    cbdt_all_path = os.path.join(SCRIPT_DIR, 'minimal_cbdt_all.ttf')
    with open(cbdt_all_path, 'wb') as f:
        f.write(cbdt_all_data)
    print(f"  Written {len(cbdt_all_data)} bytes to {cbdt_all_path}")

    print("Generating minimal_colr_v0.ttf...")
    colr_v0_data = generate_colr_v0_ttf()
    colr_v0_path = os.path.join(SCRIPT_DIR, 'minimal_colr_v0.ttf')
    with open(colr_v0_path, 'wb') as f:
        f.write(colr_v0_data)
    print(f"  Written {len(colr_v0_data)} bytes to {colr_v0_path}")

    print("Generating minimal_colr_v1.ttf...")
    colr_v1_data = generate_colr_v1_ttf()
    colr_v1_path = os.path.join(SCRIPT_DIR, 'minimal_colr_v1.ttf')
    with open(colr_v1_path, 'wb') as f:
        f.write(colr_v1_data)
    print(f"  Written {len(colr_v1_data)} bytes to {colr_v1_path}")

    print("Generating minimal_colr_v1_gradients.ttf...")
    colr_v1_gradients_data = generate_colr_v1_gradients_ttf()
    colr_v1_gradients_path = os.path.join(SCRIPT_DIR, 'minimal_colr_v1_gradients.ttf')
    with open(colr_v1_gradients_path, 'wb') as f:
        f.write(colr_v1_gradients_data)
    print(f"  Written {len(colr_v1_gradients_data)} bytes to {colr_v1_gradients_path}")

    print("Generating minimal_colr_v1_var.ttf...")
    colr_v1_var_data = generate_colr_v1_var_ttf()
    colr_v1_var_path = os.path.join(SCRIPT_DIR, 'minimal_colr_v1_var.ttf')
    with open(colr_v1_var_path, 'wb') as f:
        f.write(colr_v1_var_data)
    print(f"  Written {len(colr_v1_var_data)} bytes to {colr_v1_var_path}")

    # MVAR TTF
    print("Generating mvar.ttf...")
    mvar_data = generate_mvar_ttf()
    mvar_path = os.path.join(SCRIPT_DIR, 'mvar.ttf')
    with open(mvar_path, 'wb') as f:
        f.write(mvar_data)
    print(f"  Written {len(mvar_data)} bytes to {mvar_path}")

    # UVS TTF
    print("Generating uvs.ttf...")
    uvs_data = generate_uvs_ttf()
    uvs_path = os.path.join(SCRIPT_DIR, 'uvs.ttf')
    with open(uvs_path, 'wb') as f:
        f.write(uvs_data)
    print(f"  Written {len(uvs_data)} bytes to {uvs_path}")

    # OTF
    print("Generating minimal.otf...")
    otf_data = generate_otf()
    otf_path = os.path.join(SCRIPT_DIR, 'minimal.otf')
    with open(otf_path, 'wb') as f:
        f.write(otf_data)
    print(f"  Written {len(otf_data)} bytes to {otf_path}")

    # BDF
    print("Generating minimal.bdf...")
    bdf_path = os.path.join(SCRIPT_DIR, 'minimal.bdf')
    with open(bdf_path, 'w', newline='\n') as f:
        f.write(generate_bdf())
    print(f"  Written to {bdf_path}")

    # PFB
    print("Generating minimal.pfb...")
    pfb_data = generate_pfb()
    pfb_path = os.path.join(SCRIPT_DIR, 'minimal.pfb')
    with open(pfb_path, 'wb') as f:
        f.write(pfb_data)
    print(f"  Written {len(pfb_data)} bytes to {pfb_path}")

    # WOFF
    print("Generating minimal.woff...")
    woff_data = generate_woff(ttf_data)
    woff_path = os.path.join(SCRIPT_DIR, 'minimal.woff')
    with open(woff_path, 'wb') as f:
        f.write(woff_data)
    print(f"  Written {len(woff_data)} bytes to {woff_path}")

    # TTC
    print("Generating minimal.ttc...")
    ttc_data = generate_ttc(ttf_data)
    ttc_path = os.path.join(SCRIPT_DIR, 'minimal.ttc')
    with open(ttc_path, 'wb') as f:
        f.write(ttc_data)
    print(f"  Written {len(ttc_data)} bytes to {ttc_path}")

    # PCF note
    print("\nNote: minimal.pcf is not generated. Use 'bdftopcf minimal.bdf > minimal.pcf' if needed.")

    print("\nAll fonts generated successfully!")


if __name__ == '__main__':
    main()
