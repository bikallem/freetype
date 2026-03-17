///|
/// CID-keyed font driver.
/// CID fonts are a variant of PostScript fonts using Character IDs instead of names.
/// Ported from FreeType's cid module.

///|
/// Per-FD (Font Dict) private dictionary values.
pub(all) struct CidFontDict {
  mut blue_values : Array[Int]
  mut other_blues : Array[Int]
  mut std_hw : Int
  mut std_vw : Int
  mut default_width_x : Int64
  mut nominal_width_x : Int64
  mut len_iv : Int
  mut subrs : Array[Bytes]
  mut subrs_offset : Int
  mut sd_bytes : Int // SubrData bytes per entry
  mut paint_type : Int
} derive(Show)

///|
pub fn CidFontDict::new() -> CidFontDict {
  {
    blue_values: [],
    other_blues: [],
    std_hw: 0,
    std_vw: 0,
    default_width_x: 0L,
    nominal_width_x: 0L,
    len_iv: 4,
    subrs: [],
    subrs_offset: 0,
    sd_bytes: 0,
    paint_type: 0,
  }
}

///|
/// CID-keyed font representation.
pub(all) struct CidFont {
  mut font_name : String
  mut cid_count : Int // total number of CIDs
  mut fd_array : Array[CidFontDict] // Font Dict array
  mut registry : String // CIDSystemInfo registry
  mut ordering : String // CIDSystemInfo ordering
  mut supplement : Int // CIDSystemInfo supplement
  mut font_bbox : Array[Int] // [llx lly urx ury]
  mut gd_bytes : Int // GlyphData bytes per entry
  mut cid_map_offset : Int // offset to CID-to-GID map
  mut data_offset : Int // offset to charstring data
} derive(Show)

///|
pub fn CidFont::new() -> CidFont {
  {
    font_name: "",
    cid_count: 0,
    fd_array: [],
    registry: "",
    ordering: "",
    supplement: 0,
    font_bbox: [0, 0, 0, 0],
    gd_bytes: 0,
    cid_map_offset: 0,
    data_offset: 0,
  }
}

///|
/// Parse a CID font from raw data.
/// This is a minimal implementation; CID fonts are relatively rare.
pub fn parse_cid_font(data : Bytes) -> CidFont raise @error.FTError {
  ignore(data)
  // CID fonts use a specialized binary format with:
  // - CIDSystemInfo dictionary
  // - FDArray with per-FD private dicts
  // - CIDMap for CID-to-GID mapping
  // - CharStrings data
  // Full parsing is deferred; return empty struct for now.
  if data.length() < 4 {
    raise @error.FTError::InvalidFileFormat
  }
  CidFont::new()
}
