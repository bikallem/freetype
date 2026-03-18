///|
/// A single name record from the 'name' table.
struct NameRecord {
  platform_id : UInt
  encoding_id : UInt
  language_id : UInt
  name_id : UInt
  length : UInt
  offset : UInt // offset from start of string storage
} derive(Show)

///|
pub fn NameRecord::new(
  platform_id~ : UInt,
  encoding_id~ : UInt,
  language_id~ : UInt,
  name_id~ : UInt,
  length~ : UInt,
  offset~ : UInt,
) -> NameRecord {
  { platform_id, encoding_id, language_id, name_id, length, offset }
}

///|
/// Parsed 'name' table.
struct NameTable {
  format : UInt
  count : UInt
  string_offset : UInt // offset from start of table to string storage
  records : Array[NameRecord]
  string_data : Bytes // raw string storage
} derive(Show)

///|
pub fn NameTable::new(
  format~ : UInt,
  count~ : UInt,
  string_offset~ : UInt,
  records~ : Array[NameRecord],
  string_data~ : Bytes,
) -> NameTable {
  { format, count, string_offset, records, string_data }
}

///|
// Name IDs
pub const NAME_ID_COPYRIGHT : UInt = 0U

///|
pub const NAME_ID_FONT_FAMILY : UInt = 1U

///|
pub const NAME_ID_FONT_SUBFAMILY : UInt = 2U

///|
pub const NAME_ID_UNIQUE_ID : UInt = 3U

///|
pub const NAME_ID_FULL_NAME : UInt = 4U

///|
pub const NAME_ID_VERSION_STRING : UInt = 5U

///|
pub const NAME_ID_PS_NAME : UInt = 6U

///|
pub const NAME_ID_PREFERRED_FAMILY : UInt = 16U

///|
pub const NAME_ID_PREFERRED_SUBFAMILY : UInt = 17U

///|
/// Parse the 'name' table.
pub fn parse_name(
  reader : @stream.ByteReader,
  offset : UInt,
  length : UInt,
) -> NameTable raise @error.FTError {
  let table_start = offset.reinterpret_as_int()
  reader.seek(table_start)
  let format = reader.read_u16_be()
  let count = reader.read_u16_be()
  let string_offset = reader.read_u16_be()
  let records : Array[NameRecord] = Array::new(
    capacity=count.reinterpret_as_int(),
  )
  for _ in 0..<count.reinterpret_as_int() {
    let platform_id = reader.read_u16_be()
    let encoding_id = reader.read_u16_be()
    let language_id = reader.read_u16_be()
    let name_id = reader.read_u16_be()
    let rec_length = reader.read_u16_be()
    let rec_offset = reader.read_u16_be()
    records.push({
      platform_id,
      encoding_id,
      language_id,
      name_id,
      length: rec_length,
      offset: rec_offset,
    })
  }
  // Read the string storage area
  let string_start = table_start + string_offset.reinterpret_as_int()
  let string_len = length.reinterpret_as_int() -
    string_offset.reinterpret_as_int()
  let string_data = if string_len > 0 {
    reader.seek(string_start)
    reader.read_bytes(string_len)
  } else {
    b""
  }
  { format, count, string_offset, records, string_data }
}

///|
/// Decode a name string from the name table.
/// Handles platform-specific encodings.
pub fn NameTable::get_name(self : NameTable, name_id : UInt) -> String? {
  // Prefer Windows Unicode (platform 3, encoding 1)
  for _, rec in self.records {
    if rec.name_id == name_id && rec.platform_id == 3U && rec.encoding_id == 1U {
      return Some(decode_utf16_be(self.string_data, rec.offset, rec.length))
    }
  }
  // Fallback: Unicode platform (platform 0)
  for _, rec in self.records {
    if rec.name_id == name_id && rec.platform_id == 0U {
      return Some(decode_utf16_be(self.string_data, rec.offset, rec.length))
    }
  }
  // Fallback: Macintosh (platform 1, encoding 0 = Mac Roman)
  for _, rec in self.records {
    if rec.name_id == name_id && rec.platform_id == 1U && rec.encoding_id == 0U {
      return Some(decode_mac_roman(self.string_data, rec.offset, rec.length))
    }
  }
  None
}

///|
/// Decode UTF-16 BE bytes to a String.
fn decode_utf16_be(data : Bytes, offset : UInt, length : UInt) -> String {
  let off = offset.reinterpret_as_int()
  let len = length.reinterpret_as_int()
  let buf = StringBuilder::new()
  let mut i = 0
  while i + 1 < len {
    let hi = data[off + i].to_int()
    let lo = data[off + i + 1].to_int()
    let code = (hi << 8) | lo
    // Handle surrogate pairs
    if code >= 0xD800 && code <= 0xDBFF && i + 3 < len {
      let hi2 = data[off + i + 2].to_int()
      let lo2 = data[off + i + 3].to_int()
      let low = (hi2 << 8) | lo2
      if low >= 0xDC00 && low <= 0xDFFF {
        let cp = ((code - 0xD800) << 10) + (low - 0xDC00) + 0x10000
        buf.write_char(Int::unsafe_to_char(cp))
        i += 4
        continue
      }
    }
    buf.write_char(Int::unsafe_to_char(code))
    i += 2
  }
  buf.to_string()
}

///|
/// Decode Mac Roman bytes to a String (ASCII subset for simplicity).
fn decode_mac_roman(data : Bytes, offset : UInt, length : UInt) -> String {
  let off = offset.reinterpret_as_int()
  let len = length.reinterpret_as_int()
  let buf = StringBuilder::new()
  for i in 0..<len {
    let b = data[off + i].to_int()
    if b < 128 {
      buf.write_char(Int::unsafe_to_char(b))
    } else {
      buf.write_char('?')
    }
  }
  buf.to_string()
}
