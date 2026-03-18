///|
/// PCF (Portable Compiled Format) driver.
/// Ported from FreeType's pcf module.

///|
/// PCF table type constants.
pub const PCF_PROPERTIES : UInt = 1U

///|
pub const PCF_ACCELERATORS : UInt = 2U

///|
pub const PCF_METRICS : UInt = 4U

///|
pub const PCF_BITMAPS : UInt = 8U

///|
pub const PCF_INK_METRICS : UInt = 16U

///|
pub const PCF_BDF_ENCODINGS : UInt = 32U

///|
pub const PCF_SWIDTHS : UInt = 64U

///|
pub const PCF_GLYPH_NAMES : UInt = 128U

///|
pub const PCF_BDF_ACCELERATORS : UInt = 256U

///|
/// PCF file signature: "\x01fcp" (little-endian "pcf\x01").
pub const PCF_SIGNATURE : UInt = 0x70636601U

///|
/// PCF format flag: byte order bit (bit 2). If set, data is MSB-first.
const PCF_BYTE_MASK : UInt = 4U

///|
/// An entry in the PCF table of contents.
#valtype
struct PcfTableEntry {
  table_type : UInt // one of the PCF_* constants
  format : UInt // format flags (byte order, etc.)
  size : UInt // table size in bytes
  offset : UInt // offset from start of file
} derive(Eq, Show)

///|
/// A PCF property (key-value pair from the properties table).
#valtype
struct PcfProperty {
  name : String
  is_string : Bool
  string_value : String
  int_value : Int
} derive(Eq, Show)

///|
/// PCF per-glyph metrics.
#valtype
struct PcfMetric {
  left_bearing : Int
  right_bearing : Int
  width : Int
  ascent : Int
  descent : Int
} derive(Eq, Show)

///|
/// PCF encoding entry: maps character code to glyph index.
#valtype
struct PcfEncodings {
  min_char_or_byte2 : Int
  max_char_or_byte2 : Int
  min_byte1 : Int
  max_byte1 : Int
  default_char : Int
  glyph_indices : Array[Int] // encoding -> glyph index, -1 means no glyph
} derive(Show)

///|
/// PCF font representation.
struct PcfFont {
  mut tables : Array[PcfTableEntry]
  mut font_name : String
  mut num_glyphs : Int
  mut properties : Array[PcfProperty]
  mut metrics : Array[PcfMetric]
  mut encodings : PcfEncodings?
  mut bitmap_offsets : Array[Int]
  mut bitmap_data : Bytes
} derive(Show)

///|
pub fn PcfFont::new() -> PcfFont {
  {
    tables: [],
    font_name: "",
    num_glyphs: 0,
    properties: [],
    metrics: [],
    encodings: None,
    bitmap_offsets: [],
    bitmap_data: Bytes::new(0),
  }
}

///|
/// Look up a glyph by encoding value.
pub fn PcfFont::get_glyph(self : PcfFont, encoding : Int) -> PcfMetric? {
  match self.encodings {
    None => None
    Some(enc) => {
      // For single-byte encodings (min_byte1 == 0, max_byte1 == 0)
      let index = if enc.min_byte1 == 0 && enc.max_byte1 == 0 {
        if encoding < enc.min_char_or_byte2 || encoding > enc.max_char_or_byte2 {
          -1
        } else {
          let arr_idx = encoding - enc.min_char_or_byte2
          if arr_idx >= 0 && arr_idx < enc.glyph_indices.length() {
            enc.glyph_indices[arr_idx]
          } else {
            -1
          }
        }
      } else {
        // Two-byte encoding
        let byte1 = encoding >> 8
        let byte2 = encoding & 0xFF
        if byte1 < enc.min_byte1 ||
          byte1 > enc.max_byte1 ||
          byte2 < enc.min_char_or_byte2 ||
          byte2 > enc.max_char_or_byte2 {
          -1
        } else {
          let cols = enc.max_char_or_byte2 - enc.min_char_or_byte2 + 1
          let arr_idx = (byte1 - enc.min_byte1) * cols +
            (byte2 - enc.min_char_or_byte2)
          if arr_idx >= 0 && arr_idx < enc.glyph_indices.length() {
            enc.glyph_indices[arr_idx]
          } else {
            -1
          }
        }
      }
      if index >= 0 && index < self.metrics.length() {
        Some(self.metrics[index])
      } else {
        None
      }
    }
  }
}

