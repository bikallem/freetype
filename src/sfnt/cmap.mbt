///|
/// Cmap subtable header.
pub(all) struct CmapSubtable {
  platform_id : UInt
  encoding_id : UInt
  offset : UInt // offset from beginning of cmap table
} derive(Eq, Show)

///|
/// Parsed cmap table header.
pub(all) struct CmapTable {
  version : UInt
  subtables : Array[CmapSubtable]
} derive(Show)

///|
/// Parse the cmap table header and subtable directory.
pub fn parse_cmap_header(
  reader : @stream.ByteReader,
  offset : UInt,
) -> CmapTable raise @error.FTError {
  reader.seek(offset.reinterpret_as_int())
  let version = reader.read_u16_be()
  let num_tables = reader.read_u16_be()
  let subtables : Array[CmapSubtable] = []
  for _ in 0..<num_tables.reinterpret_as_int() {
    let platform_id = reader.read_u16_be()
    let encoding_id = reader.read_u16_be()
    let sub_offset = reader.read_u32_be()
    subtables.push({ platform_id, encoding_id, offset: sub_offset })
  }
  { version, subtables }
}

///|
/// Charcode → glyph index mapping interface.
/// Each cmap format implements this.
pub(all) enum CmapLookup {
  Format0(CmapFormat0)
  Format4(CmapFormat4)
  Format6(CmapFormat6)
  Format12(CmapFormat12)
}

///|
/// Look up a character code in a cmap.
pub fn CmapLookup::char_index(self : CmapLookup, charcode : UInt) -> UInt {
  match self {
    Format0(t) => t.char_index(charcode)
    Format4(t) => t.char_index(charcode)
    Format6(t) => t.char_index(charcode)
    Format12(t) => t.char_index(charcode)
  }
}

///|
/// Parse a cmap subtable at the given absolute offset.
/// Returns the appropriate format-specific lookup structure.
pub fn parse_cmap_subtable(
  reader : @stream.ByteReader,
  table_offset : UInt,
  subtable_offset : UInt,
) -> CmapLookup raise @error.FTError {
  let abs_offset = table_offset.reinterpret_as_int() +
    subtable_offset.reinterpret_as_int()
  reader.seek(abs_offset)
  let format = reader.read_u16_be()
  match format {
    0U => Format0(parse_cmap_format0(reader, abs_offset))
    4U => Format4(parse_cmap_format4(reader, abs_offset))
    6U => Format6(parse_cmap_format6(reader, abs_offset))
    12U => {
      // Format 12 has a different header: format(u16), reserved(u16), length(u32), language(u32)
      // We already read format. Read reserved u16.
      ignore(reader.read_u16_be())
      Format12(parse_cmap_format12(reader, abs_offset))
    }
    _ => raise @error.FTError::InvalidCharMapFormat
  }
}

// ---------------------------------------------------------------------------
// Format 0: Byte encoding table (256 entries)
// ---------------------------------------------------------------------------

///|
pub(all) struct CmapFormat0 {
  glyph_ids : FixedArray[Byte] // 256 entries
} derive(Show)

///|
fn parse_cmap_format0(
  reader : @stream.ByteReader,
  abs_offset : Int,
) -> CmapFormat0 raise @error.FTError {
  // format(2) already read. Read length(2), language(2), then 256 bytes
  reader.seek(abs_offset + 2)
  let _length = reader.read_u16_be()
  let _language = reader.read_u16_be()
  let glyph_ids = FixedArray::make(256, b'\x00')
  for i in 0..<256 {
    glyph_ids[i] = reader.read_byte()
  }
  { glyph_ids, }
}

///|
pub fn CmapFormat0::char_index(self : CmapFormat0, charcode : UInt) -> UInt {
  if charcode >= 256U {
    return 0U
  }
  self.glyph_ids[charcode.reinterpret_as_int()].to_uint()
}

// ---------------------------------------------------------------------------
// Format 4: Segment mapping to delta values (most common BMP format)
// ---------------------------------------------------------------------------

///|
pub(all) struct CmapFormat4 {
  seg_count : Int
  end_codes : Array[UInt]
  start_codes : Array[UInt]
  id_deltas : Array[Int]
  id_range_offsets : Array[UInt]
  glyph_ids : Array[UInt] // glyph index array following the segments
  id_range_offset_start : Int // byte offset into table where idRangeOffset starts
} derive(Show)

///|
fn parse_cmap_format4(
  reader : @stream.ByteReader,
  abs_offset : Int,
) -> CmapFormat4 raise @error.FTError {
  reader.seek(abs_offset + 2)
  let length = reader.read_u16_be().reinterpret_as_int()
  let _language = reader.read_u16_be()
  let seg_count_x2 = reader.read_u16_be().reinterpret_as_int()
  let seg_count = seg_count_x2 / 2
  let _search_range = reader.read_u16_be()
  let _entry_selector = reader.read_u16_be()
  let _range_shift = reader.read_u16_be()
  // endCode[segCount]
  let end_codes : Array[UInt] = []
  for _ in 0..<seg_count {
    end_codes.push(reader.read_u16_be())
  }
  // reservedPad
  let _reserved = reader.read_u16_be()
  // startCode[segCount]
  let start_codes : Array[UInt] = []
  for _ in 0..<seg_count {
    start_codes.push(reader.read_u16_be())
  }
  // idDelta[segCount]
  let id_deltas : Array[Int] = []
  for _ in 0..<seg_count {
    id_deltas.push(reader.read_i16_be())
  }
  // idRangeOffset[segCount]
  let id_range_offset_start = reader.position()
  let id_range_offsets : Array[UInt] = []
  for _ in 0..<seg_count {
    id_range_offsets.push(reader.read_u16_be())
  }
  // Remaining bytes are the glyphIdArray
  let glyph_array_start = reader.position()
  let glyph_array_end = abs_offset + length
  let glyph_ids : Array[UInt] = []
  for pos = glyph_array_start; pos + 1 < glyph_array_end; {
    reader.seek(pos)
    glyph_ids.push(reader.read_u16_be())
    continue pos + 2
  }
  {
    seg_count,
    end_codes,
    start_codes,
    id_deltas,
    id_range_offsets,
    glyph_ids,
    id_range_offset_start,
  }
}

