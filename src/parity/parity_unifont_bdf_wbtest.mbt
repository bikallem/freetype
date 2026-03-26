// Parity tests for unifont.bdf
// AUTO-GENERATED — do not edit

///|
fn load_unifont_bdf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/unifont.bdf")
}

///|
test "parity/unifont.bdf: format" {
  inspect(@base.detect_format(load_unifont_bdf()), content="Bdf")
}

///|
test "parity/unifont.bdf: loads" {
  inspect(
    (try? @freetype.from_bytes(load_unifont_bdf())) is Ok(_),
    content="true",
  )
}

///|
test "parity/unifont.bdf: metadata" {
  let f = @freetype.from_bytes(load_unifont_bdf())
  inspect(f.family_name(), content="Unifont")
  inspect(f.num_glyphs(), content="57087")
}

///|
test "parity/unifont.bdf: flags" {
  let f = @freetype.from_bytes(load_unifont_bdf())
  inspect(f.is_scalable(), content="false")
  inspect(f.is_sfnt(), content="false")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/unifont.bdf: charmaps" {
  let f = @freetype.from_bytes(load_unifont_bdf())
  inspect(f.charmaps().length(), content="1")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="3")
    inspect(f.charmaps()[0].encoding_id(), content="1")
  }
}

///|
test "parity/unifont.bdf: charmap entries" {
  let f = @freetype.from_bytes(load_unifont_bdf())
  inspect(@freetype.get_char_index(f, 0U), content="1")
  inspect(@freetype.get_char_index(f, 1U), content="2")
  inspect(@freetype.get_char_index(f, 2U), content="3")
  inspect(@freetype.get_char_index(f, 3U), content="4")
  inspect(@freetype.get_char_index(f, 4U), content="5")
  inspect(@freetype.get_char_index(f, 5U), content="6")
  inspect(@freetype.get_char_index(f, 6U), content="7")
  inspect(@freetype.get_char_index(f, 7U), content="8")
  inspect(@freetype.get_char_index(f, 8U), content="9")
  inspect(@freetype.get_char_index(f, 9U), content="10")
  inspect(@freetype.get_char_index(f, 10U), content="11")
  inspect(@freetype.get_char_index(f, 11U), content="12")
  inspect(@freetype.get_char_index(f, 12U), content="13")
  inspect(@freetype.get_char_index(f, 13U), content="14")
  inspect(@freetype.get_char_index(f, 14U), content="15")
  inspect(@freetype.get_char_index(f, 15U), content="16")
  inspect(@freetype.get_char_index(f, 16U), content="17")
  inspect(@freetype.get_char_index(f, 17U), content="18")
  inspect(@freetype.get_char_index(f, 18U), content="19")
  inspect(@freetype.get_char_index(f, 19U), content="20")
  inspect(@freetype.get_char_index(f, 20U), content="21")
  inspect(@freetype.get_char_index(f, 21U), content="22")
  inspect(@freetype.get_char_index(f, 22U), content="23")
  inspect(@freetype.get_char_index(f, 23U), content="24")
  inspect(@freetype.get_char_index(f, 24U), content="25")
  inspect(@freetype.get_char_index(f, 25U), content="26")
  inspect(@freetype.get_char_index(f, 26U), content="27")
  inspect(@freetype.get_char_index(f, 27U), content="28")
  inspect(@freetype.get_char_index(f, 28U), content="29")
  inspect(@freetype.get_char_index(f, 29U), content="30")
  inspect(@freetype.get_char_index(f, 30U), content="31")
  inspect(@freetype.get_char_index(f, 31U), content="32")
  inspect(@freetype.get_char_index(f, 32U), content="33")
  inspect(@freetype.get_char_index(f, 33U), content="34")
  inspect(@freetype.get_char_index(f, 34U), content="35")
  inspect(@freetype.get_char_index(f, 35U), content="36")
  inspect(@freetype.get_char_index(f, 36U), content="37")
  inspect(@freetype.get_char_index(f, 37U), content="38")
  inspect(@freetype.get_char_index(f, 38U), content="39")
  inspect(@freetype.get_char_index(f, 39U), content="40")
  inspect(@freetype.get_char_index(f, 40U), content="41")
  inspect(@freetype.get_char_index(f, 41U), content="42")
  inspect(@freetype.get_char_index(f, 42U), content="43")
  inspect(@freetype.get_char_index(f, 43U), content="44")
  inspect(@freetype.get_char_index(f, 44U), content="45")
  inspect(@freetype.get_char_index(f, 45U), content="46")
  inspect(@freetype.get_char_index(f, 46U), content="47")
  inspect(@freetype.get_char_index(f, 47U), content="48")
  inspect(@freetype.get_char_index(f, 48U), content="49")
  inspect(@freetype.get_char_index(f, 49U), content="50")
}
