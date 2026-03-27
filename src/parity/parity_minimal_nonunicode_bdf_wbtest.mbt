// Parity tests for minimal_nonunicode.bdf
// AUTO-GENERATED — do not edit

///|
fn load_generated_minimal_nonunicode_bdf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_nonunicode.bdf")
}

///|
test "parity/minimal_nonunicode.bdf: format" {
  inspect(
    @base.detect_format(load_generated_minimal_nonunicode_bdf()),
    content="Bdf",
  )
}

///|
test "parity/minimal_nonunicode.bdf: loads" {
  inspect(
    (try? @freetype.from_bytes(load_generated_minimal_nonunicode_bdf()))
    is Ok(_),
    content="true",
  )
}

///|
test "parity/minimal_nonunicode.bdf: metadata" {
  let f = @freetype.from_bytes(load_generated_minimal_nonunicode_bdf())
  inspect(f.num_glyphs(), content="3")
}

///|
test "parity/minimal_nonunicode.bdf: flags" {
  let f = @freetype.from_bytes(load_generated_minimal_nonunicode_bdf())
  inspect(f.is_scalable(), content="false")
  inspect(f.is_sfnt(), content="false")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/minimal_nonunicode.bdf: charmaps" {
  let f = @freetype.from_bytes(load_generated_minimal_nonunicode_bdf())
  inspect(f.charmaps().length(), content="1")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="0")
    inspect(f.charmaps()[0].encoding_id(), content="0")
  }
}

///|
test "parity/minimal_nonunicode.bdf: charmap entries" {
  let f = @freetype.from_bytes(load_generated_minimal_nonunicode_bdf())
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 65U), content="2")
}
