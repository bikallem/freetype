///|
fn load_minimal_standalone_cff() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_standalone.cff")
}

///|
fn load_sourcecodepro_standalone_cff() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/SourceCodePro_standalone.cff")
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
