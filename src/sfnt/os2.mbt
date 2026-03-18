///|
/// Parsed 'OS/2' table (key fields only).
struct Os2Table {
  version : UInt
  x_avg_char_width : Int
  us_weight_class : UInt
  us_width_class : UInt
  fs_type : UInt
  y_subscript_x_size : Int
  y_subscript_y_size : Int
  y_subscript_x_offset : Int
  y_subscript_y_offset : Int
  y_superscript_x_size : Int
  y_superscript_y_size : Int
  y_superscript_x_offset : Int
  y_superscript_y_offset : Int
  y_strikeout_size : Int
  y_strikeout_position : Int
  s_family_class : Int
  // panose[10] skipped for now
  // ulUnicodeRange[4] skipped
  // achVendID[4] skipped
  fs_selection : UInt
  us_first_char_index : UInt
  us_last_char_index : UInt
  s_typo_ascender : Int
  s_typo_descender : Int
  s_typo_line_gap : Int
  us_win_ascent : UInt
  us_win_descent : UInt
} derive(Show)

///|
/// Parse the 'OS/2' table.
pub fn parse_os2(
  reader : @stream.ByteReader,
  offset : UInt,
  length : UInt,
) -> Os2Table raise @error.FTError {
  let len = length.reinterpret_as_int()
  if len < 68 {
    raise @error.FTError::InvalidTable
  }
  reader.seek(offset.reinterpret_as_int())
  reader.enter_frame(if len < 78 { len } else { 78 })
  let version = reader.get_u16_be()
  let x_avg_char_width = reader.get_i16_be()
  let us_weight_class = reader.get_u16_be()
  let us_width_class = reader.get_u16_be()
  let fs_type = reader.get_u16_be()
  let y_subscript_x_size = reader.get_i16_be()
  let y_subscript_y_size = reader.get_i16_be()
  let y_subscript_x_offset = reader.get_i16_be()
  let y_subscript_y_offset = reader.get_i16_be()
  let y_superscript_x_size = reader.get_i16_be()
  let y_superscript_y_size = reader.get_i16_be()
  let y_superscript_x_offset = reader.get_i16_be()
  let y_superscript_y_offset = reader.get_i16_be()
  let y_strikeout_size = reader.get_i16_be()
  let y_strikeout_position = reader.get_i16_be()
  let s_family_class = reader.get_i16_be()
  // Skip panose[10]
  reader.frame_skip(10)
  // Skip ulUnicodeRange[4] (16 bytes)
  reader.frame_skip(16)
  // Skip achVendID[4]
  reader.frame_skip(4)
  let fs_selection = reader.get_u16_be()
  let us_first_char_index = reader.get_u16_be()
  let us_last_char_index = reader.get_u16_be()
  let s_typo_ascender = reader.get_i16_be()
  let s_typo_descender = reader.get_i16_be()
  let s_typo_line_gap = reader.get_i16_be()
  let us_win_ascent = reader.get_u16_be()
  let us_win_descent = reader.get_u16_be()
  reader.exit_frame()
  {
    version,
    x_avg_char_width,
    us_weight_class,
    us_width_class,
    fs_type,
    y_subscript_x_size,
    y_subscript_y_size,
    y_subscript_x_offset,
    y_subscript_y_offset,
    y_superscript_x_size,
    y_superscript_y_size,
    y_superscript_x_offset,
    y_superscript_y_offset,
    y_strikeout_size,
    y_strikeout_position,
    s_family_class,
    fs_selection,
    us_first_char_index,
    us_last_char_index,
    s_typo_ascender,
    s_typo_descender,
    s_typo_line_gap,
    us_win_ascent,
    us_win_descent,
  }
}
