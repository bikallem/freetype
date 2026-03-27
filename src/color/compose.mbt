///|
pub struct GrayMaskSurface {
  left : Int
  top : Int
  width : Int
  rows : Int
  buffer : Bytes
} derive(Eq, Show)

///|
pub fn GrayMaskSurface::new(
  left : Int,
  top : Int,
  width : Int,
  rows : Int,
  buffer : Bytes,
) -> GrayMaskSurface {
  { left, top, width, rows, buffer }
}

///|
pub fn GrayMaskSurface::empty() -> GrayMaskSurface {
  { left: 0, top: 0, width: 0, rows: 0, buffer: b"" }
}

///|
pub fn GrayMaskSurface::left(self : GrayMaskSurface) -> Int {
  self.left
}

///|
pub fn GrayMaskSurface::top(self : GrayMaskSurface) -> Int {
  self.top
}

///|
pub fn GrayMaskSurface::width(self : GrayMaskSurface) -> Int {
  self.width
}

///|
pub fn GrayMaskSurface::rows(self : GrayMaskSurface) -> Int {
  self.rows
}

///|
pub fn GrayMaskSurface::buffer(self : GrayMaskSurface) -> Bytes {
  self.buffer
}

///|
pub fn GrayMaskSurface::is_empty(self : GrayMaskSurface) -> Bool {
  self.width <= 0 || self.rows <= 0 || self.buffer.length() == 0
}

///|
pub fn gray_mask_from_bitmap(
  bitmap : @types.Bitmap,
  left : Int,
  top : Int,
) -> GrayMaskSurface {
  if bitmap.pixel_mode() != @types.PixelMode::Gray {
    return GrayMaskSurface::empty()
  }
  GrayMaskSurface::new(
    left,
    top,
    bitmap.width().reinterpret_as_int(),
    bitmap.rows().reinterpret_as_int(),
    bitmap.buffer(),
  )
}

///|
pub struct BgraSurface {
  mut left : Int
  mut top : Int
  mut width : Int
  mut rows : Int
  mut pixels : FixedArray[Byte]
} derive(Show)

///|
pub fn BgraSurface::new() -> BgraSurface {
  { left: 0, top: 0, width: 0, rows: 0, pixels: FixedArray::default() }
}

///|
pub fn BgraSurface::left(self : BgraSurface) -> Int {
  self.left
}

///|
pub fn BgraSurface::top(self : BgraSurface) -> Int {
  self.top
}

///|
pub fn BgraSurface::width(self : BgraSurface) -> Int {
  self.width
}

///|
pub fn BgraSurface::rows(self : BgraSurface) -> Int {
  self.rows
}

///|
pub fn BgraSurface::is_empty(self : BgraSurface) -> Bool {
  self.width <= 0 || self.rows <= 0 || self.pixels.length() == 0
}

///|
fn BgraSurface::right(self : BgraSurface) -> Int {
  self.left + self.width
}

///|
fn BgraSurface::bottom(self : BgraSurface) -> Int {
  self.top - self.rows
}

///|
fn scale_channel(channel : Byte, alpha : Int) -> Byte {
  ((channel.to_int() * alpha + 127) / 255).to_byte()
}

///|
fn BgraSurface::row_pitch(self : BgraSurface) -> Int {
  self.width * 4
}

///|
fn mask_bounds(mask : GrayMaskSurface) -> (Int, Int, Int, Int) {
  (
    mask.left(),
    mask.top(),
    mask.left() + mask.width(),
    mask.top() - mask.rows(),
  )
}

