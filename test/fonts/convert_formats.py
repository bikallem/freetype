#!/usr/bin/env python3
"""
Convert alternate container formats for parity testing.

Produces:
  DejaVuSans.woff  — real WOFF1 wrapping DejaVuSans.ttf (6253 glyphs)
  DejaVuSans.ttc   — real TTC containing DejaVuSans.ttf as 2 faces
  minimal_collection.woff2 — synthetic WOFF2 collection wrapping minimal.ttc

These are genuine production font data in alternate container formats,
except for the small WOFF2 collection fixture used for decoder coverage.
"""

import struct, zlib, os, sys
try:
    import brotli
except ImportError:
    brotli = None

FONT_DIR = os.path.dirname(os.path.abspath(__file__))

KNOWN_WOFF2_TAGS = [
    b'cmap', b'head', b'hhea', b'hmtx', b'maxp', b'name', b'OS/2', b'post',
    b'cvt ', b'fpgm', b'glyf', b'loca', b'prep', b'CFF ', b'VORG', b'EBDT',
    b'EBLC', b'gasp', b'hdmx', b'kern', b'LTSH', b'PCLT', b'VDMX', b'vhea',
    b'vmtx', b'BASE', b'GDEF', b'GPOS', b'GSUB', b'EBSC', b'JSTF', b'MATH',
    b'CBDT', b'CBLC', b'COLR', b'CPAL', b'SVG ', b'sbix', b'acnt', b'avar',
    b'bdat', b'bloc', b'bsln', b'cvar', b'fdsc', b'feat', b'fmtx', b'fvar',
    b'gvar', b'hsty', b'just', b'lcar', b'mort', b'morx', b'opbd', b'prop',
    b'trak', b'Zapf', b'Silf', b'Glat', b'Gloc', b'Feat', b'Sill',
]
WOFF2_TAG_INDEX = {tag: i for i, tag in enumerate(KNOWN_WOFF2_TAGS)}


def read_font(name):
    path = os.path.join(FONT_DIR, name)
    if not os.path.exists(path):
        return None
    with open(path, "rb") as f:
        return f.read()


def parse_sfnt_tables(data):
    """Parse SFNT table directory, return list of (tag, offset, length, checksum)."""
    _, num_tables = struct.unpack_from(">IH", data, 0)
    tables = []
    for i in range(num_tables):
        off = 12 + i * 16
        tag, checksum, toff, tlen = struct.unpack_from(">4sIII", data, off)
        tables.append((tag, toff, tlen, checksum))
    return tables


def encode_base128(value):
    parts = [value & 0x7F]
    value >>= 7
    while value:
        parts.append(0x80 | (value & 0x7F))
        value >>= 7
    return bytes(reversed(parts))


def encode_255ushort(value):
    if value < 253:
        return bytes([value])
    if value < 506:
        return bytes([255, value - 253])
    if value < 759:
        return bytes([254, value - 506])
    return bytes([253]) + struct.pack(">H", value)


def parse_ttc_fonts(data):
    if data[:4] != b"ttcf":
        raise ValueError("not a TTC")
    version, num_fonts = struct.unpack_from(">II", data, 4)
    offsets = struct.unpack_from(f">{num_fonts}I", data, 12)
    fonts = []
    for offset in offsets:
        sfnt_version, num_tables = struct.unpack_from(">IH", data, offset)
        tables = []
        for i in range(num_tables):
            off = offset + 12 + i * 16
            tag, checksum, table_offset, length = struct.unpack_from(">4sIII", data, off)
            tables.append((tag, table_offset, length, checksum))
        fonts.append((sfnt_version, tables))
    return version, fonts


def reorder_tables_for_woff2_collection(tables):
    ordered = []
    pending_loca = None
    for table in tables:
        if table[0] == b"loca":
            pending_loca = table
            continue
        ordered.append(table)
        if table[0] == b"glyf" and pending_loca is not None:
            ordered.append(pending_loca)
            pending_loca = None
    if pending_loca is not None:
        ordered.append(pending_loca)
    return ordered


