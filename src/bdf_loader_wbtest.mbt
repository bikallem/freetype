///|
fn load_bdf_with_wide_advance() -> Bytes {
  b"STARTFONT 2.1\nFONT -misc-Test-medium-r-normal--8-80-75-75-C-80-iso10646-1\nSIZE 8 75 75\nFONTBOUNDINGBOX 8 8 0 0\nCHARS 1\nSTARTCHAR A\nENCODING 65\nSWIDTH 625 0\nDWIDTH 10 0\nBBX 8 8 1 0\nBITMAP\n18\n24\n42\n7E\n42\n42\n42\n00\nENDCHAR\nENDFONT\n"
}

///|
fn load_sparse_bdf_fixture() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_sparse.bdf")
}

///|
fn load_chars_mismatch_bdf_fixture() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_chars_mismatch.bdf")
}

///|
test "BDF: public API uses DWIDTH for advances" {
  let face = from_bytes(load_bdf_with_wide_advance())
  inspect(face.family_name(), content="Test")
  inspect(face.max_advance_width(), content="10")
  inspect(get_char_index(face, 65U), content="1")

  let r = try? load_glyph(face, 1U)
  guard r is Ok(_) else { return }
  inspect(face.glyph().format(), content="Bitmap")
  inspect(face.glyph().metrics().width(), content="8")
  inspect(face.glyph().metrics().hori_bearing_x(), content="1")
  inspect(face.glyph().metrics().hori_advance(), content="10")
}

///|
test "BDF: sparse encoding map stays encoding-driven" {
  let face = from_bytes(load_sparse_bdf_fixture())
  inspect(face.num_glyphs(), content="3")
  inspect(get_char_index(face, 32U), content="1")
  inspect(get_char_index(face, 65U), content="0")
  inspect(get_char_index(face, 66U), content="2")
}

///|
test "BDF: CHARS mismatch still uses parsed glyph set" {
  let face = from_bytes(load_chars_mismatch_bdf_fixture())
  inspect(face.num_glyphs(), content="5")
  inspect(get_char_index(face, 32U), content="1")
  inspect(get_char_index(face, 65U), content="2")
  let r = try? load_glyph(face, 2U)
  guard r is Ok(_) else { return }
  inspect(face.glyph().metrics().hori_advance(), content="8")
}
