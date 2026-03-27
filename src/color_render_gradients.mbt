///|
struct GradientStopSample {
  offset : Double
  blue : Int
  green : Int
  red : Int
  alpha : Int
} derive(Show)

///|
struct GradientLineSample {
  extend : Int
  stops : Array[GradientStopSample]
} derive(Show)

///|
fn fixed_16_16_to_double(value : Int64) -> Double {
  value.to_double() / 65536.0
}

///|
fn fixed_to_double(value : @fixed.Fixed) -> Double {
  fixed_16_16_to_double(value.val())
}

///|
fn rounded_double_to_int(value : Double) -> Int {
  if value >= 0.0 {
    (value + 0.5).floor().to_int()
  } else {
    (value - 0.5).ceil().to_int()
  }
}

///|
fn positive_mod(value : Double, modulus : Double) -> Double {
  if modulus == 0.0 {
    return 0.0
  }
  let mut result = value % modulus
  if result < 0.0 {
    result += modulus
  }
  result
}

///|
fn clamp_double_unit(value : Double) -> Double {
  if value <= 0.0 {
    0.0
  } else if value >= 1.0 {
    1.0
  } else {
    value
  }
}

///|
fn resolve_gradient_line(
  color_line : @color.ColrColorLine,
  palette : Array[@types.Color],
  foreground_color : @types.Color,
) -> GradientLineSample raise @error.FTError {
  let stops : Array[GradientStopSample] = Array::new(
    capacity=color_line.stops().length(),
  )
  for stop in color_line.stops() {
    let base_color = resolve_palette_color(
      palette,
      foreground_color,
      stop.palette_index(),
    )
    let stop_alpha = alpha_f2dot14_to_8(stop.alpha())
    let alpha = (base_color.alpha().to_int() * stop_alpha + 127) / 255
    stops.push({
      offset: fixed_to_double(stop.stop_offset()),
      blue: base_color.blue().to_int(),
      green: base_color.green().to_int(),
      red: base_color.red().to_int(),
      alpha,
    })
  }
  { extend: color_line.extend(), stops }
}

///|
fn wrap_gradient_offset(
  offset : Double,
  first_offset : Double,
  last_offset : Double,
  extend : Int,
) -> Double {
  if extend == 0 || last_offset <= first_offset {
    return offset
  }
  let period = last_offset - first_offset
  let mut phase = positive_mod(offset - first_offset, period)
  if phase == 0.0 && offset > last_offset {
    phase = period
  }
  if extend == 1 {
    return first_offset + phase
  }
  let reflected = phase * 2.0
  if reflected > period {
    first_offset + (2.0 * period - reflected)
  } else {
    first_offset + reflected
  }
}

///|
fn interpolate_channel(a : Int, b : Int, t : Double) -> Int {
  let v = a.to_double() + (b - a).to_double() * t
  if v <= 0.0 {
    0
  } else if v >= 255.0 {
    255
  } else {
    rounded_double_to_int(v)
  }
}

