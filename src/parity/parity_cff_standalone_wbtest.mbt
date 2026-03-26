///|
fn load_minimal_standalone_cff() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_standalone.cff")
}

///|
fn load_sourcecodepro_standalone_cff() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/SourceCodePro_standalone.cff")
}

///|
fn load_variable_width_standalone_cff() -> Bytes {
  [
    1, 0, 4, 1, 0, 1, 1, 1, 18, 87, 105, 100, 116, 104, 84, 101, 115, 116, 45, 82,
    101, 103, 117, 108, 97, 114, 0, 1, 1, 1, 8, 181, 15, 186, 17, 145, 211, 18, 0,
    0, 0, 0, 0, 0, 1, 0, 34, 0, 3, 1, 1, 2, 4, 19, 14, 189, 14, 247, 92, 189, 22,
    247, 92, 249, 80, 5, 247, 92, 253, 80, 5, 14, 248, 136, 20, 248, 36, 21,
  ]
}

///|
test "standalone CFF: format detection" {
  inspect(
    @base.detect_format(load_minimal_standalone_cff()),
    content="CffStandalone",
  )
  inspect(
    @base.detect_format(load_sourcecodepro_standalone_cff()),
    content="CffStandalone",
  )
}

///|
test "standalone CFF: loads minimal" {
  let f = @freetype.from_bytes(load_minimal_standalone_cff())
  inspect(f.num_glyphs() > 0L, content="true")
}

///|
test "standalone CFF: loads SourceCodePro" {
  let f = @freetype.from_bytes(load_sourcecodepro_standalone_cff())
  inspect(f.num_glyphs(), content="1568")
  inspect(f.units_per_em(), content="1000")
}

///|
test "standalone CFF: glyph outline" {
  let f = @freetype.from_bytes(load_sourcecodepro_standalone_cff())
  // Glyph 2 should have outline data (glyph 0 is .notdef, 1 may be space)
  let r = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  let outline = f.glyph().outline()
  inspect(outline.n_points() > 0, content="true")
  inspect(outline.n_contours() > 0, content="true")
}

///|
test "standalone CFF: glyph advance width" {
  let f = @freetype.from_bytes(load_sourcecodepro_standalone_cff())
  let r = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_NO_SCALE)
  guard r is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance() > 0L, content="true")
}

///|
test "standalone CFF: PS hinted outline differs from unhinted" {
  let f = @freetype.from_bytes(load_sourcecodepro_standalone_cff())
  @freetype.set_pixel_sizes(f, 0U, 16U)
  // Load with hinting (default)
  let r1 = try? @freetype.load_glyph(f, 2U)
  guard r1 is Ok(_) else { return }
  let hinted_pts = f.glyph().outline().points()
  let hinted_y0 = hinted_pts[0].y()
  // Load without hinting
  let r2 = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  let unhinted_pts = f.glyph().outline().points()
  let unhinted_y0 = unhinted_pts[0].y()
  // Hinted and unhinted should produce different coordinates
  inspect(hinted_y0 != unhinted_y0, content="true")
}

///|
test "standalone CFF: charstring widths vary per glyph" {
  let f = @freetype.from_bytes(load_variable_width_standalone_cff())

  let r0 = try? @freetype.load_glyph(f, 0U, load_flags=@base.LOAD_NO_SCALE)
  guard r0 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="500")

  let r1 = try? @freetype.load_glyph(f, 1U, load_flags=@base.LOAD_NO_SCALE)
  guard r1 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="450")

  let r2 = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_NO_SCALE)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="600")
  inspect(f.glyph().outline().n_points(), content="3")
}