///|
pub fn CmapFormat4::char_index(self : CmapFormat4, charcode : UInt) -> UInt {
  if charcode > 0xFFFFU {
    return 0U
  }
  // Binary search for the segment containing charcode
  for lo = 0, hi = self.seg_count - 1; lo <= hi; {
    let mid = (lo + hi) / 2
    if charcode > self.end_codes[mid] {
      continue mid + 1, hi
    } else if charcode < self.start_codes[mid] {
      continue lo, mid - 1
    } else {
      // Found: charcode is in segment [startCode[mid], endCode[mid]]
      let range_offset = self.id_range_offsets[mid]
      if range_offset == 0U {
        // Use delta
        let result = charcode.reinterpret_as_int() + self.id_deltas[mid]
        return (result & 0xFFFF).reinterpret_as_uint()
      }
      // Use glyph id array
      // The idRangeOffset is a byte offset from its own position in the table
      // to the glyph ID. We compute the index into glyph_ids array.
      let offset_in_range = (charcode - self.start_codes[mid]).reinterpret_as_int()
      let range_offset_pos = self.id_range_offset_start + mid * 2
      let glyph_addr = range_offset_pos +
        range_offset.reinterpret_as_int() +
        offset_in_range * 2
      let glyph_array_base = self.id_range_offset_start + self.seg_count * 2
      let glyph_idx = (glyph_addr - glyph_array_base) / 2
      if glyph_idx >= 0 && glyph_idx < self.glyph_ids.length() {
        let gid = self.glyph_ids[glyph_idx]
        if gid == 0U {
          return 0U
        }
        return ((gid.reinterpret_as_int() + self.id_deltas[mid]) & 0xFFFF).reinterpret_as_uint()
      }
      return 0U
    }
  } nobreak {
    0U
  }
}

// ---------------------------------------------------------------------------
// Format 6: Trimmed table mapping
// ---------------------------------------------------------------------------

///|
pub(all) struct CmapFormat6 {
  first_code : UInt
  entry_count : UInt
  glyph_ids : Array[UInt]
} derive(Show)

///|
fn parse_cmap_format6(
  reader : @stream.ByteReader,
  abs_offset : Int,
) -> CmapFormat6 raise @error.FTError {
  reader.seek(abs_offset + 2)
  let _length = reader.read_u16_be()
  let _language = reader.read_u16_be()
  let first_code = reader.read_u16_be()
  let entry_count = reader.read_u16_be()
  let glyph_ids : Array[UInt] = []
  for _ in 0..<entry_count.reinterpret_as_int() {
    glyph_ids.push(reader.read_u16_be())
  }
  { first_code, entry_count, glyph_ids }
}

///|
pub fn CmapFormat6::char_index(self : CmapFormat6, charcode : UInt) -> UInt {
  if charcode < self.first_code {
    return 0U
  }
  let idx = (charcode - self.first_code).reinterpret_as_int()
  if idx < self.glyph_ids.length() {
    self.glyph_ids[idx]
  } else {
    0U
  }
}

// ---------------------------------------------------------------------------
// Format 12: Segmented coverage (full Unicode)
// ---------------------------------------------------------------------------

///|
pub(all) struct CmapFormat12Group {
  start_char_code : UInt
  end_char_code : UInt
  start_glyph_id : UInt
} derive(Eq, Show)

///|
pub(all) struct CmapFormat12 {
  groups : Array[CmapFormat12Group]
} derive(Show)

///|
fn parse_cmap_format12(
  reader : @stream.ByteReader,
  abs_offset : Int,
) -> CmapFormat12 raise @error.FTError {
  // format(2) and reserved(2) already read
  // Read length(4), language(4), numGroups(4)
  let _length = reader.read_u32_be()
  let _language = reader.read_u32_be()
  let num_groups = reader.read_u32_be().reinterpret_as_int()
  ignore(abs_offset)
  let groups : Array[CmapFormat12Group] = []
  for _ in 0..<num_groups {
    let start_char_code = reader.read_u32_be()
    let end_char_code = reader.read_u32_be()
    let start_glyph_id = reader.read_u32_be()
    groups.push({ start_char_code, end_char_code, start_glyph_id })
  }
  { groups, }
}

///|
pub fn CmapFormat12::char_index(self : CmapFormat12, charcode : UInt) -> UInt {
  // Binary search
  for lo = 0, hi = self.groups.length() - 1; lo <= hi; {
    let mid = (lo + hi) / 2
    let g = self.groups[mid]
    if charcode > g.end_char_code {
      continue mid + 1, hi
    } else if charcode < g.start_char_code {
      continue lo, mid - 1
    } else {
      return g.start_glyph_id + (charcode - g.start_char_code)
    }
  } nobreak {
    0U
  }
}
