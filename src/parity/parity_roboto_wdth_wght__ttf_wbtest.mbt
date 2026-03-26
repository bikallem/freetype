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

