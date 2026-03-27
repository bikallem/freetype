///|
fn round_double_to_int(value : Double) -> Int {
  if value < 0.0 {
    (value - 0.5).to_int()
  } else {
    (value + 0.5).to_int()
  }
}

///|
fn double_to_fixed(value : Double) -> @fixed.Fixed {
  @fixed.Fixed::from_raw(round_double_to_int(value * 65536.0).to_int64())
}

///|
fn afm_pair_key(left : UInt, right : UInt) -> Int64 {
  (left.to_int().to_int64() << 32) | right.to_int().to_int64()
}

///|
fn is_ascii_space(byte : Byte) -> Bool {
  byte == b' ' || byte == b'\t' || byte == b'\r' || byte == b'\n'
}

///|
fn skip_ascii_space(data : Bytes, start : Int, end : Int) -> Int {
  let mut pos = start
  while pos < end && is_ascii_space(data[pos]) {
    pos += 1
  }
  pos
}

///|
fn read_ascii_token(data : Bytes, start : Int, end : Int) -> (String, Int) {
  let token_start = skip_ascii_space(data, start, end)
  let mut token_end = token_start
  while token_end < end && !is_ascii_space(data[token_end]) {
    token_end += 1
  }
  let buf = StringBuilder::new()
  for i in token_start..<token_end {
    buf.write_char(Int::unsafe_to_char(data[i].to_int()))
  }
  (buf.to_string(), token_end)
}

///|
fn parse_ascii_int(data : Bytes, start : Int, end : Int) -> Int? {
  let mut pos = skip_ascii_space(data, start, end)
  if pos >= end {
    return None
  }
  let mut sign = 1
  if data[pos] == b'-' {
    sign = -1
    pos += 1
  } else if data[pos] == b'+' {
    pos += 1
  }
  let mut value = 0
  let mut saw_digit = false
  while pos < end {
    let byte = data[pos]
    if byte < b'0' || byte > b'9' {
      break
    }
    saw_digit = true
    value = value * 10 + (byte.to_int() - b'0'.to_int())
    pos += 1
  }
  if saw_digit {
    Some(value * sign)
  } else {
    None
  }
}

///|
fn parse_afm_kerning_pairs(
  data : Bytes,
  name_to_index : Map[String, UInt],
) -> Map[Int64, Int] {
  let pairs : Map[Int64, Int] = {}
  let mut line_start = 0
  while line_start < data.length() {
    let mut line_end = line_start
    while line_end < data.length() &&
          data[line_end] != b'\n' &&
          data[line_end] != b'\r' {
      line_end += 1
    }
    if line_end - line_start >= 4 &&
      data[line_start] == b'K' &&
      data[line_start + 1] == b'P' &&
      data[line_start + 2] == b'X' &&
      data[line_start + 3] == b' ' {
      let (left_name, next0) = read_ascii_token(data, line_start + 4, line_end)
      let (right_name, next1) = read_ascii_token(data, next0, line_end)
      match parse_ascii_int(data, next1, line_end) {
        Some(value) =>
          match (name_to_index.get(left_name), name_to_index.get(right_name)) {
            (Some(left), Some(right)) =>
              pairs[afm_pair_key(left, right)] = value
            _ => ()
          }
        None => ()
      }
    }
    line_start = line_end
    if line_start < data.length() && data[line_start] == b'\r' {
      line_start += 1
    }
    if line_start < data.length() && data[line_start] == b'\n' {
      line_start += 1
    }
  }
  pairs
}

///|
fn read_u16_le(data : Bytes, offset : Int) -> Int? {
  if offset < 0 || offset + 1 >= data.length() {
    None
  } else {
    Some(data[offset].to_int() | (data[offset + 1].to_int() << 8))
  }
}

///|
fn read_u32_le(data : Bytes, offset : Int) -> Int? {
  if offset < 0 || offset + 3 >= data.length() {
    None
  } else {
    Some(
      data[offset].to_int() |
      (data[offset + 1].to_int() << 8) |
      (data[offset + 2].to_int() << 16) |
      (data[offset + 3].to_int() << 24),
    )
  }
}

///|
fn read_i16_le(data : Bytes, offset : Int) -> Int? {
  match read_u16_le(data, offset) {
    Some(value) => Some(if value >= 0x8000 { value - 0x10000 } else { value })
    None => None
  }
}

///|
fn looks_like_pfm_metrics(data : Bytes) -> Bool {
  if data.length() <= 6 || data[1] >= b'\x04' {
    return false
  }
  match read_u32_le(data, 2) {
    Some(size) => size == data.length()
    None => false
  }
}

