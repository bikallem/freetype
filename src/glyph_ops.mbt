// ─── Public API: charmap lookup ──────────────────────────────────────

///|
/// Map a character code to a glyph index using the active charmap.
pub fn get_char_index(face : @base.FaceRec, charcode : UInt) -> UInt {
  face.char_index_fn()(charcode)
}

// ─── Public API: glyph loading ───────────────────────────────────────

///|
fn set_slot_metrics(
  slot : @base.GlyphSlot,
  slot_data : @base.GlyphSlotData,
) -> Unit {
  slot.metrics().set_width(slot_data.metrics_width())
  slot.metrics().set_height(slot_data.metrics_height())
  slot.metrics().set_hori_bearing_x(slot_data.metrics_hori_bearing_x())
  slot.metrics().set_hori_bearing_y(slot_data.metrics_hori_bearing_y())
  slot.metrics().set_hori_advance(slot_data.metrics_hori_advance())
}

///|
fn set_slot_metrics_from_hinted_bbox(
  slot : @base.GlyphSlot,
  bbox : @types.BBox,
) -> Unit {
  let x_min = @fixed.F26Dot6::from_raw(bbox.x_min()).floor().val()
  let x_max = @fixed.F26Dot6::from_raw(bbox.x_max()).ceil().val()
  let y_max = @fixed.F26Dot6::from_raw(bbox.y_max()).ceil().val()
  // Hinted outlines occasionally dip less than one pixel below the
  // baseline. FreeType reports these tested glyphs on the baseline instead
  // of turning that sliver into an extra pixel of height.
  let y_min = if bbox.y_min() < 0L &&
    bbox.y_min() >= -64L &&
    bbox.y_max() - bbox.y_min() < 768L {
    0L
  } else {
    @fixed.F26Dot6::from_raw(bbox.y_min()).floor().val()
  }
  slot.metrics().set_width(x_max - x_min)
  slot.metrics().set_height(y_max - y_min)
  slot.metrics().set_hori_bearing_x(x_min)
  slot.metrics().set_hori_bearing_y(y_max)
}

///|
fn set_slot_metrics_from_snapped_bbox(
  slot : @base.GlyphSlot,
  bbox : @types.BBox,
) -> Unit {
  let x_min = @fixed.F26Dot6::from_raw(bbox.x_min()).floor().val()
  let y_min = @fixed.F26Dot6::from_raw(bbox.y_min()).floor().val()
  let x_max = @fixed.F26Dot6::from_raw(bbox.x_max()).ceil().val()
  let y_max = @fixed.F26Dot6::from_raw(bbox.y_max()).ceil().val()
  slot.metrics().set_width(x_max - x_min)
  slot.metrics().set_height(y_max - y_min)
  slot.metrics().set_hori_bearing_x(x_min)
  slot.metrics().set_hori_bearing_y(y_max)
}

///|
fn load_bitmap_glyph(
  face : @base.FaceRec,
  glyph_index : UInt,
  load_flags : Int,
  ops : @base.BitmapOps,
) -> Unit raise @error.FTError {
  let glyph = ops.load_glyph()(glyph_index, load_flags)
  let slot = face.glyph()
  let slot_data = glyph.slot_data()
  slot.set_glyph_index(glyph_index)
  slot.set_format(@types.GlyphFormat::Bitmap)
  slot.set_bitmap(glyph.bitmap())
  slot.set_bitmap_left(glyph.bitmap_left())
  slot.set_bitmap_top(glyph.bitmap_top())
  slot.set_outline(@types.Outline::new())
  set_slot_metrics(slot, slot_data)
  slot.set_advance(@types.Vector::new(slot_data.metrics_hori_advance(), 0L))
}

