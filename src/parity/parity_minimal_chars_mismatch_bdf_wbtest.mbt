// Parity tests for minimal_chars_mismatch.bdf
// AUTO-GENERATED — do not edit

///|
fn load_generated_minimal_chars_mismatch_bdf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_chars_mismatch.bdf")
}

///|
test "parity/minimal_chars_mismatch.bdf: format" {
  inspect(@base.detect_format(load_generated_minimal_chars_mismatch_bdf()), content="Bdf")
}

///|
test "parity/minimal_chars_mismatch.bdf: loads" {
  inspect((try? @freetype.from_bytes(load_generated_minimal_chars_mismatch_bdf())) is Ok(_), content="true")
}

///|
test "parity/minimal_chars_mismatch.bdf: metadata" {
  let f = @freetype.from_bytes(load_generated_minimal_chars_mismatch_bdf())
  inspect(f.num_glyphs(), content="5")
}

///|
test "parity/minimal_chars_mismatch.bdf: flags" {
  let f = @freetype.from_bytes(load_generated_minimal_chars_mismatch_bdf())
  inspect(f.is_scalable(), content="false")
  inspect(f.is_sfnt(), content="false")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/minimal_chars_mismatch.bdf: charmaps" {
  let f = @freetype.from_bytes(load_generated_minimal_chars_mismatch_bdf())
  inspect(f.charmaps().length(), content="1")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="3")
    inspect(f.charmaps()[0].encoding_id(), content="1")
  }
}

///|
test "parity/minimal_chars_mismatch.bdf: charmap entries" {
  let f = @freetype.from_bytes(load_generated_minimal_chars_mismatch_bdf())
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 65U), content="2")
}

