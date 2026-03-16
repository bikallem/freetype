///|
test "mul_fix: basic cases" {
  // 1.0 * 1.0 = 1.0
  let one = @fixed.Fixed::one()
  inspect(@fixed.mul_fix(one, one), content="{val: 65536}")
  // 2.0 * 3.0 = 6.0
  let two = @fixed.Fixed::from_int(2)
  let three = @fixed.Fixed::from_int(3)
  inspect(@fixed.mul_fix(two, three), content="{val: 393216}")
  // 6.0 in 16.16 = 6 << 16 = 393216
  inspect(@fixed.mul_fix(two, three).to_int(), content="6")
}

///|
test "mul_fix: fractional" {
  // 0.5 * 0.5 = 0.25
  let half = @fixed.Fixed::from_raw(0x8000L) // 0.5 in 16.16
  let result = @fixed.mul_fix(half, half)
  // 0.25 in 16.16 = 0x4000 = 16384
  inspect(result, content="{val: 16384}")
}

///|
test "mul_fix: negative" {
  let neg_one = -@fixed.Fixed::one()
  let two = @fixed.Fixed::from_int(2)
  inspect(@fixed.mul_fix(neg_one, two).to_int(), content="-2")
}

///|
test "mul_div: basic" {
  // (10 * 20 + 3) / 6 = 203/6 = 33
  inspect(@fixed.mul_div(10L, 20L, 6L), content="33")
  // (7 * 3 + 2) / 4 = 23/4 = 5
  inspect(@fixed.mul_div(7L, 3L, 4L), content="5")
}

///|
test "mul_div: negative" {
  inspect(@fixed.mul_div(-10L, 20L, 6L), content="-33")
  inspect(@fixed.mul_div(10L, -20L, 6L), content="-33")
  inspect(@fixed.mul_div(-10L, -20L, 6L), content="33")
}

///|
test "mul_div: zero divisor" {
  inspect(@fixed.mul_div(10L, 20L, 0L), content="2147483647")
}

///|
test "div_fix: basic" {
  // 1 / 1 in 16.16 = 0x10000
  let r = @fixed.div_fix(1L, 1L)
  inspect(r, content="{val: 65536}")
  // 1 / 2 in 16.16 = 0x8000
  let r2 = @fixed.div_fix(1L, 2L)
  inspect(r2, content="{val: 32768}")
}

///|
test "msb: various" {
  inspect(@fixed.msb(0U), content="-1")
  inspect(@fixed.msb(1U), content="0")
  inspect(@fixed.msb(2U), content="1")
  inspect(@fixed.msb(255U), content="7")
  inspect(@fixed.msb(256U), content="8")
  inspect(@fixed.msb(0x8000_0000U), content="31")
  inspect(@fixed.msb(0xFFFF_FFFFU), content="31")
}

///|
test "sqrt_fixed: basic" {
  // sqrt(1.0) in 16.16 = 1 << 16 = 65536 → result should be 0x10000 = 65536
  // Input: 1.0 as UInt64 = 0x10000
  inspect(@fixed.sqrt_fixed(0x10000UL), content="65536")
  // sqrt(4.0) = 2.0 → input: 4<<16 = 0x40000, output: 2<<16 = 0x20000
  inspect(@fixed.sqrt_fixed(0x40000UL), content="131072")
  // sqrt(0) = 0
  inspect(@fixed.sqrt_fixed(0UL), content="0")
}

///|
test "corner_orientation" {
  // Counter-clockwise
  inspect(@fixed.corner_orientation(1L, 0L, 0L, 1L), content="1")
  // Clockwise
  inspect(@fixed.corner_orientation(0L, 1L, 1L, 0L), content="-1")
  // Colinear
  inspect(@fixed.corner_orientation(1L, 0L, 2L, 0L), content="0")
}

///|
test "corner_is_flat" {
  // Flat: same direction
  inspect(@fixed.corner_is_flat(100L, 0L, 100L, 0L), content="true")
  // Not flat: perpendicular
  inspect(@fixed.corner_is_flat(100L, 0L, 0L, 100L), content="false")
}
