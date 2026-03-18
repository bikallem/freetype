///|
/// Benchmarks for CJK CFF/OpenType font format using NotoSansJP-Regular.otf.

///|
fn load_cjk() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/NotoSansJP-Regular.otf")
}

///|
test "bench/cjk/face_load" (b : @bench.T) {
  let data = load_cjk()
  b.bench(fn() { b.keep(try? @freetype.from_bytes(data)) })
}

///|
test "bench/cjk/cmap_lookup" (b : @bench.T) {
  let data = load_cjk()
  let face = @freetype.from_bytes(data)
  b.bench(fn() {
    for c in 0x4E00..<0x4E5F {
      b.keep(@freetype.get_char_index(face, c.reinterpret_as_uint()))
    }
  })
}

///|
test "bench/cjk/glyph_load_no_scale" (b : @bench.T) {
  let data = load_cjk()
  let face = @freetype.from_bytes(data)
  let gid = @freetype.get_char_index(face, 0x4E00U) // CJK '一'
  b.bench(fn() {
    b.keep(try? @freetype.load_glyph(face, gid, load_flags=@base.LOAD_NO_SCALE))
  })
}

///|
test "bench/cjk/glyph_load_hinted" (b : @bench.T) {
  let data = load_cjk()
  let face = @freetype.from_bytes(data)
  let gid = @freetype.get_char_index(face, 0x4E00U)
  ignore(try? @freetype.set_pixel_sizes(face, 0U, 16U))
  b.bench(fn() { b.keep(try? @freetype.load_glyph(face, gid)) })
}