def build_woff2_collection(ttc_data):
    if brotli is None:
        raise RuntimeError("brotli module is required")
    version, fonts = parse_ttc_fonts(ttc_data)
    entries = []
    index_by_offset = {}
    collection_fonts = []
    for sfnt_version, tables in fonts:
        ordered_tables = reorder_tables_for_woff2_collection(tables)
        indices = []
        for tag, offset, length, checksum in ordered_tables:
            if offset not in index_by_offset:
                index_by_offset[offset] = len(entries)
                entries.append((tag, checksum, ttc_data[offset:offset + length]))
            indices.append(index_by_offset[offset])
        collection_fonts.append((sfnt_version, indices))

    raw_stream = b"".join(table for _, _, table in entries)
    compressed = brotli.compress(raw_stream, quality=11, mode=brotli.MODE_FONT)

    table_directory = bytearray()
    for tag, _, table in entries:
        if tag in (b"glyf", b"loca"):
            flag = 0xC0 | WOFF2_TAG_INDEX[tag]
        else:
            flag = WOFF2_TAG_INDEX.get(tag, 0x3F)
        table_directory.append(flag)
        if (flag & 0x3F) == 0x3F:
            table_directory += tag
        table_directory += encode_base128(len(table))

    collection_directory = bytearray()
    collection_directory += struct.pack(">I", version)
    collection_directory += encode_255ushort(len(collection_fonts))
    for sfnt_version, indices in collection_fonts:
        collection_directory += encode_255ushort(len(indices))
        collection_directory += struct.pack(">I", sfnt_version)
        for index in indices:
            collection_directory += encode_255ushort(index)

    length = 48 + len(table_directory) + len(collection_directory) + len(compressed)
    header = struct.pack(
        ">IIIHHIIHHIIIII",
        0x774F4632,  # wOF2
        0x74746366,  # ttcf
        length,
        len(entries),
        0,
        len(ttc_data),
        len(compressed),
        1,
        0,
        0, 0, 0,
        0, 0,
    )
    return header + table_directory + collection_directory + compressed


def build_woff(sfnt_data):
    """Wrap an SFNT font as WOFF1 (zlib-compressed tables)."""
    sfnt_version = struct.unpack_from(">I", sfnt_data, 0)[0]
    num_tables = struct.unpack_from(">H", sfnt_data, 4)[0]
    tables = parse_sfnt_tables(sfnt_data)

    # WOFF header: 44 bytes
    # WOFF table dir: 20 bytes per table
    woff_dir_offset = 44
    woff_data_offset = woff_dir_offset + num_tables * 20

    # Sort tables by tag (FreeType requires sorted WOFF directory)
    tables.sort(key=lambda t: t[0])

    # Compress each table
    compressed_tables = []
    for tag, toff, tlen, checksum in tables:
        raw = sfnt_data[toff:toff + tlen]
        compressed = zlib.compress(raw)
        # Only use compressed if smaller
        if len(compressed) < len(raw):
            compressed_tables.append((tag, compressed, len(raw), checksum, True))
        else:
            compressed_tables.append((tag, raw, len(raw), checksum, False))

    # Build WOFF file — table data must be sequential (FreeType validates offsets)
    parts = []
    table_entries = []
    current_offset = woff_data_offset
    for tag, data, orig_len, checksum, is_compressed in compressed_tables:
        table_entries.append((tag, current_offset, len(data), orig_len, checksum))
        parts.append(data)
        current_offset += len(data)
        # Pad to 4-byte boundary
        padding = (4 - (current_offset % 4)) % 4
        if padding:
            parts.append(b'\x00' * padding)
            current_offset += padding

    total_length = current_offset
    total_sfnt_size = 12 + num_tables * 16
    for _, _, orig_len, _, _ in compressed_tables:
        total_sfnt_size += (orig_len + 3) & ~3

    # Write WOFF header
    woff = bytearray()
    woff += struct.pack(">I", 0x774F4646)  # 'wOFF'
    woff += struct.pack(">I", sfnt_version)  # flavor
    woff += struct.pack(">I", total_length)  # length
    woff += struct.pack(">H", num_tables)  # numTables
    woff += struct.pack(">H", 0)  # reserved
    woff += struct.pack(">I", total_sfnt_size)  # totalSfntSize
    woff += struct.pack(">HH", 1, 0)  # majorVersion, minorVersion
    woff += struct.pack(">III", 0, 0, 0)  # meta offset/length/origLength
    woff += struct.pack(">II", 0, 0)  # priv offset/length

    # Write table directory
    for tag, offset, comp_len, orig_len, checksum in table_entries:
        woff += struct.pack(">4sIIII", tag, offset, comp_len, orig_len, checksum)

    # Write table data
    for part in parts:
        woff += part

    return bytes(woff)


