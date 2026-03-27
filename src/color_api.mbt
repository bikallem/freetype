///|
/// Return palette metadata for color fonts, if present.
pub fn get_palette_data(face : @base.FaceRec) -> @types.PaletteData? {
  face.palette_data()
}

///|
/// Return the currently active palette colors.
pub fn get_palette(face : @base.FaceRec) -> Array[@types.Color] {
  face.palette()
}

///|
/// Select a CPAL palette by index and store it on the face.
pub fn select_palette(
  face : @base.FaceRec,
  palette_index : UInt,
) -> Array[@types.Color] raise @error.FTError {
  let palette = match face.driver_data() {
    @base.DriverData::SfntDriver(ops) =>
      match ops.select_palette()(palette_index) {
        Some(colors) => colors
        None => raise @error.FTError::InvalidArgument
      }
    _ => raise @error.FTError::InvalidArgument
  }
  face.set_palette(palette)
  face.set_palette_index(palette_index.reinterpret_as_int())
  palette
}

///|
/// Override the foreground color used by COLR layers with palette index 0xFFFF.
pub fn set_foreground_color(face : @base.FaceRec, color : @types.Color) -> Unit {
  face.set_foreground_color(color)
}

///|
pub fn get_foreground_color(face : @base.FaceRec) -> @types.Color {
  face.foreground_color()
}

///|
/// Configure the SDF spread in pixels. Must be positive.
pub fn set_sdf_spread(
  face : @base.FaceRec,
  spread : Int,
) -> Unit raise @error.FTError {
  if spread <= 0 {
    raise @error.FTError::InvalidArgument
  }
  face.set_sdf_spread(spread)
}

///|
pub fn get_sdf_spread(face : @base.FaceRec) -> Int {
  face.sdf_spread()
}
