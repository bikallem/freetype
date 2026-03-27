// Parity tests for minimal_standalone_expert.cff
// AUTO-GENERATED — do not edit

///|
fn load_generated_minimal_standalone_expert_cff() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_standalone_expert.cff")
}

///|
test "parity/minimal_standalone_expert.cff: format" {
  inspect(
    @base.detect_format(load_generated_minimal_standalone_expert_cff()),
    content="CffStandalone",
  )
}

///|
test "parity/minimal_standalone_expert.cff: loads" {
  inspect(
    (try? @freetype.from_bytes(load_generated_minimal_standalone_expert_cff()))
    is Ok(_),
    content="true",
  )
}

///|
test "parity/minimal_standalone_expert.cff: metadata" {
  let f = @freetype.from_bytes(load_generated_minimal_standalone_expert_cff())
  inspect(f.family_name(), content="MinimalStandaloneExpert-Regular")
  inspect(f.num_glyphs(), content="3")
  inspect(f.units_per_em(), content="1000")
  inspect(f.ascender(), content="0")
  inspect(f.descender(), content="0")
  inspect(f.height(), content="1200")
  inspect(f.underline_position(), content="-100")
  inspect(f.underline_thickness(), content="50")
}

///|
test "parity/minimal_standalone_expert.cff: bbox" {
  let f = @freetype.from_bytes(load_generated_minimal_standalone_expert_cff())
  inspect(f.bbox().x_min(), content="0")
  inspect(f.bbox().y_min(), content="0")
  inspect(f.bbox().x_max(), content="0")
  inspect(f.bbox().y_max(), content="0")
}

///|
test "parity/minimal_standalone_expert.cff: flags" {
  let f = @freetype.from_bytes(load_generated_minimal_standalone_expert_cff())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="false")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/minimal_standalone_expert.cff: charmaps" {
  let f = @freetype.from_bytes(load_generated_minimal_standalone_expert_cff())
  inspect(f.charmaps().length(), content="2")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="3")
    inspect(f.charmaps()[0].encoding_id(), content="1")
  }
  if f.charmaps().length() > 1 {
    inspect(f.charmaps()[1].platform_id(), content="7")
    inspect(f.charmaps()[1].encoding_id(), content="1")
  }
}

///|
test "parity/minimal_standalone_expert.cff: charmap entries" {
  let f = @freetype.from_bytes(load_generated_minimal_standalone_expert_cff())
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 65U), content="2")
  inspect(@freetype.get_char_index(f, 160U), content="1")
}

///|
test "parity/minimal_standalone_expert.cff: rendered glyph 1 NORMAL char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_standalone_expert_cff())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="0")
  inspect(f.glyph().bitmap().rows(), content="0")
  inspect(f.glyph().bitmap().pitch(), content="0")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="0")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "")
}

///|
test "parity/minimal_standalone_expert.cff: rendered glyph 1 LIGHT char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_standalone_expert_cff())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="0")
  inspect(f.glyph().bitmap().rows(), content="0")
  inspect(f.glyph().bitmap().pitch(), content="0")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="0")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "")
}

///|
test "parity/minimal_standalone_expert.cff: rendered glyph 1 MONO char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_standalone_expert_cff())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="1")
  inspect(f.glyph().bitmap().rows(), content="1")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="1")
  inspect(f.glyph().bitmap().buffer().length(), content="2")
}

///|
test "parity/minimal_standalone_expert.cff: rendered glyph 1 LCD char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_standalone_expert_cff())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="6")
  inspect(f.glyph().bitmap().rows(), content="0")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="-1")
  inspect(f.glyph().bitmap_top(), content="0")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "")
}

///|
test "parity/minimal_standalone_expert.cff: rendered glyph 1 LCD_V char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_standalone_expert_cff())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="0")
  inspect(f.glyph().bitmap().rows(), content="6")
  inspect(f.glyph().bitmap().pitch(), content="0")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="1")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "")
}
