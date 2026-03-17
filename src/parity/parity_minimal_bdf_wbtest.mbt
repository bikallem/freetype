// Parity tests for minimal.bdf
// AUTO-GENERATED — do not edit

///|
fn load_minimal_bdf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal.bdf")
}

///|
test "parity/minimal.bdf: format" {
  inspect(@base.detect_format(load_minimal_bdf()), content="Bdf")
}

///|
test "parity/minimal.bdf: loads" {
  inspect(
    (try? @freetype.from_bytes(load_minimal_bdf())) is Ok(_),
    content="true",
  )
}

///|
test "parity/minimal.bdf: metadata" {
  let f = @freetype.from_bytes(load_minimal_bdf())
  inspect(
    f.num_glyphs,
    content=(
      #|1
    ),
  )
}
