///|
extern "C" fn exit(code : Int) = "exit"

///|
fn main {
  let args = @env.args()
  if args.length() != 2 {
    println("Usage: moon run --target native src/parity_probe -- <font_path>")
    exit(1)
  }

  let font_path = args[1]
  let font_bytes = load_or_abort_bytes(font_path)
  let face = load_or_abort_face(font_bytes, font_path)
  println("LOAD_OK glyphs=\{face.num_glyphs()}")
}

///|
fn load_or_abort_bytes(font_path : String) -> Bytes {
  try @fs.read_file_to_bytes(font_path) catch {
    @fs.IOError(err) => abort("LOAD_ERR cannot read \{font_path}: \{err}")
  } noraise {
    bytes => bytes
  }
}

///|
fn load_or_abort_face(font_bytes : Bytes, font_path : String) -> @base.FaceRec {
  try @freetype.from_bytes(font_bytes) catch {
    err => abort("LOAD_ERR \{font_path}: \{err}")
  } noraise {
    face => face
  }
}
