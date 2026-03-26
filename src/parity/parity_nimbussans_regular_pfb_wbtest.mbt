// Parity tests for NimbusSans-Regular.pfb
// AUTO-GENERATED — do not edit

///|
fn load_nimbussans_regular_pfb() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/NimbusSans-Regular.pfb")
}

///|
test "parity/NimbusSans-Regular.pfb: format" {
  inspect(
    @base.detect_format(load_nimbussans_regular_pfb()),
    content="Type1Pfa",
  )
}

///|
test "parity/NimbusSans-Regular.pfb: loads" {
  inspect(
    (try? @freetype.from_bytes(load_nimbussans_regular_pfb())) is Ok(_),
    content="true",
  )
}

///|
test "parity/NimbusSans-Regular.pfb: metadata" {
  let f = @freetype.from_bytes(load_nimbussans_regular_pfb())
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
  let f = @freetype.from_bytes(load_nimbussans_regular_pfb())
  inspect(f.bbox().x_min(), content="-210")
  inspect(f.bbox().y_min(), content="-299")
  inspect(f.bbox().x_max(), content="1032")
  inspect(f.bbox().y_max(), content="1075")
}

///|
test "parity/NimbusSans-Regular.pfb: flags" {
  let f = @freetype.from_bytes(load_nimbussans_regular_pfb())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="false")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/NimbusSans-Regular.pfb: charmaps" {
  let f = @freetype.from_bytes(load_nimbussans_regular_pfb())
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
  let f = @freetype.from_bytes(load_nimbussans_regular_pfb())
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
  let f = @freetype.from_bytes(load_nimbussans_regular_pfb())
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
  let f = @freetype.from_bytes(load_nimbussans_regular_pfb())
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
  let f = @freetype.from_bytes(load_nimbussans_regular_pfb())
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
  let f = @freetype.from_bytes(load_nimbussans_regular_pfb())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 274U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="256")
}

///|
test "parity/NimbusSans-Regular.pfb: hinted outline DEFAULT 16ppem" {
  let f = @freetype.from_bytes(load_nimbussans_regular_pfb())
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
  let f = @freetype.from_bytes(load_nimbussans_regular_pfb())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 274U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="285")
}

///|
test "parity/NimbusSans-Regular.pfb: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_nimbussans_regular_pfb())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(
    f,
    274U,
    load_flags=@base.LOAD_FORCE_AUTOHINT,
  )
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="256")
}
