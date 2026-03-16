///|
test "vector_unit: 0 degrees = (1, 0)" {
  let (c, s) = @fixed.vector_unit(0L)
  // cos(0) = 1.0 = 0x10000, sin(0) = 0
  inspect(c, content="{val: 65536}")
  inspect(s, content="{val: 0}")
}

///|
test "vector_unit: 90 degrees" {
  let (c, s) = @fixed.vector_unit(@fixed.angle_pi2)
  // cos(90) ≈ 0, sin(90) ≈ 1.0
  // CORDIC has small errors, check within tolerance
  let cos_val = c.val
  let sin_val = s.val
  // Should be close to 0 and 65536 respectively
  inspect(cos_val >= -2L && cos_val <= 2L, content="true")
  inspect(sin_val >= 65534L && sin_val <= 65538L, content="true")
}

///|
test "vector_unit: 180 degrees" {
  let (c, s) = @fixed.vector_unit(@fixed.angle_pi)
  // cos(180) ≈ -1.0 = -0x10000, sin(180) ≈ 0
  inspect(c.val >= -65538L && c.val <= -65534L, content="true")
  inspect(s.val >= -2L && s.val <= 2L, content="true")
}

///|
test "cos and sin: 45 degrees" {
  let c = @fixed.cos(@fixed.angle_pi4)
  let s = @fixed.sin(@fixed.angle_pi4)
  // cos(45) = sin(45) = sqrt(2)/2 ≈ 0.7071 in 16.16 ≈ 46341
  inspect(c.val >= 46300L && c.val <= 46400L, content="true")
  inspect(s.val >= 46300L && s.val <= 46400L, content="true")
}

///|
test "atan2: basic quadrants" {
  // atan2(1, 0) = 0 degrees
  inspect(@fixed.atan2(1L, 0L), content="0")
  // atan2(0, 1) = 90 degrees = angle_pi2
  let a = @fixed.atan2(0L, 1L)
  inspect(
    a >= @fixed.angle_pi2 - 16L && a <= @fixed.angle_pi2 + 16L,
    content="true",
  )
  // atan2(0, 0) = 0
  inspect(@fixed.atan2(0L, 0L), content="0")
}

///|
test "vector_length" {
  // Length of (3, 4) = 5
  let len = @fixed.vector_length(3L, 4L)
  inspect(len, content="5")
  // Length of (0, 7) = 7
  inspect(@fixed.vector_length(0L, 7L), content="7")
  // Length of (-5, 0) = 5
  inspect(@fixed.vector_length(-5L, 0L), content="5")
}

///|
test "vector_rotate: 0 angle is identity" {
  let (rx, ry) = @fixed.vector_rotate(100L, 200L, 0L)
  inspect(rx, content="100")
  inspect(ry, content="200")
}

///|
test "angle_diff" {
  inspect(@fixed.angle_diff(0L, @fixed.angle_pi2), content="5898240")
  // angle_pi2 = 90<<16 = 5898240
  inspect(@fixed.angle_diff(@fixed.angle_pi, -@fixed.angle_pi), content="0")
}
