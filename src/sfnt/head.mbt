///|
/// Parsed 'head' table — font header.
struct HeadTable {
  major_version : UInt // typically 1
  minor_version : UInt // typically 0
  font_revision : @fixed.Fixed // 16.16
  checksum_adjust : UInt
  magic_number : UInt // should be 0x5F0F3CF5
  flags : UInt
  units_per_em : UInt // typically 256..16384
  created : Int64 // seconds since 1904-01-01
  modified : Int64
  x_min : Int
  y_min : Int
  x_max : Int
  y_max : Int
  mac_style : UInt
  lowest_rec_ppem : UInt
  font_direction_hint : Int
  index_to_loc_format : Int // 0 = short offsets, 1 = long offsets
  glyph_data_format : Int
} derive(Show)

///|
pub fn HeadTable::units_per_em(self : HeadTable) -> UInt {
  self.units_per_em
}

///|
pub fn HeadTable::x_min(self : HeadTable) -> Int {
  self.x_min
}

///|
pub fn HeadTable::y_min(self : HeadTable) -> Int {
  self.y_min
}

///|
pub fn HeadTable::x_max(self : HeadTable) -> Int {
  self.x_max
}

///|
pub fn HeadTable::y_max(self : HeadTable) -> Int {
  self.y_max
}

///|
pub fn HeadTable::mac_style(self : HeadTable) -> UInt {
  self.mac_style
}

///|
pub fn HeadTable::index_to_loc_format(self : HeadTable) -> Int {
  self.index_to_loc_format
}

///|
pub fn HeadTable::flags(self : HeadTable) -> UInt {
  self.flags
}

///|
/// Parse the 'head' table.
pub fn parse_head(
  reader : @stream.ByteReader,
  offset : UInt,
  length : UInt,
) -> HeadTable raise @error.FTError {
  if length.reinterpret_as_int() < 54 {
    raise @error.FTError::InvalidTable
  }
  reader.seek(offset.reinterpret_as_int())
  reader.enter_frame(54)
  let major_version = reader.get_u16_be()
  let minor_version = reader.get_u16_be()
  let font_revision = @fixed.Fixed::from_raw(reader.get_i32_be().to_int64())
  let checksum_adjust = reader.get_u32_be()
  let magic_number = reader.get_u32_be()
  let flags = reader.get_u16_be()
  let units_per_em = reader.get_u16_be()
  let created = reader.get_i64_be()
  let modified = reader.get_i64_be()
  let x_min = reader.get_i16_be()
  let y_min = reader.get_i16_be()
  let x_max = reader.get_i16_be()
  let y_max = reader.get_i16_be()
  let mac_style = reader.get_u16_be()
  let lowest_rec_ppem = reader.get_u16_be()
  let font_direction_hint = reader.get_i16_be()
  let index_to_loc_format = reader.get_i16_be()
  let glyph_data_format = reader.get_i16_be()
  reader.exit_frame()
  {
    major_version,
    minor_version,
    font_revision,
    checksum_adjust,
    magic_number,
    flags,
    units_per_em,
    created,
    modified,
    x_min,
    y_min,
    x_max,
    y_max,
    mac_style,
    lowest_rec_ppem,
    font_direction_hint,
    index_to_loc_format,
    glyph_data_format,
  }
}
