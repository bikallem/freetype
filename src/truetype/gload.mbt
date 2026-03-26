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
fn build_phantom_points(
  bbox : @types.BBox,
  advance_width : UInt,
  lsb : Int,
) -> Array[@types.Vector] {
  let left = bbox.x_min() - lsb.to_int64()
  let right = left + advance_width.reinterpret_as_int().to_int64()
  [
    @types.Vector::new(left, 0L),
    @types.Vector::new(right, 0L),
    @types.Vector::new(0L, bbox.y_max()),
    @types.Vector::new(0L, bbox.y_min()),
  ]
}

///|
fn empty_phantom_points() -> Array[@types.Vector] {
  [
    @types.Vector::new(0L, 0L),
    @types.Vector::new(0L, 0L),
    @types.Vector::new(0L, 0L),
    @types.Vector::new(0L, 0L),
  ]
}

///|
fn transform_tt_point(
  point : @types.Vector,
  component : CompositeComponent,
) -> @types.Vector {
  let has_transform = (component.flags & WE_HAVE_A_SCALE) != 0U ||
    (component.flags & WE_HAVE_AN_X_AND_Y_SCALE) != 0U ||
    (component.flags & WE_HAVE_A_TWO_BY_TWO) != 0U
  let mut px = point.x()
  let mut py = point.y()
  if has_transform {
    let matrix = @fixed.Matrix::new(
      component.xx,
      component.xy,
      component.yx,
      component.yy,
    )
    let (rx, ry) = matrix.transform(px, py)
    px = rx
    py = ry
  }
  if (component.flags & ARGS_ARE_XY_VALUES) != 0U {
    px += component.arg1.to_int64()
    py += component.arg2.to_int64()
  }
  @types.Vector::new(px, py)
}

