///|
/// Type 42 font driver.
/// Type 42 wraps TrueType font data inside a PostScript wrapper.
/// Ported from FreeType's type42 module.

///|
/// Type 42 font representation.
pub(all) struct Type42Font {
  mut font_name : String
  mut sfnts_data : Bytes // extracted TrueType data from /sfnts array
  mut encoding : Array[String] // encoding array (glyph names per slot)
  mut font_bbox : Array[Int] // [llx lly urx ury]
  mut font_matrix : Array[Double] // 6-element font matrix
  mut paint_type : Int
  mut font_type : Int // should be 42
} derive(Show)

///|
pub fn Type42Font::new() -> Type42Font {
  {
    font_name: "",
    sfnts_data: Bytes::new(0),
    encoding: [],
    font_bbox: [0, 0, 0, 0],
    font_matrix: [1.0, 0.0, 0.0, 1.0, 0.0, 0.0],
    paint_type: 0,
    font_type: 42,
  }
}

///|
/// Extract TrueType data from a Type 42 PostScript wrapper.
/// In a Type 42 font, the /sfnts array contains hex-encoded TrueType data.
/// This is a placeholder that returns a font with the raw data stored.
pub fn parse_type42(data : Bytes) -> Type42Font raise @error.FTError {
  if data.length() < 2 {
    raise @error.FTError::InvalidFileFormat
  }
  let font = Type42Font::new()
  // In a full implementation, we would:
  // 1. Parse the PostScript wrapper to find /sfnts
  // 2. Decode hex strings into binary TrueType data
  // 3. Optionally parse /Encoding, /FontBBox, /FontMatrix
  // For now, store the raw data for later extraction.
  font.sfnts_data = data
  font
}