///|
fn BgraSurface::ensure_bounds(
  self : BgraSurface,
  left : Int,
  top : Int,
  width : Int,
  rows : Int,
) -> Unit {
  if width <= 0 || rows <= 0 {
    return
  }
  let right = left + width
  let bottom = top - rows
  if self.is_empty() {
    self.left = left
    self.top = top
    self.width = width
    self.rows = rows
    self.pixels = FixedArray::make(width * rows * 4, b'\x00')
    return
  }
  let new_left = if left < self.left { left } else { self.left }
  let new_top = if top > self.top { top } else { self.top }
  let current_right = self.right()
  let new_right = if right > current_right { right } else { current_right }
  let current_bottom = self.bottom()
  let new_bottom = if bottom < current_bottom { bottom } else { current_bottom }
  if new_left == self.left &&
    new_top == self.top &&
    new_right == current_right &&
    new_bottom == current_bottom {
    return
  }
  let new_width = new_right - new_left
  let new_rows = new_top - new_bottom
  let new_pixels = FixedArray::make(new_width * new_rows * 4, b'\x00')
  let dst_row_offset = new_top - self.top
  let dst_col_offset = self.left - new_left
  let src_pitch = self.row_pitch()
  let dst_pitch = new_width * 4
  for row in 0..<self.rows {
    let src_offset = row * src_pitch
    let dst_offset = (dst_row_offset + row) * dst_pitch + dst_col_offset * 4
    for i in 0..<src_pitch {
      new_pixels[dst_offset + i] = self.pixels[src_offset + i]
    }
  }
  self.left = new_left
  self.top = new_top
  self.width = new_width
  self.rows = new_rows
  self.pixels = new_pixels
}

///|
pub fn surface_from_mask(
  mask : GrayMaskSurface,
  color : @types.Color,
  alpha_scale? : Int = 255,
) -> BgraSurface {
  let surface = BgraSurface::new()
  surface.blend_mask(mask, color, alpha_scale~)
  surface
}

///|
pub fn surface_from_mask_sampler(
  mask : GrayMaskSurface,
  sample : (Int, Int, Int) -> (Byte, Byte, Byte, Byte),
) -> BgraSurface {
  let surface = BgraSurface::new()
  if mask.is_empty() {
    return surface
  }
  surface.ensure_bounds(mask.left(), mask.top(), mask.width(), mask.rows())
  let dst_pitch = surface.row_pitch()
  let src_pitch = mask.width()
  let mask_buffer = mask.buffer()
  for row in 0..<mask.rows() {
    let src_offset = row * src_pitch
    let dst_offset = row * dst_pitch
    let world_y_top = mask.top() - row
    for x in 0..<mask.width() {
      let coverage = mask_buffer[src_offset + x].to_int()
      if coverage == 0 {
        continue
      }
      let world_x = mask.left() + x
      let (blue, green, red, alpha) = sample(world_x, world_y_top, coverage)
      blend_premul_pixel(
        surface.pixels,
        dst_offset + x * 4,
        blue,
        green,
        red,
        alpha,
      )
    }
  }
  surface
}

///|
pub fn BgraSurface::blend_mask(
  self : BgraSurface,
  mask : GrayMaskSurface,
  color : @types.Color,
  alpha_scale? : Int = 255,
) -> Unit {
  if mask.is_empty() {
    return
  }
  let effective_alpha = if alpha_scale <= 0 {
    0
  } else if alpha_scale >= 255 {
    255
  } else {
    alpha_scale
  }
  if effective_alpha == 0 {
    return
  }
  self.ensure_bounds(mask.left(), mask.top(), mask.width(), mask.rows())
  let dst_pitch = self.row_pitch()
  let src_pitch = mask.width()
  let row_offset = self.top - mask.top()
  let col_offset = mask.left() - self.left
  let mask_buffer = mask.buffer()
  for row in 0..<mask.rows() {
    let src_offset = row * src_pitch
    let dst_offset = (row_offset + row) * dst_pitch + col_offset * 4
    for x in 0..<mask.width() {
      let coverage = mask_buffer[src_offset + x].to_int()
      if coverage == 0 {
        continue
      }
      let scaled_coverage = (coverage * effective_alpha + 127) / 255
      let (blue, green, red, alpha) = premultiply_bgra(color, scaled_coverage)
      blend_premul_pixel(
        self.pixels,
        dst_offset + x * 4,
        blue,
        green,
        red,
        alpha,
      )
    }
  }
}

