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
  let tag = (b0.to_uint() << 24) |
    (b1.to_uint() << 16) |
    (data[2].to_uint() << 8) |
    data[3].to_uint()
  // Match on 4-byte tag for well-known signatures
  match tag {
    0x00010000U => TrueType // TrueType version 1.0
    t if t == @types.tag_true => TrueType // 'true' (Apple)
    t if t == @types.tag_OTTO => CffOpenType // 'OTTO'
    t if t == @types.tag_ttcf => TrueTypeCollection // 'ttcf'
    t if t == @types.tag_wOFF => Woff1 // 'wOFF'
    t if t == @types.tag_wOF2 => Woff2 // 'wOF2'
    0x53544152U => Bdf // 'STAR' (STARTFONT)
    0x01666370U => Pcf // '\x01fcp'
    0x50465230U => Pfr // 'PFR0'
    _ =>
      // Check 2-byte signatures
      match (b0, b1) {
        (0x80, 0x01) => Type1Pfb // PFB
        (0x25, 0x21) => Type1Pfa // '%!' (PFA)
        (0x4D, 0x5A) => WindowsFnt // 'MZ' (Windows FNT)
        _ => Unknown
      }
  }
}
