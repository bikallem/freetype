///|
/// SFNT table directory entry.
struct TableRecord {
  tag : UInt // 4-byte tag
  checksum : UInt
  offset : UInt // offset from beginning of file
  length : UInt
} derive(Eq, Show)

///|
pub fn TableRecord::tag(self : TableRecord) -> UInt {
  self.tag
}

///|
pub fn TableRecord::checksum(self : TableRecord) -> UInt {
  self.checksum
}

///|
pub fn TableRecord::offset(self : TableRecord) -> UInt {
  self.offset
}

///|
pub fn TableRecord::length(self : TableRecord) -> UInt {
  self.length
}

///|
pub fn TableRecord::new(
  tag~ : UInt,
  checksum~ : UInt,
  offset~ : UInt,
  length~ : UInt,
) -> TableRecord {
  { tag, checksum, offset, length }
}

///|
/// Parsed SFNT table directory.
struct TableDirectory {
  sfnt_version : UInt // 0x00010000 for TT, 'OTTO' for CFF, 'true' for Apple TT
  num_tables : UInt
  search_range : UInt
  entry_selector : UInt
  range_shift : UInt
  tables : Array[TableRecord]
} derive(Show)

///|
pub fn TableDirectory::sfnt_version(self : TableDirectory) -> UInt {
  self.sfnt_version
}

///|
pub fn TableDirectory::num_tables(self : TableDirectory) -> UInt {
  self.num_tables
}

///|
pub fn TableDirectory::tables(self : TableDirectory) -> Array[TableRecord] {
  self.tables
}

///|
pub fn TableDirectory::new(
  sfnt_version~ : UInt,
  num_tables~ : UInt,
  search_range~ : UInt,
  entry_selector~ : UInt,
  range_shift~ : UInt,
  tables~ : Array[TableRecord],
) -> TableDirectory {
  {
    sfnt_version,
    num_tables,
    search_range,
    entry_selector,
    range_shift,
    tables,
  }
}

///|
/// Parse the SFNT table directory from a ByteReader.
/// The reader should be positioned at the start of the SFNT data.
pub fn parse_table_directory(
  reader : @stream.ByteReader,
) -> TableDirectory raise @error.FTError {
  let sfnt_version = reader.read_u32_be()
  let num_tables = reader.read_u16_be()
  let search_range = reader.read_u16_be()
  let entry_selector = reader.read_u16_be()
  let range_shift = reader.read_u16_be()
  let tables : Array[TableRecord] = Array::new(
    capacity=num_tables.reinterpret_as_int(),
  )
  for _ in 0..<num_tables.reinterpret_as_int() {
    let tag = reader.read_u32_be()
    let checksum = reader.read_u32_be()
    let offset = reader.read_u32_be()
    let length = reader.read_u32_be()
    tables.push({ tag, checksum, offset, length })
  }
  {
    sfnt_version,
    num_tables,
    search_range,
    entry_selector,
    range_shift,
    tables,
  }
}

///|
/// Find a table by tag in the directory.
pub fn TableDirectory::find_table(
  self : TableDirectory,
  tag : UInt,
) -> TableRecord? {
  for _, table in self.tables {
    if table.tag == tag {
      return Some(table)
    }
  }
  None
}

///|
/// TrueType Collection (TTC) header.
struct TtcHeader {
  version : UInt // major.minor (1.0 or 2.0)
  num_fonts : UInt
  offsets : Array[UInt] // offset to each font's table directory
} derive(Show)

///|
/// Parse a TTC header. Reader should be at position 0.
pub fn parse_ttc_header(
  reader : @stream.ByteReader,
) -> TtcHeader raise @error.FTError {
  let tag = reader.read_u32_be()
  if tag != @types.tag_ttcf {
    raise @error.FTError::InvalidFileFormat
  }
  let version = reader.read_u32_be()
  let num_fonts = reader.read_u32_be()
  let offsets : Array[UInt] = Array::new(
    capacity=num_fonts.reinterpret_as_int(),
  )
  for _ in 0..<num_fonts.reinterpret_as_int() {
    offsets.push(reader.read_u32_be())
  }
  { version, num_fonts, offsets }
}
