///|
/// SFNT face data — all parsed tables for an SFNT-based font.
struct SfntData {
  table_dir : TableDirectory
  head : HeadTable
  hhea : HheaTable
  maxp : MaxpTable
  hmtx : HmtxTable
  name : NameTable?
  os2 : Os2Table?
  post : PostTable?
  cmap : CmapTable?
  kern : KernTable?
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
pub fn SfntData::hmtx(self : SfntData) -> HmtxTable {
  self.hmtx
}

///|
pub fn SfntData::name(self : SfntData) -> NameTable? {
  self.name
}

///|
pub fn SfntData::os2(self : SfntData) -> Os2Table? {
  self.os2
}

///|
pub fn SfntData::post(self : SfntData) -> PostTable? {
  self.post
}

///|
pub fn SfntData::cmap(self : SfntData) -> CmapTable? {
  self.cmap
}

///|
pub fn SfntData::kern(self : SfntData) -> KernTable? {
  self.kern
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
  let hmtx = match table_dir.find_table(@types.TAG_HMTX) {
    Some(r) =>
      parse_hmtx(reader, r.offset, hhea.number_of_h_metrics, maxp.num_glyphs)
    None => raise @error.FTError::HmtxTableMissing
  }
  // Optional tables
  let name_table = match table_dir.find_table(@types.TAG_NAME) {
    Some(r) => Some(parse_name(reader, r.offset, r.length))
    None => None
  }
  let os2 = match table_dir.find_table(@types.TAG_OS2) {
    Some(r) => Some(parse_os2(reader, r.offset, r.length))
    None => None
  }
  let post = match table_dir.find_table(@types.TAG_POST_LC) {
    Some(r) =>
      Some(
        parse_post(
          reader,
          r.offset,
          r.length,
          maxp.num_glyphs,
          parse_names=false,
        ),
      )
    None => None
  }
  let cmap_table = match table_dir.find_table(@types.TAG_CMAP) {
    Some(r) => Some(parse_cmap_header(reader, r.offset))
    None => None
  }
  let kern = match table_dir.find_table(@types.TAG_KERN) {
    Some(r) => Some(parse_kern(reader, r.offset, r.length))
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
  if kern is Some(_) {
    face.set_face_flags(face.face_flags() | @base.FACE_FLAG_KERNING)
  }
  if post is Some(p) && p.format == 0x00020000U {
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
  if post is Some(p) {
    face.set_underline_position(p.underline_position)
    face.set_underline_thickness(p.underline_thickness)
  }
  // Names
  if name_table is Some(nt) {
    match nt.get_name(NAME_ID_FONT_FAMILY) {
      Some(n) => face.set_family_name(n)
      None => ()
    }
    match nt.get_name(NAME_ID_FONT_SUBFAMILY) {
      Some(n) => face.set_style_name(n)
      None => ()
    }
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
    hmtx,
    name: name_table,
    os2,
    post,
    cmap: cmap_table,
    kern,
    raw_data: data,
  }
  (sfnt_data, face)
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
