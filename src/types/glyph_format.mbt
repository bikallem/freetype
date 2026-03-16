///|
/// Format of glyph image data.
pub(all) enum GlyphFormat {
  None
  Composite // 'comp'
  Bitmap // 'bits'
  Outline // 'outl'
  Plotter // 'plot'
  Svg // 'SVG '
} derive(Eq, Show)
