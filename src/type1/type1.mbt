///|
/// Type 1 font driver — parsing and glyph loading for Adobe Type 1 (PFB) fonts.
/// Ported from FreeType's type1 module.

///|
/// Type 1 font representation.
pub struct Type1Font {
  mut font_name : String
  mut units_per_em : Int // default 1000 for Type 1
  mut encoding : Array[String] // glyph name per encoding slot (256 entries)
  mut charstrings : Map[String, Bytes] // glyph_name -> charstring data
  subrs : Array[Bytes] // subroutine array
  // Private dict values
  blue_values : Array[Int] // BlueValues alignment zones
  other_blues : Array[Int] // OtherBlues alignment zones
  std_hw : Int // StdHW (dominant horizontal stem width)
  std_vw : Int // StdVW (dominant vertical stem width)
  default_width_x : Int64 // defaultWidthX
  nominal_width_x : Int64 // nominalWidthX
  mut len_iv : Int // lenIV for charstring decryption (default 4)
  paint_type : Int // PaintType (0 = fill, 2 = stroke)
  font_matrix : Array[Double] // FontMatrix (6 elements)
  mut font_bbox : Array[Int] // FontBBox [llx lly urx ury]
  unique_id : Int // UniqueID
} derive(Show)

///|
/// Create a new empty Type1Font.
pub fn Type1Font::new() -> Type1Font {
  {
    font_name: "",
    units_per_em: 1000,
    encoding: [],
    charstrings: {},
    subrs: [],
    blue_values: [],
    other_blues: [],
    std_hw: 0,
    std_vw: 0,
    default_width_x: 0L,
    nominal_width_x: 0L,
    len_iv: 4,
    paint_type: 0,
    font_matrix: [0.001, 0.0, 0.0, 0.001, 0.0, 0.0],
    font_bbox: [0, 0, 0, 0],
    unique_id: 0,
  }
}

///|
/// Type 1 eexec decryption.
/// Decrypts data using the eexec cipher with the given initial key (default 55665).
/// The cipher is: plain = cipher ^ (key >> 8); key = (cipher + key) * 52845 + 22719
/// The first 4 bytes of output are random seed bytes and should be discarded.
pub fn eexec_decrypt(data : Bytes, key? : UInt = 55665) -> Bytes {
  let len = data.length()
  if len <= 4 {
    return Bytes::new(0)
  }
  let mut k = key
  // Decrypt all bytes, capturing output after first 4 (seed bytes)
  let output : Array[Byte] = []
  for i in 0..<len {
    let cipher = data[i].to_uint()
    let plain = cipher ^ (k >> 8)
    if i >= 4 {
      output.push((plain & 0xFFU).to_byte())
    }
    k = (cipher + k) * 52845U + 22719U
    k = k & 0xFFFFU
  }
  Bytes::from_array(output[:])
}

///|
/// Charstring decryption.
/// Decrypts a charstring using key 4330, then skips the first lenIV bytes.
pub fn charstring_decrypt(data : Bytes, len_iv? : Int = 4) -> Bytes {
  let len = data.length()
  if len <= len_iv {
    return Bytes::new(0)
  }
  let mut k : UInt = 4330
  let output : Array[Byte] = []
  for i in 0..<len {
    let cipher = data[i].to_uint()
    let plain = cipher ^ (k >> 8)
    if i >= len_iv {
      output.push((plain & 0xFFU).to_byte())
    }
    k = (cipher + k) * 52845U + 22719U
    k = k & 0xFFFFU
  }
  Bytes::from_array(output[:])
}

