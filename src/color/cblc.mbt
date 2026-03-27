///|
struct CblcStrike {
  index_subtable_array_offset : Int
  index_tables_size : Int
  num_subtables : Int
  start_glyph_index : UInt
  end_glyph_index : UInt
  ppem_x : UInt
  ppem_y : UInt
  bit_depth : Int
} derive(Show)

///|
fn CblcStrike::index_subtable_array_offset(self : CblcStrike) -> Int {
  self.index_subtable_array_offset
}

///|
fn CblcStrike::num_subtables(self : CblcStrike) -> Int {
  self.num_subtables
}

///|
pub fn CblcStrike::ppem_x(self : CblcStrike) -> UInt {
  self.ppem_x
}

///|
pub fn CblcStrike::ppem_y(self : CblcStrike) -> UInt {
  self.ppem_y
}

///|
pub fn CblcStrike::bit_depth(self : CblcStrike) -> Int {
  self.bit_depth
}

///|
struct CblcMetrics {
  width : Int
  height : Int
  hori_bearing_x : Int
  hori_bearing_y : Int
  hori_advance : Int
  vert_bearing_x : Int
  vert_bearing_y : Int
  vert_advance : Int
} derive(Show)

///|
fn CblcMetrics::new(
  width : Int,
  height : Int,
  hori_bearing_x : Int,
  hori_bearing_y : Int,
  hori_advance : Int,
  vert_bearing_x? : Int = 0,
  vert_bearing_y? : Int = 0,
  vert_advance? : Int = 0,
) -> CblcMetrics {
  {
    width,
    height,
    hori_bearing_x,
    hori_bearing_y,
    hori_advance,
    vert_bearing_x,
    vert_bearing_y,
    vert_advance,
  }
}

///|
struct CblcTable {
  cblc_data : Bytes
  cbdt_data : Bytes
  strikes : Array[CblcStrike]
} derive(Show)

///|
pub fn CblcTable::strikes(self : CblcTable) -> Array[CblcStrike] {
  self.strikes
}

///|
fn signed_byte(byte : Byte) -> Int {
  let value = byte.to_int()
  if value >= 0x80 {
    value - 0x100
  } else {
    value
  }
}

///|
pub fn parse_cblc(
  data : Bytes,
  cblc_rec : @sfnt.TableRecord,
  cbdt_rec : @sfnt.TableRecord,
) -> CblcTable raise @error.FTError {
  let cblc_start = cblc_rec.offset().reinterpret_as_int()
  let cblc_length = cblc_rec.length().reinterpret_as_int()
  let cbdt_start = cbdt_rec.offset().reinterpret_as_int()
  let cbdt_length = cbdt_rec.length().reinterpret_as_int()
  if cblc_length < 8 ||
    cblc_start < 0 ||
    cblc_start + cblc_length > data.length() ||
    cbdt_start < 0 ||
    cbdt_start + cbdt_length > data.length() {
    raise @error.FTError::InvalidTable
  }
  let reader = @stream.ByteReader::new(data)
  reader.seek(cblc_start)
  ignore(reader.read_u32_be()) // version
  let num_sizes = reader.read_u32_be().reinterpret_as_int()
  if num_sizes < 0 || 8 + num_sizes * 48 > cblc_length {
    raise @error.FTError::InvalidTable
  }
  let strikes : Array[CblcStrike] = []
  for i in 0..<num_sizes {
    let pos = cblc_start + 8 + i * 48
    reader.seek(pos)
    let index_subtable_array_offset = reader.read_u32_be().reinterpret_as_int()
    let index_tables_size = reader.read_u32_be().reinterpret_as_int()
    let num_subtables = reader.read_u32_be().reinterpret_as_int()
    ignore(reader.read_u32_be()) // colorRef
    reader.skip(24) // hori + vert line metrics
    let start_glyph_index = reader.read_u16_be()
    let end_glyph_index = reader.read_u16_be()
    let ppem_x = reader.read_byte().to_uint()
    let ppem_y = reader.read_byte().to_uint()
    let bit_depth = reader.read_byte().to_int()
    ignore(reader.read_byte()) // flags
    if index_subtable_array_offset < 0 ||
      index_subtable_array_offset + num_subtables * 8 > cblc_length ||
      index_tables_size < 0 {
      raise @error.FTError::InvalidTable
    }
    strikes.push({
      index_subtable_array_offset,
      index_tables_size,
      num_subtables,
      start_glyph_index,
      end_glyph_index,
      ppem_x,
      ppem_y,
      bit_depth,
    })
  }
  {
    cblc_data: data[cblc_start:cblc_start + cblc_length].to_bytes(),
    cbdt_data: data[cbdt_start:cbdt_start + cbdt_length].to_bytes(),
    strikes,
  }
}

