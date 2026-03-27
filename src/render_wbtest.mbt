///|
fn render_test_font() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/DejaVuSans.ttf")
}

///|
fn render_bitmap_test_font() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal.bdf")
}

///|
fn render_color_test_font() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_sbix.ttf")
}

///|
fn render_cbdt_test_font() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_cbdt.ttf")
}

///|
fn render_colr_v0_test_font() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_colr_v0.ttf")
}

///|
fn render_colr_v1_test_font() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_colr_v1.ttf")
}

///|
fn has_bgra_pixel(
  bitmap : @types.Bitmap,
  blue : Byte,
  green : Byte,
  red : Byte,
  alpha : Byte,
) -> Bool {
  if bitmap.pixel_mode() != @types.PixelMode::Bgra {
    return false
  }
  let buf = bitmap.buffer()
  let mut i = 0
  while i + 3 < buf.length() {
    if buf[i] == blue &&
      buf[i + 1] == green &&
      buf[i + 2] == red &&
      buf[i + 3] == alpha {
      return true
    }
    i += 4
  }
  false
}

///|
fn bitmap_has_value_at_least(bitmap : @types.Bitmap, threshold : Int) -> Bool {
  let buf = bitmap.buffer()
  for i in 0..<buf.length() {
    if buf[i].to_int() >= threshold {
      return true
    }
  }
  false
}

