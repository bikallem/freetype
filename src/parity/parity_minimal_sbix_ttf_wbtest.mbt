// Parity tests for minimal_sbix.ttf
// AUTO-GENERATED — do not edit

///|
fn load_generated_minimal_sbix_ttf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_sbix.ttf")
}

///|
test "parity/minimal_sbix.ttf: format" {
  inspect(
    @base.detect_format(load_generated_minimal_sbix_ttf())
    is (TrueType | TrueTypeCollection),
    content="true",
  )
}

///|
test "parity/minimal_sbix.ttf: loads" {
  inspect(
    (try? @freetype.from_bytes(load_generated_minimal_sbix_ttf())) is Ok(_),
    content="true",
  )
}

///|
test "parity/minimal_sbix.ttf: metadata" {
  let f = @freetype.from_bytes(load_generated_minimal_sbix_ttf())
  inspect(f.family_name(), content="Minimal SBIX")
  inspect(f.num_glyphs(), content="3")
  inspect(f.units_per_em(), content="1000")
  inspect(f.ascender(), content="800")
  inspect(f.descender(), content="-200")
  inspect(f.height(), content="1000")
  inspect(f.underline_position(), content="-125")
  inspect(f.underline_thickness(), content="50")
}

///|
test "parity/minimal_sbix.ttf: bbox" {
  let f = @freetype.from_bytes(load_generated_minimal_sbix_ttf())
  inspect(f.bbox().x_min(), content="0")
  inspect(f.bbox().y_min(), content="0")
  inspect(f.bbox().x_max(), content="450")
  inspect(f.bbox().y_max(), content="700")
}

///|
test "parity/minimal_sbix.ttf: flags" {
  let f = @freetype.from_bytes(load_generated_minimal_sbix_ttf())
  inspect(f.is_scalable(), content="false")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/minimal_sbix.ttf: charmaps" {
  let f = @freetype.from_bytes(load_generated_minimal_sbix_ttf())
  inspect(f.charmaps().length(), content="1")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="3")
    inspect(f.charmaps()[0].encoding_id(), content="1")
  }
}

///|
test "parity/minimal_sbix.ttf: charmap entries" {
  let f = @freetype.from_bytes(load_generated_minimal_sbix_ttf())
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 65U), content="2")
}

///|
test "parity/minimal_sbix.ttf: glyph 2 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_minimal_sbix_ttf())
  let r = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().outline().n_points(), content="3")
  inspect(f.glyph().outline().n_contours(), content="1")
  inspect(f.glyph().outline().points()[0].x(), content="50")
  inspect(f.glyph().outline().points()[0].y(), content="0")
  inspect(f.glyph().outline().points()[1].x(), content="250")
  inspect(f.glyph().outline().points()[1].y(), content="700")
  inspect(f.glyph().outline().points()[2].x(), content="450")
  inspect(f.glyph().outline().points()[2].y(), content="0")
  inspect(f.glyph().metrics().hori_advance(), content="500")
}
