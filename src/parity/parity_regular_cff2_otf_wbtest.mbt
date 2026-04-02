// Parity tests for regular_CFF2.otf
// AUTO-GENERATED — do not edit

///|
fn load_generated_regular_cff2_otf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/regular_CFF2.otf")
}

///|
test "parity/regular_CFF2.otf: format" {
  inspect(@base.detect_format(load_generated_regular_cff2_otf()), content="Cff2OpenType")
}

///|
test "parity/regular_CFF2.otf: loads" {
  inspect((try? @freetype.from_bytes(load_generated_regular_cff2_otf())) is Ok(_), content="true")
}

///|
test "parity/regular_CFF2.otf: metadata" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  inspect(f.family_name(), content="Source Sans Pro")
  inspect(f.num_glyphs(), content="10")
  inspect(f.units_per_em(), content="1000")
  inspect(f.ascender(), content="984")
  inspect(f.descender(), content="-273")
  inspect(f.height(), content="1257")
  inspect(f.underline_position(), content="-100")
  inspect(f.underline_thickness(), content="50")
}

///|
test "parity/regular_CFF2.otf: bbox" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  inspect(f.bbox().x_min(), content="-454")
  inspect(f.bbox().y_min(), content="-293")
  inspect(f.bbox().x_max(), content="2159")
  inspect(f.bbox().y_max(), content="968")
}

///|
test "parity/regular_CFF2.otf: flags" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/regular_CFF2.otf: charmaps" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  inspect(f.charmaps().length(), content="4")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="0")
    inspect(f.charmaps()[0].encoding_id(), content="3")
  }
  if f.charmaps().length() > 1 {
    inspect(f.charmaps()[1].platform_id(), content="0")
    inspect(f.charmaps()[1].encoding_id(), content="4")
  }
  if f.charmaps().length() > 2 {
    inspect(f.charmaps()[2].platform_id(), content="3")
    inspect(f.charmaps()[2].encoding_id(), content="1")
  }
  if f.charmaps().length() > 3 {
    inspect(f.charmaps()[3].platform_id(), content="3")
    inspect(f.charmaps()[3].encoding_id(), content="10")
  }
}

///|
test "parity/regular_CFF2.otf: charmap entries" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  inspect(@freetype.get_char_index(f, 65U), content="1")
  inspect(@freetype.get_char_index(f, 66U), content="2")
  inspect(@freetype.get_char_index(f, 67U), content="3")
  inspect(@freetype.get_char_index(f, 97U), content="4")
  inspect(@freetype.get_char_index(f, 98U), content="5")
  inspect(@freetype.get_char_index(f, 99U), content="6")
}

///|
test "parity/regular_CFF2.otf: glyph 1 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  let r = try? @freetype.load_glyph(f, 1U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="18")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="203")
  inspect(f.glyph().outline().points()[0].y(), content="367")
  inspect(f.glyph().outline().points()[1].x(), content="227")
  inspect(f.glyph().outline().points()[1].y(), content="440")
  inspect(f.glyph().outline().points()[2].x(), content="248")
  inspect(f.glyph().outline().points()[2].y(), content="512")
  inspect(f.glyph().outline().points()[3].x(), content="268")
  inspect(f.glyph().outline().points()[3].y(), content="588")
  inspect(f.glyph().outline().points()[4].x(), content="272")
  inspect(f.glyph().outline().points()[4].y(), content="588")
  inspect(f.glyph().outline().points()[5].x(), content="293")
  inspect(f.glyph().outline().points()[5].y(), content="512")
  inspect(f.glyph().outline().points()[6].x(), content="314")
  inspect(f.glyph().outline().points()[6].y(), content="440")
  inspect(f.glyph().outline().points()[7].x(), content="338")
  inspect(f.glyph().outline().points()[7].y(), content="367")
  inspect(f.glyph().metrics().hori_advance(), content="544")
}

