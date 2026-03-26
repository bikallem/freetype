///|
fn load_vertical_fixture(path : String) -> Bytes {
  try! @fs.read_file_to_bytes(path)
}

///|
test "vertical metrics: SFNT face flags and max advance height" {
  let noto = @freetype.from_bytes(
    load_vertical_fixture("test/fonts/NotoSansJP-Regular.otf"),
  )
  inspect(noto.has_vertical(), content="true")
  inspect(noto.max_advance_height(), content="3000")

  let dejavu = @freetype.from_bytes(
    load_vertical_fixture("test/fonts/DejaVuSans.ttf"),
  )
  inspect(dejavu.has_vertical(), content="false")
}

///|
test "vertical metrics: Noto uses vmtx under LOAD_VERTICAL_LAYOUT" {
  let f = @freetype.from_bytes(
    load_vertical_fixture("test/fonts/NotoSansJP-Regular.otf"),
  )
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  try! @freetype.load_glyph(
    f,
    gid,
    load_flags=@base.LOAD_VERTICAL_LAYOUT | @base.LOAD_NO_HINTING,
  )
  inspect(f.glyph().metrics().vert_bearing_x(), content="-307")
  inspect(f.glyph().metrics().vert_bearing_y(), content="151")
  inspect(f.glyph().metrics().vert_advance(), content="1024")
  inspect(f.glyph().advance().x(), content="0")
  inspect(f.glyph().advance().y(), content="1024")
  inspect(f.glyph().linear_hori_advance().val(), content="637536")
  inspect(f.glyph().linear_vert_advance().val(), content="1048578")
}

///|
test "vertical metrics: DejaVu synthesizes linear and vertical advances" {
  let f = @freetype.from_bytes(
    load_vertical_fixture("test/fonts/DejaVuSans.ttf"),
  )
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  try! @freetype.load_glyph(f, gid)
  inspect(f.glyph().advance().x(), content="704")
  inspect(f.glyph().advance().y(), content="0")
  inspect(f.glyph().linear_hori_advance().val(), content="717312")
  inspect(f.glyph().linear_vert_advance().val(), content="1048576")

  try! @freetype.load_glyph(
    f,
    gid,
    load_flags=@base.LOAD_VERTICAL_LAYOUT | @base.LOAD_NO_HINTING,
  )
  inspect(f.glyph().metrics().vert_bearing_x(), content="-342")
  inspect(f.glyph().metrics().vert_bearing_y(), content="139")
  inspect(f.glyph().metrics().vert_advance(), content="1024")
  inspect(f.glyph().advance().x(), content="0")
  inspect(f.glyph().advance().y(), content="1024")
}
