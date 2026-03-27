///|
/// Type 1 font driver — parsing and glyph loading for Adobe Type 1 (PFB) fonts.
/// Ported from FreeType's type1 module.

///|
/// Type 1 font representation.
struct Type1Font {
  mut font_name : String
  mut family_name : String
  mut units_per_em : Int // default 1000 for Type 1
  mut encoding : Array[String] // glyph name per encoding slot (256 entries)
  mut custom_encoding : Bool
  mut expert_encoding : Bool
  mut latin1_encoding : Bool
  mut charstrings : Map[String, Bytes] // glyph_name -> charstring data
  mut glyph_order : Array[String] // glyph order as stored in /CharStrings
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
  mut font_matrix : Array[Double] // FontMatrix (6 elements)
  mut font_bbox : Array[Int] // FontBBox [llx lly urx ury]
  mut underline_position : Int
  mut underline_thickness : Int
  unique_id : Int // UniqueID
  mut multiple_master : Bool
  mut mm_axis_tags : Array[UInt]
  mut mm_axis_mins : Array[@fixed.Fixed]
  mut mm_axis_defaults : Array[@fixed.Fixed]
  mut mm_axis_maxs : Array[@fixed.Fixed]
  mut mm_design_maps : Array[Type1MMDesignMap]
  mut mm_default_weights : Array[@fixed.Fixed]
  mut buildchar_len : Int
} derive(Show)

///|
struct Type1MMDesignMap {
  design_points : Array[Int]
  blend_points : Array[@fixed.Fixed]
} derive(Show)

///|
/// Create a new empty Type1Font.
pub fn Type1Font::new() -> Type1Font {
  {
    font_name: "",
    family_name: "",
    units_per_em: 1000,
    encoding: [],
    custom_encoding: false,
    expert_encoding: false,
    latin1_encoding: false,
    charstrings: {},
    glyph_order: [],
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
    underline_position: 0,
    underline_thickness: 0,
    unique_id: 0,
    multiple_master: false,
    mm_axis_tags: [],
    mm_axis_mins: [],
    mm_axis_defaults: [],
    mm_axis_maxs: [],
    mm_design_maps: [],
    mm_default_weights: [],
    buildchar_len: 0,
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
    font.family_name = extract_family_name(ascii_parts[0])
    font.font_matrix = extract_font_matrix(ascii_parts[0])
    font.font_bbox = extract_font_bbox(ascii_parts[0])
    font.underline_position = extract_named_int(
      ascii_parts[0],
      "UnderlinePosition",
    )
    font.underline_thickness = extract_named_int(
      ascii_parts[0],
      "UnderlineThickness",
    )
    // Parse encoding from ASCII segment
    let (encoding, custom_encoding, expert_encoding, latin1_encoding) = parse_encoding(
      ascii_parts[0],
    )
    font.encoding = encoding
    font.custom_encoding = custom_encoding
    font.expert_encoding = expert_encoding
    font.latin1_encoding = latin1_encoding
    apply_multiple_master_metadata(font, ascii_parts[0])
    font.buildchar_len = extract_buildchar_len(ascii_parts[0])
  }
  // Decrypt binary segment (eexec encrypted private dict + charstrings)
  if binary_parts.length() > 0 {
    let decrypted = eexec_decrypt(binary_parts[0])
    // Parse /lenIV from decrypted data
    font.len_iv = extract_len_iv(decrypted)
    // Parse /CharStrings dict from decrypted data
    let (charstrings, glyph_order) = extract_charstrings(decrypted)
    font.charstrings = charstrings
    font.glyph_order = glyph_order
  }
  font.units_per_em = units_per_em_from_font_matrix(font.font_matrix)
  font
}