///|
/// Read a 32-bit value respecting the format byte order.
fn pcf_read_i32(
  reader : @stream.ByteReader,
  format : UInt,
) -> Int raise @error.FTError {
  if (format & PCF_BYTE_MASK) != 0U {
    reader.read_i32_be()
  } else {
    let v = reader.read_u32_le()
    v.reinterpret_as_int()
  }
}

///|
/// Read a 16-bit value respecting the format byte order.
fn pcf_read_i16(
  reader : @stream.ByteReader,
  format : UInt,
) -> Int raise @error.FTError {
  if (format & PCF_BYTE_MASK) != 0U {
    reader.read_i16_be()
  } else {
    let v = reader.read_u16_le()
    v.reinterpret_as_int()
  }
}

///|
/// Parse PCF header (table of contents).
/// The TOC starts with a 4-byte signature, then a 4-byte table count,
/// followed by table_count entries of 16 bytes each.
pub fn parse_pcf_header(
  reader : @stream.ByteReader,
) -> Array[PcfTableEntry] raise @error.FTError {
  let sig = reader.read_u32_le()
  if sig != PCF_SIGNATURE {
    raise @error.FTError::InvalidFileFormat
  }
  let table_count = reader.read_u32_le()
  let count = table_count.reinterpret_as_int()
  if count < 0 || count > 1024 {
    raise @error.FTError::InvalidFileFormat
  }
  let tables : Array[PcfTableEntry] = []
  for _ in 0..<count {
    let table_type = reader.read_u32_le()
    let format = reader.read_u32_le()
    let size = reader.read_u32_le()
    let offset = reader.read_u32_le()
    tables.push({ table_type, format, size, offset })
  }
  tables
}

///|
/// Find a table entry by type.
fn find_table(
  tables : Array[PcfTableEntry],
  table_type : UInt,
) -> PcfTableEntry? {
  for _, t in tables {
    if t.table_type == table_type {
      return Some(t)
    }
  }
  None
}

///|
/// Parse the properties table (type 1).
fn parse_properties(
  reader : @stream.ByteReader,
  entry : PcfTableEntry,
) -> Array[PcfProperty] raise @error.FTError {
  let props : Array[PcfProperty] = []
  reader.seek(entry.offset.reinterpret_as_int())
  // Read the format field
  let format = reader.read_u32_le()
  let num_props = pcf_read_i32(reader, format)
  if num_props < 0 || num_props > 65536 {
    return props
  }
  // Read property descriptors: name_offset(4), is_string(1), value(4)
  let descriptors : Array[(Int, Bool, Int)] = []
  for _ in 0..<num_props {
    let name_off = pcf_read_i32(reader, format)
    let is_str_byte = reader.read_byte()
    let value = pcf_read_i32(reader, format)
    descriptors.push((name_off, is_str_byte != b'\x00', value))
  }
  // Pad to 4-byte boundary
  let pos = reader.position()
  let pad = (4 - pos % 4) % 4
  if pad > 0 {
    reader.skip(pad)
  }
  // Read string table
  let string_size = pcf_read_i32(reader, format)
  let str_start = reader.position()
  let string_data = reader.read_bytes(
    if string_size > 0 {
      string_size
    } else {
      0
    },
  )
  ignore(str_start)
  // Build properties
  for _, desc in descriptors {
    let (name_off, is_str, value) = desc
    let name = read_cstring(string_data, name_off)
    if is_str {
      let str_val = read_cstring(string_data, value)
      props.push({ name, is_string: true, string_value: str_val, int_value: 0 })
    } else {
      props.push({ name, is_string: false, string_value: "", int_value: value })
    }
  }
  props
}

///|
/// Read a null-terminated C string from bytes at the given offset.
fn read_cstring(data : Bytes, offset : Int) -> String {
  let len = data.length()
  if offset < 0 || offset >= len {
    return ""
  }
  let buf = StringBuilder::new()
  let mut i = offset
  while i < len && data[i] != b'\x00' {
    buf.write_char(Int::unsafe_to_char(data[i].to_int()))
    i += 1
  }
  buf.to_string()
}

