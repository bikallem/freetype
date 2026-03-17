///|
test "CidFont creation" {
  let font = @cid.CidFont::new()
  inspect(font.font_name, content="")
  inspect(font.cid_count, content="0")
  inspect(font.fd_array.length(), content="0")
  inspect(font.registry, content="")
  inspect(font.ordering, content="")
  inspect(font.supplement, content="0")
}

///|
test "CidFontDict creation" {
  let fd = @cid.CidFontDict::new()
  inspect(fd.std_hw, content="0")
  inspect(fd.std_vw, content="0")
  inspect(fd.len_iv, content="4")
  inspect(fd.subrs.length(), content="0")
}

///|
test "parse_cid_font rejects short data" {
  let data : Bytes = [0x00, 0x01]
  let result : Result[_, _] = Ok(@cid.parse_cid_font(data)) catch {
    err => Err(err)
  }
  inspect(result is Err(_), content="true")
}
