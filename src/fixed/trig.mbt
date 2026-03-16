///|
/// CORDIC shrink factor: 0.858785336480436 * 2^32 ≈ 0xDBD95B16
let trig_scale : UInt64 = 0xDBD9_5B16UL

///|
/// Maximum safe MSB for vector components during CORDIC.
let trig_safe_msb : Int = 29

///|
/// Number of CORDIC iterations.
let trig_max_iters : Int = 23

///|
/// Arctangent lookup table for CORDIC (16.16 degree units).
/// 22 entries used in iterations 1..22.
let trig_arctan_table : FixedArray[Int64] = [
  1740967L, 919879L, 466945L, 234379L, 117304L, 58666L, 29335L, 14668L, 7334L, 3667L,
  1833L, 917L, 458L, 229L, 115L, 57L, 29L, 14L, 7L, 4L, 2L, 1L,
]

///|
/// FT_ANGLE_PI = 180 << 16
pub let angle_pi : Int64 = 180L << 16

///|
/// FT_ANGLE_2PI = 360 << 16
pub let angle_2pi : Int64 = 360L << 16

///|
/// FT_ANGLE_PI2 = 90 << 16
pub let angle_pi2 : Int64 = 90L << 16

///|
/// FT_ANGLE_PI4 = 45 << 16
pub let angle_pi4 : Int64 = 45L << 16

///|
/// Multiply by CORDIC shrink factor (ft_trig_downscale).
fn trig_downscale(val : Int64) -> Int64 {
  let mut s = 1
  let mut v = val
  if v < 0L {
    v = -v
    s = -1
  }
  let uv = v.reinterpret_as_uint64()
  v = ((uv * trig_scale + 0x4000_0000UL) >> 32).reinterpret_as_int64()
  if s < 0 {
    -v
  } else {
    v
  }
}

///|
/// Normalize vector to safe bit range for CORDIC (ft_trig_prenorm).
/// Returns the shift applied (positive = left-shifted, negative = right-shifted).
fn trig_prenorm(x : Int64, y : Int64) -> (Int64, Int64, Int) {
  let ax = if x < 0L { -x } else { x }
  let ay = if y < 0L { -y } else { y }
  let combined = (ax | ay).reinterpret_as_uint64().to_uint()
  let m = msb(combined)
  if m < 0 {
    return (0L, 0L, 0)
  }
  let mut rx = x
  let mut ry = y
  let mut shift = 0
  if m <= trig_safe_msb {
    shift = trig_safe_msb - m
    rx = x << shift
    ry = y << shift
  } else {
    shift = m - trig_safe_msb
    rx = x >> shift
    ry = y >> shift
    shift = -shift
  }
  (rx, ry, shift)
}

///|
/// CORDIC pseudo-rotation: rotate vector (x,y) by theta.
fn trig_pseudo_rotate(x : Int64, y : Int64, theta : Int64) -> (Int64, Int64) {
  let mut rx = x
  let mut ry = y
  let mut th = theta
  // Reduce to [-PI/4, PI/4]
  while th < -angle_pi4 {
    let tmp = ry
    ry = -rx
    rx = tmp
    th = th + angle_pi2
  }
  while th > angle_pi4 {
    let tmp = -ry
    ry = rx
    rx = tmp
    th = th - angle_pi2
  }
  let mut b = 1L
  for i = 1; i < trig_max_iters; i = i + 1 {
    let arctan = trig_arctan_table[i - 1]
    if th < 0L {
      let xtemp = rx + ((ry + b) >> i)
      ry = ry - ((rx + b) >> i)
      rx = xtemp
      th = th + arctan
    } else {
      let xtemp = rx - ((ry + b) >> i)
      ry = ry + ((rx + b) >> i)
      rx = xtemp
      th = th - arctan
    }
    b = b << 1
  }
  (rx, ry)
}

///|
/// CORDIC pseudo-polarize: convert (x,y) to (magnitude, angle).
fn trig_pseudo_polarize(x : Int64, y : Int64) -> (Int64, Int64) {
  let mut rx = x
  let mut ry = y
  let mut theta = 0L
  // Reduce to first quadrant
  if ry > rx {
    if ry > -rx {
      theta = angle_pi2
      let tmp = ry
      ry = -rx
      rx = tmp
    } else {
      theta = if ry > 0L { angle_pi } else { -angle_pi }
      rx = -rx
      ry = -ry
    }
  } else if ry < -rx {
    theta = -angle_pi2
    let tmp = -ry
    ry = rx
    rx = tmp
  }
  let mut b = 1L
  for i = 1; i < trig_max_iters; i = i + 1 {
    let arctan = trig_arctan_table[i - 1]
    if ry > 0L {
      let xtemp = rx + ((ry + b) >> i)
      ry = ry - ((rx + b) >> i)
      rx = xtemp
      theta = theta + arctan
    } else {
      let xtemp = rx - ((ry + b) >> i)
      ry = ry + ((rx + b) >> i)
      rx = xtemp
      theta = theta - arctan
    }
    b = b << 1
  }
  // Round theta to reduce accumulated arctan table rounding errors
  if theta >= 0L {
    theta = (theta + 8L) & -16L
  } else {
    theta = -((-theta + 8L) & -16L)
  }
  (rx, theta)
}

