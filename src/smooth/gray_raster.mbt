///|
let pixel_bits : Int = 8

///|
let one_pixel : Int = 1 << pixel_bits

///|
let one_pixel_i64 : Int64 = one_pixel.to_int64()

///|
priv struct GrayAccum {
  cover : Int64
  area : Int64
}

///|
fn GrayAccum::new(cover? : Int64 = 0L, area? : Int64 = 0L) -> GrayAccum {
  { cover, area }
}

///|
priv struct GrayWorker {
  outline : @types.Outline
  width : Int
  rows : Int
  min_ex : Int
  max_ex : Int
  min_ey : Int
  max_ey : Int
  mut current_ex : Int
  mut current_ey : Int
  mut current_valid : Bool
  mut x : Int64
  mut y : Int64
  row_cells : Array[Map[Int, GrayAccum]]
  row_xs : Array[Array[Int]]
}

///|
fn GrayWorker::new(
  outline : @types.Outline,
  width : Int,
  rows : Int,
) -> GrayWorker {
  let row_cells : Array[Map[Int, GrayAccum]] = []
  let row_xs : Array[Array[Int]] = []
  for _ in 0..<rows {
    row_cells.push({})
    row_xs.push([])
  }
  {
    outline,
    width,
    rows,
    min_ex: 0,
    max_ex: width,
    min_ey: 0,
    max_ey: rows,
    current_ex: 0,
    current_ey: 0,
    current_valid: false,
    x: 0L,
    y: 0L,
    row_cells,
    row_xs,
  }
}

///|
fn abs_i64(value : Int64) -> Int64 {
  if value < 0L {
    -value
  } else {
    value
  }
}

///|
fn floor_div(a : Int64, b : Int64) -> Int64 {
  let mut q = a / b
  let r = a % b
  if r < 0L {
    q -= 1L
  }
  q
}

///|
fn ceil_div(a : Int64, b : Int64) -> Int64 {
  -floor_div(-a, b)
}

///|
fn trunc_coord(x : Int64) -> Int {
  floor_div(x, one_pixel_i64).to_int()
}

///|
fn fract_coord(x : Int64) -> Int {
  (x - trunc_coord(x).to_int64() * one_pixel_i64).to_int()
}

///|
fn upscale_26dot6(x : Int64) -> Int64 {
  x * (one_pixel >> 6).to_int64()
}

///|
fn ft_udiv(a : Int64, b : Int64) -> Int {
  if b == 0L {
    return 0
  }
  ((
    (a.reinterpret_as_uint64() * (0xFFFFFFFFUL / b.reinterpret_as_uint64())) >>
    32
  ) &
  0xFFFFFFFFUL)
  .reinterpret_as_int64()
  .to_int()
}

///|
fn clamp_coverage(area : Int64, even_odd : Bool) -> Int {
  let mut coverage = (area >> (pixel_bits * 2 + 1 - 8)).to_int()
  let fill = if even_odd { 0x100 } else { -2147483648 }
  if (coverage & fill) != 0 {
    coverage = -coverage - 1
  }
  if coverage > 255 && !even_odd {
    coverage = 255
  }
  if coverage < 0 {
    coverage = coverage & 0xFF
  }
  coverage
}

///|
fn GrayWorker::set_cell(self : GrayWorker, ex : Int, ey : Int) -> Unit {
  if ey < self.min_ey || ey >= self.max_ey || ex >= self.max_ex {
    self.current_valid = false
    return
  }
  self.current_ex = if ex < self.min_ex - 1 { self.min_ex - 1 } else { ex }
  self.current_ey = ey
  self.current_valid = true
}

///|
fn GrayWorker::integrate(
  self : GrayWorker,
  cover : Int64,
  area : Int64,
) -> Unit {
  if !self.current_valid {
    return
  }
  let row = self.current_ey
  let ex = self.current_ex
  let cells = self.row_cells[row]
  match cells.get(ex) {
    Some(acc) =>
      cells[ex] = GrayAccum::new(
        cover=acc.cover + cover,
        area=acc.area + cover * area,
      )
    None => {
      cells[ex] = GrayAccum::new(cover~, area=cover * area)
      self.row_xs[row].push(ex)
    }
  }
}

