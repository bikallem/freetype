///|
/// Load a font face from in-memory data.
/// This is the main entry point — replaces C's FT_New_Memory_Face.
/// No Library object needed; API is stateless.
pub fn from_bytes(
  data : Bytes,
  face_index? : Int = 0,
) -> @base.FaceRec raise @error.FTError {
  let format = @base.detect_format(data)
  match format {
    TrueType | CffOpenType | TrueTypeCollection => load_sfnt(data, face_index)
    Woff1 => {
      let decompressed = @sfnt.decompress_woff(data)
      from_bytes(decompressed, face_index~)
    }
    Type1Pfb => load_type1_pfb(data)
    Type1Pfa => {
      let face = @base.FaceRec::new()
      face.face_flags = @base.face_flag_scalable | @base.face_flag_horizontal
      face
    }
    Bdf => {
      let font = @bdf.parse_bdf_header(data)
      let face = @base.FaceRec::new()
      face.family_name = font.font_name
      face.face_flags = @base.face_flag_fixed_sizes | @base.face_flag_horizontal
      face.num_glyphs = (font.num_chars + 1).to_int64()
      face
    }
    Pcf => {
      let face = @base.FaceRec::new()
      face.face_flags = @base.face_flag_fixed_sizes | @base.face_flag_horizontal
      face
    }
    WindowsFnt => {
      let face = @base.FaceRec::new()
      face.face_flags = @base.face_flag_fixed_sizes | @base.face_flag_horizontal
      face
    }
    Pfr => {
      let face = @base.FaceRec::new()
      face.face_flags = @base.face_flag_scalable | @base.face_flag_horizontal
      face
    }
    Woff2 => raise @error.FTError::UnimplementedFeature
    Cid => raise @error.FTError::UnknownFileFormat
    Unknown => raise @error.FTError::UnknownFileFormat
  }
}

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
  let char_index_fn : (UInt) -> UInt = match cmap_lookup {
    Some(cl) => fn(charcode) { cl.char_index(charcode) }
    None => fn(_charcode) { 0U }
  }
  let load_glyph_fn : (UInt, Int) -> (@base.GlyphSlotData, @types.Outline) raise @error.FTError = fn(
    glyph_index,
    load_flags,
  ) raise @error.FTError {
    let outline = if tt_data is Some(tt) {
      @truetype.load_tt_glyph(
        data,
        tt.glyph_offsets,
        tt.glyf_offset,
        glyph_index,
      )
    } else if cff_font is Some(cff) {
      let (o, _w) = @cff.load_cff_glyph(cff, glyph_index)
      o
    } else {
      @types.Outline::new()
    }
    ignore(load_flags)
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
  let kern_fn : (UInt, UInt) -> Int = match kern_table {
    Some(k) => fn(left, right) { k.get_kerning(left, right) }
    None => fn(_left, _right) { 0 }
  }
  face.driver_data = @base.DriverData::SfntDriver({
    char_index: char_index_fn,
    load_glyph: load_glyph_fn,
    get_kerning: kern_fn,
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
  // Set up Type1Ops driver data
  let char_index_fn : (UInt) -> UInt = fn(charcode) {
    if charcode >= 256U {
      return 0U
    }
    let glyph_name = font.encoding[charcode.reinterpret_as_int()]
    if glyph_name == ".notdef" {
      return 0U
    }
    // Find glyph_name in glyph_names list
    for i, name in glyph_names {
      if name == glyph_name {
        return i.reinterpret_as_uint()
      }
    }
    0U
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

// ─── Public API: charmap lookup ──────────────────────────────────────

///|
/// Map a character code to a glyph index using the active charmap.
pub fn get_char_index(face : @base.FaceRec, charcode : UInt) -> UInt {
  match face.driver_data {
    SfntDriver(ops) => (ops.char_index)(charcode)
    Type1Ops(ops) => (ops.char_index)(charcode)
    Empty => 0U
  }
}

// ─── Public API: glyph loading ───────────────────────────────────────

///|
/// Load a glyph into face.glyph. After this call, face.glyph.outline
/// and face.glyph.metrics are populated.
pub fn load_glyph(
  face : @base.FaceRec,
  glyph_index : UInt,
  load_flags? : Int = 0,
) -> Unit raise @error.FTError {
  let (slot_data, outline) = match face.driver_data {
    SfntDriver(ops) => (ops.load_glyph)(glyph_index, load_flags)
    Type1Ops(ops) => (ops.load_glyph)(glyph_index, load_flags)
    Empty => raise @error.FTError::InvalidFaceHandle
  }
  // If NO_SCALE, return font units directly
  let no_scale = (load_flags & @base.load_no_scale) != 0
  face.glyph.glyph_index = glyph_index
  face.glyph.format = @types.GlyphFormat::Outline
  face.glyph.outline = outline
  if no_scale {
    face.glyph.metrics.width = slot_data.metrics_width
    face.glyph.metrics.height = slot_data.metrics_height
    face.glyph.metrics.hori_bearing_x = slot_data.metrics_hori_bearing_x
    face.glyph.metrics.hori_bearing_y = slot_data.metrics_hori_bearing_y
    face.glyph.metrics.hori_advance = slot_data.metrics_hori_advance
  } else {
    // Scale to 26.6 pixels using face.size.metrics
    let x_scale = face.size.metrics.x_scale
    let y_scale = face.size.metrics.y_scale
    if x_scale.val != 0L && y_scale.val != 0L {
      // Scale metrics
      face.glyph.metrics.width = @fixed.mul_fix(
          x_scale,
          @fixed.Fixed::from_raw(slot_data.metrics_width),
        ).val
      face.glyph.metrics.height = @fixed.mul_fix(
          y_scale,
          @fixed.Fixed::from_raw(slot_data.metrics_height),
        ).val
      face.glyph.metrics.hori_bearing_x = @fixed.mul_fix(
          x_scale,
          @fixed.Fixed::from_raw(slot_data.metrics_hori_bearing_x),
        ).val
      face.glyph.metrics.hori_bearing_y = @fixed.mul_fix(
          y_scale,
          @fixed.Fixed::from_raw(slot_data.metrics_hori_bearing_y),
        ).val
      face.glyph.metrics.hori_advance = @fixed.mul_fix(
          x_scale,
          @fixed.Fixed::from_raw(slot_data.metrics_hori_advance),
        ).val
      // Scale outline points
      for i, _pt in face.glyph.outline.points {
        face.glyph.outline.points[i].x = @fixed.mul_fix(
            x_scale,
            @fixed.Fixed::from_raw(face.glyph.outline.points[i].x),
          ).val
        face.glyph.outline.points[i].y = @fixed.mul_fix(
            y_scale,
            @fixed.Fixed::from_raw(face.glyph.outline.points[i].y),
          ).val
      }
    } else {
      // No scale set — return font units
      face.glyph.metrics.width = slot_data.metrics_width
      face.glyph.metrics.height = slot_data.metrics_height
      face.glyph.metrics.hori_bearing_x = slot_data.metrics_hori_bearing_x
      face.glyph.metrics.hori_bearing_y = slot_data.metrics_hori_bearing_y
      face.glyph.metrics.hori_advance = slot_data.metrics_hori_advance
    }
  }
}

// ─── Public API: size management ─────────────────────────────────────

///|
/// Set the pixel size for subsequent glyph loading.
/// Computes scale factors from ppem and units_per_em.
pub fn set_pixel_sizes(
  face : @base.FaceRec,
  pixel_width : UInt,
  pixel_height : UInt,
) -> Unit raise @error.FTError {
  let upe = face.units_per_em
  if upe == 0U {
    raise @error.FTError::InvalidPixelSize
  }
  let pw = if pixel_width == 0U { pixel_height } else { pixel_width }
  let ph = if pixel_height == 0U { pixel_width } else { pixel_height }
  // Scale: (ppem << 6) in 26.6, then div by upe to get 16.16 scale factor
  let x_scale = @fixed.div_fix(
    pw.reinterpret_as_int().to_int64() << 6,
    upe.reinterpret_as_int().to_int64(),
  )
  let y_scale = @fixed.div_fix(
    ph.reinterpret_as_int().to_int64() << 6,
    upe.reinterpret_as_int().to_int64(),
  )
  face.size.metrics.x_ppem = pw
  face.size.metrics.y_ppem = ph
  face.size.metrics.x_scale = x_scale
  face.size.metrics.y_scale = y_scale
  face.size.metrics.ascender = @fixed.mul_fix(
      y_scale,
      @fixed.Fixed::from_raw(face.ascender.to_int64()),
    ).val
  face.size.metrics.descender = @fixed.mul_fix(
      y_scale,
      @fixed.Fixed::from_raw(face.descender.to_int64()),
    ).val
  face.size.metrics.height = @fixed.mul_fix(
      y_scale,
      @fixed.Fixed::from_raw(face.height.to_int64()),
    ).val
  face.size.metrics.max_advance = @fixed.mul_fix(
      x_scale,
      @fixed.Fixed::from_raw(face.max_advance_width.to_int64()),
    ).val
}

// ─── Public API: kerning ─────────────────────────────────────────────

///|
/// Get kerning between two glyphs. Returns (x, y) in font units.
pub fn get_kerning(
  face : @base.FaceRec,
  left_glyph : UInt,
  right_glyph : UInt,
) -> (Int64, Int64) {
  match face.driver_data {
    SfntDriver(ops) => {
      let x = (ops.get_kerning)(left_glyph, right_glyph)
      (x.to_int64(), 0L)
    }
    Empty | Type1Ops(_) => (0L, 0L)
  }
}
