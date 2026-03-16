///|
/// Detected font format from header bytes.
pub(all) enum FontFormat {
  TrueType
  TrueTypeCollection
  CffOpenType // 'OTTO' — CFF inside SFNT
  Woff1
  Woff2
  Type1Pfa
  Type1Pfb
  Cid
  Bdf
  Pcf
  WindowsFnt
  Pfr
  Unknown
} derive(Eq, Show)

///|
/// Detect font format from the first few bytes of the file.
/// Pure function — no side effects, no I/O.
pub fn detect_format(data : Bytes) -> FontFormat {
  let len = data.length()
  if len < 4 {
    return Unknown
  }
  let b0 = data[0]
  let b1 = data[1]
  let b2 = data[2]
  let b3 = data[3]
  let tag = (b0.to_uint() << 24) |
    (b1.to_uint() << 16) |
    (b2.to_uint() << 8) |
    b3.to_uint()
  // TrueType: version 1.0 (0x00010000)
  if tag == 0x00010000U {
    return TrueType
  }
  // TrueType: 'true' (Apple)
  if tag == @types.tag_true {
    return TrueType
  }
  // CFF/OpenType: 'OTTO'
  if tag == @types.tag_OTTO {
    return CffOpenType
  }
  // TrueType Collection: 'ttcf'
  if tag == @types.tag_ttcf {
    return TrueTypeCollection
  }
  // WOFF1: 'wOFF'
  if tag == @types.tag_wOFF {
    return Woff1
  }
  // WOFF2: 'wOF2'
  if tag == @types.tag_wOF2 {
    return Woff2
  }
  // Type 1 PFB: 0x80 0x01
  if b0 == 0x80 && b1 == 0x01 {
    return Type1Pfb
  }
  // Type 1 PFA: '%!PS' or '%!Fo'
  if b0 == b'%' && b1 == b'!' {
    if len >= 11 {
      // Check for '%!PS-AdobeFont' or '%!FontType1'
      return Type1Pfa
    }
    return Type1Pfa
  }
  // BDF: 'STAR' (STARTFONT)
  if b0 == b'S' && b1 == b'T' && b2 == b'A' && b3 == b'R' {
    return Bdf
  }
  // PCF: 0x01 0x66 0x63 0x70 ('\x01fcp')
  if b0 == 0x01 && b1 == 0x66 && b2 == 0x63 && b3 == 0x70 {
    return Pcf
  }
  // Windows FNT: MZ header
  if b0 == b'M' && b1 == b'Z' {
    return WindowsFnt
  }
  // PFR: 0x50 0x46 0x52 0x30 ('PFR0')
  if b0 == 0x50 && b1 == 0x46 && b2 == 0x52 && b3 == 0x30 {
    return Pfr
  }
  Unknown
}
