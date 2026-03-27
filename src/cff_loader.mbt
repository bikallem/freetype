///|
/// Load a standalone CFF font (bare CFF data, not SFNT-wrapped).
fn load_cff_standalone(data : Bytes) -> @base.FaceRec raise @error.FTError {
  let cff = @cff.load_cff(data, 0)
  let face = @base.FaceRec::new()
  face.set_family_name(cff.family_name())
  face.set_style_name(cff.style_name())
  let has_glyph_names = cff.glyph_names().length() > 0
  let mut face_flags = @base.FACE_FLAG_SCALABLE |
    @base.FACE_FLAG_HORIZONTAL |
    @base.FACE_FLAG_HINTER
  if cff.is_fixed_pitch() {
    face_flags = face_flags | @base.FACE_FLAG_FIXED_WIDTH
  }
  if has_glyph_names {
    face_flags = face_flags | @base.FACE_FLAG_GLYPH_NAMES
  }
  face.set_face_flags(face_flags)
  face.set_num_glyphs(cff.num_glyphs().reinterpret_as_int().to_int64())
  face.set_units_per_em(cff.units_per_em())
  let bbox = cff.top_dict().font_bbox()
  if bbox.length() == 4 {
    face.set_bbox(@types.BBox::new(bbox[0], bbox[1], bbox[2], bbox[3]))
    let has_nonzero_bbox = bbox[0] != 0L ||
      bbox[1] != 0L ||
      bbox[2] != 0L ||
      bbox[3] != 0L
    if has_nonzero_bbox {
      face.set_ascender(bbox[3].to_int())
      face.set_descender(bbox[1].to_int())
      face.set_height((bbox[3] - bbox[1]).to_int())
    }
  }
  if face.height() == 0 {
    face.set_height(cff.units_per_em().reinterpret_as_int() * 12 / 10)
  }
  if cff.top_dict().underline_position() != 0 {
    face.set_underline_position(cff.top_dict().underline_position())
  }
  if cff.top_dict().underline_thickness() != 0 {
    face.set_underline_thickness(cff.top_dict().underline_thickness())
  }
  let unicode_cmap = @psnames.build_unicode_map(cff.glyph_names())
  let encoding_glyphs = cff.encoding_glyphs()
  let has_unicode = !unicode_cmap.is_empty()
  let mut has_encoding = false
  for _, glyph in encoding_glyphs {
    if glyph != 0U {
      has_encoding = true
      break
    }
  }
  if has_unicode {
    face.charmaps().push(@base.CharMapRec::new(@base.Encoding::Unicode, 3U, 1U))
  }
  if has_encoding {
    let encoding_charmap = match cff.top_dict().encoding_offset() {
      0U => @base.CharMapRec::new(@base.Encoding::AdobeStandard, 7U, 0U)
      1U => @base.CharMapRec::new(@base.Encoding::AdobeExpert, 7U, 1U)
      _ => @base.CharMapRec::new(@base.Encoding::AdobeCustom, 7U, 2U)
    }
    face.charmaps().push(encoding_charmap)
  }
  if face.charmaps().length() > 0 {
    face.set_active_charmap(0)
  }
  let unicode_char_index_fn : (UInt) -> UInt = fn(charcode) {
    match unicode_cmap.get(charcode) {
      Some(glyph_index) => glyph_index
      None => 0U
    }
  }
  let encoding_char_index_fn : (UInt) -> UInt = fn(charcode) {
    if charcode < 256U {
      encoding_glyphs[charcode.reinterpret_as_int()]
    } else {
      0U
    }
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
  // PS hint state (shared between load_glyph and apply_hints closures)
  let hint_h_hints : Ref[Array[@psaux.StemHint]] = Ref::new([])
  let hint_v_hints : Ref[Array[@psaux.StemHint]] = Ref::new([])
  let hint_has_hints : Ref[Bool] = Ref::new(false)
  let hint_globals_ref : Ref[@pshinter.PsGlobals?] = Ref::new(None)
  let load_glyph_fn : (UInt, Int) -> (
    @base.GlyphSlotData,
    @types.Outline,
    Bytes,
    Array[@types.Vector],
  ) raise @error.FTError = fn(glyph_index, load_flags) raise @error.FTError {
    let no_hinting = (load_flags & @base.LOAD_NO_HINTING) != 0
    let (outline, width, hh, hv) = @cff.load_cff_glyph(cff, glyph_index)
    if no_hinting {
      hint_has_hints.val = false
      hint_globals_ref.val = None
    } else {
      hint_h_hints.val = hh
      hint_v_hints.val = hv
      hint_has_hints.val = hh.length() > 0 || hv.length() > 0
      let pd = cff.private_dict_for_glyph(glyph_index)
      hint_globals_ref.val = Some(build_ps_globals_from_cff_private(pd))
    }
    let bb = @base.outline_get_bbox(outline)
    let slot_data = @base.GlyphSlotData::new(
      bb.x_max() - bb.x_min(),
      bb.y_max() - bb.y_min(),
      bb.x_min(),
      bb.y_max(),
      width,
    )
    (slot_data, outline, b"", [])
  }
  let apply_hints_fn : (@types.Outline, @fixed.Fixed) -> Bool = fn(
    outline,
    y_scale,
  ) {
    if hint_has_hints.val {
      let globals = hint_globals_ref.val.unwrap_or(@pshinter.PsGlobals::new())
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
  let no_char_variant_index : (UInt, UInt) -> UInt = fn(_charcode, _selector) {
    0U
  }
  let no_char_variant_is_default : (UInt, UInt) -> Int = fn(
    _charcode,
    _selector,
  ) {
    -1
  }
  let no_variant_selectors : () -> Array[UInt] = fn() { [] }
  let no_variants_of_char : (UInt) -> Array[UInt] = fn(_charcode) { [] }
  let no_chars_of_variant : (UInt) -> Array[UInt] = fn(_selector) { [] }
  let no_palette_data : () -> @types.PaletteData? = fn() { None }
  let no_select_palette : (UInt) -> Array[@types.Color]? raise @error.FTError = fn(
    _palette_index,
  ) {
    None
  }
  let no_load_color_glyph : (
    UInt,
    Int,
    UInt,
    UInt,
    Array[@types.Color],
    @types.Color,
  ) -> @base.BitmapGlyphData? raise @error.FTError = fn(
    _glyph_index,
    _load_flags,
    _x_ppem,
    _y_ppem,
    _palette,
    _foreground_color,
  ) {
    None
  }
  let no_tt_hint : (
    @types.Outline,
    Bytes,
    Array[@types.Vector],
    @fixed.Fixed,
    @fixed.Fixed,
    UInt,
  ) -> Bool = fn(
    _outline,
    _instructions,
    _phantoms,
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
        char_variant_index=no_char_variant_index,
        char_variant_is_default=no_char_variant_is_default,
        variant_selectors=no_variant_selectors,
        variants_of_char=no_variants_of_char,
        chars_of_variant=no_chars_of_variant,
        load_glyph=load_glyph_fn,
        get_kerning=no_kerning,
        apply_hints=apply_hints_fn,
        tt_hint=no_tt_hint,
        palette_data=no_palette_data,
        select_palette=no_select_palette,
        load_color_glyph=no_load_color_glyph,
        num_glyphs=cff.num_glyphs(),
        raw_data=data,
      ),
    ),
  )
  face
}
