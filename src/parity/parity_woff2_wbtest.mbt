///|
fn load_minimal_woff2() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal.woff2")
}

///|
fn load_dejavusans_woff2() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/DejaVuSans.woff2")
}

///|
test "WOFF2: format detection" {
  inspect(@base.detect_format(load_minimal_woff2()), content="Woff2")
  inspect(@base.detect_format(load_dejavusans_woff2()), content="Woff2")
}
