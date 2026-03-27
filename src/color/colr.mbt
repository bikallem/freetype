///|
struct ColrV0Layer {
  glyph_id : UInt
  palette_index : UInt
} derive(Eq, Show)

///|
pub fn ColrV0Layer::glyph_id(self : ColrV0Layer) -> UInt {
  self.glyph_id
}

///|
pub fn ColrV0Layer::palette_index(self : ColrV0Layer) -> UInt {
  self.palette_index
}

///|
pub(all) enum ColrPaint {
  ColrLayers(Int, Int) // (num_layers, first_layer_index)
  Solid(UInt, Int) // (palette_index, alpha F2Dot14)
  Glyph(Int, UInt) // (child_paint_offset, glyph_id)
  ColrGlyph(UInt) // glyph_id
  Transform(Int, @fixed.Matrix, Int64, Int64) // child offset, matrix, dx, dy (16.16)
  Translate(Int, Int64, Int64) // child offset, dx, dy (16.16)
  Scale(Int, @fixed.Fixed, @fixed.Fixed, Int64, Int64) // child, sx, sy, cx, cy
  Rotate(Int, @fixed.Fixed, Int64, Int64) // child, angle(turns/180 in 16.16), cx, cy
  Skew(Int, @fixed.Fixed, @fixed.Fixed, Int64, Int64) // child, x_angle, y_angle, cx, cy
  Composite(Int, Int, Int) // source offset, composite mode, backdrop offset
  Unsupported(Int)
} derive(Show)

///|
pub struct ColrTable {
  data : Bytes
  version : Int
  num_base_glyphs : Int
  base_glyphs_offset : Int
  layer_records_offset : Int
  num_layers : Int
  num_base_glyphs_v1 : Int
  base_glyphs_offset_v1 : Int
  num_layers_v1 : Int
  layers_offset_v1 : Int
  paints_start_v1 : Int
} derive(Show)

///|
pub fn ColrTable::version(self : ColrTable) -> Int {
  self.version
}

///|
fn read_u16_at(data : Bytes, offset : Int) -> UInt raise @error.FTError {
  if offset < 0 || offset + 2 > data.length() {
    raise @error.FTError::InvalidTable
  }
  data.unsafe_read_uint16_be(offset).to_uint()
}

///|
fn read_i16_at(data : Bytes, offset : Int) -> Int raise @error.FTError {
  let value = read_u16_at(data, offset).reinterpret_as_int()
  if value >= 0x8000 {
    value - 0x10000
  } else {
    value
  }
}

///|
fn read_u24_at(data : Bytes, offset : Int) -> Int raise @error.FTError {
  if offset < 0 || offset + 3 > data.length() {
    raise @error.FTError::InvalidTable
  }
  (data[offset].to_int() << 16) |
  (data[offset + 1].to_int() << 8) |
  data[offset + 2].to_int()
}

///|
fn read_i32_at(data : Bytes, offset : Int) -> Int64 raise @error.FTError {
  if offset < 0 || offset + 4 > data.length() {
    raise @error.FTError::InvalidTable
  }
  data.unsafe_read_uint32_be(offset).reinterpret_as_int().to_int64()
}

