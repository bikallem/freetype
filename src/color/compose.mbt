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
pub fn BgraSurface::blend_surface(
  self : BgraSurface,
  src : BgraSurface,
  composite_mode? : Int = 3,
) -> Unit {
  if src.is_empty() {
    return
  }
  match composite_mode {
    0 => () // clear: drop source
    2 => () // dest: keep existing surface
    _ => {
      self.ensure_bounds(src.left(), src.top(), src.width(), src.rows())
      let dst_pitch = self.row_pitch()
      let src_pitch = src.row_pitch()
      let row_offset = self.top - src.top()
      let col_offset = src.left() - self.left
      for row in 0..<src.rows() {
        let src_offset = row * src_pitch
        let dst_offset = (row_offset + row) * dst_pitch + col_offset * 4
        for x in 0..<src.width() {
          let s = src_offset + x * 4
          let d = dst_offset + x * 4
          match composite_mode {
            1 => copy_source_pixel(self.pixels, d, src.pixels, s)
            _ =>
              blend_premul_pixel(
                self.pixels,
                d,
                src.pixels[s],
                src.pixels[s + 1],
                src.pixels[s + 2],
                src.pixels[s + 3],
              )
          }
        }
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
