///|
/// WOFF2 known table tags (indices 0-62) per the spec.
/// See https://www.w3.org/TR/WOFF2/#table_dir_format
let woff2_known_tags : FixedArray[UInt] = [
  0x636D6170U, // 0  cmap
   0x68656164U, // 1  head
   0x68686561U, // 2  hhea
   0x686D7478U, // 3  hmtx
   0x6D617870U, // 4  maxp
   0x6E616D65U, // 5  name
   0x4F532F32U, // 6  OS/2
   0x706F7374U, // 7  post
   0x63767420U, // 8  cvt
   0x6670676DU, // 9  fpgm
   0x676C7966U, // 10 glyf
   0x6C6F6361U, // 11 loca
   0x70726570U, // 12 prep
   0x43464620U, // 13 CFF
   0x564F5247U, // 14 VORG
   0x45424454U, // 15 EBDT
   0x45424C43U, // 16 EBLC
   0x67617370U, // 17 gasp
   0x68646D78U, // 18 hdmx
   0x6B65726EU, // 19 kern
   0x4C545348U, // 20 LTSH
   0x50434C54U, // 21 PCLT
   0x56444D58U, // 22 VDMX
   0x76686561U, // 23 vhea
   0x766D7478U, // 24 vmtx
   0x42415345U, // 25 BASE
   0x47444546U, // 26 GDEF
   0x47504F53U, // 27 GPOS
   0x47535542U, // 28 GSUB
   0x45425343U, // 29 EBSC
   0x4A535446U, // 30 JSTF
   0x4D415448U, // 31 MATH
   0x43424454U, // 32 CBDT
   0x43424C43U, // 33 CBLC
   0x434F4C52U, // 34 COLR
   0x4350414CU, // 35 CPAL
   0x53564720U, // 36 SVG
   0x73626978U, // 37 sbix
   0x61636E74U, // 38 acnt
   0x61766172U, // 39 avar
   0x62646174U, // 40 bdat
   0x626C6F63U, // 41 bloc
   0x62736C6EU, // 42 bsln
   0x63766172U, // 43 cvar
   0x66647363U, // 44 fdsc
   0x66656174U, // 45 feat
   0x666D7478U, // 46 fmtx
   0x66766172U, // 47 fvar
   0x67766172U, // 48 gvar
   0x68737479U, // 49 hsty
   0x6A757374U, // 50 just
   0x6C636172U, // 51 lcar
   0x6D6F7274U, // 52 mort
   0x6D6F7278U, // 53 morx
   0x6F706264U, // 54 opbd
   0x70726F70U, // 55 prop
   0x7472616BU, // 56 trak
   0x5A617066U, // 57 Zapf
   0x53696C66U, // 58 Silf
   0x476C6174U, // 59 Glat
   0x476C6F63U, // 60 Gloc
   0x46656174U, // 61 Feat
   0x53696C6CU, // 62 Sill
]

///|
priv struct Woff2TableEntry {
  tag : UInt
  flags : UInt
  orig_length : UInt
  transform_length : UInt
  /// Offset within the uncompressed stream where this table's data starts
  src_offset : Int
}

///|
priv struct Woff2FontEntry {
  flavor : UInt
  table_indices : Array[Int]
}

///|
fn sorted_font_table_indices(
  font : Woff2FontEntry,
  entries : Array[Woff2TableEntry],
) -> Array[Int] {
  let indices : Array[Int] = Array::new(capacity=font.table_indices.length())
  for _, index in font.table_indices {
    indices.push(index)
  }
  indices.sort_by(fn(a, b) { entries[a].tag.compare(entries[b].tag) })
  indices
}

///|
fn find_font_table_index(
  font : Woff2FontEntry,
  entries : Array[Woff2TableEntry],
  tag : UInt,
) -> Int {
  for _, index in font.table_indices {
    if index >= 0 && index < entries.length() && entries[index].tag == tag {
      return index
    }
  }
  -1
}

