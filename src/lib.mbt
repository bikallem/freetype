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
    TrueType | CffOpenType | TrueTypeCollection => load_sfnt(data, face_index)
    Woff1 => {
      let decompressed = @sfnt.decompress_woff(data)
      from_bytes(decompressed, face_index~)
    }
    Type1Pfb => load_type1_pfb(data)
    Type1Pfa => load_type1_pfb(data) // PFA uses same parser (handles both)
    Bdf => {
      let font = @bdf.parse_bdf_header(data)
      let face = @base.FaceRec::new()
      face.family_name = font.font_name
      face.face_flags = @base.face_flag_fixed_sizes | @base.face_flag_horizontal
      face.num_glyphs = (font.num_chars + 1).to_int64()
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
    Woff2 => raise @error.FTError::UnimplementedFeature
    Cid => {
      // CID-keyed fonts — parse metadata but no glyph loading yet
      let face = @base.FaceRec::new()
      face.face_flags = @base.face_flag_scalable |
        @base.face_flag_horizontal |
        @base.face_flag_cid_keyed
      face
    }
    Unknown => raise @error.FTError::UnknownFileFormat
  }
}
