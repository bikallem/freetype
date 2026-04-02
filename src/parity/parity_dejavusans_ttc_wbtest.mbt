// Parity tests for DejaVuSans.ttc
// AUTO-GENERATED — do not edit

///|
fn load_generated_dejavusans_ttc() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/DejaVuSans.ttc")
}

///|
test "parity/DejaVuSans.ttc: format" {
  inspect(@base.detect_format(load_generated_dejavusans_ttc()), content="TrueTypeCollection")
}

///|
test "parity/DejaVuSans.ttc: loads" {
  inspect((try? @freetype.from_bytes(load_generated_dejavusans_ttc())) is Ok(_), content="true")
}

///|
test "parity/DejaVuSans.ttc: metadata" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  inspect(f.family_name(), content="DejaVu Sans")
  inspect(f.num_glyphs(), content="6253")
  inspect(f.units_per_em(), content="2048")
  inspect(f.ascender(), content="1901")
  inspect(f.descender(), content="-483")
  inspect(f.height(), content="2384")
  inspect(f.underline_position(), content="-175")
  inspect(f.underline_thickness(), content="90")
}

///|
test "parity/DejaVuSans.ttc: bbox" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  inspect(f.bbox().x_min(), content="-2090")
  inspect(f.bbox().y_min(), content="-948")
  inspect(f.bbox().x_max(), content="3673")
  inspect(f.bbox().y_max(), content="2524")
}

///|
test "parity/DejaVuSans.ttc: flags" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="true")
}

///|
test "parity/DejaVuSans.ttc: charmaps" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  inspect(f.charmaps().length(), content="5")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="0")
    inspect(f.charmaps()[0].encoding_id(), content="3")
  }
  if f.charmaps().length() > 1 {
    inspect(f.charmaps()[1].platform_id(), content="0")
    inspect(f.charmaps()[1].encoding_id(), content="10")
  }
  if f.charmaps().length() > 2 {
    inspect(f.charmaps()[2].platform_id(), content="1")
    inspect(f.charmaps()[2].encoding_id(), content="0")
  }
  if f.charmaps().length() > 3 {
    inspect(f.charmaps()[3].platform_id(), content="3")
    inspect(f.charmaps()[3].encoding_id(), content="1")
  }
  if f.charmaps().length() > 4 {
    inspect(f.charmaps()[4].platform_id(), content="3")
    inspect(f.charmaps()[4].encoding_id(), content="10")
  }
}

///|
test "parity/DejaVuSans.ttc: charmap entries" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  inspect(@freetype.get_char_index(f, 32U), content="3")
  inspect(@freetype.get_char_index(f, 33U), content="4")
  inspect(@freetype.get_char_index(f, 34U), content="5")
  inspect(@freetype.get_char_index(f, 35U), content="6")
  inspect(@freetype.get_char_index(f, 36U), content="7")
  inspect(@freetype.get_char_index(f, 37U), content="8")
  inspect(@freetype.get_char_index(f, 38U), content="9")
  inspect(@freetype.get_char_index(f, 39U), content="10")
  inspect(@freetype.get_char_index(f, 40U), content="11")
  inspect(@freetype.get_char_index(f, 41U), content="12")
  inspect(@freetype.get_char_index(f, 42U), content="13")
  inspect(@freetype.get_char_index(f, 43U), content="14")
  inspect(@freetype.get_char_index(f, 44U), content="15")
  inspect(@freetype.get_char_index(f, 45U), content="16")
  inspect(@freetype.get_char_index(f, 46U), content="17")
  inspect(@freetype.get_char_index(f, 47U), content="18")
  inspect(@freetype.get_char_index(f, 48U), content="19")
  inspect(@freetype.get_char_index(f, 49U), content="20")
  inspect(@freetype.get_char_index(f, 50U), content="21")
  inspect(@freetype.get_char_index(f, 51U), content="22")
  inspect(@freetype.get_char_index(f, 52U), content="23")
  inspect(@freetype.get_char_index(f, 53U), content="24")
  inspect(@freetype.get_char_index(f, 54U), content="25")
  inspect(@freetype.get_char_index(f, 55U), content="26")
  inspect(@freetype.get_char_index(f, 56U), content="27")
  inspect(@freetype.get_char_index(f, 57U), content="28")
  inspect(@freetype.get_char_index(f, 58U), content="29")
  inspect(@freetype.get_char_index(f, 59U), content="30")
  inspect(@freetype.get_char_index(f, 60U), content="31")
  inspect(@freetype.get_char_index(f, 61U), content="32")
  inspect(@freetype.get_char_index(f, 62U), content="33")
  inspect(@freetype.get_char_index(f, 63U), content="34")
  inspect(@freetype.get_char_index(f, 64U), content="35")
  inspect(@freetype.get_char_index(f, 65U), content="36")
  inspect(@freetype.get_char_index(f, 66U), content="37")
  inspect(@freetype.get_char_index(f, 67U), content="38")
  inspect(@freetype.get_char_index(f, 68U), content="39")
  inspect(@freetype.get_char_index(f, 69U), content="40")
  inspect(@freetype.get_char_index(f, 70U), content="41")
  inspect(@freetype.get_char_index(f, 71U), content="42")
  inspect(@freetype.get_char_index(f, 72U), content="43")
  inspect(@freetype.get_char_index(f, 73U), content="44")
  inspect(@freetype.get_char_index(f, 74U), content="45")
  inspect(@freetype.get_char_index(f, 75U), content="46")
  inspect(@freetype.get_char_index(f, 76U), content="47")
  inspect(@freetype.get_char_index(f, 77U), content="48")
  inspect(@freetype.get_char_index(f, 78U), content="49")
  inspect(@freetype.get_char_index(f, 79U), content="50")
  inspect(@freetype.get_char_index(f, 80U), content="51")
  inspect(@freetype.get_char_index(f, 81U), content="52")
  inspect(@freetype.get_char_index(f, 66304U), content="5373")
}

