// Parity tests for minimal_cbdt.ttf
// AUTO-GENERATED — do not edit

///|
fn load_generated_minimal_cbdt_ttf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_cbdt.ttf")
}

///|
test "parity/minimal_cbdt.ttf: format" {
  inspect(
    @base.detect_format(load_generated_minimal_cbdt_ttf())
    is (TrueType | TrueTypeCollection),
    content="true",
  )
}

///|
test "parity/minimal_cbdt.ttf: loads" {
  inspect(
    (try? @freetype.from_bytes(load_generated_minimal_cbdt_ttf())) is Ok(_),
    content="true",
  )
}
