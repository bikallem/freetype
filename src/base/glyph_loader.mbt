///|
/// GlyphLoader: accumulates outline data during glyph loading.
/// Used especially for composite glyphs where sub-glyphs are loaded
/// one at a time and their outlines merged. Port of ftgloadr.c.
pub(all) struct GlyphLoader {
  // Base outline: accumulated result so far
  mut base_points : Array[@types.Vector]
  mut base_tags : Array[Byte]
  mut base_contours : Array[UInt]
  // Current sub-glyph outline being loaded
  mut current_points : Array[@types.Vector]
  mut current_tags : Array[Byte]
  mut current_contours : Array[UInt]
  // Sub-glyph info
  mut subglyphs : Array[SubGlyph]
} derive(Show)

///|
pub fn GlyphLoader::new() -> GlyphLoader {
  {
    base_points: [],
    base_tags: [],
    base_contours: [],
    current_points: [],
    current_tags: [],
    current_contours: [],
    subglyphs: [],
  }
}

///|
/// Reset the loader, clearing all accumulated data.
pub fn GlyphLoader::reset(self : GlyphLoader) -> Unit {
  self.base_points = []
  self.base_tags = []
  self.base_contours = []
  self.current_points = []
  self.current_tags = []
  self.current_contours = []
  self.subglyphs = []
}

///|
/// Add a point to the current sub-glyph.
pub fn GlyphLoader::add_point(
  self : GlyphLoader,
  x : Int64,
  y : Int64,
  tag : Byte,
) -> Unit {
  self.current_points.push({ x, y })
  self.current_tags.push(tag)
}

///|
/// End the current contour.
pub fn GlyphLoader::end_contour(self : GlyphLoader) -> Unit {
  let n = self.current_points.length()
  if n > 0 {
    self.current_contours.push((n - 1).reinterpret_as_uint())
  }
}

///|
/// Merge current sub-glyph outline into the base.
/// Adjusts contour indices to be relative to the combined base.
pub fn GlyphLoader::add(self : GlyphLoader) -> Unit {
  let base_n_points = self.base_points.length()
  // Append current points and tags to base
  for i, pt in self.current_points {
    self.base_points.push(pt)
    self.base_tags.push(self.current_tags[i])
  }
  // Append contours with offset
  for _, contour in self.current_contours {
    let adjusted = contour.reinterpret_as_int() + base_n_points
    self.base_contours.push(adjusted.reinterpret_as_uint())
  }
  // Clear current
  self.current_points = []
  self.current_tags = []
  self.current_contours = []
}

///|
/// Build an Outline from the accumulated base data.
pub fn GlyphLoader::to_outline(self : GlyphLoader) -> @types.Outline {
  {
    points: self.base_points.copy(),
    tags: self.base_tags.copy(),
    contours: self.base_contours.copy(),
    flags: 0,
  }
}

///|
/// Number of points accumulated in the base.
pub fn GlyphLoader::base_n_points(self : GlyphLoader) -> Int {
  self.base_points.length()
}

///|
/// Number of contours accumulated in the base.
pub fn GlyphLoader::base_n_contours(self : GlyphLoader) -> Int {
  self.base_contours.length()
}
