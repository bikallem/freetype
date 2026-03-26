///|
fn ascii_lower_code(unit : UInt16) -> UInt16 {
  let code = unit.to_int()
  if code >= 'A'.to_int() && code <= 'Z'.to_int() {
    (code + 32).to_uint16()
  } else {
    unit
  }
}

///|
fn string_eq_ignore_ascii_case(left : String, right : String) -> Bool {
  if left.length() != right.length() {
    return false
  }
  for i in 0..<left.length() {
    if ascii_lower_code(left[i]) != ascii_lower_code(right[i]) {
      return false
    }
  }
  true
}

///|
fn string_starts_with_ignore_ascii_case(text : String, prefix : String) -> Bool {
  if prefix.length() > text.length() {
    return false
  }
  for i in 0..<prefix.length() {
    if ascii_lower_code(text[i]) != ascii_lower_code(prefix[i]) {
      return false
    }
  }
  true
}

///|
fn is_pcf_unicode(font : @pcf.PcfFont) -> Bool {
  let registry = match font.property_string("CHARSET_REGISTRY") {
    Some(value) => value
    None => return false
  }
  let encoding = font.property_string("CHARSET_ENCODING").unwrap_or("")
  if string_starts_with_ignore_ascii_case(registry, "iso") {
    let suffix = registry[3:].to_string()
    return string_eq_ignore_ascii_case(suffix, "10646") ||
      (
        string_eq_ignore_ascii_case(suffix, "8859") &&
        string_eq_ignore_ascii_case(encoding, "1")
      ) ||
      (
        string_eq_ignore_ascii_case(suffix, "646.1991") &&
        string_eq_ignore_ascii_case(encoding, "IRV")
      )
  }
  false
}

///|
fn pcf_pitch(width : Int, format : UInt) -> Int {
  match 1 << (format & 3U).reinterpret_as_int() {
    1 => (width + 7) >> 3
    2 => (width + 15) >> 4 << 1
    4 => (width + 31) >> 5 << 2
    8 => (width + 63) >> 6 << 3
    _ => 0
  }
}

///|
fn build_pcf_bitmap(
  metric : @pcf.PcfMetric,
  bitmap_data : Bytes,
  format : UInt,
) -> @types.Bitmap {
  let bitmap = @types.Bitmap::new()
  let width = metric.right_bearing() - metric.left_bearing()
  let rows = metric.ascent() + metric.descent()
  bitmap.set_rows(if rows > 0 { rows.reinterpret_as_uint() } else { 0U })
  bitmap.set_width(if width > 0 { width.reinterpret_as_uint() } else { 0U })
  bitmap.set_pitch(pcf_pitch(width, format))
  bitmap.set_buffer(bitmap_data)
  bitmap.set_num_grays(1U)
  bitmap.set_pixel_mode(@types.PixelMode::Mono)
  bitmap
}

///|
fn load_pcf(data : Bytes) -> @base.FaceRec raise @error.FTError {
  let font = @pcf.parse_pcf_font(data)
  let face = @base.FaceRec::new()
  let family_name = match font.property_string("FAMILY_NAME") {
    Some(name) if name != "" => name
    _ => extract_bdf_family_name(font.font_name())
  }
  face.set_family_name(family_name)
  let style_name = font.property_string("WEIGHT_NAME").unwrap_or("")
  if style_name != "" {
    face.set_style_name(style_name)
  }
  let mut max_width = 0
  let mut max_rows = 0
  let mut first_advance : Int? = None
  let mut fixed_width = true
  for raw_index in 0..<font.num_glyphs() {
    match font.metric(raw_index) {
      Some(metric) => {
        let width = metric.right_bearing() - metric.left_bearing()
        let rows = metric.ascent() + metric.descent()
        if metric.width() > max_width {
          max_width = metric.width()
        }
        if rows > max_rows {
          max_rows = rows
        }
        match first_advance {
          Some(advance) if advance != metric.width() => fixed_width = false
          None => first_advance = Some(metric.width())
          _ => ()
        }
        ignore(width)
      }
      None => ()
    }
  }
  let spacing = font.property_string("SPACING").unwrap_or("")
  if string_eq_ignore_ascii_case(spacing, "M") ||
    string_eq_ignore_ascii_case(spacing, "C") {
    fixed_width = true
  }
  let mut face_flags = @base.FACE_FLAG_FIXED_SIZES | @base.FACE_FLAG_HORIZONTAL
  if fixed_width {
    face_flags = face_flags | @base.FACE_FLAG_FIXED_WIDTH
  }
  face.set_face_flags(face_flags)
  face.set_num_glyphs((font.num_glyphs() + 1).to_int64())
  let font_ascent = font.property_int("FONT_ASCENT").unwrap_or(max_rows)
  let font_descent = font.property_int("FONT_DESCENT").unwrap_or(0)
  let pixel_size = font
    .property_int("PIXEL_SIZE")
    .unwrap_or(font_ascent + font_descent)
  let point_size = font.property_int("POINT_SIZE").unwrap_or(pixel_size * 10)
  let strike_ppem = if point_size > 0 {
    ((point_size + 5) / 10).to_int64() << 6
  } else {
    pixel_size.to_int64() << 6
  }
  face.set_ascender(font_ascent)
  face.set_descender(-font_descent)
  face.set_height(font_ascent + font_descent)
  face.set_max_advance_width(max_width)
  face.set_max_advance_height(font_ascent + font_descent)
  face.set_available_sizes([
    @base.BitmapSize::new(
      pixel_size, max_width, strike_ppem, strike_ppem, strike_ppem,
    ),
  ])
  if is_pcf_unicode(font) {
    face.charmaps().push(@base.CharMapRec::new(@base.Encoding::Unicode, 3U, 1U))
  } else {
    face.charmaps().push(@base.CharMapRec::new(@base.Encoding::None, 0U, 0U))
  }
  face.set_active_charmap(0)
  let char_index_fn : (UInt) -> UInt = fn(charcode) {
    let raw_index = font.glyph_index(charcode.reinterpret_as_int())
    if raw_index >= 0 {
      raw_index.reinterpret_as_uint() + 1U
    } else {
      0U
    }
  }
  let default_raw_index = font.default_glyph_index()
  let load_glyph_fn : (UInt, Int) -> @base.BitmapGlyphData raise @error.FTError = fn(
    glyph_index,
    load_flags,
  ) raise @error.FTError {
    ignore(load_flags)
    let raw_index = if glyph_index == 0U {
      default_raw_index
    } else {
      glyph_index.reinterpret_as_int() - 1
    }
    match font.metric(raw_index) {
      Some(metric) => {
        let width = metric.right_bearing() - metric.left_bearing()
        let rows = metric.ascent() + metric.descent()
        let slot_data = @base.GlyphSlotData::new(
          width.to_int64(),
          rows.to_int64(),
          metric.left_bearing().to_int64(),
          metric.ascent().to_int64(),
          metric.width().to_int64(),
        )
        @base.BitmapGlyphData::new(
          slot_data,
          build_pcf_bitmap(
            metric,
            font.bitmap_for_glyph(raw_index),
            font.bitmaps_format(),
          ),
          metric.left_bearing(),
          metric.ascent(),
        )
      }
      None => raise @error.FTError::InvalidGlyphIndex
    }
  }
  face.set_char_index_fn(char_index_fn)
  face.set_driver_data(
    @base.DriverData::BitmapOps(@base.BitmapOps::new(load_glyph=load_glyph_fn)),
  )
  face
}
