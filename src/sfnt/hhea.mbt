///|
/// Parsed 'hhea' (horizontal header) table.
pub(all) struct HheaTable {
  major_version : UInt
  minor_version : UInt
  ascender : Int // typographic ascent (FUnits)
  descender : Int // typographic descent (FUnits, typically negative)
  line_gap : Int
  advance_width_max : UInt
  min_left_side_bearing : Int
  min_right_side_bearing : Int
  x_max_extent : Int
  caret_slope_rise : Int
  caret_slope_run : Int
  caret_offset : Int
  // 4 reserved Int16 fields (skipped)
  metric_data_format : Int
  number_of_h_metrics : UInt // number of entries in hmtx with advance+lsb
} derive(Show)

///|
/// Parse the 'hhea' table.
pub fn parse_hhea(
  reader : @stream.ByteReader,
  offset : UInt,
  length : UInt,
) -> HheaTable raise @error.FTError {
  if length.reinterpret_as_int() < 36 {
    raise @error.FTError::HorizHeaderMissing
  }
  reader.seek(offset.reinterpret_as_int())
  reader.enter_frame(36)
  let major_version = reader.get_u16_be()
  let minor_version = reader.get_u16_be()
  let ascender = reader.get_i16_be()
  let descender = reader.get_i16_be()
  let line_gap = reader.get_i16_be()
  let advance_width_max = reader.get_u16_be()
  let min_left_side_bearing = reader.get_i16_be()
  let min_right_side_bearing = reader.get_i16_be()
  let x_max_extent = reader.get_i16_be()
  let caret_slope_rise = reader.get_i16_be()
  let caret_slope_run = reader.get_i16_be()
  let caret_offset = reader.get_i16_be()
  // Skip 4 reserved Int16 fields
  reader.frame_skip(8)
  let metric_data_format = reader.get_i16_be()
  let number_of_h_metrics = reader.get_u16_be()
  reader.exit_frame()
  {
    major_version,
    minor_version,
    ascender,
    descender,
    line_gap,
    advance_width_max,
    min_left_side_bearing,
    min_right_side_bearing,
    x_max_extent,
    caret_slope_rise,
    caret_slope_run,
    caret_offset,
    metric_data_format,
    number_of_h_metrics,
  }
}
