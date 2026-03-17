///|
/// BDF (Bitmap Distribution Format) driver.
/// Ported from FreeType's bdf module.

///|
/// BDF glyph representation.
pub(all) struct BdfGlyph {
  mut encoding : Int // character encoding value
  mut bbx_width : Int // bounding box width
  mut bbx_height : Int // bounding box height
  mut bbx_x_offset : Int // bounding box x offset
  mut bbx_y_offset : Int // bounding box y offset
  mut bitmap : Bytes // bitmap data (row-major, MSB first)
  mut name : String // glyph name
} derive(Show)

///|
pub fn BdfGlyph::new() -> BdfGlyph {
  {
    encoding: -1,
    bbx_width: 0,
    bbx_height: 0,
    bbx_x_offset: 0,
    bbx_y_offset: 0,
    bitmap: Bytes::new(0),
    name: "",
  }
}

///|
/// BDF font property.
pub(all) struct BdfProperty {
  name : String
  value : String
} derive(Eq, Show)

///|
/// BDF font representation.
pub(all) struct BdfFont {
  mut font_name : String
  mut point_size : Int
  mut x_resolution : Int
  mut y_resolution : Int
  mut properties : Array[BdfProperty]
  mut glyphs : Array[BdfGlyph]
  mut num_chars : Int
  mut bbx_width : Int // global bounding box
  mut bbx_height : Int
  mut bbx_x_offset : Int
  mut bbx_y_offset : Int
} derive(Show)

///|
pub fn BdfFont::new() -> BdfFont {
  {
    font_name: "",
    point_size: 0,
    x_resolution: 0,
    y_resolution: 0,
    properties: [],
    glyphs: [],
    num_chars: 0,
    bbx_width: 0,
    bbx_height: 0,
    bbx_x_offset: 0,
    bbx_y_offset: 0,
  }
}

///|
/// Look up a glyph by encoding value.
pub fn BdfFont::get_glyph(self : BdfFont, encoding : Int) -> BdfGlyph? {
  for _, g in self.glyphs {
    if g.encoding == encoding {
      return Some(g)
    }
  }
  None
}

///|
/// Parse a pair of hex character code points into a byte.
fn parse_hex_byte(hi : Int, lo : Int) -> Byte {
  let h = if hi >= 0x61 {
    hi - 0x61 + 10
  } else if hi >= 0x41 {
    hi - 0x41 + 10
  } else {
    hi - 0x30
  }
  let l = if lo >= 0x61 {
    lo - 0x61 + 10
  } else if lo >= 0x41 {
    lo - 0x41 + 10
  } else {
    lo - 0x30
  }
  ((h << 4) | l).to_byte()
}

///|
/// Parse hex string into an array of bytes.
fn parse_hex_to_array(s : String, out : Array[Byte]) -> Unit {
  let len = s.length()
  let num_bytes = len / 2
  for i in 0..<num_bytes {
    let hi = s[i * 2].to_int()
    let lo = s[i * 2 + 1].to_int()
    out.push(parse_hex_byte(hi, lo))
  }
}

