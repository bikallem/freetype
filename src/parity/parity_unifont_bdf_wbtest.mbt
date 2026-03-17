// Parity tests for unifont.bdf
// AUTO-GENERATED — do not edit

///|
fn load_unifont_bdf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/unifont.bdf")
}

///|
test "parity/unifont.bdf: format" {
  inspect(@base.detect_format(load_unifont_bdf()), content="Bdf")
}

///|
test "parity/unifont.bdf: loads" {
  inspect(
    (try? @freetype.from_bytes(load_unifont_bdf())) is Ok(_),
    content="true",
  )
}

///|
test "parity/unifont.bdf: metadata" {
  let f = @freetype.from_bytes(load_unifont_bdf())
  inspect(
    f.family_name,
    content=(
      #|-gnu-Unifont-Medium-R-Normal-Sans-16-160-75-75-c-80-iso10646-1
    ),
  )
  inspect(f.num_glyphs, content="57087")
}
