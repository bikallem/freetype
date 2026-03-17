///|
/// Type 42 font driver.
/// Type 42 wraps TrueType font data inside a PostScript wrapper.
/// The /sfnts array contains hex-encoded TrueType data which is
/// extracted and passed to the TrueType driver.

///|
pub(all) struct Type42Font {
  mut font_name : String
  mut sfnts_data : Bytes // extracted TrueType data from /sfnts array
  mut font_bbox : Array[Int] // [llx lly urx ury]
} derive(Show)

///|
pub fn Type42Font::new() -> Type42Font {
  { font_name: "", sfnts_data: Bytes::new(0), font_bbox: [0, 0, 0, 0] }
}

///|
/// Parse a Type 42 font: extract the embedded TrueType data from /sfnts.
pub fn parse_type42(data : Bytes) -> Type42Font raise @error.FTError {
  let len = data.length()
  if len < 20 {
    raise @error.FTError::InvalidFileFormat
  }
  let font = Type42Font::new()
  // Convert to string for text searching
  let text = bytes_to_ascii(data)
  // Extract font name
  font.font_name = extract_ps_value(text, "/FontName")
  // Find /sfnts array and extract hex-encoded TrueType data
  font.sfnts_data = extract_sfnts(text)
  // Extract FontBBox
  let bbox_str = extract_ps_value(text, "/FontBBox")
  if bbox_str.length() > 0 {
    font.font_bbox = parse_bbox(bbox_str)
  }
  font
}

///|
/// Extract the /sfnts hex data and decode to binary.
/// The sfnts array looks like: /sfnts [ <hex_data> ] def
/// or /sfnts [ <hex1> <hex2> ... ] def (multiple strings)
fn extract_sfnts(text : String) -> Bytes {
  // Find "/sfnts"
  let keyword = "/sfnts"
  let mut pos = 0
  let len = text.length()
  while pos + keyword.length() < len {
    let mut found = true
    for k in 0..<keyword.length() {
      if text[pos + k] != keyword[k] {
        found = false
        break
      }
    }
    if found {
      break
    }
    pos += 1
  }
  if pos + keyword.length() >= len {
    return Bytes::new(0)
  }
  pos += keyword.length()
  // Skip to first '<'
  while pos < len && text[pos] != '<' {
    pos += 1
  }
  // Collect all hex data between < > pairs
  let result : Array[Byte] = []
  while pos < len {
    if text[pos] == '<' {
      pos += 1
      while pos + 1 < len && text[pos] != '>' {
        let hi = hex_digit(text[pos])
        let lo = hex_digit(text[pos + 1])
        if hi >= 0 && lo >= 0 {
          result.push(((hi << 4) | lo).to_byte())
        }
        pos += 2
      }
      if pos < len && text[pos] == '>' {
        pos += 1
      }
    } else if text[pos] == ']' {
      break // end of sfnts array
    } else {
      pos += 1
    }
  }
  Bytes::from_array(result[:])
}

///|
fn hex_digit(c : UInt16) -> Int {
  if c >= '0' && c <= '9' {
    c.to_int() - 0x30
  } else if c >= 'a' && c <= 'f' {
    c.to_int() - 0x61 + 10
  } else if c >= 'A' && c <= 'F' {
    c.to_int() - 0x41 + 10
  } else {
    -1
  }
}

///|
fn extract_ps_value(text : String, key : String) -> String {
  let len = text.length()
  let klen = key.length()
  let mut pos = 0
  while pos + klen < len {
    let mut found = true
    for k in 0..<klen {
      if text[pos + k] != key[k] {
        found = false
        break
      }
    }
    if found {
      pos += klen
      // Skip whitespace
      while pos < len && (text[pos] == ' ' || text[pos] == '\t') {
        pos += 1
      }
      // Read value: if starts with /, read name; otherwise read to whitespace
      if pos < len && text[pos] == '/' {
        pos += 1
        let start = pos
        while pos < len &&
              text[pos] != ' ' &&
              text[pos] != '\t' &&
              text[pos] != '\n' &&
              text[pos] != '\r' {
          pos += 1
        }
        return text.substring(start~, end=pos)
      }
      // Read to end of line or 'def'
      let start = pos
      while pos < len && text[pos] != '\n' && text[pos] != '\r' {
        pos += 1
      }
      return text.substring(start~, end=pos)
    }
    pos += 1
  }
  ""
}

///|
fn parse_bbox(s : String) -> Array[Int] {
  // Parse "{llx lly urx ury}" or "[llx lly urx ury]"
  let mut clean = s
  // Strip brackets/braces
  if clean.length() > 0 {
    let first = clean[0]
    if first == '{' || first == '[' {
      clean = clean.substring(start=1)
    }
  }
  if clean.length() > 0 {
    let last = clean[clean.length() - 1]
    if last == '}' || last == ']' {
      clean = clean.substring(end=clean.length() - 1)
    }
  }
  let parts = split_on_space(clean)
  let result : Array[Int] = []
  for _, p in parts {
    if p.length() > 0 {
      result.push(parse_int_simple(p))
    }
  }
  while result.length() < 4 {
    result.push(0)
  }
  result
}

///|
fn split_on_space(s : String) -> Array[String] {
  let result : Array[String] = []
  let len = s.length()
  let mut start = 0
  let mut in_word = false
  for i in 0..<len {
    if s[i] == ' ' || s[i] == '\t' {
      if in_word {
        result.push(s.substring(start~, end=i))
        in_word = false
      }
    } else if not(in_word) {
      start = i
      in_word = true
    }
  }
  if in_word {
    result.push(s.substring(start~, end=len))
  }
  result
}

///|
fn parse_int_simple(s : String) -> Int {
  let mut result = 0
  let mut neg = false
  let mut i = 0
  let len = s.length()
  if len > 0 && s[0] == '-' {
    neg = true
    i = 1
  }
  while i < len {
    let c = s[i]
    if c >= '0' && c <= '9' {
      result = result * 10 + (c.to_int() - 0x30)
    }
    i += 1
  }
  if neg {
    -result
  } else {
    result
  }
}

///|
fn bytes_to_ascii(data : Bytes) -> String {
  let buf = StringBuilder::new()
  for _, b in data {
    buf.write_char(Int::unsafe_to_char(b.to_int()))
  }
  buf.to_string()
}
