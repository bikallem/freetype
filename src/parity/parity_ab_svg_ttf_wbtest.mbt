// Parity tests for ab_svg.ttf
// AUTO-GENERATED — do not edit

///|
fn load_generated_ab_svg_ttf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/ab_svg.ttf")
}

///|
test "parity/ab_svg.ttf: format" {
  inspect(@base.detect_format(load_generated_ab_svg_ttf()) is (TrueType | TrueTypeCollection), content="true")
}

///|
test "parity/ab_svg.ttf: loads" {
  inspect((try? @freetype.from_bytes(load_generated_ab_svg_ttf())) is Ok(_), content="true")
}

///|
test "parity/ab_svg.ttf: metadata" {
  let f = @freetype.from_bytes(load_generated_ab_svg_ttf())
  inspect(f.num_glyphs(), content="3")
  inspect(f.units_per_em(), content="1000")
  inspect(f.ascender(), content="984")
  inspect(f.descender(), content="-273")
  inspect(f.height(), content="1257")
  inspect(f.underline_position(), content="-75")
  inspect(f.underline_thickness(), content="50")
}

///|
test "parity/ab_svg.ttf: bbox" {
  let f = @freetype.from_bytes(load_generated_ab_svg_ttf())
  inspect(f.bbox().x_min(), content="52")
  inspect(f.bbox().y_min(), content="-12")
  inspect(f.bbox().x_max(), content="507")
  inspect(f.bbox().y_max(), content="712")
}

///|
test "parity/ab_svg.ttf: flags" {
  let f = @freetype.from_bytes(load_generated_ab_svg_ttf())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/ab_svg.ttf: charmaps" {
  let f = @freetype.from_bytes(load_generated_ab_svg_ttf())
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
test "parity/ab_svg.ttf: charmap entries" {
  let f = @freetype.from_bytes(load_generated_ab_svg_ttf())
  inspect(@freetype.get_char_index(f, 97U), content="1")
  inspect(@freetype.get_char_index(f, 98U), content="2")
}

///|
test "parity/ab_svg.ttf: glyph 1 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_ab_svg_ttf())
  let r = try? @freetype.load_glyph(f, 1U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="37")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="194")
  inspect(f.glyph().outline().points()[0].y(), content="-12")
  inspect(f.glyph().outline().points()[1].x(), content="133")
  inspect(f.glyph().outline().points()[1].y(), content="-12")
  inspect(f.glyph().outline().points()[2].x(), content="52")
  inspect(f.glyph().outline().points()[2].y(), content="61")
  inspect(f.glyph().outline().points()[3].x(), content="52")
  inspect(f.glyph().outline().points()[3].y(), content="126")
  inspect(f.glyph().outline().points()[4].x(), content="52")
  inspect(f.glyph().outline().points()[4].y(), content="206")
  inspect(f.glyph().outline().points()[5].x(), content="195")
  inspect(f.glyph().outline().points()[5].y(), content="291")
  inspect(f.glyph().outline().points()[6].x(), content="350")
  inspect(f.glyph().outline().points()[6].y(), content="308")
  inspect(f.glyph().outline().points()[7].x(), content="350")
  inspect(f.glyph().outline().points()[7].y(), content="339")
  inspect(f.glyph().metrics().hori_advance(), content="504")
}

///|
test "parity/ab_svg.ttf: glyph 2 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_ab_svg_ttf())
  let r = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="34")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="297")
  inspect(f.glyph().outline().points()[0].y(), content="-12")
  inspect(f.glyph().outline().points()[1].x(), content="263")
  inspect(f.glyph().outline().points()[1].y(), content="-12")
  inspect(f.glyph().outline().points()[2].x(), content="190")
  inspect(f.glyph().outline().points()[2].y(), content="21")
  inspect(f.glyph().outline().points()[3].x(), content="158")
  inspect(f.glyph().outline().points()[3].y(), content="50")
  inspect(f.glyph().outline().points()[4].x(), content="155")
  inspect(f.glyph().outline().points()[4].y(), content="50")
  inspect(f.glyph().outline().points()[5].x(), content="148")
  inspect(f.glyph().outline().points()[5].y(), content="0")
  inspect(f.glyph().outline().points()[6].x(), content="82")
  inspect(f.glyph().outline().points()[6].y(), content="0")
  inspect(f.glyph().outline().points()[7].x(), content="82")
  inspect(f.glyph().outline().points()[7].y(), content="0")
  inspect(f.glyph().metrics().hori_advance(), content="553")
}

