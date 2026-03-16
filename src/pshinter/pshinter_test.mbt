///|
test "align_stem: basic" {
  // Scale = 1.0 (identity in 16.16 = 0x10000)
  let scale = @fixed.Fixed::one()
  let (pos, width) = @pshinter.align_stem(100L, 80L, scale)
  // Position should be rounded to pixel grid (multiples of 64 in 26.6)
  inspect(pos & 63L, content="0") // aligned to pixel
  // Width should be >= 64 (1 pixel minimum)
  inspect(width >= 64L, content="true")
}

///|
test "align_stem: thin stem gets minimum width" {
  let scale = @fixed.Fixed::one()
  let (_, width) = @pshinter.align_stem(0L, 10L, scale)
  // Thin stem should get minimum 1 pixel width
  inspect(width, content="64")
}

///|
test "PsGlobals::new defaults" {
  let g = @pshinter.PsGlobals::new()
  inspect(g.blue_shift, content="7")
  inspect(g.blue_fuzz, content="1")
  inspect(g.std_hw, content="0")
}
