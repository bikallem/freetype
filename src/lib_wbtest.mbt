///|
fn load_minimal_cff2_fixture() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_cff2.cff2")
}

///|
fn load_minimal_type1_mm_fixture() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/minimal_type1_mm.pfa")
}

///|
test "from_bytes: rejects unsupported CFF2 fixture" {
  let data = load_minimal_cff2_fixture()
  inspect(@base.detect_format(data), content="CffOpenType")
  let result : Result[@base.FaceRec, @error.FTError] = Ok(from_bytes(data)) catch {
    err => Err(err)
  }
  inspect(result is Err(_), content="true")
  match result {
    Err(err) => inspect(err, content="UnimplementedFeature")
    _ => ()
  }
}

///|
test "from_bytes: rejects Multiple Master Type1 fixture" {
  let data = load_minimal_type1_mm_fixture()
  inspect(@base.detect_format(data), content="Type1Pfa")
  let result : Result[@base.FaceRec, @error.FTError] = Ok(from_bytes(data)) catch {
    err => Err(err)
  }
  inspect(result is Err(_), content="true")
  match result {
    Err(err) => inspect(err, content="UnimplementedFeature")
    _ => ()
  }
}
