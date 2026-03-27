// Parity tests for Roboto[wdth,wght].ttf
// AUTO-GENERATED — do not edit

///|
fn load_generated_roboto_wdth_wght__ttf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/Roboto[wdth,wght].ttf")
}

///|
test "parity/Roboto[wdth,wght].ttf: format" {
  inspect(@base.detect_format(load_generated_roboto_wdth_wght__ttf()) is (TrueType | TrueTypeCollection), content="true")
}

///|
test "parity/Roboto[wdth,wght].ttf: loads" {
  inspect((try? @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())) is Ok(_), content="true")
}

///|
test "parity/Roboto[wdth,wght].ttf: metadata" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  inspect(f.family_name(), content="Roboto")
  inspect(f.num_glyphs(), content="1326")
  inspect(f.units_per_em(), content="2048")
  inspect(f.ascender(), content="1900")
  inspect(f.descender(), content="-500")
  inspect(f.height(), content="2400")
  inspect(f.underline_position(), content="-200")
  inspect(f.underline_thickness(), content="100")
}

///|
test "parity/Roboto[wdth,wght].ttf: bbox" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  inspect(f.bbox().x_min(), content="-1510")
  inspect(f.bbox().y_min(), content="-555")
  inspect(f.bbox().x_max(), content="2353")
  inspect(f.bbox().y_max(), content="2163")
}

///|
test "parity/Roboto[wdth,wght].ttf: flags" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/Roboto[wdth,wght].ttf: charmaps" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  inspect(f.charmaps().length(), content="2")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="0")
    inspect(f.charmaps()[0].encoding_id(), content="3")
  }
  if f.charmaps().length() > 1 {
    inspect(f.charmaps()[1].platform_id(), content="3")
    inspect(f.charmaps()[1].encoding_id(), content="1")
  }
}

///|
test "parity/Roboto[wdth,wght].ttf: charmap entries" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  inspect(@freetype.get_char_index(f, 0U), content="1")
  inspect(@freetype.get_char_index(f, 2U), content="2")
  inspect(@freetype.get_char_index(f, 13U), content="3")
  inspect(@freetype.get_char_index(f, 32U), content="4")
  inspect(@freetype.get_char_index(f, 33U), content="5")
  inspect(@freetype.get_char_index(f, 34U), content="6")
  inspect(@freetype.get_char_index(f, 35U), content="7")
  inspect(@freetype.get_char_index(f, 36U), content="8")
  inspect(@freetype.get_char_index(f, 37U), content="9")
  inspect(@freetype.get_char_index(f, 38U), content="10")
  inspect(@freetype.get_char_index(f, 39U), content="11")
  inspect(@freetype.get_char_index(f, 40U), content="12")
  inspect(@freetype.get_char_index(f, 41U), content="13")
  inspect(@freetype.get_char_index(f, 42U), content="14")
  inspect(@freetype.get_char_index(f, 43U), content="15")
  inspect(@freetype.get_char_index(f, 44U), content="16")
  inspect(@freetype.get_char_index(f, 45U), content="17")
  inspect(@freetype.get_char_index(f, 46U), content="18")
  inspect(@freetype.get_char_index(f, 47U), content="19")
  inspect(@freetype.get_char_index(f, 48U), content="20")
  inspect(@freetype.get_char_index(f, 49U), content="21")
  inspect(@freetype.get_char_index(f, 50U), content="22")
  inspect(@freetype.get_char_index(f, 51U), content="23")
  inspect(@freetype.get_char_index(f, 52U), content="24")
  inspect(@freetype.get_char_index(f, 53U), content="25")
  inspect(@freetype.get_char_index(f, 54U), content="26")
  inspect(@freetype.get_char_index(f, 55U), content="27")
  inspect(@freetype.get_char_index(f, 56U), content="28")
  inspect(@freetype.get_char_index(f, 57U), content="29")
  inspect(@freetype.get_char_index(f, 58U), content="30")
  inspect(@freetype.get_char_index(f, 59U), content="31")
  inspect(@freetype.get_char_index(f, 60U), content="32")
  inspect(@freetype.get_char_index(f, 61U), content="33")
  inspect(@freetype.get_char_index(f, 62U), content="34")
  inspect(@freetype.get_char_index(f, 63U), content="35")
  inspect(@freetype.get_char_index(f, 64U), content="36")
  inspect(@freetype.get_char_index(f, 65U), content="37")
  inspect(@freetype.get_char_index(f, 66U), content="38")
  inspect(@freetype.get_char_index(f, 67U), content="39")
  inspect(@freetype.get_char_index(f, 68U), content="40")
  inspect(@freetype.get_char_index(f, 69U), content="41")
  inspect(@freetype.get_char_index(f, 70U), content="42")
  inspect(@freetype.get_char_index(f, 71U), content="43")
  inspect(@freetype.get_char_index(f, 72U), content="44")
  inspect(@freetype.get_char_index(f, 73U), content="45")
  inspect(@freetype.get_char_index(f, 74U), content="46")
  inspect(@freetype.get_char_index(f, 75U), content="47")
  inspect(@freetype.get_char_index(f, 76U), content="48")
  inspect(@freetype.get_char_index(f, 77U), content="49")
  inspect(@freetype.get_char_index(f, 78U), content="50")
}

