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
test "parity/cff2_vf.otf: rendered glyph 1 NORMAL NO_HINTING 16ppem char 65" {
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
test "parity/cff2_vf.otf: rendered glyph 1 LIGHT NO_HINTING 16ppem char 65" {
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
test "parity/cff2_vf.otf: rendered glyph 1 MONO NO_HINTING 16ppem char 65" {
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
test "parity/cff2_vf.otf: rendered glyph 1 LCD NO_HINTING 16ppem char 65" {
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
test "parity/cff2_vf.otf: rendered glyph 1 LCD_V NO_HINTING 16ppem char 65" {
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
test "parity/cff2_vf.otf: rendered glyph 1 NORMAL DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/cff2_vf.otf: rendered glyph 1 LIGHT DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/cff2_vf.otf: rendered glyph 1 MONO DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/cff2_vf.otf: rendered glyph 1 LCD DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/cff2_vf.otf: rendered glyph 1 LCD_V DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/cff2_vf.otf: rendered glyph 1 NORMAL NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="24")
  inspect(f.glyph().bitmap().rows(), content="25")
  inspect(f.glyph().bitmap().pitch(), content="24")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="25")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000b4b4b0800000000000000000000000000000000000000005effff540000000000000000000000000000000000000000b6ffffac0000000000000000000000000000000000000013fffffff60c00000000000000000000000000000000000065ffffffff5a000000000000000000000000000000000000bde28cffffb1000000000000000000000000000000000018fd8c35fffff910000000000000000000000000000000006dff3500deffff6000000000000000000000000000000000c5de000089ffffb70000000000000000000000000000001efe86000033fffffb13000000000000000000000000000075ff2f000000ddffff660000000000000000000000000000cdd80000000087ffffbd0000000000000000000000000025ff810000000031fffffd170000000000000000000000007dff2a0000000000dbffff6b000000000000000000000000d4d200000000000085ffffc300000000000000000000002cffff8b8b8b8b8b8bbcfffffe1c0000000000000000000084ffffffffffffffffffffffff7100000000000000000000dce51b1b1b1b1b1b1b1ba0ffffc800000000000000000034ff7600000000000000002effffff2100000000000000008cff20000000000000000000d8ffff770000000000000001e3c70000000000000000000082ffffce000000000000003cff70000000000000000000002cffffff2600000000000094fe1b0000000000000000000000d6ffff7d00000067a2ccffffd7b49136000000001985a4c3ffffffffae8f3dcfffffffffffffff730000000037ffffffffffffffffff83")
}

///|
test "parity/cff2_vf.otf: rendered glyph 1 LIGHT NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="24")
  inspect(f.glyph().bitmap().rows(), content="25")
  inspect(f.glyph().bitmap().pitch(), content="24")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="25")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000b4b4b0800000000000000000000000000000000000000005effff540000000000000000000000000000000000000000b6ffffac0000000000000000000000000000000000000013fffffff60c00000000000000000000000000000000000065ffffffff5a000000000000000000000000000000000000bde28cffffb1000000000000000000000000000000000018fd8c35fffff910000000000000000000000000000000006dff3500deffff6000000000000000000000000000000000c5de000089ffffb70000000000000000000000000000001efe86000033fffffb13000000000000000000000000000075ff2f000000ddffff660000000000000000000000000000cdd80000000087ffffbd0000000000000000000000000025ff810000000031fffffd170000000000000000000000007dff2a0000000000dbffff6b000000000000000000000000d4d200000000000085ffffc300000000000000000000002cffff8b8b8b8b8b8bbcfffffe1c0000000000000000000084ffffffffffffffffffffffff7100000000000000000000dce51b1b1b1b1b1b1b1ba0ffffc800000000000000000034ff7600000000000000002effffff2100000000000000008cff20000000000000000000d8ffff770000000000000001e3c70000000000000000000082ffffce000000000000003cff70000000000000000000002cffffff2600000000000094fe1b0000000000000000000000d6ffff7d00000067a2ccffffd7b49136000000001985a4c3ffffffffae8f3dcfffffffffffffff730000000037ffffffffffffffffff83")
}

///|
test "parity/cff2_vf.otf: rendered glyph 1 MONO NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="24")
  inspect(f.glyph().bitmap().rows(), content="24")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="24")
  inspect(f.glyph().bitmap().buffer().length(), content="96")
}

