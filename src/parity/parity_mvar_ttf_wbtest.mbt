// Parity tests for mvar.ttf
// AUTO-GENERATED — do not edit

///|
fn load_generated_mvar_ttf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/mvar.ttf")
}

///|
test "parity/mvar.ttf: format" {
  inspect(@base.detect_format(load_generated_mvar_ttf()) is (TrueType | TrueTypeCollection), content="true")
}

///|
test "parity/mvar.ttf: loads" {
  inspect((try? @freetype.from_bytes(load_generated_mvar_ttf())) is Ok(_), content="true")
}

///|
test "parity/mvar.ttf: metadata" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  inspect(f.family_name(), content="MVAR")
  inspect(f.num_glyphs(), content="3")
  inspect(f.units_per_em(), content="1000")
  inspect(f.ascender(), content="800")
  inspect(f.descender(), content="-200")
  inspect(f.height(), content="1000")
}

///|
test "parity/mvar.ttf: bbox" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  inspect(f.bbox().x_min(), content="0")
  inspect(f.bbox().y_min(), content="0")
  inspect(f.bbox().x_max(), content="450")
  inspect(f.bbox().y_max(), content="700")
}

///|
test "parity/mvar.ttf: flags" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/mvar.ttf: charmaps" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  inspect(f.charmaps().length(), content="1")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="3")
    inspect(f.charmaps()[0].encoding_id(), content="1")
  }
}

///|
test "parity/mvar.ttf: charmap entries" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 65U), content="2")
}

///|
test "parity/mvar.ttf: glyph 2 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
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
test "parity/mvar.ttf: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="512")
}

///|
test "parity/mvar.ttf: rendered glyph 1 NORMAL NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
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
test "parity/mvar.ttf: rendered glyph 2 NORMAL NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000010100000000000034330000000000007d7c000000000000c6c5000000000012fcfc110000000058ffff5700000000a2ffffa100000001e9ffffe901000034ffffffff3300007dffffffff7c0000c6ffffffffc50012fcfffffffffc12")
}

///|
test "parity/mvar.ttf: rendered glyph 1 LIGHT NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
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
test "parity/mvar.ttf: rendered glyph 2 LIGHT NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000010100000000000034330000000000007d7c000000000000c6c5000000000012fcfc110000000058ffff5700000000a2ffffa100000001e9ffffe901000034ffffffff3300007dffffffff7c0000c6ffffffffc50012fcfffffffffc12")
}

///|
test "parity/mvar.ttf: rendered glyph 1 MONO NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
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
test "parity/mvar.ttf: rendered glyph 2 MONO NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
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
test "parity/mvar.ttf: rendered glyph 1 LCD NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
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
test "parity/mvar.ttf: rendered glyph 2 LCD NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000102020100000000000000000000000000000000000000003466663300000000000000000000000000000000000000297dd1d07c2800000000000000000000000000000000001a72c6ffffc5711a0000000000000000000000000000001263bbfcfffffcba6211000000000000000000000000000b58acf8fffffffff8ab570b0000000000000000000000044ea2f0fffffffffffff0a14d04000000000000000000013f97e9ffffffffffffffffe9963e0100000000000000003488dfffffffffffffffffffffdf873300000000000000297dd1ffffffffffffffffffffffffd07c2800000000001a72c6ffffffffffffffffffffffffffffc5711a0000001263bbfcfffffffffffffffffffffffffffffcbb631200")
}

///|
test "parity/mvar.ttf: rendered glyph 1 LCD_V NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
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
test "parity/mvar.ttf: rendered glyph 2 LCD_V NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000001010000000000000a0a0000000000001c1c00000000000034330000000000004c4b00000000000065640000000000007d7c0000000000009594000000000000aead000000000000c6c5000000000000dedd000000000005f1f1050000000012fcfc110000000027ffff260000000040ffff3f0000000058ffff570000000070ffff6f000000008affff8900000000a2ffffa100000000baffffb900000000d3ffffd200000001e9ffffe90100000af8fffff80a00001cffffffff1c000034ffffffff3300004cffffffff4b000065ffffffff6400007dffffffff7c000095ffffffff940000aeffffffffad0000c6ffffffffc50000deffffffffdd0005f2fffffffff10512fcfffffffffc1212acacacacacac120d5454545454540c00000000000000000000000000000000")
}

