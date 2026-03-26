///|
fn load_switch_dejavusans_ttf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/DejaVuSans.ttf")
}

///|
fn load_switch_nimbussans_pfb() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/NimbusSans-Regular.pfb")
}

///|
fn load_switch_sourcecodepro_standalone_cff() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/SourceCodePro_standalone.cff")
}

///|
fn load_switch_sourcecodepro_otf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/SourceCodePro-Regular.otf")
}

///|
test "active charmap: SFNT honors selected cmap subtable" {
  let f = @freetype.from_bytes(load_switch_dejavusans_ttf())
  f.set_active_charmap(0)
  inspect(@freetype.get_char_index(f, 66304U), content="0")
  f.set_active_charmap(4)
  inspect(@freetype.get_char_index(f, 66304U), content="5373")
}

///|
test "active charmap: Type1 switches between Unicode and Adobe encoding" {
  let f = @freetype.from_bytes(load_switch_nimbussans_pfb())
  f.set_active_charmap(0)
  inspect(@freetype.get_char_index(f, 381U), content="85")
  f.set_active_charmap(1)
  inspect(@freetype.get_char_index(f, 381U), content="0")
  inspect(@freetype.get_char_index(f, 65U), content="854")
}

///|
test "active charmap: standalone CFF switches between Unicode and Adobe encoding" {
  let f = @freetype.from_bytes(load_switch_sourcecodepro_standalone_cff())
  f.set_active_charmap(0)
  inspect(@freetype.get_char_index(f, 0x394U), content="609")
  f.set_active_charmap(1)
  inspect(@freetype.get_char_index(f, 0x394U), content="0")
  inspect(@freetype.get_char_index(f, 65U), content="2")
}

///|
test "active charmap: SFNT CFF synthetic Adobe charmap is selectable" {
  let f = @freetype.from_bytes(load_switch_sourcecodepro_otf())
  f.set_active_charmap(0)
  inspect(@freetype.get_char_index(f, 0x394U), content="609")
  f.set_active_charmap(5)
  inspect(@freetype.get_char_index(f, 0x394U), content="0")
  inspect(@freetype.get_char_index(f, 65U), content="2")
}
