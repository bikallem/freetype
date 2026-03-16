///|
/// Character map record. Maps character codes to glyph indices.
pub(all) struct CharMapRec {
  encoding : Encoding
  platform_id : UInt
  encoding_id : UInt
} derive(Eq, Show)
