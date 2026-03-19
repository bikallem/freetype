///|
/// SFNT face data — all parsed tables for an SFNT-based font.
/// Kern table is deferred to first use via lazy Ref in load_sfnt.
/// Name and OS/2 tables are NOT stored — family/style names are extracted
/// directly from raw bytes during load to avoid full table parsing overhead.
struct SfntData {
  table_dir : TableDirectory
  head : HeadTable
  hhea : HheaTable
  maxp : MaxpTable
  cmap : CmapTable?
  // Raw table data access for driver-specific tables
  raw_data : Bytes
} derive(Show)

///|
pub fn SfntData::table_dir(self : SfntData) -> TableDirectory {
  self.table_dir
}

///|
pub fn SfntData::head(self : SfntData) -> HeadTable {
  self.head
}

///|
pub fn SfntData::hhea(self : SfntData) -> HheaTable {
  self.hhea
}

///|
pub fn SfntData::maxp(self : SfntData) -> MaxpTable {
  self.maxp
}

///|
pub fn SfntData::cmap(self : SfntData) -> CmapTable? {
  self.cmap
}

///|
pub fn SfntData::raw_data(self : SfntData) -> Bytes {
  self.raw_data
}

///|
/// Load an SFNT face from in-memory font data.
/// Parses the table directory and required tables.
pub fn load_sfnt_face(
  data : Bytes,
  face_index : Int64,
) -> (SfntData, @base.FaceRec) raise @error.FTError {
  let reader = @stream.ByteReader::new(data)
  // Check if this is a TTC
  let start_offset = if data.length() >= 4 {
    let tag = (data[0].to_uint() << 24) |
      (data[1].to_uint() << 16) |
      (data[2].to_uint() << 8) |
      data[3].to_uint()
    if tag == @types.TAG_TTCF {
      let ttc = parse_ttc_header(reader)
      let idx = face_index.to_int()
      if idx < 0 || idx >= ttc.offsets.length() {
        raise @error.FTError::InvalidArgument
      }
      ttc.offsets[idx].reinterpret_as_int()
    } else {
      0
    }
  } else {
    0
  }
  // Parse table directory
  reader.seek(start_offset)
  let table_dir = parse_table_directory(reader)
  // Parse required tables
  let head_rec = table_dir.find_table(@types.TAG_HEAD)
  let head = match head_rec {
    Some(r) => parse_head(reader, r.offset, r.length)
    None =>
      // Try 'bhed' (used by some Apple fonts)
      match table_dir.find_table(@types.TAG_BHED) {
        Some(r) => parse_head(reader, r.offset, r.length)
        None => raise @error.FTError::InvalidTable
      }
  }
  let hhea = match table_dir.find_table(@types.TAG_HHEA) {
    Some(r) => parse_hhea(reader, r.offset, r.length)
    None => raise @error.FTError::HorizHeaderMissing
  }
  let maxp = match table_dir.find_table(@types.TAG_MAXP) {
    Some(r) => parse_maxp(reader, r.offset, r.length)
    None => raise @error.FTError::InvalidTable
  }
  // Extract family_name and style_name directly from raw name table bytes
  // instead of parsing the full name table. We scan name records for nameID 1
  // (family) and nameID 2 (subfamily) and decode just those strings.
  let (family_name, style_name) = match table_dir.find_table(@types.TAG_NAME) {
    Some(r) =>
      extract_names_from_raw(
        data,
        r.offset.reinterpret_as_int(),
        r.length.reinterpret_as_int(),
      )
    None => (None, None)
  }
  // Read post header fields directly from raw bytes (format, underline pos/thickness)
  // to avoid full parse_post overhead. Glyph names are deferred.
  let (post_format, post_underline_position, post_underline_thickness) = match
    table_dir.find_table(@types.TAG_POST_LC) {
    Some(r) => {
      let off = r.offset.reinterpret_as_int()
      if r.length.reinterpret_as_int() >= 12 {
        let fmt = (data[off].to_uint() << 24) |
          (data[off + 1].to_uint() << 16) |
          (data[off + 2].to_uint() << 8) |
          data[off + 3].to_uint()
        let upos = (data[off + 8].to_int() << 8) | data[off + 9].to_int()
        let upos_signed = if upos >= 0x8000 { upos - 0x10000 } else { upos }
        let uthick = (data[off + 10].to_int() << 8) | data[off + 11].to_int()
        let uthick_signed = if uthick >= 0x8000 {
          uthick - 0x10000
        } else {
          uthick
        }
        (fmt, upos_signed, uthick_signed)
      } else {
        (0U, 0, 0)
      }
    }
    None => (0U, 0, 0)
  }
  let cmap_table = match table_dir.find_table(@types.TAG_CMAP) {
    Some(r) => Some(parse_cmap_header(reader, r.offset))
    None => None
  }
  // Determine number of faces (for TTC)
  let num_faces = if data.length() >= 12 {
    let tag = (data[0].to_uint() << 24) |
      (data[1].to_uint() << 16) |
      (data[2].to_uint() << 8) |
      data[3].to_uint()
    if tag == @types.TAG_TTCF {
      let r2 = @stream.ByteReader::new(data)
      r2.seek(8)
      r2.read_u32_be().reinterpret_as_int().to_int64()
    } else {
      1L
    }
  } else {
    1L
  }
  // Build FaceRec
  let face = @base.FaceRec::new(num_faces~, face_index~)
  face.set_num_glyphs(maxp.num_glyphs.reinterpret_as_int().to_int64())
  face.set_units_per_em(head.units_per_em)
  face.set_ascender(hhea.ascender)
  face.set_descender(hhea.descender)
  face.set_height(hhea.ascender - hhea.descender + hhea.line_gap)
  face.set_max_advance_width(hhea.advance_width_max.reinterpret_as_int())
  face.set_bbox(
    @types.BBox::new(
      head.x_min.to_int64(),
      head.y_min.to_int64(),
      head.x_max.to_int64(),
      head.y_max.to_int64(),
    ),
  )
  // Set face flags
  face.set_face_flags(@base.FACE_FLAG_SFNT | @base.FACE_FLAG_HORIZONTAL)
  // Scalable if has outlines (glyf or CFF table)
  if table_dir.find_table(@types.TAG_GLYF) is Some(_) ||
    table_dir.find_table(@types.TAG_CFF) is Some(_) ||
    table_dir.find_table(@types.TAG_CFF2) is Some(_) {
    face.set_face_flags(face.face_flags() | @base.FACE_FLAG_SCALABLE)
  }
  if table_dir.find_table(@types.TAG_KERN) is Some(_) {
    face.set_face_flags(face.face_flags() | @base.FACE_FLAG_KERNING)
  }
  if post_format == 0x00020000U {
    face.set_face_flags(face.face_flags() | @base.FACE_FLAG_GLYPH_NAMES)
  }
  // Style flags from head.mac_style
  if (head.mac_style & 1U) != 0U {
    face.set_style_flags(face.style_flags() | @base.STYLE_FLAG_BOLD)
  }
  if (head.mac_style & 2U) != 0U {
    face.set_style_flags(face.style_flags() | @base.STYLE_FLAG_ITALIC)
  }
  // Underline
  face.set_underline_position(post_underline_position)
  face.set_underline_thickness(post_underline_thickness)
  // Names (extracted directly from raw bytes above)
  if family_name is Some(n) {
    face.set_family_name(n)
  }
  if style_name is Some(n) {
    face.set_style_name(n)
  }
  // Build charmaps from cmap subtables
  if cmap_table is Some(ct) {
    for _, sub in ct.subtables {
      let encoding = select_encoding(sub.platform_id, sub.encoding_id)
      face
      .charmaps()
      .push(@base.CharMapRec::new(encoding, sub.platform_id, sub.encoding_id))
    }
    if face.charmaps().length() > 0 {
      face.set_active_charmap(0)
    }
  }
  let sfnt_data : SfntData = {
    table_dir,
    head,
    hhea,
    maxp,
    cmap: cmap_table,
    raw_data: data,
  }
  (sfnt_data, face)
}