///|
/// Parse a PFA (ASCII) Type 1 font.
/// The entire file is ASCII; the eexec section is hex-encoded.
fn parse_type1_pfa(data : Bytes) -> Type1Font {
  let font = Type1Font::new()
  // The whole file is ASCII
  font.font_name = extract_font_name(data)
  font.family_name = extract_family_name(data)
  font.font_matrix = extract_font_matrix(data)
  font.font_bbox = extract_font_bbox(data)
  font.underline_position = extract_named_int(data, "UnderlinePosition")
  font.underline_thickness = extract_named_int(data, "UnderlineThickness")
  let (encoding, custom_encoding, expert_encoding, latin1_encoding) = parse_encoding(
    data,
  )
  font.encoding = encoding
  font.custom_encoding = custom_encoding
  font.expert_encoding = expert_encoding
  font.latin1_encoding = latin1_encoding
  apply_multiple_master_metadata(font, data)
  font.buildchar_len = extract_buildchar_len(data)
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
    let binary_data = if binary.length() > 0 {
      Bytes::from_array(binary[:])
    } else {
      // Some real-world Type 1 files ship an ASCII prolog followed by raw
      // binary eexec data without the 0x80 PFB segment headers.
      data[eexec_pos:text_len].to_bytes()
    }
    let decrypted = eexec_decrypt(binary_data)
    font.len_iv = extract_len_iv(decrypted)
    let (charstrings, glyph_order) = extract_charstrings(decrypted)
    font.charstrings = charstrings
    font.glyph_order = glyph_order
  }
  font.units_per_em = units_per_em_from_font_matrix(font.font_matrix)
  font
}

///|
fn axis_tag_from_type1_name(name : String) -> UInt {
  match name {
    "Weight" => @types.make_tag(b'w', b'g', b'h', b't')
    "Width" => @types.make_tag(b'w', b'd', b't', b'h')
    "OpticalSize" => @types.make_tag(b'o', b'p', b's', b'z')
    "Slant" => @types.make_tag(b's', b'l', b'n', b't')
    _ =>
      if name.length() >= 4 {
        @types.make_tag(
          name[0].to_byte(),
          name[1].to_byte(),
          name[2].to_byte(),
          name[3].to_byte(),
        )
      } else {
        0U
      }
  }
}

///|
fn fixed_from_double(value : Double) -> @fixed.Fixed {
  @fixed.Fixed::from_raw(
    if value < 0.0 {
      (value * 65536.0 - 0.5).to_int().to_int64()
    } else {
      (value * 65536.0 + 0.5).to_int().to_int64()
    },
  )
}

///|
fn type1_mm_map_from_parts(
  design_points : Array[Int],
  blend_points : Array[@fixed.Fixed],
) -> Type1MMDesignMap {
  { design_points, blend_points }
}

///|
fn extract_blend_design_map(ascii_data : Bytes) -> Array[Type1MMDesignMap] {
  let start = find_ps_array_start(ascii_data, b"/BlendDesignMap")
  if start < 0 {
    return []
  }
  let maps : Array[Type1MMDesignMap] = []
  let mut pos = start + 1
  while pos < ascii_data.length() {
    pos = skip_ascii_ws(ascii_data, pos)
    if pos >= ascii_data.length() || ascii_data[pos] == b']' {
      break
    }
    if ascii_data[pos] != b'[' {
      pos += 1
      continue
    }
    pos += 1
    let design_points : Array[Int] = []
    let blend_points : Array[@fixed.Fixed] = []
    let mut pending_design : Int? = None
    while pos < ascii_data.length() {
      pos = skip_ascii_ws(ascii_data, pos)
      if pos >= ascii_data.length() || ascii_data[pos] == b']' {
        break
      }
      if ascii_data[pos] == b'[' {
        pos += 1
        let (design_value, next_pos0, ok_design) = read_ps_number_token(
          ascii_data, pos,
        )
        let (blend_value, next_pos1, ok_blend) = read_ps_number_token(
          ascii_data, next_pos0,
        )
        let mut pair_end = next_pos1
        while pair_end < ascii_data.length() && ascii_data[pair_end] != b']' {
          pair_end += 1
        }
        if pair_end < ascii_data.length() && ascii_data[pair_end] == b']' {
          pair_end += 1
        }
        pos = pair_end
        if ok_design && ok_blend {
          design_points.push(round_double_to_int_local(design_value))
          blend_points.push(fixed_from_double(blend_value))
        }
        pending_design = None
        continue
      }
      let (value, next_pos, ok) = read_ps_number_token(ascii_data, pos)
      if !ok {
        break
      }
      pos = next_pos
      match pending_design {
        None => pending_design = Some(round_double_to_int_local(value))
        Some(design_value) => {
          design_points.push(design_value)
          blend_points.push(fixed_from_double(value))
          pending_design = None
        }
      }
    }
    if pos < ascii_data.length() && ascii_data[pos] == b']' {
      pos += 1
    }
    if !design_points.is_empty() &&
      design_points.length() == blend_points.length() {
      maps.push(type1_mm_map_from_parts(design_points, blend_points))
    }
  }
  maps
}

