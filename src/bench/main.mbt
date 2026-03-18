///|
/// Full benchmark: all font formats, matching C benchmark operations.

///|
fn load_file(path : String) -> Bytes? {
  let r = try? @fs.read_file_to_bytes(path)
  match r {
    Ok(data) => Some(data)
    Err(_) => None
  }
}

///|
fn main {
  let font_dir = "test/fonts"
  let fonts : Array[(String, String, String)] = [
    ("DejaVuSans.ttf", font_dir + "/DejaVuSans.ttf", "TrueType"),
    ("Roboto[wdth,wght].ttf", font_dir + "/Roboto[wdth,wght].ttf", "TT Var"),
    (
      "SourceCodePro-Regular.otf",
      font_dir + "/SourceCodePro-Regular.otf",
      "CFF/OTF",
    ),
    ("NotoSansJP-Regular.otf", font_dir + "/NotoSansJP-Regular.otf", "CFF CJK"),
    ("DejaVuSans.woff", font_dir + "/DejaVuSans.woff", "WOFF1"),
    ("DejaVuSans.ttc", font_dir + "/DejaVuSans.ttc", "TTC"),
    ("NimbusSans-Regular.pfb", font_dir + "/NimbusSans-Regular.pfb", "Type1"),
    ("unifont.bdf", font_dir + "/unifont.bdf", "BDF"),
  ]
  let face_iters = 100
  let cmap_iters = 100
  let glyph_iters = 1000
  for _, font_info in fonts {
    let (name, path, _format) = font_info
    let data = match load_file(path) {
      Some(d) => d
      None => continue
    }
    // face_load
    for _ in 0..<face_iters {
      ignore(try? @freetype.from_bytes(data))
    }
    let face_r = try? @freetype.from_bytes(data)
    let face = match face_r {
      Ok(f) => f
      Err(_) => continue
    }
    // cmap_lookup
    for _ in 0..<cmap_iters {
      for c in 32..<127 {
        ignore(@freetype.get_char_index(face, c.reinterpret_as_uint()))
      }
    }
    // glyph_load
    let gid = @freetype.get_char_index(face, 65U)
    if gid > 0U && face.is_scalable() {
      for _ in 0..<glyph_iters {
        ignore(
          try? @freetype.load_glyph(face, gid, load_flags=@base.load_no_scale),
        )
      }
      ignore(try? @freetype.set_pixel_sizes(face, 0U, 16U))
      for _ in 0..<glyph_iters {
        ignore(try? @freetype.load_glyph(face, gid))
      }
    }
    println("\{name}: done")
  }
}
