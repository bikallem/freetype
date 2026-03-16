///|
/// Outline representation: a set of contours made of points.
pub(all) struct Outline {
  mut points : Array[Vector] // coordinates
  mut tags : Array[Byte] // point flags (on-curve, conic, cubic)
  mut contours : Array[UInt] // end-point index for each contour
  mut flags : Int // FT_OUTLINE_XXX
} derive(Eq, Show)

///|
pub fn Outline::new() -> Outline {
  { points: [], tags: [], contours: [], flags: 0 }
}

///|
pub fn Outline::n_points(self : Outline) -> Int {
  self.points.length()
}

///|
pub fn Outline::n_contours(self : Outline) -> Int {
  self.contours.length()
}

// Outline flag constants

///|
pub let outline_none : Int = 0x0

///|
pub let outline_owner : Int = 0x1

///|
pub let outline_even_odd_fill : Int = 0x2

///|
pub let outline_reverse_fill : Int = 0x4

///|
pub let outline_ignore_dropouts : Int = 0x8

///|
pub let outline_smart_dropouts : Int = 0x10

///|
pub let outline_include_stubs : Int = 0x20

///|
pub let outline_overlap : Int = 0x40

///|
pub let outline_high_precision : Int = 0x100

///|
pub let outline_single_pass : Int = 0x200

// Curve tag constants

///|
/// Extract curve tag from point flag byte.
pub fn curve_tag(flag : Byte) -> Byte {
  flag & 0x03
}

///|
/// On-curve point.
pub let curve_tag_on : Byte = 0x01

///|
/// Off-curve conic (quadratic) control point.
pub let curve_tag_conic : Byte = 0x00

///|
/// Off-curve cubic control point.
pub let curve_tag_cubic : Byte = 0x02

///|
pub let curve_tag_has_scanmode : Byte = 0x04

///|
/// TrueType hinter: x-touched.
pub let curve_tag_touch_x : Byte = 0x08

///|
/// TrueType hinter: y-touched.
pub let curve_tag_touch_y : Byte = 0x10

///|
pub let curve_tag_touch_both : Byte = 0x18
