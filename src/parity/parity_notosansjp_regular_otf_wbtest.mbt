// Parity tests for NotoSansJP-Regular.otf
// AUTO-GENERATED — do not edit

///|
fn load_notosansjp_regular_otf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/NotoSansJP-Regular.otf")
}

///|
test "parity/NotoSansJP-Regular.otf: format" {
  inspect(
    @base.detect_format(load_notosansjp_regular_otf()),
    content="CffOpenType",
  )
}

///|
test "parity/NotoSansJP-Regular.otf: loads" {
  inspect(
    (try? @freetype.from_bytes(load_notosansjp_regular_otf())) is Ok(_),
    content="true",
  )
}

///|
test "parity/NotoSansJP-Regular.otf: metadata" {
  let f = @freetype.from_bytes(load_notosansjp_regular_otf())
  inspect(f.family_name, content="Noto Sans JP")
  inspect(f.num_glyphs, content="17936")
  inspect(f.units_per_em, content="1000")
  inspect(f.ascender, content="1160")
  inspect(f.descender, content="-288")
  inspect(f.height, content="1448")
  inspect(
    f.underline_position,
    content=(
      #|-125
    ),
  )
  inspect(f.underline_thickness, content="50")
}

///|
test "parity/NotoSansJP-Regular.otf: bbox" {
  let f = @freetype.from_bytes(load_notosansjp_regular_otf())
  inspect(f.bbox.x_min, content="-1002")
  inspect(f.bbox.y_min, content="-1048")
  inspect(f.bbox.x_max, content="2928")
  inspect(f.bbox.y_max, content="1808")
}

///|
test "parity/NotoSansJP-Regular.otf: flags" {
  let f = @freetype.from_bytes(load_notosansjp_regular_otf())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/NotoSansJP-Regular.otf: charmaps" {
  let f = @freetype.from_bytes(load_notosansjp_regular_otf())
  inspect(
    f.charmaps.length(),
    content=(
      #|7
    ),
  )
  if f.charmaps.length() > 0 {
    inspect(f.charmaps[0].platform_id, content="0")
    inspect(f.charmaps[0].encoding_id, content="3")
  }
  if f.charmaps.length() > 1 {
    inspect(f.charmaps[1].platform_id, content="0")
    inspect(f.charmaps[1].encoding_id, content="4")
  }
  if f.charmaps.length() > 2 {
    inspect(f.charmaps[2].platform_id, content="0")
    inspect(f.charmaps[2].encoding_id, content="5")
  }
  if f.charmaps.length() > 3 {
    inspect(f.charmaps[3].platform_id, content="1")
    inspect(f.charmaps[3].encoding_id, content="1")
  }
  if f.charmaps.length() > 4 {
    inspect(f.charmaps[4].platform_id, content="3")
    inspect(f.charmaps[4].encoding_id, content="1")
  }
  if f.charmaps.length() > 5 {
    inspect(f.charmaps[5].platform_id, content="3")
    inspect(f.charmaps[5].encoding_id, content="10")
  }
}

///|
test "parity/NotoSansJP-Regular.otf: charmap entries" {
  let f = @freetype.from_bytes(load_notosansjp_regular_otf())
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
  let f = @freetype.from_bytes(load_notosansjp_regular_otf())
  let r = try? @freetype.load_glyph(f, 2U, load_flags=@base.load_no_scale)
  guard r is Ok(_) else { return }
  inspect(
    f.glyph.outline.n_points(),
    content=(
      #|13
    ),
  )
  inspect(
    f.glyph.outline.n_contours(),
    content=(
      #|1
    ),
  )
  inspect(
    f.glyph.outline.points[0].x,
    content=(
      #|44
    ),
  )
  inspect(
    f.glyph.outline.points[0].y,
    content=(
      #|-658
    ),
  )
  inspect(
    f.glyph.outline.points[1].x,
    content=(
      #|81
    ),
  )
  inspect(
    f.glyph.outline.points[1].y,
    content=(
      #|-658
    ),
  )
  inspect(
    f.glyph.outline.points[2].x,
    content=(
      #|110
    ),
  )
  inspect(
    f.glyph.outline.points[2].y,
    content=(
      #|-630
    ),
  )
  inspect(
    f.glyph.outline.points[3].x,
    content=(
      #|110
    ),
  )
  inspect(
    f.glyph.outline.points[3].y,
    content=(
      #|-589
    ),
  )
  inspect(
    f.glyph.outline.points[4].x,
    content=(
      #|110
    ),
  )
  inspect(
    f.glyph.outline.points[4].y,
    content=(
      #|-547
    ),
  )
  inspect(
    f.glyph.outline.points[5].x,
    content=(
      #|81
    ),
  )
  inspect(
    f.glyph.outline.points[5].y,
    content=(
      #|-519
    ),
  )
  inspect(
    f.glyph.outline.points[6].x,
    content=(
      #|44
    ),
  )
  inspect(
    f.glyph.outline.points[6].y,
    content=(
      #|-519
    ),
  )
  inspect(
    f.glyph.outline.points[7].x,
    content=(
      #|8
    ),
  )
  inspect(
    f.glyph.outline.points[7].y,
    content=(
      #|-519
    ),
  )
  inspect(f.glyph.metrics.hori_advance, content="323")
}

