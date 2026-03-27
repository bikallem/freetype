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
test "parity/regular_CFF2.otf: rendered glyph 1 NORMAL char 65" {
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
test "parity/regular_CFF2.otf: rendered glyph 4 NORMAL char 97" {
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
test "parity/regular_CFF2.otf: rendered glyph 1 LIGHT char 65" {
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
test "parity/regular_CFF2.otf: rendered glyph 4 LIGHT char 97" {
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
test "parity/regular_CFF2.otf: rendered glyph 1 MONO char 65" {
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
test "parity/regular_CFF2.otf: rendered glyph 4 MONO char 97" {
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
test "parity/regular_CFF2.otf: rendered glyph 1 LCD char 65" {
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
test "parity/regular_CFF2.otf: rendered glyph 4 LCD char 97" {
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
test "parity/regular_CFF2.otf: rendered glyph 1 LCD_V char 65" {
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
test "parity/regular_CFF2.otf: rendered glyph 4 LCD_V char 97" {
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

