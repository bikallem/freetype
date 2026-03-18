///|
/// TrueType-specific face data, stored in FaceRec.driver_data.
struct TtFaceData {
  sfnt : @sfnt.SfntData
  // Glyph location table ('loca')
  glyph_offsets : Array[UInt] // offset of each glyph in 'glyf' table
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
pub const ARG_1_AND_2_ARE_WORDS : UInt = 0x0001U

///|
pub const ARGS_ARE_XY_VALUES : UInt = 0x0002U

///|
pub const ROUND_XY_TO_GRID : UInt = 0x0004U

///|
pub const WE_HAVE_A_SCALE : UInt = 0x0008U

///|
pub const MORE_COMPONENTS : UInt = 0x0020U

///|
pub const WE_HAVE_AN_X_AND_Y_SCALE : UInt = 0x0040U

///|
pub const WE_HAVE_A_TWO_BY_TWO : UInt = 0x0080U

///|
pub const WE_HAVE_INSTRUCTIONS : UInt = 0x0100U

///|
pub const USE_MY_METRICS : UInt = 0x0200U

///|
pub const OVERLAP_COMPOUND : UInt = 0x0400U

///|
pub fn TtFaceData::sfnt(self : TtFaceData) -> @sfnt.SfntData {
  self.sfnt
}

///|
pub fn TtFaceData::glyph_offsets(self : TtFaceData) -> Array[UInt] {
  self.glyph_offsets
}

///|
pub fn TtFaceData::glyf_offset(self : TtFaceData) -> UInt {
  self.glyf_offset
}

///|
pub fn TtFaceData::glyf_length(self : TtFaceData) -> UInt {
  self.glyf_length
}

///|
pub fn TtFaceData::fpgm(self : TtFaceData) -> Bytes {
  self.fpgm
}

///|
pub fn TtFaceData::prep(self : TtFaceData) -> Bytes {
  self.prep
}

///|
pub fn TtFaceData::cvt(self : TtFaceData) -> Array[Int64] {
  self.cvt
}