///|
pub fn BgraSurface::apply_mask(
  self : BgraSurface,
  mask : GrayMaskSurface,
) -> Unit {
  if self.is_empty() {
    return
  }
  if mask.is_empty() {
    self.pixels = FixedArray::make(self.pixels.length(), b'\x00')
    return
  }
  let (mask_left, mask_top, mask_right, mask_bottom) = mask_bounds(mask)
  let src_pitch = self.row_pitch()
  for row in 0..<self.rows {
    let world_y_top = self.top - row
    let in_y = world_y_top <= mask_top && world_y_top > mask_bottom
    let src_offset = row * src_pitch
    for x in 0..<self.width {
      let world_x = self.left + x
      let mask_alpha = if in_y && world_x >= mask_left && world_x < mask_right {
        let mask_row = mask_top - world_y_top
        let mask_col = world_x - mask_left
        mask.buffer()[mask_row * mask.width() + mask_col].to_int()
      } else {
        0
      }
      let dst = src_offset + x * 4
      self.pixels[dst] = scale_channel(self.pixels[dst], mask_alpha)
      self.pixels[dst + 1] = scale_channel(self.pixels[dst + 1], mask_alpha)
      self.pixels[dst + 2] = scale_channel(self.pixels[dst + 2], mask_alpha)
      self.pixels[dst + 3] = scale_channel(self.pixels[dst + 3], mask_alpha)
    }
  }
}

///|
fn copy_source_pixel(
  dst : FixedArray[Byte],
  dst_offset : Int,
  src : FixedArray[Byte],
  src_offset : Int,
) -> Unit {
  dst[dst_offset] = src[src_offset]
  dst[dst_offset + 1] = src[src_offset + 1]
  dst[dst_offset + 2] = src[src_offset + 2]
  dst[dst_offset + 3] = src[src_offset + 3]
}

///|
fn clamp_unit(value : Double) -> Double {
  if value <= 0.0 {
    0.0
  } else if value >= 1.0 {
    1.0
  } else {
    value
  }
}

///|
fn channel_to_unit(channel : Byte) -> Double {
  channel.to_int().to_double() / 255.0
}

///|
fn alpha_to_unit(alpha : Byte) -> Double {
  channel_to_unit(alpha)
}

///|
fn unit_to_byte(value : Double) -> Byte {
  (clamp_unit(value) * 255.0 + 0.5).to_int().to_byte()
}

///|
fn unpremul_channel(channel : Double, alpha : Double) -> Double {
  if alpha <= 0.0 {
    0.0
  } else {
    clamp_unit(channel / alpha)
  }
}

///|
fn compose_porter_duff(
  mode : Int,
  src_blue : Double,
  src_green : Double,
  src_red : Double,
  src_alpha : Double,
  dst_blue : Double,
  dst_green : Double,
  dst_red : Double,
  dst_alpha : Double,
) -> (Double, Double, Double, Double) {
  match mode {
    0 => (0.0, 0.0, 0.0, 0.0)
    1 => (src_blue, src_green, src_red, src_alpha)
    2 => (dst_blue, dst_green, dst_red, dst_alpha)
    3 =>
      (
        src_blue + dst_blue * (1.0 - src_alpha),
        src_green + dst_green * (1.0 - src_alpha),
        src_red + dst_red * (1.0 - src_alpha),
        src_alpha + dst_alpha * (1.0 - src_alpha),
      )
    4 =>
      (
        dst_blue + src_blue * (1.0 - dst_alpha),
        dst_green + src_green * (1.0 - dst_alpha),
        dst_red + src_red * (1.0 - dst_alpha),
        dst_alpha + src_alpha * (1.0 - dst_alpha),
      )
    5 =>
      (
        src_blue * dst_alpha,
        src_green * dst_alpha,
        src_red * dst_alpha,
        src_alpha * dst_alpha,
      )
    6 =>
      (
        dst_blue * src_alpha,
        dst_green * src_alpha,
        dst_red * src_alpha,
        dst_alpha * src_alpha,
      )
    7 =>
      (
        src_blue * (1.0 - dst_alpha),
        src_green * (1.0 - dst_alpha),
        src_red * (1.0 - dst_alpha),
        src_alpha * (1.0 - dst_alpha),
      )
    8 =>
      (
        dst_blue * (1.0 - src_alpha),
        dst_green * (1.0 - src_alpha),
        dst_red * (1.0 - src_alpha),
        dst_alpha * (1.0 - src_alpha),
      )
    9 =>
      (
        src_blue * dst_alpha + dst_blue * (1.0 - src_alpha),
        src_green * dst_alpha + dst_green * (1.0 - src_alpha),
        src_red * dst_alpha + dst_red * (1.0 - src_alpha),
        src_alpha * dst_alpha + dst_alpha * (1.0 - src_alpha),
      )
    10 =>
      (
        dst_blue * src_alpha + src_blue * (1.0 - dst_alpha),
        dst_green * src_alpha + src_green * (1.0 - dst_alpha),
        dst_red * src_alpha + src_red * (1.0 - dst_alpha),
        dst_alpha * src_alpha + src_alpha * (1.0 - dst_alpha),
      )
    11 =>
      (
        src_blue * (1.0 - dst_alpha) + dst_blue * (1.0 - src_alpha),
        src_green * (1.0 - dst_alpha) + dst_green * (1.0 - src_alpha),
        src_red * (1.0 - dst_alpha) + dst_red * (1.0 - src_alpha),
        src_alpha * (1.0 - dst_alpha) + dst_alpha * (1.0 - src_alpha),
      )
    12 =>
      (
        clamp_unit(src_blue + dst_blue),
        clamp_unit(src_green + dst_green),
        clamp_unit(src_red + dst_red),
        clamp_unit(src_alpha + dst_alpha),
      )
    _ =>
      (
        src_blue + dst_blue * (1.0 - src_alpha),
        src_green + dst_green * (1.0 - src_alpha),
        src_red + dst_red * (1.0 - src_alpha),
        src_alpha + dst_alpha * (1.0 - src_alpha),
      )
  }
}

