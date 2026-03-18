///|
/// Character map record. Maps character codes to glyph indices.
pub struct CharMapRec {
  encoding : Encoding
  platform_id : UInt
  encoding_id : UInt
} derive(Eq, Show)

///|
pub fn CharMapRec::new(
  encoding : Encoding,
  platform_id : UInt,
  encoding_id : UInt,
) -> CharMapRec {
  { encoding, platform_id, encoding_id }
}
