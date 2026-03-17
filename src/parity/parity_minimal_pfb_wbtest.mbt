// Parity tests for minimal.pfb
// AUTO-GENERATED — do not edit

///|
fn load_minimal_pfb() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal.pfb")
}

///|
test "parity/minimal.pfb: format" {
  inspect(@base.detect_format(load_minimal_pfb()), content="Type1Pfb")
}

///|
test "parity/minimal.pfb: loads" {
  inspect(
    (try? @freetype.from_bytes(load_minimal_pfb())) is Ok(_),
    content="true",
  )
}

///|
test "parity/minimal.pfb: metadata" {
  let f = @freetype.from_bytes(load_minimal_pfb())
  inspect(f.family_name, content="Minimal")
  inspect(f.num_glyphs, content="3")
  inspect(f.units_per_em, content="1000")
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
}

///|
test "parity/minimal.pfb: bbox" {
  let f = @freetype.from_bytes(load_minimal_pfb())
  inspect(f.bbox.x_min, content="0")
  inspect(f.bbox.y_min, content="-200")
  inspect(f.bbox.x_max, content="500")
  inspect(f.bbox.y_max, content="800")
}

///|
test "parity/minimal.pfb: flags" {
  let f = @freetype.from_bytes(load_minimal_pfb())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="false")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/minimal.pfb: charmaps" {
  let f = @freetype.from_bytes(load_minimal_pfb())
  inspect(
    f.charmaps.length(),
    content=(
      #|1
    ),
  )
  if f.charmaps.length() > 0 {
    inspect(
      f.charmaps[0].platform_id,
      content=(
        #|7
      ),
    )
    inspect(
      f.charmaps[0].encoding_id,
      content=(
        #|2
      ),
    )
  }
  if f.charmaps.length() > 1 {
    inspect(f.charmaps[1].platform_id, content="7")
    inspect(f.charmaps[1].encoding_id, content="2")
  }
}

///|
test "parity/minimal.pfb: charmap entries" {
  let f = @freetype.from_bytes(load_minimal_pfb())
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 65U), content="2")
  inspect(
    @freetype.get_char_index(f, 160U),
    content=(
      #|0
    ),
  )
}