///|
fn GrayWorker::render_line(
  self : GrayWorker,
  to_x : Int64,
  to_y : Int64,
) -> Unit {
  let mut ey1 = trunc_coord(self.y)
  let ey2 = trunc_coord(to_y)

  if (ey1 >= self.max_ey && ey2 >= self.max_ey) ||
    (ey1 < self.min_ey && ey2 < self.min_ey) {
    self.x = to_x
    self.y = to_y
    return
  }

  let mut ex1 = trunc_coord(self.x)
  let ex2 = trunc_coord(to_x)
  let mut fx1 = fract_coord(self.x)
  let mut fy1 = fract_coord(self.y)
  let dx = to_x - self.x
  let dy = to_y - self.y

  if ex1 == ex2 && ey1 == ey2 {
    ()
  } else if dy == 0L {
    self.set_cell(ex2, ey2)
  } else if dx == 0L {
    let ex = ex1
    let two_fx = fx1 << 1
    if dy > 0L {
      while ey1 != ey2 {
        let fy2 = one_pixel
        self.integrate((fy2 - fy1).to_int64(), two_fx.to_int64())
        fy1 = 0
        ey1 += 1
        self.set_cell(ex, ey1)
      }
    } else {
      while ey1 != ey2 {
        let fy2 = 0
        self.integrate((fy2 - fy1).to_int64(), two_fx.to_int64())
        fy1 = one_pixel
        ey1 -= 1
        self.set_cell(ex, ey1)
      }
    }
  } else {
    let mut prod = dx * fy1.to_int64() - dy * fx1.to_int64()
    while ex1 != ex2 || ey1 != ey2 {
      if prod - dx * one_pixel_i64 > 0L && prod <= 0L {
        let fx2 = 0
        let fy2 = ft_udiv(-prod, -dx)
        prod -= dy * one_pixel_i64
        self.integrate((fy2 - fy1).to_int64(), (fx1 + fx2).to_int64())
        fx1 = one_pixel
        fy1 = fy2
        ex1 -= 1
      } else if prod - dx * one_pixel_i64 + dy * one_pixel_i64 > 0L &&
        prod - dx * one_pixel_i64 <= 0L {
        prod -= dx * one_pixel_i64
        let fx2 = ft_udiv(-prod, dy)
        let fy2 = one_pixel
        self.integrate((fy2 - fy1).to_int64(), (fx1 + fx2).to_int64())
        fx1 = fx2
        fy1 = 0
        ey1 += 1
      } else if prod + dy * one_pixel_i64 >= 0L &&
        prod - dx * one_pixel_i64 + dy * one_pixel_i64 <= 0L {
        prod += dy * one_pixel_i64
        let fx2 = one_pixel
        let fy2 = ft_udiv(prod, dx)
        self.integrate((fy2 - fy1).to_int64(), (fx1 + fx2).to_int64())
        fx1 = 0
        fy1 = fy2
        ex1 += 1
      } else {
        let fx2 = ft_udiv(prod, -dy)
        let fy2 = 0
        prod += dx * one_pixel_i64
        self.integrate((fy2 - fy1).to_int64(), (fx1 + fx2).to_int64())
        fx1 = fx2
        fy1 = one_pixel
        ey1 -= 1
      }
      self.set_cell(ex1, ey1)
    }
  }

  let fx2 = fract_coord(to_x)
  let fy2 = fract_coord(to_y)
  self.integrate((fy2 - fy1).to_int64(), (fx1 + fx2).to_int64())
  self.x = to_x
  self.y = to_y
}

///|
fn GrayWorker::render_conic(
  self : GrayWorker,
  control : @types.Vector,
  to : @types.Vector,
) -> Unit {
  let p0 = @types.Vector::new(self.x, self.y)
  let p1 = @types.Vector::new(
    upscale_26dot6(control.x()),
    upscale_26dot6(control.y()),
  )
  let p2 = @types.Vector::new(upscale_26dot6(to.x()), upscale_26dot6(to.y()))

  if (
      trunc_coord(p0.y()) >= self.max_ey &&
      trunc_coord(p1.y()) >= self.max_ey &&
      trunc_coord(p2.y()) >= self.max_ey
    ) ||
    (
      trunc_coord(p0.y()) < self.min_ey &&
      trunc_coord(p1.y()) < self.min_ey &&
      trunc_coord(p2.y()) < self.min_ey
    ) {
    self.x = p2.x()
    self.y = p2.y()
    return
  }

  let bx = p1.x() - p0.x()
  let by = p1.y() - p0.y()
  let ax = p2.x() - p1.x() - bx
  let ay = p2.y() - p1.y() - by
  let mut dx = abs_i64(ax)
  let dy = abs_i64(ay)
  if dx < dy {
    dx = dy
  }

  if dx <= one_pixel_i64 / 4L {
    self.render_line(p2.x(), p2.y())
    return
  }

  let mut shift = 16
  while dx > one_pixel_i64 / 4L {
    dx = dx >> 2
    shift -= 1
  }
  let mut count = 0x10000 >> shift

  let mut rx = ax << (shift + shift)
  let mut ry = ay << (shift + shift)
  let mut qx = (bx << (shift + 17)) + rx
  let mut qy = (by << (shift + 17)) + ry
  rx *= 2L
  ry *= 2L
  let mut px = p0.x() << 32
  let mut py = p0.y() << 32

  while count > 0 {
    px += qx
    py += qy
    qx += rx
    qy += ry
    self.render_line(px >> 32, py >> 32)
    count -= 1
  }
}

