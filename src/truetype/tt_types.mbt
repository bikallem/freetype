///|
/// TrueType-specific face data, stored in FaceRec.driver_data.
pub(all) struct TtFaceData {
  sfnt : @sfnt.SfntData
  // Glyph location table ('loca')
  mut glyph_offsets : Array[UInt] // offset of each glyph in 'glyf' table
  // Raw table references
  glyf_offset : UInt // offset of 'glyf' table in font data
  glyf_length : UInt
  // Hinting programs
  fpgm : Bytes // font program
  prep : Bytes // CVT program
  cvt : Array[Int64] // control value table (26.6 values)
} derive(Show)

///|
/// Composite glyph component flags (from TrueType spec).
pub let arg_1_and_2_are_words : UInt = 0x0001U

///|
pub let args_are_xy_values : UInt = 0x0002U

///|
pub let round_xy_to_grid : UInt = 0x0004U

///|
pub let we_have_a_scale : UInt = 0x0008U

///|
pub let more_components : UInt = 0x0020U

///|
pub let we_have_an_x_and_y_scale : UInt = 0x0040U

///|
pub let we_have_a_two_by_two : UInt = 0x0080U

///|
pub let we_have_instructions : UInt = 0x0100U

///|
pub let use_my_metrics : UInt = 0x0200U

///|
pub let overlap_compound : UInt = 0x0400U
