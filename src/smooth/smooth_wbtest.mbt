///|
test "render_outline_normal: unit square" {
  let outline = @types.Outline::create(
    [
      @types.Vector::new(0L, 0L),
      @types.Vector::new(64L, 0L),
      @types.Vector::new(64L, 64L),
      @types.Vector::new(0L, 64L),
    ],
    [
      @types.CURVE_TAG_ON,
      @types.CURVE_TAG_ON,
      @types.CURVE_TAG_ON,
      @types.CURVE_TAG_ON,
    ],
    [3U],
  )
  let (bitmap, left, top) = render_outline_normal(outline)
  inspect(bitmap.width(), content="1")
  inspect(bitmap.rows(), content="1")
  inspect(bitmap.pitch(), content="1")
  inspect(bitmap.pixel_mode(), content="Gray")
  inspect(bitmap.num_grays(), content="256")
  inspect(left, content="0")
  inspect(top, content="1")
  inspect(bitmap.buffer().length(), content="1")
  inspect(bitmap.buffer()[0].to_int(), content="255")
}

///|
test "render_outline_normal: invalid outline returns InvalidOutline" {
  let outline = @types.Outline::create_with_counts(
    FixedArray::default(),
    FixedArray::default(),
    FixedArray::from_array([0U]),
    1,
    1,
  )
  let result = try? render_outline_normal(outline)
  inspect(result, content="Err(InvalidOutline)")
}
