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
pub fn render_outline_normal(
  outline : @types.Outline,
) -> (@types.Bitmap, Int, Int) raise @error.FTError {
  let cbox = @base.outline_get_cbox(outline)
  let x_min = floor_div(cbox.x_min(), 64L).to_int()
  let y_min = floor_div(cbox.y_min(), 64L).to_int()
  let x_max = ceil_div(cbox.x_max(), 64L).to_int()
  let y_max = ceil_div(cbox.y_max(), 64L).to_int()
  let width = x_max - x_min
  let rows = y_max - y_min
  let bitmap = @types.Bitmap::new()
  bitmap.set_width(if width > 0 { width.reinterpret_as_uint() } else { 0U })
  bitmap.set_rows(if rows > 0 { rows.reinterpret_as_uint() } else { 0U })
  bitmap.set_pitch(if width > 0 { width } else { 0 })
  bitmap.set_num_grays(256U)
  bitmap.set_pixel_mode(@types.PixelMode::Gray)

  if width <= 0 ||
    rows <= 0 ||
    outline.n_points() == 0 ||
    outline.n_contours() == 0 {
    bitmap.set_buffer(b"")
    return (bitmap, x_min, y_max)
  }

  @base.outline_translate(
    outline,
    (-x_min).to_int64() << 6,
    (-y_min).to_int64() << 6,
  )
  let worker = GrayWorker::new(outline, width, rows)
  let render_result : Result[Unit, @error.FTError] = Ok(worker.render()) catch {
    err => Err(err)
  }
  @base.outline_translate(outline, x_min.to_int64() << 6, y_min.to_int64() << 6)
  match render_result {
    Ok(_) => ()
    Err(err) => raise err
  }

  let pixels = FixedArray::make(width * rows, b'\x00')
  sweep_worker(
    worker,
    pixels,
    (outline.flags() & @types.OUTLINE_EVEN_ODD_FILL) != 0,
  )
  bitmap.set_buffer(Bytes::from_array(pixels[:]))
  (bitmap, x_min, y_max)
}
