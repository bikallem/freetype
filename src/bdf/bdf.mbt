///|
/// BDF (Bitmap Distribution Format) driver.
/// Ported from FreeType's bdf module.

///|
/// BDF glyph representation.
struct BdfGlyph {
  mut encoding : Int // character encoding value
  mut swidth_x : Int // scalable advance width x component
  mut swidth_y : Int // scalable advance width y component
  mut dwidth_x : Int // device advance width x component
  mut dwidth_y : Int // device advance width y component
  mut bbx_width : Int // bounding box width
  mut bbx_height : Int // bounding box height
  mut bbx_x_offset : Int // bounding box x offset
  mut bbx_y_offset : Int // bounding box y offset
  mut bitmap : Bytes // bitmap data (row-major, MSB first)
  name : String // glyph name
} derive(Show)

///|
pub fn BdfGlyph::new() -> BdfGlyph {
  {
    encoding: -1,
    swidth_x: 0,
    swidth_y: 0,
    dwidth_x: 0,
    dwidth_y: 0,
    bbx_width: 0,
    bbx_height: 0,
    bbx_x_offset: 0,
    bbx_y_offset: 0,
    bitmap: Bytes::new(0),
    name: "",
  }
}

///|
/// BDF font representation.
struct BdfFont {
  font_name : String
  point_size : Int
  x_resolution : Int
  y_resolution : Int
  glyphs : Array[BdfGlyph]
  num_chars : Int
  bbx_width : Int // global bounding box
  bbx_height : Int
  bbx_x_offset : Int
  bbx_y_offset : Int
} derive(Show)