///|
fn read_collection_directory(
  reader : @stream.ByteReader,
  num_tables : Int,
) -> (UInt, Array[Woff2FontEntry]) raise @error.FTError {
  let version = reader.read_u32_be()
  let num_fonts = read_255ushort(reader).reinterpret_as_int()
  let fonts : Array[Woff2FontEntry] = Array::new(capacity=num_fonts)
  for _ in 0..<num_fonts {
    let font_num_tables = read_255ushort(reader).reinterpret_as_int()
    let flavor = reader.read_u32_be()
    let table_indices : Array[Int] = Array::new(capacity=font_num_tables)
    for _ in 0..<font_num_tables {
      let index = read_255ushort(reader).reinterpret_as_int()
      if index < 0 || index >= num_tables {
        raise @error.FTError::InvalidTable
      }
      table_indices.push(index)
    }
    fonts.push({ flavor, table_indices })
  }
  (version, fonts)
}

///|
fn make_single_font_entries(
  flavor : UInt,
  num_tables : Int,
) -> Array[Woff2FontEntry] {
  let table_indices : Array[Int] = Array::new(capacity=num_tables)
  for i in 0..<num_tables {
    table_indices.push(i)
  }
  [{ flavor, table_indices }]
}

///|
fn read_u16_be_from_bytes(data : Bytes, offset : Int) -> Int {
  data.unsafe_read_uint16_be(offset).to_int()
}

///|
fn read_i16_be_from_bytes(data : Bytes, offset : Int) -> Int {
  let value = read_u16_be_from_bytes(data, offset)
  if value >= 0x8000 {
    value - 0x10000
  } else {
    value
  }
}

///|
fn read_u32_be_from_bytes(data : Bytes, offset : Int) -> UInt {
  data.unsafe_read_uint32_be(offset)
}

///|
fn woff2_table_bytes(
  uncompressed : Bytes,
  entry : Woff2TableEntry,
) -> Bytes raise @error.FTError {
  let start = entry.src_offset
  let length = entry.transform_length.reinterpret_as_int()
  if start < 0 || start + length > uncompressed.length() {
    raise @error.FTError::InvalidTable
  }
  uncompressed[start:start + length].to_bytes()
}

///|
fn loca_glyph_offset(
  loca_data : Bytes,
  index_format : Int,
  glyph_index : Int,
) -> Int raise @error.FTError {
  if index_format != 0 {
    let offset = glyph_index * 4
    if offset + 4 > loca_data.length() {
      raise @error.FTError::InvalidTable
    }
    read_u32_be_from_bytes(loca_data, offset).reinterpret_as_int()
  } else {
    let offset = glyph_index * 2
    if offset + 2 > loca_data.length() {
      raise @error.FTError::InvalidTable
    }
    read_u16_be_from_bytes(loca_data, offset) << 1
  }
}

///|
fn collect_glyf_x_mins(
  glyf_data : Bytes,
  loca_data : Bytes,
  index_format : Int,
  num_glyphs : Int,
) -> Array[Int] raise @error.FTError {
  let x_mins : Array[Int] = Array::new(capacity=num_glyphs)
  for glyph_index in 0..<num_glyphs {
    let offset = loca_glyph_offset(loca_data, index_format, glyph_index)
    let next_offset = loca_glyph_offset(
      loca_data,
      index_format,
      glyph_index + 1,
    )
    if next_offset < offset || next_offset > glyf_data.length() {
      raise @error.FTError::InvalidTable
    }
    if offset == next_offset {
      x_mins.push(0)
    } else {
      if offset + 4 > glyf_data.length() {
        raise @error.FTError::InvalidTable
      }
      x_mins.push(read_i16_be_from_bytes(glyf_data, offset + 2))
    }
  }
  x_mins
}

