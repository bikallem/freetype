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
  inspect(dir.tables[0].tag == @types.TAG_HEAD, content="true")
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
        tag=@types.TAG_HEAD,
        checksum=0U,
        offset=100U,
        length=54U,
      ),
      TableRecord::new(
        tag=@types.TAG_HHEA,
        checksum=0U,
        offset=200U,
        length=36U,
      ),
    ],
  )
  inspect(dir.find_table(@types.TAG_HEAD) is Some(_), content="true")
  inspect(dir.find_table(@types.TAG_HHEA) is Some(_), content="true")
  inspect(dir.find_table(@types.TAG_GLYF) is Some(_), content="false")
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
test "CmapFormat2::char_index" {
  let sub_header_keys = FixedArray::make(256, 0)
  sub_header_keys[0x81] = 1
  let cmap = CmapFormat2::new(
    sub_header_keys~,
    sub_headers=[
      CmapFormat2SubHeader::new(
        first_code=32U,
        entry_count=1U,
        id_delta=0,
        glyph_array_index=0,
      ),
      CmapFormat2SubHeader::new(
        first_code=0x40U,
        entry_count=2U,
        id_delta=0,
        glyph_array_index=1,
      ),
    ],
    glyph_ids=[5U, 700U, 701U],
  )
  inspect(cmap.char_index(32U), content="5")
  inspect(cmap.char_index(0x8140U), content="700")
  inspect(cmap.char_index(0x8141U), content="701")
  inspect(cmap.char_index(0x813FU), content="0")
  inspect(cmap.char_index(0x110000U), content="0")
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
test "CmapFormat8::char_index" {
  let cmap = CmapFormat8::new(groups=[
    CmapFormat12Group::new(
      start_char_code=0x10000U,
      end_char_code=0x10002U,
      start_glyph_id=700U,
    ),
  ])
  inspect(cmap.char_index(0x10000U), content="700")
  inspect(cmap.char_index(0x10001U), content="701")
  inspect(cmap.char_index(0x10002U), content="702")
  inspect(cmap.char_index(0xFFFFU), content="0")
}

///|
test "CmapFormat10::char_index" {
  let cmap = CmapFormat10::new(start_char_code=0x10000U, num_chars=3U, glyph_ids=[
    700U, 701U, 702U,
  ])
  inspect(cmap.char_index(0x10000U), content="700")
  inspect(cmap.char_index(0x10001U), content="701")
  inspect(cmap.char_index(0x10002U), content="702")
  inspect(cmap.char_index(0xFFFFU), content="0")
  inspect(cmap.char_index(0x10003U), content="0")
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
test "CmapFormat13::char_index" {
  let cmap = CmapFormat13::new(groups=[
    CmapFormat13Group::new(start_char_code=32U, end_char_code=126U, glyph_id=3U),
    CmapFormat13Group::new(
      start_char_code=0x1F600U,
      end_char_code=0x1F64FU,
      glyph_id=900U,
    ),
  ])
  inspect(cmap.char_index(65U), content="3")
  inspect(cmap.char_index(90U), content="3")
  inspect(cmap.char_index(0x1F600U), content="900")
  inspect(cmap.char_index(0x1F602U), content="900")
  inspect(cmap.char_index(0U), content="0")
}

///|
test "parse_cmap_subtable: format 10" {
  let data : Bytes = [
    0x00, 0x0A, // format
     0x00, 0x00, // reserved
     0x00, 0x00, 0x00, 0x18, // length
     0x00, 0x00, 0x00, 0x00, // language
     0x00, 0x01, 0x00, 0x00, // startCharCode = 0x10000
     0x00, 0x00, 0x00, 0x02, // numChars = 2
     0x02, 0xBC, // glyph 700
     0x02, 0xBD, // glyph 701
  ]
  let reader = @stream.ByteReader::new(data)
  let lookup = parse_cmap_subtable(reader, 0U, 0U)
  let gid = match lookup {
    Format10(t) => t.char_index(0x10001U)
    _ => 0xFFFFFFFFU
  }
  assert_eq(gid, 701U)
}

///|
test "parse_cmap_subtable: format 2" {
  let data : Bytes = [
      0x00, 0x02, // format
       0x02, 0x1C, // length = 540
       0x00, 0x00,
    ] + // language
    Bytes::from_array(
      ({
        let keys = FixedArray::make(512, b'\x00')
        keys[0x81 * 2 + 1] = b'\x08' // subHeader index 1
        keys
      })[:],
    ) +
    [
      0x00, 0x20, // subHeader 0 firstCode
       0x00, 0x01, // entryCount
       0x00, 0x00, // idDelta
       0x00, 0x0A, // idRangeOffset -> first glyph word
       0x00, 0x40, // subHeader 1 firstCode
       0x00, 0x02, // entryCount
       0x00, 0x00, // idDelta
       0x00, 0x04, // idRangeOffset -> second glyph word
       0x00, 0x05, // glyphIdArray[0]
       0x02, 0xBC, // glyphIdArray[1] = 700
       0x02, 0xBD, // glyphIdArray[2] = 701
    ]
  let reader = @stream.ByteReader::new(data)
  let lookup = parse_cmap_subtable(reader, 0U, 0U)
  let gid = match lookup {
    Format2(t) => t.char_index(0x8141U)
    _ => 0xFFFFFFFFU
  }
  assert_eq(gid, 701U)
}

///|
test "parse_cmap_subtable: format 8" {
  let header : Bytes = [
    0x00, 0x08, // format
     0x00, 0x00, // reserved
     0x00, 0x00, 0x20, 0x1C, // length = 8204
     0x00, 0x00, 0x00, 0x00, // language
  ]
  let is32 = FixedArray::make(8192, b'\x00')
  let groups : Bytes = [
    0x00, 0x00, 0x00, 0x01, // numGroups = 1
     0x00, 0x01, 0x00, 0x00, // startCharCode = 0x10000
     0x00, 0x01, 0x00, 0x02, // endCharCode = 0x10002
     0x00, 0x00, 0x02, 0xBC, // startGlyphId = 700
  ]
  let data = header + Bytes::from_array(is32[:]) + groups
  let reader = @stream.ByteReader::new(data)
  let lookup = parse_cmap_subtable(reader, 0U, 0U)
  let gid = match lookup {
    Format8(t) => t.char_index(0x10001U)
    _ => 0xFFFFFFFFU
  }
  assert_eq(gid, 701U)
}

///|
test "parse_cmap_subtable: format 13" {
  let data : Bytes = [
    0x00, 0x0D, // format
     0x00, 0x00, // reserved
     0x00, 0x00, 0x00, 0x1C, // length
     0x00, 0x00, 0x00, 0x00, // language
     0x00, 0x00, 0x00, 0x01, // numGroups = 1
     0x00, 0x01, 0xF6, 0x00, // startCharCode = 0x1F600
     0x00, 0x01, 0xF6, 0x02, // endCharCode = 0x1F602
     0x00, 0x00, 0x03, 0x84, // glyphId = 900
  ]
  let reader = @stream.ByteReader::new(data)
  let lookup = parse_cmap_subtable(reader, 0U, 0U)
  let gid = match lookup {
    Format13(t) => t.char_index(0x1F601U)
    _ => 0xFFFFFFFFU
  }
  assert_eq(gid, 900U)
}

///|
test "parse_cmap_subtable: format 14" {
  let data : Bytes = [
    0x00, 0x0E, // format
     0x00, 0x00, 0x00, 0x26, // length = 38
     0x00, 0x00, 0x00, 0x01, // numSelectorRecords = 1
     0x00, 0xFE, 0x0F, // varSelector = U+FE0F
     0x00, 0x00, 0x00, 0x15, // default UVS offset = 21
     0x00, 0x00, 0x00, 0x1D, // non-default UVS offset = 29
     0x00, 0x00, 0x00, 0x01, // default numRanges = 1
     0x00, 0x00, 0x20, 0x00, // U+0020, additionalCount = 0
     0x00, 0x00, 0x00, 0x01, // non-default numMappings = 1
     0x00, 0x00, 0x41, // U+0041
     0x00, 0x03, // glyph id = 3
  ]
  let reader = @stream.ByteReader::new(data)
  let lookup = parse_cmap_subtable(reader, 0U, 0U)
  match lookup {
    Format14(t) => {
      assert_eq(
        t.char_variant_index(0x20U, 0xFE0FU, fn(charcode) {
          if charcode == 0x20U {
            1U
          } else {
            0U
          }
        }),
        1U,
      )
      assert_eq(
        t.char_variant_index(0x41U, 0xFE0FU, fn(charcode) {
          if charcode == 0x41U {
            2U
          } else {
            0U
          }
        }),
        3U,
      )
      assert_eq(
        t.char_variant_is_default(0x20U, 0xFE0FU, fn(_charcode) { 0U }),
        1,
      )
      assert_eq(
        t.char_variant_is_default(0x41U, 0xFE0FU, fn(_charcode) { 0U }),
        0,
      )
      assert_eq(
        t.char_variant_is_default(0x42U, 0xFE0FU, fn(_charcode) { 0U }),
        -1,
      )
      let selectors = t.variant_selectors()
      assert_eq(selectors.length(), 1)
      assert_eq(selectors[0], 0xFE0FU)
      let variants = t.variants_of_char(0x41U)
      assert_eq(variants.length(), 1)
      assert_eq(variants[0], 0xFE0FU)
      let chars = t.chars_of_variant(0xFE0FU)
      assert_eq(chars.length(), 2)
      assert_eq(chars[0], 0x20U)
      assert_eq(chars[1], 0x41U)
    }
    _ => inspect(false, content="true")
  }
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
test "reconstruct_hmtx_table: mixed explicit and inferred lsbs" {
  let transformed : Bytes = [
    0x02, // proportional lsbs present, monospace lsbs inferred from xMin
     0x01, 0xF4, // advance width 500
     0x02, 0x58, // advance width 600
     0x00, 0x0A, // lsb 10
     0x00, 0x14, // lsb 20
  ]
  let hmtx = reconstruct_hmtx_table(transformed, 3, 2, [10, 20, 30])
  inspect(hmtx.length(), content="10")
  inspect(hmtx.unsafe_read_uint16_be(0), content="500")
  inspect(hmtx.unsafe_read_uint16_be(4), content="600")
  inspect(hmtx.unsafe_read_uint16_be(8), content="30")
}

///|
test "reconstruct_hmtx_table: all lsbs inferred from xMin" {
  let transformed : Bytes = [
    0x03, // all lsbs omitted
     0x01, 0xF4, // advance width 500
     0x02, 0x58,
  ] // advance width 600
  let hmtx = reconstruct_hmtx_table(transformed, 3, 2, [11, 22, 33])
  inspect(hmtx.unsafe_read_uint16_be(2), content="11")
  inspect(hmtx.unsafe_read_uint16_be(6), content="22")
  inspect(hmtx.unsafe_read_uint16_be(8), content="33")
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
        name_id=NAME_ID_FONT_FAMILY,
        length=4U,
        offset=0U,
      ),
    ],
    string_data=data,
  )
  inspect(
    name_table.get_name(NAME_ID_FONT_FAMILY),
    content=(
      #|Some("AB")
    ),
  )
}