///|
test "parity/cff2_vf.otf: rendered glyph 1 LCD NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="75")
  inspect(f.glyph().bitmap().rows(), content="25")
  inspect(f.glyph().bitmap().pitch(), content="76")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="-1")
  inspect(f.glyph().bitmap_top(), content="25")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000000000000000000000000000b243e4b4b4b4b3b21080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000105eb2f9fffffffff5a8540b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001062b6f9fffffffffffff5ac580b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001361b9fffffffffffffffffff6af570c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001565b9fcfffffffffffffffffffff8ae5a0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001569bdfcffe2906e8cdefffffffffffff7b15d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001869c1fdffdf8c38013589e0fffffffffffff9b55d1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001b6dc1feffe08935010000338bdefffffffffffffab460120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001b71c5feffde8a3200000000003589ddfffffffffffffab76311000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e71c9feffda8632000000000000003387dffffffffffffffbba621300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002275c9ffffdb832f0000000000000000003189ddfffffffffffffcba66160000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002279cdffffd8842c00000000000000000000003387dbfffffffffffffcbd6915000000000000000000000000000000000000000000000000000000000000000000000000000000000000002579d1ffffd5812d000000000000000000000000003185ddfffffffffffffdc068170000000000000000000000000000000000000000000000000000000000000000000000000000000000297dd1ffffd67e2a0000000000000000000000000000002f87dbfffffffffffffdbf6b1a0000000000000000000000000000000000000000000000000000000000000000000000000000002980d4ffffd27e2700000000000000000000000000000000003185d9fffffffffffffdc36f19000000000000000000000000000000000000000000000000000000000000000000000000002c80e1ffffffffb48b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8cbcfffffffffffffffffec66e1c00000000000000000000000000000000000000000000000000000000000000000000003084e2fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffec5711e0000000000000000000000000000000000000000000000000000000000000000003088dcffffe5953e1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1c4ca0f4fffffffffffffec8741e000000000000000000000000000000000000000000000000000000000000003488dfffffca7623000000000000000000000000000000000000000000000000002e82daffffffffffffffcc74210000000000000000000000000000000000000000000000000000000000388cdfffffca72200000000000000000000000000000000000000000000000000000002c84d8ffffffffffffffcb77230000000000000000000000000000000000000000000000000000013890e3fffec7731d00000000000000000000000000000000000000000000000000000000002e82d6ffffffffffffffce7a23000000000000000000000000000000000000000000000000023c90e6fffec4701e000000000000000000000000000000000000000000000000000000000000002c80d8ffffffffffffffd1792600000000000000000000000000000000000000000000024094e6fffec56d1b0000000000000000000000000000000000000000000000000000000000000000002a82d6ffffffffffffffd17d29000000000000000000000000103a678895a2afbcccfffffffffffffffcd7ccc0b4a89c918562360e0000000000000000000000000019416f858f9aa4aeb9c3cdffffffffffffffffffffffffe1aea4998f84693d15000000237bcfffffffffffffffffffffffffffffffffffffffffffffc7731f00000000000000000000000000378be3ffffffffffffffffffffffffffffffffffffffffffffffffffffd7832f00")
}