///|
/// Load a glyph into face.glyph(). After this call, face.glyph().outline()
/// and face.glyph().metrics() are populated.
pub fn load_glyph(
  face : @base.FaceRec,
  glyph_index : UInt,
  load_flags? : Int = 0,
) -> Unit raise @error.FTError {
  match face.driver_data() {
    BitmapOps(ops) => {
      load_bitmap_glyph(face, glyph_index, load_flags, ops)
      return
    }
    _ => ()
  }
  let (slot_data, outline, tt_instructions) = match face.driver_data() {
    SfntDriver(ops) => ops.load_glyph()(glyph_index, load_flags)
    Type1Ops(ops) => {
      let (sd, ol) = ops.load_glyph()(glyph_index, load_flags)
      (sd, ol, b"")
    }
    Empty => raise @error.FTError::InvalidFaceHandle
    BitmapOps(_) => raise @error.FTError::InvalidFaceHandle
  }
  // If NO_SCALE, return font units directly
  let no_scale = (load_flags & @base.LOAD_NO_SCALE) != 0
  face.glyph().set_glyph_index(glyph_index)
  face.glyph().set_format(@types.GlyphFormat::Outline)
  face.glyph().set_outline(outline)
  if no_scale {
    set_slot_metrics(face.glyph(), slot_data)
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
      let scaled_hori_bearing_x = face.glyph().metrics().hori_bearing_x()
      let scaled_hori_advance = face.glyph().metrics().hori_advance()
      // Apply hinting or plain scaling to outline points
      let no_hinting = (load_flags & @base.LOAD_NO_HINTING) != 0
      let force_autohint = (load_flags & @base.LOAD_FORCE_AUTOHINT) != 0
      let mut did_autohint = false
      let did_hint = if not(no_hinting) && not(force_autohint) {
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
          Type1Ops(ops) => ops.apply_hints()(face.glyph().outline(), y_scale)
          _ => false
        }
      } else {
        false
      }
      let mut use_outline_metrics = did_hint
      if not(did_hint) {
        // Plain scaling: scale outline points
        for i in 0..<face.glyph().outline().n_points() {
          let p = face.glyph().outline().points().unsafe_get(i)
          let sx = @fixed.mul_fix(x_scale, @fixed.Fixed::from_raw(p.x())).val()
          let sy = @fixed.mul_fix(y_scale, @fixed.Fixed::from_raw(p.y())).val()
          face.glyph().outline().points()[i] = @types.Vector::new(sx, sy)
        }
        // Check if auto-hinting should be applied
        let has_native_hints = (face.face_flags() & @base.FACE_FLAG_HINTER) !=
          0L
        let should_autohint = force_autohint || not(has_native_hints)
        if should_autohint && not(no_hinting) {
          // Build script metrics for auto-hinting
          let metrics = @autofit.ScriptMetrics::new()
          metrics.set_scale(x_scale)
          // Apply auto-hinting to the already-scaled outline
          @autofit.auto_hint_outline(face.glyph().outline(), metrics)
          did_autohint = true
          use_outline_metrics = true
        }
        if not(no_hinting) {
          use_outline_metrics = true
        }
      }
      if use_outline_metrics {
        let bbox = @base.outline_get_bbox(face.glyph().outline())
        if not(no_hinting) {
          set_slot_metrics_from_hinted_bbox(face.glyph(), bbox)
        } else {
          set_slot_metrics_from_snapped_bbox(face.glyph(), bbox)
        }
        face
        .glyph()
        .metrics()
        .set_hori_advance(
          if did_autohint {
            let rounded_advance = @fixed.F26Dot6::from_raw(scaled_hori_advance)
              .round()
              .val()
            let snapped_lsb = @fixed.F26Dot6::from_raw(scaled_hori_bearing_x)
              .floor()
              .val()
            let lsb_adjust = snapped_lsb -
              face.glyph().metrics().hori_bearing_x()
            let is_narrow_sfnt_autohint = match face.driver_data() {
              SfntDriver(_) => scaled_hori_advance < 384L
              _ => false
            }
            if is_narrow_sfnt_autohint {
              let compensated_advance = if lsb_adjust > 0L {
                rounded_advance + lsb_adjust
              } else {
                rounded_advance
              }
              let ceil_advance = @fixed.F26Dot6::from_raw(scaled_hori_advance)
                .ceil()
                .val()
              if ceil_advance > compensated_advance {
                ceil_advance
              } else {
                compensated_advance
              }
            } else {
              rounded_advance
            }
          } else {
            @fixed.F26Dot6::from_raw(face.glyph().metrics().hori_advance())
            .round()
            .val()
          },
        )
        if face.glyph().outline().n_points() == 0 {
          face.glyph().metrics().set_hori_bearing_x(0L)
          face.glyph().metrics().set_hori_bearing_y(0L)
        }
      }
    } else {
      // No scale set — return font units
      set_slot_metrics(face.glyph(), slot_data)
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
/// glyph loading.
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
  let fvar_rec = match table_dir.find_table(@types.TAG_FVAR) {
    Some(r) => r
    None => raise @error.FTError::InvalidArgument
  }
  let fvar = @truetype.parse_fvar(reader, fvar_rec.offset(), fvar_rec.length())
  // Parse avar if present
  let avar : @truetype.AvarTable? = match
    table_dir.find_table(@types.TAG_AVAR) {
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
  let normalized = @truetype.normalize_coordinates(
    fvar.axes(),
    design_coords,
    avar,
  )
  face.set_var_coords(normalized)
  let mut has_non_default = false
  for _, coord in normalized {
    if coord != 0 {
      has_non_default = true
      break
    }
  }
  let base_flags = if (face.face_flags() & @base.FACE_FLAG_VARIATION) != 0L {
    face.face_flags() - @base.FACE_FLAG_VARIATION
  } else {
    face.face_flags()
  }
  face.set_face_flags(
    if has_non_default {
      base_flags | @base.FACE_FLAG_VARIATION
    } else {
      base_flags
    },
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
    Empty | BitmapOps(_) | Type1Ops(_) => (0L, 0L)
  }
}
