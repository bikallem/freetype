///|
test "CffIndex: empty" {
  // Empty INDEX: count=0
  let data : Bytes = [0x00, 0x00]
  let reader = @stream.ByteReader::new(data)
  let idx = parse_cff_index(reader)
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
  let idx = parse_cff_index(reader)
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
  let idx = parse_cff_index(reader)
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
  let dict = parse_top_dict(data)
  inspect(dict.charstrings_offset, content="100")
}

///|
test "parse_top_dict: Private dict" {
  // Private: size 50, offset 200
  // 50 = 189, 200 = 28 0x00 0xC8
  let data : Bytes = [189, 28, 0x00, 0xC8, 18]
  let dict = parse_top_dict(data)
  inspect(dict.private_size, content="50")
  inspect(dict.private_offset, content="200")
}

///|
test "parse_top_dict: encoding offset" {
  let data : Bytes = [140, 16] // encoding offset 1 (expert)
  let dict = parse_top_dict(data)
  inspect(dict.encoding_offset(), content="1")
}

///|
test "parse_private_dict: defaultWidthX" {
  // defaultWidthX = 500: 28 0x01 0xF4 20
  let data : Bytes = [28, 0x01, 0xF4, 20]
  let dict = parse_private_dict(data)
  inspect(dict.default_width_x, content="500")
}

///|
test "parse_top_dict: FontMatrix real numbers" {
  let data : Bytes = [
    30, 0x0A, 0x00, 0x2F, // 0.002
     139, // 0
     139, // 0
     30, 0x0A, 0x00, 0x2F, // 0.002
     139, // 0
     139, // 0
     12, 7, // FontMatrix
  ]
  let dict = parse_top_dict(data)
  inspect(dict.font_matrix().length(), content="6")
  inspect((1.0 / dict.font_matrix()[0]).round().to_int(), content="500")
}

///|
test "parse_top_dict: underline defaults and override" {
  let defaults = parse_top_dict(b"")
  inspect(defaults.underline_position(), content="-100")
  inspect(defaults.underline_thickness(), content="50")

  let override_position = parse_top_dict([28, 0xFF, 0xB5, 12, 3])
  inspect(override_position.underline_position(), content="-75")
  inspect(override_position.underline_thickness(), content="50")
}

///|
test "parse_private_dict: BlueScale, BlueShift, BlueFuzz" {
  let data : Bytes = [
    30, 0x0A, 0x25, 0xFF, 12, 9, // BlueScale = 0.25
     146, 12, 10, // BlueShift = 7
     140, 12, 11,
  ] // BlueFuzz = 1
  let dict = parse_private_dict(data)
  inspect(dict.blue_scale(), content="Some(0.25)")
  inspect(dict.blue_shift(), content="Some(7)")
  inspect(dict.blue_fuzz(), content="Some(1)")
}

///|
fn load_scaled_fontmatrix_cff() -> Bytes {
  [
    1, 0, 4, 1, 0, 1, 1, 1, 18, 87, 105, 100, 116, 104, 84, 101, 115, 116, 45, 82,
    101, 103, 117, 108, 97, 114, 0, 1, 1, 1, 22, 30, 10, 0, 47, 139, 139, 30, 10,
    0, 47, 139, 139, 12, 7, 195, 15, 200, 17, 145, 225, 18, 0, 0, 0, 0, 0, 0, 1,
    0, 34, 0, 3, 1, 1, 2, 4, 19, 14, 189, 14, 247, 92, 189, 22, 247, 92, 249, 80,
    5, 247, 92, 253, 80, 5, 14, 248, 136, 20, 248, 36, 21,
  ]
}

///|
test "load_cff: non-default FontMatrix adjusts units_per_em" {
  let cff = load_cff(load_scaled_fontmatrix_cff(), 0)
  inspect(cff.units_per_em(), content="500")
}

///|
test "CffIndex::get_item out of range" {
  let idx = CffIndex::new(
    count=1U,
    off_size=1,
    offsets=[1U, 4U],
    data_start=0,
    data=b"abc",
  )
  let item = idx.get_item(5)
  inspect(item.length(), content="0")
}

///|
test "CffTopDict::new defaults" {
  let dict = CffTopDict::new()
  inspect(dict.charset_offset, content="0")
  inspect(dict.encoding_offset(), content="0")
  inspect(dict.is_cid, content="false")
}

///|
fn encode_cff_test_int(value : Int) -> Bytes {
  let byte_of = fn(n : Int) { n.to_byte() }
  if value >= -107 && value <= 107 {
    Bytes::from_array([byte_of(value + 139)])
  } else if value >= 108 && value <= 1131 {
    let adjusted = value - 108
    Bytes::from_array([byte_of(247 + adjusted / 256), byte_of(adjusted % 256)])
  } else if value >= -1131 && value <= -108 {
    let adjusted = -value - 108
    Bytes::from_array([byte_of(251 + adjusted / 256), byte_of(adjusted % 256)])
  } else if value >= -32768 && value <= 32767 {
    Bytes::from_array([
      b'\x1C',
      byte_of((value >> 8) & 0xFF),
      byte_of(value & 0xFF),
    ])
  } else {
    Bytes::from_array([
      b'\x1D',
      byte_of((value >> 24) & 0xFF),
      byte_of((value >> 16) & 0xFF),
      byte_of((value >> 8) & 0xFF),
      byte_of(value & 0xFF),
    ])
  }
}

