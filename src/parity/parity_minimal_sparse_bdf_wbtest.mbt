// Parity tests for minimal_sparse.bdf
// AUTO-GENERATED — do not edit

///|
fn load_generated_minimal_sparse_bdf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_sparse.bdf")
}

///|
test "parity/minimal_sparse.bdf: format" {
  inspect(@base.detect_format(load_generated_minimal_sparse_bdf()), content="Bdf")
}

///|
test "parity/minimal_sparse.bdf: loads" {
  inspect((try? @freetype.from_bytes(load_generated_minimal_sparse_bdf())) is Ok(_), content="true")
}

///|
test "parity/minimal_sparse.bdf: metadata" {
  let f = @freetype.from_bytes(load_generated_minimal_sparse_bdf())
  inspect(f.num_glyphs(), content="3")
}

///|
test "parity/minimal_sparse.bdf: flags" {
  let f = @freetype.from_bytes(load_generated_minimal_sparse_bdf())
  inspect(f.is_scalable(), content="false")
  inspect(f.is_sfnt(), content="false")
  inspect(f.has_horizontal(), content="true")
  inspect(f.has_kerning(), content="false")
}

///|
test "parity/minimal_sparse.bdf: charmaps" {
  let f = @freetype.from_bytes(load_generated_minimal_sparse_bdf())
  inspect(f.charmaps().length(), content="1")
  if f.charmaps().length() > 0 {
    inspect(f.charmaps()[0].platform_id(), content="3")
    inspect(f.charmaps()[0].encoding_id(), content="1")
  }
}

///|
test "parity/minimal_sparse.bdf: charmap entries" {
  let f = @freetype.from_bytes(load_generated_minimal_sparse_bdf())
  inspect(@freetype.get_char_index(f, 32U), content="1")
  inspect(@freetype.get_char_index(f, 66U), content="2")
}

