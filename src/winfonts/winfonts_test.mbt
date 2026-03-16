///|
test "FntFont creation" {
  let font = @winfonts.FntFont::new()
  inspect(font.version, content="0")
  inspect(font.face_name, content="")
  inspect(font.num_glyphs, content="0")
  inspect(font.is_fon, content="false")
}

///|
test "is_mz_header" {
  let mz : Bytes = [b'M', b'Z', 0x00, 0x00]
  inspect(@winfonts.is_mz_header(mz), content="true")
  let not_mz : Bytes = [b'P', b'E', 0x00, 0x00]
  inspect(@winfonts.is_mz_header(not_mz), content="false")
  let short : Bytes = [b'M']
  inspect(@winfonts.is_mz_header(short), content="false")
}

///|
test "is_fnt_header" {
  // Version 0x0200 in LE
  let v2 : Bytes = [0x00, 0x02, 0x00, 0x00]
  inspect(@winfonts.is_fnt_header(v2), content="true")
  // Version 0x0300 in LE
  let v3 : Bytes = [0x00, 0x03, 0x00, 0x00]
  inspect(@winfonts.is_fnt_header(v3), content="true")
  // Invalid version
  let v1 : Bytes = [0x00, 0x01, 0x00, 0x00]
  inspect(@winfonts.is_fnt_header(v1), content="false")
}
