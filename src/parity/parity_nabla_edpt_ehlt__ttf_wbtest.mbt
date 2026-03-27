// Parity tests for Nabla[EDPT,EHLT].ttf
// AUTO-GENERATED — do not edit

///|
fn load_generated_nabla_edpt_ehlt__ttf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/Nabla[EDPT,EHLT].ttf")
}

///|
test "parity/Nabla[EDPT,EHLT].ttf: format" {
  inspect(
    @base.detect_format(load_generated_nabla_edpt_ehlt__ttf())
    is (TrueType | TrueTypeCollection),
    content="true",
  )
}

///|
test "parity/Nabla[EDPT,EHLT].ttf: loads" {
  inspect(
    (try? @freetype.from_bytes(load_generated_nabla_edpt_ehlt__ttf())) is Ok(_),
    content="true",
  )
}

///|
test "parity/Nabla[EDPT,EHLT].ttf: metadata" {
  let f = @freetype.from_bytes(load_generated_nabla_edpt_ehlt__ttf())
  inspect(f.family_name(), content="Nabla")
  inspect(f.num_glyphs(), content="3655")
  inspect(f.units_per_em(), content="1000")
  inspect(f.ascender(), content="1263")
  inspect(f.descender(), content="-380")
  inspect(f.height(), content="1643")
  inspect(f.underline_position(), content="-125")
  inspect(f.underline_thickness(), content="50")
}

///|
test "parity/Nabla[EDPT,EHLT].ttf: bbox" {
  let f = @freetype.from_bytes(load_generated_nabla_edpt_ehlt__ttf())
  inspect(f.bbox().x_min(), content="-43")
  inspect(f.bbox().y_min(), content="-380")
  inspect(f.bbox().x_max(), content="1039")
  inspect(f.bbox().y_max(), content="1263")
}

///|
test "parity/Nabla[EDPT,EHLT].ttf: flags" {
  let f = @freetype.from_bytes(load_generated_nabla_edpt_ehlt__ttf())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/Nabla[EDPT,EHLT].ttf: charmaps" {
  let f = @freetype.from_bytes(load_generated_nabla_edpt_ehlt__ttf())
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
test "parity/Nabla[EDPT,EHLT].ttf: charmap entries" {
  let f = @freetype.from_bytes(load_generated_nabla_edpt_ehlt__ttf())
  inspect(@freetype.get_char_index(f, 32U), content="377")
  inspect(@freetype.get_char_index(f, 33U), content="183")
  inspect(@freetype.get_char_index(f, 34U), content="261")
  inspect(@freetype.get_char_index(f, 35U), content="237")
  inspect(@freetype.get_char_index(f, 36U), content="164")
  inspect(@freetype.get_char_index(f, 37U), content="253")
  inspect(@freetype.get_char_index(f, 38U), content="126")
  inspect(@freetype.get_char_index(f, 39U), content="268")
  inspect(@freetype.get_char_index(f, 40U), content="372")
  inspect(@freetype.get_char_index(f, 41U), content="252")
  inspect(@freetype.get_char_index(f, 42U), content="366")
  inspect(@freetype.get_char_index(f, 43U), content="256")
  inspect(@freetype.get_char_index(f, 44U), content="153")
  inspect(@freetype.get_char_index(f, 45U), content="206")
  inspect(@freetype.get_char_index(f, 46U), content="254")
  inspect(@freetype.get_char_index(f, 47U), content="376")
  inspect(@freetype.get_char_index(f, 48U), content="381")
  inspect(@freetype.get_char_index(f, 49U), content="247")
  inspect(@freetype.get_char_index(f, 50U), content="290")
  inspect(@freetype.get_char_index(f, 51U), content="286")
  inspect(@freetype.get_char_index(f, 52U), content="187")
  inspect(@freetype.get_char_index(f, 53U), content="186")
  inspect(@freetype.get_char_index(f, 54U), content="281")
  inspect(@freetype.get_char_index(f, 55U), content="280")
  inspect(@freetype.get_char_index(f, 56U), content="174")
  inspect(@freetype.get_char_index(f, 57U), content="234")
  inspect(@freetype.get_char_index(f, 58U), content="152")
  inspect(@freetype.get_char_index(f, 59U), content="279")
  inspect(@freetype.get_char_index(f, 60U), content="223")
  inspect(@freetype.get_char_index(f, 61U), content="181")
  inspect(@freetype.get_char_index(f, 62U), content="196")
  inspect(@freetype.get_char_index(f, 63U), content="259")
  inspect(@freetype.get_char_index(f, 64U), content="131")
  inspect(@freetype.get_char_index(f, 65U), content="2")
  inspect(@freetype.get_char_index(f, 66U), content="13")
  inspect(@freetype.get_char_index(f, 67U), content="14")
  inspect(@freetype.get_char_index(f, 68U), content="20")
  inspect(@freetype.get_char_index(f, 69U), content="23")
  inspect(@freetype.get_char_index(f, 70U), content="364")
  inspect(@freetype.get_char_index(f, 71U), content="35")
  inspect(@freetype.get_char_index(f, 72U), content="40")
  inspect(@freetype.get_char_index(f, 73U), content="43")
  inspect(@freetype.get_char_index(f, 74U), content="54")
  inspect(@freetype.get_char_index(f, 75U), content="56")
  inspect(@freetype.get_char_index(f, 76U), content="57")
  inspect(@freetype.get_char_index(f, 77U), content="61")
  inspect(@freetype.get_char_index(f, 78U), content="62")
  inspect(@freetype.get_char_index(f, 79U), content="66")
  inspect(@freetype.get_char_index(f, 80U), content="76")
  inspect(@freetype.get_char_index(f, 81U), content="77")
}

///|
test "parity/Nabla[EDPT,EHLT].ttf: glyph 183 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_nabla_edpt_ehlt__ttf())
  let r = try? @freetype.load_glyph(f, 183U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="40")
  inspect(f.glyph().outline().n_contours(), content="5")
  inspect(f.glyph().outline().points()[0].x(), content="225")
  inspect(f.glyph().outline().points()[0].y(), content="885")
  inspect(f.glyph().outline().points()[1].x(), content="225")
  inspect(f.glyph().outline().points()[1].y(), content="185")
  inspect(f.glyph().outline().points()[2].x(), content="139")
  inspect(f.glyph().outline().points()[2].y(), content="135")
  inspect(f.glyph().outline().points()[3].x(), content="139")
  inspect(f.glyph().outline().points()[3].y(), content="835")
  inspect(f.glyph().outline().points()[4].x(), content="182")
  inspect(f.glyph().outline().points()[4].y(), content="-50")
  inspect(f.glyph().outline().points()[5].x(), content="155")
  inspect(f.glyph().outline().points()[5].y(), content="-65")
  inspect(f.glyph().outline().points()[6].x(), content="121")
  inspect(f.glyph().outline().points()[6].y(), content="-45")
  inspect(f.glyph().outline().points()[7].x(), content="121")
  inspect(f.glyph().outline().points()[7].y(), content="-15")
  inspect(f.glyph().metrics().hori_advance(), content="277")
}