///|
test "parity/DejaVuSans.ttc: glyph 4 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  let r = try? @freetype.load_glyph(f, 4U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="10")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="309")
  inspect(f.glyph().outline().points()[0].y(), content="254")
  inspect(f.glyph().outline().points()[1].x(), content="512")
  inspect(f.glyph().outline().points()[1].y(), content="254")
  inspect(f.glyph().outline().points()[2].x(), content="512")
  inspect(f.glyph().outline().points()[2].y(), content="0")
  inspect(f.glyph().outline().points()[3].x(), content="309")
  inspect(f.glyph().outline().points()[3].y(), content="0")
  inspect(f.glyph().outline().points()[4].x(), content="309")
  inspect(f.glyph().outline().points()[4].y(), content="1493")
  inspect(f.glyph().outline().points()[5].x(), content="512")
  inspect(f.glyph().outline().points()[5].y(), content="1493")
  inspect(f.glyph().outline().points()[6].x(), content="512")
  inspect(f.glyph().outline().points()[6].y(), content="838")
  inspect(f.glyph().outline().points()[7].x(), content="492")
  inspect(f.glyph().outline().points()[7].y(), content="481")
  inspect(f.glyph().metrics().hori_advance(), content="821")
}

///|
test "parity/DejaVuSans.ttc: glyph 5 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  let r = try? @freetype.load_glyph(f, 5U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="8")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="367")
  inspect(f.glyph().outline().points()[0].y(), content="1493")
  inspect(f.glyph().outline().points()[1].x(), content="367")
  inspect(f.glyph().outline().points()[1].y(), content="938")
  inspect(f.glyph().outline().points()[2].x(), content="197")
  inspect(f.glyph().outline().points()[2].y(), content="938")
  inspect(f.glyph().outline().points()[3].x(), content="197")
  inspect(f.glyph().outline().points()[3].y(), content="1493")
  inspect(f.glyph().outline().points()[4].x(), content="745")
  inspect(f.glyph().outline().points()[4].y(), content="1493")
  inspect(f.glyph().outline().points()[5].x(), content="745")
  inspect(f.glyph().outline().points()[5].y(), content="938")
  inspect(f.glyph().outline().points()[6].x(), content="575")
  inspect(f.glyph().outline().points()[6].y(), content="938")
  inspect(f.glyph().outline().points()[7].x(), content="575")
  inspect(f.glyph().outline().points()[7].y(), content="1493")
  inspect(f.glyph().metrics().hori_advance(), content="942")
}

///|
test "parity/DejaVuSans.ttc: glyph 6 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  let r = try? @freetype.load_glyph(f, 6U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="32")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="1047")
  inspect(f.glyph().outline().points()[0].y(), content="901")
  inspect(f.glyph().outline().points()[1].x(), content="756")
  inspect(f.glyph().outline().points()[1].y(), content="901")
  inspect(f.glyph().outline().points()[2].x(), content="672")
  inspect(f.glyph().outline().points()[2].y(), content="567")
  inspect(f.glyph().outline().points()[3].x(), content="965")
  inspect(f.glyph().outline().points()[3].y(), content="567")
  inspect(f.glyph().outline().points()[4].x(), content="897")
  inspect(f.glyph().outline().points()[4].y(), content="1470")
  inspect(f.glyph().outline().points()[5].x(), content="793")
  inspect(f.glyph().outline().points()[5].y(), content="1055")
  inspect(f.glyph().outline().points()[6].x(), content="1085")
  inspect(f.glyph().outline().points()[6].y(), content="1055")
  inspect(f.glyph().outline().points()[7].x(), content="1190")
  inspect(f.glyph().outline().points()[7].y(), content="1470")
  inspect(f.glyph().metrics().hori_advance(), content="1716")
}