///|
/// Parse BDF font data including header and glyph blocks.
/// Returns a BdfFont with header fields and glyphs populated.
pub fn parse_bdf_header(data : Bytes) -> BdfFont raise @error.FTError {
  let font = BdfFont::new()
  let text = bytes_to_ascii(data)
  let lines = split_lines(text)
  let num_lines = lines.length()
  let mut found_startfont = false
  let mut i = 0
  // Parse header
  while i < num_lines {
    let line = lines[i]
    if line.has_prefix("STARTFONT ") {
      found_startfont = true
    } else if line.has_prefix("FONT ") {
      font.font_name = line[5:].to_string()
    } else if line.has_prefix("SIZE ") {
      let parts = split_spaces(line[5:].to_string())
      if parts.length() >= 3 {
        font.point_size = parse_int_or_zero(parts[0])
        font.x_resolution = parse_int_or_zero(parts[1])
        font.y_resolution = parse_int_or_zero(parts[2])
      }
    } else if line.has_prefix("FONTBOUNDINGBOX ") {
      let parts = split_spaces(line[16:].to_string())
      if parts.length() >= 4 {
        font.bbx_width = parse_int_or_zero(parts[0])
        font.bbx_height = parse_int_or_zero(parts[1])
        font.bbx_x_offset = parse_int_or_zero(parts[2])
        font.bbx_y_offset = parse_int_or_zero(parts[3])
      }
    } else if line.has_prefix("CHARS ") {
      font.num_chars = parse_int_or_zero(line[6:].to_string())
    } else if line.has_prefix("STARTCHAR ") {
      break // Done with header, start parsing glyphs
    }
    i = i + 1
  }
  if not(found_startfont) {
    raise @error.FTError::MissingStartfontField
  }
  // Parse glyph blocks
  while i < num_lines {
    let line = lines[i]
    if line.has_prefix("STARTCHAR ") {
      let glyph = BdfGlyph::new()
      glyph.name = line[10:].to_string()
      i = i + 1
      // Parse glyph properties until BITMAP
      while i < num_lines && lines[i] != "BITMAP" {
        let gl = lines[i]
        if gl.has_prefix("ENCODING ") {
          glyph.encoding = parse_int_or_zero(gl[9:].to_string())
        } else if gl.has_prefix("BBX ") {
          let parts = split_spaces(gl[4:].to_string())
          if parts.length() >= 4 {
            glyph.bbx_width = parse_int_or_zero(parts[0])
            glyph.bbx_height = parse_int_or_zero(parts[1])
            glyph.bbx_x_offset = parse_int_or_zero(parts[2])
            glyph.bbx_y_offset = parse_int_or_zero(parts[3])
          }
        }
        i = i + 1
      }
      // Skip "BITMAP" line
      i = i + 1
      // Read hex bitmap lines until ENDCHAR
      let hex_lines : Array[String] = []
      while i < num_lines && lines[i] != "ENDCHAR" {
        hex_lines.push(lines[i])
        i = i + 1
      }
      // Convert hex lines to bitmap bytes
      let bitmap_bytes : Array[Byte] = []
      for _, hl in hex_lines {
        parse_hex_to_array(hl, bitmap_bytes)
      }
      glyph.bitmap = Bytes::from_array(bitmap_bytes[:])
      font.glyphs.push(glyph)
    } else if line == "ENDFONT" {
      break
    }
    i = i + 1
  }
  font
}

///|
/// Convert bytes (ASCII/Latin-1) to String by treating each byte as a char.
fn bytes_to_ascii(data : Bytes) -> String {
  let buf = StringBuilder::new()
  for _, b in data {
    buf.write_char(Int::unsafe_to_char(b.to_int()))
  }
  buf.to_string()
}

///|
/// Split a string into lines on '\n'.
fn split_lines(s : String) -> Array[String] {
  let lines : Array[String] = []
  let mut start = 0
  let len = s.length()
  for i in 0..<len {
    if s[i] == '\n' {
      let line = s[start:i].to_string()
      // Strip trailing '\r'
      let trimmed = if line.length() > 0 && line[line.length() - 1] == '\r' {
        line[:line.length() - 1].to_string()
      } else {
        line
      }
      lines.push(trimmed)
      start = i + 1
    }
  }
  if start < len {
    lines.push(s[start:].to_string())
  }
  lines
}

///|
/// Split a string on spaces.
fn split_spaces(s : String) -> Array[String] {
  let parts : Array[String] = []
  let len = s.length()
  let mut start = 0
  let mut in_word = false
  for i in 0..<len {
    if s[i] == ' ' || s[i] == '\t' {
      if in_word {
        parts.push(s[start:i].to_string())
        in_word = false
      }
    } else if not(in_word) {
      start = i
      in_word = true
    }
  }
  if in_word {
    parts.push(s[start:].to_string())
  }
  parts
}

///|
/// Parse an integer from a string, returning 0 on failure.
fn parse_int_or_zero(s : String) -> Int {
  let mut result = 0
  let mut negative = false
  let start = if s.length() > 0 && s[0] == '-' {
    negative = true
    1
  } else {
    0
  }
  let len = s.length()
  for i = start; i < len; {
    let c = s[i]
    if c >= '0' && c <= '9' {
      result = result * 10 + (c.to_int() - '0'.to_int())
    } else {
      break
    }
    continue i + 1
  }
  if negative {
    -result
  } else {
    result
  }
}
