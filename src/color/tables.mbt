///|
struct CpalTable {
  data : @types.PaletteData
  palettes : Array[Array[@types.Color]]
} derive(Show)

///|
fn CpalTable::data(self : CpalTable) -> @types.PaletteData {
  self.data
}

///|
fn CpalTable::palettes(self : CpalTable) -> Array[Array[@types.Color]] {
  self.palettes
}

///|
struct SbixStrike {
  offset : Int
  ppem : UInt
  resolution : UInt
  glyph_offsets : Array[Int]
} derive(Show)

///|
pub fn SbixStrike::offset(self : SbixStrike) -> Int {
  self.offset
}

///|
pub fn SbixStrike::ppem(self : SbixStrike) -> UInt {
  self.ppem
}

///|
pub fn SbixStrike::resolution(self : SbixStrike) -> UInt {
  self.resolution
}

///|
pub fn SbixStrike::glyph_offsets(self : SbixStrike) -> Array[Int] {
  self.glyph_offsets
}

///|
struct SbixTable {
  flags : UInt
  data : Bytes
  strikes : Array[SbixStrike]
} derive(Show)

///|
pub fn SbixTable::flags(self : SbixTable) -> UInt {
  self.flags
}

///|
pub fn SbixTable::data(self : SbixTable) -> Bytes {
  self.data
}

///|
pub fn SbixTable::strikes(self : SbixTable) -> Array[SbixStrike] {
  self.strikes
}

///|
pub struct ColorTables {
  cpal : CpalTable?
  sbix : SbixTable?
  cblc : CblcTable?
  colr : ColrTable?
} derive(Show)

///|
pub fn ColorTables::palette_data(self : ColorTables) -> @types.PaletteData? {
  match self.cpal {
    Some(cpal) => Some(cpal.data())
    None => None
  }
}

///|
pub fn ColorTables::has_sbix(self : ColorTables) -> Bool {
  self.sbix is Some(_)
}

///|
pub fn ColorTables::has_cblc(self : ColorTables) -> Bool {
  self.cblc is Some(_)
}

///|
pub fn ColorTables::sbix(self : ColorTables) -> SbixTable? {
  self.sbix
}

///|
pub fn ColorTables::cblc(self : ColorTables) -> CblcTable? {
  self.cblc
}

///|
pub fn ColorTables::colr(self : ColorTables) -> ColrTable? {
  self.colr
}

///|
pub fn ColorTables::select_palette(
  self : ColorTables,
  palette_index : UInt,
) -> Array[@types.Color]? {
  match self.cpal {
    Some(cpal) => {
      let idx = palette_index.reinterpret_as_int()
      if idx >= 0 && idx < cpal.palettes().length() {
        Some(cpal.palettes()[idx])
      } else {
        None
      }
    }
    None => None
  }
}

///|
fn parse_u16_array(
  data : Bytes,
  offset : Int,
  count : Int,
) -> Array[UInt] raise @error.FTError {
  if offset == 0 {
    return []
  }
  if offset < 0 || offset + count * 2 > data.length() {
    raise @error.FTError::InvalidTable
  }
  let reader = @stream.ByteReader::new(data)
  reader.seek(offset)
  let values : Array[UInt] = []
  for _ in 0..<count {
    values.push(reader.read_u16_be())
  }
  values
}

