// Parity tests for minimal_collection.woff2
// AUTO-GENERATED — do not edit

///|
fn load_generated_minimal_collection_woff2() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_collection.woff2")
}

///|
test "parity/minimal_collection.woff2: format" {
  inspect(@base.detect_format(load_generated_minimal_collection_woff2()), content="Woff2")
}

///|
test "parity/minimal_collection.woff2: loads" {
  inspect((try? @freetype.from_bytes(load_generated_minimal_collection_woff2())) is Ok(_), content="true")
}

///|
test "parity/minimal_collection.woff2: metadata" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
  inspect(f.family_name(), content="Minimal")
  inspect(f.num_glyphs(), content="3")
  inspect(f.units_per_em(), content="1000")
  inspect(f.ascender(), content="800")
  inspect(f.descender(), content="-200")
  inspect(f.height(), content="1000")
}

///|
test "parity/minimal_collection.woff2: bbox" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
  inspect(f.bbox().x_min(), content="0")
  inspect(f.bbox().y_min(), content="0")
  inspect(f.bbox().x_max(), content="450")
  inspect(f.bbox().y_max(), content="700")
}

///|
test "parity/minimal_collection.woff2: flags" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/minimal_collection.woff2: charmaps" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
  inspect(f.charmaps().length(), content="1")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="3")
    inspect(f.charmaps()[0].encoding_id(), content="1")
  }
}

///|
test "parity/minimal_collection.woff2: charmap entries" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 65U), content="2")
}

///|
test "parity/minimal_collection.woff2: glyph 2 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
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

///|
test "parity/minimal_collection.woff2: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="512")
}

///|
test "parity/minimal_collection.woff2: multi-face" {
  let f0 = @freetype.from_bytes(load_generated_minimal_collection_woff2(), face_index=0)
  inspect(f0.num_glyphs() > 0L, content="true")
  let f1 = @freetype.from_bytes(load_generated_minimal_collection_woff2(), face_index=1)
  inspect(f1.num_glyphs() > 0L, content="true")
}

///|
test "parity/minimal_collection.woff2: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="512")
}

///|
test "parity/minimal_collection.woff2: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_minimal_collection_woff2())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_FORCE_AUTOHINT)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="512")
}

