///|
/// Benchmarks for BDF bitmap font format using unifont.bdf.

///|
fn load_bdf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/unifont.bdf")
}

///|
test "bench/bdf/face_load" (b : @bench.T) {
  let data = load_bdf()
  b.bench(fn() { b.keep(try? @freetype.from_bytes(data)) })
}

///|
test "bench/bdf/cmap_lookup" (b : @bench.T) {
  let data = load_bdf()
  let face = @freetype.from_bytes(data)
  b.bench(fn() {
    for c in 32..<127 {
      b.keep(@freetype.get_char_index(face, c.reinterpret_as_uint()))
    }
  })
}

///|
test "bench/bdf/glyph_load" (b : @bench.T) {
  let data = load_bdf()
  let face = @freetype.from_bytes(data)
  let gid = @freetype.get_char_index(face, 65U)
  b.bench(fn() { b.keep(try? @freetype.load_glyph(face, gid)) })
}
