///|
/// Benchmarks for WOFF1 (.woff) font format using DejaVuSans.woff.

///|
fn load_woff() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/DejaVuSans.woff")
}

///|
test "bench/woff/face_load" (b : @bench.T) {
  let data = load_woff()
  b.bench(fn() { b.keep(try? @freetype.from_bytes(data)) })
}

///|
test "bench/woff/cmap_lookup" (b : @bench.T) {
  let data = load_woff()
  let face = @freetype.from_bytes(data)
  b.bench(fn() {
    for c in 32..<127 {
      b.keep(@freetype.get_char_index(face, c.reinterpret_as_uint()))
    }
  })
}

///|
test "bench/woff/glyph_load_no_scale" (b : @bench.T) {
  let data = load_woff()
  let face = @freetype.from_bytes(data)
  let gid = @freetype.get_char_index(face, 65U)
  b.bench(fn() {
    b.keep(try? @freetype.load_glyph(face, gid, load_flags=@base.LOAD_NO_SCALE))
  })
}

///|
test "bench/woff/glyph_load_hinted" (b : @bench.T) {
  let data = load_woff()
  let face = @freetype.from_bytes(data)
  let gid = @freetype.get_char_index(face, 65U)
  ignore(try? @freetype.set_pixel_sizes(face, 0U, 16U))
  b.bench(fn() { b.keep(try? @freetype.load_glyph(face, gid)) })
}