///|
fn choose_cblc_strike(
  strikes : Array[CblcStrike],
  x_ppem : UInt,
  y_ppem : UInt,
) -> CblcStrike? {
  if strikes.is_empty() {
    return None
  }
  let target = if y_ppem != 0U { y_ppem.to_int() } else { x_ppem.to_int() }
  let mut best = strikes[0]
  let mut best_delta = if best.ppem_y().to_int() >= target {
    best.ppem_y().to_int() - target
  } else {
    target - best.ppem_y().to_int()
  }
  for i in 1..<strikes.length() {
    let strike = strikes[i]
    let delta = if strike.ppem_y().to_int() >= target {
      strike.ppem_y().to_int() - target
    } else {
      target - strike.ppem_y().to_int()
    }
    if delta < best_delta {
      best = strike
      best_delta = delta
    }
  }
  Some(best)
}

///|
fn parse_small_metrics(
  data : Bytes,
  offset : Int,
) -> CblcMetrics raise @error.FTError {
  if offset < 0 || offset + 5 > data.length() {
    raise @error.FTError::InvalidTable
  }
  CblcMetrics::new(
    data[offset].to_int(),
    data[offset + 1].to_int(),
    signed_byte(data[offset + 2]),
    signed_byte(data[offset + 3]),
    data[offset + 4].to_int(),
  )
}

///|
fn parse_big_metrics(
  data : Bytes,
  offset : Int,
) -> CblcMetrics raise @error.FTError {
  if offset < 0 || offset + 8 > data.length() {
    raise @error.FTError::InvalidTable
  }
  CblcMetrics::new(
    data[offset].to_int(),
    data[offset + 1].to_int(),
    signed_byte(data[offset + 2]),
    signed_byte(data[offset + 3]),
    data[offset + 4].to_int(),
    vert_bearing_x=signed_byte(data[offset + 5]),
    vert_bearing_y=signed_byte(data[offset + 6]),
    vert_advance=data[offset + 7].to_int(),
  )
}

///|
fn read_cblc_png_glyph(
  table : CblcTable,
  image_format : Int,
  image_start : Int,
  image_length : Int,
  fallback_metrics? : CblcMetrics? = None,
) -> @base.BitmapGlyphData? raise @error.FTError {
  if image_start < 0 ||
    image_length <= 0 ||
    image_start + image_length > table.cbdt_data.length() {
    raise @error.FTError::InvalidTable
  }
  let cbdt = table.cbdt_data
  let (metrics, png_offset) = match image_format {
    17 => (parse_small_metrics(cbdt, image_start), image_start + 5)
    18 => (parse_big_metrics(cbdt, image_start), image_start + 8)
    19 =>
      match fallback_metrics {
        Some(m) => (m, image_start)
        None => raise @error.FTError::InvalidTable
      }
    _ => raise @error.FTError::UnimplementedFeature
  }
  if png_offset + 4 > cbdt.length() || png_offset > image_start + image_length {
    raise @error.FTError::InvalidTable
  }
  let png_reader = @stream.ByteReader::new(cbdt)
  png_reader.seek(png_offset)
  let png_len = png_reader.read_u32_be().reinterpret_as_int()
  let png_data_offset = png_offset + 4
  if png_len < 0 ||
    png_data_offset + png_len > cbdt.length() ||
    png_data_offset + png_len > image_start + image_length {
    raise @error.FTError::InvalidTable
  }
  let image = decode_png_to_bgra(
    cbdt[png_data_offset:png_data_offset + png_len].to_bytes(),
  )
  Some(
    make_bitmap_glyph_data(
      make_bgra_bitmap(image.width(), image.height(), image.buffer()),
      metrics.hori_bearing_x,
      metrics.hori_bearing_y,
      metrics.hori_advance,
      vert_advance=metrics.vert_advance,
      vert_bearing_x=metrics.vert_bearing_x,
      vert_bearing_y=metrics.vert_bearing_y,
    ),
  )
}

