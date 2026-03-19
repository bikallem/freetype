///|
/// Reusable glyph loading buffers to avoid per-glyph allocation.
/// Captured by the glyph loading closure and reused across loads.
pub struct GlyphBufs {
  mut flags : FixedArray[Byte]
  mut x_coords : FixedArray[Int64]
  // Reusable outline arrays — avoids per-glyph allocation
  mut points : FixedArray[@types.Vector]
  mut tags : FixedArray[Byte]
  mut contours : FixedArray[UInt]
} derive(Show)

///|
pub fn GlyphBufs::new() -> GlyphBufs {
  {
    flags: FixedArray::default(),
    x_coords: FixedArray::default(),
    points: FixedArray::default(),
    tags: FixedArray::default(),
    contours: FixedArray::default(),
  }
}

///|
fn GlyphBufs::ensure_flags(self : GlyphBufs, n : Int) -> FixedArray[Byte] {
  if self.flags.length() < n {
    self.flags = @blit.make_uninit(n)
  }
  self.flags
}

///|
fn GlyphBufs::ensure_x_coords(self : GlyphBufs, n : Int) -> FixedArray[Int64] {
  if self.x_coords.length() < n {
    self.x_coords = FixedArray::make(n, 0L)
  }
  self.x_coords
}

///|
fn GlyphBufs::ensure_points(
  self : GlyphBufs,
  n : Int,
) -> FixedArray[@types.Vector] {
  if self.points.length() < n {
    self.points = FixedArray::make(n, @types.Vector::new(0L, 0L))
  }
  self.points
}

///|
fn GlyphBufs::ensure_tags(self : GlyphBufs, n : Int) -> FixedArray[Byte] {
  if self.tags.length() < n {
    self.tags = @blit.make_uninit(n)
  }
  self.tags
}

///|
fn GlyphBufs::ensure_contours(self : GlyphBufs, n : Int) -> FixedArray[UInt] {
  if self.contours.length() < n {
    self.contours = FixedArray::make(n, 0U)
  }
  self.contours
}

///|
/// Read a big-endian signed 16-bit integer from raw bytes.
fn read_i16(data : Bytes, pos : Int) -> Int {
  let v = (data[pos].to_int() << 8) | data[pos + 1].to_int()
  if v >= 0x8000 {
    v - 0x10000
  } else {
    v
  }
}

///|
/// Load a simple glyph from the 'glyf' table.
/// Uses reusable buffers for flags and x_coords to avoid per-glyph allocation.
/// Points, tags, and contours FixedArrays are still allocated per glyph
/// since the Outline takes ownership of them.
pub fn load_simple_glyph(
  data : Bytes,
  start_pos : Int,
  num_contours : Int,
  bufs : GlyphBufs,
) -> (@types.Outline, Int, Int, @types.BBox) {
  // Returns (outline, instr_offset, instr_length, bbox)
  if num_contours <= 0 {
    return (@types.Outline::new(), 0, 0, @types.BBox::empty())
  }
  let mut pos = start_pos
  // Read bbox from glyf header (4 × i16)
  let x_min = read_i16(data, pos).to_int64()
  let y_min = read_i16(data, pos + 2).to_int64()
  let x_max = read_i16(data, pos + 4).to_int64()
  let y_max = read_i16(data, pos + 6).to_int64()
  let bbox = @types.BBox::new(x_min, y_min, x_max, y_max)
  pos += 8
  // Read end points of contours — reuse buffer
  let contours = bufs.ensure_contours(num_contours)
  for i in 0..<num_contours {
    let hi = data[pos].to_int()
    let lo = data[pos + 1].to_int()
    contours.unsafe_set(i, ((hi << 8) | lo).reinterpret_as_uint())
    pos += 2
  }
  let n_points = contours.unsafe_get(num_contours - 1).reinterpret_as_int() + 1
  // Read instruction length — skip over instructions, copy lazily
  let instr_hi = data[pos].to_int()
  let instr_lo = data[pos + 1].to_int()
  let instruction_length = (instr_hi << 8) | instr_lo
  pos += 2
  let instr_offset = pos
  pos += instruction_length
  // Read flags (compressed with repeat) — reuse buffer
  let flags = bufs.ensure_flags(n_points)
  let mut fi = 0
  while fi < n_points {
    let flag = data[pos]
    pos += 1
    flags.unsafe_set(fi, flag)
    fi += 1
    if (flag & 0x08) != b'\x00' {
      let repeat_count = data[pos].to_int()
      pos += 1
      for _ in 0..<repeat_count {
        if fi < n_points {
          flags.unsafe_set(fi, flag)
          fi += 1
        }
      }
    }
  }
  // Read x coordinates (delta-encoded) — reuse buffer
  let x_coords = bufs.ensure_x_coords(n_points)
  let mut x = 0L
  for i in 0..<n_points {
    let flag = flags.unsafe_get(i)
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
    x_coords.unsafe_set(i, x)
  }
  // Read y coordinates and build points + tags in one pass — reuse buffers
  let points = bufs.ensure_points(n_points)
  let tags = bufs.ensure_tags(n_points)
  let mut y = 0L
  for i in 0..<n_points {
    let flag = flags.unsafe_get(i)
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
    points.unsafe_set(i, @types.Vector::new(x_coords.unsafe_get(i), y))
    tags.unsafe_set(
      i,
      if (flag & 0x01) != b'\x00' {
        @types.CURVE_TAG_ON
      } else {
        @types.CURVE_TAG_CONIC
      },
    )
  }
  (
    @types.Outline::create_with_counts(
      points, tags, contours, n_points, num_contours,
    ),
    instr_offset,
    instruction_length,
    bbox,
  )
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
pub fn load_tt_glyph(
  data : Bytes,
  glyph_offsets : Array[UInt],
  glyf_offset : UInt,
  glyph_index : UInt,
  bufs : GlyphBufs,
  depth? : Int = 0,
) -> (@types.Outline, Int, Int, @types.BBox) raise @error.FTError {
  // Returns (outline, instr_offset, instr_length, bbox)
  // Caller copies instructions only when hinting is needed
  if depth > 32 {
    raise @error.FTError::InvalidComposite
  }
  let idx = glyph_index.reinterpret_as_int()
  if idx >= glyph_offsets.length() - 1 {
    return (@types.Outline::new(), 0, 0, @types.BBox::empty())
  }
  let glyph_start = glyf_offset + glyph_offsets.unsafe_get(idx)
  let glyph_end = glyf_offset + glyph_offsets.unsafe_get(idx + 1)
  if glyph_start == glyph_end {
    return (@types.Outline::new(), 0, 0, @types.BBox::empty())
  }
  let start = glyph_start.reinterpret_as_int()
  let num_contours = read_i16(data, start)
  if num_contours >= 0 {
    load_simple_glyph(data, start + 2, num_contours, bufs)
  } else {
    // Composite glyph — read bbox from header
    let comp_bbox = @types.BBox::new(
      read_i16(data, start + 2).to_int64(),
      read_i16(data, start + 4).to_int64(),
      read_i16(data, start + 6).to_int64(),
      read_i16(data, start + 8).to_int64(),
    )
    let reader = @stream.ByteReader::new(data)
    reader.seek(start + 2)
    let components = load_composite_glyph(reader)
    let loader = @base.GlyphLoader::new()
    for _, comp in components {
      let (sub_outline, _sub_instr_off, _sub_instr_len, _sub_bbox) = load_tt_glyph(
        data,
        glyph_offsets,
        glyf_offset,
        comp.glyph_index,
        bufs,
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
    (loader.to_outline(), 0, 0, comp_bbox)
  }
}