///|
test "parity/ab_svg.ttf: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_generated_ab_svg_ttf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 1U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="512")
}

///|
test "parity/ab_svg.ttf: rendered glyph 1 NORMAL char 97" {
  let f = @freetype.from_bytes(load_generated_ab_svg_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="7")
  inspect(f.glyph().bitmap().rows(), content="9")
  inspect(f.glyph().bitmap().pitch(), content="7")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="8")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00239ce3e9a50f0086843a39e58f00000000007fd40000368cc2eaeb008ee4631d68ec18ff3c000068ec15ff500027cfec0089fce4ce6dec00001623000000")
}

///|
test "parity/ab_svg.ttf: rendered glyph 1 LIGHT char 97" {
  let f = @freetype.from_bytes(load_generated_ab_svg_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="7")
  inspect(f.glyph().bitmap().rows(), content="9")
  inspect(f.glyph().bitmap().pitch(), content="7")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="8")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00239ce3e9a50f0086843a39e58f00000000007fd40000368cc2eaeb008ee4631d68ec18ff3c000068ec15ff500027cfec0089fce4ce6dec00001623000000")
}

///|
test "parity/ab_svg.ttf: rendered glyph 1 MONO char 97" {
  let f = @freetype.from_bytes(load_generated_ab_svg_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="6")
  inspect(f.glyph().bitmap().rows(), content="8")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="8")
  inspect(f.glyph().bitmap().buffer().length(), content="16")
}

///|
test "parity/ab_svg.ttf: rendered glyph 1 LCD char 97" {
  let f = @freetype.from_bytes(load_generated_ab_svg_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="24")
  inspect(f.glyph().bitmap().rows(), content="9")
  inspect(f.glyph().bitmap().pitch(), content="24")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="8")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000b234a779cbbd3e3eeefe9dcc8a571340f000000000000063d86baaf84624a3a2d2a3966ade5ffdf8f3b0300000000000000000000000000000000002b7fd3ffd480280000000000000005193657748ca0b3c2cfdbeaf6ffeb973f0000000010458ed1f1e4bb876347301d0e1868bcffec9840000000186cc4ffe4903c040000000000001468bcffec98400000001569c1ffeaa350120100000a275798cff2ffec9840000000000e4389cdf0fcf5eae4e7e4cea26a6d9ee4ec984000000000000000020a1622272314080000000000000000000000")
}

///|
test "parity/ab_svg.ttf: rendered glyph 1 LCD_V char 97" {
  let f = @freetype.from_bytes(load_generated_ab_svg_ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="7")
  inspect(f.glyph().bitmap().rows(), content="30")
  inspect(f.glyph().bitmap().pitch(), content="7")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000005373d0e000000488f95510000239ce3e9a50f0063eae6e3ea300094d58e8dfb620086843a39e58f0047300001c0af001502000098c700000000007fd4000000001792de000002386ebee60000368cc2eaeb00118adbc9cbec0046deb77197ec008ee4631d68ec02d0ae140068ec0cf36b000068ec18ff3c000068ec22ff2b000071ec20ff2e00039eec15ff500027cfec09f2953878e8ec02cfd790c9b2ec0089fce4ce6dec0042c0cf7d299e000d6877290e4d0000162300000000000000000000")
}

///|
test "parity/ab_svg.ttf: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_ab_svg_ttf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 1U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="516")
}

///|
test "parity/ab_svg.ttf: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_ab_svg_ttf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 1U, load_flags=@base.LOAD_FORCE_AUTOHINT)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="512")
}

