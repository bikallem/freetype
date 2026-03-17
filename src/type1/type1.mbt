///|
/// Type 1 font driver — parsing and glyph loading for Adobe Type 1 (PFB) fonts.
/// Ported from FreeType's type1 module.

///|
/// Type 1 font representation.
pub(all) struct Type1Font {
  mut font_name : String
  mut encoding : Array[String] // glyph name per encoding slot (256 entries)
  mut charstrings : Map[String, Bytes] // glyph_name -> charstring data
  mut subrs : Array[Bytes] // subroutine array
  // Private dict values
  mut blue_values : Array[Int] // BlueValues alignment zones
  mut other_blues : Array[Int] // OtherBlues alignment zones
  mut std_hw : Int // StdHW (dominant horizontal stem width)
  mut std_vw : Int // StdVW (dominant vertical stem width)
  mut default_width_x : Int64 // defaultWidthX
  mut nominal_width_x : Int64 // nominalWidthX
  mut len_iv : Int // lenIV for charstring decryption (default 4)
  mut paint_type : Int // PaintType (0 = fill, 2 = stroke)
  mut font_matrix : Array[Double] // FontMatrix (6 elements)
  mut font_bbox : Array[Int] // FontBBox [llx lly urx ury]
  mut unique_id : Int // UniqueID
} derive(Show)

///|
/// Create a new empty Type1Font.
pub fn Type1Font::new() -> Type1Font {
  {
    font_name: "",
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
  // Parse PFB segments
  for pos = 0; pos + 2 <= len; {
    let marker = data[pos]
    if marker != b'\x80' {
      raise @error.FTError::InvalidFileFormat
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
    if seg_type == 1 {
      ascii_parts.push(seg_data)
    } else if seg_type == 2 {
      binary_parts.push(seg_data)
    }
    continue data_start + seg_len
  }
  // Extract font name and FontBBox from ASCII segment if available
  if ascii_parts.length() > 0 {
    font.font_name = extract_font_name(ascii_parts[0])
    font.font_bbox = extract_font_bbox(ascii_parts[0])
  }
  // Decrypt binary segment (eexec encrypted private dict + charstrings)
  if binary_parts.length() > 0 {
    let _decrypted = eexec_decrypt(binary_parts[0])
    // In a full implementation, we would parse the decrypted data to extract
    // charstrings, subrs, and private dict values.
    // For now, the font struct is returned with metadata from the ASCII part.
  }
  font
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
  let (outline, _width) = @psaux.execute_type2(
    decrypted,
    font.default_width_x,
    font.nominal_width_x,
    local_subrs=font.subrs,
  )
  outline
}
