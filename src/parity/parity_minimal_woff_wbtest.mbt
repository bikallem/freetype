// Parity tests for minimal.woff
// AUTO-GENERATED — do not edit

///|
fn load_minimal_woff() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal.woff")
}

///|
test "parity/minimal.woff: format" {
  inspect(@base.detect_format(load_minimal_woff()), content="Woff1")
}

///|
test "parity/minimal.woff: loads" {
  inspect(
    (try? @freetype.from_bytes(load_minimal_woff())) is Ok(_),
    content="true",
  )
}

///|
test "parity/minimal.woff: metadata" {
  let f = @freetype.from_bytes(load_minimal_woff())
  inspect(f.family_name, content="Minimal")
  inspect(f.num_glyphs, content="3")
  inspect(f.units_per_em, content="1000")
  inspect(f.ascender, content="800")
  inspect(f.descender, content="-200")
  inspect(f.height, content="1000")
}

///|
test "parity/minimal.woff: bbox" {
  let f = @freetype.from_bytes(load_minimal_woff())
  inspect(f.bbox.x_min, content="0")
  inspect(f.bbox.y_min, content="0")
  inspect(f.bbox.x_max, content="450")
  inspect(f.bbox.y_max, content="700")
}

///|
test "parity/minimal.woff: flags" {
  let f = @freetype.from_bytes(load_minimal_woff())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/minimal.woff: charmaps" {
  let f = @freetype.from_bytes(load_minimal_woff())
  inspect(f.charmaps.length(), content="1")
  if f.charmaps.length() > 0 {
    inspect(f.charmaps[0].platform_id, content="3")
    inspect(f.charmaps[0].encoding_id, content="1")
  }
}

///|
test "parity/minimal.woff: charmap entries" {
  let f = @freetype.from_bytes(load_minimal_woff())
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 65U), content="2")
}

///|
test "parity/minimal.woff: glyph 2 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_minimal_woff())
  @freetype.load_glyph(f, 2U, load_flags=@base.load_no_scale)
  inspect(f.glyph.outline.n_points(), content="3")
  inspect(f.glyph.outline.n_contours(), content="1")
  inspect(f.glyph.outline.points[0].x, content="50")
  inspect(f.glyph.outline.points[0].y, content="0")
  inspect(f.glyph.outline.points[1].x, content="250")
  inspect(f.glyph.outline.points[1].y, content="700")
  inspect(f.glyph.outline.points[2].x, content="450")
  inspect(f.glyph.outline.points[2].y, content="0")
  inspect(f.glyph.metrics.hori_advance, content="500")
}

///|
test "parity/minimal.woff: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_minimal_woff())
  @freetype.set_pixel_sizes(f, 0U, 16U)
  @freetype.load_glyph(f, 2U)
  inspect(f.glyph.metrics.hori_advance, content="512")
}