///|
test "parity/DejaVuSans.ttc: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 4U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="384")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 3 NORMAL NO_HINTING char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
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
test "parity/DejaVuSans.ttc: rendered glyph 36 NORMAL NO_HINTING char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000005eac560000000000000001ddfed10000000000000040ff8cff33000000000000a2de06ea9400000000000ef5810090ee070000000065ff230030ff5700000000c7c3000000d1b800000029ff9f505050a8fd1c00008affffffffffffff7b0004e7ae0000000000b7db004eff5300000000005cff3daff10800000000000cf59f")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 68 NORMAL NO_HINTING char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="10")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00299fd9f0d58b0c0000599e5f4871e9bf000000000000004aff2b0000125e7c8894ff530047f5d7a599a0ff5c00d8af0000002aff5c01fb7400000071ff5c00d0d3250a57e7ff5c0037e3ffffe450ff5c0000062c2c03000000")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 3 LIGHT NO_HINTING char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
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
test "parity/DejaVuSans.ttc: rendered glyph 36 LIGHT NO_HINTING char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000005eac560000000000000001ddfed10000000000000040ff8cff33000000000000a2de06ea9400000000000ef5810090ee070000000065ff230030ff5700000000c7c3000000d1b800000029ff9f505050a8fd1c00008affffffffffffff7b0004e7ae0000000000b7db004eff5300000000005cff3daff10800000000000cf59f")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 68 LIGHT NO_HINTING char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="10")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00299fd9f0d58b0c0000599e5f4871e9bf000000000000004aff2b0000125e7c8894ff530047f5d7a599a0ff5c00d8af0000002aff5c01fb7400000071ff5c00d0d3250a57e7ff5c0037e3ffffe450ff5c0000062c2c03000000")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 3 MONO NO_HINTING char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
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
test "parity/DejaVuSans.ttc: rendered glyph 36 MONO NO_HINTING char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  inspect(f.glyph().bitmap().buffer().length(), content="24")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 68 MONO NO_HINTING char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
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
test "parity/DejaVuSans.ttc: rendered glyph 3 LCD NO_HINTING char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
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
test "parity/DejaVuSans.ttc: rendered glyph 36 LCD NO_HINTING char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="39")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="40")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="-1")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000265e97acacac8e561d000000000000000000000000000000000000000000000000000000000001338bddfffefefeffd17d26000000000000000000000000000000000000000000000000000000044094e7ffe69b8ca5f1ffdd873301000000000000000000000000000000000000000000000000074ea2eeffde8b3306439beaffe5944003000000000000000000000000000000000000000000000e58b0f5ffd5812d0000023c90e1ffeea1490700000000000000000000000000000000000000001665b9faffce762300000000003084dbfff5ab570d0000000000000000000000000000000000001d73c7fdfdc36f1a00000000000000257dd1fff9b8641300000000000000000000000000000000297dd4ffffd99f665050505050505050506ea8e2fffdc56d1c0000000000000000000000000001368addffffffffffffffffffffffffffffffffffffffffffcf7b270000000000000000000000044098e7fff5ae5a0c000000000000000000000000001163b7f9ffdb8830000000000000000000094ea2f0fff4a7530b0000000000000000000000000000000f5cb0f8ffe6913d030000000000000d5baff5fff1a54d0800000000000000000000000000000000000c55adf5ffec9f4b06000000")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 68 LCD NO_HINTING char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000052955869fb8ccd9e3ecf0ece1d5c7b08b5b290c00000000000000000f5998c09e826c5f544a484d5a7193c5e9fef3bf6b1f0000000000000000000000000000000000000000000b4a9eebffd77f2b000000000000000003122e4b5e69737c838788888894bbe4fffda7530100000000124791d5f5fbedd7bfafa59f9a999898a0c2e6ffffb05c080000002c84d8ffedaf5b160000000000000000002a7ed6ffffb05c0800000150a8fbffc874200000000000000000002271c5fbffffb05c08000000267cd0fdfad3964d250e060a17305790cde7f4f5ffffb05c08000000000b3775bce3fafffffffffffff9e4bb7b5079c0ffffb05c08000000000000000006101f2c33332c1e0e030000000000000000000000")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 3 LCD_V NO_HINTING char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
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
test "parity/DejaVuSans.ttc: rendered glyph 36 LCD_V NO_HINTING char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000002a582600000000000000005eac5600000000000000009dff900000000000000000bfffb10000000000000001ddfed1000000000000000bf3edeb0600000000000021fec6fb1700000000000040ff8cff3300000000000061fe4fff5200000000000082f31ffa74000000000000a2de06ea94000000000000c2c000d0b4000000000002e1a000afd500000000000ef5810090ee070000000024ff620070fc190000000045ff410050ff370000000065ff230030ff570000000086f50d0016fb7600000000a7e1010005eb9800000000c7c3000000d1b800000002e4a4000000b2d700000010f78400000091f009000029ff9f505050a8fd1c000049ffc8a4a4a4ccff3900006afffdfcfcfcfdff5b00008affffffffffffff7b0000abefacacacacacf29a0000ccd35454545454d9bc0004e7ae0000000000b7db0012f990000000000099f10a2dff7100000000007afe1f4eff5300000000005cff3d6eff3500000000003eff5d8ffd19000000000020fe7faff10800000000000cf59f809d00000000000001a1754447000000000000004a3f00000000000000000000000000000000000000000000")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 68 LCD_V NO_HINTING char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="33")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="10")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000042d442904000000084b859c8139000000299fd9f0d58b0c00004aeffff4ffda38000064ecb39cc5fe7d0000599e5f4871e9bf0000384a0b001dbce70700160600000079fb160000000000004aff2b0000000000002dff3e0000000c28344eff4b0000125e7c8894ff5300025bb2d0dcdeff58001ab3fef8ededff5b0047f5d7a599a0ff5c0085f884514555ff5c00b8d82c00001eff5c00d8af0000002aff5c00e98700000037ff5c01f7760000004fff5c01fb7400000071ff5c01f583000000a1ff5c00e8a8000015d2ff5c00d0d3250a57e7ff5c00aaf3795eabd3ff5c0070ffd0b6ed92ff5c0037e3ffffe450ff5c001096d8d8931dac3d00003e80803c06541e0000062c2c03000000000000000000000000")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 3 NORMAL DEFAULT char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 36 NORMAL DEFAULT char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 68 NORMAL DEFAULT char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 3 LIGHT DEFAULT char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 36 LIGHT DEFAULT char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 68 LIGHT DEFAULT char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 3 MONO DEFAULT char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 36 MONO DEFAULT char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 68 MONO DEFAULT char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 3 LCD DEFAULT char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 36 LCD DEFAULT char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 68 LCD DEFAULT char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 3 LCD_V DEFAULT char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 36 LCD_V DEFAULT char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/DejaVuSans.ttc: rendered glyph 68 LCD_V DEFAULT char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/DejaVuSans.ttc: multi-face" {
  let f0 = @freetype.from_bytes(load_generated_dejavusans_ttc(), face_index=0)
  inspect(f0.num_glyphs() > 0L, content="true")
  let f1 = @freetype.from_bytes(load_generated_dejavusans_ttc(), face_index=1)
  inspect(f1.num_glyphs() > 0L, content="true")
}

