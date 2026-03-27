// Parity tests for SourceCodePro-Regular.woff
// AUTO-GENERATED — do not edit

///|
fn load_generated_sourcecodepro_regular_woff() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/SourceCodePro-Regular.woff")
}

///|
test "parity/SourceCodePro-Regular.woff: format" {
  inspect(
    @base.detect_format(load_generated_sourcecodepro_regular_woff()),
    content="Woff1",
  )
}

///|
test "parity/SourceCodePro-Regular.woff: loads" {
  inspect(
    (try? @freetype.from_bytes(load_generated_sourcecodepro_regular_woff()))
    is Ok(_),
    content="true",
  )
}

///|
test "parity/SourceCodePro-Regular.woff: metadata" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  inspect(f.family_name(), content="Source Code Pro")
  inspect(f.num_glyphs(), content="1568")
  inspect(f.units_per_em(), content="1000")
  inspect(f.ascender(), content="984")
  inspect(f.descender(), content="-273")
  inspect(f.height(), content="1257")
  inspect(f.underline_position(), content="-75")
  inspect(f.underline_thickness(), content="50")
}

///|
test "parity/SourceCodePro-Regular.woff: bbox" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  inspect(f.bbox().x_min(), content="-193")
  inspect(f.bbox().y_min(), content="-454")
  inspect(f.bbox().x_max(), content="793")
  inspect(f.bbox().y_max(), content="1060")
}

///|
test "parity/SourceCodePro-Regular.woff: flags" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/SourceCodePro-Regular.woff: charmaps" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
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
  if f.charmaps().length() > 5 {
    inspect(f.charmaps()[5].platform_id(), content="7")
    inspect(f.charmaps()[5].encoding_id(), content="0")
  }
}

///|
test "parity/SourceCodePro-Regular.woff: charmap entries" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 33U), content="918")
  inspect(@freetype.get_char_index(f, 34U), content="923")
  inspect(@freetype.get_char_index(f, 35U), content="1000")
  inspect(@freetype.get_char_index(f, 36U), content="1106")
  inspect(@freetype.get_char_index(f, 37U), content="1131")
  inspect(@freetype.get_char_index(f, 38U), content="876")
  inspect(@freetype.get_char_index(f, 39U), content="922")
  inspect(@freetype.get_char_index(f, 40U), content="961")
  inspect(@freetype.get_char_index(f, 41U), content="962")
  inspect(@freetype.get_char_index(f, 42U), content="971")
  inspect(@freetype.get_char_index(f, 43U), content="1152")
  inspect(@freetype.get_char_index(f, 44U), content="914")
  inspect(@freetype.get_char_index(f, 45U), content="935")
  inspect(@freetype.get_char_index(f, 46U), content="913")
  inspect(@freetype.get_char_index(f, 47U), content="967")
  inspect(@freetype.get_char_index(f, 48U), content="877")
  inspect(@freetype.get_char_index(f, 49U), content="878")
  inspect(@freetype.get_char_index(f, 50U), content="879")
  inspect(@freetype.get_char_index(f, 51U), content="880")
  inspect(@freetype.get_char_index(f, 52U), content="881")
  inspect(@freetype.get_char_index(f, 53U), content="882")
  inspect(@freetype.get_char_index(f, 54U), content="883")
  inspect(@freetype.get_char_index(f, 55U), content="884")
  inspect(@freetype.get_char_index(f, 56U), content="885")
  inspect(@freetype.get_char_index(f, 57U), content="886")
  inspect(@freetype.get_char_index(f, 58U), content="915")
  inspect(@freetype.get_char_index(f, 59U), content="916")
  inspect(@freetype.get_char_index(f, 60U), content="1159")
  inspect(@freetype.get_char_index(f, 61U), content="1157")
  inspect(@freetype.get_char_index(f, 62U), content="1160")
  inspect(@freetype.get_char_index(f, 63U), content="920")
  inspect(@freetype.get_char_index(f, 64U), content="998")
  inspect(@freetype.get_char_index(f, 65U), content="2")
  inspect(@freetype.get_char_index(f, 66U), content="3")
  inspect(@freetype.get_char_index(f, 67U), content="4")
  inspect(@freetype.get_char_index(f, 68U), content="5")
  inspect(@freetype.get_char_index(f, 69U), content="6")
  inspect(@freetype.get_char_index(f, 70U), content="7")
  inspect(@freetype.get_char_index(f, 71U), content="8")
  inspect(@freetype.get_char_index(f, 72U), content="9")
  inspect(@freetype.get_char_index(f, 73U), content="10")
  inspect(@freetype.get_char_index(f, 74U), content="11")
  inspect(@freetype.get_char_index(f, 75U), content="12")
  inspect(@freetype.get_char_index(f, 76U), content="13")
  inspect(@freetype.get_char_index(f, 77U), content="14")
  inspect(@freetype.get_char_index(f, 78U), content="15")
  inspect(@freetype.get_char_index(f, 79U), content="16")
  inspect(@freetype.get_char_index(f, 80U), content="17")
  inspect(@freetype.get_char_index(f, 81U), content="18")
  inspect(@freetype.get_char_index(f, 127925U), content="1557")
}

