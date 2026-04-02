// Parity tests for NimbusSans-Regular.pfb
// AUTO-GENERATED — do not edit

///|
fn load_generated_nimbussans_regular_pfb() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/NimbusSans-Regular.pfb")
}

///|
test "parity/NimbusSans-Regular.pfb: format" {
  inspect(@base.detect_format(load_generated_nimbussans_regular_pfb()), content="Type1Pfa")
}

///|
test "parity/NimbusSans-Regular.pfb: loads" {
  inspect((try? @freetype.from_bytes(load_generated_nimbussans_regular_pfb())) is Ok(_), content="true")
}

///|
test "parity/NimbusSans-Regular.pfb: metadata" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  inspect(f.family_name(), content="Nimbus Sans")
  inspect(f.num_glyphs(), content="855")
  inspect(f.units_per_em(), content="1000")
  inspect(f.ascender(), content="1075")
  inspect(f.descender(), content="-299")
  inspect(f.height(), content="1374")
  inspect(f.underline_position(), content="-151")
  inspect(f.underline_thickness(), content="50")
}

///|
test "parity/NimbusSans-Regular.pfb: bbox" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  inspect(f.bbox().x_min(), content="-210")
  inspect(f.bbox().y_min(), content="-299")
  inspect(f.bbox().x_max(), content="1032")
  inspect(f.bbox().y_max(), content="1075")
}

///|
test "parity/NimbusSans-Regular.pfb: flags" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="false")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/NimbusSans-Regular.pfb: charmaps" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  inspect(f.charmaps().length(), content="2")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="3")
    inspect(f.charmaps()[0].encoding_id(), content="1")
  }
  if f.charmaps().length() > 1 {
    inspect(f.charmaps()[1].platform_id(), content="7")
    inspect(f.charmaps()[1].encoding_id(), content="0")
  }
}

///|
test "parity/NimbusSans-Regular.pfb: charmap entries" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  inspect(@freetype.get_char_index(f, 32U), content="381")
  inspect(@freetype.get_char_index(f, 33U), content="274")
  inspect(@freetype.get_char_index(f, 34U), content="298")
  inspect(@freetype.get_char_index(f, 35U), content="300")
  inspect(@freetype.get_char_index(f, 36U), content="244")
  inspect(@freetype.get_char_index(f, 37U), content="328")
  inspect(@freetype.get_char_index(f, 38U), content="292")
  inspect(@freetype.get_char_index(f, 39U), content="297")
  inspect(@freetype.get_char_index(f, 40U), content="288")
  inspect(@freetype.get_char_index(f, 41U), content="289")
  inspect(@freetype.get_char_index(f, 42U), content="296")
  inspect(@freetype.get_char_index(f, 43U), content="302")
  inspect(@freetype.get_char_index(f, 44U), content="268")
  inspect(@freetype.get_char_index(f, 45U), content="283")
  inspect(@freetype.get_char_index(f, 46U), content="262")
  inspect(@freetype.get_char_index(f, 47U), content="282")
  inspect(@freetype.get_char_index(f, 48U), content="242")
  inspect(@freetype.get_char_index(f, 49U), content="233")
  inspect(@freetype.get_char_index(f, 50U), content="234")
  inspect(@freetype.get_char_index(f, 51U), content="235")
  inspect(@freetype.get_char_index(f, 52U), content="236")
  inspect(@freetype.get_char_index(f, 53U), content="237")
  inspect(@freetype.get_char_index(f, 54U), content="238")
  inspect(@freetype.get_char_index(f, 55U), content="239")
  inspect(@freetype.get_char_index(f, 56U), content="240")
  inspect(@freetype.get_char_index(f, 57U), content="241")
  inspect(@freetype.get_char_index(f, 58U), content="263")
  inspect(@freetype.get_char_index(f, 59U), content="269")
  inspect(@freetype.get_char_index(f, 60U), content="430")
  inspect(@freetype.get_char_index(f, 61U), content="306")
  inspect(@freetype.get_char_index(f, 62U), content="431")
  inspect(@freetype.get_char_index(f, 63U), content="276")
  inspect(@freetype.get_char_index(f, 64U), content="299")
  inspect(@freetype.get_char_index(f, 65U), content="854")
  inspect(@freetype.get_char_index(f, 66U), content="1")
  inspect(@freetype.get_char_index(f, 67U), content="2")
  inspect(@freetype.get_char_index(f, 68U), content="3")
  inspect(@freetype.get_char_index(f, 69U), content="4")
  inspect(@freetype.get_char_index(f, 70U), content="5")
  inspect(@freetype.get_char_index(f, 71U), content="6")
  inspect(@freetype.get_char_index(f, 72U), content="7")
  inspect(@freetype.get_char_index(f, 73U), content="8")
  inspect(@freetype.get_char_index(f, 74U), content="9")
  inspect(@freetype.get_char_index(f, 75U), content="10")
  inspect(@freetype.get_char_index(f, 76U), content="11")
  inspect(@freetype.get_char_index(f, 77U), content="12")
  inspect(@freetype.get_char_index(f, 78U), content="13")
  inspect(@freetype.get_char_index(f, 79U), content="14")
  inspect(@freetype.get_char_index(f, 80U), content="15")
  inspect(@freetype.get_char_index(f, 81U), content="16")
}

