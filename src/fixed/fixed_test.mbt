///|
test "Fixed::from_int and to_int roundtrip" {
  inspect(@fixed.Fixed::from_int(42).to_int(), content="42")
  inspect(@fixed.Fixed::from_int(-7).to_int(), content="-7")
  inspect(@fixed.Fixed::from_int(0).to_int(), content="0")
}

///|
test "Fixed arithmetic" {
  let a = @fixed.Fixed::from_int(3)
  let b = @fixed.Fixed::from_int(5)
  inspect((a + b).to_int(), content="8")
  inspect((b - a).to_int(), content="2")
  inspect((-a).to_int(), content="-3")
}

///|
test "Fixed::round" {
  // 3.7 in 16.16 = 3*65536 + 0.7*65536 = 196608 + 45875 = 242483
  let v = @fixed.Fixed::from_raw(242483L)
  inspect(v.round().to_int(), content="4")
  // 3.3 = 196608 + 19661 = 216269
  let v2 = @fixed.Fixed::from_raw(216269L)
  inspect(v2.round().to_int(), content="3")
}

///|
test "Fixed::ceil and floor" {
  let v = @fixed.Fixed::from_raw(196609L) // just above 3.0
  inspect(v.ceil().to_int(), content="4")
  inspect(v.floor().to_int(), content="3")
  //
  let exact = @fixed.Fixed::from_int(5)
  inspect(exact.ceil().to_int(), content="5")
  inspect(exact.floor().to_int(), content="5")
}

///|
test "F26Dot6::from_int and to_int" {
  inspect(@fixed.F26Dot6::from_int(10).to_int(), content="10")
  inspect(@fixed.F26Dot6::from_int(-3).to_int(), content="-3")
}

///|
test "F26Dot6 arithmetic" {
  let a = @fixed.F26Dot6::from_int(10)
  let b = @fixed.F26Dot6::from_int(3)
  inspect((a + b).to_int(), content="13")
  inspect((a - b).to_int(), content="7")
  inspect((-b).to_int(), content="-3")
}

///|
test "F26Dot6::round, ceil, floor" {
  // 5.75 in 26.6 = 5*64 + 48 = 368
  let v = @fixed.F26Dot6::from_raw(368L)
  inspect(v.round().to_int(), content="6")
  inspect(v.ceil().to_int(), content="6")
  inspect(v.floor().to_int(), content="5")
}

///|
test "F2Dot14::to_fixed" {
  let v = @fixed.F2Dot14::one() // 0x4000 = 1.0 in 2.14
  let f = v.to_fixed()
  // 0x4000 << 2 = 0x10000 = 1.0 in 16.16
  inspect(f, content="{val: 65536}")
}
