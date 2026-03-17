///|
test "BdfFont creation" {
  let font = @bdf.BdfFont::new()
  inspect(font.font_name, content="")
  inspect(font.num_chars, content="0")
  inspect(font.point_size, content="0")
}

///|
test "BdfGlyph creation" {
  let glyph = @bdf.BdfGlyph::new()
  inspect(glyph.encoding, content="-1")
  inspect(glyph.bbx_width, content="0")
  inspect(glyph.name, content="")
}

///|
test "parse_bdf_header basic" {
  let bdf_text = "STARTFONT 2.1\nFONT -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso8859-1\nSIZE 12 75 75\nFONTBOUNDINGBOX 6 13 0 -2\nCHARS 256\n"
  let data = @utf8.encode(bdf_text)
  let font = @bdf.parse_bdf_header(data)
  inspect(
    font.font_name,
    content="-misc-fixed-medium-r-normal--13-120-75-75-C-70-iso8859-1",
  )
  inspect(font.point_size, content="12")
  inspect(font.x_resolution, content="75")
  inspect(font.y_resolution, content="75")
  inspect(font.bbx_width, content="6")
  inspect(font.bbx_height, content="13")
  inspect(font.bbx_x_offset, content="0")
  inspect(font.bbx_y_offset, content="-2")
  inspect(font.num_chars, content="256")
}

///|
test "parse_bdf_header missing STARTFONT" {
  let data = @utf8.encode("FONT test\nSIZE 12 75 75\n")
  let result : Result[_, _] = Ok(@bdf.parse_bdf_header(data)) catch {
    err => Err(err)
  }
  inspect(result.is_err(), content="true")
}
