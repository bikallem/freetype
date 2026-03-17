#!/usr/bin/env python3
"""
Convert real-world fonts to WOFF1 and TTC formats for parity testing.

Produces:
  DejaVuSans.woff  — real WOFF1 wrapping DejaVuSans.ttf (6253 glyphs)
  DejaVuSans.ttc   — real TTC containing DejaVuSans.ttf as 2 faces

These are genuine production font data in alternate container formats,
not synthetic minimal fonts.
"""

import struct, zlib, os, sys

FONT_DIR = os.path.dirname(os.path.abspath(__file__))


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


if __name__ == "__main__":
    main()
