///|
/// Load a font face from in-memory data.
/// This is the main entry point — replaces C's FT_New_Memory_Face.
/// No Library object needed; API is stateless.
pub fn from_bytes(
  data : Bytes,
  face_index? : Int = 0,
) -> @base.FaceRec raise @error.FTError {
  let format = @base.detect_format(data)
  match format {
    TrueType | CffOpenType | TrueTypeCollection => {
      let (sfnt_data, face) = @sfnt.load_sfnt_face(data, face_index.to_int64())
      // If TrueType with glyf table, init TT face data
      if sfnt_data.table_dir.find_table(@types.tag_glyf) is Some(_) {
        let tt_data = @truetype.init_tt_face(sfnt_data, face)
        face.driver_data = @base.DriverData::TrueType({
          placeholder: tt_data.glyph_offsets.length(),
        })
      }
      face
    }
    Woff1 => {
      // Decompress WOFF and recurse
      let decompressed = @sfnt.decompress_woff(data)
      from_bytes(decompressed, face_index~)
    }
    Type1Pfb => {
      let font = @type1.parse_type1_pfb(data)
      let face = @base.FaceRec::new()
      face.family_name = font.font_name
      face.face_flags = @base.face_flag_scalable |
        @base.face_flag_horizontal |
        @base.face_flag_glyph_names
      face.num_glyphs = font.charstrings.length().to_int64()
      if font.font_bbox.length() == 4 {
        face.bbox = @types.BBox::{
          x_min: font.font_bbox[0].to_int64(),
          y_min: font.font_bbox[1].to_int64(),
          x_max: font.font_bbox[2].to_int64(),
          y_max: font.font_bbox[3].to_int64(),
        }
      }
      face
    }
    Type1Pfa => {
      // PFA is ASCII — similar to PFB but unframed
      let face = @base.FaceRec::new()
      face.face_flags = @base.face_flag_scalable | @base.face_flag_horizontal
      face
    }
    Bdf => {
      let font = @bdf.parse_bdf_header(data)
      let face = @base.FaceRec::new()
      face.family_name = font.font_name
      face.face_flags = @base.face_flag_fixed_sizes | @base.face_flag_horizontal
      face.num_glyphs = (font.num_chars + 1).to_int64() // +1 for implicit .notdef
      face
    }
    Pcf => {
      let face = @base.FaceRec::new()
      face.face_flags = @base.face_flag_fixed_sizes | @base.face_flag_horizontal
      face
    }
    WindowsFnt => {
      let face = @base.FaceRec::new()
      face.face_flags = @base.face_flag_fixed_sizes | @base.face_flag_horizontal
      face
    }
    Pfr => {
      let face = @base.FaceRec::new()
      face.face_flags = @base.face_flag_scalable | @base.face_flag_horizontal
      face
    }
    Woff2 => raise @error.FTError::UnimplementedFeature // needs Brotli
    Unknown => raise @error.FTError::UnknownFileFormat
    _ => raise @error.FTError::UnknownFileFormat
  }
}

///|
/// Map a character code to a glyph index using the active charmap.
pub fn get_char_index(face : @base.FaceRec, charcode : UInt) -> UInt {
  // Stub — would dispatch to the appropriate cmap lookup
  ignore(face)
  ignore(charcode)
  0U
}
