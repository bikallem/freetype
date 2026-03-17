// Parity tests for DejaVuSans.woff
// AUTO-GENERATED — do not edit

///|
fn load_dejavusans_woff() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/DejaVuSans.woff")
}

///|
test "parity/DejaVuSans.woff: format" {
  inspect(@base.detect_format(load_dejavusans_woff()), content="Woff1")
}

///|
test "parity/DejaVuSans.woff: loads" {
  inspect(
    (try? @freetype.from_bytes(load_dejavusans_woff())) is Ok(_),
    content="true",
  )
}

///|
test "parity/DejaVuSans.woff: metadata" {
  let f = @freetype.from_bytes(load_dejavusans_woff())
  inspect(f.family_name, content="DejaVu Sans")
  inspect(f.num_glyphs, content="6253")
  inspect(f.units_per_em, content="2048")
  inspect(f.ascender, content="1901")
  inspect(f.descender, content="-483")
  inspect(f.height, content="2384")
  inspect(
    f.underline_position,
    content=(
      #|-130
    ),
  )
  inspect(f.underline_thickness, content="90")
}

///|
test "parity/DejaVuSans.woff: bbox" {
  let f = @freetype.from_bytes(load_dejavusans_woff())
  inspect(f.bbox.x_min, content="-2090")
  inspect(f.bbox.y_min, content="-948")
  inspect(f.bbox.x_max, content="3673")
  inspect(f.bbox.y_max, content="2524")
}

///|
test "parity/DejaVuSans.woff: flags" {
  let f = @freetype.from_bytes(load_dejavusans_woff())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="true")
}

///|
test "parity/DejaVuSans.woff: charmaps" {
  let f = @freetype.from_bytes(load_dejavusans_woff())
  inspect(f.charmaps.length(), content="5")
  if f.charmaps.length() > 0 {
    inspect(f.charmaps[0].platform_id, content="0")
    inspect(f.charmaps[0].encoding_id, content="3")
  }
  if f.charmaps.length() > 1 {
    inspect(f.charmaps[1].platform_id, content="0")
    inspect(f.charmaps[1].encoding_id, content="10")
  }
  if f.charmaps.length() > 2 {
    inspect(f.charmaps[2].platform_id, content="1")
    inspect(f.charmaps[2].encoding_id, content="0")
  }
  if f.charmaps.length() > 3 {
    inspect(f.charmaps[3].platform_id, content="3")
    inspect(f.charmaps[3].encoding_id, content="1")
  }
  if f.charmaps.length() > 4 {
    inspect(f.charmaps[4].platform_id, content="3")
    inspect(f.charmaps[4].encoding_id, content="10")
  }
}

///|
test "parity/DejaVuSans.woff: charmap entries" {
  let f = @freetype.from_bytes(load_dejavusans_woff())
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
}

///|
test "parity/DejaVuSans.woff: glyph 4 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_dejavusans_woff())
  let r = try? @freetype.load_glyph(f, 4U, load_flags=@base.load_no_scale)
  guard r is Ok(_) else { return }
  inspect(f.glyph.outline.n_points(), content="10")
  inspect(f.glyph.outline.n_contours(), content="2")
  inspect(f.glyph.outline.points[0].x, content="309")
  inspect(f.glyph.outline.points[0].y, content="254")
  inspect(f.glyph.outline.points[1].x, content="512")
  inspect(f.glyph.outline.points[1].y, content="254")
  inspect(f.glyph.outline.points[2].x, content="512")
  inspect(f.glyph.outline.points[2].y, content="0")
  inspect(f.glyph.outline.points[3].x, content="309")
  inspect(f.glyph.outline.points[3].y, content="0")
  inspect(f.glyph.outline.points[4].x, content="309")
  inspect(f.glyph.outline.points[4].y, content="1493")
  inspect(f.glyph.outline.points[5].x, content="512")
  inspect(f.glyph.outline.points[5].y, content="1493")
  inspect(f.glyph.outline.points[6].x, content="512")
  inspect(f.glyph.outline.points[6].y, content="838")
  inspect(f.glyph.outline.points[7].x, content="492")
  inspect(f.glyph.outline.points[7].y, content="481")
  inspect(f.glyph.metrics.hori_advance, content="821")
}