///|
test "parity/cff2_vf.otf: rendered glyph 1 LCD_V NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="24")
  inspect(f.glyph().bitmap().rows(), content="78")
  inspect(f.glyph().bitmap().pitch(), content="24")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="25")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000000000000000000000000000b4b4b080000000000000000000000000000000000000000209f9f1a000000000000000000000000000000000000000040f7f73800000000000000000000000000000000000000005effff5400000000000000000000000000000000000000007affff71000000000000000000000000000000000000000099ffff8f0000000000000000000000000000000000000000b6ffffac0000000000000000000000000000000000000000d2ffffc80000000000000000000000000000000000000004f8ffffe40200000000000000000000000000000000000013fffffff60c0000000000000000000000000000000000002affffffff2100000000000000000000000000000000000048ffffffff3e00000000000000000000000000000000000065ffffffff5a00000000000000000000000000000000000082ffe4ffff77000000000000000000000000000000000000a0f5b2ffff95000000000000000000000000000000000000bde28cffffb1000000000000000000000000000000000000dac66effffce000000000000000000000000000000000007f1a851ffffe9030000000000000000000000000000000018fd8c35fffff9100000000000000000000000000000000032ff6f1afeffff260000000000000000000000000000000050ff5108f2ffff43000000000000000000000000000000006dff3500deffff60000000000000000000000000000000008afd1a00c2ffff7d00000000000000000000000000000000a8f20800a5ffff9b00000000000000000000000000000000c5de000089ffffb700000000000000000000000000000001e1c100006dffffd40000000000000000000000000000000bf5a300004fffffed0500000000000000000000000000001efe86000033fffffb1300000000000000000000000000003aff6a000019fdffff2b000000000000000000000000000058ff4c000007f1ffff49000000000000000000000000000075ff2f000000ddffff66000000000000000000000000000092fc16000000c1ffff820000000000000000000000000000b0ef06000000a3ffffa00000000000000000000000000000cdd80000000087ffffbd0000000000000000000000000002e7bb000000006bffffda000000000000000000000000000ff89d000000004dfffff10700000000000000000000000025ff810000000031fffffd1700000000000000000000000041ff640000000018fdffff3100000000000000000000000060ff460000000007f0ffff4f0000000000000000000000007dff2a0000000000dbffff6b00000000000000000000000099fa120000000000bfffff88000000000000000000000000b8eb040000000000a2ffffa6000000000000000000000000d4d200000000000085ffffc3000000000000000000000005ecb600000000000069ffffdf000000000000000000000014ffd037373737373784fffff40a000000000000000000002cffff8b8b8b8b8b8bbcfffffe1c0000000000000000000049ffffdfdfdfdfdfdff7ffffff370000000000000000000067ffffffffffffffffffffffff550000000000000000000084ffffffffffffffffffffffff7100000000000000000000a1ffd7c7c7c7c7c7c7c7ffffff8e00000000000000000000bfff726f6f6f6f6f6f6fffffffac00000000000000000000dce51b1b1b1b1b1b1b1ba0ffffc800000000000000000008f1b0000000000000000068ffffe40100000000000000001afd9200000000000000004afffff60c000000000000000034ff7600000000000000002effffff21000000000000000051ff59000000000000000016fcffff3c00000000000000006fff3b000000000000000005eeffff5a00000000000000008cff20000000000000000000d8ffff770000000000000000a9f60c000000000000000000bcffff940000000000000000c7e3010000000000000000009effffb20000000000000001e3c70000000000000000000082ffffce000000000000000bf5ab0000000000000000000066ffffe80300000000000020ff8d0000000000000000000048fffff9100000000000003cff70000000000000000000002cffffff2600000000000059ff530000000000000000000014fbffff4200000000000077ff350000000000000000000005edffff6000000000000094fe1b0000000000000000000000d6ffff7d00000000011df5ff350900000000000000000117f0ffffbb050000234e75ffff84603d10000000000631506fffffffff5a3b1267a2ccffffd7b49136000000001985a4c3ffffffffae8f3dabf5fffffffffee55c000000002bd9f7ffffffffffffe369cfffffffffffffff730000000037ffffffffffffffffff83cfffffffffffffff730000000037ffffffffffffffffff838babe3ffeaababab4d0000000025abababbfffffffd3ab58445374a76d53535326000000001253535358a7a7a76c532b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/cff2_vf.otf: rendered glyph 1 NORMAL DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/cff2_vf.otf: rendered glyph 1 LIGHT DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/cff2_vf.otf: rendered glyph 1 MONO DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/cff2_vf.otf: rendered glyph 1 LCD DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/cff2_vf.otf: rendered glyph 1 LCD_V DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_cff2_vf_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
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

