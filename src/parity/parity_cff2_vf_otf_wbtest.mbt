// Parity tests for cff2_vf.otf
// AUTO-GENERATED — do not edit

///|
fn load_generated_cff2_vf_otf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/cff2_vf.otf")
}

///|
test "parity/cff2_vf.otf: format" {
  inspect(@base.detect_format(load_generated_cff2_vf_otf()), content="Cff2OpenType")
}

///|
test "parity/cff2_vf.otf: loads" {
  inspect((try? @freetype.from_bytes(load_generated_cff2_vf_otf())) is Ok(_), content="true")
}

///|
test "parity/cff2_vf.otf: metadata" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  inspect(f.family_name(), content="Test VF")
  inspect(f.num_glyphs(), content="4")
  inspect(f.units_per_em(), content="1000")
  inspect(f.ascender(), content="1036")
  inspect(f.descender(), content="-335")
  inspect(f.height(), content="1371")
  inspect(f.underline_position(), content="-75")
  inspect(f.underline_thickness(), content="50")
}

///|
test "parity/cff2_vf.otf: bbox" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  inspect(f.bbox().x_min(), content="5")
  inspect(f.bbox().y_min(), content="0")
  inspect(f.bbox().x_max(), content="697")
  inspect(f.bbox().y_max(), content="675")
}

///|
test "parity/cff2_vf.otf: flags" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/cff2_vf.otf: charmaps" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  inspect(f.charmaps().length(), content="3")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="0")
    inspect(f.charmaps()[0].encoding_id(), content="3")
  }
  if f.charmaps().length() > 1 {
    inspect(f.charmaps()[1].platform_id(), content="1")
    inspect(f.charmaps()[1].encoding_id(), content="0")
  }
  if f.charmaps().length() > 2 {
    inspect(f.charmaps()[2].platform_id(), content="3")
    inspect(f.charmaps()[2].encoding_id(), content="1")
  }
}

///|
test "parity/cff2_vf.otf: charmap entries" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  inspect(@freetype.get_char_index(f, 65U), content="1")
  inspect(@freetype.get_char_index(f, 84U), content="2")
  inspect(@freetype.get_char_index(f, 1084U), content="3")
}

///|
test "parity/cff2_vf.otf: glyph 1 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  let r = try? @freetype.load_glyph(f, 1U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="24")
  inspect(f.glyph().outline().n_contours(), content="4")
  inspect(f.glyph().outline().points()[0].x(), content="5")
  inspect(f.glyph().outline().points()[0].y(), content="0")
  inspect(f.glyph().outline().points()[1].x(), content="235")
  inspect(f.glyph().outline().points()[1].y(), content="0")
  inspect(f.glyph().outline().points()[2].x(), content="235")
  inspect(f.glyph().outline().points()[2].y(), content="40")
  inspect(f.glyph().outline().points()[3].x(), content="125")
  inspect(f.glyph().outline().points()[3].y(), content="55")
  inspect(f.glyph().outline().points()[4].x(), content="105")
  inspect(f.glyph().outline().points()[4].y(), content="55")
  inspect(f.glyph().outline().points()[5].x(), content="5")
  inspect(f.glyph().outline().points()[5].y(), content="40")
  inspect(f.glyph().outline().points()[6].x(), content="71")
  inspect(f.glyph().outline().points()[6].y(), content="0")
  inspect(f.glyph().outline().points()[7].x(), content="118")
  inspect(f.glyph().outline().points()[7].y(), content="0")
  inspect(f.glyph().metrics().hori_advance(), content="663")
}

///|
test "parity/cff2_vf.otf: glyph 2 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  let r = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="32")
  inspect(f.glyph().outline().n_contours(), content="3")
  inspect(f.glyph().outline().points()[0].x(), content="291")
  inspect(f.glyph().outline().points()[0].y(), content="55")
  inspect(f.glyph().outline().points()[1].x(), content="151")
  inspect(f.glyph().outline().points()[1].y(), content="40")
  inspect(f.glyph().outline().points()[2].x(), content="151")
  inspect(f.glyph().outline().points()[2].y(), content="0")
  inspect(f.glyph().outline().points()[3].x(), content="451")
  inspect(f.glyph().outline().points()[3].y(), content="0")
  inspect(f.glyph().outline().points()[4].x(), content="451")
  inspect(f.glyph().outline().points()[4].y(), content="40")
  inspect(f.glyph().outline().points()[5].x(), content="311")
  inspect(f.glyph().outline().points()[5].y(), content="55")
  inspect(f.glyph().outline().points()[6].x(), content="256")
  inspect(f.glyph().outline().points()[6].y(), content="310")
  inspect(f.glyph().outline().points()[7].x(), content="256")
  inspect(f.glyph().outline().points()[7].y(), content="205")
  inspect(f.glyph().metrics().hori_advance(), content="602")
}

///|
test "parity/cff2_vf.otf: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 1U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="704")
}

///|
test "parity/cff2_vf.otf: rendered glyph 1 NORMAL char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="11")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000003bbe020000000000000000abff400000000000000005b6db9700000000000000497185ea03000000000000a01c2fff45000000000007b40000d99c000000000055a83b3bbfff0500000000bf987f7fadff4a0000000bb200000000d7a100000058660000000081f10700a6ffe38700009af7ffff4d")
}

///|
test "parity/cff2_vf.otf: rendered glyph 1 LIGHT char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="11")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000003bbe020000000000000000abff400000000000000005b6db9700000000000000497185ea03000000000000a01c2fff45000000000007b40000d99c000000000055a83b3bbfff0500000000bf987f7fadff4a0000000bb200000000d7a100000058660000000081f10700a6ffe38700009af7ffff4d")
}