///|
test "parity/SourceCodePro-Regular.woff: glyph 918 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  let r = try? @freetype.load_glyph(f, 918U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="18")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="272")
  inspect(f.glyph().outline().points()[0].y(), content="232")
  inspect(f.glyph().outline().points()[1].x(), content="328")
  inspect(f.glyph().outline().points()[1].y(), content="232")
  inspect(f.glyph().outline().points()[2].x(), content="338")
  inspect(f.glyph().outline().points()[2].y(), content="576")
  inspect(f.glyph().outline().points()[3].x(), content="340")
  inspect(f.glyph().outline().points()[3].y(), content="670")
  inspect(f.glyph().outline().points()[4].x(), content="260")
  inspect(f.glyph().outline().points()[4].y(), content="670")
  inspect(f.glyph().outline().points()[5].x(), content="262")
  inspect(f.glyph().outline().points()[5].y(), content="576")
  inspect(f.glyph().outline().points()[6].x(), content="300")
  inspect(f.glyph().outline().points()[6].y(), content="-12")
  inspect(f.glyph().outline().points()[7].x(), content="340")
  inspect(f.glyph().outline().points()[7].y(), content="-12")
  inspect(f.glyph().metrics().hori_advance(), content="600")
}

///|
test "parity/SourceCodePro-Regular.woff: glyph 923 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  let r = try? @freetype.load_glyph(f, 923U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="12")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="157")
  inspect(f.glyph().outline().points()[0].y(), content="352")
  inspect(f.glyph().outline().points()[1].x(), content="213")
  inspect(f.glyph().outline().points()[1].y(), content="352")
  inspect(f.glyph().outline().points()[2].x(), content="238")
  inspect(f.glyph().outline().points()[2].y(), content="577")
  inspect(f.glyph().outline().points()[3].x(), content="240")
  inspect(f.glyph().outline().points()[3].y(), content="687")
  inspect(f.glyph().outline().points()[4].x(), content="130")
  inspect(f.glyph().outline().points()[4].y(), content="687")
  inspect(f.glyph().outline().points()[5].x(), content="132")
  inspect(f.glyph().outline().points()[5].y(), content="577")
  inspect(f.glyph().outline().points()[6].x(), content="387")
  inspect(f.glyph().outline().points()[6].y(), content="352")
  inspect(f.glyph().outline().points()[7].x(), content="443")
  inspect(f.glyph().outline().points()[7].y(), content="352")
  inspect(f.glyph().metrics().hori_advance(), content="600")
}