///|
fn skip_ascii_ws(data : Bytes, start : Int) -> Int {
  let mut pos = start
  while pos < data.length() &&
        (
          data[pos] == b' ' ||
          data[pos] == b'\t' ||
          data[pos] == b'\n' ||
          data[pos] == b'\r'
        ) {
    pos += 1
  }
  pos
}

///|
fn find_ps_array_start(data : Bytes, key : Bytes) -> Int {
  let pos = bytes_find(data, data.length(), key)
  if pos < 0 {
    return -1
  }
  let array_pos = skip_ascii_ws(data, pos + key.length())
  if array_pos < data.length() && data[array_pos] == b'[' {
    array_pos
  } else {
    -1
  }
}

///|
fn read_ps_name_token(data : Bytes, start : Int) -> (String, Int) {
  let mut pos = skip_ascii_ws(data, start)
  if pos < data.length() && data[pos] == b'/' {
    pos += 1
  }
  let begin = pos
  while pos < data.length() &&
        data[pos] != b' ' &&
        data[pos] != b'\t' &&
        data[pos] != b'\n' &&
        data[pos] != b'\r' &&
        data[pos] != b'[' &&
        data[pos] != b']' {
    pos += 1
  }
  let buf = StringBuilder::new()
  for i in begin..<pos {
    buf.write_char(Int::unsafe_to_char(data[i].to_int()))
  }
  (buf.to_string(), pos)
}

///|
fn extract_buildchar_len(ascii_data : Bytes) -> Int {
  let start = find_ps_array_start(ascii_data, b"/BuildCharArray")
  if start < 0 {
    return 0
  }
  let mut count = 0
  let mut pos = start + 1
  while pos < ascii_data.length() {
    pos = skip_ascii_ws(ascii_data, pos)
    if pos >= ascii_data.length() || ascii_data[pos] == b']' {
      break
    }
    let (_value, next_pos, ok) = read_ps_number_token(ascii_data, pos)
    if !ok {
      break
    }
    count += 1
    pos = next_pos
  }
  count
}

///|
fn read_ps_number_token(data : Bytes, start : Int) -> (Double, Int, Bool) {
  let pos0 = skip_ascii_ws(data, start)
  if pos0 >= data.length() {
    return (0.0, pos0, false)
  }
  let mut pos = pos0
  if data[pos] == b'+' || data[pos] == b'-' {
    pos += 1
  }
  let begin = pos0
  let mut saw = false
  while pos < data.length() &&
        ((data[pos] >= b'0' && data[pos] <= b'9') || data[pos] == b'.') {
    pos += 1
    saw = true
  }
  if !saw {
    return (0.0, pos0, false)
  }
  let buf = StringBuilder::new()
  for i in begin..<pos {
    buf.write_char(Int::unsafe_to_char(data[i].to_int()))
  }
  let value = @string.parse_double(buf.to_string()) catch { _ => 0.0 }
  (value, pos, true)
}

///|
fn extract_axis_types(ascii_data : Bytes) -> Array[UInt] {
  let start = find_ps_array_start(ascii_data, b"/BlendAxisTypes")
  if start < 0 {
    return []
  }
  let out : Array[UInt] = []
  let mut pos = start + 1
  while pos < ascii_data.length() {
    pos = skip_ascii_ws(ascii_data, pos)
    if pos >= ascii_data.length() || ascii_data[pos] == b']' {
      break
    }
    let (name, next_pos) = read_ps_name_token(ascii_data, pos)
    if name != "" {
      out.push(axis_tag_from_type1_name(name))
    }
    pos = next_pos
  }
  out
}

