///|
test "PcfFont creation" {
  let font = PcfFont::new()
  inspect(font.font_name, content="")
  inspect(font.num_glyphs, content="0")
  inspect(font.tables.length(), content="0")
}

///|
test "parse_pcf_header valid" {
  // Build minimal PCF: signature + 1 table entry
  // Signature: 0x70636601 in little-endian = 01 66 63 70
  // Table count: 1 (LE)
  // Table entry: type=1 (properties), format=0, size=100, offset=24
  let data : Bytes = [
    0x01, 0x66, 0x63, 0x70, // signature
     0x01, 0x00, 0x00, 0x00, // table count = 1
     0x01, 0x00, 0x00, 0x00, // type = 1 (properties)
     0x00, 0x00, 0x00, 0x00, // format = 0
     0x64, 0x00, 0x00, 0x00, // size = 100
     0x18, 0x00, 0x00, 0x00, // offset = 24
  ]
  let reader = @stream.ByteReader::new(data)
  let tables = parse_pcf_header(reader)
  inspect(tables.length(), content="1")
  inspect(tables[0].table_type, content="1")
  inspect(tables[0].size, content="100")
  inspect(tables[0].offset, content="24")
}

///|
test "parse_pcf_header invalid signature" {
  let data : Bytes = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
  let reader = @stream.ByteReader::new(data)
  let result : Result[_, _] = Ok(parse_pcf_header(reader)) catch {
    err => Err(err)
  }
  inspect(result is Err(_), content="true")
}
