///|
/// Load a standalone CFF font (bare CFF data, not SFNT-wrapped).
fn load_cff_standalone(data : Bytes) -> @base.FaceRec raise @error.FTError {
  let cff = @cff.load_cff(data, 0)
  let face = @base.FaceRec::new()
  face.set_family_name(cff.name())
  face.set_face_flags(@base.FACE_FLAG_SCALABLE | @base.FACE_FLAG_HORIZONTAL)
  face.set_num_glyphs(cff.num_glyphs().reinterpret_as_int().to_int64())
  face.set_units_per_em(1000U)
  let bbox = cff.top_dict().font_bbox()
  if bbox.length() == 4 {
    face.set_bbox(@types.BBox::new(bbox[0], bbox[1], bbox[2], bbox[3]))
  }
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
  // PS hint state (shared between load_glyph and apply_hints closures)
  let hint_h_hints : Ref[Array[@psaux.StemHint]] = Ref::new([])
  let hint_v_hints : Ref[Array[@psaux.StemHint]] = Ref::new([])
  let hint_has_hints : Ref[Bool] = Ref::new(false)
  let hint_globals_ref : Ref[@pshinter.PsGlobals?] = Ref::new(None)
  let ensure_hint_globals = fn() -> @pshinter.PsGlobals {
    match hint_globals_ref.val {
      Some(g) => g
      None => {
        let pd = cff.private_dict()
        let defaults = @pshinter.PsGlobals::new()
        let g = @pshinter.build_ps_globals(
          pd.blue_values().map(fn(v) { v.to_int() }),
          pd.other_blues().map(fn(v) { v.to_int() }),
          pd.std_hw().to_int(),
          pd.std_vw().to_int(),
          defaults.blue_scale(),
          defaults.blue_shift().to_int(),
          defaults.blue_fuzz().to_int(),
        )
        hint_globals_ref.val = Some(g)
        g
      }
    }
  }
  let load_glyph_fn : (UInt, Int) -> (
    @base.GlyphSlotData,
    @types.Outline,
    Bytes,
  ) raise @error.FTError = fn(glyph_index, load_flags) raise @error.FTError {
    let no_hinting = (load_flags & @base.LOAD_NO_HINTING) != 0
    let (outline, width, hh, hv) = @cff.load_cff_glyph(cff, glyph_index)
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
    (slot_data, outline, b"")
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
  let no_kerning : (UInt, UInt) -> Int = fn(_left, _right) { 0 }
  let no_tt_hint : (@types.Outline, Bytes, @fixed.Fixed, @fixed.Fixed, UInt) -> Bool = fn(
    _outline,
    _instructions,
    _x_scale,
    _y_scale,
    _ppem,
  ) {
    false
  }
  face.set_char_index_fn(char_index_fn)
  face.set_driver_data(
    @base.DriverData::SfntDriver(
      @base.SfntOps::new(
        char_index=char_index_fn,
        load_glyph=load_glyph_fn,
        get_kerning=no_kerning,
        apply_hints=apply_hints_fn,
        tt_hint=no_tt_hint,
        num_glyphs=cff.num_glyphs(),
        raw_data=data,
      ),
    ),
  )
  face
}