///|
fn separable_blend(mode : Int, backdrop : Double, source : Double) -> Double {
  match mode {
    13 => backdrop + source - backdrop * source
    14 =>
      if backdrop <= 0.5 {
        2.0 * backdrop * source
      } else {
        1.0 - 2.0 * (1.0 - backdrop) * (1.0 - source)
      }
    15 => if backdrop < source { backdrop } else { source }
    16 => if backdrop > source { backdrop } else { source }
    17 =>
      if source >= 1.0 {
        1.0
      } else {
        clamp_unit(backdrop / (1.0 - source))
      }
    18 =>
      if source <= 0.0 {
        0.0
      } else {
        1.0 - clamp_unit((1.0 - backdrop) / source)
      }
    19 =>
      if source <= 0.5 {
        2.0 * backdrop * source
      } else {
        1.0 - 2.0 * (1.0 - backdrop) * (1.0 - source)
      }
    20 => {
      let d = if backdrop <= 0.25 {
        ((16.0 * backdrop - 12.0) * backdrop + 4.0) * backdrop
      } else {
        backdrop.sqrt()
      }
      if source <= 0.5 {
        backdrop - (1.0 - 2.0 * source) * backdrop * (1.0 - backdrop)
      } else {
        backdrop + (2.0 * source - 1.0) * (d - backdrop)
      }
    }
    21 => if backdrop >= source { backdrop - source } else { source - backdrop }
    22 => backdrop + source - 2.0 * backdrop * source
    23 => backdrop * source
    _ => source
  }
}

///|
fn clip_color(
  red : Double,
  green : Double,
  blue : Double,
) -> (Double, Double, Double) {
  let mut r = red
  let mut g = green
  let mut b = blue
  let lum = 0.3 * r + 0.59 * g + 0.11 * b
  let min_channel = if r < g {
    if r < b {
      r
    } else {
      b
    }
  } else if g < b {
    g
  } else {
    b
  }
  let max_channel = if r > g {
    if r > b {
      r
    } else {
      b
    }
  } else if g > b {
    g
  } else {
    b
  }
  if min_channel < 0.0 {
    let denom = lum - min_channel
    if denom != 0.0 {
      r = lum + (r - lum) * lum / denom
      g = lum + (g - lum) * lum / denom
      b = lum + (b - lum) * lum / denom
    }
  }
  if max_channel > 1.0 {
    let denom = max_channel - lum
    if denom != 0.0 {
      r = lum + (r - lum) * (1.0 - lum) / denom
      g = lum + (g - lum) * (1.0 - lum) / denom
      b = lum + (b - lum) * (1.0 - lum) / denom
    }
  }
  (clamp_unit(r), clamp_unit(g), clamp_unit(b))
}

