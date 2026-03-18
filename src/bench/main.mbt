///|
fn main {
  let data = try! @fs.read_file_to_bytes(
    "/home/blem/projects/freetype/test/fonts/unifont.bdf",
  )
  // face_load: 100 iters
  for _ in 0..<100 {
    ignore(try? @freetype.from_bytes(data))
  }
  let face = try! @freetype.from_bytes(data)
  // cmap: 100 iters × 95 chars
  for _ in 0..<100 {
    for c in 32..<127 {
      ignore(@freetype.get_char_index(face, c.reinterpret_as_uint()))
    }
  }
  // glyph: 1000 iters
  let gid = @freetype.get_char_index(face, 65U)
  if gid > 0U && face.is_scalable() {
    for _ in 0..<1000 {
      ignore(
        try? @freetype.load_glyph(face, gid, load_flags=@base.load_no_scale),
      )
    }
    ignore(try? @freetype.set_pixel_sizes(face, 0U, 16U))
    for _ in 0..<1000 {
      ignore(try? @freetype.load_glyph(face, gid))
    }
  }
}
