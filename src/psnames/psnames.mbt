///|
/// PostScript glyph name ↔ Unicode mapping module.
/// Ported from FreeType's psmodule.c / pstables.h.

///|
/// Bit flag set when a glyph name contains a variant suffix (e.g. ".alt").
pub let variant_bit : UInt = 0x80000000U

///|
/// Convert a PostScript glyph name to a Unicode value.
///
/// Three lookup paths are tried in order:
/// 1. "uni" prefix with exactly 4 uppercase hex digits → Unicode code point.
/// 2. "u" prefix with 4-6 uppercase hex digits → Unicode code point.
/// 3. Adobe Glyph List lookup via `adobe_glyph_index()`.
///
/// If the name contains '.' (not at position 0), VARIANT_BIT is OR'd into the result.
/// Returns 0 if the name cannot be mapped.
pub fn unicode_value(name : String) -> UInt {
  if name.length() == 0 {
    return 0U
  }
  // Check for variant suffix: '.' not at start
  let dot_pos = find_dot(name)
  let has_variant = dot_pos > 0
  let base_name = if has_variant { name[:dot_pos].to_string() } else { name }
  // Path 1: "uni" prefix with exactly 4 hex digits
  if base_name.length() >= 7 && base_name[:3].to_string() == "uni" {
    let hex_part = base_name[3:].to_string()
    if hex_part.length() == 4 {
      match parse_uppercase_hex(hex_part) {
        Some(v) => {
          let result = v
          return if has_variant { result | variant_bit } else { result }
        }
        None => ()
      }
    }
  }
  // Path 2: "u" prefix with 4-6 hex digits
  if base_name.length() >= 5 &&
    base_name.length() <= 7 &&
    base_name[0] == 'u' &&
    base_name[1] != 'n' {
    let hex_part = base_name[1:].to_string()
    if hex_part.length() >= 4 && hex_part.length() <= 6 {
      match parse_uppercase_hex(hex_part) {
        Some(v) => {
          let result = v
          return if has_variant { result | variant_bit } else { result }
        }
        None => ()
      }
    }
  }
  // Path 3: Adobe Glyph List lookup
  let code = adobe_glyph_index(base_name)
  if code != 0U {
    return if has_variant { code | variant_bit } else { code }
  }
  0U
}

///|
/// Return the standard Macintosh glyph name for the given index (0-257).
/// Returns ".notdef" for indices >= 258.
pub fn macintosh_name(index : UInt) -> String {
  if index >= 258U {
    return ".notdef"
  }
  mac_names[index.reinterpret_as_int()]
}

///|
/// Return the CFF standard string for the given SID (0-390).
/// Returns None for SIDs >= 391.
pub fn standard_string(sid : UInt) -> String? {
  if sid >= 391U {
    return None
  }
  Some(sid_names[sid.reinterpret_as_int()])
}

///|
/// Return the SID for a character code in the standard encoding.
/// Returns 0 (.notdef) for codes >= 256.
pub fn standard_encoding_sid(code : UInt) -> Int {
  if code >= 256U {
    return 0
  }
  standard_encoding[code.reinterpret_as_int()]
}

///|
/// Return the SID for a character code in the expert encoding.
/// Returns 0 (.notdef) for codes >= 256.
pub fn expert_encoding_sid(code : UInt) -> Int {
  if code >= 256U {
    return 0
  }
  expert_encoding[code.reinterpret_as_int()]
}

///|
/// Find the position of '.' in a string, or -1 if not found.
fn find_dot(s : String) -> Int {
  let len = s.length()
  for i in 0..<len {
    if s[i] == '.' {
      return i
    }
  }
  -1
}

///|
/// Parse a string of uppercase hex digits to a UInt value.
/// Returns None if any character is not a valid uppercase hex digit.
fn parse_uppercase_hex(s : String) -> UInt? {
  let mut result = 0U
  let len = s.length()
  for i in 0..<len {
    let c = s[i]
    let digit = if c >= '0' && c <= '9' {
      c.to_int() - 48 // '0'
    } else if c >= 'A' && c <= 'F' {
      c.to_int() - 55 // 'A' - 10
    } else {
      return None
    }
    result = result * 16U + digit.reinterpret_as_uint()
  }
  Some(result)
}