///|
fn split_cubic(base : Array[@types.Vector], arc : Int) -> Unit {
  let mut a = 0L
  let mut b = 0L
  let mut c = 0L

  base[arc + 6] = base[arc + 3]
  a = base[arc].x() + base[arc + 1].x()
  b = base[arc + 1].x() + base[arc + 2].x()
  c = base[arc + 2].x() + base[arc + 3].x()
  base[arc + 5] = @types.Vector::new(c >> 1, base[arc + 5].y())
  c += b
  base[arc + 4] = @types.Vector::new(c >> 2, base[arc + 4].y())
  base[arc + 1] = @types.Vector::new(a >> 1, base[arc + 1].y())
  a += b
  base[arc + 2] = @types.Vector::new(a >> 2, base[arc + 2].y())
  base[arc + 3] = @types.Vector::new((a + c) >> 3, base[arc + 3].y())

  base[arc + 6] = @types.Vector::new(base[arc + 6].x(), base[arc + 3].y())
  a = base[arc].y() + base[arc + 1].y()
  b = base[arc + 1].y() + base[arc + 2].y()
  c = base[arc + 2].y() + base[arc + 3].y()
  base[arc + 5] = @types.Vector::new(base[arc + 5].x(), c >> 1)
  c += b
  base[arc + 4] = @types.Vector::new(base[arc + 4].x(), c >> 2)
  base[arc + 1] = @types.Vector::new(base[arc + 1].x(), a >> 1)
  a += b
  base[arc + 2] = @types.Vector::new(base[arc + 2].x(), a >> 2)
  base[arc + 3] = @types.Vector::new(base[arc + 3].x(), (a + c) >> 3)
}

///|
fn GrayWorker::render_cubic(
  self : GrayWorker,
  control1 : @types.Vector,
  control2 : @types.Vector,
  to : @types.Vector,
) -> Unit {
  let stack = Array::make(16 * 3 + 1, @types.Vector::new(0L, 0L))
  stack[0] = @types.Vector::new(upscale_26dot6(to.x()), upscale_26dot6(to.y()))
  stack[1] = @types.Vector::new(
    upscale_26dot6(control2.x()),
    upscale_26dot6(control2.y()),
  )
  stack[2] = @types.Vector::new(
    upscale_26dot6(control1.x()),
    upscale_26dot6(control1.y()),
  )
  stack[3] = @types.Vector::new(self.x, self.y)
  let mut arc = 0

  for ;; {
    let p0 = stack[arc]
    let p1 = stack[arc + 1]
    let p2 = stack[arc + 2]
    let p3 = stack[arc + 3]
    if (
        trunc_coord(p0.y()) >= self.max_ey &&
        trunc_coord(p1.y()) >= self.max_ey &&
        trunc_coord(p2.y()) >= self.max_ey &&
        trunc_coord(p3.y()) >= self.max_ey
      ) ||
      (
        trunc_coord(p0.y()) < self.min_ey &&
        trunc_coord(p1.y()) < self.min_ey &&
        trunc_coord(p2.y()) < self.min_ey &&
        trunc_coord(p3.y()) < self.min_ey
      ) {
      self.x = p0.x()
      self.y = p0.y()
    } else if abs_i64(2L * p0.x() - 3L * p1.x() + p3.x()) <= one_pixel_i64 / 2L &&
      abs_i64(2L * p0.y() - 3L * p1.y() + p3.y()) <= one_pixel_i64 / 2L &&
      abs_i64(p0.x() - 3L * p2.x() + 2L * p3.x()) <= one_pixel_i64 / 2L &&
      abs_i64(p0.y() - 3L * p2.y() + 2L * p3.y()) <= one_pixel_i64 / 2L {
      self.render_line(p0.x(), p0.y())
      if arc == 0 {
        return
      }
      arc -= 3
      continue
    } else {
      split_cubic(stack, arc)
      arc += 3
      continue
    }

    if arc == 0 {
      return
    }
    arc -= 3
  }
}

///|
fn GrayWorker::move_to(self : GrayWorker, to : @types.Vector) -> Unit {
  let x = upscale_26dot6(to.x())
  let y = upscale_26dot6(to.y())
  self.set_cell(trunc_coord(x), trunc_coord(y))
  self.x = x
  self.y = y
}

///|
fn GrayWorker::line_to(self : GrayWorker, to : @types.Vector) -> Unit {
  self.render_line(upscale_26dot6(to.x()), upscale_26dot6(to.y()))
}

///|
fn GrayWorker::conic_to(
  self : GrayWorker,
  control : @types.Vector,
  to : @types.Vector,
) -> Unit {
  self.render_conic(control, to)
}

///|
fn GrayWorker::cubic_to(
  self : GrayWorker,
  control1 : @types.Vector,
  control2 : @types.Vector,
  to : @types.Vector,
) -> Unit {
  self.render_cubic(control1, control2, to)
}

