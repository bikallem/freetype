// Parity tests for Roboto[wdth,wght].ttf
// AUTO-GENERATED — do not edit

///|
fn load_generated_roboto_wdth_wght__ttf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/Roboto[wdth,wght].ttf")
}

///|
test "parity/Roboto[wdth,wght].ttf: format" {
  inspect(@base.detect_format(load_generated_roboto_wdth_wght__ttf()) is (TrueType | TrueTypeCollection), content="true")
}

///|
test "parity/Roboto[wdth,wght].ttf: loads" {
  inspect((try? @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())) is Ok(_), content="true")
}

///|
test "parity/Roboto[wdth,wght].ttf: metadata" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  inspect(f.family_name(), content="Roboto")
  inspect(f.num_glyphs(), content="1326")
  inspect(f.units_per_em(), content="2048")
  inspect(f.ascender(), content="1900")
  inspect(f.descender(), content="-500")
  inspect(f.height(), content="2400")
  inspect(f.underline_position(), content="-200")
  inspect(f.underline_thickness(), content="100")
}

///|
test "parity/Roboto[wdth,wght].ttf: bbox" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  inspect(f.bbox().x_min(), content="-1510")
  inspect(f.bbox().y_min(), content="-555")
  inspect(f.bbox().x_max(), content="2353")
  inspect(f.bbox().y_max(), content="2163")
}

///|
test "parity/Roboto[wdth,wght].ttf: flags" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/Roboto[wdth,wght].ttf: charmaps" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  inspect(f.charmaps().length(), content="2")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="0")
    inspect(f.charmaps()[0].encoding_id(), content="3")
  }
  if f.charmaps().length() > 1 {
    inspect(f.charmaps()[1].platform_id(), content="3")
    inspect(f.charmaps()[1].encoding_id(), content="1")
  }
}

///|
test "parity/Roboto[wdth,wght].ttf: charmap entries" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  inspect(@freetype.get_char_index(f, 0U), content="1")
  inspect(@freetype.get_char_index(f, 2U), content="2")
  inspect(@freetype.get_char_index(f, 13U), content="3")
  inspect(@freetype.get_char_index(f, 32U), content="4")
  inspect(@freetype.get_char_index(f, 33U), content="5")
  inspect(@freetype.get_char_index(f, 34U), content="6")
  inspect(@freetype.get_char_index(f, 35U), content="7")
  inspect(@freetype.get_char_index(f, 36U), content="8")
  inspect(@freetype.get_char_index(f, 37U), content="9")
  inspect(@freetype.get_char_index(f, 38U), content="10")
  inspect(@freetype.get_char_index(f, 39U), content="11")
  inspect(@freetype.get_char_index(f, 40U), content="12")
  inspect(@freetype.get_char_index(f, 41U), content="13")
  inspect(@freetype.get_char_index(f, 42U), content="14")
  inspect(@freetype.get_char_index(f, 43U), content="15")
  inspect(@freetype.get_char_index(f, 44U), content="16")
  inspect(@freetype.get_char_index(f, 45U), content="17")
  inspect(@freetype.get_char_index(f, 46U), content="18")
  inspect(@freetype.get_char_index(f, 47U), content="19")
  inspect(@freetype.get_char_index(f, 48U), content="20")
  inspect(@freetype.get_char_index(f, 49U), content="21")
  inspect(@freetype.get_char_index(f, 50U), content="22")
  inspect(@freetype.get_char_index(f, 51U), content="23")
  inspect(@freetype.get_char_index(f, 52U), content="24")
  inspect(@freetype.get_char_index(f, 53U), content="25")
  inspect(@freetype.get_char_index(f, 54U), content="26")
  inspect(@freetype.get_char_index(f, 55U), content="27")
  inspect(@freetype.get_char_index(f, 56U), content="28")
  inspect(@freetype.get_char_index(f, 57U), content="29")
  inspect(@freetype.get_char_index(f, 58U), content="30")
  inspect(@freetype.get_char_index(f, 59U), content="31")
  inspect(@freetype.get_char_index(f, 60U), content="32")
  inspect(@freetype.get_char_index(f, 61U), content="33")
  inspect(@freetype.get_char_index(f, 62U), content="34")
  inspect(@freetype.get_char_index(f, 63U), content="35")
  inspect(@freetype.get_char_index(f, 64U), content="36")
  inspect(@freetype.get_char_index(f, 65U), content="37")
  inspect(@freetype.get_char_index(f, 66U), content="38")
  inspect(@freetype.get_char_index(f, 67U), content="39")
  inspect(@freetype.get_char_index(f, 68U), content="40")
  inspect(@freetype.get_char_index(f, 69U), content="41")
  inspect(@freetype.get_char_index(f, 70U), content="42")
  inspect(@freetype.get_char_index(f, 71U), content="43")
  inspect(@freetype.get_char_index(f, 72U), content="44")
  inspect(@freetype.get_char_index(f, 73U), content="45")
  inspect(@freetype.get_char_index(f, 74U), content="46")
  inspect(@freetype.get_char_index(f, 75U), content="47")
  inspect(@freetype.get_char_index(f, 76U), content="48")
  inspect(@freetype.get_char_index(f, 77U), content="49")
  inspect(@freetype.get_char_index(f, 78U), content="50")
}

///|
test "parity/Roboto[wdth,wght].ttf: glyph 5 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  let r = try? @freetype.load_glyph(f, 5U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="16")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="361")
  inspect(f.glyph().outline().points()[0].y(), content="1456")
  inspect(f.glyph().outline().points()[1].x(), content="348")
  inspect(f.glyph().outline().points()[1].y(), content="411")
  inspect(f.glyph().outline().points()[2].x(), content="181")
  inspect(f.glyph().outline().points()[2].y(), content="411")
  inspect(f.glyph().outline().points()[3].x(), content="167")
  inspect(f.glyph().outline().points()[3].y(), content="1456")
  inspect(f.glyph().outline().points()[4].x(), content="161")
  inspect(f.glyph().outline().points()[4].y(), content="93")
  inspect(f.glyph().outline().points()[5].x(), content="161")
  inspect(f.glyph().outline().points()[5].y(), content="138")
  inspect(f.glyph().outline().points()[6].x(), content="216")
  inspect(f.glyph().outline().points()[6].y(), content="200")
  inspect(f.glyph().outline().points()[7].x(), content="270")
  inspect(f.glyph().outline().points()[7].y(), content="200")
  inspect(f.glyph().metrics().hori_advance(), content="528")
}

///|
test "parity/Roboto[wdth,wght].ttf: glyph 6 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  let r = try? @freetype.load_glyph(f, 6U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="12")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().outline().points()[0].x(), content="278")
  inspect(f.glyph().outline().points()[0].y(), content="1536")
  inspect(f.glyph().outline().points()[1].x(), content="278")
  inspect(f.glyph().outline().points()[1].y(), content="1400")
  inspect(f.glyph().outline().points()[2].x(), content="248")
  inspect(f.glyph().outline().points()[2].y(), content="1043")
  inspect(f.glyph().outline().points()[3].x(), content="137")
  inspect(f.glyph().outline().points()[3].y(), content="1043")
  inspect(f.glyph().outline().points()[4].x(), content="137")
  inspect(f.glyph().outline().points()[4].y(), content="1391")
  inspect(f.glyph().outline().points()[5].x(), content="137")
  inspect(f.glyph().outline().points()[5].y(), content="1536")
  inspect(f.glyph().outline().points()[6].x(), content="548")
  inspect(f.glyph().outline().points()[6].y(), content="1536")
  inspect(f.glyph().outline().points()[7].x(), content="548")
  inspect(f.glyph().outline().points()[7].y(), content="1400")
  inspect(f.glyph().metrics().hori_advance(), content="656")
}

///|
test "parity/Roboto[wdth,wght].ttf: glyph 7 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  let r = try? @freetype.load_glyph(f, 7U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="16")
  inspect(f.glyph().outline().n_contours(), content="4")
  inspect(f.glyph().outline().points()[0].x(), content="279")
  inspect(f.glyph().outline().points()[0].y(), content="0")
  inspect(f.glyph().outline().points()[1].x(), content="562")
  inspect(f.glyph().outline().points()[1].y(), content="1456")
  inspect(f.glyph().outline().points()[2].x(), content="706")
  inspect(f.glyph().outline().points()[2].y(), content="1456")
  inspect(f.glyph().outline().points()[3].x(), content="422")
  inspect(f.glyph().outline().points()[3].y(), content="0")
  inspect(f.glyph().outline().points()[4].x(), content="686")
  inspect(f.glyph().outline().points()[4].y(), content="0")
  inspect(f.glyph().outline().points()[5].x(), content="970")
  inspect(f.glyph().outline().points()[5].y(), content="1456")
  inspect(f.glyph().outline().points()[6].x(), content="1113")
  inspect(f.glyph().outline().points()[6].y(), content="1456")
  inspect(f.glyph().outline().points()[7].x(), content="829")
  inspect(f.glyph().outline().points()[7].y(), content="0")
  inspect(f.glyph().metrics().hori_advance(), content="1261")
}