///|
test "parity/Roboto[wdth,wght].ttf: glyph 5 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  let r = try? @freetype.load_glyph(f, 5U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="16")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="361")
  inspect(f.glyph().outline().points()[0].y(), content="1456")
  inspect(f.glyph().outline().points()[1].x(), content="348")
  inspect(f.glyph().outline().points()[1].y(), content="411")
  inspect(f.glyph().outline().points()[2].x(), content="181")
  inspect(f.glyph().outline().points()[2].y(), content="411")
  inspect(f.glyph().outline().points()[3].x(), content="167")
  inspect(f.glyph().outline().points()[3].y(), content="1456")
  inspect(f.glyph().outline().points()[4].x(), content="161")
  inspect(f.glyph().outline().points()[4].y(), content="93")
  inspect(f.glyph().outline().points()[5].x(), content="161")
  inspect(f.glyph().outline().points()[5].y(), content="138")
  inspect(f.glyph().outline().points()[6].x(), content="216")
  inspect(f.glyph().outline().points()[6].y(), content="200")
  inspect(f.glyph().outline().points()[7].x(), content="270")
  inspect(f.glyph().outline().points()[7].y(), content="200")
  inspect(f.glyph().metrics().hori_advance(), content="528")
}

///|
test "parity/Roboto[wdth,wght].ttf: glyph 6 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  let r = try? @freetype.load_glyph(f, 6U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="12")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="278")
  inspect(f.glyph().outline().points()[0].y(), content="1536")
  inspect(f.glyph().outline().points()[1].x(), content="278")
  inspect(f.glyph().outline().points()[1].y(), content="1400")
  inspect(f.glyph().outline().points()[2].x(), content="248")
  inspect(f.glyph().outline().points()[2].y(), content="1043")
  inspect(f.glyph().outline().points()[3].x(), content="137")
  inspect(f.glyph().outline().points()[3].y(), content="1043")
  inspect(f.glyph().outline().points()[4].x(), content="137")
  inspect(f.glyph().outline().points()[4].y(), content="1391")
  inspect(f.glyph().outline().points()[5].x(), content="137")
  inspect(f.glyph().outline().points()[5].y(), content="1536")
  inspect(f.glyph().outline().points()[6].x(), content="548")
  inspect(f.glyph().outline().points()[6].y(), content="1536")
  inspect(f.glyph().outline().points()[7].x(), content="548")
  inspect(f.glyph().outline().points()[7].y(), content="1400")
  inspect(f.glyph().metrics().hori_advance(), content="656")
}