///|
test "parity/regular_CFF2.otf: glyph 2 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  let r = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="34")
  inspect(f.glyph().outline().n_contours(), content="3")
  inspect(f.glyph().outline().points()[0].x(), content="90")
  inspect(f.glyph().outline().points()[0].y(), content="0")
  inspect(f.glyph().outline().points()[1].x(), content="299")
  inspect(f.glyph().outline().points()[1].y(), content="0")
  inspect(f.glyph().outline().points()[2].x(), content="446")
  inspect(f.glyph().outline().points()[2].y(), content="0")
  inspect(f.glyph().outline().points()[3].x(), content="548")
  inspect(f.glyph().outline().points()[3].y(), content="63")
  inspect(f.glyph().outline().points()[4].x(), content="548")
  inspect(f.glyph().outline().points()[4].y(), content="192")
  inspect(f.glyph().outline().points()[5].x(), content="548")
  inspect(f.glyph().outline().points()[5].y(), content="282")
  inspect(f.glyph().outline().points()[6].x(), content="493")
  inspect(f.glyph().outline().points()[6].y(), content="334")
  inspect(f.glyph().outline().points()[7].x(), content="414")
  inspect(f.glyph().outline().points()[7].y(), content="349")
  inspect(f.glyph().metrics().hori_advance(), content="588")
}

///|
test "parity/regular_CFF2.otf: glyph 3 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  let r = try? @freetype.load_glyph(f, 3U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="26")
  inspect(f.glyph().outline().n_contours(), content="1")
  inspect(f.glyph().outline().points()[0].x(), content="338")
  inspect(f.glyph().outline().points()[0].y(), content="-12")
  inspect(f.glyph().outline().points()[1].x(), content="423")
  inspect(f.glyph().outline().points()[1].y(), content="-12")
  inspect(f.glyph().outline().points()[2].x(), content="487")
  inspect(f.glyph().outline().points()[2].y(), content="23")
  inspect(f.glyph().outline().points()[3].x(), content="539")
  inspect(f.glyph().outline().points()[3].y(), content="83")
  inspect(f.glyph().outline().points()[4].x(), content="493")
  inspect(f.glyph().outline().points()[4].y(), content="135")
  inspect(f.glyph().outline().points()[5].x(), content="451")
  inspect(f.glyph().outline().points()[5].y(), content="89")
  inspect(f.glyph().outline().points()[6].x(), content="404")
  inspect(f.glyph().outline().points()[6].y(), content="61")
  inspect(f.glyph().outline().points()[7].x(), content="341")
  inspect(f.glyph().outline().points()[7].y(), content="61")
  inspect(f.glyph().metrics().hori_advance(), content="571")
}

