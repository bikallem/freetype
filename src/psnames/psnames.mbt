///|
/// PostScript glyph name ↔ Unicode mapping module.
/// Ported from FreeType's psmodule.c / pstables.h.

///|
/// Bit flag set when a glyph name contains a variant suffix (e.g. ".alt").
pub const VARIANT_BIT : UInt = 0x80000000U

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
          return if has_variant { result | VARIANT_BIT } else { result }
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
          return if has_variant { result | VARIANT_BIT } else { result }
        }
        None => ()
      }
    }
  }
  // Path 3: Adobe Glyph List lookup
  let code = adobe_glyph_index(base_name)
  if code != 0U {
    return if has_variant { code | VARIANT_BIT } else { code }
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
/// Build a FreeType-style Unicode charmap from glyph names.
///
/// Base glyphs win over variant glyphs for the same character code. A small
/// set of extra aliases used by FreeType's PostScript name service is added
/// only if the font doesn't already contain a direct Unicode mapping for that
/// code.
pub fn build_unicode_map(glyph_names : Array[String]) -> Map[UInt, UInt] {
  let unicode_cmap : Map[UInt, UInt] = {}
  let unicode_is_variant : Map[UInt, Bool] = {}
  let extra_candidates : Array[UInt] = Array::make(
    extra_glyph_names.length(),
    0U,
  )
  let extra_states : Array[Int] = Array::make(extra_glyph_names.length(), 0)
  for i, name in glyph_names {
    let glyph_index = i.reinterpret_as_uint()
    match extra_glyph_index(name) {
      Some(idx) =>
        if extra_states[idx] == 0 {
          extra_states[idx] = 1
          extra_candidates[idx] = glyph_index
        }
      None => ()
    }
    let unicode = unicode_value(name)
    let charcode = unicode & 0x7FFFFFFFU
    let is_variant = (unicode & VARIANT_BIT) != 0U
    if charcode != 0U {
      disable_extra_alias(charcode, extra_states)
      insert_unicode_mapping(
        unicode_cmap, unicode_is_variant, charcode, glyph_index, is_variant,
      )
    }
  }
  for i in 0..<extra_glyph_names.length() {
    if extra_states[i] == 1 {
      let charcode = extra_glyph_unicodes[i]
      match unicode_cmap.get(charcode) {
        Some(_) => ()
        None => unicode_cmap[charcode] = extra_candidates[i]
      }
    }
  }
  unicode_cmap
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

///|
fn extra_glyph_index(name : String) -> Int? {
  for i in 0..<extra_glyph_names.length() {
    if extra_glyph_names[i] == name {
      return Some(i)
    }
  }
  None
}

///|
fn disable_extra_alias(charcode : UInt, extra_states : Array[Int]) -> Unit {
  for i in 0..<extra_glyph_unicodes.length() {
    if extra_glyph_unicodes[i] == charcode {
      extra_states[i] = 2
      return
    }
  }
}

///|
fn insert_unicode_mapping(
  unicode_cmap : Map[UInt, UInt],
  unicode_is_variant : Map[UInt, Bool],
  charcode : UInt,
  glyph_index : UInt,
  is_variant : Bool,
) -> Unit {
  match unicode_cmap.get(charcode) {
    Some(_) => {
      let existing_is_variant = match unicode_is_variant.get(charcode) {
        Some(flag) => flag
        None => false
      }
      if existing_is_variant && not(is_variant) {
        unicode_cmap[charcode] = glyph_index
        unicode_is_variant[charcode] = false
      }
    }
    None => {
      unicode_cmap[charcode] = glyph_index
      unicode_is_variant[charcode] = is_variant
    }
  }
}
