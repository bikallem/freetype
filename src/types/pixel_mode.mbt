///|
/// Pixel mode for bitmaps.
pub(all) enum PixelMode {
  None
  Mono // 1-bit per pixel, MSB first
  Gray // 8-bit anti-aliased
  Gray2 // 2-bit
  Gray4 // 4-bit
  Lcd // 8-bit, 3× width (RGB/BGR subpixel)
  LcdV // 8-bit, 3× height (vertical LCD)
  Bgra // 32-bit BGRA color
} derive(Eq, Show)