///|
fn parse_pfm_kerning_pairs(
  data : Bytes,
  char_index_for_code : (UInt) -> UInt,
) -> Map[Int64, Int] raise @error.FTError {
  let width_table_length = match read_u16_le(data, 99) {
    Some(value) => value
    None => raise @error.FTError::InvalidFileFormat
  }
  let extension_offset = 99 + 2 + 18 + width_table_length
  match read_u16_le(data, extension_offset) {
    Some(size) if size >= 0x12 => ()
    Some(_) => return {}
    None => return {}
  }
  let kerning_offset = match read_u32_le(data, extension_offset + 14) {
    Some(value) => value
    None => raise @error.FTError::InvalidFileFormat
  }
  if kerning_offset == 0 {
    return {}
  }
  let pair_count = match read_u16_le(data, kerning_offset) {
    Some(value) => value
    None => raise @error.FTError::InvalidFileFormat
  }
  let pair_data_start = kerning_offset + 2
  if pair_data_start + pair_count * 4 > data.length() {
    raise @error.FTError::InvalidFileFormat
  }
  let pairs : Map[Int64, Int] = {}
  for pair_index in 0..<pair_count {
    let pos = pair_data_start + pair_index * 4
    let left = char_index_for_code(data[pos].to_uint())
    let right = char_index_for_code(data[pos + 1].to_uint())
    match read_i16_le(data, pos + 2) {
      Some(value) =>
        if left != 0U && right != 0U {
          pairs[afm_pair_key(left, right)] = value
        }
      None => raise @error.FTError::InvalidFileFormat
    }
  }
  pairs
}

///|
fn normalize_mm_design_coord(
  value : @fixed.Fixed,
  min_value : @fixed.Fixed,
  default_value : @fixed.Fixed,
  max_value : @fixed.Fixed,
) -> Int {
  if value.val() == default_value.val() {
    return 0
  }
  if value.val() < default_value.val() {
    let denom = default_value.val() - min_value.val()
    if denom <= 0L {
      return -0x4000
    }
    let num = value.val() - default_value.val()
    let scaled = (num * 0x4000L / denom).max(-0x4000L)
    scaled.to_int()
  } else {
    let denom = max_value.val() - default_value.val()
    if denom <= 0L {
      return 0x4000
    }
    let num = value.val() - default_value.val()
    let scaled = (num * 0x4000L / denom).min(0x4000L)
    scaled.to_int()
  }
}

///|
fn type1_font_transform(
  font_matrix : Array[Double],
) -> (@fixed.Matrix, Int64, Int64) {
  if font_matrix.length() < 6 {
    return (@fixed.Matrix::identity(), 0L, 0L)
  }
  let scale = if font_matrix[3] < 0.0 {
    -font_matrix[3]
  } else {
    font_matrix[3]
  }
  if scale <= 0.0 {
    return (@fixed.Matrix::identity(), 0L, 0L)
  }
  let yy = if font_matrix[3] < 0.0 { -1.0 } else { 1.0 }
  (
    @fixed.Matrix::new(
      double_to_fixed(font_matrix[0] / scale),
      double_to_fixed(font_matrix[2] / scale),
      double_to_fixed(font_matrix[1] / scale),
      double_to_fixed(yy),
    ),
    (font_matrix[4] / scale).to_int().to_int64(),
    (font_matrix[5] / scale).to_int().to_int64(),
  )
}

