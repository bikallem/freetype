///|
test "eexec_decrypt basic" {
  // Test eexec decryption with a known small input (8 bytes).
  // First 4 bytes are seed, remaining 4 are actual output.
  let data : Bytes = [0xD9, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
  let result = @type1.eexec_decrypt(data)
  // Result should skip first 4 bytes (random seed), giving us the remaining bytes
  inspect(result.length(), content="4")
}

///|
test "eexec_decrypt empty" {
  let data : Bytes = []
  let result = @type1.eexec_decrypt(data)
  inspect(result.length(), content="0")
}

///|
test "eexec_decrypt short input" {
  // Less than 4 bytes: should return empty since we skip 4 seed bytes
  let data : Bytes = [0x01, 0x02, 0x03]
  let result = @type1.eexec_decrypt(data)
  inspect(result.length(), content="0")
}

///|
test "charstring_decrypt basic" {
  // Test charstring decryption with key 4330
  let data : Bytes = [0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
  let result = @type1.charstring_decrypt(data)
  // Should skip first 4 bytes (lenIV=4), giving 4 bytes
  inspect(result.length(), content="4")
}

///|
test "charstring_decrypt custom lenIV" {
  let data : Bytes = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
  let result = @type1.charstring_decrypt(data, len_iv=2)
  // Skip first 2 bytes, giving 4 bytes
  inspect(result.length(), content="4")
}

///|
test "parse_type1_pfb segment parsing" {
  // Construct a minimal PFB with an ASCII segment and EOF
  // ASCII segment: marker=0x80, type=1, length=10 (LE), then 10 bytes of spaces
  // EOF segment: marker=0x80, type=3
  let pfb : Bytes = [
    0x80, 0x01, // marker + ASCII type
     0x0A, 0x00, 0x00, 0x00, // length = 10 (LE)
     0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, // 10 spaces
     0x80, 0x03, // marker + EOF type
  ]
  let font = @type1.parse_type1_pfb(pfb)
  // Font name should be empty since our ASCII data doesn't contain /FontName
  inspect(font.font_name, content="")
}

///|
test "parse_type1_pfb invalid marker" {
  let pfb : Bytes = [0x00, 0x01, 0x00, 0x00, 0x00, 0x00]
  let result : Result[_, _] = Ok(@type1.parse_type1_pfb(pfb)) catch {
    err => Err(err)
  }
  inspect(result.is_err(), content="true")
}

///|
test "Type1Font creation" {
  let font = @type1.Type1Font::new()
  inspect(font.font_name, content="")
  inspect(font.len_iv, content="4")
  inspect(font.paint_type, content="0")
  inspect(font.std_hw, content="0")
  inspect(font.std_vw, content="0")
  inspect(font.charstrings.size(), content="0")
  inspect(font.subrs.length(), content="0")
}
