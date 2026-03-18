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
      // Apply PS hinting or plain scaling to outline points
      let no_hinting = (load_flags & @base.load_no_hinting) != 0
      let did_hint = if not(no_hinting) {
        match face.driver_data {
          SfntDriver(ops) => (ops.apply_hints)(face.glyph.outline, y_scale)
          _ => false
        }
      } else {
        false
      }
      if not(did_hint) {
        // Plain scaling: scale outline points
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