///|
test "parity/Roboto[wdth,wght].ttf: glyph 7 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  let r = try? @freetype.load_glyph(f, 7U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="16")
  inspect(f.glyph().outline().n_contours(), content="4")
  inspect(f.glyph().outline().points()[0].x(), content="279")
  inspect(f.glyph().outline().points()[0].y(), content="0")
  inspect(f.glyph().outline().points()[1].x(), content="562")
  inspect(f.glyph().outline().points()[1].y(), content="1456")
  inspect(f.glyph().outline().points()[2].x(), content="706")
  inspect(f.glyph().outline().points()[2].y(), content="1456")
  inspect(f.glyph().outline().points()[3].x(), content="422")
  inspect(f.glyph().outline().points()[3].y(), content="0")
  inspect(f.glyph().outline().points()[4].x(), content="686")
  inspect(f.glyph().outline().points()[4].y(), content="0")
  inspect(f.glyph().outline().points()[5].x(), content="970")
  inspect(f.glyph().outline().points()[5].y(), content="1456")
  inspect(f.glyph().outline().points()[6].x(), content="1113")
  inspect(f.glyph().outline().points()[6].y(), content="1456")
  inspect(f.glyph().outline().points()[7].x(), content="829")
  inspect(f.glyph().outline().points()[7].y(), content="0")
  inspect(f.glyph().metrics().hori_advance(), content="1261")
}