///|
fn sample_gradient_line(
  line : GradientLineSample,
  offset : Double,
) -> (Int, Int, Int, Int) {
  if line.stops.is_empty() {
    return (0, 0, 0, 0)
  }
  if line.stops.length() == 1 {
    let stop = line.stops[0]
    return (stop.blue, stop.green, stop.red, stop.alpha)
  }
  let first = line.stops[0]
  let last = line.stops[line.stops.length() - 1]
  let start = first.offset
  let end_ = last.offset
  let t = wrap_gradient_offset(offset, start, end_, line.extend)
  if end_ <= start {
    if t < start {
      return (first.blue, first.green, first.red, first.alpha)
    } else {
      return (last.blue, last.green, last.red, last.alpha)
    }
  }
  if t < start {
    return (first.blue, first.green, first.red, first.alpha)
  }
  if t > end_ {
    return (last.blue, last.green, last.red, last.alpha)
  }

  let mut i = 0
  while i < line.stops.length() {
    let stop = line.stops[i]
    if t < stop.offset {
      break
    }
    if t == stop.offset {
      let mut j = i
      while j + 1 < line.stops.length() &&
            line.stops[j + 1].offset == stop.offset {
        j += 1
      }
      let exact = line.stops[j]
      return (exact.blue, exact.green, exact.red, exact.alpha)
    }
    i += 1
  }
  if i <= 0 {
    let stop = line.stops[0]
    return (stop.blue, stop.green, stop.red, stop.alpha)
  }
  if i >= line.stops.length() {
    let stop = line.stops[line.stops.length() - 1]
    return (stop.blue, stop.green, stop.red, stop.alpha)
  }
  let before = line.stops[i - 1]
  let after = line.stops[i]
  let span = after.offset - before.offset
  if span <= 0.0 {
    return (before.blue, before.green, before.red, before.alpha)
  }
  let mix = clamp_double_unit((t - before.offset) / span)
  (
    interpolate_channel(before.blue, after.blue, mix),
    interpolate_channel(before.green, after.green, mix),
    interpolate_channel(before.red, after.red, mix),
    interpolate_channel(before.alpha, after.alpha, mix),
  )
}

///|
fn inverse_matrix(matrix : @fixed.Matrix) -> @fixed.Matrix? {
  let delta = @fixed.mul_fix(matrix.xx(), matrix.yy()) -
    @fixed.mul_fix(matrix.xy(), matrix.yx())
  if delta.val() == 0L {
    return None
  }
  Some(
    @fixed.Matrix::new(
      @fixed.div_fix(matrix.yy().val(), delta.val()),
      -@fixed.div_fix(matrix.xy().val(), delta.val()),
      -@fixed.div_fix(matrix.yx().val(), delta.val()),
      @fixed.div_fix(matrix.xx().val(), delta.val()),
    ),
  )
}

///|
fn device_point_to_paint_space(
  transform : PaintTransform,
  inverse : @fixed.Matrix,
  x : Int64,
  y : Int64,
) -> (Int64, Int64) {
  inverse.transform(x - transform.dx, y - transform.dy)
}

///|
fn sample_gradient_color(
  line : GradientLineSample,
  offset : Double,
  coverage : Int,
) -> (Byte, Byte, Byte, Byte) {
  let (blue, green, red, alpha) = sample_gradient_line(line, offset)
  let combined_alpha = (alpha * coverage + 127) / 255
  @color.premultiply_bgra(
    @types.Color::new(
      blue.to_byte(),
      green.to_byte(),
      red.to_byte(),
      combined_alpha.to_byte(),
    ),
    255,
  )
}

///|
fn make_clip_box_outline(
  x_min : Int64,
  y_min : Int64,
  x_max : Int64,
  y_max : Int64,
) -> @types.Outline {
  let points = FixedArray::make(4, @types.Vector::new(0L, 0L))
  points[0] = @types.Vector::new(x_min, y_min)
  points[1] = @types.Vector::new(x_max, y_min)
  points[2] = @types.Vector::new(x_max, y_max)
  points[3] = @types.Vector::new(x_min, y_max)
  let tags = FixedArray::make(4, @types.CURVE_TAG_ON)
  let contours = FixedArray::make(1, 3U)
  @types.Outline::create(points, tags, contours)
}

///|
fn render_clip_box_mask(
  clip_box : @color.ColrClipBox,
  transform : PaintTransform,
  x_scale : @fixed.Fixed,
  y_scale : @fixed.Fixed,
) -> @color.GrayMaskSurface raise @error.FTError {
  let (x_min, y_min) = scale_colr_offset(
    x_scale,
    y_scale,
    clip_box.x_min(),
    clip_box.y_min(),
  )
  let (x_max, y_max) = scale_colr_offset(
    x_scale,
    y_scale,
    clip_box.x_max(),
    clip_box.y_max(),
  )
  let outline = make_clip_box_outline(x_min, y_min, x_max, y_max)
  render_transformed_mask(outline, transform)
}

