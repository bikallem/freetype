///|
/// Windows FNT/FON font driver.
/// Ported from FreeType's winfonts module.

///|
/// FNT font header (Windows .fnt format).
pub(all) struct FntFont {
  mut version : UInt // FNT version (0x200 or 0x300)
  mut file_size : UInt
  mut face_name : String
  mut points_size : UInt
  mut vert_resolution : UInt
  mut horiz_resolution : UInt
  mut ascent : UInt
  mut internal_leading : UInt
  mut external_leading : UInt
  mut weight : UInt // 400 = normal, 700 = bold
  mut charset : UInt
  mut pixel_width : UInt
  mut pixel_height : UInt
  mut pitch_and_family : UInt
  mut avg_width : UInt
  mut max_width : UInt
  mut first_char : UInt
  mut last_char : UInt
  mut default_char : UInt
  mut num_glyphs : Int
  mut is_fon : Bool // true if from a .fon (NE/PE) container
} derive(Show)

///|
pub fn FntFont::new() -> FntFont {
  {
    version: 0U,
    file_size: 0U,
    face_name: "",
    points_size: 0U,
    vert_resolution: 0U,
    horiz_resolution: 0U,
    ascent: 0U,
    internal_leading: 0U,
    external_leading: 0U,
    weight: 0U,
    charset: 0U,
    pixel_width: 0U,
    pixel_height: 0U,
    pitch_and_family: 0U,
    avg_width: 0U,
    max_width: 0U,
    first_char: 0U,
    last_char: 0U,
    default_char: 0U,
    num_glyphs: 0,
    is_fon: false,
  }
}

///|
/// Detect if data starts with an MZ header (DOS executable, used by .fon files).
/// .fon files are NE (New Executable) or PE containers that wrap .fnt resources.
pub fn is_mz_header(data : Bytes) -> Bool {
  if data.length() < 2 {
    return false
  }
  data[0] == b'M' && data[1] == b'Z'
}

///|
/// Detect if data starts with an FNT header.
/// FNT files start with a 2-byte version (0x0200 or 0x0300) in little-endian.
pub fn is_fnt_header(data : Bytes) -> Bool {
  if data.length() < 4 {
    return false
  }
  let version = data[0].to_uint() | (data[1].to_uint() << 8)
  version == 0x0200U || version == 0x0300U
}
