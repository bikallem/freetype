///|
/// Benchmarks for TrueType Collection (.ttc) font format using DejaVuSans.ttc.

///|
fn load_ttc() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/DejaVuSans.ttc")
}

///|
test "bench/ttc/face_load" (b : @bench.T) {
  let data = load_ttc()
  b.bench(fn() { b.keep(try? @freetype.from_bytes(data)) })
}

///|
test "bench/ttc/cmap_lookup" (b : @bench.T) {
  let data = load_ttc()
  let face = @freetype.from_bytes(data)
  b.bench(fn() {
    for c in 32..<127 {
      b.keep(@freetype.get_char_index(face, c.reinterpret_as_uint()))
    }
  })
}

///|
test "bench/ttc/glyph_load_no_scale" (b : @bench.T) {
  let data = load_ttc()
  let face = @freetype.from_bytes(data)
  let gid = @freetype.get_char_index(face, 65U)
  b.bench(fn() {
    b.keep(try? @freetype.load_glyph(face, gid, load_flags=@base.LOAD_NO_SCALE))
  })
}

///|
test "bench/ttc/glyph_load_hinted" (b : @bench.T) {
  let data = load_ttc()
  let face = @freetype.from_bytes(data)
  let gid = @freetype.get_char_index(face, 65U)
  ignore(try? @freetype.set_pixel_sizes(face, 0U, 16U))
  b.bench(fn() { b.keep(try? @freetype.load_glyph(face, gid)) })
}