///|
fn apply_parent_clips(
  surface : @color.BgraSurface,
  clips : Array[@color.GrayMaskSurface],
) -> Unit {
  if clips.length() <= 1 {
    return
  }
  for i in 0..<(clips.length() - 1) {
    surface.apply_mask(clips[i])
  }
}

///|
fn render_linear_gradient_surface(
  mask : @color.GrayMaskSurface,
  color_line : @color.ColrColorLine,
  palette : Array[@types.Color],
  foreground_color : @types.Color,
  transform : PaintTransform,
  p0x : Int64,
  p0y : Int64,
  p1x : Int64,
  p1y : Int64,
  p2x : Int64,
  p2y : Int64,
  x_scale : @fixed.Fixed,
  y_scale : @fixed.Fixed,
) -> @color.BgraSurface raise @error.FTError {
  if mask.is_empty() {
    return @color.BgraSurface::new()
  }
  let inverse = match inverse_matrix(transform.matrix) {
    Some(v) => v
    None => return @color.BgraSurface::new()
  }
  let line = resolve_gradient_line(color_line, palette, foreground_color)
  let (sp0x, sp0y) = scale_colr_offset(x_scale, y_scale, p0x, p0y)
  let (sp1x, sp1y) = scale_colr_offset(x_scale, y_scale, p1x, p1y)
  let (sp2x, sp2y) = scale_colr_offset(x_scale, y_scale, p2x, p2y)
  let vx = (sp1x - sp0x).to_double()
  let vy = (sp1y - sp0y).to_double()
  let rx = (sp2x - sp0x).to_double()
  let ry = (sp2y - sp0y).to_double()
  if (vx == 0.0 && vy == 0.0) || (rx == 0.0 && ry == 0.0) {
    return @color.BgraSurface::new()
  }
  let nx = -ry
  let ny = rx
  let denom = vx * nx + vy * ny
  if denom == 0.0 {
    return @color.BgraSurface::new()
  }
  @color.surface_from_mask_sampler(mask, fn(world_x, world_y_top, coverage) {
    let x = (world_x.to_int64() << 6) + 32L
    let y = (world_y_top.to_int64() << 6) - 32L
    let (px, py) = device_point_to_paint_space(transform, inverse, x, y)
    let tx = (px - sp0x).to_double()
    let ty = (py - sp0y).to_double()
    let t = (tx * nx + ty * ny) / denom
    sample_gradient_color(line, t, coverage)
  })
}

///|
fn solve_radial_offset(
  px : Double,
  py : Double,
  c0x : Double,
  c0y : Double,
  r0 : Double,
  c1x : Double,
  c1y : Double,
  r1 : Double,
) -> Double? {
  let dx = px - c0x
  let dy = py - c0y
  let fx = c1x - c0x
  let fy = c1y - c0y
  let dr = r1 - r0
  let a = fx * fx + fy * fy - dr * dr
  let b = -2.0 * (dx * fx + dy * fy + r0 * dr)
  let c = dx * dx + dy * dy - r0 * r0
  if a == 0.0 {
    if b == 0.0 {
      return None
    }
    let t = -c / b
    if r0 + dr * t > 0.0 {
      return Some(t)
    }
    return None
  }
  let disc = b * b - 4.0 * a * c
  if disc < 0.0 {
    return None
  }
  let root = disc.sqrt()
  let t1 = (-b - root) / (2.0 * a)
  let t2 = (-b + root) / (2.0 * a)
  let mut best : Double? = None
  if r0 + dr * t1 > 0.0 {
    best = Some(t1)
  }
  if r0 + dr * t2 > 0.0 {
    match best {
      Some(current) => if t2 > current { best = Some(t2) }
      None => best = Some(t2)
    }
  }
  best
}

