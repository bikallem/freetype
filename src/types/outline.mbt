///|
/// Outline representation: a set of contours made of points.
struct Outline {
  mut points : FixedArray[Vector] // coordinates (may be larger than n_points)
  mut tags : FixedArray[Byte] // point flags (on-curve, conic, cubic)
  mut contours : FixedArray[UInt] // end-point index for each contour
  mut n_points_ : Int // actual point count (may be < points.length())
  mut n_contours_ : Int // actual contour count
  mut flags : Int // FT_OUTLINE_XXX
} derive(Eq, Show)

///|
pub fn Outline::new() -> Outline {
  {
    points: FixedArray::default(),
    tags: FixedArray::default(),
    contours: FixedArray::default(),
    n_points_: 0,
    n_contours_: 0,
    flags: 0,
  }
}

///|
pub fn Outline::create(
  points : FixedArray[Vector],
  tags : FixedArray[Byte],
  contours : FixedArray[UInt],
  flags? : Int = 0,
) -> Outline {
  {
    points,
    tags,
    contours,
    n_points_: points.length(),
    n_contours_: contours.length(),
    flags,
  }
}

///|
/// Create an outline with explicit point/contour counts.
/// Used when arrays may be larger than the actual data (reusable buffers).
pub fn Outline::create_with_counts(
  points : FixedArray[Vector],
  tags : FixedArray[Byte],
  contours : FixedArray[UInt],
  n_points : Int,
  n_contours : Int,
) -> Outline {
  {
    points,
    tags,
    contours,
    n_points_: n_points,
    n_contours_: n_contours,
    flags: 0,
  }
}

///|
pub fn Outline::set_flags(self : Outline, flags : Int) -> Unit {
  self.flags = flags
}

///|
pub fn Outline::n_points(self : Outline) -> Int {
  self.n_points_
}

///|
pub fn Outline::n_contours(self : Outline) -> Int {
  self.n_contours_
}

///|
pub fn Outline::points(self : Outline) -> FixedArray[Vector] {
  self.points
}

///|
pub fn Outline::tags(self : Outline) -> FixedArray[Byte] {
  self.tags
}

///|
pub fn Outline::contours(self : Outline) -> FixedArray[UInt] {
  self.contours
}

///|
pub fn Outline::flags(self : Outline) -> Int {
  self.flags
}

///|
pub fn Outline::set_points(self : Outline, points : FixedArray[Vector]) -> Unit {
  self.points = points
}

///|
pub fn Outline::set_tags(self : Outline, tags : FixedArray[Byte]) -> Unit {
  self.tags = tags
}

///|
pub fn Outline::set_contours(
  self : Outline,
  contours : FixedArray[UInt],
) -> Unit {
  self.contours = contours
}

// Outline flag constants

///|
pub const OUTLINE_NONE : Int = 0x0

///|
pub const OUTLINE_OWNER : Int = 0x1

///|
pub const OUTLINE_EVEN_ODD_FILL : Int = 0x2

///|
pub const OUTLINE_REVERSE_FILL : Int = 0x4

///|
pub const OUTLINE_IGNORE_DROPOUTS : Int = 0x8

///|
pub const OUTLINE_SMART_DROPOUTS : Int = 0x10

///|
pub const OUTLINE_INCLUDE_STUBS : Int = 0x20

///|
pub const OUTLINE_OVERLAP : Int = 0x40

///|
pub const OUTLINE_HIGH_PRECISION : Int = 0x100

///|
pub const OUTLINE_SINGLE_PASS : Int = 0x200

// Curve tag enum — preferred over raw Byte constants

///|
/// Curve point classification.
pub(all) enum CurveTag {
  On // on-curve point (was 0x01)
  Conic // off-curve conic/quadratic (was 0x00)
  Cubic // off-curve cubic (was 0x02)
} derive(Eq, Show)

///|
/// Convert a raw tag byte to a CurveTag, masking to the low 2 bits.
pub fn CurveTag::from_byte(b : Byte) -> CurveTag {
  match (b & 0x03).to_int() {
    0x01 => On
    0x02 => Cubic
    _ => Conic
  }
}

// Legacy Byte constants — kept for backward compatibility

///|
/// Extract curve tag from point flag byte.
pub fn curve_tag(flag : Byte) -> Byte {
  flag & 0x03
}

///|
/// On-curve point. (legacy — prefer CurveTag::On)
pub const CURVE_TAG_ON : Byte = 0x01

///|
/// Off-curve conic (quadratic) control point. (legacy — prefer CurveTag::Conic)
pub const CURVE_TAG_CONIC : Byte = 0x00

///|
/// Off-curve cubic control point. (legacy — prefer CurveTag::Cubic)
pub const CURVE_TAG_CUBIC : Byte = 0x02

///|
pub const CURVE_TAG_HAS_SCANMODE : Byte = 0x04

///|
/// TrueType hinter: x-touched.
pub const CURVE_TAG_TOUCH_X : Byte = 0x08

///|
/// TrueType hinter: y-touched.
pub const CURVE_TAG_TOUCH_Y : Byte = 0x10

///|
pub const CURVE_TAG_TOUCH_BOTH : Byte = 0x18
