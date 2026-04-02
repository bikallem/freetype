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
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 NORMAL NO_HINTING 16ppem char 32" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 NORMAL NO_HINTING 16ppem char 65" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 NORMAL NO_HINTING 16ppem char 97" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 NORMAL NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="10")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00001c8fc0d3b86904000026f2d67d6f9bf7b70100a8db0a00000047ff5500d4b50000000000b96300b2fa510200000000000029e0ffe9a4601a00000000054c94d9fffca50c000000000000228afe9823b7280000000000aae112fd760000000000b3c4009df66d13000d72fe65000387fefff7fff37f000000000b37563c0f0000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 NORMAL NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00002d7f7e283546004bf7c6b3e9b8b304df9600004cffb33dff22000000d9b360fc02000000b4b35dfe06000000b8b338ff35000004e6b301cbbe0c0281fdb3002bdff9f1b4b3ab010b0d473702c6900bf97600002afc3d0074f9c4b1f29c0000002b6967350000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 NORMAL NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="12")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="12")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000002786b7cc9d5e010000000068f6dc9a85b7fcbc1900003fff97070000003de8b70000d2d102000000000059ff4d1cff5f00000000000001e39645ff3400000000000000b9c057ff2300000000000000a9d230ff4700000000000000cea909fa8d0000000014001af77c008bf826000000cc9fa9ec13000ddcee5d15004dfcff6e0000000ea1fefff8ffe0c2e435000000000d3c553603028c56")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 NORMAL NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="11")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000d45390100000000000030e8e6f9bf050000000000b9b2021df9540000000000c9870004eb6a00000000006fed2796ed1a000000000002d0fccb290000000000079eeee5b3020b570c0000a9db1e33f7853cfd0a0015ff5f00005dffcfbf00001cff4300000099ff62000000dfc7160145e9f0e31600003eeafcf1fd9517dfc20500000e46531f0000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 NORMAL NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00001b66804d0400000047f0dab8f3b70a000ce7a4030021ec710040ff2900000088d60057ff1900000072fc022bff5d000000beff1500abf37e62b6efff19000681cfd58d6cfe0400000000000081e8000aa343000000d0990000c9d51f057bfc3200002ce4fef4f751000000000c47440a000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 LIGHT NO_HINTING 16ppem char 32" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 LIGHT NO_HINTING 16ppem char 65" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 LIGHT NO_HINTING 16ppem char 97" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 LIGHT NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="10")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00001c8fc0d3b86904000026f2d67d6f9bf7b70100a8db0a00000047ff5500d4b50000000000b96300b2fa510200000000000029e0ffe9a4601a00000000054c94d9fffca50c000000000000228afe9823b7280000000000aae112fd760000000000b3c4009df66d13000d72fe65000387fefff7fff37f000000000b37563c0f0000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 LIGHT NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00002d7f7e283546004bf7c6b3e9b8b304df9600004cffb33dff22000000d9b360fc02000000b4b35dfe06000000b8b338ff35000004e6b301cbbe0c0281fdb3002bdff9f1b4b3ab010b0d473702c6900bf97600002afc3d0074f9c4b1f29c0000002b6967350000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 LIGHT NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="12")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="12")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000002786b7cc9d5e010000000068f6dc9a85b7fcbc1900003fff97070000003de8b70000d2d102000000000059ff4d1cff5f00000000000001e39645ff3400000000000000b9c057ff2300000000000000a9d230ff4700000000000000cea909fa8d0000000014001af77c008bf826000000cc9fa9ec13000ddcee5d15004dfcff6e0000000ea1fefff8ffe0c2e435000000000d3c553603028c56")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 LIGHT NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="11")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000d45390100000000000030e8e6f9bf050000000000b9b2021df9540000000000c9870004eb6a00000000006fed2796ed1a000000000002d0fccb290000000000079eeee5b3020b570c0000a9db1e33f7853cfd0a0015ff5f00005dffcfbf00001cff4300000099ff62000000dfc7160145e9f0e31600003eeafcf1fd9517dfc20500000e46531f0000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 LIGHT NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00001b66804d0400000047f0dab8f3b70a000ce7a4030021ec710040ff2900000088d60057ff1900000072fc022bff5d000000beff1500abf37e62b6efff19000681cfd58d6cfe0400000000000081e8000aa343000000d0990000c9d51f057bfc3200002ce4fef4f751000000000c47440a000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 MONO NO_HINTING 16ppem char 32" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 MONO NO_HINTING 16ppem char 65" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 MONO NO_HINTING 16ppem char 97" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 MONO NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  inspect(f.glyph().bitmap().buffer().length(), content="24")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 MONO NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="7")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="9")
  inspect(f.glyph().bitmap().buffer().length(), content="24")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 MONO NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  inspect(f.glyph().bitmap().buffer().length(), content="26")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 MONO NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="11")
  inspect(f.glyph().bitmap().buffer().length(), content="22")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 MONO NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="7")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  inspect(f.glyph().bitmap().buffer().length(), content="24")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 LCD NO_HINTING 16ppem char 32" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 LCD NO_HINTING 16ppem char 65" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 LCD NO_HINTING 16ppem char 97" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 LCD NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="33")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="36")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000061c3f6c8fa6b4c0cbd3d3cdc4b8a488693f1a040000000000000000000000000003266dc0f2fff1d6b1917d716c6f77859bbce1f7feebb76621010000000000000000000554a8f6ffdb91390a0000000000000000000010479be2fff5a9550c00000000000000002880d4fffcb5610c00000000000000000000000000367ab9c3a3632200000000000000000e5eb2f7fffad29451290e0200000000000000000000000000000000000000000000000000052964b0e0f9fffffff8e9d3bba48e76604a321a090000000000000000000000000000000000000005152f4c657d94aac2d9edfafffffffceed2a56b2f0c000000000000000000000000000000000000000000000000020e223d618abfe9feffe3984408000000000000235f9eb7a465280000000000000000000000000000000956aaf4ffe18d350000000000001263bbfdfdc9762400000000000000000000000000000c5fb3faffc47019000000000000000c4b9de4fdf6d9a66d41231309020000040d214072b0e5fef1b965200000000000000000000003194887c3ecfefffffffef9f7f9fdfffffff3dab37f44140000000000000000000000000000000000030b19283746535651463c311f0f02000000000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 LCD NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="27")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="28")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000112d506b7f8e8d7e694b280d14355563462503000000000000174b97d7f7f6e1c6b1abb3cbe6e9c4a9b8e4ffb35f0700000000043890dfffda96420f0000000000144ca0e3ffffffb35f07000000003d91e9ffce76220000000000000000002d85d9ffffb35f070000000c60b4fffcaa52020000000000000000000860b4ffffb35f070000000a5db1fffeb058060000000000000000000c64b8ffffb35f0700000000388ce4ffdf89350100000000000000043e96e6ffffb35f0700000000012578cbfaeebe752f0c010002103a81c4f1fdffffb35f07000000000000082b64aedffafff9efeaf1fae7b46a7fb3fefeab57000000000001050a0b0a070d1c33474f4a37200d021a72c6ffe4903c00000000000b59b1f9fcca7626000000000000072a7bcbfce4913d06000000000000073074c0eff9efdbc4b2acb1c2dcf2f4d49c531b000000000000000000000001112b485d69717067594a351c07000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 LCD NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="39")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="40")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000a274e728696a7b7c7cfccbead9d8c7b5e361201000000000000000000000000000000000c3168a4d8f6fff1dcc1ac9a89818593a5b7d1eafcfce5bc8444190100000000000000000000093f92e0fff5d09754220700000000000000000001153d78bce8fff2b7631900000000000000002a7fd2fcfcd17f2b02000000000000000000000000000000001559adf0ffeba14d0e00000000001c70c8fffeb35f0d00000000000000000000000000000000000000013890e3ffea964200000000004599f0ffe088340000000000000000000000000000000000000000000d65b9ffffc06c140000000557abfdffcf77230000000000000000000000000000000000000000000255a9faffd27e26000000003084dcfff39b47000000000000000000000000000000000000000000227acefff9a95504000000000957affaffdc8d390400000000000000000000000614140e0000001a66bef7ffd07c2800000000000006398bd9fef8c572260500000000000000002479ccf3d69f6772a9e9ffecaa52130000000000000000000d4495dcf9ffeec98e5d3b251508010004184d9addfcfffffffcc36e1e00000000000000000000000000000e2f66a1d2f2fefffffffbf8f8fcfffffff6e0c0b0c2e4f9e4b570350f00000000000000000000000000000000030d1b2c3c4b55554c413624110300000219498cb09a561b00000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 LCD NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="33")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="36")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000010d2037454c4739230f0100000000000000000000000000000000000000000000073070bde8fbf6e6e0e9f9fdeabf722d050000000000000000000000000000000000001065b9fcf5b261140200041d6bbef9f9a8540700000000000000000000000000000000001d75c9ffdb87330000000004449cebffbe6a16000000000000000000000000000000000000246fc3f7edb66127225296d1f6edb35c1a000000000000000000000000000000000000000002297fd0fdfcfcfbedcb975a29090000000000000000000000000000000000000007285f9ed0f0eed6d5e5feeab3611f0200000b28465747290c0000000000000000001355a9e9fadba1521e0509337ecdf7f8cf85380b3c90e7fdb35b0a00000000000000001568c0fff9b35f110000000000011e5db0eaffe7cecfe7f9bf6b1a0000000000000000001c70c8ffed97430100000000000000000d4599dffffffcb662120000000000000000000000358cdffff4c7863d160300010a1e457cbfe9fbf0f0f3fee3a54f16000000000000000000000e3e7fc5eafcfffcf3eef1fafffdefcb95531f17499edffdf2c2742a0500000000000000000000010e21374652565348361f0b000000000000000000000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 LCD NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="27")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="28")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000051b375566778280725f4d321804000000000000000000000014478ccef0fdeedac1b6b8c6e0f3fde7b7702f0a0000000000000c479fe7ffe3a454180300000000062162b3ecfdc5712000000000004094ecffd57d29000000000000000000003488dcffd6822a0000000557abfdffc56d19000000000000000000001e72c6fffca951020000002b7fd7fff3b15d1500000000000000001c6bbef6ffffc16915000000001357abebfff3d3a47e685f626f8cb6dee8efefffffc56d1900000000000006204f81a7bfcfdcded5c4af8d5a366cb8fffead550400000000000000000000000000000000000000002d81d5ffe8943c000000000a4078a3a279430f0000000000000000247cd0ffe999450500000000002275c9fbfdd5954a1f0b0105123a7bc1f1fcd882320200000000000000052c6ab6e4fafffef6f3f4fdfff7d79a511d02000000000000000000000000000c1e36475251442f1a0a0100000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 LCD_V NO_HINTING 16ppem char 32" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 LCD_V NO_HINTING 16ppem char 65" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 LCD_V NO_HINTING 16ppem char 97" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 LCD_V NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="42")
  inspect(f.glyph().bitmap().pitch(), content="10")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="13")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000000000014270e0000000000003b6c7f641a000000001c8fc0d3b8690400000062e3fffffdbd28000009bafed1c3eafa6a000026f2d67d6f9bf7b7010057ff8c291b47cee7130089f2360000058dfd3100a8db0a00000047ff5500babe000000001cfe6d00cbae0000000005f87c00d4b50000000000b96300d3cd0000000000663900c8ea1000000000150c00b2fa510200000000000090ffa54005000000000059feec9850100000000029e0ffe9a4601a0000000891f1fff3b46b100000003ba0e7fffcc351000000054c94d9fffca50c000000064085ceffe82e00000000002d76d8ff63000000000000228afe98020b020000000037edbb1563130000000006cdd423b7280000000000aae12aff3f00000000009be21fff5500000000009fd812fd760000000000b3c408eda80100000005d2b100ced82300000025ed92009df66d13000d72fe65005bfabf674b61c1f7310022d1f5bfa3b9f9cf0d000387fefff7fff37f00000039b5e3fee8af340000000a5d8baa905703000000000b37563c0f000000000000000300000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 LCD_V NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="39")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000012b2a00080b00002d7f7e283546000178d3d26c6181001bcffffcc394b3004bf7c6b3e9b8b30087f3725fd5e0b300bbca1a0b92fcb304df9600004cffb314f66200001dfbb32aff3d000007ecb33dff22000000d9b349ff11000000c7b355ff07000000bcb360fc02000000b4b366fa00000000afb365fb01000000b1b35dfe06000000b8b351ff0d000000c2b345ff1d000000d2b338ff35000004e6b322fd55000014f7b30eeb8600003effb301cbbe0c0281fdb3009de95946c3e6b1005efdb19ed9c9ad002bdff9f1b4b3ab000797f1e264b4a50000419b8b24bb9c010b0d473702c6900b5f1a020000d97e0db743000009ee620bf97600002afc3d02e4ad190870fa1c00b6dc705dbfde070074f9c4b1f29c000036d5fffde14e00000c7dbdbb89110000002b69673500000000001513000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 LCD_V NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="12")
  inspect(f.glyph().bitmap().rows(), content="45")
  inspect(f.glyph().bitmap().pitch(), content="12")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="13")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000000000000000000000d2001000000000000000332637849140000000000002786b7cc9d5e01000000000171dafefff0b2200000000023c6ffeed9fdf5690000000068f6dc9a85b7fcbc19000004b9fd8f463163d9f144000019f0d93700000d8dff8300003fff97070000003de8b7000070fe48000000000cc2e00900a4ef14000000000089f92500d2d102000000000059ff4d05f0a50000000000002dfd700eff7b0000000000000ef2881cff5f00000000000001e39629ff4e00000000000000d3a437ff4100000000000000c6b245ff3400000000000000b9c052ff2800000000000000acce59ff2100000000000000a6d457ff2300000000000000a9d24cff2d00000000000000b3c53eff3a00000000000000c1b630ff4700000000000000cea923ff5500000000000000da9b15ff6c00000000000005eb8c09fa8d0000000014001af77c02e5b8000000004d1440ff5e00bde1080000009f4d74fd35008bf826000000cc9fa9ec130059ff69000000b4dfd7ca02002afbb815000066faf79600000ddcee5d15004dfcff6e00000096ffb1684d80fcff7600000043e4f4c0a5d4fff8ab0a00000ea1fefff8ffe0c2e4350000004db7e8fde29071f868000000115f90a98a3820d37b000000000d3c553603028c56000000000000030000003e22000000000000000000000c05000000000000000000000000000000000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 LCD_V NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000d453901000000000000004a998d250000000000000ea1f1e56e00000000000030e8e6f9bf05000000000065f495bdf01a000000000098d83d6aff380000000000b9b2021df9540000000000cb910005eb650000000000d1830000e56c0000000000c9870004eb6a0000000000b7a30018fa58000000000099cc054bff3900000000006fed2796ed1a00000000003dfc77d7bd05000000000015e9caf56a00000000000002d0fccb290000000000000ed2ff9c040000000000004be6fe89000003000000079eeee5b3020b570c00002be3b8b5e2171aab13000068f9626dfc452cff150000a9db1e33f7853cfd0a0002d9b1020ed8c459f502000af47f0000a0ee96df000015ff5f00005dffcfbf000020ff46000028f1f797000022ff3c000008cbff6f00001cff4300000099ff6200000fff6000000091ff79000005f78f00000db7ffb3020000dfc7160145e9f0e3160000b6ee664799fcb3fb4100007affbe9fe4db5cfa8400003eeafcf1fd9517dfc2050014a4f1fbc944018b970500004c9aa7710d0039530500000e46531f00000000000000000003000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 LCD_V NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="39")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000132c0400000000001b66804d04000000005fbad4a12500000019b7fffff56800000047f0dab8f3b70a000086f98964beeb240001c1d6310c69fd4b000ce7a4030021ec71001cfb6a000002cb940031ff42000000a4b90040ff2900000088d6004fff1b00000077ea0058ff150000006ff60057ff1900000072fc024bff240000007fff063cff3b00000099ff0d2bff5d000000beff1516f694000019e3ff1c06d9cc2a0e62faff1d00abf37e62b6efff190067fcd2b6efc1ff11002cd4ffffdf8bff0a000681cfd58d6cfe040000317b813b6bf90000000123290174f20000000000000081e80000000000000096d600084f1a000000b3bb000aa343000000d099000af07b00000de9780001e8ab000035fa560000c9d51f057bfc3200009df1714dc2de15000061ffc9a5f19f0300002ce4fef4f7510000000b9cf2eeae1a00000000449b985601000000000c47440a000000000000010100000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 NORMAL DEFAULT 16ppem char 32" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 NORMAL DEFAULT 16ppem char 65" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 NORMAL DEFAULT 16ppem char 97" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 NORMAL DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 NORMAL DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 NORMAL DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 NORMAL DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 NORMAL DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 LIGHT DEFAULT 16ppem char 32" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 LIGHT DEFAULT 16ppem char 65" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 LIGHT DEFAULT 16ppem char 97" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 LIGHT DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 LIGHT DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 LIGHT DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 LIGHT DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 LIGHT DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 MONO DEFAULT 16ppem char 32" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 MONO DEFAULT 16ppem char 65" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 MONO DEFAULT 16ppem char 97" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 MONO DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 MONO DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 MONO DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 MONO DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 MONO DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 LCD DEFAULT 16ppem char 32" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 LCD DEFAULT 16ppem char 65" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 LCD DEFAULT 16ppem char 97" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 LCD DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 LCD DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 LCD DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 LCD DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 LCD DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 LCD_V DEFAULT 16ppem char 32" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 LCD_V DEFAULT 16ppem char 65" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 LCD_V DEFAULT 16ppem char 97" {
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 LCD_V DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 LCD_V DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 LCD_V DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 LCD_V DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 LCD_V DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 NORMAL NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 NORMAL NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="24")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="24")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000043f3f3f3f150000000000000000000000000000000000004cffffffff8e000000000000000000000000000000000000a8ffffffffe602000000000000000000000000000000000df6ffffffffff42000000000000000000000000000000005efffff9e2ffff9c00000000000000000000000000000000b9ffffad85ffffef06000000000000000000000000000018fcffff512fffffff4f000000000000000000000000000070ffffee0700d8ffffa90000000000000000000000000000cbffff98000082fffff60d00000000000000000000000027ffffff3c00002cffffff5d00000000000000000000000082ffffdf01000000d5ffffb7000000000000000000000000dcffff83000000007ffffffb160000000000000000000038ffffff280000000029ffffff6b0000000000000000000094ffffca000000000000d2ffffc500000000000000000004eaffff6e0000000000007cffffff2000000000000000004afffffb1600000000000026ffffff790000000000000000a5fffff2afafafafafafafaffaffffd3000000000000000bf5ffffffffffffffffffffffffffffff2c0000000000005cffffffffffffffffffffffffffffffff86000000000000b7ffffd11b1b1b1b1b1b1b1b1b1bcfffffe0010000000016fcffff750000000000000000000076ffffff3a000000006efffffe1d000000000000000000001fffffff9400000000c9ffffc1000000000000000000000000c6ffffea04000025ffffff660000000000000000000000006fffffff48000080fffffa120000000000000000000000001afdffffa20000daffffb20000000000000000000000000000bffffff30936ffffff58000000000000000000000000000067ffffff56")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 NORMAL NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="21")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="20")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000264c5f563a1f000000000000000000000e7ce5ffffffffffffd4620600000000000023d9ffffffffffffffffffffaa010000000001c5ffffffc783697293e8ffffff6e000000004dffffff61000000000006b2ffffb9000000008affffb30000000000000027ffffec0000000073b7b7530000000000000000fffffb0000000000000000000000000000001efffffb000000000000000000000000000e48c9fffffb000000000000000f4b789fc2e3fefffffffffb0000000000169af8ffffffffffffffd7fffffb0000000023e7ffffffffdfad885f2a00fffffb00000000ccffffef7b18000000000000fffffb00000038fffffa380000000000000000fffffb00000064ffffc4000000000000000016fffffb0000006dffffb5000000000000000068fffffb00000040ffffec0f0000000000004df7fffffc00000010f4ffffbf280000052eaaffffffffff3f00000066ffffffffe7d6f9ffffff8cccfffffac13200007ef6ffffffffffffdd50006fffffffff430000001e7ea6c9c1a054060000026fbecdab24")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 NORMAL NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="22")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="22")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000073f7793a59b82692a00000000000000000000000c86ebffffffffffffffffd16901000000000000002adfffffffffffffffffffffffffb414000000000019e6ffffffd6714a2a385884ebffffffc20200000000a4ffffff6a020000000000000c8bffffff7600000012fbffff8400000000000000000000adffffef07000053ffffff1d000000000000000000001dffffff4c00006fffffed000000000000000000000000e8ffff6c00006bfffffd0b000000000000000000000058737333000045ffffff87000000000000000000000000000000000010efffffffa6210000000000000000000000000000000074ffffffffffc77631010000000000000000000000000286ffffffffffffffeba8631f000000000000000000000044affbffffffffffffffffda7a1700000000000000000000165ca0e4fffffffffffffff98001000000000000000000000000286db1f3ffffffffffaa0200000000000000000000000000000853baffffffff62000000000000000000000000000000000057f9ffffe803175b5b540000000000000000000000000074ffffff2436fffffc060000000000000000000000001cffffff4d1dffffff2800000000000000000000000009ffffff4500e8ffff9400000000000000000000000040ffffff1f007ffffffc320000000000000000000006c3ffffcb000010f0ffffee47000000000000000009a3ffffff5700000053fcffffffc374402c263c558deeffffffb200000000005bf7ffffffffffffffffffffffffffba0900000000000020acfdffffffffffffffffffdf6601000000000000000000155d9ab2c7cebfa8783c010000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 NORMAL NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="20")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000136575835010000000000000000000065e1ffffffffda4a0063dbdb44000002a7fffffffffffffffd6973ffff4f000090ffffffd19071a8ebfffcb5ffff4f0036feffff8b0000000019d2ffffffff4f00b2ffffa200000000000010eeffffff4f17fbffff2f000000000000008dffffff4f56ffffca000000000000000029ffffff4f8bffff9f000000000000000002fbffff4fa5ffff84000000000000000000e3ffff4fb5ffff6b000000000000000000c9ffff4fb2ffff78000000000000000000d3ffff4fa2ffff93000000000000000000efffff4f81ffffb000000000000000000cffffff4f48fffff20c000000000000005affffff4f09edffff6800000000000000c7ffffff4f0085ffffe72b000000000072ffffffff4f000bdaffffec5f1e053795fffae6ffff4900002fedfffffffffbffffff6ac1ffff400000002cd2fffffffffffb6c00cbffff37000000000559aacabd8e250000deffff1c00000000000000000000000008fcfff50107d2d7d60e000000000000004cffffc00000c0ffff6100000000000005c5ffff6b000068fffff24d000000001fc7ffffe20c000000a6ffffffe1bdbbe2fffffff74300000000088ff7ffffffffffffffd23a000000000000001b7aa0c4ceb98d460100000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 NORMAL NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="26")
  inspect(f.glyph().bitmap().rows(), content="30")
  inspect(f.glyph().bitmap().pitch(), content="26")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000002b6c869ea0886f310000000000000000000000000000000a7ce0ffffffffffffffffe3840e000000000000000000000052e5ffffffffffffffffffffffffea5c00000000000000000073fefffffff1a66f56536da0edffffffff82000000000000006efffffff47a080000000000000570f0ffffff81000000000033f9ffffe62c0000000000000000000023dffffffd4300000000cefffff4270000000000000000000000001dedffffdf04000046ffffff68000000000000000000000000000057ffffff5c0000b6ffffdf03000000000000000000000000000000d0ffffcc0006f5ffff760000000000000000000000000000000063fffffe143dffffff2e000000000000000000000000000000001cffffff546cfffff1020000000000000000000000000000000000dfffff8380ffffd4000000000000000000000000000000000000c1ffff9894ffffc1000000000000000000000000000000000000aeffffad97ffffbf000000000000000000000000000000000000acffffac83ffffd1000000000000000000000000000000000000beffff986fffffeb000000000000000000000000000000000000d7ffff8546ffffff240000000000000000000000000000000012feffff590bfaffff670000000000000000000000000000000053ffffff1800c1ffffcf00000000000000000000002400000000bfffffd2000057ffffff4d00000000000000000068fa6600003dffffff64000003dcffffe714000000000000001ffaffff9414dfffffe30600000049feffffce150000000000000059f7fffff0ffffff53000000000089ffffffdf4d0000000000000037efffffffff920000000000000399ffffffffcd7a442b2c4576d2ffffffffff5b000000000000000076f8fffffffffffffffffffffffffffffffe8201000000000000001fa3fafffffffffffffffff5982b77fdffffaf0c00000000000000000e5596b0c7c6a68763110000004df3ffe71b000000000000000000000000000000000000000000002dd93b000000000000000000000000000000000000000000000000030000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 NORMAL NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="22")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="22")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000001244736d400d00000000000000000000000000000576f5ffffffffe95a00000000000000000000000001b6ffffffffffffffff74000000000000000000000073ffffdf4e101f7ffbfff82900000000000000000000dffffc2e0000000081ffff7f00000000000000000016ffffd5000000000024ffffb00000000000000000002dffffc500000000001bffffc10000000000000000000bf7fff612000000006cffff9d00000000000000000000a4ffffa400000037f0ffff3d000000000000000000001ff6ffff6c005bf3ffff9d0000000000000000000000006cfffffcbdffffff970200000000000000000000000000abffffffffe754000000000000000000000000000044d9fffffffa22000000000000000000000000000998fffffffbffffba0300000002070704000000000cc0fffff76d3efaffff8e00000051ffff9300000003c4ffffe52c00006affffff5f000072ffff7b0000005fffffe924000000009dfffff83700adffff46000000d2ffff63000000000007c8ffffe531faffef0b000002f9fffe0a0000000000001ae7fffff5ffff8400000018fffff000000000000000003bfafffffff6150000000dffffff1c000000000000000067ffffffb20000000000e7ffff7800000000000000006bfffffffe4f0000000099fffff93a00000000000485fffffffffff22900000016ebfffffb893207165acfffffff82e2ffffda1000000056fefffffffffffffffffffa630035f8ffffb6020000003ed6ffffffffffffffc73500000062ffffff88000000000661a5c4caac8b3600000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 NORMAL NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="18")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="18")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000002000000000000000000000000000868b8e9fef2d58a29000000000000000042e1fffffffffffffffa7e01000000000053fafffffff9cfecffffffff8a0000000027f4ffffea5006000028beffffff4c000000adffffe5180000000000029dffffd302001afeffff5b000000000000000fe9ffff460060ffffec0000000000000000007fffff970086ffffc10000000000000000004fffffdb009affffa50000000000000000002bfffffc078dffffc40000000000000000004affffff2a6effffec0200000000000000007affffff3b2bffffff610000000000000010e7ffffff4600b3ffffe62400000000000aabffffffff50001ff4fffff3712f08275bdcffffffffff4a000065feffffffffffffffffff86faffff3f00000050e3fffffffffffff56e06ffffff340000000008589fbfc8b0731a0018ffffff19000000000000000000000000003bfffff2000000000000000000000000000068ffffcb0000000000000000000000000000acffff860003e1efef380000000000000012f5ffff380000abffff920000000000000086ffffd30100005ffffffb39000000000047fcffff5400000006cdfffff27220052587fbffffb1010000000025f3ffffffffffffffffffca0c0000000000002ec7fffffffffffffb8d06000000000000000001558cb8c8aa7518000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 LIGHT NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 LIGHT NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="24")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="24")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000043f3f3f3f150000000000000000000000000000000000004cffffffff8e000000000000000000000000000000000000a8ffffffffe602000000000000000000000000000000000df6ffffffffff42000000000000000000000000000000005efffff9e2ffff9c00000000000000000000000000000000b9ffffad85ffffef06000000000000000000000000000018fcffff512fffffff4f000000000000000000000000000070ffffee0700d8ffffa90000000000000000000000000000cbffff98000082fffff60d00000000000000000000000027ffffff3c00002cffffff5d00000000000000000000000082ffffdf01000000d5ffffb7000000000000000000000000dcffff83000000007ffffffb160000000000000000000038ffffff280000000029ffffff6b0000000000000000000094ffffca000000000000d2ffffc500000000000000000004eaffff6e0000000000007cffffff2000000000000000004afffffb1600000000000026ffffff790000000000000000a5fffff2afafafafafafafaffaffffd3000000000000000bf5ffffffffffffffffffffffffffffff2c0000000000005cffffffffffffffffffffffffffffffff86000000000000b7ffffd11b1b1b1b1b1b1b1b1b1bcfffffe0010000000016fcffff750000000000000000000076ffffff3a000000006efffffe1d000000000000000000001fffffff9400000000c9ffffc1000000000000000000000000c6ffffea04000025ffffff660000000000000000000000006fffffff48000080fffffa120000000000000000000000001afdffffa20000daffffb20000000000000000000000000000bffffff30936ffffff58000000000000000000000000000067ffffff56")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 LIGHT NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="21")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="20")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000264c5f563a1f000000000000000000000e7ce5ffffffffffffd4620600000000000023d9ffffffffffffffffffffaa010000000001c5ffffffc783697293e8ffffff6e000000004dffffff61000000000006b2ffffb9000000008affffb30000000000000027ffffec0000000073b7b7530000000000000000fffffb0000000000000000000000000000001efffffb000000000000000000000000000e48c9fffffb000000000000000f4b789fc2e3fefffffffffb0000000000169af8ffffffffffffffd7fffffb0000000023e7ffffffffdfad885f2a00fffffb00000000ccffffef7b18000000000000fffffb00000038fffffa380000000000000000fffffb00000064ffffc4000000000000000016fffffb0000006dffffb5000000000000000068fffffb00000040ffffec0f0000000000004df7fffffc00000010f4ffffbf280000052eaaffffffffff3f00000066ffffffffe7d6f9ffffff8cccfffffac13200007ef6ffffffffffffdd50006fffffffff430000001e7ea6c9c1a054060000026fbecdab24")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 LIGHT NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="22")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="22")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000073f7793a59b82692a00000000000000000000000c86ebffffffffffffffffd16901000000000000002adfffffffffffffffffffffffffb414000000000019e6ffffffd6714a2a385884ebffffffc20200000000a4ffffff6a020000000000000c8bffffff7600000012fbffff8400000000000000000000adffffef07000053ffffff1d000000000000000000001dffffff4c00006fffffed000000000000000000000000e8ffff6c00006bfffffd0b000000000000000000000058737333000045ffffff87000000000000000000000000000000000010efffffffa6210000000000000000000000000000000074ffffffffffc77631010000000000000000000000000286ffffffffffffffeba8631f000000000000000000000044affbffffffffffffffffda7a1700000000000000000000165ca0e4fffffffffffffff98001000000000000000000000000286db1f3ffffffffffaa0200000000000000000000000000000853baffffffff62000000000000000000000000000000000057f9ffffe803175b5b540000000000000000000000000074ffffff2436fffffc060000000000000000000000001cffffff4d1dffffff2800000000000000000000000009ffffff4500e8ffff9400000000000000000000000040ffffff1f007ffffffc320000000000000000000006c3ffffcb000010f0ffffee47000000000000000009a3ffffff5700000053fcffffffc374402c263c558deeffffffb200000000005bf7ffffffffffffffffffffffffffba0900000000000020acfdffffffffffffffffffdf6601000000000000000000155d9ab2c7cebfa8783c010000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 LIGHT NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="20")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000136575835010000000000000000000065e1ffffffffda4a0063dbdb44000002a7fffffffffffffffd6973ffff4f000090ffffffd19071a8ebfffcb5ffff4f0036feffff8b0000000019d2ffffffff4f00b2ffffa200000000000010eeffffff4f17fbffff2f000000000000008dffffff4f56ffffca000000000000000029ffffff4f8bffff9f000000000000000002fbffff4fa5ffff84000000000000000000e3ffff4fb5ffff6b000000000000000000c9ffff4fb2ffff78000000000000000000d3ffff4fa2ffff93000000000000000000efffff4f81ffffb000000000000000000cffffff4f48fffff20c000000000000005affffff4f09edffff6800000000000000c7ffffff4f0085ffffe72b000000000072ffffffff4f000bdaffffec5f1e053795fffae6ffff4900002fedfffffffffbffffff6ac1ffff400000002cd2fffffffffffb6c00cbffff37000000000559aacabd8e250000deffff1c00000000000000000000000008fcfff50107d2d7d60e000000000000004cffffc00000c0ffff6100000000000005c5ffff6b000068fffff24d000000001fc7ffffe20c000000a6ffffffe1bdbbe2fffffff74300000000088ff7ffffffffffffffd23a000000000000001b7aa0c4ceb98d460100000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 LIGHT NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="26")
  inspect(f.glyph().bitmap().rows(), content="30")
  inspect(f.glyph().bitmap().pitch(), content="26")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000002b6c869ea0886f310000000000000000000000000000000a7ce0ffffffffffffffffe3840e000000000000000000000052e5ffffffffffffffffffffffffea5c00000000000000000073fefffffff1a66f56536da0edffffffff82000000000000006efffffff47a080000000000000570f0ffffff81000000000033f9ffffe62c0000000000000000000023dffffffd4300000000cefffff4270000000000000000000000001dedffffdf04000046ffffff68000000000000000000000000000057ffffff5c0000b6ffffdf03000000000000000000000000000000d0ffffcc0006f5ffff760000000000000000000000000000000063fffffe143dffffff2e000000000000000000000000000000001cffffff546cfffff1020000000000000000000000000000000000dfffff8380ffffd4000000000000000000000000000000000000c1ffff9894ffffc1000000000000000000000000000000000000aeffffad97ffffbf000000000000000000000000000000000000acffffac83ffffd1000000000000000000000000000000000000beffff986fffffeb000000000000000000000000000000000000d7ffff8546ffffff240000000000000000000000000000000012feffff590bfaffff670000000000000000000000000000000053ffffff1800c1ffffcf00000000000000000000002400000000bfffffd2000057ffffff4d00000000000000000068fa6600003dffffff64000003dcffffe714000000000000001ffaffff9414dfffffe30600000049feffffce150000000000000059f7fffff0ffffff53000000000089ffffffdf4d0000000000000037efffffffff920000000000000399ffffffffcd7a442b2c4576d2ffffffffff5b000000000000000076f8fffffffffffffffffffffffffffffffe8201000000000000001fa3fafffffffffffffffff5982b77fdffffaf0c00000000000000000e5596b0c7c6a68763110000004df3ffe71b000000000000000000000000000000000000000000002dd93b000000000000000000000000000000000000000000000000030000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 LIGHT NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="22")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="22")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000001244736d400d00000000000000000000000000000576f5ffffffffe95a00000000000000000000000001b6ffffffffffffffff74000000000000000000000073ffffdf4e101f7ffbfff82900000000000000000000dffffc2e0000000081ffff7f00000000000000000016ffffd5000000000024ffffb00000000000000000002dffffc500000000001bffffc10000000000000000000bf7fff612000000006cffff9d00000000000000000000a4ffffa400000037f0ffff3d000000000000000000001ff6ffff6c005bf3ffff9d0000000000000000000000006cfffffcbdffffff970200000000000000000000000000abffffffffe754000000000000000000000000000044d9fffffffa22000000000000000000000000000998fffffffbffffba0300000002070704000000000cc0fffff76d3efaffff8e00000051ffff9300000003c4ffffe52c00006affffff5f000072ffff7b0000005fffffe924000000009dfffff83700adffff46000000d2ffff63000000000007c8ffffe531faffef0b000002f9fffe0a0000000000001ae7fffff5ffff8400000018fffff000000000000000003bfafffffff6150000000dffffff1c000000000000000067ffffffb20000000000e7ffff7800000000000000006bfffffffe4f0000000099fffff93a00000000000485fffffffffff22900000016ebfffffb893207165acfffffff82e2ffffda1000000056fefffffffffffffffffffa630035f8ffffb6020000003ed6ffffffffffffffc73500000062ffffff88000000000661a5c4caac8b3600000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 LIGHT NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="18")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="18")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000002000000000000000000000000000868b8e9fef2d58a29000000000000000042e1fffffffffffffffa7e01000000000053fafffffff9cfecffffffff8a0000000027f4ffffea5006000028beffffff4c000000adffffe5180000000000029dffffd302001afeffff5b000000000000000fe9ffff460060ffffec0000000000000000007fffff970086ffffc10000000000000000004fffffdb009affffa50000000000000000002bfffffc078dffffc40000000000000000004affffff2a6effffec0200000000000000007affffff3b2bffffff610000000000000010e7ffffff4600b3ffffe62400000000000aabffffffff50001ff4fffff3712f08275bdcffffffffff4a000065feffffffffffffffffff86faffff3f00000050e3fffffffffffff56e06ffffff340000000008589fbfc8b0731a0018ffffff19000000000000000000000000003bfffff2000000000000000000000000000068ffffcb0000000000000000000000000000acffff860003e1efef380000000000000012f5ffff380000abffff920000000000000086ffffd30100005ffffffb39000000000047fcffff5400000006cdfffff27220052587fbffffb1010000000025f3ffffffffffffffffffca0c0000000000002ec7fffffffffffffb8d06000000000000000001558cb8c8aa7518000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 MONO NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 MONO NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="23")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  inspect(f.glyph().bitmap().buffer().length(), content="104")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 MONO NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="20")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="19")
  inspect(f.glyph().bitmap().buffer().length(), content="80")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 MONO NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="20")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="27")
  inspect(f.glyph().bitmap().buffer().length(), content="112")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 MONO NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="16")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="19")
  inspect(f.glyph().bitmap().buffer().length(), content="54")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 MONO NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="26")
  inspect(f.glyph().bitmap().rows(), content="29")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  inspect(f.glyph().bitmap().buffer().length(), content="116")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 MONO NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="21")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="26")
  inspect(f.glyph().bitmap().buffer().length(), content="108")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 MONO NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  inspect(f.glyph().bitmap().buffer().length(), content="108")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 LCD NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 LCD NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="72")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="72")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000000000000000004192f3f3f3f3f3f3f3f3f3f3f3f2a1501000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000084ca0f0ffffffffffffffffffffffe18e3a01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000954a8f2ffffffffffffffffffffffffffe6943c0200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d57aff6ffffffffffffffffffffffffffffffea964204000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000115eb2f9fffffffffffff9dbdbe2ffffffffffffffeb9c4804000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001365b9fafffffffffffff5ad5a3e85d9ffffffffffffffefa24a0600000000000000000000000000000000000000000000000000000000000000000000000000000000000000001869c1fcfffffffffffff3a5510a002f83dbfffffffffffffff2a34f090000000000000000000000000000000000000000000000000000000000000000000000000000000000001d70c4feffffffffffffeea149070000002d85d8fffffffffffffff3a9550a000000000000000000000000000000000000000000000000000000000000000000000000000000002077cbfeffffffffffffe998440400000000002e82d6fffffffffffffff6af570d0000000000000000000000000000000000000000000000000000000000000000000000000000277bd2ffffffffffffffe6903c02000000000000002c80d8fffffffffffffff9b15d100000000000000000000000000000000000000000000000000000000000000000000000002e82d6ffffffffffffffdf8c34010000000000000000002a82d5fffffffffffffffab76312000000000000000000000000000000000000000000000000000000000000000000003189dcffffffffffffffd8832f0000000000000000000000002b7fd3fffffffffffffffbbd65160000000000000000000000000000000000000000000000000000000000000001388ce2ffffffffffffffd37b280000000000000000000000000000297dd5fffffffffffffffdbf6b1a0000000000000000000000000000000000000000000000000000000000024094e5fffffffffffffeca762000000000000000000000000000000000277ed2fffffffffffffffdc5711c00000000000000000000000000000000000000000000000000000004439beafffffffffffffec26e1d000000000000000000000000000000000000287cd0ffffffffffffffffcb732000000000000000000000000000000000000000000000000000074a9eeffffffffffffffbbe66160000000000000000000000000000000000000000267ad2ffffffffffffffffcd792600000000000000000000000000000000000000000000000851a5f1fffffffffffffff2d8bdafafafafafafafafafafafafafafafafafafafafafafc4dffaffffffffffffffffd37f270000000000000000000000000000000000000000000b55adf5ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd9802c000000000000000000000000000000000000000f5cb0f8ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffda863200000000000000000000000000000000001263b7f9ffffffffffffffd186381b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b3684cfffffffffffffffffe08c340100000000000000000000000000001667bffcffffffffffffffc975220000000000000000000000000000000000000000000000000000000000002276caffffffffffffffffe48e3a020000000000000000000000001c6ec2fdfffffffffffffec76f1d00000000000000000000000000000000000000000000000000000000000000001f72caffffffffffffffffe6944002000000000000000000001e75c9fefffffffffffffcc16d18000000000000000000000000000000000000000000000000000000000000000000001c72c6feffffffffffffffea9a420400000000000000002578d0fffffffffffffffcba66170000000000000000000000000000000000000000000000000000000000000000000000001c6fc3feffffffffffffffee9c48060000000000002b80d4fffffffffffffffab8601200000000000000000000000000000000000000000000000000000000000000000000000000001a6bc3fdffffffffffffffefa24e07000000002f87dafffffffffffffff8b25e0f00000000000000000000000000000000000000000000000000000000000000000000000000000000176bbffcfffffffffffffff3a850090001368ae0fffffffffffffff7ac580d0000000000000000000000000000000000000000000000000000000000000000000000000000000000001767bbfcfffffffffffffff6aa560c")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 LCD NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="57")
  inspect(f.glyph().bitmap().rows(), content="21")
  inspect(f.glyph().bitmap().pitch(), content="60")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="20")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000005132637444c52595f615e564d433a31271f12070000000000000000000000000000000000000000000000000000000000000000000e29547ca5c9e5f5fefffffffffffffffffffffffffffffffffdeed4af88623d1a0600000000000000000000000000000000000000000000042358a3d9f7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe5aa581a010000000000000000000000000000000000012272c5f7fffffffffffffffffae6c7a790837a7169676a727b8593aacbe8f9fffffffffffffffff7c26e23000000000000000000000000000000074da1f1ffffffffffffffe8ad612306000000000000000000000000000000062465b2e7fffffffffffffeb9650f0000000000000000000000000000368adefffffffffffff9b35f0e000000000000000000000000000000000000000000277bd3ffffffffffffec984000000000000000000000000000003673afb7b7b7b7b7b7905317000000000000000000000000000000000000000000000054acfffffffffffffba74f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e72c9fffffffffffffba74f0000000000000000000000000000000000000000000000000000000000000000000000000000000000040e1c2f486797c9effffffffffffffffba74f0000000000000000000000000000000000000000000000030f21374b5c6b7885939fabb7c2cdd8e3eff9fefffffffffffffffffffffffffffffba74f0000000000000000000000000000000000031638699ac4e7f8fffffffffffffffffffffffffffffffffffffffffffceed7dbe9fffffffffffffba74f0000000000000000000000000000042360b2e7fefffffffffffffffffffffffbf0dfccbbada094887b6e5f503f2a15050053abfffffffffffffba74f000000000000000000000000002479ccfcffffffffffffffefd2a57b53311809010000000000000000000000000000000053abfffffffffffffba74f000000000000000000000000388ce4fffffffffffffad386380b000000000000000000000000000000000000000000000053abfffffffffffffba74f00000000000000000000001064b8ffffffffffffffc47018000000000000000000000000000000000000000000000000166ac2fffffffffffffba74f0000000000000000000000196dc1fffffffffffffeb5610a00000000000000000000000000000000000000000000011f68bbf5fffffffffffffba74f0000000000000000000000004094ecffffffffffffeca8500f00000000000000000000000000000000000006204d91d0f7fffffffffffffffffca9510000000000000000000000001058b0f4ffffffffffffffeabf8650280d00000000000000050e1c2e4b77aad8f5ffffffffffffffffffffffffffe5933f050000000000000000000000012066b9f1fffffffffffffffffffffbf2e7ddd5d6e0eff9fffffffffffffffffff0c88c678fccfffffffffffffffffaecd4c1ae6e3200000000000000000017447eb2ddf6fffffffffffffffffffffffffffffffffffffff6ddb6845024070000246fc3f7ffffffffffffffffffffef974300000000000000000000000000071e43687e8c99a6b2bfc9ccc9c1b9afa0896e54361906000000000000000002173e6f95b0bec8cdcdc6baab90562400000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 LCD NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="66")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="68")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000007162c3f516577848e93999fa5a6a29b928a827a71695b452a130400000000000000000000000000000000000000000000000000000000000000000000000c2a5986add0ebfbfffffffffffffffffffffffffffffffffffffffffffffffaebd1b49369381101000000000000000000000000000000000000000000000000072a65aedff8fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffbe1b4773a14010000000000000000000000000000000000001956ace6fefffffffffffffffffef1d6b08b7160554a3e332a282e38434e58636f84a3cdebfcfffffffffffffffffff4c271240200000000000000000000000000000e50a4e9ffffffffffffffffe7ae6a2f100200000000000000000000000000000000000000000c254f8bc6f3fffffffffffffff7c6762a0300000000000000000000001262bafbfffffffffffffbcf843509000000000000000000000000000000000000000000000000000000001959ade8ffffffffffffffefa34b070000000000000000000453a7faffffffffffffffc9711d00000000000000000000000000000000000000000000000000000000000000001d71c9fffffffffffffff4a04c0300000000000000001b6fc3ffffffffffffffed9941000000000000000000000000000000000000000000000000000000000000000000003c94e8ffffffffffffffc06c180000000000000000176bbffffffffffffffffdb45c0b0000000000000000000000000000000000000000000000000000000000000000000a32587373737373737359330d0000000000000000004599f1fffffffffffffffbd287380800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001054aceffffffffffffffffffff3d5a67445210c01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002574c7fafffffffffffffffffffffffffff6e3c7ab8f765f47311b0a010000000000000000000000000000000000000000000000000000000000000000000000000000000002174686c4eefffffffffffffffffffffffffffffffffffffffff9ebd6bea8917a634d351f0d020000000000000000000000000000000000000000000000000000000000000000000620446c8fafd0ebfbfffffffffffffffffffffffffffffffffffffffffffffffffbeedabe9e7a57331705000000000000000000000000000000000000000000000000000000000000000006162c465c728aa0b7cee4f5fefffffffffffffffffffffffffffffffffffffffffff9e6bb8040140100000000000000000000000000000000000000000000000000000000000000000000000000000614283f566d839ab1c7e0f3fdfffffffffffffffffffffffffffffadeaa5d220200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000081a36537092badff9fffffffffffffffffffff4b6621a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a27579ad5f9ffffffffffffffffe8973f03000000001735555b5b5b5b5b5b54361600000000000000000000000000000000000000000000000000000000000000000000000000032774c5f9ffffffffffffffd0782400000000368ae2fffffffffffffcae560600000000000000000000000000000000000000000000000000000000000000000000000000001c70c8fffffffffffffff8a14d010000001d71c9ffffffffffffffd47c280000000000000000000000000000000000000000000000000000000000000000000000000000095db5fffffffffffffff1994500000000003d95e8ffffffffffffffe09440080000000000000000000000000000000000000000000000000000000000000000000000044094e8ffffffffffffffcb731f0000000000012d7fd1fefffffffffffffcd182320900000000000000000000000000000000000000000000000000000000000000062b76c3f3fffffffffffffecb772000000000000000001054acf0ffffffffffffffffeec382471d0700000000000000000000000000000000000000000000000009215aa3dffdffffffffffffffeeab571500000000000000000000011c53a2dffcfffffffffffffffffff9e2c3a289745f4d4038322c2724262c343c454d5560728dafd4eefcffffffffffffffffffebb25f1b00000000000000000000000000000003225ba3dcf7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffde9ba722e090000000000000000000000000000000000000000000820497cacd6f2fdfffffffffffffffffffffffffffffffffffffffffffffffffffffffef3dfbf946635120100000000000000000000000000000000000000000000000000000000000006152b455d768c9aa4abb2b9c0c7cdcfcec9c4bfbab3a89a887868543c200b01000000000000000000000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 LCD NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="54")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="56")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="20")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000010d2136444e575f5f584e4435200c0100000000000000000000000000000000000000000000000000000000000000000000000e326596c1e1f5fffffffffffffffffffffffef1dab6834a1c0300001b63abdbdbdbdbdbd88c4400000000000000000000000000021f5ca7dffafffffffffffffffffffffffffffffffffffffffffffde9b6692a2473c7fffffffffffba34f00000000000000000000000b4190d9fbfffffffffffffff9e8d1b9a4907c70718095a8bcd5ebfbfffffffffcdab1b5d6fffffffffffba34f000000000000000000063688dafefffffffffffff4cc8b4313000000000000000000000002194995d2f5fffffffffffffffffffffffba34f00000000000000000f5eb2f6ffffffffffffe7a24e0e0000000000000000000000000000000000001053aaeefffffffffffffffffffba34f000000000000001767bffbffffffffffffda822f01000000000000000000000000000000000000000002398ddffffffffffffffffffba34f0000000000000756aafaffffffffffffca761e000000000000000000000000000000000000000000000000297dd4fffffffffffffffba34f000000000000378bdffffffffffffff39f4b000000000000000000000000000000000000000000000000000252aafbfffffffffffffba34f00000000000051a5f9ffffffffffffd884300000000000000000000000000000000000000000000000000000378fe3fffffffffffffba34f00000000000961b5ffffffffffffffbf6b1700000000000000000000000000000000000000000000000000001d75c9fffffffffffffba34f0000000000065eb2ffffffffffffffcc78240000000000000000000000000000000000000000000000000000277fd3fffffffffffffba34f0000000000004ea2f6ffffffffffffe7933f0000000000000000000000000000000000000000000000000000439beffffffffffffffba34f0000000000002d81d5fffffffffffffdb05c060000000000000000000000000000000000000000000000000c60b8fffffffffffffffba34f00000000000002489cf1fffffffffffff2aa520c00000000000000000000000000000000000000000000105aaef5fffffffffffffffba34f00000000000000094aa2edfffffffffffffbbc681a00000000000000000000000000000000000000001e73c7fcfffffffffffffffffba34f0000000000000000013385d8feffffffffffffe7b5672b0800000000000000000000000000000b3272baebfffffffffffffffffffffba34f000000000000000000000b3c91dafdffffffffffffffecc18a5f47321e0e04051124374b6795caf2fffffffae0e0e6fffffffffffff59d49000000000000000000000000082f70bfedfffffffffffffffffffffffffdfbfbfefffffffffffffffff1bb6a3b70c1ffffffffffffec94400000000000000000000000000000000a2c61a1d2f1fffffffffffffffffffffffffffffffffbe2b06c310c001f77cbffffffffffffe38b3700000000000000000000000000000000000000051836597895aab8c2caccc7bdb3a48e6f49250d0100000000328adeffffffffffffc8701c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000859b1fcfffffffffff5a24a0100000000000000074892d2d7d7d7d7d7d69d530e00000000000000000000000000000000000000000000064ca0f1fffffffffffdc06c17000000000000000000156cc0fefffffffffff6b5611600000000000000000000000000000000000000052576c5f8fffffffffffdbf6b1900000000000000000000001f68bcf5fffffffffffff2c7894d250c0000000000000000000000061f4d8cc7edffffffffffffffe29a430c00000000000000000000000000001854a6e3fefffffffffffffffdf0e1d1c6bdb5b4bbc7d5e2f0fafffffffffffffffffff7d58e431100000000000000000000000000000000000008295a8fbae1f7fffffffffffffffffffffffffffffffffffffffffffeefd2a8713a120000000000000000000000000000000000000000000000000000061b3e627a8895a0acb9c4ced1cec7c0b9b0a18d775f46291001000000000000000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 LCD NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="81")
  inspect(f.glyph().bitmap().rows(), content="30")
  inspect(f.glyph().bitmap().pitch(), content="84")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000000000006152b455c6c767e868e969ea4a5a0988f8880776f604a3119080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a234e7ca3c5e0f2fdfffffffffffffffffffffffffffffffffffffffffffffef5e3cbaa84562a0e0100000000000000000000000000000000000000000000000000000000000000000000000000000421528cc2e5fafffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffceac9965c2907000000000000000000000000000000000000000000000000000000000000000d3573b9e9fefffffffffffffffffffffcf1ddc1a68e7b6f675e564f4e535c646d7789a0bbd7edfbffffffffffffffffffffffefc48240130000000000000000000000000000000000000000000000000003276ebff3fffffffffffffffffff4d9ab7a491f08000000000000000000000000000000000000000005194070a1d1f0fefffffffffffffffff8ce8134070000000000000000000000000000000000000000083381d0f9fffffffffffffffde6b6692c0900000000000000000000000000000000000000000000000000000000000005235ba8dffbfffffffffffffffddd95430f0000000000000000000000000000000000257acefdfffffffffffffff4c2702705000000000000000000000000000000000000000000000000000000000000000000000000021d5eb4edffffffffffffffffdf8f37040000000000000000000000000009469ae9fffffffffffffff3bb68200100000000000000000000000000000000000000000000000000000000000000000000000000000000001757abebfffffffffffffff4b05c1300000000000000000000001162b6f8ffffffffffffffdf8e3603000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000277dd0fefffffffffffffecc78210000000000000000000650a8f5ffffffffffffffca76220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001563b7fafffffffffffffebe661400000000000000003d91e8ffffffffffffffda822e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001c6fc7fffffffffffffff8a85408000000000000186cc0fffffffffffffff19f4702000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000338bdfffffffffffffffd7832f0000000000002c80d4ffffffffffffffd4802800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000156dc1ffffffffffffffec98440000000000004094e8ffffffffffffffc16d1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000035aaefefffffffffffffead590300000000004397ebffffffffffffffbf6b13000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000258acfdfffffffffffffeac580300000000002f83d7ffffffffffffffd17d2500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000126abeffffffffffffffec98440000000000001b6fc3ffffffffffffffeb973f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002b83d7ffffffffffffffd9853100000000000002469aefffffffffffffffd0782400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001264bcfefffffffffffffaad590b000000000000000b59b1fafffffffffffffdbb67150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000953a7f5ffffffffffffffc36b18000000000000000000186dc1fdfffffffffffffecf7b25000000000000000000000000000000000000000000000000000000000000001023241400000000000000000000001a6bbff9ffffffffffffffd27e2700000000000000000000001057abf2ffffffffffffffe7a14d110000000000000000000000000000000000000000000000000000032568b8eefadfaa662d0a00000000000a3d91dffffffffffffffff7b864180000000000000000000000000003348cdcffffffffffffffffe7a74f1400000000000000000000000000000000000000000000001f6dc5fafffffffffffff3cf94511e14459bdffeffffffffffffffe3953d060000000000000000000000000000000012499be1fefffffffffffffff4ce8f44150100000000000000000000000000000000000000000624599ed8f7fffffffffffffef0f0f1ffffffffffffffffe7a753170000000000000000000000000000000000000000093a89d4fbfffffffffffffffff8dfb57e4d2309000000000000000000000000000000000000000010377ac2effffffffffffffffffffffffffdda92420d000000000000000000000000000000000000000000000000031d5199d3f6fffffffffffffffffffff9e7cdb1947a6250443c342b26272c343d454f5f7693b3d2ebfbffffffffffffffffffffffffffe5a95b2105000000000000000000000000000000000000000000000000000000000f3976b2e0f8fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeecc18242150100000000000000000000000000000000000000000000000000000000081f4576a3cbeafafffffffffffffffffffffffffffffffffffffffffffffffffffff5dfbc98744e2b213b77b9e8fdfffffffffffffbe0af6c300c00000000000000000000000000000000000000000000000000000000000000030e213c556e8596a0a8b0b7bfc7cdccc6bbb0a69c91877c72634c2b11020000000000000000031d4d91cff3ffffffffffe7ae571b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b2d66add9ce883b0c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010303020000000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 LCD NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="69")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="72")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000005122334445363737b796d5e4f40311d0d0100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000051b4476aad9f5fffffffffffffffffffffffffffce9c58f5a2b0c000000000000000000000000000000000000000000000000000000000000000000000000000000000000011e64b6edfffffffffffffffffffffffffffffffffffffffffffffff7c674290200000000000000000000000000000000000000000000000000000000000000000000000000032873c4f5fffffffffff9dfb37a4e311e100b111f32537fb7e3fbfffffffffff8cb7629020000000000000000000000000000000000000000000000000000000000000000000000338bdffffffffffffcd27f2e040000000000000000000000053181d0fcffffffffffd37f2b00000000000000000000000000000000000000000000000000000000000000000000166ac2ffffffffffffd581290000000000000000000000000000002478d0fffffffffffcb05c080000000000000000000000000000000000000000000000000000000000000000002d81d9ffffffffffffc571190000000000000000000000000000001b6fc7ffffffffffffc16d150000000000000000000000000000000000000000000000000000000000000000000b57aff7fffffffffff6b55d1200000000000000000000000000206cc0f8fffffffffff19d4900000000000000000000000000000000000000000000000000000000000000000000000a50a4eeffffffffffffe5a4501200000000000000000e377bc5f0ffffffffffffe1903d07000000000000000000000000000000000000000000000000000000000000000000000000001f69c1f6ffffffffffffefbc6c2904000a2a5b98d0f3fffffffffffffbdd9d4e140000000000000000000000000000000000000000000000000000000000000000000000000000000002266cbef2fffffffffffffcdec2bddbf7fffffffffffffff7d4974e19020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001858abe8fffffffffffffffffffffffffce7c18a54260900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000051d4476acd9f5fffffffffffffffffffffac77022010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009285d98cef1fffffffffffffffbfbfbffffffffffffffeeba6a240300000000000000000000000204070707070707070402000000000000000000000000000000000000000c3379c0edfffffffffffffff7dba86d361e3e8bd6fafffffffffffffbd58e3f0d00000000000000000251a5faffffffffffe7933f00000000000000000000000000000000032b73c4f0fffffffffffffde5b1682c0b000000000003266abbf0ffffffffffffffebb15f1f0100000000001e72c6ffffffffffffcf7b27000000000000000000000000000000165fb3f5ffffffffffffe9b46124050000000000000000000000124b9ddefdfffffffffffff8d083370b00000d59adf4fffffffffff09a46020000000000000000000000000000267ed2fffffffffffff5b7631a00000000000000000000000000000000072e7bc8f5ffffffffffffffe5ab543167befaffffffffffefa74f0b0000000000000000000000000000024fa7f9fffffffffffeb45c0a00000000000000000000000000000000000000011a57ade7fffffffffffffff6f5f5feffffffffffd7843101000000000000000000000000000000186cc4fffffffffffff09c4400000000000000000000000000000000000000000000000c3b89d4fafffffffffffffffffffffff6b75f1500000000000000000000000000000000000d61b9ffffffffffffffc8701c000000000000000000000000000000000000000000000000022467b8effffffffffffffffff9b25e0d000000000000000000000000000000000000003c94e7fffffffffffffac9782a0300000000000000000000000000000000000000000000082d6bb6e9fffffffffffffffffffee2a14f160000000000000000000000000000000000044599e8fffffffffffffff9ce863a1000000000000000000000000000000000041b4885c2eefffffffffffffffffffffffffffffff2c26f2905000000000000000000000000000000001655adebfffffffffffffffffbe6bc89614432221207060d16253c5a7ca5cfefffffffffffffffffecbc8279a7e2fefffffffffffffbda964210000000000000000000000000000000001756a9eafefffffffffffffffffffffffffffffffffffffffffffffffffffffffffffadfa9632a080000093581cff8ffffffffffffffecb665210200000000000000000000000000000003183e71a8d6f3fffffffffffffffffffffffffffffffffffffffff9e6c79f6b35110000000000000000012162b4edfffffffffffffff9d1883a0b000000000000000000000000000000000000061c3f617a91a5b4bec4cbcecac1b6aca1968b77593617050000000000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 LCD NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="54")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="56")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000000000202010000000000000000000000000000000000000000000000000000000000000000000000000000000000081f4468859fb8cedfe9f1f9fefefaf2e9e0d5c2a88a6c4c290f000000000000000000000000000000000000000000000000000116427eb9e1f8fffffffffffffffffffffffffffffffffffffffffffffae3b77e4318010000000000000000000000000000000000001a53a1dffafffffffffffffffffffffff9eddbcfcfdbecf8fffffffffffffffffffffff9d18a3d0d00000000000000000000000000022770c5f4fffffffffffffffdeac285502a11060000000000000612284d83bee8fdffffffffffffffe9a04c0e000000000000000000001059adf0ffffffffffffffe5a75318030000000000000000000000000000000002174c9ddcfffffffffffffdd3822d02000000000000001a6dc5fefffffffffffff0af5b17000000000000000000000000000000000000000000000f4ca4e9ffffffffffffed9a460400000000000f60b4fcffffffffffffec994100000000000000000000000000000000000000000000000000002b7fd3ffffffffffffe9974302000000003286daffffffffffffffc16d150000000000000000000000000000000000000000000000000000034fa3f8ffffffffffffdb872f00000000469aeefffffffffffff9a551000000000000000000000000000000000000000000000000000000002b7fd7fffffffffffffcaf5707000000398de1ffffffffffffffc470180000000000000000000000000000000000000000000000000000014a9ef4ffffffffffffffd67e2a0000001a6ec2ffffffffffffffec9a420200000000000000000000000000000000000000000000000000267aceffffffffffffffffe78f3b000000002b7fd7fffffffffffffff4b5611900000000000000000000000000000000000000000000104ca4e7fffffffffffffffffff29a460000000000185fb3efffffffffffffffe6ae5f2408000000000000000000000000000000000a2761abe2fffffffffffffffffffffffca450000000000000001f67bff4fffffffffffffffff3d49f71523f2f1f0f080b172736475b7dafdcf7fffffffffffffffffffffffffffff69e4a0000000000000000012565b6e9fefffffffffffffffffffffffffffffffffffffffffffffffffffffff5cb868db6faffffffffffffeb933f000000000000000000000004215089bee3f8fffffffffffffffffffffffffffffffffffffff5d8a76e3710065ab2ffffffffffffffe0883400000000000000000000000000000000081d3b58718b9faeb7bfc6cac8c1b8b0a38e7357361a0700000000186cc4ffffffffffffffc56d19000000000000000000000000000000000000000000000000000000000000000000000000000000000000003b8fe7fffffffffffff29f47000000000000000000000000000000000000000000000000000000000000000000000000000000000000001568bcffffffffffffffcb771f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000858acf7ffffffffffffdb8632000000000000034496e1efefefefefefd786380100000000000000000000000000000000000000000000125cb4f5ffffffffffffe48c3800000000000000000957abf6ffffffffffffe2923e0400000000000000000000000000000000000000063386d3fefffffffffffdd3812b01000000000000000000105fb3fbfffffffffffffbd588390a000000000000000000000000000001174796d9fcfffffffffffff0a85410000000000000000000000000062f7fcdf8fffffffffffffff2d4a3724b30201207050b16253e6087b7e1fbffffffffffffffe8b15f1e0100000000000000000000000000000003256dc2f3fffffffffffffffffffffffffffffffffffffffffffffffffffffffff1ca82380c0000000000000000000000000000000000000000000f2e5e94c7eafdfffffffffffffffffffffffffffffffffffffbe9c28d51200600000000000000000000000000000000000000000000000000000000011232556e7e8c9baab8c5cbc8bfb4aa9f8d75563418060000000000000000000000000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 LCD_V NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
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
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 LCD_V NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="24")
  inspect(f.glyph().bitmap().rows(), content="84")
  inspect(f.glyph().bitmap().pitch(), content="24")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000000000000000000000000043f3f3f3f1500000000000000000000000000000000000013939393933a0000000000000000000000000000000000002eebebebeb6b0000000000000000000000000000000000004cffffffff8e0000000000000000000000000000000000006affffffffab0000000000000000000000000000000000008affffffffca000000000000000000000000000000000000a8ffffffffe6020000000000000000000000000000000000c6fffffffff70e0000000000000000000000000000000001e3ffffffffff25000000000000000000000000000000000df6ffffffffff420000000000000000000000000000000021ffffffffffff5f0000000000000000000000000000000040fffffff7ffff7e000000000000000000000000000000005efffff9e2ffff9c000000000000000000000000000000007cffffe8c3ffffb9000000000000000000000000000000009bffffcca2ffffd800000000000000000000000000000000b9ffffad85ffffef06000000000000000000000000000000d7ffff8f69fffffc17000000000000000000000000000007efffff6f4bffffff32000000000000000000000000000018fcffff512fffffff4f000000000000000000000000000033ffffff3316fcffff6d000000000000000000000000000052fffffc1706efffff8c000000000000000000000000000070ffffee0700d8ffffa900000000000000000000000000008effffd70000bcffffc70000000000000000000000000000adffffb700009fffffe40200000000000000000000000000cbffff98000082fffff60d00000000000000000000000002e6ffff7a000066ffffff2200000000000000000000000010f8ffff5a000048ffffff4000000000000000000000000027ffffff3c00002cffffff5d00000000000000000000000044fffffe20000014fbffff7b00000000000000000000000064fffff30b000005edffff9a00000000000000000000000082ffffdf01000000d5ffffb7000000000000000000000000a0ffffc100000000b9ffffd5000000000000000000000000bfffffa1000000009bffffee060000000000000000000000dcffff83000000007ffffffb160000000000000000000009f2ffff650000000063ffffff2f000000000000000000001cfdffff450000000045ffffff4d0000000000000000000038ffffff280000000029ffffff6b0000000000000000000056fffff8100000000012faffff880000000000000000000076ffffe6030000000004ebffffa70000000000000000000094ffffca000000000000d2ffffc500000000000000000000b2ffffac000000000000b6ffffe101000000000000000000d1ffff8c00000000000098fffff50c000000000000000004eaffff6e0000000000007cffffff20000000000000000012faffff5000000000000060ffffff3c00000000000000002cffffff3000000000000042ffffff5b00000000000000004afffffb1600000000000026ffffff79000000000000000068ffffef0a03030303030314faffff96000000000000000088ffffef5c5b5b5b5b5b5b5ffaffffb50000000000000000a5fffff2afafafafafafafaffaffffd30000000000000000c3ffffffffffffffffffffffffffffec0500000000000001e1fffffffffffffffffffffffffffffb140000000000000bf5ffffffffffffffffffffffffffffff2c00000000000020feffffffffffffffffffffffffffffff4a0000000000003effffffffffffffffffffffffffffffff690000000000005cffffffffffffffffffffffffffffffff860000000000007afffffbc7c7c7c7c7c7c7c7c7c7faffffa400000000000099ffffea6f6f6f6f6f6f6f6f6f6fe9ffffc3000000000000b7ffffd11b1b1b1b1b1b1b1b1b1bcfffffe0010000000000d5ffffb200000000000000000000b1fffff40a0000000006eeffff930000000000000000000092fffffe1f0000000016fcffff750000000000000000000076ffffff3a0000000031ffffff580000000000000000000059ffffff580000000050ffffff39000000000000000000003bffffff77000000006efffffe1d000000000000000000001fffffff94000000008cfffff30a000000000000000000000bf5ffffb200000000abffffde000000000000000000000001e2ffffd000000000c9ffffc1000000000000000000000000c6ffffea04000002e4ffffa3000000000000000000000000aafffffa1200000ff7ffff840000000000000000000000008bffffff2b000025ffffff660000000000000000000000006fffffff48000042ffffff4900000000000000000000000052ffffff65000062ffffff2b00000000000000000000000034ffffff84000080fffffa120000000000000000000000001afdffffa200009effffeb0400000000000000000000000008f2ffffbf0000bdffffd00000000000000000000000000000dcffffde0000daffffb20000000000000000000000000000bffffff30908f0ffff940000000000000000000000000000a2fffffe1c1bfdffff75000000000000000000000000000084ffffff3836ffffff58000000000000000000000000000067ffffff562eababab3100000000000000000000000000003cababab441c5353531300000000000000000000000000001853535326000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 LCD_V NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="66")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="20")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000b05000000000000000000000000000000264c5f563a1f000000000000000000000000397aa0b3aa8e732a000000000000000000002a91d2f8fffde6cb801600000000000000000e7ce5ffffffffffffd462060000000000000040d0fffffffffffffffeb6270000000000000493fefffffffffffffffff86200000000000023d9ffffffffffffffffffffaa01000000000053fbffffffffffffffffffffdd13000000000093fffffffbd7bdc6e6fffffffa3e0000000001c5ffffffc783697293e8ffffff6e000000000ee8ffffe6732f151e3f9afdffff93000000002bfcffffad1f0000000042e4ffffa8000000004dffffff61000000000006b2ffffb90000000067fffff02600000000000074ffffca000000007bffffd40700000000000043ffffdc000000008affffb30000000000000027ffffec0000000094ffff980000000000000015fffff7000000009cffff810000000000000007fffffb0000000073b7b7530000000000000000fffffb00000000406363290000000000000003fffffb00000000070b0b04000000000000000cfffffb0000000000000000000000000000001efffffb00000000000000000000000000000042fffffb00000000000000000000000000000686fffffb000000000000000000000000000e48c9fffffb00000000000000000000001637609cf5fffffb000000000000000003244b6e8fb8edfffffffb000000000000000f4b789fc2e3fefffffffffb0000000000000a5c9fccf3fffffffffffffffb00000000000046b4f4fffffffffffffffffffb0000000000169af8ffffffffffffffd7fffffb000000000053e4fffffffffffffed683fffffb0000000005a9fffffffffffbdcb37e2bfffffb0000000023e7ffffffffdfad885f2a00fffffb0000000059fefffffdc48b59340d0000fffffb000000009bffffffce6c330500000000fffffb00000000ccffffef7b18000000000000fffffb00000008ebffffc22900000000000000fffffb0000001efcffff7b0000000000000000fffffb00000038fffffa380000000000000000fffffb0000004dffffec110000000000000001fffffb0000005affffd7000000000000000009fffffb00000064ffffc4000000000000000016fffffb0000006effffb5000000000000000026fffffb00000072ffffaf00000000000000003ffffffb0000006dffffb5000000000000000068fffffb00000060ffffc30000000000000000a1fffffb00000050ffffd80000000000000012d9fffffb00000040ffffec0f0000000000004df7fffffc00000031fffffa34000000000013a0fffffffd0a000020ffffff7b010000000056e6ffffffff1f000010f4ffffbf280000052eaaffffffffff3f000005d6ffffee7b3b2a5282ebfffaf7ffff84150500a1ffffffd29382aadaffffd4e4ffffc76d1c0066ffffffffe7d6f9ffffff8cccfffffac1320031f9ffffffffffffffffe83db5ffffffff43000ecfffffffffffffffffa30c98ffffffff4300007ef6ffffffffffffdd50006fffffffff43000030c1fffffffffff69012003df9ffffff4300000369d2f7fffff2a839000015c3fffff83a0000001e7ea6c9c1a054060000026fbecdab24000000002a52756d4c0a00000000226a79570d0000000000021d1502000000000000122106000000000000000000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 LCD_V NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="22")
  inspect(f.glyph().bitmap().rows(), content="87")
  inspect(f.glyph().bitmap().pitch(), content="22")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000233f51472e150000000000000000000000000000073f7793a59b82692a000000000000000000000000014693cbe7f9efd6bd7e260000000000000000000000339eebffffffffffffd67d200000000000000000000c86ebffffffffffffffffd16901000000000000000041d9ffffffffffffffffffffbd1c000000000000000897fefffffffffffffffffffff561000000000000002adfffffffffffffffffffffffffb41400000000000066fefffffffff5d6e4feffffffffec41000000000004b4fffffffec59e7e8cacd7ffffffff85000000000019e6ffffffd6714a2a385884ebffffffc202000000003ffefffff1851d0000000630a3fcffffe9150000000073ffffffb72e0000000000004bd0fffffd3e00000000a4ffffff6a020000000000000c8bffffff7600000000ceffffec2400000000000000003bf9ffffaa00000004edffffc006000000000000000010ddffffd600000012fbffff8400000000000000000000adffffef07000028ffffff53000000000000000000006ffffffc19000041ffffff31000000000000000000003dffffff35000053ffffff1d000000000000000000001dffffff4c00005efffffd0d000000000000000000000cfdffff5c000067fffff4030000000000000000000003f5ffff6600006fffffed000000000000000000000000e8ffff6c000074ffffee000000000000000000000000d8ffff6f000073fffff70200000000000000000000009fc7c75800006bfffffd0b00000000000000000000005873733300005effffff230000000000000000000000171f1f0e000052ffffff4f000000000000000000000000000000000045ffffff87000000000000000000000000000000000038ffffffc3110000000000000000000000000000000023feffffec520000000000000000000000000000000010efffffffa62100000000000000000000000000000002d1ffffffe9751d000000000000000000000000000000a3ffffffffcd7322000000000000000000000000000074ffffffffffc776310100000000000000000000000040f9fffffffffeca854007000000000000000000000018d0ffffffffffffdd985412000000000000000000000286ffffffffffffffeba8631f0000000000000000000039e6fffffffffffffff5b7732e0000000000000000000a97f5fffffffffffffffdcb862800000000000000000044affbffffffffffffffffda7a170000000000000000085bbdfbffffffffffffffffcf640800000000000000000e65b0f1ffffffffffffffffbc35000000000000000000165ca0e4fffffffffffffff980010000000000000000000d4c90d4ffffffffffffffcb1a0000000000000000000003387cc1fafffffffffff759000000000000000000000000286db1f3ffffffffffaa020000000000000000000000001a5da8f4ffffffffe412000000000000000000000000000b50a7f5fffffffe3400000000000000000000000000000853baffffffff620000000000000000000000000000000a66ecffffff930000000000000000000000000000000019aaffffffc5000000000000000000000000000000000057f9ffffe8030000000000000000000000000000000016dffffffb0a0207070700000000000000000000000000aeffffff16175b5b540000000000000000000000000074ffffff242aafafa5000000000000000000000000004affffff323bfffff5010000000000000000000000002dffffff4036fffffc060000000000000000000000001cffffff4d30ffffff0f0000000000000000000000000dffffff5229ffffff1a00000000000000000000000007ffffff4f1dffffff2800000000000000000000000009ffffff4510feffff4000000000000000000000000014ffffff3b05f8ffff6600000000000000000000000027ffffff2f00e8ffff9400000000000000000000000040ffffff1f00cdffffc400000000000000000000000061fffff80f00a8ffffe90e000000000000000000000090ffffe602007ffffffc320000000000000000000006c3ffffcb000055ffffff740000000000000000000023ecffffac00002cfeffffbe0e0000000000000000005bffffff85000010f0ffffee47000000000000000009a3ffffff57000002d1ffffff9b1b000000000000024bdafffffa2a00000097ffffffe46e20000000000439a3faffffe10b00000053fcffffffc374402c263c558deeffffffb2000000001ee1fffffffbc894807a90a9dfffffffff6d0000000003a8ffffffffffecd8d2e8fdffffffffec2e00000000005bf7ffffffffffffffffffffffffffba09000000000022c3fffffffffffffffffffffffff468000000000000036ceeffffffffffffffffffffffb9240000000000000020acfdffffffffffffffffffdf6601000000000000000058bffaffffffffffffffe78c1d0000000000000000001267b1eefffffffff9cc90340000000000000000000000155d9ab2c7cebfa8783c010000000000000000000000000e465e737a6b542401000000000000000000000000000000061b22130300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 LCD_V NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="87")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="20")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000606000000000000000000000000000136575835010000000000000000000000368aabac892f0000152f2f0e000000001f8ee2fefee18714003d87872a0000000065e1ffffffffda4a0063dbdb440000001bb8ffffffffffff9d0773ffff4f00000057f2ffffffffffffe02d73ffff4f000002a7fffffffffffffffd6973ffff4f00001be0ffffffffffffffffb275ffff4f00004ffcffffffe4c5f6ffffe38bffff4f000090ffffffd19071a8ebfffcb5ffff4f0002c9fffff77e3c1d54afffffe1ffff4f0014edffffcf2600000658f7fffbffff4f0036feffff8b0000000019d2ffffffff4f0064fffff23f00000000018effffffff4f008fffffcf0f00000000003ffcffffff4f00b2ffffa200000000000010eeffffff4f00d2ffff7600000000000000d4ffffff4f07edffff5100000000000000b0ffffff4f17fbffff2f000000000000008dffffff4f2dfffff814000000000000006affffff4f44ffffe4040000000000000046ffffff4f56ffffca000000000000000029ffffff4f67ffffb5000000000000000013ffffff4f7affffa8000000000000000007ffffff4f8bffff9f000000000000000002fbffff4f97ffff96000000000000000000f5ffff4f9fffff8d000000000000000000ecffff4fa5ffff84000000000000000000e3ffff4faaffff7b000000000000000000daffff4fb0ffff72000000000000000000d1ffff4fb5ffff6b000000000000000000c9ffff4fb7ffff6a000000000000000000c7ffff4fb6ffff6f000000000000000000cbffff4fb2ffff78000000000000000000d3ffff4facffff81000000000000000000dcffff4fa7ffff8a000000000000000000e6ffff4fa2ffff93000000000000000000efffff4f9bffff9c000000000000000000f7ffff4f90ffffa5000000000000000004fdffff4f81ffffb000000000000000000cffffff4f6effffc100000000000000001dffffff4f5bffffdc010000000000000037ffffff4f48fffff20c000000000000005affffff4f33fffffe23000000000000007effffff4f1afcffff4600000000000000a3ffffff4f09edffff6800000000000000c7ffffff4f00d2ffff8f00000000000007e6ffffff4f00acffffc10700000000002ef9ffffff4f0085ffffe72b000000000072ffffffff4f0058fffffe6c000000000ebeffffffff4f0029f6ffffbc1000000041effffaffff4c000bdaffffec5f1e053795fffae6ffff490000aaffffffb372558bdbffdfd1ffff46000066fffffffbcaade4ffffabc1ffff4300002fedfffffffffbffffff6ac1ffff4000000bbefffffffffffffff031c4ffff3d0000006efbffffffffffffbc0cc7ffff3a0000002cd2fffffffffffb6c00cbffff370000000783f6ffffffffcd2800cfffff310000000030adf9ffffe1750400d5ffff28000000000559aacabd8e250000deffff1c00000000000e5676693a000000eaffff10000000000000041e1100000001f5fffc0600000000000000000000000008fcfff501042b2b2a000000000000000018ffffe90007838382030000000000000031ffffd70007d2d7d60e000000000000004cffffc00002edffff21000000000000006dffffa40000d7ffff3c0000000000000097ffff860000c0ffff6100000000000005c5ffff6b0000a8ffff940000000000002ae8ffff4a00008effffcf0d000000000177fcfff926000068fffff24d000000001fc7ffffe20c00003af9ffffa136110f3672f5ffffb900000012dbffffeb8e69678ec9ffffff7f00000000a6ffffffe1bdbbe2fffffff7430000000061ffffffffffffffffffffd1180000000028ddfffffffffffffffffd860000000000088ff7ffffffffffffffd23a0000000000003bbfffffffffffffee800c0000000000000567cef4ffffffe19a2b00000000000000001b7aa0c4ceb98d4601000000000000000000264c707a65390300000000000000000000000018220d0000000000000000000000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 LCD_V NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="26")
  inspect(f.glyph().bitmap().rows(), content="90")
  inspect(f.glyph().bitmap().pitch(), content="26")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000018324a4c341b000000000000000000000000000000000000002b6c869ea0886f310000000000000000000000000000000001337fc0daf2f4dcc385380200000000000000000000000000002b8bd7ffffffffffffdd9031000000000000000000000000000a7ce0ffffffffffffffffe3840e00000000000000000000000044ceffffffffffffffffffffd54c0000000000000000000000189bfcfffffffffffffffffffffea41d0000000000000000000052e5ffffffffffffffffffffffffea5c00000000000000000007a4fffffffffffffdfcffffffffffffaf0b00000000000000002ee4fffffffff2c3aaa7c1efffffffffea38000000000000000073fefffffff1a66f56536da0edffffffff82000000000000000ec1fffffffba5521b0403194c9ff8ffffffcc1500000000000035f1ffffffcc4d07000000000547c3fffffff6420000000000006efffffff47a080000000000000570f0ffffff81000000000000adffffffc52a000000000000000023bbffffffbd02000000000fdefffffe750200000000000000000067fcffffe9190000000033f9ffffe62c0000000000000000000023dffffffd430000000069ffffffb2080000000000000000000004a4ffffff7e00000000a1ffffff6300000000000000000000000053feffffb500000000cefffff4270000000000000000000000001dedffffdf0400000aebffffd50800000000000000000000000004c9fffff615000023fcffffa0000000000000000000000000000090ffffff34000046ffffff68000000000000000000000000000057ffffff5c00006effffff35000000000000000000000000000027fcffff84000095fffff51200000000000000000000000000000aecffffac0000b6ffffdf03000000000000000000000000000000d0ffffcc0000d0ffffbd00000000000000000000000000000000acffffe60000e6ffff970000000000000000000000000000000085fffff60606f5ffff760000000000000000000000000000000063fffffe1413feffff5a0000000000000000000000000000000047ffffff2827ffffff420000000000000000000000000000000030ffffff3e3dffffff2e000000000000000000000000000000001cffffff5451ffffff1b000000000000000000000000000000000cfbffff6961fffffb0a0000000000000000000000000000000002f0ffff796cfffff1020000000000000000000000000000000000dfffff8373ffffe5000000000000000000000000000000000000d1ffff8a79ffffdb000000000000000000000000000000000000c8ffff9180ffffd4000000000000000000000000000000000000c1ffff9887ffffce000000000000000000000000000000000000bbffff9f8dffffc8000000000000000000000000000000000000b5ffffa694ffffc1000000000000000000000000000000000000aeffffad9affffbd000000000000000000000000000000000000a9ffffb29bffffbc000000000000000000000000000000000000a9ffffb297ffffbf000000000000000000000000000000000000acffffac90ffffc5000000000000000000000000000000000000b2ffffa68affffcb000000000000000000000000000000000000b8ffff9f83ffffd1000000000000000000000000000000000000beffff987cffffd7000000000000000000000000000000000000c4ffff9276ffffdf000000000000000000000000000000000000ccffff8b6fffffeb000000000000000000000000000000000000d7ffff8567fffff6050000000000000000000000000000000000e7ffff7c59fffffe120000000000000000000000000000000006f6ffff6d46ffffff240000000000000000000000000000000012feffff5931ffffff380000000000000000000000000000000025ffffff431bffffff4e000000000000000000000000000000003affffff2c0bfaffff670000000000000000000000000000000053ffffff1802eeffff860000000000000000000000000000000072fffff80900daffffab0000000000000000000000000000000098ffffea0100c1ffffcf00000000000000000000002400000000bfffffd20000a3ffffeb080000000000000000000a7202000004e1ffffb400007efffffc210000000000000000002eca24000017f7ffff8d000057ffffff4d00000000000000000068fa6600003dffffff64000030ffffff83000000000000000001abffb70f0073ffffff3c000012f4ffffbe010000000000000014e0ffee4400b1fffff81a000003dcffffe714000000000000001ffaffff9414dfffffe306000000b5fffffc40000000000000001ee7ffffd858f9ffffbf0000000081ffffff8d000000000000000aabfffffcb0ffffff8c0000000049feffffce150000000000000059f7fffff0ffffff53000000001cecfffff54a000000000000001dcffffffffffff1230000000004c4ffffffa00f0000000000000182ffffffffffcb06000000000089ffffffdf4d0000000000000037efffffffff920000000000004bfbfffffea12200000000000032efffffffff540000000000001cd9ffffffea792600000000227ef0ffffffff3b0000000000000399ffffffffcd7a442b2c4576d2ffffffffff5b0000000000000049f3ffffffffce987f8099caffffffffffffa60900000000000013c5fffffffffff0d7d8f1ffffffffffffffe5360000000000000076f8fffffffffffffffffffffffffffffffe82010000000000002ec3ffffffffffffffffffffffffd6f4ffffcc1d000000000000046beaffffffffffffffffffffe67fc4fffff75d000000000000001fa3fafffffffffffffffff5982b77fdffffaf0c000000000000004fb4f7fffffffffffffdb244002fe1ffffe824000000000000000d5ca9eafefffff8dbb75a0500069ffffffd2800000000000000000e5596b0c7c6a68763110000004df3ffe71b0000000000000000000a425c73725233110000000016c5ffbc030000000000000000000000051b1a010000000000000074fd7700000000000000000000000000000000000000000000002dd93b000000000000000000000000000000000000000000000007891200000000000000000000000000000000000000000000000034000000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 LCD_V NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="22")
  inspect(f.glyph().bitmap().rows(), content="84")
  inspect(f.glyph().bitmap().pitch(), content="22")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000001f190000000000000000000000000000000000001244736d400d000000000000000000000000000000025b98c7c1944a00000000000000000000000000000029b3f0ffffeca217000000000000000000000000000576f5ffffffffe95a000000000000000000000000002bc9ffffffffffffae130000000000000000000000006bf9ffffffffffffef3b000000000000000000000001b6ffffffffffffffff74000000000000000000000012e3ffffedbccbfbffffae00000000000000000000003afbfffea26473cfffffdd0c0000000000000000000073ffffdf4e101f7ffbfff82900000000000000000000a5ffffab0c000030e4ffff4e00000000000000000000caffff6200000004b8ffff6d00000000000000000000dffffc2e0000000081ffff7f00000000000000000001f0fff30e0000000055ffff8f00000000000000000009fbffe5000000000036ffffa000000000000000000016ffffd5000000000024ffffb000000000000000000026ffffc9000000000017ffffbf0000000000000000002effffc3000000000014ffffc50000000000000000002dffffc500000000001bffffc100000000000000000024ffffd200000000002bffffb500000000000000000017ffffe5030000000046ffffa90000000000000000000bf7fff612000000006cffff9d00000000000000000002e5ffff34000000009effff8900000000000000000000c7ffff690000000cd1ffff6700000000000000000000a4ffffa400000037f0ffff3d000000000000000000007affffd60b00007dfffff51a0000000000000000000048fffff5310019c9ffffd705000000000000000000001ff6ffff6c005bf3ffff9d000000000000000000000007dbffffb218affffffa55000000000000000000000000a8ffffe469edffffd71c0000000000000000000000006cfffffcbdffffff970200000000000000000000000034f9fffff8ffffeb49000000000000000000000000000edcffffffffffa8140000000000000000000000000000abffffffffe7540000000000000000000000000000008effffffffa41400000000000000000000000000000ca8fffffffa4d00000000000000000000000000000044d9fffffffa2200000000000000000000000000000d97fdfffffffa39000000000000000000000000000046e3ffffffffff79000000000000000000000000000998fffffffbffffba0300000002070704000000000030dffffff4d1ffffe71b000000195b5b38000000000076feffffbf8cfffffd4c00000035b3b36a000000000cc0fffff76d3efaffff8e00000051ffff930000000035eeffffc92414e0ffffca0800005cffff8c000000007dfffffd780201adfffff129000067ffff8500000003c4ffffe52c00006affffff5f000072ffff7b00000014efffffaf06000031f6ffffa300007effff6d00000035fffffd5f0000000cd4ffffda100092ffff5a0000005fffffe924000000009dfffff83700adffff4600000089ffffc505000000005affffff7300ceffff32000000b4ffff91000000000024efffffb809eafffd1b000000d2ffff63000000000007c8ffffe531faffef0b000000e5ffff3a0000000000008cfffffc7affffd501000000f0ffff1a00000000000048fdffffc9ffffac00000002f9fffe0a0000000000001ae7fffff5ffff8400000007fefff80200000000000003bbffffffffff5d00000010fffff0000000000000000078ffffffffff3400000018fffff000000000000000003bfafffffff61500000019fffff6030000000000000013deffffffe00400000014fffffd0d0000000000000000aaffffffbc000000000dffffff1c000000000000000067ffffffb20000000007ffffff2f000000000000000035ffffffc70400000002f7ffff4e000000000000000036ffffffea1e00000000e7ffff7800000000000000006bfffffffe4f00000000d1ffffb0000000000000000ab8ffffffff9000000000b8ffffdf0e00000000000037ecffffffffce0900000099fffff93a00000000000485fffffffffff2290000006fffffff8906000000002ccffffffbffffff600000003bfdffffd3350000001080faffffcdfbffffa600000016ebfffffb893207165acfffffff82e2ffffda10000002c6ffffffd6865b6aaefbffffea33b4fffff8360000008fffffffffdeb3c2f6ffffffb30970ffffff7500000056fefffffffffffffffffffa630035f8ffffb602000027dfffffffffffffffffffd224000fdaffffe41800000891fdfffffffffffffffc84030000a4fffffd470000003ed6ffffffffffffffc73500000062ffffff880000000a88fbffffffffffdf73090000002bababab720000000034b5f5fffffcdf8a1e000000000953535343000000000661a5c4caac8b36000000000000000000000000000000125170765837020000000000000000000000000000000004181e040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 LCD_V NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="18")
  inspect(f.glyph().bitmap().rows(), content="87")
  inspect(f.glyph().bitmap().pitch(), content="18")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000000000002000000000000000000000000000000113d544629000000000000000000000000186495ac9e8136000000000000000000000868b8e9fef2d58a290000000000000000003ebcfbffffffffde7805000000000000001095fbffffffffffffd0300000000000000042e1fffffffffffffffa7e0100000000000391ffffffffffffffffffcd17000000000020d8fffffffffffffffffffa46000000000053fafffffff9cfecffffffff8a000000000099ffffffeaab7b99d3ffffffc8080000000ad2ffffffa45323417cf1fffff12300000027f4ffffea5006000028beffffff4c00000052ffffffae11000000006cf8ffff7a00000083fffffa57000000000023d2ffffa9000000adffffe5180000000000029dffffd3020001d5ffffc0000000000000005efffff010000af1ffff8c000000000000002efcfffe28001afeffff5b000000000000000fe9ffff460031fffffe2d0000000000000001c6ffff600049fffff70e00000000000000009cffff7c0060ffffec0000000000000000007fffff970072ffffdd0000000000000000006cffffb2007fffffcf0000000000000000005dffffc90086ffffc10000000000000000004fffffdb008effffb300000000000000000040ffffe80095ffffa800000000000000000032fffff5019affffa50000000000000000002bfffffc079affffac0000000000000000002effffff1194ffffb80000000000000000003bffffff1e8dffffc40000000000000000004affffff2a86ffffd100000000000000000059ffffff327dffffde00000000000000000068ffffff376effffec0200000000000000007affffff3b5afffff712000000000000000097ffffff3f42fffffe330000000000000001c2ffffff422bffffff610000000000000010e7ffffff4615f8ffff900000000000000031fcffffff4a06deffffc20200000000000068ffffffff4d00b3ffffe62400000000000aabffffffff50007ffffffa6c00000000003cdeffffffff500048ffffffc11f0000000c91feffffffff4e001ff4fffff3712f08275bdcffffffffff4a0006d8ffffffc4835c7baffdfff3fcffff460000a6fffffffedbb4d3fbffffcafbffff43000065feffffffffffffffffff86faffff3f00002de4fffffffffffffffff53ffdffff3b000007a2ffffffffffffffffc013ffffff3800000050e3fffffffffffff56e06ffffff340000001697f8ffffffffffbb2509ffffff2e000000003facf2fffffec7630110ffffff250000000008589fbfc8b0731a0018ffffff1900000000000c4b6b745c20000023ffffff0e00000000000001131c0500000030fffffb04000000000000000000000000003bfffff2000000000000000000000000000047ffffe6000000000000000000000000000057ffffd9000000000000000000000000000068ffffcb00000000000000000000000000007effffb8000000000000000000000000000096ffffa00000000000000000000000000000acffff860003434343080000000000000000c5ffff6c0003989b9b1c0000000000000003e1ffff510003e1efef380000000000000012f5ffff380000deffff54000000000000002efffffe1f0000c4ffff720000000000000057ffffef0b0000abffff920000000000000086ffffd301000093ffffbc00000000000001baffffaa00000079ffffe312000000000015e6ffff7e0000005ffffffb39000000000047fcffff540000003effffff7e010000000395fffffc2b0000001df0ffffc42400000033d9ffffe10e00000006cdfffff27220052587fbffffb1010000000096ffffffc5745979d7ffffff6c000000000056fffffff9ccb1d1fffffff42f000000000025f3ffffffffffffffffffca0c000000000008c9fffffffffffffffffc7c0000000000000076f8ffffffffffffffd730000000000000002ec7fffffffffffffb8d06000000000000000474f4fffffffffec03c00000000000000000024a9e0fffffbc9680900000000000000000001558cb8c8aa751800000000000000000000000c386474562200000000000000000000000000000d1c020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 NORMAL DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="381")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 NORMAL DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 NORMAL DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 NORMAL DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 NORMAL DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 NORMAL DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 NORMAL DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 NORMAL DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 LIGHT DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="381")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 LIGHT DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 LIGHT DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 LIGHT DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 LIGHT DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 LIGHT DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 LIGHT DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 LIGHT DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 MONO DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="381")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 MONO DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 MONO DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 MONO DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 MONO DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 MONO DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 MONO DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 MONO DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 LCD DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="381")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 LCD DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 LCD DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 LCD DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 LCD DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 LCD DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 LCD DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 LCD DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 381 LCD_V DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="381")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 854 LCD_V DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="854")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 113 LCD_V DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="113")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 18 LCD_V DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 119 LCD_V DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="119")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 16 LCD_V DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="16")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 292 LCD_V DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="292")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NimbusSans-Regular.pfb: rendered glyph 241 LCD_V DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_nimbussans_regular_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="241")
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