///|
fn set_lum(
  red : Double,
  green : Double,
  blue : Double,
  lum : Double,
) -> (Double, Double, Double) {
  let d = lum - (0.3 * red + 0.59 * green + 0.11 * blue)
  clip_color(red + d, green + d, blue + d)
}

///|
fn saturation(red : Double, green : Double, blue : Double) -> Double {
  let min_channel = if red < green {
    if red < blue {
      red
    } else {
      blue
    }
  } else if green < blue {
    green
  } else {
    blue
  }
  let max_channel = if red > green {
    if red > blue {
      red
    } else {
      blue
    }
  } else if green > blue {
    green
  } else {
    blue
  }
  max_channel - min_channel
}

///|
fn set_sat(
  red : Double,
  green : Double,
  blue : Double,
  sat : Double,
) -> (Double, Double, Double) {
  let channels = [(red, 0), (green, 1), (blue, 2)]
  let sorted = channels
  sorted.sort_by(fn(a, b) { a.0.compare(b.0) })
  let min_value = sorted[0].0
  let mid_value = sorted[1].0
  let max_value = sorted[2].0
  let out = [0.0, 0.0, 0.0]
  if max_value > min_value {
    out[sorted[1].1] = (mid_value - min_value) * sat / (max_value - min_value)
    out[sorted[2].1] = sat
  }
  out[sorted[0].1] = 0.0
  (out[0], out[1], out[2])
}

///|
fn nonseparable_blend(
  mode : Int,
  backdrop_red : Double,
  backdrop_green : Double,
  backdrop_blue : Double,
  source_red : Double,
  source_green : Double,
  source_blue : Double,
) -> (Double, Double, Double) {
  let backdrop_lum = 0.3 * backdrop_red +
    0.59 * backdrop_green +
    0.11 * backdrop_blue
  let source_lum = 0.3 * source_red + 0.59 * source_green + 0.11 * source_blue
  let backdrop_sat = saturation(backdrop_red, backdrop_green, backdrop_blue)
  let source_sat = saturation(source_red, source_green, source_blue)
  match mode {
    24 => {
      let (r, g, b) = set_sat(
        source_red, source_green, source_blue, backdrop_sat,
      )
      set_lum(r, g, b, backdrop_lum)
    }
    25 => {
      let (r, g, b) = set_sat(
        backdrop_red, backdrop_green, backdrop_blue, source_sat,
      )
      set_lum(r, g, b, backdrop_lum)
    }
    26 => set_lum(source_red, source_green, source_blue, backdrop_lum)
    27 => set_lum(backdrop_red, backdrop_green, backdrop_blue, source_lum)
    _ => (source_red, source_green, source_blue)
  }
}

///|
fn compose_blend_mode(
  mode : Int,
  src_blue : Double,
  src_green : Double,
  src_red : Double,
  src_alpha : Double,
  dst_blue : Double,
  dst_green : Double,
  dst_red : Double,
  dst_alpha : Double,
) -> (Double, Double, Double, Double) {
  let out_alpha = src_alpha + dst_alpha - src_alpha * dst_alpha
  let src_blue_np = unpremul_channel(src_blue, src_alpha)
  let src_green_np = unpremul_channel(src_green, src_alpha)
  let src_red_np = unpremul_channel(src_red, src_alpha)
  let dst_blue_np = unpremul_channel(dst_blue, dst_alpha)
  let dst_green_np = unpremul_channel(dst_green, dst_alpha)
  let dst_red_np = unpremul_channel(dst_red, dst_alpha)
  let (blend_blue, blend_green, blend_red) = if mode >= 24 {
    let (r, g, b) = nonseparable_blend(
      mode, dst_red_np, dst_green_np, dst_blue_np, src_red_np, src_green_np, src_blue_np,
    )
    (b, g, r)
  } else {
    (
      separable_blend(mode, dst_blue_np, src_blue_np),
      separable_blend(mode, dst_green_np, src_green_np),
      separable_blend(mode, dst_red_np, src_red_np),
    )
  }
  (
    clamp_unit(
      (1.0 - src_alpha) * dst_blue +
      (1.0 - dst_alpha) * src_blue +
      src_alpha * dst_alpha * blend_blue,
    ),
    clamp_unit(
      (1.0 - src_alpha) * dst_green +
      (1.0 - dst_alpha) * src_green +
      src_alpha * dst_alpha * blend_green,
    ),
    clamp_unit(
      (1.0 - src_alpha) * dst_red +
      (1.0 - dst_alpha) * src_red +
      src_alpha * dst_alpha * blend_red,
    ),
    clamp_unit(out_alpha),
  )
}