///|
/// Load a Type 1 PFB font.
fn load_type1_pfb(data : Bytes) -> @base.FaceRec raise @error.FTError {
  let font = @type1.parse_type1_pfb(data)
  let face = @base.FaceRec::new()
  let (font_transform, font_offset_x, font_offset_y) = type1_font_transform(
    font.font_matrix(),
  )
  let family_name = font.family_name()
  face.set_family_name(
    if family_name != "" {
      family_name
    } else {
      font.font_name()
    },
  )
  face.set_face_flags(
    @base.FACE_FLAG_SCALABLE |
    @base.FACE_FLAG_HORIZONTAL |
    @base.FACE_FLAG_GLYPH_NAMES |
    @base.FACE_FLAG_HINTER,
  )
  face.set_num_glyphs(font.charstrings().length().to_int64())
  face.set_units_per_em(font.units_per_em().reinterpret_as_uint())
  if font.font_bbox().length() == 4 {
    face.set_bbox(
      @types.BBox::new(
        font.font_bbox()[0].to_int64(),
        font.font_bbox()[1].to_int64(),
        font.font_bbox()[2].to_int64(),
        font.font_bbox()[3].to_int64(),
      ),
    )
    face.set_ascender(font.font_bbox()[3])
    face.set_descender(font.font_bbox()[1])
  }
  let bbox_height = face.ascender() - face.descender()
  let default_height = font.units_per_em() * 12 / 10
  face.set_height(
    if default_height > bbox_height {
      default_height
    } else {
      bbox_height
    },
  )
  face.set_underline_position(font.underline_position())
  face.set_underline_thickness(font.underline_thickness())
  let glyph_names = if font.glyph_order().length() > 0 {
    font.glyph_order()
  } else {
    font.charstrings().keys().collect()
  }
  let mut notdef_index : Int? = None
  for i, name in glyph_names {
    if name == ".notdef" {
      notdef_index = Some(i)
      break
    }
  }
  if glyph_names.length() > 1 {
    match notdef_index {
      Some(idx) if idx != 0 => {
        let first = glyph_names[0]
        glyph_names[0] = glyph_names[idx]
        glyph_names[idx] = first
      }
      _ => ()
    }
  }
  face.set_num_glyphs(glyph_names.length().to_int64())
  // Build glyph name list for index lookup
  // Build O(1) name-to-index map
  let name_to_index : Map[String, UInt] = {}
  for i, name in glyph_names {
    name_to_index[name] = i.reinterpret_as_uint()
  }
  let attached_kerning : Ref[Map[Int64, Int]] = Ref::new({})
  // Build Unicode charmap from glyph names when possible.
  let unicode_cmap = @psnames.build_unicode_map(glyph_names)
  // Pre-compute charcode -> glyph_index cache (256 entries)
  let cached_cmap : FixedArray[UInt] = FixedArray::make(256, 0U)
  let enc = font.encoding()
  for code in 0..<256 {
    let glyph_name = enc[code]
    if glyph_name != ".notdef" {
      match name_to_index.get(glyph_name) {
        Some(idx) => cached_cmap[code] = idx
        None => ()
      }
    }
  }
  let has_unicode = !unicode_cmap.is_empty()
  if has_unicode {
    face.charmaps().push(@base.CharMapRec::new(@base.Encoding::Unicode, 3U, 1U))
  }
  let encoding_charmap = if font.custom_encoding() {
    @base.CharMapRec::new(@base.Encoding::AdobeCustom, 7U, 2U)
  } else if font.expert_encoding() {
    @base.CharMapRec::new(@base.Encoding::AdobeExpert, 7U, 1U)
  } else if font.latin1_encoding() {
    @base.CharMapRec::new(@base.Encoding::AdobeLatin1, 7U, 3U)
  } else {
    @base.CharMapRec::new(@base.Encoding::AdobeStandard, 7U, 0U)
  }
  face.charmaps().push(encoding_charmap)
  if face.charmaps().length() > 0 {
    face.set_active_charmap(0)
  }
  if font.multiple_master() && font.mm_axis_tags().length() > 0 {
    face.set_face_flags(face.face_flags() | @base.FACE_FLAG_MULTIPLE_MASTERS)
    face.set_var_coords(Array::make(font.mm_axis_tags().length(), 0))
  }
  // Set up Type1Ops driver data. Public API uses the active charmap, which we
  // synthesize as Unicode when glyph names allow it.
  let unicode_char_index_fn : (UInt) -> UInt = fn(charcode) {
    match unicode_cmap.get(charcode) {
      Some(gid) => gid
      None => 0U
    }
  }
  let encoding_char_index_fn : (UInt) -> UInt = fn(charcode) {
    if charcode >= 256U {
      return 0U
    }
    cached_cmap.unsafe_get(charcode.reinterpret_as_int())
  }
  let unicode_charmap_index = if has_unicode { 0 } else { -1 }
  let encoding_charmap_index = if has_unicode { 1 } else { 0 }
  let char_index_fn : (UInt) -> UInt = fn(charcode) {
    if face.active_charmap() == encoding_charmap_index {
      return encoding_char_index_fn(charcode)
    }
    if face.active_charmap() == unicode_charmap_index && has_unicode {
      return unicode_char_index_fn(charcode)
    }
    if has_unicode {
      unicode_char_index_fn(charcode)
    } else {
      encoding_char_index_fn(charcode)
    }
  }
  let hint_h_hints : Ref[Array[@psaux.StemHint]] = Ref::new([])
  let hint_v_hints : Ref[Array[@psaux.StemHint]] = Ref::new([])
  let hint_has_hints : Ref[Bool] = Ref::new(false)
  let hint_globals_ref : Ref[@pshinter.PsGlobals?] = Ref::new(None)
  let ensure_hint_globals = fn() -> @pshinter.PsGlobals {
    match hint_globals_ref.val {
      Some(g) => g
      None => {
        let defaults = @pshinter.PsGlobals::new()
        let g = @pshinter.build_ps_globals(
          font.blue_values(),
          font.other_blues(),
          font.std_hw(),
          font.std_vw(),
          defaults.blue_scale(),
          defaults.blue_shift().to_int(),
          defaults.blue_fuzz().to_int(),
        )
        hint_globals_ref.val = Some(g)
        g
      }
    }
  }
  let load_glyph_fn : (UInt, Int) -> (@base.GlyphSlotData, @types.Outline) raise @error.FTError = fn(
    glyph_index,
    load_flags,
  ) raise @error.FTError {
    let idx = glyph_index.reinterpret_as_int()
    if idx < 0 || idx >= glyph_names.length() {
      raise @error.FTError::InvalidGlyphIndex
    }
    let name = glyph_names[idx]
    let no_hinting = (load_flags & @base.LOAD_NO_HINTING) != 0
    let (outline, raw_width, hh, hv) = @type1.load_type1_glyph_full_data(
      font,
      name,
      normalized_coords=face.var_coords(),
    )
    let has_transform = font_transform.xx().val() != 0x10000L ||
      font_transform.xy().val() != 0L ||
      font_transform.yx().val() != 0L ||
      font_transform.yy().val() != 0x10000L
    if has_transform {
      @base.outline_transform(outline, font_transform)
    }
    if font_offset_x != 0L || font_offset_y != 0L {
      @base.outline_translate(outline, font_offset_x, font_offset_y)
    }
    let width = @fixed.mul_div(raw_width, font_transform.xx().val(), 0x10000L) +
      font_offset_x
    if no_hinting {
      hint_has_hints.val = false
    } else {
      hint_h_hints.val = hh
      hint_v_hints.val = hv
      hint_has_hints.val = hh.length() > 0 || hv.length() > 0
    }
    let bb = @base.outline_get_bbox(outline)
    let slot_data = @base.GlyphSlotData::new(
      bb.x_max() - bb.x_min(),
      bb.y_max() - bb.y_min(),
      bb.x_min(),
      bb.y_max(),
      width,
    )
    (slot_data, outline)
  }
  let apply_hints_fn : (@types.Outline, @fixed.Fixed) -> Bool = fn(
    outline,
    y_scale,
  ) {
    if hint_has_hints.val {
      let globals = ensure_hint_globals()
      @pshinter.hint_outline(
        outline,
        hint_h_hints.val,
        hint_v_hints.val,
        globals,
        y_scale,
      )
      hint_has_hints.val = false
      true
    } else {
      false
    }
  }
  face.set_char_index_fn(char_index_fn)
  face.set_driver_data(
    @base.DriverData::Type1Ops(
      @base.Type1Ops::new(
        char_index=encoding_char_index_fn,
        load_glyph=load_glyph_fn,
        apply_hints=apply_hints_fn,
        get_kerning=fn(left, right) {
          match attached_kerning.val.get(afm_pair_key(left, right)) {
            Some(value) => value
            None => 0
          }
        },
        set_var_design_coordinates=coordinates => {
          if !font.multiple_master() || font.mm_axis_tags().length() == 0 {
            raise @error.FTError::InvalidArgument
          }
          let normalized : Array[Int] = []
          let mut has_non_default = false
          for axis_index, axis_tag in font.mm_axis_tags() {
            let mut design_value = font.mm_axis_defaults()[axis_index]
            for _, coordinate in coordinates {
              let (coord_value, tag) = coordinate
              if tag == axis_tag {
                design_value = coord_value
                break
              }
            }
            let norm = normalize_mm_design_coord(
              design_value,
              font.mm_axis_mins()[axis_index],
              font.mm_axis_defaults()[axis_index],
              font.mm_axis_maxs()[axis_index],
            )
            normalized.push(norm)
            if norm != 0 {
              has_non_default = true
            }
          }
          face.set_var_coords(normalized)
          let base_flags = if (face.face_flags() & @base.FACE_FLAG_VARIATION) !=
            0L {
            face.face_flags() - @base.FACE_FLAG_VARIATION
          } else {
            face.face_flags()
          }
          face.set_face_flags(
            if has_non_default {
              base_flags | @base.FACE_FLAG_VARIATION
            } else {
              base_flags
            },
          )
        },
        attach_metrics=metrics_data => {
          let parsed_pairs = parse_afm_kerning_pairs(
            metrics_data, name_to_index,
          )
          let final_pairs = if !parsed_pairs.is_empty() {
            parsed_pairs
          } else if looks_like_pfm_metrics(metrics_data) {
            parse_pfm_kerning_pairs(metrics_data, encoding_char_index_fn)
          } else {
            {}
          }
          if parsed_pairs.is_empty() &&
            final_pairs.is_empty() &&
            !looks_like_pfm_metrics(metrics_data) {
            raise @error.FTError::InvalidFileFormat
          }
          let merged = attached_kerning.val
          for pair, value in final_pairs {
            merged[pair] = value
          }
          attached_kerning.val = merged
          if !final_pairs.is_empty() {
            face.set_face_flags(face.face_flags() | @base.FACE_FLAG_KERNING)
          }
        },
      ),
    ),
  )
  face
}
