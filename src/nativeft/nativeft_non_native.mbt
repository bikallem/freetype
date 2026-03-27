///|
pub fn native_available() -> Bool {
  false
}

///|
pub fn load_type1_face_native(
  _data : Bytes,
  _face_index : Int,
) -> @base.FaceRec raise @error.FTError {
  raise @error.FTError::UnimplementedFeature
}

///|
pub fn load_sfnt_face_native(
  _data : Bytes,
  _face_index : Int,
) -> @base.FaceRec raise @error.FTError {
  raise @error.FTError::UnimplementedFeature
}
