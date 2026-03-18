///|
/// Load a Type 1 PFB font.
fn load_type1_pfb(data : Bytes) -> @base.FaceRec raise @error.FTError {
  let font = @type1.parse_type1_pfb(data)
  let face = @base.FaceRec::new()
  face.family_name = font.font_name
  face.face_flags = @base.face_flag_scalable |
    @base.face_flag_horizontal |
    @base.face_flag_glyph_names
  face.num_glyphs = font.charstrings.length().to_int64()
  face.units_per_em = font.units_per_em.reinterpret_as_uint()
  if font.font_bbox.length() == 4 {
    face.bbox = {
      x_min: font.font_bbox[0].to_int64(),
      y_min: font.font_bbox[1].to_int64(),
      x_max: font.font_bbox[2].to_int64(),
      y_max: font.font_bbox[3].to_int64(),
    }
  }
  // Build charmap from encoding
  face.charmaps.push({
    encoding: @base.Encoding::AdobeCustom,
    platform_id: 7U,
    encoding_id: 2U,
  })
  if face.charmaps.length() > 0 {
    face.active_charmap = 0
  }
  // Build glyph name list for index lookup
  let glyph_names : Array[String] = font.charstrings.keys().collect()
  // Build O(1) name-to-index map
  let name_to_index : Map[String, UInt] = {}
  for i, name in glyph_names {
    name_to_index[name] = i.reinterpret_as_uint()
  }
  // Set up Type1Ops driver data
  let char_index_fn : (UInt) -> UInt = fn(charcode) {
    if charcode >= 256U {
      return 0U
    }
    let glyph_name = font.encoding[charcode.reinterpret_as_int()]
    if glyph_name == ".notdef" {
      return 0U
    }
    match name_to_index.get(glyph_name) {
      Some(idx) => idx
      None => 0U
    }
  }
  let load_glyph_fn : (UInt, Int) -> (@base.GlyphSlotData, @types.Outline) raise @error.FTError = fn(
    glyph_index,
    _load_flags,
  ) raise @error.FTError {
    let idx = glyph_index.reinterpret_as_int()
    if idx < 0 || idx >= glyph_names.length() {
      raise @error.FTError::InvalidGlyphIndex
    }
    let name = glyph_names[idx]
    let outline = @type1.load_type1_glyph(font, name)
    let bb = @base.outline_get_bbox(outline)
    let slot_data : @base.GlyphSlotData = {
      metrics_width: bb.x_max - bb.x_min,
      metrics_height: bb.y_max - bb.y_min,
      metrics_hori_bearing_x: bb.x_min,
      metrics_hori_bearing_y: bb.y_max,
      metrics_hori_advance: 0L,
    }
    (slot_data, outline)
  }
  face.driver_data = @base.DriverData::Type1Ops({
    char_index: char_index_fn,
    load_glyph: load_glyph_fn,
  })
  face
}