///|
fn parse_cpal(
  data : Bytes,
  rec : @sfnt.TableRecord,
) -> CpalTable raise @error.FTError {
  let start = rec.offset().reinterpret_as_int()
  let length = rec.length().reinterpret_as_int()
  if length < 12 || start < 0 || start + length > data.length() {
    raise @error.FTError::InvalidTable
  }
  let reader = @stream.ByteReader::new(data)
  reader.seek(start)
  let version = reader.read_u16_be().reinterpret_as_int()
  let num_palette_entries = reader.read_u16_be().reinterpret_as_int()
  let num_palettes = reader.read_u16_be().reinterpret_as_int()
  let num_color_records = reader.read_u16_be().reinterpret_as_int()
  let color_records_offset = reader.read_u32_be().reinterpret_as_int()
  let color_record_indices : Array[Int] = []
  for _ in 0..<num_palettes {
    color_record_indices.push(reader.read_u16_be().reinterpret_as_int())
  }
  let mut palette_types_offset = 0
  let mut palette_labels_offset = 0
  let mut palette_entry_labels_offset = 0
  if version >= 1 && length >= 24 {
    palette_types_offset = reader.read_u32_be().reinterpret_as_int()
    palette_labels_offset = reader.read_u32_be().reinterpret_as_int()
    palette_entry_labels_offset = reader.read_u32_be().reinterpret_as_int()
  }
  let records_base = start + color_records_offset
  if color_records_offset <= 0 ||
    records_base < start ||
    records_base + num_color_records * 4 > start + length {
    raise @error.FTError::InvalidTable
  }
  let mut palette_name_ids = parse_u16_array(
    data,
    if palette_labels_offset == 0 {
      0
    } else {
      start + palette_labels_offset
    },
    num_palettes,
  )
  let mut palette_flags = parse_u16_array(
    data,
    if palette_types_offset == 0 {
      0
    } else {
      start + palette_types_offset
    },
    num_palettes,
  )
  let mut palette_entry_name_ids = parse_u16_array(
    data,
    if palette_entry_labels_offset == 0 {
      0
    } else {
      start + palette_entry_labels_offset
    },
    num_palette_entries,
  )
  if palette_name_ids.length() == 0 {
    palette_name_ids = Array::make(num_palettes, 0xFFFFU)
  }
  if palette_flags.length() == 0 {
    palette_flags = Array::make(num_palettes, 0U)
  }
  if palette_entry_name_ids.length() == 0 {
    palette_entry_name_ids = Array::make(num_palette_entries, 0xFFFFU)
  }
  let palettes : Array[Array[@types.Color]] = []
  for index in color_record_indices {
    if index < 0 || index + num_palette_entries > num_color_records {
      raise @error.FTError::InvalidTable
    }
    let palette : Array[@types.Color] = []
    for j in 0..<num_palette_entries {
      let pos = records_base + (index + j) * 4
      palette.push(
        @types.Color::new(
          data[pos],
          data[pos + 1],
          data[pos + 2],
          data[pos + 3],
        ),
      )
    }
    palettes.push(palette)
  }
  {
    data: @types.PaletteData::new(
      num_palettes.reinterpret_as_uint(),
      palette_name_ids,
      palette_flags,
      num_palette_entries.reinterpret_as_uint(),
      palette_entry_name_ids,
    ),
    palettes,
  }
}

///|
fn parse_sbix(
  data : Bytes,
  rec : @sfnt.TableRecord,
  num_glyphs : UInt,
) -> SbixTable raise @error.FTError {
  let start = rec.offset().reinterpret_as_int()
  let length = rec.length().reinterpret_as_int()
  if length < 8 || start < 0 || start + length > data.length() {
    raise @error.FTError::InvalidTable
  }
  let reader = @stream.ByteReader::new(data)
  reader.seek(start)
  ignore(reader.read_u16_be()) // version
  let flags = reader.read_u16_be()
  let num_strikes = reader.read_u32_be().reinterpret_as_int()
  if num_strikes < 0 || 8 + num_strikes * 4 > length {
    raise @error.FTError::InvalidTable
  }
  let strike_offsets : Array[Int] = []
  for _ in 0..<num_strikes {
    strike_offsets.push(reader.read_u32_be().reinterpret_as_int())
  }
  let strikes : Array[SbixStrike] = []
  for strike_offset in strike_offsets {
    let strike_pos = start + strike_offset
    if strike_offset < 8 ||
      strike_pos < start ||
      strike_pos + 4 > start + length {
      raise @error.FTError::InvalidTable
    }
    reader.seek(strike_pos)
    let ppem = reader.read_u16_be()
    let resolution = reader.read_u16_be()
    let glyph_offsets : Array[Int] = []
    for _ in 0..<(num_glyphs.reinterpret_as_int() + 1) {
      glyph_offsets.push(reader.read_u32_be().reinterpret_as_int())
    }
    strikes.push({ offset: strike_offset, ppem, resolution, glyph_offsets })
  }
  { flags, data: data[start:start + length].to_bytes(), strikes }
}

