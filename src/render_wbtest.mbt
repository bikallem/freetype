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
fn corrupt_first_embedded_png_crc(data : Bytes) -> Bytes {
  let signature : Bytes = b"\x89PNG\r\n\x1A\n"
  let bytes = FixedArray::make(data.length(), b'\x00')
  for i in 0..<data.length() {
    bytes[i] = data[i]
  }
  let mut png_start = -1
  for i in 0..<(data.length() - signature.length() + 1) {
    let mut match_ = true
    for j in 0..<signature.length() {
      if data[i + j] != signature[j] {
        match_ = false
        break
      }
    }
    if match_ {
      png_start = i
      break
    }
  }
  if png_start < 0 || png_start + 16 > bytes.length() {
    return data
  }
  let length_offset = png_start + signature.length()
  let chunk_len = (bytes[length_offset].to_int() << 24) |
    (bytes[length_offset + 1].to_int() << 16) |
    (bytes[length_offset + 2].to_int() << 8) |
    bytes[length_offset + 3].to_int()
  let crc_offset = length_offset + 8 + chunk_len
  if crc_offset + 3 >= bytes.length() {
    return data
  }
  bytes[crc_offset + 3] = bytes[crc_offset + 3] ^ b'\x01'
  Bytes::from_array(bytes[:])
}

///|
fn render_cbdt_test_font() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_cbdt.ttf")
}

///|
fn render_cbdt_all_test_font() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_cbdt_all.ttf")
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
fn render_colr_v1_gradients_test_font() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_colr_v1_gradients.ttf")
}

///|
fn render_colr_v1_var_test_font() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_colr_v1_var.ttf")
}

