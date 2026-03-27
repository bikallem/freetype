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
fn load_nonunicode_bdf_fixture() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_nonunicode.bdf")
}

///|
fn load_gray2_bdf_fixture() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_gray2.bdf")
}

///|
fn load_gray4_bdf_fixture() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_gray4.bdf")
}

///|
fn load_gray8_bdf_fixture() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_gray8.bdf")
}

///|
fn load_default_char_bdf_fixture() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_default_char.bdf")
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

///|
test "BDF: non-Unicode charset does not publish Unicode metadata" {
  let face = from_bytes(load_nonunicode_bdf_fixture())
  inspect(face.charmaps().length(), content="1")
  inspect(face.charmaps()[0].encoding(), content="None")
  inspect(face.charmaps()[0].platform_id(), content="0")
  inspect(face.charmaps()[0].encoding_id(), content="0")
  inspect(get_char_index(face, 32U), content="1")
  inspect(get_char_index(face, 65U), content="2")
}

///|
test "BDF: gray2 fixture exposes Gray2 bitmap" {
  let face = from_bytes(load_gray2_bdf_fixture())
  let r = try? load_glyph(face, 1U)
  guard r is Ok(_) else { return }
  inspect(face.glyph().bitmap().pixel_mode(), content="Gray2")
  inspect(face.glyph().bitmap().pitch(), content="1")
  inspect(face.glyph().bitmap().num_grays(), content="4")
  inspect(face.glyph().bitmap().buffer()[0].to_int(), content="27")
}

///|
test "BDF: gray4 fixture exposes Gray4 bitmap" {
  let face = from_bytes(load_gray4_bdf_fixture())
  let r = try? load_glyph(face, 1U)
  guard r is Ok(_) else { return }
  inspect(face.glyph().bitmap().pixel_mode(), content="Gray4")
  inspect(face.glyph().bitmap().pitch(), content="1")
  inspect(face.glyph().bitmap().num_grays(), content="16")
  inspect(face.glyph().bitmap().buffer()[0].to_int(), content="175")
}

///|
test "BDF: gray8 fixture exposes Gray bitmap" {
  let face = from_bytes(load_gray8_bdf_fixture())
  let r = try? load_glyph(face, 1U)
  guard r is Ok(_) else { return }
  inspect(face.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(face.glyph().bitmap().pitch(), content="2")
  inspect(face.glyph().bitmap().num_grays(), content="256")
  inspect(face.glyph().bitmap().buffer()[0].to_int(), content="18")
  inspect(face.glyph().bitmap().buffer()[1].to_int(), content="254")
}

///|
test "BDF: glyph index 0 uses DEFAULT_CHAR fallback" {
  let face = from_bytes(load_default_char_bdf_fixture())
  inspect(get_char_index(face, 65U), content="1")
  inspect(get_char_index(face, 66U), content="2")
  let r = try? load_glyph(face, 0U)
  guard r is Ok(_) else { return }
  inspect(face.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(face.glyph().bitmap().buffer()[0].to_int(), content="124")
  inspect(face.glyph().metrics().hori_advance(), content="8")
}
