///|
/// Detected font format from header bytes.
pub(all) enum FontFormat {
  TrueType
  TrueTypeCollection
  CffOpenType // 'OTTO' — CFF inside SFNT
  Cff2OpenType // 'OTTO' — CFF2 inside SFNT (unsupported)
  CffStandalone // bare CFF (major version 1)
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
fn read_be_u16(data : Bytes, offset : Int) -> UInt? {
  if offset < 0 || offset + 1 >= data.length() {
    None
  } else {
    Some((data[offset].to_uint() << 8) | data[offset + 1].to_uint())
  }
}

///|
fn read_be_u32(data : Bytes, offset : Int) -> UInt? {
  if offset < 0 || offset + 3 >= data.length() {
    None
  } else {
    Some(
      (data[offset].to_uint() << 24) |
      (data[offset + 1].to_uint() << 16) |
      (data[offset + 2].to_uint() << 8) |
      data[offset + 3].to_uint(),
    )
  }
}

///|
fn detect_otf_sfnt_format(data : Bytes) -> FontFormat {
  match read_be_u16(data, 4) {
    Some(num_tables) => {
      let mut saw_cff = false
      for i in 0..<num_tables.reinterpret_as_int() {
        let record_offset = 12 + i * 16
        match read_be_u32(data, record_offset) {
          Some(tag) => {
            if tag == @types.TAG_CFF2 {
              return Cff2OpenType
            }
            if tag == @types.TAG_CFF {
              saw_cff = true
            }
          }
          None => break
        }
      }
      if saw_cff {
        CffOpenType
      } else {
        // Keep the historical bucket for generic OTTO SFNTs when the table
        // directory is truncated or does not expose CFF/CFF2 yet.
        CffOpenType
      }
    }
    None => CffOpenType
  }
}

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
    t if t == @types.TAG_TRUE => TrueType // 'true' (Apple)
    t if t == @types.TAG_OTTO => detect_otf_sfnt_format(data) // 'OTTO'
    t if t == @types.TAG_TTCF => TrueTypeCollection // 'ttcf'
    t if t == @types.TAG_WOFF => Woff1 // 'wOFF'
    t if t == @types.TAG_WOF2 => Woff2 // 'wOF2'
    0x53544152U => Bdf // 'STAR' (STARTFONT)
    0x01666370U => Pcf // '\x01fcp'
    0x50465230U => Pfr // 'PFR0'
    _ =>
      // Check 2-byte signatures
      match (b0, b1) {
        (0x80, 0x01) => Type1Pfb // PFB
        (0x25, 0x21) => Type1Pfa // '%!' (PFA)
        (0x4D, 0x5A) => WindowsFnt // 'MZ' (Windows FNT)
        // CFF: major=1, minor=any, hdrSize>=4
        (0x01, _) if data[2].to_int() >= 4 => CffStandalone
        _ => Unknown
      }
  }
}