///|
test "parity/DejaVuSans.woff: glyph 5 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_dejavusans_woff())
  let r = try? @freetype.load_glyph(f, 5U, load_flags=@base.load_no_scale)
  guard r is Ok(_) else { return }
  inspect(f.glyph.outline.n_points(), content="8")
  inspect(f.glyph.outline.n_contours(), content="2")
  inspect(f.glyph.outline.points[0].x, content="367")
  inspect(f.glyph.outline.points[0].y, content="1493")
  inspect(f.glyph.outline.points[1].x, content="367")
  inspect(f.glyph.outline.points[1].y, content="938")
  inspect(f.glyph.outline.points[2].x, content="197")
  inspect(f.glyph.outline.points[2].y, content="938")
  inspect(f.glyph.outline.points[3].x, content="197")
  inspect(f.glyph.outline.points[3].y, content="1493")
  inspect(f.glyph.outline.points[4].x, content="745")
  inspect(f.glyph.outline.points[4].y, content="1493")
  inspect(f.glyph.outline.points[5].x, content="745")
  inspect(f.glyph.outline.points[5].y, content="938")
  inspect(f.glyph.outline.points[6].x, content="575")
  inspect(f.glyph.outline.points[6].y, content="938")
  inspect(f.glyph.outline.points[7].x, content="575")
  inspect(f.glyph.outline.points[7].y, content="1493")
  inspect(f.glyph.metrics.hori_advance, content="942")
}

///|
test "parity/DejaVuSans.woff: glyph 6 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_dejavusans_woff())
  let r = try? @freetype.load_glyph(f, 6U, load_flags=@base.load_no_scale)
  guard r is Ok(_) else { return }
  inspect(f.glyph.outline.n_points(), content="32")
  inspect(f.glyph.outline.n_contours(), content="2")
  inspect(f.glyph.outline.points[0].x, content="1047")
  inspect(f.glyph.outline.points[0].y, content="901")
  inspect(f.glyph.outline.points[1].x, content="756")
  inspect(f.glyph.outline.points[1].y, content="901")
  inspect(f.glyph.outline.points[2].x, content="672")
  inspect(f.glyph.outline.points[2].y, content="567")
  inspect(f.glyph.outline.points[3].x, content="965")
  inspect(f.glyph.outline.points[3].y, content="567")
  inspect(f.glyph.outline.points[4].x, content="897")
  inspect(f.glyph.outline.points[4].y, content="1470")
  inspect(f.glyph.outline.points[5].x, content="793")
  inspect(f.glyph.outline.points[5].y, content="1055")
  inspect(f.glyph.outline.points[6].x, content="1085")
  inspect(f.glyph.outline.points[6].y, content="1055")
  inspect(f.glyph.outline.points[7].x, content="1190")
  inspect(f.glyph.outline.points[7].y, content="1470")
  inspect(f.glyph.metrics.hori_advance, content="1716")
}

///|
test "parity/DejaVuSans.woff: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_dejavusans_woff())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 4U)
  guard r2 is Ok(_) else { return }
  inspect(
    f.glyph.metrics.hori_advance,
    content=(
      #|411
    ),
  )
}

///|
test "parity/DejaVuSans.woff: kerning" {
  let f = @freetype.from_bytes(load_dejavusans_woff())
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
test "parity/DejaVuSans.woff: hinted outline DEFAULT 16ppem" {
  let f = @freetype.from_bytes(load_dejavusans_woff())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 4U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph.outline.n_points(), content="10")
  inspect(
    f.glyph.metrics.width,
    content=(
      #|102
    ),
  )
  inspect(
    f.glyph.metrics.height,
    content=(
      #|747
    ),
  )
  inspect(
    f.glyph.metrics.hori_advance,
    content=(
      #|411
    ),
  )
}

///|
test "parity/DejaVuSans.woff: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_dejavusans_woff())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 4U, load_flags=@base.load_no_hinting)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph.metrics.hori_advance, content="411")
}

///|
test "parity/DejaVuSans.woff: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_dejavusans_woff())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(
    f,
    4U,
    load_flags=@base.load_force_autohint,
  )
  guard r2 is Ok(_) else { return }
  inspect(
    f.glyph.metrics.hori_advance,
    content=(
      #|411
    ),
  )
}