///|
test "parity/mvar.ttf: rendered glyph 1 NORMAL DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/mvar.ttf: rendered glyph 2 NORMAL DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/mvar.ttf: rendered glyph 1 LIGHT DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/mvar.ttf: rendered glyph 2 LIGHT DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/mvar.ttf: rendered glyph 1 MONO DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/mvar.ttf: rendered glyph 2 MONO DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/mvar.ttf: rendered glyph 1 LCD DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/mvar.ttf: rendered glyph 2 LCD DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/mvar.ttf: rendered glyph 1 LCD_V DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/mvar.ttf: rendered glyph 2 LCD_V DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/mvar.ttf: rendered glyph 1 NORMAL NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
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
test "parity/mvar.ttf: rendered glyph 2 NORMAL NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="16")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="16")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000001010000000000000000000000000000343300000000000000000000000000007d7c0000000000000000000000000000c6c50000000000000000000000000012fcfc1100000000000000000000000058ffff57000000000000000000000000a1ffffa0000000000000000000000001e8ffffe8010000000000000000000034ffffffff33000000000000000000007dffffffff7c00000000000000000000c6ffffffffc500000000000000000012fcfffffffffc11000000000000000058ffffffffffff570000000000000000a2ffffffffffffa10000000000000001e9ffffffffffffe90100000000000034ffffffffffffffff330000000000007dffffffffffffffff7c000000000000c6ffffffffffffffffc5000000000012fcfffffffffffffffffc120000000059ffffffffffffffffffff5800000000a2ffffffffffffffffffffa100000001e9ffffffffffffffffffffe901000034ffffffffffffffffffffffff3300007dffffffffffffffffffffffff7c0000c6ffffffffffffffffffffffffc50012fcfffffffffffffffffffffffffc12")
}

///|
test "parity/mvar.ttf: rendered glyph 1 LIGHT NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
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
test "parity/mvar.ttf: rendered glyph 2 LIGHT NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="16")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="16")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000001010000000000000000000000000000343300000000000000000000000000007d7c0000000000000000000000000000c6c50000000000000000000000000012fcfc1100000000000000000000000058ffff57000000000000000000000000a1ffffa0000000000000000000000001e8ffffe8010000000000000000000034ffffffff33000000000000000000007dffffffff7c00000000000000000000c6ffffffffc500000000000000000012fcfffffffffc11000000000000000058ffffffffffff570000000000000000a2ffffffffffffa10000000000000001e9ffffffffffffe90100000000000034ffffffffffffffff330000000000007dffffffffffffffff7c000000000000c6ffffffffffffffffc5000000000012fcfffffffffffffffffc120000000059ffffffffffffffffffff5800000000a2ffffffffffffffffffffa100000001e9ffffffffffffffffffffe901000034ffffffffffffffffffffffff3300007dffffffffffffffffffffffff7c0000c6ffffffffffffffffffffffffc50012fcfffffffffffffffffffffffffc12")
}

///|
test "parity/mvar.ttf: rendered glyph 1 MONO NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
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
test "parity/mvar.ttf: rendered glyph 2 MONO NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="14")
  inspect(f.glyph().bitmap().rows(), content="25")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="25")
  inspect(f.glyph().bitmap().buffer().length(), content="50")
}

///|
test "parity/mvar.ttf: rendered glyph 1 LCD NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
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
test "parity/mvar.ttf: rendered glyph 2 LCD NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="48")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="48")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000102020100000000000000000000000000000000000000000000000000000000000000000000000000000000000000003466663300000000000000000000000000000000000000000000000000000000000000000000000000000000000000297dd1d07c2800000000000000000000000000000000000000000000000000000000000000000000000000000000001a72c6ffffc5711a0000000000000000000000000000000000000000000000000000000000000000000000000000001263bbfcfffffcba6211000000000000000000000000000000000000000000000000000000000000000000000000000b58acf8fffffffff8ab570b0000000000000000000000000000000000000000000000000000000000000000000000044da1f0fffffffffffff0a04c04000000000000000000000000000000000000000000000000000000000000000000013f97e8ffffffffffffffffe8963e0100000000000000000000000000000000000000000000000000000000000000003488dfffffffffffffffffffffdf873300000000000000000000000000000000000000000000000000000000000000297dd1ffffffffffffffffffffffffd07c2800000000000000000000000000000000000000000000000000000000001a72c6ffffffffffffffffffffffffffffc5711a0000000000000000000000000000000000000000000000000000001263bbfcfffffffffffffffffffffffffffffcba6211000000000000000000000000000000000000000000000000000b58acf8fffffffffffffffffffffffffffffffff8ab570b0000000000000000000000000000000000000000000000044ea2f0fffffffffffffffffffffffffffffffffffff0a14d04000000000000000000000000000000000000000000013f97e9ffffffffffffffffffffffffffffffffffffffffe9963e0100000000000000000000000000000000000000003488dfffffffffffffffffffffffffffffffffffffffffffffdf873300000000000000000000000000000000000000297dd1ffffffffffffffffffffffffffffffffffffffffffffffffd07c2800000000000000000000000000000000001a72c6ffffffffffffffffffffffffffffffffffffffffffffffffffffc5711a0000000000000000000000000000001263bbfcfffffffffffffffffffffffffffffffffffffffffffffffffffffcba6212000000000000000000000000000b59adf8fffffffffffffffffffffffffffffffffffffffffffffffffffffffff8ac580b0000000000000000000000044ea2f1fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0a14d04000000000000000000013f97e9ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe9963e0100000000000000003488dfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdf873300000000000000297dd1ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd07c2800000000001a72c6ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc5711a0000001263bbfcfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffcbb631200")
}

