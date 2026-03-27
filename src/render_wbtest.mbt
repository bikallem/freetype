///|
fn render_test_font() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/DejaVuSans.ttf")
}

///|
fn render_bitmap_test_font() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal.bdf")
}

///|
test "render_glyph: scalable glyph to bitmap" {
  let face = from_bytes(render_test_font())
  try! set_pixel_sizes(face, 0U, 16U)
  let gid = get_char_index(face, 65U)
  try! load_glyph(face, gid)
  inspect(face.glyph().format(), content="Outline")
  inspect(face.glyph().bitmap().rows(), content="0")
  try! render_glyph(face)
  inspect(face.glyph().format(), content="Bitmap")
  inspect(face.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(face.glyph().bitmap().width(), content="11")
  inspect(face.glyph().bitmap().rows(), content="12")
  inspect(face.glyph().bitmap_left(), content="0")
  inspect(face.glyph().bitmap_top(), content="12")
}

///|
test "load_glyph: LOAD_RENDER populates bitmap" {
  let face = from_bytes(render_test_font())
  try! set_pixel_sizes(face, 0U, 16U)
  let gid = get_char_index(face, 65U)
  try! load_glyph(face, gid, load_flags=@base.LOAD_RENDER)
  inspect(face.glyph().format(), content="Bitmap")
  inspect(face.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(face.glyph().bitmap().width(), content="11")
  inspect(face.glyph().bitmap().rows(), content="12")
  inspect(face.glyph().bitmap_left(), content="0")
  inspect(face.glyph().bitmap_top(), content="12")
}

///|
test "render_glyph: no-hint grayscale bytes match reference" {
  let face = from_bytes(render_test_font())
  try! set_pixel_sizes(face, 0U, 16U)
  let gid = get_char_index(face, 65U)
  try! load_glyph(face, gid, load_flags=@base.LOAD_NO_HINTING)
  try! render_glyph(face)
  inspect(face.glyph().bitmap().buffer().length(), content="132")
  inspect(face.glyph().bitmap().buffer()[0].to_int(), content="0")
  inspect(face.glyph().bitmap().buffer()[1].to_int(), content="0")
  inspect(face.glyph().bitmap().buffer()[2].to_int(), content="0")
  inspect(face.glyph().bitmap().buffer()[3].to_int(), content="0")
  inspect(face.glyph().bitmap().buffer()[4].to_int(), content="94")
  inspect(face.glyph().bitmap().buffer()[5].to_int(), content="172")
  inspect(face.glyph().bitmap().buffer()[6].to_int(), content="86")
  inspect(face.glyph().bitmap().buffer()[7].to_int(), content="0")
}

///|
test "render_glyph: no-hint light bytes match grayscale reference" {
  let face = from_bytes(render_test_font())
  try! set_pixel_sizes(face, 0U, 16U)
  let gid = get_char_index(face, 65U)
  try! load_glyph(face, gid, load_flags=@base.LOAD_NO_HINTING)
  try! render_glyph(face, mode=Light)
  inspect(face.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(face.glyph().bitmap().width(), content="11")
  inspect(face.glyph().bitmap().rows(), content="12")
  inspect(face.glyph().bitmap().buffer().length(), content="132")
  inspect(face.glyph().bitmap().buffer()[4].to_int(), content="94")
  inspect(face.glyph().bitmap().buffer()[5].to_int(), content="172")
  inspect(face.glyph().bitmap().buffer()[6].to_int(), content="86")
}

///|
test "render_glyph: repeated render on bitmap is stable" {
  let face = from_bytes(render_test_font())
  try! set_pixel_sizes(face, 0U, 16U)
  let gid = get_char_index(face, 65U)
  try! load_glyph(face, gid, load_flags=@base.LOAD_RENDER)
  let before = face.glyph().bitmap().buffer()
  try! render_glyph(face)
  inspect(face.glyph().format(), content="Bitmap")
  inspect(
    face.glyph().bitmap().buffer().length(),
    content=before.length().to_string(),
  )
  if before.length() > 0 {
    inspect(face.glyph().bitmap().buffer()[0], content=before[0].to_string())
  }
}

///|
test "render_glyph: monochrome bitmap matches reference" {
  let face = from_bytes(render_test_font())
  try! set_pixel_sizes(face, 0U, 16U)
  let gid = get_char_index(face, 65U)
  try! load_glyph(face, gid, load_flags=@base.LOAD_NO_HINTING)
  try! render_glyph(face, mode=Mono)
  inspect(face.glyph().format(), content="Bitmap")
  inspect(face.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(face.glyph().bitmap().width(), content="11")
  inspect(face.glyph().bitmap().rows(), content="12")
  inspect(face.glyph().bitmap().pitch(), content="2")
  inspect(face.glyph().bitmap_left(), content="0")
  inspect(face.glyph().bitmap_top(), content="12")
  inspect(face.glyph().bitmap().buffer().length(), content="24")
}

///|
test "render_glyph: lcd bitmap matches reference" {
  let face = from_bytes(render_test_font())
  try! set_pixel_sizes(face, 0U, 16U)
  let gid = get_char_index(face, 65U)
  try! load_glyph(face, gid, load_flags=@base.LOAD_NO_HINTING)
  try! render_glyph(face, mode=Lcd)
  inspect(face.glyph().format(), content="Bitmap")
  inspect(face.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(face.glyph().bitmap().width(), content="39")
  inspect(face.glyph().bitmap().rows(), content="12")
  inspect(face.glyph().bitmap().pitch(), content="40")
  inspect(face.glyph().bitmap_left(), content="-1")
  inspect(face.glyph().bitmap_top(), content="12")
  inspect(face.glyph().bitmap().buffer().length(), content="480")
  let expected = [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 38, 94, 151, 172, 172, 172, 142,
    86, 29, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  ]
  for i in 0..<expected.length() {
    inspect(
      face.glyph().bitmap().buffer()[i].to_int(),
      content=expected[i].to_string(),
    )
  }
}

///|
test "render_glyph: lcdv bitmap matches reference" {
  let face = from_bytes(render_test_font())
  try! set_pixel_sizes(face, 0U, 16U)
  let gid = get_char_index(face, 65U)
  try! load_glyph(face, gid, load_flags=@base.LOAD_NO_HINTING)
  try! render_glyph(face, mode=LcdV)
  inspect(face.glyph().format(), content="Bitmap")
  inspect(face.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(face.glyph().bitmap().width(), content="11")
  inspect(face.glyph().bitmap().rows(), content="39")
  inspect(face.glyph().bitmap().pitch(), content="11")
  inspect(face.glyph().bitmap_left(), content="0")
  inspect(face.glyph().bitmap_top(), content="12")
  inspect(face.glyph().bitmap().buffer().length(), content="429")
  let expected = [
    0, 0, 0, 0, 42, 88, 38, 0, 0, 0, 0, 0, 0, 0, 0, 94, 172, 86, 0, 0, 0, 0, 0, 0,
    0, 0, 157, 255, 144, 0, 0, 0, 0, 0, 0, 0, 0, 191, 255, 177, 0, 0, 0, 0, 0, 0,
    0, 1,
  ]
  for i in 0..<expected.length() {
    inspect(
      face.glyph().bitmap().buffer()[i].to_int(),
      content=expected[i].to_string(),
    )
  }
}

///|
test "load_glyph: render target flags select raster mode" {
  let face = from_bytes(render_test_font())
  try! set_pixel_sizes(face, 0U, 16U)
  let gid = get_char_index(face, 65U)

  try! load_glyph(
    face,
    gid,
    load_flags=@base.LOAD_RENDER |
      @base.LOAD_NO_HINTING |
      @base.LOAD_TARGET_LIGHT,
  )
  inspect(face.glyph().bitmap().pixel_mode(), content="Gray")

  try! load_glyph(
    face,
    gid,
    load_flags=@base.LOAD_RENDER |
      @base.LOAD_NO_HINTING |
      @base.LOAD_TARGET_MONO,
  )
  inspect(face.glyph().bitmap().pixel_mode(), content="Mono")

  try! load_glyph(
    face,
    gid,
    load_flags=@base.LOAD_RENDER | @base.LOAD_NO_HINTING | @base.LOAD_TARGET_LCD,
  )
  inspect(face.glyph().bitmap().pixel_mode(), content="Lcd")

  try! load_glyph(
    face,
    gid,
    load_flags=@base.LOAD_RENDER |
      @base.LOAD_NO_HINTING |
      @base.LOAD_TARGET_LCD_V,
  )
  inspect(face.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "render_glyph: bitmap font render is a no-op" {
  let face = from_bytes(render_bitmap_test_font())
  let gid = get_char_index(face, 65U)
  try! load_glyph(face, gid)
  let before = face.glyph().bitmap().buffer()
  inspect(face.glyph().bitmap().pixel_mode(), content="Mono")
  try! render_glyph(face, mode=Lcd)
  inspect(face.glyph().format(), content="Bitmap")
  inspect(face.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(
    face.glyph().bitmap().buffer().length(),
    content=before.length().to_string(),
  )
}