///|
fn bitmap_has_value_at_most(bitmap : @types.Bitmap, threshold : Int) -> Bool {
  let buf = bitmap.buffer()
  for i in 0..<buf.length() {
    if buf[i].to_int() <= threshold {
      return true
    }
  }
  false
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

///|
test "load_glyph: LOAD_COLOR loads sbix bitmap glyph" {
  let face = from_bytes(render_color_test_font())
  inspect(face.has_color(), content="true")
  try! set_pixel_sizes(face, 0U, 16U)
  let gid = get_char_index(face, 65U)
  inspect(gid, content="2")
  try! load_glyph(face, gid, load_flags=@base.LOAD_COLOR)
  inspect(face.glyph().format(), content="Bitmap")
  inspect(face.glyph().bitmap().pixel_mode(), content="Bgra")
  inspect(face.glyph().bitmap().width(), content="6")
  inspect(face.glyph().bitmap().rows(), content="6")
  inspect(face.glyph().bitmap().pitch(), content="24")
  inspect(face.glyph().bitmap().num_grays(), content="256")
  inspect(face.glyph().bitmap_left(), content="0")
  inspect(face.glyph().bitmap_top(), content="6")
  inspect(face.glyph().bitmap().buffer().length(), content="144")
  inspect(face.glyph().bitmap().buffer()[0].to_hex(), content="20")
  inspect(face.glyph().bitmap().buffer()[1].to_hex(), content="40")
  inspect(face.glyph().bitmap().buffer()[2].to_hex(), content="e0")
  inspect(face.glyph().bitmap().buffer()[3].to_hex(), content="ff")
}

///|
test "load_glyph: sbix font stays outline without LOAD_COLOR" {
  let face = from_bytes(render_color_test_font())
  try! set_pixel_sizes(face, 0U, 16U)
  let gid = get_char_index(face, 65U)
  try! load_glyph(face, gid)
  inspect(face.glyph().format(), content="Outline")
  inspect(face.glyph().bitmap().rows(), content="0")
}

///|
test "render_glyph: color bitmap slot is stable" {
  let face = from_bytes(render_color_test_font())
  try! set_pixel_sizes(face, 0U, 16U)
  let gid = get_char_index(face, 65U)
  try! load_glyph(face, gid, load_flags=@base.LOAD_COLOR)
  let before = face.glyph().bitmap().buffer()
  try! render_glyph(face, mode=Normal)
  inspect(face.glyph().format(), content="Bitmap")
  inspect(face.glyph().bitmap().pixel_mode(), content="Bgra")
  inspect(
    face.glyph().bitmap().buffer().length(),
    content=before.length().to_string(),
  )
  inspect(
    face.glyph().bitmap().buffer()[0].to_hex(),
    content=before[0].to_hex(),
  )
}

///|
test "load_glyph: LOAD_COLOR loads CBDT bitmap glyph" {
  let face = from_bytes(render_cbdt_test_font())
  inspect(face.has_color(), content="true")
  inspect(face.has_fixed_sizes(), content="true")
  inspect(face.available_sizes().length(), content="1")
  try! set_pixel_sizes(face, 0U, 16U)
  let gid = get_char_index(face, 65U)
  inspect(gid, content="2")
  try! load_glyph(face, gid, load_flags=@base.LOAD_COLOR)
  inspect(face.glyph().format(), content="Bitmap")
  inspect(face.glyph().bitmap().pixel_mode(), content="Bgra")
  inspect(face.glyph().bitmap().width(), content="6")
  inspect(face.glyph().bitmap().rows(), content="6")
  inspect(face.glyph().bitmap().pitch(), content="24")
  inspect(face.glyph().bitmap_left(), content="0")
  inspect(face.glyph().bitmap_top(), content="6")
  inspect(face.glyph().metrics().hori_advance(), content="8")
  inspect(face.glyph().bitmap().buffer().length(), content="144")
  inspect(face.glyph().bitmap().buffer()[0].to_hex(), content="20")
  inspect(face.glyph().bitmap().buffer()[1].to_hex(), content="40")
  inspect(face.glyph().bitmap().buffer()[2].to_hex(), content="e0")
  inspect(face.glyph().bitmap().buffer()[3].to_hex(), content="ff")
}

///|
test "load_glyph: LOAD_COLOR renders COLR v0 layers and palette selection" {
  let face = from_bytes(render_colr_v0_test_font())
  inspect(face.has_color(), content="true")
  try! set_pixel_sizes(face, 0U, 16U)
  let gid = get_char_index(face, 65U)
  inspect(gid, content="4")
  try! load_glyph(face, gid, load_flags=@base.LOAD_COLOR)
  inspect(face.glyph().format(), content="Bitmap")
  inspect(face.glyph().bitmap().pixel_mode(), content="Bgra")
  inspect(face.glyph().bitmap().width() > 0U, content="true")
  inspect(face.glyph().bitmap().rows() > 0U, content="true")
  inspect(
    has_bgra_pixel(face.glyph().bitmap(), b'\x00', b'\x00', b'\xFF', b'\xFF'),
    content="true",
  )
  inspect(
    has_bgra_pixel(face.glyph().bitmap(), b'\xFF', b'\x00', b'\x00', b'\xFF'),
    content="true",
  )

  ignore(try! select_palette(face, 1U))
  try! load_glyph(face, gid, load_flags=@base.LOAD_COLOR)
  inspect(
    has_bgra_pixel(face.glyph().bitmap(), b'\x00', b'\xFF', b'\x00', b'\xFF'),
    content="true",
  )
  inspect(
    has_bgra_pixel(face.glyph().bitmap(), b'\x00', b'\xFF', b'\xFF', b'\xFF'),
    content="true",
  )
}

///|
test "load_glyph: LOAD_COLOR renders COLR v1 with foreground color" {
  let face = from_bytes(render_colr_v1_test_font())
  inspect(face.has_color(), content="true")
  try! set_pixel_sizes(face, 0U, 16U)
  ignore(try! select_palette(face, 1U))
  set_foreground_color(
    face,
    @types.Color::new(b'\xFF', b'\x20', b'\x10', b'\xFF'),
  )
  let gid = get_char_index(face, 65U)
  inspect(gid, content="4")
  try! load_glyph(face, gid, load_flags=@base.LOAD_COLOR)
  inspect(face.glyph().format(), content="Bitmap")
  inspect(face.glyph().bitmap().pixel_mode(), content="Bgra")
  inspect(face.glyph().bitmap().width() > 0U, content="true")
  inspect(face.glyph().bitmap().rows() > 0U, content="true")
  inspect(
    has_bgra_pixel(face.glyph().bitmap(), b'\xFF', b'\x20', b'\x10', b'\xFF'),
    content="true",
  )
  inspect(
    has_bgra_pixel(face.glyph().bitmap(), b'\x00', b'\xFF', b'\xFF', b'\xFF'),
    content="true",
  )
}

///|
test "render_glyph: scalable glyph to sdf bitmap" {
  let face = from_bytes(render_test_font())
  try! set_pixel_sizes(face, 0U, 16U)
  try! set_sdf_spread(face, 2)
  let gid = get_char_index(face, 65U)
  try! load_glyph(face, gid, load_flags=@base.LOAD_NO_HINTING)
  try! render_glyph(face, mode=Sdf)
  inspect(face.glyph().format(), content="Bitmap")
  inspect(face.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(face.glyph().bitmap().width(), content="15")
  inspect(face.glyph().bitmap().rows(), content="16")
  inspect(face.glyph().bitmap_left(), content="-2")
  inspect(face.glyph().bitmap_top(), content="14")
  inspect(bitmap_has_value_at_most(face.glyph().bitmap(), 16), content="true")
  inspect(bitmap_has_value_at_least(face.glyph().bitmap(), 144), content="true")
}

///|
test "render_glyph: bitmap font can be re-rendered as sdf" {
  let face = from_bytes(render_bitmap_test_font())
  try! set_sdf_spread(face, 2)
  let gid = get_char_index(face, 65U)
  try! load_glyph(face, gid)
  let before_width = face.glyph().bitmap().width()
  let before_rows = face.glyph().bitmap().rows()
  try! render_glyph(face, mode=Sdf)
  inspect(face.glyph().format(), content="Bitmap")
  inspect(face.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(face.glyph().bitmap().width() > before_width, content="true")
  inspect(face.glyph().bitmap().rows() > before_rows, content="true")
  inspect(bitmap_has_value_at_most(face.glyph().bitmap(), 16), content="true")
  inspect(bitmap_has_value_at_least(face.glyph().bitmap(), 144), content="true")
}
