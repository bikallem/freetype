///|
/// CFF INDEX structure: array of variable-length data items.
pub(all) struct CffIndex {
  count : UInt
  off_size : Int // 1, 2, 3, or 4 bytes per offset
  offsets : Array[UInt] // count+1 offsets
  data_start : Int // absolute offset of data region start
  data : Bytes // raw data region (or reference to font data)
} derive(Show)

///|
/// CFF header.
pub(all) struct CffHeader {
  major : Int
  minor : Int
  hdr_size : Int
  off_size : Int
} derive(Show)

///|
/// CFF Top DICT values.
pub(all) struct CffTopDict {
  mut charset_offset : UInt
  mut encoding_offset : UInt
  mut charstrings_offset : UInt
  mut private_offset : UInt
  mut private_size : UInt
  mut fd_array_offset : UInt
  mut fd_select_offset : UInt
  mut ros : (UInt, UInt, UInt) // Registry, Ordering, Supplement (CID fonts)
  mut is_cid : Bool
  mut font_matrix : Array[Int64] // 6 values
  mut font_bbox : Array[Int64] // 4 values
} derive(Show)

///|
pub fn CffTopDict::new() -> CffTopDict {
  {
    charset_offset: 0U,
    encoding_offset: 0U,
    charstrings_offset: 0U,
    private_offset: 0U,
    private_size: 0U,
    fd_array_offset: 0U,
    fd_select_offset: 0U,
    ros: (0U, 0U, 0U),
    is_cid: false,
    font_matrix: [],
    font_bbox: [],
  }
}

///|
/// CFF Private DICT values.
pub(all) struct CffPrivateDict {
  mut default_width_x : Int64
  mut nominal_width_x : Int64
  mut subrs_offset : UInt // relative to start of Private DICT
  mut blue_values : Array[Int64]
  mut other_blues : Array[Int64]
  mut std_hw : Int64
  mut std_vw : Int64
} derive(Show)

///|
pub fn CffPrivateDict::new() -> CffPrivateDict {
  {
    default_width_x: 0L,
    nominal_width_x: 0L,
    subrs_offset: 0U,
    blue_values: [],
    other_blues: [],
    std_hw: 0L,
    std_vw: 0L,
  }
}

///|
/// Parsed CFF font data.
pub(all) struct CffFont {
  header : CffHeader
  name : String // font name from Name INDEX
  top_dict : CffTopDict
  private_dict : CffPrivateDict
  charstrings : CffIndex // Charstrings INDEX
  global_subrs : CffIndex // Global Subr INDEX
  local_subrs : CffIndex? // Local Subr INDEX (from Private DICT)
  num_glyphs : UInt
} derive(Show)