///|
test "parity/Roboto[wdth,wght].ttf: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 5U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="256")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 NORMAL NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
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
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 NORMAL NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000003b91000000000000000000d6ff390000000000000027fffa9b0000000000000088d966f20a000000000003e57c10f85e00000000004bfe2100acc00000000000acc200004ffe2300000014ff9d38383dff9f0000006fffffffffffffff020000d0af040404043cff470032ff4e0000000000dba90093ec0500000000007ef812")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 NORMAL NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="10")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00002378947213000053fabd9be3e31400c29600001efe6d000000021920f4870020aef8ece4ff8801d4be1a0000e8881cff5f000004ff8807eec73333b8ff8f0048e8fffa92ceb90000031f07000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 NORMAL NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000055179773d00000023dcf1bcc7fbb40700c4db18000031f68200f79000000000a0bc00c7db1a0000000000002de7f49c4905000000000e7bd9ffe65a00000000000032acff5f1a4c0d00000000c5c83cff5700000000b0da02b4eb5e212b74fc79000985eeffffe97801000000001815000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 NORMAL NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00002b87914932670040fadeaadff3e400cccb09000afff516ff5e000000ddff33ff3a000000c0ff27ff44000000c3ff07f682000000ffff008ff55b1d5fffe50008a5ffffceafe3000000141d00a2cf007779060042f5830037e1f8eaffb2080000023950290000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 NORMAL NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="14")
  inspect(f.glyph().bitmap().pitch(), content="11")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000001d6a816415000000000066f8e8c6eef2510000003ffe8c040008a0f8280000bbde030000000def9b0006f9890000000000a6df001cff69000000000089fb0023ff5d00000000007dff0315ff75000000000094f50000eaa00000000000bccb000094f71b0000002bfe77000016e5de4b2656ffd70a00000020b4fcffffff5a0000000000000d2119b2fc72000000000000000001807d00")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 NORMAL NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="10")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000004588060080000000000b7f5b3e8c6020000002eff5d002fff380000003cff410039ff2400000006dfb541ea99000000000045ffff83010000000011c0ffff510004400e00b9d91999f43023ff2724ff5a0004bee282f00621ff61000011ebff9a0000c7e33a0e41ffffb1000019b3fdfffaae5efb7d0000000d220a00000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 NORMAL NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000166c805102000033e8debbf8b60400cbbf06003cfd5917ff52000000b7b82eff3c000000acff10fe6c000000ffff00ace63e146effe20014c1ffffc0b0c8000000202000c58c00000000004cfe340000244d92f9850000009bf1bf5300000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 LIGHT NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
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
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 LIGHT NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000003b91000000000000000000d6ff390000000000000027fffa9b0000000000000088d966f20a000000000003e57c10f85e00000000004bfe2100acc00000000000acc200004ffe2300000014ff9d38383dff9f0000006fffffffffffffff020000d0af040404043cff470032ff4e0000000000dba90093ec0500000000007ef812")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 LIGHT NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="10")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00002378947213000053fabd9be3e31400c29600001efe6d000000021920f4870020aef8ece4ff8801d4be1a0000e8881cff5f000004ff8807eec73333b8ff8f0048e8fffa92ceb90000031f07000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 LIGHT NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000055179773d00000023dcf1bcc7fbb40700c4db18000031f68200f79000000000a0bc00c7db1a0000000000002de7f49c4905000000000e7bd9ffe65a00000000000032acff5f1a4c0d00000000c5c83cff5700000000b0da02b4eb5e212b74fc79000985eeffffe97801000000001815000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 LIGHT NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00002b87914932670040fadeaadff3e400cccb09000afff516ff5e000000ddff33ff3a000000c0ff27ff44000000c3ff07f682000000ffff008ff55b1d5fffe50008a5ffffceafe3000000141d00a2cf007779060042f5830037e1f8eaffb2080000023950290000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 LIGHT NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="14")
  inspect(f.glyph().bitmap().pitch(), content="11")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000001d6a816415000000000066f8e8c6eef2510000003ffe8c040008a0f8280000bbde030000000def9b0006f9890000000000a6df001cff69000000000089fb0023ff5d00000000007dff0315ff75000000000094f50000eaa00000000000bccb000094f71b0000002bfe77000016e5de4b2656ffd70a00000020b4fcffffff5a0000000000000d2119b2fc72000000000000000001807d00")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 LIGHT NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="10")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="10")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000004588060080000000000b7f5b3e8c6020000002eff5d002fff380000003cff410039ff2400000006dfb541ea99000000000045ffff83010000000011c0ffff510004400e00b9d91999f43023ff2724ff5a0004bee282f00621ff61000011ebff9a0000c7e33a0e41ffffb1000019b3fdfffaae5efb7d0000000d220a00000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 LIGHT NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000166c805102000033e8debbf8b60400cbbf06003cfd5917ff52000000b7b82eff3c000000acff10fe6c000000ffff00ace63e146effe20014c1ffffc0b0c8000000202000c58c00000000004cfe340000244d92f9850000009bf1bf5300000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 MONO NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
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
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 MONO NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
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
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 MONO NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
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
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 MONO NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
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
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 MONO NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="7")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="9")
  inspect(f.glyph().bitmap().buffer().length(), content="24")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 MONO NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="14")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  inspect(f.glyph().bitmap().buffer().length(), content="28")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 MONO NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  inspect(f.glyph().bitmap().buffer().length(), content="24")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 MONO NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="7")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="12")
  inspect(f.glyph().bitmap().buffer().length(), content="24")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 LCD NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
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
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 LCD NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="36")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="36")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="-1")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000113b7a9f91521b000000000000000000000000000000000000000000000000000000001c71d6ffffffff8d390200000000000000000000000000000000000000000000000000277bd2fffbfafafee99b470500000000000000000000000000000000000000000000003488dbffd9854466bafbf2a8500a0000000000000000000000000000000000000000033e96e5ffd07c2800105db5f8f8b25e11000000000000000000000000000000000000084b9feefecb73210000000b58acf4fbc06c18000000000000000000000000000000000c58acf4fdc26e190000000000094fa3f1fece76230000000000000000000000000000146ed9fffff19d4e383838383838383d7ed6ffffff9f390000000000000000000000001d6ffbffffffffffffffffffffffffffffffffffffffffbd3902000000000000000000257dd0fff6af5b0f0404040404040404040404053c90e5ffed9b4706000000000000013286ddfff1a24e0900000000000000000000000000002f87dbfff2a9550a00000000023f93e4ffec9e4605000000000000000000000000000000002a7ed2fff8b75f1200")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 LCD NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000a2346657885909491847256311302000000000000000000001953a0dffaf5dbbda4999ba7c6e3fafde3a44f14000000000000002977c2e4d6964c0b0000000000011e71c7feffc16d1a0000000000000000000000000000020710191e20205daaf4ffdb87330000000000000003204d86aed0ebf8f9f4ece7e4e4ffffffffdc88340000000000013083d4faeebe7c3e1a0800000000003c94e8ffdc883400000000001c70c8ffffb35f0b000000000000000472fbffffe6883400000000000749a1eefff2c78950332726334e7fb8ffffffffe68f3b0000000000000018488ac4e8fafffffffffae8c3927298cefffdb9651000000000000000000000030c181f1d12070100000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 LCD NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000005193751606d797f7e776b573d200a0000000000000000000000000003235ea8dcf5fdf1ddc9bcb9bcc7d9eefbfbe1b46c2d0700000000000000001e70c4f9ffdb9d4718020000000000000d317bc6f6fdd58230010000000000004ba3f7ffe4903c00000000000000000000000754a0e5e8bc70200000000000001e73c7fdfddb9d4c1a050000000000000000000000000000000000000000000000062d6cb9e7fbfff4dcbb9c8064492d1405000000000000000000000000000000000000000e2c567b9cbcd9f0fdfffff9e6c2905a2a0b000000000000000000000000000000000000000000061732537dacd8f5ffeeb25f1c0000000000011a334c4c40260d0000000000000000000000001a71c5feffc8741c00000000003c90e8fff7ab570c0000000000000000000000095cb0faffda862e0000000000022263b4e8ffebc28b5e412c211c1f2b394f74addffcf7cb792e02000000000000000009275585aed3eefbfffffffffffff9e9cca4784218010000000000000000000000000000000000040d181f1d150a0300000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 LCD NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="27")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="28")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000f2b517387939591836c4925163258746741190000000000000d408ed9fafff2dec3b0aab0c5dfe9f1f3feffe4903800000000002478ccfcfacb812e0900000000000a2fb6fffffff5903800000000166ac2fffcb25e0d00000000000000000040ddffffff9438000000003387dfffe68e3a0000000000000000000038c0ffffffb73800000000277bd3fff098440000000000000000000038c3ffffffa938000000000752aaf6ffd6822e00000000000000000269ffffffff90380000000000043b8fdefff5cf925b38251d21365f9effffffffe5903800000000000000082863a5d8f5fffffffffdf0ce998eafe7ffe38f3700000000000000000000000109141f211d110600034ea2f2ffcf7b230000000000052f77b1ae793f190600000003154287cdf5fed68330000000000000000e3776b6e1f6fef8ece5eaf5fdfff9e0b26d2e08000000000000000000000000020f2439474f504a3d291404000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 LCD NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="33")
  inspect(f.glyph().bitmap().rows(), content="14")
  inspect(f.glyph().bitmap().pitch(), content="36")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000091d39566a7880817e74644e2f15040000000000000000000000000000000000072b66abdff8fff8e8d6c9c6cbdceefbfff2d295511d0200000000000000000000000a3f91defef6cc8c4618040000000000082157a0dafcf8ca74280100000000000000001567bbf9ffde8e360300000000000000000000000d50a8efffea9b47040000000000000654acf9ffdd893500000000000000000000000000000252a6f8ffdf8b330000000000001c70c8ffffbd69150000000000000000000000000000003589ddfffba74f0000000000002377cfffffb15d09000000000000000000000000000000297dd1ffffaf570300000000001569c1ffffc975210000000000000000000000000000004094e8fff5a149000000000000003f97eaffeea04c06000000000000000000000000001168bcfeffcb771f00000000000000044094e3fff7bd671b01000000000000000000042b7dd1fefecb7725000000000000000000001651a7e5fdfadead744b3528262a395697d7fffffad78e3c0a0000000000000000000000000005204d87b4d8f1fcffffffffffffffffffffc15a18010000000000000000000000000000000000000000050d1720211e15193771b2e1fbfce4b372370f00000000000000000000000000000000000000000000000000000001154180afae7d3a0f0000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 LCD NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="33")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="36")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000041736586d7c807f7460411e080000000000000000000000000000000000000000001f65b7ecfef5e0c3b3b4cee8fcf2c674290200000000000000000000000000000000002e82dafff7b25d12000000022f83d8ffe48c3800000000000000000000000000000000003c90e8ffec95410100000005398ddfffd078240000000000000000000000000000000000063b92dffef0b56431417dbeeaf9dc99491000000000000000000000000000000000000000000d45adffffffffffffc6834416010000000000000000000000000000000000000000113b7ec0eefffffffffffca551180000000004192f4039230e0000000000000000001f65b9eefcd99c4b19144899dafcf4c8793008002377cfffd37b2700000000000000002478d0fff9ae5a0c0000000004276fbeeffee2a66a82befbf0a34b0600000000000000002175cdfffdb5610f00000000000000114498ebffffffffff9a3e05000000000000000000002473c7f7fde3af6c3a1f110e1425416cacffffffffffffb15418000000000000000000000001194482b3d9f1fdfffffffffffaedd2ae7f575e96dafbf5c87d33080000000000000000000000000000050d1820221f150a02000000000000000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 LCD NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="27")
  inspect(f.glyph().bitmap().rows(), content="13")
  inspect(f.glyph().bitmap().pitch(), content="28")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000031633576c7b81807969513013020000000000000000000000093372bee8fcf2dec5b8bbcde7f8fde8b6682604000000000000002477cbfbf5bf72250600000000103c8ed6fdf4ad59100000000000176bc3fff9a6520500000000000000000f63b7fcfcb86410000000002e82daffe8903c000000000000000000003aacffffff8d32000000001062bafefec06c1a0000000000000000076cffffffff9b4200000000000f58acf0ffe6b56f3e1f121423426eacffffffffe28d3500000000000000143f83c1eafcfffffffffce9c08688b0eeffc8741c00000000000000000000000612202828201206001a71c5fee08c3800000000000000000000000000000000000000154c9ee2fedc873403000000000000000000000f243a444d5c7392bbe2f9f4cd853c0b000000000000000000000000489bedf8f1e6d4bfa37f53280b00000000000000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 LCD_V NO_HINTING 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
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
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 LCD_V NO_HINTING 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000006110000000000000000003b9100000000000000000078ff080000000000000000bdff1c0000000000000000d6ff390000000000000002ebff59000000000000000ff8ff7b0000000000000027fffa9b0000000000000047fdbfbb0000000000000068ef8cdb0000000000000088d966f20a000000000000a8ba47fd1f000000000000ca9a27ff3e000000000003e57c10f85e000000000011f85d03e77e00000000002bff3d00caa000000000004bfe2100acc000000000006bf50c008ede01000000008de001006ef40d00000000acc200004ffe2300000000cca4000031ff4200000004e984000015fb6300000014ff9d38383dff9f0000002dffd38c8c8cffea0000004fffffe4e4e4ffff0000006fffffffffffffff0200008fffb3b0b0b0ffff0f0000b1ff58585858afff270000d0af040404043cff470005ea8d000000001cfd670016fb6d0000000008f1890032ff4e0000000000dba90052ff300000000000bdc90074fb1500000000009de60393ec0500000000007ef8126d980000000000004aab123b450000000000001f540e00000000000000000000000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 LCD_V NO_HINTING 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="30")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000024401f00000000237894721300000471cce8c64e000020c9fdefffa3030053fabd9be3e3140090ef6947a7fc3200c0cd130055ff5600c29600001efe6d008152000006f87c00341d000000ef83000000021920f48700000f4f6d74ff8800045aa7c5ccff880020aef8ece4ff880054f2c59890ff88009eea6d4038fc8801d4be1a0000e88809f48a000000ed8814ff65000000ff881cff5f000004ff881bff6a000024ff8810fd95000069ff8a07eec73333b8ff8f00ccf08787ebff98008effdfdfdcf7a60048e8fffa92ceb9001698cbae3f82840000407356093c440000031f070000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 LCD_V NO_HINTING 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="9")
  inspect(f.glyph().bitmap().rows(), content="39")
  inspect(f.glyph().bitmap().pitch(), content="9")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000425230300000000055179773d0000000037a5cdcb911c0000068ef8ffffe661000023dcf1bcc7fbb4070055ffb46873cfec240094f55d101b81ff5200c4db18000031f68200e2b900000009e1a600f39a00000000c4c000f79000000000a0bc00ef9500000000617b00dfb700000000263300c7db1a000000000000a0f86204000000000065ffba4805000000002de7f49c49050000000ba2ffec9d40000000004acfffef98180000000e7bd9ffe65a000000002886dcffae0b000000002d86edee2c000000000032acff5f00000000000158f99000000000000013e1b41a4c0d00000000c5c833a02100000000abd74af83d00000000a6de3cff5700000000b0da24fe8400000002ccc90ee5bf13000024eaaa02b4eb5e212b74fc79006cfeb2757fc5fa40002cd7f7cdd7fccb13000985eeffffe978010000329ac4c1952900000002426c693d0000000000001815000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 LCD_V NO_HINTING 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="39")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000001333d090d1c00002b8791493267000179dbe59d6ab20018d0fffbebb4e40040fadeaadff3e40074ff945695ffe400a3ec3c023dffe700cccb09000afff504ea9f000000ffff0bfc79000000fcff16ff5e000000ddff21ff4c000000cbff2cff41000000c1ff33ff3a000000c0ff36ff38000000c0ff31ff3c000000c0ff27ff44000000c3ff1dff50000000d2ff11ff65000000edff07f682000000ffff02dfac000001ffff00b9d7130019fff1008ff55b1d5fffe5005afeaf71b1ffe40029e4f3c9ebe4e40008a5ffffceafe3000052c0c97b91e000001568712994d9000000141d00a2cf000f07000000bbbf003a2d000011dda6007779060042f5830092c5523d96ff540074f6aa95ddec260037e1f8eaffb208000c90e5fbd55e000000388da47d190000000239502900000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 LCD_V NO_HINTING 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="45")
  inspect(f.glyph().bitmap().pitch(), content="11")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000172d12000000000000001d6a81641500000000000469bed5b85c010000000027c1fffffdb41b0000000066f8e8c6eef25100000003b4f89972a2fc9c00000019e9ce411a4adad90c00003ffe8c040008a0f82800006eff430000005bff50000099f51600000027fd7b0000bbde030000000def9b0000d7bb0000000001d5b70001ec9c0000000000b9cd0006f9890000000000a6df000dff7e00000000009ced0016ff73000000000092f6001cff69000000000089fb0020ff61000000000081fe0123ff5d00000000007dff0323ff5d00000000007dff0320ff62000000000082fe011cff6a00000000008bfa0015ff75000000000094f5000dff7f00000000009deb0005f88b0000000000a8dd0000eaa00000000000bccb0000d4be0000000001d7b50000b7e1050000000ef198000094f71b0000002bfe7700006aff5100000066ff4f00003afda007000cb0f726000016e5de4b2656ffd70a000002affd9f7ac5ff9b000000005cf3f0d2ffff5c0000000020b4fcffffff5a000000000260b6cdffff920400000000145e7599fada2b00000000000d2119b2fc72000000000000000060f7b500000000000000001dcbba000000000000000001807d0000000000000000003435000000000000000000080a0000000000000000000000000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 LCD_V NO_HINTING 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
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
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000c2c110000000000000458806008000000000029acd4b43300000000006bf7fefa7a0000000000b7f5b3e8c60200000008e6ce5fb0ee100000001afc920965ff240000002eff5d002fff380000003cff40001bff3d00000040ff39001fff350000003cff410039ff240000002dff5b006ff31200000017f8830db6d30500000006dfb541ea990000000000b3e7a2f853000000000079ffffcf1b000000000045ffff830100000000003effff3a00000000000072ffff27000000000011c0ffff510004400e0038f1deff95000d941e007af762d2d20c17ec2b00b9d91999f43023ff2707e5ad0054fe6b32ff1d14fc79001fe9b24bfd1024ff5a0004bee282f0062cff4c00007cfbd7db002aff5000003af9ffba0021ff61000011ebff9a0012fb82000000e8ff860006ebb6050006f3ff8a0000c7e33a0e41ffffb100008ffd8e6295ffffda120049f2e1bae7f1d7f93c0019b3fdfffaae5efb7d00015fb6ceb15a18a76b0000155e765910014f400000000d220a0000000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 LCD_V NO_HINTING 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="39")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000192c0a00000000166c80510200000053c0d4a52400000eaafffff366000033e8debbf8b6040067fd9167d0e81500a0e5390f88fe3300cbbf06003cfd5903eb8e000010ef7d0bfd6a000001d4a017ff52000000b7b823ff44000000a3c92dff3d00000099d62eff3c000000acff28ff44000000c9ff1dff54000000f2ff10fe6c000000ffff07f08f000001ffff01d3c1070024fff400ace63e146effe20079fe9268c0ffdc003ef2e2c0e9d7d50014c1ffffc0b0c800006dcccc6da1b7000023747421b0a1000000202000c58c000000000004e17500000000001bf55700000000004cfe34000000000594ef15000000023ed5c7030000244d92f98500000057a1e1ee410000008df7fea7100000009bf1bf5300000000699d6b110000000033451400000000000000000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 NORMAL DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 NORMAL DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 NORMAL DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 NORMAL DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 NORMAL DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 NORMAL DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 NORMAL DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 NORMAL DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 LIGHT DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 LIGHT DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 LIGHT DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 LIGHT DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 LIGHT DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 LIGHT DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 LIGHT DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 LIGHT DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 MONO DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 MONO DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 MONO DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 MONO DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 MONO DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 MONO DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 MONO DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 MONO DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 LCD DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 LCD DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 LCD DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 LCD DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 LCD DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 LCD DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 LCD DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 LCD DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 LCD_V DEFAULT 16ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 LCD_V DEFAULT 16ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 LCD_V DEFAULT 16ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 LCD_V DEFAULT 16ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 LCD_V DEFAULT 16ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 LCD_V DEFAULT 16ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 LCD_V DEFAULT 16ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 LCD_V DEFAULT 16ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 NORMAL NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
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
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 NORMAL NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="24")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="24")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000080ffe2340000000000000000000000000000000000000027ffffffa70000000000000000000000000000000000000088fffffff711000000000000000000000000000000000003e6ffffffff6b00000000000000000000000000000000004cffffffffffcd0000000000000000000000000000000000adffff6fe6ffff2f00000000000000000000000000000014f9fffa148cffff9100000000000000000000000000000070ffffb2002fffffec060000000000000000000000000000d1ffff540000d1ffff550000000000000000000000000033ffffef07000074ffffb70000000000000000000000000095ffff9a0000001afdfffd1b000000000000000000000007eeffff3d00000000baffff7b000000000000000000000058ffffdf01000000005dffffdb0000000000000000000000b9ffff8300000000000bf4ffff3f0000000000000000001dfdffff27000000000000a3ffffa10000000000000000007cffffc90000000000000046fffff50d0000000000000001fcffffe4787878787878787bffffff72000000000000003fffffffffffffffffffffffffffffffe300000000000000a1ffffffffffffffffffffffffffffffff2900000000000df4ffffa04c4c4c4c4c4c4c4c4c4cffffff8b000000000064ffffef070000000000000000000074ffffe80400000000c5ffff9a00000000000000000000001afdffff4f00000027ffffff3d000000000000000000000000baffffb100000088ffffdf010000000000000000000000005dfffffb170003e6ffff83000000000000000000000000000bf4ffff75004bffffff270000000000000000000000000000a3ffffd600")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 NORMAL NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="21")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="20")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000014445851390800000000000000000050c6fefffffffff5a71f000000000006a7fffffffffffffffffff43e00000000a5ffffffb864475492f7ffffee17000040ffffff64000000000032f6ffff7e000091ffffbf0000000000000094ffffc700002a404026000000000000005cffffe50000000000000000000000000050fffff40000000000000739657a868888d8fffff4000000001e9cf1fffffffffffffffffff40000004cf5fffffff7d6c6c0c0fffffff400002af8ffffc747050000000050fffff40000a8ffffbf0400000000000050fffff40000f1ffff4d0000000000000054fffff4000cffffff390000000000000096fffff40001f7ffff7000000000000010fffffff40000bfffffed2e0000000030d2fffffffd020048fffffff9b18892c4ffffffffffff1400007cffffffffffffffffee6dffffff3d00000049cdfffffffff8a11d03edffff850000000000214655400c00000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 NORMAL NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="20")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="20")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000001570b0d9ececd8ad660d0000000000000000088af8ffffffffffffffffef5d0000000000000ec8fffffffff3dde2f8ffffffff9c0000000000adffffffa7340100000344bfffffff790000003bffffff8000000000000000029efffffc27000091ffffe604000000000000000008ebffff8f0000b6ffffaf0000000000000000000098ffffd20000b7ffffb0000000000000000000005dc8c8b9000093fffff2160000000000000000000000000000003bffffffc717000000000000000000000000000000a4ffffffee78130000000000000000000000000008b4fffffffffab6691900000000000000000000000170f0fffffffffffec45e0700000000000000000000127ee2ffffffffffffe4600000000000000000000000023e91e1ffffffffffae0900000000000000000000000000379cf9ffffffb100000000000000000000000000000022c7ffffff550000000000000000000000000000000de3ffffb8003b6c6c58000000000000000000000086ffffec0079ffffe400000000000000000000006bfffffc004effffff2d000000000000000000008affffe80005e8ffffc10600000000000000000de7ffffab000059ffffffc22a00000000000023c6ffffff4000000080fffffffec58b706f84bbfaffffff91000000000059e8fffffffffffffffffffffb84010000000000000e72cffeffffffffffeb972a00000000000000000000000f3d5255462300000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 NORMAL NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="20")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000274c57400d000000040403000000004bd2fffffffff8a2183effffc000000084ffffffffffffffffe878ffffc0000063fffffff6a06f6c98eeffffffffc00012eeffffda240000000013bdffffffc00072fffffa280000000000000fffffffc000cbffff9e0000000000000000dcffffc008faffff4a000000000000000089ffffc02dffffff18000000000000000080ffffc03ffffffd01000000000000000080ffffc04afffff500000000000000000080ffffc03ffffffd00000000000000000080ffffc02cffffff17000000000000000080ffffc007f9ffff48000000000000000089ffffc000c6ffff9c0000000000000000e8ffffc00069fffff92600000000000014ffffffc0000ce5ffffd924000000001acaffffffc0000050fefffff6a37477a2f6ffffffffc00000006dfdffffffffffffffe6a7ffffc0000000003ecafffffffff59d1680ffffbe0000000000002249533c0a000094ffffb200000000000000000000000000bfffff9000000b74010000000000000028fdffff510004b6ffa00e000000000019d1ffffe406001eeeffffe68647324787ecfffffc4400000037e3fffffffffffffffffff96600000000001184e9fffffffffffbb72e00000000000000000236657a6b50160000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 NORMAL NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="22")
  inspect(f.glyph().bitmap().rows(), content="31")
  inspect(f.glyph().bitmap().pitch(), content="22")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000013f91c8e1ebd4b36817000000000000000000000032c6fffffffffffffffff67e08000000000000000054fafffffffffef8ffffffffffc20e0000000000004dfcfffff88a2e05001257c7ffffffc5030000000015e9ffffe4290000000000000284ffffff7b0000000095fffff82a0000000000000000009ffffff81500000ff3ffff840000000000000000000013efffff79000062fffffc1900000000000000000000009affffd500009effffc10000000000000000000000004afffffe1200d5ffff8d00000000000000000000000018ffffff4800f0ffff6700000000000000000000000000f2ffff6302feffff5800000000000000000000000000e4ffff740effffff4c00000000000000000000000000d9ffff8210ffffff4c00000000000000000000000000d8ffff8407ffffff5200000000000000000000000000deffff7b00f6ffff6100000000000000000000000000ecffff6a00e3ffff7b00000000000000000000000007fcffff5800b4ffffab00000000000000000000000032ffffff2b0079ffffea05000000000000000000000071fffff002002cffffff510000000000000000000000ccffffa9000000beffffd80600000000000000000053ffffff3f0000003ffeffffa0010000000000000026e9ffffc3000000000090ffffffb620000000000155e9fffff524000000000006aefffffffdc2978ba3e3fffffff74b00000000000000038dfcffffffffffffffffffff5e000000000000000000002da4f0ffffffffffffffffeb420000000000000000000000063049543e1f80fefffffc7300000000000000000000000000000000004df0ffffffa80b0000000000000000000000000000000025d4fffff94600000000000000000000000000000000000cabf34400000000000000000000000000000000000000001f0000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 NORMAL NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="22")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="22")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000e6dbedfebd297300000000000000000000000000037e1fffffffffffffc7c00000000000000000000001ceaffffffd2c0ebffffff660000000000000000000093fffff44600000798ffffe907000000000000000000e9ffff7e0000000004deffff3b00000000000000000bffffff350000000000aeffff54000000000000000017ffffff2f0000000000ccffff3e000000000000000002f4ffff6c0000000045ffffee06000000000000000000a4ffffe009000049f2ffff6c0000000000000000000027fbffff920588fdffff980000000000000000000000007dffffffffffffff7c0000000000000000000000000002baffffffffee4f000000000000000000000000000011c0ffffffff39000000000000000000000000000029dcffffffffffcc0900000000000000000000000030edffffec8bfbffffaa0100000024d0d09e00000014e6ffffd8220066ffffff810000003fffffb600000098ffffec1e00000091ffffff57000062ffff97000006f3ffff710000000003b7fffff63500a6ffff6a000022ffffff2300000000000fd6ffffe62bf1ffff25000027ffffff1700000000000022ecffffffffffc600000008feffff44000000000000003efaffffffff4c00000000c8ffffb1000000000000000087ffffffff00000000005affffff850200000000005aeaffffffff590000000001aaffffffd983616085d8fffffffffffff7360000000009a5ffffffffffffffffffffd030d3ffffe61c00000000004eb8fbfffffffffbc158020020eaffffce0a00000000000011354e51390d00000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 NORMAL NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000254a8d7ecddbf6f120000000000000025cbffffffffffffffeb4c000000000023e6ffffffeac8ddfffffffd4f00000002c5ffffec5603000039d8fffff31d000053fffffb35000000000018e3ffff9f0000b8ffff9a0000000000000057fffff90f03f4ffff3e0000000000000004e8ffff5b22ffffff0b0000000000000000a7ffff9134fffff800000000000000000079ffffbb32fffffe02000000000000000068ffffcd1affffff26000000000000000082ffffda00e9ffff6e0000000000000000e3ffffdb009effffdd060000000000002dffffffd30035ffffffa3050000000036e6ffffffc90000a0ffffffd06c4b5ea8fdffffffffb3000009c1ffffffffffffffffc084ffff990000000581efffffffffed78049affff6e00000000000743616343060000cbffff3d0000000000000000000000001afeffee040000000000000000000000008dffff9d00000000000000000000000037f9fffd28000000000000000000000042efffff96000000000000000000043ca9ffffffcd0700000000000076bed2f5ffffffffbd1100000000000000a4ffffffffffe971050000000000000000a4f9e7d198550b0000000000000000000004000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 LIGHT NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
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
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 LIGHT NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="24")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="24")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000080ffe2340000000000000000000000000000000000000027ffffffa70000000000000000000000000000000000000088fffffff711000000000000000000000000000000000003e6ffffffff6b00000000000000000000000000000000004cffffffffffcd0000000000000000000000000000000000adffff6fe6ffff2f00000000000000000000000000000014f9fffa148cffff9100000000000000000000000000000070ffffb2002fffffec060000000000000000000000000000d1ffff540000d1ffff550000000000000000000000000033ffffef07000074ffffb70000000000000000000000000095ffff9a0000001afdfffd1b000000000000000000000007eeffff3d00000000baffff7b000000000000000000000058ffffdf01000000005dffffdb0000000000000000000000b9ffff8300000000000bf4ffff3f0000000000000000001dfdffff27000000000000a3ffffa10000000000000000007cffffc90000000000000046fffff50d0000000000000001fcffffe4787878787878787bffffff72000000000000003fffffffffffffffffffffffffffffffe300000000000000a1ffffffffffffffffffffffffffffffff2900000000000df4ffffa04c4c4c4c4c4c4c4c4c4cffffff8b000000000064ffffef070000000000000000000074ffffe80400000000c5ffff9a00000000000000000000001afdffff4f00000027ffffff3d000000000000000000000000baffffb100000088ffffdf010000000000000000000000005dfffffb170003e6ffff83000000000000000000000000000bf4ffff75004bffffff270000000000000000000000000000a3ffffd600")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 LIGHT NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="21")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="20")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000014445851390800000000000000000050c6fefffffffff5a71f000000000006a7fffffffffffffffffff43e00000000a5ffffffb864475492f7ffffee17000040ffffff64000000000032f6ffff7e000091ffffbf0000000000000094ffffc700002a404026000000000000005cffffe50000000000000000000000000050fffff40000000000000739657a868888d8fffff4000000001e9cf1fffffffffffffffffff40000004cf5fffffff7d6c6c0c0fffffff400002af8ffffc747050000000050fffff40000a8ffffbf0400000000000050fffff40000f1ffff4d0000000000000054fffff4000cffffff390000000000000096fffff40001f7ffff7000000000000010fffffff40000bfffffed2e0000000030d2fffffffd020048fffffff9b18892c4ffffffffffff1400007cffffffffffffffffee6dffffff3d00000049cdfffffffff8a11d03edffff850000000000214655400c00000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 LIGHT NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="20")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="20")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000001570b0d9ececd8ad660d0000000000000000088af8ffffffffffffffffef5d0000000000000ec8fffffffff3dde2f8ffffffff9c0000000000adffffffa7340100000344bfffffff790000003bffffff8000000000000000029efffffc27000091ffffe604000000000000000008ebffff8f0000b6ffffaf0000000000000000000098ffffd20000b7ffffb0000000000000000000005dc8c8b9000093fffff2160000000000000000000000000000003bffffffc717000000000000000000000000000000a4ffffffee78130000000000000000000000000008b4fffffffffab6691900000000000000000000000170f0fffffffffffec45e0700000000000000000000127ee2ffffffffffffe4600000000000000000000000023e91e1ffffffffffae0900000000000000000000000000379cf9ffffffb100000000000000000000000000000022c7ffffff550000000000000000000000000000000de3ffffb8003b6c6c58000000000000000000000086ffffec0079ffffe400000000000000000000006bfffffc004effffff2d000000000000000000008affffe80005e8ffffc10600000000000000000de7ffffab000059ffffffc22a00000000000023c6ffffff4000000080fffffffec58b706f84bbfaffffff91000000000059e8fffffffffffffffffffffb84010000000000000e72cffeffffffffffeb972a00000000000000000000000f3d5255462300000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 LIGHT NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="20")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000274c57400d000000040403000000004bd2fffffffff8a2183effffc000000084ffffffffffffffffe878ffffc0000063fffffff6a06f6c98eeffffffffc00012eeffffda240000000013bdffffffc00072fffffa280000000000000fffffffc000cbffff9e0000000000000000dcffffc008faffff4a000000000000000089ffffc02dffffff18000000000000000080ffffc03ffffffd01000000000000000080ffffc04afffff500000000000000000080ffffc03ffffffd00000000000000000080ffffc02cffffff17000000000000000080ffffc007f9ffff48000000000000000089ffffc000c6ffff9c0000000000000000e8ffffc00069fffff92600000000000014ffffffc0000ce5ffffd924000000001acaffffffc0000050fefffff6a37477a2f6ffffffffc00000006dfdffffffffffffffe6a7ffffc0000000003ecafffffffff59d1680ffffbe0000000000002249533c0a000094ffffb200000000000000000000000000bfffff9000000b74010000000000000028fdffff510004b6ffa00e000000000019d1ffffe406001eeeffffe68647324787ecfffffc4400000037e3fffffffffffffffffff96600000000001184e9fffffffffffbb72e00000000000000000236657a6b50160000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 LIGHT NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="22")
  inspect(f.glyph().bitmap().rows(), content="31")
  inspect(f.glyph().bitmap().pitch(), content="22")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000013f91c8e1ebd4b36817000000000000000000000032c6fffffffffffffffff67e08000000000000000054fafffffffffef8ffffffffffc20e0000000000004dfcfffff88a2e05001257c7ffffffc5030000000015e9ffffe4290000000000000284ffffff7b0000000095fffff82a0000000000000000009ffffff81500000ff3ffff840000000000000000000013efffff79000062fffffc1900000000000000000000009affffd500009effffc10000000000000000000000004afffffe1200d5ffff8d00000000000000000000000018ffffff4800f0ffff6700000000000000000000000000f2ffff6302feffff5800000000000000000000000000e4ffff740effffff4c00000000000000000000000000d9ffff8210ffffff4c00000000000000000000000000d8ffff8407ffffff5200000000000000000000000000deffff7b00f6ffff6100000000000000000000000000ecffff6a00e3ffff7b00000000000000000000000007fcffff5800b4ffffab00000000000000000000000032ffffff2b0079ffffea05000000000000000000000071fffff002002cffffff510000000000000000000000ccffffa9000000beffffd80600000000000000000053ffffff3f0000003ffeffffa0010000000000000026e9ffffc3000000000090ffffffb620000000000155e9fffff524000000000006aefffffffdc2978ba3e3fffffff74b00000000000000038dfcffffffffffffffffffff5e000000000000000000002da4f0ffffffffffffffffeb420000000000000000000000063049543e1f80fefffffc7300000000000000000000000000000000004df0ffffffa80b0000000000000000000000000000000025d4fffff94600000000000000000000000000000000000cabf34400000000000000000000000000000000000000001f0000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 LIGHT NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="22")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="22")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000e6dbedfebd297300000000000000000000000000037e1fffffffffffffc7c00000000000000000000001ceaffffffd2c0ebffffff660000000000000000000093fffff44600000798ffffe907000000000000000000e9ffff7e0000000004deffff3b00000000000000000bffffff350000000000aeffff54000000000000000017ffffff2f0000000000ccffff3e000000000000000002f4ffff6c0000000045ffffee06000000000000000000a4ffffe009000049f2ffff6c0000000000000000000027fbffff920588fdffff980000000000000000000000007dffffffffffffff7c0000000000000000000000000002baffffffffee4f000000000000000000000000000011c0ffffffff39000000000000000000000000000029dcffffffffffcc0900000000000000000000000030edffffec8bfbffffaa0100000024d0d09e00000014e6ffffd8220066ffffff810000003fffffb600000098ffffec1e00000091ffffff57000062ffff97000006f3ffff710000000003b7fffff63500a6ffff6a000022ffffff2300000000000fd6ffffe62bf1ffff25000027ffffff1700000000000022ecffffffffffc600000008feffff44000000000000003efaffffffff4c00000000c8ffffb1000000000000000087ffffffff00000000005affffff850200000000005aeaffffffff590000000001aaffffffd983616085d8fffffffffffff7360000000009a5ffffffffffffffffffffd030d3ffffe61c00000000004eb8fbfffffffffbc158020020eaffffce0a00000000000011354e51390d00000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 LIGHT NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000254a8d7ecddbf6f120000000000000025cbffffffffffffffeb4c000000000023e6ffffffeac8ddfffffffd4f00000002c5ffffec5603000039d8fffff31d000053fffffb35000000000018e3ffff9f0000b8ffff9a0000000000000057fffff90f03f4ffff3e0000000000000004e8ffff5b22ffffff0b0000000000000000a7ffff9134fffff800000000000000000079ffffbb32fffffe02000000000000000068ffffcd1affffff26000000000000000082ffffda00e9ffff6e0000000000000000e3ffffdb009effffdd060000000000002dffffffd30035ffffffa3050000000036e6ffffffc90000a0ffffffd06c4b5ea8fdffffffffb3000009c1ffffffffffffffffc084ffff990000000581efffffffffed78049affff6e00000000000743616343060000cbffff3d0000000000000000000000001afeffee040000000000000000000000008dffff9d00000000000000000000000037f9fffd28000000000000000000000042efffff96000000000000000000043ca9ffffffcd0700000000000076bed2f5ffffffffbd1100000000000000a4ffffffffffe971050000000000000000a4f9e7d198550b0000000000000000000004000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 MONO NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
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
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 MONO NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="22")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  inspect(f.glyph().bitmap().buffer().length(), content="104")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 MONO NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="16")
  inspect(f.glyph().bitmap().rows(), content="19")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="19")
  inspect(f.glyph().bitmap().buffer().length(), content="38")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 MONO NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="19")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  inspect(f.glyph().bitmap().buffer().length(), content="104")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 MONO NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="16")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="19")
  inspect(f.glyph().bitmap().buffer().length(), content="54")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 MONO NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="21")
  inspect(f.glyph().bitmap().rows(), content="30")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="26")
  inspect(f.glyph().bitmap().buffer().length(), content="120")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 MONO NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="20")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="4")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="26")
  inspect(f.glyph().bitmap().buffer().length(), content="104")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 MONO NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
  inspect(f.glyph().bitmap().width(), content="16")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="2")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="2")
  inspect(f.glyph().bitmap_top(), content="26")
  inspect(f.glyph().bitmap().buffer().length(), content="52")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 LCD NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
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
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 LCD NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="72")
  inspect(f.glyph().bitmap().rows(), content="26")
  inspect(f.glyph().bitmap().pitch(), content="72")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000000000000000000001a4e80c8fcffffffe2ad66340500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000277bd2fffffffffffffffff1a7530900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003488dbfffffffffffffffffffff7b55d110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000033e96e6fffffffffffffffffffffffffcbf6b1a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000084ca0effffffffffffffffffffffffffffffecd7922000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c59adf4fffffffffffdc06f5895e6ffffffffffffda832f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001463bbf9fffffffffffabb631401388cdeffffffffffffe2913d0200000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e70c4fdfffffffffff7b25e0f0000002f83daffffffffffffec9f4706000000000000000000000000000000000000000000000000000000000000000000000000000000000000267ed1fffffffffffff4a8540c0000000000257dd1fffffffffffff4a9550c000000000000000000000000000000000000000000000000000000000000000000000000000000013387ddffffffffffffefa34b07000000000000002174c8fefffffffffff8b7631200000000000000000000000000000000000000000000000000000000000000000000000000034195e5ffffffffffffea9a46040000000000000000001a6bc3fdfffffffffffdc56d1b0000000000000000000000000000000000000000000000000000000000000000000000074aa2eeffffffffffffe6913d0300000000000000000000001366bafaffffffffffffcf7b270000000000000000000000000000000000000000000000000000000000000000000e58acf5ffffffffffffdf8c340100000000000000000000000000105db1f8ffffffffffffdb8931000000000000000000000000000000000000000000000000000000000000001365b9f9ffffffffffffd7832f000000000000000000000000000000000b54acf4ffffffffffffe6933f03000000000000000000000000000000000000000000000000000000001d6fc7fdffffffffffffd27a27000000000000000000000000000000000000074fa3efffffffffffffeda14d070000000000000000000000000000000000000000000000000000287cd0fffffffffffffec9751f000000000000000000000000000000000000000005469aecfffffffffffff5af570d000000000000000000000000000000000000000000000001328afcffffffffffffffffe493787878787878787878787878787878787878787878787bb5ffffffffffffffffffed7216000000000000000000000000000000000000000000033f93e7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe3731d00000000000000000000000000000000000000074da1edffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd47d2900000000000000000000000000000000000d56aef4fffffffffffffff4a0584c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c71c9ffffffffffffffffdd8b370100000000000000000000000000001564b8faffffffffffffefa34b07000000000000000000000000000000000000000000000000000000000000002174c8feffffffffffffe89941040000000000000000000000001b71c5fdffffffffffffea9a46040000000000000000000000000000000000000000000000000000000000000000001a6bc3fdfffffffffffff1a34f0900000000000000000000277bd2ffffffffffffffe6913d0300000000000000000000000000000000000000000000000000000000000000000000001366bafafffffffffffff6b15d0e00000000000000003488dbffffffffffffffdf8c340100000000000000000000000000000000000000000000000000000000000000000000000000105db1f8fffffffffffffbbf67170000000000033e96e6ffffffffffffffd7832f000000000000000000000000000000000000000000000000000000000000000000000000000000000b54acf4fffffffffffffec97522000000084b9fefffffffffffffffd27a27000000000000000000000000000000000000000000000000000000000000000000000000000000000000074fa3efffffffffffffffd6832b0000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 LCD NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="51")
  inspect(f.glyph().bitmap().rows(), content="21")
  inspect(f.glyph().bitmap().pitch(), content="52")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="20")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000006142738444b52585a58514941392b1808000000000000000000000000000000000000000000000000000000000a27507ba2c6e3f7fefffffffffffffffffffffffffffef5e3c8a77d481f070000000000000000000000000000000000062762a7daf7fffffffffffffffffffffffffffffffffffffffffffffffffffffff4d0873e0f0000000000000000000000001452a5e5fefffffffffffffff6dcb8957864554c47464b54617692b7ddf7ffffffffffffffffeeb159170000000000000000054094e7ffffffffffffffe8b164280700000000000000000000000000000b327cc9f6ffffffffffffffd17e2b000000000000003d91e5fffffffffffffdbf6b1600000000000000000000000000000000000000034094e5ffffffffffffffc7731b000000000000152a3f4040404040403b2611000000000000000000000000000000000000000000095cb0ffffffffffffffe591390000000000000000000000000000000000000000000000000000000000000000000000000000000050a4fcfffffffffffff4a04800000000000000000000000000000000000000071529394959656f757a7e83868788888888888888d8fffffffffffffffff4a048000000000000000000000000071e44749cbedcf1fdfffffffffffffffffffffffffffffffffffffffffffffffffffffffff4a0480000000000000000021b4c93d2f5fffffffffffffffffffffdf7ede1d6cec9c6c2c0c0c0c0c0c0c0fffffffffffffffffff4a048000000000000042a77cbf8fffffffffffffeebc79769472a1305000000000000000000000000000050a4fcfffffffffffff4a04800000000000954a8f2fffffffffffff3bf702504000000000000000000000000000000000000000050a4fcfffffffffffff4a0480000000000469ef1fffffffffffff3a14d050000000000000000000000000000000000000000000054c0fffffffffffffff4a048000000000c60b8ffffffffffffffe58d39000000000000000000000000000000000000000000000996fffffffffffffffff4a04800000000014ea6f7fffffffffffffdc4701e00000000000000000000000000000000000000103f92fffffffffffffffffff4a0480000000000186bbffaffffffffffffffedba6f2e0c0000000000000000000000011030619fd2f3fffffffffffffffffffffdac540200000000000c489ce7fffffffffffffffffff9e8ccb19d8f88868a929cadc4e0f5ffffffffffffffffffffffffffffffffc06814000000000000000a367cc5f0ffffffffffffffffffffffffffffffffffffffffffffffffeec9876d92d5ffffffffffffffe9913d00000000000000000000051e497dabcde7f9fffffffffffffffffffffffff8e7c8a175431d050003459dedffffffffffffffd98531000000000000000000000000000000031021323d464e5555514940321e0c0200000000000000000000000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 LCD NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="60")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="60")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000415315470889cb0c2d0d9dfe6ecefefece7e1d8ccbead9a816648260d01000000000000000000000000000000000000000000000000000823528abbe4f8fffffffffffffffffffffffffffffffffffffffffffffffffffdefce985d2a0a0000000000000000000000000000000000000e3982c8f1fffffffffffffffffffffffffaf3ece4ddd9dbe2e9f1f8fdfffffffffffffffffffffff6d89c5219000000000000000000000000001559adecfffffffffffffffff4d5a77850341b0901000000000000000003102844638ebfe7fdfffffffffffffff5c6792f060000000000000000023b90e5fffffffffffffff6ca80350900000000000000000000000000000000000000000002154e9edffefffffffffffffcce7727010000000000003d91e5ffffffffffffffe6963e04000000000000000000000000000000000000000000000000000008479febffffffffffffffe28f3b01000000000a62b6fffffffffffffffdaf5b0500000000000000000000000000000000000000000000000000000000014498eaffffffffffffffd27e26000000000b63b7fffffffffffffffdb05c0700000000000000000000000000000000000000000000000000000000001c5d9fc8c8c8c8c8c8c8b9773200000000003f93e7fffffffffffffff2b45c1600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000033b8fe4fffffffffffffffff0c78842170300000000000000000000000000000000000000000000000000000000000000000000000000000000000000001251a4e6fffffffffffffffffffeeecfa278522e130400000000000000000000000000000000000000000000000000000000000000000000000000000000082a6bb4e5fcfffffffffffffffffffffffffaead1b69c82694e3319080000000000000000000000000000000000000000000000000000000000000000000001133b70a4d3f0fefffffffffffffffffffffffffffffffffef4e0c4a5815e3a1a0700000000000000000000000000000000000000000000000000000000000000021230597ea0c4e2f6fffffffffffffffffffffffffffffffffffff9e4bf8f603110000000000000000000000000000000000000000000000000000000000000000000020d223e597591abc7e1f3fefffffffffffffffffffffffffffadeae692d09000000000000000000000000000000000000000000000000000000000000000000000000000000081a3757799cc2e5f9ffffffffffffffffffffe8b15f1e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008224e8dc7eeffffffffffffffffefa95512000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d449ce3fffffffffffffffbb864100000183b5f6c6c6c6c6c6c6c58340f00000000000000000000000000000000000000000000000000000000000000003286daffffffffffffffec984000002579cdffffffffffffffe490380000000000000000000000000000000000000000000000000000000000000000176bbffffffffffffffffca9510000074ea2f3ffffffffffffffd7802d01000000000000000000000000000000000000000000000000000000000000368addffffffffffffffe8943c00000005429ae8fffffffffffffff3c173280600000000000000000000000000000000000000000000000000000d48a0e7fffffffffffffff4ab570b00000000001a59aceaffffffffffffffffebc28b542a0e0100000000000000000000000000000000000a234d8ac6f0ffffffffffffffffe293400900000000000000000f3c80c4effffffffffffffffffffef4dfc5ae9a8b7f76706c6c6f757b8491a4bbd3ebfafffffffffffffffffff9d791430e0000000000000000000000000008295992c5e8fcfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffbe6be8446160100000000000000000000000000000000000000010e294f7292b3cfe7f7fefffffffffffffffffffffffffffffffff8ebd4b69776502a0e000000000000000000000000000000000000000000000000000000000000000000050f21313d454c52565755514b463e322312060000000000000000000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 LCD NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="54")
  inspect(f.glyph().bitmap().rows(), content="28")
  inspect(f.glyph().bitmap().pitch(), content="56")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="20")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000004142738434c545957514940331f0d020000000000000000020304040404040403010000000000000000000000000000000006204b7faed2ebfbfffffffffffffffffffffffff8e8c9a2733e1804003e92eaffffffffffffc06c140000000000000000000000000e3c84c9f3fffffffffffffffffffffffffffffffffffffffffffffffee8b56678abfbffffffffffffc06c14000000000000000000001e63b7f1fffffffffffffffffff6e1c0a089786f68676c748398b3d5eefeffffffffffffffffffffffffffc06c1400000000000000001255adeefffffffffffffffbdaa257240800000000000000000000000002133a7abdeaffffffffffffffffffffc06c14000000000000002072c6fefffffffffffffaca762804000000000000000000000000000000000000000f49cdffffffffffffffffffc06c140000000000001f77cbffffffffffffffeb9e4a07000000000000000000000000000000000000000000000040dcffffffffffffffffc06c1400000000000857affafffffffffffff19e4a050000000000000000000000000000000000000000000000002c89ffffffffffffffffc06c1400000000002d81d9ffffffffffffffc46c18000000000000000000000000000000000000000000000000002c80e3ffffffffffffffc06c1400000000003f93ebfffffffffffffdaa5201000000000000000000000000000000000000000000000000002c80dcffffffffffffffc06c1400000000004a9ef6fffffffffffff5a14900000000000000000000000000000000000000000000000000002c80dcffffffffffffffc06c1400000000003f93ebfffffffffffffda95100000000000000000000000000000000000000000000000000002c80dcffffffffffffffc06c1400000000002c80d8ffffffffffffffc36b17000000000000000000000000000000000000000000000000002c80e1ffffffffffffffc06c1400000000000755adf9fffffffffffff09c48040000000000000000000000000000000000000000000000002c89ffffffffffffffffc06c140000000000001b72c6feffffffffffffe99c4807000000000000000000000000000000000000000000000046e8ffffffffffffffffc06c14000000000000001969bdfbfffffffffffff9c874260400000000000000000000000000000000000000144fd3ffffffffffffffffffc06c1400000000000000000c469ee5fffffffffffffffad9a1562407000000000000000000000000031a488dcaf1ffffffffffffffffffffc06c14000000000000000000001450a3e6fefffffffffffffffff6e1c2a38d7e746f7077818ea2bfe1f6ffffffffffffffffffffffffffffc06c14000000000000000000000000072d6db8eafdfffffffffffffffffffffffffffffffffffffffffffffee6b490a7daffffffffffffffc06c1400000000000000000000000000000002173e73a4cae6f8fffffffffffffffffffffffef5e4c49d6e3a16032c80d4ffffffffffffffbe6a120000000000000000000000000000000000000000000311223440495255534d453c2e1b0a010000000000004094e8ffffffffffffffb25e06000000000000000000000000000000000000000000000000000000000000000000000000000000000000166bbffdffffffffffffe4903c0000000000000000000000000b366b744b16010000000000000000000000000000000000000000000003287acefdfffffffffffff4a55108000000000000000000042366b6eafffff9d6a0602c0e0000000000000000000000000000000003194593d1f9ffffffffffffffe4963e06000000000000000000001e61b9eefffffffffffffffbe6c8a3866c56473d3432353e47556b87a7ceecfefffffffffffffffcdc95441000000000000000000000000000000f3773b7e3fbfffffffffffffffffffffffffffffffffffffffffffffffffffffffff9dfad662c060000000000000000000000000000000000000001112f5b84aacee9f9fffffffffffffffffffffffffffffffffbedd5b7915f2e0d000000000000000000000000000000000000000000000000000000000000020d21364857656f777a79736b635a50432d16060000000000000000000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 LCD NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="66")
  inspect(f.glyph().bitmap().rows(), content="31")
  inspect(f.glyph().bitmap().pitch(), content="68")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000010c223f5a7691a9bcc8d0d9e1e9edebe5dcd4ccc2b39e83684e311706000000000000000000000000000000000000000000000000000000000000000000000112326295c6e9fcfffffffffffffffffffffffffffffffffffffffffffffffff6dcb07e4c21080000000000000000000000000000000000000000000000000000031f549fdbfafffffffffffffffffffffffffffffef9f6f8fcffffffffffffffffffffffffffffffeec27d360e000000000000000000000000000000000000000000134d9ee2fcfffffffffffffffff8deb48a68492e1a0c05010000030912223a57749bc7eafdfffffffffffffffff2c5752a03000000000000000000000000000000001552abe9fffffffffffffffde4ae64290b0000000000000000000000000000000000000002133e84c6f3fffffffffffffff9cb7b2d04000000000000000000000000044195e4fffffffffffffff8c8762a060000000000000000000000000000000000000000000000000000114b9fe2fffffffffffffff8ba6215000000000000000000000f58b0f3fffffffffffffed48431040000000000000000000000000000000000000000000000000000000000001357afeffffffffffffffecd792600000000000000001162b6fdfffffffffffffcc26a1900000000000000000000000000000000000000000000000000000000000000000004469aeaffffffffffffffd58129000000000000014a9eefffffffffffffffc16d160000000000000000000000000000000000000000000000000000000000000000000000034a9ef2fffffffffffffebd651200000000002981d5ffffffffffffffe18d3900000000000000000000000000000000000000000000000000000000000000000000000000186cc4fffffffffffffff39c480100000000449cf0ffffffffffffffbb67130000000000000000000000000000000000000000000000000000000000000000000000000000469ef2ffffffffffffffb7630f0000000255adfeffffffffffffffac580400000000000000000000000000000000000000000000000000000000000000000000000000003890e4ffffffffffffffc874200000000e62bafffffffffffffff8a04c0000000000000000000000000000000000000000000000000000000000000000000000000000002d85d9ffffffffffffffd6822e0000001064bcfffffffffffffff8a04c0000000000000000000000000000000000000000000000000000000000000000000000000000002c84d8ffffffffffffffd88430000000075bb3fffffffffffffffda652010000000000000000000000000000000000000000000000000000000000000000000000000000328adeffffffffffffffcf7b27000000004aa2f6ffffffffffffffb5610d00000000000000000000000000000000000000000000000000000000000000000000000000004098ecffffffffffffffbe6a1600000000378fe3ffffffffffffffcf7b27000000000000000000000000000000000000000000000000000000000000000000000000000758b0fcfffffffffffffeac5806000000000b60b4fcfffffffffffff9ab57050000000000000000000000000000000000000000000000000000000000000000000000003286deffffffffffffffd77f2b0000000000002579cdffffffffffffffea9b4305000000000000000000000000000000000000000000000000000000000000000000001e71c5fefffffffffffff09e4602000000000000002c80d8fffffffffffffff1a5510c00000000000000000000000000000000000000000000000000000000000000002178ccfefffffffffffff1a9550b000000000000000000186abef9fffffffffffffdd88a3406000000000000000000000000000000000000000000000000000000001253a7ecffffffffffffffe6933f0500000000000000000000000a3f92dffefffffffffffffcdca0521a0100000000000000000000000000000000000000000000052664b6e9fffffffffffffff5c370220000000000000000000000000000000a3e90d9fdfffffffffffffffae0b67f49200800000000000000000000000000010c28558ac2e9fdfffffffffffffff5c36d2402000000000000000000000000000000000000062663aee2fdfffffffffffffffffffdf2dcc2aea0978f8a8b919aa3b2cae3f9fffffffffffffffffffff7d5954b19010000000000000000000000000000000000000000000000031e508dc3e9fcffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc95e1900000000000000000000000000000000000000000000000000000000000000000f2d5984a4c0dcf0fcfffffffffffffffffffffffffffffffffffffffffffffffffeebc2814217010000000000000000000000000000000000000000000000000000000000000000000000061323303941495155544e463e362c1f244580bfeafefffffffffffffffffce4b4733810000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041e4d8ecbf0fffffffffffffffffff9dba8662c0b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000825599ed4f5fffffffffffffff9da9346110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c2e69abddfaf3ce8b44160000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011201f0e0000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 LCD NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="66")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="68")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "000000000000000000000000000000000e284d6d8ba8becdd7dfe8ecebe4dbd2c6b2977755301301000000000000000000000000000000000000000000000000000000000000000000000000000000000f3772b5e1f9fffffffffffffffffffffffffffffffffffffffce7bb7c3d1100000000000000000000000000000000000000000000000000000000000000000000001c5bb2eafffffffffffffffffff7e6d2c2bdc0ccdaebf8ffffffffffffffffefb9662200000000000000000000000000000000000000000000000000000000000000023f93e3fffffffffffffff4cd8a46190400000000000007215198d2faffffffffffffe99c440700000000000000000000000000000000000000000000000000000000003d95e9ffffffffffffffd17e2a0100000000000000000000000004368edeffffffffffffe78f3b000000000000000000000000000000000000000000000000000000000b5fb7ffffffffffffffe18935000000000000000000000000000000035aaefefffffffffffea85402000000000000000000000000000000000000000000000000000000176bc3ffffffffffffffdb832f0000000000000000000000000000002078ccffffffffffffea923e00000000000000000000000000000000000000000000000000000000024aa2f4fffffffffffffdc06c1b000000000000000000000000104599e1ffffffffffffeea0480600000000000000000000000000000000000000000000000000000000000850a4efffffffffffffffe0953d09000000000000031b498ccbf2fffffffffffff4c06c230000000000000000000000000000000000000000000000000000000000000000012777cdfbfffffffffffffdd992410c051e4e88c1eafdfffffffffffff7d5984d1700000000000000000000000000000000000000000000000000000000000000000000000005307dcbf8ffffffffffffffffffffffffffffffffffffffecbe7c3b100000000000000000000000000000000000000000000000000000000000000000000000000000000000022368bafdfffffffffffffffffffffffffeeec98d4f20050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000113672c0ffffffffffffffffffffffffffa139060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000092961a9dcf9fffffffffffffffffffffffffffffff6cc8233090000000000000000000000000000000000000000000000000000000000000000000000000000000a3072bfedfffffffffffffffeecc5988baddcfbffffffffffffffe5aa581a0100000000000000000000002468afd0d0d0d0d0d09e59120000000000000000000000144fa6e6fffffffffffffff9d8a15522060000032566b7edfffffffffffffff7cb8136090000000000000000003f93ebffffffffffffb6620a000000000000000000054498e7ffffffffffffffecb55f1e0200000000000000000f4191d6fbffffffffffffffe6a9571b0100000000001062b6fdffffffffffeb9743000000000000000000064da5f3fffffffffffffcc4712000000000000000000000000000032266b7ecfffffffffffffff6cd80350a00000552a6f4ffffffffffffbe6a170000000000000000002276ceffffffffffffffcf772300000000000000000000000000000000000f3e91d6fafffffffffffffee6ac572b56adf1ffffffffffffd1792500000000000000000000277bd3ffffffffffffffc36b1700000000000000000000000000000000000000032263b7ecfffffffffffffffffffffffffffffffffcc6721e0000000000000000000000085cb4feffffffffffffeb9844040000000000000000000000000000000000000000000f3e8dd6faffffffffffffffffffffffffe9a04c0e000000000000000000000000001f74c8fcffffffffffffeeb15d1600000000000000000000000000000000000000000000022887ffffffffffffffffffffffff902000000000000000000000000000000000115aaef4fffffffffffffff0c4854217020000000000000000000000000000000c2b5a8ec5eaffffffffffffffffffffffffe7aa591c010000000000000000000000000000011a58aae5fffffffffffffffffdf0d9ba9b83746a615b5b606a75859cbbd8effdfffffffffffffffffffffffffffffffffffff7ce81360a000000000000000000000000000000092d66a5d6f5fffffffffffffffffffffffffffffffffffffffffffffffffffffffffef0d09a5630428dd3f9ffffffffffffffe6ad581c010000000000000000000000000000000008244e789bb8d5eefbfffffffffffffffffffffffffffffbeed9c1a480582e10020000000002205fb4eafffffffffffffff7ce85360a0000000000000000000000000000000000000000000511202c353d464e5455514a42392f1e0d030000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 LCD NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
  inspect(f.glyph().bitmap().width(), content="54")
  inspect(f.glyph().bitmap().rows(), content="27")
  inspect(f.glyph().bitmap().pitch(), content="56")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000002133154728ea8becdd7dfe7ecece6ddd4cabfab8f6f4e2b1203000000000000000000000000000000000000000000000000000006255798cbecfefffffffffffffffffffffffffffffffffffffffffeebc4884c1e040000000000000000000000000000000000000002235fb3e6fefffffffffffffffffff8eadbcfc8c8ceddedfafffffffffffffffffffde1a04f17000000000000000000000000000000022574c5f6ffffffffffffffecc68b562c0f0300000000000005163969a7d8f7fffffffffffffff3bc641d0000000000000000000000000d53a7f1fffffffffffffbd285350b000000000000000000000000000000011850a6e3ffffffffffffffe79f4b0b0000000000000000001164b8faffffffffffffe79a460700000000000000000000000000000000000000001257abf0fffffffffffff9b45c0f00000000000000034ca4f4ffffffffffffe8923e0100000000000000000000000000000000000000000000044098e8fffffffffffff9af5b0d0000000000002276ceffffffffffffffb75f0b0000000000000000000000000000000000000000000000000453a7f6ffffffffffffe5913d0000000000003488e0fffffffffffff8a44c00000000000000000000000000000000000000000000000000002579cdffffffffffffffbb670f00000000003286defffffffffffffeac5402000000000000000000000000000000000000000000000000001368e8ffffffffffffffcd792100000000001a6ec6ffffffffffffffd27a26000000000000000000000000000000000000000000000000000c82ffffffffffffffffda862e0000000000003d95e9fffffffffffffec26e1c0000000000000000000000000000000000000000000000023be3ffffffffffffffffdb872f000000000000064a9eecffffffffffffffdd8f380600000000000000000000000000000000000000072d78d4ffffffffffffffffffd37f2700000000000000033588ddfffffffffffffffddea3571e0500000000000000000000000001113671b7e6fdffffffffffffffffffffc9751d0000000000000000000e4da0e5ffffffffffffffffffeed0a9856c5a504b4b525e7089a8ccecfdffffffffffffffffffffffffffffb35f080000000000000000000000093077c1efffffffffffffffffffffffffffffffffffffffffffffffffecc07b5884cbffffffffffffed9945000000000000000000000000000000051d4a81b0d7effcfffffffffffffffffffffffffbedd3a878441a0400469aedffffffffffffc26e1a000000000000000000000000000000000000000000071830434f58616869635b51432e16060000000000001f77cbffffffffffffe9913d000000000000000000000000000000000000000000000000000000000000000000000000000000000000001a6cc4feffffffffffee9e4604000000000000000000000000000000000000000000000000000000000000000000000000000000000005398ddaffffffffffffeb9d4905000000000000000000000000000000000000000000000000000000000000000000000000000000000d3785cff9fffffffffffdd079280100000000000000000000000000000000000000000000000000000000000000000000000000041a4280c3effffffffffffffddd96440c0000000000000000000000000000000000000000000000000000000000000000040f233c5a7fa9d5f3fffffffffffffffff7cd8031070000000000000000000000000000000000000000000000003976b3bbbec2c9d2ddeaf5fdfffffffffffffffffffffffee9bd7c391100000000000000000000000000000000000000000000000000000050a4f8fffffffffffffffffffffffffffffffbe9c89c71421b0500000000000000000000000000000000000000000000000000000000000050a4f7fdf9f3ede7e1dad1c2ad98826b553c1f0b0000000000000000000000000000000000000000000000000000000000000000000000000204040100000000000000000000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 LCD_V NO_HINTING 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
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
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 LCD_V NO_HINTING 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="24")
  inspect(f.glyph().bitmap().rows(), content="81")
  inspect(f.glyph().bitmap().pitch(), content="24")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="26")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000035876513000000000000000000000000000000000000000080ffe2340000000000000000000000000000000000000002d4ffff60000000000000000000000000000000000000000ff6ffff870000000000000000000000000000000000000027ffffffa70000000000000000000000000000000000000047ffffffc70000000000000000000000000000000000000068ffffffe50300000000000000000000000000000000000088fffffff711000000000000000000000000000000000000a8ffffffff29000000000000000000000000000000000000caffffffff4b000000000000000000000000000000000003e6ffffffff6b000000000000000000000000000000000011f8ffffffff8b00000000000000000000000000000000002bffffffffffac00000000000000000000000000000000004cffffffffffcd00000000000000000000000000000000006cffffd2ffffe804000000000000000000000000000000008dffff9af7fff91400000000000000000000000000000000adffff6fe6ffff2f00000000000000000000000000000000cdffff4dcaffff4f00000000000000000000000000000005e9ffff2daaffff7000000000000000000000000000000014f9fffa148cffff910000000000000000000000000000002effffeb056dffffb100000000000000000000000000000050ffffd0004dffffd200000000000000000000000000000070ffffb2002fffffec06000000000000000000000000000090ffff930015fbfffb170000000000000000000000000000b2ffff730005ebffff340000000000000000000000000000d1ffff540000d1ffff550000000000000000000000000006ebffff360000b3ffff750000000000000000000000000017fbfffc19000093ffff960000000000000000000000000033ffffef07000074ffffb70000000000000000000000000053ffffd900000056ffffd60000000000000000000000000075ffffb900000036ffffef0800000000000000000000000095ffff9a0000001afdfffd1b000000000000000000000000b5ffff7c00000008f0ffff39000000000000000000000000d5ffff5c00000000d8ffff5a000000000000000000000007eeffff3d00000000baffff7b000000000000000000000019fcfffe20000000009cffff9b000000000000000000000038fffff30b000000007cffffbc000000000000000000000058ffffdf01000000005dffffdb000000000000000000000078ffffc100000000003efffff20a0000000000000000000099ffffa100000000001ffefffe2000000000000000000000b9ffff8300000000000bf4ffff3f00000000000000000000d8ffff64000000000001e0ffff5f00000000000000000009f0ffff44000000000000c1ffff800000000000000000001dfdffff27000000000000a3ffffa10000000000000000003bfffff80f00000000000084ffffc10000000000000000005cffffe50200000000000064ffffe00100000000000000007cffffc90000000000000046fffff50d00000000000000009cffffaa0000000000000027ffffff240000000000000000c7ffffae2424242424242433ffffff470000000000000001fcffffe4787878787878787bffffff72000000000000000bffffffffccccccccccccccccffffff9b0000000000000020ffffffffffffffffffffffffffffffc2000000000000003fffffffffffffffffffffffffffffffe3000000000000005fffffffffffffffffffffffffffffffff0200000000000081ffffffffffffffffffffffffffffffff10000000000000a1ffffffffffffffffffffffffffffffff29000000000000c1fffffff8f8f8f8f8f8f8f8f8ffffffff49000000000001e0ffffffa0a0a0a0a0a0a0a0a0a5ffffff6a00000000000df4ffffa04c4c4c4c4c4c4c4c4c4cffffff8b000000000023feffff3600000000000000000000b3ffffab000000000044fffffc190000000000000000000093ffffcc000000000064ffffef070000000000000000000074ffffe8040000000084ffffd8000000000000000000000056fffff91300000000a5ffffb9000000000000000000000036ffffff2e00000000c5ffff9a00000000000000000000001afdffff4f00000002e2ffff7b000000000000000000000008f0ffff6f0000000ff6ffff5b000000000000000000000000d8ffff9000000027ffffff3d000000000000000000000000baffffb100000047fffffe200000000000000000000000009bffffd000000068fffff30b0000000000000000000000007bffffeb06000088ffffdf010000000000000000000000005dfffffb170000a8ffffc1000000000000000000000000003effffff330000caffffa1000000000000000000000000001ffeffff540003e6ffff83000000000000000000000000000bf4ffff750011f8ffff640000000000000000000000000001e0ffff95002bffffff440000000000000000000000000000c1ffffb6004bffffff270000000000000000000000000000a3ffffd6003dacacab0f000000000000000000000000000063acac9a00235454530200000000000000000000000000002b54545000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 LCD_V NO_HINTING 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="63")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="20")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000050100000000000000000000000000144458513908000000000000000000001d6698aca58d520b00000000000000000f72bef0fffbe5aa53000000000000000050c6fefffffffff5a71f00000000000015a4fcffffffffffffef6700000000000054ecffffffffffffffffbf130000000006a7fffffffffffffffffff43e0000000027e5fffffffff3fcffffffff810000000061fefffff7b89ba8e4ffffffc405000000a5ffffffb864475492f7ffffee17000008d8ffffe9641000033ec9ffffff3400001ff6ffffb215000000027dffffff5a000040ffffff64000000000032f6ffff7e000062fffff62700000000000cddffff9f00007effffdd06000000000000b8ffffb8000091ffffbf0000000000000094ffffc7000090ecec9c000000000000007affffd100005e94945c0000000000000067ffffdb00002a404026000000000000005cffffe50000000000000000000000000055ffffed0000000000000000000000000051fffff20000000000000000000000000050fffff40000000000000000000000000050fffff40000000000000000122632343484fffff40000000000000739657a868888d8fffff40000000000064d8db9cedadcdcfffffff4000000000048a5e5fffffffffffffffff4000000001e9cf1fffffffffffffffffff40000000067e9fffffffffffffffffffff400000017bffffffffffffffffffffffff40000004cf5fffffff7d6c6c0c0fffffff400000098ffffffeba982726c6cbcfffff400000cd9fffff79b512a1a141464fffff400002af8ffffc747050000000050fffff4000057fffffd7807000000000050fffff4000085ffffe72800000000000050fffff40000a8ffffbf0400000000000050fffff40000c6ffff8e0000000000000050fffff40000e0ffff650000000000000050fffff40000f1ffff4d0000000000000054fffff40002fbffff3d0000000000000060fffff40007ffffff370000000000000076fffff4000cffffff390000000000000096fffff4000bffffff4100000000000000bffffff40006fdffff5500000000000000f6fffff40001f7ffff7000000000000010fffffff40000edffff980000000000003dfffffff60000daffffc90600000000058ffffffffa0000bfffffed2e0000000030d2fffffffd02009dfffffe7b0c00001a83faffffffff070075ffffffcd5d343e70d6ffffffffff0d0048fffffff9b18892c4ffffffffffff140021edfffffff8dce6feffffffffffff1e0006c2ffffffffffffffffffc2ffffff2c00007cffffffffffffffffee6dffffff3d000039e4ffffffffffffffb72fffffff5300000d9dffffffffffffe9600cfbffff6c00000049cdfffffffff8a11d03edffff850000001179cdf2feecb14d000099acac620000000021759aa994590b0000465454330000000000214655400c000000000000000000000000000002000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 LCD_V NO_HINTING 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="20")
  inspect(f.glyph().bitmap().rows(), content="84")
  inspect(f.glyph().bitmap().pitch(), content="20")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000092d40402c07000000000000000000000000001e5c85989884591600000000000000000000001570b0d9ececd8ad660d0000000000000000000761c4fafffffffffaba5100000000000000000038b9fefffffffffffffca91b00000000000000088af8ffffffffffffffffef5d0000000000000033d6ffffffffffffffffffffb0140000000000007cfdffffffffffffffffffffed4e00000000000ec8fffffffff3dde2f8ffffffff9c000000000035f1ffffffdfa0898ea8ebffffffdc110000000071ffffffe9884831365098f3fffff93b00000000adffffffa7340100000344bfffffff7900000008daffffee530000000000046df7ffffb80000001df6ffffc11100000000000022d5ffffe60c00003bffffff8000000000000000029efffffc2700005bffffff4300000000000000005cffffff4c000079fffff817000000000000000026faffff71000091ffffe604000000000000000008ebffff8f0000a2ffffce00000000000000000000d0ffffaa0000adffffba00000000000000000000afffffc00000b6ffffaf0000000000000000000098ffffd20000bcffffa80000000000000000000088ffffdf0000bcffffa7000000000000000000007effffe90000b7ffffb0000000000000000000005dc8c8b90000afffffc2000000000000000000003474746c0000a4ffffdd020000000000000000000c1c1c1a000093fffff2160000000000000000000000000000007bfffffe3f0000000000000000000000000000005dffffff870000000000000000000000000000003bffffffc71700000000000000000000000000001cf5fffff25a000000000000000000000000000007d6ffffffb1270000000000000000000000000000a4ffffffee78130000000000000000000000000063ffffffffcc620f0000000000000000000000002ae9fffffffdba6217000000000000000000000008b4fffffffffab66919000000000000000000000062f6fffffffffabd6c1b0000000000000000000020c3fffffffffffdc470130000000000000000000170f0fffffffffffec45e0700000000000000000026b0fffffffffffffdb23f0000000000000000000158d1fffffffffffff79818000000000000000000127ee2ffffffffffffe460000000000000000000002a90e7ffffffffffffb41a000000000000000000003892e3fffffffffff35a00000000000000000000023e91e1ffffffffffae0900000000000000000000023d8ee1ffffffffe82c000000000000000000000001368be8ffffffff6b00000000000000000000000000379cf9ffffffb1000000000000000000000000000248c6ffffffe30d00000000000000000000000000076ff4fffffc2a000000000000000000000000000022c7ffffff5500000000000000000000000000000180ffffff7d00000000000000000000000000000034f9ffff9e0000000000000000000000000000000de3ffffb800000000000000000000000000000000c2ffffcf000d18181300000000000000000000009effffe1003b6c6c58000000000000000000000086ffffec0066c0c0a0000000000000000000000076fffff40083ffffdb00000000000000000000006cfffffb0079ffffe400000000000000000000006bfffffc006ffffff104000000000000000000006ffffff90062fffffa13000000000000000000007bfffff1004effffff2d000000000000000000008affffe80031ffffff5400000000000000000000a3ffffdb0015f9ffff8800000000000000000000c6ffffc60005e8ffffc10600000000000000000de7ffffab0000c6ffffe92a000000000000000036faffff8d000093fffffe7502000000000000007fffffff69000059ffffffc22a00000000000023c6ffffff40000026f3fffff27c1a000000001171f1fffff11b000008c8ffffffd271371c1b3067c8ffffffce0400000080fffffffec58b706f84bbfaffffff910000000039ebffffffffdfc4c3d8fdfffffff84c000000000badffffffffffffffffffffffffd117000000000059e8fffffffffffffffffffffb840100000000001aa3feffffffffffffffffffd037000000000000004bc6ffffffffffffffffe67a06000000000000000e72cffeffffffffffeb972a0000000000000000001f7bbae9fcfef2cf98430100000000000000000000236291a6a99a7740030000000000000000000000000f3d52554623000000000000000000000000000000000102000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 LCD_V NO_HINTING 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="84")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="20")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "0000000000000000040000000000000000000000000000274c57400d0000000404030000000000267ba0ab94590c001358584200000000107ed3f7ffecb14e0028b0b084000000004bd2fffffffff8a2183effffc00000000f9fffffffffffffe95644ffffc00000003de6ffffffffffffffac51ffffc000000084ffffffffffffffffe878ffffc000000cc8fffffffffffffffffeb8ffffc0000030f2ffffffedc3c0e9ffffffffffc0000063fffffff6a06f6c98eeffffffffc000009bffffffc34c1b1844aeffffffffc00003cdfffff96f0600000256edffffffc00012eeffffda240000000013bdffffffc0002dfeffffa403000000000077ffffffc00051ffffff5d00000000000032ffffffc00072fffffa280000000000000fffffffc00093ffffe60a00000000000000ffffffc000b2ffffc40000000000000000ffffffc000cbffff9e0000000000000000dcffffc000e0ffff7f0000000000000000b7ffffc001f0ffff6200000000000000009affffc008faffff4a000000000000000089ffffc014ffffff36000000000000000081ffffc023ffffff26000000000000000080ffffc02dffffff18000000000000000080ffffc035ffffff0c000000000000000080ffffc03affffff04000000000000000080ffffc03ffffffd01000000000000000080ffffc044fffffa00000000000000000080ffffc048fffff600000000000000000080ffffc04afffff500000000000000000080ffffc048fffff600000000000000000080ffffc044fffffa00000000000000000080ffffc03ffffffd00000000000000000080ffffc03affffff04000000000000000080ffffc034ffffff0b000000000000000080ffffc02cffffff17000000000000000080ffffc022ffffff25000000000000000080ffffc012ffffff35000000000000000080ffffc007f9ffff48000000000000000089ffffc000edffff6000000000000000009dffffc000dbffff7d0000000000000000c0ffffc000c6ffff9c0000000000000000e8ffffc000aaffffc10000000000000000ffffffc0008affffe50900000000000002ffffffc00069fffff92600000000000014ffffffc00047ffffff5b0000000000003effffffc00024faffffa202000000000089ffffffc0000ce5ffffd924000000001acaffffffc00000befffff86e0700000665f5ffffffc0000088ffffffc34f20234ebcffffffffc0000050fefffff6a37477a2f6ffffffffc0000023e9fffffff0c8cbefffffffffffc0000006b7fffffffffffffffffee2ffffc00000006dfdffffffffffffffe6a7ffffc00000002edcffffffffffffffa986ffffc00000000890feffffffffffe65280ffffbf000000003ecafffffffff59d1680ffffbe000000000b76cef4fde8ac490084ffffbb000000000020769da790540a008bffffb70000000000002249533c0a000094ffffb2000000000000000002000000009cffffaa00000000000000000000000000aaffff9e00000000000000000000000000bfffff9000000000000000000000000000dbffff800000002700000000000000000af2ffff6900000b74010000000000000028fdffff51000030c8170000000000000059ffffff34000070f94f000000000000009afffff8180004b6ffa00e000000000019d1ffffe406001ae5ffde48000000000059f3ffffbc000022fdffffa03200000033b0ffffff8100001eeeffffe68647324787ecfffffc44000008c5ffffffda9b869bdbffffffe6190000007afffffffff2def2ffffffffb40200000037e3fffffffffffffffffff966000000000ca1ffffffffffffffffffcd2800000000004ad6fffffffffffffff97c0300000000001184e9fffffffffffbb72e000000000000003098e2fffffffabe63050000000000000001408ab9cebfa466110000000000000000000236657a6b501600000000000000000000000011261701000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 LCD_V NO_HINTING 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="22")
  inspect(f.glyph().bitmap().rows(), content="96")
  inspect(f.glyph().bitmap().pitch(), content="22")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011c353f280c000000000000000000000000000000023d748d97805f1700000000000000000000000000013f91c8e1ebd4b368170000000000000000000000002293e3fffffffffbbc6102000000000000000000000573e9fffffffffffffdb92d0000000000000000000032c6fffffffffffffffff67e0800000000000000000180f8ffffffffffffffffffcf2f00000000000000001dd3fffffffffffffffffffffc77000000000000000054fafffffffffef8ffffffffffc20e00000000000004a4ffffffffdaafa4bef6ffffffef390000000000001fe0ffffffda82574c66abf8ffffff800000000000004dfcfffff88a2e05001257c7ffffffc503000000000089ffffffc936000000000c75f5ffffee190000000002c2fffffd7603000000000025c9fffffe430000000015e9ffffe4290000000000000284ffffff7b0000000039fdffffb104000000000000003af5ffffb2000000006bffffff6500000000000000000fd1ffffe00500000095fffff82a0000000000000000009ffffff815000000baffffdf0a00000000000000000067ffffff31000002ddffffb40000000000000000000034fdffff5600000ff3ffff840000000000000000000013efffff79000028feffff5a0000000000000000000002d8ffff9c000048ffffff350000000000000000000000b7ffffbc000062fffffc1900000000000000000000009affffd5000077ffffef0700000000000000000000007dffffe900008bffffd900000000000000000000000060fffff706009effffc10000000000000000000000004afffffe1200b1ffffae00000000000000000000000039ffffff2400c4ffff9e00000000000000000000000028ffffff3800d5ffff8d00000000000000000000000018ffffff4800e1ffff7d0000000000000000000000000bfdffff5500eaffff7000000000000000000000000002f8ffff5d00f0ffff6700000000000000000000000000f2ffff6300f5ffff6100000000000000000000000000eeffff6800faffff5c00000000000000000000000000e9ffff6e02feffff5800000000000000000000000000e4ffff7406ffffff5300000000000000000000000000e0ffff790bffffff4f00000000000000000000000000dbffff7f0effffff4c00000000000000000000000000d9ffff820fffffff4c00000000000000000000000000d8ffff8310ffffff4c00000000000000000000000000d8ffff8410ffffff4c00000000000000000000000000d8ffff840fffffff4c00000000000000000000000000d8ffff830cffffff4e00000000000000000000000000daffff8007ffffff5200000000000000000000000000deffff7b03feffff5700000000000000000000000000e3ffff7500fbffff5c00000000000000000000000000e8ffff7000f6ffff6100000000000000000000000000ecffff6a00f0ffff6500000000000000000000000000f0ffff6500eaffff6e00000000000000000000000001f7ffff5f00e3ffff7b00000000000000000000000007fcffff5800d7ffff8a00000000000000000000000013ffffff4d00c7ffff9b00000000000000000000000023ffffff3d00b4ffffab00000000000000000000000032ffffff2b00a0ffffbd00000000000000000000000042ffffff18008cffffd400000000000000000000000058fffffb090079ffffea05000000000000000000000071fffff0020064fffffa1400000000000000000000008fffffdf00004bffffff300000000000000000000000adffffc600002cffffff510000000000000000000000ccffffa9000012f6ffff7a000000000000000000000be7ffff87000003dfffffab0000000000000000000027faffff62000000beffffd80600000000000000000053ffffff3f00000099fffff42000000000000000000087fffffd1f0000006effffff58000000000000000006c1ffffe9090000003ffeffffa0010000000000000026e9ffffc30000000019edffffda1c0000000000000063feffff8e0000000003c6fffffa6400000000000014b4ffffff52000000000090ffffffb620000000000155e9fffff524000000000054feffffef721700000139acffffffd408000000000022e4ffffffc96e43374f91ffffffff9300000000000006aefffffffdc2978ba3e3fffffff74b000000000000005ffcfffffffeebdff6ffffffffd2170000000000000020d9ffffffffffffffffffffff8c0000000000000000038dfcffffffffffffffffffff5e0000000000000000003dd2ffffffffffffffffffff6e000000000000000000087ef1ffffffffffffffffffb40f0000000000000000002da4f0ffffffffffffffffeb420000000000000000000350a3dcf5fdeaffffffffff9205000000000000000000074b849da89290f4ffffffdb2b00000000000000000000063049543e1f80fefffffc730000000000000000000000000002000034e2ffffffc217000000000000000000000000000000089ffffffff355000000000000000000000000000000004df0ffffffa80b00000000000000000000000000000015beffffffe434000000000000000000000000000000006afaffffff4f0000000000000000000000000000000025d4fffff94600000000000000000000000000000000038dffffd61c00000000000000000000000000000000003be6ff920100000000000000000000000000000000000cabf3440000000000000000000000000000000000000058bf130000000000000000000000000000000000000019670000000000000000000000000000000000000000001f000000000000000000000000000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 LCD_V NO_HINTING 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="22")
  inspect(f.glyph().bitmap().rows(), content="84")
  inspect(f.glyph().bitmap().pitch(), content="22")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000014333f2603000000000000000000000000000000001b6a8b977e430100000000000000000000000000000e6dbedfebd29730000000000000000000000000000045c1feffffffe781060000000000000000000000000c9bfdffffffffffd73300000000000000000000000037e1fffffffffffffc7c00000000000000000000000077feffffffffffffffc90b0000000000000000000004c1fffffffffffffffff52f000000000000000000001ceaffffffd2c0ebffffff660000000000000000000041feffffe07e6c9ffcffff9d000000000000000000006fffffff99261447d6ffffcc0000000000000000000093fffff44600000798ffffe907000000000000000000b3ffffd7110000004cfffffa17000000000000000000d3ffffa9000000001bf1ffff2b000000000000000000e9ffff7e0000000004deffff3b000000000000000000f7ffff5d0000000000c5ffff46000000000000000004fdffff450000000000b4ffff5000000000000000000bffffff350000000000aeffff54000000000000000014ffffff2c0000000000b1ffff52000000000000000019ffffff2a0000000000bcffff4a000000000000000017ffffff2f0000000000ccffff3e000000000000000010ffffff3c0000000004e2ffff2c000000000000000007feffff510000000019f6fffd15000000000000000002f4ffff6c0000000045ffffee06000000000000000000e0ffff8f0000000087ffffcf00000000000000000000c3ffffba00000013caffffa100000000000000000000a4ffffe009000049f2ffff6c000000000000000000007ffffff72400089bfffff9370000000000000000000052ffffff560038e0ffffd8100000000000000000000027fbffff920588fdffff9800000000000000000000000ce4ffffca36d4fffff44c000000000000000000000000b7fffff4a7fcffffc7150000000000000000000000007dffffffffffffff7c0000000000000000000000000042fdffffffffffe5330000000000000000000000000017e7ffffffffffa2090000000000000000000000000002baffffffffee4f00000000000000000000000000000092ffffffffb71500000000000000000000000000000093ffffffff6400000000000000000000000000000011c0ffffffff3900000000000000000000000000000046ebffffffff4b0000000000000000000000000000059affffffffff90000000000000000000000000000029dcffffffffffcc09000000000000000000000000006cfcfffffffffff12a000000000524241b000000000abeffffffffffffff6500000000147c7c5f0000000030edffffec8bfbffffaa0100000024d0d09e000000006effffffb729e0ffffdd1300000031ffffbf00000001b8fffffa6301abfffffa4000000039ffffba00000014e6ffffd8220066ffffff810000003fffffb600000039fcffff9f03002df3ffffc105000046ffffaf0000006cfffffd5200000accffffed23000052ffffa400000098ffffec1e00000091ffffff57000062ffff97000000bdffffcb040000004dfdffff9c000078ffff8a000001ddffff9b000000001be5ffffd60f008fffff7b000006f3ffff710000000003b7fffff63500a6ffff6a00000efeffff4e000000000075ffffff7200beffff55000019ffffff35000000000034f6ffffb805dbffff3c000022ffffff2300000000000fd6ffffe62bf1ffff2500002affffff180000000000009efffffd75fefff91000002cffffff1400000000000056feffffe3ffffe604000027ffffff1700000000000022ecffffffffffc60000001dffffff2000000000000006c2ffffffffffa100000012ffffff2f000000000000007fffffffffff7800000008feffff44000000000000003efaffffffff4c00000002f8ffff600000000000000014deffffffff2400000000e5ffff840000000000000000adffffffff0800000000c8ffffb1000000000000000087ffffffff0000000000a5ffffda0c000000000000008dffffffff06000000007ffffff83800000000000017bfffffffff24000000005affffff850200000000005aeaffffffff590000000031faffffcc2f000000002daeffffffffff9d0000000012ddfffff8872f0d0c3185efffffffffffd70f00000001aaffffffd983616085d8fffffffffffff7360000000066ffffffffd7b5b4d9ffffffffffffffff73000000002ae7fffffffffffffffffffffa95f5ffffb90300000009a5ffffffffffffffffffffd030d3ffffe61c0000000052eafffffffffffffffff17f039afffffd4b0000000012a2fafffffffffffffeac2c0053feffff9200000000004eb8fbfffffffffbc158020020eaffffce0a000000001064b9e1f9fbe5b56d1100000596acac9e0a0000000000126189a2a58d5d1600000000405454530a00000000000011354e51390d0000000000000000000000000000000000000001000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 LCD_V NO_HINTING 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
  inspect(f.glyph().bitmap().width(), content="17")
  inspect(f.glyph().bitmap().rows(), content="84")
  inspect(f.glyph().bitmap().pitch(), content="17")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="1")
  inspect(f.glyph().bitmap_top(), content="27")
  try! assert_buffer_hex(f.glyph().bitmap().buffer(), "00000000000000000000000000000000000000000000000000000000000000000000000000000000082b40311300000000000000000000000b548398896b1d0000000000000000000254a8d7ecddbf6f12000000000000000027a8f4ffffffffc352000000000000000579f4fffffffffffdaa1300000000000025cbffffffffffffffeb4c00000000000061f9ffffffffffffffff9e030000000006b2ffffffffffffffffffe21e0000000023e6ffffffeac8ddfffffffd4f0000000052feffffee9a7489deffffff930000000091ffffffaa421c318dfbffffd006000002c5ffffec5603000039d8fffff31d000011ebffffbf14000000079affffff4100002efeffff76000000000049faffff71000053fffffb35000000000018e3ffff9f000077ffffe70f000000000001bbffffc700009affffc30000000000000085ffffe80300b8ffff9a0000000000000057fffff90f00d0ffff76000000000000002effffff2400e4ffff570000000000000012f9ffff4203f4ffff3e0000000000000004e8ffff5b0cfdffff2a0000000000000000d1ffff7018ffffff180000000000000000b9ffff8122ffffff0b0000000000000000a7ffff9129fffffe03000000000000000095ffffa02ffffffb00000000000000000084ffffaf34fffff800000000000000000079ffffbb37fffff700000000000000000073ffffc336fffffa0000000000000000006dffffc832fffffe02000000000000000068ffffcd2cffffff09000000000000000068ffffd225ffffff1600000000000000006fffffd71affffff26000000000000000082ffffda0efeffff3900000000000000009bffffdb04f6ffff520000000000000000bdffffdb00e9ffff6e0000000000000000e3ffffdb00d5ffff8e0000000000000000ffffffd900bbffffb7000000000000000bffffffd6009effffdd060000000000002dffffffd3007efffff52300000000000069ffffffd1005bffffff5a000000000009b5ffffffce0035ffffffa3050000000036e6ffffffc90016f1ffffdb2c0000000a87feffffffc40003d1fffffb8218000b54d6ffffffffbb0000a0ffffffd06c4b5ea8fdffffffffb3000063fffffffdc09fb2f1ffffe4ffffab00002beefffffffff7ffffffefa8ffffa2000009c1ffffffffffffffffc084ffff9900000073fbfffffffffffff97180ffff8d0000002dd1ffffffffffffca2a8dffff7d0000000581efffffffffed78049affff6e0000000031a3efffffefa02a00a7ffff5e00000000044b97b5b797480200b7ffff4e00000000000743616343060000cbffff3d000000000000000c0f00000000e1ffff2700000000000000000000000009f5fffb120000000000000000000000001afeffee0400000000000000000000000037ffffd8000000000000000000000000005fffffbc000000000000000000000000008dffff9d00000000000000000000000000bbffff790000000000000000000000000ee3ffff4f00000000000000000000000037f9fffd280000000000000000000000007bffffee0e00000000000000000000000cc3ffffcb01000000000000000000000042efffff9600000000000000000000001196ffffff59000000000000000000000255e2fffff124000000000000000000043ca9ffffffcd070000000000000712264e90ecffffff8a00000000000000406a7ea6e5ffffffef400000000000000076bed2f5ffffffffbd1100000000000000a4fffffffffffffa6f0000000000000000a4ffffffffffffc4270000000000000000a4ffffffffffe971050000000000000000a4fffffffff8a021000000000000000000a4ffffffeaa94800000000000000000000a4f9e7d198550b0000000000000000000072a6937d440800000000000000000000003a4e3b2501000000000000000000000000040000000000000000000000000000000000000000000000000000000000")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 NORMAL DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 NORMAL DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 NORMAL DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 NORMAL DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 NORMAL DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 NORMAL DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 NORMAL DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 NORMAL DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Normal)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 LIGHT DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 LIGHT DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 LIGHT DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 LIGHT DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 LIGHT DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 LIGHT DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 LIGHT DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 LIGHT DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Light)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Gray")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 MONO DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 MONO DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 MONO DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 MONO DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 MONO DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 MONO DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 MONO DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 MONO DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Mono)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Mono")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 LCD DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 LCD DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 LCD DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 LCD DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 LCD DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 LCD DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 LCD DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 LCD DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=Lcd)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="Lcd")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 LCD_V DEFAULT 36ppem char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 LCD_V DEFAULT 36ppem char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 LCD_V DEFAULT 36ppem char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 55 LCD_V DEFAULT 36ppem char 83" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 83U)
  inspect(gid, content="55")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 75 LCD_V DEFAULT 36ppem char 103" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 103U)
  inspect(gid, content="75")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 53 LCD_V DEFAULT 36ppem char 81" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 81U)
  inspect(gid, content="53")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 10 LCD_V DEFAULT 36ppem char 38" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 38U)
  inspect(gid, content="10")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 29 LCD_V DEFAULT 36ppem char 57" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 36U)
  let gid = @freetype.get_char_index(f, 57U)
  inspect(gid, content="29")
  try! @freetype.load_glyph(f, gid, load_flags=0)
  try! @freetype.render_glyph(f, mode=LcdV)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().pixel_mode(), content="LcdV")
}

