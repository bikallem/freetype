// Parity tests for minimal_collection.woff2
// AUTO-GENERATED — do not edit

///|
fn load_generated_minimal_collection_woff2() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_collection.woff2")
}

///|
test "parity/minimal_collection.woff2: format" {
  inspect(
    @base.detect_format(load_generated_minimal_collection_woff2()),
    content="Woff2",
  )
}

///|
test "parity/minimal_collection.woff2: loads" {
  inspect(
    (try? @freetype.from_bytes(load_generated_minimal_collection_woff2()))
    is Ok(_),
    content="true",
  )
}

///|
test "parity/minimal_collection.woff2: metadata" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
  inspect(f.family_name(), content="Minimal")
  inspect(f.num_glyphs(), content="3")
  inspect(f.units_per_em(), content="1000")
  inspect(f.ascender(), content="800")
  inspect(f.descender(), content="-200")
  inspect(f.height(), content="1000")
}

///|
test "parity/minimal_collection.woff2: bbox" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
  inspect(f.bbox().x_min(), content="0")
  inspect(f.bbox().y_min(), content="0")
  inspect(f.bbox().x_max(), content="450")
  inspect(f.bbox().y_max(), content="700")
}

///|
test "parity/minimal_collection.woff2: flags" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/minimal_collection.woff2: charmaps" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
  inspect(f.charmaps().length(), content="1")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="3")
    inspect(f.charmaps()[0].encoding_id(), content="1")
  }
}

///|
test "parity/minimal_collection.woff2: charmap entries" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 65U), content="2")
}

///|
test "parity/minimal_collection.woff2: glyph 2 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
  let r = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="3")
  inspect(f.glyph().outline().n_contours(), content="1")
  inspect(f.glyph().outline().points()[0].x(), content="50")
  inspect(f.glyph().outline().points()[0].y(), content="0")
  inspect(f.glyph().outline().points()[1].x(), content="250")
  inspect(f.glyph().outline().points()[1].y(), content="700")
  inspect(f.glyph().outline().points()[2].x(), content="450")
  inspect(f.glyph().outline().points()[2].y(), content="0")
  inspect(f.glyph().metrics().hori_advance(), content="500")
}

///|
test "parity/minimal_collection.woff2: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="512")
}

///|
test "parity/minimal_collection.woff2: rendered glyph 1 char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().width(), content="0")
  inspect(f.glyph().bitmap().rows(), content="0")
  inspect(f.glyph().bitmap().pitch(), content="0")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="0")
  inspect(f.glyph().bitmap().buffer().length(), content="0")
}

///|
test "parity/minimal_collection.woff2: rendered glyph 2 char 65" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  inspect(f.glyph().bitmap().buffer().length(), content="96")
  inspect(f.glyph().bitmap().buffer()[0].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[1].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[2].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[3].to_int(), content="1")
  inspect(f.glyph().bitmap().buffer()[4].to_int(), content="1")
  inspect(f.glyph().bitmap().buffer()[5].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[6].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[7].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[8].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[9].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[10].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[11].to_int(), content="52")
  inspect(f.glyph().bitmap().buffer()[12].to_int(), content="51")
  inspect(f.glyph().bitmap().buffer()[13].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[14].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[15].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[16].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[17].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[18].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[19].to_int(), content="125")
  inspect(f.glyph().bitmap().buffer()[20].to_int(), content="124")
  inspect(f.glyph().bitmap().buffer()[21].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[22].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[23].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[24].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[25].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[26].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[27].to_int(), content="198")
  inspect(f.glyph().bitmap().buffer()[28].to_int(), content="197")
  inspect(f.glyph().bitmap().buffer()[29].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[30].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[31].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[32].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[33].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[34].to_int(), content="18")
  inspect(f.glyph().bitmap().buffer()[35].to_int(), content="252")
  inspect(f.glyph().bitmap().buffer()[36].to_int(), content="252")
  inspect(f.glyph().bitmap().buffer()[37].to_int(), content="17")
  inspect(f.glyph().bitmap().buffer()[38].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[39].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[40].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[41].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[42].to_int(), content="88")
  inspect(f.glyph().bitmap().buffer()[43].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[44].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[45].to_int(), content="87")
  inspect(f.glyph().bitmap().buffer()[46].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[47].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[48].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[49].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[50].to_int(), content="162")
  inspect(f.glyph().bitmap().buffer()[51].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[52].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[53].to_int(), content="161")
  inspect(f.glyph().bitmap().buffer()[54].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[55].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[56].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[57].to_int(), content="1")
  inspect(f.glyph().bitmap().buffer()[58].to_int(), content="233")
  inspect(f.glyph().bitmap().buffer()[59].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[60].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[61].to_int(), content="233")
  inspect(f.glyph().bitmap().buffer()[62].to_int(), content="1")
  inspect(f.glyph().bitmap().buffer()[63].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[64].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[65].to_int(), content="52")
  inspect(f.glyph().bitmap().buffer()[66].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[67].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[68].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[69].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[70].to_int(), content="51")
  inspect(f.glyph().bitmap().buffer()[71].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[72].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[73].to_int(), content="125")
  inspect(f.glyph().bitmap().buffer()[74].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[75].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[76].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[77].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[78].to_int(), content="124")
  inspect(f.glyph().bitmap().buffer()[79].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[80].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[81].to_int(), content="198")
  inspect(f.glyph().bitmap().buffer()[82].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[83].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[84].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[85].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[86].to_int(), content="197")
  inspect(f.glyph().bitmap().buffer()[87].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[88].to_int(), content="18")
  inspect(f.glyph().bitmap().buffer()[89].to_int(), content="252")
  inspect(f.glyph().bitmap().buffer()[90].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[91].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[92].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[93].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[94].to_int(), content="252")
  inspect(f.glyph().bitmap().buffer()[95].to_int(), content="18")
}

///|
test "parity/minimal_collection.woff2: multi-face" {
  let f0 = @freetype.from_bytes(
    load_generated_minimal_collection_woff2(),
    face_index=0,
  )
  inspect(f0.num_glyphs() > 0L, content="true")
  let f1 = @freetype.from_bytes(
    load_generated_minimal_collection_woff2(),
    face_index=1,
  )
  inspect(f1.num_glyphs() > 0L, content="true")
}

///|
test "parity/minimal_collection.woff2: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="512")
}

///|
test "parity/minimal_collection.woff2: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(
    f,
    2U,
    load_flags=@base.LOAD_FORCE_AUTOHINT,
  )
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="512")
}
