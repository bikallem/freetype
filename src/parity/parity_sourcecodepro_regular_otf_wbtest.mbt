// Parity tests for SourceCodePro-Regular.otf
// AUTO-GENERATED — do not edit

///|
fn load_generated_sourcecodepro_regular_otf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/SourceCodePro-Regular.otf")
}

///|
test "parity/SourceCodePro-Regular.otf: format" {
  inspect(@base.detect_format(load_generated_sourcecodepro_regular_otf()), content="CffOpenType")
}

///|
test "parity/SourceCodePro-Regular.otf: loads" {
  inspect((try? @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())) is Ok(_), content="true")
}

///|
test "parity/SourceCodePro-Regular.otf: metadata" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  inspect(f.family_name(), content="Source Code Pro")
  inspect(f.num_glyphs(), content="1568")
  inspect(f.units_per_em(), content="1000")
  inspect(f.ascender(), content="984")
  inspect(f.descender(), content="-273")
  inspect(f.height(), content="1257")
  inspect(f.underline_position(), content="-75")
  inspect(f.underline_thickness(), content="50")
}

///|
test "parity/SourceCodePro-Regular.otf: bbox" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  inspect(f.bbox().x_min(), content="-193")
  inspect(f.bbox().y_min(), content="-454")
  inspect(f.bbox().x_max(), content="793")
  inspect(f.bbox().y_max(), content="1060")
}

///|
test "parity/SourceCodePro-Regular.otf: flags" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/SourceCodePro-Regular.otf: charmaps" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  inspect(f.charmaps().length(), content="6")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="0")
    inspect(f.charmaps()[0].encoding_id(), content="3")
  }
  if f.charmaps().length() > 1 {
    inspect(f.charmaps()[1].platform_id(), content="0")
    inspect(f.charmaps()[1].encoding_id(), content="4")
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
  if f.charmaps().length() > 5 {
    inspect(f.charmaps()[5].platform_id(), content="7")
    inspect(f.charmaps()[5].encoding_id(), content="0")
  }
}

///|
test "parity/SourceCodePro-Regular.otf: charmap entries" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 33U), content="918")
  inspect(@freetype.get_char_index(f, 34U), content="923")
  inspect(@freetype.get_char_index(f, 35U), content="1000")
  inspect(@freetype.get_char_index(f, 36U), content="1106")
  inspect(@freetype.get_char_index(f, 37U), content="1131")
  inspect(@freetype.get_char_index(f, 38U), content="876")
  inspect(@freetype.get_char_index(f, 39U), content="922")
  inspect(@freetype.get_char_index(f, 40U), content="961")
  inspect(@freetype.get_char_index(f, 41U), content="962")
  inspect(@freetype.get_char_index(f, 42U), content="971")
  inspect(@freetype.get_char_index(f, 43U), content="1152")
  inspect(@freetype.get_char_index(f, 44U), content="914")
  inspect(@freetype.get_char_index(f, 45U), content="935")
  inspect(@freetype.get_char_index(f, 46U), content="913")
  inspect(@freetype.get_char_index(f, 47U), content="967")
  inspect(@freetype.get_char_index(f, 48U), content="877")
  inspect(@freetype.get_char_index(f, 49U), content="878")
  inspect(@freetype.get_char_index(f, 50U), content="879")
  inspect(@freetype.get_char_index(f, 51U), content="880")
  inspect(@freetype.get_char_index(f, 52U), content="881")
  inspect(@freetype.get_char_index(f, 53U), content="882")
  inspect(@freetype.get_char_index(f, 54U), content="883")
  inspect(@freetype.get_char_index(f, 55U), content="884")
  inspect(@freetype.get_char_index(f, 56U), content="885")
  inspect(@freetype.get_char_index(f, 57U), content="886")
  inspect(@freetype.get_char_index(f, 58U), content="915")
  inspect(@freetype.get_char_index(f, 59U), content="916")
  inspect(@freetype.get_char_index(f, 60U), content="1159")
  inspect(@freetype.get_char_index(f, 61U), content="1157")
  inspect(@freetype.get_char_index(f, 62U), content="1160")
  inspect(@freetype.get_char_index(f, 63U), content="920")
  inspect(@freetype.get_char_index(f, 64U), content="998")
  inspect(@freetype.get_char_index(f, 65U), content="2")
  inspect(@freetype.get_char_index(f, 66U), content="3")
  inspect(@freetype.get_char_index(f, 67U), content="4")
  inspect(@freetype.get_char_index(f, 68U), content="5")
  inspect(@freetype.get_char_index(f, 69U), content="6")
  inspect(@freetype.get_char_index(f, 70U), content="7")
  inspect(@freetype.get_char_index(f, 71U), content="8")
  inspect(@freetype.get_char_index(f, 72U), content="9")
  inspect(@freetype.get_char_index(f, 73U), content="10")
  inspect(@freetype.get_char_index(f, 74U), content="11")
  inspect(@freetype.get_char_index(f, 75U), content="12")
  inspect(@freetype.get_char_index(f, 76U), content="13")
  inspect(@freetype.get_char_index(f, 77U), content="14")
  inspect(@freetype.get_char_index(f, 78U), content="15")
  inspect(@freetype.get_char_index(f, 79U), content="16")
  inspect(@freetype.get_char_index(f, 80U), content="17")
  inspect(@freetype.get_char_index(f, 81U), content="18")
  inspect(@freetype.get_char_index(f, 127925U), content="1557")
}

///|
test "parity/SourceCodePro-Regular.otf: glyph 918 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  let r = try? @freetype.load_glyph(f, 918U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="18")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="272")
  inspect(f.glyph().outline().points()[0].y(), content="232")
  inspect(f.glyph().outline().points()[1].x(), content="328")
  inspect(f.glyph().outline().points()[1].y(), content="232")
  inspect(f.glyph().outline().points()[2].x(), content="338")
  inspect(f.glyph().outline().points()[2].y(), content="576")
  inspect(f.glyph().outline().points()[3].x(), content="340")
  inspect(f.glyph().outline().points()[3].y(), content="670")
  inspect(f.glyph().outline().points()[4].x(), content="260")
  inspect(f.glyph().outline().points()[4].y(), content="670")
  inspect(f.glyph().outline().points()[5].x(), content="262")
  inspect(f.glyph().outline().points()[5].y(), content="576")
  inspect(f.glyph().outline().points()[6].x(), content="300")
  inspect(f.glyph().outline().points()[6].y(), content="-12")
  inspect(f.glyph().outline().points()[7].x(), content="340")
  inspect(f.glyph().outline().points()[7].y(), content="-12")
  inspect(f.glyph().metrics().hori_advance(), content="600")
}

///|
test "parity/SourceCodePro-Regular.otf: glyph 923 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  let r = try? @freetype.load_glyph(f, 923U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="12")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="157")
  inspect(f.glyph().outline().points()[0].y(), content="352")
  inspect(f.glyph().outline().points()[1].x(), content="213")
  inspect(f.glyph().outline().points()[1].y(), content="352")
  inspect(f.glyph().outline().points()[2].x(), content="238")
  inspect(f.glyph().outline().points()[2].y(), content="577")
  inspect(f.glyph().outline().points()[3].x(), content="240")
  inspect(f.glyph().outline().points()[3].y(), content="687")
  inspect(f.glyph().outline().points()[4].x(), content="130")
  inspect(f.glyph().outline().points()[4].y(), content="687")
  inspect(f.glyph().outline().points()[5].x(), content="132")
  inspect(f.glyph().outline().points()[5].y(), content="577")
  inspect(f.glyph().outline().points()[6].x(), content="387")
  inspect(f.glyph().outline().points()[6].y(), content="352")
  inspect(f.glyph().outline().points()[7].x(), content="443")
  inspect(f.glyph().outline().points()[7].y(), content="352")
  inspect(f.glyph().metrics().hori_advance(), content="600")
}

///|
test "parity/SourceCodePro-Regular.otf: glyph 1000 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  let r = try? @freetype.load_glyph(f, 1000U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="32")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="228")
  inspect(f.glyph().outline().points()[0].y(), content="261")
  inspect(f.glyph().outline().points()[1].x(), content="246")
  inspect(f.glyph().outline().points()[1].y(), content="409")
  inspect(f.glyph().outline().points()[2].x(), content="378")
  inspect(f.glyph().outline().points()[2].y(), content="409")
  inspect(f.glyph().outline().points()[3].x(), content="360")
  inspect(f.glyph().outline().points()[3].y(), content="261")
  inspect(f.glyph().outline().points()[4].x(), content="142")
  inspect(f.glyph().outline().points()[4].y(), content="0")
  inspect(f.glyph().outline().points()[5].x(), content="196")
  inspect(f.glyph().outline().points()[5].y(), content="0")
  inspect(f.glyph().outline().points()[6].x(), content="221")
  inspect(f.glyph().outline().points()[6].y(), content="204")
  inspect(f.glyph().outline().points()[7].x(), content="353")
  inspect(f.glyph().outline().points()[7].y(), content="204")
  inspect(f.glyph().metrics().hori_advance(), content="600")
}