///|
test "parity/cff2_vf.otf: rendered glyph 1 MONO char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  inspect(f.glyph().bitmap().buffer().length(), content="22")
}

///|
test "parity/cff2_vf.otf: rendered glyph 1 LCD char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="36")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="36")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="-1")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000033b7ec0be7e38020000000000000000000000000000000000000000000000000000000345abffffffe99440030000000000000000000000000000000000000000000000000005459cb6a5a6dbffe8974303000000000000000000000000000000000000000000000006499cb5711f3185d9ffea9a4203000000000000000000000000000000000000000000064da0b56e1c00002f83dbffec99450400000000000000000000000000000000000000074da3b46f1a000000002d85d9ffec9c480400000000000000000000000000000000000955bae0a8563b3b3b3b3b3c6bbfffffffa047050000000000000000000000000000000954bff7d8987f7f7f7f7f7f7f80adffffffff9e4a06000000000000000000000000000b54a9b26915000000000000000000002b83d7ffefa14d0600000000000000000000000d58a9b166160000000000000000000000002d81d5fff1a44c070000000000002a67a6ccffffffffe3c2b7874a0f00000000215e9ab8c3f7ffffffffffffbf894d14")
}

///|
test "parity/cff2_vf.otf: rendered glyph 1 LCD_V char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="39")
  inspect(f.glyph().bitmap().pitch(), content="11")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000000000000051a0000000000000000001c6a0000000000000000003bbe0200000000000000005ef70d000000000000000088ff240000000000000000abff400000000000000000c0ff5c0000000000000000c0f27a0000000000000005b6db970000000000000013a7bfb4000000000000002c8ea1d100000000000000497185ea03000000000000665569fa1100000000000084374bff29000000000000a01c2fff45000000000000b20a16fc62000000000000bb0006ef80000000000007b40000d99c000000000018a40000bcb90000000000348800009fd7000000000055a83b3bbfff050000000080df8f8ff6ff1400000000a9edbbbbffff2e00000000bf987f7fadff4a00000000c2332b2b40ff6700000001bc00000005ee850000000bb200000000d7a10000001e9f00000000babe0000003b82000000009ddc00000058660000000081f1070009a16c0400000585ff2c0059ffa647000051c0ff9f27a6ffe38700009af7ffff4d9dffb182000095bfffeb4c4d93534000004958a7772600000000000000000000000000000000000000000000")
}

///|
test "parity/cff2_vf.otf: hinted outline DEFAULT 16ppem" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 1U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="24")
  inspect(f.glyph().metrics().width(), content="704")
  inspect(f.glyph().metrics().height(), content="704")
  inspect(f.glyph().metrics().hori_advance(), content="704")
}

///|
test "parity/cff2_vf.otf: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 1U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="679")
}

///|
test "parity/cff2_vf.otf: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 1U, load_flags=@base.LOAD_FORCE_AUTOHINT)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="704")
}

///|
test "parity/cff2_vf.otf: variation state" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  inspect(f.has_multiple_masters(), content="true")
  inspect(f.is_variation(), content="false")
  try! @freetype.set_var_design_coordinates(
    f,
    [
      (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
    ],
  )
  inspect(f.is_variation(), content="true")
}

///|
test "parity/cff2_vf.otf: varied 65 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_var_design_coordinates(
    f,
    [
      (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
    ],
  )
  let gid = @freetype.get_char_index(f, 65U)
  let r = try? @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(gid, content="1")
  inspect(f.glyph().outline().n_points(), content="24")
  inspect(f.glyph().outline().n_contours(), content="4")
  inspect(f.glyph().metrics().hori_advance(), content="680")
  inspect(f.glyph().metrics().width(), content="655")
  inspect(f.glyph().metrics().hori_bearing_x(), content="10")
  inspect(f.glyph().outline().points()[0].x(), content="10")
  inspect(f.glyph().outline().points()[0].y(), content="0")
  inspect(f.glyph().outline().points()[1].x(), content="220")
  inspect(f.glyph().outline().points()[1].y(), content="0")
  inspect(f.glyph().outline().points()[2].x(), content="220")
  inspect(f.glyph().outline().points()[2].y(), content="59")
  inspect(f.glyph().outline().points()[3].x(), content="131")
  inspect(f.glyph().outline().points()[3].y(), content="74")
}

///|
test "parity/cff2_vf.otf: varied outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_var_design_coordinates(
    f,
    [
      (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
    ],
  )
  let gid = @freetype.get_char_index(f, 65U)
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="696")
  inspect(f.glyph().metrics().width(), content="671")
  inspect(f.glyph().metrics().height(), content="668")
  inspect(f.glyph().metrics().hori_bearing_x(), content="10")
  inspect(f.glyph().metrics().hori_bearing_y(), content="668")
  inspect(f.glyph().outline().points()[0].x(), content="10")
  inspect(f.glyph().outline().points()[0].y(), content="0")
}

///|
test "parity/cff2_vf.otf: varied hinted outline DEFAULT 16ppem" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_var_design_coordinates(
    f,
    [
      (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
    ],
  )
  let gid = @freetype.get_char_index(f, 65U)
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, gid)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="704")
  inspect(f.glyph().metrics().width(), content="704")
  inspect(f.glyph().metrics().height(), content="704")
  inspect(f.glyph().metrics().hori_bearing_x(), content="0")
  inspect(f.glyph().metrics().hori_bearing_y(), content="704")
}

///|
test "parity/cff2_vf.otf: varied outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_var_design_coordinates(
    f,
    [
      (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
    ],
  )
  let gid = @freetype.get_char_index(f, 65U)
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, gid, load_flags=@base.LOAD_FORCE_AUTOHINT)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="768")
}