///|
test "parity/Nabla[EDPT,EHLT].ttf: glyph 261 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_nabla_edpt_ehlt__ttf())
  let r = try? @freetype.load_glyph(f, 261U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="36")
  inspect(f.glyph().outline().n_contours(), content="6")
  inspect(f.glyph().outline().points()[0].x(), content="217")
  inspect(f.glyph().outline().points()[0].y(), content="460")
  inspect(f.glyph().outline().points()[1].x(), content="182")
  inspect(f.glyph().outline().points()[1].y(), content="440")
  inspect(f.glyph().outline().points()[2].x(), content="130")
  inspect(f.glyph().outline().points()[2].y(), content="470")
  inspect(f.glyph().outline().points()[3].x(), content="130")
  inspect(f.glyph().outline().points()[3].y(), content="510")
  inspect(f.glyph().outline().points()[4].x(), content="130")
  inspect(f.glyph().outline().points()[4].y(), content="710")
  inspect(f.glyph().outline().points()[5].x(), content="217")
  inspect(f.glyph().outline().points()[5].y(), content="760")
  inspect(f.glyph().outline().points()[6].x(), content="424")
  inspect(f.glyph().outline().points()[6].y(), content="580")
  inspect(f.glyph().outline().points()[7].x(), content="390")
  inspect(f.glyph().outline().points()[7].y(), content="560")
  inspect(f.glyph().metrics().hori_advance(), content="468")
}

///|
test "parity/Nabla[EDPT,EHLT].ttf: glyph 237 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_nabla_edpt_ehlt__ttf())
  let r = try? @freetype.load_glyph(f, 237U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="104")
  inspect(f.glyph().outline().n_contours(), content="18")
  inspect(f.glyph().outline().points()[0].x(), content="217")
  inspect(f.glyph().outline().points()[0].y(), content="60")
  inspect(f.glyph().outline().points()[1].x(), content="130")
  inspect(f.glyph().outline().points()[1].y(), content="10")
  inspect(f.glyph().outline().points()[2].x(), content="130")
  inspect(f.glyph().outline().points()[2].y(), content="110")
  inspect(f.glyph().outline().points()[3].x(), content="217")
  inspect(f.glyph().outline().points()[3].y(), content="160")
  inspect(f.glyph().outline().points()[4].x(), content="217")
  inspect(f.glyph().outline().points()[4].y(), content="340")
  inspect(f.glyph().outline().points()[5].x(), content="130")
  inspect(f.glyph().outline().points()[5].y(), content="290")
  inspect(f.glyph().outline().points()[6].x(), content="130")
  inspect(f.glyph().outline().points()[6].y(), content="390")
  inspect(f.glyph().outline().points()[7].x(), content="217")
  inspect(f.glyph().outline().points()[7].y(), content="440")
  inspect(f.glyph().metrics().hori_advance(), content="675")
}

