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
pub(all) struct ColrColorStop {
  stop_offset : @fixed.Fixed
  palette_index : UInt
  alpha : Int
  order : Int
} derive(Eq, Show)

///|
pub fn ColrColorStop::stop_offset(self : ColrColorStop) -> @fixed.Fixed {
  self.stop_offset
}

///|
pub fn ColrColorStop::palette_index(self : ColrColorStop) -> UInt {
  self.palette_index
}

///|
pub fn ColrColorStop::alpha(self : ColrColorStop) -> Int {
  self.alpha
}

///|
pub(all) struct ColrColorLine {
  extend : Int
  stops : Array[ColrColorStop]
} derive(Show)

///|
pub fn ColrColorLine::extend(self : ColrColorLine) -> Int {
  self.extend
}

///|
pub fn ColrColorLine::stops(self : ColrColorLine) -> Array[ColrColorStop] {
  self.stops
}

///|
pub(all) struct ColrClipBox {
  x_min : Int64
  y_min : Int64
  x_max : Int64
  y_max : Int64
} derive(Eq, Show)

///|
pub fn ColrClipBox::x_min(self : ColrClipBox) -> Int64 {
  self.x_min
}

///|
pub fn ColrClipBox::y_min(self : ColrClipBox) -> Int64 {
  self.y_min
}

///|
pub fn ColrClipBox::x_max(self : ColrClipBox) -> Int64 {
  self.x_max
}

///|
pub fn ColrClipBox::y_max(self : ColrClipBox) -> Int64 {
  self.y_max
}

///|
pub(all) enum ColrPaint {
  ColrLayers(Int, Int) // (num_layers, first_layer_index)
  Solid(UInt, Int) // (palette_index, alpha F2Dot14)
  LinearGradient(ColrColorLine, Int64, Int64, Int64, Int64, Int64, Int64) // p0, p1, p2 in 16.16 font units
  RadialGradient(ColrColorLine, Int64, Int64, Int64, Int64, Int64, Int64) // c0, r0, c1, r1 in 16.16 font units
  SweepGradient(ColrColorLine, Int64, Int64, @fixed.Fixed, @fixed.Fixed) // center, start, end
  Glyph(Int, UInt) // (child_paint_offset, glyph_id)
  ColrGlyph(UInt) // glyph_id
  Transform(Int, @fixed.Matrix, Int64, Int64) // child offset, matrix, dx, dy (16.16 device transform values)
  Translate(Int, Int64, Int64) // child offset, dx, dy (16.16 font units)
  Scale(Int, @fixed.Fixed, @fixed.Fixed, Int64, Int64) // child, sx, sy, cx, cy
  Rotate(Int, @fixed.Fixed, Int64, Int64) // child, angle(turns/180 in 16.16), cx, cy
  Skew(Int, @fixed.Fixed, @fixed.Fixed, Int64, Int64) // child, x_angle, y_angle, cx, cy
  Composite(Int, Int, Int) // source offset, composite mode, backdrop offset
  Unsupported(Int)
} derive(Show)

///|
struct RegionAxisCoordinates {
  start_coord : Int
  peak_coord : Int
  end_coord : Int
} derive(Show)

///|
struct ItemVariationData {
  region_indexes : Array[Int]
  delta_sets : Array[Array[Int]]
} derive(Show)

///|
struct DeltaSetIndexMapEntry {
  outer_index : Int
  inner_index : Int
} derive(Show)

///|
struct DeltaSetIndexMap {
  entries : Array[DeltaSetIndexMapEntry]
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
  clip_list_offset : Int
  var_index_map_offset : Int
  item_var_store_offset : Int
  paints_start_v1 : Int
  regions : Array[Array[RegionAxisCoordinates]]
  item_data : Array[ItemVariationData?]
  delta_set_index_map : DeltaSetIndexMap?
} derive(Show)

///|
let paint_format_var_solid = 3

///|
let paint_format_var_linear_gradient = 5

///|
let paint_format_var_radial_gradient = 7

///|
let paint_format_var_sweep_gradient = 9

///|
let paint_format_var_transform = 13

///|
let paint_format_var_translate = 15

///|
let paint_format_scale = 16

///|
let paint_format_var_scale = 17