///|
test "parity/mvar.ttf: rendered glyph 1 LCD_V NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
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
test "parity/mvar.ttf: rendered glyph 2 LCD_V NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="16")
  inspect(f.glyph().bitmap().rows(), content="81")
  inspect(f.glyph().bitmap().pitch(), content="16")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000000010100000000000000000000000000000a0a00000000000000000000000000001c1c0000000000000000000000000000343300000000000000000000000000004c4b0000000000000000000000000000656400000000000000000000000000007d7c000000000000000000000000000095940000000000000000000000000000aead0000000000000000000000000000c6c50000000000000000000000000000dedd0000000000000000000000000005f1f10500000000000000000000000012fcfc1100000000000000000000000027ffff2600000000000000000000000040ffff3f00000000000000000000000058ffff5700000000000000000000000070ffff6f00000000000000000000000089ffff88000000000000000000000000a1ffffa0000000000000000000000000b9ffffb8000000000000000000000000d3ffffd2000000000000000000000001e8ffffe801000000000000000000000af8fffff70a000000000000000000001cffffffff1c0000000000000000000034ffffffff33000000000000000000004cffffffff4b0000000000000000000065ffffffff64000000000000000000007dffffffff7c0000000000000000000095ffffffff9400000000000000000000aeffffffffad00000000000000000000c6ffffffffc500000000000000000000deffffffffdd00000000000000000005f1fffffffff105000000000000000012fcfffffffffc11000000000000000027ffffffffffff26000000000000000040ffffffffffff3f000000000000000058ffffffffffff57000000000000000070ffffffffffff6f00000000000000008affffffffffff890000000000000000a2ffffffffffffa10000000000000000baffffffffffffb90000000000000000d3ffffffffffffd20000000000000001e9ffffffffffffe9010000000000000af8fffffffffffff80a0000000000001cffffffffffffffff1c00000000000034ffffffffffffffff330000000000004cffffffffffffffff4b00000000000065ffffffffffffffff640000000000007dffffffffffffffff7c00000000000095ffffffffffffffff94000000000000aeffffffffffffffffad000000000000c6ffffffffffffffffc5000000000000deffffffffffffffffdd000000000005f2fffffffffffffffff1050000000012fcfffffffffffffffffc120000000027ffffffffffffffffffff260000000040ffffffffffffffffffff3f0000000059ffffffffffffffffffff580000000071ffffffffffffffffffff70000000008affffffffffffffffffff8900000000a2ffffffffffffffffffffa100000000baffffffffffffffffffffb900000000d3ffffffffffffffffffffd200000001e9ffffffffffffffffffffe90100000af8fffffffffffffffffffff80a00001cffffffffffffffffffffffff1c000034ffffffffffffffffffffffff3300004cffffffffffffffffffffffff4b000065ffffffffffffffffffffffff6400007dffffffffffffffffffffffff7c000095ffffffffffffffffffffffff940000aeffffffffffffffffffffffffad0000c6ffffffffffffffffffffffffc50000deffffffffffffffffffffffffdd0005f2fffffffffffffffffffffffff10512fcfffffffffffffffffffffffffc1212acacacacacacacacacacacacacac120d54545454545454545454545454540c0000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/mvar.ttf: rendered glyph 1 NORMAL DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/mvar.ttf: rendered glyph 2 NORMAL DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/mvar.ttf: rendered glyph 1 LIGHT DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/mvar.ttf: rendered glyph 2 LIGHT DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/mvar.ttf: rendered glyph 1 MONO DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/mvar.ttf: rendered glyph 2 MONO DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/mvar.ttf: rendered glyph 1 LCD DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/mvar.ttf: rendered glyph 2 LCD DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/mvar.ttf: rendered glyph 1 LCD_V DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/mvar.ttf: rendered glyph 2 LCD_V DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/mvar.ttf: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="512")
}

///|
test "parity/mvar.ttf: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_mvar_ttf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_FORCE_AUTOHINT)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="512")
}

