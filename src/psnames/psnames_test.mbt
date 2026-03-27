///|
test "unicode_value: basic ASCII names" {
  assert_eq(unicode_value("space"), 0x0020U)
  assert_eq(unicode_value("exclam"), 0x0021U)
  assert_eq(unicode_value("A"), 0x0041U)
  assert_eq(unicode_value("Z"), 0x005AU)
  assert_eq(unicode_value("a"), 0x0061U)
  assert_eq(unicode_value("z"), 0x007AU)
  assert_eq(unicode_value("zero"), 0x0030U)
  assert_eq(unicode_value("nine"), 0x0039U)
}

///|
test "unicode_value: extended Latin names" {
  assert_eq(unicode_value("Aacute"), 0x00C1U)
  assert_eq(unicode_value("ccedilla"), 0x00E7U)
  assert_eq(unicode_value("germandbls"), 0x00DFU)
  assert_eq(unicode_value("AE"), 0x00C6U)
  assert_eq(unicode_value("oslash"), 0x00F8U)
  assert_eq(unicode_value("Scaron"), 0x0160U)
  assert_eq(unicode_value("zcaron"), 0x017EU)
}

///|
test "unicode_value: typographic names" {
  assert_eq(unicode_value("endash"), 0x2013U)
  assert_eq(unicode_value("emdash"), 0x2014U)
  assert_eq(unicode_value("bullet"), 0x2022U)
  assert_eq(unicode_value("ellipsis"), 0x2026U)
  assert_eq(unicode_value("fi"), 0xFB01U)
  assert_eq(unicode_value("fl"), 0xFB02U)
  assert_eq(unicode_value("trademark"), 0x2122U)
  assert_eq(unicode_value("copyright"), 0x00A9U)
}

///|
test "unicode_value: uni prefix" {
  assert_eq(unicode_value("uni0041"), 0x0041U) // A
  assert_eq(unicode_value("uni00E9"), 0x00E9U) // eacute
  assert_eq(unicode_value("uniFF00"), 0xFF00U)
  // With variant suffix
  assert_eq(unicode_value("uni0041.alt"), 0x0041U | 0x80000000U)
}

///|
test "unicode_value: uni prefix invalid" {
  // Too few digits
  assert_eq(unicode_value("uni004"), 0U)
  // Too many digits (5 digits, not exactly 4)
  assert_eq(unicode_value("uni00410"), 0U)
  // Lowercase hex not accepted
  assert_eq(unicode_value("uni00e9"), 0U)
}

///|
test "unicode_value: u prefix" {
  assert_eq(unicode_value("u0041"), 0x0041U)
  assert_eq(unicode_value("u00E9"), 0x00E9U)
  assert_eq(unicode_value("u1F600"), 0x1F600U)
  assert_eq(unicode_value("u10FFFF"), 0x10FFFFU)
  // With variant suffix
  assert_eq(unicode_value("u0041.smcp"), 0x0041U | 0x80000000U)
}

///|
test "unicode_value: u prefix invalid" {
  // Too few digits
  assert_eq(unicode_value("u004"), 0U)
  // Lowercase
  assert_eq(unicode_value("u00e9"), 0U)
}

///|
test "unicode_value: variant bit" {
  let result = unicode_value("space.alt")
  assert_eq(result, 0x0020U | 0x80000000U)
  // Dot at start is not a variant
  assert_eq(unicode_value(".notdef"), 0U)
}

///|
test "unicode_value: unknown names" {
  assert_eq(unicode_value("nonexistent_glyph_xyz"), 0U)
  assert_eq(unicode_value(""), 0U)
}

///|
test "macintosh_name: basic lookups" {
  assert_eq(macintosh_name(0U), ".notdef")
  assert_eq(macintosh_name(1U), ".null")
  assert_eq(macintosh_name(2U), "nonmarkingreturn")
  assert_eq(macintosh_name(3U), "space")
  assert_eq(macintosh_name(36U), "A")
  assert_eq(macintosh_name(68U), "a")
  assert_eq(macintosh_name(257U), "dcroat")
}

///|
test "macintosh_name: out of range" {
  assert_eq(macintosh_name(258U), ".notdef")
  assert_eq(macintosh_name(1000U), ".notdef")
}

///|
test "standard_string: basic lookups" {
  assert_eq(standard_string(0U), Some(".notdef"))
  assert_eq(standard_string(1U), Some("space"))
  assert_eq(standard_string(2U), Some("exclam"))
  assert_eq(standard_string(34U), Some("A"))
  assert_eq(standard_string(66U), Some("a"))
  assert_eq(standard_string(390U), Some("Semibold"))
}

///|
test "standard_string: out of range" {
  assert_eq(standard_string(391U), None)
  assert_eq(standard_string(1000U), None)
}

///|
test "standard_encoding_sid: basic lookups" {
  assert_eq(standard_encoding_sid(0x20U), 1) // space
  assert_eq(standard_encoding_sid(0x21U), 2) // exclam
  assert_eq(standard_encoding_sid(0x41U), 34) // A
  assert_eq(standard_encoding_sid(0x61U), 66) // a
  assert_eq(standard_encoding_sid(0x00U), 0) // .notdef
}

///|
test "expert_encoding_sid: basic lookups" {
  assert_eq(expert_encoding_sid(0x20U), 1) // space
  assert_eq(expert_encoding_sid(0x00U), 0) // .notdef
}

///|
test "latin1_name: basic lookups" {
  assert_eq(latin1_name(0x20U), Some("space"))
  assert_eq(latin1_name(0xA0U), Some("nonbreakingspace"))
  assert_eq(latin1_name(0xC1U), Some("Aacute"))
  assert_eq(latin1_name(0xFFU), Some("ydieresis"))
  assert_eq(latin1_name(0x80U), None)
}

///|
test "adobe_glyph_index: known names" {
  assert_eq(adobe_glyph_index("space"), 0x0020U)
  assert_eq(adobe_glyph_index("A"), 0x0041U)
  assert_eq(adobe_glyph_index("copyright"), 0x00A9U)
}

///|
test "adobe_glyph_index: unknown names" {
  assert_eq(adobe_glyph_index("nonexistent"), 0U)
  assert_eq(adobe_glyph_index(".notdef"), 0U)
}

///|
test "build_unicode_map: extra aliases match FreeType behavior" {
  let cmap = build_unicode_map([".notdef", "space", "Delta"])
  assert_eq(cmap[0x0020U], 1U)
  assert_eq(cmap[0x00A0U], 1U)
  assert_eq(cmap[0x0394U], 2U)
}

///|
test "build_unicode_map: direct glyph wins over extra alias" {
  let cmap = build_unicode_map([".notdef", "space", "uni00A0"])
  assert_eq(cmap[0x0020U], 1U)
  assert_eq(cmap[0x00A0U], 2U)
}

///|
test "build_unicode_map: base glyph wins over variant" {
  let cmap = build_unicode_map(["A.swash", "A"])
  assert_eq(cmap[0x0041U], 1U)
}
