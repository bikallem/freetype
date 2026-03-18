///|
/// Bitmap image.
pub struct Bitmap {
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