///|
fn GrayWorker::render(self : GrayWorker) -> Unit raise @error.FTError {
  let funcs = @base.OutlineFuncs::new(
    move_to=fn(to) { self.move_to(to) },
    line_to=fn(to) { self.line_to(to) },
    conic_to=fn(control, to) { self.conic_to(control, to) },
    cubic_to=fn(control1, control2, to) {
      self.cubic_to(control1, control2, to)
    },
  )
  @base.outline_decompose(self.outline, funcs)
}

///|
fn fill_span(
  bitmap : FixedArray[Byte],
  start : Int,
  coverage : Int,
  count : Int,
) -> Unit {
  for i in 0..<count {
    bitmap[start + i] = coverage.to_byte()
  }
}

///|
fn sweep_worker(
  worker : GrayWorker,
  bitmap : FixedArray[Byte],
  even_odd_fill : Bool,
) -> Unit {
  for y in worker.min_ey..<worker.max_ey {
    let xs = worker.row_xs[y]
    if xs.is_empty() {
      continue
    }
    xs.sort()
    let row_map = worker.row_cells[y]
    let row_offset = (worker.rows - 1 - y) * worker.width
    let mut x = worker.min_ex
    let mut cover = 0L
    for cell_x in xs {
      let cell = row_map.get(cell_x).unwrap()
      if cover != 0L && cell_x > x {
        let coverage = clamp_coverage(cover, even_odd_fill)
        fill_span(bitmap, row_offset + x, coverage, cell_x - x)
      }
      cover += cell.cover * (one_pixel_i64 * 2L)
      let area = cover - cell.area
      if area != 0L && cell_x >= worker.min_ex {
        let coverage = clamp_coverage(area, even_odd_fill)
        bitmap[row_offset + cell_x] = coverage.to_byte()
      }
      x = cell_x + 1
    }
    if cover != 0L && x < worker.max_ex {
      let coverage = clamp_coverage(cover, even_odd_fill)
      fill_span(bitmap, row_offset + x, coverage, worker.max_ex - x)
    }
  }
}

///|
priv struct RasterLayout {
  left : Int
  top : Int
  base_width : Int
  base_rows : Int
  width : Int
  rows : Int
  pitch : Int
  pixel_mode : @types.PixelMode
  num_grays : UInt
}

///|
fn RasterLayout::new(
  left : Int,
  top : Int,
  base_width : Int,
  base_rows : Int,
  width : Int,
  rows : Int,
  pitch : Int,
  pixel_mode : @types.PixelMode,
  num_grays : UInt,
) -> RasterLayout {
  {
    left,
    top,
    base_width,
    base_rows,
    width,
    rows,
    pitch,
    pixel_mode,
    num_grays,
  }
}

///|
fn pad_ceil(value : Int, align : Int) -> Int {
  if value <= 0 {
    0
  } else {
    (value + align - 1) / align * align
  }
}

///|
fn clone_outline(outline : @types.Outline) -> @types.Outline {
  let points : Array[@types.Vector] = []
  let tags : Array[Byte] = []
  let contours : Array[UInt] = []
  for i in 0..<outline.n_points() {
    points.push(outline.points()[i])
    tags.push(outline.tags()[i])
  }
  for i in 0..<outline.n_contours() {
    contours.push(outline.contours()[i])
  }
  let copy = @types.Outline::create_with_counts(
    FixedArray::from_array(points),
    FixedArray::from_array(tags),
    FixedArray::from_array(contours),
    outline.n_points(),
    outline.n_contours(),
  )
  copy.set_flags(outline.flags())
  copy
}

///|
fn make_bitmap(layout : RasterLayout, buffer : Bytes) -> @types.Bitmap {
  let bitmap = @types.Bitmap::new()
  bitmap.set_width(
    if layout.width > 0 {
      layout.width.reinterpret_as_uint()
    } else {
      0U
    },
  )
  bitmap.set_rows(
    if layout.rows > 0 {
      layout.rows.reinterpret_as_uint()
    } else {
      0U
    },
  )
  bitmap.set_pitch(layout.pitch)
  bitmap.set_num_grays(layout.num_grays)
  bitmap.set_pixel_mode(layout.pixel_mode)
  bitmap.set_buffer(buffer)
  bitmap
}

///|
fn normal_layout(cbox : @types.BBox) -> RasterLayout {
  let x_min = floor_div(cbox.x_min(), 64L).to_int()
  let y_min = floor_div(cbox.y_min(), 64L).to_int()
  let x_max = ceil_div(cbox.x_max(), 64L).to_int()
  let y_max = ceil_div(cbox.y_max(), 64L).to_int()
  let width = x_max - x_min
  let rows = y_max - y_min
  RasterLayout::new(
    x_min,
    y_max,
    width,
    rows,
    width,
    rows,
    if width > 0 {
      width
    } else {
      0
    },
    @types.PixelMode::Gray,
    256U,
  )
}

///|
fn mono_bound(value : Int64, offset : Int) -> Int {
  let pixel = floor_div(value, 64L).to_int()
  let remainder = (value - pixel.to_int64() * 64L).to_int()
  pixel + ((remainder + offset) >> 6)
}

