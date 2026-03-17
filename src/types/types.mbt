///|
/// 2D vector with position values (font units, 16.16, or 26.6 depending on context).
pub(all) struct Vector {
  mut x : Int64
  mut y : Int64
} derive(Eq, Show, ToJson)

///|
/// Bounding box.
pub(all) struct BBox {
  mut x_min : Int64
  mut y_min : Int64
  mut x_max : Int64
  mut y_max : Int64
} derive(Eq, Show, ToJson)

///|
pub fn BBox::empty() -> BBox {
  { x_min: 0L, y_min: 0L, x_max: 0L, y_max: 0L }
}

///|
/// Glyph metrics (in font units or 26.6).
pub(all) struct GlyphMetrics {
  mut width : Int64
  mut height : Int64
  mut hori_bearing_x : Int64
  mut hori_bearing_y : Int64
  mut hori_advance : Int64
  mut vert_bearing_x : Int64
  mut vert_bearing_y : Int64
  mut vert_advance : Int64
} derive(Eq, Show, ToJson)

///|
pub fn GlyphMetrics::new() -> GlyphMetrics {
  {
    width: 0L,
    height: 0L,
    hori_bearing_x: 0L,
    hori_bearing_y: 0L,
    hori_advance: 0L,
    vert_bearing_x: 0L,
    vert_bearing_y: 0L,
    vert_advance: 0L,
  }
}

///|
/// Size metrics (in 26.6).
pub(all) struct SizeMetrics {
  mut x_ppem : UInt
  mut y_ppem : UInt
  mut x_scale : @fixed.Fixed
  mut y_scale : @fixed.Fixed
  mut ascender : Int64
  mut descender : Int64
  mut height : Int64
  mut max_advance : Int64
} derive(Eq, Show)
