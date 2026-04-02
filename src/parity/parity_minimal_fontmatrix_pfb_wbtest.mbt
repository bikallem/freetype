// Parity tests for minimal_fontmatrix.pfb
// AUTO-GENERATED — do not edit

///|
fn load_generated_minimal_fontmatrix_pfb() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_fontmatrix.pfb")
}

///|
test "parity/minimal_fontmatrix.pfb: format" {
  inspect(@base.detect_format(load_generated_minimal_fontmatrix_pfb()), content="Type1Pfb")
}

///|
test "parity/minimal_fontmatrix.pfb: loads" {
  inspect((try? @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())) is Ok(_), content="true")
}

///|
test "parity/minimal_fontmatrix.pfb: metadata" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  inspect(f.family_name(), content="Minimal FontMatrix")
  inspect(f.num_glyphs(), content="3")
  inspect(f.units_per_em(), content="2000")
  inspect(f.ascender(), content="800")
  inspect(f.descender(), content="-200")
  inspect(f.height(), content="2400")
}

///|
test "parity/minimal_fontmatrix.pfb: bbox" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  inspect(f.bbox().x_min(), content="0")
  inspect(f.bbox().y_min(), content="-200")
  inspect(f.bbox().x_max(), content="500")
  inspect(f.bbox().y_max(), content="800")
}

///|
test "parity/minimal_fontmatrix.pfb: flags" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="false")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/minimal_fontmatrix.pfb: charmaps" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  inspect(f.charmaps().length(), content="2")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="3")
    inspect(f.charmaps()[0].encoding_id(), content="1")
  }
  if f.charmaps().length() > 1 {
    inspect(f.charmaps()[1].platform_id(), content="7")
    inspect(f.charmaps()[1].encoding_id(), content="2")
  }
}

///|
test "parity/minimal_fontmatrix.pfb: charmap entries" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 65U), content="2")
  inspect(@freetype.get_char_index(f, 160U), content="1")
}

///|
test "parity/minimal_fontmatrix.pfb: glyph 2 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  let r = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="3")
  inspect(f.glyph().outline().n_contours(), content="1")
  inspect(f.glyph().outline().points()[0].x(), content="50")
  inspect(f.glyph().outline().points()[0].y(), content="0")
  inspect(f.glyph().outline().points()[1].x(), content="250")
  inspect(f.glyph().outline().points()[1].y(), content="700")
  inspect(f.glyph().outline().points()[2].x(), content="450")
  inspect(f.glyph().outline().points()[2].y(), content="0")
  inspect(f.glyph().metrics().hori_advance(), content="500")
}

///|
test "parity/minimal_fontmatrix.pfb: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="256")
}

///|
test "parity/minimal_fontmatrix.pfb: rendered glyph 1 NORMAL NO_HINTING char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
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
test "parity/minimal_fontmatrix.pfb: rendered glyph 2 NORMAL NO_HINTING char 65" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="4")
  inspect(f.glyph().bitmap().rows(), content="6")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="6")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000c0c0000504f000099980000e1e1002bffff2a74ffff73")
}

///|
test "parity/minimal_fontmatrix.pfb: rendered glyph 1 LIGHT NO_HINTING char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
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
test "parity/minimal_fontmatrix.pfb: rendered glyph 2 LIGHT NO_HINTING char 65" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="4")
  inspect(f.glyph().bitmap().rows(), content="6")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="6")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000c0c0000504f000099980000e1e1002bffff2a74ffff73")
}

///|
test "parity/minimal_fontmatrix.pfb: rendered glyph 1 MONO NO_HINTING char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
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
test "parity/minimal_fontmatrix.pfb: rendered glyph 2 MONO NO_HINTING char 65" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="4")
  inspect(f.glyph().bitmap().rows(), content="6")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="6")
  inspect(f.glyph().bitmap().buffer().length(), content="12")
}

///|
test "parity/minimal_fontmatrix.pfb: rendered glyph 1 LCD NO_HINTING char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
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
test "parity/minimal_fontmatrix.pfb: rendered glyph 2 LCD NO_HINTING char 65" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="12")
  inspect(f.glyph().bitmap().rows(), content="6")
  inspect(f.glyph().bitmap().pitch(), content="12")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="6")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000c19190c00000000000000075099984f070000000000024599eaea98440100000000368ee1ffffe18d350000002b7fd7ffffffffd67e2a001f74c8ffffffffffffc7731f")
}

///|
test "parity/minimal_fontmatrix.pfb: rendered glyph 1 LCD_V NO_HINTING char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
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

///|
test "parity/minimal_fontmatrix.pfb: rendered glyph 2 LCD_V NO_HINTING char 65" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="4")
  inspect(f.glyph().bitmap().rows(), content="21")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="6")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00020200000c0c00001f1e000038370000504f0000686700008180000099980000b1b00000cac90000e1e10006f3f30615fdfd142bffff2a43ffff425cffff5b74ffff7355acac552e54542d0000000000000000")
}

///|
test "parity/minimal_fontmatrix.pfb: rendered glyph 1 NORMAL DEFAULT char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/minimal_fontmatrix.pfb: rendered glyph 2 NORMAL DEFAULT char 65" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/minimal_fontmatrix.pfb: rendered glyph 1 LIGHT DEFAULT char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/minimal_fontmatrix.pfb: rendered glyph 2 LIGHT DEFAULT char 65" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/minimal_fontmatrix.pfb: rendered glyph 1 MONO DEFAULT char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/minimal_fontmatrix.pfb: rendered glyph 2 MONO DEFAULT char 65" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/minimal_fontmatrix.pfb: rendered glyph 1 LCD DEFAULT char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/minimal_fontmatrix.pfb: rendered glyph 2 LCD DEFAULT char 65" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/minimal_fontmatrix.pfb: rendered glyph 1 LCD_V DEFAULT char 32" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/minimal_fontmatrix.pfb: rendered glyph 2 LCD_V DEFAULT char 65" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/minimal_fontmatrix.pfb: hinted outline DEFAULT 16ppem" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="3")
  inspect(f.glyph().metrics().width(), content="256")
  inspect(f.glyph().metrics().height(), content="384")
  inspect(f.glyph().metrics().hori_advance(), content="256")
}

///|
test "parity/minimal_fontmatrix.pfb: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="256")
}

///|
test "parity/minimal_fontmatrix.pfb: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_minimal_fontmatrix_pfb())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_FORCE_AUTOHINT)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="256")
}