///|
let paint_format_scale_center = 18

///|
let paint_format_var_scale_center = 19

///|
let paint_format_var_scale_uniform = 21

///|
let paint_format_scale_uniform_center = 22

///|
let paint_format_var_scale_uniform_center = 23

///|
let paint_format_var_rotate = 25

///|
let paint_format_rotate_center = 26

///|
let paint_format_var_rotate_center = 27

///|
let paint_format_var_skew = 29

///|
let paint_format_skew_center = 30

///|
let paint_format_var_skew_center = 31

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
fn child_offset(
  data : Bytes,
  paint_base : Int,
  field_offset : Int,
) -> Int raise @error.FTError {
  let delta = read_u24_at(data, field_offset)
  if delta <= 0 {
    raise @error.FTError::InvalidTable
  }
  let absolute = paint_base + delta
  if absolute <= 0 || absolute >= data.length() {
    raise @error.FTError::InvalidTable
  }
  absolute
}

///|
fn point_delta_scalar(
  coord : Int,
  start_coord : Int,
  peak_coord : Int,
  end_coord : Int,
) -> @fixed.Fixed {
  if start_coord > peak_coord || peak_coord > end_coord {
    return @fixed.Fixed::one()
  }
  if start_coord < 0 && end_coord > 0 && peak_coord != 0 {
    return @fixed.Fixed::one()
  }
  if peak_coord == 0 {
    return @fixed.Fixed::one()
  }
  if coord < start_coord || coord > end_coord {
    return @fixed.Fixed::zero()
  }
  if coord == peak_coord {
    return @fixed.Fixed::one()
  }
  if coord < peak_coord {
    @fixed.div_fix(
      (coord - start_coord).to_int64(),
      (peak_coord - start_coord).to_int64(),
    )
  } else {
    @fixed.div_fix(
      (end_coord - coord).to_int64(),
      (end_coord - peak_coord).to_int64(),
    )
  }
}

///|
fn region_scalar(
  axes : Array[RegionAxisCoordinates],
  normalized_coords : Array[Int],
) -> @fixed.Fixed {
  let mut scalar = @fixed.Fixed::one()
  for i, axis in axes {
    let coord = if i < normalized_coords.length() {
      normalized_coords[i]
    } else {
      0
    }
    scalar = @fixed.mul_fix(
      scalar,
      point_delta_scalar(
        coord,
        axis.start_coord,
        axis.peak_coord,
        axis.end_coord,
      ),
    )
    if scalar.val() == 0L {
      break
    }
  }
  scalar
}

///|
fn scale_delta(delta : Int, scalar : @fixed.Fixed) -> Int64 {
  @fixed.mul_fix(scalar, @fixed.Fixed::from_raw(delta.to_int64())).val()
}

///|
fn item_store_delta(
  regions : Array[Array[RegionAxisCoordinates]],
  item_data : Array[ItemVariationData?],
  outer_index : Int,
  inner_index : Int,
  normalized_coords : Array[Int],
) -> Int64 {
  if outer_index < 0 || outer_index >= item_data.length() {
    return 0L
  }
  let subtable = match item_data[outer_index] {
    Some(v) => v
    None => return 0L
  }
  if inner_index < 0 || inner_index >= subtable.delta_sets.length() {
    return 0L
  }
  let deltas = subtable.delta_sets[inner_index]
  let mut total = 0L
  for i, delta in deltas {
    if i >= subtable.region_indexes.length() {
      break
    }
    let region_index = subtable.region_indexes[i]
    if region_index < 0 || region_index >= regions.length() {
      continue
    }
    let scalar = region_scalar(regions[region_index], normalized_coords)
    if scalar.val() != 0L {
      total += scale_delta(delta, scalar)
    }
  }
  total
}

///|
fn delta_set_index_map_entry(
  entry_format : UInt,
  raw_value : UInt,
) -> DeltaSetIndexMapEntry {
  let inner_bits = (entry_format & 0x000FU).reinterpret_as_int() + 1
  let inner_mask = (1U << inner_bits) - 1U
  let inner_index = (raw_value & inner_mask).reinterpret_as_int()
  let outer_index = (raw_value >> inner_bits).reinterpret_as_int()
  { outer_index, inner_index }
}