///|
pub fn load_cblc_glyph(
  table : CblcTable,
  glyph_index : UInt,
  x_ppem : UInt,
  y_ppem : UInt,
) -> @base.BitmapGlyphData? raise @error.FTError {
  let strike = match choose_cblc_strike(table.strikes(), x_ppem, y_ppem) {
    Some(strike) => strike
    None => return None
  }
  let cblc = table.cblc_data
  let array_base = strike.index_subtable_array_offset()
  let mut entry_pos = -1
  for i in 0..<strike.num_subtables() {
    let pos = array_base + i * 8
    if pos < 0 || pos + 8 > cblc.length() {
      raise @error.FTError::InvalidTable
    }
    let reader = @stream.ByteReader::new(cblc)
    reader.seek(pos)
    let start_glyph = reader.read_u16_be()
    let end_glyph = reader.read_u16_be()
    ignore(reader.read_u32_be())
    if glyph_index >= start_glyph && glyph_index <= end_glyph {
      entry_pos = pos
      break
    }
  }
  if entry_pos < 0 {
    return None
  }

  let entry_reader = @stream.ByteReader::new(cblc)
  entry_reader.seek(entry_pos)
  let start_glyph = entry_reader.read_u16_be()
  ignore(entry_reader.read_u16_be())
  let additional_offset = entry_reader.read_u32_be().reinterpret_as_int()
  let subtable_pos = array_base + additional_offset
  if subtable_pos < 0 || subtable_pos + 8 > cblc.length() {
    raise @error.FTError::InvalidTable
  }

  let reader = @stream.ByteReader::new(cblc)
  reader.seek(subtable_pos)
  let index_format = reader.read_u16_be().reinterpret_as_int()
  let image_format = reader.read_u16_be().reinterpret_as_int()
  let image_data_offset = reader.read_u32_be().reinterpret_as_int()
  let glyph_delta = glyph_index.reinterpret_as_int() -
    start_glyph.reinterpret_as_int()

  let mut image_start = -1
  let mut image_end = -1
  let mut fallback_metrics : CblcMetrics? = None
  match index_format {
    1 => {
      let pos = subtable_pos + 8 + glyph_delta * 4
      if glyph_delta < 0 || pos < 0 || pos + 8 > cblc.length() {
        return None
      }
      let offsets_reader = @stream.ByteReader::new(cblc)
      offsets_reader.seek(pos)
      image_start = offsets_reader.read_u32_be().reinterpret_as_int()
      image_end = offsets_reader.read_u32_be().reinterpret_as_int()
    }
    3 => {
      let pos = subtable_pos + 8 + glyph_delta * 2
      if glyph_delta < 0 || pos < 0 || pos + 4 > cblc.length() {
        return None
      }
      let offsets_reader = @stream.ByteReader::new(cblc)
      offsets_reader.seek(pos)
      image_start = offsets_reader.read_u16_be().reinterpret_as_int()
      image_end = offsets_reader.read_u16_be().reinterpret_as_int()
    }
    4 => {
      let num_glyphs = reader.read_u32_be().reinterpret_as_int()
      if num_glyphs < 0 ||
        subtable_pos + 12 + (num_glyphs + 1) * 4 > cblc.length() {
        raise @error.FTError::InvalidTable
      }
      for i in 0..<num_glyphs {
        let pair_pos = subtable_pos + 12 + i * 4
        let pair_reader = @stream.ByteReader::new(cblc)
        pair_reader.seek(pair_pos)
        if pair_reader.read_u16_be() == glyph_index {
          image_start = pair_reader.read_u16_be().reinterpret_as_int()
          let next_reader = @stream.ByteReader::new(cblc)
          next_reader.seek(pair_pos + 4)
          ignore(next_reader.read_u16_be())
          image_end = next_reader.read_u16_be().reinterpret_as_int()
          break
        }
      }
    }
    5 => {
      let image_size = reader.read_u32_be().reinterpret_as_int()
      fallback_metrics = Some(parse_big_metrics(cblc, subtable_pos + 12))
      reader.seek(subtable_pos + 20)
      let num_glyphs = reader.read_u32_be().reinterpret_as_int()
      if num_glyphs < 0 || subtable_pos + 24 + num_glyphs * 2 > cblc.length() {
        raise @error.FTError::InvalidTable
      }
      for i in 0..<num_glyphs {
        let gpos = subtable_pos + 24 + i * 2
        let glyph_reader = @stream.ByteReader::new(cblc)
        glyph_reader.seek(gpos)
        if glyph_reader.read_u16_be() == glyph_index {
          image_start = image_size * i
          image_end = image_start + image_size
          break
        }
      }
    }
    _ => return None
  }

  if image_start < 0 || image_end <= image_start {
    return None
  }
  read_cblc_png_glyph(
    table,
    image_format,
    image_data_offset + image_start,
    image_end - image_start,
    fallback_metrics~,
  )
}
