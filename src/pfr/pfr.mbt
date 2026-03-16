///|
/// PFR (Portable Font Resource) driver.
/// Ported from FreeType's pfr module.

///|
/// PFR file header.
pub(all) struct PfrHeader {
  signature : UInt // should be 0x50465230 ("PFR0")
  version : UInt
  signature2 : UInt
  header_size : UInt
  log_dir_size : UInt
  log_dir_offset : UInt
  log_font_max_size : UInt
  phy_font_offset : UInt
  phy_font_max_size : UInt
  gps_offset : UInt
  gps_max_size : UInt
} derive(Eq, Show)

///|
/// PFR font representation.
pub(all) struct PfrFont {
  mut header : PfrHeader
  mut font_name : String
  mut num_chars : Int
} derive(Show)

///|
pub fn PfrFont::new() -> PfrFont {
  {
    header: {
      signature: 0U,
      version: 0U,
      signature2: 0U,
      header_size: 0U,
      log_dir_size: 0U,
      log_dir_offset: 0U,
      log_font_max_size: 0U,
      phy_font_offset: 0U,
      phy_font_max_size: 0U,
      gps_offset: 0U,
      gps_max_size: 0U,
    },
    font_name: "",
    num_chars: 0,
  }
}

///|
/// Check if data begins with the PFR signature "PFR0".
pub fn is_pfr(data : Bytes) -> Bool {
  if data.length() < 4 {
    return false
  }
  data[0] == b'P' && data[1] == b'F' && data[2] == b'R' && data[3] == b'0'
}
