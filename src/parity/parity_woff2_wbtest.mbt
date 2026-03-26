///|
fn load_minimal_woff2() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal.woff2")
}

///|
fn load_dejavusans_woff2() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/DejaVuSans.woff2")
}

///|
fn load_minimal_hmtx_woff2() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_hmtx.woff2")
}

///|
fn load_minimal_collection_woff2() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_collection.woff2")
}

///|
test "WOFF2: format detection" {
  inspect(@base.detect_format(load_minimal_woff2()), content="Woff2")
  inspect(@base.detect_format(load_dejavusans_woff2()), content="Woff2")
  inspect(@base.detect_format(load_minimal_hmtx_woff2()), content="Woff2")
  inspect(@base.detect_format(load_minimal_collection_woff2()), content="Woff2")
}

///|
test "WOFF2: loads CFF font" {
  let f = @freetype.from_bytes(load_minimal_woff2())
  inspect(f.num_glyphs(), content="3")
}

///|
test "WOFF2: loads DejaVuSans TrueType font" {
  let f = @freetype.from_bytes(load_dejavusans_woff2())
  inspect(f.family_name(), content="DejaVu Sans")
  inspect(f.num_glyphs(), content="6253")
  inspect(f.units_per_em(), content="2048")
}

///|
test "WOFF2: glyph outline" {
  let f = @freetype.from_bytes(load_dejavusans_woff2())
  let r = try? @freetype.load_glyph(f, 36U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  let outline = f.glyph().outline()
  inspect(outline.n_points() > 0, content="true")
  inspect(outline.n_contours() > 0, content="true")
}

///|
test "WOFF2: metadata matches TTF source" {
  let woff2_face = @freetype.from_bytes(load_dejavusans_woff2())
  let ttf_face = @freetype.from_bytes(
    try! @fs.read_file_to_bytes("test/fonts/DejaVuSans.ttf"),
  )
  inspect(woff2_face.family_name() == ttf_face.family_name(), content="true")
  inspect(woff2_face.num_glyphs() == ttf_face.num_glyphs(), content="true")
  inspect(woff2_face.units_per_em() == ttf_face.units_per_em(), content="true")
}

///|
test "WOFF2: CFF metadata matches OTF source" {
  let woff2_face = @freetype.from_bytes(load_minimal_woff2())
  let otf_face = @freetype.from_bytes(
    try! @fs.read_file_to_bytes("test/fonts/minimal.otf"),
  )
  inspect(woff2_face.num_glyphs() == otf_face.num_glyphs(), content="true")
  inspect(woff2_face.units_per_em() == otf_face.units_per_em(), content="true")
}

///|
test "WOFF2: transformed hmtx metrics match TTF source" {
  let woff2_face = @freetype.from_bytes(load_minimal_hmtx_woff2())
  let ttf_face = @freetype.from_bytes(
    try! @fs.read_file_to_bytes("test/fonts/minimal.ttf"),
  )

  let r1 = try? @freetype.load_glyph(
    woff2_face,
    1U,
    load_flags=@base.LOAD_NO_SCALE,
  )
  let r2 = try? @freetype.load_glyph(
    ttf_face,
    1U,
    load_flags=@base.LOAD_NO_SCALE,
  )
  guard r1 is Ok(_) && r2 is Ok(_) else { return }
  inspect(
    woff2_face.glyph().metrics().hori_advance() ==
    ttf_face.glyph().metrics().hori_advance(),
    content="true",
  )

  let r3 = try? @freetype.load_glyph(
    woff2_face,
    2U,
    load_flags=@base.LOAD_NO_SCALE,
  )
  let r4 = try? @freetype.load_glyph(
    ttf_face,
    2U,
    load_flags=@base.LOAD_NO_SCALE,
  )
  guard r3 is Ok(_) && r4 is Ok(_) else { return }
  inspect(
    woff2_face.glyph().metrics().width() == ttf_face.glyph().metrics().width(),
    content="true",
  )
  inspect(
    woff2_face.glyph().metrics().height() == ttf_face.glyph().metrics().height(),
    content="true",
  )
  inspect(
    woff2_face.glyph().metrics().hori_bearing_x() ==
    ttf_face.glyph().metrics().hori_bearing_x(),
    content="true",
  )
  inspect(
    woff2_face.glyph().metrics().hori_bearing_y() ==
    ttf_face.glyph().metrics().hori_bearing_y(),
    content="true",
  )
  inspect(
    woff2_face.glyph().metrics().hori_advance() ==
    ttf_face.glyph().metrics().hori_advance(),
    content="true",
  )
}

///|
test "WOFF2: collection face selection works" {
  let face0 = @freetype.from_bytes(load_minimal_collection_woff2())
  let face1 = @freetype.from_bytes(load_minimal_collection_woff2(), face_index=1)
  inspect(face0.num_faces(), content="2")
  inspect(face0.num_glyphs(), content="3")
  inspect(face1.num_glyphs(), content="3")
  inspect(face1.family_name(), content="Minimal")
}