///|
test "parity/NimbusSans-Regular.pfb: glyph 274 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  let r = try? @freetype.load_glyph(f, 274U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="10")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="208")
  inspect(f.glyph().outline().points()[0].y(), content="729")
  inspect(f.glyph().outline().points()[1].x(), content="125")
  inspect(f.glyph().outline().points()[1].y(), content="729")
  inspect(f.glyph().outline().points()[2].x(), content="125")
  inspect(f.glyph().outline().points()[2].y(), content="391")
  inspect(f.glyph().outline().points()[3].x(), content="147")
  inspect(f.glyph().outline().points()[3].y(), content="168")
  inspect(f.glyph().outline().points()[4].x(), content="186")
  inspect(f.glyph().outline().points()[4].y(), content="168")
  inspect(f.glyph().outline().points()[5].x(), content="208")
  inspect(f.glyph().outline().points()[5].y(), content="391")
  inspect(f.glyph().outline().points()[6].x(), content="208")
  inspect(f.glyph().outline().points()[6].y(), content="104")
  inspect(f.glyph().outline().points()[7].x(), content="124")
  inspect(f.glyph().outline().points()[7].y(), content="104")
  inspect(f.glyph().metrics().hori_advance(), content="278")
}

///|
test "parity/NimbusSans-Regular.pfb: glyph 298 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  let r = try? @freetype.load_glyph(f, 298U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="12")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="52")
  inspect(f.glyph().outline().points()[0].y(), content="709")
  inspect(f.glyph().outline().points()[1].x(), content="52")
  inspect(f.glyph().outline().points()[1].y(), content="598")
  inspect(f.glyph().outline().points()[2].x(), content="79")
  inspect(f.glyph().outline().points()[2].y(), content="464")
  inspect(f.glyph().outline().points()[3].x(), content="118")
  inspect(f.glyph().outline().points()[3].y(), content="464")
  inspect(f.glyph().outline().points()[4].x(), content="145")
  inspect(f.glyph().outline().points()[4].y(), content="598")
  inspect(f.glyph().outline().points()[5].x(), content="145")
  inspect(f.glyph().outline().points()[5].y(), content="709")
  inspect(f.glyph().outline().points()[6].x(), content="212")
  inspect(f.glyph().outline().points()[6].y(), content="709")
  inspect(f.glyph().outline().points()[7].x(), content="212")
  inspect(f.glyph().outline().points()[7].y(), content="598")
  inspect(f.glyph().metrics().hori_advance(), content="355")
}