///|
test "parity/Roboto[wdth,wght].ttf: hinted outline DEFAULT 16ppem" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 5U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="16")
  inspect(f.glyph().metrics().width(), content="128")
  inspect(f.glyph().metrics().height(), content="768")
  inspect(f.glyph().metrics().hori_advance(), content="256")
}

///|
test "parity/Roboto[wdth,wght].ttf: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 5U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="264")
}

///|
test "parity/Roboto[wdth,wght].ttf: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 5U, load_flags=@base.LOAD_FORCE_AUTOHINT)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="320")
}

///|
test "parity/Roboto[wdth,wght].ttf: variation state" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  inspect(f.has_multiple_masters(), content="true")
  inspect(f.is_variation(), content="false")
  try! @freetype.set_var_design_coordinates(
    f,
    [
      (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
      (@fixed.Fixed::from_raw(4915200L), 0x77647468U),
    ],
  )
  inspect(f.is_variation(), content="true")
}

///|
test "parity/Roboto[wdth,wght].ttf: varied 65 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_var_design_coordinates(
    f,
    [
      (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
      (@fixed.Fixed::from_raw(4915200L), 0x77647468U),
    ],
  )
  let gid = @freetype.get_char_index(f, 65U)
  let r = try? @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(gid, content="37")
  inspect(f.glyph().outline().n_points(), content="14")
  inspect(f.glyph().outline().n_contours(), content="3")
  inspect(f.glyph().metrics().hori_advance(), content="1240")
  inspect(f.glyph().metrics().width(), content="1219")
  inspect(f.glyph().metrics().hori_bearing_x(), content="10")
  inspect(f.glyph().outline().points()[0].x(), content="649")
  inspect(f.glyph().outline().points()[0].y(), content="1150")
  inspect(f.glyph().outline().points()[1].x(), content="378")
  inspect(f.glyph().outline().points()[1].y(), content="0")
  inspect(f.glyph().outline().points()[2].x(), content="10")
  inspect(f.glyph().outline().points()[2].y(), content="0")
  inspect(f.glyph().outline().points()[3].x(), content="459")
  inspect(f.glyph().outline().points()[3].y(), content="1456")
}

