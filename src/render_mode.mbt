///|
/// Render mode for converting a loaded glyph slot to a bitmap.
pub(all) enum RenderMode {
  Normal
  Light
  Mono
  Lcd
  LcdV
} derive(Eq, Show)

///|
fn render_mode_from_load_flags(load_flags : Int) -> RenderMode {
  if (load_flags & @base.LOAD_MONOCHROME) != 0 {
    RenderMode::Mono
  } else {
    RenderMode::Normal
  }
}