///|
test "parity/NimbusSans-Regular.pfb: glyph 300 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  let r = try? @freetype.load_glyph(f, 300U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="32")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="485")
  inspect(f.glyph().outline().points()[0].y(), content="697")
  inspect(f.glyph().outline().points()[1].x(), content="408")
  inspect(f.glyph().outline().points()[1].y(), content="697")
  inspect(f.glyph().outline().points()[2].x(), content="373")
  inspect(f.glyph().outline().points()[2].y(), content="501")
  inspect(f.glyph().outline().points()[3].x(), content="248")
  inspect(f.glyph().outline().points()[3].y(), content="501")
  inspect(f.glyph().outline().points()[4].x(), content="284")
  inspect(f.glyph().outline().points()[4].y(), content="697")
  inspect(f.glyph().outline().points()[5].x(), content="208")
  inspect(f.glyph().outline().points()[5].y(), content="697")
  inspect(f.glyph().outline().points()[6].x(), content="172")
  inspect(f.glyph().outline().points()[6].y(), content="501")
  inspect(f.glyph().outline().points()[7].x(), content="51")
  inspect(f.glyph().outline().points()[7].y(), content="501")
  inspect(f.glyph().metrics().hori_advance(), content="556")
}

///|
test "parity/NimbusSans-Regular.pfb: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 274U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="256")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 NORMAL NO_HINTING char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="381")
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 NORMAL NO_HINTING char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000072a74f0000000000000008f1ffc30000000000000055ff9bfe1e000000000000b1ce1bfe76000000000012fa7100c2d0000000000068fc19006bff2b00000000c4b8000018fd8400000020fedfbfbfbff7de0000007bfd837f7f7fabff380000d7bc0000000017fc920032ff620000000000bce9038ef810000000000064ff46")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 NORMAL NO_HINTING char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000337a977e270000006afcd4ade3f8310000ddae00000dec800000160900000de78b00000975aed1f6fa8b0003cedb724115c78b0038ff28000000d28b0036ff60000273ff930001aeffe0eeaaa3f76f0000385428000b4d26")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 LIGHT NO_HINTING char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="381")
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 LIGHT NO_HINTING char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000072a74f0000000000000008f1ffc30000000000000055ff9bfe1e000000000000b1ce1bfe76000000000012fa7100c2d0000000000068fc19006bff2b00000000c4b8000018fd8400000020fedfbfbfbff7de0000007bfd837f7f7fabff380000d7bc0000000017fc920032ff620000000000bce9038ef810000000000064ff46")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 LIGHT NO_HINTING char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000337a977e270000006afcd4ade3f8310000ddae00000dec800000160900000de78b00000975aed1f6fa8b0003cedb724115c78b0038ff28000000d28b0036ff60000273ff930001aeffe0eeaaa3f76f0000385428000b4d26")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 MONO NO_HINTING char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="381")
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 MONO NO_HINTING char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  inspect(f.glyph().bitmap().buffer().length(), content="24")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 MONO NO_HINTING char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="9")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="9")
  inspect(f.glyph().bitmap().buffer().length(), content="18")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 LCD NO_HINTING char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="381")
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 LCD NO_HINTING char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000053b72a3a7a7a7864f1800000000000000000000000000000000000000000000000000084ea6f1fffffffffdc36f1a00000000000000000000000000000000000000000000000c55a9f5ffd79c9bc4fefec8701e0000000000000000000000000000000000000000000e5db1f7ffce7a231b6dc5feffca7623000000000000000000000000000000000000001261b9fafec5711f0000196ec2fdffd07c2500000000000000000000000000000000001868bcfcfcc1691900000000196bbffdffd77e2b0000000000000000000000000000001a70c4fdfab864130000000000001869c1fdffd88430000000000000000000000000002073cbfefff4dfcabfbfbfbfbfbfbfbfcce2f7ffffde8a320000000000000000000000277bcffffdd6aa837f7f7f7f7f7f7f7f7f7f83abd5fdffe38c380100000000000000002a83d7fffbbc68150000000000000000000000001768c0fcffe4923e020000000000003286ddfffbb6621400000000000000000000000000001468bcfbffe9984003000000013a8ee0fff8b45c10000000000000000000000000000000001464b8fbffed9a4605")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 LCD NO_HINTING char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000011333556d7a87939793897e6a4a270e01000000000000000001286abaebfcf8e9d4bfaeadb9cde3f4fef8d17e31040000000000003189ddfff1ae5a110000000000000d4da5ecffd4802c000000000000060e1617110902000000000000010d489fe7ffdf8b370000000000000000092750758c9faebac5d1ddecf6f6f8faffdf8b37000000000003337ecef2f5dbb48d725f4e413526152474c7ffdf8b370000000000388ce4ffd47c28000000000000000000267ed2ffdf8b370000000000368ae2fff3af60180400000002143a73b4e7ffffe7933f0000000000011e60aee4fbfffcf0e0d9e0eef0d9aa7274a3e4fff7e5bb6f2e0000000000000b20384953544b3a2815070000000b1e3b4d5243260e00")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 LCD_V NO_HINTING char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="381")
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 LCD_V NO_HINTING char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000345322000000000000000072a74f0000000000000000bafb850000000000000000dbffa50000000000000008f1ffc3000000000000001afdf2e00100000000000037ffcff40b00000000000055ff9bfe1e00000000000073fa66ff3a00000000000093e939ff59000000000000b1ce1bfe76000000000000cfb009f394000000000004ea9000deb3000000000012fa7100c2d000000000002aff5300a6ea04000000004aff330088fa130000000068fc19006bff2b0000000086ef07004fff4800000000a6d7000031ff6700000000c4b8000018fd8400000001e0a613131bf4a20000000cf5be6b6b6cf4c000000020fedfbfbfbff7de0000003dfffffffffffff20900005dffd6d3d3d3e5fe1d00007bfd837f7f7fabff38000099f12f2b2b2b67ff550000b9db0000000030ff740000d7bc0000000017fc920006ee9f0000000007f0af0018fc800000000000d8ce0032ff620000000000bce90350ff4400000000009ff91070ff26000000000080ff298ef810000000000064ff4669a403000000000039ab39384c00000000000017532100000000000000000000000000000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 LCD_V NO_HINTING char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="30")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000326432a0000000000337a977e270000000984ceebd27400000032d8fffbffcb1100006afcd4ade3f8310000a5f280599bff560000c8d7280444fc720000ddae00000dec800000af71000000da8900006335000000d78b0000160900000de78b00000000062559f88b000000225a7db1ff8b00000975aed1f6fa8b000035c9fcedbfe78b000084fdc69567d48b0003cedb724115c78b000ff79d1e0000c78b0022ff52000000ca8b0038ff28000000d28b0044ff22000006e48b0043ff35000028f58c0036ff60000273ff930020fba43445c0f7b10f0de4dd8c9ddfd2d84001aeffe0eeaaa3f76f005ee4fcd45563f687001e8ca87c1430a1550000385428000b4d26000000030000000200")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 NORMAL DEFAULT char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="381")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 NORMAL DEFAULT char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 NORMAL DEFAULT char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 LIGHT DEFAULT char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="381")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 LIGHT DEFAULT char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 LIGHT DEFAULT char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 MONO DEFAULT char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="381")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 MONO DEFAULT char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 MONO DEFAULT char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 LCD DEFAULT char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="381")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 LCD DEFAULT char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 LCD DEFAULT char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 LCD_V DEFAULT char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="381")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 LCD_V DEFAULT char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 LCD_V DEFAULT char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NimbusSans-Regular.pfb: hinted outline DEFAULT 16ppem" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 274U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="10")
  inspect(f.glyph().metrics().width(), content="192")
  inspect(f.glyph().metrics().height(), content="768")
  inspect(f.glyph().metrics().hori_advance(), content="256")
}

///|
test "parity/NimbusSans-Regular.pfb: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 274U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="285")
}

///|
test "parity/NimbusSans-Regular.pfb: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 274U, load_flags=@base.LOAD_FORCE_AUTOHINT)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="256")
}