///|
test "parity/DejaVuSans.ttc: kerning" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  inspect(@freetype.get_kerning(f, 36U, 36U).0, content="57")
  inspect(@freetype.get_kerning(f, 36U, 38U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 42U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 50U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 52U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 55U).0, content="-159")
  inspect(@freetype.get_kerning(f, 36U, 57U).0, content="-131")
  inspect(@freetype.get_kerning(f, 36U, 58U).0, content="-112")
  inspect(@freetype.get_kerning(f, 36U, 60U).0, content="-159")
  inspect(@freetype.get_kerning(f, 36U, 70U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 71U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 72U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 73U).0, content="-73")
  inspect(@freetype.get_kerning(f, 36U, 82U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 84U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 87U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 89U).0, content="-120")
  inspect(@freetype.get_kerning(f, 36U, 90U).0, content="-83")
  inspect(@freetype.get_kerning(f, 36U, 92U).0, content="-139")
  inspect(@freetype.get_kerning(f, 37U, 38U).0, content="-36")
}

///|
test "parity/DejaVuSans.ttc: hinted outline DEFAULT 16ppem" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 4U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="10")
  inspect(f.glyph().metrics().width(), content="128")
  inspect(f.glyph().metrics().height(), content="768")
  inspect(f.glyph().metrics().hori_advance(), content="384")
}

///|
test "parity/DejaVuSans.ttc: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 4U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="411")
}

///|
test "parity/DejaVuSans.ttc: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_dejavusans_ttc())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 4U, load_flags=@base.LOAD_FORCE_AUTOHINT)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="384")
}

