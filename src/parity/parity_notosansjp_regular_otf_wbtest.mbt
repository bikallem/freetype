// Parity tests for NotoSansJP-Regular.otf
// AUTO-GENERATED — do not edit

///|
fn load_generated_notosansjp_regular_otf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/NotoSansJP-Regular.otf")
}

///|
test "parity/NotoSansJP-Regular.otf: format" {
  inspect(@base.detect_format(load_generated_notosansjp_regular_otf()), content="CffOpenType")
}

///|
test "parity/NotoSansJP-Regular.otf: loads" {
  inspect((try? @freetype.from_bytes(load_generated_notosansjp_regular_otf())) is Ok(_), content="true")
}

///|
test "parity/NotoSansJP-Regular.otf: metadata" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  inspect(f.family_name(), content="Noto Sans JP")
  inspect(f.num_glyphs(), content="17936")
  inspect(f.units_per_em(), content="1000")
  inspect(f.ascender(), content="1160")
  inspect(f.descender(), content="-288")
  inspect(f.height(), content="1448")
  inspect(f.underline_position(), content="-150")
  inspect(f.underline_thickness(), content="50")
}

///|
test "parity/NotoSansJP-Regular.otf: bbox" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  inspect(f.bbox().x_min(), content="-1002")
  inspect(f.bbox().y_min(), content="-1048")
  inspect(f.bbox().x_max(), content="2928")
  inspect(f.bbox().y_max(), content="1808")
}

///|
test "parity/NotoSansJP-Regular.otf: flags" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/NotoSansJP-Regular.otf: charmaps" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  inspect(f.charmaps().length(), content="6")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="0")
    inspect(f.charmaps()[0].encoding_id(), content="3")
  }
  if f.charmaps().length() > 1 {
    inspect(f.charmaps()[1].platform_id(), content="0")
    inspect(f.charmaps()[1].encoding_id(), content="4")
  }
  if f.charmaps().length() > 2 {
    inspect(f.charmaps()[2].platform_id(), content="0")
    inspect(f.charmaps()[2].encoding_id(), content="5")
  }
  if f.charmaps().length() > 3 {
    inspect(f.charmaps()[3].platform_id(), content="1")
    inspect(f.charmaps()[3].encoding_id(), content="1")
  }
  if f.charmaps().length() > 4 {
    inspect(f.charmaps()[4].platform_id(), content="3")
    inspect(f.charmaps()[4].encoding_id(), content="1")
  }
  if f.charmaps().length() > 5 {
    inspect(f.charmaps()[5].platform_id(), content="3")
    inspect(f.charmaps()[5].encoding_id(), content="10")
  }
}

///|
test "parity/NotoSansJP-Regular.otf: charmap entries" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 33U), content="2")
  inspect(@freetype.get_char_index(f, 34U), content="3")
  inspect(@freetype.get_char_index(f, 35U), content="4")
  inspect(@freetype.get_char_index(f, 36U), content="5")
  inspect(@freetype.get_char_index(f, 37U), content="6")
  inspect(@freetype.get_char_index(f, 38U), content="7")
  inspect(@freetype.get_char_index(f, 39U), content="8")
  inspect(@freetype.get_char_index(f, 40U), content="9")
  inspect(@freetype.get_char_index(f, 41U), content="10")
  inspect(@freetype.get_char_index(f, 42U), content="11")
  inspect(@freetype.get_char_index(f, 43U), content="12")
  inspect(@freetype.get_char_index(f, 44U), content="13")
  inspect(@freetype.get_char_index(f, 45U), content="14")
  inspect(@freetype.get_char_index(f, 46U), content="15")
  inspect(@freetype.get_char_index(f, 47U), content="16")
  inspect(@freetype.get_char_index(f, 48U), content="17")
  inspect(@freetype.get_char_index(f, 49U), content="18")
  inspect(@freetype.get_char_index(f, 50U), content="19")
  inspect(@freetype.get_char_index(f, 51U), content="20")
  inspect(@freetype.get_char_index(f, 52U), content="21")
  inspect(@freetype.get_char_index(f, 53U), content="22")
  inspect(@freetype.get_char_index(f, 54U), content="23")
  inspect(@freetype.get_char_index(f, 55U), content="24")
  inspect(@freetype.get_char_index(f, 56U), content="25")
  inspect(@freetype.get_char_index(f, 57U), content="26")
  inspect(@freetype.get_char_index(f, 58U), content="27")
  inspect(@freetype.get_char_index(f, 59U), content="28")
  inspect(@freetype.get_char_index(f, 60U), content="29")
  inspect(@freetype.get_char_index(f, 61U), content="30")
  inspect(@freetype.get_char_index(f, 62U), content="31")
  inspect(@freetype.get_char_index(f, 63U), content="32")
  inspect(@freetype.get_char_index(f, 64U), content="33")
  inspect(@freetype.get_char_index(f, 65U), content="34")
  inspect(@freetype.get_char_index(f, 66U), content="35")
  inspect(@freetype.get_char_index(f, 67U), content="36")
  inspect(@freetype.get_char_index(f, 68U), content="37")
  inspect(@freetype.get_char_index(f, 69U), content="38")
  inspect(@freetype.get_char_index(f, 70U), content="39")
  inspect(@freetype.get_char_index(f, 71U), content="40")
  inspect(@freetype.get_char_index(f, 72U), content="41")
  inspect(@freetype.get_char_index(f, 73U), content="42")
  inspect(@freetype.get_char_index(f, 74U), content="43")
  inspect(@freetype.get_char_index(f, 75U), content="44")
  inspect(@freetype.get_char_index(f, 76U), content="45")
  inspect(@freetype.get_char_index(f, 77U), content="46")
  inspect(@freetype.get_char_index(f, 78U), content="47")
  inspect(@freetype.get_char_index(f, 79U), content="48")
  inspect(@freetype.get_char_index(f, 80U), content="49")
  inspect(@freetype.get_char_index(f, 81U), content="50")
}

///|
test "parity/NotoSansJP-Regular.otf: glyph 2 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  let r = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="18")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="130")
  inspect(f.glyph().outline().points()[0].y(), content="221")
  inspect(f.glyph().outline().points()[1].x(), content="193")
  inspect(f.glyph().outline().points()[1].y(), content="221")
  inspect(f.glyph().outline().points()[2].x(), content="205")
  inspect(f.glyph().outline().points()[2].y(), content="645")
  inspect(f.glyph().outline().points()[3].x(), content="207")
  inspect(f.glyph().outline().points()[3].y(), content="749")
  inspect(f.glyph().outline().points()[4].x(), content="115")
  inspect(f.glyph().outline().points()[4].y(), content="749")
  inspect(f.glyph().outline().points()[5].x(), content="117")
  inspect(f.glyph().outline().points()[5].y(), content="645")
  inspect(f.glyph().outline().points()[6].x(), content="161")
  inspect(f.glyph().outline().points()[6].y(), content="-13")
  inspect(f.glyph().outline().points()[7].x(), content="198")
  inspect(f.glyph().outline().points()[7].y(), content="-13")
  inspect(f.glyph().metrics().hori_advance(), content="323")
}

///|
test "parity/NotoSansJP-Regular.otf: glyph 3 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  let r = try? @freetype.load_glyph(f, 3U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="12")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="110")
  inspect(f.glyph().outline().points()[0].y(), content="483")
  inspect(f.glyph().outline().points()[1].x(), content="167")
  inspect(f.glyph().outline().points()[1].y(), content="483")
  inspect(f.glyph().outline().points()[2].x(), content="184")
  inspect(f.glyph().outline().points()[2].y(), content="669")
  inspect(f.glyph().outline().points()[3].x(), content="186")
  inspect(f.glyph().outline().points()[3].y(), content="771")
  inspect(f.glyph().outline().points()[4].x(), content="90")
  inspect(f.glyph().outline().points()[4].y(), content="771")
  inspect(f.glyph().outline().points()[5].x(), content="92")
  inspect(f.glyph().outline().points()[5].y(), content="669")
  inspect(f.glyph().outline().points()[6].x(), content="307")
  inspect(f.glyph().outline().points()[6].y(), content="483")
  inspect(f.glyph().outline().points()[7].x(), content="362")
  inspect(f.glyph().outline().points()[7].y(), content="483")
  inspect(f.glyph().metrics().hori_advance(), content="474")
}

///|
test "parity/NotoSansJP-Regular.otf: glyph 4 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  let r = try? @freetype.load_glyph(f, 4U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="32")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="101")
  inspect(f.glyph().outline().points()[0].y(), content="0")
  inspect(f.glyph().outline().points()[1].x(), content="160")
  inspect(f.glyph().outline().points()[1].y(), content="0")
  inspect(f.glyph().outline().points()[2].x(), content="188")
  inspect(f.glyph().outline().points()[2].y(), content="229")
  inspect(f.glyph().outline().points()[3].x(), content="336")
  inspect(f.glyph().outline().points()[3].y(), content="229")
  inspect(f.glyph().outline().points()[4].x(), content="309")
  inspect(f.glyph().outline().points()[4].y(), content="0")
  inspect(f.glyph().outline().points()[5].x(), content="369")
  inspect(f.glyph().outline().points()[5].y(), content="0")
  inspect(f.glyph().outline().points()[6].x(), content="396")
  inspect(f.glyph().outline().points()[6].y(), content="229")
  inspect(f.glyph().outline().points()[7].x(), content="500")
  inspect(f.glyph().outline().points()[7].y(), content="229")
  inspect(f.glyph().metrics().hori_advance(), content="555")
}