///|
fn mono_collapsed_adjust(lo_value : Int64, hi_value : Int64) -> Int {
  let lo_pixel = floor_div(lo_value, 64L).to_int()
  let hi_pixel = floor_div(hi_value, 64L).to_int()
  let lo_remainder = (lo_value - lo_pixel.to_int64() * 64L).to_int()
  let hi_remainder = (hi_value - hi_pixel.to_int64() * 64L).to_int()
  ((lo_remainder + 31) & 63) - 31 + (((hi_remainder + 32) & 63) - 32)
}

///|
fn mono_layout(cbox : @types.BBox) -> RasterLayout {
  let mut x_min = mono_bound(cbox.x_min(), 31)
  let mut x_max = mono_bound(cbox.x_max(), 32)
  if x_min == x_max {
    if mono_collapsed_adjust(cbox.x_min(), cbox.x_max()) < 0 {
      x_min -= 1
    } else {
      x_max += 1
    }
  }

  let mut y_min = mono_bound(cbox.y_min(), 31)
  let mut y_max = mono_bound(cbox.y_max(), 32)
  if y_min == y_max {
    if mono_collapsed_adjust(cbox.y_min(), cbox.y_max()) < 0 {
      y_min -= 1
    } else {
      y_max += 1
    }
  }

  let width = x_max - x_min
  let rows = y_max - y_min
  RasterLayout::new(
    x_min,
    y_max,
    width,
    rows,
    width,
    rows,
    if width > 0 {
      (width + 15) >> 4 << 1
    } else {
      0
    },
    @types.PixelMode::Mono,
    256U,
  )
}

///|
fn lcd_layout(cbox : @types.BBox) -> RasterLayout {
  let padded = @types.BBox::new(
    cbox.x_min() - 21L,
    cbox.y_min(),
    cbox.x_max() + 21L,
    cbox.y_max(),
  )
  let x_min = floor_div(padded.x_min(), 64L).to_int()
  let y_min = floor_div(padded.y_min(), 64L).to_int()
  let x_max = ceil_div(padded.x_max(), 64L).to_int()
  let y_max = ceil_div(padded.y_max(), 64L).to_int()
  let base_width = x_max - x_min
  let base_rows = y_max - y_min
  let width = if base_width > 0 { base_width * 3 } else { 0 }
  RasterLayout::new(
    x_min,
    y_max,
    base_width,
    base_rows,
    width,
    base_rows,
    pad_ceil(width, 4),
    @types.PixelMode::Lcd,
    256U,
  )
}

///|
fn lcdv_layout(cbox : @types.BBox) -> RasterLayout {
  let padded = @types.BBox::new(
    cbox.x_min(),
    cbox.y_min() - 21L,
    cbox.x_max(),
    cbox.y_max() + 21L,
  )
  let x_min = floor_div(padded.x_min(), 64L).to_int()
  let y_min = floor_div(padded.y_min(), 64L).to_int()
  let x_max = ceil_div(padded.x_max(), 64L).to_int()
  let y_max = ceil_div(padded.y_max(), 64L).to_int()
  let base_width = x_max - x_min
  let base_rows = y_max - y_min
  let rows = if base_rows > 0 { base_rows * 3 } else { 0 }
  RasterLayout::new(
    x_min,
    y_max,
    base_width,
    base_rows,
    base_width,
    rows,
    if base_width > 0 {
      base_width
    } else {
      0
    },
    @types.PixelMode::LcdV,
    256U,
  )
}

///|
fn render_gray_plane(
  outline : @types.Outline,
  left : Int,
  top : Int,
  width : Int,
  rows : Int,
  origin_rows? : Int = rows,
  shift_x? : Int64 = 0L,
  shift_y? : Int64 = 0L,
  scale_x? : Int = 1,
  scale_y? : Int = 1,
) -> Bytes raise @error.FTError {
  if width <= 0 || rows <= 0 {
    return b""
  }
  if outline.n_points() == 0 || outline.n_contours() == 0 {
    return Bytes::from_array(FixedArray::make(width * rows, b'\x00')[:])
  }

  let copy = clone_outline(outline)
  @base.outline_translate(
    copy,
    ((-left).to_int64() << 6) + shift_x,
    ((origin_rows - top).to_int64() << 6) + shift_y,
  )
  if scale_x != 1 || scale_y != 1 {
    for i in 0..<copy.n_points() {
      let p = copy.points()[i]
      copy.points()[i] = @types.Vector::new(
        p.x() * scale_x.to_int64(),
        p.y() * scale_y.to_int64(),
      )
    }
  }
  let worker = GrayWorker::new(copy, width, rows)
  worker.render()
  let pixels = FixedArray::make(width * rows, b'\x00')
  sweep_worker(
    worker,
    pixels,
    (outline.flags() & @types.OUTLINE_EVEN_ODD_FILL) != 0,
  )
  Bytes::from_array(pixels[:])
}

