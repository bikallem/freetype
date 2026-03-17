// Parity tests for minimal.otf
// AUTO-GENERATED — do not edit

///|
fn load_minimal_otf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal.otf")
}

///|
test "parity/minimal.otf: format" {
  inspect(@base.detect_format(load_minimal_otf()), content="CffOpenType")
}

///|
test "parity/minimal.otf: loads" {
  inspect(
    (try? @freetype.from_bytes(load_minimal_otf())) is Ok(_),
    content="true",
  )
}

///|
test "parity/minimal.otf: metadata" {
  let f = @freetype.from_bytes(load_minimal_otf())
  inspect(f.family_name, content="MinimalCFF")
  inspect(f.num_glyphs, content="3")
  inspect(f.units_per_em, content="1000")
  inspect(f.ascender, content="800")
  inspect(f.descender, content="-200")
  inspect(f.height, content="1000")
}

///|
test "parity/minimal.otf: bbox" {
  let f = @freetype.from_bytes(load_minimal_otf())
  inspect(f.bbox.x_min, content="0")
  inspect(f.bbox.y_min, content="0")
  inspect(f.bbox.x_max, content="450")
  inspect(f.bbox.y_max, content="700")
}

///|
test "parity/minimal.otf: flags" {
  let f = @freetype.from_bytes(load_minimal_otf())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/minimal.otf: charmaps" {
  let f = @freetype.from_bytes(load_minimal_otf())
  inspect(f.charmaps.length(), content="2")
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
test "parity/minimal.otf: charmap entries" {
  let f = @freetype.from_bytes(load_minimal_otf())
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 65U), content="2")
}

///|
test "parity/minimal.otf: glyph 2 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_minimal_otf())
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
test "parity/minimal.otf: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_minimal_otf())
  @freetype.set_pixel_sizes(f, 0U, 16U)
  @freetype.load_glyph(f, 2U)
  inspect(f.glyph.metrics.hori_advance, content="512")
}
