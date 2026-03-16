///|
/// Character encoding identifiers.
/// Encoded as 4-char tags matching C FreeType's FT_Encoding.
pub(all) enum Encoding {
  None
  MsSymbol // 'symb' 0x73796D62
  Unicode // 'unic' 0x756E6963
  Sjis // 'sjis' 0x736A6973
  Prc // 'gb  ' 0x67622020
  Big5 // 'big5' 0x62696735
  Wansung // 'wans' 0x77616E73
  Johab // 'joha' 0x6A6F6861
  AdobeStandard // 'ADOB' 0x41444F42
  AdobeExpert // 'ADBE' 0x41444245
  AdobeCustom // 'ADBC' 0x41444243
  AdobeLatin1 // 'lat1' 0x6C617431
  OldLatin2 // 'lat2' 0x6C617432
  AppleRoman // 'armn' 0x61726D6E
} derive(Eq, Show)

///|
pub fn Encoding::from_tag(tag : UInt) -> Encoding {
  match tag {
    0x73796D62U => MsSymbol
    0x756E6963U => Unicode
    0x736A6973U => Sjis
    0x67622020U => Prc
    0x62696735U => Big5
    0x77616E73U => Wansung
    0x6A6F6861U => Johab
    0x41444F42U => AdobeStandard
    0x41444245U => AdobeExpert
    0x41444243U => AdobeCustom
    0x6C617431U => AdobeLatin1
    0x6C617432U => OldLatin2
    0x61726D6EU => AppleRoman
    _ => None
  }
}

///|
pub fn Encoding::to_tag(self : Encoding) -> UInt {
  match self {
    None => 0U
    MsSymbol => 0x73796D62U
    Unicode => 0x756E6963U
    Sjis => 0x736A6973U
    Prc => 0x67622020U
    Big5 => 0x62696735U
    Wansung => 0x77616E73U
    Johab => 0x6A6F6861U
    AdobeStandard => 0x41444F42U
    AdobeExpert => 0x41444245U
    AdobeCustom => 0x41444243U
    AdobeLatin1 => 0x6C617431U
    OldLatin2 => 0x6C617432U
    AppleRoman => 0x61726D6EU
  }
}