///|
test "parity/SourceCodePro-Regular.woff: glyph 1000 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  let r = try? @freetype.load_glyph(f, 1000U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="32")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="228")
  inspect(f.glyph().outline().points()[0].y(), content="261")
  inspect(f.glyph().outline().points()[1].x(), content="246")
  inspect(f.glyph().outline().points()[1].y(), content="409")
  inspect(f.glyph().outline().points()[2].x(), content="378")
  inspect(f.glyph().outline().points()[2].y(), content="409")
  inspect(f.glyph().outline().points()[3].x(), content="360")
  inspect(f.glyph().outline().points()[3].y(), content="261")
  inspect(f.glyph().outline().points()[4].x(), content="142")
  inspect(f.glyph().outline().points()[4].y(), content="0")
  inspect(f.glyph().outline().points()[5].x(), content="196")
  inspect(f.glyph().outline().points()[5].y(), content="0")
  inspect(f.glyph().outline().points()[6].x(), content="221")
  inspect(f.glyph().outline().points()[6].y(), content="204")
  inspect(f.glyph().outline().points()[7].x(), content="353")
  inspect(f.glyph().outline().points()[7].y(), content="204")
  inspect(f.glyph().metrics().hori_advance(), content="600")
}

///|
test "parity/SourceCodePro-Regular.woff: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 918U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="640")
}

///|
test "parity/SourceCodePro-Regular.woff: rendered glyph 1 NORMAL char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
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
test "parity/SourceCodePro-Regular.woff: rendered glyph 2 NORMAL char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="10")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "000000057f50000000000000004aede101000000000000a07de938000000000006f0309f8e00000000004ce50053e30100000000a299000df93b00000007f1824343d2920000004ef7cbcbcbdae6020000a4a600000019fe3f0008f25600000000c7950050f90e0000000077e903",
  )
}

///|
test "parity/SourceCodePro-Regular.woff: rendered glyph 28 NORMAL char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="9")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="8")
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "0046a9dae6aa1d0027d76b333dc9ca01000000000047ff1f00074c96bbdbff3a21d9b0511f17ff3b92b600000014ff3b96cd11002abcfe3b1dd2fdebcb40e13b00011f1100000000",
  )
}

///|
test "parity/SourceCodePro-Regular.woff: rendered glyph 1 LIGHT char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
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
test "parity/SourceCodePro-Regular.woff: rendered glyph 2 LIGHT char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="10")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "000000057f50000000000000004aede101000000000000a07de938000000000006f0309f8e00000000004ce50053e30100000000a299000df93b00000007f1824343d2920000004ef7cbcbcbdae6020000a4a600000019fe3f0008f25600000000c7950050f90e0000000077e903",
  )
}

///|
test "parity/SourceCodePro-Regular.woff: rendered glyph 28 LIGHT char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="9")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="8")
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "0046a9dae6aa1d0027d76b333dc9ca01000000000047ff1f00074c96bbdbff3a21d9b0511f17ff3b92b600000014ff3b96cd11002abcfe3b1dd2fdebcb40e13b00011f1100000000",
  )
}

///|
test "parity/SourceCodePro-Regular.woff: rendered glyph 1 MONO char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
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
test "parity/SourceCodePro-Regular.woff: rendered glyph 2 MONO char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="11")
  inspect(f.glyph().bitmap().buffer().length(), content="22")
}

///|
test "parity/SourceCodePro-Regular.woff: rendered glyph 28 MONO char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="7")
  inspect(f.glyph().bitmap().rows(), content="8")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="8")
  inspect(f.glyph().bitmap().buffer().length(), content="16")
}

///|
test "parity/SourceCodePro-Regular.woff: rendered glyph 1 LCD char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
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
test "parity/SourceCodePro-Regular.woff: rendered glyph 2 LCD char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="30")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="32")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "00000000000000000000052e5a7f7f7a50260000000000000000000000000000000000000000000000064a9eefededede18d35010000000000000000000000000000000000000000054ca0eecf7d6797e9e38c3801000000000000000000000000000000000000064aa2f0dd8430044b9fefe28e3a0100000000000000000000000000000000074ca0f1e5923a00000953a7f6e39139010000000000000000000000000000064ea2f0eb9945020000000d5ab2f9e68f3b02000000000000000000000000074ca4f1fbc0824943434343435494d2ffe4923e0100000000000000000000084ea2f2f7e6d4cbcbcbcbcbcbcbcbcbdaebfde6943c0200000000000000000750a4f1f3a65207000000000000000000196bc3fee8933f03000000000000084ea6f2f7aa560b00000000000000000000001c73c7ffe7954102000000000950a4f3f9b35b0e000000000000000000000000002477cbffe9984003000000",
  )
}

