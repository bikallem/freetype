// Parity tests for minimal_sbix_refs.ttf
// AUTO-GENERATED — do not edit

///|
fn load_generated_minimal_sbix_refs_ttf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_sbix_refs.ttf")
}

///|
test "parity/minimal_sbix_refs.ttf: format" {
  inspect(
    @base.detect_format(load_generated_minimal_sbix_refs_ttf())
    is (TrueType | TrueTypeCollection),
    content="true",
  )
}

///|
test "parity/minimal_sbix_refs.ttf: loads" {
  inspect(
    (try? @freetype.from_bytes(load_generated_minimal_sbix_refs_ttf())) is Ok(_),
    content="true",
  )
}

///|
test "parity/minimal_sbix_refs.ttf: metadata" {
  let f = @freetype.from_bytes(load_generated_minimal_sbix_refs_ttf())
  inspect(f.family_name(), content="Minimal SBIX Refs")
  inspect(f.num_glyphs(), content="6")
  inspect(f.units_per_em(), content="1000")
  inspect(f.ascender(), content="800")
  inspect(f.descender(), content="-200")
  inspect(f.height(), content="1000")
  inspect(f.underline_position(), content="-125")
  inspect(f.underline_thickness(), content="50")
}

///|
test "parity/minimal_sbix_refs.ttf: bbox" {
  let f = @freetype.from_bytes(load_generated_minimal_sbix_refs_ttf())
  inspect(f.bbox().x_min(), content="0")
  inspect(f.bbox().y_min(), content="0")
  inspect(f.bbox().x_max(), content="450")
  inspect(f.bbox().y_max(), content="700")
}

///|
test "parity/minimal_sbix_refs.ttf: flags" {
  let f = @freetype.from_bytes(load_generated_minimal_sbix_refs_ttf())
  inspect(f.is_scalable(), content="false")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/minimal_sbix_refs.ttf: charmaps" {
  let f = @freetype.from_bytes(load_generated_minimal_sbix_refs_ttf())
  inspect(f.charmaps().length(), content="1")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="3")
    inspect(f.charmaps()[0].encoding_id(), content="1")
  }
}

///|
test "parity/minimal_sbix_refs.ttf: charmap entries" {
  let f = @freetype.from_bytes(load_generated_minimal_sbix_refs_ttf())
  inspect(@freetype.get_char_index(f, 65U), content="2")
  inspect(@freetype.get_char_index(f, 66U), content="3")
  inspect(@freetype.get_char_index(f, 67U), content="4")
  inspect(@freetype.get_char_index(f, 68U), content="5")
}