def build_ttc(fonts):
    """Build a TTC from a list of SFNT font data blobs."""
    num_fonts = len(fonts)
    # TTC header: 12 bytes + 4 bytes per font offset
    header_size = 12 + num_fonts * 4

    # Each font's table directory is placed sequentially after the header.
    # Table data follows all directories.
    # For simplicity, we don't share tables between fonts.

    # First pass: calculate layout
    font_dirs = []
    all_tables = []
    dir_offset = header_size
    for font_data in fonts:
        sfnt_version = struct.unpack_from(">I", font_data, 0)[0]
        num_tables = struct.unpack_from(">H", font_data, 4)[0]
        tables = parse_sfnt_tables(font_data)
        font_dirs.append((dir_offset, sfnt_version, num_tables, tables))
        dir_offset += 12 + num_tables * 16
        for tag, toff, tlen, checksum in tables:
            all_tables.append((font_data, tag, toff, tlen, checksum))

    # Second pass: place table data after all directories
    data_offset = dir_offset
    table_placements = {}  # (font_idx, table_idx) -> new_offset
    table_data_parts = []
    for fi, (_, _, _, tables) in enumerate(font_dirs):
        for ti, (tag, toff, tlen, checksum) in enumerate(tables):
            # Align to 4 bytes
            padding = (4 - (data_offset % 4)) % 4
            data_offset += padding
            table_data_parts.append(b'\x00' * padding)

            table_placements[(fi, ti)] = data_offset
            table_data_parts.append(fonts[fi][toff:toff + tlen])
            data_offset += tlen

    # Build TTC
    ttc = bytearray()
    # TTC header
    ttc += struct.pack(">4sI", b'ttcf', 0x00010000)  # tag, version 1.0
    ttc += struct.pack(">I", num_fonts)
    # Font offsets
    for dir_off, _, _, _ in font_dirs:
        ttc += struct.pack(">I", dir_off)

    # Font table directories
    for fi, (_, sfnt_version, num_tables, tables) in enumerate(font_dirs):
        # Compute searchRange etc.
        sr, es = 1, 0
        while sr * 2 <= num_tables:
            sr *= 2
            es += 1
        sr *= 16
        rs = num_tables * 16 - sr

        ttc += struct.pack(">I", sfnt_version)
        ttc += struct.pack(">HHH H", num_tables, sr, es, rs)
        for ti, (tag, _, tlen, checksum) in enumerate(tables):
            new_offset = table_placements[(fi, ti)]
            ttc += struct.pack(">4sIII", tag, checksum, new_offset, tlen)

    # Table data
    for part in table_data_parts:
        ttc += part

    return bytes(ttc)


def main():
    # === WOFF from DejaVuSans.ttf ===
    dejavu = read_font("DejaVuSans.ttf")
    if dejavu:
        woff_path = os.path.join(FONT_DIR, "DejaVuSans.woff")
        if os.path.exists(woff_path):
            print(f"  [skip] DejaVuSans.woff")
        else:
            woff = build_woff(dejavu)
            with open(woff_path, "wb") as f:
                f.write(woff)
            print(f"  [created] DejaVuSans.woff ({len(woff):,} bytes from {len(dejavu):,} byte TTF)")
    else:
        print("  [skip] DejaVuSans.woff (DejaVuSans.ttf not found)")

    # === TTC from DejaVuSans.ttf (2 faces of same font) ===
    if dejavu:
        ttc_path = os.path.join(FONT_DIR, "DejaVuSans.ttc")
        if os.path.exists(ttc_path):
            print(f"  [skip] DejaVuSans.ttc")
        else:
            ttc = build_ttc([dejavu, dejavu])
            with open(ttc_path, "wb") as f:
                f.write(ttc)
            print(f"  [created] DejaVuSans.ttc ({len(ttc):,} bytes, 2 faces)")
    else:
        print("  [skip] DejaVuSans.ttc (DejaVuSans.ttf not found)")

    # === WOFF from SourceCodePro ===
    scp = read_font("SourceCodePro-Regular.otf")
    if scp:
        woff_path = os.path.join(FONT_DIR, "SourceCodePro-Regular.woff")
        if os.path.exists(woff_path):
            print(f"  [skip] SourceCodePro-Regular.woff")
        else:
            woff = build_woff(scp)
            with open(woff_path, "wb") as f:
                f.write(woff)
            print(f"  [created] SourceCodePro-Regular.woff ({len(woff):,} bytes from {len(scp):,} byte OTF)")
    else:
        print("  [skip] SourceCodePro-Regular.woff (SourceCodePro-Regular.otf not found)")

    # === WOFF2 collection from minimal.ttc ===
    minimal_ttc = read_font("minimal.ttc")
    if brotli is None:
        print("  [skip] minimal_collection.woff2 (python brotli module not available)")
    elif minimal_ttc:
        woff2_path = os.path.join(FONT_DIR, "minimal_collection.woff2")
        if os.path.exists(woff2_path):
            print("  [skip] minimal_collection.woff2")
        else:
            woff2 = build_woff2_collection(minimal_ttc)
            with open(woff2_path, "wb") as f:
                f.write(woff2)
            print(f"  [created] minimal_collection.woff2 ({len(woff2):,} bytes from {len(minimal_ttc):,} byte TTC)")
    else:
        print("  [skip] minimal_collection.woff2 (minimal.ttc not found)")


if __name__ == "__main__":
    main()
