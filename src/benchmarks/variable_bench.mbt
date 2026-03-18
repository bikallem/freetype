///|
/// Benchmarks for Variable TrueType font format using Roboto[wdth,wght].ttf.

///|
fn load_variable() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/Roboto[wdth,wght].ttf")
}

///|
test "bench/variable/face_load" (b : @bench.T) {
  let data = load_variable()
  b.bench(fn() { b.keep(try? @freetype.from_bytes(data)) })
}

///|
test "bench/variable/cmap_lookup" (b : @bench.T) {
  let data = load_variable()
  let face = @freetype.from_bytes(data)
  b.bench(fn() {
    for c in 32..<127 {
      b.keep(@freetype.get_char_index(face, c.reinterpret_as_uint()))
    }
  })
}

///|
test "bench/variable/glyph_load_no_scale" (b : @bench.T) {
  let data = load_variable()
  let face = @freetype.from_bytes(data)
  let gid = @freetype.get_char_index(face, 65U)
  b.bench(fn() {
    b.keep(try? @freetype.load_glyph(face, gid, load_flags=@base.LOAD_NO_SCALE))
  })
}

///|
test "bench/variable/glyph_load_hinted" (b : @bench.T) {
  let data = load_variable()
  let face = @freetype.from_bytes(data)
  let gid = @freetype.get_char_index(face, 65U)
  ignore(try? @freetype.set_pixel_sizes(face, 0U, 16U))
  b.bench(fn() { b.keep(try? @freetype.load_glyph(face, gid)) })
}
