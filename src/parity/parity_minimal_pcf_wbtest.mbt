// Parity tests for minimal.pcf
// AUTO-GENERATED — do not edit

///|
fn load_generated_minimal_pcf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal.pcf")
}

///|
test "parity/minimal.pcf: format" {
  inspect(@base.detect_format(load_generated_minimal_pcf()), content="Pcf")
}

///|
test "parity/minimal.pcf: loads" {
  inspect((try? @freetype.from_bytes(load_generated_minimal_pcf())) is Ok(_), content="true")
}

///|
test "parity/minimal.pcf: metadata" {
  let f = @freetype.from_bytes(load_generated_minimal_pcf())
  inspect(f.num_glyphs(), content="3")
}

///|
test "parity/minimal.pcf: flags" {
  let f = @freetype.from_bytes(load_generated_minimal_pcf())
  inspect(f.is_scalable(), content="false")
  inspect(f.is_sfnt(), content="false")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/minimal.pcf: charmaps" {
  let f = @freetype.from_bytes(load_generated_minimal_pcf())
  inspect(f.charmaps().length(), content="1")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="0")
    inspect(f.charmaps()[0].encoding_id(), content="0")
  }
}

///|
test "parity/minimal.pcf: charmap entries" {
  let f = @freetype.from_bytes(load_generated_minimal_pcf())
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 65U), content="2")
}