///|
/// Parse a PFB (Printer Font Binary) file.
/// PFB format: segments with 6-byte headers (marker 0x80, type, 4-byte LE length).
/// Segment types: 1 = ASCII, 2 = binary, 3 = EOF.
pub fn parse_type1_pfb(data : Bytes) -> Type1Font raise @error.FTError {
  let font = Type1Font::new()
  let len = data.length()
  let ascii_parts : Array[Bytes] = []
  let binary_parts : Array[Bytes] = []
  // Check if PFB (binary, starts with 0x80) or PFA (ASCII, starts with %!)
  if len < 2 || data[0] != b'\x80' {
    // PFA format: entire file is ASCII, eexec section is hex-encoded
    return parse_type1_pfa(data)
  }
  // Parse PFB segments
  for pos = 0; pos + 2 <= len; {
    let marker = data[pos]
    if marker != b'\x80' {
      break // end of PFB data
    }
    let seg_type = data[pos + 1].to_int()
    if seg_type == 3 {
      break // EOF segment
    }
    if pos + 6 > len {
      raise @error.FTError::InvalidFileFormat
    }
    // Read 4-byte little-endian length
    let seg_len = data[pos + 2].to_uint().reinterpret_as_int() |
      (data[pos + 3].to_uint().reinterpret_as_int() << 8) |
      (data[pos + 4].to_uint().reinterpret_as_int() << 16) |
      (data[pos + 5].to_uint().reinterpret_as_int() << 24)
    let data_start = pos + 6
    if data_start + seg_len > len {
      raise @error.FTError::InvalidFileFormat
    }
    let seg_data = data[data_start:data_start + seg_len].to_bytes()
    match seg_type {
      1 => ascii_parts.push(seg_data)
      2 => binary_parts.push(seg_data)
      _ => ()
    }
    continue data_start + seg_len
  }
  // Extract font name and FontBBox from ASCII segment if available
  if ascii_parts.length() > 0 {
    font.font_name = extract_font_name(ascii_parts[0])
    font.font_bbox = extract_font_bbox(ascii_parts[0])
    // Parse encoding from ASCII segment
    font.encoding = parse_encoding(ascii_parts[0])
  }
  // Decrypt binary segment (eexec encrypted private dict + charstrings)
  if binary_parts.length() > 0 {
    let decrypted = eexec_decrypt(binary_parts[0])
    // Parse /lenIV from decrypted data
    font.len_iv = extract_len_iv(decrypted)
    // Parse /CharStrings dict from decrypted data
    font.charstrings = extract_charstrings(decrypted)
  }
  font.units_per_em = 1000
  font
}

///|
/// Parse a PFA (ASCII) Type 1 font.
/// The entire file is ASCII; the eexec section is hex-encoded.
fn parse_type1_pfa(data : Bytes) -> Type1Font {
  let font = Type1Font::new()
  // The whole file is ASCII
  font.font_name = extract_font_name(data)
  font.font_bbox = extract_font_bbox(data)
  font.encoding = parse_encoding(data)
  // Find "eexec" keyword — everything after it is hex-encoded encrypted data
  let text_len = data.length()
  let mut eexec_pos = -1
  for i in 0..<(text_len - 5) {
    if data[i] == b'e' &&
      data[i + 1] == b'e' &&
      data[i + 2] == b'x' &&
      data[i + 3] == b'e' &&
      data[i + 4] == b'c' {
      eexec_pos = i + 5
      // Skip whitespace after "eexec"
      while eexec_pos < text_len &&
            (
              data[eexec_pos] == b' ' ||
              data[eexec_pos] == b'\n' ||
              data[eexec_pos] == b'\r'
            ) {
        eexec_pos += 1
      }
      break
    }
  }
  if eexec_pos >= 0 {
    // Decode hex characters to binary
    let binary : Array[Byte] = []
    let mut i = eexec_pos
    while i + 1 < text_len {
      let hi = hex_val(data[i])
      let lo = hex_val(data[i + 1])
      if hi >= 0 && lo >= 0 {
        binary.push(((hi << 4) | lo).to_byte())
        i += 2
      } else if data[i] == b'\n' || data[i] == b'\r' || data[i] == b' ' {
        i += 1 // skip whitespace
      } else {
        break // end of hex data (e.g., cleartomark)
      }
    }
    let binary_data = Bytes::from_array(binary[:])
    let decrypted = eexec_decrypt(binary_data)
    font.len_iv = extract_len_iv(decrypted)
    font.charstrings = extract_charstrings(decrypted)
  }
  font.units_per_em = 1000
  font
}

///|
fn hex_val(b : Byte) -> Int {
  @stream.hex_digit_value(b.to_int())
}

