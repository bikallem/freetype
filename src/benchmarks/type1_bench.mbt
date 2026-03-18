///|
/// Benchmarks for Type 1 (.pfb) font format using NimbusSans-Regular.pfb.

///|
fn load_pfb() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/NimbusSans-Regular.pfb")
}

///|
test "bench/type1/face_load" (b : @bench.T) {
  let data = load_pfb()
  b.bench(fn() { b.keep(try? @freetype.from_bytes(data)) })
}

///|
test "bench/type1/cmap_lookup" (b : @bench.T) {
  let data = load_pfb()
  let face = @freetype.from_bytes(data)
  b.bench(fn() {
    for c in 32..<127 {
      b.keep(@freetype.get_char_index(face, c.reinterpret_as_uint()))
    }
  })
}

///|
test "bench/type1/glyph_load_no_scale" (b : @bench.T) {
  let data = load_pfb()
  let face = @freetype.from_bytes(data)
  let gid = @freetype.get_char_index(face, 65U)
  b.bench(fn() {
    b.keep(try? @freetype.load_glyph(face, gid, load_flags=@base.LOAD_NO_SCALE))
  })
}

///|
test "bench/type1/glyph_load_hinted" (b : @bench.T) {
  let data = load_pfb()
  let face = @freetype.from_bytes(data)
  let gid = @freetype.get_char_index(face, 65U)
  ignore(try? @freetype.set_pixel_sizes(face, 0U, 16U))
  b.bench(fn() { b.keep(try? @freetype.load_glyph(face, gid)) })
}
