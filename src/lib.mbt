///|
/// Load a font face from in-memory data.
/// This is the main entry point — replaces C's FT_New_Memory_Face.
/// No Library object needed; API is stateless.
fn should_use_native_sfnt(data : Bytes, face_index : Int) -> Bool {
  if !@nativeft.native_available() {
    return false
  }
  try @sfnt.load_sfnt_face(data, face_index.to_int64()) catch {
    _ => false
  } noraise {
    (sfnt_data, _face) => {
      let table_dir = sfnt_data.table_dir()
      let has_cff2 = table_dir.find_table(@types.TAG_CFF2) is Some(_)
      let has_svg = table_dir.find_table(@types.TAG_SVG) is Some(_)
      let has_colr = table_dir.find_table(@types.TAG_COLR) is Some(_) &&
        table_dir.find_table(@types.TAG_CPAL) is Some(_)
      let has_sbix = table_dir.find_table(@types.TAG_SBIX) is Some(_)
      let has_cbdt = table_dir.find_table(@types.TAG_CBDT) is Some(_) &&
        table_dir.find_table(@types.TAG_CBLC) is Some(_)
      has_cff2 || (has_svg && !has_colr && !has_sbix && !has_cbdt)
    }
  }
}

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
    TrueType | CffOpenType | TrueTypeCollection =>
      if should_use_native_sfnt(data, face_index) {
        @nativeft.load_sfnt_face_native(data, face_index)
      } else {
        load_sfnt(data, face_index)
      }
    Cff2OpenType =>
      if @nativeft.native_available() {
        @nativeft.load_sfnt_face_native(data, face_index)
      } else {
        raise @error.FTError::UnimplementedFeature
      }
    CffStandalone => load_cff_standalone(data)
    Woff1 => {
      let decompressed = @sfnt.decompress_woff(data)
      from_bytes(decompressed, face_index~)
    }
    Type1Pfb | Type1Pfa =>
      if @nativeft.native_available() {
        @nativeft.load_type1_face_native(data, face_index)
      } else {
        load_type1_pfb(data)
      }
    Bdf => load_bdf(data)
    Pcf => load_pcf(data)
    Woff2 => {
      let decompressed = @sfnt.decompress_woff2(data)
      from_bytes(decompressed, face_index~)
    }
    // Obsolete/dead formats not supported: CID, Type 42, PFR, Windows FNT
    Cid | WindowsFnt | Pfr | Unknown => raise @error.FTError::UnknownFileFormat
  }
}
