// Parity tests for minimal_hmtx.woff2
// AUTO-GENERATED — do not edit

///|
fn load_generated_minimal_hmtx_woff2() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_hmtx.woff2")
}

///|
test "parity/minimal_hmtx.woff2: format" {
  inspect(
    @base.detect_format(load_generated_minimal_hmtx_woff2()),
    content="Woff2",
  )
}

///|
test "parity/minimal_hmtx.woff2: loads" {
  inspect(
    (try? @freetype.from_bytes(load_generated_minimal_hmtx_woff2())) is Ok(_),
    content="true",
  )
}

///|
test "parity/minimal_hmtx.woff2: metadata" {
  let f = @freetype.from_bytes(load_generated_minimal_hmtx_woff2())
  inspect(f.family_name(), content="Minimal")
  inspect(f.num_glyphs(), content="3")
  inspect(f.units_per_em(), content="1000")
  inspect(f.ascender(), content="800")
  inspect(f.descender(), content="-200")
  inspect(f.height(), content="1000")
}

///|
test "parity/minimal_hmtx.woff2: bbox" {
  let f = @freetype.from_bytes(load_generated_minimal_hmtx_woff2())
  inspect(f.bbox().x_min(), content="0")
  inspect(f.bbox().y_min(), content="0")
  inspect(f.bbox().x_max(), content="450")
  inspect(f.bbox().y_max(), content="700")
}

///|
test "parity/minimal_hmtx.woff2: flags" {
  let f = @freetype.from_bytes(load_generated_minimal_hmtx_woff2())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/minimal_hmtx.woff2: charmaps" {
  let f = @freetype.from_bytes(load_generated_minimal_hmtx_woff2())
  inspect(f.charmaps().length(), content="1")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="3")
    inspect(f.charmaps()[0].encoding_id(), content="1")
  }
}

///|
test "parity/minimal_hmtx.woff2: charmap entries" {
  let f = @freetype.from_bytes(load_generated_minimal_hmtx_woff2())
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 65U), content="2")
}

///|
test "parity/minimal_hmtx.woff2: glyph 2 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_minimal_hmtx_woff2())
  let r = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="3")
  inspect(f.glyph().outline().n_contours(), content="1")
  inspect(f.glyph().outline().points()[0].x(), content="50")
  inspect(f.glyph().outline().points()[0].y(), content="0")
  inspect(f.glyph().outline().points()[1].x(), content="250")
  inspect(f.glyph().outline().points()[1].y(), content="700")
  inspect(f.glyph().outline().points()[2].x(), content="450")
  inspect(f.glyph().outline().points()[2].y(), content="0")
  inspect(f.glyph().metrics().hori_advance(), content="500")
}

///|
test "parity/minimal_hmtx.woff2: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_generated_minimal_hmtx_woff2())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="512")
}

///|
test "parity/minimal_hmtx.woff2: rendered glyph 1 NORMAL char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_hmtx_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="0")
  inspect(f.glyph().bitmap().rows(), content="0")
  inspect(f.glyph().bitmap().pitch(), content="0")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="0")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "")
}

///|
test "parity/minimal_hmtx.woff2: rendered glyph 2 NORMAL char 65" {
  let f = @freetype.from_bytes(load_generated_minimal_hmtx_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "000000010100000000000034330000000000007d7c000000000000c6c5000000000012fcfc110000000058ffff5700000000a2ffffa100000001e9ffffe901000034ffffffff3300007dffffffff7c0000c6ffffffffc50012fcfffffffffc12",
  )
}

///|
test "parity/minimal_hmtx.woff2: rendered glyph 1 LIGHT char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_hmtx_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="0")
  inspect(f.glyph().bitmap().rows(), content="0")
  inspect(f.glyph().bitmap().pitch(), content="0")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="0")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "")
}

///|
test "parity/minimal_hmtx.woff2: rendered glyph 2 LIGHT char 65" {
  let f = @freetype.from_bytes(load_generated_minimal_hmtx_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "000000010100000000000034330000000000007d7c000000000000c6c5000000000012fcfc110000000058ffff5700000000a2ffffa100000001e9ffffe901000034ffffffff3300007dffffffff7c0000c6ffffffffc50012fcfffffffffc12",
  )
}

///|
test "parity/minimal_hmtx.woff2: rendered glyph 1 MONO char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_hmtx_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="1")
  inspect(f.glyph().bitmap().rows(), content="1")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="1")
  inspect(f.glyph().bitmap().buffer().length(), content="2")
}

///|
test "parity/minimal_hmtx.woff2: rendered glyph 2 MONO char 65" {
  let f = @freetype.from_bytes(load_generated_minimal_hmtx_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="6")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="11")
  inspect(f.glyph().bitmap().buffer().length(), content="22")
}

///|
test "parity/minimal_hmtx.woff2: rendered glyph 1 LCD char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_hmtx_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="6")
  inspect(f.glyph().bitmap().rows(), content="0")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="-1")
  inspect(f.glyph().bitmap_top(), content="0")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "")
}

///|
test "parity/minimal_hmtx.woff2: rendered glyph 2 LCD char 65" {
  let f = @freetype.from_bytes(load_generated_minimal_hmtx_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="24")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="24")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "000000000000000000000102020100000000000000000000000000000000000000003466663300000000000000000000000000000000000000297dd1d07c2800000000000000000000000000000000001a72c6ffffc5711a0000000000000000000000000000001263bbfcfffffcba6211000000000000000000000000000b58acf8fffffffff8ab570b0000000000000000000000044ea2f0fffffffffffff0a14d04000000000000000000013f97e9ffffffffffffffffe9963e0100000000000000003488dfffffffffffffffffffffdf873300000000000000297dd1ffffffffffffffffffffffffd07c2800000000001a72c6ffffffffffffffffffffffffffffc5711a0000001263bbfcfffffffffffffffffffffffffffffcbb631200",
  )
}

///|
test "parity/minimal_hmtx.woff2: rendered glyph 1 LCD_V char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_hmtx_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="0")
  inspect(f.glyph().bitmap().rows(), content="6")
  inspect(f.glyph().bitmap().pitch(), content="0")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="1")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "")
}

///|
test "parity/minimal_hmtx.woff2: rendered glyph 2 LCD_V char 65" {
  let f = @freetype.from_bytes(load_generated_minimal_hmtx_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="39")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "000000000000000000000001010000000000000a0a0000000000001c1c00000000000034330000000000004c4b00000000000065640000000000007d7c0000000000009594000000000000aead000000000000c6c5000000000000dedd000000000005f1f1050000000012fcfc110000000027ffff260000000040ffff3f0000000058ffff570000000070ffff6f000000008affff8900000000a2ffffa100000000baffffb900000000d3ffffd200000001e9ffffe90100000af8fffff80a00001cffffffff1c000034ffffffff3300004cffffffff4b000065ffffffff6400007dffffffff7c000095ffffffff940000aeffffffffad0000c6ffffffffc50000deffffffffdd0005f2fffffffff10512fcfffffffffc1212acacacacacac120d5454545454540c00000000000000000000000000000000",
  )
}

///|
test "parity/minimal_hmtx.woff2: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_minimal_hmtx_woff2())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="512")
}

///|
test "parity/minimal_hmtx.woff2: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_minimal_hmtx_woff2())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(
    f,
    2U,
    load_flags=@base.LOAD_FORCE_AUTOHINT,
  )
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="512")
}
