///|
test "Type42Font creation" {
  let font = @type42.Type42Font::new()
  inspect(font.font_name, content="")
  inspect(font.sfnts_data.length(), content="0")
}

///|
test "parse_type42 rejects short data" {
  let data : Bytes = [0x00]
  let result = try? @type42.parse_type42(data)
  inspect(result is Err(_), content="true")
}

///|
test "parse_type42 extracts sfnts" {
  let ps = "%!PS-AdobeFont-1.0: TestFont\n/FontName /TestFont def\n/FontType 42 def\n/sfnts [<00010000>] def\nend\n"
  let data = @utf8.encode(ps)
  let font = @type42.parse_type42(data)
  inspect(font.font_name, content="TestFont")
  inspect(font.sfnts_data.length(), content="4")
  inspect(font.sfnts_data[0], content="b'\\x00'")
  inspect(font.sfnts_data[1], content="b'\\x01'")
}
