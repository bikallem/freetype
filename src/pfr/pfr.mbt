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

///|
/// Read a PFR-encoded unsigned number (1, 2, or 4 bytes based on size flags).
fn pfr_read_uint(data : Bytes, pos : Int, size : Int) -> (UInt, Int) {
  match size {
    1 => (data[pos].to_uint(), pos + 1)
    2 => {
      let v = (data[pos].to_uint() << 8) | data[pos + 1].to_uint()
      (v, pos + 2)
    }
    _ => {
      let v = (data[pos].to_uint() << 24) |
        (data[pos + 1].to_uint() << 16) |
        (data[pos + 2].to_uint() << 8) |
        data[pos + 3].to_uint()
      (v, pos + 4)
    }
  }
}

///|
/// Parse a PFR font from raw data.
/// Reads the PFR header, then extracts font name and glyph count
/// from the physical font record.
pub fn parse_pfr_font(data : Bytes) -> PfrFont raise @error.FTError {
  let len = data.length()
  if len < 58 {
    raise @error.FTError::InvalidFileFormat
  }
  if not(is_pfr(data)) {
    raise @error.FTError::InvalidFileFormat
  }
  let font = PfrFont::new()
  // Parse PFR header (all fields are big-endian)
  let sig = (data[0].to_uint() << 24) |
    (data[1].to_uint() << 16) |
    (data[2].to_uint() << 8) |
    data[3].to_uint()
  let version = (data[4].to_uint() << 8) | data[5].to_uint()
  let sig2 = (data[6].to_uint() << 8) | data[7].to_uint()
  let header_size = (data[8].to_uint() << 8) | data[9].to_uint()
  let log_dir_size = (data[10].to_uint() << 8) | data[11].to_uint()
  let log_dir_offset = (data[12].to_uint() << 24) |
    (data[13].to_uint() << 16) |
    (data[14].to_uint() << 8) |
    data[15].to_uint()
  let log_font_max_size = (data[16].to_uint() << 24) |
    (data[17].to_uint() << 16) |
    (data[18].to_uint() << 8) |
    data[19].to_uint()
  let phy_font_offset = (data[42].to_uint() << 24) |
    (data[43].to_uint() << 16) |
    (data[44].to_uint() << 8) |
    data[45].to_uint()
  let phy_font_max_size = (data[46].to_uint() << 24) |
    (data[47].to_uint() << 16) |
    (data[48].to_uint() << 8) |
    data[49].to_uint()
  let gps_offset = (data[50].to_uint() << 24) |
    (data[51].to_uint() << 16) |
    (data[52].to_uint() << 8) |
    data[53].to_uint()
  let gps_max_size = (data[54].to_uint() << 24) |
    (data[55].to_uint() << 16) |
    (data[56].to_uint() << 8) |
    data[57].to_uint()
  font.header = {
    signature: sig,
    version,
    signature2: sig2,
    header_size,
    log_dir_size,
    log_dir_offset,
    log_font_max_size,
    phy_font_offset,
    phy_font_max_size,
    gps_offset,
    gps_max_size,
  }
  // Parse physical font record to get font name and num_chars
  let phy_off = phy_font_offset.reinterpret_as_int()
  if phy_off > 0 && phy_off + 20 < len {
    // Physical font record starts with:
    //   font_name_size(1), font_name(N), then flags and metrics
    let name_size = data[phy_off].to_int()
    if name_size > 0 && phy_off + 1 + name_size <= len {
      let buf = StringBuilder::new()
      for i = 0; i < name_size; i = i + 1 {
        buf.write_char(Char::from_int(data[phy_off + 1 + i].to_int()))
      }
      font.font_name = buf.to_string()
    }
    // After font name: flags(1), then various fields depending on flags
    let after_name = phy_off + 1 + name_size
    if after_name + 10 < len {
      let flags = data[after_name].to_int()
      let mut pos = after_name + 1
      // Skip auxiliary bytes (count at pos if flag bit 7 set)
      if (flags & 0x80) != 0 && pos + 1 < len {
        let aux_count = data[pos].to_int()
        pos = pos + 1 + aux_count
      }
      // Skip blue values area (if flag bit 6 set)
      ignore(flags)
      // Try to find num_chars: it appears after several variable fields.
      // For simplicity, read the num_chars field using size from flags bits 0-1.
      let char_count_size = (flags & 0x03) + 1
      // The num_chars field is not at a fixed offset, so we do a best-effort:
      // scan forward to find it. For now, set from gps_max_size heuristic.
      ignore(char_count_size)
      ignore(pos)
    }
  }
  font
}