///|
/// Extract the font name from the ASCII segment of a PFB file.
fn extract_font_name(ascii_data : Bytes) -> String {
  // Look for /FontName pattern
  let len = ascii_data.length()
  for i = 0; i + 9 < len; {
    if ascii_data[i] == b'/' &&
      ascii_data[i + 1] == b'F' &&
      ascii_data[i + 2] == b'o' &&
      ascii_data[i + 3] == b'n' &&
      ascii_data[i + 4] == b't' &&
      ascii_data[i + 5] == b'N' &&
      ascii_data[i + 6] == b'a' &&
      ascii_data[i + 7] == b'm' &&
      ascii_data[i + 8] == b'e' {
      // Skip "/FontName" and whitespace
      let mut j = i + 9
      while j < len && (ascii_data[j] == b' ' || ascii_data[j] == b'\t') {
        j += 1
      }
      // Expect '/' before the name
      if j < len && ascii_data[j] == b'/' {
        j += 1
        let start = j
        while j < len &&
              ascii_data[j] != b' ' &&
              ascii_data[j] != b'\t' &&
              ascii_data[j] != b'\n' &&
              ascii_data[j] != b'\r' {
          j += 1
        }
        let name_bytes = ascii_data[start:j].to_bytes()
        let buf = StringBuilder::new()
        for _, b in name_bytes {
          buf.write_char(Int::unsafe_to_char(b.to_int()))
        }
        return buf.to_string()
      }
    }
    continue i + 1
  }
  ""
}

///|
/// Extract FontBBox from the ASCII segment of a PFB file.
/// Looks for /FontBBox {llx lly urx ury} or /FontBBox [llx lly urx ury].
fn extract_font_bbox(ascii_data : Bytes) -> Array[Int] {
  let len = ascii_data.length()
  // Search for "/FontBBox"
  for i = 0; i + 9 < len; {
    if ascii_data[i] == b'/' &&
      ascii_data[i + 1] == b'F' &&
      ascii_data[i + 2] == b'o' &&
      ascii_data[i + 3] == b'n' &&
      ascii_data[i + 4] == b't' &&
      ascii_data[i + 5] == b'B' &&
      ascii_data[i + 6] == b'B' &&
      ascii_data[i + 7] == b'o' &&
      ascii_data[i + 8] == b'x' {
      // Skip "/FontBBox" and whitespace
      let mut j = i + 9
      while j < len && (ascii_data[j] == b' ' || ascii_data[j] == b'\t') {
        j += 1
      }
      // Skip opening delimiter '{' or '['
      if j < len && (ascii_data[j] == b'{' || ascii_data[j] == b'[') {
        j += 1
      }
      // Parse 4 integers
      let nums : Array[Int] = []
      while nums.length() < 4 && j < len {
        // Skip whitespace
        while j < len && (ascii_data[j] == b' ' || ascii_data[j] == b'\t') {
          j += 1
        }
        if j >= len {
          break
        }
        let c = ascii_data[j]
        if c == b'}' || c == b']' {
          break
        }
        // Parse number (possibly negative)
        let mut negative = false
        if ascii_data[j] == b'-' {
          negative = true
          j += 1
        }
        let mut num = 0
        while j < len && ascii_data[j] >= b'0' && ascii_data[j] <= b'9' {
          num = num * 10 + (ascii_data[j].to_int() - b'0'.to_int())
          j += 1
        }
        if negative {
          num = -num
        }
        nums.push(num)
      }
      if nums.length() == 4 {
        return nums
      }
    }
    continue i + 1
  }
  [0, 0, 0, 0]
}

