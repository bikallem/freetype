///|
test "CffIndex: empty" {
  // Empty INDEX: count=0
  let data : Bytes = [0x00, 0x00]
  let reader = @stream.ByteReader::new(data)
  let idx = @cff.parse_cff_index(reader)
  inspect(idx.count, content="0")
}

///|
test "CffIndex: single item" {
  // INDEX with 1 item, offSize=1
  // count=1, offSize=1, offsets=[1, 4], data="abc"
  let data : Bytes = [
    0x00, 0x01, // count = 1
     0x01, // offSize = 1
     0x01, 0x04, // offsets: 1, 4 (1-based, so data is 3 bytes)
     b'a', b'b', b'c',
  ] // data
  let reader = @stream.ByteReader::new(data)
  let idx = @cff.parse_cff_index(reader)
  inspect(idx.count, content="1")
  let item = idx.get_item(0)
  inspect(item.length(), content="3")
  inspect(item[0], content="b'\\x61'") // 'a'
}

///|
test "CffIndex: two items" {
  // INDEX with 2 items
  let data : Bytes = [
    0x00, 0x02, // count = 2
     0x01, // offSize = 1
     0x01, 0x03, 0x06, // offsets: 1, 3, 6
     b'h', b'i', // item 0: "hi"
     b'b', b'y', b'e', // item 1: "bye"
  ]
  let reader = @stream.ByteReader::new(data)
  let idx = @cff.parse_cff_index(reader)
  inspect(idx.count, content="2")
  inspect(idx.get_item(0).length(), content="2")
  inspect(idx.get_item(1).length(), content="3")
}

///|
test "parse_top_dict: charstrings offset" {
  // DICT with operator 17 (CharStrings) and value 100
  // 100 encoded as: 247 b1 where (247-247)*256 + b1 + 108 = b1 + 108
  // So b1 = 100 - 108 = negative, try different encoding
  // 100 = 100 + 139 = 239 (single byte)
  let data : Bytes = [239, 17]
  let dict = @cff.parse_top_dict(data)
  inspect(dict.charstrings_offset, content="100")
}

///|
test "parse_top_dict: Private dict" {
  // Private: size 50, offset 200
  // 50 = 189, 200 = 28 0x00 0xC8
  let data : Bytes = [189, 28, 0x00, 0xC8, 18]
  let dict = @cff.parse_top_dict(data)
  inspect(dict.private_size, content="50")
  inspect(dict.private_offset, content="200")
}

///|
test "parse_private_dict: defaultWidthX" {
  // defaultWidthX = 500: 28 0x01 0xF4 20
  let data : Bytes = [28, 0x01, 0xF4, 20]
  let dict = @cff.parse_private_dict(data)
  inspect(dict.default_width_x, content="500")
}

///|
test "CffIndex::get_item out of range" {
  let idx = @cff.CffIndex::{
    count: 1U,
    off_size: 1,
    offsets: [1U, 4U],
    data_start: 0,
    data: b"abc",
  }
  let item = idx.get_item(5)
  inspect(item.length(), content="0")
}

///|
test "CffTopDict::new defaults" {
  let dict = @cff.CffTopDict::new()
  inspect(dict.charset_offset, content="0")
  inspect(dict.is_cid, content="false")
}