///|
fn parse_delta_set_index_map(
  reader : @stream.ByteReader,
  offset : Int,
) -> DeltaSetIndexMap raise @error.FTError {
  reader.seek(offset)
  let entry_format = reader.read_u16_be()
  let map_count = reader.read_u16_be().reinterpret_as_int()
  let entry_size = ((entry_format >> 4) & 0x0003U).reinterpret_as_int() + 1
  let entries : Array[DeltaSetIndexMapEntry] = Array::new(capacity=map_count)
  for _ in 0..<map_count {
    let raw = match entry_size {
      1 => reader.read_byte().to_uint()
      2 => reader.read_u16_be()
      3 =>
        (reader.read_byte().to_uint() << 16) |
        (reader.read_byte().to_uint() << 8) |
        reader.read_byte().to_uint()
      _ => reader.read_u32_be()
    }
    entries.push(delta_set_index_map_entry(entry_format, raw))
  }
  { entries, }
}

///|
fn parse_variation_region_list(
  reader : @stream.ByteReader,
  offset : Int,
) -> Array[Array[RegionAxisCoordinates]] raise @error.FTError {
  reader.seek(offset)
  let axis_count = reader.read_u16_be().reinterpret_as_int()
  let region_count = reader.read_u16_be().reinterpret_as_int()
  let regions : Array[Array[RegionAxisCoordinates]] = Array::new(
    capacity=region_count,
  )
  for _ in 0..<region_count {
    let region_axes : Array[RegionAxisCoordinates] = Array::new(
      capacity=axis_count,
    )
    for _ in 0..<axis_count {
      region_axes.push({
        start_coord: reader.read_i16_be(),
        peak_coord: reader.read_i16_be(),
        end_coord: reader.read_i16_be(),
      })
    }
    regions.push(region_axes)
  }
  regions
}

///|
fn parse_item_variation_data(
  reader : @stream.ByteReader,
  offset : Int,
) -> ItemVariationData raise @error.FTError {
  reader.seek(offset)
  let item_count = reader.read_u16_be().reinterpret_as_int()
  let word_delta_count_raw = reader.read_u16_be()
  let long_words = (word_delta_count_raw & 0x8000U) != 0U
  let word_delta_count = (word_delta_count_raw & 0x7FFFU).reinterpret_as_int()
  let region_index_count = reader.read_u16_be().reinterpret_as_int()
  let region_indexes : Array[Int] = Array::new(capacity=region_index_count)
  for _ in 0..<region_index_count {
    region_indexes.push(reader.read_u16_be().reinterpret_as_int())
  }
  let delta_sets : Array[Array[Int]] = Array::new(capacity=item_count)
  for _ in 0..<item_count {
    let row : Array[Int] = Array::new(capacity=region_index_count)
    for i in 0..<region_index_count {
      if i < word_delta_count {
        if long_words {
          row.push(reader.read_i32_be())
        } else {
          row.push(reader.read_i16_be())
        }
      } else if long_words {
        row.push(reader.read_i16_be())
      } else {
        let value = reader.read_byte().to_int()
        row.push(if value >= 128 { value - 256 } else { value })
      }
    }
    delta_sets.push(row)
  }
  { region_indexes, delta_sets }
}

///|
fn parse_item_variation_store(
  reader : @stream.ByteReader,
  offset : Int,
) -> (Array[Array[RegionAxisCoordinates]], Array[ItemVariationData?]) raise @error.FTError {
  reader.seek(offset)
  let format = reader.read_u16_be()
  if format != 1U {
    raise @error.FTError::InvalidTable
  }
  let region_list_offset = reader.read_u32_be().reinterpret_as_int()
  let item_data_count = reader.read_u16_be().reinterpret_as_int()
  let item_data_offsets : Array[Int] = Array::new(capacity=item_data_count)
  for _ in 0..<item_data_count {
    item_data_offsets.push(reader.read_u32_be().reinterpret_as_int())
  }
  let regions = parse_variation_region_list(reader, offset + region_list_offset)
  let item_data : Array[ItemVariationData?] = Array::new(
    capacity=item_data_count,
  )
  for _, data_offset in item_data_offsets {
    if data_offset == 0 {
      item_data.push(None)
    } else {
      item_data.push(
        Some(parse_item_variation_data(reader, offset + data_offset)),
      )
    }
  }
  (regions, item_data)
}

