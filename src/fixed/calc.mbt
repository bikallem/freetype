///|
/// FT_MulFix: multiply two 16.16 fixed-point values, return 16.16 result.
/// Equivalent to (a * b) / 0x10000 with rounding.
/// Port of ftcalc.c FT_MulFix (64-bit path).
pub fn mul_fix(a : Fixed, b : Fixed) -> Fixed {
  let ab = a.val * b.val
  // Arithmetic right shift for rounding bias: add 0x8000, but if negative
  // add 0x7FFF (the >> 63 gives -1 for negative, 0 for non-negative).
  let result = (ab + 0x8000L + (ab >> 63)) >> 16
  { val: result }
}

///|
/// FT_MulDiv: compute (a * b + c/2) / c with rounding to nearest.
/// Port of ftcalc.c FT_MulDiv (64-bit path).
pub fn mul_div(a : Int64, b : Int64, c : Int64) -> Int64 {
  let mut s = 1
  let mut ua = a
  let mut ub = b
  let mut uc = c
  if a < 0L {
    ua = -a
    s = -s
  }
  if b < 0L {
    ub = -b
    s = -s
  }
  if c < 0L {
    uc = -c
    s = -s
  }
  let d = if uc > 0L { (ua * ub + (uc >> 1)) / uc } else { 0x7FFF_FFFFL }
  if s < 0 {
    -d
  } else {
    d
  }
}

///|
/// FT_DivFix: compute (a << 16) / b with rounding. Returns 16.16 fixed.
/// Port of ftcalc.c FT_DivFix (64-bit path).
pub fn div_fix(a : Int64, b : Int64) -> Fixed {
  let mut s = 1
  let mut ua = a
  let mut ub = b
  if a < 0L {
    ua = -a
    s = -s
  }
  if b < 0L {
    ub = -b
    s = -s
  }
  let q = if ub > 0L { ((ua << 16) + (ub >> 1)) / ub } else { 0x7FFF_FFFFL }
  let result = if s < 0 { -q } else { q }
  { val: result }
}

///|
/// FT_MSB: return index of the most significant bit (0-based).
/// Returns -1 if z == 0.
pub fn msb(z : UInt) -> Int {
  if z == 0U {
    return -1
  }
  let mut v = z
  let mut shift = 0
  if (v & 0xFFFF_0000U) != 0U {
    v = v >> 16
    shift = shift + 16
  }
  if (v & 0x0000_FF00U) != 0U {
    v = v >> 8
    shift = shift + 8
  }
  if (v & 0x0000_00F0U) != 0U {
    v = v >> 4
    shift = shift + 4
  }
  if (v & 0x0000_000CU) != 0U {
    v = v >> 2
    shift = shift + 2
  }
  if (v & 0x0000_0002U) != 0U {
    shift = shift + 1
  }
  shift
}

///|
/// FT_SqrtFixed: integer square root of a 16.16 fixed-point value.
/// Uses Babylonian method. Port of ftcalc.c FT_SqrtFixed.
pub fn sqrt_fixed(v : UInt64) -> UInt {
  if v == 0UL {
    return 0U
  }
  let r = (v << 16) - 1UL
  // Initial guess: 1 << ((17 + MSB(v)) >> 1)
  let m = msb(v.to_uint())
  let mut q : UInt64 = 1UL << ((17 + m) >> 1)
  for ;; {
    let t = q
    q = (t + r / t + 1UL) >> 1
    if q == t {
      break
    }
  }
  q.to_uint()
}

///|
/// Determine orientation of corner formed by vectors (in_x,in_y) → (out_x,out_y).
/// Returns +1 (counter-clockwise), -1 (clockwise), or 0 (colinear).
pub fn corner_orientation(
  in_x : Int64,
  in_y : Int64,
  out_x : Int64,
  out_y : Int64,
) -> Int {
  let delta = in_x * out_y - in_y * out_x
  if delta > 0L {
    1
  } else if delta < 0L {
    -1
  } else {
    0
  }
}

///|
/// Test whether a corner is flat (nearly colinear).
/// Port of ftcalc.c ft_corner_is_flat.
pub fn corner_is_flat(
  in_x : Int64,
  in_y : Int64,
  out_x : Int64,
  out_y : Int64,
) -> Bool {
  fn hypot(x : Int64, y : Int64) -> Int64 {
    let ax = if x < 0L { -x } else { x }
    let ay = if y < 0L { -y } else { y }
    if ax > ay {
      ax + (ay >> 1)
    } else {
      ay + (ax >> 1)
    }
  }

  let d_in = hypot(in_x, in_y)
  let d_out = hypot(out_x, out_y)
  let d_hypot = hypot(in_x + out_x, in_y + out_y)
  d_in + d_out - d_hypot < d_hypot >> 4
}