///|
fn composite_pixel(
  mode : Int,
  src : FixedArray[Byte],
  src_offset : Int,
  dst : FixedArray[Byte],
  dst_offset : Int,
) -> Unit {
  let src_blue = channel_to_unit(src[src_offset])
  let src_green = channel_to_unit(src[src_offset + 1])
  let src_red = channel_to_unit(src[src_offset + 2])
  let src_alpha = alpha_to_unit(src[src_offset + 3])
  let dst_blue = channel_to_unit(dst[dst_offset])
  let dst_green = channel_to_unit(dst[dst_offset + 1])
  let dst_red = channel_to_unit(dst[dst_offset + 2])
  let dst_alpha = alpha_to_unit(dst[dst_offset + 3])
  let (out_blue, out_green, out_red, out_alpha) = if mode <= 12 {
    compose_porter_duff(
      mode, src_blue, src_green, src_red, src_alpha, dst_blue, dst_green, dst_red,
      dst_alpha,
    )
  } else {
    compose_blend_mode(
      mode, src_blue, src_green, src_red, src_alpha, dst_blue, dst_green, dst_red,
      dst_alpha,
    )
  }
  dst[dst_offset] = unit_to_byte(out_blue)
  dst[dst_offset + 1] = unit_to_byte(out_green)
  dst[dst_offset + 2] = unit_to_byte(out_red)
  dst[dst_offset + 3] = unit_to_byte(out_alpha)
}

///|
pub fn BgraSurface::blend_surface(
  self : BgraSurface,
  src : BgraSurface,
  composite_mode? : Int = 3,
) -> Unit {
  if src.is_empty() {
    return
  }
  self.ensure_bounds(src.left(), src.top(), src.width(), src.rows())
  let dst_pitch = self.row_pitch()
  let src_pitch = src.row_pitch()
  let zero_src = FixedArray::make(4, b'\x00')
  for row in 0..<self.rows {
    let world_y_top = self.top - row
    let dst_offset = row * dst_pitch
    let in_src_y = world_y_top <= src.top() && world_y_top > src.bottom()
    let src_row = src.top() - world_y_top
    for x in 0..<self.width {
      let world_x = self.left + x
      let d = dst_offset + x * 4
      if in_src_y && world_x >= src.left() && world_x < src.right() {
        let src_col = world_x - src.left()
        let s = src_row * src_pitch + src_col * 4
        if composite_mode == 1 {
          copy_source_pixel(self.pixels, d, src.pixels, s)
        } else if composite_mode == 3 {
          blend_premul_pixel(
            self.pixels,
            d,
            src.pixels[s],
            src.pixels[s + 1],
            src.pixels[s + 2],
            src.pixels[s + 3],
          )
        } else {
          composite_pixel(composite_mode, src.pixels, s, self.pixels, d)
        }
      } else if composite_mode != 3 {
        composite_pixel(composite_mode, zero_src, 0, self.pixels, d)
      }
    }
  }
}

///|
pub fn BgraSurface::to_bitmap(self : BgraSurface) -> (@types.Bitmap, Int, Int) {
  if self.is_empty() {
    return (empty_bgra_bitmap(), 0, 0)
  }
  (
    make_bgra_bitmap(self.width, self.rows, Bytes::from_array(self.pixels[:])),
    self.left,
    self.top,
  )
}