///|
test "parity/Roboto[wdth,wght].ttf: varied 97 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_var_design_coordinates(
    f,
    [
      (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
      (@fixed.Fixed::from_raw(4915200L), 0x77647468U),
    ],
  )
  let gid = @freetype.get_char_index(f, 97U)
  let r = try? @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(gid, content="69")
  inspect(f.glyph().outline().n_points(), content="59")
  inspect(f.glyph().outline().n_contours(), content="2")
  inspect(f.glyph().metrics().hori_advance(), content="955")
  inspect(f.glyph().metrics().width(), content="862")
  inspect(f.glyph().metrics().hori_bearing_x(), content="51")
  inspect(f.glyph().outline().points()[0].x(), content="541")
  inspect(f.glyph().outline().points()[0].y(), content="272")
  inspect(f.glyph().outline().points()[1].x(), content="541")
  inspect(f.glyph().outline().points()[1].y(), content="748")
  inspect(f.glyph().outline().points()[2].x(), content="541")
  inspect(f.glyph().outline().points()[2].y(), content="794")
  inspect(f.glyph().outline().points()[3].x(), content="527")
  inspect(f.glyph().outline().points()[3].y(), content="843")
}

///|
test "parity/Roboto[wdth,wght].ttf: varied outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_var_design_coordinates(
    f,
    [
      (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
      (@fixed.Fixed::from_raw(4915200L), 0x77647468U),
    ],
  )
  let gid = @freetype.get_char_index(f, 65U)
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="620")
  inspect(f.glyph().metrics().width(), content="610")
  inspect(f.glyph().metrics().height(), content="728")
  inspect(f.glyph().metrics().hori_bearing_x(), content="5")
  inspect(f.glyph().metrics().hori_bearing_y(), content="728")
  inspect(f.glyph().outline().points()[0].x(), content="325")
  inspect(f.glyph().outline().points()[0].y(), content="575")
}

///|
test "parity/Roboto[wdth,wght].ttf: varied hinted outline DEFAULT 16ppem" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_var_design_coordinates(
    f,
    [
      (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
      (@fixed.Fixed::from_raw(4915200L), 0x77647468U),
    ],
  )
  let gid = @freetype.get_char_index(f, 65U)
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, gid)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="640")
  inspect(f.glyph().metrics().width(), content="640")
  inspect(f.glyph().metrics().height(), content="768")
  inspect(f.glyph().metrics().hori_bearing_x(), content="0")
  inspect(f.glyph().metrics().hori_bearing_y(), content="768")
}

///|
test "parity/Roboto[wdth,wght].ttf: varied outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_var_design_coordinates(
    f,
    [
      (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
      (@fixed.Fixed::from_raw(4915200L), 0x77647468U),
    ],
  )
  let gid = @freetype.get_char_index(f, 65U)
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, gid, load_flags=@base.LOAD_FORCE_AUTOHINT)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="640")
}