///|
fn reconstruct_hmtx_table(
  transformed_hmtx : Bytes,
  num_glyphs : Int,
  num_hmetrics : Int,
  x_mins : Array[Int],
) -> Bytes raise @error.FTError {
  if num_hmetrics < 1 ||
    num_hmetrics > num_glyphs ||
    x_mins.length() < num_glyphs {
    raise @error.FTError::InvalidTable
  }
  let reader = @stream.ByteReader::new(transformed_hmtx)
  let hmtx_flags = reader.read_byte().to_int()
  let has_proportional_lsbs = (hmtx_flags & 1) == 0
  let has_monospace_lsbs = (hmtx_flags & 2) == 0
  if (hmtx_flags & 0xFC) != 0 || (has_proportional_lsbs && has_monospace_lsbs) {
    raise @error.FTError::InvalidTable
  }
  let advance_widths : Array[UInt] = Array::new(capacity=num_hmetrics)
  let lsbs : Array[Int] = Array::make(num_glyphs, 0)
  for _ in 0..<num_hmetrics {
    advance_widths.push(reader.read_u16_be())
  }
  for i in 0..<num_hmetrics {
    lsbs[i] = if has_proportional_lsbs {
      reader.read_i16_be()
    } else {
      x_mins[i]
    }
  }
  for i in num_hmetrics..<num_glyphs {
    lsbs[i] = if has_monospace_lsbs { reader.read_i16_be() } else { x_mins[i] }
  }
  let hmtx = FixedArray::make(2 * num_hmetrics + 2 * num_glyphs, b'\x00')
  let mut offset = 0
  for i in 0..<num_glyphs {
    if i < num_hmetrics {
      write_u16_be(hmtx, offset, advance_widths[i])
      offset += 2
    }
    write_i16_be(hmtx, offset, lsbs[i])
    offset += 2
  }
  Bytes::from_array(hmtx[:])
}

///|
fn reconstruct_transformed_hmtx(
  hmtx_entry : Woff2TableEntry,
  uncompressed : Bytes,
  maxp : Bytes,
  hhea : Bytes,
  glyf_data : Bytes,
  loca_data : Bytes,
) -> Bytes raise @error.FTError {
  if (hmtx_entry.flags & 0x100U) == 0U {
    raise @error.FTError::InvalidTable
  }
  if maxp.length() < 6 || hhea.length() < 36 {
    raise @error.FTError::InvalidTable
  }
  let num_glyphs = read_u16_be_from_bytes(maxp, 4)
  let num_hmetrics = read_u16_be_from_bytes(hhea, 34)
  let expected_long = (num_glyphs + 1) * 4
  let index_format = if loca_data.length() == expected_long { 1 } else { 0 }
  let x_mins = collect_glyf_x_mins(
    glyf_data, loca_data, index_format, num_glyphs,
  )
  let transformed = woff2_table_bytes(uncompressed, hmtx_entry)
  reconstruct_hmtx_table(transformed, num_glyphs, num_hmetrics, x_mins)
}

///|
/// Read a WOFF2 UIntBase128 value.
fn read_base128(reader : @stream.ByteReader) -> UInt raise @error.FTError {
  let mut result = 0U
  for i in 0..<5 {
    let code = reader.read_byte()
    if i == 0 && code == 0x80 {
      raise @error.FTError::InvalidTable
    }
    if (result & 0xFE000000U) != 0U {
      raise @error.FTError::InvalidTable
    }
    result = (result << 7) | (code.to_uint() & 0x7FU)
    if (code.to_uint() & 0x80U) == 0U {
      return result
    }
  }
  raise @error.FTError::InvalidTable
}

///|
/// Read a WOFF2 255UShort value.
fn read_255ushort(reader : @stream.ByteReader) -> UInt raise @error.FTError {
  let code = reader.read_byte().to_uint()
  if code == 253U {
    reader.read_u16_be()
  } else if code == 255U {
    reader.read_byte().to_uint() + 253U
  } else if code == 254U {
    reader.read_byte().to_uint() + 506U
  } else {
    code
  }
}

///|
/// Compute checksum of a byte range.
fn compute_checksum(data : Bytes, offset : Int, length : Int) -> UInt {
  let mut checksum = 0U
  let aligned = length & -4
  let mut k = 0
  while k < aligned {
    let c = (data[offset + k].to_uint() << 24) |
      (data[offset + k + 1].to_uint() << 16) |
      (data[offset + k + 2].to_uint() << 8) |
      data[offset + k + 3].to_uint()
    checksum = checksum + c
    k += 4
  }
  let mut shift = 24
  while k < length {
    checksum = checksum + (data[offset + k].to_uint() << shift)
    k += 1
    shift -= 8
  }
  checksum
}

