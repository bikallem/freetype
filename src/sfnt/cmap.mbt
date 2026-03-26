///|
/// Cmap subtable header.
#valtype
struct CmapSubtable {
  platform_id : UInt
  encoding_id : UInt
  offset : UInt // offset from beginning of cmap table
} derive(Eq, Show)

///|
/// Parsed cmap table header.
#valtype
struct CmapTable {
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
  let subtables : Array[CmapSubtable] = Array::new(
    capacity=num_tables.reinterpret_as_int(),
  )
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
  Format2(CmapFormat2)
  Format4(CmapFormat4)
  Format6(CmapFormat6)
  Format8(CmapFormat8)
  Format10(CmapFormat10)
  Format12(CmapFormat12)
  Format13(CmapFormat13)
  Format14(CmapFormat14)
}

///|
/// Look up a character code in a cmap.
pub fn CmapLookup::char_index(self : CmapLookup, charcode : UInt) -> UInt {
  match self {
    Format0(t) => t.char_index(charcode)
    Format2(t) => t.char_index(charcode)
    Format4(t) => t.char_index(charcode)
    Format6(t) => t.char_index(charcode)
    Format8(t) => t.char_index(charcode)
    Format10(t) => t.char_index(charcode)
    Format12(t) => t.char_index(charcode)
    Format13(t) => t.char_index(charcode)
    Format14(t) => t.char_index(charcode)
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
    2U => Format2(parse_cmap_format2(reader, abs_offset))
    4U => Format4(parse_cmap_format4(reader, abs_offset))
    6U => Format6(parse_cmap_format6(reader, abs_offset))
    8U => {
      ignore(reader.read_u16_be())
      Format8(parse_cmap_format8(reader, abs_offset))
    }
    10U => {
      // Format 10 has a different header: format(u16), reserved(u16), length(u32), language(u32)
      // We already read format. Read reserved u16.
      ignore(reader.read_u16_be())
      Format10(parse_cmap_format10(reader, abs_offset))
    }
    12U => {
      // Format 12 has a different header: format(u16), reserved(u16), length(u32), language(u32)
      // We already read format. Read reserved u16.
      ignore(reader.read_u16_be())
      Format12(parse_cmap_format12(reader, abs_offset))
    }
    13U => {
      // Format 13 shares the format 12 header and group layout.
      ignore(reader.read_u16_be())
      Format13(parse_cmap_format13(reader, abs_offset))
    }
    14U => Format14(parse_cmap_format14(reader, abs_offset))
    _ => raise @error.FTError::InvalidCharMapFormat
  }
}

// ---------------------------------------------------------------------------
// Format 0: Byte encoding table (256 entries)
// ---------------------------------------------------------------------------

///|
#valtype
struct CmapFormat0 {
  glyph_ids : FixedArray[Byte] // 256 entries
} derive(Show)

///|
pub fn CmapFormat0::new(glyph_ids~ : FixedArray[Byte]) -> CmapFormat0 {
  { glyph_ids, }
}

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
  self.glyph_ids.unsafe_get(charcode.reinterpret_as_int()).to_uint()
}

// ---------------------------------------------------------------------------
// Format 2: High byte mapping through table
// ---------------------------------------------------------------------------

///|
struct CmapFormat2SubHeader {
  first_code : UInt
  entry_count : UInt
  id_delta : Int
  glyph_array_index : Int
} derive(Show)

///|
pub fn CmapFormat2SubHeader::new(
  first_code~ : UInt,
  entry_count~ : UInt,
  id_delta~ : Int,
  glyph_array_index~ : Int,
) -> CmapFormat2SubHeader {
  { first_code, entry_count, id_delta, glyph_array_index }
}

///|
struct CmapFormat2 {
  sub_header_keys : FixedArray[Int]
  sub_headers : Array[CmapFormat2SubHeader]
  glyph_ids : Array[UInt]
} derive(Show)

///|
pub fn CmapFormat2::new(
  sub_header_keys~ : FixedArray[Int],
  sub_headers~ : Array[CmapFormat2SubHeader],
  glyph_ids~ : Array[UInt],
) -> CmapFormat2 {
  { sub_header_keys, sub_headers, glyph_ids }
}

