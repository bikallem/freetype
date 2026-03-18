///|
test "parse_table_directory: minimal SFNT" {
  // Construct a minimal SFNT with 1 table (head)
  let buf = FixedArray::make(12 + 16, b'\x00')
  // sfVersion = 0x00010000 (TrueType)
  buf[0] = b'\x00'
  buf[1] = b'\x01'
  buf[2] = b'\x00'
  buf[3] = b'\x00'
  // numTables = 1
  buf[5] = b'\x01'
  // searchRange = 16
  buf[7] = b'\x10'
  // entrySelector = 0
  // rangeShift = 0
  // Table record: tag = 'head' (0x68656164)
  buf[12] = b'\x68'
  buf[13] = b'\x65'
  buf[14] = b'\x61'
  buf[15] = b'\x64'
  // checksum = 0
  // offset = 28 (right after directory)
  buf[23] = b'\x1C'
  // length = 54
  buf[27] = b'\x36'
  let reader = @stream.ByteReader::new(Bytes::from_array(buf[:]))
  let dir = parse_table_directory(reader)
  inspect(dir.sfnt_version, content="65536") // 0x00010000
  inspect(dir.num_tables, content="1")
  inspect(dir.tables.length(), content="1")
  inspect(dir.tables[0].tag == @types.tag_head, content="true")
  inspect(dir.tables[0].offset, content="28")
  inspect(dir.tables[0].length, content="54")
}

///|
test "TableDirectory::find_table" {
  let dir = TableDirectory::new(
    sfnt_version=0x00010000U,
    num_tables=2U,
    search_range=0U,
    entry_selector=0U,
    range_shift=0U,
    tables=[
      TableRecord::new(
        tag=@types.tag_head,
        checksum=0U,
        offset=100U,
        length=54U,
      ),
      TableRecord::new(
        tag=@types.tag_hhea,
        checksum=0U,
        offset=200U,
        length=36U,
      ),
    ],
  )
  inspect(dir.find_table(@types.tag_head) is Some(_), content="true")
  inspect(dir.find_table(@types.tag_hhea) is Some(_), content="true")
  inspect(dir.find_table(@types.tag_glyf) is Some(_), content="false")
}

///|
test "CmapFormat0::char_index" {
  let glyph_ids = FixedArray::make(256, b'\x00')
  glyph_ids[65] = b'\x24' // 'A' → glyph 36
  glyph_ids[66] = b'\x25' // 'B' → glyph 37
  let cmap = CmapFormat0::new(glyph_ids~)
  inspect(cmap.char_index(65U), content="36")
  inspect(cmap.char_index(66U), content="37")
  inspect(cmap.char_index(0U), content="0")
  inspect(cmap.char_index(256U), content="0") // out of range
}

///|
test "CmapFormat6::char_index" {
  let cmap = CmapFormat6::new(first_code=32U, entry_count=3U, glyph_ids=[
    10U, 11U, 12U,
  ])
  inspect(cmap.char_index(32U), content="10")
  inspect(cmap.char_index(33U), content="11")
  inspect(cmap.char_index(34U), content="12")
  inspect(cmap.char_index(31U), content="0") // below range
  inspect(cmap.char_index(35U), content="0") // above range
}

///|
test "CmapFormat12::char_index" {
  let cmap = CmapFormat12::new(groups=[
    CmapFormat12Group::new(
      start_char_code=32U,
      end_char_code=126U,
      start_glyph_id=3U,
    ),
    CmapFormat12Group::new(
      start_char_code=0x4E00U,
      end_char_code=0x9FFFU,
      start_glyph_id=500U,
    ),
  ])
  // ASCII 'A' (65) → 3 + (65 - 32) = 36
  inspect(cmap.char_index(65U), content="36")
  // CJK: 0x4E00 → 500
  inspect(cmap.char_index(0x4E00U), content="500")
  // CJK: 0x4E01 → 501
  inspect(cmap.char_index(0x4E01U), content="501")
  // Not in any range
  inspect(cmap.char_index(0U), content="0")
  inspect(cmap.char_index(200U), content="0")
}

///|
test "KernTable::get_kerning" {
  let kern = KernTable::new(pairs=[
    KernPair::new(left=36U, right=55U, value=-80),
    KernPair::new(left=36U, right=82U, value=-50),
    KernPair::new(left=55U, right=36U, value=-30),
  ])
  inspect(kern.get_kerning(36U, 55U), content="-80")
  inspect(kern.get_kerning(36U, 82U), content="-50")
  inspect(kern.get_kerning(55U, 36U), content="-30")
  inspect(kern.get_kerning(1U, 2U), content="0") // not found
}

///|
test "HmtxTable::get_metrics" {
  let hmtx = HmtxTable::new(
    metrics=[
      LongHorMetric::new(advance_width=600U, lsb=50),
      LongHorMetric::new(advance_width=700U, lsb=60),
    ],
    left_side_bearings=[30, 40],
  )
  // First metric
  let (aw, lsb) = hmtx.get_metrics(0U)
  inspect(aw, content="600")
  inspect(lsb, content="50")
  //
  // Glyph beyond num_h_metrics uses last advance_width
  let (aw2, lsb2) = hmtx.get_metrics(2U)
  inspect(aw2, content="700") // last advance width
  inspect(lsb2, content="30") // from left_side_bearings[0]
}

///|
test "decode_utf16_be" {
  // "AB" in UTF-16 BE = 0x00 0x41 0x00 0x42
  let data : Bytes = [0x00, 0x41, 0x00, 0x42]
  let name_table = NameTable::new(
    format=0U,
    count=1U,
    string_offset=0U,
    records=[
      NameRecord::new(
        platform_id=3U,
        encoding_id=1U,
        language_id=0x0409U,
        name_id=name_id_font_family,
        length=4U,
        offset=0U,
      ),
    ],
    string_data=data,
  )
  inspect(
    name_table.get_name(name_id_font_family),
    content=(
      #|Some("AB")
    ),
  )
}
