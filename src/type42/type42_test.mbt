///|
test "Type42Font creation" {
  let font = @type42.Type42Font::new()
  inspect(font.font_name, content="")
  inspect(font.font_type, content="42")
  inspect(font.paint_type, content="0")
  inspect(font.sfnts_data.length(), content="0")
  inspect(font.encoding.length(), content="0")
}

///|
test "parse_type42 rejects short data" {
  let data : Bytes = [0x00]
  let result : Result[_, _] = Ok(@type42.parse_type42(data)) catch {
    err => Err(err)
  }
  inspect(result is Err(_), content="true")
}

///|
test "parse_type42 stores data" {
  let data : Bytes = [0x25, 0x21, 0x50, 0x53] // "%!PS"
  let font = @type42.parse_type42(data)
  inspect(font.sfnts_data.length(), content="4")
}
