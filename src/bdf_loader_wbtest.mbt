///|
fn load_bdf_with_wide_advance() -> Bytes {
  b"STARTFONT 2.1\nFONT -misc-Test-medium-r-normal--8-80-75-75-C-80-iso10646-1\nSIZE 8 75 75\nFONTBOUNDINGBOX 8 8 0 0\nCHARS 1\nSTARTCHAR A\nENCODING 65\nSWIDTH 625 0\nDWIDTH 10 0\nBBX 8 8 1 0\nBITMAP\n18\n24\n42\n7E\n42\n42\n42\n00\nENDCHAR\nENDFONT\n"
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
