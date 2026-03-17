///|
test "validate_coverage format 1 valid" {
  // Format 1: format(2) + count(2) + glyph_ids(2 each)
  // Format=1, count=3, glyphs: 10, 20, 30
  let data = b"\x00\x01\x00\x03\x00\x0A\x00\x14\x00\x1E"
  let reader = @stream.ByteReader::new(data)
  let results = @otvalid.validate_coverage(reader, 0U)
  inspect(results.contains(@otvalid.Valid), content="true")
}

///|
test "validate_class_def format 1 valid" {
  // Format 1: format(2) + startGlyph(2) + count(2) + classValues(2 each)
  let data = b"\x00\x01\x00\x05\x00\x02\x00\x01\x00\x02"
  let reader = @stream.ByteReader::new(data)
  let results = @otvalid.validate_class_def(reader, 0U)
  inspect(results.contains(@otvalid.Valid), content="true")
}

///|
test "validate_gdef version check" {
  // GDEF version 1.0
  let data = b"\x00\x01\x00\x00"
  let reader = @stream.ByteReader::new(data)
  let results = @otvalid.validate_gdef(reader, 0U)
  inspect(results.contains(@otvalid.Valid), content="true")
}

///|
test "validate_coverage invalid format" {
  let data = b"\x00\x05\x00\x00"
  let reader = @stream.ByteReader::new(data)
  let results = @otvalid.validate_coverage(reader, 0U)
  inspect(results.length() > 0, content="true")
  // Should contain an error
  let has_error = results
    .iter()
    .any(fn(r) {
      match r {
        @otvalid.Error(_) => true
        _ => false
      }
    })
  inspect(has_error, content="true")
}
