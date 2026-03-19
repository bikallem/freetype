///|
/// Load a simple glyph from the 'glyf' table.
/// Returns the parsed outline (points, tags, contours) and the glyph instructions.
///
/// Optimized: reads all data directly from raw bytes — no ByteReader allocation.
/// Uses @blit.make_uninit for tags array to avoid zeroing memory.
pub fn load_simple_glyph(
  data : Bytes,
  start_pos : Int,
  num_contours : Int,
) -> (@types.Outline, Bytes) {
  if num_contours <= 0 {
    return (@types.Outline::new(), b"")
  }
  let mut pos = start_pos
  // Skip bbox (4 × i16) — we compute it from points
  pos += 8
  // Read end points of contours
  let contours : FixedArray[UInt] = FixedArray::make(num_contours, 0U)
  for i in 0..<num_contours {
    let hi = data[pos].to_int()
    let lo = data[pos + 1].to_int()
    contours.unsafe_set(i, ((hi << 8) | lo).reinterpret_as_uint())
    pos += 2
  }
  let n_points = contours.unsafe_get(num_contours - 1).reinterpret_as_int() + 1
  // Read instruction length and instructions
  let instr_hi = data[pos].to_int()
  let instr_lo = data[pos + 1].to_int()
  let instruction_length = (instr_hi << 8) | instr_lo
  pos += 2
  let instructions = if instruction_length > 0 {
    data[pos:pos + instruction_length].to_bytes()
  } else {
    b""
  }
  pos += instruction_length
  // Read flags (compressed with repeat)
  let flags = @blit.make_uninit(n_points)
  let mut fi = 0
  while fi < n_points {
    let flag = data[pos]
    pos += 1
    flags[fi] = flag
    fi += 1
    if (flag & 0x08) != b'\x00' {
      let repeat_count = data[pos].to_int()
      pos += 1
      for _ in 0..<repeat_count {
        if fi < n_points {
          flags[fi] = flag
          fi += 1
        }
      }
    }
  }
  // Read x coordinates (delta-encoded) directly from bytes
  let x_coords = FixedArray::make(n_points, 0L)
  let mut x = 0L
  for i in 0..<n_points {
    let flag = flags[i]
    let x_short = (flag & 0x02) != b'\x00'
    let x_same = (flag & 0x10) != b'\x00'
    if x_short {
      let delta = data[pos].to_int().to_int64()
      pos += 1
      x = if x_same { x + delta } else { x - delta }
    } else if !x_same {
      let hi = data[pos].to_int()
      let lo = data[pos + 1].to_int()
      pos += 2
      let v = (hi << 8) | lo
      let signed_v = if v >= 0x8000 { v - 0x10000 } else { v }
      x += signed_v.to_int64()
    }
    x_coords[i] = x
  }
  // Read y coordinates and build points + tags in one pass
  let zero_vec = @types.Vector::new(0L, 0L)
  let points : FixedArray[@types.Vector] = FixedArray::make(n_points, zero_vec)
  let tags : FixedArray[Byte] = @blit.make_uninit(n_points)
  let mut y = 0L
  for i in 0..<n_points {
    let flag = flags[i]
    let y_short = (flag & 0x04) != b'\x00'
    let y_same = (flag & 0x20) != b'\x00'
    if y_short {
      let delta = data[pos].to_int().to_int64()
      pos += 1
      y = if y_same { y + delta } else { y - delta }
    } else if !y_same {
      let hi = data[pos].to_int()
      let lo = data[pos + 1].to_int()
      pos += 2
      let v = (hi << 8) | lo
      let signed_v = if v >= 0x8000 { v - 0x10000 } else { v }
      y += signed_v.to_int64()
    }
    points.unsafe_set(i, @types.Vector::new(x_coords[i], y))
    tags.unsafe_set(
      i,
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
///
/// Optimized: reads num_contours directly from raw bytes and avoids
/// ByteReader allocation for simple glyphs (the hot path).
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
  // Read num_contours directly from raw bytes — avoid ByteReader for simple glyphs
  let start = glyph_start.reinterpret_as_int()
  let hi = data[start].to_int()
  let lo = data[start + 1].to_int()
  let num_contours_raw = (hi << 8) | lo
  let num_contours = if num_contours_raw >= 0x8000 {
    num_contours_raw - 0x10000
  } else {
    num_contours_raw
  }
  if num_contours >= 0 {
    // Simple glyph — pass raw data + position, no ByteReader needed
    load_simple_glyph(data, start + 2, num_contours)
  } else {
    // Composite glyph — use ByteReader (rare path, not performance-critical)
    let reader = @stream.ByteReader::new(data)
    reader.seek(start + 2)
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
      for j in 0..<sub_outline.n_points() {
        let point = sub_outline.points().unsafe_get(j)
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
        loader.add_point(px, py, sub_outline.tags().unsafe_get(j))
      }
      for _ in 0..<sub_outline.n_contours() {
        loader.end_contour()
      }
      loader.add()
    }
    (loader.to_outline(), b"")
  }
}
