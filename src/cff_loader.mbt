///|
/// Load a standalone CFF font (bare CFF data, not SFNT-wrapped).
fn load_cff_standalone(data : Bytes) -> @base.FaceRec raise @error.FTError {
  let cff = @cff.load_cff(data, 0)
  let face = @base.FaceRec::new()
  face.set_family_name(cff.name())
  face.set_face_flags(
    @base.FACE_FLAG_SCALABLE | @base.FACE_FLAG_HORIZONTAL,
  )
  face.set_num_glyphs(cff.num_glyphs().reinterpret_as_int().to_int64())
  // CFF default units_per_em is 1000
  face.set_units_per_em(1000U)
  // Set bbox from Top DICT if available
  let bbox = cff.top_dict().font_bbox()
  if bbox.length() == 4 {
    face.set_bbox(
      @types.BBox::new(bbox[0], bbox[1], bbox[2], bbox[3]),
    )
  }
  // CFF standalone fonts use CFF built-in encoding (or charset-based lookup).
  // For now, add a Unicode charmap — char_index defaults to identity for
  // standalone CFF (glyph index == charcode) as a simple fallback.
  face.charmaps().push(@base.CharMapRec::new(@base.Encoding::Unicode, 7U, 0U))
  if face.charmaps().length() > 0 {
    face.set_active_charmap(0)
  }
  let char_index_fn : (UInt) -> UInt = fn(charcode) {
    if charcode >= cff.num_glyphs() {
      0U
    } else {
      charcode
    }
  }
  let load_glyph_fn : (UInt, Int) -> (
    @base.GlyphSlotData,
    @types.Outline,
  ) raise @error.FTError = fn(glyph_index, _load_flags) raise @error.FTError {
    let (outline, width, _hh, _hv) = @cff.load_cff_glyph(cff, glyph_index)
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
  face.set_char_index_fn(char_index_fn)
  face.set_driver_data(
    @base.DriverData::Type1Ops(
      @base.Type1Ops::new(char_index=char_index_fn, load_glyph=load_glyph_fn),
    ),
  )
  face
}