///|
pub fn BdfFont::new() -> BdfFont {
  {
    font_name: "",
    point_size: 0,
    x_resolution: 0,
    y_resolution: 0,
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

// ---------------------------------------------------------------------------
// Zero-allocation byte-level helpers
// ---------------------------------------------------------------------------

///|
/// Convert a hex ASCII byte to its value (0-15), or -1 if invalid.
fn hex_val(b : Byte) -> Int {
  let c = b.to_int()
  if c >= 0x30 && c <= 0x39 {
    c - 0x30
  } else if c >= 0x41 && c <= 0x46 {
    c - 0x41 + 10
  } else if c >= 0x61 && c <= 0x66 {
    c - 0x61 + 10
  } else {
    -1
  }
}

///|
/// Check if the bytes at data[start..end) start with the given ASCII prefix.
fn bytes_starts_with(
  data : Bytes,
  start : Int,
  end : Int,
  prefix : String,
) -> Bool {
  let plen = prefix.length()
  if end - start < plen {
    return false
  }
  for i in 0..<plen {
    if data[start + i].to_int() != prefix[i].to_int() {
      return false
    }
  }
  true
}

///|
/// Check if data[start..end) equals the given ASCII string exactly.
fn bytes_equals(data : Bytes, start : Int, end : Int, s : String) -> Bool {
  let slen = s.length()
  if end - start != slen {
    return false
  }
  for i in 0..<slen {
    if data[start + i].to_int() != s[i].to_int() {
      return false
    }
  }
  true
}

///|
/// Convert bytes in data[start..end) to a String (ASCII).
fn bytes_to_string(data : Bytes, start : Int, end : Int) -> String {
  let buf = StringBuilder::new(size_hint=end - start)
  for i = start; i < end; {
    buf.write_char(Int::unsafe_to_char(data[i].to_int()))
    continue i + 1
  }
  buf.to_string()
}

///|
/// Parse an integer directly from bytes in data[start..end).
/// Handles optional leading '-' or '+' sign. Returns 0 on empty/invalid.
fn bytes_parse_int(data : Bytes, start : Int, end : Int) -> Int {
  if start >= end {
    return 0
  }
  let mut i = start
  let mut negative = false
  if data[i] == b'-' {
    negative = true
    i = i + 1
  } else if data[i] == b'+' {
    i = i + 1
  }
  let mut result = 0
  while i < end {
    let c = data[i].to_int()
    if c >= 0x30 && c <= 0x39 {
      result = result * 10 + (c - 0x30)
    } else {
      break
    }
    i = i + 1
  }
  if negative {
    -result
  } else {
    result
  }
}

///|
/// Skip spaces and tabs starting at pos, return new position.
fn bytes_skip_spaces(data : Bytes, pos : Int, end : Int) -> Int {
  let mut p = pos
  while p < end && (data[p] == b' ' || data[p] == b'\t') {
    p = p + 1
  }
  p
}

///|
/// Find the end of a whitespace-delimited token starting at pos.
fn bytes_find_token_end(data : Bytes, pos : Int, end : Int) -> Int {
  let mut p = pos
  while p < end && data[p] != b' ' && data[p] != b'\t' {
    p = p + 1
  }
  p
}

///|
/// Parse space-separated integers from data[start..end) into out array.
/// Parses up to `max` integers.
fn bytes_parse_int_fields(
  data : Bytes,
  start : Int,
  end : Int,
  out : Array[Int],
  max : Int,
) -> Unit {
  let mut pos = bytes_skip_spaces(data, start, end)
  let mut count = 0
  while pos < end && count < max {
    let tok_end = bytes_find_token_end(data, pos, end)
    out.push(bytes_parse_int(data, pos, tok_end))
    count = count + 1
    pos = bytes_skip_spaces(data, tok_end, end)
  }
}

// ---------------------------------------------------------------------------
// Main parser — scans Bytes directly, no String conversion
// ---------------------------------------------------------------------------

///|
/// Parse BDF font data including header and glyph blocks.
/// Returns a BdfFont with header fields and glyphs populated.
pub fn parse_bdf_header(data : Bytes) -> BdfFont raise @error.FTError {
  let len = data.length()
  let mut found_startfont = false
  let mut pos = 0
  let mut font_name = ""
  let mut point_size = 0
  let mut x_resolution = 0
  let mut y_resolution = 0
  let mut num_chars = 0
  let mut bbx_width = 0
  let mut bbx_height = 0
  let mut bbx_x_offset = 0
  let mut bbx_y_offset = 0
  // --- Parse header ---
  while pos < len {
    // Find end of line
    let line_start = pos
    let mut line_end = pos
    while line_end < len && data[line_end] != b'\n' && data[line_end] != b'\r' {
      line_end = line_end + 1
    }
    // Process header line
    if bytes_starts_with(data, line_start, line_end, "STARTFONT ") {
      found_startfont = true
    } else if bytes_starts_with(data, line_start, line_end, "FONT ") {
      font_name = bytes_to_string(data, line_start + 5, line_end)
    } else if bytes_starts_with(data, line_start, line_end, "SIZE ") {
      let fields : Array[Int] = []
      bytes_parse_int_fields(data, line_start + 5, line_end, fields, 3)
      if fields.length() >= 3 {
        point_size = fields[0]
        x_resolution = fields[1]
        y_resolution = fields[2]
      }
    } else if bytes_starts_with(data, line_start, line_end, "FONTBOUNDINGBOX ") {
      let fields : Array[Int] = []
      bytes_parse_int_fields(data, line_start + 16, line_end, fields, 4)
      if fields.length() >= 4 {
        bbx_width = fields[0]
        bbx_height = fields[1]
        bbx_x_offset = fields[2]
        bbx_y_offset = fields[3]
      }
    } else if bytes_starts_with(data, line_start, line_end, "CHARS ") {
      num_chars = bytes_parse_int(
        data,
        bytes_skip_spaces(data, line_start + 6, line_end),
        line_end,
      )
    } else if bytes_starts_with(data, line_start, line_end, "STARTCHAR ") {
      // Don't advance pos past this line — glyph loop will re-read it
      break
    }
    // Skip line ending
    pos = line_end
    if pos < len && data[pos] == b'\r' {
      pos = pos + 1
    }
    if pos < len && data[pos] == b'\n' {
      pos = pos + 1
    }
  }
  if not(found_startfont) {
    raise @error.FTError::MissingStartfontField
  }
  // --- Parse glyph blocks ---
  // Pre-allocate glyphs array using CHARS count to avoid repeated growth
  let glyphs : Array[BdfGlyph] = Array::new(
    capacity=if num_chars > 0 { num_chars } else { 256 },
  )
  while pos < len {
    // Find end of line
    let line_start = pos
    let mut line_end = pos
    while line_end < len && data[line_end] != b'\n' && data[line_end] != b'\r' {
      line_end = line_end + 1
    }
    if bytes_starts_with(data, line_start, line_end, "STARTCHAR ") {
      let glyph = BdfGlyph::new()
      // Skip glyph name allocation — names are not used at runtime
      // Advance past STARTCHAR line
      pos = line_end
      if pos < len && data[pos] == b'\r' {
        pos = pos + 1
      }
      if pos < len && data[pos] == b'\n' {
        pos = pos + 1
      }
      // Parse glyph properties until BITMAP
      while pos < len {
        let gs = pos
        let mut ge = pos
        while ge < len && data[ge] != b'\n' && data[ge] != b'\r' {
          ge = ge + 1
        }
        if bytes_equals(data, gs, ge, "BITMAP") {
          // Advance past BITMAP line
          pos = ge
          if pos < len && data[pos] == b'\r' {
            pos = pos + 1
          }
          if pos < len && data[pos] == b'\n' {
            pos = pos + 1
          }
          break
        } else if bytes_starts_with(data, gs, ge, "ENCODING ") {
          glyph.encoding = bytes_parse_int(
            data,
            bytes_skip_spaces(data, gs + 9, ge),
            ge,
          )
        } else if bytes_starts_with(data, gs, ge, "SWIDTH ") {
          let fields : Array[Int] = []
          bytes_parse_int_fields(data, gs + 7, ge, fields, 2)
          if fields.length() >= 2 {
            glyph.swidth_x = fields[0]
            glyph.swidth_y = fields[1]
          }
        } else if bytes_starts_with(data, gs, ge, "DWIDTH ") {
          let fields : Array[Int] = []
          bytes_parse_int_fields(data, gs + 7, ge, fields, 2)
          if fields.length() >= 2 {
            glyph.dwidth_x = fields[0]
            glyph.dwidth_y = fields[1]
          }
        } else if bytes_starts_with(data, gs, ge, "BBX ") {
          let fields : Array[Int] = []
          bytes_parse_int_fields(data, gs + 4, ge, fields, 4)
          if fields.length() >= 4 {
            glyph.bbx_width = fields[0]
            glyph.bbx_height = fields[1]
            glyph.bbx_x_offset = fields[2]
            glyph.bbx_y_offset = fields[3]
          }
        }
        // Advance past this glyph property line
        pos = ge
        if pos < len && data[pos] == b'\r' {
          pos = pos + 1
        }
        if pos < len && data[pos] == b'\n' {
          pos = pos + 1
        }
      }
      // Pre-allocate bitmap based on BBX dimensions and decode hex directly
      let row_bytes = (glyph.bbx_width + 7) / 8
      let bitmap_size = row_bytes * glyph.bbx_height
      let bitmap = FixedArray::make(
        if bitmap_size > 0 {
          bitmap_size
        } else {
          1
        },
        b'\x00',
      )
      let mut bmp_pos = 0
      // Read hex bitmap lines until ENDCHAR
      while pos < len {
        let hs = pos
        let mut he = pos
        while he < len && data[he] != b'\n' && data[he] != b'\r' {
          he = he + 1
        }
        if bytes_equals(data, hs, he, "ENDCHAR") {
          pos = he
          if pos < len && data[pos] == b'\r' {
            pos = pos + 1
          }
          if pos < len && data[pos] == b'\n' {
            pos = pos + 1
          }
          break
        }
        // Decode hex line directly into bitmap FixedArray
        let mut hi_pos = hs
        while hi_pos + 1 < he && bmp_pos < bitmap_size {
          let hi_val = hex_val(data[hi_pos])
          let lo_val = hex_val(data[hi_pos + 1])
          if hi_val >= 0 && lo_val >= 0 {
            bitmap[bmp_pos] = ((hi_val << 4) | lo_val).to_byte()
            bmp_pos += 1
          }
          hi_pos += 2
        }
        pos = he
        if pos < len && data[pos] == b'\r' {
          pos = pos + 1
        }
        if pos < len && data[pos] == b'\n' {
          pos = pos + 1
        }
      }
      glyph.bitmap = Bytes::from_array(bitmap[:])
      glyphs.push(glyph)
      continue // Don't advance pos again — already past ENDCHAR
    } else if bytes_equals(data, line_start, line_end, "ENDFONT") {
      break
    }
    // Advance past this line
    pos = line_end
    if pos < len && data[pos] == b'\r' {
      pos = pos + 1
    }
    if pos < len && data[pos] == b'\n' {
      pos = pos + 1
    }
  }
  {
    font_name,
    point_size,
    x_resolution,
    y_resolution,
    glyphs,
    num_chars,
    bbx_width,
    bbx_height,
    bbx_x_offset,
    bbx_y_offset,
  }
}

///|
pub fn BdfFont::font_name(self : BdfFont) -> String {
  self.font_name
}

///|
pub fn BdfFont::num_chars(self : BdfFont) -> Int {
  self.num_chars
}

///|
pub fn BdfFont::point_size(self : BdfFont) -> Int {
  self.point_size
}

///|
pub fn BdfFont::glyphs(self : BdfFont) -> Array[BdfGlyph] {
  self.glyphs
}

///|
pub fn BdfFont::bbx_width(self : BdfFont) -> Int {
  self.bbx_width
}

///|
pub fn BdfFont::bbx_height(self : BdfFont) -> Int {
  self.bbx_height
}

///|
pub fn BdfFont::bbx_x_offset(self : BdfFont) -> Int {
  self.bbx_x_offset
}

///|
pub fn BdfFont::bbx_y_offset(self : BdfFont) -> Int {
  self.bbx_y_offset
}

///|
pub fn BdfFont::x_resolution(self : BdfFont) -> Int {
  self.x_resolution
}

///|
pub fn BdfFont::y_resolution(self : BdfFont) -> Int {
  self.y_resolution
}

///|
pub fn BdfGlyph::encoding(self : BdfGlyph) -> Int {
  self.encoding
}

///|
pub fn BdfGlyph::swidth_x(self : BdfGlyph) -> Int {
  self.swidth_x
}

///|
pub fn BdfGlyph::swidth_y(self : BdfGlyph) -> Int {
  self.swidth_y
}

///|
pub fn BdfGlyph::dwidth_x(self : BdfGlyph) -> Int {
  self.dwidth_x
}

///|
pub fn BdfGlyph::dwidth_y(self : BdfGlyph) -> Int {
  self.dwidth_y
}

///|
pub fn BdfGlyph::bbx_width(self : BdfGlyph) -> Int {
  self.bbx_width
}

///|
pub fn BdfGlyph::bbx_height(self : BdfGlyph) -> Int {
  self.bbx_height
}

///|
pub fn BdfGlyph::bbx_x_offset(self : BdfGlyph) -> Int {
  self.bbx_x_offset
}

///|
pub fn BdfGlyph::bbx_y_offset(self : BdfGlyph) -> Int {
  self.bbx_y_offset
}

///|
pub fn BdfGlyph::bitmap(self : BdfGlyph) -> Bytes {
  self.bitmap
}

///|
pub fn BdfGlyph::name(self : BdfGlyph) -> String {
  self.name
}