///|
fn apply_simple_gvar_to_outline(
  outline : @types.Outline,
  phantoms : Array[@types.Vector],
  delta_x : Array[Int64],
  delta_y : Array[Int64],
) -> Unit {
  for i in 0..<outline.n_points() {
    let point = outline.points().unsafe_get(i)
    outline.points()[i] = @types.Vector::new(
      point.x() + delta_x[i],
      point.y() + delta_y[i],
    )
  }
  let base = outline.n_points()
  if phantoms.length() >= 4 &&
    delta_x.length() >= base + 4 &&
    delta_y.length() >= base + 4 {
    phantoms[0] = @types.Vector::new(
      phantoms[0].x() + delta_x[base],
      phantoms[0].y(),
    )
    phantoms[1] = @types.Vector::new(
      phantoms[1].x() + delta_x[base + 1],
      phantoms[1].y(),
    )
    phantoms[2] = @types.Vector::new(
      phantoms[2].x(),
      phantoms[2].y() + delta_y[base + 2],
    )
    phantoms[3] = @types.Vector::new(
      phantoms[3].x(),
      phantoms[3].y() + delta_y[base + 3],
    )
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
/// Load a glyph from a TrueType font, returning the outline and phantom points.
/// Handles both simple and composite glyphs (recursively).
pub fn load_tt_glyph_with_phantoms(
  data : Bytes,
  glyph_offsets : Array[UInt],
  glyf_offset : UInt,
  glyph_index : UInt,
  bufs : GlyphBufs,
  hmtx? : @sfnt.HmtxTable? = None,
  gvar? : GvarTable? = None,
  var_coords? : Array[Int] = [],
  depth? : Int = 0,
) -> (@types.Outline, Int, Int, @types.BBox, Array[@types.Vector]) raise @error.FTError {
  // Returns (outline, instr_offset, instr_length, bbox, phantom_points)
  // Caller copies instructions only when hinting is needed
  if depth > 32 {
    raise @error.FTError::InvalidComposite
  }
  let default_phantoms = empty_phantom_points()
  let idx = glyph_index.reinterpret_as_int()
  if idx >= glyph_offsets.length() - 1 {
    return (@types.Outline::new(), 0, 0, @types.BBox::empty(), default_phantoms)
  }
  let glyph_start = glyf_offset + glyph_offsets.unsafe_get(idx)
  let glyph_end = glyf_offset + glyph_offsets.unsafe_get(idx + 1)
  let (advance_width, lsb) = match hmtx {
    Some(h) => h.get_metrics(glyph_index)
    None => (0U, 0)
  }
  if glyph_start == glyph_end {
    return (
      @types.Outline::new(),
      0,
      0,
      @types.BBox::empty(),
      build_phantom_points(@types.BBox::empty(), advance_width, lsb),
    )
  }
  let start = glyph_start.reinterpret_as_int()
  let num_contours = read_i16(data, start)
  if num_contours >= 0 {
    let (outline, instr_offset, instruction_length, bbox) = load_simple_glyph(
      data,
      start + 2,
      num_contours,
      bufs,
    )
    let phantoms = build_phantom_points(bbox, advance_width, lsb)
    match gvar {
      Some(table) => {
        let point_count = outline.n_points() + 4
        let (delta_x, delta_y) = compute_gvar_deltas(
          table, data, glyph_index, var_coords, point_count, outline, 0,
        )
        apply_simple_gvar_to_outline(outline, phantoms, delta_x, delta_y)
      }
      None => ()
    }
    (outline, instr_offset, instruction_length, bbox, phantoms)
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
    let phantoms = build_phantom_points(comp_bbox, advance_width, lsb)
    match gvar {
      Some(table) => {
        let (delta_x, delta_y) = compute_gvar_deltas(
          table,
          data,
          glyph_index,
          var_coords,
          components.length() + 4,
          @types.Outline::new(),
          components.length(),
        )
        let phantom_base = components.length()
        if delta_x.length() >= phantom_base + 4 &&
          delta_y.length() >= phantom_base + 4 {
          phantoms[0] = @types.Vector::new(
            phantoms[0].x() + delta_x[phantom_base],
            phantoms[0].y(),
          )
          phantoms[1] = @types.Vector::new(
            phantoms[1].x() + delta_x[phantom_base + 1],
            phantoms[1].y(),
          )
          phantoms[2] = @types.Vector::new(
            phantoms[2].x(),
            phantoms[2].y() + delta_y[phantom_base + 2],
          )
          phantoms[3] = @types.Vector::new(
            phantoms[3].x(),
            phantoms[3].y() + delta_y[phantom_base + 3],
          )
        }
        for i in 0..<components.length() {
          if i < delta_x.length() &&
            i < delta_y.length() &&
            (components[i].flags & ARGS_ARE_XY_VALUES) != 0U {
            let comp = components[i]
            components[i] = {
              flags: comp.flags,
              glyph_index: comp.glyph_index,
              arg1: comp.arg1 + delta_x[i].to_int(),
              arg2: comp.arg2 + delta_y[i].to_int(),
              xx: comp.xx,
              xy: comp.xy,
              yx: comp.yx,
              yy: comp.yy,
            }
          }
        }
      }
      None => ()
    }
    for _, comp in components {
      let (sub_outline, _sub_instr_off, _sub_instr_len, _sub_bbox, sub_phantoms) = load_tt_glyph_with_phantoms(
        data,
        glyph_offsets,
        glyf_offset,
        comp.glyph_index,
        bufs,
        hmtx~,
        gvar~,
        var_coords~,
        depth=depth + 1,
      )
      for j in 0..<sub_outline.n_points() {
        let point = transform_tt_point(sub_outline.points().unsafe_get(j), comp)
        loader.add_point(point.x(), point.y(), sub_outline.tags().unsafe_get(j))
      }
      for _ in 0..<sub_outline.n_contours() {
        loader.end_contour()
      }
      loader.add()
      if (comp.flags & USE_MY_METRICS) != 0U && sub_phantoms.length() >= 4 {
        phantoms[0] = transform_tt_point(sub_phantoms[0], comp)
        phantoms[1] = transform_tt_point(sub_phantoms[1], comp)
        phantoms[2] = transform_tt_point(sub_phantoms[2], comp)
        phantoms[3] = transform_tt_point(sub_phantoms[3], comp)
      }
    }
    (loader.to_outline(), 0, 0, comp_bbox, phantoms)
  }
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
  let (outline, instr_offset, instruction_length, bbox, _phantoms) = load_tt_glyph_with_phantoms(
    data,
    glyph_offsets,
    glyf_offset,
    glyph_index,
    bufs,
    depth~,
  )
  (outline, instr_offset, instruction_length, bbox)
}
