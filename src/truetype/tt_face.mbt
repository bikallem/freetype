///|
/// Initialize a TrueType face from SFNT data.
/// Parses loca, glyf, cvt, fpgm, prep tables.
pub fn init_tt_face(
  sfnt : @sfnt.SfntData,
  face : @base.FaceRec,
) -> TtFaceData raise @error.FTError {
  let reader = @stream.ByteReader::new(sfnt.raw_data())
  // Parse loca table
  let loca_rec = sfnt.table_dir().find_table(@types.TAG_LOCA)
  let glyph_offsets = match loca_rec {
    Some(r) =>
      parse_loca(
        reader,
        r.offset(),
        r.length(),
        sfnt.maxp().num_glyphs(),
        sfnt.head().index_to_loc_format(),
      )
    None => raise @error.FTError::LocationsMissing
  }
  // Get glyf table location
  let glyf_rec = sfnt.table_dir().find_table(@types.TAG_GLYF)
  let (glyf_offset, glyf_length) = match glyf_rec {
    Some(r) => (r.offset(), r.length())
    None => (0U, 0U) // CFF fonts don't have glyf
  }
  // Parse CVT table (control values, optional)
  let cvt = match sfnt.table_dir().find_table(@types.TAG_CVT) {
    Some(r) => {
      reader.seek(r.offset().reinterpret_as_int())
      let count = r.length().reinterpret_as_int() / 2
      let values : Array[Int64] = []
      for _ in 0..<count {
        // CVT values are FWord (signed 16-bit), stored as 26.6 for hinting
        let v = reader.read_i16_be()
        values.push(v.to_int64() << 6) // convert to 26.6
      }
      values
    }
    None => []
  }
  // Read fpgm (font program, optional)
  let fpgm = match sfnt.table_dir().find_table(@types.TAG_FPGM) {
    Some(r) => {
      reader.seek(r.offset().reinterpret_as_int())
      reader.read_bytes(r.length().reinterpret_as_int())
    }
    None => b""
  }
  // Read prep (CVT program, optional)
  let prep = match sfnt.table_dir().find_table(@types.TAG_PREP) {
    Some(r) => {
      reader.seek(r.offset().reinterpret_as_int())
      reader.read_bytes(r.length().reinterpret_as_int())
    }
    None => b""
  }
  // Set hinter flag if font has programs
  if fpgm.length() > 0 || prep.length() > 0 {
    face.set_face_flags(face.face_flags() | @base.FACE_FLAG_HINTER)
  }
  { sfnt, glyph_offsets, glyf_offset, glyf_length, fpgm, prep, cvt }
}
