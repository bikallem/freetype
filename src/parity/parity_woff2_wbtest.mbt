///|
fn load_minimal_woff2() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal.woff2")
}

///|
test "WOFF2: format detection" {
  inspect(@base.detect_format(load_minimal_woff2()), content="Woff2")
  let djv = try! @fs.read_file_to_bytes("test/fonts/DejaVuSans.woff2")
  inspect(@base.detect_format(djv), content="Woff2")
}

///|
test "WOFF2: loads CFF font" {
  let f = @freetype.from_bytes(load_minimal_woff2())
  inspect(f.num_glyphs(), content="3")
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
