// Parity tests for SourceCodePro-Regular.woff
// AUTO-GENERATED — do not edit

///|
fn load_sourcecodepro_regular_woff() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/SourceCodePro-Regular.woff")
}

///|
test "parity/SourceCodePro-Regular.woff: format" {
  inspect(
    @base.detect_format(load_sourcecodepro_regular_woff()),
    content="Woff1",
  )
}

///|
test "parity/SourceCodePro-Regular.woff: loads" {
  inspect(
    (try? @freetype.from_bytes(load_sourcecodepro_regular_woff())) is Ok(_),
    content="true",
  )
}

///|
test "parity/SourceCodePro-Regular.woff: metadata" {
  let f = @freetype.from_bytes(load_sourcecodepro_regular_woff())
  inspect(f.family_name(), content="Source Code Pro")
  inspect(f.num_glyphs(), content="1568")
  inspect(f.units_per_em(), content="1000")
  inspect(f.ascender(), content="984")
  inspect(f.descender(), content="-273")
  inspect(f.height(), content="1257")
  inspect(
    f.underline_position(),
    content=(
      #|-50
    ),
  )
  inspect(f.underline_thickness(), content="50")
}

///|
test "parity/SourceCodePro-Regular.woff: bbox" {
  let f = @freetype.from_bytes(load_sourcecodepro_regular_woff())
  inspect(f.bbox().x_min(), content="-193")
  inspect(f.bbox().y_min(), content="-454")
  inspect(f.bbox().x_max(), content="793")
  inspect(f.bbox().y_max(), content="1060")
}

///|
test "parity/SourceCodePro-Regular.woff: flags" {
  let f = @freetype.from_bytes(load_sourcecodepro_regular_woff())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/SourceCodePro-Regular.woff: charmaps" {
  let f = @freetype.from_bytes(load_sourcecodepro_regular_woff())
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
  let f = @freetype.from_bytes(load_sourcecodepro_regular_woff())
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
}

///|
test "parity/SourceCodePro-Regular.woff: glyph 918 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_sourcecodepro_regular_woff())
  let r = try? @freetype.load_glyph(f, 918U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(
    f.glyph().outline().n_points(),
    content=(
      #|19
    ),
  )
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
  let f = @freetype.from_bytes(load_sourcecodepro_regular_woff())
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
  let f = @freetype.from_bytes(load_sourcecodepro_regular_woff())
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
  let f = @freetype.from_bytes(load_sourcecodepro_regular_woff())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 918U)
  guard r2 is Ok(_) else { return }
  inspect(
    f.glyph().metrics().hori_advance(),
    content=(
      #|614
    ),
  )
}

///|
test "parity/SourceCodePro-Regular.woff: hinted outline DEFAULT 16ppem" {
  let f = @freetype.from_bytes(load_sourcecodepro_regular_woff())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 918U)
  guard r2 is Ok(_) else { return }
  inspect(
    f.glyph().outline().n_points(),
    content=(
      #|19
    ),
  )
  inspect(
    f.glyph().metrics().width(),
    content=(
      #|150
    ),
  )
  inspect(
    f.glyph().metrics().height(),
    content=(
      #|698
    ),
  )
  inspect(
    f.glyph().metrics().hori_advance(),
    content=(
      #|614
    ),
  )
}

///|
test "parity/SourceCodePro-Regular.woff: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_sourcecodepro_regular_woff())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 918U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="614")
}

///|
test "parity/SourceCodePro-Regular.woff: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_sourcecodepro_regular_woff())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(
    f,
    918U,
    load_flags=@base.LOAD_FORCE_AUTOHINT,
  )
  guard r2 is Ok(_) else { return }
  inspect(
    f.glyph().metrics().hori_advance(),
    content=(
      #|614
    ),
  )
}
