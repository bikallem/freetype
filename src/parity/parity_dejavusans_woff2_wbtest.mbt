// Parity tests for DejaVuSans.woff2
// AUTO-GENERATED — do not edit

///|
fn load_generated_dejavusans_woff2() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/DejaVuSans.woff2")
}

///|
test "parity/DejaVuSans.woff2: format" {
  inspect(@base.detect_format(load_generated_dejavusans_woff2()), content="Woff2")
}

///|
test "parity/DejaVuSans.woff2: loads" {
  inspect((try? @freetype.from_bytes(load_generated_dejavusans_woff2())) is Ok(_), content="true")
}

///|
test "parity/DejaVuSans.woff2: metadata" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  inspect(f.family_name(), content="DejaVu Sans")
  inspect(f.num_glyphs(), content="6253")
  inspect(f.units_per_em(), content="2048")
  inspect(f.ascender(), content="1901")
  inspect(f.descender(), content="-483")
  inspect(f.height(), content="2384")
  inspect(f.underline_position(), content="-175")
  inspect(f.underline_thickness(), content="90")
}

///|
test "parity/DejaVuSans.woff2: bbox" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  inspect(f.bbox().x_min(), content="-2090")
  inspect(f.bbox().y_min(), content="-948")
  inspect(f.bbox().x_max(), content="3673")
  inspect(f.bbox().y_max(), content="2524")
}

///|
test "parity/DejaVuSans.woff2: flags" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="true")
}

///|
test "parity/DejaVuSans.woff2: charmaps" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  inspect(f.charmaps().length(), content="5")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="0")
    inspect(f.charmaps()[0].encoding_id(), content="3")
  }
  if f.charmaps().length() > 1 {
    inspect(f.charmaps()[1].platform_id(), content="0")
    inspect(f.charmaps()[1].encoding_id(), content="10")
  }
  if f.charmaps().length() > 2 {
    inspect(f.charmaps()[2].platform_id(), content="1")
    inspect(f.charmaps()[2].encoding_id(), content="0")
  }
  if f.charmaps().length() > 3 {
    inspect(f.charmaps()[3].platform_id(), content="3")
    inspect(f.charmaps()[3].encoding_id(), content="1")
  }
  if f.charmaps().length() > 4 {
    inspect(f.charmaps()[4].platform_id(), content="3")
    inspect(f.charmaps()[4].encoding_id(), content="10")
  }
}

///|
test "parity/DejaVuSans.woff2: charmap entries" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  inspect(@freetype.get_char_index(f, 32U), content="3")
  inspect(@freetype.get_char_index(f, 33U), content="4")
  inspect(@freetype.get_char_index(f, 34U), content="5")
  inspect(@freetype.get_char_index(f, 35U), content="6")
  inspect(@freetype.get_char_index(f, 36U), content="7")
  inspect(@freetype.get_char_index(f, 37U), content="8")
  inspect(@freetype.get_char_index(f, 38U), content="9")
  inspect(@freetype.get_char_index(f, 39U), content="10")
  inspect(@freetype.get_char_index(f, 40U), content="11")
  inspect(@freetype.get_char_index(f, 41U), content="12")
  inspect(@freetype.get_char_index(f, 42U), content="13")
  inspect(@freetype.get_char_index(f, 43U), content="14")
  inspect(@freetype.get_char_index(f, 44U), content="15")
  inspect(@freetype.get_char_index(f, 45U), content="16")
  inspect(@freetype.get_char_index(f, 46U), content="17")
  inspect(@freetype.get_char_index(f, 47U), content="18")
  inspect(@freetype.get_char_index(f, 48U), content="19")
  inspect(@freetype.get_char_index(f, 49U), content="20")
  inspect(@freetype.get_char_index(f, 50U), content="21")
  inspect(@freetype.get_char_index(f, 51U), content="22")
  inspect(@freetype.get_char_index(f, 52U), content="23")
  inspect(@freetype.get_char_index(f, 53U), content="24")
  inspect(@freetype.get_char_index(f, 54U), content="25")
  inspect(@freetype.get_char_index(f, 55U), content="26")
  inspect(@freetype.get_char_index(f, 56U), content="27")
  inspect(@freetype.get_char_index(f, 57U), content="28")
  inspect(@freetype.get_char_index(f, 58U), content="29")
  inspect(@freetype.get_char_index(f, 59U), content="30")
  inspect(@freetype.get_char_index(f, 60U), content="31")
  inspect(@freetype.get_char_index(f, 61U), content="32")
  inspect(@freetype.get_char_index(f, 62U), content="33")
  inspect(@freetype.get_char_index(f, 63U), content="34")
  inspect(@freetype.get_char_index(f, 64U), content="35")
  inspect(@freetype.get_char_index(f, 65U), content="36")
  inspect(@freetype.get_char_index(f, 66U), content="37")
  inspect(@freetype.get_char_index(f, 67U), content="38")
  inspect(@freetype.get_char_index(f, 68U), content="39")
  inspect(@freetype.get_char_index(f, 69U), content="40")
  inspect(@freetype.get_char_index(f, 70U), content="41")
  inspect(@freetype.get_char_index(f, 71U), content="42")
  inspect(@freetype.get_char_index(f, 72U), content="43")
  inspect(@freetype.get_char_index(f, 73U), content="44")
  inspect(@freetype.get_char_index(f, 74U), content="45")
  inspect(@freetype.get_char_index(f, 75U), content="46")
  inspect(@freetype.get_char_index(f, 76U), content="47")
  inspect(@freetype.get_char_index(f, 77U), content="48")
  inspect(@freetype.get_char_index(f, 78U), content="49")
  inspect(@freetype.get_char_index(f, 79U), content="50")
  inspect(@freetype.get_char_index(f, 80U), content="51")
  inspect(@freetype.get_char_index(f, 81U), content="52")
  inspect(@freetype.get_char_index(f, 66304U), content="5373")
}

///|
test "parity/DejaVuSans.woff2: glyph 4 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  let r = try? @freetype.load_glyph(f, 4U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="10")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="309")
  inspect(f.glyph().outline().points()[0].y(), content="254")
  inspect(f.glyph().outline().points()[1].x(), content="512")
  inspect(f.glyph().outline().points()[1].y(), content="254")
  inspect(f.glyph().outline().points()[2].x(), content="512")
  inspect(f.glyph().outline().points()[2].y(), content="0")
  inspect(f.glyph().outline().points()[3].x(), content="309")
  inspect(f.glyph().outline().points()[3].y(), content="0")
  inspect(f.glyph().outline().points()[4].x(), content="309")
  inspect(f.glyph().outline().points()[4].y(), content="1493")
  inspect(f.glyph().outline().points()[5].x(), content="512")
  inspect(f.glyph().outline().points()[5].y(), content="1493")
  inspect(f.glyph().outline().points()[6].x(), content="512")
  inspect(f.glyph().outline().points()[6].y(), content="838")
  inspect(f.glyph().outline().points()[7].x(), content="492")
  inspect(f.glyph().outline().points()[7].y(), content="481")
  inspect(f.glyph().metrics().hori_advance(), content="821")
}

///|
test "parity/DejaVuSans.woff2: glyph 5 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  let r = try? @freetype.load_glyph(f, 5U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="8")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="367")
  inspect(f.glyph().outline().points()[0].y(), content="1493")
  inspect(f.glyph().outline().points()[1].x(), content="367")
  inspect(f.glyph().outline().points()[1].y(), content="938")
  inspect(f.glyph().outline().points()[2].x(), content="197")
  inspect(f.glyph().outline().points()[2].y(), content="938")
  inspect(f.glyph().outline().points()[3].x(), content="197")
  inspect(f.glyph().outline().points()[3].y(), content="1493")
  inspect(f.glyph().outline().points()[4].x(), content="745")
  inspect(f.glyph().outline().points()[4].y(), content="1493")
  inspect(f.glyph().outline().points()[5].x(), content="745")
  inspect(f.glyph().outline().points()[5].y(), content="938")
  inspect(f.glyph().outline().points()[6].x(), content="575")
  inspect(f.glyph().outline().points()[6].y(), content="938")
  inspect(f.glyph().outline().points()[7].x(), content="575")
  inspect(f.glyph().outline().points()[7].y(), content="1493")
  inspect(f.glyph().metrics().hori_advance(), content="942")
}

///|
test "parity/DejaVuSans.woff2: glyph 6 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  let r = try? @freetype.load_glyph(f, 6U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="32")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="1047")
  inspect(f.glyph().outline().points()[0].y(), content="901")
  inspect(f.glyph().outline().points()[1].x(), content="756")
  inspect(f.glyph().outline().points()[1].y(), content="901")
  inspect(f.glyph().outline().points()[2].x(), content="672")
  inspect(f.glyph().outline().points()[2].y(), content="567")
  inspect(f.glyph().outline().points()[3].x(), content="965")
  inspect(f.glyph().outline().points()[3].y(), content="567")
  inspect(f.glyph().outline().points()[4].x(), content="897")
  inspect(f.glyph().outline().points()[4].y(), content="1470")
  inspect(f.glyph().outline().points()[5].x(), content="793")
  inspect(f.glyph().outline().points()[5].y(), content="1055")
  inspect(f.glyph().outline().points()[6].x(), content="1085")
  inspect(f.glyph().outline().points()[6].y(), content="1055")
  inspect(f.glyph().outline().points()[7].x(), content="1190")
  inspect(f.glyph().outline().points()[7].y(), content="1470")
  inspect(f.glyph().metrics().hori_advance(), content="1716")
}