///|
fn parse_cmap_format2(
  reader : @stream.ByteReader,
  abs_offset : Int,
) -> CmapFormat2 raise @error.FTError {
  reader.seek(abs_offset + 2)
  let length = reader.read_u16_be().reinterpret_as_int()
  let _language = reader.read_u16_be()
  let sub_header_keys = FixedArray::make(256, 0)
  let mut max_sub_header_index = 0
  for i in 0..<256 {
    let key = reader.read_u16_be().reinterpret_as_int()
    let sub_header_index = key / 8
    sub_header_keys[i] = sub_header_index
    if sub_header_index > max_sub_header_index {
      max_sub_header_index = sub_header_index
    }
  }
  let sub_headers_start = reader.position()
  let num_sub_headers = max_sub_header_index + 1
  let glyph_array_start = sub_headers_start + num_sub_headers * 8
  let sub_headers : Array[CmapFormat2SubHeader] = Array::new(
    capacity=num_sub_headers,
  )
  for i in 0..<num_sub_headers {
    let sub_header_offset = sub_headers_start + i * 8
    reader.seek(sub_header_offset)
    let first_code = reader.read_u16_be()
    let entry_count = reader.read_u16_be()
    let id_delta = reader.read_i16_be()
    let id_range_offset = reader.read_u16_be().reinterpret_as_int()
    let glyph_word_offset = sub_header_offset + 6 + id_range_offset
    let glyph_array_index = (glyph_word_offset - glyph_array_start) / 2
    sub_headers.push({ first_code, entry_count, id_delta, glyph_array_index })
  }
  let glyph_ids : Array[UInt] = []
  let glyph_count = (abs_offset + length - glyph_array_start) / 2
  if glyph_count < 0 {
    raise @error.FTError::InvalidCharMapFormat
  }
  reader.seek(glyph_array_start)
  for _ in 0..<glyph_count {
    glyph_ids.push(reader.read_u16_be())
  }
  { sub_header_keys, sub_headers, glyph_ids }
}

///|
pub fn CmapFormat2::char_index(self : CmapFormat2, charcode : UInt) -> UInt {
  if charcode > 0xFFFFU {
    return 0U
  }
  let high_byte = if charcode > 0xFFU {
    ((charcode >> 8) & 0xFFU).reinterpret_as_int()
  } else {
    0
  }
  let low_byte = (charcode & 0xFFU).reinterpret_as_int()
  let sub_header_index = self.sub_header_keys[high_byte]
  if sub_header_index < 0 || sub_header_index >= self.sub_headers.length() {
    return 0U
  }
  let sub = self.sub_headers.unsafe_get(sub_header_index)
  let first_code = sub.first_code.reinterpret_as_int()
  let entry_count = sub.entry_count.reinterpret_as_int()
  if low_byte < first_code || low_byte >= first_code + entry_count {
    return 0U
  }
  let glyph_index = sub.glyph_array_index + (low_byte - first_code)
  if glyph_index < 0 || glyph_index >= self.glyph_ids.length() {
    return 0U
  }
  let glyph_id = self.glyph_ids.unsafe_get(glyph_index)
  if glyph_id == 0U {
    return 0U
  }
  let adjusted = (glyph_id.reinterpret_as_int() + sub.id_delta) & 0xFFFF
  adjusted.reinterpret_as_uint()
}

// ---------------------------------------------------------------------------
// Format 4: Segment mapping to delta values (most common BMP format)
// ---------------------------------------------------------------------------