///|
test "parity/Nabla[EDPT,EHLT].ttf: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_nabla_edpt_ehlt__ttf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 183U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="284")
}

///|
test "parity/Nabla[EDPT,EHLT].ttf: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_nabla_edpt_ehlt__ttf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(
    f,
    183U,
    load_flags=@base.LOAD_FORCE_AUTOHINT,
  )
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="320")
}

///|
test "parity/Nabla[EDPT,EHLT].ttf: variation state" {
  let f = @freetype.from_bytes(load_generated_nabla_edpt_ehlt__ttf())
  inspect(f.has_multiple_masters(), content="true")
  inspect(f.is_variation(), content="false")
  try! @freetype.set_var_design_coordinates(f, [
    (@fixed.Fixed::from_raw(0L), 0x45445054U),
    (@fixed.Fixed::from_raw(0L), 0x45484C54U),
  ])
  inspect(f.is_variation(), content="true")
}

///|
test "parity/Nabla[EDPT,EHLT].ttf: varied 65 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_nabla_edpt_ehlt__ttf())
  try! @freetype.set_var_design_coordinates(f, [
    (@fixed.Fixed::from_raw(0L), 0x45445054U),
    (@fixed.Fixed::from_raw(0L), 0x45484C54U),
  ])
  let gid = @freetype.get_char_index(f, 65U)
  let r = try? @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(gid, content="2")
  inspect(f.glyph().outline().n_points(), content="49")
  inspect(f.glyph().outline().n_contours(), content="6")
  inspect(f.glyph().metrics().hori_advance(), content="563")
  inspect(f.glyph().metrics().width(), content="390")
  inspect(f.glyph().metrics().hori_bearing_x(), content="130")
  inspect(f.glyph().outline().points()[0].x(), content="217")
  inspect(f.glyph().outline().points()[0].y(), content="740")
  inspect(f.glyph().outline().points()[1].x(), content="433")
  inspect(f.glyph().outline().points()[1].y(), content="865")
  inspect(f.glyph().outline().points()[2].x(), content="467")
  inspect(f.glyph().outline().points()[2].y(), content="885")
  inspect(f.glyph().outline().points()[3].x(), content="520")
  inspect(f.glyph().outline().points()[3].y(), content="855")
}

///|
test "parity/Nabla[EDPT,EHLT].ttf: varied 97 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_nabla_edpt_ehlt__ttf())
  try! @freetype.set_var_design_coordinates(f, [
    (@fixed.Fixed::from_raw(0L), 0x45445054U),
    (@fixed.Fixed::from_raw(0L), 0x45484C54U),
  ])
  let gid = @freetype.get_char_index(f, 97U)
  let r = try? @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(gid, content="116")
  inspect(f.glyph().outline().n_points(), content="74")
  inspect(f.glyph().outline().n_contours(), content="9")
  inspect(f.glyph().metrics().hori_advance(), content="520")
  inspect(f.glyph().metrics().width(), content="346")
  inspect(f.glyph().metrics().hori_bearing_x(), content="130")
  inspect(f.glyph().outline().points()[0].x(), content="130")
  inspect(f.glyph().outline().points()[0].y(), content="490")
  inspect(f.glyph().outline().points()[1].x(), content="390")
  inspect(f.glyph().outline().points()[1].y(), content="640")
  inspect(f.glyph().outline().points()[2].x(), content="424")
  inspect(f.glyph().outline().points()[2].y(), content="660")
  inspect(f.glyph().outline().points()[3].x(), content="476")
  inspect(f.glyph().outline().points()[3].y(), content="630")
}

///|
test "parity/Nabla[EDPT,EHLT].ttf: varied outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_nabla_edpt_ehlt__ttf())
  try! @freetype.set_var_design_coordinates(f, [
    (@fixed.Fixed::from_raw(0L), 0x45445054U),
    (@fixed.Fixed::from_raw(0L), 0x45484C54U),
  ])
  let gid = @freetype.get_char_index(f, 65U)
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="577")
  inspect(f.glyph().metrics().width(), content="399")
  inspect(f.glyph().metrics().height(), content="957")
  inspect(f.glyph().metrics().hori_bearing_x(), content="133")
  inspect(f.glyph().metrics().hori_bearing_y(), content="906")
  inspect(f.glyph().outline().points()[0].x(), content="222")
  inspect(f.glyph().outline().points()[0].y(), content="758")
}

///|
test "parity/Nabla[EDPT,EHLT].ttf: varied outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_nabla_edpt_ehlt__ttf())
  try! @freetype.set_var_design_coordinates(f, [
    (@fixed.Fixed::from_raw(0L), 0x45445054U),
    (@fixed.Fixed::from_raw(0L), 0x45484C54U),
  ])
  let gid = @freetype.get_char_index(f, 65U)
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(
    f,
    gid,
    load_flags=@base.LOAD_FORCE_AUTOHINT,
  )
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="576")
}