///|
/// Extract family_name (nameID 1) and style_name (nameID 2) directly from raw
/// name table bytes without building intermediate NameRecord/NameTable structs.
/// Uses the same platform priority as NameTable::get_name: Windows Unicode >
/// Unicode platform > Mac Roman.
fn extract_names_from_raw(
  data : Bytes,
  table_offset : Int,
  table_length : Int,
) -> (String?, String?) {
  if table_length < 6 {
    return (None, None)
  }
  // Read name table header: format(u16), count(u16), string_offset(u16)
  let count = (data[table_offset + 2].to_int() << 8) |
    data[table_offset + 3].to_int()
  let storage_offset = (data[table_offset + 4].to_int() << 8) |
    data[table_offset + 5].to_int()
  let string_base = table_offset + storage_offset
  // Each name record is 12 bytes, starting at offset 6
  let records_start = table_offset + 6
  let records_end = records_start + count * 12
  if records_end > table_offset + table_length {
    return (None, None)
  }
  // Helper to find a name by nameID with platform priority
  let find_name : (Int) -> String? = fn(target_name_id) {
    // Pass 1: Windows Unicode (platform 3, encoding 1)
    for i in 0..<count {
      let off = records_start + i * 12
      let plat = (data[off].to_int() << 8) | data[off + 1].to_int()
      let enc = (data[off + 2].to_int() << 8) | data[off + 3].to_int()
      let name_id = (data[off + 6].to_int() << 8) | data[off + 7].to_int()
      if name_id == target_name_id && plat == 3 && enc == 1 {
        let str_len = (data[off + 8].to_int() << 8) | data[off + 9].to_int()
        let str_off = (data[off + 10].to_int() << 8) | data[off + 11].to_int()
        return Some(
          decode_utf16_be(
            data,
            (string_base + str_off).reinterpret_as_uint(),
            str_len.reinterpret_as_uint(),
          ),
        )
      }
    }
    // Pass 2: Unicode platform (platform 0)
    for i in 0..<count {
      let off = records_start + i * 12
      let plat = (data[off].to_int() << 8) | data[off + 1].to_int()
      let name_id = (data[off + 6].to_int() << 8) | data[off + 7].to_int()
      if name_id == target_name_id && plat == 0 {
        let str_len = (data[off + 8].to_int() << 8) | data[off + 9].to_int()
        let str_off = (data[off + 10].to_int() << 8) | data[off + 11].to_int()
        return Some(
          decode_utf16_be(
            data,
            (string_base + str_off).reinterpret_as_uint(),
            str_len.reinterpret_as_uint(),
          ),
        )
      }
    }
    // Pass 3: Mac Roman (platform 1, encoding 0)
    for i in 0..<count {
      let off = records_start + i * 12
      let plat = (data[off].to_int() << 8) | data[off + 1].to_int()
      let enc = (data[off + 2].to_int() << 8) | data[off + 3].to_int()
      let name_id = (data[off + 6].to_int() << 8) | data[off + 7].to_int()
      if name_id == target_name_id && plat == 1 && enc == 0 {
        let str_len = (data[off + 8].to_int() << 8) | data[off + 9].to_int()
        let str_off = (data[off + 10].to_int() << 8) | data[off + 11].to_int()
        return Some(
          decode_mac_roman(
            data,
            (string_base + str_off).reinterpret_as_uint(),
            str_len.reinterpret_as_uint(),
          ),
        )
      }
    }
    None
  }
  (find_name(1), find_name(2))
}

///|
/// Select the best encoding for a cmap subtable based on platform/encoding IDs.
fn select_encoding(platform_id : UInt, encoding_id : UInt) -> @base.Encoding {
  match (platform_id, encoding_id) {
    (0U, _) => @base.Encoding::Unicode // Unicode platform
    (3U, 1U) => @base.Encoding::Unicode // Windows UCS-2
    (3U, 10U) => @base.Encoding::Unicode // Windows UCS-4
    (3U, 0U) => @base.Encoding::MsSymbol // Windows Symbol
    (1U, 0U) => @base.Encoding::AppleRoman // Mac Roman
    _ => @base.Encoding::None
  }
}
