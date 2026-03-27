///|
/// CFF INDEX structure: array of variable-length data items.
struct CffIndex {
  count : UInt
  off_size : Int // 1, 2, 3, or 4 bytes per offset
  offsets : Array[UInt] // count+1 offsets
  data_start : Int // absolute offset of data region start
  data : Bytes // raw data region (or reference to font data)
} derive(Show)

///|
/// Creates a CFF INDEX from parsed components.
pub fn CffIndex::new(
  count~ : UInt,
  off_size~ : Int,
  offsets~ : Array[UInt],
  data_start~ : Int,
  data~ : Bytes,
) -> CffIndex {
  { count, off_size, offsets, data_start, data }
}

///|
/// CFF header.
#valtype
struct CffHeader {
  major : Int
  minor : Int
  hdr_size : Int
  off_size : Int
} derive(Show)

///|
/// CFF Top DICT values.
struct CffTopDict {
  mut full_name_sid : UInt
  mut family_name_sid : UInt
  mut weight_sid : UInt
  mut is_fixed_pitch : Bool
  mut charset_offset : UInt
  mut encoding_offset : UInt
  mut charstrings_offset : UInt
  mut private_offset : UInt
  mut private_size : UInt
  mut fd_array_offset : UInt
  mut fd_select_offset : UInt
  mut vstore_offset : UInt
  mut ros : (UInt, UInt, UInt) // Registry, Ordering, Supplement (CID fonts)
  mut is_cid : Bool
  mut font_matrix : Array[Double] // 6 values
  mut font_bbox : Array[Int64] // 4 values
  mut underline_position : Int
  mut underline_thickness : Int
} derive(Show)

///|
pub fn CffTopDict::new() -> CffTopDict {
  {
    full_name_sid: 0U,
    family_name_sid: 0U,
    weight_sid: 0U,
    is_fixed_pitch: false,
    charset_offset: 0U,
    encoding_offset: 0U,
    charstrings_offset: 0U,
    private_offset: 0U,
    private_size: 0U,
    fd_array_offset: 0U,
    fd_select_offset: 0U,
    vstore_offset: 0U,
    ros: (0U, 0U, 0U),
    is_cid: false,
    font_matrix: [],
    font_bbox: [],
    underline_position: -100,
    underline_thickness: 50,
  }
}

///|
/// CFF Private DICT values.
struct CffPrivateDict {
  mut default_width_x : Int64
  mut nominal_width_x : Int64
  mut default_vsindex : Int
  mut subrs_offset : UInt // relative to start of Private DICT
  mut blue_values : Array[Int64]
  mut other_blues : Array[Int64]
  mut std_hw : Int64
  mut std_vw : Int64
  mut blue_scale : Double?
  mut blue_shift : Int?
  mut blue_fuzz : Int?
} derive(Show)

///|
pub fn CffPrivateDict::new() -> CffPrivateDict {
  {
    default_width_x: 0L,
    nominal_width_x: 0L,
    default_vsindex: 0,
    subrs_offset: 0U,
    blue_values: [],
    other_blues: [],
    std_hw: 0L,
    std_vw: 0L,
    blue_scale: None,
    blue_shift: None,
    blue_fuzz: None,
  }
}

///|
struct CffVarRegionAxis {
  start_coord : Int64
  peak_coord : Int64
  end_coord : Int64
} derive(Show)

///|
struct CffVarData {
  region_indices : Array[Int]
} derive(Show)

///|
struct CffVarStore {
  axis_count : Int
  regions : Array[Array[CffVarRegionAxis]]
  data : Array[CffVarData?]
} derive(Show)

///|
/// Parsed CFF font data.
struct CffFont {
  header : CffHeader
  name : String // font name from Name INDEX
  family_name : String
  style_name : String
  units_per_em : UInt
  is_fixed_pitch : Bool
  top_dict : CffTopDict
  private_dict : CffPrivateDict
  private_data : Bytes?
  charstrings : CffIndex // Charstrings INDEX
  global_subrs : CffIndex // Global Subr INDEX
  local_subrs : CffIndex? // Local Subr INDEX (from Private DICT)
  num_glyphs : UInt
  custom_strings : Array[String]
  glyph_names : Array[String]
  encoding_glyphs : Array[UInt]
  cached_local_subrs : Array[Bytes]
  fd_private_dicts : Array[CffPrivateDict]
  fd_private_data : Array[Bytes]
  fd_local_subrs : Array[Array[Bytes]]
  fd_select : Array[Int]
  cached_global_subrs : Array[Bytes]
  is_cff2 : Bool
  vstore : CffVarStore?
} derive(Show)

