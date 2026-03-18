///|
/// Benchmark harness for FreeType MoonBit port.
/// Outputs JSON matching the C benchmark format for comparison.
/// Run with: moon run src/bench --target native

///|
struct FontEntry {
  name : String
  path : String
  format : String
}

///|
fn load_file(path : String) -> Bytes? {
  let result = try? @fs.read_file_to_bytes(path)
  match result {
    Ok(data) => Some(data)
    Err(_) => None
  }
}

///|
fn now_ns() -> Int64 {
  // MoonBit doesn't expose a high-res clock natively.
  // We measure by running many iterations and dividing.
  // The actual timing is done by wrapping with `time` externally.
  0L // placeholder — we use iteration counting + external timer
}

///|
fn bench_iters(warmup : Int, iters : Int, body : () -> Unit) -> Unit {
  for _ in 0..<warmup {
    body()
  }
  for _ in 0..<iters {
    body()
  }
}

///|
fn main {
  let font_dir = "test/fonts"
  let entries : Array[FontEntry] = [
    {
      name: "DejaVuSans.ttf",
      path: font_dir + "/DejaVuSans.ttf",
      format: "TrueType",
    },
    {
      name: "Roboto[wdth,wght].ttf",
      path: font_dir + "/Roboto[wdth,wght].ttf",
      format: "TrueType Variable",
    },
    {
      name: "SourceCodePro-Regular.otf",
      path: font_dir + "/SourceCodePro-Regular.otf",
      format: "CFF/OpenType",
    },
    {
      name: "NotoSansJP-Regular.otf",
      path: font_dir + "/NotoSansJP-Regular.otf",
      format: "CFF/OpenType CJK",
    },
    {
      name: "DejaVuSans.woff",
      path: font_dir + "/DejaVuSans.woff",
      format: "WOFF1",
    },
    {
      name: "DejaVuSans.ttc",
      path: font_dir + "/DejaVuSans.ttc",
      format: "TrueType Collection",
    },
    {
      name: "NimbusSans-Regular.pfb",
      path: font_dir + "/NimbusSans-Regular.pfb",
      format: "Type 1 PFB",
    },
    {
      name: "unifont.bdf",
      path: font_dir + "/unifont.bdf",
      format: "BDF Bitmap",
    },
  ]
  let warmup = 3
  let iters = 100
  let glyph_iters = 1000
  println("Running MoonBit FreeType benchmarks...")
  println("")
  for i, entry in entries {
    let data = match load_file(entry.path) {
      Some(d) => d
      None => {
        println("  [skip] \{entry.name} (not found)")
        continue
      }
    }
    let size_kb = data.length() / 1024
    println("  \{entry.name} (\{entry.format}, \{size_kb}KB)")
    // Bench: face_load
    bench_iters(warmup, iters, fn() {
      let r = try? @freetype.from_bytes(data)
      ignore(r)
    })
    println("    face_load:      \{iters} iters")
    // Load face for remaining benchmarks
    let face_result = try? @freetype.from_bytes(data)
    let face = match face_result {
      Ok(f) => f
      Err(_) => {
        println("    [load failed]")
        continue
      }
    }
    // Bench: cmap_lookup (ASCII range)
    bench_iters(warmup, iters, fn() {
      for c in 32..<127 {
        ignore(@freetype.get_char_index(face, c.reinterpret_as_uint()))
      }
    })
    println("    cmap_lookup:    \{iters} iters (95 chars each)")
    // Bench: glyph_load NO_SCALE
    let gid_a = @freetype.get_char_index(face, 65U)
    if gid_a > 0U && face.is_scalable() {
      bench_iters(warmup, glyph_iters, fn() {
        let r = try? @freetype.load_glyph(
          face,
          gid_a,
          load_flags=@base.load_no_scale,
        )
        ignore(r)
      })
      println("    glyph_noscale:  \{glyph_iters} iters")
      // Bench: glyph_load DEFAULT (with scaling)
      let r = try? @freetype.set_pixel_sizes(face, 0U, 16U)
      ignore(r)
      bench_iters(warmup, glyph_iters, fn() {
        let r = try? @freetype.load_glyph(face, gid_a)
        ignore(r)
      })
      println("    glyph_default:  \{glyph_iters} iters")
    } else {
      println("    glyph_noscale:  [skipped — no scalable glyphs]")
      println("    glyph_default:  [skipped]")
    }
    ignore(i)
    println("")
  }
  println("Done. For timing, run with: time moon run src/bench --target native")
}
