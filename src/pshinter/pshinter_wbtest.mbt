///|
test "align_stem: basic" {
  // Scale = 1.0 (identity in 16.16 = 0x10000)
  let scale = @fixed.Fixed::one()
  let (pos, width) = align_stem(100L, 80L, scale)
  // Position should be rounded to pixel grid (multiples of 64 in 26.6)
  inspect(pos & 63L, content="0") // aligned to pixel
  // Width should be >= 64 (1 pixel minimum)
  inspect(width >= 64L, content="true")
}

///|
test "align_stem: thin stem gets minimum width" {
  let scale = @fixed.Fixed::one()
  let (_, width) = align_stem(0L, 10L, scale)
  // Thin stem should get minimum 1 pixel width
  inspect(width, content="64")
}

///|
test "PsGlobals::new defaults" {
  let g = PsGlobals::new()
  inspect(g.blue_shift, content="7")
  inspect(g.blue_fuzz, content="1")
  inspect(g.std_hw, content="0")
}

///|
test "fit_stems: top blue zones snap the top edge to the flat reference edge" {
  let defaults = PsGlobals::new()
  let globals = build_ps_globals(
    [-10, 0, 500, 510],
    [],
    0,
    0,
    @fixed.Fixed::from_int(128),
    defaults.blue_shift().to_int(),
    defaults.blue_fuzz().to_int(),
  )
  let scale = @fixed.Fixed::from_int(64)
  let fitted = fit_stems([@psaux.StemHint::new(500L, 10L)], globals, scale, true)
  inspect(fitted.length(), content="1")
  inspect(fitted[0].cur_pos() + fitted[0].cur_width(), content="32000")
  inspect(fitted[0].cur_pos(), content="31360")
}

///|
test "fit_stems: bottom zones only snap the bottom edge" {
  let defaults = PsGlobals::new()
  let globals = build_ps_globals(
    [-10, 0, 500, 510],
    [],
    0,
    0,
    @fixed.Fixed::from_int(128),
    defaults.blue_shift().to_int(),
    defaults.blue_fuzz().to_int(),
  )
  let scale = @fixed.Fixed::from_int(64)
  let fitted = fit_stems([@psaux.StemHint::new(-10L, 10L)], globals, scale, true)
  inspect(fitted.length(), content="1")
  inspect(fitted[0].cur_pos(), content="0")
  inspect(fitted[0].cur_pos() + fitted[0].cur_width(), content="640")
}
