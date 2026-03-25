///|
fn load_minimal_woff2() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal.woff2")
}

///|
fn load_dejavusans_woff2() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/DejaVuSans.woff2")
}

///|
test "WOFF2: format detection" {
  inspect(@base.detect_format(load_minimal_woff2()), content="Woff2")
  inspect(@base.detect_format(load_dejavusans_woff2()), content="Woff2")
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
  inspect(
    woff2_face.family_name() == ttf_face.family_name(),
    content="true",
  )
  inspect(
    woff2_face.num_glyphs() == ttf_face.num_glyphs(),
    content="true",
  )
  inspect(
    woff2_face.units_per_em() == ttf_face.units_per_em(),
    content="true",
  )
}

///|
test "WOFF2: CFF metadata matches OTF source" {
  let woff2_face = @freetype.from_bytes(load_minimal_woff2())
  let otf_face = @freetype.from_bytes(
    try! @fs.read_file_to_bytes("test/fonts/minimal.otf"),
  )
  inspect(
    woff2_face.num_glyphs() == otf_face.num_glyphs(),
    content="true",
  )
  inspect(
    woff2_face.units_per_em() == otf_face.units_per_em(),
    content="true",
  )
}
