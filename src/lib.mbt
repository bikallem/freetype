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
    TrueType | CffOpenType | TrueTypeCollection | Cff2OpenType =>
      load_sfnt(data, face_index)
    CffStandalone => load_cff_standalone(data)
    Woff1 => {
      let decompressed = @sfnt.decompress_woff(data)
      from_bytes(decompressed, face_index~)
    }
    Type1Pfb | Type1Pfa => load_type1_pfb(data)
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