///|
struct CmapFormat4 {
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
  let end_codes : Array[UInt] = Array::new(capacity=seg_count)
  for _ in 0..<seg_count {
    end_codes.push(reader.read_u16_be())
  }
  // reservedPad
  let _reserved = reader.read_u16_be()
  // startCode[segCount]
  let start_codes : Array[UInt] = Array::new(capacity=seg_count)
  for _ in 0..<seg_count {
    start_codes.push(reader.read_u16_be())
  }
  // idDelta[segCount]
  let id_deltas : Array[Int] = Array::new(capacity=seg_count)
  for _ in 0..<seg_count {
    id_deltas.push(reader.read_i16_be())
  }
  // idRangeOffset[segCount]
  let id_range_offset_start = reader.position()
  let id_range_offsets : Array[UInt] = Array::new(capacity=seg_count)
  for _ in 0..<seg_count {
    id_range_offsets.push(reader.read_u16_be())
  }
  // Remaining bytes are the glyphIdArray — read sequentially (no seeking)
  let glyph_array_end = abs_offset + length
  let glyph_count = (glyph_array_end - reader.position()) / 2
  let glyph_ids : Array[UInt] = Array::new(capacity=glyph_count)
  for _ in 0..<glyph_count {
    glyph_ids.push(reader.read_u16_be())
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
  // All array accesses use unsafe_get since mid is always in [0, seg_count)
  for lo = 0, hi = self.seg_count - 1; lo <= hi; {
    let mid = (lo + hi) / 2
    if charcode > self.end_codes.unsafe_get(mid) {
      continue mid + 1, hi
    } else if charcode < self.start_codes.unsafe_get(mid) {
      continue lo, mid - 1
    } else {
      let range_offset = self.id_range_offsets.unsafe_get(mid)
      if range_offset == 0U {
        let result = charcode.reinterpret_as_int() +
          self.id_deltas.unsafe_get(mid)
        return (result & 0xFFFF).reinterpret_as_uint()
      }
      let offset_in_range = (charcode - self.start_codes.unsafe_get(mid)).reinterpret_as_int()
      let range_offset_pos = self.id_range_offset_start + mid * 2
      let glyph_addr = range_offset_pos +
        range_offset.reinterpret_as_int() +
        offset_in_range * 2
      let glyph_array_base = self.id_range_offset_start + self.seg_count * 2
      let glyph_idx = (glyph_addr - glyph_array_base) / 2
      if glyph_idx >= 0 && glyph_idx < self.glyph_ids.length() {
        let gid = self.glyph_ids.unsafe_get(glyph_idx)
        if gid == 0U {
          return 0U
        }
        return ((gid.reinterpret_as_int() + self.id_deltas.unsafe_get(mid)) &
        0xFFFF).reinterpret_as_uint()
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
struct CmapFormat6 {
  first_code : UInt
  entry_count : UInt
  glyph_ids : Array[UInt]
} derive(Show)

///|
pub fn CmapFormat6::new(
  first_code~ : UInt,
  entry_count~ : UInt,
  glyph_ids~ : Array[UInt],
) -> CmapFormat6 {
  { first_code, entry_count, glyph_ids }
}

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
  let glyph_ids : Array[UInt] = Array::new(
    capacity=entry_count.reinterpret_as_int(),
  )
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
    self.glyph_ids.unsafe_get(idx)
  } else {
    0U
  }
}

// ---------------------------------------------------------------------------
// Format 8: Mixed 16-bit and 32-bit coverage
// ---------------------------------------------------------------------------

///|
struct CmapFormat8 {
  groups : Array[CmapFormat12Group]
} derive(Show)

///|
pub fn CmapFormat8::new(groups~ : Array[CmapFormat12Group]) -> CmapFormat8 {
  { groups, }
}

///|
fn parse_cmap_format8(
  reader : @stream.ByteReader,
  abs_offset : Int,
) -> CmapFormat8 raise @error.FTError {
  // format(2) and reserved(2) already read
  let _length = reader.read_u32_be()
  let _language = reader.read_u32_be()
  // is32[8192] describes the original UTF-16 stream encoding. Lookups in this
  // port are scalar-value based, so the mapping groups below are sufficient.
  reader.seek(reader.position() + 8192)
  let num_groups = reader.read_u32_be().reinterpret_as_int()
  ignore(abs_offset)
  let groups : Array[CmapFormat12Group] = Array::new(capacity=num_groups)
  for _ in 0..<num_groups {
    groups.push(
      CmapFormat12Group::new(
        start_char_code=reader.read_u32_be(),
        end_char_code=reader.read_u32_be(),
        start_glyph_id=reader.read_u32_be(),
      ),
    )
  }
  { groups, }
}

///|
pub fn CmapFormat8::char_index(self : CmapFormat8, charcode : UInt) -> UInt {
  CmapFormat12::new(groups=self.groups).char_index(charcode)
}

// ---------------------------------------------------------------------------
// Format 10: Trimmed array with 32-bit character codes
// ---------------------------------------------------------------------------

///|
struct CmapFormat10 {
  start_char_code : UInt
  num_chars : UInt
  glyph_ids : Array[UInt]
} derive(Show)

///|
pub fn CmapFormat10::new(
  start_char_code~ : UInt,
  num_chars~ : UInt,
  glyph_ids~ : Array[UInt],
) -> CmapFormat10 {
  { start_char_code, num_chars, glyph_ids }
}

///|
fn parse_cmap_format10(
  reader : @stream.ByteReader,
  abs_offset : Int,
) -> CmapFormat10 raise @error.FTError {
  // format(2) and reserved(2) already read
  // Read length(4), language(4), startCharCode(4), numChars(4)
  let _length = reader.read_u32_be()
  let _language = reader.read_u32_be()
  let start_char_code = reader.read_u32_be()
  let num_chars = reader.read_u32_be()
  ignore(abs_offset)
  let glyph_ids : Array[UInt] = Array::new(
    capacity=num_chars.reinterpret_as_int(),
  )
  for _ in 0..<num_chars.reinterpret_as_int() {
    glyph_ids.push(reader.read_u16_be())
  }
  { start_char_code, num_chars, glyph_ids }
}

///|
pub fn CmapFormat10::char_index(self : CmapFormat10, charcode : UInt) -> UInt {
  if charcode < self.start_char_code {
    return 0U
  }
  let idx = (charcode - self.start_char_code).reinterpret_as_int()
  if idx < self.glyph_ids.length() {
    self.glyph_ids.unsafe_get(idx)
  } else {
    0U
  }
}

// ---------------------------------------------------------------------------
// Format 12: Segmented coverage (full Unicode)
// ---------------------------------------------------------------------------

///|
struct CmapFormat12Group {
  start_char_code : UInt
  end_char_code : UInt
  start_glyph_id : UInt
} derive(Eq, Show)

///|
pub fn CmapFormat12Group::new(
  start_char_code~ : UInt,
  end_char_code~ : UInt,
  start_glyph_id~ : UInt,
) -> CmapFormat12Group {
  { start_char_code, end_char_code, start_glyph_id }
}

///|
struct CmapFormat12 {
  groups : Array[CmapFormat12Group]
} derive(Show)

///|
pub fn CmapFormat12::new(groups~ : Array[CmapFormat12Group]) -> CmapFormat12 {
  { groups, }
}

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
  let groups : Array[CmapFormat12Group] = Array::new(capacity=num_groups)
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
  // Binary search — mid is always in [0, groups.length()) so unsafe_get is safe
  for lo = 0, hi = self.groups.length() - 1; lo <= hi; {
    let mid = (lo + hi) / 2
    let g = self.groups.unsafe_get(mid)
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

// ---------------------------------------------------------------------------
// Format 13: Many-to-one segmented coverage
// ---------------------------------------------------------------------------

///|
struct CmapFormat13Group {
  start_char_code : UInt
  end_char_code : UInt
  glyph_id : UInt
} derive(Eq, Show)

///|
pub fn CmapFormat13Group::new(
  start_char_code~ : UInt,
  end_char_code~ : UInt,
  glyph_id~ : UInt,
) -> CmapFormat13Group {
  { start_char_code, end_char_code, glyph_id }
}

///|
struct CmapFormat13 {
  groups : Array[CmapFormat13Group]
} derive(Show)

///|
pub fn CmapFormat13::new(groups~ : Array[CmapFormat13Group]) -> CmapFormat13 {
  { groups, }
}

///|
fn parse_cmap_format13(
  reader : @stream.ByteReader,
  abs_offset : Int,
) -> CmapFormat13 raise @error.FTError {
  // format(2) and reserved(2) already read
  // Read length(4), language(4), numGroups(4)
  let _length = reader.read_u32_be()
  let _language = reader.read_u32_be()
  let num_groups = reader.read_u32_be().reinterpret_as_int()
  ignore(abs_offset)
  let groups : Array[CmapFormat13Group] = Array::new(capacity=num_groups)
  for _ in 0..<num_groups {
    let start_char_code = reader.read_u32_be()
    let end_char_code = reader.read_u32_be()
    let glyph_id = reader.read_u32_be()
    groups.push({ start_char_code, end_char_code, glyph_id })
  }
  { groups, }
}

///|
pub fn CmapFormat13::char_index(self : CmapFormat13, charcode : UInt) -> UInt {
  // Binary search — mid is always in [0, groups.length()) so unsafe_get is safe
  for lo = 0, hi = self.groups.length() - 1; lo <= hi; {
    let mid = (lo + hi) / 2
    let g = self.groups.unsafe_get(mid)
    if charcode > g.end_char_code {
      continue mid + 1, hi
    } else if charcode < g.start_char_code {
      continue lo, mid - 1
    } else {
      return g.glyph_id
    }
  } nobreak {
    0U
  }
}

// ---------------------------------------------------------------------------
// Format 14: Unicode variation sequences
// ---------------------------------------------------------------------------

///|
struct CmapFormat14Range {
  start_unicode_value : UInt
  additional_count : UInt
} derive(Eq, Show)

///|
pub fn CmapFormat14Range::new(
  start_unicode_value~ : UInt,
  additional_count~ : UInt,
) -> CmapFormat14Range {
  { start_unicode_value, additional_count }
}

///|
struct CmapFormat14Mapping {
  unicode_value : UInt
  glyph_id : UInt
} derive(Eq, Show)

///|
pub fn CmapFormat14Mapping::new(
  unicode_value~ : UInt,
  glyph_id~ : UInt,
) -> CmapFormat14Mapping {
  { unicode_value, glyph_id }
}

///|
struct CmapFormat14Selector {
  selector : UInt
  default_ranges : Array[CmapFormat14Range]
  non_default_mappings : Array[CmapFormat14Mapping]
} derive(Show)

///|
pub fn CmapFormat14Selector::new(
  selector~ : UInt,
  default_ranges~ : Array[CmapFormat14Range],
  non_default_mappings~ : Array[CmapFormat14Mapping],
) -> CmapFormat14Selector {
  { selector, default_ranges, non_default_mappings }
}

///|
struct CmapFormat14 {
  selectors : Array[CmapFormat14Selector]
} derive(Show)

///|
pub fn CmapFormat14::new(
  selectors~ : Array[CmapFormat14Selector],
) -> CmapFormat14 {
  { selectors, }
}

///|
fn read_u24_be(reader : @stream.ByteReader) -> UInt raise @error.FTError {
  (reader.read_byte().to_uint() << 16) |
  (reader.read_byte().to_uint() << 8) |
  reader.read_byte().to_uint()
}

///|
fn parse_cmap_format14(
  reader : @stream.ByteReader,
  abs_offset : Int,
) -> CmapFormat14 raise @error.FTError {
  reader.seek(abs_offset + 2)
  let _length = reader.read_u32_be()
  let num_selector_records = reader.read_u32_be().reinterpret_as_int()
  let records : Array[(UInt, UInt, UInt)] = Array::new(
    capacity=num_selector_records,
  )
  for _ in 0..<num_selector_records {
    records.push(
      (read_u24_be(reader), reader.read_u32_be(), reader.read_u32_be()),
    )
  }
  let selectors : Array[CmapFormat14Selector] = Array::new(
    capacity=num_selector_records,
  )
  for _, record in records {
    let (selector, default_offset, non_default_offset) = record
    let default_ranges : Array[CmapFormat14Range] = []
    if default_offset != 0U {
      reader.seek(abs_offset + default_offset.reinterpret_as_int())
      let num_ranges = reader.read_u32_be().reinterpret_as_int()
      for _ in 0..<num_ranges {
        default_ranges.push(
          CmapFormat14Range::new(
            start_unicode_value=read_u24_be(reader),
            additional_count=reader.read_byte().to_uint(),
          ),
        )
      }
    }
    let non_default_mappings : Array[CmapFormat14Mapping] = []
    if non_default_offset != 0U {
      reader.seek(abs_offset + non_default_offset.reinterpret_as_int())
      let num_mappings = reader.read_u32_be().reinterpret_as_int()
      for _ in 0..<num_mappings {
        non_default_mappings.push(
          CmapFormat14Mapping::new(
            unicode_value=read_u24_be(reader),
            glyph_id=reader.read_u16_be(),
          ),
        )
      }
    }
    selectors.push(
      CmapFormat14Selector::new(
        selector~,
        default_ranges~,
        non_default_mappings~,
      ),
    )
  }
  { selectors, }
}

///|
pub fn CmapFormat14::char_index(self : CmapFormat14, _charcode : UInt) -> UInt {
  ignore(self)
  0U
}

///|
fn CmapFormat14::find_selector(
  self : CmapFormat14,
  selector : UInt,
) -> CmapFormat14Selector? {
  for _, entry in self.selectors {
    if entry.selector == selector {
      return Some(entry)
    }
  }
  None
}

///|
fn range_contains(range : CmapFormat14Range, charcode : UInt) -> Bool {
  let end = range.start_unicode_value + range.additional_count
  charcode >= range.start_unicode_value && charcode <= end
}

///|
fn CmapFormat14Selector::default_contains(
  self : CmapFormat14Selector,
  charcode : UInt,
) -> Bool {
  for _, range in self.default_ranges {
    if range_contains(range, charcode) {
      return true
    }
  }
  false
}

///|
fn CmapFormat14Selector::non_default_glyph(
  self : CmapFormat14Selector,
  charcode : UInt,
) -> UInt {
  for _, mapping in self.non_default_mappings {
    if mapping.unicode_value == charcode {
      return mapping.glyph_id
    }
  }
  0U
}

///|
pub fn CmapFormat14::char_variant_index(
  self : CmapFormat14,
  charcode : UInt,
  selector : UInt,
  unicode_char_index : (UInt) -> UInt,
) -> UInt {
  match self.find_selector(selector) {
    Some(entry) => {
      let non_default = entry.non_default_glyph(charcode)
      if non_default != 0U {
        return non_default
      }
      if entry.default_contains(charcode) {
        return unicode_char_index(charcode)
      }
      0U
    }
    None => 0U
  }
}

///|
pub fn CmapFormat14::char_variant_is_default(
  self : CmapFormat14,
  charcode : UInt,
  selector : UInt,
  _unicode_char_index : (UInt) -> UInt,
) -> Int {
  match self.find_selector(selector) {
    Some(entry) => {
      if entry.non_default_glyph(charcode) != 0U {
        return 0
      }
      if entry.default_contains(charcode) {
        return 1
      }
      -1
    }
    None => -1
  }
}

///|
pub fn CmapFormat14::variant_selectors(self : CmapFormat14) -> Array[UInt] {
  let selectors : Array[UInt] = Array::new(capacity=self.selectors.length())
  for _, entry in self.selectors {
    selectors.push(entry.selector)
  }
  selectors
}

///|
pub fn CmapFormat14::variants_of_char(
  self : CmapFormat14,
  charcode : UInt,
) -> Array[UInt] {
  let selectors : Array[UInt] = []
  for _, entry in self.selectors {
    if entry.default_contains(charcode) ||
      entry.non_default_glyph(charcode) != 0U {
      selectors.push(entry.selector)
    }
  }
  selectors
}

///|
pub fn CmapFormat14::chars_of_variant(
  self : CmapFormat14,
  selector : UInt,
) -> Array[UInt] {
  match self.find_selector(selector) {
    Some(entry) => {
      let chars : Array[UInt] = []
      for _, range in entry.default_ranges {
        let end = range.start_unicode_value + range.additional_count
        for
          value in range.start_unicode_value.reinterpret_as_int()..<=end.reinterpret_as_int() {
          chars.push(value.reinterpret_as_uint())
        }
      }
      for _, mapping in entry.non_default_mappings {
        let mut exists = false
        for _, value in chars {
          if value == mapping.unicode_value {
            exists = true
            break
          }
        }
        if !exists {
          chars.push(mapping.unicode_value)
        }
      }
      chars.sort()
      chars
    }
    None => []
  }
}

///|
pub fn CmapTable::subtables(self : CmapTable) -> Array[CmapSubtable] {
  self.subtables
}

///|
pub fn CmapSubtable::platform_id(self : CmapSubtable) -> UInt {
  self.platform_id
}

///|
pub fn CmapSubtable::encoding_id(self : CmapSubtable) -> UInt {
  self.encoding_id
}

///|
pub fn CmapSubtable::offset(self : CmapSubtable) -> UInt {
  self.offset
}