///|
pub fn CffFont::private_dict(self : CffFont) -> CffPrivateDict {
  self.private_dict
}

///|
pub fn CffFont::top_dict(self : CffFont) -> CffTopDict {
  self.top_dict
}

///|
pub fn CffFont::family_name(self : CffFont) -> String {
  self.family_name
}

///|
pub fn CffFont::style_name(self : CffFont) -> String {
  self.style_name
}

///|
pub fn CffFont::units_per_em(self : CffFont) -> UInt {
  self.units_per_em
}

///|
pub fn CffFont::is_fixed_pitch(self : CffFont) -> Bool {
  self.is_fixed_pitch
}

///|
pub fn CffFont::charstrings(self : CffFont) -> CffIndex {
  self.charstrings
}

///|
pub fn CffFont::global_subrs(self : CffFont) -> CffIndex {
  self.global_subrs
}

///|
pub fn CffFont::local_subrs(self : CffFont) -> CffIndex? {
  self.local_subrs
}

///|
pub fn CffFont::num_glyphs(self : CffFont) -> UInt {
  self.num_glyphs
}

///|
pub fn CffFont::custom_strings(self : CffFont) -> Array[String] {
  self.custom_strings
}

///|
pub fn CffFont::glyph_names(self : CffFont) -> Array[String] {
  self.glyph_names
}

///|
pub fn CffFont::encoding_glyphs(self : CffFont) -> Array[UInt] {
  self.encoding_glyphs
}

///|
pub fn CffFont::cached_local_subrs(self : CffFont) -> Array[Bytes] {
  self.cached_local_subrs
}

///|
pub fn CffFont::private_data(self : CffFont) -> Bytes? {
  self.private_data
}

///|
pub fn CffFont::fd_private_dicts(self : CffFont) -> Array[CffPrivateDict] {
  self.fd_private_dicts
}

///|
pub fn CffFont::fd_private_data(self : CffFont) -> Array[Bytes] {
  self.fd_private_data
}

///|
pub fn CffFont::fd_local_subrs(self : CffFont) -> Array[Array[Bytes]] {
  self.fd_local_subrs
}

///|
pub fn CffFont::fd_select(self : CffFont) -> Array[Int] {
  self.fd_select
}

///|
pub fn CffFont::cached_global_subrs(self : CffFont) -> Array[Bytes] {
  self.cached_global_subrs
}

///|
pub fn CffFont::name(self : CffFont) -> String {
  self.name
}

///|
pub fn CffFont::is_cff2(self : CffFont) -> Bool {
  self.is_cff2
}

///|
pub fn CffFont::vstore(self : CffFont) -> CffVarStore? {
  self.vstore
}

///|
pub fn CffFont::fd_index_for_glyph(self : CffFont, glyph_index : UInt) -> Int {
  let idx = glyph_index.reinterpret_as_int()
  if idx < 0 || idx >= self.fd_select.length() {
    0
  } else {
    self.fd_select[idx]
  }
}

///|
pub fn CffFont::private_dict_for_glyph(
  self : CffFont,
  glyph_index : UInt,
) -> CffPrivateDict {
  if self.fd_private_dicts.length() == 0 {
    self.private_dict
  } else {
    let fd_idx = self.fd_index_for_glyph(glyph_index)
    if fd_idx < 0 || fd_idx >= self.fd_private_dicts.length() {
      self.private_dict
    } else {
      self.fd_private_dicts[fd_idx]
    }
  }
}

///|
pub fn CffFont::cached_local_subrs_for_glyph(
  self : CffFont,
  glyph_index : UInt,
) -> Array[Bytes] {
  if self.fd_local_subrs.length() == 0 {
    self.cached_local_subrs
  } else {
    let fd_idx = self.fd_index_for_glyph(glyph_index)
    if fd_idx < 0 || fd_idx >= self.fd_local_subrs.length() {
      self.cached_local_subrs
    } else {
      self.fd_local_subrs[fd_idx]
    }
  }
}