///|
pub fn parse_colr(
  data : Bytes,
  rec : @sfnt.TableRecord,
) -> ColrTable raise @error.FTError {
  let start = rec.offset().reinterpret_as_int()
  let length = rec.length().reinterpret_as_int()
  if length < 14 || start < 0 || start + length > data.length() {
    raise @error.FTError::InvalidTable
  }
  let table = data[start:start + length].to_bytes()
  let version = read_u16_at(table, 0).reinterpret_as_int()
  if version != 0 && version != 1 {
    raise @error.FTError::InvalidTable
  }
  let num_base_glyphs = read_u16_at(table, 2).reinterpret_as_int()
  let base_glyphs_offset = table.unsafe_read_uint32_be(4).reinterpret_as_int()
  let layer_records_offset = table.unsafe_read_uint32_be(8).reinterpret_as_int()
  let num_layers = read_u16_at(table, 12).reinterpret_as_int()
  if base_glyphs_offset < 0 ||
    base_glyphs_offset + num_base_glyphs * 6 > table.length() ||
    layer_records_offset < 0 ||
    layer_records_offset + num_layers * 4 > table.length() {
    raise @error.FTError::InvalidTable
  }
  let mut num_base_glyphs_v1 = 0
  let mut base_glyphs_offset_v1 = 0
  let mut num_layers_v1 = 0
  let mut layers_offset_v1 = 0
  let mut paints_start_v1 = 0
  if version == 1 {
    if length < 34 {
      raise @error.FTError::InvalidTable
    }
    base_glyphs_offset_v1 = table.unsafe_read_uint32_be(14).reinterpret_as_int()
    layers_offset_v1 = table.unsafe_read_uint32_be(18).reinterpret_as_int()
    if base_glyphs_offset_v1 <= 0 || base_glyphs_offset_v1 + 4 > table.length() {
      raise @error.FTError::InvalidTable
    }
    num_base_glyphs_v1 = table
      .unsafe_read_uint32_be(base_glyphs_offset_v1)
      .reinterpret_as_int()
    if base_glyphs_offset_v1 + 4 + num_base_glyphs_v1 * 6 > table.length() {
      raise @error.FTError::InvalidTable
    }
    if layers_offset_v1 != 0 {
      if layers_offset_v1 + 4 > table.length() {
        raise @error.FTError::InvalidTable
      }
      num_layers_v1 = table
        .unsafe_read_uint32_be(layers_offset_v1)
        .reinterpret_as_int()
      if layers_offset_v1 + 4 + num_layers_v1 * 4 > table.length() {
        raise @error.FTError::InvalidTable
      }
      paints_start_v1 = if base_glyphs_offset_v1 + 4 + num_base_glyphs_v1 * 6 <
        layers_offset_v1 + 4 + num_layers_v1 * 4 {
        base_glyphs_offset_v1 + 4 + num_base_glyphs_v1 * 6
      } else {
        layers_offset_v1 + 4 + num_layers_v1 * 4
      }
    } else {
      paints_start_v1 = base_glyphs_offset_v1 + 4 + num_base_glyphs_v1 * 6
    }
    if paints_start_v1 < 0 || paints_start_v1 >= table.length() {
      raise @error.FTError::InvalidTable
    }
  }
  {
    data: table,
    version,
    num_base_glyphs,
    base_glyphs_offset,
    layer_records_offset,
    num_layers,
    num_base_glyphs_v1,
    base_glyphs_offset_v1,
    num_layers_v1,
    layers_offset_v1,
    paints_start_v1,
  }
}

///|
pub fn ColrTable::v0_layers(
  self : ColrTable,
  glyph_id : UInt,
) -> Array[ColrV0Layer] raise @error.FTError {
  let layers : Array[ColrV0Layer] = []
  for i in 0..<self.num_base_glyphs {
    let record_offset = self.base_glyphs_offset + i * 6
    if read_u16_at(self.data, record_offset) == glyph_id {
      let first_layer = read_u16_at(self.data, record_offset + 2).reinterpret_as_int()
      let num_layers = read_u16_at(self.data, record_offset + 4).reinterpret_as_int()
      if first_layer < 0 || first_layer + num_layers > self.num_layers {
        raise @error.FTError::InvalidTable
      }
      for j in 0..<num_layers {
        let layer_offset = self.layer_records_offset + (first_layer + j) * 4
        layers.push({
          glyph_id: read_u16_at(self.data, layer_offset),
          palette_index: read_u16_at(self.data, layer_offset + 2),
        })
      }
      break
    }
  }
  layers
}

///|
pub fn ColrTable::v1_root_paint_offset(
  self : ColrTable,
  glyph_id : UInt,
) -> Int? raise @error.FTError {
  if self.version < 1 || self.num_base_glyphs_v1 <= 0 {
    return None
  }
  for i in 0..<self.num_base_glyphs_v1 {
    let record_offset = self.base_glyphs_offset_v1 + 4 + i * 6
    if read_u16_at(self.data, record_offset) == glyph_id {
      let paint_offset = self.data
        .unsafe_read_uint32_be(record_offset + 2)
        .reinterpret_as_int()
      if paint_offset <= 0 {
        return None
      }
      let absolute = self.base_glyphs_offset_v1 + paint_offset
      if absolute < self.paints_start_v1 || absolute >= self.data.length() {
        raise @error.FTError::InvalidTable
      }
      return Some(absolute)
    }
  }
  None
}

