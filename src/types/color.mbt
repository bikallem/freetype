///|
/// Non-premultiplied BGRA color, matching FreeType's FT_Color layout.
struct Color {
  blue : Byte
  green : Byte
  red : Byte
  alpha : Byte
} derive(Eq, Show)

///|
pub fn Color::new(blue : Byte, green : Byte, red : Byte, alpha : Byte) -> Color {
  { blue, green, red, alpha }
}

///|
pub fn Color::blue(self : Color) -> Byte {
  self.blue
}

///|
pub fn Color::green(self : Color) -> Byte {
  self.green
}

///|
pub fn Color::red(self : Color) -> Byte {
  self.red
}

///|
pub fn Color::alpha(self : Color) -> Byte {
  self.alpha
}

///|
/// Public palette metadata mirroring FreeType's FT_Palette_Data.
struct PaletteData {
  num_palettes : UInt
  palette_name_ids : Array[UInt]
  palette_flags : Array[UInt]
  num_palette_entries : UInt
  palette_entry_name_ids : Array[UInt]
} derive(Eq, Show)

///|
pub fn PaletteData::new(
  num_palettes : UInt,
  palette_name_ids : Array[UInt],
  palette_flags : Array[UInt],
  num_palette_entries : UInt,
  palette_entry_name_ids : Array[UInt],
) -> PaletteData {
  {
    num_palettes,
    palette_name_ids,
    palette_flags,
    num_palette_entries,
    palette_entry_name_ids,
  }
}

///|
pub fn PaletteData::num_palettes(self : PaletteData) -> UInt {
  self.num_palettes
}

///|
pub fn PaletteData::palette_name_ids(self : PaletteData) -> Array[UInt] {
  self.palette_name_ids
}

///|
pub fn PaletteData::palette_flags(self : PaletteData) -> Array[UInt] {
  self.palette_flags
}

///|
pub fn PaletteData::num_palette_entries(self : PaletteData) -> UInt {
  self.num_palette_entries
}

///|
pub fn PaletteData::palette_entry_name_ids(self : PaletteData) -> Array[UInt] {
  self.palette_entry_name_ids
}
