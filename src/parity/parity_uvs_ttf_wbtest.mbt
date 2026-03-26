// Parity tests for uvs.ttf
// AUTO-GENERATED — do not edit

///|
fn load_generated_uvs_ttf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/uvs.ttf")
}

///|
test "parity/uvs.ttf: format" {
  inspect(@base.detect_format(load_generated_uvs_ttf()) is (TrueType | TrueTypeCollection), content="true")
}

///|
test "parity/uvs.ttf: loads" {
  inspect((try? @freetype.from_bytes(load_generated_uvs_ttf())) is Ok(_), content="true")
}

///|
test "parity/uvs.ttf: metadata" {
  let f = @freetype.from_bytes(load_generated_uvs_ttf())
  inspect(f.family_name(), content="UVS")
  inspect(f.num_glyphs(), content="4")
  inspect(f.units_per_em(), content="1000")
  inspect(f.ascender(), content="800")
  inspect(f.descender(), content="-200")
  inspect(f.height(), content="1000")
}

///|
test "parity/uvs.ttf: bbox" {
  let f = @freetype.from_bytes(load_generated_uvs_ttf())
  inspect(f.bbox().x_min(), content="0")
  inspect(f.bbox().y_min(), content="0")
  inspect(f.bbox().x_max(), content="450")
  inspect(f.bbox().y_max(), content="700")
}

///|
test "parity/uvs.ttf: flags" {
  let f = @freetype.from_bytes(load_generated_uvs_ttf())
  inspect(f.is_scalable(), content="true")
  inspect(f.is_sfnt(), content="true")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/uvs.ttf: charmaps" {
  let f = @freetype.from_bytes(load_generated_uvs_ttf())
  inspect(f.charmaps().length(), content="2")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="3")
    inspect(f.charmaps()[0].encoding_id(), content="1")
  }
  if f.charmaps().length() > 1 {
    inspect(f.charmaps()[1].platform_id(), content="0")
    inspect(f.charmaps()[1].encoding_id(), content="5")
  }
}

///|
test "parity/uvs.ttf: charmap entries" {
  let f = @freetype.from_bytes(load_generated_uvs_ttf())
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 65U), content="2")
}

///|
test "parity/uvs.ttf: glyph 2 outline NO_SCALE" {
  let f = @freetype.from_bytes(load_generated_uvs_ttf())
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
test "parity/uvs.ttf: glyph metrics at 16ppem" {
  let f = @freetype.from_bytes(load_generated_uvs_ttf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="512")
}

///|
test "parity/uvs.ttf: outline NO_HINTING 16ppem" {
  let f = @freetype.from_bytes(load_generated_uvs_ttf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_NO_HINTING)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="512")
}

///|
test "parity/uvs.ttf: outline FORCE_AUTOHINT 16ppem" {
  let f = @freetype.from_bytes(load_generated_uvs_ttf())
  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  let r2 = try? @freetype.load_glyph(f, 2U, load_flags=@base.LOAD_FORCE_AUTOHINT)
  guard r2 is Ok(_) else { return }
  inspect(f.glyph().metrics().hori_advance(), content="512")
}

