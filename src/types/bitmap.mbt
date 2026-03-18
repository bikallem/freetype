///|
/// Bitmap image.
struct Bitmap {
  mut rows : UInt
  mut width : UInt
  mut pitch : Int // positive = top-down, negative = bottom-up
  mut buffer : Bytes
  mut num_grays : UInt // only meaningful for Gray mode
  mut pixel_mode : PixelMode
} derive(Eq, Show)

///|
pub fn Bitmap::new() -> Bitmap {
  {
    rows: 0U,
    width: 0U,
    pitch: 0,
    buffer: b"",
    num_grays: 0U,
    pixel_mode: PixelMode::None,
  }
}

///|
pub fn Bitmap::rows(self : Bitmap) -> UInt {
  self.rows
}

///|
pub fn Bitmap::width(self : Bitmap) -> UInt {
  self.width
}

///|
pub fn Bitmap::pitch(self : Bitmap) -> Int {
  self.pitch
}

///|
pub fn Bitmap::buffer(self : Bitmap) -> Bytes {
  self.buffer
}

///|
pub fn Bitmap::num_grays(self : Bitmap) -> UInt {
  self.num_grays
}

///|
pub fn Bitmap::pixel_mode(self : Bitmap) -> PixelMode {
  self.pixel_mode
}

///|
pub fn Bitmap::set_rows(self : Bitmap, v : UInt) -> Unit {
  self.rows = v
}

///|
pub fn Bitmap::set_width(self : Bitmap, v : UInt) -> Unit {
  self.width = v
}

///|
pub fn Bitmap::set_pitch(self : Bitmap, v : Int) -> Unit {
  self.pitch = v
}

///|
pub fn Bitmap::set_buffer(self : Bitmap, v : Bytes) -> Unit {
  self.buffer = v
}

///|
pub fn Bitmap::set_num_grays(self : Bitmap, v : UInt) -> Unit {
  self.num_grays = v
}

///|
pub fn Bitmap::set_pixel_mode(self : Bitmap, v : PixelMode) -> Unit {
  self.pixel_mode = v
}