///|
test "parity/Roboto[wdth,wght].ttf: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 5U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="256")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 NORMAL char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
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
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 NORMAL char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="11")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000003b91000000000000000000d6ff390000000000000027fffa9b0000000000000088d966f20a000000000003e57c10f85e00000000004bfe2100acc00000000000acc200004ffe2300000014ff9d38383dff9f0000006fffffffffffffff020000d0af040404043cff470032ff4e0000000000dba90093ec0500000000007ef812")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 NORMAL char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="10")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00002378947213000053fabd9be3e31400c29600001efe6d000000021920f4870020aef8ece4ff8801d4be1a0000e8881cff5f000004ff8807eec73333b8ff8f0048e8fffa92ceb90000031f07000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 LIGHT char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
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
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 LIGHT char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="11")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000003b91000000000000000000d6ff390000000000000027fffa9b0000000000000088d966f20a000000000003e57c10f85e00000000004bfe2100acc00000000000acc200004ffe2300000014ff9d38383dff9f0000006fffffffffffffff020000d0af040404043cff470032ff4e0000000000dba90093ec0500000000007ef812")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 LIGHT char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="10")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00002378947213000053fabd9be3e31400c29600001efe6d000000021920f4870020aef8ece4ff8801d4be1a0000e8881cff5f000004ff8807eec73333b8ff8f0048e8fffa92ceb90000031f07000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 MONO char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
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
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 MONO char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  inspect(f.glyph().bitmap().buffer().length(), content="22")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 MONO char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="7")
  inspect(f.glyph().bitmap().rows(), content="9")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="9")
  inspect(f.glyph().bitmap().buffer().length(), content="18")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 LCD char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
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
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 LCD char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="36")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="36")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="-1")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000113b7a9f91521b000000000000000000000000000000000000000000000000000000001c71d6ffffffff8d390200000000000000000000000000000000000000000000000000277bd2fffbfafafee99b470500000000000000000000000000000000000000000000003488dbffd9854466bafbf2a8500a0000000000000000000000000000000000000000033e96e5ffd07c2800105db5f8f8b25e11000000000000000000000000000000000000084b9feefecb73210000000b58acf4fbc06c18000000000000000000000000000000000c58acf4fdc26e190000000000094fa3f1fece76230000000000000000000000000000146ed9fffff19d4e383838383838383d7ed6ffffff9f390000000000000000000000001d6ffbffffffffffffffffffffffffffffffffffffffffbd3902000000000000000000257dd0fff6af5b0f0404040404040404040404053c90e5ffed9b4706000000000000013286ddfff1a24e0900000000000000000000000000002f87dbfff2a9550a00000000023f93e4ffec9e4605000000000000000000000000000000002a7ed2fff8b75f1200")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 LCD char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="27")
  inspect(f.glyph().bitmap().rows(), content="10")
  inspect(f.glyph().bitmap().pitch(), content="28")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000a2346657885909491847256311302000000000000000000001953a0dffaf5dbbda4999ba7c6e3fafde3a44f14000000000000002977c2e4d6964c0b0000000000011e71c7feffc16d1a0000000000000000000000000000020710191e20205daaf4ffdb87330000000000000003204d86aed0ebf8f9f4ece7e4e4ffffffffdc88340000000000013083d4faeebe7c3e1a0800000000003c94e8ffdc883400000000001c70c8ffffb35f0b000000000000000472fbffffe6883400000000000749a1eefff2c78950332726334e7fb8ffffffffe68f3b0000000000000018488ac4e8fafffffffffae8c3927298cefffdb9651000000000000000000000030c181f1d12070100000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 LCD_V char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
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
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 LCD_V char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="39")
  inspect(f.glyph().bitmap().pitch(), content="11")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000006110000000000000000003b9100000000000000000078ff080000000000000000bdff1c0000000000000000d6ff390000000000000002ebff59000000000000000ff8ff7b0000000000000027fffa9b0000000000000047fdbfbb0000000000000068ef8cdb0000000000000088d966f20a000000000000a8ba47fd1f000000000000ca9a27ff3e000000000003e57c10f85e000000000011f85d03e77e00000000002bff3d00caa000000000004bfe2100acc000000000006bf50c008ede01000000008de001006ef40d00000000acc200004ffe2300000000cca4000031ff4200000004e984000015fb6300000014ff9d38383dff9f0000002dffd38c8c8cffea0000004fffffe4e4e4ffff0000006fffffffffffffff0200008fffb3b0b0b0ffff0f0000b1ff58585858afff270000d0af040404043cff470005ea8d000000001cfd670016fb6d0000000008f1890032ff4e0000000000dba90052ff300000000000bdc90074fb1500000000009de60393ec0500000000007ef8126d980000000000004aab123b450000000000001f540e00000000000000000000000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 LCD_V char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="30")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000024401f00000000237894721300000471cce8c64e000020c9fdefffa3030053fabd9be3e3140090ef6947a7fc3200c0cd130055ff5600c29600001efe6d008152000006f87c00341d000000ef83000000021920f48700000f4f6d74ff8800045aa7c5ccff880020aef8ece4ff880054f2c59890ff88009eea6d4038fc8801d4be1a0000e88809f48a000000ed8814ff65000000ff881cff5f000004ff881bff6a000024ff8810fd95000069ff8a07eec73333b8ff8f00ccf08787ebff98008effdfdfdcf7a60048e8fffa92ceb9001698cbae3f82840000407356093c440000031f070000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: hinted outline DEFAULT 16ppem" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 5U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="16")
  inspect(f.glyph().metrics().width(), content="128")
  inspect(f.glyph().metrics().height(), content="768")
  inspect(f.glyph().metrics().hori_advance(), content="256")
}

///|
test "parity/Roboto[wdth,wght].ttf: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 5U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="264")
}

///|
test "parity/Roboto[wdth,wght].ttf: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 5U, load_flags=@base.LOAD_FORCE_AUTOHINT)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="320")
}

///|
test "parity/Roboto[wdth,wght].ttf: variation state" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  inspect(f.has_multiple_masters(), content="true")
  inspect(f.is_variation(), content="false")
  try! @freetype.set_var_design_coordinates(
    f,
    [
      (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
      (@fixed.Fixed::from_raw(4915200L), 0x77647468U),
    ],
  )
  inspect(f.is_variation(), content="true")
}

