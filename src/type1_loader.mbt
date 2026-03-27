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
  } else {
    @base.CharMapRec::new(@base.Encoding::AdobeStandard, 7U, 0U)
  }
  face.charmaps().push(encoding_charmap)
  if face.charmaps().length() > 0 {
    face.set_active_charmap(0)
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
      font, name,
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
      ),
    ),
  )
  face
}
