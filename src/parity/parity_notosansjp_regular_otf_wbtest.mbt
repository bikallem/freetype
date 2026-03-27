// Parity tests for NotoSansJP-Regular.otf
// AUTO-GENERATED — do not edit

///|
fn load_generated_notosansjp_regular_otf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/NotoSansJP-Regular.otf")
}

///|
test "parity/NotoSansJP-Regular.otf: format" {
  inspect(
    @base.detect_format(load_generated_notosansjp_regular_otf()),
    content="CffOpenType",
  )
}

///|
test "parity/NotoSansJP-Regular.otf: loads" {
  inspect(
    (try? @freetype.from_bytes(load_generated_notosansjp_regular_otf()))
    is Ok(_),
    content="true",
  )
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 NORMAL char 32" {
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 NORMAL char 65" {
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
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "00000011bb980000000000000063e1fe1c000000000000b97dd570000000000014fb3188c7000000000066e5013cff1f00000000bd9a0003eb7400000017fc4a00009fcb0000006affc6bfbfdbff220000c1c36b6b6b6cf6780019fd5700000000b1ce006ef80d0000000060ff25c4b4000000000014fc7c",
  )
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 NORMAL char 97" {
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
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "000460aad9c255000079de8059a7ff3a000a06000004f49600000005305de4b5000686e9ce9bddbb00a6db2c0000bbbb04f770000000bebb00eabf171e90fdbb0056f4fff1828ebb00000c2703000000",
  )
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 NORMAL char 19968" {
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
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "43e3e3e3e3e3e3e3e3e3e3e3e3e3e351206b6b6b6b6b6b6b6b6b6b6b6b6b6b26",
  )
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 LIGHT char 32" {
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 LIGHT char 65" {
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
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "00000011bb980000000000000063e1fe1c000000000000b97dd570000000000014fb3188c7000000000066e5013cff1f00000000bd9a0003eb7400000017fc4a00009fcb0000006affc6bfbfdbff220000c1c36b6b6b6cf6780019fd5700000000b1ce006ef80d0000000060ff25c4b4000000000014fc7c",
  )
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 LIGHT char 97" {
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
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "000460aad9c255000079de8059a7ff3a000a06000004f49600000005305de4b5000686e9ce9bddbb00a6db2c0000bbbb04f770000000bebb00eabf171e90fdbb0056f4fff1828ebb00000c2703000000",
  )
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 LIGHT char 19968" {
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
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "43e3e3e3e3e3e3e3e3e3e3e3e3e3e351206b6b6b6b6b6b6b6b6b6b6b6b6b6b26",
  )
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 MONO char 32" {
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 MONO char 65" {
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 MONO char 97" {
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 MONO char 19968" {
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 LCD char 32" {
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 LCD char 65" {
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
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "00000000000000000000000000114f8fbbbbbb985a1a00000000000000000000000000000000000000000000000000001363b7fae1e1e2fec66e1c0000000000000000000000000000000000000000000000001265b9fad17d5281d5fec4701e000000000000000000000000000000000000000000001464bcfbde8531003488dcfec7731d00000000000000000000000000000000000000001666bafce5923a0100013c90e6ffc9711f0000000000000000000000000000000000001569bdfceb9a460200000003439bebffc87421000000000000000000000000000000001768c0fcf19e4a060000000000044b9fefffcb77200000000000000000000000000000196abefdfff1dbc6bfbfbfbfbfbfbfc6dbf0ffffcd7522000000000000000000000000176dc1fdf4c3936c6b6b6b6b6b6b6b6b6b6c93c6f6ffcc782500000000000000000000196bc3fdf7ab570c00000000000000000000000d5db1f8ffce7a2300000000000000001c6ec2fef8b1590d000000000000000000000000001160b4fbffd179250000000000001a70c4fef9b4600e0000000000000000000000000000001464bcfcffd07c28000000",
  )
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 LCD char 97" {
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
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "0000000004163860819aaabbccd9dbd2c2ae885524060000000000000000002679cdf5deba97806e5e59607aa7d6f8ffe18d3a0500000000000000000a1010060000000000000000044ca4f4ffea96420000000000000000000000000000051021303f4e5d7cb3e4ffffb561090000000000000006255486abcee9f1e4cebaaa9b95b7ddffffbb670f00000000001253a6e7f9dba25e2c1002000000000f67bbffffbb670f000000000450a8f7ffc4701c0000000000000000126abeffffbb670f00000000003e96eafff7bf7a32170a0d1e365d90c8edfdffffbb670f0000000000001e569fd9f4fffffffffbf1dbb4824c538edbffbb670f000000000000000000030c1926271c0c030000000000000000000000000000",
  )
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 LCD char 19968" {
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
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "00438edce3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e39c5107002043686b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b4a2603",
  )
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 1 LCD_V char 32" {
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
test "parity/NotoSansJP-Regular.otf: rendered glyph 34 LCD_V char 65" {
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
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "0000000000000000000000000000000000000000000000000f0b0000000000000004674e0000000000000011bb980000000000000028ffdf0000000000000046f9f40900000000000063e1fe1c0000000000007fbffa360000000000009d99eb54000000000000b97dd570000000000000d564bc8d000000000005ee4aa1aa000000000014fb3188c700000000002cfe1a6fe201000000004af60955f50b0000000066e5013cff1f0000000083cd0022ff3a00000000a1b3000efa5800000000bd9a0003eb7400000000d9800000d59000000006f0640000b9ae00000017fc4a00009fcb00000030ff44131392e50200004eff826b6bb3f70d00006affc6bfbfdbff22000087ffffffffffff3e0000a4e9bfbfbfc0ff5b0000c1c36b6b6b6cf6780000dd9517171718e6940008f27100000000cbb20019fd5700000000b1ce0034ff3c0000000097e80352ff21000000007bf9106ef80d0000000060ff258ae8020000000046ff41a8ce00000000002aff5fc4b4000000000014fc7c8d70000000000005a85d4a3200000000000050320000000000000000000000000000000000000000",
  )
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 66 LCD_V char 97" {
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
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "00000000000000000000000000000000000000052d16000000001656856e1800000460aad9c255000031b4f9feffa805005ff5d4ade6e8190079de8059a7ff3a0056902c0657ff61002739000019fd81000a06000004f496000000000000e4a100000000000bdbac00000005305de4b50000014384b1f3ba0000349bdcedf3bb000686e9ce9bddbb0027d9d57a47c7bb0066f87f2200bbbb00a6db2c0000bbbb00d1af020000bbbb00e980000000bbbb04f770000000bebb04fd7800000bd3bb03f89300003eeabb00eabf171e90fdbb00cbe36a71d5e1bb009afcc2c9cfb8bb0056f4fff1828ebb0022add3a132577e0002557b4905293d00000c27030000000000000000000000",
  )
}

///|
test "parity/NotoSansJP-Regular.otf: rendered glyph 2388 LCD_V char 19968" {
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
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "0000000000000000000000000000000000000000000000000000000000000000103737373737373737373737373737142a8f8f8f8f8f8f8f8f8f8f8f8f8f8f3343e3e3e3e3e3e3e3e3e3e3e3e3e3e3514bffffffffffffffffffffffffffff5b38bfbfbfbfbfbfbfbfbfbfbfbfbfbf44206b6b6b6b6b6b6b6b6b6b6b6b6b6b2607171717171717171717171717171708",
  )
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
  let r2 = try? @freetype.load_glyph(
    f,
    2U,
    load_flags=@base.LOAD_FORCE_AUTOHINT,
  )
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="384")
}
