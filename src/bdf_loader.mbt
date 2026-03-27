///|
fn extract_bdf_family_name(font_name : String) -> String {
  let len = font_name.length()
  if len == 0 || font_name[0] != '-' {
    return font_name
  }
  let mut field_start = 1
  let mut field_index = 0
  for i in 1..<len {
    if font_name[i] == '-' {
      if field_index == 1 && i > field_start {
        return font_name[field_start:i].to_string()
      }
      field_index += 1
      field_start = i + 1
    }
  }
  font_name
}

///|
fn make_bdf_bitmap(glyph : @bdf.BdfGlyph) -> @types.Bitmap {
  let bitmap = @types.Bitmap::new()
  let width = glyph.bbx_width()
  let height = glyph.bbx_height()
  let pitch = if width <= 0 { 0 } else { (width + 7) / 8 }
  bitmap.set_rows(height.reinterpret_as_uint())
  bitmap.set_width(width.reinterpret_as_uint())
  bitmap.set_pitch(pitch)
  bitmap.set_buffer(glyph.bitmap())
  bitmap.set_num_grays(2U)
  bitmap.set_pixel_mode(@types.PixelMode::Mono)
  bitmap
}

///|
fn glyph_advance_width(glyph : @bdf.BdfGlyph) -> Int {
  let dwidth = glyph.dwidth_x()
  if dwidth != 0 {
    dwidth
  } else {
    glyph.bbx_width()
  }
}

///|
fn bdf_ascii_lower_code(unit : UInt16) -> UInt16 {
  let code = unit.to_int()
  if code >= 'A'.to_int() && code <= 'Z'.to_int() {
    (code + 32).to_uint16()
  } else {
    unit
  }
}

///|
fn bdf_string_eq_ignore_ascii_case(left : String, right : String) -> Bool {
  if left.length() != right.length() {
    return false
  }
  for i in 0..<left.length() {
    if bdf_ascii_lower_code(left[i]) != bdf_ascii_lower_code(right[i]) {
      return false
    }
  }
  true
}

///|
fn bdf_string_starts_with_ignore_ascii_case(
  text : String,
  prefix : String,
) -> Bool {
  if prefix.length() > text.length() {
    return false
  }
  for i in 0..<prefix.length() {
    if bdf_ascii_lower_code(text[i]) != bdf_ascii_lower_code(prefix[i]) {
      return false
    }
  }
  true
}

///|
fn bdf_has_unicode_charmap(font : @bdf.BdfFont) -> Bool {
  let registry = font.charset_registry()
  let encoding = font.charset_encoding()
  if registry == "" || encoding == "" {
    return false
  }
  if bdf_string_starts_with_ignore_ascii_case(registry, "iso") {
    let suffix = registry[3:].to_string()
    return bdf_string_eq_ignore_ascii_case(suffix, "10646") ||
      (
        bdf_string_eq_ignore_ascii_case(suffix, "8859") &&
        bdf_string_eq_ignore_ascii_case(encoding, "1")
      ) ||
      (
        bdf_string_eq_ignore_ascii_case(suffix, "646.1991") &&
        bdf_string_eq_ignore_ascii_case(encoding, "IRV")
      )
  }
  false
}

///|
fn load_bdf(data : Bytes) -> @base.FaceRec raise @error.FTError {
  let font = @bdf.parse_bdf_header(data)
  let face = @base.FaceRec::new()
  let glyphs = font.glyphs()
  let num_chars = font.num_chars()
  let num_glyphs = glyphs.length()
  let family_name = extract_bdf_family_name(font.font_name())
  let mut max_advance_width = font.bbx_width()
  for _, glyph in glyphs {
    max_advance_width = max_advance_width.max(glyph_advance_width(glyph))
  }
  face.set_family_name(family_name)
  face.set_face_flags(@base.FACE_FLAG_FIXED_SIZES | @base.FACE_FLAG_HORIZONTAL)
  let advertised_glyphs = if num_chars > 0 { num_chars } else { num_glyphs }
  face.set_num_glyphs((advertised_glyphs + 1).to_int64())
  face.set_ascender(font.bbx_height() + font.bbx_y_offset())
  face.set_descender(font.bbx_y_offset())
  face.set_height(font.bbx_height())
  face.set_max_advance_width(max_advance_width)
  face.set_max_advance_height(font.bbx_height())
  let strike_ppem = font.point_size().to_int64() << 6
  face.set_available_sizes([
    @base.BitmapSize::new(
      font.bbx_height(),
      font.bbx_width(),
      strike_ppem,
      strike_ppem,
      strike_ppem,
    ),
  ])
  if font.charset_registry() != "" && font.charset_encoding() != "" {
    if bdf_has_unicode_charmap(font) {
      face
      .charmaps()
      .push(@base.CharMapRec::new(@base.Encoding::Unicode, 3U, 1U))
    } else {
      face.charmaps().push(@base.CharMapRec::new(@base.Encoding::None, 0U, 0U))
    }
  } else {
    face
    .charmaps()
    .push(@base.CharMapRec::new(@base.Encoding::AdobeStandard, 7U, 0U))
  }
  face.set_active_charmap(0)

  let cmap : Map[UInt, UInt] = {}
  for i, glyph in glyphs {
    let encoding = glyph.encoding()
    if encoding >= 0 {
      cmap[encoding.reinterpret_as_uint()] = (i + 1).reinterpret_as_uint()
    }
  }
  let char_index_fn : (UInt) -> UInt = fn(charcode) {
    match cmap.get(charcode) {
      Some(gid) => gid
      None => 0U
    }
  }
  let load_glyph_fn : (UInt, Int) -> @base.BitmapGlyphData raise @error.FTError = fn(
    glyph_index,
    load_flags,
  ) raise @error.FTError {
    ignore(load_flags)
    if glyph_index == 0U {
      return @base.BitmapGlyphData::new(
        @base.GlyphSlotData::new(0L, 0L, 0L, 0L, 0L),
        @types.Bitmap::new(),
        0,
        0,
      )
    }
    let index = glyph_index.reinterpret_as_int() - 1
    if index < 0 || index >= glyphs.length() {
      raise @error.FTError::InvalidGlyphIndex
    }
    let glyph = glyphs[index]
    let top = glyph.bbx_height() + glyph.bbx_y_offset()
    let advance = glyph_advance_width(glyph)
    @base.BitmapGlyphData::new(
      @base.GlyphSlotData::new(
        glyph.bbx_width().to_int64(),
        glyph.bbx_height().to_int64(),
        glyph.bbx_x_offset().to_int64(),
        top.to_int64(),
        advance.to_int64(),
      ),
      make_bdf_bitmap(glyph),
      glyph.bbx_x_offset(),
      top,
    )
  }
  face.set_char_index_fn(char_index_fn)
  face.set_driver_data(
    @base.DriverData::BitmapOps(@base.BitmapOps::new(load_glyph=load_glyph_fn)),
  )
  face
}
