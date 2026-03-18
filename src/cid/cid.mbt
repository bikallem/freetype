///|
/// CID-keyed font driver.
/// CID fonts are a variant of PostScript fonts using Character IDs instead of names.
/// Ported from FreeType's cid module.

///|
/// Per-FD (Font Dict) private dictionary values.
pub(all) struct CidFontDict {
  mut blue_values : Array[Int]
  mut other_blues : Array[Int]
  mut std_hw : Int
  mut std_vw : Int
  mut default_width_x : Int64
  mut nominal_width_x : Int64
  mut len_iv : Int
  mut subrs : Array[Bytes]
  mut subrs_offset : Int
  mut sd_bytes : Int // SubrData bytes per entry
  mut paint_type : Int
} derive(Show)

///|
pub fn CidFontDict::new() -> CidFontDict {
  {
    blue_values: [],
    other_blues: [],
    std_hw: 0,
    std_vw: 0,
    default_width_x: 0L,
    nominal_width_x: 0L,
    len_iv: 4,
    subrs: [],
    subrs_offset: 0,
    sd_bytes: 0,
    paint_type: 0,
  }
}

///|
/// CID-keyed font representation.
pub(all) struct CidFont {
  mut font_name : String
  mut cid_count : Int // total number of CIDs
  mut fd_array : Array[CidFontDict] // Font Dict array
  mut registry : String // CIDSystemInfo registry
  mut ordering : String // CIDSystemInfo ordering
  mut supplement : Int // CIDSystemInfo supplement
  mut font_bbox : Array[Int] // [llx lly urx ury]
  mut gd_bytes : Int // GlyphData bytes per entry
  mut cid_map_offset : Int // offset to CID-to-GID map
  mut data_offset : Int // offset to charstring data
} derive(Show)

///|
pub fn CidFont::new() -> CidFont {
  {
    font_name: "",
    cid_count: 0,
    fd_array: [],
    registry: "",
    ordering: "",
    supplement: 0,
    font_bbox: [0, 0, 0, 0],
    gd_bytes: 0,
    cid_map_offset: 0,
    data_offset: 0,
  }
}

///|
/// Check if data is a CID-keyed font (starts with %!PS-Adobe and contains CIDFont).
pub fn is_cid_font(data : Bytes) -> Bool {
  let len = data.length()
  if len < 20 {
    return false
  }
  // Must start with %!PS-Adobe
  if data[0] != b'%' ||
    data[1] != b'!' ||
    data[2] != b'P' ||
    data[3] != b'S' ||
    data[4] != b'-' {
    return false
  }
  // Scan for "CIDFont" or "CID" keyword in first 2048 bytes
  let search_len = if len < 2048 { len } else { 2048 }
  find_ascii(data, "CIDFont", search_len) >= 0
}

///|
/// Find an ASCII string in bytes, returning the offset or -1 if not found.
fn find_ascii(data : Bytes, needle : String, max_offset : Int) -> Int {
  let needle_len = needle.length()
  if needle_len == 0 {
    return 0
  }
  let limit = max_offset - needle_len
  for i = 0; i <= limit; i = i + 1 {
    let mut found = true
    for j = 0; j < needle_len; j = j + 1 {
      if data[i + j] != needle[j].to_int().to_byte() {
        found = false
        break
      }
    }
    if found {
      return i
    }
  }
  -1
}

///|
/// Skip ASCII whitespace (space, tab, CR, LF).
fn skip_ws(data : Bytes, start : Int) -> Int {
  let len = data.length()
  let mut pos = start
  while pos < len {
    let b = data[pos]
    if b == b' ' || b == b'\t' || b == b'\r' || b == b'\n' {
      pos += 1
    } else {
      break
    }
  }
  pos
}

///|
/// Read a PostScript token starting at pos. Returns (token_string, next_pos).
fn read_ps_token(data : Bytes, start : Int) -> (String, Int) {
  let len = data.length()
  let pos = skip_ws(data, start)
  if pos >= len {
    return ("", pos)
  }
  let b = data[pos]
  // Parenthesized string
  if b == b'(' {
    let buf = StringBuilder::new()
    let mut depth = 1
    let mut i = pos + 1
    while i < len && depth > 0 {
      let c = data[i]
      if c == b'(' {
        depth += 1
        buf.write_char(Char::from_int(c.to_int()))
      } else if c == b')' {
        depth -= 1
        if depth > 0 {
          buf.write_char(Char::from_int(c.to_int()))
        }
      } else if c == b'\\' && i + 1 < len {
        i += 1
        buf.write_char(Char::from_int(data[i].to_int()))
      } else {
        buf.write_char(Char::from_int(c.to_int()))
      }
      i += 1
    }
    return (buf.to_string(), i)
  }
  // Regular token (delimited by whitespace or special chars)
  let buf = StringBuilder::new()
  let mut i = pos
  while i < len {
    let c = data[i]
    if c == b' ' ||
      c == b'\t' ||
      c == b'\r' ||
      c == b'\n' ||
      c == b'(' ||
      c == b')' ||
      c == b'<' ||
      c == b'>' ||
      c == b'[' ||
      c == b']' ||
      c == b'{' ||
      c == b'}' {
      break
    }
    buf.write_char(Char::from_int(c.to_int()))
    i += 1
  }
  (buf.to_string(), i)
}

