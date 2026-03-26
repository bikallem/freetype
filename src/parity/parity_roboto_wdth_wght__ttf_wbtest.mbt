// Parity tests for Roboto[wdth,wght].ttf
// AUTO-GENERATED — do not edit

///|
fn load_generated_roboto_wdth_wght__ttf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/Roboto[wdth,wght].ttf")
}

///|
test "parity/Roboto[wdth,wght].ttf: format" {
  inspect(
    @base.detect_format(load_generated_roboto_wdth_wght__ttf())
    is (TrueType | TrueTypeCollection),
    content="true",
  )
}

///|
test "parity/Roboto[wdth,wght].ttf: loads" {
  inspect(
    (try? @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())) is Ok(_),
    content="true",
  )
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
test "parity/Roboto[wdth,wght].ttf: rendered glyph 4 char 32" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 32U)
  inspect(gid, content="4")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().width(), content="0")
  inspect(f.glyph().bitmap().rows(), content="0")
  inspect(f.glyph().bitmap().pitch(), content="0")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="0")
  inspect(f.glyph().bitmap().buffer().length(), content="0")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 37 char 65" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 65U)
  inspect(gid, content="37")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().width(), content="11")
  inspect(f.glyph().bitmap().rows(), content="12")
  inspect(f.glyph().bitmap().pitch(), content="11")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="12")
  inspect(f.glyph().bitmap().buffer().length(), content="132")
  inspect(f.glyph().bitmap().buffer()[0].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[1].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[2].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[3].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[4].to_int(), content="59")
  inspect(f.glyph().bitmap().buffer()[5].to_int(), content="145")
  inspect(f.glyph().bitmap().buffer()[6].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[7].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[8].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[9].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[10].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[11].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[12].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[13].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[14].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[15].to_int(), content="214")
  inspect(f.glyph().bitmap().buffer()[16].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[17].to_int(), content="57")
  inspect(f.glyph().bitmap().buffer()[18].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[19].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[20].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[21].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[22].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[23].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[24].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[25].to_int(), content="39")
  inspect(f.glyph().bitmap().buffer()[26].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[27].to_int(), content="250")
  inspect(f.glyph().bitmap().buffer()[28].to_int(), content="155")
  inspect(f.glyph().bitmap().buffer()[29].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[30].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[31].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[32].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[33].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[34].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[35].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[36].to_int(), content="136")
  inspect(f.glyph().bitmap().buffer()[37].to_int(), content="217")
  inspect(f.glyph().bitmap().buffer()[38].to_int(), content="102")
  inspect(f.glyph().bitmap().buffer()[39].to_int(), content="242")
  inspect(f.glyph().bitmap().buffer()[40].to_int(), content="10")
  inspect(f.glyph().bitmap().buffer()[41].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[42].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[43].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[44].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[45].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[46].to_int(), content="3")
  inspect(f.glyph().bitmap().buffer()[47].to_int(), content="229")
  inspect(f.glyph().bitmap().buffer()[48].to_int(), content="124")
  inspect(f.glyph().bitmap().buffer()[49].to_int(), content="16")
  inspect(f.glyph().bitmap().buffer()[50].to_int(), content="248")
  inspect(f.glyph().bitmap().buffer()[51].to_int(), content="94")
  inspect(f.glyph().bitmap().buffer()[52].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[53].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[54].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[55].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[56].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[57].to_int(), content="75")
  inspect(f.glyph().bitmap().buffer()[58].to_int(), content="254")
  inspect(f.glyph().bitmap().buffer()[59].to_int(), content="33")
  inspect(f.glyph().bitmap().buffer()[60].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[61].to_int(), content="172")
  inspect(f.glyph().bitmap().buffer()[62].to_int(), content="192")
  inspect(f.glyph().bitmap().buffer()[63].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[64].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[65].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[66].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[67].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[68].to_int(), content="172")
  inspect(f.glyph().bitmap().buffer()[69].to_int(), content="194")
  inspect(f.glyph().bitmap().buffer()[70].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[71].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[72].to_int(), content="79")
  inspect(f.glyph().bitmap().buffer()[73].to_int(), content="254")
  inspect(f.glyph().bitmap().buffer()[74].to_int(), content="35")
  inspect(f.glyph().bitmap().buffer()[75].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[76].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[77].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[78].to_int(), content="20")
  inspect(f.glyph().bitmap().buffer()[79].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[80].to_int(), content="157")
  inspect(f.glyph().bitmap().buffer()[81].to_int(), content="56")
  inspect(f.glyph().bitmap().buffer()[82].to_int(), content="56")
  inspect(f.glyph().bitmap().buffer()[83].to_int(), content="61")
  inspect(f.glyph().bitmap().buffer()[84].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[85].to_int(), content="159")
  inspect(f.glyph().bitmap().buffer()[86].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[87].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[88].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[89].to_int(), content="111")
  inspect(f.glyph().bitmap().buffer()[90].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[91].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[92].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[93].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[94].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[95].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[96].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[97].to_int(), content="2")
  inspect(f.glyph().bitmap().buffer()[98].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[99].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[100].to_int(), content="208")
  inspect(f.glyph().bitmap().buffer()[101].to_int(), content="175")
  inspect(f.glyph().bitmap().buffer()[102].to_int(), content="4")
  inspect(f.glyph().bitmap().buffer()[103].to_int(), content="4")
  inspect(f.glyph().bitmap().buffer()[104].to_int(), content="4")
  inspect(f.glyph().bitmap().buffer()[105].to_int(), content="4")
  inspect(f.glyph().bitmap().buffer()[106].to_int(), content="60")
  inspect(f.glyph().bitmap().buffer()[107].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[108].to_int(), content="71")
  inspect(f.glyph().bitmap().buffer()[109].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[110].to_int(), content="50")
  inspect(f.glyph().bitmap().buffer()[111].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[112].to_int(), content="78")
  inspect(f.glyph().bitmap().buffer()[113].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[114].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[115].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[116].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[117].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[118].to_int(), content="219")
  inspect(f.glyph().bitmap().buffer()[119].to_int(), content="169")
  inspect(f.glyph().bitmap().buffer()[120].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[121].to_int(), content="147")
  inspect(f.glyph().bitmap().buffer()[122].to_int(), content="236")
  inspect(f.glyph().bitmap().buffer()[123].to_int(), content="5")
  inspect(f.glyph().bitmap().buffer()[124].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[125].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[126].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[127].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[128].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[129].to_int(), content="126")
  inspect(f.glyph().bitmap().buffer()[130].to_int(), content="248")
  inspect(f.glyph().bitmap().buffer()[131].to_int(), content="18")
}