// ---------------------------------------------------------------------------
// Public trigonometric API
// ---------------------------------------------------------------------------

///|
/// Compute unit vector for the given angle (16.16 degrees).
/// Returns (cos, sin) as Fixed values.
pub fn vector_unit(angle : Int64) -> (Fixed, Fixed) {
  let x0 = (trig_scale >> 8).reinterpret_as_int64()
  let y0 = 0L
  let (rx, ry) = trig_pseudo_rotate(x0, y0, angle)
  ({ val: (rx + 0x80L) >> 8 }, { val: (ry + 0x80L) >> 8 })
}

///|
/// Cosine of an angle (16.16 degrees). Returns Fixed.
pub fn cos(angle : Int64) -> Fixed {
  let (c, _) = vector_unit(angle)
  c
}

///|
/// Sine of an angle (16.16 degrees). Returns Fixed.
pub fn sin(angle : Int64) -> Fixed {
  let (_, s) = vector_unit(angle)
  s
}

///|
/// Tangent of an angle (16.16 degrees). Returns Fixed.
pub fn tan(angle : Int64) -> Fixed {
  let x0 = 1L << 24
  let y0 = 0L
  let (rx, ry) = trig_pseudo_rotate(x0, y0, angle)
  div_fix(ry, rx)
}

///|
/// Arctangent of (dx, dy). Returns angle in 16.16 degrees.
pub fn atan2(dx : Int64, dy : Int64) -> Int64 {
  if dx == 0L && dy == 0L {
    return 0L
  }
  let (rx, ry, _) = trig_prenorm(dx, dy)
  let (_, theta) = trig_pseudo_polarize(rx, ry)
  theta
}

///|
/// Rotate vector (x, y) by angle. Returns rotated (x, y).
pub fn vector_rotate(x : Int64, y : Int64, angle : Int64) -> (Int64, Int64) {
  if angle == 0L {
    return (x, y)
  }
  if x == 0L && y == 0L {
    return (0L, 0L)
  }
  let (nx, ny, shift) = trig_prenorm(x, y)
  let (rx, ry) = trig_pseudo_rotate(nx, ny, angle)
  let dx = trig_downscale(rx)
  let dy = trig_downscale(ry)
  if shift > 0 {
    let half = 1L << (shift - 1)
    (
      (dx + half - (if dx < 0L { 1L } else { 0L })) >> shift,
      (dy + half - (if dy < 0L { 1L } else { 0L })) >> shift,
    )
  } else {
    let s = -shift
    (dx << s, dy << s)
  }
}

///|
/// Compute length of vector (x, y).
pub fn vector_length(x : Int64, y : Int64) -> Int64 {
  if x == 0L {
    return if y < 0L { -y } else { y }
  }
  if y == 0L {
    return if x < 0L { -x } else { x }
  }
  let (nx, ny, shift) = trig_prenorm(x, y)
  let (mag, _) = trig_pseudo_polarize(nx, ny)
  let v = trig_downscale(mag)
  if shift > 0 {
    (v + (1L << (shift - 1))) >> shift
  } else {
    v << -shift
  }
}

///|
/// Convert vector to polar form: (length, angle).
pub fn vector_polarize(x : Int64, y : Int64) -> (Int64, Int64) {
  let (nx, ny, shift) = trig_prenorm(x, y)
  let (mag, theta) = trig_pseudo_polarize(nx, ny)
  let v = trig_downscale(mag)
  let length = if shift >= 0 { v >> shift } else { v << -shift }
  (length, theta)
}

///|
/// Create vector from polar coordinates (length, angle).
pub fn vector_from_polar(length : Int64, angle : Int64) -> (Int64, Int64) {
  vector_rotate(length, 0L, angle)
}

///|
/// Compute difference between two angles, normalized to [-PI, PI].
pub fn angle_diff(angle1 : Int64, angle2 : Int64) -> Int64 {
  let mut delta = angle2 - angle1
  while delta <= -angle_pi {
    delta = delta + angle_2pi
  }
  while delta > angle_pi {
    delta = delta - angle_2pi
  }
  delta
}
