///|
/// Load a simple glyph from the 'glyf' table.
/// Returns the parsed outline (points, tags, contours) and the glyph bbox.
///
/// Simple glyph layout:
///   numberOfContours (i16) — already read, passed as parameter
///   xMin, yMin, xMax, yMax (i16 each)
///   endPtsOfContours[numberOfContours] (u16 each)
///   instructionLength (u16)
///   instructions[instructionLength] (byte each)
///   flags[] (compressed: repeat flag)
///   xCoordinates[] (compressed: delta-encoded)
///   yCoordinates[] (compressed: delta-encoded)
pub fn load_simple_glyph(
  reader : @stream.ByteReader,
  num_contours : Int,
) -> (@types.Outline, Bytes) raise @error.FTError {
  if num_contours <= 0 {
    return (@types.Outline::new(), b"")
  }
  // Read bbox (4 × i16), skip — we compute it from points
  let _x_min = reader.read_i16_be()
  let _y_min = reader.read_i16_be()
  let _x_max = reader.read_i16_be()
  let _y_max = reader.read_i16_be()
  // Read end points of contours
  let contours : Array[UInt] = []
  for _ in 0..<num_contours {
    contours.push(reader.read_u16_be())
  }
  let n_points = if num_contours > 0 {
    contours[num_contours - 1].reinterpret_as_int() + 1
  } else {
    0
  }
  // Read instructions
  let instruction_length = reader.read_u16_be().reinterpret_as_int()
  let instructions = if instruction_length > 0 {
    reader.read_bytes(instruction_length)
  } else {
    b""
  }
  // Read flags (compressed with repeat)
  let flags : Array[Byte] = []
  let mut i = 0
  while i < n_points {
    let flag = reader.read_byte()
    flags.push(flag)
    i += 1
    // Bit 3: repeat flag
    if (flag & 0x08) != b'\x00' {
      let repeat_count = reader.read_byte().to_int()
      for _ in 0..<repeat_count {
        flags.push(flag)
        i += 1
      }
    }
  }
  // Read x coordinates (delta-encoded)
  let x_coords : Array[Int64] = []
  let mut x = 0L
  for _, flag in flags {
    let x_short = (flag & 0x02) != b'\x00' // bit 1: x is 1 byte
    let x_same = (flag & 0x10) != b'\x00' // bit 4: x same or positive
    if x_short {
      let delta = reader.read_byte().to_int().to_int64()
      if x_same {
        x += delta
      } else {
        x -= delta
      }
    } else if not(x_same) {
      // 2-byte signed delta
      x += reader.read_i16_be().to_int64()
    }
    // else: x_same && !x_short → x unchanged
    x_coords.push(x)
  }
  // Read y coordinates (delta-encoded)
  let y_coords : Array[Int64] = []
  let mut y = 0L
  for _, flag in flags {
    let y_short = (flag & 0x04) != b'\x00' // bit 2: y is 1 byte
    let y_same = (flag & 0x20) != b'\x00' // bit 5: y same or positive
    if y_short {
      let delta = reader.read_byte().to_int().to_int64()
      if y_same {
        y += delta
      } else {
        y -= delta
      }
    } else if not(y_same) {
      y += reader.read_i16_be().to_int64()
    }
    y_coords.push(y)
  }
  // Build outline
  let points : Array[@types.Vector] = []
  let tags : Array[Byte] = []
  for i, flag in flags {
    points.push({ x: x_coords[i], y: y_coords[i] })
    // Convert TT flags to FreeType tags:
    // Bit 0 of TT flag = on-curve (1) or off-curve (0)
    let on_curve = (flag & 0x01) != b'\x00'
    tags.push(
      if on_curve {
        @types.curve_tag_on
      } else {
        @types.curve_tag_conic
      },
    )
  }
  ({ points, tags, contours, flags: 0 }, instructions)
}

///|
/// A composite glyph component parsed from 'glyf'.
pub(all) struct CompositeComponent {
  flags : UInt
  glyph_index : UInt
  arg1 : Int // x offset or point index
  arg2 : Int // y offset or point index
  xx : @fixed.Fixed // transform matrix (identity if no transform)
  xy : @fixed.Fixed
  yx : @fixed.Fixed
  yy : @fixed.Fixed
} derive(Show)