///|
test "parity/Roboto[wdth,wght].ttf: rendered glyph 69 char 97" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_pixel_sizes(f, 0U, 16U)
  let gid = @freetype.get_char_index(f, 97U)
  inspect(gid, content="69")
  try! @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)
  try! @freetype.render_glyph(f)
  inspect(f.glyph().format(), content="Bitmap")
  inspect(f.glyph().bitmap().width(), content="8")
  inspect(f.glyph().bitmap().rows(), content="10")
  inspect(f.glyph().bitmap().pitch(), content="8")
  inspect(f.glyph().bitmap().num_grays(), content="256")
  inspect(f.glyph().bitmap_left(), content="0")
  inspect(f.glyph().bitmap_top(), content="9")
  inspect(f.glyph().bitmap().buffer().length(), content="80")
  inspect(f.glyph().bitmap().buffer()[0].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[1].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[2].to_int(), content="35")
  inspect(f.glyph().bitmap().buffer()[3].to_int(), content="120")
  inspect(f.glyph().bitmap().buffer()[4].to_int(), content="148")
  inspect(f.glyph().bitmap().buffer()[5].to_int(), content="114")
  inspect(f.glyph().bitmap().buffer()[6].to_int(), content="19")
  inspect(f.glyph().bitmap().buffer()[7].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[8].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[9].to_int(), content="83")
  inspect(f.glyph().bitmap().buffer()[10].to_int(), content="250")
  inspect(f.glyph().bitmap().buffer()[11].to_int(), content="189")
  inspect(f.glyph().bitmap().buffer()[12].to_int(), content="155")
  inspect(f.glyph().bitmap().buffer()[13].to_int(), content="227")
  inspect(f.glyph().bitmap().buffer()[14].to_int(), content="227")
  inspect(f.glyph().bitmap().buffer()[15].to_int(), content="20")
  inspect(f.glyph().bitmap().buffer()[16].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[17].to_int(), content="194")
  inspect(f.glyph().bitmap().buffer()[18].to_int(), content="150")
  inspect(f.glyph().bitmap().buffer()[19].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[20].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[21].to_int(), content="30")
  inspect(f.glyph().bitmap().buffer()[22].to_int(), content="254")
  inspect(f.glyph().bitmap().buffer()[23].to_int(), content="109")
  inspect(f.glyph().bitmap().buffer()[24].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[25].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[26].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[27].to_int(), content="2")
  inspect(f.glyph().bitmap().buffer()[28].to_int(), content="25")
  inspect(f.glyph().bitmap().buffer()[29].to_int(), content="32")
  inspect(f.glyph().bitmap().buffer()[30].to_int(), content="244")
  inspect(f.glyph().bitmap().buffer()[31].to_int(), content="135")
  inspect(f.glyph().bitmap().buffer()[32].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[33].to_int(), content="32")
  inspect(f.glyph().bitmap().buffer()[34].to_int(), content="174")
  inspect(f.glyph().bitmap().buffer()[35].to_int(), content="248")
  inspect(f.glyph().bitmap().buffer()[36].to_int(), content="236")
  inspect(f.glyph().bitmap().buffer()[37].to_int(), content="228")
  inspect(f.glyph().bitmap().buffer()[38].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[39].to_int(), content="136")
  inspect(f.glyph().bitmap().buffer()[40].to_int(), content="1")
  inspect(f.glyph().bitmap().buffer()[41].to_int(), content="212")
  inspect(f.glyph().bitmap().buffer()[42].to_int(), content="190")
  inspect(f.glyph().bitmap().buffer()[43].to_int(), content="26")
  inspect(f.glyph().bitmap().buffer()[44].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[45].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[46].to_int(), content="232")
  inspect(f.glyph().bitmap().buffer()[47].to_int(), content="136")
  inspect(f.glyph().bitmap().buffer()[48].to_int(), content="28")
  inspect(f.glyph().bitmap().buffer()[49].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[50].to_int(), content="95")
  inspect(f.glyph().bitmap().buffer()[51].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[52].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[53].to_int(), content="4")
  inspect(f.glyph().bitmap().buffer()[54].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[55].to_int(), content="136")
  inspect(f.glyph().bitmap().buffer()[56].to_int(), content="7")
  inspect(f.glyph().bitmap().buffer()[57].to_int(), content="238")
  inspect(f.glyph().bitmap().buffer()[58].to_int(), content="199")
  inspect(f.glyph().bitmap().buffer()[59].to_int(), content="51")
  inspect(f.glyph().bitmap().buffer()[60].to_int(), content="51")
  inspect(f.glyph().bitmap().buffer()[61].to_int(), content="184")
  inspect(f.glyph().bitmap().buffer()[62].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[63].to_int(), content="143")
  inspect(f.glyph().bitmap().buffer()[64].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[65].to_int(), content="72")
  inspect(f.glyph().bitmap().buffer()[66].to_int(), content="232")
  inspect(f.glyph().bitmap().buffer()[67].to_int(), content="255")
  inspect(f.glyph().bitmap().buffer()[68].to_int(), content="250")
  inspect(f.glyph().bitmap().buffer()[69].to_int(), content="146")
  inspect(f.glyph().bitmap().buffer()[70].to_int(), content="206")
  inspect(f.glyph().bitmap().buffer()[71].to_int(), content="185")
  inspect(f.glyph().bitmap().buffer()[72].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[73].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[74].to_int(), content="3")
  inspect(f.glyph().bitmap().buffer()[75].to_int(), content="31")
  inspect(f.glyph().bitmap().buffer()[76].to_int(), content="7")
  inspect(f.glyph().bitmap().buffer()[77].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[78].to_int(), content="0")
  inspect(f.glyph().bitmap().buffer()[79].to_int(), content="0")
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
  let r2 = try? @freetype.load_glyph(
    f,
    5U,
    load_flags=@base.LOAD_FORCE_AUTOHINT,
  )
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="320")
}

