// Parity tests for minimal_cbdt_matrix.ttf
// AUTO-GENERATED — do not edit

///|
fn load_generated_minimal_cbdt_matrix_ttf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_cbdt_matrix.ttf")
}

///|
test "parity/minimal_cbdt_matrix.ttf: format" {
  inspect(
    @base.detect_format(load_generated_minimal_cbdt_matrix_ttf())
    is (TrueType | TrueTypeCollection),
    content="true",
  )
}

///|
test "parity/minimal_cbdt_matrix.ttf: loads" {
  inspect(
    (try? @freetype.from_bytes(load_generated_minimal_cbdt_matrix_ttf()))
    is Ok(_),
    content="true",
  )
}
