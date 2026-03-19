///|
test "BdfFont creation" {
  let font = BdfFont::new()
  inspect(font.font_name, content="")
  inspect(font.num_chars, content="0")
  inspect(font.point_size, content="0")
}

///|
test "BdfGlyph creation" {
  let glyph = BdfGlyph::new()
  inspect(glyph.encoding, content="-1")
  inspect(glyph.bbx_width, content="0")
  inspect(glyph.name, content="")
}

///|
test "parse_bdf_header basic" {
  let bdf_text = "STARTFONT 2.1\nFONT -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso8859-1\nSIZE 12 75 75\nFONTBOUNDINGBOX 6 13 0 -2\nCHARS 256\n"
  let data = @utf8.encode(bdf_text)
  let font = parse_bdf_header(data)
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
test "parse_bdf_header parses glyphs" {
  let bdf = "STARTFONT 2.1\nFONT test\nSIZE 8 75 75\nFONTBOUNDINGBOX 8 8 0 0\nCHARS 1\nSTARTCHAR A\nENCODING 65\nSWIDTH 500 0\nDWIDTH 8 0\nBBX 8 8 0 0\nBITMAP\n18\n24\n42\n7E\n42\n42\n42\n00\nENDCHAR\nENDFONT\n"
  let data = @utf8.encode(bdf)
  let font = parse_bdf_header(data)
  inspect(font.glyphs.length(), content="1")
  inspect(font.glyphs[0].encoding, content="65")
  inspect(font.glyphs[0].bbx_width, content="8")
  inspect(font.glyphs[0].bbx_height, content="8")
  inspect(font.glyphs[0].name, content="")
  inspect(font.glyphs[0].bitmap.length() > 0, content="true")
  inspect(font.glyphs[0].bitmap.length(), content="8")
}

///|
test "BdfFont::get_glyph" {
  let bdf = "STARTFONT 2.1\nFONT test\nSIZE 8 75 75\nFONTBOUNDINGBOX 8 8 0 0\nCHARS 2\nSTARTCHAR A\nENCODING 65\nSWIDTH 500 0\nDWIDTH 8 0\nBBX 8 8 0 0\nBITMAP\n18\n24\n42\n7E\n42\n42\n42\n00\nENDCHAR\nSTARTCHAR B\nENCODING 66\nSWIDTH 500 0\nDWIDTH 8 0\nBBX 8 8 0 0\nBITMAP\n7C\n42\n7C\n42\n42\n42\n7C\n00\nENDCHAR\nENDFONT\n"
  let data = @utf8.encode(bdf)
  let font = parse_bdf_header(data)
  inspect(font.glyphs.length(), content="2")
  let g_a = font.get_glyph(65)
  inspect(g_a is Some(_), content="true")
  inspect(g_a.unwrap().name, content="")
  let g_b = font.get_glyph(66)
  inspect(g_b is Some(_), content="true")
  inspect(g_b.unwrap().name, content="")
  let g_none = font.get_glyph(99)
  inspect(g_none is None, content="true")
}

///|
test "parse_bdf_header missing STARTFONT" {
  let data = @utf8.encode("FONT test\nSIZE 12 75 75\n")
  let result : Result[_, _] = Ok(parse_bdf_header(data)) catch {
    err => Err(err)
  }
  inspect(result is Err(_), content="true")
}