///|
test "parity/NotoSansJP-Regular.otf: glyph 3 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_notosansjp_regular_otf())
  let r = try? @freetype.load_glyph(f, 3U, load_flags=@base.load_no_scale)
  guard r is Ok(_) else { return }
  inspect(f.glyph.outline.n_points(), content="12")
  inspect(f.glyph.outline.n_contours(), content="2")
  inspect(f.glyph.outline.points[0].x, content="110")
  inspect(f.glyph.outline.points[0].y, content="483")
  inspect(f.glyph.outline.points[1].x, content="167")
  inspect(f.glyph.outline.points[1].y, content="483")
  inspect(f.glyph.outline.points[2].x, content="184")
  inspect(f.glyph.outline.points[2].y, content="669")
  inspect(f.glyph.outline.points[3].x, content="186")
  inspect(f.glyph.outline.points[3].y, content="771")
  inspect(f.glyph.outline.points[4].x, content="90")
  inspect(f.glyph.outline.points[4].y, content="771")
  inspect(f.glyph.outline.points[5].x, content="92")
  inspect(f.glyph.outline.points[5].y, content="669")
  inspect(f.glyph.outline.points[6].x, content="307")
  inspect(f.glyph.outline.points[6].y, content="483")
  inspect(f.glyph.outline.points[7].x, content="362")
  inspect(f.glyph.outline.points[7].y, content="483")
  inspect(f.glyph.metrics.hori_advance, content="474")
}

///|
test "parity/NotoSansJP-Regular.otf: glyph 4 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_notosansjp_regular_otf())
  let r = try? @freetype.load_glyph(f, 4U, load_flags=@base.load_no_scale)
  guard r is Ok(_) else { return }
  inspect(f.glyph.outline.n_points(), content="32")
  inspect(f.glyph.outline.n_contours(), content="2")
  inspect(f.glyph.outline.points[0].x, content="101")
  inspect(f.glyph.outline.points[0].y, content="0")
  inspect(f.glyph.outline.points[1].x, content="160")
  inspect(f.glyph.outline.points[1].y, content="0")
  inspect(f.glyph.outline.points[2].x, content="188")
  inspect(f.glyph.outline.points[2].y, content="229")
  inspect(f.glyph.outline.points[3].x, content="336")
  inspect(f.glyph.outline.points[3].y, content="229")
  inspect(f.glyph.outline.points[4].x, content="309")
  inspect(f.glyph.outline.points[4].y, content="0")
  inspect(f.glyph.outline.points[5].x, content="369")
  inspect(f.glyph.outline.points[5].y, content="0")
  inspect(f.glyph.outline.points[6].x, content="396")
  inspect(f.glyph.outline.points[6].y, content="229")
  inspect(f.glyph.outline.points[7].x, content="500")
  inspect(f.glyph.outline.points[7].y, content="229")
  inspect(f.glyph.metrics.hori_advance, content="555")
}

///|
test "parity/NotoSansJP-Regular.otf: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_notosansjp_regular_otf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U)
  guard r2 is Ok(_) else { return }
  inspect(
    f.glyph.metrics.hori_advance,
    content=(
      #|331
    ),
  )
}