///|
test "parity/DejaVuSans.woff2: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 4U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="384")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 NORMAL NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
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
test "parity/DejaVuSans.woff2: rendered glyph 36 NORMAL NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="11")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000005eac560000000000000001ddfed10000000000000040ff8cff33000000000000a2de06ea9400000000000ef5810090ee070000000065ff230030ff5700000000c7c3000000d1b800000029ff9f505050a8fd1c00008affffffffffffff7b0004e7ae0000000000b7db004eff5300000000005cff3daff10800000000000cf59f")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 NORMAL NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="10")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00299fd9f0d58b0c0000599e5f4871e9bf000000000000004aff2b0000125e7c8894ff530047f5d7a599a0ff5c00d8af0000002aff5c01fb7400000071ff5c00d0d3250a57e7ff5c0037e3ffffe450ff5c0000062c2c03000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 NORMAL NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "002c9fc9d6be8b32004bfcd6817293da9000cbdd0a000000001500e7b000000000000000bbf54e0400000000002fe4fff3bd77200000000c5fa6dffff65600000000000036e2f10c00000000000073ff3605000000000085ff2dd2893716236cf7d2018ce3fffffffdb51d0000001933320f000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 NORMAL NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00004fcff0cc4b8d87003dfdb14e62dfe4b400bfd201000031ffb401f77e00000000dbb413ff6700000000c3b401f87d00000000d9b400c3cf0000002dffb40043feaa4659dce7b3000059d8f9d654c8aa00000000000009ef8600084c02000c9ffd2f000efaf8e4fcf4670000000b3b4e420e0000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 NORMAL NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="12")
  inspect(f.glyph().bitmap().rows(), content="15")
  inspect(f.glyph().bitmap().pitch(), content="12")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000002694ccd9bd70080000000057f9de846f9df9d31900002bf8bf0900000037f7be0000a2fc1f000000000091ff3d00eac100000000000030ff850cff9a0000000000000effa711ff9500000000000005fea902f8af00000000000023ff8e00c0ed07000000000066ff520058ff7f000000000cdfe3050000a8ff8f2b1645cbf939000000037dedffffffd72c000000000000032939bbf4360000000000000000000cc9ec2800000000000000000005100900")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 NORMAL NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="11")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000045b6d7c38109000000003cfdb96780d71c0000000093ea0400000102000000008bf50b000000000000000023fcac030000000000000099effca102000002441c6afa365bfd9c010029ff4dd7a9000061fe960064f70ef59100000068ff92d59500d0d6060000006dfff4130056ffb836163cb4f9ff8600005de6fffffebd2d77ff7f0000022a35150000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 NORMAL NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0029a3d6cf880d00002df3d9747fedca0600b2ef13000037ff6800efac00000000e1c100f4a600000000dbf100c7e106000020fbff0651ffb3434dd1f4ff09005ad9fff28da0f500000000050000d1c100000000000040ff6300266b2f2463edc403002ff1fffffba30f0000000428341100000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 LIGHT NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
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
test "parity/DejaVuSans.woff2: rendered glyph 36 LIGHT NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="11")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000005eac560000000000000001ddfed10000000000000040ff8cff33000000000000a2de06ea9400000000000ef5810090ee070000000065ff230030ff5700000000c7c3000000d1b800000029ff9f505050a8fd1c00008affffffffffffff7b0004e7ae0000000000b7db004eff5300000000005cff3daff10800000000000cf59f")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 LIGHT NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="10")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00299fd9f0d58b0c0000599e5f4871e9bf000000000000004aff2b0000125e7c8894ff530047f5d7a599a0ff5c00d8af0000002aff5c01fb7400000071ff5c00d0d3250a57e7ff5c0037e3ffffe450ff5c0000062c2c03000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 LIGHT NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "002c9fc9d6be8b32004bfcd6817293da9000cbdd0a000000001500e7b000000000000000bbf54e0400000000002fe4fff3bd77200000000c5fa6dffff65600000000000036e2f10c00000000000073ff3605000000000085ff2dd2893716236cf7d2018ce3fffffffdb51d0000001933320f000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 LIGHT NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00004fcff0cc4b8d87003dfdb14e62dfe4b400bfd201000031ffb401f77e00000000dbb413ff6700000000c3b401f87d00000000d9b400c3cf0000002dffb40043feaa4659dce7b3000059d8f9d654c8aa00000000000009ef8600084c02000c9ffd2f000efaf8e4fcf4670000000b3b4e420e0000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 LIGHT NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="12")
  inspect(f.glyph().bitmap().rows(), content="15")
  inspect(f.glyph().bitmap().pitch(), content="12")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000002694ccd9bd70080000000057f9de846f9df9d31900002bf8bf0900000037f7be0000a2fc1f000000000091ff3d00eac100000000000030ff850cff9a0000000000000effa711ff9500000000000005fea902f8af00000000000023ff8e00c0ed07000000000066ff520058ff7f000000000cdfe3050000a8ff8f2b1645cbf939000000037dedffffffd72c000000000000032939bbf4360000000000000000000cc9ec2800000000000000000005100900")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 LIGHT NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="11")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000045b6d7c38109000000003cfdb96780d71c0000000093ea0400000102000000008bf50b000000000000000023fcac030000000000000099effca102000002441c6afa365bfd9c010029ff4dd7a9000061fe960064f70ef59100000068ff92d59500d0d6060000006dfff4130056ffb836163cb4f9ff8600005de6fffffebd2d77ff7f0000022a35150000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 LIGHT NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0029a3d6cf880d00002df3d9747fedca0600b2ef13000037ff6800efac00000000e1c100f4a600000000dbf100c7e106000020fbff0651ffb3434dd1f4ff09005ad9fff28da0f500000000050000d1c100000000000040ff6300266b2f2463edc403002ff1fffffba30f0000000428341100000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 MONO NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
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
test "parity/DejaVuSans.woff2: rendered glyph 36 MONO NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  inspect(f.glyph().bitmap().buffer().length(), content="24")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 MONO NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="7")
  inspect(f.glyph().bitmap().rows(), content="9")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="9")
  inspect(f.glyph().bitmap().buffer().length(), content="18")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 MONO NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  inspect(f.glyph().bitmap().buffer().length(), content="24")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 MONO NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="9")
  inspect(f.glyph().bitmap().buffer().length(), content="24")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 MONO NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="14")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  inspect(f.glyph().bitmap().buffer().length(), content="28")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 MONO NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  inspect(f.glyph().bitmap().buffer().length(), content="24")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 MONO NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  inspect(f.glyph().bitmap().buffer().length(), content="24")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 LCD NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
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
test "parity/DejaVuSans.woff2: rendered glyph 36 LCD NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="39")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="40")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="-1")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000265e97acacac8e561d000000000000000000000000000000000000000000000000000000000001338bddfffefefeffd17d26000000000000000000000000000000000000000000000000000000044094e7ffe69b8ca5f1ffdd873301000000000000000000000000000000000000000000000000074ea2eeffde8b3306439beaffe5944003000000000000000000000000000000000000000000000e58b0f5ffd5812d0000023c90e1ffeea1490700000000000000000000000000000000000000001665b9faffce762300000000003084dbfff5ab570d0000000000000000000000000000000000001d73c7fdfdc36f1a00000000000000257dd1fff9b8641300000000000000000000000000000000297dd4ffffd99f665050505050505050506ea8e2fffdc56d1c0000000000000000000000000001368addffffffffffffffffffffffffffffffffffffffffffcf7b270000000000000000000000044098e7fff5ae5a0c000000000000000000000000001163b7f9ffdb8830000000000000000000094ea2f0fff4a7530b0000000000000000000000000000000f5cb0f8ffe6913d030000000000000d5baff5fff1a54d0800000000000000000000000000000000000c55adf5ffec9f4b06000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 LCD NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="27")
  inspect(f.glyph().bitmap().rows(), content="10")
  inspect(f.glyph().bitmap().pitch(), content="28")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000052955869fb8ccd9e3ecf0ece1d5c7b08b5b290c00000000000000000f5998c09e826c5f544a484d5a7193c5e9fef3bf6b1f0000000000000000000000000000000000000000000b4a9eebffd77f2b000000000000000003122e4b5e69737c838788888894bbe4fffda7530100000000124791d5f5fbedd7bfafa59f9a999898a0c2e6ffffb05c080000002c84d8ffedaf5b160000000000000000002a7ed6ffffb05c0800000150a8fbffc874200000000000000000002271c5fbffffb05c08000000267cd0fdfad3964d250e060a17305790cde7f4f5ffffb05c08000000000b3775bce3fafffffffffffff9e4bb7b5079c0ffffb05c08000000000000000006101f2c33332c1e0e030000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 LCD NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="30")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="32")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000001102c56809fb3bec9d3d8d6cfc7beb1a08b765932120000000000000000134b9ce1fcfff1d6b294817770727a8793a4bddaf1e1903c000000000000001f77cbffffdd933b0a0000000000000000000000000915150c000000000000003b93e7fffeb05c060000000000000000000000000000000000000000000000001567bbfafff5ca8c4e2a1004000000000000000000000000000000000000000000062f6cb8e4fafffffffdf3e3cfbda990775e3f20090000000000000000000000000000000c23435f7891a6b9cbdff1fdfffffff6d9a0561f0000000000000000000000000000000000000000000005153669afe2fefff1aa520c0000000000000000000000000000000000000000000000001f73c7ffffe28a360000000000050505000000000000000000000000000000013185d8ffffd9812d0000000000388cd2d3ad89684b37271c16151a2331496ca1d4f7fffbd27f2c0100000000001c518cb2cce3f5fefffffffffffffffffffdf2d9b5874a1d0300000000000000000000000000050e19222b333737322a1d0f050000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 LCD NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="30")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="32")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000004214f86b1cfe2eff0ede0ccaf814b2a528dc0c087480600000000000000073d8fdffdfbe0b1815f4e49506284b7dfdce0e4ffffb460080000000000001a6bbff9fed2802a0100000000000000033184d9ffffffb460080000000000014da5f7ffd27e2a00000000000000000000002f87dbffffb4600800000000001367bfffffbb67130000000000000000000000176fc3ffffb460080000000000014ea6f8ffd17d2900000000000000000000002d85d9ffffb460080000000000001c6fc3fafdcf7c260000000000000000012d80d6ffffffb4600800000000000000094396e4fef9dbaa7957464147597bb0dcdee3e7ffffb35f0700000000000000000007285990bbd8ecf7f9f6ead6ba8c543f79c8fffdaa56010000000000000000000000000000000000000000000000094ca4efffda8632000000000000000000082c474c2a100200000000010c295b9fd7fcfdd7802f010000000000000000000e5cb4fafffdf8efe6e4eaf5fcfffff4dba8672d0700000000000000000000000000020b1b2e3b444b4e4f4b4234200e030000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 LCD NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="39")
  inspect(f.glyph().bitmap().rows(), content="15")
  inspect(f.glyph().bitmap().pitch(), content="40")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000b264e7694acbfccd4d9d9d3cabda9907049200800000000000000000000000000000000022157a2dcf9fff6debc9984756f6f76879dc1e3f9fff6d3984b190000000000000000000000022b78cdf8ffefbf742d09000000000000000000000e3782ccf7fff3be6b1f0000000000000000084ea2eefffcc66f1f000000000000000000000000000000053d91e0ffffe6913d030000000000003e96eaffffc16d160000000000000000000000000000000000003084dcffffd9853100000000000c60b8ffffee9a46000000000000000000000000000000000000000e62bafffffaa75300000000001165bdffffe99541000000000000000000000000000000000000000557affefffba9550200000000024fa7f8fffbaf5b070000000000000000000000000000000000002377cfffffe28e3a000000000000176cc0fdffeda04807000000000000000000000000000000001966baf8fff3a6520b000000000000001258acf2fffacb7f31070000000000000000000000000c3f97dfffffe3953e05000000000000000000001a58a8e3fdffebc38f64402b1c16161d2d456898cbeffff9d386390b0000000000000000000000000000031c477dabd3edfbfffffffffffffffffffad7a25d2c0d0000000000000000000000000000000000000000000000030e1c293137394979bbecfff4ca7f360c00000000000000000000000000000000000000000000000000000000000000000c3681c9f3ffecba6828060000000000000000000000000000000000000000000000000000000000000000050a0f10100e090300000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 LCD NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="39")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="40")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000051d45759cb6c5d2d7d5cdc3b39c81572a090000000000000000000000000000000000000000093c8ddcfdfce1b98d726767718096b4d7b86e1c00000000000000000000000000000000000000003f93e7ffea9b43040000000000000000010303020000000000000000000000000000000000000000378bdffff5ad550b0000000000000000000000000000000000000000000000000000000000000000012373cafcffe4ac5c1f0300000000000000000000000000000000000000000000000000000000194e99d4f7efececfcfbdca1541b0200000000000000000219304444321c0500000000000000216abef4fad285360e225ba9e3fdfad99c4e18010000000000297dd5fff6a14d030000000000002b83d7fff4a9550900000000042561afe6fef9d5964a1500001464b8fbf7b1590e0000000000000049a1f5ffe5913d0000000000000000062968b4e9fff8d2927095d5fee29541060000000000000000247cd0ffffd6893106000000000000000000072d6db9ecfffffff4b35b1300000000000000000000001756a9eafffce2b88154362418161d2b3c5781b4def8f9f8f8fff5cb863d0f0000000000000000000000092a5d96c6e6f9fffffffffffffffef6dfbd925d2d163277c1f0fff2c67f380c00000000000000000000000000020c1b2a3337352f24150800000000000000000000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 LCD NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="30")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="32")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000b295582a3bbccd6d9d7cfc0a9885d2e0d000000000000000000000000052d75c7f3fff7d9b08a746c6f7f9ec9edfef4ca7c2f060000000000000000105eb2f6ffefae56130000000000000006378adbfff9bc681b00000000000000439beffffcac580400000000000000000000358de1fffec16d1600000000000048a0f4fff8a65201000000000000000000002f87dbfffff19d450000000000001d73c7feffe1943c0600000000000000002070c8fbffffffb25a060000000000001451a5e9fffbe1b37f58433c3f4d6c9dd1f0f4f4f7ffffb55d09000000000000000008295a90bad9eefbfffffcf2ddba8d5369a0effff5a149000000000000000000000000000000000205060300000000257dd1fffec16d17000000000000000000000000000000000000000000000b4094e0fff8b763170000000000000000002654786b503c2f2622242f44638fc6edfff2c4732903000000000000000000002f77cbf1fcfffffffffffffffbedcea36c340f00000000000000000000000000000000040e1d283135342d2011050000000000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 LCD_V NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
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
test "parity/DejaVuSans.woff2: rendered glyph 36 LCD_V NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000002a582600000000000000005eac5600000000000000009dff900000000000000000bfffb10000000000000001ddfed1000000000000000bf3edeb0600000000000021fec6fb1700000000000040ff8cff3300000000000061fe4fff5200000000000082f31ffa74000000000000a2de06ea94000000000000c2c000d0b4000000000002e1a000afd500000000000ef5810090ee070000000024ff620070fc190000000045ff410050ff370000000065ff230030ff570000000086f50d0016fb7600000000a7e1010005eb9800000000c7c3000000d1b800000002e4a4000000b2d700000010f78400000091f009000029ff9f505050a8fd1c000049ffc8a4a4a4ccff3900006afffdfcfcfcfdff5b00008affffffffffffff7b0000abefacacacacacf29a0000ccd35454545454d9bc0004e7ae0000000000b7db0012f990000000000099f10a2dff7100000000007afe1f4eff5300000000005cff3d6eff3500000000003eff5d8ffd19000000000020fe7faff10800000000000cf59f809d00000000000001a1754447000000000000004a3f00000000000000000000000000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 LCD_V NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="33")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="10")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000042d442904000000084b859c8139000000299fd9f0d58b0c00004aeffff4ffda38000064ecb39cc5fe7d0000599e5f4871e9bf0000384a0b001dbce70700160600000079fb160000000000004aff2b0000000000002dff3e0000000c28344eff4b0000125e7c8894ff5300025bb2d0dcdeff58001ab3fef8ededff5b0047f5d7a599a0ff5c0085f884514555ff5c00b8d82c00001eff5c00d8af0000002aff5c00e98700000037ff5c01f7760000004fff5c01fb7400000071ff5c01f583000000a1ff5c00e8a8000015d2ff5c00d0d3250a57e7ff5c00aaf3795eabd3ff5c0070ffd0b6ed92ff5c0037e3ffffe450ff5c001096d8d8931dac3d00003e80803c06541e0000062c2c03000000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 LCD_V NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="42")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="13")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000021d2a1200000000024b75826a370400002c9fc9d6be8b3200037df0ffffffdf61001ed3ffd5c6e7ff8e004bfcd6817293da900082ff8d2d1e3f877500adf2350000002f4400cbdd0a000000001500ddc200000000000000e7b200000000000000e7b000000000000000e0c000000000000000d1de0e000000000000bbf54e04000000000098ffa24c120000000062ffeca469230000002fe4fff3bd772000000d9dfbfffecb6a01000045b3f5ffffc22200000c5fa6dffff6560000000f528cddff9b0000000004348afad103000000000036e2f10c000000000005b9ff1a0000000000008dff2a00000000000073ff360000000000006cff3b00000000000071ff3a05000000000085ff2d3e0100000000acff1c8d350000001dd8f10ad2893716236cf7d201e4db8b6a77c0ff9900d4ffe3c2cffbf452008ce3fffffffdb51d004190c5dfdeb961020002386d87866115000000001933320f000000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 LCD_V NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="42")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="10")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000244421000e0e0000147b9c78134f4b00004fcff0cc4b8d870004a0fff7fd9abdb4001ae4eaa2b6ddceb4003dfdb14e62dfe4b4006bfd5f0310adfab40099ee1c000067ffb400bfd201000031ffb400dbae00000013f7b400ed9000000003e9b401f77e00000000dbb406fd7400000000d1b40fff6a00000000c6b413ff6700000000c3b410ff6a00000000c6b407fe7300000000d0b401f87d00000000d9b400ef8e00000002e8b400deab00000011f5b400c3cf0000002dffb4009dec18000061ffb40071fc57010aa7fbb40043feaa4659dce7b3001ee9e69aade1d1b20006abfff1fba5c2af000059d8f9d654c8aa00001a84a58218d3a30000002c4d2a00e09700000000000009ef8600000000000022fa7000030900000057ff5300084c02000c9ffd2f000da04f385ddae9130010eea790b5feb502000efaf8e4fcf467000008b2e7faeeae270000035a8fa29656030000000b3b4e420e0000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 LCD_V NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="12")
  inspect(f.glyph().bitmap().rows(), content="48")
  inspect(f.glyph().bitmap().pitch(), content="12")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="13")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000000000000000001202d12000000000000000140788569200000000000002694ccd9bd7008000000000274e7fffffec437000000001fcbffd8c3ecfb880100000057f9de846f9df9d319000000a1ff94301b49cff84400000ddcea3c00000584ff8600002bf8bf0900000037f7be000055ff82000000000de0e6080080ff470000000000bafb1e00a2fc1f000000000091ff3d00bfee08000000000068ff5a00d7d800000000000046ff7200eac100000000000030ff8502f8b000000000000024ff9506ffa300000000000019ffa00cff9a0000000000000effa711ff9500000000000005feac14ff9300000000000002fead11ff9500000000000005fea90dff9a0000000000000dffa106ffa200000000000019ff9702f8af00000000000023ff8e00ebc00000000000002fff8200d7d800000000000046ff6d00c0ed07000000000066ff5200a4fb1d00000000008fff320081ff470000000000bafa150058ff7f000000000cdfe305002efabc0800000033f6b700000edeea3b00000483ff76000000a8ff8f2b1645cbf9390000005efbdb7f6a99f8cc1200000021cfffd7c2ecf77900000000037dedffffffd72c00000000002d9dd5e5ffcb04000000000002457d8de9d30e000000000000032939bbf43600000000000000000074ff7700000000000000000031f1bf0700000000000000000cc9ec280000000000000000007abb3100000000000000000031642900000000000000000005100900000000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 LCD_V NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="42")
  inspect(f.glyph().bitmap().pitch(), content="11")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="13")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000000000d2b17000000000000000c62836f2d00000000000045b6d7c38109000000000296fdffffd5120000000017e2f2bbd4ff1b000000003cfdb96780d71c0000000065ff6a132c84150000000083f72000002d0b0000000093ea0400000102000000009be200000000000000000098e90000000000000000008bf50b000000000000000071fe2c00000000000000004aff67000000000000000023fcac03000000000000001dfce01d000000000000004afcfc550000000000000099effca102000002441c11d8c2e1db1a00000a983a38fa7aa8fb50000018f0556afa365bfd9c010029ff4d98e71023e4d8170038ff3abdc80004adf94b004aff22d7a9000061fe960064f70ee895000026e7d41585e202f28d000005b3f847afbf00f59100000068ff92d59500f19e0000002aead1f06700e3b700000007b8f7fb3500d0d6060000006dfff41300b2f12300000046fff4120089ff6b01000068fff73e0056ffb836163cb4f9ff860027ecf08a6a90f0cceec90e07b1ffe1c2e7f77abef33a005de6fffffebd2d77ff7f001d95d6e1c0690535ab7000003d7e896819000c53450000022a351500000000000000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 LCD_V NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="42")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="13")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000062a230000000000034f827b350000000029a3d6cf880d00000070f1ffffdb3a00000cc5fcc8d3ff8400002df3d9747fedca06005dff96202bbbf11b008ffe44000076ff4000b2ef13000037ff6800ced702000015f88b00e2bc00000003eea900efac00000000e1c100f5a300000000d7d400f7a000000000d5e400f4a600000000dbf100ebb200000000e6fa00dcc800000008f3ff03c7e106000020fbff06abf62100004dffff0b83ff66000495ffff0c51ffb3434dd1f4ff0925ebeb97a1f7d5ff0507adffeff5dab2fd02005ad9fff28da0f500001a85b19f3ba9e70000002d594706bbd600000000050000d1c100000000000004e8a800000000000019f98700000000000040ff630000000000007cfe3a00121a000016bfed1700266b2f2463edc403003abf8378b7ff8100003cfddbd0f9e83a00002ff1fffffba30f00001ba2d4e0b94f000000064a7c88610f000000000428341100000000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 NORMAL DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 36 NORMAL DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 NORMAL DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 NORMAL DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 NORMAL DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 NORMAL DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 NORMAL DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 NORMAL DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 LIGHT DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 36 LIGHT DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 LIGHT DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 LIGHT DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 LIGHT DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 LIGHT DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 LIGHT DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 LIGHT DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 MONO DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 36 MONO DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 MONO DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 MONO DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 MONO DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 MONO DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 MONO DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 MONO DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 LCD DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 36 LCD DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 LCD DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 LCD DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 LCD DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 LCD DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 LCD DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 LCD DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 LCD_V DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 36 LCD_V DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 LCD_V DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 LCD_V DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 LCD_V DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 LCD_V DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 LCD_V DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 LCD_V DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 NORMAL NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
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
test "parity/DejaVuSans.woff2: rendered glyph 36 NORMAL NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="25")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="25")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000003040404018000000000000000000000000000000000000000bf2ffffff9c000000000000000000000000000000000000005ffffffffff20b000000000000000000000000000000000000c1ffffffffff5f000000000000000000000000000000000023feffffcbffffc1000000000000000000000000000000000084ffffd93affffff2300000000000000000000000000000002e2ffff7a00daffff8400000000000000000000000000000048fffffe1e007dffffe3020000000000000000000000000000a9ffffbd00001ffeffff470000000000000000000000000012f8ffff5e000000bfffffa9000000000000000000000000006dfffff40b00000061fffff811000000000000000000000000ceffffa1000000000df5ffff6c00000000000000000000002fffffff430000000000a4ffffcd000000000000000000000092ffffe202000000000045ffffff2f00000000000000000006ecffff8500000000000002e3ffff9000000000000000000055ffffff270000000000000088ffffeb060000000000000000b7ffffc8000000000000000029ffffff53000000000000001bfcffffdbb0b0b0b0b0b0b0b0b0f9ffffb5000000000000007afffffffffffffffffffffffffffffffffc1a000000000000daffffffffffffffffffffffffffffffffff7800000000003dffffff7a4444444444444444444444b8ffffd900000000009ffffff209000000000000000000000050ffffff3b0000000cf4ffffa000000000000000000000000006eeffff9c00000062ffffff45000000000000000000000000009afffff20b0000c4ffffe703000000000000000000000000003fffffff5f0026ffffff8f000000000000000000000000000001e2ffffc10087ffffff3500000000000000000000000000000089ffffff24")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 NORMAL NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="22")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="21")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000a1c22120200000000000000001c6cade2fefffffff3ba61050000000056feffffffffffffffffffffd72600000064fffffcd5ac9b9db7efffffffe918000064c85d100000000000076bf5ffffad00000b000000000000000000004afffffd2100000000000000000000000000bfffff690000000000000000000000000082ffff9e0000000000103c57646b6c6c6cadffffb700000261c6feffffffffffffffffffffc70011c5ffffffffffffffffffffffffffcc01c1ffffffc074472e231c1c1c80ffffcc50fffffe5800000000000000007cffffcca2ffffae00000000000000000096ffffccc7ffff71000000000000000000d1ffffccd1ffff6e000000000000000033ffffffccbaffffaa0000000000000004c7ffffffcc7cfffffd4c00000000000caeffffffffcc17f4ffffffa95c3c4982e6fff7a4ffffcc0055fcfffffffffffffffff85870ffffcc000041d4fffffffffffec02e0070ffffcc00000001346a7e71581e00000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 NORMAL NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000001f6091a6b4ad9d7c5621000000000000002db8feffffffffffffffffffe59c1d00000063faffffffffffffffffffffffffff4400004dfeffffffc470412e324572abf2ffff440006e1fffff75500000000000000000752c0430048ffffff72000000000000000000000000010081ffffff11000000000000000000000000000098fffff500000000000000000000000000000092ffffff1000000000000000000000000000006effffff7b000000000000000000000000000024fdfffffd8d1a000000000000000000000000009efffffffffdc98d572200000000000000000009baffffffffffffffffe9aa5909000000000000026de7ffffffffffffffffffec6d02000000000000054d9ad8feffffffffffffffb3080000000000000000000f4078bdfcffffffff9c000000000000000000000000001fabfffffffe2e0000000000000000000000000000a3ffffff8700000000000000000000000000001dffffffbc000000000000000000000000000000e7ffffd1000000000000000000000000000000e8ffffc600000000000000000000000000001dfeffffaa5a4e000000000000000000000000a0ffffff6384ffd16e1500000000000000129effffffe80f84fffffffccf9778666880b2f7fffffffc51007affffffffffffffffffffffffffffef540000002e80c5f9ffffffffffffffffe389160000000000000009335a727f7b6d5224010000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 NORMAL NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="29")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="21")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000003191a030000000000000000000000000049b5f9fffffcc664020073b0b06500000004a1ffffffffffffffffbd13a8ffff94000000a9fffffff9b8959dd0ffffbbaaffff94000061ffffffba1a0000000041e6fff7ffff940005e8ffffc8070000000000002cf7ffffff940055ffffff32000000000000000087ffffff94009cffffcd00000000000000000022ffffff9400d2ffff8f00000000000000000000e4ffff9400edffff6800000000000000000000beffff9400fcffff5900000000000000000000aeffff9400faffff5c00000000000000000000b1ffff9400ebffff6c00000000000000000000c2ffff9400caffff9700000000000000000000ecffff940094ffffdb00000000000000000030ffffff940046ffffff4700000000000000009cffffff940001dcffffdb1300000000000045fdffffff94000049ffffffd53b0000000669f4ffebffff940000008affffffffe0bcc4f1ffff9ea8ffff92000000007cfaffffffffffffff9807aeffff850000000000288fd6f3f3d89f3d0000c0ffff75000000000000000000000000000000ecffff5000000000000000000000000000003cffffff1b0000000000000000000000000002bfffffc90000000057270000000000000009a1ffffff5c00000000a4fec57c4d37384f89e8ffffffb60000000000a4ffffffffffffffffffffffbb0f00000000005bd0feffffffffffffffd965040000000000000000113e5468776b5520000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 NORMAL NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="25")
  inspect(f.glyph().bitmap().rows(), content="32")
  inspect(f.glyph().bitmap().pitch(), content="25")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000002b7291a7af99814707000000000000000000000000000365dffffffffffffffffff497160000000000000000000026d3fffffffffffffffffffffffff15d000000000000000036ebfffffff09f563a314a80d7ffffffff770000000000001deeffffffa715000000000000026cf5ffffff5e0000000002c1ffffff900000000000000000000042f6fffff32400000059ffffffbd00000000000000000000000067ffffffac000000cafffffc2500000000000000000000000001c8fffffc210030ffffffb200000000000000000000000000005bffffff840070ffffff56000000000000000000000000000008f6ffffc300abffffff1e000000000000000000000000000000c7fffff807d1ffffee0000000000000000000000000000000097ffffff24e3ffffd90000000000000000000000000000000082ffffff36f4ffffc90000000000000000000000000000000072ffffff48f2ffffcc0000000000000000000000000000000076ffffff47e0ffffdc0000000000000000000000000000000085ffffff3acdfffff3010000000000000000000000000000009fffffff20a0ffffff28000000000000000000000000000000d2fffff40164ffffff66000000000000000000000000000013fcffffbd0021feffffc6000000000000000000000000000070ffffff6e0000b4ffffff3f00000000000000000000000009defffff616000040ffffffd70a00000000000000000000008affffff92000000009fffffffbc080000000000000000006dffffffe410000000000cd8ffffffd33c00000000000015a0fffffff73e00000000000018cfffffffffd58d706880b6fafffffff34a00000000000000000ea3feffffffffffffffffffffffcc28000000000000000000000034acf2ffffffffffffffff84010000000000000000000000000000063f5e758183fbffffe72300000000000000000000000000000000000000005dfeffffdd1800000000000000000000000000000000000000006fffffffd00f000000000000000000000000000000000000000082ffffffc20900000000000000000000000000000000000000007aa4a4a45a000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 NORMAL NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="25")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="25")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000014486a7b3a888581600000000000000000000000000000037d5fffffffffffffffdbc2000000000000000000000000043f9ffffffffffffffffffff4000000000000000000000000de8fffffea23f1b214c92eaff40000000000000000000000067ffffff5800000000000005632c0000000000000000000000a5ffffc7000000000000000000000000000000000000000000baffff9f000000000000000000000000000000000000000000a5ffffc500000000000000000000000000000000000000000061ffffff38000000000000000000000000000000000000000009e6ffffdf15000000000000000000000000000000000000000053ffffffca0c0000000000000000000000000000000000000aa8ffffffffc10a000000000000000000000000000000000dc3fffffcffffffbc0800000000000000000a14140e000002b6fffff139a5ffffffb807000000000000009affffa3000070fffffe430003a9ffffffb306000000000000b7ffff78000ceeffff9300000004adffffffaf040000000000e9ffff41005cfffffd1d0000000005b2ffffffa9030000002cffffec03009affffce00000000000006b6ffffffa40200008affff980000b5ffffb00000000000000008baffffff9f010cebfffc240000aeffffbb000000000000000009beffffff9987ffffa400000093ffffee0400000000000000000bc2ffffffffffef1900000052ffffff620000000000000000000cc6ffffffff61000000000ae9ffffee2b0000000000000000003dfeffffff8f000000000063ffffffee570100000000000c7af7ffffffffff8a000000000096ffffffffd68b665f74aaefffffffc7d4ffffff8500000000027ffcfffffffffffffffffffffa860417d7ffffff80000000000032abfbffffffffffffee971f0000001adbffffff7a0000000000000b466a7c776137020000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 NORMAL NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000001c6497acab91600f000000000000000000159efcfffffffffffff886060000000000002ae0ffffffffffffffffffffc90c0000000013dfffffffb95125234eb5ffffffb5010000009cffffff7e00000000000077ffffff5b00001afaffffba0000000000000000b2ffffdf040061ffffff4500000000000000003bffffff440098fffffa08000000000000000003f4ffff9700aeffffe300000000000000000000d8ffffd800b6ffffdd00000000000000000000d1fffffb06a5fffff000000000000000000000e6ffffff2b82ffffff23000000000000000019ffffffff4142ffffff80000000000000000077ffffffff4e03defffff42800000000000023f1ffffffff5a005dffffffe74b0000000047e4ffffffffff5600009affffffffe3b7b6e1ffffff99ffffff4500000182fbfffffffffffffff76a51ffffff34000000002491d8feffffe693260074fffffe0f0000000000000003150800000000acffffd7000000000000000000000000000006ecffff9b000000000000000000000000000055ffffff3b0000000000000000000000000007d8ffffd300000000000000000000000000019effffff44000000098d2900000000000022b4ffffff9d000000000cffffdda8898195c7feffffffb707000000000cffffffffffffffffffffffa108000000000005a1edfffffffffffffdbf43000000000000000000022d5a777f6b51170000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 LIGHT NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
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
test "parity/DejaVuSans.woff2: rendered glyph 36 LIGHT NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="25")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="25")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000003040404018000000000000000000000000000000000000000bf2ffffff9c000000000000000000000000000000000000005ffffffffff20b000000000000000000000000000000000000c1ffffffffff5f000000000000000000000000000000000023feffffcbffffc1000000000000000000000000000000000084ffffd93affffff2300000000000000000000000000000002e2ffff7a00daffff8400000000000000000000000000000048fffffe1e007dffffe3020000000000000000000000000000a9ffffbd00001ffeffff470000000000000000000000000012f8ffff5e000000bfffffa9000000000000000000000000006dfffff40b00000061fffff811000000000000000000000000ceffffa1000000000df5ffff6c00000000000000000000002fffffff430000000000a4ffffcd000000000000000000000092ffffe202000000000045ffffff2f00000000000000000006ecffff8500000000000002e3ffff9000000000000000000055ffffff270000000000000088ffffeb060000000000000000b7ffffc8000000000000000029ffffff53000000000000001bfcffffdbb0b0b0b0b0b0b0b0b0f9ffffb5000000000000007afffffffffffffffffffffffffffffffffc1a000000000000daffffffffffffffffffffffffffffffffff7800000000003dffffff7a4444444444444444444444b8ffffd900000000009ffffff209000000000000000000000050ffffff3b0000000cf4ffffa000000000000000000000000006eeffff9c00000062ffffff45000000000000000000000000009afffff20b0000c4ffffe703000000000000000000000000003fffffff5f0026ffffff8f000000000000000000000000000001e2ffffc10087ffffff3500000000000000000000000000000089ffffff24")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 LIGHT NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="22")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="21")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000a1c22120200000000000000001c6cade2fefffffff3ba61050000000056feffffffffffffffffffffd72600000064fffffcd5ac9b9db7efffffffe918000064c85d100000000000076bf5ffffad00000b000000000000000000004afffffd2100000000000000000000000000bfffff690000000000000000000000000082ffff9e0000000000103c57646b6c6c6cadffffb700000261c6feffffffffffffffffffffc70011c5ffffffffffffffffffffffffffcc01c1ffffffc074472e231c1c1c80ffffcc50fffffe5800000000000000007cffffcca2ffffae00000000000000000096ffffccc7ffff71000000000000000000d1ffffccd1ffff6e000000000000000033ffffffccbaffffaa0000000000000004c7ffffffcc7cfffffd4c00000000000caeffffffffcc17f4ffffffa95c3c4982e6fff7a4ffffcc0055fcfffffffffffffffff85870ffffcc000041d4fffffffffffec02e0070ffffcc00000001346a7e71581e00000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 LIGHT NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000001f6091a6b4ad9d7c5621000000000000002db8feffffffffffffffffffe59c1d00000063faffffffffffffffffffffffffff4400004dfeffffffc470412e324572abf2ffff440006e1fffff75500000000000000000752c0430048ffffff72000000000000000000000000010081ffffff11000000000000000000000000000098fffff500000000000000000000000000000092ffffff1000000000000000000000000000006effffff7b000000000000000000000000000024fdfffffd8d1a000000000000000000000000009efffffffffdc98d572200000000000000000009baffffffffffffffffe9aa5909000000000000026de7ffffffffffffffffffec6d02000000000000054d9ad8feffffffffffffffb3080000000000000000000f4078bdfcffffffff9c000000000000000000000000001fabfffffffe2e0000000000000000000000000000a3ffffff8700000000000000000000000000001dffffffbc000000000000000000000000000000e7ffffd1000000000000000000000000000000e8ffffc600000000000000000000000000001dfeffffaa5a4e000000000000000000000000a0ffffff6384ffd16e1500000000000000129effffffe80f84fffffffccf9778666880b2f7fffffffc51007affffffffffffffffffffffffffffef540000002e80c5f9ffffffffffffffffe389160000000000000009335a727f7b6d5224010000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 LIGHT NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="29")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="21")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000003191a030000000000000000000000000049b5f9fffffcc664020073b0b06500000004a1ffffffffffffffffbd13a8ffff94000000a9fffffff9b8959dd0ffffbbaaffff94000061ffffffba1a0000000041e6fff7ffff940005e8ffffc8070000000000002cf7ffffff940055ffffff32000000000000000087ffffff94009cffffcd00000000000000000022ffffff9400d2ffff8f00000000000000000000e4ffff9400edffff6800000000000000000000beffff9400fcffff5900000000000000000000aeffff9400faffff5c00000000000000000000b1ffff9400ebffff6c00000000000000000000c2ffff9400caffff9700000000000000000000ecffff940094ffffdb00000000000000000030ffffff940046ffffff4700000000000000009cffffff940001dcffffdb1300000000000045fdffffff94000049ffffffd53b0000000669f4ffebffff940000008affffffffe0bcc4f1ffff9ea8ffff92000000007cfaffffffffffffff9807aeffff850000000000288fd6f3f3d89f3d0000c0ffff75000000000000000000000000000000ecffff5000000000000000000000000000003cffffff1b0000000000000000000000000002bfffffc90000000057270000000000000009a1ffffff5c00000000a4fec57c4d37384f89e8ffffffb60000000000a4ffffffffffffffffffffffbb0f00000000005bd0feffffffffffffffd965040000000000000000113e5468776b5520000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 LIGHT NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="25")
  inspect(f.glyph().bitmap().rows(), content="32")
  inspect(f.glyph().bitmap().pitch(), content="25")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000002b7291a7af99814707000000000000000000000000000365dffffffffffffffffff497160000000000000000000026d3fffffffffffffffffffffffff15d000000000000000036ebfffffff09f563a314a80d7ffffffff770000000000001deeffffffa715000000000000026cf5ffffff5e0000000002c1ffffff900000000000000000000042f6fffff32400000059ffffffbd00000000000000000000000067ffffffac000000cafffffc2500000000000000000000000001c8fffffc210030ffffffb200000000000000000000000000005bffffff840070ffffff56000000000000000000000000000008f6ffffc300abffffff1e000000000000000000000000000000c7fffff807d1ffffee0000000000000000000000000000000097ffffff24e3ffffd90000000000000000000000000000000082ffffff36f4ffffc90000000000000000000000000000000072ffffff48f2ffffcc0000000000000000000000000000000076ffffff47e0ffffdc0000000000000000000000000000000085ffffff3acdfffff3010000000000000000000000000000009fffffff20a0ffffff28000000000000000000000000000000d2fffff40164ffffff66000000000000000000000000000013fcffffbd0021feffffc6000000000000000000000000000070ffffff6e0000b4ffffff3f00000000000000000000000009defffff616000040ffffffd70a00000000000000000000008affffff92000000009fffffffbc080000000000000000006dffffffe410000000000cd8ffffffd33c00000000000015a0fffffff73e00000000000018cfffffffffd58d706880b6fafffffff34a00000000000000000ea3feffffffffffffffffffffffcc28000000000000000000000034acf2ffffffffffffffff84010000000000000000000000000000063f5e758183fbffffe72300000000000000000000000000000000000000005dfeffffdd1800000000000000000000000000000000000000006fffffffd00f000000000000000000000000000000000000000082ffffffc20900000000000000000000000000000000000000007aa4a4a45a000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 LIGHT NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="25")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="25")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000014486a7b3a888581600000000000000000000000000000037d5fffffffffffffffdbc2000000000000000000000000043f9ffffffffffffffffffff4000000000000000000000000de8fffffea23f1b214c92eaff40000000000000000000000067ffffff5800000000000005632c0000000000000000000000a5ffffc7000000000000000000000000000000000000000000baffff9f000000000000000000000000000000000000000000a5ffffc500000000000000000000000000000000000000000061ffffff38000000000000000000000000000000000000000009e6ffffdf15000000000000000000000000000000000000000053ffffffca0c0000000000000000000000000000000000000aa8ffffffffc10a000000000000000000000000000000000dc3fffffcffffffbc0800000000000000000a14140e000002b6fffff139a5ffffffb807000000000000009affffa3000070fffffe430003a9ffffffb306000000000000b7ffff78000ceeffff9300000004adffffffaf040000000000e9ffff41005cfffffd1d0000000005b2ffffffa9030000002cffffec03009affffce00000000000006b6ffffffa40200008affff980000b5ffffb00000000000000008baffffff9f010cebfffc240000aeffffbb000000000000000009beffffff9987ffffa400000093ffffee0400000000000000000bc2ffffffffffef1900000052ffffff620000000000000000000cc6ffffffff61000000000ae9ffffee2b0000000000000000003dfeffffff8f000000000063ffffffee570100000000000c7af7ffffffffff8a000000000096ffffffffd68b665f74aaefffffffc7d4ffffff8500000000027ffcfffffffffffffffffffffa860417d7ffffff80000000000032abfbffffffffffffee971f0000001adbffffff7a0000000000000b466a7c776137020000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 LIGHT NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000001c6497acab91600f000000000000000000159efcfffffffffffff886060000000000002ae0ffffffffffffffffffffc90c0000000013dfffffffb95125234eb5ffffffb5010000009cffffff7e00000000000077ffffff5b00001afaffffba0000000000000000b2ffffdf040061ffffff4500000000000000003bffffff440098fffffa08000000000000000003f4ffff9700aeffffe300000000000000000000d8ffffd800b6ffffdd00000000000000000000d1fffffb06a5fffff000000000000000000000e6ffffff2b82ffffff23000000000000000019ffffffff4142ffffff80000000000000000077ffffffff4e03defffff42800000000000023f1ffffffff5a005dffffffe74b0000000047e4ffffffffff5600009affffffffe3b7b6e1ffffff99ffffff4500000182fbfffffffffffffff76a51ffffff34000000002491d8feffffe693260074fffffe0f0000000000000003150800000000acffffd7000000000000000000000000000006ecffff9b000000000000000000000000000055ffffff3b0000000000000000000000000007d8ffffd300000000000000000000000000019effffff44000000098d2900000000000022b4ffffff9d000000000cffffdda8898195c7feffffffb707000000000cffffffffffffffffffffffa108000000000005a1edfffffffffffffdbf43000000000000000000022d5a777f6b51170000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 MONO NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
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
test "parity/DejaVuSans.woff2: rendered glyph 36 MONO NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="24")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="26")
  inspect(f.glyph().bitmap().buffer().length(), content="104")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 MONO NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="21")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="20")
  inspect(f.glyph().bitmap().buffer().length(), content="84")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 MONO NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="27")
  inspect(f.glyph().bitmap().buffer().length(), content="112")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 MONO NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="18")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="20")
  inspect(f.glyph().bitmap().buffer().length(), content="108")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 MONO NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="24")
  inspect(f.glyph().bitmap().rows(), content="32")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="27")
  inspect(f.glyph().bitmap().buffer().length(), content="128")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 MONO NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="25")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="27")
  inspect(f.glyph().bitmap().buffer().length(), content="112")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 MONO NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="18")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="27")
  inspect(f.glyph().bitmap().buffer().length(), content="112")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 LCD NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
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
test "parity/DejaVuSans.woff2: rendered glyph 36 LCD NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="78")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="80")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="-1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000000000000000000000000051b30404040404040404040402d18030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b52aaf2ffffffffffffffffffffeb9c480500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000125fb3f8fffffffffffffffffffffffff2aa520b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000186dc1fbfffffffffffffffffffffffffffff8b35f120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002377cffeffffffffffffe2cbcbe8fffffffffffffcc16d19000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002f84d7ffffffffffffffd985303a8ee3ffffffffffffffcf762300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000023a92e2ffffffffffffffce7a2700002f87daffffffffffffffd78430000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006489cecfffffffffffffec8701e00000000287dd1ffffffffffffffe3923a0200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a55a9f2fffffffffffffbbd69160000000000001f72cafeffffffffffffec9b4706000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000125fb7f8fffffffffffff8b25e120000000000000000176bbffbfffffffffffff2a9550a000000000000000000000000000000000000000000000000000000000000000000000000000000000000001b6dc1fcfffffffffffff4ac540b000000000000000000001361b5f9fffffffffffff8b65e110000000000000000000000000000000000000000000000000000000000000000000000000000000000237acefeffffffffffffeea14d070000000000000000000000000d56aef5fffffffffffffcc06c1b0000000000000000000000000000000000000000000000000000000000000000000000000000002f84daffffffffffffffea97430400000000000000000000000000000750a4effffffffffffffecd7922000000000000000000000000000000000000000000000000000000000000000000000000023e92e2ffffffffffffffe290380200000000000000000000000000000000054599ebffffffffffffffda832f0000000000000000000000000000000000000000000000000000000000000000000006479fecffffffffffffffd9853100000000000000000000000000000000000000023a92e3ffffffffffffffe2903c02000000000000000000000000000000000000000000000000000000000000000c55a9f4ffffffffffffffd37b27000000000000000000000000000000000000000000003488dbffffffffffffffeb9e460600000000000000000000000000000000000000000000000000000000001263b7f8fffffffffffffec8741e000000000000000000000000000000000000000000000000297dd5fffffffffffffff3a7530b0000000000000000000000000000000000000000000000000000001b6cc4fcfffffffffffffff5dbc1b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0c3dff9fffffffffffffff7b5611100000000000000000000000000000000000000000000000000267acefffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffcc26a1a00000000000000000000000000000000000000000000002f88daffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffcc78250000000000000000000000000000000000000000033d91e5fffffffffffffff5b87a474444444444444444444444444444444444444444444444444444444444444444467bb8f4ffffffffffffffd9852d000000000000000000000000000000000000064b9fecfffffffffffffff2a74f09000000000000000000000000000000000000000000000000000000000000000000000950a4f2ffffffffffffffe48f3b020000000000000000000000000000000c55adf4ffffffffffffffeea04c060000000000000000000000000000000000000000000000000000000000000000000000000649a1eeffffffffffffffeb9c4805000000000000000000000000001462b6f9ffffffffffffffec994505000000000000000000000000000000000000000000000000000000000000000000000000000004469aeafffffffffffffff2aa520b00000000000000000000001b70c4fcffffffffffffffe7963e0300000000000000000000000000000000000000000000000000000000000000000000000000000000033f93e8fffffffffffffff8b35f12000000000000000000267ad1ffffffffffffffffe28f3b01000000000000000000000000000000000000000000000000000000000000000000000000000000000000013890e2fffffffffffffffcc16d19000000000000003387daffffffffffffffffe08935010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003589dcffffffffffffffffcf7724000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 LCD NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="57")
  inspect(f.glyph().bitmap().rows(), content="22")
  inspect(f.glyph().bitmap().pitch(), content="60")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="21")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000030a11181c2123221e18120c060200000000000000000000000000000000000000000000000000000000000000000000091c36536c8298adc1d3e2eff9fefffffffffffffffffffffdf3e3cebaa38561391705000000000000000000000000000000000000000000000c56a8f3fefffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff6d7a15b26080000000000000000000000000000000000001064b8fffffffffffffffcf3e4d5c4b6aca6a19b98989da2abb7c8dceffbffffffffffffffffffffe9ae5618000000000000000000000000000000001064b2e7c8a17c5d422510030000000000000000000000000000000007193d6ba2d6f5fffffffffffffff0ad59100000000000000000000000000000030b0b080000000000000000000000000000000000000000000000000000000000144a9ee2fffffffffffffdca7221000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000166bbffdffffffffffffbd69150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002e82d6fffffffffffff29e4a00000000000000000000000000000000000000000000000005101e2d3c4952575c6064686b6b6c6c6c6c6c6c6c6c6c6c7caddeffffffffffffffb7630b0000000000000000000000000000000213366188a9c6e2f5feffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc7731b000000000000000000000000113e85c5edfeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffcc782000000000000000000001226fc1f5fffffffffffffffff6e0c0a288746252473f352e292623211e1c1c1c1c1c1c1c1c3580caffffffffffffffcc782000000000000000000a50a4f1fffffffffffffee1a55821050000000000000000000000000000000000000000000000287cd0ffffffffffffffcc782000000000000000044ea2f1fffffffffffff5ae5a0c00000000000000000000000000000000000000000000000000004296eaffffffffffffffcc7820000000000000001b73c7ffffffffffffffc5711d0000000000000000000000000000000000000000000000000000257dd1ffffffffffffffffcc782000000000000000257dd1ffffffffffffffc26e1a000000000000000000000000000000000000000000000000023387dcffffffffffffffffffcc7820000000000000000f66bafffffffffffffff2aa560b000000000000000000000000000000000000000000042877c7f6ffffffffffffffffffffcc78200000000000000000287cd0fffffffffffffffddc9a4c19030000000000000000000000000000000c2c68aee2fdffffffffffffffffffffffffcc7820000000000000000000175fb7f4fffffffffffffffffff2d4a9856a5c50433c3b40495569829fc5e6fafffffffff7ce9ca4cdffffffffffffffcc782000000000000000000000001b55a4e2fcfffffffffffffffffffffffffffffffffffffffffffffffffffff8dda2581f1d70c4ffffffffffffffcc78200000000000000000000000000002174178acd4effefffffffffffffffffffffffffffffffef4dfc098622e0d0000001c70c4ffffffffffffffcc7820000000000000000000000000000000000000010b1d34495d6a73797e7e79716961584b371e0a000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 LCD NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="60")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="60")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000b1f384e607183919ba1a6acb1b4b4b0ada9a49d94887c716456453321100500000000000000000000000000000000000000000000000e2d5e90b8daf2fefffffffffffffffffffffffffffffffffffffffffffffffffffffffef6e5ceb59c7e481d000000000000000000000000052763abe2fafffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0984400000000000000000000124d9fe5fefffffffffffffffffff8e3c4a487705e4e4138332e2c2d32383e455060728395abc3def2fdfffffffffff098440000000000000000063b93e1fffffffffffffffff7d59855230800000000000000000000000000000000000000000000000007173352769cc0d08e430000000000000004489ceefffffffffffffffac572230100000000000000000000000000000000000000000000000000000000000000000000010101000000000000002d81d5ffffffffffffffffbc6411000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004498ecfffffffffffffff5a14900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003e92e6ffffffffffffffffbc6410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001a6ec2fffffffffffffffffbca7b2b050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002476cefdfffffffffffffffffde9c08d60391a0700000000000000000000000000000000000000000000000000000000000000000000000000000000000e4b9ee4fffffffffffffffffffffffffffdf3e0c9b39f8d7a68574634221206000000000000000000000000000000000000000000000000000000000000093173bae7fdfffffffffffffffffffffffffffffffffffffffffffffff7e9d5bfaa9377593a1c09000000000000000000000000000000000000000000000002173d6d9ac6e7fafffffffffffffffffffffffffffffffffffffffffffffffffffffffdeccc9c6d3c1602000000000000000000000000000000000000000000000005142f4d69849aafc4d8eaf8fefffffffffffffffffffffffffffffffffffffffffffce2b36b2c0800000000000000000000000000000000000000000000000000000000000000050f1f30405164788ca3bdd9f0fcfffffffffffffffffffffffffedf9c49100000000000000000000000000000000000000000000000000000000000000000000000000000000000091f4476abdbf8fffffffffffffffffffed7812e0200000000000000000000000000000000000000000000000000000000000000000000000000000000000000001550a3e3ffffffffffffffffffdb8733000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001d71c9ffffffffffffffffffbc6810000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003b93e7ffffffffffffffffd17d25000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003c94e8ffffffffffffffffc6721a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001d70c8fefffffffffffffff9aa56050000245a81784e270c00000000000000000000000000000000000000000000000000000000000000000000114ca0e3fffffffffffffffffcb763130000003084d8fffffdecd1ae8d6e4f2f1505000000000000000000000000000000000000000000021232639ed2f6ffffffffffffffffffe8a34c0f000000003084d8fffffffffffffffffffffcf2e1cfbca897897f78726b666364686d75808d9eb2cae5f7fffffffffffffffffffffffce1a251180000000000002a7acefcfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeefce965420030000000000000000000005152e49668099b0c5d9edf9fffffffffffffffffffffffffffffffffffffffffffffffffff6e3c7a889643816030000000000000000000000000000000000000000000000000109152533404d5a646c72777c7f807f7b76726d685f5243332414080100000000000000000000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 LCD NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="57")
  inspect(f.glyph().bitmap().rows(), content="29")
  inspect(f.glyph().bitmap().pitch(), content="60")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="21")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000000030811191f201a1109030000000000000000000000000000000000000000000000000000000000000000000000000000000000000620497498b5d1eaf9fffffffffffffffffcf4e0c6a786643b1702000000003973adb0b0b0b0b0b09f652c0000000000000000000000000004235da1d7f5fffffffffffffffffffffffffffffffffffffffffffffde7bd7f3d130054a8fcffffffffffffe8944000000000000000000000001b58a9e2fdfffffffffffffffffff9ead0b8a79d9592959da7b8d0e9f9fffffffffff0bb6a75aafcffffffffffffe894400000000000000000001b61b5f1fffffffffffffffee6ba7d421a040000000000000000000000041a4179b9e6fefffff8f7f7feffffffffffffe894400000000000000005429ae8fffffffffffffff7c87b2c0700000000000000000000000000000000000000072c78c8f7ffffffffffffffffffffe894400000000000000c55a9f4ffffffffffffffda8632040000000000000000000000000000000000000000000000033387d7ffffffffffffffffffe89440000000000001489ceeffffffffffffffcd79220000000000000000000000000000000000000000000000000000002276ceffffffffffffffffe894400000000000267ed2ffffffffffffffe38f3b00000000000000000000000000000000000000000000000000000000003890e4ffffffffffffffe8944000000000004199edffffffffffffffbc68140000000000000000000000000000000000000000000000000000000000126abeffffffffffffffe89440000000000051a9fcffffffffffffffad59050000000000000000000000000000000000000000000000000000000000035aaeffffffffffffffe8944000000000004fa7faffffffffffffffb05c080000000000000000000000000000000000000000000000000000000000045db1ffffffffffffffe8944000000000003f97ebffffffffffffffc06c180000000000000000000000000000000000000000000000000000000000166ec2ffffffffffffffe8944000000000001e76caffffffffffffffeb974300000000000000000000000000000000000000000000000000000000004098ecffffffffffffffe894400000000000004094e7ffffffffffffffdb88300000000000000000000000000000000000000000000000000000003084dbffffffffffffffffe8944000000000000006469aebffffffffffffffe79b470c00000000000000000000000000000000000000000000000a489ce5ffffffffffffffffffe8944000000000000000013289dcfffffffffffffffddb9b451300000000000000000000000000000000000000134597dbfdffffffffffffffffffffe894400000000000000000000f499de5fffffffffffffffff5d5a4693b190600000000000000000006183b69a1d5f4ffffffeceaebfeffffffffffffe8944000000000000000000000000f3f8acef6fffffffffffffffffffffdf0e0cfc4bcbabdc4cee0f1fcfffffffffffee19e4c65a8fcffffffffffffe6923e000000000000000000000000000012407cb8e3fafffffffffffffffffffffffffffffffffffffffffff3cf98582307035aaefeffffffffffffd985310000000000000000000000000000000000000d284d728faac4d6e2eaf3f8f8f3eae1d8cdb99f805f3d1d0700000000146cc0ffffffffffffffc9752100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004199ecfffffffffffff7a45005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000043c90e3ffffffffffffffc76f1b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002226ebff3fffffffffffffdc9752000000000000000000000000000003157714d270e0100000000000000000000000000000000000000000009265da1d8f9fffffffffffffff3b05c1400000000000000000000000000000050a4f8fffef5e1c5aa907c6b5a4d433d373434383e444f5f7389a5c9e8faffffffffffffffffffeeb6631c000000000000000000000000000000000050a4f8fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffee8bb79360f00000000000000000000000000000000000000285b97b7d0e8f8fefffffffffffffffffffffffffffffffffffffffffffcf1d9b88e653a170400000000000000000000000000000000000000000000000000000000061122323e474e545b62686f757776716b655e554835200e030000000000000000000000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 LCD NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="78")
  inspect(f.glyph().bitmap().rows(), content="32")
  inspect(f.glyph().bitmap().pitch(), content="80")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000000000006152b445e7280899198a0a7afb2afa8a099918a81735f472e1607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000314376594bedff3fdfffffffffffffffffffffffffffffffffffffffffffffffdf4e1bf9769381603000000000000000000000000000000000000000000000000000000000000000000000007265c9ed3f0fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1d49e5d2606000000000000000000000000000000000000000000000000000000000e3676bfebfefffffffffffffffffffef0d9ba9f8368564a423a312e3139424a5568809cb9d7eefdffffffffffffffffffffebbc77360d00000000000000000000000000000000000000000000011d5fb5eefffffffffffffffffff6d7a76f391502000000000000000000000000000000000000000213386ca3d6f5ffffffffffffffffffedb15e1c00000000000000000000000000000000000002246fc1f3fffffffffffffffff7d1904513000000000000000000000000000000000000000000000000000000000013428dd1f6fffffffffffffffff3c06b240200000000000000000000000000001059adf4fffffffffffffffff3bd6a1e00000000000000000000000000000000000000000000000000000000000000000000001f67bbf4fffffffffffffffff1ac580e0000000000000000000000002177cafcfffffffffffffffccb75250200000000000000000000000000000000000000000000000000000000000000000000000000012376c8fbfffffffffffffffcca7221000000000000000000003084dcfffffffffffffffff6b25e0f0000000000000000000000000000000000000000000000000000000000000000000000000000000000105baff7ffffffffffffffffd8843000000000000000001b70c4fffffffffffffffff8aa560a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000853abf6ffffffffffffffffc36f170000000000000757abf8ffffffffffffffffca721e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001b73c7fffffffffffffffff8ab53070000000000257dd1ffffffffffffffffee9a4200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004397ebffffffffffffffffd078240000000000378fe3ffffffffffffffffd9852d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002e82d6ffffffffffffffffe28a36000000000048a0f4ffffffffffffffffc9751d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e72c6fffffffffffffffff49c480000000000469ef2ffffffffffffffffcc782000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002276cafffffffffffffffff39b470000000000348ce0ffffffffffffffffdc883000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003185d9ffffffffffffffffe68e3a00000000002179cdfffffffffffffffff3a14901000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000014b9ff1ffffffffffffffffcc74200000000000024ca0f1ffffffffffffffffd47c28000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000267ed2fffffffffffffffff4a149010000000000001164b8fefffffffffffffffdba6615000000000000000000000000000000000000000000000000000000000000000000000000000000000000001363bbfcfffffffffffffffdbd691400000000000000002174ccfefffffffffffffffdc6721d00000000000000000000000000000000000000000000000000000000000000000000000000000000001e70c4fdffffffffffffffffc26e1b000000000000000000001260b4f5ffffffffffffffffe0923f0a00000000000000000000000000000000000000000000000000000000000000000000000000093c94defffffffffffffffff6b86016000000000000000000000000064094e5fffffffffffffffffdd78e380a00000000000000000000000000000000000000000000000000000000000000000008398ad5fdffffffffffffffffe0923e05000000000000000000000000000000104b9fe2ffffffffffffffffffebbc702d08000000000000000000000000000000000000000000000000000000072c6db8ebffffffffffffffffffe4a04910000000000000000000000000000000000000000c3d90d8fbfffffffffffffffffff2d3a46d3c180400000000000000000000000000000000000415386ba0d1f1fffffffffffffffffff7d2893e0f000000000000000000000000000000000000000000000002184893cff4fffffffffffffffffffffffbecd5b99f8d8178706966686f78808b9eb6d2ebfafffffffffffffffffffffff3d2924a180000000000000000000000000000000000000000000000000000000000000e336ca3d0f0fefffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdedcc9a5c280900000000000000000000000000000000000000000000000000000000000000000000000000021334608bacc6e0f2fdfffffffffffffffffffffffffffffffffffffffffffffff9c984370f010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006142b3f4d575e666d757b80817d7883acdcfbfffffffffffffffee7b26023040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003215dade6fefffffffffffffffbdda04d180100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000072d6fbceefffffffffffffffff7d08c3d0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c3982c9f5fffffffffffffffff0c2772f09000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000013457a9da4a4a4a4a4a4a4a4a38b5a240400000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 LCD NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="81")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="84")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000000010d26445d728695a0a7adb2b3b1ada8a195887b6a58422b160700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012376ea8d5f1fefffffffffffffffffffffffffffffffffffffffffffdf1dabc93522000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000124391d5f9ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffec944000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d4ba3e8fffffffffffffffffeeecea276543f33261b1719212b394c617892afd0eaf9ffffec9440000000000000000000000000000000000000000000000000000000000000000000000000000000000000001667bbfdffffffffffffffe6a9581d0200000000000000000000000000000000000005183a637c5a2c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000051a5f8ffffffffffffffc7731b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e66bafffffffffffffff39f4b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000151a5f7ffffffffffffffc5711900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001261b5faffffffffffffffdb8b38080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009439be6fffffffffffffffddfa04a15000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001453a7eafffffffffffffffff3ca83370c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a2b65a8dbf9ffffffffffffffffffffffeec178310a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d357cc3eefffffffffffffffcfcfdffffffffffffffffecbc722d0800000000000000000000000000000000000000000000000000040a11141414141414140e0701000000000000000000000000000000022164b6ebfffffffffffffff1c77c392a57a5defcffffffffffffffffe9b86c290700000000000000000000000000000000000000000000469aeefffffffffffff5a34f0100000000000000000000000000002570c3f6fffffffffffffedd95430f00000000031f5ba9e1fdfffffffffffffffee7b36626060000000000000000000000000000000000000b63b7ffffffffffffffcc7824000000000000000000000000000c4fa7eeffffffffffffffdd933f0a000000000000000000042260ade3fefffffffffffffffee4af6123040000000000000000000000000000003f97e9ffffffffffffeb9541020000000000000000000000000f5cb0f9fffffffffffffdc76f1d0000000000000000000000000000052565b2e6fefffffffffffffffde1a95b1f0300000000000000000000002c80d8ffffffffffffec9b430300000000000000000000000000469aeeffffffffffffffce7a2200000000000000000000000000000000000006286ab6e8fffffffffffffffffcdea4561c0200000000000001368adcffffffffffffe7984404000000000000000000000000000961b5ffffffffffffffffb05c04000000000000000000000000000000000000000000082b6fbaebfffffffffffffffffbdb9f511a0100000c4ba3ebfffffffffffccd7524000000000000000000000000000000035aaefdffffffffffffffbb670f000000000000000000000000000000000000000000000000092f74beedfffffffffffffffffad799514b87d5feffffffffffeca4500c00000000000000000000000000000000003f93e7ffffffffffffffee9f470400000000000000000000000000000000000000000000000000000b327ac2efffffffffffffffffffffffffffffffffefb55d19000000000000000000000000000000000000000852a6f5fffffffffffffff4b66219000000000000000000000000000000000000000000000000000000000c367fc6f1fffffffffffffffffffffff1b5611c000000000000000000000000000000000000000000000a48a0e9ffffffffffffffffeebf6f2b070000000000000000000000000000000000000000000000000000000d3d90dafefffffffffffffffffff7d18f451300000000000000000000000000000000000000000000001c63b7f3ffffffffffffffffffeeca8f57290d0100000000000000000000000000000000000c264f7aaddbf7fffffffffffffffffffffffffffffff6ce8a401000000000000000000000000000000000000000000000134796d7fafffffffffffffffffffffdeed6b9a08b796d665f5d5f656c748193aac0dbeffcfffffffffffffffffeedc7a5aed4f7fffffffffffffffff4ca853d0f0000000000000000000000000000000000000000000217437fbbe7fcfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffae6bd864a1c04000117499ad7f9fffffffffffffffff2c680390d000000000000000000000000000000000000000000000213325b84abceecfbfffffffffffffffffffffffffffffffffffffffaeed9ba9770441f09000000000000000000011a4e9fdbfafffffffffffffffff0c27a350b0000000000000000000000000000000000000000000000000000020b1c324656636a70777c7f7c77706861584a37200d0200000000000000000000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 LCD NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="60")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="60")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000a1c354d64798b979ea5acb1b0aba2999187776043250f0200000000000000000000000000000000000000000000000000000000000001153b709ec9eafcfffffffffffffffffffffffffffffffffffffffff8e3ba864d1f0600000000000000000000000000000000000000000000082a64afe0fbfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1c982370c000000000000000000000000000000000013499fdffdfffffffffffffffff9e0b98f6b513c2d251f1e232c3b4e688cb5ddf7ffffffffffffffffeab563200100000000000000000000000008489ce7fffffffffffffffff2c57e380e000000000000000000000000000000000b3377bfeffffffffffffffff2af5b15000000000000000000001a68c0fafffffffffffffff3ba661b00000000000000000000000000000000000000000000175eb2efffffffffffffffdf8f3804000000000000001061b5fcffffffffffffffeb994506000000000000000000000000000000000000000000000000033b8fe4ffffffffffffffec9844040000000000004498ecfffffffffffffffaae56080000000000000000000000000000000000000000000000000000034ca4f4ffffffffffffffe897430200000000035aaefeffffffffffffffe38f37000000000000000000000000000000000000000000000000000000002c84d8ffffffffffffffffd8842c000000000a62b6ffffffffffffffffdd893100000000000000000000000000000000000000000000000000000000257dd1fffffffffffffffffbae56060000000051a5f8fffffffffffffff09c44000000000000000000000000000000000000000000000000000000003a92e6ffffffffffffffffffd77f2b000000002e82d6ffffffffffffffffcf77230000000000000000000000000000000000000000000000000000196dc5ffffffffffffffffffffed954100000000014296edffffffffffffffffd3802d0100000000000000000000000000000000000000000000002477cafefffffffffffffffffffffaa24e000000000003368edefffffffffffffffff4c2702805000000000000000000000000000000000000042368bcf1ffffffffffffffffffffffffffae5a060000000000001a5db1eefffffffffffffffffee7bc7f4b2309000000000000000000000820477ab7e4fdfffffffffffffffffffffffffffffeaa56030000000000000000124b9adcfbfffffffffffffffffffffef4e3cfc0b7b2b2b6bfcde1f3fdffffffffffffffebb399ade5fffffffffffffff19945000000000000000000000001154382bee9fbfffffffffffffffffffffffffffffffffffffffffffffff7dba96a320d51a5faffffffffffffffe08834000000000000000000000000000000000b244a7291abc2d8ebf8fefffffffffffffbf4e6d0b293744c260b0000002074c8fffffffffffffffeb9610f0000000000000000000000000000000000000000000000000000030810151510080200000000000000000000000658acf8ffffffffffffffd7832b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006469eecffffffffffffffec9b470200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d55a9f3ffffffffffffffe38f3b030000000000000000000000000000000000000000000000000000000000000000000000000000000000000007368cd8fdfffffffffffffed37f290000000000000000000000000000000000000000000000000000000000000000000000000000000000000119509edafbffffffffffffffe297440d000000000000000000000000000943748d6a47291204000000000000000000000000000000000009224b7fb4dffafffffffffffffffee39d4a0e0000000000000000000000000000000c60b8fffffffffcf0ddc9b8a89a9089848081868d959fb0c7e0f4feffffffffffffffffffffe9b76b290700000000000000000000000000000000000c60b8fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff2d2a1622a080000000000000000000000000000000000000000053168a1bcd7edfafffffffffffffffffffffffffffffffffffffffdf1dabf9e74431c04000000000000000000000000000000000000000000000000000000000000020a1a2d3e4e5a6670777c7f7f7b746b635b51442e1707000000000000000000000000000000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 LCD_V NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
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
test "parity/DejaVuSans.woff2: rendered glyph 36 LCD_V NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="25")
  inspect(f.glyph().bitmap().rows(), content="84")
  inspect(f.glyph().bitmap().pitch(), content="25")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000000000000000000000000000000003040404018000000000000000000000000000000000000000078949494400000000000000000000000000000000000000001ceececec76000000000000000000000000000000000000000bf2ffffff9c000000000000000000000000000000000000001ffeffffffbc000000000000000000000000000000000000003fffffffffdc010000000000000000000000000000000000005ffffffffff20b0000000000000000000000000000000000007ffffffffffe20000000000000000000000000000000000000a1ffffffffff3f000000000000000000000000000000000000c1ffffffffff5f000000000000000000000000000000000001dfffffffffff7f00000000000000000000000000000000000df4ffffefffffa1000000000000000000000000000000000023feffffcbffffc1000000000000000000000000000000000043fffffd95ffffdf010000000000000000000000000000000064fffff062fffff50d0000000000000000000000000000000084ffffd93affffff2300000000000000000000000000000000a4ffffba1dfdffff4200000000000000000000000000000000c6ffff9909f1ffff6400000000000000000000000000000002e2ffff7a00daffff840000000000000000000000000000000ff6ffff5b00bcffffa400000000000000000000000000000027ffffff3b009cffffc600000000000000000000000000000048fffffe1e007dffffe302000000000000000000000000000068fffff20a005efffff60f000000000000000000000000000089ffffdc00003dffffff270000000000000000000000000000a9ffffbd00001ffeffff470000000000000000000000000000c9ffff9e00000bf3ffff670000000000000000000000000003e6ffff7d000001ddffff890000000000000000000000000012f8ffff5e000000bfffffa9000000000000000000000000002affffff3f000000a0ffffc9000000000000000000000000004dfffffe2000000080ffffe6030000000000000000000000006dfffff40b00000061fffff8110000000000000000000000008dffffe00100000042ffffff2a000000000000000000000000aeffffc00000000022feffff4c000000000000000000000000ceffffa1000000000df5ffff6c000000000000000000000004e9ffff820000000001e1ffff8c000000000000000000000015faffff620000000000c3ffffad00000000000000000000002fffffff430000000000a4ffffcd000000000000000000000050ffffff24000000000085ffffe8040000000000000000000072fffff50d000000000064fffffa150000000000000000000092ffffe202000000000045ffffff2f00000000000000000000b2ffffc500000000000026ffffff4f00000000000000000000d3ffffa40000000000000ef6ffff7000000000000000000006ecffff8500000000000002e3ffff9000000000000000000017fbffff6600000000000000c7ffffb000000000000000000035ffffff4600000000000000a7ffffd100000000000000000055ffffff270000000000000088ffffeb06000000000000000075fffff8100000000000000069fffffb17000000000000000097ffffe4020000000000000048ffffff330000000000000000b7ffffc8000000000000000029ffffff530000000000000000d6ffffab040404040404040415f9ffff730000000000000008efffffbe5c5c5c5c5c5c5c5c5ff9ffff95000000000000001bfcffffdbb0b0b0b0b0b0b0b0b0f9ffffb50000000000000038ffffffffffffffffffffffffffffffffd4000000000000005affffffffffffffffffffffffffffffffee070000000000007afffffffffffffffffffffffffffffffffc1a0000000000009affffffffffffffffffffffffffffffffff36000000000000bcffffffffffffffffffffffffffffffffff58000000000000daffffffffffffffffffffffffffffffffff7800000000000af1fffff6f0f0f0f0f0f0f0f0f0f0f0fbffff9800000000001ffeffffbc9898989898989898989898deffffb900000000003dffffff7a4444444444444444444444b8ffffd900000000005dffffff3800000000000000000000008dfffff009000000007ffffffd1b00000000000000000000006efffffd1d000000009ffffff209000000000000000000000050ffffff3b00000000bfffffdd00000000000000000000000032ffffff5b00000001dfffffbe00000000000000000000000016fcffff7c0000000cf4ffffa000000000000000000000000006eeffff9c00000022feffff8200000000000000000000000000d7ffffbc00000042ffffff6300000000000000000000000000b8ffffdc01000062ffffff45000000000000000000000000009afffff20b000083ffffff28000000000000000000000000007cfffffe200000a4fffff810000000000000000000000000005dffffff3f0000c4ffffe703000000000000000000000000003fffffff5f0002e2ffffcc000000000000000000000000000022ffffff7f000ff6ffffad00000000000000000000000000000cf5ffffa10026ffffff8f000000000000000000000000000001e2ffffc10046ffffff72000000000000000000000000000000c7ffffdf0167ffffff52000000000000000000000000000000a7fffff50d87ffffff3500000000000000000000000000000089ffffff2465acacac1900000000000000000000000000000052acacac22375454540700000000000000000000000000000023545454160000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 LCD_V NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="66")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="21")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000000000a1c2212020000000000000000000008365c7076664910000000000000000019598eb4c8cebea166160000000000001c6cade2fefffffff3ba610500000000136ec0f8fffffffffffffdb5350000000035c6fefffffffffffffffff6880400000056feffffffffffffffffffffd72600000064fffffffffffffffffffffffb6600000064fffffffffdeff1feffffffffb703000064fffffcd5ac9b9db7efffffffe918000064fff9b88158474963a2f6fffffd43000064fbb160290200000d4abeffffff7c000064c85d100000000000076bf5ffffad00004e740f0000000000000020d0ffffd400002b200000000000000000008fffffef0b000b000000000000000000004afffffd210000000000000000000000001cf4ffff3d00000000000000000000000005ddffff5600000000000000000000000000bfffff6900000000000000000000000000a4ffff7b0000000000000000000000000090ffff8e0000000000000000000000000082ffff9e000000000000000000000000007affffaa0000000000000004101718181881ffffb20000000000103c57646b6c6c6cadffffb7000000001c6390abb8bfc0c0c0dcffffbc0000001872bbe8ffffffffffffffffffc200000261c6feffffffffffffffffffffc7000027b5feffffffffffffffffffffffca000073f5ffffffffffffffffffffffffcb0011c5ffffffffffffffffffffffffffcc003ff3fffffffff3dacfc8c8c8e0ffffcc0083fffffffbc89b8277707070afffffcc01c1ffffffc074472e231c1c1c80ffffcc0fe8ffffe66c2000000000000072ffffcc2cfcffffa8180000000000000076ffffcc50fffffe5800000000000000007cffffcc6fffffee1d000000000000000081ffffcc8affffd103000000000000000089ffffcca2ffffae00000000000000000096ffffccb3ffff91000000000000000000a8ffffccbfffff7d000000000000000000bbffffccc7ffff71000000000000000000d1ffffccceffff6a000000000000000004e7ffffccd2ffff69000000000000000016f8ffffccd1ffff6e000000000000000033ffffffccccffff7a00000000000000005effffffccc5ffff8d000000000000000092ffffffccbaffffaa0000000000000004c7ffffffccabffffcd0100000000000021ecffffffcc95ffffec1800000000000060feffffffcc7cfffffd4c00000000000caeffffffffcc5effffff9e100000000046e4fff5ffffcc37ffffffdf550900002e9efeffd3ffffcc17f4ffffffa95c3c4982e6fff7a4ffffcc04d4ffffffedb0909dd6ffffd97fffffcc0099fffffffffee8f4ffffffa170ffffcc0055fcfffffffffffffffff85870ffffcc0021dbffffffffffffffffcd2270ffffcc000492fefffffffffffffb7b0270ffffcc000041d4fffffffffffec02e0070ffffcc00000e82e0fffffffec96c05004bacac890000002b88bed2c5ac711900002454544200000001346a7e71581e000000000000000000000000162a1d050000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 LCD_V NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="87")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="28")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080200000000000000000000000000000e3d526059492807000000000000000000001f6091a6b4ad9d7c562100000000000000001471b4e5fafffef1d0aa75390300000000000464c9fefffffffffffffacd914806000000002db8feffffffffffffffffffe59c1d000000047bf8ffffffffffffffffffffffed3300000026cfffffffffffffffffffffffffff4400000063faffffffffffffffffffffffffff44000005b0ffffffffffeddadef1ffffffffff44000021e6fffffffcc495828699c6f6ffffff4400004dfeffffffc470412e324572abf2ffff44000084ffffffe8701c000000001e57a6f2ff440000b9ffffffa81b000000000000084ea6fa440006e1fffff75500000000000000000752c0430014f8ffffda180000000000000000000c6c2f002dffffffa8000000000000000000000019170048ffffff72000000000000000000000000010060ffffff48000000000000000000000000000075ffffff27000000000000000000000000000081ffffff1100000000000000000000000000008afffffc04000000000000000000000000000092fffff800000000000000000000000000000098fffff50000000000000000000000000000009afffff700000000000000000000000000000098fffffb04000000000000000000000000000092ffffff1000000000000000000000000000008affffff2800000000000000000000000000007fffffff4b00000000000000000000000000006effffff7b000000000000000000000000000059ffffffb5070000000000000000000000000040ffffffe53a0000000000000000000000000024fdfffffd8d1a0000000000000000000000000eefffffffda6c1d000000000000000000000001cfffffffffc4753908000000000000000000009efffffffffdc98d572200000000000000000063ffffffffffffe1ab763d07000000000000002aeeffffffffffffface95560e00000000000009baffffffffffffffffe9aa590900000000000069f9fffffffffffffffff7ad4900000000000022c0fffffffffffffffffff6a1210000000000026de7ffffffffffffffffffec6d0200000000002098f0ffffffffffffffffffc11f00000000000040a1ecfffffffffffffffff862000000000000054d9ad8feffffffffffffffb308000000000000084684bbecffffffffffffea2500000000000000012c6394ccfcffffffffff5c0000000000000000000f4078bdfcffffffff9c00000000000000000000002469c8ffffffffd00200000000000000000000001470e9fffffff2120000000000000000000000001fabfffffffe2e0000000000000000000000000058f7ffffff510000000000000000000000000016d6ffffff700000000000000000000000000000a3ffffff8700000000000000000000000000006bffffff9d00000000000000000000000000003effffffaf00000000000000000000000000001dffffffbc00000000000000000000000000000af9ffffc4000000000000000000000000000001f1ffffcb000000000000000000000000000000e7ffffd1000000000000000000000000000000e2ffffd2000000000000000000000000000000e2ffffce000000000000000000000000000000e8ffffc6000000000000000000000000000001f2ffffbf00000000000000000000000000000bfaffffb700000000000000000000000000001dfeffffaa05000000000000000000000000003dffffff972e0d0000000000000000000000006affffff7d5a4e000000000000000000000000a0ffffff6380a2270000000000000000000012d2ffffff4884ed7e1c0000000000000000004af4fffffc2784ffd16e1500000000000000129effffffe80f84fffec2652300000000000b5edfffffffc40184fffffdbd7b432412142c5eb6ffffffff8e0084fffffffccf9778666880b2f7fffffffc510084ffffffffffebccbabcd4faffffffffe1210084ffffffffffffffffffffffffffffffa503007affffffffffffffffffffffffffffef5400004fd9ffffffffffffffffffffffffffb11c00002282d4ffffffffffffffffffffffdc59000000002e80c5f9ffffffffffffffffe3891600000000002c71afdffdfffffffff9d0903500000000000000195787aec6d3cfc1a6783800000000000000000009335a727f7b6d5224010000000000000000000000081e2b27190500000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 LCD_V NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="87")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="21")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000000000003191a0300000000000000000000000000000f506d6e531d0000000204040200000000000e61a8c5c6ab721600003c5c5c35000000000049b5f9fffffcc664020073b0b06500000000129df9fffffffffdb82300a8ffff94000000004fe7fffffffffffff96c00a8ffff9400000004a1ffffffffffffffffbd13a8ffff9400000022e2fffffffffffffffff03da8ffff940000005efdfffffffde9f1ffffff7ea8ffff94000000a9fffffff9b8959dd0ffffbbaaffff9400000edfffffffbf6441497ce1ffe6beffff9400002ffaffffed680f00002495fefddcffff94000061ffffffba1a0000000041e6fff7ffff94000096ffffff6e00000000000cb4ffffffff940000c6ffffec2800000000000068ffffffff940005e8ffffc8070000000000002cf7ffffff940016f9ffff940000000000000009dfffffff940034ffffff5e0000000000000000b3ffffff940055ffffff32000000000000000087ffffff940071fffff913000000000000000061ffffff940089ffffe703000000000000000040ffffff94009cffffcd00000000000000000022ffffff9400aeffffb40000000000000000000dfcffff9400c1ffff9f00000000000000000001f2ffff9400d2ffff8f00000000000000000000e4ffff9400deffff7f00000000000000000000d5ffff9400e7ffff7200000000000000000000c7ffff9400edffff6800000000000000000000beffff9400f3ffff6300000000000000000000b8ffff9400f8ffff5e00000000000000000000b3ffff9400fcffff5900000000000000000000aeffff9400feffff5700000000000000000000abffff9400feffff5800000000000000000000acffff9400faffff5c00000000000000000000b1ffff9400f6ffff6000000000000000000000b5ffff9400f0ffff6500000000000000000000baffff9400ebffff6c00000000000000000000c2ffff9400e4ffff7800000000000000000000cdffff9400d9ffff8700000000000000000000dcffff9400caffff9700000000000000000000ecffff9400b9ffffa900000000000000000005f7ffff9400a6ffffc000000000000000000016feffff940094ffffdb00000000000000000030ffffff94007ffffff10800000000000000004fffffff940065fffffd20000000000000000073ffffff940046ffffff4700000000000000009cffffff940025ffffff760000000000000001c9ffffff94000df3ffffae0000000000000017ecffffff940001dcffffdb1300000000000045fdffffff940000b3fffff7420000000000008cffffffff9400007fffffff94070000000020cffffeffff94000049ffffffd53b0000000669f4ffebffff9400001ff3fffffb8f3410184bbdfff5ceffff94000006cbffffffe08c6870a3f5ffd3b1ffff930000008affffffffe0bcc4f1ffff9ea8ffff9200000043f6fffffffffffffffffd5ca8ffff8f00000012cbffffffffffffffffdc26aaffff8a000000007cfaffffffffffffff9807aeffff850000000032cdffffffffffffe44600b4ffff80000000000576e1ffffffffec910f00b9ffff7a0000000000288fd6f3f3d89f3d0000c0ffff750000000000013b829f9f844b030000cbffff6d000000000000012a47472c06000000dbffff60000000000000000000000000000000ecffff50000000000000000000000000000008f8ffff3f00000000000000000000000000001dffffff2d00000000000000000000000000003cffffff1b000000000000000000000000000061fffff90c00000000000000000000000000008effffe7030000000000000000000000000002bfffffc9000000000000000000000000000018e7ffffa7000000002100000000000000000052fdffff830000000057270000000000000009a1ffffff5c000000008d7a1b00000000000045dffffffb3100000000a4d1712802000003359dfeffffe21000000000a4fec57c4d37384f89e8ffffffb60000000000a4fffed0a18b8ca3ddffffffff770000000000a4fffffff7e3e4f8ffffffffed380000000000a4ffffffffffffffffffffffbb0f0000000000a4fffffffffffffffffffff76b00000000000091ffffffffffffffffffffb9250000000000005bd0feffffffffffffffd96504000000000000257cbceafdfffffffccc86190000000000000000246492a8bccbbfa9742e00000000000000000000113e5468776b552000000000000000000000000000021423170500000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 LCD_V NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="25")
  inspect(f.glyph().bitmap().rows(), content="99")
  inspect(f.glyph().bitmap().pitch(), content="25")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="28")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001040000000000000000000000000000000000000000001e3d535b452d0400000000000000000000000000000000002b7291a7af99814707000000000000000000000000000000337fc6e5fafeedd59b4f08000000000000000000000000001b8bd7ffffffffffffeea7430000000000000000000000000365dffffffffffffffffff4971600000000000000000000002db9ffffffffffffffffffffe25c010000000000000000000582f5ffffffffffffffffffffffb42000000000000000000026d3fffffffffffffffffffffffff15d00000000000000000065fcfffffffffce6ddf5ffffffffffaf08000000000000000bb8ffffffffedaa8e859ed4ffffffffe8310000000000000036ebfffffff09f563a314a80d7ffffffff770000000000000079ffffffffb24b060000002c85f5ffffffc20a000000000004c4ffffffe75a0400000000002dbefffffff12b00000000001deeffffffa715000000000000026cf5ffffff5e000000000048fefffff653000000000000000021d0ffffff9b000000000087ffffffd1130000000000000000008bffffffd20800000002c1ffffff900000000000000000000042f6fffff32400000013e9fffffb460000000000000000000014d6ffffff5000000031fdffffe5140000000000000000000000a2ffffff8300000059ffffffbd00000000000000000000000067ffffffac0000007effffff8900000000000000000000000035fdffffd0000000a6ffffff5100000000000000000000000011e9ffffee0a0000cafffffc2500000000000000000000000001c8fffffc210007e8ffffed0a00000000000000000000000000a0ffffff440019fbffffd200000000000000000000000000007cffffff670030ffffffb200000000000000000000000000005bffffff840047ffffff9100000000000000000000000000003bffffff9a005cffffff7100000000000000000000000000001cfeffffaf0070ffffff56000000000000000000000000000008f6ffffc30083ffffff41000000000000000000000000000000e9ffffd60098ffffff2f000000000000000000000000000000d8ffffea00abffffff1e000000000000000000000000000000c7fffff807bcfffffe0e000000000000000000000000000000b6fffffe11c9fffff704000000000000000000000000000000a5ffffff1cd1ffffee0000000000000000000000000000000097ffffff24d7ffffe4000000000000000000000000000000008dffffff2addffffde0000000000000000000000000000000088ffffff30e3ffffd90000000000000000000000000000000082ffffff36e9ffffd4000000000000000000000000000000007dffffff3cefffffce0000000000000000000000000000000078ffffff42f4ffffc90000000000000000000000000000000072ffffff48f7ffffc70000000000000000000000000000000070ffffff4bf6ffffc80000000000000000000000000000000071ffffff4bf2ffffcc0000000000000000000000000000000076ffffff47ecffffd1000000000000000000000000000000007bffffff43e6ffffd70000000000000000000000000000000080ffffff3ee0ffffdc0000000000000000000000000000000085ffffff3adaffffe1000000000000000000000000000000008affffff34d4ffffe90000000000000000000000000000000092ffffff2ccdfffff3010000000000000000000000000000009fffffff20c2fffffb09000000000000000000000000000000afffffff12b3ffffff17000000000000000000000000000000c1fffffc07a0ffffff28000000000000000000000000000000d2fffff4018cffffff3a000000000000000000000000000000e3ffffe60078ffffff4e000000000000000000000000000004f2ffffd30064ffffff66000000000000000000000000000013fcffffbd0050ffffff8400000000000000000000000000002dffffffa3003affffffa600000000000000000000000000004fffffff880021feffffc6000000000000000000000000000070ffffff6e000ef2ffffe4030000000000000000000000000091ffffff530001d8fffff71900000000000000000000000000baffffff310000b4ffffff3f00000000000000000000000009defffff61600008fffffff7200000000000000000000000024f7ffffe004000068ffffffaa00000000000000000000000053ffffffbb00000040ffffffd70a00000000000000000000008affffff920000001ef4fffff42e0000000000000000000008c3ffffff6300000007d2ffffff72000000000000000000002decfffffa31000000009fffffffbc080000000000000000006dffffffe4100000000062ffffffeb3400000000000000000eb8ffffffbb00000000002bf6ffffff8808000000000000004ceaffffff7a00000000000cd8ffffffd33c00000000000015a0fffffff73e0000000000009cfffffffc9029000000001064e5ffffffd5130000000000004ef6ffffffdf81391c142c62bcffffffff950000000000000018cfffffffffd58d706880b6fafffffff34a00000000000000018affffffffffe1c4bcd4faffffffffc41800000000000000003be9fffffffffffffffffffffffffa710000000000000000000ea3feffffffffffffffffffffffcc28000000000000000000004fd9fffffffffffffffffffff17a04000000000000000000000e87f5ffffffffffffffffffb32700000000000000000000000034acf2ffffffffffffffff84010000000000000000000000000558a5ebffffffffffffff7c00000000000000000000000000000a4d93b2c9d5d5ffffffb8050000000000000000000000000000063f5e758183fbffffe723000000000000000000000000000000000a212d2fe0fffffe5a0000000000000000000000000000000000000002a8ffffffa601000000000000000000000000000000000000005dfeffffdd180000000000000000000000000000000000000025e9fffffa480000000000000000000000000000000000000005b7ffffff9300000000000000000000000000000000000000006fffffffd00f0000000000000000000000000000000000000030f1fffff538000000000000000000000000000000000000000ac5ffffff7e000000000000000000000000000000000000000082ffffffc209000000000000000000000000000000000000003ef6ffffed2a0000000000000000000000000000000000000011cef8f8f76300000000000000000000000000000000000000007aa4a4a45a00000000000000000000000000000000000000002f50505037000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 LCD_V NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="25")
  inspect(f.glyph().bitmap().rows(), content="87")
  inspect(f.glyph().bitmap().pitch(), content="25")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="28")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000000000000000000000000000000000000000000332535f54340a0000000000000000000000000000000000014486a7b3a8885816000000000000000000000000000000002d98dafafffbdcac681500000000000000000000000000000982ecfffffffffff9c0680b0000000000000000000000000037d5fffffffffffffffdbc200000000000000000000000000084fdfffffffffffffffffa3500000000000000000000000016d3ffffffffffffffffffff4000000000000000000000000043f9ffffffffffffffffffff4000000000000000000000000084ffffffffebc7cdf3ffffff40000000000000000000000000c2ffffffe8936f75a0e4ffff4000000000000000000000000de8fffffea23f1b214c92eaff40000000000000000000000027fbffffdf4e000000043e9bf74000000000000000000000004affffffa30c000000000243b73f000000000000000000000067ffffff5800000000000005632c000000000000000000000081fffff622000000000000001717000000000000000000000096ffffe2060000000000000000010000000000000000000000a5ffffc7000000000000000000000000000000000000000000aeffffb1000000000000000000000000000000000000000000b6ffffa2000000000000000000000000000000000000000000baffff9f000000000000000000000000000000000000000000b8ffffa3000000000000000000000000000000000000000000b0ffffb0000000000000000000000000000000000000000000a5ffffc500000000000000000000000000000000000000000094ffffdf0200000000000000000000000000000000000000007dfffff514000000000000000000000000000000000000000061ffffff38000000000000000000000000000000000000000041ffffff6e00000000000000000000000000000000000000001ffaffffaf010000000000000000000000000000000000000009e6ffffdf150000000000000000000000000000000000000000c0fffffa4100000000000000000000000000000000000000008affffff8a000000000000000000000000000000000000000053ffffffca0c000000000000000000000000000000000000003cfffffff134000000000000000000000000000000000000005effffffff7a0000000000000000000000000000000000000aa8ffffffffc10a000000000000000000000000000000000031e5ffffffffee30000000000000000000000000000000000079ffffffffffff74000000000000000000000000000000000dc3fffffcffffffbc0800000000000000000a14140e00000031f0ffffd4fbffffeb2c00000000000000003968684800000072ffffff8addffffff6e00000000000000006ec0c081000002b6fffff139a5ffffffb807000000000000009affffa3000014e5ffffc80d58fcffffe92800000000000000a3ffff9500003bfdffff85001fe0ffffff6800000000000000aeffff86000070fffffe430003a9ffffffb306000000000000b7ffff780000a2ffffec1800005dfdffffe625000000000000c4ffff6a0001d0ffffc602000021e3fffffe62000000000000d6ffff58000ceeffff9300000004adffffffaf040000000000e9ffff410021fdffff640000000062feffffe3220000000007f7ffff270040ffffff3c0000000024e5fffffd5d0000000016fffffa10005cfffffd1d0000000005b2ffffffa9030000002cffffec030074fffff109000000000066feffffe01e00000047ffffd4000089ffffe000000000000027e8fffffc5800000068ffffb700009affffce00000000000006b6ffffffa40200008affff980000a6ffffc3000000000000006cffffffdd1b0000acffff740000b0ffffb8000000000000002beafffffb530000cfffff4a0000b5ffffb00000000000000008baffffff9f010cebfffc240000b7ffffae000000000000000070ffffffd91928fbffec0c0000b4ffffb300000000000000002eecfffffa4e56ffffcd000000aeffffbb000000000000000009beffffff9987ffffa4000000a6ffffc700000000000000000076ffffffd6beffff760000009effffdb00000000000000000031eefffff9e8fffe4100000093ffffee0400000000000000000bc2ffffffffffef1900000083fffffb150000000000000000007bffffffffffcd040000006cffffff3600000000000000000034f0ffffffff980000000052ffffff620000000000000000000cc6ffffffff610000000038ffffff950000000000000000000081ffffffff42000000001cfcffffcb090000000000000000003efeffffff53000000000ae9ffffee2b0000000000000000003dfeffffff8f0000000000c6ffffff6e0000000000000000027afeffffffd0120000000095ffffffbd150000000000000029ccfffffffff6420000000063ffffffee570100000000000c7af7ffffffffff8a0000000032f6ffffffab2c000000000750ccffffffffffffcc100000000fd2ffffffed8437120b2056a8fdfffff5f7fffff53d0000000096ffffffffd68b665f74aaefffffffc7d4ffffff85000000004df9ffffffffdfbab3c8f6fffffffb7895ffffffc90e0000001accffffffffffffffffffffffffd22a48f8fffff33a000000027ffcfffffffffffffffffffffa860417d7ffffff800000000032d7ffffffffffffffffffffc63600019bffffffc50c0000000683f0ffffffffffffffffe56f0700004cfafffff1360000000032abfbffffffffffffee971f0000001adbffffff7a000000000357b2f0ffffffffe39d43000000000287acacac6d00000000000e5a9abed0cbb58b4506000000000034545454430000000000000b466a7c77613702000000000000000000000000000000000000021628230d00000000000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 LCD_V NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="87")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="28")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000302000000000000000000000000000000124358573d120000000000000000000000001c6497acab91600f000000000000000000000a6cb8ebfdfce5b45b070000000000000000004ac4fdfffffffffab3360000000000000000159efcfffffffffffff88606000000000000004de8ffffffffffffffffd33000000000000007a2fffffffffffffffffffc7b0000000000002ae0ffffffffffffffffffffc90c000000000064fdfffffff4d1cff3fffffff3300000000001affffffff3a57977a2f2ffffff6f0000000013dfffffffb95125234eb5ffffffb50100000038fafffff2650800000761f0ffffe5100000006dffffffc4190000000017bffffffd2f0000009cffffff7e00000000000077ffffff5b000000c5fffffa3900000000000033f8ffff88000008e7ffffe10e0000000000000bdcffffb800001afaffffba0000000000000000b2ffffdf040032ffffff8d000000000000000084fffff712004bffffff6600000000000000005cffffff290061ffffff4500000000000000003bffffff440077ffffff2b000000000000000020ffffff60008affffff1500000000000000000dfdffff7c0098fffffa08000000000000000003f4ffff9700a1fffff201000000000000000000e9ffffb100a8ffffe900000000000000000000deffffc700aeffffe300000000000000000000d8ffffd800b4ffffde00000000000000000000d3ffffe600b7ffffdb00000000000000000000d0fffff301b6ffffdd00000000000000000000d1fffffb06b1ffffe200000000000000000000d7ffffff10abffffe700000000000000000000dcffffff1fa5fffff000000000000000000000e6ffffff2b9dfffff805000000000000000001f1ffffff3692fffffe1100000000000000000afbffffff3d82ffffff23000000000000000019ffffffff416effffff3c000000000000000032ffffffff4558ffffff5c000000000000000053ffffffff4a42ffffff80000000000000000077ffffffff4e29ffffffab0000000000000000a2ffffffff5212f5ffffd70800000000000006d1ffffffff5603defffff42800000000000023f1ffffffff5a00bbffffff640000000000005dffffffffff5c008fffffffb30e000000000cadffffffffff5a005dffffffe74b0000000047e4ffffffffff56002df5fffffe9f370b0a359bfefff3ffffff50000bd4ffffffe98f63628de7ffffcfffffff4b00009affffffffe3b7b6e1ffffff99ffffff45000052f8ffffffffffffffffffef69ffffff4000001bcdffffffffffffffffffbb50ffffff3a00000182fbfffffffffffffff76a51ffffff3400000036cbffffffffffffffc82659ffffff2b0000000874e4ffffffffffe4710265ffffff1e000000002491d8feffffe693260074fffffe0f00000000003d84aec1b4923f010086fffff6040000000000002c56695c3a02000099ffffe8000000000000000003150800000000acffffd7000000000000000000000000000000beffffc5000000000000000000000000000000d6ffffb2000000000000000000000000000006ecffff9b000000000000000000000000000017fbffff7e000000000000000000000000000034ffffff5c000000000000000000000000000055ffffff3b00000000000000000000000000007cfffffc1c0000000000000000000000000000acffffee080000000000000000000000000007d8ffffd3000000000000000000000000000020f4ffffaa000000000000000000000000000057ffffff7800000000000000000000000000019effffff44000000010200000000000000001bd9fffff11b0000000539000000000000000062faffffd004000000098d2900000000000022b4ffffff9d000000000cdf7d31040000001c74efffffff5e000000000cffd58954352d4173ccffffffe828000000000cffffdda8898195c7feffffffb707000000000cfffffff8ddd5e9ffffffffff6c00000000000cffffffffffffffffffffffe52b00000000000cffffffffffffffffffffffa10800000000000cffffffffffffffffffffe24e00000000000009effffffffffffffffffc980f00000000000005a1edfffffffffffffdbf4300000000000000014d9bd9fefffffffbc06b0c0000000000000000054381aecbd3bfa5681600000000000000000000022d5a777f6b51170000000000000000000000000008232b1702000000000000000000")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 NORMAL DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 36 NORMAL DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 NORMAL DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 NORMAL DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 NORMAL DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 NORMAL DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 NORMAL DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 NORMAL DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 LIGHT DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 36 LIGHT DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 LIGHT DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 LIGHT DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 LIGHT DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 LIGHT DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 LIGHT DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 LIGHT DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 MONO DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 36 MONO DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 MONO DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 MONO DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 MONO DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 MONO DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 MONO DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 MONO DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 LCD DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 36 LCD DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 LCD DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 LCD DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 LCD DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 LCD DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 LCD DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 LCD DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 3 LCD_V DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="3")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 36 LCD_V DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="36")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 68 LCD_V DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="68")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 54 LCD_V DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="54")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 74 LCD_V DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="74")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 52 LCD_V DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="52")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 9 LCD_V DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="9")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/DejaVuSans.woff2: rendered glyph 28 LCD_V DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/DejaVuSans.woff2: kerning" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  inspect(@freetype.get_kerning(f, 36U, 36U).0, content="57")
  inspect(@freetype.get_kerning(f, 36U, 38U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 42U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 50U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 52U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 55U).0, content="-159")
  inspect(@freetype.get_kerning(f, 36U, 57U).0, content="-131")
  inspect(@freetype.get_kerning(f, 36U, 58U).0, content="-112")
  inspect(@freetype.get_kerning(f, 36U, 60U).0, content="-159")
  inspect(@freetype.get_kerning(f, 36U, 70U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 71U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 72U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 73U).0, content="-73")
  inspect(@freetype.get_kerning(f, 36U, 82U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 84U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 87U).0, content="-36")
  inspect(@freetype.get_kerning(f, 36U, 89U).0, content="-120")
  inspect(@freetype.get_kerning(f, 36U, 90U).0, content="-83")
  inspect(@freetype.get_kerning(f, 36U, 92U).0, content="-139")
  inspect(@freetype.get_kerning(f, 37U, 38U).0, content="-36")
}

///|
test "parity/DejaVuSans.woff2: hinted outline DEFAULT 16ppem" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 4U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="10")
  inspect(f.glyph().metrics().width(), content="128")
  inspect(f.glyph().metrics().height(), content="768")
  inspect(f.glyph().metrics().hori_advance(), content="384")
}

///|
test "parity/DejaVuSans.woff2: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 4U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="411")
}

///|
test "parity/DejaVuSans.woff2: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_dejavusans_woff2())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 4U, load_flags=@base.LOAD_FORCE_AUTOHINT)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="384")
}