///|
fn extract_blend_design_positions(ascii_data : Bytes) -> Array[Array[Double]] {
  let start = find_ps_array_start(ascii_data, b"/BlendDesignPositions")
  if start < 0 {
    return []
  }
  let masters : Array[Array[Double]] = []
  let mut pos = start + 1
  while pos < ascii_data.length() {
    pos = skip_ascii_ws(ascii_data, pos)
    if pos >= ascii_data.length() || ascii_data[pos] == b']' {
      break
    }
    if ascii_data[pos] != b'[' {
      pos += 1
      continue
    }
    pos += 1
    let coords : Array[Double] = []
    while pos < ascii_data.length() {
      pos = skip_ascii_ws(ascii_data, pos)
      if pos >= ascii_data.length() || ascii_data[pos] == b']' {
        break
      }
      let (value, next_pos, ok) = read_ps_number_token(ascii_data, pos)
      if !ok {
        break
      }
      coords.push(value)
      pos = next_pos
    }
    if pos < ascii_data.length() && ascii_data[pos] == b']' {
      pos += 1
    }
    if !coords.is_empty() {
      masters.push(coords)
    }
  }
  masters
}

///|
fn extract_weight_vector(ascii_data : Bytes) -> Array[Double] {
  let start = find_ps_array_start(ascii_data, b"/WeightVector")
  if start < 0 {
    return []
  }
  let values : Array[Double] = []
  let mut pos = start + 1
  while pos < ascii_data.length() {
    pos = skip_ascii_ws(ascii_data, pos)
    if pos >= ascii_data.length() || ascii_data[pos] == b']' {
      break
    }
    let (value, next_pos, ok) = read_ps_number_token(ascii_data, pos)
    if !ok {
      break
    }
    values.push(value)
    pos = next_pos
  }
  values
}

///|
fn apply_multiple_master_metadata(font : Type1Font, ascii_data : Bytes) -> Unit {
  let axis_tags = extract_axis_types(ascii_data)
  let design_positions = extract_blend_design_positions(ascii_data)
  let design_maps = extract_blend_design_map(ascii_data)
  let weight_vector = extract_weight_vector(ascii_data)
  if axis_tags.is_empty() ||
    design_positions.is_empty() ||
    design_maps.length() != axis_tags.length() ||
    weight_vector.length() != design_positions.length() {
    return
  }
  let axis_count = axis_tags.length()
  let mins : Array[Double] = Array::make(axis_count, 0.0)
  let maxs : Array[Double] = Array::make(axis_count, 0.0)
  let defaults : Array[Double] = Array::make(axis_count, 0.0)
  let mut total_weight = 0.0
  for axis in 0..<axis_count {
    mins[axis] = if axis < design_positions[0].length() {
      design_positions[0][axis]
    } else {
      0.0
    }
    maxs[axis] = mins[axis]
  }
  for master_index, master in design_positions {
    let weight = if master_index < weight_vector.length() {
      weight_vector[master_index]
    } else {
      1.0
    }
    total_weight += weight
    for axis in 0..<axis_count {
      let value = if axis < master.length() { master[axis] } else { 0.0 }
      if master_index == 0 || value < mins[axis] {
        mins[axis] = value
      }
      if master_index == 0 || value > maxs[axis] {
        maxs[axis] = value
      }
      defaults[axis] = defaults[axis] + value * weight
    }
  }
  let denom = if total_weight == 0.0 {
    design_positions.length().to_double()
  } else {
    total_weight
  }
  let axis_mins : Array[@fixed.Fixed] = []
  let axis_defaults : Array[@fixed.Fixed] = []
  let axis_maxs : Array[@fixed.Fixed] = []
  let default_weights : Array[@fixed.Fixed] = []
  for axis in 0..<axis_count {
    axis_mins.push(fixed_from_double(mins[axis]))
    axis_defaults.push(fixed_from_double(defaults[axis] / denom))
    axis_maxs.push(fixed_from_double(maxs[axis]))
  }
  for weight in weight_vector {
    default_weights.push(fixed_from_double(weight))
  }
  font.multiple_master = true
  font.mm_axis_tags = axis_tags
  font.mm_axis_mins = axis_mins
  font.mm_axis_defaults = axis_defaults
  font.mm_axis_maxs = axis_maxs
  font.mm_design_maps = design_maps
  font.mm_default_weights = default_weights
}

///|
fn round_double_to_int_local(value : Double) -> Int {
  if value < 0.0 {
    (value - 0.5).to_int()
  } else {
    (value + 0.5).to_int()
  }
}

