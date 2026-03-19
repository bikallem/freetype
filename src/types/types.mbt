///|
/// 2D vector with position values (font units, 16.16, or 26.6 depending on context).
#valtype
struct Vector {
  x : Int64
  y : Int64
} derive(Eq, Show, ToJson)

///|
pub fn Vector::new(x : Int64, y : Int64) -> Vector {
  { x, y }
}

///|
pub fn Vector::x(self : Vector) -> Int64 {
  self.x
}

///|
pub fn Vector::y(self : Vector) -> Int64 {
  self.y
}

///|
/// Bounding box.
#valtype
struct BBox {
  x_min : Int64
  y_min : Int64
  x_max : Int64
  y_max : Int64
} derive(Eq, Show, ToJson)

///|
pub fn BBox::new(
  x_min : Int64,
  y_min : Int64,
  x_max : Int64,
  y_max : Int64,
) -> BBox {
  { x_min, y_min, x_max, y_max }
}

///|
pub fn BBox::empty() -> BBox {
  { x_min: 0L, y_min: 0L, x_max: 0L, y_max: 0L }
}

///|
pub fn BBox::x_min(self : BBox) -> Int64 {
  self.x_min
}

///|
pub fn BBox::y_min(self : BBox) -> Int64 {
  self.y_min
}

///|
pub fn BBox::x_max(self : BBox) -> Int64 {
  self.x_max
}

///|
pub fn BBox::y_max(self : BBox) -> Int64 {
  self.y_max
}

///|
/// Glyph metrics (in font units or 26.6).
struct GlyphMetrics {
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
pub fn GlyphMetrics::set_width(self : GlyphMetrics, v : Int64) -> Unit {
  self.width = v
}

///|
pub fn GlyphMetrics::set_height(self : GlyphMetrics, v : Int64) -> Unit {
  self.height = v
}

///|
pub fn GlyphMetrics::set_hori_bearing_x(self : GlyphMetrics, v : Int64) -> Unit {
  self.hori_bearing_x = v
}

///|
pub fn GlyphMetrics::set_hori_bearing_y(self : GlyphMetrics, v : Int64) -> Unit {
  self.hori_bearing_y = v
}

///|
pub fn GlyphMetrics::set_hori_advance(self : GlyphMetrics, v : Int64) -> Unit {
  self.hori_advance = v
}

///|
pub fn GlyphMetrics::set_vert_bearing_x(self : GlyphMetrics, v : Int64) -> Unit {
  self.vert_bearing_x = v
}

///|
pub fn GlyphMetrics::set_vert_bearing_y(self : GlyphMetrics, v : Int64) -> Unit {
  self.vert_bearing_y = v
}

///|
pub fn GlyphMetrics::set_vert_advance(self : GlyphMetrics, v : Int64) -> Unit {
  self.vert_advance = v
}

///|
pub fn GlyphMetrics::width(self : GlyphMetrics) -> Int64 {
  self.width
}

///|
pub fn GlyphMetrics::height(self : GlyphMetrics) -> Int64 {
  self.height
}

///|
pub fn GlyphMetrics::hori_bearing_x(self : GlyphMetrics) -> Int64 {
  self.hori_bearing_x
}

///|
pub fn GlyphMetrics::hori_bearing_y(self : GlyphMetrics) -> Int64 {
  self.hori_bearing_y
}

///|
pub fn GlyphMetrics::hori_advance(self : GlyphMetrics) -> Int64 {
  self.hori_advance
}

///|
pub fn GlyphMetrics::vert_bearing_x(self : GlyphMetrics) -> Int64 {
  self.vert_bearing_x
}

///|
pub fn GlyphMetrics::vert_bearing_y(self : GlyphMetrics) -> Int64 {
  self.vert_bearing_y
}

///|
pub fn GlyphMetrics::vert_advance(self : GlyphMetrics) -> Int64 {
  self.vert_advance
}

///|
/// Size metrics (in 26.6).
struct SizeMetrics {
  mut x_ppem : UInt
  mut y_ppem : UInt
  mut x_scale : @fixed.Fixed
  mut y_scale : @fixed.Fixed
  mut ascender : Int64
  mut descender : Int64
  mut height : Int64
  mut max_advance : Int64
} derive(Eq, Show)

///|
pub fn SizeMetrics::new(
  x_ppem? : UInt = 0U,
  y_ppem? : UInt = 0U,
  x_scale? : @fixed.Fixed = @fixed.Fixed::zero(),
  y_scale? : @fixed.Fixed = @fixed.Fixed::zero(),
  ascender? : Int64 = 0L,
  descender? : Int64 = 0L,
  height? : Int64 = 0L,
  max_advance? : Int64 = 0L,
) -> SizeMetrics {
  { x_ppem, y_ppem, x_scale, y_scale, ascender, descender, height, max_advance }
}

///|
pub fn SizeMetrics::set_x_ppem(self : SizeMetrics, v : UInt) -> Unit {
  self.x_ppem = v
}

///|
pub fn SizeMetrics::set_y_ppem(self : SizeMetrics, v : UInt) -> Unit {
  self.y_ppem = v
}

///|
pub fn SizeMetrics::set_x_scale(self : SizeMetrics, v : @fixed.Fixed) -> Unit {
  self.x_scale = v
}

///|
pub fn SizeMetrics::set_y_scale(self : SizeMetrics, v : @fixed.Fixed) -> Unit {
  self.y_scale = v
}

///|
pub fn SizeMetrics::set_ascender(self : SizeMetrics, v : Int64) -> Unit {
  self.ascender = v
}

///|
pub fn SizeMetrics::set_descender(self : SizeMetrics, v : Int64) -> Unit {
  self.descender = v
}

///|
pub fn SizeMetrics::set_height(self : SizeMetrics, v : Int64) -> Unit {
  self.height = v
}

///|
pub fn SizeMetrics::set_max_advance(self : SizeMetrics, v : Int64) -> Unit {
  self.max_advance = v
}

///|
pub fn SizeMetrics::x_ppem(self : SizeMetrics) -> UInt {
  self.x_ppem
}

///|
pub fn SizeMetrics::y_ppem(self : SizeMetrics) -> UInt {
  self.y_ppem
}

///|
pub fn SizeMetrics::x_scale(self : SizeMetrics) -> @fixed.Fixed {
  self.x_scale
}

///|
pub fn SizeMetrics::y_scale(self : SizeMetrics) -> @fixed.Fixed {
  self.y_scale
}

///|
pub fn SizeMetrics::ascender(self : SizeMetrics) -> Int64 {
  self.ascender
}

///|
pub fn SizeMetrics::descender(self : SizeMetrics) -> Int64 {
  self.descender
}

///|
pub fn SizeMetrics::height(self : SizeMetrics) -> Int64 {
  self.height
}

///|
pub fn SizeMetrics::max_advance(self : SizeMetrics) -> Int64 {
  self.max_advance
}