///|
/// Parse encoding from the ASCII segment.
/// Looks for "/Encoding StandardEncoding def" or custom "dup N /name put" entries.
fn parse_encoding(ascii_data : Bytes) -> Array[String] {
  let len = ascii_data.length()
  let encoding : Array[String] = Array::make(256, ".notdef")
  // Convert to string for easier searching
  let buf = StringBuilder::new()
  for i in 0..<len {
    buf.write_char(Int::unsafe_to_char(ascii_data[i].to_int()))
  }
  let text = buf.to_string()
  // Check for StandardEncoding
  if text.contains("StandardEncoding") &&
    text.contains("/Encoding") &&
    not(text.contains("/Encoding 256 array")) {
    // Use standard encoding: map code -> SID -> glyph name
    for i in 0..<256 {
      let sid = @psnames.standard_encoding_sid(i.reinterpret_as_uint())
      if sid != 0 {
        match @psnames.standard_string(sid.reinterpret_as_uint()) {
          Some(name) => encoding[i] = name
          None => ()
        }
      }
    }
    return encoding
  }
  // Look for custom encoding: "dup N /name put" entries
  // Search for "/Encoding" first
  let enc_keyword = "/Encoding"
  let mut start = 0
  let mut found_encoding = false
  for i in 0..<(len - enc_keyword.length()) {
    let mut match_ = true
    for j in 0..<enc_keyword.length() {
      if ascii_data[i + j] != enc_keyword[j].to_byte() {
        match_ = false
        break
      }
    }
    if match_ {
      start = i + enc_keyword.length()
      found_encoding = true
      break
    }
  }
  if not(found_encoding) {
    return encoding
  }
  // Parse "dup N /name put" entries
  let dup_kw = "dup"
  let put_kw = "put"
  let mut i = start
  while i + 10 < len {
    // Skip whitespace
    while i < len &&
          (
            ascii_data[i] == b' ' ||
            ascii_data[i] == b'\t' ||
            ascii_data[i] == b'\n' ||
            ascii_data[i] == b'\r'
          ) {
      i += 1
    }
    // Check for "def" or "readonly" which ends the encoding section
    if i + 3 <= len &&
      ascii_data[i] == b'd' &&
      ascii_data[i + 1] == b'e' &&
      ascii_data[i + 2] == b'f' {
      break
    }
    if i + 8 <= len &&
      ascii_data[i] == b'r' &&
      ascii_data[i + 1] == b'e' &&
      ascii_data[i + 2] == b'a' &&
      ascii_data[i + 3] == b'd' {
      break
    }
    // Check for "dup"
    if i + 3 <= len &&
      ascii_data[i] == b'd' &&
      ascii_data[i + 1] == b'u' &&
      ascii_data[i + 2] == b'p' {
      i += 3
      // Skip whitespace
      while i < len && (ascii_data[i] == b' ' || ascii_data[i] == b'\t') {
        i += 1
      }
      // Parse number
      let mut code = 0
      while i < len && ascii_data[i] >= b'0' && ascii_data[i] <= b'9' {
        code = code * 10 + (ascii_data[i].to_int() - b'0'.to_int())
        i += 1
      }
      // Skip whitespace
      while i < len && (ascii_data[i] == b' ' || ascii_data[i] == b'\t') {
        i += 1
      }
      // Expect '/'
      if i < len && ascii_data[i] == b'/' {
        i += 1
        let name_start = i
        while i < len &&
              ascii_data[i] != b' ' &&
              ascii_data[i] != b'\t' &&
              ascii_data[i] != b'\n' &&
              ascii_data[i] != b'\r' {
          i += 1
        }
        let name_buf = StringBuilder::new()
        for j in name_start..<i {
          name_buf.write_char(Int::unsafe_to_char(ascii_data[j].to_int()))
        }
        let name = name_buf.to_string()
        if code >= 0 && code < 256 {
          encoding[code] = name
        }
      }
      // Skip to end of line
      while i < len && ascii_data[i] != b'\n' && ascii_data[i] != b'\r' {
        i += 1
      }
    } else {
      // Skip to end of line
      while i < len && ascii_data[i] != b'\n' && ascii_data[i] != b'\r' {
        i += 1
      }
      i += 1
    }
    ignore(dup_kw)
    ignore(put_kw)
  }
  encoding
}

///|
/// Extract /lenIV value from decrypted eexec data. Default is 4.
fn extract_len_iv(data : Bytes) -> Int {
  let len = data.length()
  let keyword = "/lenIV"
  for i in 0..<(len - keyword.length()) {
    let mut match_ = true
    for j in 0..<keyword.length() {
      if data[i + j] != keyword[j].to_byte() {
        match_ = false
        break
      }
    }
    if match_ {
      let mut k = i + keyword.length()
      // Skip whitespace
      while k < len && (data[k] == b' ' || data[k] == b'\t') {
        k += 1
      }
      // Parse integer
      let mut val = 0
      while k < len && data[k] >= b'0' && data[k] <= b'9' {
        val = val * 10 + (data[k].to_int() - b'0'.to_int())
        k += 1
      }
      return val
    }
  }
  4 // default
}