///|
fn fword_to_fixed(value : Int) -> Int64 {
  @fixed.Fixed::from_int(value).val()
}

///|
fn f2dot14_to_fixed(value : Int) -> @fixed.Fixed {
  @fixed.F2Dot14::from_raw(value).to_fixed()
}

///|
fn sort_color_stops(stops : Array[ColrColorStop]) -> Unit {
  stops.sort_by(fn(a, b) {
    let cmp = a.stop_offset().compare(b.stop_offset())
    if cmp == 0 {
      a.order.compare(b.order)
    } else {
      cmp
    }
  })
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
  let mut clip_list_offset = 0
  let mut var_index_map_offset = 0
  let mut item_var_store_offset = 0
  let mut paints_start_v1 = 0
  let mut regions : Array[Array[RegionAxisCoordinates]] = []
  let mut item_data : Array[ItemVariationData?] = []
  let mut delta_set_index_map : DeltaSetIndexMap? = None
  if version == 1 {
    if length < 34 {
      raise @error.FTError::InvalidTable
    }
    base_glyphs_offset_v1 = table.unsafe_read_uint32_be(14).reinterpret_as_int()
    layers_offset_v1 = table.unsafe_read_uint32_be(18).reinterpret_as_int()
    clip_list_offset = table.unsafe_read_uint32_be(22).reinterpret_as_int()
    var_index_map_offset = table.unsafe_read_uint32_be(26).reinterpret_as_int()
    item_var_store_offset = table.unsafe_read_uint32_be(30).reinterpret_as_int()
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
    }
    paints_start_v1 = 1
    if clip_list_offset != 0 && clip_list_offset >= table.length() {
      raise @error.FTError::InvalidTable
    }
    let reader = @stream.ByteReader::new(table)
    if item_var_store_offset != 0 {
      if item_var_store_offset >= table.length() {
        raise @error.FTError::InvalidTable
      }
      let (parsed_regions, parsed_item_data) = parse_item_variation_store(
        reader, item_var_store_offset,
      )
      regions = parsed_regions
      item_data = parsed_item_data
    }
    if var_index_map_offset != 0 {
      if var_index_map_offset >= table.length() {
        raise @error.FTError::InvalidTable
      }
      delta_set_index_map = Some(
        parse_delta_set_index_map(reader, var_index_map_offset),
      )
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
    clip_list_offset,
    var_index_map_offset,
    item_var_store_offset,
    paints_start_v1,
    regions,
    item_data,
    delta_set_index_map,
  }
}

///|
fn ColrTable::variation_deltas(
  self : ColrTable,
  var_index_base : UInt,
  num_deltas : Int,
  normalized_coords : Array[Int],
) -> Array[Int64] {
  let deltas : Array[Int64] = Array::new(capacity=num_deltas)
  if num_deltas <= 0 ||
    var_index_base == 0xFFFF_FFFFU ||
    self.item_data.is_empty() {
    for _ in 0..<num_deltas {
      deltas.push(0L)
    }
    return deltas
  }
  for i in 0..<num_deltas {
    let var_index = var_index_base.to_int64() + i.to_int64()
    let mapping = match self.delta_set_index_map {
      Some(map) =>
        if var_index >= 0L && var_index.to_int() < map.entries.length() {
          map.entries[var_index.to_int()]
        } else if map.entries.is_empty() {
          { outer_index: 0, inner_index: i }
        } else {
          map.entries[map.entries.length() - 1]
        }
      None => { outer_index: 0, inner_index: var_index.to_int() }
    }
    deltas.push(
      item_store_delta(
        self.regions,
        self.item_data,
        mapping.outer_index,
        mapping.inner_index,
        normalized_coords,
      ),
    )
  }
  deltas
}

