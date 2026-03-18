///|
/// SFNT table directory entry.
pub(all) struct TableRecord {
  tag : UInt // 4-byte tag
  checksum : UInt
  offset : UInt // offset from beginning of file
  length : UInt
} derive(Eq, Show)

///|
/// Parsed SFNT table directory.
pub(all) struct TableDirectory {
  sfnt_version : UInt // 0x00010000 for TT, 'OTTO' for CFF, 'true' for Apple TT
  num_tables : UInt
  search_range : UInt
  entry_selector : UInt
  range_shift : UInt
  tables : Array[TableRecord]
} derive(Show)

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
  let tables : Array[TableRecord] = []
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
pub(all) struct TtcHeader {
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
  let offsets : Array[UInt] = []
  for _ in 0..<num_fonts.reinterpret_as_int() {
    offsets.push(reader.read_u32_be())
  }
  { version, num_fonts, offsets }
}