///|
test "parity/SourceCodePro-Regular.woff: rendered glyph 28 LCD char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="27")
  inspect(f.glyph().bitmap().rows(), content="9")
  inspect(f.glyph().bitmap().pitch(), content="28")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="8")
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "00000000000921466f91a9b9cadae8ece6d8c7aa80471d0500000000000000002778c3d7b38a6b5543332c2e3d598fc9f2faca782501000000000000000000000000000000000000000005479bedffcb731f0000000000000000000717314c688396a5afbbc6d1dbeaf7ffe68e3a0000000000042157a3d9efd8b0886b513c2b1f140a1768bfffe78f3b00000000003e92e5f9b662110000000000000000001468c0ffe78f3b00000000004296e9fdcd86351104000005112a5286bce3fafee78f3b0000000000011d539bd2effefdf4ecebece5cba573404f92e1e78f3b0000000000000000000107131f241f110500000000000000000000000000",
  )
}

///|
test "parity/SourceCodePro-Regular.woff: rendered glyph 1 LCD_V char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
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
test "parity/SourceCodePro-Regular.woff: rendered glyph 2 LCD_V char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="36")
  inspect(f.glyph().bitmap().pitch(), content="10")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "000000002b1900000000000000057f500000000000000014d391000000000000002dfec5000000000000004aede10100000000000066cbf40a00000000000083a0f71d000000000000a07de938000000000000bc63d254000000000000d949b872000000000006f0309f8e000000000016fb1986ab000000000030f6086cc800000000004ce50053e3010000000068cd003af60b0000000086b30020fe2000000000a299000df93b00000000be7f0002e95700000000dc630000d07500000007f1824343d29200000017fdb59797e1ae00000032fff3efeffacc0000004ef7cbcbcbdae60200006ae377777797f70d000088c51f1f1f47ff230000a4a600000019fe3f0000c18c00000008f45b0000de7100000000e1790008f25600000000c7950019fd3c00000000adb10034ff220000000092cf0050f90e0000000077e90340a5020000000047a503244d00000000001e53030000000000000000000000000000000000000000",
  )
}

///|
test "parity/SourceCodePro-Regular.woff: rendered glyph 28 LCD_V char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="30")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(
    f.glyph().bitmap().buffer(),
    "000000000000000000000000000000000000052e3a0d000000095586925600000046a9dae6aa1d00179af7dfe7f1500026e8bf8791f2950027d76b333dc9ca01108418000196eb07012c00000065fd12000000000047ff1f000000000f59ff2c000007426798ff3500074c96bbdbff3a0039a0e0cbb2ff3b048de2a57360ff3b21d9b0511f17ff3b4aee5c080013ff3b78d814000013ff3b92b600000014ff3ba1a50000002bff3ba3ad0000016fff3b96cd11002abcfe3b77eb62417ed4f73b47fcba99d294ed3b1dd2fdebcb40e13b047fcbbb770a9428002a73632200471300011f11000000000000000000000000",
  )
}

///|
test "parity/SourceCodePro-Regular.woff: hinted outline DEFAULT 16ppem" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 918U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="18")
  inspect(f.glyph().metrics().width(), content="192")
  inspect(f.glyph().metrics().height(), content="704")
  inspect(f.glyph().metrics().hori_advance(), content="640")
}

///|
test "parity/SourceCodePro-Regular.woff: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 918U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="614")
}

///|
test "parity/SourceCodePro-Regular.woff: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_woff())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(
    f,
    918U,
    load_flags=@base.LOAD_FORCE_AUTOHINT,
  )
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="640")
}
