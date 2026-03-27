///|
/// Render mode for converting a loaded glyph slot to a bitmap.
pub(all) enum RenderMode {
  Normal
  Light
  Mono
  Lcd
  LcdV
  Sdf
} derive(Eq, Show)

///|
fn render_mode_from_target_bits(load_flags : Int) -> RenderMode {
  match (load_flags & @base.LOAD_TARGET_MODE_MASK) >> 16 {
    1 => RenderMode::Light
    2 => RenderMode::Mono
    3 => RenderMode::Lcd
    4 => RenderMode::LcdV
    _ => RenderMode::Normal
  }
}

///|
fn render_mode_from_load_flags(load_flags : Int) -> RenderMode {
  if (load_flags & @base.LOAD_MONOCHROME) != 0 {
    RenderMode::Mono
  } else {
    render_mode_from_target_bits(load_flags)
  }
}