///|
fn same_vector(a : @types.Vector, b : @types.Vector) -> Bool {
  a.x() == b.x() && a.y() == b.y()
}

///|
fn midpoint(a : @types.Vector, b : @types.Vector) -> @types.Vector {
  @types.Vector::new((a.x() + b.x()) / 2L, (a.y() + b.y()) / 2L)
}

///|
fn conic_flat_enough(
  p0 : @types.Vector,
  p1 : @types.Vector,
  p2 : @types.Vector,
) -> Bool {
  let bx = p1.x() - p0.x()
  let by = p1.y() - p0.y()
  let ax = p2.x() - p1.x() - bx
  let ay = p2.y() - p1.y() - by
  let mut dx = abs_i64(ax)
  let dy = abs_i64(ay)
  if dx < dy {
    dx = dy
  }
  dx <= one_pixel_i64 / 4L
}

///|
fn cubic_flat_enough(
  p0 : @types.Vector,
  p1 : @types.Vector,
  p2 : @types.Vector,
  p3 : @types.Vector,
) -> Bool {
  abs_i64(2L * p0.x() - 3L * p1.x() + p3.x()) <= one_pixel_i64 / 2L &&
  abs_i64(2L * p0.y() - 3L * p1.y() + p3.y()) <= one_pixel_i64 / 2L &&
  abs_i64(p0.x() - 3L * p2.x() + 2L * p3.x()) <= one_pixel_i64 / 2L &&
  abs_i64(p0.y() - 3L * p2.y() + 2L * p3.y()) <= one_pixel_i64 / 2L
}

///|
priv struct MonoBuilder {
  contours : Array[Array[@types.Vector]]
  mut current : Array[@types.Vector]
  mut current_point : @types.Vector
  mut has_current : Bool
}

///|
fn MonoBuilder::new() -> MonoBuilder {
  {
    contours: [],
    current: [],
    current_point: @types.Vector::new(0L, 0L),
    has_current: false,
  }
}

///|
fn MonoBuilder::push_point(self : MonoBuilder, point : @types.Vector) -> Unit {
  let last_index = self.current.length() - 1
  if self.current.is_empty() || !same_vector(self.current[last_index], point) {
    self.current.push(point)
  }
  self.current_point = point
  self.has_current = true
}

///|
fn MonoBuilder::finish_contour(self : MonoBuilder) -> Unit {
  if !self.has_current || self.current.length() < 2 {
    self.current = []
    self.has_current = false
    return
  }
  let last_index = self.current.length() - 1
  if !same_vector(self.current[0], self.current[last_index]) {
    self.current.push(self.current[0])
  }
  self.contours.push(self.current)
  self.current = []
  self.has_current = false
}

///|
fn flatten_conic_to(
  builder : MonoBuilder,
  p0 : @types.Vector,
  p1 : @types.Vector,
  p2 : @types.Vector,
) -> Unit {
  if conic_flat_enough(p0, p1, p2) {
    builder.push_point(p2)
    return
  }
  let p01 = midpoint(p0, p1)
  let p12 = midpoint(p1, p2)
  let p012 = midpoint(p01, p12)
  flatten_conic_to(builder, p0, p01, p012)
  flatten_conic_to(builder, p012, p12, p2)
}

///|
fn flatten_cubic_to(
  builder : MonoBuilder,
  p0 : @types.Vector,
  p1 : @types.Vector,
  p2 : @types.Vector,
  p3 : @types.Vector,
) -> Unit {
  if cubic_flat_enough(p0, p1, p2, p3) {
    builder.push_point(p3)
    return
  }
  let p01 = midpoint(p0, p1)
  let p12 = midpoint(p1, p2)
  let p23 = midpoint(p2, p3)
  let p012 = midpoint(p01, p12)
  let p123 = midpoint(p12, p23)
  let p0123 = midpoint(p012, p123)
  flatten_cubic_to(builder, p0, p01, p012, p0123)
  flatten_cubic_to(builder, p0123, p123, p23, p3)
}

///|
fn flatten_outline(
  outline : @types.Outline,
  left : Int,
  top : Int,
  rows : Int,
) -> Array[Array[@types.Vector]] raise @error.FTError {
  if outline.n_points() == 0 || outline.n_contours() == 0 {
    return []
  }
  let copy = clone_outline(outline)
  @base.outline_translate(
    copy,
    (-left).to_int64() << 6,
    (rows - top).to_int64() << 6,
  )
  let builder = MonoBuilder::new()
  let funcs = @base.OutlineFuncs::new(
    move_to=fn(to) {
      builder.finish_contour()
      builder.push_point(to)
    },
    line_to=fn(to) { builder.push_point(to) },
    conic_to=fn(control, to) {
      flatten_conic_to(builder, builder.current_point, control, to)
    },
    cubic_to=fn(control1, control2, to) {
      flatten_cubic_to(builder, builder.current_point, control1, control2, to)
    },
  )
  @base.outline_decompose(copy, funcs)
  builder.finish_contour()
  builder.contours
}