///|
/// Parse an integer from a PostScript token string.
fn parse_ps_int(s : String) -> Int {
  @stream.parse_int_from_string(s)
}

///|
/// Parse a CID font from raw data.
/// CID fonts start with %!PS-Adobe and contain CIDSystemInfo, CIDCount, etc.
pub fn parse_cid_font(data : Bytes) -> CidFont raise @error.FTError {
  let len = data.length()
  if len < 20 {
    raise @error.FTError::InvalidFileFormat
  }
  // Verify header starts with %!PS-Adobe
  if data[0] != b'%' || data[1] != b'!' || data[2] != b'P' || data[3] != b'S' {
    raise @error.FTError::InvalidFileFormat
  }
  let font = CidFont::new()
  // Scan for PostScript dictionary keys in the header portion.
  // CID fonts have the metadata before "StartData".
  let scan_limit = if len < 65536 { len } else { 65536 }
  // Find and parse /CIDFontName first, fall back to /FontName
  let cidfn_off = find_ascii(data, "/CIDFontName", scan_limit)
  let fn_off = if cidfn_off >= 0 {
    let (tok, _) = read_ps_token(data, cidfn_off + 12)
    let name = if tok.length() > 0 && tok[0] == '/' {
      tok.substring(start=1)
    } else {
      tok
    }
    font.font_name = name
    cidfn_off
  } else {
    let off = find_ascii(data, "/FontName", scan_limit)
    if off >= 0 {
      let (tok, _) = read_ps_token(data, off + 9)
      let name = if tok.length() > 0 && tok[0] == '/' {
        tok.substring(start=1)
      } else {
        tok
      }
      font.font_name = name
    }
    off
  }
  ignore(fn_off)
  // Find and parse /CIDCount
  let cc_off = find_ascii(data, "/CIDCount", scan_limit)
  if cc_off >= 0 {
    let (tok, _) = read_ps_token(data, cc_off + 9)
    let count = parse_ps_int(tok)
    if count > 0 {
      font.cid_count = count
    }
  }
  // Find CIDSystemInfo - look for /Registry, /Ordering, /Supplement
  let reg_off = find_ascii(data, "/Registry", scan_limit)
  if reg_off >= 0 {
    let (tok, _) = read_ps_token(data, reg_off + 9)
    font.registry = tok
  }
  let ord_off = find_ascii(data, "/Ordering", scan_limit)
  if ord_off >= 0 {
    let (tok, _) = read_ps_token(data, ord_off + 9)
    font.ordering = tok
  }
  let sup_off = find_ascii(data, "/Supplement", scan_limit)
  if sup_off >= 0 {
    let (tok, _) = read_ps_token(data, sup_off + 11)
    font.supplement = parse_ps_int(tok)
  }
  // Find and parse /FontBBox
  let bb_off = find_ascii(data, "/FontBBox", scan_limit)
  if bb_off >= 0 {
    // Skip past /FontBBox and any whitespace/bracket
    let mut pos = bb_off + 9
    pos = skip_ws(data, pos)
    if pos < len && (data[pos] == b'[' || data[pos] == b'{') {
      pos += 1
    }
    let bbox : Array[Int] = []
    for _ in 0..<4 {
      let (tok, next) = read_ps_token(data, pos)
      if tok.length() > 0 {
        bbox.push(parse_ps_int(tok))
      }
      pos = next
    }
    if bbox.length() == 4 {
      font.font_bbox = bbox
    }
  }
  // Count FDArray entries - look for /FDArray followed by array
  let fd_off = find_ascii(data, "/FDArray", scan_limit)
  if fd_off >= 0 {
    // Look for a number before "array" keyword after /FDArray
    let pos = fd_off + 8
    let (tok, _) = read_ps_token(data, pos)
    let count = parse_ps_int(tok)
    if count > 0 && count < 256 {
      for _ in 0..<count {
        font.fd_array.push(CidFontDict::new())
      }
    }
  }
  // Find StartData offset
  let sd_off = find_ascii(data, "StartData", scan_limit)
  if sd_off >= 0 {
    font.data_offset = sd_off
  }
  font
}
