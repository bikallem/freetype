///|
/// Load a simple glyph from the 'glyf' table.
/// Returns the parsed outline (points, tags, contours) and the glyph instructions.
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
  let contours : Array[UInt] = Array::new(capacity=num_contours)
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
  // Read flags (compressed with repeat) — use FixedArray to avoid growth
  let flags = FixedArray::make(n_points, b'\x00')
  let mut fi = 0
  while fi < n_points {
    let flag = reader.read_byte()
    flags[fi] = flag
    fi += 1
    // Bit 3: repeat flag
    if (flag & 0x08) != b'\x00' {
      let repeat_count = reader.read_byte().to_int()
      for _ in 0..<repeat_count {
        if fi < n_points {
          flags[fi] = flag
          fi += 1
        }
      }
    }
  }
  // Read x coordinates (delta-encoded) directly into FixedArray
  let x_coords = FixedArray::make(n_points, 0L)
  let mut x = 0L
  for i in 0..<n_points {
    let flag = flags[i]
    let x_short = (flag & 0x02) != b'\x00'
    let x_same = (flag & 0x10) != b'\x00'
    if x_short {
      let delta = reader.read_byte().to_int().to_int64()
      if x_same {
        x += delta
      } else {
        x -= delta
      }
    } else if !x_same {
      x += reader.read_i16_be().to_int64()
    }
    x_coords[i] = x
  }
  // Read y coordinates and build points + tags in one pass
  let points : Array[@types.Vector] = Array::new(capacity=n_points)
  let tags : Array[Byte] = Array::new(capacity=n_points)
  let mut y = 0L
  for i in 0..<n_points {
    let flag = flags[i]
    let y_short = (flag & 0x04) != b'\x00'
    let y_same = (flag & 0x20) != b'\x00'
    if y_short {
      let delta = reader.read_byte().to_int().to_int64()
      if y_same {
        y += delta
      } else {
        y -= delta
      }
    } else if !y_same {
      y += reader.read_i16_be().to_int64()
    }
    points.push(@types.Vector::new(x_coords[i], y))
    tags.push(
      if (flag & 0x01) != b'\x00' {
        @types.CURVE_TAG_ON
      } else {
        @types.CURVE_TAG_CONIC
      },
    )
  }
  (@types.Outline::create(points, tags, contours), instructions)
}

///|
/// A composite glyph component parsed from 'glyf'.
struct CompositeComponent {
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
    let (arg1, arg2) = if (flags & ARG_1_AND_2_ARE_WORDS) != 0U {
      if (flags & ARGS_ARE_XY_VALUES) != 0U {
        (reader.read_i16_be(), reader.read_i16_be())
      } else {
        (
          reader.read_u16_be().reinterpret_as_int(),
          reader.read_u16_be().reinterpret_as_int(),
        )
      }
    } else if (flags & ARGS_ARE_XY_VALUES) != 0U {
      let a1 = reader.read_byte().to_int()
      let a1_signed = if a1 >= 128 { a1 - 256 } else { a1 }
      let a2 = reader.read_byte().to_int()
      let a2_signed = if a2 >= 128 { a2 - 256 } else { a2 }
      (a1_signed, a2_signed)
    } else {
      (reader.read_byte().to_int(), reader.read_byte().to_int())
    }
    // Read transformation matrix
    let mut xx = @fixed.Fixed::one()
    let mut xy = @fixed.Fixed::zero()
    let mut yx = @fixed.Fixed::zero()
    let mut yy = @fixed.Fixed::one()
    if (flags & WE_HAVE_A_SCALE) != 0U {
      let scale = @fixed.F2Dot14::from_raw(reader.read_i16_be())
      xx = scale.to_fixed()
      yy = scale.to_fixed()
    } else if (flags & WE_HAVE_AN_X_AND_Y_SCALE) != 0U {
      xx = @fixed.F2Dot14::from_raw(reader.read_i16_be()).to_fixed()
      yy = @fixed.F2Dot14::from_raw(reader.read_i16_be()).to_fixed()
    } else if (flags & WE_HAVE_A_TWO_BY_TWO) != 0U {
      xx = @fixed.F2Dot14::from_raw(reader.read_i16_be()).to_fixed()
      yx = @fixed.F2Dot14::from_raw(reader.read_i16_be()).to_fixed()
      xy = @fixed.F2Dot14::from_raw(reader.read_i16_be()).to_fixed()
      yy = @fixed.F2Dot14::from_raw(reader.read_i16_be()).to_fixed()
    }
    components.push({ flags, glyph_index, arg1, arg2, xx, xy, yx, yy })
    has_more = (flags & MORE_COMPONENTS) != 0U
  }
  components
}

///|
/// Load a glyph from a TrueType font, returning the outline.
/// Handles both simple and composite glyphs (recursively).
pub fn load_tt_glyph(
  data : Bytes,
  glyph_offsets : Array[UInt],
  glyf_offset : UInt,
  glyph_index : UInt,
  depth? : Int = 0,
) -> (@types.Outline, Bytes) raise @error.FTError {
  if depth > 32 {
    raise @error.FTError::InvalidComposite
  }
  let idx = glyph_index.reinterpret_as_int()
  if idx >= glyph_offsets.length() - 1 {
    return (@types.Outline::new(), b"")
  }
  let glyph_start = glyf_offset + glyph_offsets[idx]
  let glyph_end = glyf_offset + glyph_offsets[idx + 1]
  if glyph_start == glyph_end {
    return (@types.Outline::new(), b"")
  }
  let reader = @stream.ByteReader::new(data)
  reader.seek(glyph_start.reinterpret_as_int())
  let num_contours = reader.read_i16_be()
  if num_contours >= 0 {
    load_simple_glyph(reader, num_contours)
  } else {
    let components = load_composite_glyph(reader)
    let loader = @base.GlyphLoader::new()
    for _, comp in components {
      let (sub_outline, _sub_instr) = load_tt_glyph(
        data,
        glyph_offsets,
        glyf_offset,
        comp.glyph_index,
        depth=depth + 1,
      )
      let has_transform = (comp.flags & WE_HAVE_A_SCALE) != 0U ||
        (comp.flags & WE_HAVE_AN_X_AND_Y_SCALE) != 0U ||
        (comp.flags & WE_HAVE_A_TWO_BY_TWO) != 0U
      for j, point in sub_outline.points() {
        let mut px = point.x()
        let mut py = point.y()
        if has_transform {
          let matrix = @fixed.Matrix::new(comp.xx, comp.xy, comp.yx, comp.yy)
          let (rx, ry) = matrix.transform(px, py)
          px = rx
          py = ry
        }
        if (comp.flags & ARGS_ARE_XY_VALUES) != 0U {
          px += comp.arg1.to_int64()
          py += comp.arg2.to_int64()
        }
        loader.add_point(px, py, sub_outline.tags()[j])
      }
      for _ in sub_outline.contours() {
        loader.end_contour()
      }
      loader.add()
    }
    (loader.to_outline(), b"")
  }
}
