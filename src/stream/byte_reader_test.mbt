///|
test "ByteReader::read_byte" {
  let r = @stream.ByteReader::new(b"\x41\x42\x43")
  inspect(r.read_byte(), content="b'\\x41'")
  inspect(r.read_byte(), content="b'\\x42'")
  inspect(r.position(), content="2")
}

///|
test "ByteReader::read_u16_be" {
  let r = @stream.ByteReader::new(b"\x01\x02\x03\x04")
  inspect(r.read_u16_be(), content="258") // 0x0102
  inspect(r.read_u16_be(), content="772") // 0x0304
}

///|
test "ByteReader::read_u16_le" {
  let r = @stream.ByteReader::new(b"\x01\x02")
  inspect(r.read_u16_le(), content="513") // 0x0201
}

///|
test "ByteReader::read_i16_be" {
  let r = @stream.ByteReader::new(b"\xFF\xFE")
  inspect(r.read_i16_be(), content="-2") // 0xFFFE = -2
}

///|
test "ByteReader::read_u32_be" {
  let r = @stream.ByteReader::new(b"\x00\x01\x00\x00")
  inspect(r.read_u32_be(), content="65536") // 0x00010000
}

///|
test "ByteReader::read_u32_le" {
  let r = @stream.ByteReader::new(b"\x01\x00\x00\x00")
  inspect(r.read_u32_le(), content="1")
}

///|
test "ByteReader::seek and skip" {
  let r = @stream.ByteReader::new(b"\x00\x01\x02\x03\x04")
  r.seek(3)
  inspect(r.position(), content="3")
  inspect(r.read_byte(), content="b'\\x03'")
  r.seek(0)
  r.skip(2)
  inspect(r.read_byte(), content="b'\\x02'")
}

///|
test "ByteReader::seek out of bounds" {
  let r = @stream.ByteReader::new(b"\x00\x01")
  let result = try? r.seek(10)
  inspect(result, content="Err(InvalidStreamSeek)")
}

///|
test "ByteReader::read past end" {
  let r = @stream.ByteReader::new(b"\x00")
  ignore(r.read_byte())
  let result = try? r.read_byte()
  inspect(result, content="Err(InvalidStreamRead)")
}

///|
test "ByteReader::frame operations" {
  let r = @stream.ByteReader::new(b"\x00\x01\x02\x03\x04\x05\x06\x07")
  r.seek(2)
  r.enter_frame(4)
  inspect(r.in_frame(), content="true")
  inspect(r.get_byte(), content="b'\\x02'")
  inspect(r.get_u16_be(), content="772") // 0x0304
  inspect(r.get_byte(), content="b'\\x05'")
  inspect(r.frame_remaining(), content="0")
  r.exit_frame()
  inspect(r.in_frame(), content="false")
  // Position should be past the frame
  inspect(r.position(), content="6")
}

///|
test "ByteReader::nested frame rejected" {
  let r = @stream.ByteReader::new(b"\x00\x01\x02\x03")
  r.enter_frame(2)
  let result = try? r.enter_frame(1)
  inspect(result, content="Err(NestedFrameAccess)")
  r.exit_frame()
}

///|
test "ByteReader::read_u24_be" {
  let r = @stream.ByteReader::new(b"\x01\x02\x03")
  inspect(r.read_u24_be(), content="66051") // 0x010203
}

///|
test "ByteReader::read_bytes" {
  let r = @stream.ByteReader::new(b"\x41\x42\x43\x44")
  let bs = r.read_bytes(3)
  inspect(bs.length(), content="3")
  inspect(bs[0], content="b'\\x41'")
  inspect(bs[2], content="b'\\x43'")
}

///|
test "ByteReader::get_i32_be" {
  let r = @stream.ByteReader::new(b"\xFF\xFF\xFF\xFE")
  r.enter_frame(4)
  inspect(r.get_i32_be(), content="-2")
  r.exit_frame()
}

///|
test "ByteReader::get_i64_be" {
  let r = @stream.ByteReader::new(b"\x00\x00\x00\x00\x00\x00\x00\x2A")
  r.enter_frame(8)
  inspect(r.get_i64_be(), content="42")
  r.exit_frame()
}
