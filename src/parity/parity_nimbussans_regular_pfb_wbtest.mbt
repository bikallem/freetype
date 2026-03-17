// Parity tests for NimbusSans-Regular.pfb
// AUTO-GENERATED — do not edit

///|
fn load_nimbussans_regular_pfb() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/NimbusSans-Regular.pfb")
}

///|
test "parity/NimbusSans-Regular.pfb: format" {
  inspect(
    @base.detect_format(load_nimbussans_regular_pfb()),
    content=(
      #|Type1Pfa
    ),
  )
}

///|
test "parity/NimbusSans-Regular.pfb: loads" {
  inspect(
    (try? @freetype.from_bytes(load_nimbussans_regular_pfb())) is Ok(_),
    content="true",
  )
}

///|
test "parity/NimbusSans-Regular.pfb: metadata" {
  let f = @freetype.from_bytes(load_nimbussans_regular_pfb())
  inspect(
    f.family_name,
    content=(
      #|
    ),
  )
  inspect(
    f.num_glyphs,
    content=(
      #|0
    ),
  )
  inspect(
    f.units_per_em,
    content=(
      #|0
    ),
  )
  inspect(
    f.ascender,
    content=(
      #|0
    ),
  )
  inspect(
    f.descender,
    content=(
      #|0
    ),
  )
  inspect(
    f.height,
    content=(
      #|0
    ),
  )
  inspect(
    f.underline_position,
    content=(
      #|0
    ),
  )
  inspect(
    f.underline_thickness,
    content=(
      #|0
    ),
  )
}

///|
test "parity/NimbusSans-Regular.pfb: bbox" {
  let f = @freetype.from_bytes(load_nimbussans_regular_pfb())
  inspect(
    f.bbox.x_min,
    content=(
      #|0
    ),
  )
  inspect(
    f.bbox.y_min,
    content=(
      #|0
    ),
  )
  inspect(
    f.bbox.x_max,
    content=(
      #|0
    ),
  )
  inspect(
    f.bbox.y_max,
    content=(
      #|0
    ),
  )
}

///|
test "parity/NimbusSans-Regular.pfb: flags" {
  let f = @freetype.from_bytes(load_nimbussans_regular_pfb())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="false")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/NimbusSans-Regular.pfb: charmaps" {
  let f = @freetype.from_bytes(load_nimbussans_regular_pfb())
  inspect(
    f.charmaps.length(),
    content=(
      #|0
    ),
  )
  if f.charmaps.length() > 0 {
    inspect(f.charmaps[0].platform_id, content="3")
    inspect(f.charmaps[0].encoding_id, content="1")
  }
  if f.charmaps.length() > 1 {
    inspect(f.charmaps[1].platform_id, content="7")
    inspect(f.charmaps[1].encoding_id, content="0")
  }
}

///|
test "parity/NimbusSans-Regular.pfb: charmap entries" {
  let f = @freetype.from_bytes(load_nimbussans_regular_pfb())
  inspect(
    @freetype.get_char_index(f, 32U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 33U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 34U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 35U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 36U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 37U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 38U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 39U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 40U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 41U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 42U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 43U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 44U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 45U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 46U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 47U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 48U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 49U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 50U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 51U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 52U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 53U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 54U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 55U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 56U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 57U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 58U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 59U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 60U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 61U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 62U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 63U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 64U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 65U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 66U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 67U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 68U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 69U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 70U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 71U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 72U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 73U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 74U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 75U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 76U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 77U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 78U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 79U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 80U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 81U),
    content=(
      #|0
    ),
  )
}
