///|
/// PCF (Portable Compiled Format) driver.
/// Ported from FreeType's pcf module.

///|
/// PCF table type constants.
pub let pcf_properties : UInt = 1U << 0

///|
pub let pcf_accelerators : UInt = 1U << 1

///|
pub let pcf_metrics : UInt = 1U << 2

///|
pub let pcf_bitmaps : UInt = 1U << 3

///|
pub let pcf_ink_metrics : UInt = 1U << 4

///|
pub let pcf_bdf_encodings : UInt = 1U << 5

///|
pub let pcf_swidths : UInt = 1U << 6

///|
pub let pcf_glyph_names : UInt = 1U << 7

///|
pub let pcf_bdf_accelerators : UInt = 1U << 8

///|
/// PCF file signature: "\x01fcp" (little-endian "pcf\x01").
pub let pcf_signature : UInt = 0x70636601U

///|
/// An entry in the PCF table of contents.
pub(all) struct PcfTableEntry {
  table_type : UInt // one of the PCF_* constants
  format : UInt // format flags (byte order, etc.)
  size : UInt // table size in bytes
  offset : UInt // offset from start of file
} derive(Eq, Show)

///|
/// PCF font representation.
pub(all) struct PcfFont {
  mut tables : Array[PcfTableEntry]
  mut font_name : String
  mut num_glyphs : Int
} derive(Show)

///|
pub fn PcfFont::new() -> PcfFont {
  { tables: [], font_name: "", num_glyphs: 0 }
}

///|
/// Parse PCF header (table of contents).
/// The TOC starts with a 4-byte signature, then a 4-byte table count,
/// followed by table_count entries of 16 bytes each.
pub fn parse_pcf_header(
  reader : @stream.ByteReader,
) -> Array[PcfTableEntry] raise @error.FTError {
  let sig = reader.read_u32_le()
  if sig != pcf_signature {
    raise @error.FTError::InvalidFileFormat
  }
  let table_count = reader.read_u32_le()
  let count = table_count.reinterpret_as_int()
  if count < 0 || count > 1024 {
    raise @error.FTError::InvalidFileFormat
  }
  let tables : Array[PcfTableEntry] = []
  for i = 0; i < count; i = i + 1 {
    let table_type = reader.read_u32_le()
    let format = reader.read_u32_le()
    let size = reader.read_u32_le()
    let offset = reader.read_u32_le()
    tables.push({ table_type, format, size, offset })
  }
  tables
}