///|
fn compute_search_params(num_tables : Int) -> (Int, Int, Int) {
  let (sr, es) = for sr = 1, es = 0; sr * 2 <= num_tables; {
    continue sr * 2, es + 1
  } nobreak {
    (sr * 16, es)
  }
  (sr, es, num_tables * 16 - sr)
}

///|
fn build_sfnt_font(
  font : Woff2FontEntry,
  entries : Array[Woff2TableEntry],
  resolved_tables : Array[Bytes],
) -> Bytes {
  let indices = sorted_font_table_indices(font, entries)
  let num_tables = indices.length()
  let sfnt_header_size = 12 + num_tables * 16
  let table_offsets : Array[Int] = Array::new(capacity=num_tables)
  let mut dest_offset = sfnt_header_size
  for _, entry_index in indices {
    dest_offset = (dest_offset + 3) & -4
    table_offsets.push(dest_offset)
    dest_offset += resolved_tables[entry_index].length()
  }
  let total_size = (dest_offset + 3) & -4
  let sfnt = FixedArray::make(total_size, b'\x00')
  write_u32_be(sfnt, 0, font.flavor)
  write_u16_be(sfnt, 4, num_tables.reinterpret_as_uint())
  let (search_range, entry_selector, range_shift) = compute_search_params(
    num_tables,
  )
  write_u16_be(sfnt, 6, search_range.reinterpret_as_uint())
  write_u16_be(sfnt, 8, entry_selector.reinterpret_as_uint())
  write_u16_be(sfnt, 10, range_shift.reinterpret_as_uint())
  for i, entry_index in indices {
    let table_offset = table_offsets[i]
    let table_data = resolved_tables[entry_index]
    for j in 0..<table_data.length() {
      sfnt[table_offset + j] = table_data[j]
    }
    let checksum = compute_checksum(table_data, 0, table_data.length())
    let rec_offset = 12 + i * 16
    write_u32_be(sfnt, rec_offset, entries[entry_index].tag)
    write_u32_be(sfnt, rec_offset + 4, checksum)
    write_u32_be(sfnt, rec_offset + 8, table_offset.reinterpret_as_uint())
    write_u32_be(
      sfnt,
      rec_offset + 12,
      table_data.length().reinterpret_as_uint(),
    )
  }
  Bytes::from_array(sfnt[:])
}

///|
fn build_ttc_font_collection(
  version : UInt,
  fonts : Array[Woff2FontEntry],
  entries : Array[Woff2TableEntry],
  resolved_tables : Array[Bytes],
) -> Bytes {
  let num_fonts = fonts.length()
  let ttc_version = if version == 0U { 0x00010000U } else { version }
  let header_size = if ttc_version == 0x00020000U {
    24 + num_fonts * 4
  } else {
    12 + num_fonts * 4
  }
  let sorted_indices : Array[Array[Int]] = Array::new(capacity=num_fonts)
  let font_offsets : Array[Int] = Array::new(capacity=num_fonts)
  let mut dir_offset = header_size
  for _, font in fonts {
    let indices = sorted_font_table_indices(font, entries)
    sorted_indices.push(indices)
    font_offsets.push(dir_offset)
    dir_offset += 12 + indices.length() * 16
  }
  let table_offsets : Array[Int] = Array::make(entries.length(), -1)
  let mut data_offset = dir_offset
  for i, _ in entries {
    data_offset = (data_offset + 3) & -4
    table_offsets[i] = data_offset
    data_offset += resolved_tables[i].length()
  }
  let total_size = (data_offset + 3) & -4
  let ttc = FixedArray::make(total_size, b'\x00')
  write_u32_be(ttc, 0, @types.TAG_TTCF)
  write_u32_be(ttc, 4, ttc_version)
  write_u32_be(ttc, 8, num_fonts.reinterpret_as_uint())
  for i, font_offset in font_offsets {
    write_u32_be(ttc, 12 + i * 4, font_offset.reinterpret_as_uint())
  }
  if ttc_version == 0x00020000U {
    let dsig_offset = 12 + num_fonts * 4
    write_u32_be(ttc, dsig_offset, 0U)
    write_u32_be(ttc, dsig_offset + 4, 0U)
    write_u32_be(ttc, dsig_offset + 8, 0U)
  }
  for font_index, font in fonts {
    let indices = sorted_indices[font_index]
    let base = font_offsets[font_index]
    let num_tables = indices.length()
    let (search_range, entry_selector, range_shift) = compute_search_params(
      num_tables,
    )
    write_u32_be(ttc, base, font.flavor)
    write_u16_be(ttc, base + 4, num_tables.reinterpret_as_uint())
    write_u16_be(ttc, base + 6, search_range.reinterpret_as_uint())
    write_u16_be(ttc, base + 8, entry_selector.reinterpret_as_uint())
    write_u16_be(ttc, base + 10, range_shift.reinterpret_as_uint())
    for j, entry_index in indices {
      let rec_offset = base + 12 + j * 16
      let table_data = resolved_tables[entry_index]
      write_u32_be(ttc, rec_offset, entries[entry_index].tag)
      write_u32_be(
        ttc,
        rec_offset + 4,
        compute_checksum(table_data, 0, table_data.length()),
      )
      write_u32_be(
        ttc,
        rec_offset + 8,
        table_offsets[entry_index].reinterpret_as_uint(),
      )
      write_u32_be(
        ttc,
        rec_offset + 12,
        table_data.length().reinterpret_as_uint(),
      )
    }
  }
  for i, table_data in resolved_tables {
    let table_offset = table_offsets[i]
    for j in 0..<table_data.length() {
      ttc[table_offset + j] = table_data[j]
    }
  }
  Bytes::from_array(ttc[:])
}

