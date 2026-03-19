///|
/// Load a Type 1 PFB font.
fn load_type1_pfb(data : Bytes) -> @base.FaceRec raise @error.FTError {
  let font = @type1.parse_type1_pfb(data)
  let face = @base.FaceRec::new()
  face.set_family_name(font.font_name())
  face.set_face_flags(
    @base.FACE_FLAG_SCALABLE |
    @base.FACE_FLAG_HORIZONTAL |
    @base.FACE_FLAG_GLYPH_NAMES,
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
  }
  // Build charmap from encoding
  face
  .charmaps()
  .push(@base.CharMapRec::new(@base.Encoding::AdobeCustom, 7U, 2U))
  if face.charmaps().length() > 0 {
    face.set_active_charmap(0)
  }
  // Build glyph name list for index lookup
  let glyph_names : Array[String] = font.charstrings().keys().collect()
  // Build O(1) name-to-index map
  let name_to_index : Map[String, UInt] = {}
  for i, name in glyph_names {
    name_to_index[name] = i.reinterpret_as_uint()
  }
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
  // Set up Type1Ops driver data
  let char_index_fn : (UInt) -> UInt = fn(charcode) {
    if charcode >= 256U {
      return 0U
    }
    cached_cmap.unsafe_get(charcode.reinterpret_as_int())
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
    let slot_data = @base.GlyphSlotData::new(
      bb.x_max() - bb.x_min(),
      bb.y_max() - bb.y_min(),
      bb.x_min(),
      bb.y_max(),
      0L,
    )
    (slot_data, outline)
  }
  face.set_driver_data(
    @base.DriverData::Type1Ops(
      @base.Type1Ops::new(char_index=char_index_fn, load_glyph=load_glyph_fn),
    ),
  )
  face
}
