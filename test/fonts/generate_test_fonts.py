#!/usr/bin/env python3
"""
generate_test_fonts.py — Generate minimal synthetic test fonts for FreeType testing.

Generates:
  minimal.ttf  — Minimal TrueType font (3 glyphs: .notdef, space, A)
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


def build_hmtx_table() -> bytes:
    """Build hmtx for 3 glyphs. Each has advanceWidth and lsb."""
    # .notdef: advance=500, lsb=0
    # space: advance=250, lsb=0
    # A: advance=500, lsb=50
    data = struct.pack('>Hh', 500, 0)   # .notdef
    data += struct.pack('>Hh', 250, 0)  # space
    data += struct.pack('>Hh', 500, 50) # A
    return data


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