///|
/// Parse a WOFF2 file and return the decompressed SFNT data.
/// Uses @brotli.decompress for the compressed data stream.
pub fn decompress_woff2(data : Bytes) -> Bytes raise @error.FTError {
  let reader = @stream.ByteReader::new(data)
  // Parse WOFF2 header (48 bytes)
  let signature = reader.read_u32_be()
  if signature != @types.TAG_WOF2 {
    raise @error.FTError::InvalidFileFormat
  }
  let flavor = reader.read_u32_be()
  let _length = reader.read_u32_be()
  let num_tables = reader.read_u16_be().reinterpret_as_int()
  let _reserved = reader.read_u16_be()
  let _total_sfnt_size = reader.read_u32_be()
  let total_compressed_size = reader.read_u32_be()
  let _major_version = reader.read_u16_be()
  let _minor_version = reader.read_u16_be()
  let _meta_offset = reader.read_u32_be()
  let _meta_length = reader.read_u32_be()
  let _meta_orig_length = reader.read_u32_be()
  let _priv_offset = reader.read_u32_be()
  let _priv_length = reader.read_u32_be()
  // Parse table directory
  let entries : Array[Woff2TableEntry] = []
  let mut stream_offset = 0
  for _ in 0..<num_tables {
    let flag_byte = reader.read_byte().to_uint()
    let tag_index = flag_byte & 0x3FU
    let tag = if tag_index == 0x3FU {
      reader.read_u32_be()
    } else {
      if tag_index.reinterpret_as_int() >= woff2_known_tags.length() {
        raise @error.FTError::InvalidTable
      }
      woff2_known_tags[tag_index.reinterpret_as_int()]
    }
    let xform_version = (flag_byte >> 6) & 0x03U
    let is_glyf_or_loca = tag == @types.TAG_GLYF || tag == @types.TAG_LOCA
    let transformed = if is_glyf_or_loca {
      xform_version == 0U
    } else {
      xform_version != 0U
    }
    let orig_length = read_base128(reader)
    let transform_length = if transformed {
      read_base128(reader)
    } else {
      orig_length
    }
    let flags = (if transformed { 0x100U } else { 0U }) | xform_version
    let src_offset = stream_offset
    entries.push({ tag, flags, orig_length, transform_length, src_offset })
    stream_offset += transform_length.reinterpret_as_int()
  }
  let (collection_version, fonts) = if flavor == @types.TAG_TTCF {
    read_collection_directory(reader, num_tables)
  } else {
    (0U, make_single_font_entries(flavor, num_tables))
  }
  // Read and decompress the compressed data stream
  let compressed_offset = reader.position()
  let compressed_data = data[compressed_offset:compressed_offset +
  total_compressed_size.reinterpret_as_int()].to_bytes()
  let uncompressed = @brotli.decompress(compressed_data) catch {
    _ => raise @error.FTError::InvalidTable
  }
  if uncompressed.length() < stream_offset {
    raise @error.FTError::InvalidTable
  }
  let resolved_tables : Array[Bytes] = Array::make(entries.length(), b"")
  let table_is_resolved : Array[Bool] = Array::make(entries.length(), false)
  for _, font in fonts {
    let glyf_index = find_font_table_index(font, entries, @types.TAG_GLYF)
    let loca_index = find_font_table_index(font, entries, @types.TAG_LOCA)
    if glyf_index < 0 || loca_index < 0 || table_is_resolved[glyf_index] {
      continue
    }
    let glyf_entry = entries[glyf_index]
    let is_transformed = (glyf_entry.flags & 0x100U) != 0U
    if is_transformed {
      if flavor == @types.TAG_TTCF && loca_index != glyf_index + 1 {
        raise @error.FTError::InvalidTable
      }
      let (glyf_data, loca_data, _x_mins) = reconstruct_glyf(
        uncompressed,
        glyf_entry.src_offset,
        glyf_entry.transform_length.reinterpret_as_int(),
        entries[loca_index].orig_length.reinterpret_as_int(),
      )
      resolved_tables[glyf_index] = glyf_data
      resolved_tables[loca_index] = loca_data
      table_is_resolved[glyf_index] = true
      table_is_resolved[loca_index] = true
    }
  }
  for _, font in fonts {
    let hmtx_index = find_font_table_index(font, entries, @types.TAG_HMTX)
    if hmtx_index < 0 ||
      table_is_resolved[hmtx_index] ||
      (entries[hmtx_index].flags & 0x100U) == 0U {
      continue
    }
    let maxp_index = find_font_table_index(font, entries, @types.TAG_MAXP)
    let hhea_index = find_font_table_index(font, entries, @types.TAG_HHEA)
    let glyf_index = find_font_table_index(font, entries, @types.TAG_GLYF)
    let loca_index = find_font_table_index(font, entries, @types.TAG_LOCA)
    if maxp_index < 0 || hhea_index < 0 || glyf_index < 0 || loca_index < 0 {
      raise @error.FTError::InvalidTable
    }
    let maxp = if table_is_resolved[maxp_index] {
      resolved_tables[maxp_index]
    } else {
      woff2_table_bytes(uncompressed, entries[maxp_index])
    }
    let hhea = if table_is_resolved[hhea_index] {
      resolved_tables[hhea_index]
    } else {
      woff2_table_bytes(uncompressed, entries[hhea_index])
    }
    let glyf = if table_is_resolved[glyf_index] {
      resolved_tables[glyf_index]
    } else {
      woff2_table_bytes(uncompressed, entries[glyf_index])
    }
    let loca = if table_is_resolved[loca_index] {
      resolved_tables[loca_index]
    } else {
      woff2_table_bytes(uncompressed, entries[loca_index])
    }
    resolved_tables[hmtx_index] = reconstruct_transformed_hmtx(
      entries[hmtx_index],
      uncompressed,
      maxp,
      hhea,
      glyf,
      loca,
    )
    table_is_resolved[hmtx_index] = true
  }
  for i, entry in entries {
    if table_is_resolved[i] {
      continue
    }
    let is_transformed = (entry.flags & 0x100U) != 0U
    if is_transformed {
      // WOFF2 only defines transforms for glyf/loca and hmtx; anything else
      // is an invalid font rather than a missing implementation detail.
      raise @error.FTError::InvalidTable
    }
    resolved_tables[i] = woff2_table_bytes(uncompressed, entry)
    table_is_resolved[i] = true
  }
  if flavor == @types.TAG_TTCF {
    build_ttc_font_collection(
      collection_version, fonts, entries, resolved_tables,
    )
  } else {
    build_sfnt_font(fonts[0], entries, resolved_tables)
  }
}
