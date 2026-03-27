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
fn build_minimal_pfm_metrics(
  left_code : Byte,
  right_code : Byte,
  value : Int,
) -> Bytes {
  let bytes = FixedArray::make(150, b'\x00')
  bytes[1] = b'\x01'
  let size = 150
  bytes[2] = (size & 0xFF).to_byte()
  bytes[3] = ((size >> 8) & 0xFF).to_byte()
  bytes[4] = ((size >> 16) & 0xFF).to_byte()
  bytes[5] = ((size >> 24) & 0xFF).to_byte()
  bytes[99] = b'\x00'
  bytes[100] = b'\x00'
  bytes[119] = b'\x12'
  bytes[120] = b'\x00'
  let kern_offset = 140
  bytes[133] = (kern_offset & 0xFF).to_byte()
  bytes[134] = ((kern_offset >> 8) & 0xFF).to_byte()
  bytes[135] = ((kern_offset >> 16) & 0xFF).to_byte()
  bytes[136] = ((kern_offset >> 24) & 0xFF).to_byte()
  bytes[kern_offset] = b'\x01'
  bytes[kern_offset + 1] = b'\x00'
  bytes[kern_offset + 2] = left_code
  bytes[kern_offset + 3] = right_code
  let signed_value = if value < 0 { value + 0x10000 } else { value }
  bytes[kern_offset + 4] = (signed_value & 0xFF).to_byte()
  bytes[kern_offset + 5] = ((signed_value >> 8) & 0xFF).to_byte()
  Bytes::from_array(bytes[:])
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

///|
test "attach_metrics: attaches PFM kerning to Type1 face" {
  let face = try! from_bytes(load_minimal_type1_mm_fixture())
  let metrics = build_minimal_pfm_metrics(b'A', b'A', -120)
  try! attach_metrics(face, metrics)
  let a = get_char_index(face, 65U)
  inspect(get_kerning(face, a, a).0, content="-120")
}
