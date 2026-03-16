///|
test "PfrFont creation" {
  let font = @pfr.PfrFont::new()
  inspect(font.font_name, content="")
  inspect(font.num_chars, content="0")
  inspect(font.header.signature, content="0")
}

///|
test "is_pfr signature check" {
  let valid : Bytes = [b'P', b'F', b'R', b'0', 0x00]
  inspect(@pfr.is_pfr(valid), content="true")
  let invalid : Bytes = [b'P', b'F', b'R', b'1']
  inspect(@pfr.is_pfr(invalid), content="false")
  let short : Bytes = [b'P', b'F']
  inspect(@pfr.is_pfr(short), content="false")
}
