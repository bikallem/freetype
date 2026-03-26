///|
fn render_test_font() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/DejaVuSans.ttf")
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