///|
fn render_nabla_test_font() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/Nabla[EDPT,EHLT].ttf")
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
fn bitmap_has_colored_bgra_pixel(bitmap : @types.Bitmap) -> Bool {
  if bitmap.pixel_mode() != @types.PixelMode::Bgra {
    return false
  }
  let buf = bitmap.buffer()
  let mut i = 0
  while i + 3 < buf.length() {
    if buf[i + 3] != b'\x00' &&
      (buf[i] != buf[i + 1] || buf[i + 1] != buf[i + 2]) {
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
test "load_glyph: corrupt embedded PNG CRC is rejected" {
  let face = from_bytes(
    corrupt_first_embedded_png_crc(render_color_test_font()),
  )
  try! set_pixel_sizes(face, 0U, 16U)
  let gid = get_char_index(face, 65U)
  let result : Result[Unit, @error.FTError] = Ok(
    load_glyph(face, gid, load_flags=@base.LOAD_COLOR),
  ) catch {
    err => Err(err)
  }
  inspect(result, content="Err(InvalidFileFormat)")
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
test "load_glyph: LOAD_COLOR renders COLR v1 gradients and composites" {
  let face = from_bytes(render_colr_v1_gradients_test_font())
  inspect(face.has_color(), content="true")
  try! set_pixel_sizes(face, 0U, 16U)

  let gid_a = get_char_index(face, 65U)
  inspect(gid_a, content="4")
  try! load_glyph(face, gid_a, load_flags=@base.LOAD_COLOR)
  inspect(face.glyph().format(), content="Bitmap")
  inspect(face.glyph().bitmap().pixel_mode(), content="Bgra")
  inspect(face.glyph().bitmap().buffer().length() > 0, content="true")

  let gid_a2 = get_char_index(face, 97U)
  inspect(gid_a2, content="5")
  try! load_glyph(face, gid_a2, load_flags=@base.LOAD_COLOR)
  inspect(face.glyph().format(), content="Bitmap")
  inspect(face.glyph().bitmap().pixel_mode(), content="Bgra")
  inspect(face.glyph().bitmap().buffer().length() > 0, content="true")
}

///|
test "load_glyph: LOAD_COLOR applies COLR v1 variation deltas" {
  let face = from_bytes(render_colr_v1_var_test_font())
  inspect(face.has_color(), content="true")
  inspect(face.has_multiple_masters(), content="true")
  try! set_pixel_sizes(face, 0U, 16U)
  let gid = get_char_index(face, 65U)
  inspect(gid, content="4")

  try! load_glyph(face, gid, load_flags=@base.LOAD_COLOR)
  let default_left = face.glyph().bitmap_left()
  let default_buffer = face.glyph().bitmap().buffer()

  try! set_var_design_coordinates(face, [
    (@fixed.Fixed::from_int(900), 0x77676874U),
  ])
  try! load_glyph(face, gid, load_flags=@base.LOAD_COLOR)
  inspect(face.is_variation(), content="true")
  inspect(face.glyph().bitmap_left() > default_left, content="true")
  inspect(face.glyph().bitmap().buffer() == default_buffer, content="false")
}

///|
test "load_glyph: real COLR v1 font renders BGRA bitmap" {
  let face = from_bytes(render_nabla_test_font())
  inspect(face.has_color(), content="true")
  inspect(face.has_multiple_masters(), content="true")
  try! set_pixel_sizes(face, 0U, 16U)
  let gid = get_char_index(face, 65U)
  inspect(gid > 0U, content="true")
  try! load_glyph(face, gid, load_flags=@base.LOAD_COLOR)
  inspect(face.glyph().format(), content="Bitmap")
  inspect(face.glyph().bitmap().pixel_mode(), content="Bgra")
  inspect(face.glyph().bitmap().buffer().length() > 0, content="true")
  inspect(bitmap_has_colored_bgra_pixel(face.glyph().bitmap()), content="true")
}

///|
test "load_glyph: real COLR v1 variation changes BGRA output" {
  let face = from_bytes(render_nabla_test_font())
  inspect(face.has_color(), content="true")
  inspect(face.has_multiple_masters(), content="true")
  try! set_pixel_sizes(face, 0U, 16U)
  let gid = get_char_index(face, 65U)
  inspect(gid > 0U, content="true")

  try! load_glyph(face, gid, load_flags=@base.LOAD_COLOR)
  let default_buffer = face.glyph().bitmap().buffer()

  try! set_var_design_coordinates(face, [
    (@fixed.Fixed::from_int(200), 0x45445054U),
    (@fixed.Fixed::from_int(24), 0x45484C54U),
  ])
  try! load_glyph(face, gid, load_flags=@base.LOAD_COLOR)
  inspect(face.is_variation(), content="true")
  inspect(face.glyph().bitmap().pixel_mode(), content="Bgra")
  inspect(face.glyph().bitmap().buffer() == default_buffer, content="false")
  inspect(bitmap_has_colored_bgra_pixel(face.glyph().bitmap()), content="true")
}

///|
test "load_glyph: LOAD_COLOR loads CBDT PNG and packed bitmap formats" {
  let face = from_bytes(render_cbdt_all_test_font())
  inspect(face.has_color(), content="true")
  try! set_pixel_sizes(face, 0U, 16U)

  try! load_glyph(face, get_char_index(face, 65U), load_flags=@base.LOAD_COLOR)
  inspect(face.glyph().bitmap().pixel_mode(), content="Bgra")
  inspect(face.glyph().bitmap().buffer().length() > 0, content="true")

  try! load_glyph(face, get_char_index(face, 66U), load_flags=@base.LOAD_COLOR)
  inspect(face.glyph().bitmap().pixel_mode(), content="Bgra")
  inspect(face.glyph().bitmap().buffer().length() > 0, content="true")

  try! load_glyph(face, get_char_index(face, 67U), load_flags=@base.LOAD_COLOR)
  inspect(face.glyph().bitmap().pixel_mode(), content="Bgra")
  inspect(face.glyph().bitmap().buffer().length() > 0, content="true")

  for code in [68U, 69U, 97U, 98U, 99U, 100U, 101U] {
    try! load_glyph(
      face,
      get_char_index(face, code),
      load_flags=@base.LOAD_COLOR,
    )
    inspect(face.glyph().bitmap().pixel_mode(), content="Gray4")
    inspect(face.glyph().bitmap().buffer().length() > 0, content="true")
  }
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