///|
test "parity/Roboto[wdth,wght].ttf: variation state" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  inspect(f.has_multiple_masters(), content="true")
  inspect(f.is_variation(), content="false")
  try! @freetype.set_var_design_coordinates(f, [
    (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
    (@fixed.Fixed::from_raw(4915200L), 0x77647468U),
  ])
  inspect(f.is_variation(), content="true")
}

///|
test "parity/Roboto[wdth,wght].ttf: varied 65 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_roboto_wdth_wght__ttf())
  try! @freetype.set_var_design_coordinates(f, [
    (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
    (@fixed.Fixed::from_raw(4915200L), 0x77647468U),
  ])
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
  try! @freetype.set_var_design_coordinates(f, [
    (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
    (@fixed.Fixed::from_raw(4915200L), 0x77647468U),
  ])
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
  try! @freetype.set_var_design_coordinates(f, [
    (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
    (@fixed.Fixed::from_raw(4915200L), 0x77647468U),
  ])
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
  try! @freetype.set_var_design_coordinates(f, [
    (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
    (@fixed.Fixed::from_raw(4915200L), 0x77647468U),
  ])
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
  try! @freetype.set_var_design_coordinates(f, [
    (@fixed.Fixed::from_raw(58982400L), 0x77676874U),
    (@fixed.Fixed::from_raw(4915200L), 0x77647468U),
  ])
  let gid = @freetype.get_char_index(f, 65U)
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(
    f,
    gid,
    load_flags=@base.LOAD_FORCE_AUTOHINT,
  )
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="640")
}