///|
test "parity/regular_CFF2.otf: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 1U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="576")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 NORMAL NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000003e7f18000000000000beeb71000000000018f56bc800000000006bb815fc1f00000000c26e00c7750000001afd22007acb0000006fe643436bff230000c5e0cbcbcbf278001dfe320000008bcf0072e1000000003bff26c8900000000002e97c")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 NORMAL NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="7")
  inspect(f.glyph().bitmap().rows(), content="9")
  inspect(f.glyph().bitmap().pitch(), content="7")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="8")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "002398d3e7a30f0086853a3fe19000000000008ad400002e8abbe9eb0083e46a2369eb0ffd3b000067eb14ff65002bd0eb0087feedcd6deb00001517000000")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 LIGHT NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000003e7f18000000000000beeb71000000000018f56bc800000000006bb815fc1f00000000c26e00c7750000001afd22007acb0000006fe643436bff230000c5e0cbcbcbf278001dfe320000008bcf0072e1000000003bff26c8900000000002e97c")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 LIGHT NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="7")
  inspect(f.glyph().bitmap().rows(), content="9")
  inspect(f.glyph().bitmap().pitch(), content="7")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="8")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "002398d3e7a30f0086853a3fe19000000000008ad400002e8abbe9eb0083e46a2369eb0ffd3b000067eb14ff65002bd0eb0087feedcd6deb00001517000000")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 MONO NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  inspect(f.glyph().bitmap().buffer().length(), content="22")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 MONO NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="6")
  inspect(f.glyph().bitmap().rows(), content="8")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="8")
  inspect(f.glyph().bitmap().buffer().length(), content="16")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 LCD NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="30")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="32")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="-1")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000143e687f7f6e42180000000000000000000000000000000000000000000000166abef1ebebf5c5711f0000000000000000000000000000000000000000001869c1f5af676bb3fac8741d00000000000000000000000000000000000000196bbffab864111567bffcca721f0000000000000000000000000000000000186ec2fcc26e1b00001c73c7fec975220000000000000000000000000000001a6cc4fdcd752200000000267aceffcb7720000000000000000000000000001c6fc3fee6a8674343434343436ba8e9ffce762300000000000000000000001b71c5fef1e0cfcbcbcbcbcbcbcbcbcfe1f2ffcc78250000000000000000001d70c8fede863200000000000000000000378bdfffcf7b24000000000000001f72c6ffe18d350000000000000000000000013b8fe6ffd1792600000000001d74c8fee3903c01000000000000000000000000023f97e9ffd07c280000")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 LCD NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="24")
  inspect(f.glyph().bitmap().rows(), content="9")
  inspect(f.glyph().bitmap().pitch(), content="24")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="8")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000b23497698b2c3d3e4ebe7d9c6a370340f000000000000063d86bab085644b3a2e2f3f67aae1ffe0903c040000000000000000000000000000000000368adeffd480280000000000000004142e4e708a9dacbbc9d8e9f6ffeb973f000000000e3c83c8efe4be8e6a4d3423131b69bbffeb973f0000000f61b9fde38f3b040000000000001367bbffeb973f0000001467bffff6b5651b0400020e2b5999d0f2ffeb973f000000000d4187cbeffefcf2edece7cda26a6d9de4eb973f0000000000000001091522221709010000000000000000000000")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 LCD_V NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="36")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000132b060000000000003e7f1800000000000073d334000000000000a2fe55000000000000beeb71000000000000dac88e000000000007f096ab000000000018f56bc8000000000031e948e301000000004fd12cf60c000000006bb815fc1f0000000088a007f33b00000000a58600e05800000000c26e00c77500000000de5500ae9100000009f33b0094af0000001afd22007acb00000034f90e0060e602000052e9020044f80e00006fe643436bff2300008bec9797a8ff3e0000a9fcefeff1ff5c0000c5e0cbcbcbf2780000e0a5777777d494000af55e1f1f1fadb2001dfe320000008bcf0038fe1900000071e80356f30800000056f91072e1000000003bff268ec60000000022ff41acaa000000000df95fc8900000000002e97c90580000000000955d4b2600000000004432000000000000000000000000000000000000")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 LCD_V NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="7")
  inspect(f.glyph().bitmap().rows(), content="30")
  inspect(f.glyph().bitmap().pitch(), content="7")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000002273b0c000000447f934f00002398d3e7a30f0063eae6e7ea310094d68e93fa630086853a3fe1900048310003c1b100150200009ec800000000008ad4000000001096df0000003667bfe600002e8abbe9eb000e81dacfcceb003cd8be7798eb0083e46a2369eb00c6ae1a0067eb04f06a000067eb0ffd3b000067eb1bff30000071eb1eff3d00039eeb14ff65002bd0eb08f1a6417fe8eb01ccdf99cfb2eb0087feedcd6deb0041c0c479299e000d686c250e4d0000151700000000000000000000")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 NORMAL DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 NORMAL DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 LIGHT DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 LIGHT DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 MONO DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 MONO DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 LCD DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 LCD DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 LCD_V DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 LCD_V DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 NORMAL NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="20")
  inspect(f.glyph().bitmap().rows(), content="24")
  inspect(f.glyph().bitmap().pitch(), content="20")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="24")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000004989b9b5b00000000000000000000000000000048ffffffdb0000000000000000000000000000009efff6ffff310000000000000000000000000006efff7bf6ff88000000000000000000000000004cffff26b4ffde00000000000000000000000000a2ffdb0067ffff35000000000000000000000007f1ff90001cffff8c00000000000000000000004fffff450000cfffe20100000000000000000000a6fff306000082ffff3900000000000000000009f3ffaf00000036ffff8f00000000000000000053ffff6400000001e7ffe4010000000000000000aafffe18000000009bffff3d000000000000000bf5ffc500000000004dffff930000000000000057ffff76000000000009f5ffe702000000000000adffffb49b9b9b9b9b9be9ffff4000000000000df7ffffffffffffffffffffffff9700000000005affffe1cbcbcbcbcbcbcbcbfbffea0300000000b1ffff360000000000000000bcffff440000000ff8ffe50100000000000000006effff9b0000005effff950000000000000000001fffffed040000b5ffff4500000000000000000000d0ffff480011faffef050000000000000000000081ffff9e0062ffffa4000000000000000000000032ffffef06b8ffff53000000000000000000000000e2ffff4c")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 NORMAL NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="15")
  inspect(f.glyph().bitmap().rows(), content="19")
  inspect(f.glyph().bitmap().pitch(), content="15")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="18")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000001f6eb2d0e5d4a13800000000002dacfdfffffffffffffb730000002afcfffff5b5929fd8ffffff5e000000b9ee7409000000018cffffd70200001d1100000000000001dfffff3e00000000000000000000008effff6100000000000000000000007affff7f00000000000029679ecbf0ffffff960000000b74d8fffffffffdf1ffff9700003ce5fffff5ab67300867ffff97002ff6fffb830f0000000067ffff9700b9ffff5b00000000000067ffff9706fdffef0300000000000067ffff9716ffffcf0000000000000074ffff9700eefff714000000000062f9ffff9700b4ffffc430020641b8fffbffff970024f4fffffffafdffffbf2dffff97000039d1ffffffffe46a0100ebff9700000003315b5f3a02000000000000")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 LIGHT NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="20")
  inspect(f.glyph().bitmap().rows(), content="24")
  inspect(f.glyph().bitmap().pitch(), content="20")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="24")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000004989b9b5b00000000000000000000000000000048ffffffdb0000000000000000000000000000009efff6ffff310000000000000000000000000006efff7bf6ff88000000000000000000000000004cffff26b4ffde00000000000000000000000000a2ffdb0067ffff35000000000000000000000007f1ff90001cffff8c00000000000000000000004fffff450000cfffe20100000000000000000000a6fff306000082ffff3900000000000000000009f3ffaf00000036ffff8f00000000000000000053ffff6400000001e7ffe4010000000000000000aafffe18000000009bffff3d000000000000000bf5ffc500000000004dffff930000000000000057ffff76000000000009f5ffe702000000000000adffffb49b9b9b9b9b9be9ffff4000000000000df7ffffffffffffffffffffffff9700000000005affffe1cbcbcbcbcbcbcbcbfbffea0300000000b1ffff360000000000000000bcffff440000000ff8ffe50100000000000000006effff9b0000005effff950000000000000000001fffffed040000b5ffff4500000000000000000000d0ffff480011faffef050000000000000000000081ffff9e0062ffffa4000000000000000000000032ffffef06b8ffff53000000000000000000000000e2ffff4c")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 LIGHT NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="15")
  inspect(f.glyph().bitmap().rows(), content="19")
  inspect(f.glyph().bitmap().pitch(), content="15")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="18")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000001f6eb2d0e5d4a13800000000002dacfdfffffffffffffb730000002afcfffff5b5929fd8ffffff5e000000b9ee7409000000018cffffd70200001d1100000000000001dfffff3e00000000000000000000008effff6100000000000000000000007affff7f00000000000029679ecbf0ffffff960000000b74d8fffffffffdf1ffff9700003ce5fffff5ab67300867ffff97002ff6fffb830f0000000067ffff9700b9ffff5b00000000000067ffff9706fdffef0300000000000067ffff9716ffffcf0000000000000074ffff9700eefff714000000000062f9ffff9700b4ffffc430020641b8fffbffff970024f4fffffffafdffffbf2dffff97000039d1ffffffffe46a0100ebff9700000003315b5f3a02000000000000")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 MONO NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="24")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="24")
  inspect(f.glyph().bitmap().buffer().length(), content="96")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 MONO NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="14")
  inspect(f.glyph().bitmap().rows(), content="18")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="18")
  inspect(f.glyph().bitmap().buffer().length(), content="36")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 LCD NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="63")
  inspect(f.glyph().bitmap().rows(), content="24")
  inspect(f.glyph().bitmap().pitch(), content="64")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="-1")
  inspect(f.glyph().bitmap_top(), content="24")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000000000004346a989b9b9b9b9b9b9b8e5b280000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005489ceeffffffffffffffffffdb872f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000054a9eedfffffffdf6f6f9ffffffffdd85310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000649a1efffffffffc57b73acf6ffffffffdc883400000000000000000000000000000000000000000000000000000000000000000000000000000000000000074ca0f0ffffffffd27a260e60b4faffffffffde8b330000000000000000000000000000000000000000000000000000000000000000000000000000000000064ea2f0ffffffffdb872f00001667bbfdffffffffe18935010000000000000000000000000000000000000000000000000000000000000000000000000000074da5f1ffffffffe4903c000000001c6fc7ffffffffffdf8c3800000000000000000000000000000000000000000000000000000000000000000000000000084fa3f2ffffffffee9945030000000000237bcfffffffffffe28e3601000000000000000000000000000000000000000000000000000000000000000000000852a6f2fffffffff3a64e06000000000000002e82d6ffffffffffe38d390100000000000000000000000000000000000000000000000000000000000000000950a8f3fffffffff8af5b0b000000000000000000368ae1ffffffffffe38f3b010000000000000000000000000000000000000000000000000000000000000a53a7f4fffffffffdb8641300000000000000000000013d95e7ffffffffffe4923a01000000000000000000000000000000000000000000000000000000000956aaf4fffffffffec1691800000000000000000000000003479becffffffffffe6913d0200000000000000000000000000000000000000000000000000000b54acf5fffffffffec5711b0000000000000000000000000000064da1f2ffffffffffe6933f020000000000000000000000000000000000000000000000000c57abf6ffffffffffca7622000000000000000000000000000000000952aaf5ffffffffffe7963e02000000000000000000000000000000000000000000000b59adf6fffffffffff7d5b49b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9ba6c9e9ffffffffffffe994400300000000000000000000000000000000000000000d58b0f7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe89743030000000000000000000000000000000000000e5aaef8fffffffffff2e1cfcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbd8eafbffffffffffea994103000000000000000000000000000000000d5db1f7ffffffffffe28a360000000000000000000000000000000000000000000000001368bcfcffffffffffec98440400000000000000000000000000000f5cb4f8ffffffffffe5923a01000000000000000000000000000000000000000000000000001b6ec2feffffffffffeb9b4704000000000000000000000000105eb2f9ffffffffffe89541020000000000000000000000000000000000000000000000000000001f73cbffffffffffffed9d4504000000000000000000000f61b5f9ffffffffffed9945040000000000000000000000000000000000000000000000000000000000247cd0ffffffffffffee9c48050000000000000000115fb7faffffffffffefa04805000000000000000000000000000000000000000000000000000000000000002d81d5ffffffffffffed9e4a050000000000001362b6fbfffffffffff1a450060000000000000000000000000000000000000000000000000000000000000000003286deffffffffffffefa14906000000001264b8fafffffffffff6a7530a0000000000000000000000000000000000000000000000000000000000000000000000378fe2fffffffffffff1a04c0700")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 LCD NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="45")
  inspect(f.glyph().bitmap().rows(), content="19")
  inspect(f.glyph().bitmap().pitch(), content="48")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="18")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000b1f3b556e869fb2bfc8d0d9e2e5e3dcd4cab8a1886438140100000000000000000000000000000000000f2d5886acd2eefdfffffffffffffffffffffffffffffffffffffffffbe3b37339110000000000000000000000002a7bd2fcfffffffffffffffef5e3cab5a69b928d929fb0c3d8ecfbfffffffffffffff5b25e1500000000000000000000001965b9f3fdeed0a27447200900000000000000000000000115458cccf4fffffffffffed7852e0200000000000000000000021d2d2b11020000000000000000000000000000000000000001348cdfffffffffffffea923e000000000000000000000000000000000000000000000000000000000000000000000000003a8ee2ffffffffffffb5610d000000000000000000000000000000000000000000000000000000000000000000000002267acbffffffffffffd37f2b0000000000000000000000000000000000000000041329415667798c9eafbfcbd7e3f0f9feffffffffffffffffea9642000000000000000000000000000b234a7499bbd8eefbfffffffffffffffffffffffffdf7eff1f7ffffffffffffeb9743000000000000000001143c78b9e5fcfffffffffffffef5e2c6ab927a67554130211308021367bbffffffffffffeb9743000000000000072f7acbf6fffffffffffbe4b783532a0f010000000000000000000000001367bbffffffffffffeb974300000000001465b9f8ffffffffffecae5b1b0100000000000000000000000000000000001367bbffffffffffffeb9743000000000657affdffffffffffef9d4503000000000000000000000000000000000000001367bbffffffffffffeb974300000000166ac2ffffffffffffcf7b2300000000000000000000000000000000000000002074c7ffffffffffffeb97430000000000439beefffffffffff7b75f140000000000000000000000000000000b2c62a4dbf9ffffffffffffffeb974300000000001260b4f6ffffffffffffeec48c5530160802000106112641638bb8e0f9fffffffbfbfbffffffffffeb974300000000000002246cc2f4fffffffffffffffffffffefaf8f9fdfffffffffffffce6bf894f2d66b6ffffffffffeb974300000000000000000115396ca1d1f0fffffffffffffffffffffffff7e4c69b6a3611010000003f97ebffffffffeb974300000000000000000000000000030e20313f4d5b65665f554a3a240e0200000000000000000000000000000000000000000000")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 LCD_V NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="20")
  inspect(f.glyph().bitmap().rows(), content="75")
  inspect(f.glyph().bitmap().pitch(), content="20")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="24")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000004447472600000000000000000000000000000004989b9b5b00000000000000000000000000000013ecefef9a0000000000000000000000000000002bffffffbe00000000000000000000000000000048ffffffdb00000000000000000000000000000064fffffff007000000000000000000000000000082fffffffd1800000000000000000000000000009efff6ffff310000000000000000000000000000bbffd8ffff4e0000000000000000000000000000d8ffa9ffff6c0000000000000000000000000006efff7bf6ff880000000000000000000000000015fcff59e6ffa4000000000000000000000000002fffff3ecdffc2000000000000000000000000004cffff26b4ffde0000000000000000000000000068fffc119bfff20800000000000000000000000086ffef0481fffe1b000000000000000000000000a2ffdb0067ffff35000000000000000000000000bfffc2004effff52000000000000000000000000dcffa80034ffff6f000000000000000000000007f1ff90001cffff8c000000000000000000000018fdff77000af7ffa8000000000000000000000033ffff5d0001e6ffc600000000000000000000004fffff450000cfffe201000000000000000000006cffff2c0000b5fff40a0000000000000000000089fffd1500009bfffe1e00000000000000000000a6fff306000082ffff3900000000000000000000c2ffe100000069ffff5500000000000000000000dfffc80000004fffff7300000000000000000009f3ffaf00000036ffff8f0000000000000000001bfeff960000001dffffac00000000000000000037ffff7d0000000af7ffca00000000000000000053ffff6400000001e7ffe40100000000000000006fffff4b00000000d0fff60c00000000000000008dffff3000000000b5ffff210000000000000000aafffe18000000009bffff3d0000000000000000c6fff4080000000081ffff590000000000000001e2ffe0000000000066ffff77000000000000000bf5ffc500000000004dffff93000000000000001efeffab000000000033ffffb0000000000000003affff90000000000019feffcd0000000000000057ffff76000000000009f5ffe70200000000000073ffff5b000000000000e3fff80e00000000000091ffff7e474747474747e0ffff25000000000000adffffb49b9b9b9b9b9be9ffff40000000000000cafffff3efefefefefeffbffff5d000000000002e5ffffffffffffffffffffffff7a00000000000df7ffffffffffffffffffffffff97000000000021ffffffffffffffffffffffffffb300000000003effffffffffffffffffffffffffd100000000005affffe1cbcbcbcbcbcbcbcbfbffea030000000077ffffa87777777777777777eefff9100000000095ffff621f1f1f1f1f1f1f1fd7ffff2800000000b1ffff360000000000000000bcffff4400000000cdffff1d0000000000000000a3ffff6000000003e8fff60a000000000000000088ffff7e0000000ff8ffe50100000000000000006effff9b00000024ffffcb00000000000000000054ffffb700000042ffffb000000000000000000039ffffd50000005effff950000000000000000001fffffed0400007bffff7b0000000000000000000cf8fffb13000098ffff5f00000000000000000002e8ffff2b0000b5ffff4500000000000000000000d0ffff480000d1ffff2a00000000000000000000b6ffff640004ebfffc13000000000000000000009bffff820011faffef050000000000000000000081ffff9e0028ffffda000000000000000000000067ffffbb0046ffffbe00000000000000000000004cffffd90062ffffa4000000000000000000000032ffffef067effff89000000000000000000000019fefffc159cffff6d000000000000000000000008f4ffff2fb8ffff53000000000000000000000000e2ffff4c85abab2f00000000000000000000000090abab3c465353120000000000000000000000004153532200000000000000000000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 LCD_V NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="15")
  inspect(f.glyph().bitmap().rows(), content="60")
  inspect(f.glyph().bitmap().pitch(), content="15")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="19")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000000000000000000000000000000000a243928050000000000000000001b5e7c91804d08000000000000001f6eb2d0e5d4a1380000000000000e70c2fcfffffff08804000000000358c8ffffffffffffd72b000000002dacfdfffffffffffffb73000000087df2ffffffffffffffffc312000022d2fffffffde6f1fffffff43200002afcfffff5b5929fd8ffffff5e000021f8fffaaa613e4b86f8ffff86000008e0ffc7520b00012ed0ffffb1000000b9ee7409000000018cffffd702000089ab25000000000042fffff11000004a5300000000000011f4fffe2700001d1100000000000001dfffff3e0000010000000000000000bfffff4c0000000000000000000000a2ffff5700000000000000000000008effff61000000000000000000000083ffff6b00000000000000000000007affff7500000000000000000000007affff7f0000000000000000011f43a5ffff8a00000000000000144a779bd6ffff9200000000000029679ecbf0ffffff9600000000002b7dbbf0ffffffffff97000000002383d5ffffffffffffff970000000b74d8fffffffffdf1ffff9700000045c8ffffffffdcb2bfffff9700000c9cfcfffff5bb845a8bffff9700003ce5fffff5ab67300867ffff97000087fffffdb05714000067ffff97000dd2ffffd1580a00000067ffff97002ff6fffb830f0000000067ffff970061ffffdb30000000000067ffff970093ffffa105000000000067ffff9700b9ffff5b00000000000067ffff9700d9ffff2b00000000000067ffff9701f1fffb0d00000000000067ffff9706fdffef0300000000000067ffff970dffffdc0000000000000067ffff9715ffffcf0000000000000067ffff9716ffffcf0000000000000074ffff970fffffda000000000000029effff9705f9ffeb01000000000020d3ffff9700eefff714000000000062f9ffff9700e0fffe3b000000001ab5ffffff9700cfffff830200000464eeffffff9700b4ffffc430020641b8fffbffff97008bfffff084505795f2ffcfffff970053ffffffdaa8afe9fff47cffff970024f4fffffffafdffffbf2dffff970008d1fffffffffffff46d05fcff97000082fbffffffffffbd2000f5ff97000039d1ffffffffe46a0100ebff9700000880ddfdffe6932100009aab660000002c85afb38e3b00000049533100000003315b5f3a020000000000000000000000090c0000000000000000")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 NORMAL DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 NORMAL DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 LIGHT DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 LIGHT DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 MONO DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 MONO DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 LCD DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 LCD DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 1 LCD_V DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/regular_CFF2.otf: rendered glyph 4 LCD_V DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/regular_CFF2.otf: hinted outline DEFAULT 16ppem" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 1U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="18")
  inspect(f.glyph().metrics().width(), content="576")
  inspect(f.glyph().metrics().height(), content="704")
  inspect(f.glyph().metrics().hori_advance(), content="576")
}

///|
test "parity/regular_CFF2.otf: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 1U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="557")
}

///|
test "parity/regular_CFF2.otf: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_regular_cff2_otf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 1U, load_flags=@base.LOAD_FORCE_AUTOHINT)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="576")
}

