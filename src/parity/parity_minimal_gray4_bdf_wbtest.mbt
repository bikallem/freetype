// Parity tests for minimal_gray4.bdf
// AUTO-GENERATED — do not edit

///|
fn load_generated_minimal_gray4_bdf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_gray4.bdf")
}

///|
test "parity/minimal_gray4.bdf: format" {
  inspect(
    @base.detect_format(load_generated_minimal_gray4_bdf()),
    content="Bdf",
  )
}

///|
test "parity/minimal_gray4.bdf: loads" {
  inspect(
    (try? @freetype.from_bytes(load_generated_minimal_gray4_bdf())) is Ok(_),
    content="true",
  )
}

///|
test "parity/minimal_gray4.bdf: metadata" {
  let f = @freetype.from_bytes(load_generated_minimal_gray4_bdf())
  inspect(f.num_glyphs(), content="2")
}

///|
test "parity/minimal_gray4.bdf: flags" {
  let f = @freetype.from_bytes(load_generated_minimal_gray4_bdf())
  inspect(f.is_scalable(), content="false")
  inspect(f.is_sfnt(), content="false")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/minimal_gray4.bdf: charmaps" {
  let f = @freetype.from_bytes(load_generated_minimal_gray4_bdf())
  inspect(f.charmaps().length(), content="1")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="3")
    inspect(f.charmaps()[0].encoding_id(), content="1")
  }
}

///|
test "parity/minimal_gray4.bdf: charmap entries" {
  let f = @freetype.from_bytes(load_generated_minimal_gray4_bdf())
  inspect(@freetype.get_char_index(f, 65U), content="1")
}