///|
fn edge_intersection_x(
  p0 : @types.Vector,
  p1 : @types.Vector,
  y : Int64,
) -> Int64 {
  p0.x() + (y - p0.y()) * (p1.x() - p0.x()) / (p1.y() - p0.y())
}

///|
fn insert_intersection(
  xs : Array[Int64],
  deltas : Array[Int],
  x : Int64,
  delta : Int,
) -> Unit {
  let mut i = 0
  while i < xs.length() && xs[i] <= x {
    i += 1
  }
  xs.insert(i, x)
  deltas.insert(i, delta)
}

///|
fn set_mono_bit(packed : FixedArray[Byte], dst_offset : Int, x : Int) -> Unit {
  let byte_index = dst_offset + (x >> 3)
  packed[byte_index] = packed[byte_index] | (0x80 >> (x & 7)).to_byte()
}

///|
fn fill_mono_span(
  packed : FixedArray[Byte],
  dst_offset : Int,
  width : Int,
  x_start : Int64,
  x_end : Int64,
) -> Bool {
  let mut filled = false
  for x in 0..<width {
    let x_center = (x << 6).to_int64() + 32L
    if x_start < x_center && x_center < x_end {
      set_mono_bit(packed, dst_offset, x)
      filled = true
    }
  }
  filled
}

///|
fn fill_mono_span_with_dropout(
  packed : FixedArray[Byte],
  dst_offset : Int,
  width : Int,
  x_start : Int64,
  x_end : Int64,
  allow_dropout : Bool,
) -> Unit {
  if x_end <= x_start {
    return
  }
  if fill_mono_span(packed, dst_offset, width, x_start, x_end) {
    return
  }
  if !allow_dropout {
    return
  }
  let drop_x = floor_div((x_start + x_end) / 2L, 64L).to_int()
  if drop_x >= 0 && drop_x < width {
    set_mono_bit(packed, dst_offset, drop_x)
  }
}

///|
fn rasterize_mono_scanline(
  packed : FixedArray[Byte],
  dst_offset : Int,
  width : Int,
  contours : Array[Array[@types.Vector]],
  y : Int64,
  even_odd : Bool,
  allow_dropout : Bool,
) -> Unit {
  let xs : Array[Int64] = []
  let deltas : Array[Int] = []
  for contour in contours {
    for i in 1..<contour.length() {
      let p0 = contour[i - 1]
      let p1 = contour[i]
      if p0.y() <= y && y < p1.y() {
        insert_intersection(xs, deltas, edge_intersection_x(p0, p1, y), 1)
      } else if p1.y() <= y && y < p0.y() {
        insert_intersection(xs, deltas, edge_intersection_x(p0, p1, y), -1)
      }
    }
  }
  if even_odd {
    let mut i = 0
    while i + 1 < xs.length() {
      fill_mono_span_with_dropout(
        packed,
        dst_offset,
        width,
        xs[i],
        xs[i + 1],
        allow_dropout,
      )
      i += 2
    }
    return
  }

  let mut winding = 0
  let mut span_start = 0L
  let mut active = false
  for i in 0..<xs.length() {
    let prev = winding
    winding += deltas[i]
    if prev == 0 && winding != 0 {
      span_start = xs[i]
      active = true
    } else if active && prev != 0 && winding == 0 {
      fill_mono_span_with_dropout(
        packed,
        dst_offset,
        width,
        span_start,
        xs[i],
        allow_dropout,
      )
      active = false
    }
  }
}

///|
fn render_mono_plane(
  outline : @types.Outline,
  left : Int,
  top : Int,
  width : Int,
  rows : Int,
  pitch : Int,
) -> Bytes raise @error.FTError {
  if width <= 0 || rows <= 0 {
    return b""
  }
  let packed = FixedArray::make(rows * pitch, b'\x00')
  if outline.n_points() == 0 || outline.n_contours() == 0 {
    return Bytes::from_array(packed[:])
  }
  let contours = flatten_outline(outline, left, top, rows)
  let even_odd = (outline.flags() & @types.OUTLINE_EVEN_ODD_FILL) != 0
  for row in 0..<rows {
    let y = ((rows - 1 - row) << 6).to_int64() + 31L
    let dst_offset = row * pitch
    rasterize_mono_scanline(
      packed,
      dst_offset,
      width,
      contours,
      y,
      even_odd,
      row > 0 && row + 1 < rows,
    )
  }
  Bytes::from_array(packed[:])
}