///|
test "parity/Roboto[wdth,wght].ttf: varied 65 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_var_design_coordinates(
    f,
    [
      (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
      (@fixed.Fixed::from_raw(4915200L), 0x77647468U),
    ],
  )
  let gid = @freetype.get_char_index(f, 65U)
  let r = try? @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(gid, content="37")
  inspect(f.glyph().outline().n_points(), content="14")
  inspect(f.glyph().outline().n_contours(), content="3")
  inspect(f.glyph().metrics().hori_advance(), content="1240")
  inspect(f.glyph().metrics().width(), content="1219")
  inspect(f.glyph().metrics().hori_bearing_x(), content="10")
  inspect(f.glyph().outline().points()[0].x(), content="649")
  inspect(f.glyph().outline().points()[0].y(), content="1150")
  inspect(f.glyph().outline().points()[1].x(), content="378")
  inspect(f.glyph().outline().points()[1].y(), content="0")
  inspect(f.glyph().outline().points()[2].x(), content="10")
  inspect(f.glyph().outline().points()[2].y(), content="0")
  inspect(f.glyph().outline().points()[3].x(), content="459")
  inspect(f.glyph().outline().points()[3].y(), content="1456")
}

///|
test "parity/Roboto[wdth,wght].ttf: varied 97 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_var_design_coordinates(
    f,
    [
      (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
      (@fixed.Fixed::from_raw(4915200L), 0x77647468U),
    ],
  )
  let gid = @freetype.get_char_index(f, 97U)
  let r = try? @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(gid, content="69")
  inspect(f.glyph().outline().n_points(), content="59")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().metrics().hori_advance(), content="955")
  inspect(f.glyph().metrics().width(), content="862")
  inspect(f.glyph().metrics().hori_bearing_x(), content="51")
  inspect(f.glyph().outline().points()[0].x(), content="541")
  inspect(f.glyph().outline().points()[0].y(), content="272")
  inspect(f.glyph().outline().points()[1].x(), content="541")
  inspect(f.glyph().outline().points()[1].y(), content="748")
  inspect(f.glyph().outline().points()[2].x(), content="541")
  inspect(f.glyph().outline().points()[2].y(), content="794")
  inspect(f.glyph().outline().points()[3].x(), content="527")
  inspect(f.glyph().outline().points()[3].y(), content="843")
}

///|
test "parity/Roboto[wdth,wght].ttf: varied outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_var_design_coordinates(
    f,
    [
      (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
      (@fixed.Fixed::from_raw(4915200L), 0x77647468U),
    ],
  )
  let gid = @freetype.get_char_index(f, 65U)
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="620")
  inspect(f.glyph().metrics().width(), content="610")
  inspect(f.glyph().metrics().height(), content="728")
  inspect(f.glyph().metrics().hori_bearing_x(), content="5")
  inspect(f.glyph().metrics().hori_bearing_y(), content="728")
  inspect(f.glyph().outline().points()[0].x(), content="325")
  inspect(f.glyph().outline().points()[0].y(), content="575")
}

///|
test "parity/Roboto[wdth,wght].ttf: varied hinted outline DEFAULT 16ppem" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_var_design_coordinates(
    f,
    [
      (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
      (@fixed.Fixed::from_raw(4915200L), 0x77647468U),
    ],
  )
  let gid = @freetype.get_char_index(f, 65U)
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, gid)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="640")
  inspect(f.glyph().metrics().width(), content="640")
  inspect(f.glyph().metrics().height(), content="768")
  inspect(f.glyph().metrics().hori_bearing_x(), content="0")
  inspect(f.glyph().metrics().hori_bearing_y(), content="768")
}

///|
test "parity/Roboto[wdth,wght].ttf: varied outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_var_design_coordinates(
    f,
    [
      (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
      (@fixed.Fixed::from_raw(4915200L), 0x77647468U),
    ],
  )
  let gid = @freetype.get_char_index(f, 65U)
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, gid, load_flags=@base.LOAD_FORCE_AUTOHINT)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="640")
}

