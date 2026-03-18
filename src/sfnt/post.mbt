///|
/// Parsed 'post' (PostScript) table header.
pub struct PostTable {
  format : UInt // 0x00010000, 0x00020000, 0x00025000, 0x00030000
  italic_angle : @fixed.Fixed
  underline_position : Int
  underline_thickness : Int
  is_fixed_pitch : UInt
  // Format 2.0 data
  glyph_names : Array[String] // per-glyph name (format 2.0 only)
} derive(Show)

///|
/// Parse the 'post' table.
pub fn parse_post(
  reader : @stream.ByteReader,
  offset : UInt,
  length : UInt,
  num_glyphs : UInt,
  parse_names? : Bool = true,
) -> PostTable raise @error.FTError {
  let len = length.reinterpret_as_int()
  if len < 12 {
    // Minimum: format(4) + italicAngle(4) + underlinePosition(2) + underlineThickness(2)
    raise @error.FTError::PostTableMissing
  }
  reader.seek(offset.reinterpret_as_int())
  let frame_size = if len < 32 { len } else { 32 }
  reader.enter_frame(frame_size)
  let format = reader.get_u32_be()
  let italic_angle = @fixed.Fixed::from_raw(reader.get_i32_be().to_int64())
  let underline_position = reader.get_i16_be()
  let underline_thickness = reader.get_i16_be()
  let is_fixed_pitch = if frame_size >= 16 { reader.get_u32_be() } else { 0U }
  // Skip minMemType42, maxMemType42, minMemType1, maxMemType1 (16 bytes)
  if frame_size >= 32 {
    reader.frame_skip(16)
  }
  reader.exit_frame()
  let glyph_names : Array[String] = []
  // Format 2.0: per-glyph name table
  if parse_names && format == 0x00020000U && len > 34 {
    let ng = num_glyphs.reinterpret_as_int()
    let table_num_glyphs = reader.read_u16_be().reinterpret_as_int()
    let actual_count = if table_num_glyphs < ng { table_num_glyphs } else { ng }
    // Read glyph name indices
    let indices : Array[UInt] = Array::new(capacity=actual_count)
    for _ in 0..<actual_count {
      indices.push(reader.read_u16_be())
    }
    // Read Pascal strings (extra names beyond the 258 Mac standard names)
    let extra_names : Array[String] = []
    // Read remaining bytes as Pascal strings
    let remaining_start = reader.position()
    let remaining_end = offset.reinterpret_as_int() + len
    while reader.position() < remaining_end {
      let slen = reader.read_byte().to_int()
      if reader.position() + slen > remaining_end {
        break // invalid data
      }
      let name_bytes = reader.read_bytes(slen)
      let buf = StringBuilder::new()
      for j in 0..<slen {
        buf.write_char(Int::unsafe_to_char(name_bytes[j].to_int()))
      }
      extra_names.push(buf.to_string())
    }
    ignore(remaining_start)
    // Resolve indices to names
    for _, idx_val in indices {
      let idx = idx_val.reinterpret_as_int()
      if idx < 258 {
        glyph_names.push(@psnames.macintosh_name(idx.reinterpret_as_uint()))
      } else {
        let extra_idx = idx - 258
        if extra_idx < extra_names.length() {
          glyph_names.push(extra_names[extra_idx])
        } else {
          glyph_names.push(".notdef")
        }
      }
    }
  }
  {
    format,
    italic_angle,
    underline_position,
    underline_thickness,
    is_fixed_pitch,
    glyph_names,
  }
}