///|
fn render_radial_gradient_surface(
  mask : @color.GrayMaskSurface,
  color_line : @color.ColrColorLine,
  palette : Array[@types.Color],
  foreground_color : @types.Color,
  transform : PaintTransform,
  c0x : Int64,
  c0y : Int64,
  r0 : Int64,
  c1x : Int64,
  c1y : Int64,
  r1 : Int64,
  x_scale : @fixed.Fixed,
  y_scale : @fixed.Fixed,
) -> @color.BgraSurface raise @error.FTError {
  if mask.is_empty() {
    return @color.BgraSurface::new()
  }
  let inverse = match inverse_matrix(transform.matrix) {
    Some(v) => v
    None => return @color.BgraSurface::new()
  }
  let line = resolve_gradient_line(color_line, palette, foreground_color)
  let (sc0x, sc0y) = scale_colr_offset(x_scale, y_scale, c0x, c0y)
  let sr0 = scale_colr_translation_component(x_scale, r0)
  let (sc1x, sc1y) = scale_colr_offset(x_scale, y_scale, c1x, c1y)
  let sr1 = scale_colr_translation_component(x_scale, r1)
  if sc0x == sc1x && sc0y == sc1y && sr0 == sr1 {
    return @color.BgraSurface::new()
  }
  let dc0x = sc0x.to_double()
  let dc0y = sc0y.to_double()
  let dr0 = sr0.to_double()
  let dc1x = sc1x.to_double()
  let dc1y = sc1y.to_double()
  let dr1 = sr1.to_double()
  @color.surface_from_mask_sampler(mask, fn(world_x, world_y_top, coverage) {
    let x = (world_x.to_int64() << 6) + 32L
    let y = (world_y_top.to_int64() << 6) - 32L
    let (px, py) = device_point_to_paint_space(transform, inverse, x, y)
    match
      solve_radial_offset(
        px.to_double(),
        py.to_double(),
        dc0x,
        dc0y,
        dr0,
        dc1x,
        dc1y,
        dr1,
      ) {
      Some(offset) => sample_gradient_color(line, offset, coverage)
      None => (b'\x00', b'\x00', b'\x00', b'\x00')
    }
  })
}

///|
fn angle_fixed_to_degrees(value : @fixed.Fixed) -> Double {
  fixed_to_double(value) * 180.0
}

///|
fn render_sweep_gradient_surface(
  mask : @color.GrayMaskSurface,
  color_line : @color.ColrColorLine,
  palette : Array[@types.Color],
  foreground_color : @types.Color,
  transform : PaintTransform,
  center_x : Int64,
  center_y : Int64,
  start_angle : @fixed.Fixed,
  end_angle : @fixed.Fixed,
  x_scale : @fixed.Fixed,
  y_scale : @fixed.Fixed,
) -> @color.BgraSurface raise @error.FTError {
  if mask.is_empty() {
    return @color.BgraSurface::new()
  }
  let inverse = match inverse_matrix(transform.matrix) {
    Some(v) => v
    None => return @color.BgraSurface::new()
  }
  let line = resolve_gradient_line(color_line, palette, foreground_color)
  let (scx, scy) = scale_colr_offset(x_scale, y_scale, center_x, center_y)
  let start_deg = positive_mod(angle_fixed_to_degrees(start_angle), 360.0)
  let end_deg = positive_mod(angle_fixed_to_degrees(end_angle), 360.0)
  let mut sweep = positive_mod(end_deg - start_deg, 360.0)
  if sweep == 0.0 {
    sweep = 360.0
  }
  @color.surface_from_mask_sampler(mask, fn(world_x, world_y_top, coverage) {
    let x = (world_x.to_int64() << 6) + 32L
    let y = (world_y_top.to_int64() << 6) - 32L
    let (px, py) = device_point_to_paint_space(transform, inverse, x, y)
    let dx = px - scx
    let dy = py - scy
    if dx == 0L && dy == 0L {
      (b'\x00', b'\x00', b'\x00', b'\x00')
    } else {
      let angle = positive_mod(
        @fixed.atan2(dx, dy).to_double() / 65536.0,
        360.0,
      )
      let delta = positive_mod(angle - start_deg, 360.0)
      if sweep < 360.0 && delta > sweep {
        (b'\x00', b'\x00', b'\x00', b'\x00')
      } else {
        sample_gradient_color(line, delta / sweep, coverage)
      }
    }
  })
}
