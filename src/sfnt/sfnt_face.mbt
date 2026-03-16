///|
/// SFNT face data — all parsed tables for an SFNT-based font.
pub(all) struct SfntData {
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
    if tag == @types.tag_ttcf {
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
  let head_rec = table_dir.find_table(@types.tag_head)
  let head = match head_rec {
    Some(r) => parse_head(reader, r.offset, r.length)
    None =>
      // Try 'bhed' (used by some Apple fonts)
      match table_dir.find_table(@types.tag_bhed) {
        Some(r) => parse_head(reader, r.offset, r.length)
        None => raise @error.FTError::InvalidTable
      }
  }
  let hhea = match table_dir.find_table(@types.tag_hhea) {
    Some(r) => parse_hhea(reader, r.offset, r.length)
    None => raise @error.FTError::HorizHeaderMissing
  }
  let maxp = match table_dir.find_table(@types.tag_maxp) {
    Some(r) => parse_maxp(reader, r.offset, r.length)
    None => raise @error.FTError::InvalidTable
  }
  let hmtx = match table_dir.find_table(@types.tag_hmtx) {
    Some(r) =>
      parse_hmtx(reader, r.offset, hhea.number_of_h_metrics, maxp.num_glyphs)
    None => raise @error.FTError::HmtxTableMissing
  }
  // Optional tables
  let name_table = match table_dir.find_table(@types.tag_name) {
    Some(r) => Some(parse_name(reader, r.offset, r.length))
    None => None
  }
  let os2 = match table_dir.find_table(@types.tag_OS2) {
    Some(r) => Some(parse_os2(reader, r.offset, r.length))
    None => None
  }
  let post = match table_dir.find_table(@types.tag_post) {
    Some(r) => Some(parse_post(reader, r.offset, r.length, maxp.num_glyphs))
    None => None
  }
  let cmap_table = match table_dir.find_table(@types.tag_cmap) {
    Some(r) => Some(parse_cmap_header(reader, r.offset))
    None => None
  }
  let kern = match table_dir.find_table(@types.tag_kern) {
    Some(r) => Some(parse_kern(reader, r.offset, r.length))
    None => None
  }
  // Determine number of faces (for TTC)
  let num_faces = if data.length() >= 12 {
    let tag = (data[0].to_uint() << 24) |
      (data[1].to_uint() << 16) |
      (data[2].to_uint() << 8) |
      data[3].to_uint()
    if tag == @types.tag_ttcf {
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
  face.num_glyphs = maxp.num_glyphs.reinterpret_as_int().to_int64()
  face.units_per_em = head.units_per_em
  face.ascender = hhea.ascender
  face.descender = hhea.descender
  face.height = hhea.ascender - hhea.descender + hhea.line_gap
  face.max_advance_width = hhea.advance_width_max.reinterpret_as_int()
  face.bbox = {
    x_min: head.x_min.to_int64(),
    y_min: head.y_min.to_int64(),
    x_max: head.x_max.to_int64(),
    y_max: head.y_max.to_int64(),
  }
  // Set face flags
  face.face_flags = @base.face_flag_sfnt | @base.face_flag_horizontal
  // Scalable if has outlines (glyf or CFF table)
  if table_dir.find_table(@types.tag_glyf) is Some(_) ||
    table_dir.find_table(@types.tag_CFF) is Some(_) ||
    table_dir.find_table(@types.tag_CFF2) is Some(_) {
    face.face_flags = face.face_flags | @base.face_flag_scalable
  }
  if kern is Some(_) {
    face.face_flags = face.face_flags | @base.face_flag_kerning
  }
  if post is Some(p) && p.glyph_names.length() > 0 {
    face.face_flags = face.face_flags | @base.face_flag_glyph_names
  }
  // Style flags from head.mac_style
  if (head.mac_style & 1U) != 0U {
    face.style_flags = face.style_flags | @base.style_flag_bold
  }
  if (head.mac_style & 2U) != 0U {
    face.style_flags = face.style_flags | @base.style_flag_italic
  }
  // Underline
  if post is Some(p) {
    face.underline_position = p.underline_position
    face.underline_thickness = p.underline_thickness
  }
  // Names
  if name_table is Some(nt) {
    match nt.get_name(name_id_font_family) {
      Some(n) => face.family_name = n
      None => ()
    }
    match nt.get_name(name_id_font_subfamily) {
      Some(n) => face.style_name = n
      None => ()
    }
  }
  // Build charmaps from cmap subtables
  if cmap_table is Some(ct) {
    for i = 0; i < ct.subtables.length(); i = i + 1 {
      let sub = ct.subtables[i]
      let encoding = select_encoding(sub.platform_id, sub.encoding_id)
      face.charmaps.push({
        encoding,
        platform_id: sub.platform_id,
        encoding_id: sub.encoding_id,
      })
    }
    if face.charmaps.length() > 0 {
      face.active_charmap = 0
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
