///|
/// Load an SFNT-based font (TrueType, CFF/OpenType, TTC).
fn load_sfnt(
  data : Bytes,
  face_index : Int,
) -> @base.FaceRec raise @error.FTError {
  let (sfnt_data, face) = @sfnt.load_sfnt_face(data, face_index.to_int64())
  // Parse the best cmap subtable for charmap lookup
  let cmap_lookup : @sfnt.CmapLookup? = match sfnt_data.cmap {
    Some(ct) => {
      let cmap_table_rec = sfnt_data.table_dir.find_table(@types.tag_cmap)
      match cmap_table_rec {
        Some(rec) => find_best_cmap(data, ct, rec.offset)
        None => None
      }
    }
    None => None
  }
  // Initialize format-specific data
  let has_glyf = sfnt_data.table_dir.find_table(@types.tag_glyf) is Some(_)
  let has_cff = sfnt_data.table_dir.find_table(@types.tag_CFF) is Some(_)
  let tt_data : @truetype.TtFaceData? = if has_glyf {
    Some(@truetype.init_tt_face(sfnt_data, face))
  } else {
    None
  }
  let cff_font : @cff.CffFont? = if has_cff {
    match sfnt_data.table_dir.find_table(@types.tag_CFF) {
      Some(rec) => Some(@cff.load_cff(data, rec.offset.reinterpret_as_int()))
      None => None
    }
  } else {
    None
  }
  // Build the closure-based driver ops
  let kern_table = sfnt_data.kern
  let hmtx = sfnt_data.hmtx
  // Per-face hint state (captured by closures below, avoids module-level mutable)
  let hint_h_hints : Ref[Array[@psaux.StemHint]] = Ref::new([])
  let hint_v_hints : Ref[Array[@psaux.StemHint]] = Ref::new([])
  let hint_has_hints : Ref[Bool] = Ref::new(false)
  // Build PS hint globals for CFF fonts
  let hint_globals : Ref[@pshinter.PsGlobals] = Ref::new(
    @pshinter.PsGlobals::new(),
  )
  if cff_font is Some(cff) {
    let pd = cff.private_dict
    let defaults = @pshinter.PsGlobals::new()
    hint_globals.val = @pshinter.build_ps_globals(
      pd.blue_values.map(fn(v) { v.to_int() }),
      pd.other_blues.map(fn(v) { v.to_int() }),
      pd.std_hw.to_int(),
      pd.std_vw.to_int(),
      defaults.blue_scale,
      defaults.blue_shift.to_int(),
      defaults.blue_fuzz.to_int(),
    )
  }
  let char_index_fn : (UInt) -> UInt = match cmap_lookup {
    Some(cl) => fn(charcode) { cl.char_index(charcode) }
    None => fn(_charcode) { 0U }
  }
  let load_glyph_fn : (UInt, Int) -> (@base.GlyphSlotData, @types.Outline) raise @error.FTError = fn(
    glyph_index,
    load_flags,
  ) raise @error.FTError {
    let no_hinting = (load_flags & @base.load_no_hinting) != 0
    let outline = if tt_data is Some(tt) {
      hint_has_hints.val = false
      @truetype.load_tt_glyph(
        data,
        tt.glyph_offsets,
        tt.glyf_offset,
        glyph_index,
      )
    } else if cff_font is Some(cff) {
      let (o, _w, hh, hv) = @cff.load_cff_glyph(cff, glyph_index)
      if no_hinting {
        hint_has_hints.val = false
      } else {
        // Store stem hints for use during point scaling
        hint_h_hints.val = hh
        hint_v_hints.val = hv
        hint_has_hints.val = hh.length() > 0 || hv.length() > 0
      }
      o
    } else {
      hint_has_hints.val = false
      @types.Outline::new()
    }
    // Compute metrics from outline bbox + hmtx
    let (advance_width, _lsb) = hmtx.get_metrics(glyph_index)
    let bb = @base.outline_get_bbox(outline)
    let slot_data : @base.GlyphSlotData = {
      metrics_width: bb.x_max - bb.x_min,
      metrics_height: bb.y_max - bb.y_min,
      metrics_hori_bearing_x: bb.x_min,
      metrics_hori_bearing_y: bb.y_max,
      metrics_hori_advance: advance_width.reinterpret_as_int().to_int64(),
    }
    (slot_data, outline)
  }
  let apply_hints_fn : (@types.Outline, @fixed.Fixed) -> Bool = fn(
    outline,
    y_scale,
  ) {
    if hint_has_hints.val {
      @pshinter.hint_outline(
        outline,
        hint_h_hints.val,
        hint_v_hints.val,
        hint_globals.val,
        y_scale,
      )
      hint_has_hints.val = false
      true
    } else {
      false
    }
  }
  let kern_fn : (UInt, UInt) -> Int = match kern_table {
    Some(k) => fn(left, right) { k.get_kerning(left, right) }
    None => fn(_left, _right) { 0 }
  }
  face.driver_data = @base.DriverData::SfntDriver({
    char_index: char_index_fn,
    load_glyph: load_glyph_fn,
    get_kerning: kern_fn,
    apply_hints: apply_hints_fn,
    num_glyphs: sfnt_data.maxp.num_glyphs,
    raw_data: data,
  })
  // Add synthetic charmap for CFF fonts (matches C FreeType behavior)
  if has_cff {
    face.charmaps.push({
      encoding: @base.Encoding::Unicode,
      platform_id: 7U,
      encoding_id: 0U,
    })
  }
  face
}

///|
/// Find the best cmap subtable for Unicode lookup.
fn find_best_cmap(
  data : Bytes,
  ct : @sfnt.CmapTable,
  cmap_table_offset : UInt,
) -> @sfnt.CmapLookup? {
  let reader = @stream.ByteReader::new(data)
  // Prefer platform 3/encoding 1 (Windows BMP), then 3/10 (Windows UCS-4),
  // then platform 0 (Unicode), then first available
  let priorities : Array[(UInt, UInt)] = [
    (3U, 1U),
    (3U, 10U),
    (0U, 3U),
    (0U, 4U),
    (0U, 1U),
    (0U, 0U),
  ]
  for _, prio in priorities {
    let (plat, enc) = prio
    for _, sub in ct.subtables {
      if sub.platform_id == plat && sub.encoding_id == enc {
        let result = try? @sfnt.parse_cmap_subtable(
          reader,
          cmap_table_offset,
          sub.offset,
        )
        if result is Ok(cl) {
          return Some(cl)
        }
      }
    }
  }
  // Fallback: first parseable subtable
  for _, sub in ct.subtables {
    let result = try? @sfnt.parse_cmap_subtable(
      reader,
      cmap_table_offset,
      sub.offset,
    )
    if result is Ok(cl) {
      return Some(cl)
    }
  }
  None
}