///|
pub fn CffPrivateDict::blue_values(self : CffPrivateDict) -> Array[Int64] {
  self.blue_values
}

///|
pub fn CffPrivateDict::other_blues(self : CffPrivateDict) -> Array[Int64] {
  self.other_blues
}

///|
pub fn CffPrivateDict::default_width_x(self : CffPrivateDict) -> Int64 {
  self.default_width_x
}

///|
pub fn CffPrivateDict::nominal_width_x(self : CffPrivateDict) -> Int64 {
  self.nominal_width_x
}

///|
pub fn CffPrivateDict::default_vsindex(self : CffPrivateDict) -> Int {
  self.default_vsindex
}

///|

///|
pub fn CffTopDict::charset_offset(self : CffTopDict) -> UInt {
  self.charset_offset
}

///|
pub fn CffTopDict::encoding_offset(self : CffTopDict) -> UInt {
  self.encoding_offset
}

///|
pub fn CffTopDict::is_cid(self : CffTopDict) -> Bool {
  self.is_cid
}

///|
pub fn CffTopDict::private_size(self : CffTopDict) -> UInt {
  self.private_size
}

///|
pub fn CffTopDict::private_offset(self : CffTopDict) -> UInt {
  self.private_offset
}

///|
pub fn CffTopDict::font_bbox(self : CffTopDict) -> Array[Int64] {
  self.font_bbox
}

///|
pub fn CffTopDict::font_matrix(self : CffTopDict) -> Array[Double] {
  self.font_matrix
}

///|
pub fn CffTopDict::underline_position(self : CffTopDict) -> Int {
  self.underline_position
}

///|
pub fn CffTopDict::underline_thickness(self : CffTopDict) -> Int {
  self.underline_thickness
}

///|
pub fn CffIndex::count(self : CffIndex) -> UInt {
  self.count
}

///|
pub fn CffPrivateDict::std_hw(self : CffPrivateDict) -> Int64 {
  self.std_hw
}

///|
pub fn CffPrivateDict::std_vw(self : CffPrivateDict) -> Int64 {
  self.std_vw
}

///|
pub fn CffPrivateDict::blue_scale(self : CffPrivateDict) -> Double? {
  self.blue_scale
}

///|
pub fn CffPrivateDict::blue_shift(self : CffPrivateDict) -> Int? {
  self.blue_shift
}

///|
pub fn CffPrivateDict::blue_fuzz(self : CffPrivateDict) -> Int? {
  self.blue_fuzz
}

///|
fn cff_region_scalar(
  region : Array[CffVarRegionAxis],
  normalized_coords : Array[Int],
) -> Int64 {
  if normalized_coords.length() == 0 {
    return 0L
  }
  let mut scalar = 0x10000L
  let axis_count = if region.length() < normalized_coords.length() {
    region.length()
  } else {
    normalized_coords.length()
  }
  for axis_index in 0..<axis_count {
    let axis = region[axis_index]
    let coord = @fixed.F2Dot14::from_raw(normalized_coords[axis_index])
      .to_fixed()
      .val()
    if axis.peak_coord == 0L || axis.peak_coord == coord {
      continue
    }
    if coord <= axis.start_coord || coord >= axis.end_coord {
      return 0L
    }
    let (numerator, denominator) = if coord < axis.peak_coord {
      (coord - axis.start_coord, axis.peak_coord - axis.start_coord)
    } else {
      (axis.end_coord - coord, axis.end_coord - axis.peak_coord)
    }
    if denominator <= 0L {
      return 0L
    }
    scalar = scalar * numerator / denominator
    if scalar <= 0L {
      return 0L
    }
  }
  scalar
}

///|
pub fn CffVarStore::blend_vector(
  self : CffVarStore,
  vsindex : Int,
  normalized_coords : Array[Int],
) -> Array[Int64] {
  if vsindex < 0 || vsindex >= self.data.length() {
    return [0x10000L]
  }
  match self.data[vsindex] {
    None => [0x10000L]
    Some(data) => {
      let out : Array[Int64] = [0x10000L]
      for _, region_index in data.region_indices {
        if region_index < 0 || region_index >= self.regions.length() {
          out.push(0L)
        } else {
          out.push(
            cff_region_scalar(self.regions[region_index], normalized_coords),
          )
        }
      }
      out
    }
  }
}
