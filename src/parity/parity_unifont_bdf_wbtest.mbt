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
  inspect(
    f.family_name(),
    content=(
      #|-gnu-Unifont-Medium-R-Normal-Sans-16-160-75-75-c-80-iso10646-1
    ),
  )
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
  inspect(
    f.charmaps().length(),
    content=(
      #|0
    ),
  )
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="3")
    inspect(f.charmaps()[0].encoding_id(), content="1")
  }
}

///|
test "parity/unifont.bdf: charmap entries" {
  let f = @freetype.from_bytes(load_unifont_bdf())
  inspect(
    @freetype.get_char_index(f, 0U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 1U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 2U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 3U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 4U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 5U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 6U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 7U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 8U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 9U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 10U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 11U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 12U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 13U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 14U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 15U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 16U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 17U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 18U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 19U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 20U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 21U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 22U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 23U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 24U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 25U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 26U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 27U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 28U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 29U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 30U),
    content=(
      #|0
    ),
  )
  inspect(
    @freetype.get_char_index(f, 31U),
    content=(
      #|0
    ),
  )
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
}
