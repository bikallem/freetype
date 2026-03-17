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

///|
/// Read a 16-bit little-endian unsigned value from data at offset.
fn fnt_u16(data : Bytes, off : Int) -> UInt {
  data[off].to_uint() | (data[off + 1].to_uint() << 8)
}

///|
/// Read a 32-bit little-endian unsigned value from data at offset.
fn fnt_u32(data : Bytes, off : Int) -> UInt {
  data[off].to_uint() |
  (data[off + 1].to_uint() << 8) |
  (data[off + 2].to_uint() << 16) |
  (data[off + 3].to_uint() << 24)
}

///|
/// Read a null-terminated string from data at the given offset.
fn fnt_string(data : Bytes, off : Int) -> String {
  let len = data.length()
  let o = off
  if o <= 0 || o >= len {
    return ""
  }
  let buf = StringBuilder::new()
  let mut i = o
  while i < len && data[i] != b'\x00' {
    buf.write_char(Char::from_int(data[i].to_int()))
    i += 1
  }
  buf.to_string()
}

///|
/// Parse a standalone .fnt file header.
/// FNT v2 = 118 byte header, v3 = 148 byte header.
pub fn parse_fnt_font(data : Bytes) -> FntFont raise @error.FTError {
  let len = data.length()
  if len < 118 {
    raise @error.FTError::InvalidFileFormat
  }
  let version = fnt_u16(data, 0)
  if version != 0x0200U && version != 0x0300U {
    raise @error.FTError::InvalidFileFormat
  }
  let font = FntFont::new()
  font.version = version
  font.file_size = fnt_u32(data, 2)
  font.points_size = fnt_u16(data, 68)
  font.vert_resolution = fnt_u16(data, 70)
  font.horiz_resolution = fnt_u16(data, 72)
  font.ascent = fnt_u16(data, 74)
  font.internal_leading = fnt_u16(data, 76)
  font.external_leading = fnt_u16(data, 78)
  font.weight = fnt_u16(data, 83)
  font.charset = data[85].to_uint()
  font.pixel_width = fnt_u16(data, 86)
  font.pixel_height = fnt_u16(data, 88)
  font.pitch_and_family = data[90].to_uint()
  font.avg_width = fnt_u16(data, 91)
  font.max_width = fnt_u16(data, 93)
  font.first_char = data[95].to_uint()
  font.last_char = data[96].to_uint()
  font.default_char = data[97].to_uint()
  font.num_glyphs = (font.last_char - font.first_char + 1U).reinterpret_as_int() +
    1
  // Face name: offset stored at byte 105 (4 bytes LE)
  let face_name_off = fnt_u32(data, 105)
  font.face_name = fnt_string(data, face_name_off.reinterpret_as_int())
  font
}