///|
fn interleave_lcd_horizontal(
  plane0 : Bytes,
  plane1 : Bytes,
  plane2 : Bytes,
  width : Int,
  rows : Int,
  pitch : Int,
) -> Bytes {
  let interleaved = FixedArray::make(rows * pitch, b'\x00')
  for row in 0..<rows {
    let src_offset = row * width
    let dst_offset = row * pitch
    for x in 0..<width {
      let dst = dst_offset + x * 3
      interleaved[dst] = plane0[src_offset + x]
      interleaved[dst + 1] = plane1[src_offset + x]
      interleaved[dst + 2] = plane2[src_offset + x]
    }
  }
  Bytes::from_array(interleaved[:])
}

///|
fn interleave_lcd_vertical(
  plane0 : Bytes,
  plane1 : Bytes,
  plane2 : Bytes,
  width : Int,
  rows : Int,
  pitch : Int,
) -> Bytes {
  let interleaved = FixedArray::make(rows * 3 * pitch, b'\x00')
  for y in 0..<rows {
    let src_offset = y * width
    let dst0 = y * 3 * pitch
    let dst1 = dst0 + pitch
    let dst2 = dst1 + pitch
    for x in 0..<width {
      interleaved[dst0 + x] = plane0[src_offset + x]
      interleaved[dst1 + x] = plane1[src_offset + x]
      interleaved[dst2 + x] = plane2[src_offset + x]
    }
  }
  Bytes::from_array(interleaved[:])
}

///|
fn render_outline_with_layout(
  outline : @types.Outline,
  layout : RasterLayout,
) -> (@types.Bitmap, Int, Int) raise @error.FTError {
  if layout.width <= 0 || layout.rows <= 0 {
    return (make_bitmap(layout, b""), layout.left, layout.top)
  }

  let gray = render_gray_plane(
    outline,
    layout.left,
    layout.top,
    layout.base_width,
    layout.base_rows,
  )
  let buffer = match layout.pixel_mode {
    @types.PixelMode::Gray => gray
    @types.PixelMode::Mono =>
      render_mono_plane(
        outline,
        layout.left,
        layout.top,
        layout.base_width,
        layout.base_rows,
        layout.pitch,
      )
    @types.PixelMode::Lcd => {
      let left_plane = render_gray_plane(
        outline,
        layout.left,
        layout.top,
        layout.base_width,
        layout.base_rows,
        shift_x=21L,
      )
      let right_plane = render_gray_plane(
        outline,
        layout.left,
        layout.top,
        layout.base_width,
        layout.base_rows,
        shift_x=-21L,
      )
      interleave_lcd_horizontal(
        left_plane,
        gray,
        right_plane,
        layout.base_width,
        layout.base_rows,
        layout.pitch,
      )
    }
    @types.PixelMode::LcdV => {
      let top_plane = render_gray_plane(
        outline,
        layout.left,
        layout.top,
        layout.base_width,
        layout.base_rows,
        shift_y=-21L,
      )
      let bottom_plane = render_gray_plane(
        outline,
        layout.left,
        layout.top,
        layout.base_width,
        layout.base_rows,
        shift_y=21L,
      )
      interleave_lcd_vertical(
        top_plane,
        gray,
        bottom_plane,
        layout.base_width,
        layout.base_rows,
        layout.pitch,
      )
    }
    _ => b""
  }
  (make_bitmap(layout, buffer), layout.left, layout.top)
}

///|
pub fn render_outline_normal(
  outline : @types.Outline,
) -> (@types.Bitmap, Int, Int) raise @error.FTError {
  @base.outline_check(outline)
  render_outline_with_layout(
    outline,
    normal_layout(@base.outline_get_cbox(outline)),
  )
}

///|
pub fn render_outline_light(
  outline : @types.Outline,
) -> (@types.Bitmap, Int, Int) raise @error.FTError {
  @base.outline_check(outline)
  render_outline_with_layout(
    outline,
    normal_layout(@base.outline_get_cbox(outline)),
  )
}

///|
pub fn render_outline_mono(
  outline : @types.Outline,
) -> (@types.Bitmap, Int, Int) raise @error.FTError {
  @base.outline_check(outline)
  render_outline_with_layout(
    outline,
    mono_layout(@base.outline_get_cbox(outline)),
  )
}

///|
pub fn render_outline_lcd(
  outline : @types.Outline,
) -> (@types.Bitmap, Int, Int) raise @error.FTError {
  @base.outline_check(outline)
  render_outline_with_layout(
    outline,
    lcd_layout(@base.outline_get_cbox(outline)),
  )
}

///|
pub fn render_outline_lcdv(
  outline : @types.Outline,
) -> (@types.Bitmap, Int, Int) raise @error.FTError {
  @base.outline_check(outline)
  render_outline_with_layout(
    outline,
    lcdv_layout(@base.outline_get_cbox(outline)),
  )
}

///|
/// Render a grayscale mask into explicit bitmap bounds.
pub fn render_outline_gray_mask(
  outline : @types.Outline,
  left : Int,
  top : Int,
  width : Int,
  rows : Int,
) -> Bytes raise @error.FTError {
  @base.outline_check(outline)
  render_gray_plane(outline, left, top, width, rows)
}
