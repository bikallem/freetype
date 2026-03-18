// ─── Public API: charmap lookup ──────────────────────────────────────

///|
/// Map a character code to a glyph index using the active charmap.
pub fn get_char_index(face : @base.FaceRec, charcode : UInt) -> UInt {
  match face.driver_data() {
    SfntDriver(ops) => ops.char_index()(charcode)
    Type1Ops(ops) => ops.char_index()(charcode)
    Empty => 0U
  }
}

// ─── Public API: glyph loading ───────────────────────────────────────

///|
/// Load a glyph into face.glyph(). After this call, face.glyph().outline()
/// and face.glyph().metrics() are populated.
pub fn load_glyph(
  face : @base.FaceRec,
  glyph_index : UInt,
  load_flags? : Int = 0,
) -> Unit raise @error.FTError {
  let (slot_data, outline, tt_instructions) = match face.driver_data() {
    SfntDriver(ops) => ops.load_glyph()(glyph_index, load_flags)
    Type1Ops(ops) => {
      let (sd, ol) = ops.load_glyph()(glyph_index, load_flags)
      (sd, ol, b"")
    }
    Empty => raise @error.FTError::InvalidFaceHandle
  }
  // If NO_SCALE, return font units directly
  let no_scale = (load_flags & @base.load_no_scale) != 0
  face.glyph().set_glyph_index(glyph_index)
  face.glyph().set_format(@types.GlyphFormat::Outline)
  face.glyph().set_outline(outline)
  if no_scale {
    face.glyph().metrics().set_width(slot_data.metrics_width())
    face.glyph().metrics().set_height(slot_data.metrics_height())
    face
    .glyph()
    .metrics()
    .set_hori_bearing_x(slot_data.metrics_hori_bearing_x())
    face
    .glyph()
    .metrics()
    .set_hori_bearing_y(slot_data.metrics_hori_bearing_y())
    face.glyph().metrics().set_hori_advance(slot_data.metrics_hori_advance())
  } else {
    // Scale to 26.6 pixels using face.size().metrics()
    let x_scale = face.size().metrics().x_scale()
    let y_scale = face.size().metrics().y_scale()
    if x_scale.val() != 0L && y_scale.val() != 0L {
      // Scale metrics
      face
      .glyph()
      .metrics()
      .set_width(
        @fixed.mul_fix(
          x_scale,
          @fixed.Fixed::from_raw(slot_data.metrics_width()),
        ).val(),
      )
      face
      .glyph()
      .metrics()
      .set_height(
        @fixed.mul_fix(
          y_scale,
          @fixed.Fixed::from_raw(slot_data.metrics_height()),
        ).val(),
      )
      face
      .glyph()
      .metrics()
      .set_hori_bearing_x(
        @fixed.mul_fix(
          x_scale,
          @fixed.Fixed::from_raw(slot_data.metrics_hori_bearing_x()),
        ).val(),
      )
      face
      .glyph()
      .metrics()
      .set_hori_bearing_y(
        @fixed.mul_fix(
          y_scale,
          @fixed.Fixed::from_raw(slot_data.metrics_hori_bearing_y()),
        ).val(),
      )
      face
      .glyph()
      .metrics()
      .set_hori_advance(
        @fixed.mul_fix(
          x_scale,
          @fixed.Fixed::from_raw(slot_data.metrics_hori_advance()),
        ).val(),
      )
      // Apply hinting or plain scaling to outline points
      let no_hinting = (load_flags & @base.load_no_hinting) != 0
      let did_hint = if not(no_hinting) {
        match face.driver_data() {
          SfntDriver(ops) =>
            // Try TT bytecode hinting first (for TrueType glyphs with instructions)
            if tt_instructions.length() > 0 {
              ops.tt_hint()(
                face.glyph().outline(),
                tt_instructions,
                x_scale,
                y_scale,
                face.size().metrics().y_ppem(),
              )
            } else {
              // Fall back to PS hinting (for CFF/OpenType glyphs)
              ops.apply_hints()(face.glyph().outline(), y_scale)
            }
          _ => false
        }
      } else {
        false
      }
      if not(did_hint) {
        // Plain scaling: scale outline points
        for i, _pt in face.glyph().outline().points() {
          face.glyph().outline().points()[i].set_x(
            @fixed.mul_fix(
              x_scale,
              @fixed.Fixed::from_raw(face.glyph().outline().points()[i].x()),
            ).val(),
          )
          face.glyph().outline().points()[i].set_y(
            @fixed.mul_fix(
              y_scale,
              @fixed.Fixed::from_raw(face.glyph().outline().points()[i].y()),
            ).val(),
          )
        }
        // Check if auto-hinting should be applied
        let force_autohint = (load_flags & @base.load_force_autohint) != 0
        let has_native_hints = (face.face_flags() & @base.face_flag_hinter) !=
          0L
        let should_autohint = force_autohint || not(has_native_hints)
        if should_autohint && not(no_hinting) {
          // Build script metrics for auto-hinting
          let metrics = @autofit.ScriptMetrics::new()
          metrics.set_scale(x_scale)
          // Apply auto-hinting to the already-scaled outline
          @autofit.auto_hint_outline(face.glyph().outline(), metrics)
        }
      }
    } else {
      // No scale set — return font units
      face.glyph().metrics().set_width(slot_data.metrics_width())
      face.glyph().metrics().set_height(slot_data.metrics_height())
      face
      .glyph()
      .metrics()
      .set_hori_bearing_x(slot_data.metrics_hori_bearing_x())
      face
      .glyph()
      .metrics()
      .set_hori_bearing_y(slot_data.metrics_hori_bearing_y())
      face.glyph().metrics().set_hori_advance(slot_data.metrics_hori_advance())
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
  let upe = face.units_per_em()
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
  face.size().metrics().set_x_ppem(pw)
  face.size().metrics().set_y_ppem(ph)
  face.size().metrics().set_x_scale(x_scale)
  face.size().metrics().set_y_scale(y_scale)
  face
  .size()
  .metrics()
  .set_ascender(
    @fixed.mul_fix(y_scale, @fixed.Fixed::from_raw(face.ascender().to_int64())).val(),
  )
  face
  .size()
  .metrics()
  .set_descender(
    @fixed.mul_fix(y_scale, @fixed.Fixed::from_raw(face.descender().to_int64())).val(),
  )
  face
  .size()
  .metrics()
  .set_height(
    @fixed.mul_fix(y_scale, @fixed.Fixed::from_raw(face.height().to_int64())).val(),
  )
  face
  .size()
  .metrics()
  .set_max_advance(
    @fixed.mul_fix(
      x_scale,
      @fixed.Fixed::from_raw(face.max_advance_width().to_int64()),
    ).val(),
  )
}

// ─── Public API: font variations ─────────────────────────────────────

///|
/// Set variation design coordinates on a face.
/// Validates and normalizes the coordinates, storing them for use during
/// glyph loading. Actual gvar delta application is not yet implemented.
pub fn set_var_design_coordinates(
  face : @base.FaceRec,
  coordinates : Array[(@fixed.Fixed, UInt)],
) -> Unit raise @error.FTError {
  // Face must be an SFNT with fvar data (multiple masters flag)
  if not(face.has_multiple_masters()) {
    raise @error.FTError::InvalidArgument
  }
  // Retrieve fvar axes from the raw font data
  let raw_data = match face.driver_data() {
    SfntDriver(ops) => ops.raw_data()
    _ => raise @error.FTError::InvalidFaceHandle
  }
  let reader = @stream.ByteReader::new(raw_data)
  // Re-parse table directory to find fvar
  reader.seek(0)
  let table_dir = @sfnt.parse_table_directory(reader)
  let fvar_rec = match table_dir.find_table(@types.tag_fvar) {
    Some(r) => r
    None => raise @error.FTError::InvalidArgument
  }
  let fvar = @truetype.parse_fvar(reader, fvar_rec.offset(), fvar_rec.length())
  // Parse avar if present
  let avar : @truetype.AvarTable? = match
    table_dir.find_table(@types.tag_avar) {
    Some(r) =>
      Some(
        @truetype.parse_avar(
          reader,
          r.offset(),
          r.length(),
          fvar.axes().length(),
        ),
      )
    None => None
  }
  // Build design coordinate array matching axis order
  let design_coords : Array[@fixed.Fixed] = []
  for _, axis in fvar.axes() {
    let mut found = false
    for _, coord in coordinates {
      let (value, tag) = coord
      if tag == axis.tag() {
        design_coords.push(value)
        found = true
        break
      }
    }
    if not(found) {
      design_coords.push(axis.default_value())
    }
  }
  // Normalize and store
  face.set_var_coords(
    @truetype.normalize_coordinates(fvar.axes(), design_coords, avar),
  )
}

// ─── Public API: kerning ─────────────────────────────────────────────

///|
/// Get kerning between two glyphs. Returns (x, y) in font units.
pub fn get_kerning(
  face : @base.FaceRec,
  left_glyph : UInt,
  right_glyph : UInt,
) -> (Int64, Int64) {
  match face.driver_data() {
    SfntDriver(ops) => {
      let x = ops.get_kerning()(left_glyph, right_glyph)
      (x.to_int64(), 0L)
    }
    Empty | Type1Ops(_) => (0L, 0L)
  }
}