///|
fn ColrTable::read_color_line(
  self : ColrTable,
  color_line_offset : Int,
  variable : Bool,
  normalized_coords : Array[Int],
) -> ColrColorLine raise @error.FTError {
  if color_line_offset <= 0 || color_line_offset + 3 > self.data.length() {
    raise @error.FTError::InvalidTable
  }
  let extend = self.data[color_line_offset].to_int()
  if extend < 0 || extend > 2 {
    raise @error.FTError::InvalidTable
  }
  let stop_count = read_u16_at(self.data, color_line_offset + 1).reinterpret_as_int()
  let entry_size = if variable { 10 } else { 6 }
  if color_line_offset + 3 + stop_count * entry_size > self.data.length() {
    raise @error.FTError::InvalidTable
  }
  let stops : Array[ColrColorStop] = Array::new(capacity=stop_count)
  let mut pos = color_line_offset + 3
  for order in 0..<stop_count {
    let mut stop_offset = f2dot14_to_fixed(read_i16_at(self.data, pos))
    let palette_index = read_u16_at(self.data, pos + 2)
    let mut alpha = read_i16_at(self.data, pos + 4)
    pos += 6
    if variable {
      let deltas = self.variation_deltas(
        self.data.unsafe_read_uint32_be(pos),
        2,
        normalized_coords,
      )
      stop_offset = stop_offset + f2dot14_to_fixed(deltas[0].to_int())
      alpha += deltas[1].to_int()
      pos += 4
    }
    stops.push({ stop_offset, palette_index, alpha, order })
  }
  sort_color_stops(stops)
  { extend, stops }
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
      if absolute <= 0 || absolute >= self.data.length() {
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
    if absolute <= 0 || absolute >= self.data.length() {
      raise @error.FTError::InvalidTable
    }
    offsets.push(absolute)
  }
  offsets
}

///|
pub fn ColrTable::clip_box(
  self : ColrTable,
  glyph_id : UInt,
  normalized_coords? : Array[Int] = [],
) -> ColrClipBox? raise @error.FTError {
  if self.version < 1 || self.clip_list_offset == 0 {
    return None
  }
  let clip_base = self.clip_list_offset
  if clip_base + 5 > self.data.length() {
    raise @error.FTError::InvalidTable
  }
  if self.data[clip_base].to_int() != 1 {
    raise @error.FTError::InvalidTable
  }
  let num_clip_boxes = self.data
    .unsafe_read_uint32_be(clip_base + 1)
    .reinterpret_as_int()
  let mut pos = clip_base + 5
  if pos + num_clip_boxes * 7 > self.data.length() {
    raise @error.FTError::InvalidTable
  }
  for _ in 0..<num_clip_boxes {
    let gid_start = read_u16_at(self.data, pos)
    let gid_end = read_u16_at(self.data, pos + 2)
    let box_offset = read_u24_at(self.data, pos + 4)
    pos += 7
    if glyph_id < gid_start || glyph_id > gid_end {
      continue
    }
    let absolute = clip_base + box_offset
    if absolute + 9 > self.data.length() {
      raise @error.FTError::InvalidTable
    }
    let format = self.data[absolute].to_int()
    if format != 1 && format != 2 {
      raise @error.FTError::InvalidTable
    }
    let mut x_min = fword_to_fixed(read_i16_at(self.data, absolute + 1))
    let mut y_min = fword_to_fixed(read_i16_at(self.data, absolute + 3))
    let mut x_max = fword_to_fixed(read_i16_at(self.data, absolute + 5))
    let mut y_max = fword_to_fixed(read_i16_at(self.data, absolute + 7))
    if format == 2 {
      if absolute + 13 > self.data.length() {
        raise @error.FTError::InvalidTable
      }
      let deltas = self.variation_deltas(
        self.data.unsafe_read_uint32_be(absolute + 9),
        4,
        normalized_coords,
      )
      x_min += fword_to_fixed(deltas[0].to_int())
      y_min += fword_to_fixed(deltas[1].to_int())
      x_max += fword_to_fixed(deltas[2].to_int())
      y_max += fword_to_fixed(deltas[3].to_int())
    }
    return Some({ x_min, y_min, x_max, y_max })
  }
  None
}

