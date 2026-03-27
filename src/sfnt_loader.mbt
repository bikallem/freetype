///|
/// Load an SFNT-based font (TrueType, CFF/OpenType, TTC).
/// Uses lazy initialization for expensive table parsing — only the table
/// directory, head, maxp, hhea, and metadata tables are parsed eagerly.
/// hmtx, cmap subtables, TT/CFF data are parsed on first use.
fn load_sfnt(
  data : Bytes,
  face_index : Int,
) -> @base.FaceRec raise @error.FTError {
  let (sfnt_data, face) = @sfnt.load_sfnt_face(data, face_index.to_int64())
  // Lazy state: None = not yet parsed
  let hmtx_ref : Ref[@sfnt.HmtxTable?] = Ref::new(None)
  let vmtx_ref : Ref[@sfnt.HmtxTable??] = Ref::new(None)
  let tt_ref : Ref[@truetype.TtFaceData??] = Ref::new(None)
  let cff_ref : Ref[@cff.CffFont??] = Ref::new(None)
  let gvar_ref : Ref[@truetype.GvarTable??] = Ref::new(None)
  let hvar_ref : Ref[@truetype.HvarTable??] = Ref::new(None)
  let hint_globals_ref : Ref[@pshinter.PsGlobals?] = Ref::new(None)
  // Check table presence (cheap O(1) lookups)
  let has_glyf = sfnt_data.table_dir().find_table(@types.TAG_GLYF) is Some(_)
  let has_cff = sfnt_data.table_dir().find_table(@types.TAG_CFF) is Some(_)
  let has_cff2 = sfnt_data.table_dir().find_table(@types.TAG_CFF2) is Some(_)
  let has_svg = sfnt_data.table_dir().find_table(@types.TAG_SVG) is Some(_)
  let color_tables = try
    @color.parse_color_tables(
      data,
      sfnt_data.table_dir(),
      sfnt_data.maxp().num_glyphs(),
    )
  catch {
    _ => None
  } noraise {
    tables => tables
  }
  // Set FACE_FLAG_HINTER eagerly from table directory (avoids lazy TT init)
  if has_glyf &&
    (
      sfnt_data.table_dir().find_table(@types.TAG_FPGM) is Some(_) ||
      sfnt_data.table_dir().find_table(@types.TAG_PREP) is Some(_)
    ) {
    face.set_face_flags(face.face_flags() | @base.FACE_FLAG_HINTER)
  }
  if has_cff || has_cff2 {
    face.set_face_flags(face.face_flags() | @base.FACE_FLAG_HINTER)
  }
  // Lazy initializers
  let ensure_hmtx = fn() -> @sfnt.HmtxTable raise @error.FTError {
    match hmtx_ref.val {
      Some(h) => h
      None => {
        let reader = @stream.ByteReader::new(data)
        match sfnt_data.table_dir().find_table(@types.TAG_HMTX) {
          Some(r) => {
            let h = @sfnt.parse_hmtx(
              reader,
              r.offset(),
              sfnt_data.hhea().number_of_h_metrics(),
              sfnt_data.maxp().num_glyphs(),
            )
            hmtx_ref.val = Some(h)
            h
          }
          None => raise @error.FTError::HmtxTableMissing
        }
      }
    }
  }
  let ensure_vmtx = fn() -> @sfnt.HmtxTable? raise @error.FTError {
    match vmtx_ref.val {
      Some(result) => result
      None => {
        let result : @sfnt.HmtxTable? = match sfnt_data.vhea() {
          Some(vhea) =>
            match sfnt_data.table_dir().find_table(@types.TAG_VMTX) {
              Some(r) =>
                Some(
                  @sfnt.parse_hmtx(
                    @stream.ByteReader::new(data),
                    r.offset(),
                    vhea.number_of_h_metrics(),
                    sfnt_data.maxp().num_glyphs(),
                  ),
                )
              None => None
            }
          None => None
        }
        vmtx_ref.val = Some(result)
        result
      }
    }
  }
  let ensure_tt = fn() -> @truetype.TtFaceData? raise @error.FTError {
    match tt_ref.val {
      Some(result) => result
      None => {
        let result : @truetype.TtFaceData? = if has_glyf {
          Some(@truetype.init_tt_face(sfnt_data, face))
        } else {
          None
        }
        tt_ref.val = Some(result)
        result
      }
    }
  }
  let ensure_cff = fn() -> @cff.CffFont? raise @error.FTError {
    match cff_ref.val {
      Some(result) => result
      None => {
        let result : @cff.CffFont? = if has_cff {
          match sfnt_data.table_dir().find_table(@types.TAG_CFF) {
            Some(rec) =>
              Some(@cff.load_cff(data, rec.offset().reinterpret_as_int()))
            None => None
          }
        } else if has_cff2 {
          match sfnt_data.table_dir().find_table(@types.TAG_CFF2) {
            Some(rec) =>
              Some(
                @cff.load_cff2(
                  data,
                  rec.offset().reinterpret_as_int(),
                  face.units_per_em(),
                ),
              )
            None => None
          }
        } else {
          None
        }
        cff_ref.val = Some(result)
        result
      }
    }
  }
  let ensure_gvar = fn() -> @truetype.GvarTable? raise @error.FTError {
    match gvar_ref.val {
      Some(result) => result
      None => {
        let result : @truetype.GvarTable? = match
          sfnt_data.table_dir().find_table(@types.TAG_GVAR) {
          Some(rec) =>
            Some(
              @truetype.parse_gvar(
                @stream.ByteReader::new(data),
                rec.offset(),
                rec.length(),
                sfnt_data.maxp().num_glyphs(),
              ),
            )
          None => None
        }
        gvar_ref.val = Some(result)
        result
      }
    }
  }
  let ensure_hvar = fn() -> @truetype.HvarTable? raise @error.FTError {
    match hvar_ref.val {
      Some(result) => result
      None => {
        let result : @truetype.HvarTable? = match
          sfnt_data.table_dir().find_table(@types.TAG_HVAR) {
          Some(rec) =>
            Some(
              @truetype.parse_hvar(
                @stream.ByteReader::new(data),
                rec.offset(),
                rec.length(),
              ),
            )
          None => None
        }
        hvar_ref.val = Some(result)
        result
      }
    }
  }
  let has_active_variation = fn() -> Bool {
    for _, coord in face.var_coords() {
      if coord != 0 {
        return true
      }
    }
    false
  }
  // Reusable glyph loading buffers (captured by load_glyph_fn closure)
  let glyph_bufs = @truetype.GlyphBufs::new()
  // Cached TT interpreter state: fpgm func_defs + prep-modified CVT + reusable context
  let tt_cached_funcs : Ref[Map[Int, @truetype.FuncDef]?] = Ref::new(None)
  let tt_cached_cvt : Ref[Array[Int64]?] = Ref::new(None)
  let tt_cached_ppem : Ref[UInt] = Ref::new(0U)
  let tt_cached_var_coords : Ref[Array[Int]?] = Ref::new(None)
  let tt_cached_ok : Ref[Bool] = Ref::new(false)
  let same_var_coords = fn(coords : Array[Int]) -> Bool {
    match tt_cached_var_coords.val {
      Some(cached) => {
        if cached.length() != coords.length() {
          return false
        }
        for i in 0..<coords.length() {
          if cached[i] != coords[i] {
            return false
          }
        }
        true
      }
      None => false
    }
  }
  // Reusable interpreter context — avoid allocating new one per glyph
  let tt_reuse_ctx : Ref[@truetype.InterpContext?] = Ref::new(None)
  // Per-face hint state
  let hint_h_hints : Ref[Array[@psaux.StemHint]] = Ref::new([])
  let hint_v_hints : Ref[Array[@psaux.StemHint]] = Ref::new([])
  let hint_has_hints : Ref[Bool] = Ref::new(false)
  let actual_cmap_count = match sfnt_data.cmap() {
    Some(ct) => ct.subtables().length()
    None => 0
  }
  let best_cmap_lookup_ref : Ref[@sfnt.CmapLookup?] = Ref::new(None)
  let best_cmap_lookup_done : Ref[Bool] = Ref::new(false)
  let format14_lookup_ref : Ref[@sfnt.CmapFormat14?] = Ref::new(None)
  let format14_lookup_done : Ref[Bool] = Ref::new(false)
  let cmap_lookup_cache : Ref[Map[Int, @sfnt.CmapLookup?]] = Ref::new({})
  let synthetic_adobe_charmap_index : Ref[Int] = Ref::new(-1)
  let palette_data_fn : () -> @types.PaletteData? = fn() {
    match color_tables {
      Some(tables) => tables.palette_data()
      None => None
    }
  }
  let select_palette_fn : (UInt) -> Array[@types.Color]? raise @error.FTError = fn(
    palette_index,
  ) {
    match color_tables {
      Some(tables) => tables.select_palette(palette_index)
      None => None
    }
  }
  let bitmap_size_from_ppem = fn(
    x_ppem : UInt,
    y_ppem : UInt,
  ) -> @base.BitmapSize {
    @base.BitmapSize::new(
      y_ppem.reinterpret_as_int(),
      x_ppem.reinterpret_as_int(),
      y_ppem.to_int64() << 6,
      x_ppem.to_int64() << 6,
      y_ppem.to_int64() << 6,
    )
  }
  let resolve_cmap_lookup = fn(index : Int) -> @sfnt.CmapLookup? {
    match cmap_lookup_cache.val.get(index) {
      Some(lookup) => lookup
      None => {
        let lookup : @sfnt.CmapLookup? = match sfnt_data.cmap() {
          Some(ct) =>
            if index >= 0 && index < ct.subtables().length() {
              match sfnt_data.table_dir().find_table(@types.TAG_CMAP) {
                Some(rec) => {
                  let reader = @stream.ByteReader::new(data)
                  let result = try? @sfnt.parse_cmap_subtable(
                    reader,
                    rec.offset(),
                    ct.subtables()[index].offset(),
                  )
                  match result {
                    Ok(parsed) => Some(parsed)
                    Err(_) => None
                  }
                }
                None => None
              }
            } else {
              None
            }
          None => None
        }
        cmap_lookup_cache.val[index] = lookup
        lookup
      }
    }
  }
  let resolve_best_cmap_lookup = fn() -> @sfnt.CmapLookup? {
    if best_cmap_lookup_done.val {
      return best_cmap_lookup_ref.val
    }
    best_cmap_lookup_done.val = true
    best_cmap_lookup_ref.val = match sfnt_data.cmap() {
      Some(ct) =>
        match sfnt_data.table_dir().find_table(@types.TAG_CMAP) {
          Some(rec) => find_best_cmap(data, ct, rec.offset())
          None => None
        }
      None => None
    }
    best_cmap_lookup_ref.val
  }
  let resolve_format14_lookup = fn() -> @sfnt.CmapFormat14? {
    if format14_lookup_done.val {
      return format14_lookup_ref.val
    }
    format14_lookup_done.val = true
    format14_lookup_ref.val = match sfnt_data.cmap() {
      Some(ct) =>
        match sfnt_data.table_dir().find_table(@types.TAG_CMAP) {
          Some(_) => {
            for i in 0..<ct.subtables().length() {
              match resolve_cmap_lookup(i) {
                Some(@sfnt.Format14(t)) => {
                  format14_lookup_ref.val = Some(t)
                  return Some(t)
                }
                _ => ()
              }
            }
            None
          }
          None => None
        }
      None => None
    }
    format14_lookup_ref.val
  }
  let resolve_active_unicode_cmap_lookup = fn() -> @sfnt.CmapLookup? {
    let active = face.active_charmap()
    if active < 0 || active >= actual_cmap_count {
      return None
    }
    if face.charmaps()[active].encoding() != @base.Encoding::Unicode {
      return None
    }
    resolve_cmap_lookup(active)
  }
  let cff_encoding_char_index_fn : (UInt) -> UInt = fn(charcode) {
    if charcode >= 256U {
      return 0U
    }
    let cff_result = try? ensure_cff()
    match cff_result {
      Ok(Some(cff)) => cff.encoding_glyphs()[charcode.reinterpret_as_int()]
      _ => 0U
    }
  }
  let char_index_fn : (UInt) -> UInt = fn(charcode) {
    let active = face.active_charmap()
    if active == synthetic_adobe_charmap_index.val {
      return cff_encoding_char_index_fn(charcode)
    }
    if active >= 0 && active < actual_cmap_count {
      match resolve_cmap_lookup(active) {
        Some(lookup) => return lookup.char_index(charcode)
        None => ()
      }
    }
    match resolve_best_cmap_lookup() {
      Some(lookup) => lookup.char_index(charcode)
      None => 0U
    }
  }
  let char_variant_index_fn : (UInt, UInt) -> UInt = fn(charcode, selector) {
    match resolve_format14_lookup() {
      Some(format14) =>
        match resolve_active_unicode_cmap_lookup() {
          Some(base_lookup) =>
            format14.char_variant_index(charcode, selector, fn(code) {
              base_lookup.char_index(code)
            })
          None => 0U
        }
      None => 0U
    }
  }
  let char_variant_is_default_fn : (UInt, UInt) -> Int = fn(
    charcode,
    selector,
  ) {
    match resolve_format14_lookup() {
      Some(format14) =>
        format14.char_variant_is_default(charcode, selector, fn(_code) { 0U })
      None => -1
    }
  }
  let variant_selectors_fn : () -> Array[UInt] = fn() {
    match resolve_format14_lookup() {
      Some(format14) => format14.variant_selectors()
      None => []
    }
  }
  let variants_of_char_fn : (UInt) -> Array[UInt] = fn(charcode) {
    match resolve_format14_lookup() {
      Some(format14) => format14.variants_of_char(charcode)
      None => []
    }
  }
  let chars_of_variant_fn : (UInt) -> Array[UInt] = fn(selector) {
    match resolve_format14_lookup() {
      Some(format14) => format14.chars_of_variant(selector)
      None => []
    }
  }
  let load_glyph_fn : (UInt, Int) -> (
    @base.GlyphSlotData,
    @types.Outline,
    Bytes,
    Array[@types.Vector],
  ) raise @error.FTError = fn(glyph_index, load_flags) raise @error.FTError {
    let no_hinting = (load_flags & @base.LOAD_NO_HINTING) != 0
    let hmtx = ensure_hmtx()
    let has_variation = has_active_variation()
    let tt_data = ensure_tt()
    let (outline, tt_instructions, tt_bbox, tt_phantoms) = if tt_data
      is Some(tt) {
      hint_has_hints.val = false
      let gvar = if has_variation { ensure_gvar() } else { None }
      let (o, instr_off, instr_len, bbox, phantoms) = @truetype.load_tt_glyph_with_phantoms(
        data,
        tt.glyph_offsets(),
        tt.glyf_offset(),
        glyph_index,
        glyph_bufs,
        hmtx=Some(hmtx),
        gvar~,
        var_coords=face.var_coords(),
      )
      // Only copy instructions when hinting is needed
      let instr = if !no_hinting && instr_len > 0 {
        data[instr_off:instr_off + instr_len].to_bytes()
      } else {
        b""
      }
      (o, instr, bbox, phantoms)
    } else if ensure_cff() is Some(cff) {
      let (o, _w, hh, hv) = @cff.load_cff_glyph(
        cff,
        glyph_index,
        normalized_coords=face.var_coords(),
      )
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
      (o, b"", @types.BBox::empty(), [])
    } else {
      hint_has_hints.val = false
      hint_globals_ref.val = None
      (@types.Outline::new(), b"", @types.BBox::empty(), [])
    }
    let (advance_width, _lsb) = hmtx.get_metrics(glyph_index)
    let varied_advance = if has_variation {
      match ensure_hvar() {
        Some(hvar) =>
          advance_width.reinterpret_as_int().to_int64() +
          hvar.advance_width_delta(glyph_index, face.var_coords())
        None =>
          if tt_phantoms.length() >= 2 {
            tt_phantoms[1].x() - tt_phantoms[0].x()
          } else {
            advance_width.reinterpret_as_int().to_int64()
          }
      }
    } else {
      advance_width.reinterpret_as_int().to_int64()
    }
    // Use glyf header bbox for TT glyphs unless variation moved the outline.
    let bb = if !has_variation &&
      (tt_bbox.x_max() != 0L || tt_bbox.y_max() != 0L) {
      tt_bbox
    } else {
      @base.outline_get_bbox(outline)
    }
    let raw_height = bb.y_max() - bb.y_min()
    let (vert_top_bearing, vert_advance) = match ensure_vmtx() {
      Some(vmtx) => {
        let (advance_height, top_side_bearing) = vmtx.get_metrics(glyph_index)
        (
          top_side_bearing.to_int64(),
          advance_height.reinterpret_as_int().to_int64(),
        )
      }
      None => {
        let fallback_advance = match sfnt_data.os2() {
          Some(os2) =>
            (os2.s_typo_ascender() - os2.s_typo_descender()).to_int64()
          None => (face.ascender() - face.descender()).to_int64()
        }
        ((fallback_advance - raw_height) / 2, fallback_advance)
      }
    }
    let slot_data = @base.GlyphSlotData::new(
      bb.x_max() - bb.x_min(),
      raw_height,
      bb.x_min(),
      bb.y_max(),
      varied_advance,
      metrics_vert_bearing_x=bb.x_min() - varied_advance / 2,
      metrics_vert_bearing_y=vert_top_bearing,
      metrics_vert_advance=vert_advance,
    )
    (slot_data, outline, tt_instructions, tt_phantoms)
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
  if has_cff || has_cff2 {
    match ensure_cff() {
      Some(cff) => {
        if !cff.is_cff2() && cff.top_dict().underline_position() != 0 {
          face.set_underline_position(cff.top_dict().underline_position())
        }
        if !cff.is_cff2() && cff.top_dict().underline_thickness() != 0 {
          face.set_underline_thickness(cff.top_dict().underline_thickness())
        }
      }
      None => ()
    }
  }
  let tt_hint_fn : (
    @types.Outline,
    Bytes,
    Array[@types.Vector],
    @fixed.Fixed,
    @fixed.Fixed,
    UInt,
  ) -> Bool = fn(outline, instructions, phantoms, x_scale, y_scale, ppem) {
    let tt_result = try? ensure_tt()
    let tt_data = match tt_result {
      Ok(d) => d
      Err(_) => return false
    }
    if tt_data is Some(tt) && instructions.length() > 0 {
      // Cache fpgm func_defs + prep-modified CVT per ppem
      if tt_cached_ppem.val != ppem ||
        tt_cached_funcs.val is None ||
        !same_var_coords(face.var_coords()) {
        // Run fpgm + prep once, cache results
        let init_ctx = @truetype.InterpContext::new(
          cvt=tt.cvt().copy(),
          storage_size=64,
          max_stack=256,
        )
        init_ctx.set_ppem(ppem.reinterpret_as_int())
        init_ctx.set_cvt_scale(y_scale)
        // Scale CVT
        for i in 0..<init_ctx.cvt().length() {
          let font_units = init_ctx.cvt()[i] >> 6
          init_ctx.cvt()[i] = @fixed.mul_fix(
            y_scale,
            @fixed.Fixed::from_raw(font_units),
          ).val()
        }
        // Twilight zone for fpgm/prep
        let twilight_size = 16
        init_ctx.set_zone0_org(
          FixedArray::make(twilight_size, @types.Vector::new(0L, 0L)),
        )
        init_ctx.set_zone0_cur(
          FixedArray::make(twilight_size, @types.Vector::new(0L, 0L)),
        )
        init_ctx.set_zone0_tags(FixedArray::make(twilight_size, b'\x00'))
        init_ctx.set_zone0_points(init_ctx.zone0_cur())
        // Empty glyph zone for fpgm/prep
        init_ctx.set_zone1_org(FixedArray::default())
        init_ctx.set_zone1_cur(FixedArray::default())
        init_ctx.set_zone1_tags(FixedArray::default())
        init_ctx.set_zone1_touch(FixedArray::default())
        init_ctx.set_zone1_points(init_ctx.zone1_cur())
        let mut init_ok = true
        if tt.fpgm().length() > 0 {
          if (try? init_ctx.execute(tt.fpgm())) is Err(_) {
            init_ok = false
          }
        }
        init_ctx.set_gs(@truetype.GraphicsState::default())
        if init_ok && tt.prep().length() > 0 {
          if (try? init_ctx.execute(tt.prep())) is Err(_) {
            init_ok = false
          }
        }
        init_ctx.set_var_coords(face.var_coords())
        // Cache func_defs and scaled CVT
        tt_cached_funcs.val = Some(init_ctx.func_defs())
        tt_cached_cvt.val = Some(init_ctx.cvt())
        tt_cached_ppem.val = ppem
        tt_cached_var_coords.val = Some(face.var_coords())
        tt_cached_ok.val = init_ok
      }
      // If fpgm/prep failed, skip TT hinting (fall back to auto-hint)
      if !tt_cached_ok.val {
        return false
      }
      // Reuse or create interpreter context
      let cached_cvt = tt_cached_cvt.val.unwrap()
      let cached_funcs = tt_cached_funcs.val.unwrap()
      let ctx = match tt_reuse_ctx.val {
        Some(c) => c
        None => {
          let c = @truetype.InterpContext::new(storage_size=64, max_stack=256)
          let twilight_size = 16
          c.set_zone0_org(
            FixedArray::make(twilight_size, @types.Vector::new(0L, 0L)),
          )
          c.set_zone0_cur(
            FixedArray::make(twilight_size, @types.Vector::new(0L, 0L)),
          )
          c.set_zone0_tags(FixedArray::make(twilight_size, b'\x00'))
          c.set_zone0_points(c.zone0_cur())
          tt_reuse_ctx.val = Some(c)
          c
        }
      }
      // Reset context for this glyph
      ctx.set_cvt(cached_cvt.copy())
      ctx.set_cvt_scale(y_scale)
      ctx.set_ppem(ppem.reinterpret_as_int())
      ctx.set_func_defs(cached_funcs)
      ctx.set_var_coords(face.var_coords())
      ctx.reset_sp()
      // Reuse zone1 arrays if large enough, else reallocate
      let n_points = outline.n_points()
      let total_points = n_points + 4
      let zero_vec = @types.Vector::new(0L, 0L)
      if ctx.zone1_org().length() < total_points {
        ctx.set_zone1_org(FixedArray::make(total_points, zero_vec))
        ctx.set_zone1_cur(
          FixedArray::make(total_points, @types.Vector::new(0L, 0L)),
        )
        ctx.set_zone1_tags(@blit.make_uninit(total_points))
        ctx.set_zone1_touch(@blit.make_uninit(total_points))
        @blit.fill_bytes(ctx.zone1_tags(), 0, b'\x00', total_points)
        @blit.fill_bytes(ctx.zone1_touch(), 0, b'\x00', total_points)
        ctx.set_zone1_points(ctx.zone1_cur())
      } else {
        // Only zero phantom points (n_points..total_points) and touch flags
        // The real points are overwritten below, tags are set below
        for i in n_points..<total_points {
          ctx.zone1_org()[i] = zero_vec
          ctx.zone1_cur()[i] = @types.Vector::new(0L, 0L)
        }
        // Touch flags must all be zero (tracks which points were hinted)
        @blit.fill_bytes(ctx.zone1_touch(), 0, b'\x00', total_points)
        ctx.set_zone1_points(ctx.zone1_cur())
      }
      ctx.set_zone1_contours(outline.contours())
      let z1_org = ctx.zone1_org()
      let z1_cur = ctx.zone1_cur()
      let z1_tags = ctx.zone1_tags()
      let o_pts = outline.points()
      let o_tags = outline.tags()
      let xs = x_scale.val()
      let ys = y_scale.val()
      fn scale_point(point : @types.Vector) -> @types.Vector {
        let abx = xs * point.x()
        let sx = (abx + 0x8000L + (abx >> 63)) >> 16
        let aby = ys * point.y()
        let sy = (aby + 0x8000L + (aby >> 63)) >> 16
        @types.Vector::new(sx, sy)
      }
      for i in 0..<n_points {
        let v = scale_point(o_pts.unsafe_get(i))
        z1_org.unsafe_set(i, v)
        z1_cur.unsafe_set(i, v)
        z1_tags.unsafe_set(i, o_tags.unsafe_get(i))
      }
      for i in 0..<4 {
        let v = if i < phantoms.length() {
          scale_point(phantoms[i])
        } else {
          zero_vec
        }
        z1_org.unsafe_set(n_points + i, v)
        z1_cur.unsafe_set(n_points + i, v)
        z1_tags.unsafe_set(n_points + i, @types.CURVE_TAG_ON)
      }
      z1_cur[n_points] = @types.Vector::new(
        @fixed.F26Dot6::from_raw(z1_cur[n_points].x()).round().val(),
        z1_cur[n_points].y(),
      )
      z1_cur[n_points + 1] = @types.Vector::new(
        @fixed.F26Dot6::from_raw(z1_cur[n_points + 1].x()).round().val(),
        z1_cur[n_points + 1].y(),
      )
      z1_cur[n_points + 2] = @types.Vector::new(
        z1_cur[n_points + 2].x(),
        @fixed.F26Dot6::from_raw(z1_cur[n_points + 2].y()).round().val(),
      )
      z1_cur[n_points + 3] = @types.Vector::new(
        z1_cur[n_points + 3].x(),
        @fixed.F26Dot6::from_raw(z1_cur[n_points + 3].y()).round().val(),
      )
      // Run glyph instructions only (fpgm+prep already cached)
      ctx.set_gs(@truetype.GraphicsState::default())
      let glyph_result = try? ctx.execute(instructions)
      if glyph_result is Err(_) {
        return false
      }
      let hinted_shift_x = z1_cur[n_points].x()
      for i in 0..<n_points {
        o_pts.unsafe_set(
          i,
          @types.Vector::new(
            z1_cur.unsafe_get(i).x() - hinted_shift_x,
            z1_cur.unsafe_get(i).y(),
          ),
        )
      }
      if phantoms.length() >= 4 {
        phantoms[0] = z1_cur[n_points]
        phantoms[1] = z1_cur[n_points + 1]
        phantoms[2] = z1_cur[n_points + 2]
        phantoms[3] = z1_cur[n_points + 3]
      }
      true
    } else {
      false
    }
  }
  let scale_design_units_to_pixels = fn(value : Int, ppem : UInt) -> Int {
    let upem = face.units_per_em().reinterpret_as_int()
    if upem <= 0 {
      return value
    }
    let num = value * ppem.reinterpret_as_int()
    if num >= 0 {
      (num + upem / 2) / upem
    } else {
      -((-num + upem / 2) / upem)
    }
  }
  let make_bitmap_slot_data = fn(
    glyph_index : UInt,
    bitmap : @types.Bitmap,
    left : Int,
    top : Int,
    x_ppem : UInt,
    y_ppem : UInt,
  ) -> @base.GlyphSlotData raise @error.FTError {
    let hmtx = ensure_hmtx()
    let (advance_width, _lsb) = hmtx.get_metrics(glyph_index)
    let hori_advance = scale_design_units_to_pixels(
      advance_width.reinterpret_as_int(),
      x_ppem,
    )
    let vert_advance = match ensure_vmtx() {
      Some(vmtx) => {
        let (advance_height, _top_side_bearing) = vmtx.get_metrics(glyph_index)
        scale_design_units_to_pixels(
          advance_height.reinterpret_as_int(),
          y_ppem,
        )
      }
      None =>
        scale_design_units_to_pixels(face.ascender() - face.descender(), y_ppem)
    }
    @base.GlyphSlotData::new(
      bitmap.width().reinterpret_as_int().to_int64(),
      bitmap.rows().reinterpret_as_int().to_int64(),
      left.to_int64(),
      top.to_int64(),
      hori_advance.to_int64(),
      metrics_vert_bearing_x=left.to_int64(),
      metrics_vert_bearing_y=0L,
      metrics_vert_advance=vert_advance.to_int64(),
    )
  }
  let load_scaled_outline_fn : (UInt, Int) -> @types.Outline raise @error.FTError = fn(
    glyph_index,
    load_flags,
  ) raise @error.FTError {
    let sanitized_flags = load_flags &
      (-1 ^ @base.LOAD_COLOR) &
      (-1 ^ @base.LOAD_RENDER)
    let (_slot_data, outline, tt_instructions, tt_phantoms) = load_glyph_fn(
      glyph_index, sanitized_flags,
    )
    let x_scale = face.size().metrics().x_scale()
    let y_scale = face.size().metrics().y_scale()
    if x_scale.val() == 0L || y_scale.val() == 0L {
      return outline
    }
    let no_hinting = (sanitized_flags & @base.LOAD_NO_HINTING) != 0
    let force_autohint = (sanitized_flags & @base.LOAD_FORCE_AUTOHINT) != 0
    let did_hint = if !no_hinting && !force_autohint {
      if tt_instructions.length() > 0 {
        tt_hint_fn(
          outline,
          tt_instructions,
          tt_phantoms,
          x_scale,
          y_scale,
          face.size().metrics().y_ppem(),
        )
      } else {
        apply_hints_fn(outline, y_scale)
      }
    } else {
      false
    }
    if !did_hint {
      for i in 0..<outline.n_points() {
        let p = outline.points().unsafe_get(i)
        let sx = @fixed.mul_fix(x_scale, @fixed.Fixed::from_raw(p.x())).val()
        let sy = @fixed.mul_fix(y_scale, @fixed.Fixed::from_raw(p.y())).val()
        outline.points()[i] = @types.Vector::new(sx, sy)
      }
      let has_native_hints = (face.face_flags() & @base.FACE_FLAG_HINTER) != 0L
      let should_autohint = (force_autohint || !has_native_hints) && !no_hinting
      if should_autohint {
        let metrics = @autofit.ScriptMetrics::new()
        metrics.set_scale(x_scale)
        @autofit.auto_hint_outline(outline, metrics)
      }
    }
    outline
  }
  let load_color_glyph_fn : (
    UInt,
    Int,
    UInt,
    UInt,
    Array[@types.Color],
    @types.Color,
  ) -> @base.BitmapGlyphData? raise @error.FTError = fn(
    glyph_index,
    load_flags,
    x_ppem,
    y_ppem,
    _palette,
    _foreground_color,
  ) raise @error.FTError {
    if (load_flags & @base.LOAD_NO_BITMAP) != 0 ||
      (load_flags & @base.LOAD_NO_SCALE) != 0 ||
      x_ppem == 0U ||
      y_ppem == 0U {
      return None
    }
    match color_tables {
      Some(tables) =>
        match @color.load_sbix_glyph(tables, glyph_index, x_ppem, y_ppem) {
          Some((bitmap, left, top)) => {
            let slot_data = make_bitmap_slot_data(
              glyph_index, bitmap, left, top, x_ppem, y_ppem,
            )
            Some(@base.BitmapGlyphData::new(slot_data, bitmap, left, top))
          }
          None =>
            match tables.cblc() {
              Some(cblc) =>
                match
                  @color.load_cblc_glyph(cblc, glyph_index, x_ppem, y_ppem) {
                  Some(glyph) => Some(glyph)
                  None =>
                    match tables.colr() {
                      Some(colr) =>
                        match
                          render_colr_bitmap_glyph(
                            colr,
                            glyph_index,
                            load_flags,
                            face.palette(),
                            face.foreground_color(),
                            face.var_coords(),
                            face.size().metrics().x_scale(),
                            face.size().metrics().y_scale(),
                            load_scaled_outline_fn,
                          ) {
                          Some((bitmap, left, top)) => {
                            let slot_data = make_bitmap_slot_data(
                              glyph_index, bitmap, left, top, x_ppem, y_ppem,
                            )
                            Some(
                              @base.BitmapGlyphData::new(
                                slot_data, bitmap, left, top,
                              ),
                            )
                          }
                          None => None
                        }
                      None => None
                    }
                }
              None =>
                match tables.colr() {
                  Some(colr) =>
                    match
                      render_colr_bitmap_glyph(
                        colr,
                        glyph_index,
                        load_flags,
                        face.palette(),
                        face.foreground_color(),
                        face.var_coords(),
                        face.size().metrics().x_scale(),
                        face.size().metrics().y_scale(),
                        load_scaled_outline_fn,
                      ) {
                      Some((bitmap, left, top)) => {
                        let slot_data = make_bitmap_slot_data(
                          glyph_index, bitmap, left, top, x_ppem, y_ppem,
                        )
                        Some(
                          @base.BitmapGlyphData::new(
                            slot_data, bitmap, left, top,
                          ),
                        )
                      }
                      None => None
                    }
                  None => None
                }
            }
        }
      None => None
    }
  }
  // Lazy kern: defer expensive kern table parsing to first get_kerning() call
  let kern_ref : Ref[@sfnt.KernTable?] = Ref::new(None)
  let kern_parsed : Ref[Bool] = Ref::new(false)
  let kern_fn : (UInt, UInt) -> Int = fn(left, right) {
    if !kern_parsed.val {
      kern_parsed.val = true
      let kern_result = match
        sfnt_data.table_dir().find_table(@types.TAG_KERN) {
        Some(r) => {
          let reader = @stream.ByteReader::new(data)
          let result = try? @sfnt.parse_kern(reader, r.offset(), r.length())
          match result {
            Ok(k) => Some(k)
            Err(_) => None
          }
        }
        None => None
      }
      kern_ref.val = kern_result
    }
    match kern_ref.val {
      Some(k) => k.get_kerning(left, right)
      None => 0
    }
  }
  // Parse fvar if present (variable font support)
  if sfnt_data.table_dir().find_table(@types.TAG_FVAR) is Some(fvar_rec) {
    let fvar_reader = @stream.ByteReader::new(data)
    let fvar_result = try? @truetype.parse_fvar(
      fvar_reader,
      fvar_rec.offset(),
      fvar_rec.length(),
    )
    if fvar_result is Ok(fvar) && fvar.axes().length() > 0 {
      face.set_face_flags(face.face_flags() | @base.FACE_FLAG_MULTIPLE_MASTERS)
      face.set_var_coords(Array::make(fvar.axes().length(), 0))
    }
  }
  if actual_cmap_count > 0 {
    let default_cmap_index = match sfnt_data.cmap() {
      Some(ct) => find_best_cmap_index(ct).unwrap_or(0)
      None => 0
    }
    face.set_active_charmap(default_cmap_index)
  }
  if has_svg {
    face.set_face_flags(
      face.face_flags() | @base.FACE_FLAG_COLOR | @base.FACE_FLAG_SVG,
    )
  }
  match color_tables {
    Some(tables) => {
      if tables.palette_data() is Some(palette_data) {
        face.set_face_flags(face.face_flags() | @base.FACE_FLAG_COLOR)
        face.set_palette_data(Some(palette_data))
        match tables.select_palette(0U) {
          Some(default_palette) => {
            face.set_palette(default_palette)
            face.set_palette_index(0)
          }
          None => ()
        }
      }
      if tables.colr() is Some(_) {
        face.set_face_flags(face.face_flags() | @base.FACE_FLAG_COLOR)
      }
      let bitmap_sizes : Array[@base.BitmapSize] = []
      match tables.sbix() {
        Some(sbix) => {
          face.set_face_flags(
            (
              face.face_flags() |
              @base.FACE_FLAG_COLOR |
              @base.FACE_FLAG_SBIX |
              @base.FACE_FLAG_FIXED_SIZES
            ) &
            (-1L ^ @base.FACE_FLAG_SCALABLE),
          )
          for strike in sbix.strikes() {
            bitmap_sizes.push(
              bitmap_size_from_ppem(strike.ppem(), strike.ppem()),
            )
          }
          if sbix.flags() == 3U {
            face.set_face_flags(
              face.face_flags() | @base.FACE_FLAG_SBIX_OVERLAY,
            )
          }
        }
        None => ()
      }
      match tables.cblc() {
        Some(cblc) => {
          face.set_face_flags(
            face.face_flags() |
            @base.FACE_FLAG_COLOR |
            @base.FACE_FLAG_FIXED_SIZES,
          )
          for strike in cblc.strikes() {
            let x_ppem = strike.ppem_x()
            let y_ppem = strike.ppem_y()
            let mut duplicate = false
            for size in bitmap_sizes {
              if size.x_ppem() == x_ppem.to_int64() << 6 &&
                size.y_ppem() == y_ppem.to_int64() << 6 {
                duplicate = true
                break
              }
            }
            if !duplicate {
              bitmap_sizes.push(bitmap_size_from_ppem(x_ppem, y_ppem))
            }
          }
        }
        None => ()
      }
      if !bitmap_sizes.is_empty() {
        face.set_available_sizes(bitmap_sizes)
      }
    }
    None => ()
  }
  face.set_char_index_fn(char_index_fn)
  face.set_driver_data(
    @base.DriverData::SfntDriver(
      @base.SfntOps::new(
        char_index=char_index_fn,
        char_variant_index=char_variant_index_fn,
        char_variant_is_default=char_variant_is_default_fn,
        variant_selectors=variant_selectors_fn,
        variants_of_char=variants_of_char_fn,
        chars_of_variant=chars_of_variant_fn,
        load_glyph=load_glyph_fn,
        get_kerning=kern_fn,
        apply_hints=apply_hints_fn,
        tt_hint=tt_hint_fn,
        palette_data=palette_data_fn,
        select_palette=select_palette_fn,
        load_color_glyph=load_color_glyph_fn,
        num_glyphs=sfnt_data.maxp().num_glyphs(),
        raw_data=data,
      ),
    ),
  )
  // Add synthetic Adobe charmap for non-CID CFF fonts.
  if has_cff {
    match ensure_cff() {
      Some(cff) =>
        if !cff.top_dict().is_cid() {
          synthetic_adobe_charmap_index.val = face.charmaps().length()
          face
          .charmaps()
          .push(@base.CharMapRec::new(@base.Encoding::Unicode, 7U, 0U))
        }
      None => ()
    }
  }
  face
}

///|
fn find_best_cmap_index(ct : @sfnt.CmapTable) -> Int? {
  let priorities : Array[(UInt, UInt)] = [
    (3U, 10U),
    (0U, 10U),
    (0U, 6U),
    (0U, 4U),
    (3U, 1U),
    (0U, 3U),
    (0U, 2U),
    (0U, 1U),
    (0U, 0U),
  ]
  for _, prio in priorities {
    let (plat, enc) = prio
    for i, sub in ct.subtables() {
      if sub.platform_id() == plat && sub.encoding_id() == enc {
        return Some(i)
      }
    }
  }
  if ct.subtables().length() > 0 {
    Some(0)
  } else {
    None
  }
}

///|
/// Find the best cmap subtable for Unicode lookup.
fn find_best_cmap(
  data : Bytes,
  ct : @sfnt.CmapTable,
  cmap_table_offset : UInt,
) -> @sfnt.CmapLookup? {
  let reader = @stream.ByteReader::new(data)
  // Prefer full-repertoire Unicode subtables before BMP-only ones so
  // supplementary-plane lookups don't get trapped on a 16-bit cmap.
  let priorities : Array[(UInt, UInt)] = [
    (3U, 10U),
    (0U, 10U),
    (0U, 6U),
    (0U, 4U),
    (3U, 1U),
    (0U, 3U),
    (0U, 2U),
    (0U, 1U),
    (0U, 0U),
  ]
  for _, prio in priorities {
    let (plat, enc) = prio
    for _, sub in ct.subtables() {
      if sub.platform_id() == plat && sub.encoding_id() == enc {
        let result = try? @sfnt.parse_cmap_subtable(
          reader,
          cmap_table_offset,
          sub.offset(),
        )
        if result is Ok(cl) {
          return Some(cl)
        }
      }
    }
  }
  // Fallback: first parseable subtable
  for _, sub in ct.subtables() {
    let result = try? @sfnt.parse_cmap_subtable(
      reader,
      cmap_table_offset,
      sub.offset(),
    )
    if result is Ok(cl) {
      return Some(cl)
    }
  }
  None
}
