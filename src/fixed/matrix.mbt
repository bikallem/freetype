///|
/// 2×2 matrix with 16.16 fixed-point entries.
/// Used for glyph transformations (scaling, rotation, skewing).
pub struct Matrix {
  mut xx : Fixed
  mut xy : Fixed
  mut yx : Fixed
  mut yy : Fixed
} derive(Eq, Show)

///|
/// Create a matrix with the given entries.
pub fn Matrix::new(xx : Fixed, xy : Fixed, yx : Fixed, yy : Fixed) -> Matrix {
  { xx, xy, yx, yy }
}

///|
/// Identity matrix.
pub fn Matrix::identity() -> Matrix {
  { xx: Fixed::one(), xy: Fixed::zero(), yx: Fixed::zero(), yy: Fixed::one() }
}

///|
/// Multiply matrix `a` into `self` (self = a * self).
/// Port of ftcalc.c FT_Matrix_Multiply.
pub fn Matrix::multiply(self : Matrix, a : Matrix) -> Unit {
  let xx = mul_fix(a.xx, self.xx) + mul_fix(a.xy, self.yx)
  let xy = mul_fix(a.xx, self.xy) + mul_fix(a.xy, self.yy)
  let yx = mul_fix(a.yx, self.xx) + mul_fix(a.yy, self.yx)
  let yy = mul_fix(a.yx, self.xy) + mul_fix(a.yy, self.yy)
  self.xx = xx
  self.xy = xy
  self.yx = yx
  self.yy = yy
}

///|
/// Invert this matrix in place.
/// Port of ftcalc.c FT_Matrix_Invert.
pub fn Matrix::invert(self : Matrix) -> Unit raise @error.FTError {
  let delta = mul_fix(self.xx, self.yy) - mul_fix(self.xy, self.yx)
  if delta.val == 0L {
    raise @error.FTError::InvalidArgument
  }
  let xy = -div_fix(self.xy.val, delta.val)
  let yx = -div_fix(self.yx.val, delta.val)
  let xx = div_fix(self.yy.val, delta.val)
  let yy = div_fix(self.xx.val, delta.val)
  self.xx = xx
  self.xy = xy
  self.yx = yx
  self.yy = yy
}

///|
/// Transform a vector (x, y) by this matrix.
/// Returns (xx*x + xy*y, yx*x + yy*y).
pub fn Matrix::transform(self : Matrix, x : Int64, y : Int64) -> (Int64, Int64) {
  let rx = mul_fix(self.xx, { val: x }).val + mul_fix(self.xy, { val: y }).val
  let ry = mul_fix(self.yx, { val: x }).val + mul_fix(self.yy, { val: y }).val
  (rx, ry)
}
