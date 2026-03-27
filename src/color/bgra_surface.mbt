///|
struct PngImage {
  width : Int
  height : Int
  buffer : Bytes
} derive(Eq, Show)

///|
pub fn PngImage::new(width : Int, height : Int, buffer : Bytes) -> PngImage {
  { width, height, buffer }
}

///|
pub fn PngImage::width(self : PngImage) -> Int {
  self.width
}

///|
pub fn PngImage::height(self : PngImage) -> Int {
  self.height
}

///|
pub fn PngImage::buffer(self : PngImage) -> Bytes {
  self.buffer
}

///|
fn premul_channel(channel : Int, alpha : Int) -> Byte {
  ((channel * alpha + 127) / 255).to_byte()
}

///|
pub fn premultiply_bgra(
  color : @types.Color,
  coverage : Int,
) -> (Byte, Byte, Byte, Byte) {
  let alpha = (coverage * color.alpha().to_int() + 127) / 255
  (
    premul_channel(color.blue().to_int(), alpha),
    premul_channel(color.green().to_int(), alpha),
    premul_channel(color.red().to_int(), alpha),
    alpha.to_byte(),
  )
}

///|
pub fn make_bgra_bitmap(
  width : Int,
  rows : Int,
  buffer : Bytes,
) -> @types.Bitmap {
  let bitmap = @types.Bitmap::new()
  bitmap.set_width(if width > 0 { width.reinterpret_as_uint() } else { 0U })
  bitmap.set_rows(if rows > 0 { rows.reinterpret_as_uint() } else { 0U })
  bitmap.set_pitch(if width > 0 { width * 4 } else { 0 })
  bitmap.set_num_grays(256U)
  bitmap.set_pixel_mode(@types.PixelMode::Bgra)
  bitmap.set_buffer(buffer)
  bitmap
}

///|
pub fn empty_bgra_bitmap() -> @types.Bitmap {
  make_bgra_bitmap(0, 0, b"")
}

///|
pub fn make_bitmap_glyph_data(
  bitmap : @types.Bitmap,
  left : Int,
  top : Int,
  hori_advance : Int,
  vert_advance? : Int = 0,
  vert_bearing_x? : Int = 0,
  vert_bearing_y? : Int = 0,
) -> @base.BitmapGlyphData {
  @base.BitmapGlyphData::new(
    @base.GlyphSlotData::new(
      bitmap.width().reinterpret_as_int().to_int64(),
      bitmap.rows().reinterpret_as_int().to_int64(),
      left.to_int64(),
      top.to_int64(),
      hori_advance.to_int64(),
      metrics_vert_bearing_x=vert_bearing_x.to_int64(),
      metrics_vert_bearing_y=vert_bearing_y.to_int64(),
      metrics_vert_advance=vert_advance.to_int64(),
    ),
    bitmap,
    left,
    top,
  )
}

///|
pub fn flip_bgra_horizontal(buffer : Bytes, width : Int, rows : Int) -> Bytes {
  if width <= 0 || rows <= 0 {
    return b""
  }
  let out = FixedArray::make(width * rows * 4, b'\x00')
  for row in 0..<rows {
    let src_row = row * width * 4
    for x in 0..<width {
      let src = src_row + x * 4
      let dst = src_row + (width - 1 - x) * 4
      out[dst] = buffer[src]
      out[dst + 1] = buffer[src + 1]
      out[dst + 2] = buffer[src + 2]
      out[dst + 3] = buffer[src + 3]
    }
  }
  Bytes::from_array(out[:])
}

///|
fn blend_premul_channel(src : Int, dst : Int, src_a : Int) -> Byte {
  let inv = 255 - src_a
  (src + (dst * inv + 127) / 255).to_byte()
}

///|
pub fn blend_premul_pixel(
  buffer : FixedArray[Byte],
  offset : Int,
  blue : Byte,
  green : Byte,
  red : Byte,
  alpha : Byte,
) -> Unit {
  let src_a = alpha.to_int()
  if src_a <= 0 {
    return
  }
  if src_a >= 255 {
    buffer[offset] = blue
    buffer[offset + 1] = green
    buffer[offset + 2] = red
    buffer[offset + 3] = alpha
    return
  }
  buffer[offset] = blend_premul_channel(
    blue.to_int(),
    buffer[offset].to_int(),
    src_a,
  )
  buffer[offset + 1] = blend_premul_channel(
    green.to_int(),
    buffer[offset + 1].to_int(),
    src_a,
  )
  buffer[offset + 2] = blend_premul_channel(
    red.to_int(),
    buffer[offset + 2].to_int(),
    src_a,
  )
  buffer[offset + 3] = blend_premul_channel(
    alpha.to_int(),
    buffer[offset + 3].to_int(),
    src_a,
  )
}