///|
fn concat_test_bytes(chunks : Array[Bytes]) -> Bytes {
  let out : Array[Byte] = []
  for chunk in chunks {
    for byte in chunk {
      out.push(byte)
    }
  }
  Bytes::from_array(out[:])
}

///|
fn make_minimal_cff2_with_top_private() -> Bytes {
  let byte_of = fn(n : Int) { n.to_byte() }
  let private_dict = concat_test_bytes([
    encode_cff_test_int(2),
    Bytes::from_array([byte_of(19)]),
  ])
  let charstrings = Bytes::from_array([
    byte_of(0),
    byte_of(0),
    byte_of(0),
    byte_of(1),
    byte_of(1),
    byte_of(1),
    byte_of(2),
    byte_of(14),
  ])
  let global_subrs = Bytes::from_array([
    byte_of(0),
    byte_of(0),
    byte_of(0),
    byte_of(0),
  ])
  let local_subrs = Bytes::from_array([
    byte_of(0),
    byte_of(0),
    byte_of(0),
    byte_of(1),
    byte_of(1),
    byte_of(1),
    byte_of(2),
    byte_of(11),
  ])
  let top_dict_data_placeholder = concat_test_bytes([
    encode_cff_test_int(0),
    Bytes::from_array([byte_of(17)]),
    encode_cff_test_int(private_dict.length()),
    encode_cff_test_int(0),
    Bytes::from_array([byte_of(18)]),
  ])
  let charstrings_offset = 5 +
    top_dict_data_placeholder.length() +
    global_subrs.length()
  let private_offset = charstrings_offset + charstrings.length()
  let top_dict_data = concat_test_bytes([
    encode_cff_test_int(charstrings_offset),
    Bytes::from_array([byte_of(17)]),
    encode_cff_test_int(private_dict.length()),
    encode_cff_test_int(private_offset),
    Bytes::from_array([byte_of(18)]),
  ])
  concat_test_bytes([
    Bytes::from_array([byte_of(2), byte_of(0), byte_of(5)]),
    Bytes::from_array([
      byte_of((top_dict_data.length() >> 8) & 0xFF),
      byte_of(top_dict_data.length() & 0xFF),
    ]),
    top_dict_data,
    global_subrs,
    charstrings,
    private_dict,
    local_subrs,
  ])
}

///|
test "load_cff2: preserves top-level private data" {
  let cff = load_cff2(make_minimal_cff2_with_top_private(), 0, 1000U)
  inspect(cff.is_cff2(), content="true")
  inspect(cff.private_data() is Some(_), content="true")
  inspect(cff.local_subrs() is Some(_), content="true")
  inspect(cff.cached_local_subrs().length(), content="1")
}

///|
test "CffFont::private_dict_for_glyph uses fd_select without CID ROS" {
  let top_dict = CffTopDict::new()
  let private_dict = CffPrivateDict::new()
  private_dict.default_width_x = 10L
  let fd_private0 = CffPrivateDict::new()
  fd_private0.default_width_x = 20L
  let fd_private1 = CffPrivateDict::new()
  fd_private1.default_width_x = 30L
  let font : CffFont = {
    header: { major: 2, minor: 0, hdr_size: 5, off_size: 0 },
    name: "Test",
    family_name: "Test",
    style_name: "Regular",
    units_per_em: 1000U,
    is_fixed_pitch: false,
    top_dict,
    private_dict,
    private_data: None,
    charstrings: CffIndex::new(
      count=0U,
      off_size=0,
      offsets=[],
      data_start=0,
      data=b"",
    ),
    global_subrs: CffIndex::new(
      count=0U,
      off_size=0,
      offsets=[],
      data_start=0,
      data=b"",
    ),
    local_subrs: None,
    num_glyphs: 2U,
    custom_strings: [],
    glyph_names: [],
    encoding_glyphs: [],
    cached_local_subrs: [b"base"],
    fd_private_dicts: [fd_private0, fd_private1],
    fd_private_data: [b"a", b"b"],
    fd_local_subrs: [[b"fd0"], [b"fd1"]],
    fd_select: [0, 1],
    cached_global_subrs: [],
    is_cff2: true,
    vstore: None,
  }
  inspect(font.private_dict_for_glyph(0U).default_width_x(), content="20")
  inspect(font.private_dict_for_glyph(1U).default_width_x(), content="30")
  inspect(font.cached_local_subrs_for_glyph(1U).length(), content="1")
  inspect(font.cached_local_subrs_for_glyph(1U)[0], content="b\"fd1\"")
}