///|
fn design_coord_from_normalized(
  norm : Int,
  min_value : @fixed.Fixed,
  default_value : @fixed.Fixed,
  max_value : @fixed.Fixed,
) -> @fixed.Fixed {
  let raw_norm = norm.to_int64()
  let raw = if raw_norm < 0L {
    default_value.val() +
    @fixed.mul_div(raw_norm, default_value.val() - min_value.val(), 0x4000L)
  } else {
    default_value.val() +
    @fixed.mul_div(raw_norm, max_value.val() - default_value.val(), 0x4000L)
  }
  @fixed.Fixed::from_raw(raw)
}

///|
fn design_coord_to_blend(
  design_map : Type1MMDesignMap,
  design_value : @fixed.Fixed,
) -> Int64 {
  if design_map.design_points.is_empty() || design_map.blend_points.is_empty() {
    return 0L
  }
  let design = design_value.to_int()
  let last = design_map.design_points.length() - 1
  if design <= design_map.design_points[0] {
    return design_map.blend_points[0].val()
  }
  for i in 1..<=last {
    let point = design_map.design_points[i]
    if design <= point {
      let prev_design = design_map.design_points[i - 1]
      let prev_blend = design_map.blend_points[i - 1].val()
      let curr_blend = design_map.blend_points[i].val()
      let denom = (point - prev_design).to_int64()
      if denom == 0L {
        return curr_blend
      }
      return prev_blend +
        @fixed.mul_div(
          (design - prev_design).to_int64(),
          curr_blend - prev_blend,
          denom,
        )
    }
  }
  design_map.blend_points[last].val()
}

