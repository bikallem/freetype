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
  let tt_ref : Ref[@truetype.TtFaceData??] = Ref::new(None)
  let cff_ref : Ref[@cff.CffFont??] = Ref::new(None)
  let hint_globals_ref : Ref[@pshinter.PsGlobals?] = Ref::new(None)
  // Check table presence (cheap O(1) lookups)
  let has_glyf = sfnt_data.table_dir().find_table(@types.TAG_GLYF) is Some(_)
  let has_cff = sfnt_data.table_dir().find_table(@types.TAG_CFF) is Some(_)
  // Set FACE_FLAG_HINTER eagerly from table directory (avoids lazy TT init)
  if has_glyf &&
    (
      sfnt_data.table_dir().find_table(@types.TAG_FPGM) is Some(_) ||
      sfnt_data.table_dir().find_table(@types.TAG_PREP) is Some(_)
    ) {
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
        } else {
          None
        }
        cff_ref.val = Some(result)
        result
      }
    }
  }
  let ensure_hint_globals = fn() -> @pshinter.PsGlobals {
    match hint_globals_ref.val {
      Some(g) => g
      None => {
        // Use cff_ref directly (already cached if CFF was loaded)
        let g = match cff_ref.val {
          Some(Some(cff)) => {
            let pd = cff.private_dict()
            let defaults = @pshinter.PsGlobals::new()
            @pshinter.build_ps_globals(
              pd.blue_values().map(fn(v) { v.to_int() }),
              pd.other_blues().map(fn(v) { v.to_int() }),
              pd.std_hw().to_int(),
              pd.std_vw().to_int(),
              defaults.blue_scale(),
              defaults.blue_shift().to_int(),
              defaults.blue_fuzz().to_int(),
            )
          }
          _ => @pshinter.PsGlobals::new()
        }
        hint_globals_ref.val = Some(g)
        g
      }
    }
  }
  // Reusable glyph loading buffers (captured by load_glyph_fn closure)
  let glyph_bufs = @truetype.GlyphBufs::new()
  // Cached TT interpreter state: fpgm func_defs + prep-modified CVT + reusable context
  let tt_cached_funcs : Ref[Map[Int, @truetype.FuncDef]?] = Ref::new(None)
  let tt_cached_cvt : Ref[Array[Int64]?] = Ref::new(None)
  let tt_cached_ppem : Ref[UInt] = Ref::new(0U)
  // Reusable interpreter context — avoid allocating new one per glyph
  let tt_reuse_ctx : Ref[@truetype.InterpContext?] = Ref::new(None)
  // Per-face hint state
  let hint_h_hints : Ref[Array[@psaux.StemHint]] = Ref::new([])
  let hint_v_hints : Ref[Array[@psaux.StemHint]] = Ref::new([])
  let hint_has_hints : Ref[Bool] = Ref::new(false)
  // Closure-based driver ops
  // Lazy cmap: resolved on first char_index call, then direct dispatch
  let char_index_ref : Ref[(UInt) -> UInt] = Ref::new(fn(_c) { 0U })
  char_index_ref.val = fn(charcode) {
    let lookup : @sfnt.CmapLookup? = match sfnt_data.cmap() {
      Some(ct) =>
        match sfnt_data.table_dir().find_table(@types.TAG_CMAP) {
          Some(rec) => find_best_cmap(data, ct, rec.offset())
          None => None
        }
      None => None
    }
    let fast_fn : (UInt) -> UInt = match lookup {
      Some(@sfnt.CmapLookup::Format0(t)) => fn(c) { t.char_index(c) }
      Some(@sfnt.CmapLookup::Format4(t)) => fn(c) { t.char_index(c) }
      Some(@sfnt.CmapLookup::Format6(t)) => fn(c) { t.char_index(c) }
      Some(@sfnt.CmapLookup::Format12(t)) => fn(c) { t.char_index(c) }
      None => fn(_c) { 0U }
    }
    char_index_ref.val = fast_fn
    fast_fn(charcode)
  }
  let char_index_fn : (UInt) -> UInt = fn(charcode) {
    (char_index_ref.val)(charcode)
  }
  let load_glyph_fn : (UInt, Int) -> (
    @base.GlyphSlotData,
    @types.Outline,
    Bytes,
  ) raise @error.FTError = fn(glyph_index, load_flags) raise @error.FTError {
    let no_hinting = (load_flags & @base.LOAD_NO_HINTING) != 0
    let tt_data = ensure_tt()
    let cff_font = ensure_cff()
    let (outline, tt_instructions, tt_bbox) = if tt_data is Some(tt) {
      hint_has_hints.val = false
      @truetype.load_tt_glyph(
        data,
        tt.glyph_offsets(),
        tt.glyf_offset(),
        glyph_index,
        glyph_bufs,
      )
    } else if cff_font is Some(cff) {
      let (o, _w, hh, hv) = @cff.load_cff_glyph(cff, glyph_index)
      if no_hinting {
        hint_has_hints.val = false
      } else {
        hint_h_hints.val = hh
        hint_v_hints.val = hv
        hint_has_hints.val = hh.length() > 0 || hv.length() > 0
      }
      (o, b"", @types.BBox::empty())
    } else {
      hint_has_hints.val = false
      (@types.Outline::new(), b"", @types.BBox::empty())
    }
    let hmtx = ensure_hmtx()
    let (advance_width, _lsb) = hmtx.get_metrics(glyph_index)
    // Use glyf header bbox for TT glyphs (avoids scanning all points)
    let bb = if tt_bbox.x_max() != 0L || tt_bbox.y_max() != 0L {
      tt_bbox
    } else {
      @base.outline_get_bbox(outline)
    }
    let slot_data = @base.GlyphSlotData::new(
      bb.x_max() - bb.x_min(),
      bb.y_max() - bb.y_min(),
      bb.x_min(),
      bb.y_max(),
      advance_width.reinterpret_as_int().to_int64(),
    )
    (slot_data, outline, tt_instructions)
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
  let tt_hint_fn : (@types.Outline, Bytes, @fixed.Fixed, @fixed.Fixed, UInt) -> Bool = fn(
    outline,
    instructions,
    x_scale,
    y_scale,
    ppem,
  ) {
    let tt_result = try? ensure_tt()
    let tt_data = match tt_result {
      Ok(d) => d
      Err(_) => return false
    }
    if tt_data is Some(tt) && instructions.length() > 0 {
      // Cache fpgm func_defs + prep-modified CVT per ppem
      if tt_cached_ppem.val != ppem || tt_cached_funcs.val is None {
        // Run fpgm + prep once, cache results
        let init_ctx = @truetype.InterpContext::new(
          cvt=tt.cvt().copy(),
          storage_size=64,
          max_stack=256,
        )
        init_ctx.set_ppem(ppem.reinterpret_as_int())
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
          Array::make(twilight_size, @types.Vector::new(0L, 0L)),
        )
        init_ctx.set_zone0_cur(
          Array::make(twilight_size, @types.Vector::new(0L, 0L)),
        )
        init_ctx.set_zone0_tags(Array::make(twilight_size, b'\x00'))
        init_ctx.set_zone0_points(init_ctx.zone0_cur())
        // Empty glyph zone for fpgm/prep
        init_ctx.set_zone1_org([])
        init_ctx.set_zone1_cur([])
        init_ctx.set_zone1_tags([])
        init_ctx.set_zone1_touch([])
        init_ctx.set_zone1_points(init_ctx.zone1_cur())
        if tt.fpgm().length() > 0 {
          let fpgm_result = try? init_ctx.execute(tt.fpgm())
          if fpgm_result is Err(_) {
            return false
          }
        }
        init_ctx.set_gs(@truetype.GraphicsState::default())
        if tt.prep().length() > 0 {
          let prep_result = try? init_ctx.execute(tt.prep())
          if prep_result is Err(_) {
            return false
          }
        }
        // Cache func_defs and scaled CVT
        tt_cached_funcs.val = Some(init_ctx.func_defs())
        tt_cached_cvt.val = Some(init_ctx.cvt())
        tt_cached_ppem.val = ppem
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
            Array::make(twilight_size, @types.Vector::new(0L, 0L)),
          )
          c.set_zone0_cur(
            Array::make(twilight_size, @types.Vector::new(0L, 0L)),
          )
          c.set_zone0_tags(Array::make(twilight_size, b'\x00'))
          c.set_zone0_points(c.zone0_cur())
          tt_reuse_ctx.val = Some(c)
          c
        }
      }
      // Reset context for this glyph
      ctx.set_cvt(cached_cvt.copy())
      ctx.set_ppem(ppem.reinterpret_as_int())
      ctx.set_func_defs(cached_funcs)
      ctx.reset_sp()
      // Set up glyph zone points
      let n_points = outline.points().length()
      let total_points = n_points + 4
      let zero_vec = @types.Vector::new(0L, 0L)
      ctx.set_zone1_org(Array::make(total_points, zero_vec))
      ctx.set_zone1_cur(Array::make(total_points, @types.Vector::new(0L, 0L)))
      ctx.set_zone1_tags(Array::make(total_points, b'\x00'))
      ctx.set_zone1_touch(Array::make(total_points, b'\x00'))
      ctx.set_zone1_points(ctx.zone1_cur())
      for i in 0..<n_points {
        let sx = @fixed.mul_fix(
          x_scale,
          @fixed.Fixed::from_raw(outline.points()[i].x()),
        ).val()
        let sy = @fixed.mul_fix(
          y_scale,
          @fixed.Fixed::from_raw(outline.points()[i].y()),
        ).val()
        ctx.zone1_org()[i] = @types.Vector::new(sx, sy)
        ctx.zone1_cur()[i] = @types.Vector::new(sx, sy)
        ctx.zone1_tags()[i] = if i < outline.tags().length() {
          outline.tags()[i]
        } else {
          b'\x01'
        }
      }
      // Run glyph instructions only (fpgm+prep already cached)
      ctx.set_gs(@truetype.GraphicsState::default())
      let glyph_result = try? ctx.execute(instructions)
      if glyph_result is Err(_) {
        return false
      }
      for i in 0..<n_points {
        outline.points()[i] = @types.Vector::new(
          ctx.zone1_cur()[i].x(),
          ctx.zone1_cur()[i].y(),
        )
      }
      true
    } else {
      false
    }
  }
  // Lazy kern: defer expensive kern table parsing to first get_kerning() call
  let kern_ref : Ref[@sfnt.KernTable?] = Ref::new(None)
  let kern_parsed : Ref[Bool] = Ref::new(false)
  let kern_fn : (UInt, UInt) -> Int = fn(left, right) {
    if not(kern_parsed.val) {
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
  face.set_driver_data(
    @base.DriverData::SfntDriver(
      @base.SfntOps::new(
        char_index=char_index_fn,
        load_glyph=load_glyph_fn,
        get_kerning=kern_fn,
        apply_hints=apply_hints_fn,
        tt_hint=tt_hint_fn,
        num_glyphs=sfnt_data.maxp().num_glyphs(),
        raw_data=data,
      ),
    ),
  )
  // Add synthetic charmap for CFF fonts
  if has_cff {
    face.charmaps().push(@base.CharMapRec::new(@base.Encoding::Unicode, 7U, 0U))
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
