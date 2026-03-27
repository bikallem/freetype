///|
fn load_switch_dejavusans_ttf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/DejaVuSans.ttf")
}

///|
fn load_switch_nimbussans_pfb() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/NimbusSans-Regular.pfb")
}

///|
fn load_switch_type1_encoding_only_pfb() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_type1_encoding_only.pfb")
}

///|
fn load_switch_type1_expert_pfb() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_type1_expert.pfb")
}

///|
fn load_switch_minimal_standalone_expert_cff() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_standalone_expert.cff")
}

///|
fn load_switch_minimal_standalone_custom_cff() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_standalone_custom.cff")
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
test "active charmap: Type1 Unicode miss does not fall back to encoding" {
  let f = @freetype.from_bytes(load_switch_type1_encoding_only_pfb())
  f.set_active_charmap(0)
  inspect(@freetype.get_char_index(f, 66U), content="0")
  f.set_active_charmap(1)
  inspect(@freetype.get_char_index(f, 66U), content="3")
}

///|
test "active charmap: Type1 ExpertEncoding is exposed distinctly" {
  let f = @freetype.from_bytes(load_switch_type1_expert_pfb())
  inspect(f.charmaps().length(), content="2")
  inspect(f.charmaps()[1].encoding(), content="AdobeExpert")
  inspect(f.charmaps()[1].platform_id(), content="7")
  inspect(f.charmaps()[1].encoding_id(), content="1")
  f.set_active_charmap(0)
  inspect(@freetype.get_char_index(f, 65U), content="2")
  f.set_active_charmap(1)
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 65U), content="0")
}

///|
test "active charmap: standalone CFF switches between Unicode and Adobe encoding" {
  let f = @freetype.from_bytes(load_switch_sourcecodepro_standalone_cff())
  f.set_active_charmap(0)
  inspect(@freetype.get_char_index(f, 0x394U), content="609")
  inspect(@freetype.get_char_index(f, 178U), content="0")
  f.set_active_charmap(1)
  inspect(@freetype.get_char_index(f, 0x394U), content="0")
  inspect(@freetype.get_char_index(f, 65U), content="2")
  inspect(@freetype.get_char_index(f, 178U), content="972")
}

///|
test "active charmap: standalone CFF expert encoding metadata is exposed" {
  let f = @freetype.from_bytes(load_switch_minimal_standalone_expert_cff())
  inspect(f.charmaps().length(), content="2")
  inspect(f.charmaps()[1].encoding(), content="AdobeExpert")
  inspect(f.charmaps()[1].platform_id(), content="7")
  inspect(f.charmaps()[1].encoding_id(), content="1")
  f.set_active_charmap(0)
  inspect(@freetype.get_char_index(f, 65U), content="2")
  f.set_active_charmap(1)
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 65U), content="0")
}

///|
test "active charmap: standalone CFF custom encoding metadata is exposed" {
  let f = @freetype.from_bytes(load_switch_minimal_standalone_custom_cff())
  inspect(f.charmaps().length(), content="2")
  inspect(f.charmaps()[1].encoding(), content="AdobeCustom")
  inspect(f.charmaps()[1].platform_id(), content="7")
  inspect(f.charmaps()[1].encoding_id(), content="2")
  f.set_active_charmap(0)
  inspect(@freetype.get_char_index(f, 65U), content="2")
  f.set_active_charmap(1)
  inspect(@freetype.get_char_index(f, 65U), content="0")
  inspect(@freetype.get_char_index(f, 66U), content="2")
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