///|
fn mm_weight_vector_for_normalized_coords(
  font : Type1Font,
  normalized_coords : Array[Int],
) -> Array[Int64] {
  if !font.multiple_master ||
    font.mm_axis_tags.is_empty() ||
    font.mm_default_weights.is_empty() ||
    font.mm_design_maps.length() != font.mm_axis_tags.length() {
    return []
  }
  let axis_blends : Array[Int64] = []
  for axis_index in 0..<font.mm_axis_tags.length() {
    let design_value = if axis_index < normalized_coords.length() {
      design_coord_from_normalized(
        normalized_coords[axis_index],
        font.mm_axis_mins[axis_index],
        font.mm_axis_defaults[axis_index],
        font.mm_axis_maxs[axis_index],
      )
    } else {
      font.mm_axis_defaults[axis_index]
    }
    let blend = design_coord_to_blend(
      font.mm_design_maps[axis_index],
      design_value,
    )
    axis_blends.push(blend.max(0L).min(0x10000L))
  }
  let weights : Array[Int64] = []
  for design_index in 0..<font.mm_default_weights.length() {
    let mut result = 0x10000L
    for axis_index in 0..<font.mm_axis_tags.length() {
      let mut factor = if axis_index < axis_blends.length() {
        axis_blends[axis_index]
      } else {
        0x8000L
      }
      if (design_index & (1 << axis_index)) == 0 {
        factor = 0x10000L - factor
      }
      if factor <= 0L {
        result = 0L
        break
      }
      if factor < 0x10000L {
        result = @fixed.mul_div(result, factor, 0x10000L)
      }
    }
    weights.push(result)
  }
  weights
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
/// Extract the family name from the ASCII segment of a Type 1 font.
fn extract_family_name(ascii_data : Bytes) -> String {
  // Look for /FamilyName (Name) pattern
  let len = ascii_data.length()
  for i = 0; i + 11 < len; {
    if ascii_data[i] == b'/' &&
      ascii_data[i + 1] == b'F' &&
      ascii_data[i + 2] == b'a' &&
      ascii_data[i + 3] == b'm' &&
      ascii_data[i + 4] == b'i' &&
      ascii_data[i + 5] == b'l' &&
      ascii_data[i + 6] == b'y' &&
      ascii_data[i + 7] == b'N' &&
      ascii_data[i + 8] == b'a' &&
      ascii_data[i + 9] == b'm' &&
      ascii_data[i + 10] == b'e' {
      let mut j = i + 11
      while j < len && (ascii_data[j] == b' ' || ascii_data[j] == b'\t') {
        j += 1
      }
      if j < len && ascii_data[j] == b'(' {
        j += 1
        let start = j
        while j < len && ascii_data[j] != b')' {
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
fn extract_named_int(ascii_data : Bytes, key : String) -> Int {
  let len = ascii_data.length()
  for i in 0..<(len - key.length()) {
    let mut match_ = true
    if ascii_data[i] != b'/' {
      continue
    }
    for j in 0..<key.length() {
      if ascii_data[i + 1 + j] != key[j].to_byte() {
        match_ = false
        break
      }
    }
    if match_ {
      let mut pos = i + key.length() + 1
      while pos < len && (ascii_data[pos] == b' ' || ascii_data[pos] == b'\t') {
        pos += 1
      }
      let mut sign = 1
      if pos < len && ascii_data[pos] == b'-' {
        sign = -1
        pos += 1
      }
      let mut value = 0
      while pos < len && ascii_data[pos] >= b'0' && ascii_data[pos] <= b'9' {
        value = value * 10 + (ascii_data[pos].to_int() - b'0'.to_int())
        pos += 1
      }
      return sign * value
    }
  }
  0
}

///|
fn extract_font_matrix(ascii_data : Bytes) -> Array[Double] {
  let len = ascii_data.length()
  for i in 0..<(len - 11) {
    if ascii_data[i] != b'/' {
      continue
    }
    let keyword = "FontMatrix"
    let mut match_ = true
    for j in 0..<keyword.length() {
      if ascii_data[i + 1 + j] != keyword[j].to_byte() {
        match_ = false
        break
      }
    }
    if !match_ {
      continue
    }
    let mut pos = i + 1 + keyword.length()
    while pos < len && (ascii_data[pos] == b' ' || ascii_data[pos] == b'\t') {
      pos += 1
    }
    if pos >= len || (ascii_data[pos] != b'[' && ascii_data[pos] != b'{') {
      continue
    }
    pos += 1
    let values : Array[Double] = []
    while pos < len && values.length() < 6 {
      while pos < len &&
            (
              ascii_data[pos] == b' ' ||
              ascii_data[pos] == b'\t' ||
              ascii_data[pos] == b'\n' ||
              ascii_data[pos] == b'\r'
            ) {
        pos += 1
      }
      if pos >= len || ascii_data[pos] == b']' || ascii_data[pos] == b'}' {
        break
      }
      let start = pos
      if ascii_data[pos] == b'+' || ascii_data[pos] == b'-' {
        pos += 1
      }
      while pos < len &&
            (
              (ascii_data[pos] >= b'0' && ascii_data[pos] <= b'9') ||
              ascii_data[pos] == b'.' ||
              ascii_data[pos] == b'e' ||
              ascii_data[pos] == b'E' ||
              ascii_data[pos] == b'+' ||
              ascii_data[pos] == b'-'
            ) {
        pos += 1
      }
      let buf = StringBuilder::new()
      for j in start..<pos {
        buf.write_char(Int::unsafe_to_char(ascii_data[j].to_int()))
      }
      let token = buf.to_string()
      let value = @string.parse_double(token) catch { _ => 0.0 }
      values.push(value)
    }
    if values.length() == 6 {
      return values
    }
    break
  }
  [0.001, 0.0, 0.0, 0.001, 0.0, 0.0]
}

///|
fn units_per_em_from_font_matrix(font_matrix : Array[Double]) -> Int {
  if font_matrix.length() < 4 {
    return 1000
  }
  let yy = font_matrix[3]
  let scale = (if yy < 0.0 { -yy } else { yy }) * 1000.0
  if scale <= 0.0 {
    1000
  } else {
    let upem = 1000.0 / scale
    if upem < 1.0 {
      1
    } else if upem < 32767.0 {
      if upem < 0.0 {
        (upem - 0.5).to_int()
      } else {
        (upem + 0.5).to_int()
      }
    } else {
      32767
    }
  }
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
/// Search for a byte pattern in a Bytes buffer starting from offset.
/// Returns the index of the first match, or -1 if not found.
fn bytes_find(data : Bytes, len : Int, pattern : Bytes, from? : Int = 0) -> Int {
  let plen = pattern.length()
  if plen == 0 || plen > len - from {
    return -1
  }
  let end = len - plen
  for i in from..<=end {
    let mut match_ = true
    for j in 0..<plen {
      if data[i + j] != pattern[j] {
        match_ = false
        break
      }
    }
    if match_ {
      return i
    }
  }
  -1
}

///|
/// Parse encoding from the ASCII segment.
/// Returns the decoded encoding array plus flags for custom, expert, and
/// ISOLatin1 encodings.
fn parse_encoding(ascii_data : Bytes) -> (Array[String], Bool, Bool, Bool) {
  let len = ascii_data.length()
  let encoding : Array[String] = Array::make(256, ".notdef")
  // Byte-level search for encoding keywords (no String conversion)
  let pat_std = b"StandardEncoding"
  let pat_expert = b"ExpertEncoding"
  let pat_latin1 = b"ISOLatin1Encoding"
  let pat_enc = b"/Encoding"
  let pat_enc256 = b"/Encoding 256 array"
  let has_std = bytes_find(ascii_data, len, pat_std) >= 0
  let has_expert = bytes_find(ascii_data, len, pat_expert) >= 0
  let has_latin1 = bytes_find(ascii_data, len, pat_latin1) >= 0
  let has_enc = bytes_find(ascii_data, len, pat_enc) >= 0
  let has_enc256 = bytes_find(ascii_data, len, pat_enc256) >= 0
  // Check for StandardEncoding
  if has_std && has_enc && !has_enc256 {
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
    return (encoding, false, false, false)
  }
  if has_expert && has_enc && !has_enc256 {
    for i in 0..<256 {
      let sid = @psnames.expert_encoding_sid(i.reinterpret_as_uint())
      if sid != 0 {
        match @psnames.standard_string(sid.reinterpret_as_uint()) {
          Some(name) => encoding[i] = name
          None => ()
        }
      }
    }
    return (encoding, false, true, false)
  }
  if has_latin1 && has_enc && !has_enc256 {
    for i in 0..<256 {
      match @psnames.latin1_name(i.reinterpret_as_uint()) {
        Some(name) => encoding[i] = name
        None => ()
      }
    }
    return (encoding, false, false, true)
  }
  // Look for custom encoding: "dup N /name put" entries
  // Search for "/Encoding" first
  let enc_pos = bytes_find(ascii_data, len, pat_enc)
  if enc_pos < 0 {
    return (encoding, false, false, false)
  }
  let start = enc_pos + pat_enc.length()
  let mut saw_custom_entry = false
  // Parse "dup N /name put" entries
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
          saw_custom_entry = true
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
  }
  (encoding, has_enc256 || saw_custom_entry, false, false)
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
fn extract_charstrings(data : Bytes) -> (Map[String, Bytes], Array[String]) {
  let charstrings : Map[String, Bytes] = {}
  let glyph_order : Array[String] = []
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
    return (charstrings, glyph_order)
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
    if !found_digit {
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
      glyph_order.push(name)
      pos += cs_len
    } else {
      break
    }
    // Skip rest of line (ND, noaccess def, |-, etc.)
    while pos < len && data[pos] != b'\n' && data[pos] != b'\r' {
      pos += 1
    }
  }
  (charstrings, glyph_order)
}

///|
/// Load a glyph from a Type 1 font by name.
/// Looks up the charstring, decrypts it, and executes it via the PS interpreter.
pub fn load_type1_glyph_full_data(
  font : Type1Font,
  glyph_name : String,
  allow_seac? : Bool = true,
  normalized_coords? : Array[Int] = [],
) -> (@types.Outline, Int64, Array[@psaux.StemHint], Array[@psaux.StemHint]) raise @error.FTError {
  let charstring = match font.charstrings.get(glyph_name) {
    Some(cs) => cs
    None => raise @error.FTError::InvalidGlyphIndex
  }
  let decrypted = charstring_decrypt(charstring, len_iv=font.len_iv)
  let mm_weight_vector = mm_weight_vector_for_normalized_coords(
    font, normalized_coords,
  )
  let load_seac_component : (String) -> (
    @types.Outline,
    Int64,
    Array[@psaux.StemHint],
    Array[@psaux.StemHint],
  ) raise @error.FTError = fn(component_name) raise @error.FTError {
    if !allow_seac {
      raise @error.FTError::SyntaxError
    }
    load_type1_glyph_full_data(
      font,
      component_name,
      allow_seac=false,
      normalized_coords~,
    )
  }
  @psaux.execute_type1(
    decrypted,
    font.subrs,
    font.default_width_x,
    load_seac_component,
    mm_weight_vector~,
    buildchar_len=font.buildchar_len,
  )
}

///|
/// Load a glyph from a Type 1 font by name.
/// Looks up the charstring, decrypts it, and executes it via the PS interpreter.
pub fn load_type1_glyph_data(
  font : Type1Font,
  glyph_name : String,
) -> (@types.Outline, Int64) raise @error.FTError {
  let (outline, width, _, _) = load_type1_glyph_full_data(font, glyph_name)
  (outline, width)
}

///|
/// Load a glyph from a Type 1 font by name.
/// Looks up the charstring, decrypts it, and executes it via the PS interpreter.
pub fn load_type1_glyph(
  font : Type1Font,
  glyph_name : String,
) -> @types.Outline raise @error.FTError {
  let (outline, _width) = load_type1_glyph_data(font, glyph_name)
  outline
}

///|
pub fn Type1Font::font_name(self : Type1Font) -> String {
  self.font_name
}

///|
pub fn Type1Font::family_name(self : Type1Font) -> String {
  self.family_name
}

///|
pub fn Type1Font::font_bbox(self : Type1Font) -> Array[Int] {
  self.font_bbox
}

///|

///|
pub fn Type1Font::charstrings(self : Type1Font) -> Map[String, Bytes] {
  self.charstrings
}

///|
pub fn Type1Font::glyph_order(self : Type1Font) -> Array[String] {
  self.glyph_order
}

///|
pub fn Type1Font::encoding(self : Type1Font) -> Array[String] {
  self.encoding
}

///|
pub fn Type1Font::custom_encoding(self : Type1Font) -> Bool {
  self.custom_encoding
}

///|
pub fn Type1Font::expert_encoding(self : Type1Font) -> Bool {
  self.expert_encoding
}

///|
pub fn Type1Font::latin1_encoding(self : Type1Font) -> Bool {
  self.latin1_encoding
}

///|
pub fn Type1Font::subrs(self : Type1Font) -> Array[Bytes] {
  self.subrs
}

///|
pub fn Type1Font::units_per_em(self : Type1Font) -> Int {
  self.units_per_em
}

///|
pub fn Type1Font::underline_position(self : Type1Font) -> Int {
  self.underline_position
}

///|
pub fn Type1Font::underline_thickness(self : Type1Font) -> Int {
  self.underline_thickness
}

///|
pub fn Type1Font::len_iv(self : Type1Font) -> Int {
  self.len_iv
}

///|
pub fn Type1Font::paint_type(self : Type1Font) -> Int {
  self.paint_type
}

///|
pub fn Type1Font::font_matrix(self : Type1Font) -> Array[Double] {
  self.font_matrix
}

///|
pub fn Type1Font::std_hw(self : Type1Font) -> Int {
  self.std_hw
}

///|
pub fn Type1Font::std_vw(self : Type1Font) -> Int {
  self.std_vw
}

///|
pub fn Type1Font::blue_values(self : Type1Font) -> Array[Int] {
  self.blue_values
}

///|
pub fn Type1Font::other_blues(self : Type1Font) -> Array[Int] {
  self.other_blues
}

///|
pub fn Type1Font::multiple_master(self : Type1Font) -> Bool {
  self.multiple_master
}

///|
pub fn Type1Font::mm_axis_tags(self : Type1Font) -> Array[UInt] {
  self.mm_axis_tags
}

///|
pub fn Type1Font::mm_axis_mins(self : Type1Font) -> Array[@fixed.Fixed] {
  self.mm_axis_mins
}

///|
pub fn Type1Font::mm_axis_defaults(self : Type1Font) -> Array[@fixed.Fixed] {
  self.mm_axis_defaults
}

///|
pub fn Type1Font::mm_axis_maxs(self : Type1Font) -> Array[@fixed.Fixed] {
  self.mm_axis_maxs
}

///|

///|