///|
pub fn ColrTable::read_paint(
  self : ColrTable,
  paint_offset : Int,
  normalized_coords? : Array[Int] = [],
) -> ColrPaint raise @error.FTError {
  if paint_offset <= 0 || paint_offset >= self.data.length() {
    raise @error.FTError::InvalidTable
  }
  let format = self.data[paint_offset].to_int()
  let paint_base = paint_offset
  match format {
    1 =>
      ColrLayers(
        self.data[paint_offset + 1].to_int(),
        self.data.unsafe_read_uint32_be(paint_offset + 2).reinterpret_as_int(),
      )
    2 | 3 => {
      let palette_index = read_u16_at(self.data, paint_offset + 1)
      let mut alpha = read_i16_at(self.data, paint_offset + 3)
      if format == paint_format_var_solid {
        let deltas = self.variation_deltas(
          self.data.unsafe_read_uint32_be(paint_offset + 5),
          1,
          normalized_coords,
        )
        alpha += deltas[0].to_int()
      }
      Solid(palette_index, alpha)
    }
    4 | 5 => {
      let color_line_offset = child_offset(
        self.data,
        paint_base,
        paint_offset + 1,
      )
      let color_line = self.read_color_line(
        color_line_offset,
        format == paint_format_var_linear_gradient,
        normalized_coords,
      )
      let mut p0x = fword_to_fixed(read_i16_at(self.data, paint_offset + 4))
      let mut p0y = fword_to_fixed(read_i16_at(self.data, paint_offset + 6))
      let mut p1x = fword_to_fixed(read_i16_at(self.data, paint_offset + 8))
      let mut p1y = fword_to_fixed(read_i16_at(self.data, paint_offset + 10))
      let mut p2x = fword_to_fixed(read_i16_at(self.data, paint_offset + 12))
      let mut p2y = fword_to_fixed(read_i16_at(self.data, paint_offset + 14))
      if format == paint_format_var_linear_gradient {
        let deltas = self.variation_deltas(
          self.data.unsafe_read_uint32_be(paint_offset + 16),
          6,
          normalized_coords,
        )
        p0x += fword_to_fixed(deltas[0].to_int())
        p0y += fword_to_fixed(deltas[1].to_int())
        p1x += fword_to_fixed(deltas[2].to_int())
        p1y += fword_to_fixed(deltas[3].to_int())
        p2x += fword_to_fixed(deltas[4].to_int())
        p2y += fword_to_fixed(deltas[5].to_int())
      }
      LinearGradient(color_line, p0x, p0y, p1x, p1y, p2x, p2y)
    }
    6 | 7 => {
      let color_line_offset = child_offset(
        self.data,
        paint_base,
        paint_offset + 1,
      )
      let color_line = self.read_color_line(
        color_line_offset,
        format == paint_format_var_radial_gradient,
        normalized_coords,
      )
      let mut c0x = fword_to_fixed(read_i16_at(self.data, paint_offset + 4))
      let mut c0y = fword_to_fixed(read_i16_at(self.data, paint_offset + 6))
      let mut r0 = fword_to_fixed(read_i16_at(self.data, paint_offset + 8))
      let mut c1x = fword_to_fixed(read_i16_at(self.data, paint_offset + 10))
      let mut c1y = fword_to_fixed(read_i16_at(self.data, paint_offset + 12))
      let mut r1 = fword_to_fixed(read_i16_at(self.data, paint_offset + 14))
      if format == paint_format_var_radial_gradient {
        let deltas = self.variation_deltas(
          self.data.unsafe_read_uint32_be(paint_offset + 16),
          6,
          normalized_coords,
        )
        c0x += fword_to_fixed(deltas[0].to_int())
        c0y += fword_to_fixed(deltas[1].to_int())
        r0 += fword_to_fixed(deltas[2].to_int())
        c1x += fword_to_fixed(deltas[3].to_int())
        c1y += fword_to_fixed(deltas[4].to_int())
        r1 += fword_to_fixed(deltas[5].to_int())
      }
      RadialGradient(color_line, c0x, c0y, r0, c1x, c1y, r1)
    }
    8 | 9 => {
      let color_line_offset = child_offset(
        self.data,
        paint_base,
        paint_offset + 1,
      )
      let color_line = self.read_color_line(
        color_line_offset,
        format == paint_format_var_sweep_gradient,
        normalized_coords,
      )
      let mut center_x = fword_to_fixed(
        read_i16_at(self.data, paint_offset + 4),
      )
      let mut center_y = fword_to_fixed(
        read_i16_at(self.data, paint_offset + 6),
      )
      let mut start_angle = f2dot14_to_fixed(
        read_i16_at(self.data, paint_offset + 8),
      )
      let mut end_angle = f2dot14_to_fixed(
        read_i16_at(self.data, paint_offset + 10),
      )
      if format == paint_format_var_sweep_gradient {
        let deltas = self.variation_deltas(
          self.data.unsafe_read_uint32_be(paint_offset + 12),
          4,
          normalized_coords,
        )
        center_x += fword_to_fixed(deltas[0].to_int())
        center_y += fword_to_fixed(deltas[1].to_int())
        start_angle = start_angle + f2dot14_to_fixed(deltas[2].to_int())
        end_angle = end_angle + f2dot14_to_fixed(deltas[3].to_int())
      }
      SweepGradient(color_line, center_x, center_y, start_angle, end_angle)
    }
    10 =>
      Glyph(
        child_offset(self.data, paint_base, paint_offset + 1),
        read_u16_at(self.data, paint_offset + 4),
      )
    11 => ColrGlyph(read_u16_at(self.data, paint_offset + 1))
    12 | 13 => {
      let paint = child_offset(self.data, paint_base, paint_offset + 1)
      let transform_offset = child_offset(
        self.data,
        paint_base,
        paint_offset + 4,
      )
      let mut xx = @fixed.Fixed::from_raw(
        read_i32_at(self.data, transform_offset),
      )
      let mut yx = @fixed.Fixed::from_raw(
        read_i32_at(self.data, transform_offset + 4),
      )
      let mut xy = @fixed.Fixed::from_raw(
        read_i32_at(self.data, transform_offset + 8),
      )
      let mut yy = @fixed.Fixed::from_raw(
        read_i32_at(self.data, transform_offset + 12),
      )
      let mut dx = read_i32_at(self.data, transform_offset + 16)
      let mut dy = read_i32_at(self.data, transform_offset + 20)
      if format == paint_format_var_transform {
        let deltas = self.variation_deltas(
          self.data.unsafe_read_uint32_be(transform_offset + 24),
          6,
          normalized_coords,
        )
        xx = xx + @fixed.Fixed::from_raw(deltas[0])
        yx = yx + @fixed.Fixed::from_raw(deltas[1])
        xy = xy + @fixed.Fixed::from_raw(deltas[2])
        yy = yy + @fixed.Fixed::from_raw(deltas[3])
        dx += deltas[4]
        dy += deltas[5]
      }
      Transform(paint, @fixed.Matrix::new(xx, xy, yx, yy), dx, dy)
    }
    14 | 15 => {
      let child = child_offset(self.data, paint_base, paint_offset + 1)
      let mut dx = fword_to_fixed(read_i16_at(self.data, paint_offset + 4))
      let mut dy = fword_to_fixed(read_i16_at(self.data, paint_offset + 6))
      if format == paint_format_var_translate {
        let deltas = self.variation_deltas(
          self.data.unsafe_read_uint32_be(paint_offset + 8),
          2,
          normalized_coords,
        )
        dx += fword_to_fixed(deltas[0].to_int())
        dy += fword_to_fixed(deltas[1].to_int())
      }
      Translate(child, dx, dy)
    }
    16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 => {
      let child = child_offset(self.data, paint_base, paint_offset + 1)
      let mut pos = paint_offset + 4
      let mut sx = f2dot14_to_fixed(read_i16_at(self.data, pos))
      pos += 2
      let mut sy = if format == paint_format_scale ||
        format == paint_format_var_scale ||
        format == paint_format_scale_center ||
        format == paint_format_var_scale_center {
        let value = f2dot14_to_fixed(read_i16_at(self.data, pos))
        pos += 2
        value
      } else {
        sx
      }
      let mut cx = 0L
      let mut cy = 0L
      if format == paint_format_scale_center ||
        format == paint_format_var_scale_center ||
        format == paint_format_scale_uniform_center ||
        format == paint_format_var_scale_uniform_center {
        cx = fword_to_fixed(read_i16_at(self.data, pos))
        cy = fword_to_fixed(read_i16_at(self.data, pos + 2))
        pos += 4
      }
      if format == paint_format_var_scale ||
        format == paint_format_var_scale_center ||
        format == paint_format_var_scale_uniform ||
        format == paint_format_var_scale_uniform_center {
        let var_index_base = self.data.unsafe_read_uint32_be(pos)
        let deltas = if format == paint_format_var_scale {
          self.variation_deltas(var_index_base, 2, normalized_coords)
        } else if format == paint_format_var_scale_center {
          self.variation_deltas(var_index_base, 4, normalized_coords)
        } else if format == paint_format_var_scale_uniform {
          self.variation_deltas(var_index_base, 1, normalized_coords)
        } else {
          self.variation_deltas(var_index_base, 3, normalized_coords)
        }
        sx = sx + f2dot14_to_fixed(deltas[0].to_int())
        sy = if format == paint_format_var_scale_uniform ||
          format == paint_format_var_scale_uniform_center {
          sy + f2dot14_to_fixed(deltas[0].to_int())
        } else {
          sy + f2dot14_to_fixed(deltas[1].to_int())
        }
        if format == paint_format_var_scale_center {
          cx += fword_to_fixed(deltas[2].to_int())
          cy += fword_to_fixed(deltas[3].to_int())
        } else if format == paint_format_var_scale_uniform_center {
          cx += fword_to_fixed(deltas[1].to_int())
          cy += fword_to_fixed(deltas[2].to_int())
        }
      }
      Scale(child, sx, sy, cx, cy)
    }
    24 | 25 | 26 | 27 => {
      let child = child_offset(self.data, paint_base, paint_offset + 1)
      let mut pos = paint_offset + 4
      let mut angle = f2dot14_to_fixed(read_i16_at(self.data, pos))
      pos += 2
      let mut cx = 0L
      let mut cy = 0L
      if format == paint_format_rotate_center ||
        format == paint_format_var_rotate_center {
        cx = fword_to_fixed(read_i16_at(self.data, pos))
        cy = fword_to_fixed(read_i16_at(self.data, pos + 2))
        pos += 4
      }
      if format == paint_format_var_rotate ||
        format == paint_format_var_rotate_center {
        let deltas = self.variation_deltas(
          self.data.unsafe_read_uint32_be(pos),
          if format == paint_format_var_rotate_center {
            3
          } else {
            1
          },
          normalized_coords,
        )
        angle = angle + f2dot14_to_fixed(deltas[0].to_int())
        if format == paint_format_var_rotate_center {
          cx += fword_to_fixed(deltas[1].to_int())
          cy += fword_to_fixed(deltas[2].to_int())
        }
      }
      Rotate(child, angle, cx, cy)
    }
    28 | 29 | 30 | 31 => {
      let child = child_offset(self.data, paint_base, paint_offset + 1)
      let mut pos = paint_offset + 4
      let mut x_angle = f2dot14_to_fixed(read_i16_at(self.data, pos))
      let mut y_angle = f2dot14_to_fixed(read_i16_at(self.data, pos + 2))
      pos += 4
      let mut cx = 0L
      let mut cy = 0L
      if format == paint_format_skew_center ||
        format == paint_format_var_skew_center {
        cx = fword_to_fixed(read_i16_at(self.data, pos))
        cy = fword_to_fixed(read_i16_at(self.data, pos + 2))
        pos += 4
      }
      if format == paint_format_var_skew ||
        format == paint_format_var_skew_center {
        let deltas = self.variation_deltas(
          self.data.unsafe_read_uint32_be(pos),
          if format == paint_format_var_skew_center {
            4
          } else {
            2
          },
          normalized_coords,
        )
        x_angle = x_angle + f2dot14_to_fixed(deltas[0].to_int())
        y_angle = y_angle + f2dot14_to_fixed(deltas[1].to_int())
        if format == paint_format_var_skew_center {
          cx += fword_to_fixed(deltas[2].to_int())
          cy += fword_to_fixed(deltas[3].to_int())
        }
      }
      Skew(child, x_angle, y_angle, cx, cy)
    }
    32 =>
      Composite(
        child_offset(self.data, paint_base, paint_offset + 1),
        self.data[paint_offset + 4].to_int(),
        child_offset(self.data, paint_base, paint_offset + 5),
      )
    _ => Unsupported(format)
  }
}