///|
pub fn ColrTable::v1_layer_paint_offsets(
  self : ColrTable,
  first_layer_index : Int,
  num_layers : Int,
) -> Array[Int] raise @error.FTError {
  let offsets : Array[Int] = []
  if self.layers_offset_v1 == 0 {
    raise @error.FTError::InvalidTable
  }
  if first_layer_index < 0 ||
    num_layers < 0 ||
    first_layer_index + num_layers > self.num_layers_v1 {
    raise @error.FTError::InvalidTable
  }
  for i in 0..<num_layers {
    let record_offset = self.layers_offset_v1 + 4 + (first_layer_index + i) * 4
    let paint_delta = self.data
      .unsafe_read_uint32_be(record_offset)
      .reinterpret_as_int()
    let absolute = self.layers_offset_v1 + paint_delta
    if absolute < self.paints_start_v1 || absolute >= self.data.length() {
      raise @error.FTError::InvalidTable
    }
    offsets.push(absolute)
  }
  offsets
}

///|
pub fn ColrTable::read_paint(
  self : ColrTable,
  paint_offset : Int,
) -> ColrPaint raise @error.FTError {
  if paint_offset < self.paints_start_v1 || paint_offset >= self.data.length() {
    raise @error.FTError::InvalidTable
  }
  let format = self.data[paint_offset].to_int()
  let paint_base = paint_offset
  let child_offset = fn(field_offset : Int) -> Int raise @error.FTError {
    let delta = read_u24_at(self.data, field_offset)
    if delta <= 0 {
      raise @error.FTError::InvalidTable
    }
    let absolute = paint_base + delta
    if absolute < self.paints_start_v1 || absolute >= self.data.length() {
      raise @error.FTError::InvalidTable
    }
    absolute
  }
  match format {
    1 =>
      ColrLayers(
        self.data[paint_offset + 1].to_int(),
        self.data.unsafe_read_uint32_be(paint_offset + 2).reinterpret_as_int(),
      )
    2 =>
      Solid(
        read_u16_at(self.data, paint_offset + 1),
        read_i16_at(self.data, paint_offset + 3),
      )
    10 =>
      Glyph(
        child_offset(paint_offset + 1),
        read_u16_at(self.data, paint_offset + 4),
      )
    11 => ColrGlyph(read_u16_at(self.data, paint_offset + 1))
    12 => {
      let paint = child_offset(paint_offset + 1)
      let transform = child_offset(paint_offset + 4)
      Transform(
        paint,
        @fixed.Matrix::new(
          @fixed.Fixed::from_raw(read_i32_at(self.data, transform)),
          @fixed.Fixed::from_raw(read_i32_at(self.data, transform + 8)),
          @fixed.Fixed::from_raw(read_i32_at(self.data, transform + 4)),
          @fixed.Fixed::from_raw(read_i32_at(self.data, transform + 12)),
        ),
        read_i32_at(self.data, transform + 16),
        read_i32_at(self.data, transform + 20),
      )
    }
    14 =>
      Translate(
        child_offset(paint_offset + 1),
        @fixed.Fixed::from_int(read_i16_at(self.data, paint_offset + 4)).val(),
        @fixed.Fixed::from_int(read_i16_at(self.data, paint_offset + 6)).val(),
      )
    16 =>
      Scale(
        child_offset(paint_offset + 1),
        @fixed.F2Dot14::from_raw(read_i16_at(self.data, paint_offset + 4)).to_fixed(),
        @fixed.F2Dot14::from_raw(read_i16_at(self.data, paint_offset + 6)).to_fixed(),
        0L,
        0L,
      )
    24 =>
      Rotate(
        child_offset(paint_offset + 1),
        @fixed.F2Dot14::from_raw(read_i16_at(self.data, paint_offset + 4)).to_fixed(),
        0L,
        0L,
      )
    28 =>
      Skew(
        child_offset(paint_offset + 1),
        @fixed.F2Dot14::from_raw(read_i16_at(self.data, paint_offset + 4)).to_fixed(),
        @fixed.F2Dot14::from_raw(read_i16_at(self.data, paint_offset + 6)).to_fixed(),
        0L,
        0L,
      )
    32 =>
      Composite(
        child_offset(paint_offset + 1),
        self.data[paint_offset + 4].to_int(),
        child_offset(paint_offset + 5),
      )
    _ => Unsupported(format)
  }
}