///|
test "parity/SourceCodePro-Regular.otf: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 918U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="640")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 NORMAL NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
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
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 NORMAL NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="10")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000057f50000000000000004aede101000000000000a07de938000000000006f0309f8e00000000004ce50053e30100000000a299000df93b00000007f1824343d2920000004ef7cbcbcbdae6020000a4a600000019fe3f0008f25600000000c7950050f90e0000000077e903")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 NORMAL NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="9")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="8")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0046a9dae6aa1d0027d76b333dc9ca01000000000047ff1f00074c96bbdbff3a21d9b0511f17ff3b92b600000014ff3b96cd11002abcfe3b1dd2fdebcb40e13b00011f1100000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 NORMAL NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0004619b9661080005c0e79c96d6d60d4cfc1900000340005afc18000000000010e1df6106000000001196fae67104000000001b8af6d110000000000022f375100600000000d384a6d24a100a6bfa360c94eafeffe154000000001c18000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 NORMAL NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="8")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0030b9ebd5c7c7c70615eb7c0a40f3784b0255ed0000009d9200003ef80f0000b885000003b9d273ade71c000016d5597a650f0000004ae82100000000000007cffff6f3ebcb560069b10f1d2034a4f603c461000000006fde0065ef8d6771abe43600002b758c7c53060000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 NORMAL NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="14")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000005629c86370000000cbee593acfa6700007ae81d00006df81a00e98100000004e58113ff4400000000adaa32ff2b0000000094ca25ff3700000000a1bc08fd5900000000c29d00b5b20000001dfd4b003bf971061ac4ca0200004fdff8fdb314000000000298da0f00000000000009d2e09d71000000000009659065")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 NORMAL NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="10")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000e83a142000000000000b4b167f3160000000005fc2a00e3360000000000f4424be4090000000000acc3e134000000000002a6ff3e000022a30500a0cba4c404007bb4002cff2c0ad5a50ce34d0045fd07001cdcdec0000012f184020692ffda4c000047e5f0f4c12d88f418000002210e0000000c00")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 NORMAL NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000385b320200000cbee2b0e1ba140091c6090008b79f00d7620000002efd17d16a00000009f73e84dc2c0336c7f95a0791ebf1ba31f64000000001001eff1d000000000082d101396406045df5470041d8f8f7e54e00000000131c00000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 LIGHT NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
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
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 LIGHT NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="10")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000057f50000000000000004aede101000000000000a07de938000000000006f0309f8e00000000004ce50053e30100000000a299000df93b00000007f1824343d2920000004ef7cbcbcbdae6020000a4a600000019fe3f0008f25600000000c7950050f90e0000000077e903")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 LIGHT NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="9")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="8")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0046a9dae6aa1d0027d76b333dc9ca01000000000047ff1f00074c96bbdbff3a21d9b0511f17ff3b92b600000014ff3b96cd11002abcfe3b1dd2fdebcb40e13b00011f1100000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 LIGHT NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0004619b9661080005c0e79c96d6d60d4cfc1900000340005afc18000000000010e1df6106000000001196fae67104000000001b8af6d110000000000022f375100600000000d384a6d24a100a6bfa360c94eafeffe154000000001c18000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 LIGHT NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="8")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0030b9ebd5c7c7c70615eb7c0a40f3784b0255ed0000009d9200003ef80f0000b885000003b9d273ade71c000016d5597a650f0000004ae82100000000000007cffff6f3ebcb560069b10f1d2034a4f603c461000000006fde0065ef8d6771abe43600002b758c7c53060000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 LIGHT NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="14")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000005629c86370000000cbee593acfa6700007ae81d00006df81a00e98100000004e58113ff4400000000adaa32ff2b0000000094ca25ff3700000000a1bc08fd5900000000c29d00b5b20000001dfd4b003bf971061ac4ca0200004fdff8fdb314000000000298da0f00000000000009d2e09d71000000000009659065")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 LIGHT NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="10")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000e83a142000000000000b4b167f3160000000005fc2a00e3360000000000f4424be4090000000000acc3e134000000000002a6ff3e000022a30500a0cba4c404007bb4002cff2c0ad5a50ce34d0045fd07001cdcdec0000012f184020692ffda4c000047e5f0f4c12d88f418000002210e0000000c00")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 LIGHT NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000385b320200000cbee2b0e1ba140091c6090008b79f00d7620000002efd17d16a00000009f73e84dc2c0336c7f95a0791ebf1ba31f64000000001001eff1d000000000082d101396406045df5470041d8f8f7e54e00000000131c00000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 MONO NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
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
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 MONO NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="11")
  inspect(f.glyph().bitmap().buffer().length(), content="22")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 MONO NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="7")
  inspect(f.glyph().bitmap().rows(), content="8")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="8")
  inspect(f.glyph().bitmap().buffer().length(), content="16")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 MONO NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="11")
  inspect(f.glyph().bitmap().buffer().length(), content="22")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 MONO NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="8")
  inspect(f.glyph().bitmap().buffer().length(), content="24")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 MONO NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="14")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="11")
  inspect(f.glyph().bitmap().buffer().length(), content="28")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 MONO NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="11")
  inspect(f.glyph().bitmap().buffer().length(), content="22")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 MONO NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="7")
  inspect(f.glyph().bitmap().rows(), content="10")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="10")
  inspect(f.glyph().bitmap().buffer().length(), content="20")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 LCD NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
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
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 LCD NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="30")
  inspect(f.glyph().bitmap().rows(), content="11")
  inspect(f.glyph().bitmap().pitch(), content="32")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000052e5a7f7f7a50260000000000000000000000000000000000000000000000064a9eefededede18d35010000000000000000000000000000000000000000054ca0eecf7d6797e9e38c3801000000000000000000000000000000000000064aa2f0dd8430044b9fefe28e3a0100000000000000000000000000000000074ca0f1e5923a00000953a7f6e39139010000000000000000000000000000064ea2f0eb9945020000000d5ab2f9e68f3b02000000000000000000000000074ca4f1fbc0824943434343435494d2ffe4923e0100000000000000000000084ea2f2f7e6d4cbcbcbcbcbcbcbcbcbdaebfde6943c0200000000000000000750a4f1f3a65207000000000000000000196bc3fee8933f03000000000000084ea6f2f7aa560b00000000000000000000001c73c7ffe7954102000000000950a4f3f9b35b0e000000000000000000000000002477cbffe9984003000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 LCD NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="27")
  inspect(f.glyph().bitmap().rows(), content="9")
  inspect(f.glyph().bitmap().pitch(), content="28")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="8")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000921466f91a9b9cadae8ece6d8c7aa80471d0500000000000000002778c3d7b38a6b5543332c2e3d598fc9f2faca782501000000000000000000000000000000000000000005479bedffcb731f0000000000000000000717314c688396a5afbbc6d1dbeaf7ffe68e3a0000000000042157a3d9efd8b0886b513c2b1f140a1768bfffe78f3b00000000003e92e5f9b662110000000000000000001468c0ffe78f3b00000000004296e9fdcd86351104000005112a5286bce3fafee78f3b0000000000011d539bd2effefdf4ecebece5cba573404f92e1e78f3b0000000000000000000107131f241f110500000000000000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 LCD NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="27")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="28")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000004173b617d8e9ba4a296857361432108000000000000000000052972c0f0f8e7cfb49c8d8b96a5b9d6eff3d68f420d0000000000044ca0f4fcc16919000000000000000003173a402c09000000000000095aaefcfcc0681800000000000000000000000000000000000000000010489de1fdf7dfb98a6139180600000000000000000000000000000000000111326496c4e8fafff9e6c89e714018040000000000000000000000000000000000071b3a628ab5def6fff0d18e45100000000000000000000000000000000000000000052269bcf3ffc97521000000000010171706000000000000000000000000277fd3ffd884300000000e52a6ebf2d2a06d4a34211006040a1c396babe2fad986360400000000000c2b6094bdd8eaf6fefefefefffff7e1bd8d5425040000000000000000000000000000040e1c2423180c04000000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 LCD NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="30")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="32")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="8")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000f306195b9d2e2ebebe1d5ccc8c7c7c7c7c7c7c78c4706000000000000001554adebf1bf7c3e190a0a1c4080c4f3ecb378504b4b351b020000000000000655a9faed99410000000000000001499df0e6923e0000000000000000000000003e92eaf8b45c0f0000000000001164b8fad98531000000000000000000000000032168b9eeeed2ac8873738badd4ede7af5a1c010000000000000000000000001651a8d5bc7f595b6d7a7c74654e2b0f010000000000000000000000000000014a9ef4e8a859210e040000000000000000000000000000000000000000000000072f83cffbfffffefaf6f4f3f3f3f0ebe4dbcbb48c562404000000000000002769bdd5b165280f0f171d1f1f202229344166a4dffff6a64e0300000000001870c4feb5610e000000000000000000000003206fc0fbde8a32000000000000002565b9ebefd3ab8d796d676569717d91abcfe6e4bc77360d0000000000000000000003122b4a64757e868c8c867c726653381906000000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 LCD NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="30")
  inspect(f.glyph().bitmap().rows(), content="14")
  inspect(f.glyph().bitmap().pitch(), content="32")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000051d4062778b9ca19986735b37170100000000000000000000000000000c3578beeaf9e5c8a6938d96acceebfae3b1672c0600000000000000000000297acdfde8af591d02000000000005276dbbf2f8be661a00000000000000003d95e9ffd5812d00000000000000000000043e96e5ffd5812d0000000000001367bffff098440000000000000000000000000459adfdfbaa560300000000003286deffd77f2b000000000000000000000000004094e8ffca761e00000000002579d1ffe38b37000000000000000000000000004da1f4ffbc68100000000000085ab2fdfbad59090000000000000000000000166ec2fff19d49000000000000001261b5f6f6b25e100000000000000000001d6ec6fdee9f4b090000000000000000083b8ad9f9eab67138140601091a4181c4f0f4ca782c020000000000000000000000011c4f8cbedff4fdf8f7f9fdf1d7b37f42140000000000000000000000000000000000000002114898dcfbda953f0f00000000000000000000000000000000000000000000000000093688d2f9f3e0c6af9d9599713f060000000000000000000000000000000000000000092147657a8890908565391000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 LCD NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="30")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="32")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000e305e839aa3a19170421a020000000000000000000000000000000000001660b4f1dfb17760679ed5f3b96116000000000000000000000000000000000556aefcd67e2a0000003890e3e28a36000000000000000000000000000000000049a1f4ed964202114b9ee4e499420900000000000000000000000000000000000d58acf3e1c3bbd8e1bb72340d000000000000000000000000000000000000021a55a6e2ffffe4923e0600000000000000225993a371380500000000001550a0dff0cb8e7ca4e0f3c474280400000000277bcff8b4601000000000002c80d8ffd8802c00000a398bd5f6dea5581e0c4098e3eba14d0d0000000000004599f1fdb1590700000000021c51a2dcf7e2dee2f3c06c1d00000000000000001258b0f1f7c7843c13020000061a4792d1fbfffff6daaf7b4c230900000000000000194785bfe5f9faf0e8ecf4f5e4c191542d2b5288b9e1f4c169180000000000000000000002081421241c0e04000000000000000000030c0c0800000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 LCD NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="27")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="28")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000d213849575b5443321e0d020000000000000000000000000c387abee5f1e2c9b4b0b6c9e1f0e5ba7e3d1400000000000000033d91e1f6c67b2c09000000000008246bb7eee89f4b0b00000000002b83d7ffb6620e000000000000000000012e82d9fdc0681700000000257dd1ffbe6a16000000000000000000000955adf7ea923e00000000033384d5fadca35a2c1004030c1e365c94c7e4f2f9ffae5a07000000000007265891bbdaebf6f7f1e2d1ba9764315ba4f6ec94400000000000000000000000000001010100000000001e72caffc9711d00000000000000000000000000000000000000023082d4fbd17f2a0100000000000d396d81643614060000040f2e5d9cd5f5e79b470c0000000000000018417bb0d8f1fbf8f2f1f7fcf7e5c08a4e2005000000000000000000000000000001081320241c0e04000000000000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 LCD_V NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
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
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 LCD_V NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="36")
  inspect(f.glyph().bitmap().pitch(), content="10")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000002b1900000000000000057f500000000000000014d391000000000000002dfec5000000000000004aede10100000000000066cbf40a00000000000083a0f71d000000000000a07de938000000000000bc63d254000000000000d949b872000000000006f0309f8e000000000016fb1986ab000000000030f6086cc800000000004ce50053e3010000000068cd003af60b0000000086b30020fe2000000000a299000df93b00000000be7f0002e95700000000dc630000d07500000007f1824343d29200000017fdb59797e1ae00000032fff3efeffacc0000004ef7cbcbcbdae60200006ae377777797f70d000088c51f1f1f47ff230000a4a600000019fe3f0000c18c00000008f45b0000de7100000000e1790008f25600000000c7950019fd3c00000000adb10034ff220000000092cf0050f90e0000000077e90340a5020000000047a503244d00000000001e53030000000000000000000000000000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 LCD_V NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="30")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000052e3a0d000000095586925600000046a9dae6aa1d00179af7dfe7f1500026e8bf8791f2950027d76b333dc9ca01108418000196eb07012c00000065fd12000000000047ff1f000000000f59ff2c000007426798ff3500074c96bbdbff3a0039a0e0cbb2ff3b048de2a57360ff3b21d9b0511f17ff3b4aee5c080013ff3b78d814000013ff3b92b600000014ff3ba1a50000002bff3ba3ad0000016fff3b96cd11002abcfe3b77eb62417ed4f73b47fcba99d294ed3b1dd2fdebcb40e13b047fcbbb770a9428002a73632200471300011f11000000000000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 LCD_V NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="39")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000000000000001647421000000004619b96610800002eb5efeab537000073f7edeafd8b0705c0e79c96d6d60d18eba9484286e10d32ff5502002e93054cfc1900000340005df903000000060062f90300000000005afc18000000000046ff4b000000000028fa9f170000000010e1df6106000000019effb540000000004be0f698240000001196fae6710400000042c1ffc52e0000000969daf881010000001b8af6d1100000000036bffb3100000000036cfe58000000000022f375000000000004e385000000000000d38b100600000000d3843b3200000004e273818405000021f35aa6d24a100a6bfa3688f99e635dbbe41642dff1bbb5f5a4010c94eafeffe15400004196c8c48e170000093e706c3500000000001c180000000000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 LCD_V NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="39")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000143f291b1b1b000006659781737373030030b9ebd5c7c7c7060071eeb6e2fff8f70704c2c35e94ffad9f0415eb7c0a40f3784b022bfc33000ad856000045f70e0000b67c000055ed0000009d92000059e70000009899000051ed0000009e9500003ef80f0000b885000026fb38000ed86b000011e48d1f59f242000003b9d273ade71c000000a3f9c7f2a304000005b8adceb94d00000016d5597a650f00000031da0926120000000048da000000000000004ae82100000000000038fa754b473f1f00001be6cca39f97771b0007cffff6f3ebcb56000acdbbc9cce0fda20034c963717488d8dc0069b10f1d2034a4f6039f7a0000000069fb03bc5d0000000058f203c461000000006fde00bc8a0000000baab5009bc439131d57e0760065ef8d6771abe436002fd6e0bbc5ea9a0d00087ec9e0d0a7420000002b758c7c53060000000021382808000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 LCD_V NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="45")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000000000000000000124832040000000005629c86370000000027b6f0da88040000006ffce6f7db2800000cbee593acfa67000027efab3f58e6af000051fb570009b0e306007ae81d00006df81a00a4ca02000035ff3b00cca300000013f86400e98100000004e58102f96400000000ce9409ff4f00000000b99f13ff4400000000adaa1eff3b00000000a4b52aff31000000009ac132ff2b0000000094ca34ff2a0000000093cb2eff300000000098c525ff3700000000a1bc1bff4000000000a9b211ff4a00000000b3a808fd5900000000c29d02f17000000000d88a00d79000000009f06d00b5b20000001dfd4b0091d607000046ff2a0069f12c000084f110003bf971061ac4ca020017dbbd526cef890000019df1aac4f4410000004fdff8fdb3140000001a8df4e25f000000000035cfd81200000000000298da0f00000000000059f64301000000000025f49b49320000000009d2e09d71000000000088fbf0b600000000003cb9e4a3000000000009659065000000000000163c20")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 LCD_V NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="39")
  inspect(f.glyph().bitmap().pitch(), content="10")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000000000000000000000000304d0d0000000000000e83a14200000000000039d7f18e00000000000077e8bbd8070000000000b4b167f3160000000000da7216f0290000000001f33e00e2360000000005fc2a00e3360000000006ff2408ee2b0000000005fc2e1df7170000000000f4424be4090000000000e4598eb9000000000000cb8cd071000000000000acc3e1340000000000008af1b30a00000000000085ff6300000c53050002a6ff3e000022a305001dd8fa4d000041e9050058ecd98900005fd30000a0cba4c404007bb40006d98e5feb1f009a970017f65329f45900c174002cff2c0ad5a50ce34d0040fd14009ade40f4260048fd06004ff797e50a0045fd07001cdcdec0000039ff1a0002a3fea2000025ff4100007bffb60e0012f184020692ffda4c0005d0c6464fcbd6fba00e008df59ea7ef81d6ea170047e5f0f4c12d88f418001593cdb86d0237ac0900003b75601e00065400000002210e0000000c0000000000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 LCD_V NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="36")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="11")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000008000000000000385b32020000001e8caf86200000006ae4fede6800000cbee2b0e1ba14002cf1975c95ed390061ea3f053de2700091c6090008b79f00b2980000007fcb01c77500000050ec0ad7620000002efd17e05a00000015ff27dd5c00000008f933d16a00000009f73ec38400000032f84aaab002000281fe5684dc2c0336c7f95a51f680548ac7f25722ddd6acdb7ef04c0791ebf1ba31f640003d97a1660cfd3500083f491210ff2900000001001eff1d000000000035fe11000000000059ef07000000000082d1010000000000b0a500111d00001cdb7500396406045df547006db7524fb1e520006af1aaa7eda1070041d8f8f7e54e00000e84bfc891140000002d6770390000000000131c000000000000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 NORMAL DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 NORMAL DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 NORMAL DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 NORMAL DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 NORMAL DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 NORMAL DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 NORMAL DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 NORMAL DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 LIGHT DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 LIGHT DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 LIGHT DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 LIGHT DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 LIGHT DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 LIGHT DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 LIGHT DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 LIGHT DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 MONO DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 MONO DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 MONO DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 MONO DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 MONO DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 MONO DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 MONO DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 MONO DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 LCD DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 LCD DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 LCD DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 LCD DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 LCD DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 LCD DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 LCD DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 LCD DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 LCD_V DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 LCD_V DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 LCD_V DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 LCD_V DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 LCD_V DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 LCD_V DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 LCD_V DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 LCD_V DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 NORMAL NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
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
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 NORMAL NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="20")
  inspect(f.glyph().bitmap().rows(), content="24")
  inspect(f.glyph().bitmap().pitch(), content="20")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="24")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000003979b9b5b00000000000000000000000000000043ffffffdb0000000000000000000000000000009afff6ffff310000000000000000000000000004ecff82f1ff870000000000000000000000000046ffff32abffde000000000000000000000000009cffe60160ffff34000000000000000000000005edff9c0017feff8b000000000000000000000049ffff510000caffe100000000000000000000009ffff90d00007fffff3700000000000000000006efffbb00000034ffff8e0000000000000000004bffff7000000001e7ffe3010000000000000000a2ffff22000000009affff3b0000000000000007f1ffd100000000004affff91000000000000004effff82000000000007f3ffe602000000000000a4ffffb99b9b9b9b9b9be8ffff3e000000000008f2ffffffffffffffffffffffff94000000000051ffffe3cbcbcbcbcbcbcbcbfbffe80300000000a7ffff420000000000000000bcffff4100000009f4ffee0400000000000000006dffff9700000054ffffa10000000000000000001effffea030000aaffff5100000000000000000000ceffff44000bf5fff60a000000000000000000007effff9b0056ffffb000000000000000000000002fffffed04acffff5f000000000000000000000000dfffff48")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 NORMAL NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="19")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="18")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000001377eb8d2e5d5b0640300000000000669d7ffffffffffffffffc92b0000001edbffffffeaae909cc6fafffff31a000002cdffc24402000000002dd0ffffa20000003444000000000000000022f8fffe1e00000000000000000000000000a7ffff480000000000000000000000000183ffff6d000000000000053b6e99c2def8ffffff8a0000000145adf3fffffffffff8efffff8b000023c3ffffffd6956137140067ffff8b001ee6ffffa72e00000000000067ffff8b00a4ffff77000000000000000067ffff8b00f4ffea03000000000000000067ffff8b09ffffde00000000000000000197ffff8b00d9ffff2f0000000000001fb7ffffff8b0092ffffe75f1100093c96f8ffd5ffff8b000acffffffffff7ffffffec650affff8b0000148ff8ffffffffed93130000edff8b00000000123d625c3b0500000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 NORMAL NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="18")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="18")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="25")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000400000000000000000000000000399ec6edffebc87e280000000000000020affffffffffffffffffd9f17000000000fd9ffffffcfaa9cb3e9ffffffe22e000000b3ffffd032000000000146daffe91e00002cfffff21b0000000000000008853c00000063ffffb6000000000000000000000000000067ffffb6000000000000000000000000000035fffff31a0000000000000000000000000007eaffffd531000000000000000000000000004effffffffb0320000000000000000000000006bf9ffffffffbc4b010000000000000000000034c0ffffffffffda6706000000000000000000003aacfcffffffffe3540000000000000000000000208cf0ffffffff8a0000000000000000000000000d73efffffff550000000000000000000000000017ceffffe5000000000000000000000000000021feffff1c0000000000000000000000000000d9ffff470000050000000000000000000000d6ffff3c0058d62400000000000000000021fefff80f3cf8fff1770800000000000018d3ffffa1001ccdffffffee9f6044405f97f7ffffe41800000a90f9ffffffffffffffffffffcb2700000000002293e2ffffffffffffdc59010000000000000000002b4a64665325000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 NORMAL NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="18")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000004897c1e0c096807f7f7f7f7f7f2500000022b7ffffffffffffffffffffffffff4b00000ddaffffcb6c486ed0fffffbebebebeb460000a7ffff970300000005a0fff92d00000000001cfeffdd0800000000000ce5ffc2000000000051ffff9800000000000000a5fffc0c0000000060ffff7c0000000000000089ffff360000000044ffffa600000000000000b3ffff220000000009f0fff11d000000000024f5ffde00000000000063ffffc92100000025cfffff4f000000000000008efffff5b593b7f7ffff880000000000000005b1ffedffffffffffd2480000000000000000aaffbe0b20586b4b230200000000000000002bffff4500000000000000000000000000000049ffff5f00000000000000000000000000000017f8fff686432d2727272717050000000000000057f8ffffffffffffffffffffeca2450000000017cbffffffffffffffffffffffffff6d000028e8ff99111e394747474a5777cdfffffe1004d8ffa20000000000000000000005cfffff4747ffff350000000000000000000000a1ffff4a5dffff4e000000000000000000000ce9fff6132dffffcf19000000000000000020cfffff800000abffffed984f3420284363b6fcffff9c0200000a9ffcffffffffffffffffffffe05a0000000000001a76c1dbf4fff5d6b79449040000000000000000000000000900000000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 NORMAL NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="31")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="25")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000400000000000000000000000000000359b3e6fdf7d98e2d0000000000000000002bcbfffffffffffffffc8b060000000000002dedffffffc99fabe6ffffffae04000000000de3ffffd630000000046ef9ffff890000000090ffffde1200000000000058fffffb2c000012f8ffff430000000000000000a8ffffa200006cffffc60000000000000000002cfffff60f00b6ffff6f00000000000000000000d6ffff4f00eaffff35000000000000000000009affff8418ffffff19000000000000000000007fffffb32afffffc020000000000000000000063ffffc53affffe3000000000000000000000048ffffd53effffd900000000000000000000003dffffd930ffffe400000000000000000000004affffca20fffff601000000000000000000005dffffba02f4ffff200000000000000000000086ffff9000c8ffff5300000000000000000000b9ffff620081ffffa00000000000000000000df9fffe1b002cfffff41400000000000000006effffc4000000b7ffff950000000000000014e7ffff4e00000030faffff6700000000000ebfffffc100000000006effffffa93f162262dbffffe91b00000000000072fdffffffffffffffffde26000000000000000036bcfeffffffffed870d0000000000000000000000179fffffc804000000000000000000000000000015f3ffff5300000000000000000000000000000077fffffc7d1200000001000000000000000000008ffffffff8ceb8db8800000000000000000000006de9ffffffffffc60000000000000000000000000b6b9bc1d8bf7b")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 NORMAL NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="20")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="20")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="25")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000002000000000000000000000000000000001196d4fcdfa2180000000000000000000000002be2ffffffffffec1c0000000000000000000001c5fff4622259f2ffa60000000000000000000046ffff6400000083ffed0000000000000000000078ffff0b00000056ffff0f00000000000000000099fff00000000077ffeb000000000000000000007effff0c000004d0ffb10000000000000000000056ffff36000087fffa2d000000000000000000001efdff8d028bffff75000000000000000000000000b6ffe9bdffff7a000000000000000000000000004ffffffff86200000000000000000000000000028bffffff4b0000000000000042bfbf49000007b6ffffffffbc02000000000000a3fffc160003b0ffffb4aaffff7f000000000007f1ffb700006effffc50a0edefffd42000000004dffff5d000cebfff315000036faffec30000000bdfff40d003fffff9a0000000073ffffed300049ffff7f00006bffff6f00000000008fffffed34d2ffe50b00006dffff8b00000000000095fffffaffff6100000046ffffcd010000000000019affffffe40300000007e7ffff750000000000006cffffffffbe200000004affffffa43007043bb9fffff6f1fffff49123000085fefffffffbfcffffffe1321db8ffffff960000003acfffffffffffe7800b0000005cd2ff400000000000174266583602000000000000003e02")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 NORMAL NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="25")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="24")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000053b595c430e0000000000000000000579f2fffffffff9b12b0000000000002ed5fffffffefcfffffffc6a000000000dddffffbc3e0d093684fcffff67000000a2ffff8c0100000000003cedfff5240024ffffd506000000000000006affffa1006cffff7b000000000000000003d6fff8138bffff4e00000000000000000083ffff558dffff4b0000000000000000004bffff8e76ffff710000000000000000001bffffb63cffffca02000000000000000abaffffc703caffff7d01000000000031ceffffffd7002cf9ffffc4643e3459aefcff97faffcd000054e8ffffffffffffffeb620cffffbc0000000e87c4ebfff6ca74100021ffffab000000000000000b000000000051ffff800000000000000000000000000089ffff4800000000000000000000000001defffa100000000000000000000000004effffa60000000000000000000000000ee1ffff39000009a23700000000000013c8ffff9b000002b0fffd9853200d2e7bedffffd10c0000026ff3ffffffffffffffffffc11000000000001eacf9ffffffffffd75f0100000000000000000d445e68532400000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 LIGHT NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
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
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 LIGHT NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="20")
  inspect(f.glyph().bitmap().rows(), content="24")
  inspect(f.glyph().bitmap().pitch(), content="20")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="24")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000003979b9b5b00000000000000000000000000000043ffffffdb0000000000000000000000000000009afff6ffff310000000000000000000000000004ecff82f1ff870000000000000000000000000046ffff32abffde000000000000000000000000009cffe60160ffff34000000000000000000000005edff9c0017feff8b000000000000000000000049ffff510000caffe100000000000000000000009ffff90d00007fffff3700000000000000000006efffbb00000034ffff8e0000000000000000004bffff7000000001e7ffe3010000000000000000a2ffff22000000009affff3b0000000000000007f1ffd100000000004affff91000000000000004effff82000000000007f3ffe602000000000000a4ffffb99b9b9b9b9b9be8ffff3e000000000008f2ffffffffffffffffffffffff94000000000051ffffe3cbcbcbcbcbcbcbcbfbffe80300000000a7ffff420000000000000000bcffff4100000009f4ffee0400000000000000006dffff9700000054ffffa10000000000000000001effffea030000aaffff5100000000000000000000ceffff44000bf5fff60a000000000000000000007effff9b0056ffffb000000000000000000000002fffffed04acffff5f000000000000000000000000dfffff48")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 LIGHT NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="19")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="18")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000001377eb8d2e5d5b0640300000000000669d7ffffffffffffffffc92b0000001edbffffffeaae909cc6fafffff31a000002cdffc24402000000002dd0ffffa20000003444000000000000000022f8fffe1e00000000000000000000000000a7ffff480000000000000000000000000183ffff6d000000000000053b6e99c2def8ffffff8a0000000145adf3fffffffffff8efffff8b000023c3ffffffd6956137140067ffff8b001ee6ffffa72e00000000000067ffff8b00a4ffff77000000000000000067ffff8b00f4ffea03000000000000000067ffff8b09ffffde00000000000000000197ffff8b00d9ffff2f0000000000001fb7ffffff8b0092ffffe75f1100093c96f8ffd5ffff8b000acffffffffff7ffffffec650affff8b0000148ff8ffffffffed93130000edff8b00000000123d625c3b0500000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 LIGHT NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="18")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="18")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="25")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000400000000000000000000000000399ec6edffebc87e280000000000000020affffffffffffffffffd9f17000000000fd9ffffffcfaa9cb3e9ffffffe22e000000b3ffffd032000000000146daffe91e00002cfffff21b0000000000000008853c00000063ffffb6000000000000000000000000000067ffffb6000000000000000000000000000035fffff31a0000000000000000000000000007eaffffd531000000000000000000000000004effffffffb0320000000000000000000000006bf9ffffffffbc4b010000000000000000000034c0ffffffffffda6706000000000000000000003aacfcffffffffe3540000000000000000000000208cf0ffffffff8a0000000000000000000000000d73efffffff550000000000000000000000000017ceffffe5000000000000000000000000000021feffff1c0000000000000000000000000000d9ffff470000050000000000000000000000d6ffff3c0058d62400000000000000000021fefff80f3cf8fff1770800000000000018d3ffffa1001ccdffffffee9f6044405f97f7ffffe41800000a90f9ffffffffffffffffffffcb2700000000002293e2ffffffffffffdc59010000000000000000002b4a64665325000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 LIGHT NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="18")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000004897c1e0c096807f7f7f7f7f7f2500000022b7ffffffffffffffffffffffffff4b00000ddaffffcb6c486ed0fffffbebebebeb460000a7ffff970300000005a0fff92d00000000001cfeffdd0800000000000ce5ffc2000000000051ffff9800000000000000a5fffc0c0000000060ffff7c0000000000000089ffff360000000044ffffa600000000000000b3ffff220000000009f0fff11d000000000024f5ffde00000000000063ffffc92100000025cfffff4f000000000000008efffff5b593b7f7ffff880000000000000005b1ffedffffffffffd2480000000000000000aaffbe0b20586b4b230200000000000000002bffff4500000000000000000000000000000049ffff5f00000000000000000000000000000017f8fff686432d2727272717050000000000000057f8ffffffffffffffffffffeca2450000000017cbffffffffffffffffffffffffff6d000028e8ff99111e394747474a5777cdfffffe1004d8ffa20000000000000000000005cfffff4747ffff350000000000000000000000a1ffff4a5dffff4e000000000000000000000ce9fff6132dffffcf19000000000000000020cfffff800000abffffed984f3420284363b6fcffff9c0200000a9ffcffffffffffffffffffffe05a0000000000001a76c1dbf4fff5d6b79449040000000000000000000000000900000000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 LIGHT NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="31")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="25")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000400000000000000000000000000000359b3e6fdf7d98e2d0000000000000000002bcbfffffffffffffffc8b060000000000002dedffffffc99fabe6ffffffae04000000000de3ffffd630000000046ef9ffff890000000090ffffde1200000000000058fffffb2c000012f8ffff430000000000000000a8ffffa200006cffffc60000000000000000002cfffff60f00b6ffff6f00000000000000000000d6ffff4f00eaffff35000000000000000000009affff8418ffffff19000000000000000000007fffffb32afffffc020000000000000000000063ffffc53affffe3000000000000000000000048ffffd53effffd900000000000000000000003dffffd930ffffe400000000000000000000004affffca20fffff601000000000000000000005dffffba02f4ffff200000000000000000000086ffff9000c8ffff5300000000000000000000b9ffff620081ffffa00000000000000000000df9fffe1b002cfffff41400000000000000006effffc4000000b7ffff950000000000000014e7ffff4e00000030faffff6700000000000ebfffffc100000000006effffffa93f162262dbffffe91b00000000000072fdffffffffffffffffde26000000000000000036bcfeffffffffed870d0000000000000000000000179fffffc804000000000000000000000000000015f3ffff5300000000000000000000000000000077fffffc7d1200000001000000000000000000008ffffffff8ceb8db8800000000000000000000006de9ffffffffffc60000000000000000000000000b6b9bc1d8bf7b")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 LIGHT NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="20")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="20")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="25")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000002000000000000000000000000000000001196d4fcdfa2180000000000000000000000002be2ffffffffffec1c0000000000000000000001c5fff4622259f2ffa60000000000000000000046ffff6400000083ffed0000000000000000000078ffff0b00000056ffff0f00000000000000000099fff00000000077ffeb000000000000000000007effff0c000004d0ffb10000000000000000000056ffff36000087fffa2d000000000000000000001efdff8d028bffff75000000000000000000000000b6ffe9bdffff7a000000000000000000000000004ffffffff86200000000000000000000000000028bffffff4b0000000000000042bfbf49000007b6ffffffffbc02000000000000a3fffc160003b0ffffb4aaffff7f000000000007f1ffb700006effffc50a0edefffd42000000004dffff5d000cebfff315000036faffec30000000bdfff40d003fffff9a0000000073ffffed300049ffff7f00006bffff6f00000000008fffffed34d2ffe50b00006dffff8b00000000000095fffffaffff6100000046ffffcd010000000000019affffffe40300000007e7ffff750000000000006cffffffffbe200000004affffffa43007043bb9fffff6f1fffff49123000085fefffffffbfcffffffe1321db8ffffff960000003acfffffffffffe7800b0000005cd2ff400000000000174266583602000000000000003e02")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 LIGHT NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="25")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="24")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000053b595c430e0000000000000000000579f2fffffffff9b12b0000000000002ed5fffffffefcfffffffc6a000000000dddffffbc3e0d093684fcffff67000000a2ffff8c0100000000003cedfff5240024ffffd506000000000000006affffa1006cffff7b000000000000000003d6fff8138bffff4e00000000000000000083ffff558dffff4b0000000000000000004bffff8e76ffff710000000000000000001bffffb63cffffca02000000000000000abaffffc703caffff7d01000000000031ceffffffd7002cf9ffffc4643e3459aefcff97faffcd000054e8ffffffffffffffeb620cffffbc0000000e87c4ebfff6ca74100021ffffab000000000000000b000000000051ffff800000000000000000000000000089ffff4800000000000000000000000001defffa100000000000000000000000004effffa60000000000000000000000000ee1ffff39000009a23700000000000013c8ffff9b000002b0fffd9853200d2e7bedffffd10c0000026ff3ffffffffffffffffffc11000000000001eacf9ffffffffffd75f0100000000000000000d445e68532400000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 MONO NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
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
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 MONO NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="24")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="24")
  inspect(f.glyph().bitmap().buffer().length(), content="96")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 MONO NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="16")
  inspect(f.glyph().bitmap().rows(), content="18")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="3")
  inspect(f.glyph().bitmap_top(), content="18")
  inspect(f.glyph().bitmap().buffer().length(), content="36")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 MONO NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="24")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="24")
  inspect(f.glyph().bitmap().buffer().length(), content="96")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 MONO NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="3")
  inspect(f.glyph().bitmap_top(), content="18")
  inspect(f.glyph().bitmap().buffer().length(), content="104")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 MONO NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="18")
  inspect(f.glyph().bitmap().rows(), content="30")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="24")
  inspect(f.glyph().bitmap().buffer().length(), content="120")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 MONO NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="24")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="24")
  inspect(f.glyph().bitmap().buffer().length(), content="96")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 MONO NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="23")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="23")
  inspect(f.glyph().bitmap().buffer().length(), content="92")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 LCD NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
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
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 LCD NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="63")
  inspect(f.glyph().bitmap().rows(), content="24")
  inspect(f.glyph().bitmap().pitch(), content="64")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="24")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000000000000033267979b9b9b9b9b9b9b8e5b2800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044397ebffffffffffffffffffdb872f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003469aeafffffffff6f6f7ffffffffdd853100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004449cecffffffffd18273a2f1ffffffffdc87330000000000000000000000000000000000000000000000000000000000000000000000000000000000000005469aedffffffffde86320957abf6ffffffffde8a32000000000000000000000000000000000000000000000000000000000000000000000000000000000004489cecffffffffe6933b01001060b4fbffffffffe0883400000000000000000000000000000000000000000000000000000000000000000000000000000005469eedffffffffed9c48030000001769c1feffffffffde8b370000000000000000000000000000000000000000000000000000000000000000000000000006499deffffffffff5a5510800000000001e76caffffffffffe18d350000000000000000000000000000000000000000000000000000000000000000000000054b9feefffffffff9b25a0d000000000000002b7fd3ffffffffffe38b370100000000000000000000000000000000000000000000000000000000000000000649a1effffffffffcbb67120000000000000000003488e0ffffffffffe18e3a01000000000000000000000000000000000000000000000000000000000000074b9ff0ffffffffffc4701d00000000000000000000013d95e7ffffffffffe390380100000000000000000000000000000000000000000000000000000000064ea2efffffffffffcd752200000000000000000000000003469aebffffffffffe58f3b020000000000000000000000000000000000000000000000000000074ca4f1ffffffffffd17d260000000000000000000000000000054a9ef0ffffffffffe4913d01000000000000000000000000000000000000000000000000084ea2f2ffffffffffd6822e00000000000000000000000000000000074fa7f3ffffffffffe6933b02000000000000000000000000000000000000000000000750a4f1fffffffffffcdab99c9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9ba5c7e8ffffffffffffe7923e020000000000000000000000000000000000000000084fa7f2ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe69440020000000000000000000000000000000000000951a5f3fffffffffff4e3d2cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbd8eafbffffffffffe8973f03000000000000000000000000000000000853a7f2ffffffffffeb96420300000000000000000000000000000000000000000000001368bcfcffffffffffea95410300000000000000000000000000000951a9f4ffffffffffee9e4604000000000000000000000000000000000000000000000000001a6dc1feffffffffffe99743030000000000000000000000000a54a8f5fffffffffff0a14d050000000000000000000000000000000000000000000000000000001e71c9ffffffffffffea9a4203000000000000000000000a56aaf4fffffffffff4a551090000000000000000000000000000000000000000000000000000000000227aceffffffffffffec98440400000000000000000b54acf5fffffffffff6ac540a000000000000000000000000000000000000000000000000000000000000002a7ed2ffffffffffffeb9b47040000000000000c56aaf6fffffffffff8b05c0c0000000000000000000000000000000000000000000000000000000000000000002f83dbffffffffffffed9d4504000000000b58acf5fffffffffffbb35f100000000000000000000000000000000000000000000000000000000000000000000000338bdfffffffffffffee9c480500")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 LCD NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="51")
  inspect(f.glyph().bitmap().rows(), content="19")
  inspect(f.glyph().bitmap().pitch(), content="52")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="18")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000010b1e374e667e96aab8c0c9d2dae3e5e3dcd5cfc2b09982643c1703000000000000000000000000000000000000061c40698eb4d7f0fefffffffffffffffffffffffffffffffffffffffffffffeecc9955c2b0d00000000000000000000001e57a5dbf5fffffffffffffffffff9ead4beaea39a908c909caab8c6d8ebfafffffffffffffffff3ba621a00000000000000000002287bcdfbfffffae5c2986b44230d02000000000000000000000000000d2d5e9bd0f2ffffffffffffe8a24e0e00000000000000000008345968442008000000000000000000000000000000000000000000000000226ec6f8fffffffffffec9711e000000000000000000000000000000000000000000000000000000000000000000000000000000000453a7f6fffffffffff49c4800000000000000000000000000000000000000000000000000000000000000000000000000000001043083d3ffffffffffffc16d1900000000000000000000000000000000000000000511253b4f606e7c8b99a7b6c2ccd6dee7f1f8fdffffffffffffffffffde8a360000000000000000000000010c2445688dadc9e2f3fdfffffffffffffffffffffffffffffffdf8f0eaeff7ffffffffffffdf8b37000000000000000823518cc3e9fdfffffffffffffff9ebd6c0aa958170615345372a1d140b0400001367bbffffffffffffdf8b3700000000021e5aafe6fefffffffffff3d5a7794f2e130400000000000000000000000000000000001367bbffffffffffffdf8b370000000a50a4edfffffffffff4c2772f0800000000000000000000000000000000000000000000001367bbffffffffffffdf8b3700000049a1f4ffffffffffea994103000000000000000000000000000000000000000000000000001367bbffffffffffffdf8b370000095cb4ffffffffffffde8a3200000000000000000000000000000000000000000000000001134497d9ffffffffffffdf8b370000002d85d9ffffffffffffd3832f07000000000000000000000000000000000000081f477eb7e3fbffffffffffffffffdf8b37000000023f92e4fffffffffffffee7be895f3e231107020000030914253c577696bce1f8fffffffdead5d8ebffffffffffdf8b3700000000000a3686cff7fffffffffffffffffffffffefaf7f7fbfffffffffffffffffdeccb986534110a5cb4ffffffffffdf8b3700000000000000021434648fbbe1f8fffffffffffffffffffffffffffbedd5b7936836130200000000004199edffffffffdf8b3700000000000000000000000000061222313d4a566267655c52473b2813050000000000000000000000000000000000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 LCD NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="54")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="56")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="25")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000000000000020404020000000000000000000000000000000000000000000000000000000000000000000000000000000004173964879eacb9c6d3e0edf8fefffbf4ebe2d8c8b3977e6447280f010000000000000000000000000000000000000000000004204b82afd8f4fffffffffffffffffffffffffffffffffffffffffffffffffdedcc9f713c17020000000000000000000000000000000f4195d9fbfffffffffffffffff5e3cfc0b5aa9f9b9ca3abb3c0d3e9f8fffffffffffffffffffbe2b3692e0a000000000000000000001b5fb3ebfffffffffffff7d09a5d321403000000000000000000000000010b214675addaf5ffffffffe9b25c1e020000000000000000002c80d8fffffffffffff2b8611b0100000000000000000000000000000000000000000000082250859a793c0d00000000000000000000000f63b7fffffffffffffdb6620d000000000000000000000000000000000000000000000000000000000000000000000000000000000000001367bbfffffffffffffcb6620e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000003589e1fffffffffffff3b8621a0100000000000000000000000000000000000000000000000000000000000000000000000000000000000007459deafffffffffffffff8d59f5f31130200000000000000000000000000000000000000000000000000000000000000000000000000000000134ea1e5fffffffffffffffffffff2d7b0865a3214030000000000000000000000000000000000000000000000000000000000000000000000000c326baddff9fffffffffffffffffffffffff5debc97704b280e0100000000000000000000000000000000000000000000000000000000000000000010346597c0e3f8fffffffffffffffffffffffffffef2dab68e673d1a060000000000000000000000000000000000000000000000000000000000000000051a3a6087acd1edfcfffffffffffffffffffffffffff8e3c08c542306000000000000000000000000000000000000000000000000000000000000000000000a2041678cb1d7f0feffffffffffffffffffffffefc88a451500000000000000000000000000000000000000000000000000000000000000000000000000010d264b739fcfeffeffffffffffffffffeca9551500000000000000000000000000000000000000000000000000000000000000000000000000000000000317428ecef7ffffffffffffffe5913900000000000000000000000000000000000000000000000000000000000000000000000000000000000000022173c9feffffffffffffc8701c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000002d85d9fffffffffffff39b4700000000000000000405050000000000000000000000000000000000000000000000000000000000000000002a82d6ffffffffffffe8903c0000000000011d58a9dcd6a0582406000000000000000000000000000000000000000000000000000000022174cafefffffffffff8b35b0f0000000d3c89d3f8fffffffffff1d4a677481f080000000000000000000000000000000000000005184692d3f8ffffffffffffe9a14d0c00000000031c4b92cdf2fffffffffffffffffffbeed8ba9f856f60564d443c3b4049555f6a7c97bbe0f7fffffffffffffffde4a85218000000000000000000000a295b90bfe5f9fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdebcb9b5b270600000000000000000000000000000000000922497293aec9e2f4fefffffffffffffffffffffffffffffffffef4dcb787592d0e01000000000000000000000000000000000000000000000000000000000008182b39424a535b64696a66605a53483825120500000000000000000000000000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 LCD NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="57")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="60")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="18")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000821486d8797a5b3c1cfdde0dccdc0b2a4968b83807f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7b4f250000000000000000000000000006224e86b7dff8fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff79f4b00000000000000000000000d3f94dafcfffffffffffeedcba17f6c5b4c484e5e6e83a6d0f0fffffffffffffffbf5eeebebebebebebebebebebe493460000000000000000001453a7e6fffffffffffdd7974917030000000000000000000000051b52a0defefffffff9ce7a2d04000000000000000000000000000000000000001c6fc7feffffffffffdd91390800000000000000000000000000000000000c459de5fffffffff9c26e1d00000000000000000000000000000000000251a5fbffffffffffec984400000000000000000000000000000000000000000351a5f6fffffffffcb45c0c000000000000000000000000000000000c60b4ffffffffffffd07c280000000000000000000000000000000000000000003589ddffffffffffe28a3600000000000000000000000000000000004498f0fffffffffff7a65203000000000000000000000000000000000000000a5fb3fdffffffffffce76220000000000000000000000000000000000094da5f0fffffffffff1ba631d0000000000000000000000000000000002246fc4f5ffffffffffde8a3200000000000000000000000000000000000000022363b5ecfffffffffff1c98e4c21070000000000000000000a255296cff5ffffffffffe5a24f1500000000000000000000000000000000000000000000000d3f8ed4fbfffffffffffff5e2c8b5a5979399a8b7cce5f7fffffffffffff8d1883c0a000000000000000000000000000000000000000000000000052564b1e5fefffff4ededf8fffffffffffffffffffffffffffef0d2a776482008000000000000000000000000000000000000000000000000001957aae5feffffeebe752f0b010c20384b58626a6b65584b3e302315090200000000000000000000000000000000000000000000000000000000002b80d8ffffffffed99450300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000499df5fffffffff8b25f12000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001764bcf8fffffffffff6d8ae866a52433a332d2a2827272727272727272727241e17110a050100000000000000000000000000000000000000000000000422579fd9f8fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffcf7ecdabfa2856745230900000000000000000000000000000317408bcbf6ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffecb96d2c070000000000000000062867b6e8fdfffff4cf995d2b110c151e27303941464747474747474747484a4d52575c67778da9cdebfefffffffffffffebb63100000000000043389d8fdffffffe4a24e11000000000000000000000000000000000000000000000000000000000000052981cffffffffffffff19b470100000001479bf2ffffffffe18935000000000000000000000000000000000000000000000000000000000000000000024da1f2fffffffffff59e4a01000000095db1fffffffffff4a24e07000000000000000000000000000000000000000000000000000000000000000c49a1e9fffffffffff6b55d1300000000002d81d9fffffffffff5cf9347190200000000000000000000000000000000000000000000000008205094cff3fffffffffff8ce803305000000000000001758abe8fffffffffffffcedd4b4987c624f433b342d26201d2028313a434c55637997b6d6effcfffffffffffff6d49c541d0200000000000000000000000a2a639fcfeffcfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7e0ba8a5a2c0c0000000000000000000000000000000000000000081a36577695b0c1cbd3dbe3ecf4fafefffffcf5ebe0d6ccc1b7ada2948166492b120400000000000000000000000000000000000000000000000000000000000000000000000000000001050908030000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 LCD NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="60")
  inspect(f.glyph().bitmap().rows(), content="31")
  inspect(f.glyph().bitmap().pitch(), content="60")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="25")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000000000000000001040503000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000031635597695b3cbdce6eff9fdfffdf7eee4d9c6ac8e70502d110100000000000000000000000000000000000000000000000000000000000b2b5d98cbeefefffffffffffffffffffffffffffffffffffffffffffce8c08b51210600000000000000000000000000000000000000000000082d6fbdedfffffffffffffffffff6e1c9b5a99f9ca1abb8cee6f8fffffffffffffffffee4ae60220400000000000000000000000000000000000d469de3fefffffffffffff5d6a16230110200000000000000000004153a6eacdff9fffffffffffffdd789380600000000000000000000000000083d90dcfefffffffffffdde9c4812000000000000000000000000000000000000001b58aae8fffffffffffffbd07c2c0300000000000000000000125eb6f8ffffffffffffe597430900000000000000000000000000000000000000000000000e54a8edffffffffffffeea24e0800000000000000001b6cc0fcfffffffffffdc6721c0000000000000000000000000000000000000000000000000000012c80d7fffffffffffff6b1590f0000000000000c62b6fdffffffffffffc36f1d00000000000000000000000000000000000000000000000000000000002a82d6fffffffffffff7a34f0400000000003f97eaffffffffffffe1893500000000000000000000000000000000000000000000000000000000000000469aeeffffffffffffd8843000000000186cc4ffffffffffffffc56d19000000000000000000000000000000000000000000000000000000000000002b7fd3fffffffffffffeb35f080000002a7ed6fffffffffffffcaa5202000000000000000000000000000000000000000000000000000000000000000f63b7ffffffffffffffc571190000003a8ee6ffffffffffffe38f37000000000000000000000000000000000000000000000000000000000000000000489cf4ffffffffffffd581290000003e92eaffffffffffffd9852d0000000000000000000000000000000000000000000000000000000000000000003d91e9ffffffffffffd9852d0000003084dcffffffffffffe490380000000000000000000000000000000000000000000000000000000000000000004a9ef6ffffffffffffca761e0000002074ccfffffffffffff6a44c01000000000000000000000000000000000000000000000000000000000000000a5db1ffffffffffffffba660e000000024ba3f4ffffffffffffcc7420000000000000000000000000000000000000000000000000000000000000003286daffffffffffffe4903c00000000001b74c8fffffffffffff7a7530900000000000000000000000000000000000000000000000000000000001165b9fcfffffffffffeb662100000000000002d81d5ffffffffffffefa04c040000000000000000000000000000000000000000000000000000000d5ab2f9fffffffffffec56d1b00000000000000002c7fd7fffffffffffff4b45c14000000000000000000000000000000000000000000000000001f6ec2fafffffffffffdc4701b000000000000000000001763b7f4ffffffffffffdc95420c000000000000000000000000000000000000000000144fa7e7ffffffffffffeda24e0d00000000000000000000000004307fd3faffffffffffffe8b1672a090000000000000000000000000000000e3279bfeffffffffffffff3c16e220000000000000000000000000000000003276ebef2fffffffffffffff3d3a9805b3f2c1f161418222f456286b3dbf7ffffffffffffffe9b0591b0000000000000000000000000000000000000000000d3572b6e7fdfffffffffffffffffffffffffffffffffffffffffffffffffffadeaa5f260700000000000000000000000000000000000000000000000000000315366392bcdff5fefffffffffffffffffffffffffffbedd5b18757290d0000000000000000000000000000000000000000000000000000000000000000000000000008172d5b9fdcfffffffffffffac87825040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000155cb4f3ffffffffffffe5a453190200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000022d77c8f5fffffffffffffce3b37d502c1203000000000000000000010100000000000000000000000000000000000000000000000000000000000000000012438fd0f7fffffffffffffffffff8ebdbcec5bdb8bdcadbecd688340000000000000000000000000000000000000000000000000000000000000000000000143a6d9bc8e9fbffffffffffffffffffffffffffffffffc6721a0000000000000000000000000000000000000000000000000000000000000000000000000000000b244a6b808e9ba7b4c1cdd6d8d2c9bfaf997b481c0000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 LCD NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="63")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="64")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="25")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000000020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111366c96b1c3d4e6f5fcf9eedfd1bfa2773f180300000000000000000000000000000000000000000000000000000000000000000000000000000000042b67b5e2fafffffffffffffffffffffffffffffffeecb55e1c000000000000000000000000000000000000000000000000000000000000000000000000012272c5f7fffffffff4d09562402b222637598dcbf2ffffffffeba6520e00000000000000000000000000000000000000000000000000000000000000000002469af0fffffffff7b864190000000000000000002f83d7ffffffffed99410000000000000000000000000000000000000000000000000000000000000000002478ccffffffffffb65e0b000000000000000000000356aafeffffffffbb630f00000000000000000000000000000000000000000000000000000000000000004599edfffffffff09c4400000000000000000000002377cbffffffffeb973f0000000000000000000000000000000000000000000000000000000000000000002a7ed2ffffffffffb75f0c0000000000000000042d81d0fbfffffff8b15d0c0000000000000000000000000000000000000000000000000000000000000000000656aafcffffffffe28a360000000000000e3a87cdf9fffffffacf7b2d0400000000000000000000000000000000000000000000000000000000000000000000001e70c8fdffffffffe08d39010217468bcaf3fffffffff2c4752f0400000000000000000000000000000000000000000000000000000000000000000000000000001262b6f7ffffffffe9bfa9bde7fdffffffffefc17a370c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000a4fa3f0fffffffffffffffffff8daa4622b09000000000000000000000000000000000000000000000000000000000000000000000000000000000000000219488bc9f1ffffffffffffffe7a04b0f000000000000000000000000000000000000000000074281bbbfbfbfbfbd88490c0000000000000000000000072c6cb6e5fdfffffffffffffffffffffff0bc6a2202000000000000000000000000000000000000064fa3f0fffffffffcbe6616000000000000000000032161b0e6feffffffffffe9b47876aae7fffffffffff8cc7f3207000000000000000000000000000000074ca4f1fffffffffab76312000000000000000000216ec1f9fffffffffff2c57b310a00000e4398defdfffffffffddd93420f000000000000000000000000074da1f1fffffffff9b15d1000000000000000000c4ca4ebfffffffffff3b45c1500000000000000093684d3faffffffffffecbe71300a00000000000000001b69bdf6fffffffff4ad550d0000000000000000003f93ebffffffffffeb9a460300000000000000000000032a73c3f5ffffffffffffedbe71300a0000000c499de9fffffffffdd17f2e02000000000000000000176bbfffffffffffffc36f1b000000000000000000000000000012448fd1f7ffffffffffffedbf72343781d2fdffffffffe59c450b0000000000000000000000196dc1ffffffffffffdf8b370000000000000000000000000000000000154995d4f9fffffffffffffafafafffffffff4b561190000000000000000000000000003469aefffffffffffffcd7a2301000000000000000000000000000000000001174d9ad8faffffffffffffffffffe4933b0300000000000000000000000000000007429ae7fffffffffffff6c4752b050000000000000000000000000000000010356cb1e3fffffffffffffffffffffce6be874c200700000000000000000000000000114a9de4fffffffffffffff3d3a4734a302011070100040e213b5b87b9e3fbfffffffffffff6e8e7f1fffffffffffffffff4ddb7916d46230c0000000000000000000d4085caeffefffffffffffffffffffffffbf9f9fcfffffffffffffffffffffae1b16d320d051d4780b8e2faffffffffffffffffe8964202000000000000000000000002163a6ca1cfeffdfffffffffffffffffffffffffffff7e7cda98051250b0000000000000000000e2f5c87aed2edfcffe9944003000000000000000000000000000000000000020a17253442505e66676058504536200c02000000000000000000000000000000000000000000091f3e3821020000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 LCD NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="54")
  inspect(f.glyph().bitmap().rows(), content="25")
  inspect(f.glyph().bitmap().pitch(), content="56")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="24")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000512283b49515960615c544b4335210e02000000000000000000000000000000000000000000000000000000000000000000051c4679acd7f2fdfffffffffffffffffffffffffff9ebd2b189572b0e0000000000000000000000000000000000000000000000092e64a6d5f2fffffffffffffffffffffefafafcfffffffffffffffffffffffce5b16a2d0800000000000000000000000000000000000d4197ddfdfffffffffffbe5bc875b3e2d1c0d040209152636465e84b7e5fcffffffffffffeeb8672401000000000000000000000000114ea2e3fffffffffffbd18c3d100100000000000000000000000000000001153c7cc0edfffffffffff5c46e24020000000000000000002478d0fffffffffffcd5883306000000000000000000000000000000000000000000001e6abdf7ffffffffffeca14d0800000000000000196cc0ffffffffffffcf7b2700000000000000000000000000000000000000000000000000032f86d6fefffffffff8b86013000000000000378bdffffffffffff7a24e030000000000000000000000000000000000000000000000000000002f83d7fffffffffff9a955080000000000398de1fffffffffff59f4b01000000000000000000000000000000000000000000000000000000034b9ff4ffffffffffe28e3a00000000002276caffffffffffffc5711d000000000000000000000000000000000000000000000000000000001b6fc7ffffffffffffb6620a00000000003c90e7fffffffffff9ca78260200000000000000000000000000000000000000000000000a2e71bae9ffffffffffffffc7731b0000000000032979caf8fffffffffff5c17d351001000000000000000000000000000000011031629bceefffffffffffffffffffffd7832b00000000000000042c79cdf9fffffffffffffce9c4997764584a3e3330343d4959718faed0ecfcfffffff5d1979dc0faffffffffffcd792100000000000000000004245490c4e8fbfffffffffffffffffffffffffffffffffffffffffffdebc998622f0c0c5fb7ffffffffffffbc681000000000000000000000000000000e2d5c87a5b8c4d1dfebf6fdfffffdf6eddfcaaf9174532c1001000000002175cdfffffffffffdab570200000000000000000000000000000000000000000000000001070b0a0400000000000000000000000000000551a5f7ffffffffffd4802c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000003589ddfffffffffff29c480200000000000000000000000000000000000000000000000000000000000000000000000000000000000001348cdefffffffffffab65e100000000000000000000000000000000000000000000000000000000000000000000000000000000000000e4ea2ebffffffffffefa6520a00000000000000000000000000000000000000000000000000000000000000000000000000000000000e449be1ffffffffffffe18d3903000000000000000000000000093277a29e6b371301000000000000000000000000000000000002133e85c8f1ffffffffffffe19b480e000000000000000000000002205fb0e7fffffffffde9c398786453423120120b0d141e2e435d7ba0cdedfdfffffffffffff5d18a3d0c0000000000000000000000000002153b6fa4d5f3fffffffffffffffffffffffffffffffffffffffffffffffffffffffeebc17f3a10000000000000000000000000000000000000000000061e477eacd0eaf9fffffffffffffffffffffffffffffffbedd7b78d5f321101000000000000000000000000000000000000000000000000000000000000020d1f35444e565e666a68625a53493924100300000000000000000000000000000000000000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 LCD_V NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
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
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 LCD_V NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="20")
  inspect(f.glyph().bitmap().rows(), content="75")
  inspect(f.glyph().bitmap().pitch(), content="20")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="24")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000004347472600000000000000000000000000000003979b9b5b00000000000000000000000000000010ebefef9a00000000000000000000000000000027ffffffbe00000000000000000000000000000043ffffffdb00000000000000000000000000000060fffffff00700000000000000000000000000007dfffffffd1800000000000000000000000000009afff6ffff310000000000000000000000000000b6ffd9ffff4d0000000000000000000000000000d3ffacfcff6b0000000000000000000000000004ecff82f1ff870000000000000000000000000011faff64ddffa4000000000000000000000000002affff4ac3ffc10000000000000000000000000046ffff32abffde0000000000000000000000000062ffff1a92fff20800000000000000000000000080fff60978fffd1a0000000000000000000000009cffe60160ffff34000000000000000000000000b9ffce0047ffff51000000000000000000000000d6ffb4002dffff6e000000000000000000000005edff9c0017feff8b000000000000000000000013fbff830007f4ffa700000000000000000000002cffff690000e2ffc5000000000000000000000049ffff510000caffe1000000000000000000000065ffff380000b1fff4090000000000000000000083ffff1f000098fffe1d000000000000000000009ffff90d00007fffff3700000000000000000000bbffeb02000066ffff5400000000000000000000d9ffd40000004dffff7100000000000000000006efffbb00000034ffff8e00000000000000000015fcffa20000001cffffaa0000000000000000002fffff890000000af7ffc80000000000000000004bffff7000000001e7ffe301000000000000000068ffff5700000000cffff50b000000000000000085ffff3c00000000b4ffff1f0000000000000000a2ffff22000000009affff3b0000000000000000befff90e0000000080ffff570000000000000000dbffea020000000065ffff750000000000000007f1ffd100000000004affff910000000000000017fdffb7000000000030ffffad0000000000000032ffff9c000000000017fdffcb000000000000004effff82000000000007f3ffe6020000000000006affff67000000000000e0fff70d00000000000088ffff87474747474747deffff22000000000000a4ffffb99b9b9b9b9b9be8ffff3e000000000000c1fffff3efefefefefeffbffff5a000000000000deffffffffffffffffffffffff78000000000008f2ffffffffffffffffffffffff94000000000019fdffffffffffffffffffffffffb1000000000035ffffffffffffffffffffffffffce000000000051ffffe3cbcbcbcbcbcbcbcbfbffe803000000006dffffae7777777777777777eefff80f000000008bffff6d1f1f1f1f1f1f1f1fd7ffff2500000000a7ffff420000000000000000bcffff4100000000c3ffff280000000000000000a2ffff5d00000000e0fffb11000000000000000087ffff7b00000009f4ffee0400000000000000006dffff970000001cfeffd800000000000000000052ffffb400000037ffffbc00000000000000000037ffffd200000054ffffa10000000000000000001effffea03000070ffff870000000000000000000bf7fffa1100008dffff6b00000000000000000001e6ffff290000aaffff5100000000000000000000ceffff440000c6ffff3600000000000000000000b4ffff610001e2ffff1c0000000000000000000098ffff7e000bf5fff60a000000000000000000007effff9b001dfeffe5010000000000000000000064ffffb7003affffca000000000000000000000049ffffd50056ffffb000000000000000000000002fffffed0473ffff95000000000000000000000017fdfffb1390ffff79000000000000000000000007f2ffff2bacffff5f000000000000000000000000dfffff487dabab370000000000000000000000008dabab3a425353160000000000000000000000004053532100000000000000000000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 LCD_V NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="60")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="19")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000000000000000000000000000000000000000000000c2639290a00000000000000000000002a647e91815c18000000000000000001377eb8d2e5d5b06403000000000000002d8bd2fffffffff9b8280000000000001b84e3fffffffffffff87804000000000669d7ffffffffffffffffc92b0000000037bdfffffffffffffffffff8740000000e8dfafffffffce4efffffffffc70500001edbffffffeaae909cc6fafffff31a00001ffcffffe8995a3c4872ceffffff3f000012edfff998410500001a7af9ffff71000002cdffc24402000000002dd0ffffa20000009fe76e0800000000000495ffffd003000068981d000000000000004dfffff00f00003444000000000000000022f8fffe1e00001009000000000000000009e2ffff2e00000000000000000000000000c2ffff3b00000000000000000000000000a7ffff480000000000000000000000000097ffff540000000000000000000000000088ffff610000000000000000000000000183ffff6d0000000000000000000016324daaffff7b00000000000000001a456e8aa5d8ffff85000000000000053b6e99c2def8ffffff8a00000000000c4b8fc2edffffffffffff8b000000000759a3e7ffffffffffffffff8b0000000145adf3fffffffffff8efffff8b0000002399f4ffffffffe3c0a5bdffff8b00000270ebffffffe8b58b684d89ffff8b000023c3ffffffd6956137140067ffff8b000060f5ffffd982410e00000067ffff8b0004b3ffffea822a000000000067ffff8b001ee6ffffa72e00000000000067ffff8b0048fdffeb530000000000000067ffff8b007cffffba110000000000000067ffff8b00a4ffff77000000000000000067ffff8b00c7ffff3a000000000000000067ffff8b00e3fff613000000000000000067ffff8b00f4ffea03000000000000000067ffff8b03fbffdb00000000000000000067ffff8b09ffffd60000000000000000006fffff8b09ffffde00000000000000000197ffff8b06f8ffee02000000000000001ec9ffff8b00ebfffa0d0000000000000064f6ffff8b00d9ffff2f0000000000001fb7ffffff8b00c7ffff6a0000000000056beeffffff8b00b2ffffb6130000000242c3fffeffff8b0092ffffe75f1100093c96f8ffd5ffff8b0062fffffeb3654b5c90e5fff48affff8b002bf2fffff8bda3b4e6ffffb936ffff8b000acffffffffff7ffffffec650affff8b00008fffffffffffffffffac1c03fcff8b000044deffffffffffffe3540000f6ff8b0000148ff8ffffffffed93130000edff8b0000003bb6e9ffffe79e3f0000009cab5e000000055e91b6b08f46040000004a532d00000000123d625c3b05000000000000000000000000000e09000000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 LCD_V NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="18")
  inspect(f.glyph().bitmap().rows(), content="78")
  inspect(f.glyph().bitmap().pitch(), content="18")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="25")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000000000000000000000000040000000000000000000000000000001a41573f1d0000000000000000000000064a7299af97742a00000000000000000000399ec6edffebc87e280000000000000000138cf2ffffffffffd2790b000000000000025bdeffffffffffffffd04b00000000000020affffffffffffffffffd9f17000000000056f0ffffffffffffffffffe84f0000000000a3fffffffffaf0ffffffffffa5090000000fd9ffffffcfaa9cb3e9ffffffe22e00000035f7ffffdb7b56485f97e6fffffe4800000074fffff586230300083f9afdfffe44000000b3ffffd032000000000146daffe91e000004e1ffff950300000000000b8efdbe04000014fafffd4b0000000000000039d47a0000002cfffff21b0000000000000008853c00000045ffffe0030000000000000000341300000058ffffc9000000000000000000050000000063ffffb600000000000000000000000000006cffffa900000000000000000000000000006effffa8000000000000000000000000000067ffffb6000000000000000000000000000058ffffcb000000000000000000000000000046ffffe2020000000000000000000000000035fffff31a0000000000000000000000000024fffffd4c0000000000000000000000000013fdffff990300000000000000000000000007eaffffd53100000000000000000000000001c3fffff7831200000000000000000000000088ffffffd85c0300000000000000000000004effffffffb032000000000000000000000020f0fffffff285170000000000000000000005bcffffffffda680a000000000000000000006bf9ffffffffbc4b0100000000000000000027d2fffffffff89f300000000000000000000381f9ffffffffed871a00000000000000000034c0ffffffffffda67060000000000000000086ce1ffffffffffbb3e0000000000000000001b8ef2fffffffff896180000000000000000003aacfcffffffffe3540000000000000000000458c8ffffffffffa70b0000000000000000000e70deffffffffe73d00000000000000000000208cf0ffffffff8a000000000000000000000038aafcffffffd209000000000000000000000252c6fffffff82700000000000000000000000d73efffffff5500000000000000000000000022b3ffffff8b000000000000000000000000005af2ffffc00000000000000000000000000017ceffffe5000000000000000000000000000095fffff9050000000000000000000000000051ffffff0f0000000000000000000000000021feffff1c0000000000000000000000000006f7ffff2b0000000000000000000000000000eaffff3b0000000000000000000000000000d9ffff470000000000000000000000000000ccffff4a0000000000000000000000000000cbffff460000050000000000000000000000d6ffff3c0005340000000000000000000000e9ffff320023870300000000000000000007f7ffff200058d62400000000000000000021fefff80f009ffa6901000000000000000053ffffe80313d9ffbd28000000000000000099ffffc9003cf8fff1770800000000000018d3ffffa10056ffffffca4a05000000000563f5ffff710045f6fffffba24b0d00000c43bafffffd3c001ccdffffffee9f6044405f97f7ffffe418000183ffffffffeeb49894b3e5ffffffb103000034defffffffffff0ecfffffffffb620000000a90f9ffffffffffffffffffffcb27000000003dc7fffffffffffffffffff0780600000000066fe5ffffffffffffffffad250000000000002293e2ffffffffffffdc5901000000000000003f8fd7f6fffffdd18914000000000000000001377f9eb8baa7793100000000000000000000002b4a64665325000000000000000000000000000010120200000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 LCD_V NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="84")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="19")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000015341400000000000000000000000000000c436d8c6c422c2b2b2b2b2b2b0d00000000004897c1e0c096807f7f7f7f7f7f2500000000189cebffffffebd4d3d3d3d3d3d33e0000000262e8ffffffffffffffffffffffff4b00000022b7ffffffffffffffffffffffffff4b00000059f2fffffff4ffffffffffffffffff4b000000a6fffff9c09cc2faffffffffffffff4b00000ddaffffcb6c486ed0fffffbebebebeb46000030f7fff87a18001a81fafff5989797972d00006affffd0290000002ed6fff54d3f3f3f120000a7ffff970300000005a0fff92d000000000000d7ffff5300000000005effff5e00000000000af4fff42300000000002af8ff9800000000001cfeffdd0800000000000ce5ffc2000000000033ffffc000000000000000cdffe1000000000046ffffa800000000000000b5fff3030000000051ffff9800000000000000a5fffc0c000000005affff880000000000000095ffff1c0000000060ffff7d0000000000000089ffff2d0000000060ffff7c0000000000000089ffff360000000059ffff870000000000000093ffff34000000004fffff9600000000000000a3ffff2b0000000044ffffa600000000000000b3ffff220000000032ffffbb00000000000000c8fffe14000000001bfdffd905000000000009e2fff2080000000009f0fff11d000000000024f5ffde000000000000d4ffff47000000000052ffffbb000000000000a1ffff8c010000000296ffff8a00000000000063ffffc92100000025cfffff4f0000000000002bf1fff26a0b000d71f4ffee2000000000000009caffffc1613f63c7ffffc605000000000000008efffff5b593b7f7ffff88000000000000000068fffffffde7feffffe745000000000000000077fffffffffffffffc9c150000000000000005b1ffedffffffffffd248000000000000000025e5ffa5cbfefff5cf800c000000000000000063feea4d73acbf9f772b000000000000000000aaffbe0b20586b4b2302000000000000000005deff8900000617010000000000000000000016f8ff5d0000000000000000000000000000002bffff4500000000000000000000000000000040ffff3a00000000000000000000000000000049ffff4100000000000000000000000000000049ffff5f0000000000000000000000000000003fffff950000000000000000000000000000002cffffcf32000000000000000000000000000017f8fff686432d27272727170500000000000007dfffffda97817b7b7b7b6b5740070000000000a2ffffffefd9d3d3d3d3c3af984e070000000057f8ffffffffffffffffffffeca245000000001dd5fffffffffffffffffffffff0990800000001c3ffffffffffffffffffffffffea2e00000017cbffffffffffffffffffffffffff6d00000055eefebdcae5f3f3f3f6ffffffffffb6000007acffdd65728d9b9b9b9eabcbfdffffe9050028e8ff99111e394747474a5777cdfffffe100060fef5470000000000000004237ffdffff2100a6ffd31000000000000000000029e9ffff3404d8ffa20000000000000000000005cfffff4716f4ff6f0000000000000000000000b0ffff522fffff4c0000000000000000000000a0ffff5347ffff350000000000000000000000a1ffff4a56ffff300000000000000000000000b2ffff3d5effff3a0000000000000000000000d0ffff275dffff4e000000000000000000000ce9fff61355ffff6b0000000000000000000038f9ffe00345ffff9e0100000000000000000187ffffb6002dffffcf19000000000000000020cfffff800015f8fff65a030000000000001271f7fffc440004dcffffb14404000000001062c8ffffdd170000abffffed984f3420284363b6fcffff9c0200006affffffe9a388747c97b7f8fffff04b0000002de3fffffff7e0ccd4efffffffffae130000000a9ffcffffffffffffffffffffe05a00000000004bc3ffffffffffffffffffee911600000000000f6bcaffffffffffffffe89d39000000000000001a76c1dbf4fff5d6b79449040000000000000000236d87a0b5a18263400600000000000000000000152f485d492a0b000000000000000000000000000000090000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 LCD_V NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="96")
  inspect(f.glyph().bitmap().pitch(), content="19")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="25")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000f3a564b2d010000000000000000000000000e5f92aea3853a01000000000000000000000359b3e6fdf7d98e2d000000000000000000002aadf8ffffffffe17e070000000000000000047af6ffffffffffffd53a00000000000000002bcbfffffffffffffffc8b06000000000000006cf9ffffffffffffffffd82500000000000009bffffffffff3fbfffffffd630000000000002dedffffffc99fabe6ffffffae0400000000006affffffd7754b5797f4ffffe21f0000000000b3fffffb841d00043fbffffffd4f000000000de3ffffd630000000046ef9ffff89000000002bfaffff93040000000026d9ffffbe000000005cfffff9410000000000039fffffe60e00000090ffffde1200000000000058fffffb2c000000bfffffaf0100000000000024f1ffff56000003e4ffff740000000000000006d3ffff80000012f8ffff430000000000000000a8ffffa200002afffff91e00000000000000007dffffc200004cffffe407000000000000000051ffffe202006cffffc60000000000000000002cfffff60f0089ffffa600000000000000000011fbffff2300a3ffff8a00000000000000000004ecffff3c00b6ffff6f00000000000000000000d6ffff4f00c7ffff5700000000000000000000bcffff6100daffff4300000000000000000000a8ffff7300eaffff35000000000000000000009affff8404f7ffff2c0000000000000000000091ffff960efeffff220000000000000000000088ffffa718ffffff19000000000000000000007fffffb320ffffff100000000000000000000076ffffbb25ffffff08000000000000000000006cffffc02afffffc020000000000000000000063ffffc530fffff500000000000000000000005affffca35ffffec000000000000000000000051ffffd03affffe3000000000000000000000048ffffd53fffffdb000000000000000000000040ffffda40ffffd800000000000000000000003cffffdb3effffd900000000000000000000003dffffd939ffffdc000000000000000000000041ffffd434ffffe0000000000000000000000046ffffcf30ffffe400000000000000000000004affffca2bffffe900000000000000000000004effffc626ffffef000000000000000000000054ffffc120fffff601000000000000000000005dffffba15fffffc070000000000000000000069ffffaf09fcffff130000000000000000000078ffff9f02f4ffff200000000000000000000086ffff9000e7ffff2e0000000000000000000093ffff8100d7ffff3f00000000000000000000a5ffff7100c8ffff5300000000000000000000b9ffff6200b4ffff6b00000000000000000000d1ffff4e009cffff8600000000000000000002eaffff350081ffffa00000000000000000000df9fffe1b0065ffffbd00000000000000000023fffff5090048ffffdd03000000000000000047ffffe100002cfffff41400000000000000006effffc4000014f6ffff32000000000000000098ffffa2000004deffff610000000000000001c5ffff79000000b7ffff950000000000000014e7ffff4e0000008bffffca060000000000003cfbfffc270000005dfffff0260000000000007effffe90c00000030faffff6700000000000ebfffffc10000000011e0ffffb40f000000003feaffff870000000000aeffffec550200001595fffffe4700000000006effffffa93f162262dbffffe91b000000000033f1ffffee936a76b6feffffb70400000000000ec0ffffffe8c2cef9fffffc660000000000000072fdffffffffffffffffde26000000000000002cdafffffffffffffffe9805000000000000000588f7ffffffffffffd64300000000000000000036bcfeffffffffed870d0000000000000000000568c1fbffffee9e3400000000000000000000001969d3ffffd24604000000000000000000000000179fffffc804000000000000000000000000000062ffffd906000000000000000000000000000035fffff51f000000000000000000000000000015f3ffff53000000000000000000000000000003d9ffff9d040000000000000000000000000000aeffffdc2b000000000000000000000000000077fffffc7d12000000010000000000000000003df6ffffcc5e220c2f2600000000000000000011cffffffdb67a648756000000000000000000008ffffffff8ceb8db880000000000000000000045f7ffffffffffff9d0000000000000000000014c1ffffffffffffb200000000000000000000006de9ffffffffffc6000000000000000000000021a0fcffffffffda00000000000000000000000048bfefffffffc30000000000000000000000000b6b9bc1d8bf7b000000000000000000000000001a476d846b2c000000000000000000000000000000152c13000000000000000000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 LCD_V NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="20")
  inspect(f.glyph().bitmap().rows(), content="78")
  inspect(f.glyph().bitmap().pitch(), content="20")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="25")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000002285333090000000000000000000000000000004280ab8b4e00000000000000000000000000001196d4fcdfa2180000000000000000000000000049e8ffffffec590000000000000000000000000b9fffffffffffb10600000000000000000000002be2ffffffffffec1c00000000000000000000005cfefff7cef2ffff43000000000000000000000095ffffb576adffff770000000000000000000001c5fff4622259f2ffa6000000000000000000000fe8ffcf160012d4ffc80000000000000000000029fcff99000000a8ffdf0000000000000000000046ffff6400000083ffed000000000000000000005bffff3d0000006bfff7020000000000000000006affff1e0000005bfffe0a00000000000000000078ffff0b00000056ffff0f00000000000000000086fffa0300000059fffe0d00000000000000000094fff30000000066fff80500000000000000000099fff00000000077ffeb0000000000000000000096fff4000000008bffd9000000000000000000008bfffb04000000abffc6000000000000000000007effff0c000004d0ffb10000000000000000000071ffff17000018f0ff8f0000000000000000000063ffff24000045ffff5e0000000000000000000056ffff36000087fffa2d0000000000000000000049ffff4f000fc7ffe20e0000000000000000000035ffff6e003ef2ffb600000000000000000000001efdff8d028bffff7500000000000000000000000bf1ffad23d0fff138000000000000000000000000d7ffcf6bf9ffc30d000000000000000000000000b6ffe9bdffff7a0000000000000000000000000094fffaf0ffec350000000000000000000000000071ffffffffb30b000000000000000000000000004ffffffff862000000000000000000000000000037ffffffcf2000000000000004131309000000004cffffff83010000000000001f6b6b2f000000028bffffff4b0000000000000042bfbf4900000022d2ffffff4a0000000000000069ffff4e00000065faffffff7f0000000000000087ffff2f000007b6ffffffffbc02000000000000a3fffc16000028eafffdf9ffe717000000000000bfffee06000066ffffe5dbfffd43000000000000dbffd6000003b0ffffb4aaffff7f000000000007f1ffb7000018e3ffff6c6bffffbb020000000017fdff9a00003efdffef2c31f9ffe8180000000031ffff7b00006effffc50a0edefffd42000000004dffff5d00009cffff840000aeffff81000000006cffff3f0001cbffff3f00006effffc30a00000092ffff21000cebfff315000036faffec30000000bdfff40d001cfcffda03000011e1ffff71000008e2ffda020030ffffb600000000b1ffffbe0a0022f9ffae00003fffff9a0000000073ffffed300049ffff7f00004dffff860000000038f6ffff720077ffff5000005dffff780000000011d0ffffbf0aa7fffa2500006bffff6f00000000008fffffed34d2ffe50b000073ffff70000000000046f8ffff82f0ffc100000073ffff7b000000000014d3ffffcffeff900000006dffff8b00000000000095fffffaffff6100000065ffff9b0000000000004af9fffffffe3400000058ffffaf00000000000016d7ffffffef1200000046ffffcd010000000000019affffffe4030000002effffe81300000000000050ffffffe52000000016fcfffc3b0000000000003dfffffff56b01000007e7ffff750000000000006cffffffffbe20000000bfffffb710000000001dbdfffffffff36904000084ffffe7500000000265f4ffffffffffc03d00004affffffa43007043bb9fffff6f1fffff49123001ef1ffffe88456548ff0ffffcbb9ffffffe25f0005ccffffffdcaeace5fffffe7c62f0ffffff92000085fefffffffbfcffffffe1321db8ffffff96000040dcfffffffffffffffd98080064f1ffff7a00000c8cfbffffffffffffd14200001cb0feff5c0000003acfffffffffffe7800b0000005cd2ff40000000087bc3eefffee2952e00000000167ee62400000000286b96baac8a3d02000000000028920e0000000000174266583602000000000000003e020000000000000012050000000000000000000400")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 LCD_V NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="75")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="24")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000070800000000000000000000000000053b595c430e00000000000000000000024b8fadb0975b110000000000000000002ba3e7ffffefb35d02000000000000000579f2fffffffff9b12b0000000000000032cbfffffffffffff47b0500000000000986faffffffffffffffd02900000000002ed5fffffffefcfffffffc6a000000000067fcffffe9b8b1e2ffffffb80a00000000aefffff29260598ad2ffffec300000000dddffffbc3e0d093684fcffff670000002ef8fff3690100000030d8ffffa600000066ffffc81e00000000058cfeffd8090000a2ffff8c0100000000003cedfff5240003d5ffff4b0000000000000ccbffff4e000ff5fff31e0000000000000099ffff7c0024ffffd506000000000000006affffa1003fffffaf00000000000000003bffffc40059ffff8e000000000000000016f1ffe5046cffff7b000000000000000003d6fff81379ffff6c000000000000000000b4ffff2982ffff5c00000000000000000096ffff428bffff4e00000000000000000083ffff5591ffff4400000000000000000071ffff6892ffff430000000000000000005dffff7b8dffff4b0000000000000000004bffff8e87ffff5700000000000000000039ffffa080ffff6400000000000000000026ffffad76ffff710000000000000000001bffffb668ffff8200000000000000000032ffffbb53ffffa10000000000000000006effffc13cffffca02000000000000000abaffffc724feffec130000000000000033ebffffcc0fedfffd380000000000000584ffffffd303caffff7d01000000000031ceffffffd70097ffffc023000000000d81f9fcfdffd6005dfffff3721100000a5ad4ffdafaffd2002cf9ffffc4643e3459aefcff97faffcd000de0fffff7b89288adf5fff049fcffc70000a1ffffffffeae0fbffffb517ffffc1000054e8ffffffffffffffeb620cffffbc000018a2ffffffffffffffa71d12ffffb60000004adaffffffffffc84f0019ffffb00000000e87c4ebfff6ca74100021ffffab00000000347097b7a3762100002effffa10000000000183f5f4b1f0000003fffff93000000000000000b000000000051ffff800000000000000000000000000063ffff6e0000000000000000000000000075ffff5a0000000000000000000000000089ffff4800000000000000000000000000a0ffff3500000000000000000000000000bfffff2200000000000000000000000001defffa100000000000000000000000000df4ffe80500000000000000000000000026feffca000000000000000000000000004effffa6000000000000000000000000007effff8200000000000000000000000000b6ffff5d0000000000000000000000000ee1ffff390000000a000000000000000038f9fff21a0000004f080000000000000082ffffcf05000009a23700000000000013c8ffff9b0000002bec8808000000000055f2ffff6100000069ffd8440600000028adfffff72c000002b0fffd9853200d2e7bedffffd10c000005d9ffffe4a7746182cfffffff8e00000005befffffff9ccb9dafffffff13f000000026ff3ffffffffffffffffffc1100000000024bdfffffffffffffffff36f00000000000166efffffffffffffffb3260000000000001eacf9ffffffffffd75f010000000000000058b2f0fffffcd183180000000000000000105a98b2bca7792b000000000000000000000d445e685324000000000000000000000000000a14020000000000000000")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 NORMAL DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 NORMAL DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 NORMAL DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 NORMAL DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 NORMAL DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 NORMAL DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 NORMAL DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 NORMAL DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 LIGHT DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 LIGHT DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 LIGHT DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 LIGHT DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 LIGHT DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 LIGHT DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 LIGHT DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 LIGHT DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 MONO DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 MONO DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 MONO DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 MONO DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 MONO DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 MONO DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 MONO DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 MONO DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 LCD DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 LCD DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 LCD DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 LCD DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 LCD DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 LCD DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 LCD DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 LCD DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 1 LCD_V DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="1")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 2 LCD_V DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="2")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 28 LCD_V DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="28")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 20 LCD_V DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="20")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 34 LCD_V DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="34")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 18 LCD_V DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="18")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 876 LCD_V DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="876")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/SourceCodePro-Regular.otf: rendered glyph 886 LCD_V DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="886")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/SourceCodePro-Regular.otf: hinted outline DEFAULT 16ppem" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 918U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="18")
  inspect(f.glyph().metrics().width(), content="192")
  inspect(f.glyph().metrics().height(), content="704")
  inspect(f.glyph().metrics().hori_advance(), content="640")
}

///|
test "parity/SourceCodePro-Regular.otf: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 918U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="614")
}

///|
test "parity/SourceCodePro-Regular.otf: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_sourcecodepro_regular_otf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 918U, load_flags=@base.LOAD_FORCE_AUTOHINT)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="640")
}

