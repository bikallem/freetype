///|
fn load_regular_cff2_fixture() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/regular_CFF2.otf")
}

///|
fn load_minimal_type1_mm_fixture() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_type1_mm.pfb")
}

///|
fn load_nimbus_type1_fixture() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/NimbusSans-Regular.pfb")
}

///|
fn load_nimbus_type1_afm() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/NimbusSans-Regular.afm")
}

///|
test "from_bytes: loads supported CFF2 fixture" {
  let data = load_regular_cff2_fixture()
  inspect(@base.detect_format(data), content="Cff2OpenType")
  let face = try! from_bytes(data)
  inspect(face.is_sfnt(), content="true")
  inspect(face.is_scalable(), content="true")
  inspect(face.num_glyphs() > 0L, content="true")
  inspect(face.family_name() != "", content="true")
}

///|
test "from_bytes: loads Multiple Master Type1 fixture" {
  let data = load_minimal_type1_mm_fixture()
  inspect(@base.detect_format(data), content="Type1Pfb")
  let face = try! from_bytes(data)
  inspect(face.has_multiple_masters(), content="true")
  inspect(face.num_glyphs() > 0L, content="true")
  inspect(get_char_index(face, 65U) != 0U, content="true")
}

///|
test "attach_metrics: attaches AFM kerning to Type1 face" {
  let data = load_nimbus_type1_fixture()
  let metrics = load_nimbus_type1_afm()
  let face = try! from_bytes(data)
  try! attach_metrics(face, metrics)
  let a = get_char_index(face, 65U)
  let v = get_char_index(face, 86U)
  inspect(get_kerning(face, a, v).0, content="-71")
}
