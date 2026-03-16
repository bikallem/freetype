///|
test "Matrix::identity transform" {
  let m = @fixed.Matrix::identity()
  let (rx, ry) = m.transform(0x30000L, 0x40000L)
  // Identity should return same values
  inspect(rx, content="196608")
  inspect(ry, content="262144")
  // 0x30000 = 196608, 0x40000 = 262144
}

///|
test "Matrix::multiply with identity" {
  let m = @fixed.Matrix::identity()
  let id = @fixed.Matrix::identity()
  m.multiply(id)
  inspect(
    m,
    content="{xx: {val: 65536}, xy: {val: 0}, yx: {val: 0}, yy: {val: 65536}}",
  )
}

///|
test "Matrix::invert identity" {
  let m = @fixed.Matrix::identity()
  m.invert()
  // Inverse of identity is identity
  inspect(m.xx.val, content="65536")
  inspect(m.xy.val, content="0")
  inspect(m.yx.val, content="0")
  inspect(m.yy.val, content="65536")
}

///|
test "Matrix::invert singular" {
  let m : @fixed.Matrix = {
    xx: @fixed.Fixed::zero(),
    xy: @fixed.Fixed::zero(),
    yx: @fixed.Fixed::zero(),
    yy: @fixed.Fixed::zero(),
  }
  let result = try? m.invert()
  inspect(result, content="Err(InvalidArgument)")
}