///|
/// Parse composite glyph components from the reader.
/// Reader should be positioned right after the numberOfContours field.
pub fn load_composite_glyph(
  reader : @stream.ByteReader,
) -> Array[CompositeComponent] raise @error.FTError {
  // Skip bbox (4 × i16)
  let _x_min = reader.read_i16_be()
  let _y_min = reader.read_i16_be()
  let _x_max = reader.read_i16_be()
  let _y_max = reader.read_i16_be()
  let components : Array[CompositeComponent] = []
  let mut has_more = true
  while has_more {
    let flags = reader.read_u16_be()
    let glyph_index = reader.read_u16_be()
    // Read arguments
    let (arg1, arg2) = if (flags & arg_1_and_2_are_words) != 0U {
      if (flags & args_are_xy_values) != 0U {
        (reader.read_i16_be(), reader.read_i16_be())
      } else {
        (
          reader.read_u16_be().reinterpret_as_int(),
          reader.read_u16_be().reinterpret_as_int(),
        )
      }
    } else if (flags & args_are_xy_values) != 0U {
      // 2 signed bytes
      let a1 = reader.read_byte().to_int()
      let a1_signed = if a1 >= 128 { a1 - 256 } else { a1 }
      let a2 = reader.read_byte().to_int()
      let a2_signed = if a2 >= 128 { a2 - 256 } else { a2 }
      (a1_signed, a2_signed)
    } else {
      // 2 unsigned bytes (point indices)
      (reader.read_byte().to_int(), reader.read_byte().to_int())
    }
    // Read transformation matrix
    let mut xx = @fixed.Fixed::one()
    let mut xy = @fixed.Fixed::zero()
    let mut yx = @fixed.Fixed::zero()
    let mut yy = @fixed.Fixed::one()
    if (flags & we_have_a_scale) != 0U {
      // Single scale factor (F2Dot14)
      let scale = @fixed.F2Dot14::from_raw(reader.read_i16_be())
      xx = scale.to_fixed()
      yy = scale.to_fixed()
    } else if (flags & we_have_an_x_and_y_scale) != 0U {
      xx = @fixed.F2Dot14::from_raw(reader.read_i16_be()).to_fixed()
      yy = @fixed.F2Dot14::from_raw(reader.read_i16_be()).to_fixed()
    } else if (flags & we_have_a_two_by_two) != 0U {
      xx = @fixed.F2Dot14::from_raw(reader.read_i16_be()).to_fixed()
      yx = @fixed.F2Dot14::from_raw(reader.read_i16_be()).to_fixed()
      xy = @fixed.F2Dot14::from_raw(reader.read_i16_be()).to_fixed()
      yy = @fixed.F2Dot14::from_raw(reader.read_i16_be()).to_fixed()
    }
    components.push({ flags, glyph_index, arg1, arg2, xx, xy, yx, yy })
    has_more = (flags & more_components) != 0U
  }
  components
}

///|
/// Load a glyph from a TrueType font, returning the outline.
/// Handles both simple and composite glyphs (recursively).
/// `glyph_index` is the glyph to load.
/// `data` is the raw font data, `offsets` from loca table, `glyf_offset` is the glyf table offset.
pub fn load_tt_glyph(
  data : Bytes,
  glyph_offsets : Array[UInt],
  glyf_offset : UInt,
  glyph_index : UInt,
  depth? : Int = 0,
) -> (@types.Outline, Bytes) raise @error.FTError {
  if depth > 32 {
    raise @error.FTError::InvalidComposite // prevent infinite recursion
  }
  let idx = glyph_index.reinterpret_as_int()
  if idx >= glyph_offsets.length() - 1 {
    return (@types.Outline::new(), b"") // .notdef or out of range
  }
  let glyph_start = glyf_offset + glyph_offsets[idx]
  let glyph_end = glyf_offset + glyph_offsets[idx + 1]
  if glyph_start == glyph_end {
    return (@types.Outline::new(), b"") // empty glyph (e.g., space)
  }
  let reader = @stream.ByteReader::new(data)
  reader.seek(glyph_start.reinterpret_as_int())
  let num_contours = reader.read_i16_be()
  if num_contours >= 0 {
    // Simple glyph
    load_simple_glyph(reader, num_contours)
  } else {
    // Composite glyph
    let components = load_composite_glyph(reader)
    let loader = @base.GlyphLoader::new()
    for _, comp in components {
      // Recursively load component glyph
      let (sub_outline, _sub_instr) = load_tt_glyph(
        data,
        glyph_offsets,
        glyf_offset,
        comp.glyph_index,
        depth=depth + 1,
      )
      // Apply transformation if needed
      let has_transform = (comp.flags & we_have_a_scale) != 0U ||
        (comp.flags & we_have_an_x_and_y_scale) != 0U ||
        (comp.flags & we_have_a_two_by_two) != 0U
      // Add points to loader
      for j, point in sub_outline.points {
        let mut px = point.x
        let mut py = point.y
        if has_transform {
          let matrix : @fixed.Matrix = {
            xx: comp.xx,
            xy: comp.xy,
            yx: comp.yx,
            yy: comp.yy,
          }
          let (rx, ry) = matrix.transform(px, py)
          px = rx
          py = ry
        }
        // Apply offset (args are xy values)
        if (comp.flags & args_are_xy_values) != 0U {
          px += comp.arg1.to_int64()
          py += comp.arg2.to_int64()
        }
        loader.add_point(px, py, sub_outline.tags[j])
      }
      // Add contour end points
      for _ in sub_outline.contours {
        loader.end_contour()
      }
      loader.add()
    }
    // Composite glyphs: no per-glyph instructions returned
    (loader.to_outline(), b"")
  }
}