///|
test "parity/NotoSansJP-Regular.otf: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="320")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 NORMAL NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 NORMAL NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="10")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000011bb980000000000000063e1fe1c000000000000b97dd570000000000014fb3188c7000000000066e5013cff1f00000000bd9a0003eb7400000017fc4a00009fcb0000006affc6bfbfdbff220000c1c36b6b6b6cf6780019fd5700000000b1ce006ef80d0000000060ff25c4b4000000000014fc7c")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 NORMAL NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000460aad9c255000079de8059a7ff3a000a06000004f49600000005305de4b5000686e9ce9bddbb00a6db2c0000bbbb04f770000000bebb00eabf171e90fdbb0056f4fff1828ebb00000c2703000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 NORMAL NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000027a4dad5a02d000023f0d48275b9f932008aee0a0000003c00009eea030000000000004fffb02100000000000065f0faa63200000000001885edfc8a0700000000000f8dff7f00000000000000c6c600460e00000000c6b40de4de662d2d8dff500015a5edffffe65f0000000000201a000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 NORMAL NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00004dbedbb8afaf70004efd713598fc7a4700b8af000002e56a0000c69a000000d37f00007ae819003dfc3e000006e7efcdf47800000071b80d330f000000009acd2514130400000029fbfffffffecb2c00af870f1f244df2b21aff2900000000bfa705e9ad2a0a238bf334002aace8f8da9e2700")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 NORMAL NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="12")
  inspect(f.glyph().bitmap().rows(), content="15")
  inspect(f.glyph().bitmap().pitch(), content="12")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000003aa3d8d19c2700000000006cfbc2767dd0f35000000026fb9802000008b3ec0f0000a3f00e0000000023fc7d0000d9a7000000000000c8b30003fa85000000000000a7d80007fe80000000000000a1e10000e49f000000000000c0c00000b5dd02000000000ef290000044ff5e0000000080fd24000000a3fa73222987ff80000000000180e6ffffde6900000000000000029af83700000000000000000011ceef8c5763000000000000000d7bcce9d615")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 NORMAL NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000088edecd4200000000000086dd4283eb020000000000d07b0020ff110000000000c47a0081ce00000000000086cb92e42b00000000000047ffd11a0000004b20003deedae517000031ff2813ef9c07ccc0070097c60057ff220020e5bc38fb420050ff22000025e4fbaa000011e8bd1f0644d9f7f47b140036d4fffdf0860c74e970000000192100000000040a")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 NORMAL NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000275d0d6930c00000089eb5d4ec9cf050010fa5e00000ff061003bff210000009dbd0035ff2700000072de000df37f00001fdefb00006bfdafa2dba8f60000003578651889df00000000000000b6ab00000000000021fd44000092601435d5c50000006ef0fffdaf0d0000000001230d00000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 NORMAL NO_HINTING 16ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="16")
  inspect(f.glyph().bitmap().rows(), content="2")
  inspect(f.glyph().bitmap().pitch(), content="16")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="7")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "43e3e3e3e3e3e3e3e3e3e3e3e3e3e351206b6b6b6b6b6b6b6b6b6b6b6b6b6b26")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 LIGHT NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 LIGHT NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="10")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000011bb980000000000000063e1fe1c000000000000b97dd570000000000014fb3188c7000000000066e5013cff1f00000000bd9a0003eb7400000017fc4a00009fcb0000006affc6bfbfdbff220000c1c36b6b6b6cf6780019fd5700000000b1ce006ef80d0000000060ff25c4b4000000000014fc7c")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 LIGHT NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000460aad9c255000079de8059a7ff3a000a06000004f49600000005305de4b5000686e9ce9bddbb00a6db2c0000bbbb04f770000000bebb00eabf171e90fdbb0056f4fff1828ebb00000c2703000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 LIGHT NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000027a4dad5a02d000023f0d48275b9f932008aee0a0000003c00009eea030000000000004fffb02100000000000065f0faa63200000000001885edfc8a0700000000000f8dff7f00000000000000c6c600460e00000000c6b40de4de662d2d8dff500015a5edffffe65f0000000000201a000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 LIGHT NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00004dbedbb8afaf70004efd713598fc7a4700b8af000002e56a0000c69a000000d37f00007ae819003dfc3e000006e7efcdf47800000071b80d330f000000009acd2514130400000029fbfffffffecb2c00af870f1f244df2b21aff2900000000bfa705e9ad2a0a238bf334002aace8f8da9e2700")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 LIGHT NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="12")
  inspect(f.glyph().bitmap().rows(), content="15")
  inspect(f.glyph().bitmap().pitch(), content="12")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000003aa3d8d19c2700000000006cfbc2767dd0f35000000026fb9802000008b3ec0f0000a3f00e0000000023fc7d0000d9a7000000000000c8b30003fa85000000000000a7d80007fe80000000000000a1e10000e49f000000000000c0c00000b5dd02000000000ef290000044ff5e0000000080fd24000000a3fa73222987ff80000000000180e6ffffde6900000000000000029af83700000000000000000011ceef8c5763000000000000000d7bcce9d615")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 LIGHT NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000088edecd4200000000000086dd4283eb020000000000d07b0020ff110000000000c47a0081ce00000000000086cb92e42b00000000000047ffd11a0000004b20003deedae517000031ff2813ef9c07ccc0070097c60057ff220020e5bc38fb420050ff22000025e4fbaa000011e8bd1f0644d9f7f47b140036d4fffdf0860c74e970000000192100000000040a")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 LIGHT NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000275d0d6930c00000089eb5d4ec9cf050010fa5e00000ff061003bff210000009dbd0035ff2700000072de000df37f00001fdefb00006bfdafa2dba8f60000003578651889df00000000000000b6ab00000000000021fd44000092601435d5c50000006ef0fffdaf0d0000000001230d00000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 LIGHT NO_HINTING 16ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="16")
  inspect(f.glyph().bitmap().rows(), content="2")
  inspect(f.glyph().bitmap().pitch(), content="16")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="7")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "43e3e3e3e3e3e3e3e3e3e3e3e3e3e351206b6b6b6b6b6b6b6b6b6b6b6b6b6b26")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 MONO NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 MONO NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 MONO NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 MONO NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  inspect(f.glyph().bitmap().buffer().length(), content="24")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 MONO NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="9")
  inspect(f.glyph().bitmap().buffer().length(), content="26")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 MONO NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="15")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  inspect(f.glyph().bitmap().buffer().length(), content="30")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 MONO NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  inspect(f.glyph().bitmap().buffer().length(), content="24")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 MONO NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 MONO NO_HINTING 16ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="14")
  inspect(f.glyph().bitmap().rows(), content="1")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="7")
  inspect(f.glyph().bitmap().buffer().length(), content="2")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 LCD NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 LCD NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="33")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="36")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="-1")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000114f8fbbbbbb985a1a00000000000000000000000000000000000000000000000000001363b7fae1e1e2fec66e1c0000000000000000000000000000000000000000000000001265b9fad17d5281d5fec4701e000000000000000000000000000000000000000000001464bcfbde8531003488dcfec7731d00000000000000000000000000000000000000001666bafce5923a0100013c90e6ffc9711f0000000000000000000000000000000000001569bdfceb9a460200000003439bebffc87421000000000000000000000000000000001768c0fcf19e4a060000000000044b9fefffcb77200000000000000000000000000000196abefdfff1dbc6bfbfbfbfbfbfbfc6dbf0ffffcd7522000000000000000000000000176dc1fdf4c3936c6b6b6b6b6b6b6b6b6b6c93c6f6ffcc782500000000000000000000196bc3fdf7ab570c00000000000000000000000d5db1f8ffce7a2300000000000000001c6ec2fef8b1590d000000000000000000000000001160b4fbffd179250000000000001a70c4fef9b4600e0000000000000000000000000000001464bcfcffd07c28000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 LCD NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000004163860819aaabbccd9dbd2c2ae885524060000000000000000002679cdf5deba97806e5e59607aa7d6f8ffe18d3a0500000000000000000a1010060000000000000000044ca4f4ffea96420000000000000000000000000000051021303f4e5d7cb3e4ffffb561090000000000000006255486abcee9f1e4cebaaa9b95b7ddffffbb670f00000000001253a6e7f9dba25e2c1002000000000f67bbffffbb670f000000000450a8f7ffc4701c0000000000000000126abeffffbb670f00000000003e96eafff7bf7a32170a0d1e365d90c8edfdffffbb670f0000000000001e569fd9f4fffffffffbf1dbb4824c538edbffbb670f000000000000000000030c1926271c0c030000000000000000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 LCD NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="30")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="32")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000c275180a4bdcddae3e1d5c3b1a0855c2d0d0000000000000000000000022368bdf0ffeed4b49a82706b75869ab9dbf6f9d37f32030000000000000000368adeffeea54d0a00000000000000000009263c3316000000000000000000004a9ef1ffea9a4203000000000000000000000000000000000000000000000000104fa4ebfffbddb078482109000000000000000000000000000000000000000000000e31659cd0f0fffffae9cba6825b321301000000000000000000000000000000000000000418376085aad1edfcfffce9c18a512207000000000000000000000000000000000000000000010f2c5a8dc4edfffdd27f2e000000000000000000000000000000000000000000000000001a72c6ffffc6721a00000000000003244651300e0000000000000000000000001a72c6fffcb4600c00000000000d489de4fdf9deb38566523f2d23232d3f5e8dc4eeffe7a45015000000000000000002153c75a5c6dcedf8fffffffffffff9e6c3935f2e0c00000000000000000000000000000000000005112028261a0e0400000000000000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 LCD NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="30")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="32")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000008234d7ea5becedadbd3c4b8b1afafafafafafaa70360000000000000000134ea1e5fde0ac714b3735406298cff6fcd7a57a6f6c4722000000000000000e64b8fef9af5b0a000000000000023c94e5febe6a18000000000000000000001a72c6ffee9a460000000000000000277fd3ffd37f2b00000000000000000000002a7acefbe8aa5619030000000f3d8ed7fce5923e0400000000000000000000000006429ae7fdfbefe0cfcdd9edf4e1b7783b0e000000000000000000000000002271c5f3b864170d1d2e332d1e0f050000000000000000000000000000000000469aedfccd8b42251a1514131313100a04010000000000000000000000000000052979ccfbfffffffffffffffffffffffef8e5cba2642c07000000000000001c5cafe1cd873a130f171d1f1f20242d3c4d80bef2fffbb25e0a00000000001a6ec6ffd57d29000000000000000000000000136bbffff5a75306000000000005439ae9fce0ad72442a180e0a0d15233a5b8bc2edf3c97b340a0000000000000000092a5789acc7dce8f0f7f8f1e5dacfbb9e794e270d0000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 LCD NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="36")
  inspect(f.glyph().bitmap().rows(), content="15")
  inspect(f.glyph().bitmap().pitch(), content="36")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000001143a698ea3b4c7d8e1dfd1c0ae9c82552709000000000000000000000000000008306cb4e3fbfce3c2a089766b6e7d91acd0eefff3d298501d000000000000000000012675cbfbfdd6984917020000000000000000082767b3e8ffeca74f0f000000000000084fa3eefff0a9510e00000000000000000000000000002373cbfcfed17d2a00000000002d85d9fff8a75302000000000000000000000000000000001c74c8fffeb35f090000000352aafaffd9853100000000000000000000000000000000000253a7f9ffd8842c000000075ab2feffd4802c0000000000000000000000000000000000004da1f4ffe18d35000000003890e4fff39f4b0000000000000000000000000000000000146cc0ffffc06c14000000001161b5f8ffdd8c340200000000000000000000000000000e55adf2ffe4903c000000000000084498e7fff1b15e190100000000000000000000062e80cdfdfdcd74240000000000000000001a54a3dcfbfadeaa734d3522171a293d5a87c0edfff2c780390c00000000000000000000000001184980accbe6f7fffffffffffef3debf9b69350d0000000000000000000000000000000000000000000210489ae0fff8ce83370c0000000000000000000000000000000000000000000000000000000011408ccef4ffefd0a98c796557535a6345220000000000000000000000000000000000000000000d28527b9fbbccd7e3e9e9e2d6a1561500")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 LCD NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000825588eb5cfdee3decdaf7f42160000000000000000000000000000000000000000023386d7fdddab6942364483c2f6eb9a4202000000000000000000000000000000000000247cd0ffcf7b27000000002074ccffbd65110000000000000000000000000000000000001870c4ffce7a260000083381ccf5ce7a2700000000000000000000000000000000000000003286dafecb916e92cdefe4b5672b0600000000000000000000000000000000000000000008479bebfffff7d194481a02000000000000000016314b4f3a2006000000000000123d7ec4eef7dddae2fce5a8511700000000000000003185dcffd47b2800000000001357afefffdc9c491407307fccf7f1c0742a07000000074397e4fdc6721d00000000000757abfbffce76220000000002205cb0e5fdeabc7434387dd1fbe295420b0000000000000450a4f8ffce762200000000000000062560b0e4fdfbfbfbeeaa5610000000000000000000114ea6e8ffecbd7e421f0a03061225446fa9d9f6f8f7f8fff4d8a97b522f140400000000000010366ca7d4f1fefffefdfdfefaf0dbb6864e210c1a4274a2cce9f9c4701e0000000000000000000000030c192528211206000000000000000000000000040f0f0a00000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 LCD NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000002153e75a0bed0dfe1d6c3b093652f0c00000000000000000000063889d6fcebc1885d47444e6795c9f0f4cf813405000000000000105eb6faf6b25e14000000000000000f54acf0f6b5611600000000003b8fe7ffcd752100000000000000000002499deeffbd6912000000003589e1ffd37b27000000000000000000001e72c6ffde8a32000000000d54acf3fdce7f2d050000000000031f56a6defbfffba850000000000001296bbbecfdedd0af9a97a2b9d6dbc196a8d0fff6a24a00000000000000000217355569787e78654f3218063589ddffdf8b3300000000000000000000000000000000000000000f62b6fbf7ab5708000000000000000000000000000000000000002172cafde8984408000000000000164e92ae94603a2114121e355d9bd5f6f5c57124000000000000000010366ea7d4f0fbfffffffffdf3dbaf72320d00000000000000000000000000000001081523261c0d0300000000000000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 LCD NO_HINTING 16ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="48")
  inspect(f.glyph().bitmap().rows(), content="2")
  inspect(f.glyph().bitmap().pitch(), content="48")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="7")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00438edce3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e39c5107002043686b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b4a2603")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 LCD_V NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 LCD_V NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000000000f0b0000000000000004674e0000000000000011bb980000000000000028ffdf0000000000000046f9f40900000000000063e1fe1c0000000000007fbffa360000000000009d99eb54000000000000b97dd570000000000000d564bc8d000000000005ee4aa1aa000000000014fb3188c700000000002cfe1a6fe201000000004af60955f50b0000000066e5013cff1f0000000083cd0022ff3a00000000a1b3000efa5800000000bd9a0003eb7400000000d9800000d59000000006f0640000b9ae00000017fc4a00009fcb00000030ff44131392e50200004eff826b6bb3f70d00006affc6bfbfdbff22000087ffffffffffff3e0000a4e9bfbfbfc0ff5b0000c1c36b6b6b6cf6780000dd9517171718e6940008f27100000000cbb20019fd5700000000b1ce0034ff3c0000000097e80352ff21000000007bf9106ef80d0000000060ff258ae8020000000046ff41a8ce00000000002aff5fc4b4000000000014fc7c8d70000000000005a85d4a3200000000000050320000000000000000000000000000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 LCD_V NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="33")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="10")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000052d16000000001656856e1800000460aad9c255000031b4f9feffa805005ff5d4ade6e8190079de8059a7ff3a0056902c0657ff61002739000019fd81000a06000004f496000000000000e4a100000000000bdbac00000005305de4b50000014384b1f3ba0000349bdcedf3bb000686e9ce9bddbb0027d9d57a47c7bb0066f87f2200bbbb00a6db2c0000bbbb00d1af020000bbbb00e980000000bbbb04f770000000bebb04fd7800000bd3bb03f89300003eeabb00eabf171e90fdbb00cbe36a71d5e1bb009afcc2c9cfb8bb0056f4fff1828ebb0022add3a132577e0002557b4905293d00000c27030000000000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 LCD_V NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="42")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="13")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000082e290200000000015086814c0500000027a4dad5a02d0000006bf0fffff27a030007c1ffd6c9f8cd220023f0d48275b9f932004bff8b2e2165e32f0072fa34000014900f008aee0a0000003c00009be100000000040000a2df000000000000009eea030000000000008ff71d00000000000075ff600000000000004fffb021000000000026f2ea700b0000000009b8ffc852030000000065f0faa632000000001eb4ffef8307000000005cd8ffd739000000001885edfc8a070000000031a8fed621000000000150d8fd4e00000000000f8dff7f0000000000003af5a100000000000009e0b900000000000000c6c600000000000000b6cb000d0000000000b7c500460e00000000c6b40195430000000ae0a10de0981300003af57f0de4de662d2d8dff500babfeba8181d7ef220052ecfed9d9ffb2060015a5edffffe65f0000005199ccc6921b0000000d41746e3a000000000000201a000000000000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 LCD_V NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="45")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="10")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000132f0c0303020000106a87645b5b3a00004dbedbb8afaf700005a0f9e1feffffa30020e8c389dafcc47d004efd713598fc7a47007fec220048fa421100a3ce020014f44b0000b8af000002e56a0000c89c000000d47c0000cd96000000cf830000c69a000000d37f0000b2ac000001e37000009ccb010012f35d00007ae819003dfc3e00004bfa60218bf11f00001decb679d1c705000006e7efcdf4780000001be0b6dfb43200000043d65e875c0400000071b80d330f0000000090a1000000000000009dab000000000000009acd2514130400000081ec7968675621000051fdd1c0bfae77090029fbfffffffecb2c002aecbbcbd0f5fe600066c2637378a1ff9300af870f1f244df2b202e25100000004d8bc0df92f00000000c0b91aff2900000000bfa71dff3600000009d98f11fd6900000038f16305e9ad2a0a238bf33400b9e57e5e77d6c60e006af3d6b6cfe96f00002aace8f8da9e270000065894a4864a010000000c3c4c2e070000000000000000000000000000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 LCD_V NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="12")
  inspect(f.glyph().bitmap().rows(), content="51")
  inspect(f.glyph().bitmap().pitch(), content="12")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="13")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000000000000000000032c2501000000000000000b4f847d48040000000000003aa3d8d19c2700000000000489f4ffffef6f00000000002cd7facad1fdc31b000000006cfbc2767dd0f35000000000b7f971222984fe930000000be8d21e00002fe3cd01000026fb9802000008b3ec0f00004fff570000000079fd2c00007efd280000000047ff580000a3f00e0000000023fc7d0000bcd701000000000bee970000ccba000000000000dba60000d9a7000000000000c8b30000e59b000000000000bdbf0000f190000000000000b2cc0003fa85000000000000a7d80009ff7e0000000000009ee3000bff7b0000000000009ce60007fe80000000000000a1e10002f98a000000000000abd60000ef94000000000000b6cb0000e49f000000000000c0c00000d9ab000000000000ccb50000cbc1000000000001e0a70000b5dd02000000000ef290000096f3110000000028fe7000006cff2e000000004fff47000044ff5e0000000080fd24000020fb9e02000009b9ed0c000009ddd922000034e8c300000000a3fa73222987ff800000000055f9c4767dd2f13b000000001bd2fcced5febe0e000000000180e6ffffde690000000000003294f2f88b24000000000000013ccdf8410000000000000000029af83700000000000000000064ff7900000000000000000032f6c438061000000000000011ceef8c57630000000000000088fee0abb7060000000000003acffffcfe140000000000000d7bcce9d61500000000000000297895820f0000000000000000203d2a01000000000000000000000000000000000000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 LCD_V NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="42")
  inspect(f.glyph().bitmap().pitch(), content="11")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="13")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000000000006322200000000000000003c8a7910000000000000088edecd4200000000000023dce8f98400000000000053f596c4c800000000000086dd4283eb020000000000aab90640fd090000000000c2930025ff120000000000d07b0020ff110000000000d56d002bfb0a0000000000d06e004eed020000000000c47a0081ce000000000000b68e0ebfa0000000000000a1a942ea5f00000000000086cb92e42b00000000000066e8d8a90900000000000046faf1530000000000000047ffd11a0000004b20000073ffba010000059f38000fbdfec102000017f746003deedae517000031ff280082f78efc41000051f71002c9d238f082000073e30213ef9c07ccc0070097c6002bfe650093ea2b00c1a10046ff3e0050fd700ee7730057ff220020e5bc38fb42005fff120005b1ec87f31b005dff11000061fdd1d4050050ff22000025e4fbaa000040ff44000005c1ffab010026fd7d000008c0ffca290011e8bd1f0644d9f7f47b1402c0eb735798f9b0f9cd420075fccbafe7d358c6fe690036d4fffdf0860c74e970000a80c5cd9d3500269a4d00002b6d75450600014226000000192100000000040a0000000000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 LCD_V NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="42")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="13")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000242a010000000000297c823f000000000275d0d6930c0000001dc8f9f5e5390000004cf7b1a2f38700000089eb5d4ec9cf050000bcc40f0482f6180005e58c000038fd3a0010fa5e00000ff061001eff40000001d789002dff2c000000b6a9003bff210000009dbd0042ff1c0000008cc9003fff1e0000007ed40035ff2700000072de0029ff380000007fe9001aff54000003acf4000df37f00001fdefb0003d7b80a0461f6fd0000a9e65b4eb6d6fb00006bfdafa2dba8f6000033ddf8f0b283f200000987ccb9597eea0000003578651889df0000000224130093d000000000000000a1bf00000000000000b6ab00000000000000d3900000000000000bef6b00000000000021fd4400000f00000051fc2100004618000297eb09000092601435d5c5000001cbb46889f883000001b8f3c0dfeb3c0000006ef0fffdaf0d000000269dcfb65b000000000245775e18000000000001230d00000000000000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 LCD_V NO_HINTING 16ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="16")
  inspect(f.glyph().bitmap().rows(), content="9")
  inspect(f.glyph().bitmap().pitch(), content="16")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="8")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000000000000000000000000103737373737373737373737373737142a8f8f8f8f8f8f8f8f8f8f8f8f8f8f3343e3e3e3e3e3e3e3e3e3e3e3e3e3e3514bffffffffffffffffffffffffffff5b38bfbfbfbfbfbfbfbfbfbfbfbfbfbf44206b6b6b6b6b6b6b6b6b6b6b6b6b6b2607171717171717171717171717171708")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 NORMAL DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 NORMAL DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 NORMAL DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 NORMAL DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 NORMAL DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 NORMAL DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 NORMAL DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 NORMAL DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 NORMAL DEFAULT 16ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 LIGHT DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 LIGHT DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 LIGHT DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 LIGHT DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 LIGHT DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 LIGHT DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 LIGHT DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 LIGHT DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 LIGHT DEFAULT 16ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 MONO DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 MONO DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 MONO DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 MONO DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 MONO DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 MONO DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 MONO DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 MONO DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 MONO DEFAULT 16ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 LCD DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 LCD DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 LCD DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 LCD DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 LCD DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 LCD DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 LCD DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 LCD DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 LCD DEFAULT 16ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 LCD_V DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 LCD_V DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 LCD_V DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 LCD_V DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 LCD_V DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 LCD_V DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 LCD_V DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 LCD_V DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 LCD_V DEFAULT 16ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 NORMAL NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 NORMAL NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="22")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="22")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000161636354000000000000000000000000000000000039fffffffd170000000000000000000000000000000090ffffffff6b00000000000000000000000000000001e5ffccf7ffc20000000000000000000000000000003dffff71b5fffe1b000000000000000000000000000094ffff2668ffff700000000000000000000000000002e8ffdb001cffffc70000000000000000000000000041ffff8f0000cfffff1f00000000000000000000000098ffff44000082ffff75000000000000000000000004ebfff306000035ffffcc000000000000000000000045ffffad00000001e7ffff24000000000000000000009cffff62000000009cffff7a00000000000000000005edfffd18000000004fffffd100000000000000000049ffffc4000000000009f5ffff290000000000000000a0ffff72000000000000b0ffff7f0000000000000006f0ffff2200000000000060ffffd6000000000000004efffff9afafafafafafafbdffffff2d000000000000a4ffffffffffffffffffffffffffff84000000000008f2fffff0efefefefefefefeff4ffffdb000000000052ffffdd00000000000000000020ffffff3200000000a8ffff8c00000000000000000000cfffff890000000af4ffff3a000000000000000000007fffffe000000056ffffe702000000000000000000002fffffff370000acffff98000000000000000000000000dfffff8e000cf6ffff460000000000000000000000008fffffe4015afffff0050000000000000000000000003fffffff3cb0ffffa40000000000000000000000000003ecffff93")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 NORMAL NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="16")
  inspect(f.glyph().bitmap().rows(), content="22")
  inspect(f.glyph().bitmap().pitch(), content="16")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="21")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000050000000000000000000001438fd0edfff7d38513000000000263d8ffffffffffffffffec36000000c3ffffffffe0c0c7f7ffffffeb0b00007dfff78b260000000580ffffff7100000a8f1c000000000000009affffe501000000000000000000000031ffffff18000000000000000000000003fcffff3600000000000000000007284df3ffff550000000000115e9cd3fdffffffffff6300000038b1fbffffffffffe6fbffff63000797fffffff6b06d360b00e3ffff6300adfffff67a0e0000000000e3ffff6352fffff43300000000000000e3ffff63afffff9b0000000000000000e3ffff63d3ffff5e0000000000000000e3ffff63c5ffff700000000000000045f7ffff6397ffffcf07000000000881fcffffff6348ffffffce623d4981e1fffbe1ffff63009effffffffffffffffcf317effff6300067af5ffffffffe77904005fffff6300000012426a623d0300000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 NORMAL NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000001e77b1cbd3ba9a4f0900000000000000001089f7fffffffffffffff07607000000000027e7ffffffffffffffffffffffd5210000000addfffffeb14e2a182f63b7ffffffc500000078ffffff5a000000000000003ad7f22a000000d1ffffab0000000000000000000d3800000001f9ffff6d000000000000000000000000000002f6ffff7d000000000000000000000000000000c8ffffc802000000000000000000000000000090ffffff93040000000000000000000000000015eaffffffdb59010000000000000000000000004df9ffffffffd25e06000000000000000000000038e4ffffffffffe87f17000000000000000000000c7aedfffffffffff68a13000000000000000000000b69d8ffffffffffeb3e00000000000000000000000149bdfffffffff94c0000000000000000000000000036caffffffe40c00000000000000000000000000039effffff75000000000000000000000000000007ddffffa80000000000000000000000000000009effffd300000000000000000000000000000088ffffd80000651e0000000000000000000000bcffffb60058fee63d00000000000000000041fbffff6912f2ffffffa52e00000000000258ecffffe20a0043f0ffffffffd69e8184a6dcfffffff84000000024b2ffffffffffffffffffffffd54000000000000040a4f0ffffffffffffe76a040000000000000000000537526c6d592c010000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 NORMAL NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="30")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="21")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000301000000000000000000000000000039a1cef8fbdc9b8b8b8b8b8b8b3d000000129efeffffffffffffffffffffffff6f000001bcfffffba36e7bbbfffffffbf7f7f76c000077ffffe933000000005bfdffc702000000000af5ffff5b00000000000097ffff6f0000000047fffff40100000000000032ffffbd0000000065ffffca0000000000000009fdffee000000005dffffcf000000000000000efffffa0100000037fffff8050000000000003bffffdb0000000001deffff70000000000000afffff9200000000005bfffff349000000027bffffe91700000000000096ffffffb77f8ccfffffff4c0000000000000029f8ffffffffffffffd4400000000000000025e7ffa34fa1c4b48a59040000000000000000b3fff407000000000000000000000000000002f6ffc600000000000000000000000000000000e8fff11f000000000000000000000000000000a7fffff09a77686767675b442d0400000000001bdaffffffffffffffffffffffe787110000000190ffffffffffffffffffffffffffc4080001aaffec381733474747495a7ed8ffffff6f0074ffff4e0000000000000000000bd1ffffa401e9ffed020000000000000000000082ffffc01bffffcb0000000000000000000000a7ffff9911fffffb1400000000000000000032f4ffff3b00c8ffffce1b0000000000000252edffff9b00002ae8fffffbb073594c698bdaffffffa40600000028ceffffffffffffffffffffdf58000000000000003495bfdaf5f6e5c590440200000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 NORMAL NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="24")
  inspect(f.glyph().bitmap().rows(), content="34")
  inspect(f.glyph().bitmap().pitch(), content="24")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000002678abc5d4bda25f12000000000000000000000000002cbefffffffffffffffffb9311000000000000000000006efcffffffffffffffffffffffea3600000000000000007afffffffdab5228183068cafffffff33e00000000000045ffffffe13b000000000000016afaffffe713000000000de3ffffe82300000000000000000056fdffffa7000000006effffff4e000000000000000000000097fffffe26000001d9ffffbf00000000000000000000000013f5ffff91000030ffffff5a00000000000000000000000000a4ffffe600006bfffffc0b0000000000000000000000000051ffffff2100a4ffffd300000000000000000000000000001dffffff5a00c0ffffa8000000000000000000000000000000f1ffff7600d2ffff96000000000000000000000000000000dfffff8800e3ffff88000000000000000000000000000000d1ffff9a00dbffff8f000000000000000000000000000000d8ffff9200cbffff9e000000000000000000000000000000e7ffff8100b6ffffba000000000000000000000000000007fbffff6c0086ffffea000000000000000000000000000034ffffff3b0051ffffff270000000000000000000000000071fffffc0b000ff7ffff8100000000000000000000000000cbffffba000000a6ffffe50b00000000000000000000003affffff5c00000037feffff870000000000000000000004cbffffe10800000000a1fffffe570000000000000000009dffffff57000000000013dafffffb7e04000000000017b1ffffffa10000000000000023e6ffffffe79064536ca7f7ffffffb906000000000000000018bffffffffffffffffffffffe8c03000000000000000000000150c5fefffffffffff6aa2d000000000000000000000000000000115bfdffff9f08000000000000000000000000000000000000009afffff72f0000000000000000000000000000000000000015eefffff0560000000000000000000000000000000000000034ebffffffd075462c314e4c0000000000000000000000000029e0ffffffffffffffffcf00000000000000000000000000000767defffffffffffffe1300000000000000000000000000000003365a7e998a733602")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 NORMAL NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="23")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="23")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000035f98c9bd912f00000000000000000000000000000025c7fffffffffffa76000000000000000000000000000adfffffd08a96f1fffe3800000000000000000000000089ffff9d03000034feffb2000000000000000000000000e4ffed0e00000000c5ffdf000000000000000000000012ffffb50000000000b1fffa00000000000000000000002dffffa20000000000e3ffdd00000000000000000000000bfeffc40000000055ffff8d000000000000000000000000e3ffed02000029ecffe611000000000000000000000000aeffff48003cedfffd4c000000000000000000000000004bffffae7afbfffb5a000000000000000000000000000003e2fffffffff04a00000000000000000000000000000001aeffffffcc2200000000000000001f37371c00000012b3ffffffff60000000000000000000c8ffff45000017d7fffff8fffff52c0000000000000027ffffe1020011d4ffffe32ea4ffffd90d00000000000086ffff82000092ffffec25000bd5ffffac000000000002e2fffe220025fbffff4f00000029f4ffff8f0000000061ffffbe000069ffffce00000000005affffff9a020010eafffd36000096ffff9500000000000077ffffffa50495ffff97000000abffff990000000000000076ffffffbffdffea1100000090ffffcc000000000000000075ffffffffff5f000000004dfffffe4400000000000000008efffffffe700300000005ceffffe63100000000000477f7ffffffffffce3b00000028f5fffffd9d5b333d73d4ffffffc1c8ffffffffce5f000050ebfffffffffffffffffffb89040165edffffffa00000001196fbfffffffffff0a025000000001483e3ff4e00000000000e4967715b3d050000000000000000024708")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 NORMAL NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000252a3c9d1b67a220000000000000000002bcffffffffffffffc8a080000000000002eefffffffdebee5ffffffba070000000001c7ffffd62800000150e9ffff9e0000000064ffffe01000000000002cf2ffff3d000000e3ffff650000000000000075ffffbb00002afffffa06000000000000000cf5fffd1c0051ffffda000000000000000000adffff6a0066ffffba00000000000000000080ffff9c005effffc700000000000000000056ffffce004affffe70000000000000000002dffffe60017ffffff2b000000000000000080fffff50000c6ffffa60000000000000060ffffffff030039ffffff89020000000c8dfffafffffb000000a5ffffffdaa17e9feffff561ffffec0000000aabffffffffffffffd33232ffffde000000000042a2ddf3e6ba5c060048ffffc9000000000000000000000000000073ffff9a0000000000000000000000000000a3ffff690000000000000000000000000002e7ffff340000000000000000000000000041ffffdc0000000000000000000000000000baffff7f000000000f06000000000000005afffff11700000007c3ce25000000000055f8ffff6f000000009cfffff4995b4b68bbffffffae030000000020c6ffffffffffffffffffae060000000000000481eeffffffffffd85b00000000000000000000053f5f715b300000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 NORMAL NO_HINTING 36ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="34")
  inspect(f.glyph().bitmap().rows(), content="4")
  inspect(f.glyph().bitmap().pitch(), content="34")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="16")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "3783838383838383838383838383838383838383838383838383838383838383834a6bffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8f6bffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8f2f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f3e")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 LIGHT NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 LIGHT NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="22")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="22")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000161636354000000000000000000000000000000000039fffffffd170000000000000000000000000000000090ffffffff6b00000000000000000000000000000001e5ffccf7ffc20000000000000000000000000000003dffff71b5fffe1b000000000000000000000000000094ffff2668ffff700000000000000000000000000002e8ffdb001cffffc70000000000000000000000000041ffff8f0000cfffff1f00000000000000000000000098ffff44000082ffff75000000000000000000000004ebfff306000035ffffcc000000000000000000000045ffffad00000001e7ffff24000000000000000000009cffff62000000009cffff7a00000000000000000005edfffd18000000004fffffd100000000000000000049ffffc4000000000009f5ffff290000000000000000a0ffff72000000000000b0ffff7f0000000000000006f0ffff2200000000000060ffffd6000000000000004efffff9afafafafafafafbdffffff2d000000000000a4ffffffffffffffffffffffffffff84000000000008f2fffff0efefefefefefefeff4ffffdb000000000052ffffdd00000000000000000020ffffff3200000000a8ffff8c00000000000000000000cfffff890000000af4ffff3a000000000000000000007fffffe000000056ffffe702000000000000000000002fffffff370000acffff98000000000000000000000000dfffff8e000cf6ffff460000000000000000000000008fffffe4015afffff0050000000000000000000000003fffffff3cb0ffffa40000000000000000000000000003ecffff93")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 LIGHT NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="16")
  inspect(f.glyph().bitmap().rows(), content="22")
  inspect(f.glyph().bitmap().pitch(), content="16")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="21")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000050000000000000000000001438fd0edfff7d38513000000000263d8ffffffffffffffffec36000000c3ffffffffe0c0c7f7ffffffeb0b00007dfff78b260000000580ffffff7100000a8f1c000000000000009affffe501000000000000000000000031ffffff18000000000000000000000003fcffff3600000000000000000007284df3ffff550000000000115e9cd3fdffffffffff6300000038b1fbffffffffffe6fbffff63000797fffffff6b06d360b00e3ffff6300adfffff67a0e0000000000e3ffff6352fffff43300000000000000e3ffff63afffff9b0000000000000000e3ffff63d3ffff5e0000000000000000e3ffff63c5ffff700000000000000045f7ffff6397ffffcf07000000000881fcffffff6348ffffffce623d4981e1fffbe1ffff63009effffffffffffffffcf317effff6300067af5ffffffffe77904005fffff6300000012426a623d0300000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 LIGHT NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000001e77b1cbd3ba9a4f0900000000000000001089f7fffffffffffffff07607000000000027e7ffffffffffffffffffffffd5210000000addfffffeb14e2a182f63b7ffffffc500000078ffffff5a000000000000003ad7f22a000000d1ffffab0000000000000000000d3800000001f9ffff6d000000000000000000000000000002f6ffff7d000000000000000000000000000000c8ffffc802000000000000000000000000000090ffffff93040000000000000000000000000015eaffffffdb59010000000000000000000000004df9ffffffffd25e06000000000000000000000038e4ffffffffffe87f17000000000000000000000c7aedfffffffffff68a13000000000000000000000b69d8ffffffffffeb3e00000000000000000000000149bdfffffffff94c0000000000000000000000000036caffffffe40c00000000000000000000000000039effffff75000000000000000000000000000007ddffffa80000000000000000000000000000009effffd300000000000000000000000000000088ffffd80000651e0000000000000000000000bcffffb60058fee63d00000000000000000041fbffff6912f2ffffffa52e00000000000258ecffffe20a0043f0ffffffffd69e8184a6dcfffffff84000000024b2ffffffffffffffffffffffd54000000000000040a4f0ffffffffffffe76a040000000000000000000537526c6d592c010000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 LIGHT NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="30")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="21")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000301000000000000000000000000000039a1cef8fbdc9b8b8b8b8b8b8b3d000000129efeffffffffffffffffffffffff6f000001bcfffffba36e7bbbfffffffbf7f7f76c000077ffffe933000000005bfdffc702000000000af5ffff5b00000000000097ffff6f0000000047fffff40100000000000032ffffbd0000000065ffffca0000000000000009fdffee000000005dffffcf000000000000000efffffa0100000037fffff8050000000000003bffffdb0000000001deffff70000000000000afffff9200000000005bfffff349000000027bffffe91700000000000096ffffffb77f8ccfffffff4c0000000000000029f8ffffffffffffffd4400000000000000025e7ffa34fa1c4b48a59040000000000000000b3fff407000000000000000000000000000002f6ffc600000000000000000000000000000000e8fff11f000000000000000000000000000000a7fffff09a77686767675b442d0400000000001bdaffffffffffffffffffffffe787110000000190ffffffffffffffffffffffffffc4080001aaffec381733474747495a7ed8ffffff6f0074ffff4e0000000000000000000bd1ffffa401e9ffed020000000000000000000082ffffc01bffffcb0000000000000000000000a7ffff9911fffffb1400000000000000000032f4ffff3b00c8ffffce1b0000000000000252edffff9b00002ae8fffffbb073594c698bdaffffffa40600000028ceffffffffffffffffffffdf58000000000000003495bfdaf5f6e5c590440200000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 LIGHT NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="24")
  inspect(f.glyph().bitmap().rows(), content="34")
  inspect(f.glyph().bitmap().pitch(), content="24")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000002678abc5d4bda25f12000000000000000000000000002cbefffffffffffffffffb9311000000000000000000006efcffffffffffffffffffffffea3600000000000000007afffffffdab5228183068cafffffff33e00000000000045ffffffe13b000000000000016afaffffe713000000000de3ffffe82300000000000000000056fdffffa7000000006effffff4e000000000000000000000097fffffe26000001d9ffffbf00000000000000000000000013f5ffff91000030ffffff5a00000000000000000000000000a4ffffe600006bfffffc0b0000000000000000000000000051ffffff2100a4ffffd300000000000000000000000000001dffffff5a00c0ffffa8000000000000000000000000000000f1ffff7600d2ffff96000000000000000000000000000000dfffff8800e3ffff88000000000000000000000000000000d1ffff9a00dbffff8f000000000000000000000000000000d8ffff9200cbffff9e000000000000000000000000000000e7ffff8100b6ffffba000000000000000000000000000007fbffff6c0086ffffea000000000000000000000000000034ffffff3b0051ffffff270000000000000000000000000071fffffc0b000ff7ffff8100000000000000000000000000cbffffba000000a6ffffe50b00000000000000000000003affffff5c00000037feffff870000000000000000000004cbffffe10800000000a1fffffe570000000000000000009dffffff57000000000013dafffffb7e04000000000017b1ffffffa10000000000000023e6ffffffe79064536ca7f7ffffffb906000000000000000018bffffffffffffffffffffffe8c03000000000000000000000150c5fefffffffffff6aa2d000000000000000000000000000000115bfdffff9f08000000000000000000000000000000000000009afffff72f0000000000000000000000000000000000000015eefffff0560000000000000000000000000000000000000034ebffffffd075462c314e4c0000000000000000000000000029e0ffffffffffffffffcf00000000000000000000000000000767defffffffffffffe1300000000000000000000000000000003365a7e998a733602")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 LIGHT NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="23")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="23")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000035f98c9bd912f00000000000000000000000000000025c7fffffffffffa76000000000000000000000000000adfffffd08a96f1fffe3800000000000000000000000089ffff9d03000034feffb2000000000000000000000000e4ffed0e00000000c5ffdf000000000000000000000012ffffb50000000000b1fffa00000000000000000000002dffffa20000000000e3ffdd00000000000000000000000bfeffc40000000055ffff8d000000000000000000000000e3ffed02000029ecffe611000000000000000000000000aeffff48003cedfffd4c000000000000000000000000004bffffae7afbfffb5a000000000000000000000000000003e2fffffffff04a00000000000000000000000000000001aeffffffcc2200000000000000001f37371c00000012b3ffffffff60000000000000000000c8ffff45000017d7fffff8fffff52c0000000000000027ffffe1020011d4ffffe32ea4ffffd90d00000000000086ffff82000092ffffec25000bd5ffffac000000000002e2fffe220025fbffff4f00000029f4ffff8f0000000061ffffbe000069ffffce00000000005affffff9a020010eafffd36000096ffff9500000000000077ffffffa50495ffff97000000abffff990000000000000076ffffffbffdffea1100000090ffffcc000000000000000075ffffffffff5f000000004dfffffe4400000000000000008efffffffe700300000005ceffffe63100000000000477f7ffffffffffce3b00000028f5fffffd9d5b333d73d4ffffffc1c8ffffffffce5f000050ebfffffffffffffffffffb89040165edffffffa00000001196fbfffffffffff0a025000000001483e3ff4e00000000000e4967715b3d050000000000000000024708")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 LIGHT NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000252a3c9d1b67a220000000000000000002bcffffffffffffffc8a080000000000002eefffffffdebee5ffffffba070000000001c7ffffd62800000150e9ffff9e0000000064ffffe01000000000002cf2ffff3d000000e3ffff650000000000000075ffffbb00002afffffa06000000000000000cf5fffd1c0051ffffda000000000000000000adffff6a0066ffffba00000000000000000080ffff9c005effffc700000000000000000056ffffce004affffe70000000000000000002dffffe60017ffffff2b000000000000000080fffff50000c6ffffa60000000000000060ffffffff030039ffffff89020000000c8dfffafffffb000000a5ffffffdaa17e9feffff561ffffec0000000aabffffffffffffffd33232ffffde000000000042a2ddf3e6ba5c060048ffffc9000000000000000000000000000073ffff9a0000000000000000000000000000a3ffff690000000000000000000000000002e7ffff340000000000000000000000000041ffffdc0000000000000000000000000000baffff7f000000000f06000000000000005afffff11700000007c3ce25000000000055f8ffff6f000000009cfffff4995b4b68bbffffffae030000000020c6ffffffffffffffffffae060000000000000481eeffffffffffd85b00000000000000000000053f5f715b300000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 LIGHT NO_HINTING 36ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="34")
  inspect(f.glyph().bitmap().rows(), content="4")
  inspect(f.glyph().bitmap().pitch(), content="34")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="16")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "3783838383838383838383838383838383838383838383838383838383838383834a6bffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8f6bffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8f2f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f3e")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 MONO NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 MONO NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="22")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="26")
  inspect(f.glyph().bitmap().buffer().length(), content="104")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 MONO NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="15")
  inspect(f.glyph().bitmap().rows(), content="20")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="20")
  inspect(f.glyph().bitmap().buffer().length(), content="40")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 MONO NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="18")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="27")
  inspect(f.glyph().bitmap().buffer().length(), content="108")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 MONO NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="18")
  inspect(f.glyph().bitmap().rows(), content="29")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="20")
  inspect(f.glyph().bitmap().buffer().length(), content="116")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 MONO NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="23")
  inspect(f.glyph().bitmap().rows(), content="34")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="27")
  inspect(f.glyph().bitmap().buffer().length(), content="136")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 MONO NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="23")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  inspect(f.glyph().bitmap().buffer().length(), content="108")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 MONO NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="16")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="27")
  inspect(f.glyph().bitmap().buffer().length(), content="54")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 MONO NO_HINTING 36ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="33")
  inspect(f.glyph().bitmap().rows(), content="3")
  inspect(f.glyph().bitmap().pitch(), content="6")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="16")
  inspect(f.glyph().bitmap().buffer().length(), content="18")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 LCD NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 LCD NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="72")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="72")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="-1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000000000000000000011f42616363636363636363543311000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001398de3fffffffffffffffffffdc06817000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000013c90e2fffffffffffffffffffffffdbf6b1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000013a92e5fffffffffdccc3c6f7fffffffffdc26e190000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000023d91e6ffffffffffc5712d61b5fafffffffffec56d1b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000024094e5ffffffffffd27a26001668bcfdfffffffffec4701e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000023f97e8ffffffffffdb872f0000001c6fc7fffffffffffec7731d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000034195eaffffffffffe38f3b0000000000237bcfffffffffffffca721f000000000000000000000000000000000000000000000000000000000000000000000000000000000000034498e8ffffffffffed9844030000000000002e82d6ffffffffffffc975220000000000000000000000000000000000000000000000000000000000000000000000000000000004439bebfffffffffff3a54d0600000000000000003589e1ffffffffffffcc78210000000000000000000000000000000000000000000000000000000000000000000000000000044599ecfffffffffff7ad590a000000000000000000013d95e7ffffffffffffcf772400000000000000000000000000000000000000000000000000000000000000000000000004489cebfffffffffffcb66212000000000000000000000003489cedffffffffffffce7a270000000000000000000000000000000000000000000000000000000000000000000005479fedfffffffffffdc1691800000000000000000000000000074fa3f3ffffffffffffd17d26000000000000000000000000000000000000000000000000000000000000000006499deffffffffffffec4701a0000000000000000000000000000000953abf5ffffffffffffd47c29000000000000000000000000000000000000000000000000000000000000054ca0eeffffffffffffc6722000000000000000000000000000000000000c5cb0f8ffffffffffffd37f2b00000000000000000000000000000000000000000000000000000000064ba3f0ffffffffffffcd7522000000000000000000000000000000000000001160b4fbffffffffffffd6822a0000000000000000000000000000000000000000000000000000084ea2f1fffffffffffff9dfc4afafafafafafafafafafafafafafafafafafafafafbdd8f3ffffffffffffffd9812d0000000000000000000000000000000000000000000000000750a4f1ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd8843000000000000000000000000000000000000000000000084fa7f2fffffffffffffbf5f0efefefefefefefefefefefefefefefefefefefefefefefefefeff4f9ffffffffffffffdb872f00000000000000000000000000000000000000000952a6f4ffffffffffffdd89310000000000000000000000000000000000000000000000000000002073cbffffffffffffffde86320000000000000000000000000000000000000954a8f3ffffffffffffe08c380000000000000000000000000000000000000000000000000000000000237bcfffffffffffffffdd8935000000000000000000000000000000000a53abf4ffffffffffffe58e3a010000000000000000000000000000000000000000000000000000000000002b7fd3ffffffffffffffe08c3400000000000000000000000000000b56aaf6ffffffffffffe7953d0200000000000000000000000000000000000000000000000000000000000000002f83dbffffffffffffffe28b370100000000000000000000000b58acf5ffffffffffffe998440200000000000000000000000000000000000000000000000000000000000000000000338bdfffffffffffffffe18e3a010000000000000000000c57aff6ffffffffffffee9a46040000000000000000000000000000000000000000000000000000000000000000000000003b8fe3ffffffffffffffe4913901000000000000000e5aaef7fffffffffffff0a1490500000000000000000000000000000000000000000000000000000000000000000000000000023f93e9ffffffffffffffe6903c0200000000000d5cb0f7fffffffffffff1a4500600000000000000000000000000000000000000000000000000000000000000000000000000000003439becffffffffffffffe5933f020000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 LCD NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="51")
  inspect(f.glyph().bitmap().rows(), content="22")
  inspect(f.glyph().bitmap().pitch(), content="52")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="21")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000000000000000305050200000000000000000000000000000000000000000000000000000000000000000000010e26435c768fa8bfd0dbe4edf6fcfffffcf7efe4d3bba185613413020000000000000000000000000000000000021437638cb3d8f1fefffffffffffffffffffffffffffffffffffffffffffffffdecc179360d0000000000000000000000002871c3eefefffffffffffffffffffffbefe0d3c9c0b9bcc7d8ebf7feffffffffffffffffffffeba34b0b00000000000000000000022c7dcffcfffffff7e0b88b644126110300000000000000000005164280c3eefffffffffffffffcc6712200000000000000000000000a3e748f70411c06000000000000000000000000000000000000000008469ae6ffffffffffffffe5933b010000000000000000000000000000000000000000000000000000000000000000000000000000013185dcffffffffffffffc46c180000000000000000000000000000000000000000000000000000000000000000000000000000000354acfcffffffffffffe28a3600000000000000000000000000000000000000000000000000000000000000000107111c2834414d7fbdf3fffffffffffffca9550400000000000000000000000000000000000000041128445e768a9caec1d3e5f4fdffffffffffffffffffffffffffffffffb7630f0000000000000000000000000418385f8bb1d3edfbfffffffffffffffffffffffffffffffaf2e6e5eefbffffffffffffffb7630f000000000000000007245997cff3fffffffffffffffffff6e5cbb097806d5b483626170b040000378fe3ffffffffffffffb7630f0000000000001a5aade7fffffffffffffff6d9aa7a50290e010000000000000000000000000000378fe3ffffffffffffffb7630f000000000c52a6f1fffffffffffff4c87c330c0000000000000000000000000000000000000000378fe3ffffffffffffffb7630f000000095baff9ffffffffffffee9b470200000000000000000000000000000000000000000000378fe3ffffffffffffffb7630f000000277fd3fffffffffffffeb25e0b0000000000000000000000000000000000000000000000378fe3ffffffffffffffb7630f0000001971c5ffffffffffffffc4701c00000000000000000000000000000000000000000218458ed0f7ffffffffffffffb7630f000000004397ebfffffffffffff9cf833207000000000000000000000000000008204c81b9e5fcffffffffffffffffffffb7630f000000000d489be6fffffffffffffffeedcea47d6250453d3b40495568819fc2e1f6fffffffffbe6dde1f7ffffffffffffb7630f0000000000000f4a9ee2fffffffffffffffffffffffffffffffffffffffffffffffff0cf9e6431102b7ed2ffffffffffffb7630f0000000000000000061d477aacdaf5fffffffffffffffffffffffffff8e7cca679451b04000000000b5fb3ffffffffffffb7630f0000000000000000000000000006122334424f5d6a6f6c62574c3d2610030000000000000000000000000000000000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 LCD NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="60")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="60")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000071e3f60778ca1b1bdc4cbd3d5d3ccc3bab1a89a856a4f341a090000000000000000000000000000000000000000000000000000000001102e5b89b7e0f7fffffffffffffffffffffffffffffffffffffffffffffef0d3a576471e0700000000000000000000000000000000000000062765b4e7fdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff6d59d542105000000000000000000000000000a3e94ddfefffffffffffffffef2d7b188654e40352a1f18181e272f3a4c637d98b7d9f3fffffffffffffffffac5711f00000000000000000000002678ccfdffffffffffffffe7ab5a1e020000000000000000000000000000000000000004173a6aa5d7f6fff2c26f2a050000000000000000000000257dd1fffffffffffffff5ab570a0000000000000000000000000000000000000000000000000000000d3046381500000000000000000000000000014ea6f9ffffffffffffffc16d1900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000024ca4f6ffffffffffffffd17d2900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001c74c8fffffffffffffffdc8762002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003c90e3fffffffffffffffffad4934a180400000000000000000000000000000000000000000000000000000000000000000000000000000000000000001554abeafffffffffffffffffffff4dbb385592f100100000000000000000000000000000000000000000000000000000000000000000000000000000000154d9adcf9fffffffffffffffffffffffffeeed2ab835e39190600000000000000000000000000000000000000000000000000000000000000000000000000113873b6e4fcfffffffffffffffffffffffffffffffae8caa37f5a341705000000000000000000000000000000000000000000000000000000000000000000000c264f7aa5d0edfdfffffffffffffffffffffffffffffffff6deb58a5e311302000000000000000000000000000000000000000000000000000000000000000000000b2144698eb4d8f1fefffffffffffffffffffffffffffffeebc17d3e1300000000000000000000000000000000000000000000000000000000000000000000000000010d26496e96bde0f7fffffffffffffffffffffffff9dd9a4c1500000000000000000000000000000000000000000000000000000000000000000000000000000000000417366397caedfeffffffffffffffffffe49c450c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000318509eddfdfffffffffffffffec9752300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000073991ddfffffffffffffff9a8540300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000014a9ef1ffffffffffffffd37f2700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003488dcffffffffffffffd8842c0000000000000008326577511e0400000000000000000000000000000000000000000000000000000000000000001168bcfefffffffffffffcb6620e00000000011d58a9e6fefffde6b8773d170300000000000000000000000000000000000000000000000000000f4191d9fbfffffffffffffdbd6918000000001259b1f2fffffffffffffffffff1d2a5774e2e1505000000000000000000000000000000021130588ac3ecffffffffffffffffe298410a00000000000001164386c8f0fffffffffffffffffffffffffbedd6bdaa9e958b817c7d848f9ba6b2c3dcf1fefffffffffffffffffff8d38c401000000000000000000000000009244f83b2dbf6fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff2d5aa7640180100000000000000000000000000000000000000051c406789a4bfdbf0fcfffffffffffffffffffffffffffffffffffff9e7c7996a3b1704000000000000000000000000000000000000000000000000000000000000000005132737414a525b646c72726d6760594f402c18090100000000000000000000000000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 LCD NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="60")
  inspect(f.glyph().bitmap().rows(), content="30")
  inspect(f.glyph().bitmap().pitch(), content="60")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="21")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000000000003040401000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021639668ba1b0bfceddecf8fefefbf5ebdcc8ae9b8f8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b6b3d0f0000000000000000000000000012356b9eceeffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc36f1b0000000000000000000001206abcf0fffffffffffffffbe5c4a38f7e6e686d7b8b9ebbdcf7fffffffffffffffffefbf8f7f7f7f7f7f7f7f7f7bd6c1b0000000000000000042b77c6f7ffffffffffffe9b870331100000000000000000000000a285ba3ddfdfffffffff7c775260200000000000000000000000000000000000a54acf5ffffffffffffefaf5b1700000000000000000000000000000000000a4497e0fffffffffff7c36f2300000000000000000000000000000000479bf2fffffffffffff4a24a0100000000000000000000000000000000000000003286deffffffffffffbd691200000000000000000000000000001165b9ffffffffffffffca761e000000000000000000000000000000000000000000095bb3fdffffffffffee9a4200000000000000000000000000000a5db1ffffffffffffffcf7b230000000000000000000000000000000000000000000e61b9fffffffffffffaa64e010000000000000000000000000000378be3fffffffffffff8a9510500000000000000000000000000000000000000003b8fe6ffffffffffffdb872f00000000000000000000000000000001338bdefffffffffffff8c370240100000000000000000000000000000000155bafedffffffffffffe5923e010000000000000000000000000000000000195bafeefffffffffffff3cb8c491e0400000000000000000002153e7bbcebffffffffffffe9ac5417000000000000000000000000000000000000000000154a96d5f8fffffffffffffff0d5b7a08e7f787d8c9db1cfeafdffffffffffffffe49f4c12000000000000000000000000000000000000000000000000062976c7f8fffffffffffffffffffffffffffffffffffffffffffff2d4a772401a040000000000000000000000000000000000000000000000042561b4e7fefffffddfa362434f6e8ba1afbac4c7c1b4a6988a7b6d593a1904000000000000000000000000000000000000000000000000000000125fb3f4fffffffff4a74f070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000024ca4f6ffffffffffc6721a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003d95e8fffffffffff1ba651f0200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000653a7f4fffffffffffffdf0d8b59a897f77706a6867676767676767676766625b544b443c342d20100400000000000000000000000000000000000000021b50a0dafafffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff9e7caa887613311000000000000000000000000000001144090d1fdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1c4782e080000000000000000011d5caae2fcffffffecc07838150d17202a333c43474747474747474748494d535a606c7e98b7d8f1fffffffffffffffffec36f1c0000000000002874c8f8ffffffffe9a24e11000000000000000000000000000000000000000000000000000000000b3288d1fdfffffffffffff5a45003000000013f97e9ffffffffffed9c4402000000000000000000000000000000000000000000000000000000000000002e82d6ffffffffffffffc06c140000001b6fc7ffffffffffffcb771f000000000000000000000000000000000000000000000000000000000000000753a7f4ffffffffffffed9945000000001165bdfffffffffffffbbb6414000000000000000000000000000000000000000000000000000000000b327ac7f4ffffffffffffe38f3b0400000000001f74c8fdfffffffffffff4ce8f491b060000000000000000000000000000000000000002102b5286c2edfffffffffffffedf9b480f0000000000000000072a68b6e8fefffffffffffffffbecd0b0947f736a6159514b4c535d69747f8b9cb8daf2fefffffffffffffffadba45c230600000000000000000000000000072860a1ceeafbfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff5dfb989582b0d00000000000000000000000000000000000000000000061834567995aab6bfc8d1dae3ecf5fafaf6f0ebe5ded3c5b3a1907c6244250e0200000000000000000000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 LCD NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="75")
  inspect(f.glyph().bitmap().rows(), content="34")
  inspect(f.glyph().bitmap().pitch(), content="76")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000000031026405c788fa1abb4bcc5cdd4d4cfc6bdb5aca2927b5f45281205000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2c598dbee3fafffffffffffffffffffffffffffffffffffffffffffffffffbe8c3936231110100000000000000000000000000000000000000000000000000000000000000000009306eb4e6fcfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdeabe77360e0000000000000000000000000000000000000000000000000000000b367ac2effffffffffffffffffffdeccfab8c6c523f31281f18181d27303c4f6887a7cae8fcfffffffffffffffffff3cc853e11000000000000000000000000000000000000000000000e4598e1fffffffffffffffffce1b2723b15020000000000000000000000000000000000000111356aa8dcfaffffffffffffffffe7a74f130000000000000000000000000000000000000d459ce3ffffffffffffffffe8b36023040000000000000000000000000000000000000000000000000000021d56a6e2fdffffffffffffffe9a753120000000000000000000000000000001d6ec2fcffffffffffffffeaa24e1000000000000000000000000000000000000000000000000000000000000000000a4497e1fffffffffffffffed07826000000000000000000000000012f87d9fffffffffffffff9bf6b19000000000000000000000000000000000000000000000000000000000000000000000000135cb4f5ffffffffffffffe1913d03000000000000000000003084dcfffffffffffffff7ae5a0f00000000000000000000000000000000000000000000000000000000000000000000000000000850a4efffffffffffffffe6923a000000000000000000176bbffffffffffffffffcb35b0b000000000000000000000000000000000000000000000000000000000000000000000000000000000551a5f7ffffffffffffffcd7521000000000000000250a4f5ffffffffffffffd37f270000000000000000000000000000000000000000000000000000000000000000000000000000000000001d71c9fffffffffffffffcae5a0a000000000000146cc0fffffffffffffffaa8540200000000000000000000000000000000000000000000000000000000000000000000000000000000000000459df1ffffffffffffffca7622000000000000267ed2ffffffffffffffea96420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000338bdfffffffffffffffdc8834000000000000378fe3ffffffffffffffdc88340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000257dd1ffffffffffffffee9a460000000000002f87dbffffffffffffffe38f3b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000002c84d8ffffffffffffffe6923e0000000000001f77cbfffffffffffffff29e4a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000003b93e7ffffffffffffffd5812d0000000000000b62b6feffffffffffffffba660e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000757affbffffffffffffffc06c18000000000000003286daffffffffffffffea963e0000000000000000000000000000000000000000000000000000000000000000000000000000000000003488e0ffffffffffffffe88f3b00000000000000000551a5f7ffffffffffffffd37b27000000000000000000000000000000000000000000000000000000000000000000000000000000001d71c5fffffffffffffffcb45c0b0000000000000000000f5ab2f7ffffffffffffffd5812d00000000000000000000000000000000000000000000000000000000000000000000000000002077cbfefffffffffffffaba661400000000000000000000000952a6f1ffffffffffffffe59d450b00000000000000000000000000000000000000000000000000000000000000000000073a8edefffffffffffffff8b05c100000000000000000000000000006378adcfefffffffffffffdd487350600000000000000000000000000000000000000000000000000000000000004297bcbfaffffffffffffffe1963e08000000000000000000000000000000000d4da1e7fffffffffffffffee4a7571d0100000000000000000000000000000000000000000000000000164e9ddcfcffffffffffffffefab5714000000000000000000000000000000000000000013479adafbfffffffffffffffbe5b87e461b040000000000000000000000000000000003173d77b1def9fffffffffffffffddfa15016000000000000000000000000000000000000000000000000042361b2e6fdfffffffffffffffffff9e7ccac907c6e645a545359636c798da7c6e5f7fffffffffffffffffffee8b96d2a06000000000000000000000000000000000000000000000000000000000002184282bfe8fdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeeec68c4b1b03000000000000000000000000000000000000000000000000000000000000000000000000010e2a5078a1c5e3f6fefffffffffffffffffffffffffffffffffef6e7ccaa82562d1001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000051124395b9ad7fdffffffffffffffe29f531908000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a469ae3fffffffffffffff7cb7a2f0700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001557afeefffffffffffffffff0cd935625070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d3474beebfffffffffffffffffffaead0b191755f50463d342c292b3137414e5f6c4c2600000000000000000000000000000000000000000000000000000000000000000000000000000000000000082964ade0f9ffffffffffffffffffffffffffffffffffffffffffffffffffcf7b2300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000071c3f678fb9def5fffffffffffffffffffffffffffffffffffffffebd651300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003112436424e5a66727e8a959998918a847d73634d361e0c020000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 LCD NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="75")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="76")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000003173b5f778898a8b9c9cfcbbdaf9f917d592f0f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008255490c7ebfefffffffffffffffffffffffffffffffae4b976380b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a3e95dffefffffffffffeebd0b19b8a828796b1d5f1fffffffffffedb8a3807000000000000000000000000000000000000000000000000000000000000000000000000000000000000053689d7fdfffffffffed99d4e1b03000000000000000a3486d4fefffffffffbb25e0b00000000000000000000000000000000000000000000000000000000000000000000000000000000003890e4ffffffffffeda74f0e0000000000000000000000001971c5ffffffffffdf8b33000000000000000000000000000000000000000000000000000000000000000000000000000000001266befffffffffffeb5610b00000000000000000000000000065db1fefffffffffaa74f000000000000000000000000000000000000000000000000000000000000000000000000000000002d81d9fffffffffff6a24e0000000000000000000000000000378fe3ffffffffffdd8931000000000000000000000000000000000000000000000000000000000000000000000000000000000b5eb6feffffffffffc4701800000000000000000000001655a9eaffffffffffe08d3a010000000000000000000000000000000000000000000000000000000000000000000000000000000000378fe3ffffffffffed9b43020000000000000008296ab9ecffffffffffe6a44d11000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c5aaef6ffffffffffed9c4807000001133c7dc2edfffffffffffde49e4c1200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000094b9feefffffffffff3ae6d4c7ab6e4fbfffffffffffbdea45a230400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000033991e2fffffffffffffffffffffffffffff0cc8e4a1a010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001125caef1fffffffffffffffffff0cc945222070000000000000000000000000000000000000000000000000c1f313737373737372e1c090000000000000000000000000000000001123874b3e1fbffffffffffffffffffffefb3601c00000000000000000000000000000000000000000000000000001e74c8feffffffffffeb9945060000000000000000000000000001174999d7f8fffffffffffffff8f8f8fffffffffffff5c7742c0500000000000000000000000000000000000000000000277bd3ffffffffffffe18f3702000000000000000000000000114191d4f8fffffffffffffce3b3692e2051a4e3fffffffffffffcd9923f0d000000000000000000000000000000000000003286d9ffffffffffffd6822e000000000000000000000000073e92deffffffffffffffecb9652504000000000b3a8dd5fbffffffffffffe7ac5a19000000000000000000000000000000023991e2fffffffffffecc74220000000000000000000000002575cdfbffffffffffffeba34f0f000000000000000000042971c4f4fffffffffffff6cf8f461400000000000000000000001a61b5f2fffffffffffabe6a180000000000000000000000001569bdffffffffffffffce7b2300000000000000000000000000001b5aadeafffffffffffffff8d69a4f1a020000000000104fa7eafffffffffffdd9873606000000000000000000000000004296eaffffffffffffe9954100000000000000000000000000000000000b3477c0effffffffffffffffbdda5592004094195dfffffffffffffe197440a00000000000000000000000000000157abfcffffffffffffed994500000000000000000000000000000000000000000a3376bfeefffffffffffffffde3bfbfd9fdffffffffffeaa74f1100000000000000000000000000000000003c90e4ffffffffffffffcc7820000000000000000000000000000000000000000000000a3375beeefffffffffffffffffffffffffff2b45f1a00000000000000000000000000000000000000074da1f2fffffffffffffedf96440f00000000000000000000000000000000000000000000000a3c8ed7fefffffffffffffffffffee1af703c1603000000000000000000000000000000000000052e7fcef8ffffffffffffffe6b26a31110100000000000000000000000000000004194377addcf7fffffffffffffffffffffffffffffffeefce9d693b1805000000000000000000000000000000032871c6f5fffffffffffffffffdebc79d7e695b4d3e3330343d495c738eb0d4f0fffffffffffffffffee9c1a0a2c8ebfdfffffffffffffffffffffaeacead8a5f310c0000000000000000000000011f5091c8ebfdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffbe8c0894c1b0400000112356598cbedfdffffffffffffffffffefa04c050000000000000000000000000000000111326496c5e9fbfffffffffffffffffffffffffffffffffcf0dcc0a07a4d250b0000000000000000000000000214345f83a3c5e3f6fffff3a24e0800000000000000000000000000000000000000000000030e2037495760676e72716b635b534a3d2a13050000000000000000000000000000000000000000000000000000020f2747432b080000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 LCD NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000021330526f8ba3b5c0c9d2d4d1c8beb6a9947a5d3e220d0100000000000000000000000000000000000000000000000000000000092b5f9ecfeefefffffffffffffffffffffffffffffffffffffce8bf8a532408000000000000000000000000000000000000000000042e71c4effffffffffffffffffffbf0decbbfbec7d4e5f5ffffffffffffffffffebba6e2a0700000000000000000000000000000000012475c7f8fffffffffffff7d69f5a280c02000000000000010d265085c1e9fdfffffffffffee49e4b0e000000000000000000000000001c64b8f3ffffffffffffe09c451000000000000000000000000000000000072c72c3f2ffffffffffffdf903d0900000000000000000000378fe3fffffffffffff7b9651a0000000000000000000000000000000000000000002675c8fbfffffffffffabb671400000000000000002a7ed6fffffffffffffaac540600000000000000000000000000000000000000000000000c55adf5fffffffffffdc66e1c0000000000000151a5fcffffffffffffda862e000000000000000000000000000000000000000000000000000859adf9ffffffffffffbe6a1600000000001266baffffffffffffffba660e00000000000000000000000000000000000000000000000000002c80d4fffffffffffff09c4801000000000a5eb2ffffffffffffffc7731b00000000000000000000000000000000000000000000000000000656aafcffffffffffffce7a2200000000004a9ef6ffffffffffffe7933b0000000000000000000000000000000000000000000000000000002d81d9ffffffffffffe6923a0000000000176bc3ffffffffffffffd57f2b010000000000000000000000000000000000000000000000093580caf6fffffffffffff5a1490000000000002072c6f9ffffffffffffeda6520c00000000000000000000000000000000000000062460ade7ffffffffffffffffffffaf570300000000000007398cddffffffffffffffefc68948190200000000000000000000010c25548dc8effffffffafafafffffffffffffba74f0000000000000000000f51a5eafffffffffffffffffdeedac4b2a190827e84909fb5d5effdfffffffff5d08b6186cbffffffffffffec984000000000000000000000000a2c68abddf8fffffffffffffffffffffffffffffffffffffffff3d3a2673210003286deffffffffffffde8a32000000000000000000000000000000071e426989a2bacfdde6eef3f5f0e6dacdbaa07e5c3919060000000000489cf3ffffffffffffc9751d000000000000000000000000000000000000000000000000000000000000000000000000000000000000001f73c7ffffffffffffee9a4600000000000000000000000000000000000000000000000000000000000000000000000000000000000000024fa3f5ffffffffffffbd6916000000000000000000000000000000000000000000000000000000000000000000000000000000000000023e96e7ffffffffffffe08834000000000000000000000000000000000000000000000000000000000000000000000000000000000000044195e9ffffffffffffdc88300000000000000000000000000000000000000000000000000000000000000000000000000000000000001966baf5ffffffffffffd47f2c0000000000000000000000000000000f161606000000000000000000000000000000000000000000011c5aace9fffffffffffff1b45c1700000000000000000000000000072d77c3f1f1ce97572508000000000000000000000000000008245599d4f8fffffffffffff8c26f23000000000000000000000000000d499ce3fefffffffffffff4dcb9997f695b514b4b505a687d9abbdcf5fffffffffffffffee4ae5f210300000000000000000000000000000006204e8dc6ecfefffffffffffffffffffffffffffffffffffffffffffffffffff9dfae67290600000000000000000000000000000000000000000000041b4981b1d6eefbfffffffffffffffffffffffffffffcefd8b88c5b2b0b000000000000000000000000000000000000000000000000000000000000000005132a3f4d565f676f716d645b524430180600000000000000000000000000000000000000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 LCD NO_HINTING 36ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="102")
  inspect(f.glyph().bitmap().rows(), content="4")
  inspect(f.glyph().bitmap().pitch(), content="104")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="16")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0c3762838383838383838383838383838383838383838383838383838383838383838383838383838383838383838383838383838383838383838383838383838383838383838383838383838383838383838383838383838383838383838383838383754a1e0000176bbfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe38f3b0000176bbfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe38f3b00000a2f536f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f633e1a0000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 LCD_V NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 LCD_V NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="22")
  inspect(f.glyph().bitmap().rows(), content="84")
  inspect(f.glyph().bitmap().pitch(), content="22")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000e0f0f0c0000000000000000000000000000000000016163635400000000000000000000000000000000000ab5b7b7a500000000000000000000000000000000001efefffff1070000000000000000000000000000000039fffffffd170000000000000000000000000000000056ffffffff310000000000000000000000000000000073ffffffff4f0000000000000000000000000000000090ffffffff6b00000000000000000000000000000000acffffffff8800000000000000000000000000000000caffe9ffffa600000000000000000000000000000001e5ffccf7ffc20000000000000000000000000000000cf6ffa5e7ffde00000000000000000000000000000021ffff8acefff30900000000000000000000000000003dffff71b5fffe1b00000000000000000000000000005affff599cffff36000000000000000000000000000077ffff3f81ffff54000000000000000000000000000094ffff2668ffff700000000000000000000000000000b0fffc124fffff8d0000000000000000000000000000ceffef0435ffffab0000000000000000000000000002e8ffdb001cffffc7000000000000000000000000000ef8ffc2000af7ffe30100000000000000000000000025ffffa80001e6fff60c00000000000000000000000041ffff8f0000cfffff1f0000000000000000000000005effff770000b6ffff3b0000000000000000000000007bffff5d00009bffff5900000000000000000000000098ffff44000082ffff75000000000000000000000000b4ffff2b000069ffff92000000000000000000000000d2fffd1400004fffffb0000000000000000000000004ebfff306000035ffffcc000000000000000000000011faffe00000001dffffe7020000000000000000000029ffffc60000000af7fff80f0000000000000000000045ffffad00000001e7ffff240000000000000000000062ffff9500000000d0ffff400000000000000000000080ffff7b00000000b5ffff5e000000000000000000009cffff62000000009cffff7a00000000000000000000b8ffff4a0000000083ffff9700000000000000000000d6ffff2f0000000068ffffb500000000000000000005edfffd18000000004fffffd100000000000000000013fbfff3080000000035ffffea0300000000000000002dffffde00000000001bfefffa12000000000000000049ffffc4000000000009f5ffff29000000000000000066ffffa9000000000001e4ffff45000000000000000084ffff8d000000000000caffff630000000000000000a0ffff72000000000000b0ffff7f0000000000000000bdffff5800000000000096ffff9c0000000000000000daffff3c0000000000007affffba0000000000000006f0ffff2200000000000060ffffd60000000000000016fcfff9120303030303034affffee0500000000000031fffff95e5b5b5b5b5b5b80fffffc150000000000004efffff9afafafafafafafbdffffff2d0000000000006affffffffffffffffffffffffffff4a00000000000088ffffffffffffffffffffffffffff68000000000000a4ffffffffffffffffffffffffffff84000000000000c1ffffffffffffffffffffffffffffa1000000000000deffffffffffffffffffffffffffffbf000000000008f2fffff0efefefefefefefeff4ffffdb000000000019fdfffd9c9b9b9b9b9b9b9b9bb3fffff1070000000035fffff144434343434343434366fffffd190000000052ffffdd00000000000000000020ffffff32000000006effffc20000000000000000000cf8ffff4f000000008cffffa600000000000000000001e7ffff6d00000000a8ffff8c00000000000000000000cfffff8900000000c5ffff7100000000000000000000b5ffffa600000001e1ffff550000000000000000000099ffffc40000000af4ffff3a000000000000000000007fffffe00000001cfeffff210000000000000000000065fffff309000039fffff80c0000000000000000000049fffffe1d000056ffffe702000000000000000000002fffffff37000072ffffce000000000000000000000017fdffff54000090ffffb2000000000000000000000007f2ffff720000acffff98000000000000000000000000dfffff8e0000c9ffff7d000000000000000000000000c5ffffab0001e5ffff61000000000000000000000000a9ffffc9000cf6ffff460000000000000000000000008fffffe40120ffffff2c00000000000000000000000075fffff60c3dfffffc140000000000000000000000005affffff215afffff0050000000000000000000000003fffffff3c76ffffda0000000000000000000000000025ffffff5994ffffbe0000000000000000000000000010faffff77b0ffffa40000000000000000000000000003ecffff9380abab65000000000000000000000000000098abab6d4353532c00000000000000000000000000004653533a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 LCD_V NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="16")
  inspect(f.glyph().bitmap().rows(), content="66")
  inspect(f.glyph().bitmap().pitch(), content="16")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="21")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000000000005000000000000000000000000002441584b27000000000000000000033b7c99b0a37f310000000000000001438fd0edfff7d385130000000000002f97e3ffffffffffd95300000000001985ecffffffffffffffab0d0000000263d8ffffffffffffffffec360000002ab7ffffffffffffffffffff790000007df6ffffffffffffffffffffc0000000c3ffffffffe0c0c7f7ffffffeb0b0000d4ffffffd28c6c73a8f5fffffc230000acffffda7a34141b50c9ffffff4900007dfff78b260000000580ffffff7100004effc037000000000037ecffff99000023e0680400000000000ac8ffffc400000a8f1c000000000000009affffe50100003b000000000000000074fffff906000002000000000000000051ffffff0f000000000000000000000031ffffff18000000000000000000000019ffffff22000000000000000000000009ffffff2d000000000000000000000003fcffff36000000000000000000000000f7ffff40000000000000000000000002f0ffff4b00000000000000000007284df3ffff55000000000000000127587ca1f9ffff5d00000000000010487fb0d4f7ffffff620000000000115e9cd3fdffffffffff63000000001160b2efffffffffffffff63000000045db8faffffffffffffffff6300000038b1fbffffffffffe6fbffff6300000f8bf4ffffffffe2b792f1ffff63000046dffffffff7c18a5f3ae8ffff63000797fffffff6b06d360b00e3ffff63002addfffffdb15c19000000e3ffff630066fdffffcc590c00000000e3ffff6300adfffff67a0e0000000000e3ffff6310deffffca28000000000000e3ffff632cfaffff7e01000000000000e3ffff6352fffff43300000000000000e3ffff6375ffffdb0c00000000000000e3ffff6397ffffb90000000000000000e3ffff63afffff9b0000000000000000e3ffff63bfffff850000000000000000e3ffff63caffff6e0000000000000000e3ffff63d3ffff5e0000000000000000e3ffff63d7ffff590000000000000000e4ffff63d2ffff610000000000000011eeffff63c5ffff700000000000000045f7ffff63b6ffff830000000000000595ffffff63a6ffffa600000000000030dcffffff6397ffffcf07000000000881fcffffff6388fffff12e000000003dcfffffffff636effffff820f00002d95fcffffffff6348ffffffce623d4981e1fffbe1ffff6320f2fffffcb6919dd5ffffd3baffff6306d1fffffffee9f5fffffa818effff63009effffffffffffffffcf317effff63005dfbfffffffffffffa800574ffff630027ccffffffffffffcc2e0069ffff6300067af5ffffffffe77904005fffff6300002bb4eeffffe9962b00003cabab430000025c96beb6913e0100001c53532000000012426a623d03000000000000000000000000160e000000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 LCD_V NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="87")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="28")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000091f270e0000000000000000000000000000235d777f66460800000000000000000000001e77b1cbd3ba9a4f09000000000000000000046acbfcffffffeea34d01000000000000000036c2fffffffffffff3a527000000000000001089f7fffffffffffffff076070000000000004dd9ffffffffffffffffffc937000000000007a3fffffffffffffffffffffb89030000000027e7ffffffffffffffffffffffd5210000000061fefffffff6d6c4dbfcfffffff96000000000aafffffff2a27e6c83b7f9ffffffad0000000addfffffeb14e2a182f63b7ffffffc500000025f7ffffe05d030000001263deffffa700000050ffffffa6120000000000128dfbff6000000078ffffff5a000000000000003ad7f22a00000099ffffee24000000000000000690cd09000000b8ffffcf0600000000000000003e7e00000000d1ffffab0000000000000000000d3800000000e4ffff92000000000000000000000900000000f1ffff7e000000000000000000000000000001f9ffff6d000000000000000000000000000003feffff66000000000000000000000000000004fdffff6c000000000000000000000000000002f6ffff7d000000000000000000000000000000e9ffff90000000000000000000000000000000d8ffffa7000000000000000000000000000000c8ffffc8020000000000000000000000000000b7ffffe5190000000000000000000000000000a6fffffc4a000000000000000000000000000090ffffff9304000000000000000000000000006bffffffd034000000000000000000000000003afdfffff78b1300000000000000000000000015eaffffffdb5901000000000000000000000002c5ffffffffad2a0000000000000000000000008bfffffffff17f1300000000000000000000004df9ffffffffd25e06000000000000000000001ed2fffffffffdb242000000000000000000000285fefffffffff69a2c0000000000000000000038e4ffffffffffe87f170000000000000000000a9dfdffffffffffd3610400000000000000000046cdffffffffffffb9370000000000000000000c7aedfffffffffff68a1300000000000000000029a4faffffffffffda53000000000000000000004cbdffffffffffffab0e0000000000000000000b69d8ffffffffffeb3e000000000000000000001a85ecffffffffff8b02000000000000000000002e9df8ffffffffd41f000000000000000000000149bdfffffffff94c00000000000000000000000969deffffffff88000000000000000000000000198af8ffffffbe0000000000000000000000000036caffffffe40c000000000000000000000000047af9fffffa27000000000000000000000000002ad5ffffff5300000000000000000000000000039effffff75000000000000000000000000000059ffffff8c000000000000000000000000000024f2ffff9a000000000000000000000000000007ddffffa8000000000000000000000000000000c3ffffb6000000000000000000000000000000afffffc40000000000000000000000000000009effffd30000000000000000000000000000008effffdd00000000000000000000000000000085ffffdf00000000000000000000000000000088ffffd800000000000000000000000000000097ffffcf000024020000000000000000000000aaffffc60000651e0000000000000000000000bcffffb60005b75a0000000000000000000001d4ffffa10023ebaf0a00000000000000000016ebffff850058fee63d00000000000000000041fbffff69009ffffe900f000000000000000080ffffff480fd9ffffde510000000000000013c2fffff92412f2ffffffa52e00000000000258ecffffe20a12d7ffffffea822a0000000232acfeffffba000291ffffffffda824a2d30528af2ffffff7d000043f0ffffffffd69e8184a6dcfffffff840000011befffffffffff2d5d8f8ffffffffd71400000068f1fffffffffffffffffffffffd8c0000000024b2ffffffffffffffffffffffd54000000000015ee3fffffffffffffffffff7860d00000000001593f1ffffffffffffffffbe300000000000000040a4f0ffffffffffffe76a04000000000000000850a1e3fcffffffd8941e00000000000000000006498ba6c0c1ad803c00000000000000000000000537526c6d592c01000000000000000000000000000218190600000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 LCD_V NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="93")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="21")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000000000000030100000000000000000000000000000001224e503001000000000000000000000000074d7aa6a8884737373737373718000000000039a1cef8fbdc9b8b8b8b8b8b8b3d000000000d8bf4ffffffffeddfdfdfdfdfdf61000000004adcffffffffffffffffffffffff6f000000129efeffffffffffffffffffffffff6f0000003ce5ffffffffffffffffffffffffff6f0000007efffffff2c2cff9ffffffffffffff6f000001bcfffffba36e7bbbfffffffbf7f7f76c000014e6ffffd44f1a2767ecffffd7a3a3a34700003dfcfffd8305000015adffffc44b4b4b21000077ffffe933000000005bfdffc7020000000000afffffc507000000001aedffeb160000000001ddffff8f000000000002c9fffe3e000000000af5ffff5b00000000000097ffff6f000000001bfeffff2d00000000000069ffff940000000034fffffc0e00000000000047ffffad0000000047fffff40100000000000032ffffbd0000000053ffffe70000000000000024ffffcd000000005cffffd80000000000000015ffffde0000000065ffffca0000000000000009fdffee0000000069ffffc30000000000000002fcfff90100000066ffffc50000000000000004fcfffd010000005dffffcf000000000000000efffffa0100000053ffffde000000000000001cfffff20000000047ffffee000000000000002bffffea0000000037fffff8050000000000003bffffdb0000000021fefffe1800000000000055ffffc7000000000cf3ffff3f0000000000007dffffad0000000001deffff70000000000000afffff920000000000bcffffa4000000000008dbffff6d00000000008effffd5110000000030f7fffd3d00000000005bfffff349000000027bffffe91700000000002af8ffff9c0f000026c7ffffc20200000000000bd5ffffe3632b387ef7ffff860000000000000096ffffffb77f8ccfffffff4c000000000000004bfafffffcd3e0ffffffe11f000000000000001df8fffffffffffffffc94050000000000000029f8ffffffffffffffd440000000000000000064fefaf2fffffffff9850a0000000000000006b4ffdba3f3fffedead30000000000000000025e7ffa34fa1c4b48a5904000000000000000052feff5c094d7060360c00000000000000000089fffd230001180a0000000000000000000000b3fff407000000000000000000000000000000d2ffe300000000000000000000000000000000eaffce00000000000000000000000000000002f6ffc600000000000000000000000000000002fcffca00000000000000000000000000000002f7ffe004000000000000000000000000000000e8fff11f000000000000000000000000000000d3fffe64030000000000000000000000000000bdffffb7462314131313080000000000000000a7fffff09a77686767675b442d04000000000082ffffffebcbbcbbbbbbaf98813f01000000004bfafffffffffffffffffff0d99733000000001bdaffffffffffffffffffffffe7871100000002a2ffffffffffffffffffffffffdb3b0000000079ffffffffffffffffffffffffff810000000190ffffffffffffffffffffffffffc40800001fc8ffd8c3dff3f3f3f5ffffffffffed2500005cf7ff8c6b879b9b9b9daed2ffffffff4c0001aaffec381733474747495a7ed8ffffff6f0017e1ffc40b000000000000062a90ffffff810041fbff8500000000000000000038eeffff930074ffff4e0000000000000000000bd1ffffa400a2ffff2500000000000000000000adffffb600cbfffa0d0000000000000000000092ffffc001e9ffed020000000000000000000082ffffc006faffd9000000000000000000000081ffffb610ffffca00000000000000000000008fffffaa1bffffcb0000000000000000000000a7ffff991fffffda0000000000000000000000c1ffff801bffffef030000000000000000000bdfffff5e11fffffb1400000000000000000032f4ffff3b08f9ffff4200000000000000000074fffff31b02e7ffff8c00000000000000000ec0ffffd10700c8ffffce1b0000000000000252edffff9b00009efffff56a0e000000000031a6fffffd59000060feffffc25c1f0700153788f0ffffe02400002ae8fffffbb073594c698bdaffffffa406000007b6fffffff5c7ada0bddfffffffef530000000066fefffffffffff7ffffffffffac180000000028ceffffffffffffffffffffdf580000000000077adfffffffffffffffffeb8d150000000000002488e8ffffffffffffe4983500000000000000003495bfdaf5f6e5c5904402000000000000000001416b86a1a291713c050000000000000000000000132e494a3918000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 LCD_V NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="24")
  inspect(f.glyph().bitmap().rows(), content="105")
  inspect(f.glyph().bitmap().pitch(), content="24")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="28")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000031928110000000000000000000000000000000000000024577180694e11000000000000000000000000000000002678abc5d4bda25f1200000000000000000000000000001c79ccfcfffffff6b36208000000000000000000000000036ad1fffffffffffffbba400000000000000000000000002cbefffffffffffffffffb931100000000000000000000067cf5ffffffffffffffffffdf4f000000000000000000002cd1ffffffffffffffffffffffa70c0000000000000000006efcffffffffffffffffffffffea3600000000000000000bbbfffffffff5d4c4dcfcffffffff7d000000000000000036edfffffff3a67c6c84bcfdffffffc811000000000000007afffffffdab5228183068cafffffff33e00000000000004c2ffffffdb57080000001878f4ffffff7e0000000000001beefffffd8d0b000000000022bdffffffc001000000000045ffffffe13b000000000000016afaffffe71300000000007effffffab0a0000000000000022dcfffffc380000000000b9fffffe5b000000000000000001a1ffffff70000000000de3ffffe82300000000000000000056fdffffa70000000025faffffbe0500000000000000000020ecffffd5010000004affffff830000000000000000000003c8fffff20d0000006effffff4e000000000000000000000097fffffe2600000091fffff824000000000000000000000065ffffff47000000b7ffffe109000000000000000000000034ffffff6d000001d9ffffbf00000000000000000000000013f5ffff9100000af1ffff9a00000000000000000000000002e1ffffb200001bfeffff7900000000000000000000000000c3ffffd0000030ffffff5a00000000000000000000000000a4ffffe6000043ffffff3b0000000000000000000000000085fffff5040057ffffff1e0000000000000000000000000068fffffe0f006bfffffc0b0000000000000000000000000051ffffff21007efffff302000000000000000000000000003fffffff340092ffffe300000000000000000000000000002dffffff4800a4ffffd300000000000000000000000000001dffffff5a00b1ffffc200000000000000000000000000000efeffff6800baffffb3000000000000000000000000000004f8ffff7100c0ffffa8000000000000000000000000000000f1ffff7600c6ffffa0000000000000000000000000000000e9ffff7c00ccffff9b000000000000000000000000000000e4ffff8200d2ffff96000000000000000000000000000000dfffff8800d8ffff90000000000000000000000000000000daffff8e00deffff8b000000000000000000000000000000d4ffff9500e3ffff88000000000000000000000000000000d1ffff9a00e3ffff87000000000000000000000000000000d0ffff9b00e0ffff8a000000000000000000000000000000d3ffff9800dbffff8f000000000000000000000000000000d8ffff9200d6ffff94000000000000000000000000000000ddffff8c00d0ffff99000000000000000000000000000000e2ffff8700cbffff9e000000000000000000000000000000e7ffff8100c5ffffa4000000000000000000000000000000edffff7c00bfffffad000000000000000000000000000001f5ffff7600b6ffffba000000000000000000000000000007fbffff6c00a8ffffc9000000000000000000000000000014ffffff5e0097ffffda000000000000000000000000000024ffffff4c0086ffffea000000000000000000000000000034ffffff3b0074fffff7040000000000000000000000000045ffffff2a0062fffffe110000000000000000000000000059ffffff190051ffffff270000000000000000000000000071fffffc0b003dffffff43000000000000000000000000008dfffff0020024ffffff6300000000000000000000000000adffffd900000ff7ffff8100000000000000000000000000cbffffba000002e4ffffa000000000000000000000000003e6ffff9b000000c6ffffc600000000000000000000000017f8ffff7b000000a6ffffe50b00000000000000000000003affffff5c00000087fffffa2600000000000000000000006affffff3c00000061ffffff5300000000000000000000009cfffff81d00000037feffff870000000000000000000004cbffffe10800000016f0ffffbe040000000000000000001fecffffb90000000002cfffffe82200000000000000000055feffff870000000000a1fffffe570000000000000000009dffffff5700000000006effffffa2050000000000000019d7fffff82a000000000037f9ffffdc30000000000000005ef8ffffd80d000000000013dafffffb7e04000000000017b1ffffffa100000000000001a4ffffffcd40010000000962ecffffff5b0000000000000059fefffffa983c10011853baffffffeb230000000000000023e6ffffffe79064536ca7f7ffffffb9060000000000000006aaffffffffe3b8a7c0f2fffffffb6a00000000000000000054f1fffffffffffdffffffffffd42500000000000000000018bffffffffffffffffffffffe8c03000000000000000000006defffffffffffffffffffd53d000000000000000000000023a4fcfffffffffffffff07f0b00000000000000000000000150c5fefffffffffff6aa2d000000000000000000000000000d71bcf4ffffffeeab560200000000000000000000000000001d64adffffffbb530d00000000000000000000000000000000115bfdffff9f0800000000000000000000000000000000000012ecffffa70000000000000000000000000000000000000001c9ffffdb0c000000000000000000000000000000000000009afffff72f0000000000000000000000000000000000000069ffffff730000000000000000000000000000000000000037feffffbe1800000000000000000000000000000000000015eefffff05600000000000000000000000000000000000003c3ffffffaa2500000000000000000000000000000000000077ffffffe97c21000000041600000000000000000000000034ebffffffd075462c314e4c0000000000000000000000000bbaffffffffc99a8085a28a0000000000000000000000000069fefffffffff3d8ddf6ba0000000000000000000000000029e0ffffffffffffffffcf000000000000000000000000000694f9ffffffffffffffe500000000000000000000000000003ebbfffffffffffffff506000000000000000000000000000767defffffffffffffe1300000000000000000000000000001a8de2feffffffffe115000000000000000000000000000000368aaed2eddec78a0f00000000000000000000000000000003365a7e998a7336020000000000000000000000000000000000082a45361f0000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 LCD_V NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="23")
  inspect(f.glyph().bitmap().rows(), content="87")
  inspect(f.glyph().bitmap().pitch(), content="23")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="28")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001d1200000000000000000000000000000000000000124475693d0500000000000000000000000000000000035f98c9bd912f0000000000000000000000000000000027b3ecffffe57e0500000000000000000000000000000276f8ffffffffd132000000000000000000000000000025c7fffffffffffa76000000000000000000000000000060f6ffffffffffffc20200000000000000000000000000adffffffdeeaffffed150000000000000000000000000adfffffd08a96f1fffe3800000000000000000000000025f8fffb803642c3ffff6a00000000000000000000000054ffffd528000078ffff9500000000000000000000000089ffff9d03000034feffb2000000000000000000000000b3ffff5b0000000ff0ffc3000000000000000000000000d2fffc2a00000001dbffd1000000000000000000000000e4ffed0e00000000c5ffdf000000000000000000000001f2ffd90100000000b6ffee000000000000000000000007fbffc30000000000aefff8000000000000000000000012ffffb50000000000b1fffa000000000000000000000020ffffa90000000000bdfff500000000000000000000002bffffa20000000000d0ffeb00000000000000000000002dffffa20000000000e3ffdd000000000000000000000025ffffab0000000008f3ffc9000000000000000000000017ffffb80000000026fdffac00000000000000000000000bfeffc40000000055ffff8d000000000000000000000003f9ffd0000000008fffff65000000000000000000000000f0ffde00000006c8fffc34000000000000000000000000e3ffed02000029ecffe611000000000000000000000000d6fff80f00006bfeffbf01000000000000000000000000c5ffff28000dbcffff8500000000000000000000000000aeffff48003cedfffd4c0000000000000000000000000090ffff69058cffffe420000000000000000000000000006dffff8b2ed6ffffa905000000000000000000000000004bffffae7afbfffb5a00000000000000000000000000002affffd4c9ffffdb1f000000000000000000000000000010f6fff1f8ffff9902000000000000000000000000000003e2fffffffff04a00000000000000000000000000000000c4ffffffffbc1600000000000000000000000000000000a5fffffff7670000000000000000000000000000000001aeffffffcc2200000000000000001f37371c000000001ccdffffff86020000000000000000568b8b3d000000005ff5ffffff550000000000000000009be3e35500000012b3ffffffff60000000000000000000c8ffff4500000045ecffffffff9b000000000000000002e4ffff2600000195ffffffffffd40b0000000000000010f7fff50e000017d7fffff8fffff52c0000000000000027ffffe102000048f8ffffcbf7ffff620000000000000046ffffc300000096fffffe7bd8ffffa50000000000000067ffffa2000011d4ffffe32ea4ffffd90d00000000000086ffff82000031f7ffffad0764fffff730000000000000a5ffff62000062ffffff5e002cf5ffff6c000000000000c5ffff40000092ffffec25000bd5ffffac000000000002e2fffe220000c2ffffc2060000a1ffffdd120000000011f6fff40c000de7ffff860000005efffffa440000000033ffffde010025fbffff4f00000029f4ffff8f0000000061ffffbe000042fffffb250000000ad3ffffd11600000094ffff9600005affffe80a000000009afffff74c000001c7ffff66000069ffffce00000000005affffff9a020010eafffd36000078ffffb5000000000027efffffd81c0030fcffed14000087ffffa4000000000008c0fffffa560062ffffc902000096ffff9500000000000077ffffffa50495ffff97000000a4ffff8c00000000000034efffffdf23c6ffff64000000abffff8d0000000000000bc0fffffd70eafffc32000000abffff990000000000000076ffffffbffdffea11000000a3ffffaa0000000000000033eefffff4ffffc6010000009bffffbb000000000000000abfffffffffff920000000090ffffcc000000000000000075ffffffffff5f000000007fffffe1030000000000000032eefffffffe310000000067fffff31a000000000000000abefffffffe32000000004dfffffe4400000000000000008efffffffe700300000031ffffff7f000000000000000296ffffffffc12b00000016f0ffffbc040000000000002ac6fffffffff77d07000005ceffffe63100000000000477f7ffffffffffce3b00000098fffffc8209000000002ec9fffffffffffffa8f23000059ffffffd5490900002084f9fffff2f8ffffffe07a190028f5fffffd9d5b333d73d4ffffffc1c8ffffffffce5f000ad7ffffffe7af8791c7fefffffb7176f4fffffffe9c00009afffffffffddfe9ffffffffd42625b9ffffffffba000050ebfffffffffffffffffffb89040165edffffffa000001aa8ffffffffffffffffffcb3a00001dadffffff8500000050e0ffffffffffffffed740800000055d6ffff690000001196fbfffffffffff0a025000000001483e3ff4e0000000042b6f3ffffffe9a24c0100000000002f91ec3300000000095e9dbbc5af914a0700000000000000399b1900000000000e4967715b3d05000000000000000002470800000000000001131d0700000000000000000000000600")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 LCD_V NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="18")
  inspect(f.glyph().bitmap().rows(), content="87")
  inspect(f.glyph().bitmap().pitch(), content="18")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="28")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000000000000000000000000000000000000000000041d250a000000000000000000000000000a4f757d622600000000000000000000000252a3c9d1b67a22000000000000000000002aa6f3ffffffce72070000000000000000067df4ffffffffffca3800000000000000002bcffffffffffffffc8a08000000000000006efbffffffffffffffd72d0000000000000dbffffffffffffffffffd700000000000002eefffffffdebee5ffffffba0700000000005effffffd18a6a93ebffffe928000000000096fffffa7c32123ba4ffffff5f0000000001c7ffffd62800000150e9ffff9e0000000011eaffff920300000011b7ffffd00300000033fdfff74000000000006afffff11800000064ffffe01000000000002cf2ffff3d00000096ffffbc0000000000000ad4ffff6c000000c2ffff8f00000000000000a5ffff98000000e3ffff650000000000000075ffffbb000006f5ffff3c000000000000004affffd9000015feffff190000000000000023fefff109002afffffa06000000000000000cf5fffd1c003cfffff1000000000000000001e1ffff390049ffffe5000000000000000000c5ffff540051ffffda000000000000000000adffff6a0058ffffce0000000000000000009bffff7a0060ffffc20000000000000000008dffff8c0066ffffba00000000000000000080ffff9c0067ffffb800000000000000000072ffffad0064ffffbd00000000000000000064ffffbe005effffc700000000000000000056ffffce0059ffffd200000000000000000049ffffd90053ffffdc0000000000000000003bffffe1004affffe70000000000000000002dffffe6003dfffff20100000000000000002cffffeb002afffffa10000000000000000049fffff00017ffffff2b000000000000000080fffff50009faffff520000000000000006c1fffffa0001e7ffff7c0000000000000024edfffffe0200c6ffffa60000000000000060ffffffff03009affffd00b00000000000baeffffffff030068ffffef3b00000000003de7fffffffe010039ffffff89020000000c8dfffafffffb000016f1ffffd2310200024fd5ffdcfffff6000003d3fffffa894d2a4ba7fcffa2fffff1000000a5ffffffdaa17e9feffff561ffffec00000068fffffffff3d2f0ffffcd38ffffe70000002fe7fffffffffffffffb7c2cffffe20000000aabffffffffffffffd33232ffffde0000000058e5fffffffffff7860638ffffd9000000001896f1fffffffcb032003fffffd3000000000042a2ddf3e6ba5c060048ffffc90000000000094e899f926611000054ffffbb0000000000000531473a1200000063ffffaa000000000000000000000000000073ffff9a000000000000000000000000000083ffff8a000000000000000000000000000093ffff790000000000000000000000000000a3ffff690000000000000000000000000000b6ffff590000000000000000000000000000ceffff480000000000000000000000000002e7ffff34000000000000000000000000000ef7fffd1c0000000000000000000000000024fffff2090000000000000000000000000041ffffdc000000000000000000000000000063ffffbd00000000000000000000000000008dffff9e0000000000000000000000000000baffff7f0000000000000000000000000007e0ffff5f0000000000000000000000000025f8ffff37000000000f06000000000000005afffff117000000003930000000000000009effffd204000000007f8003000000000017d9ffffa10000000007c3ce25000000000055f8ffff6f0000000027edf86e0300000015a8fffffd3d0000000062ffffc34508001467e9ffffe217000000009cfffff4995b4b68bbffffffae03000000009bffffffeaaf9fbcfafffffe63000000000061f5fffffffff7ffffffffe826000000000020c6ffffffffffffffffffae0600000000000176faffffffffffffffee5b0000000000000029d1ffffffffffffffaf19000000000000000481eeffffffffffd85b000000000000000000339febffffffdc8418000000000000000000044793b3c5af842c0000000000000000000000053f5f715b3000000000000000000000000000000b1d08000000000000000000")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 LCD_V NO_HINTING 36ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="34")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="34")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="16")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "142f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f1a3783838383838383838383838383838383838383838383838383838383838383834a5bd7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7796bffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8f6bffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8f6bffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8f6bffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8f6bffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8f6bffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8f52c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c36e2f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f6f3e0b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b0f")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 NORMAL DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 NORMAL DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 NORMAL DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 NORMAL DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 NORMAL DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 NORMAL DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 NORMAL DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 NORMAL DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 NORMAL DEFAULT 36ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 LIGHT DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 LIGHT DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 LIGHT DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 LIGHT DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 LIGHT DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 LIGHT DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 LIGHT DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 LIGHT DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 LIGHT DEFAULT 36ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 MONO DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 MONO DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 MONO DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 MONO DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 MONO DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 MONO DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 MONO DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 MONO DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 MONO DEFAULT 36ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 LCD DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 LCD DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 LCD DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 LCD DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 LCD DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 LCD DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 LCD DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 LCD DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 LCD DEFAULT 36ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 LCD_V DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 LCD_V DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 LCD_V DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="66")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 52 LCD_V DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 72 LCD_V DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="72")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 50 LCD_V DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="50")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 7 LCD_V DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="7")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 26 LCD_V DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="26")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 LCD_V DEFAULT 36ppem char 19968" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 19968U)
  inspect(gid, content="2388")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/NotoSansJP-Regular.otf: hinted outline DEFAULT 16ppem" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="18")
  inspect(f.glyph().metrics().width(), content="192")
  inspect(f.glyph().metrics().height(), content="832")
  inspect(f.glyph().metrics().hori_advance(), content="320")
}

///|
test "parity/NotoSansJP-Regular.otf: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="331")
}

///|
test "parity/NotoSansJP-Regular.otf: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_notosansjp_regular_otf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_FORCE_AUTOHINT)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="384")
}