///|
/// Extract charstrings from decrypted eexec data.
/// Looks for /CharStrings dict and parses "/name N RD ..." entries.
fn extract_charstrings(data : Bytes) -> Map[String, Bytes] {
  let charstrings : Map[String, Bytes] = {}
  let len = data.length()
  // Find /CharStrings
  let keyword = "/CharStrings"
  let mut cs_start = -1
  for i in 0..<(len - keyword.length()) {
    let mut match_ = true
    for j in 0..<keyword.length() {
      if data[i + j] != keyword[j].to_byte() {
        match_ = false
        break
      }
    }
    if match_ {
      cs_start = i + keyword.length()
      break
    }
  }
  if cs_start < 0 {
    return charstrings
  }
  // Skip to after "begin" or past the dict size
  let begin_kw = "begin"
  let mut pos = cs_start
  for i in cs_start..<(len - begin_kw.length()) {
    let mut match_ = true
    for j in 0..<begin_kw.length() {
      if data[i + j] != begin_kw[j].to_byte() {
        match_ = false
        break
      }
    }
    if match_ {
      pos = i + begin_kw.length()
      break
    }
  }
  // Now parse entries: /name N RD <N bytes> ND  (or -| and |-)
  while pos < len {
    // Skip whitespace
    while pos < len &&
          (
            data[pos] == b' ' ||
            data[pos] == b'\t' ||
            data[pos] == b'\n' ||
            data[pos] == b'\r'
          ) {
      pos += 1
    }
    if pos >= len {
      break
    }
    // Check for "end" which terminates the dict
    if pos + 3 <= len &&
      data[pos] == b'e' &&
      data[pos + 1] == b'n' &&
      data[pos + 2] == b'd' {
      break
    }
    // Expect '/' for glyph name
    if data[pos] != b'/' {
      pos += 1
      continue
    }
    pos += 1
    // Read name
    let name_start = pos
    while pos < len &&
          data[pos] != b' ' &&
          data[pos] != b'\t' &&
          data[pos] != b'\n' &&
          data[pos] != b'\r' {
      pos += 1
    }
    let name_buf = StringBuilder::new()
    for j in name_start..<pos {
      name_buf.write_char(Int::unsafe_to_char(data[j].to_int()))
    }
    let name = name_buf.to_string()
    // Skip whitespace
    while pos < len && (data[pos] == b' ' || data[pos] == b'\t') {
      pos += 1
    }
    // Parse charstring length N
    let mut cs_len = 0
    let mut found_digit = false
    while pos < len && data[pos] >= b'0' && data[pos] <= b'9' {
      cs_len = cs_len * 10 + (data[pos].to_int() - b'0'.to_int())
      found_digit = true
      pos += 1
    }
    if not(found_digit) {
      // Not a charstring entry, skip line
      while pos < len && data[pos] != b'\n' && data[pos] != b'\r' {
        pos += 1
      }
      continue
    }
    // Skip whitespace
    while pos < len && (data[pos] == b' ' || data[pos] == b'\t') {
      pos += 1
    }
    // Skip "RD" or "-|" token
    if pos + 2 <= len &&
      (
        (data[pos] == b'R' && data[pos + 1] == b'D') ||
        (data[pos] == b'-' && data[pos + 1] == b'|')
      ) {
      pos += 2
    }
    // Skip single space after RD
    if pos < len && data[pos] == b' ' {
      pos += 1
    }
    // Read cs_len bytes of charstring data
    if pos + cs_len <= len {
      let cs_data = data[pos:pos + cs_len].to_bytes()
      charstrings[name] = cs_data
      pos += cs_len
    } else {
      break
    }
    // Skip rest of line (ND, noaccess def, |-, etc.)
    while pos < len && data[pos] != b'\n' && data[pos] != b'\r' {
      pos += 1
    }
  }
  charstrings
}

///|
/// Load a glyph from a Type 1 font by name.
/// Looks up the charstring, decrypts it, and executes it via the PS interpreter.
pub fn load_type1_glyph(
  font : Type1Font,
  glyph_name : String,
) -> @types.Outline raise @error.FTError {
  let charstring = match font.charstrings.get(glyph_name) {
    Some(cs) => cs
    None => raise @error.FTError::InvalidGlyphIndex
  }
  let decrypted = charstring_decrypt(charstring, len_iv=font.len_iv)
  let (outline, _width, _, _) = @psaux.execute_type1(
    decrypted,
    font.subrs,
    font.default_width_x,
  )
  outline
}