///|
/// Parse the metrics table (type 4).
fn parse_metrics(
  reader : @stream.ByteReader,
  entry : PcfTableEntry,
) -> Array[PcfMetric] raise @error.FTError {
  let metrics : Array[PcfMetric] = []
  reader.seek(entry.offset.reinterpret_as_int())
  let format = reader.read_u32_le()
  // Compressed metrics use 2-byte format (format & 0x100 != 0)
  let compressed = (format & 0x100U) != 0U
  if compressed {
    let count = pcf_read_i16(reader, format)
    for _ in 0..<count {
      // Compressed metrics: 5 bytes each, values biased by 0x80
      let lb = reader.read_byte().to_int() - 0x80
      let rb = reader.read_byte().to_int() - 0x80
      let w = reader.read_byte().to_int() - 0x80
      let asc = reader.read_byte().to_int() - 0x80
      let desc = reader.read_byte().to_int() - 0x80
      metrics.push({
        left_bearing: lb,
        right_bearing: rb,
        width: w,
        ascent: asc,
        descent: desc,
      })
    }
  } else {
    let count = pcf_read_i32(reader, format)
    for _ in 0..<count {
      // Uncompressed: 5 x int16 + 2 bytes attributes (padding)
      let lb = pcf_read_i16(reader, format)
      let rb = pcf_read_i16(reader, format)
      let w = pcf_read_i16(reader, format)
      let asc = pcf_read_i16(reader, format)
      let desc = pcf_read_i16(reader, format)
      // Skip 2-byte attributes field
      let _attrs = pcf_read_i16(reader, format)
      metrics.push({
        left_bearing: lb,
        right_bearing: rb,
        width: w,
        ascent: asc,
        descent: desc,
      })
    }
  }
  metrics
}

///|
/// Parse the BDF encodings table (type 32).
fn parse_encodings(
  reader : @stream.ByteReader,
  entry : PcfTableEntry,
) -> PcfEncodings raise @error.FTError {
  reader.seek(entry.offset.reinterpret_as_int())
  let format = reader.read_u32_le()
  let min2 = pcf_read_i16(reader, format)
  let max2 = pcf_read_i16(reader, format)
  let min1 = pcf_read_i16(reader, format)
  let max1 = pcf_read_i16(reader, format)
  let default_char = pcf_read_i16(reader, format)
  let num_entries = (max2 - min2 + 1) * (max1 - min1 + 1)
  let indices : Array[Int] = []
  for _ in 0..<num_entries {
    let idx = pcf_read_i16(reader, format)
    // 0xFFFF means no glyph
    let glyph_idx = if idx == 0xFFFF || idx < 0 { -1 } else { idx }
    indices.push(glyph_idx)
  }
  {
    min_char_or_byte2: min2,
    max_char_or_byte2: max2,
    min_byte1: min1,
    max_byte1: max1,
    default_char,
    glyph_indices: indices,
  }
}

///|
/// Parse the bitmaps table (type 8).
fn parse_bitmaps(
  reader : @stream.ByteReader,
  entry : PcfTableEntry,
) -> (Array[Int], Bytes) raise @error.FTError {
  reader.seek(entry.offset.reinterpret_as_int())
  let format = reader.read_u32_le()
  let num_glyphs = pcf_read_i32(reader, format)
  let offsets : Array[Int] = []
  for _ in 0..<num_glyphs {
    offsets.push(pcf_read_i32(reader, format))
  }
  // 4 bitmap sizes (for different padding modes), pick the one matching format
  let mut bitmap_size = 0
  for i in 0..<4 {
    let sz = pcf_read_i32(reader, format)
    let pad_index = (format & 3U).reinterpret_as_int()
    if i == pad_index {
      bitmap_size = sz
    }
  }
  let bdata = if bitmap_size > 0 {
    reader.read_bytes(bitmap_size)
  } else {
    Bytes::new(0)
  }
  (offsets, bdata)
}

///|
/// Parse a complete PCF font from raw data.
pub fn parse_pcf_font(data : Bytes) -> PcfFont raise @error.FTError {
  let reader = @stream.ByteReader::new(data)
  let tables = parse_pcf_header(reader)
  let font = PcfFont::new()
  font.tables = tables
  // Parse properties
  match find_table(tables, PCF_PROPERTIES) {
    Some(entry) => {
      font.properties = parse_properties(reader, entry)
      // Extract FONT property as font_name
      for _, p in font.properties {
        if p.name == "FONT" && p.is_string {
          font.font_name = p.string_value
          break
        }
      }
    }
    None => ()
  }
  // Parse metrics
  match find_table(tables, PCF_METRICS) {
    Some(entry) => {
      font.metrics = parse_metrics(reader, entry)
      font.num_glyphs = font.metrics.length()
    }
    None => ()
  }
  // Parse encodings
  match find_table(tables, PCF_BDF_ENCODINGS) {
    Some(entry) => font.encodings = Some(parse_encodings(reader, entry))
    None => ()
  }
  // Parse bitmaps
  match find_table(tables, PCF_BITMAPS) {
    Some(entry) => {
      let (offsets, bdata) = parse_bitmaps(reader, entry)
      font.bitmap_offsets = offsets
      font.bitmap_data = bdata
    }
    None => ()
  }
  font
}