///|
fn choose_sbix_strike(
  strikes : Array[SbixStrike],
  x_ppem : UInt,
  y_ppem : UInt,
) -> SbixStrike? {
  if strikes.is_empty() {
    return None
  }
  let target = if y_ppem != 0U { y_ppem.to_int() } else { x_ppem.to_int() }
  let mut best = strikes[0]
  let mut best_delta = if best.ppem().to_int() >= target {
    best.ppem().to_int() - target
  } else {
    target - best.ppem().to_int()
  }
  for i in 1..<strikes.length() {
    let strike = strikes[i]
    let delta = if strike.ppem().to_int() >= target {
      strike.ppem().to_int() - target
    } else {
      target - strike.ppem().to_int()
    }
    if delta < best_delta {
      best = strike
      best_delta = delta
    }
  }
  Some(best)
}

///|
fn load_sbix_from_strike(
  table : SbixTable,
  strike : SbixStrike,
  glyph_index : UInt,
  depth : Int,
) -> (@types.Bitmap, Int, Int)? raise @error.FTError {
  if depth > 4 {
    raise @error.FTError::InvalidTable
  }
  let glyph = glyph_index.reinterpret_as_int()
  if glyph < 0 || glyph + 1 >= strike.glyph_offsets().length() {
    return None
  }
  let start = strike.glyph_offsets()[glyph]
  let end_ = strike.glyph_offsets()[glyph + 1]
  if start == end_ {
    return None
  }
  if start < 0 || end_ < start || end_ > table.data().length() - strike.offset() {
    raise @error.FTError::InvalidTable
  }
  let glyph_start = strike.offset() + start
  let glyph_end = strike.offset() + end_
  if glyph_end - glyph_start < 8 {
    raise @error.FTError::InvalidTable
  }
  let data = table.data()
  let reader = @stream.ByteReader::new(data)
  reader.seek(glyph_start)
  let origin_x = reader.read_i16_be()
  let origin_y = reader.read_i16_be()
  let graphic_type = reader.read_u32_be()
  match graphic_type {
    0x706E6720U => {
      let image = decode_png_to_bgra(data[glyph_start + 8:glyph_end].to_bytes())
      Some(
        (
          make_bgra_bitmap(image.width(), image.height(), image.buffer()),
          origin_x,
          origin_y + image.height(),
        ),
      )
    }
    0x64757065U => {
      let referenced = reader.read_u16_be()
      load_sbix_from_strike(table, strike, referenced, depth + 1)
    }
    0x666C6970U => {
      let referenced = reader.read_u16_be()
      match load_sbix_from_strike(table, strike, referenced, depth + 1) {
        Some((bitmap, left, top)) => {
          let width = bitmap.width().reinterpret_as_int()
          let rows = bitmap.rows().reinterpret_as_int()
          Some(
            (
              make_bgra_bitmap(
                width,
                rows,
                flip_bgra_horizontal(bitmap.buffer(), width, rows),
              ),
              left,
              top,
            ),
          )
        }
        None => None
      }
    }
    _ => raise @error.FTError::UnimplementedFeature
  }
}

///|
pub fn load_sbix_glyph(
  tables : ColorTables,
  glyph_index : UInt,
  x_ppem : UInt,
  y_ppem : UInt,
) -> (@types.Bitmap, Int, Int)? raise @error.FTError {
  match tables.sbix {
    Some(table) =>
      match choose_sbix_strike(table.strikes(), x_ppem, y_ppem) {
        Some(strike) => load_sbix_from_strike(table, strike, glyph_index, 0)
        None => None
      }
    None => None
  }
}

///|
pub fn parse_color_tables(
  data : Bytes,
  table_dir : @sfnt.TableDirectory,
  num_glyphs : UInt,
) -> ColorTables? raise @error.FTError {
  let cpal = match table_dir.find_table(@types.TAG_CPAL) {
    Some(rec) => Some(parse_cpal(data, rec))
    None => None
  }
  let sbix = match table_dir.find_table(@types.TAG_SBIX) {
    Some(rec) => Some(parse_sbix(data, rec, num_glyphs))
    None => None
  }
  let cblc = match
    (
      table_dir.find_table(@types.TAG_CBLC),
      table_dir.find_table(@types.TAG_CBDT),
    ) {
    (Some(cblc_rec), Some(cbdt_rec)) =>
      Some(parse_cblc(data, cblc_rec, cbdt_rec))
    _ => None
  }
  let colr = match table_dir.find_table(@types.TAG_COLR) {
    Some(rec) => Some(parse_colr(data, rec))
    None => None
  }
  if cpal is Some(_) || sbix is Some(_) || cblc is Some(_) || colr is Some(_) {
    Some({ cpal, sbix, cblc, colr })
  } else {
    None
  }
}
