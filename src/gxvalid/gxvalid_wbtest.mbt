///|
test "validate_feat valid table" {
  // Build a minimal feat table: version 1.0, 1 feature entry
  // Header: version(4) + featureNameCount(2) + reserved(2) + reserved(4) = 12 bytes
  // Each feature entry: 12 bytes
  let data = b"\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x01\x00\x01\x00\x00\x00\x18\x00\x02\x00\x00"
  let reader = @stream.ByteReader::new(data)
  let result = validate_feat(reader, 0U, data.length().reinterpret_as_uint())
  inspect(result.issues.length(), content="0")
}

///|
test "validate_feat table too short" {
  let data = b"\x00\x01\x00\x00"
  let reader = @stream.ByteReader::new(data)
  let result = validate_feat(reader, 0U, 4U)
  inspect(result.issues.length() > 0, content="true")
}

///|
test "validate_kern_apple too short" {
  let data = b"\x00\x01\x00\x00"
  let reader = @stream.ByteReader::new(data)
  let result = validate_kern_apple(reader, 0U, 4U)
  inspect(result.issues.length() > 0, content="true")
}
