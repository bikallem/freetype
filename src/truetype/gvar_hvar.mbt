///|
/// Glyph variation table header and shared tuple directory.
pub struct GvarTable {
  table_offset : UInt
  data_offset : UInt
  axis_count : Int
  shared_tuples : Array[Array[Int]]
  glyph_offsets : Array[UInt]
} derive(Show)

///|
struct GvarTupleData {
  peak_coords : Array[Int]
  start_coords : Array[Int]
  end_coords : Array[Int]
  point_numbers : Array[Int]
  all_points : Bool
  x_deltas : Array[Int]
  y_deltas : Array[Int]
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
pub struct HvarTable {
  regions : Array[Array[RegionAxisCoordinates]]
  item_data : Array[ItemVariationData?]
  advance_width_map : DeltaSetIndexMap?
} derive(Show)

///|
pub fn GvarTable::axis_count(self : GvarTable) -> Int {
  self.axis_count
}

///|
pub fn parse_gvar(
  reader : @stream.ByteReader,
  offset : UInt,
  length : UInt,
  glyph_count : UInt,
) -> GvarTable raise @error.FTError {
  if length.reinterpret_as_int() < 20 {
    raise @error.FTError::InvalidTable
  }
  reader.seek(offset.reinterpret_as_int())
  let major = reader.read_u16_be()
  let minor = reader.read_u16_be()
  if major != 1U || (minor != 0U && minor != 1U) {
    raise @error.FTError::InvalidTable
  }
  let axis_count = reader.read_u16_be().reinterpret_as_int()
  let shared_tuple_count = reader.read_u16_be().reinterpret_as_int()
  let shared_tuples_offset = reader.read_u32_be()
  let glyph_count_in_table = reader.read_u16_be()
  if glyph_count_in_table != glyph_count {
    raise @error.FTError::InvalidTable
  }
  let flags = reader.read_u16_be()
  let data_offset = reader.read_u32_be()
  let long_offsets = (flags & 1U) != 0U
  let glyph_offsets : Array[UInt] = Array::new(
    capacity=glyph_count.reinterpret_as_int() + 1,
  )
  for _ in 0..<=glyph_count.reinterpret_as_int() {
    if long_offsets {
      glyph_offsets.push(reader.read_u32_be())
    } else {
      glyph_offsets.push(reader.read_u16_be() << 1)
    }
  }
  let shared_tuples : Array[Array[Int]] = Array::new(
    capacity=shared_tuple_count,
  )
  let shared_tuple_base = offset + shared_tuples_offset
  reader.seek(shared_tuple_base.reinterpret_as_int())
  for _ in 0..<shared_tuple_count {
    let tuple : Array[Int] = Array::new(capacity=axis_count)
    for _ in 0..<axis_count {
      tuple.push(reader.read_i16_be())
    }
    shared_tuples.push(tuple)
  }
  {
    table_offset: offset,
    data_offset,
    axis_count,
    shared_tuples,
    glyph_offsets,
  }
}

///|
pub fn parse_hvar(
  reader : @stream.ByteReader,
  offset : UInt,
  length : UInt,
) -> HvarTable raise @error.FTError {
  if length.reinterpret_as_int() < 20 {
    raise @error.FTError::InvalidTable
  }
  reader.seek(offset.reinterpret_as_int())
  let major = reader.read_u16_be()
  let minor = reader.read_u16_be()
  if major != 1U || minor != 0U {
    raise @error.FTError::InvalidTable
  }
  let item_store_offset = reader.read_u32_be()
  let advance_width_map_offset = reader.read_u32_be()
  let _lsb_map_offset = reader.read_u32_be()
  let _rsb_map_offset = reader.read_u32_be()
  let (regions, item_data) = parse_item_variation_store(
    reader,
    offset + item_store_offset,
  )
  let advance_width_map : DeltaSetIndexMap? = if advance_width_map_offset != 0U {
    Some(parse_delta_set_index_map(reader, offset + advance_width_map_offset))
  } else {
    None
  }
  { regions, item_data, advance_width_map }
}

///|
pub fn HvarTable::advance_width_delta(
  self : HvarTable,
  glyph_index : UInt,
  normalized_coords : Array[Int],
) -> Int64 {
  let mapping = match self.advance_width_map {
    Some(m) =>
      if glyph_index.reinterpret_as_int() < m.entries.length() {
        m.entries[glyph_index.reinterpret_as_int()]
      } else {
        { outer_index: 0, inner_index: glyph_index.reinterpret_as_int() }
      }
    None => { outer_index: 0, inner_index: glyph_index.reinterpret_as_int() }
  }
  self.delta_from_mapping(mapping, normalized_coords)
}

///|
fn HvarTable::delta_from_mapping(
  self : HvarTable,
  mapping : DeltaSetIndexMapEntry,
  normalized_coords : Array[Int],
) -> Int64 {
  if mapping.outer_index < 0 || mapping.outer_index >= self.item_data.length() {
    return 0L
  }
  let subtable = match self.item_data[mapping.outer_index] {
    Some(v) => v
    None => return 0L
  }
  if mapping.inner_index < 0 ||
    mapping.inner_index >= subtable.delta_sets.length() {
    return 0L
  }
  let deltas = subtable.delta_sets[mapping.inner_index]
  let mut total = 0L
  for i, delta in deltas {
    if i >= subtable.region_indexes.length() {
      break
    }
    let region_index = subtable.region_indexes[i]
    if region_index < 0 || region_index >= self.regions.length() {
      continue
    }
    let scalar = region_scalar(self.regions[region_index], normalized_coords)
    if scalar.val() != 0L {
      total += scale_delta(delta, scalar)
    }
  }
  total
}

///|
fn read_u16_be_from_bytes(data : Bytes, pos : Int) -> UInt {
  (data[pos].to_uint() << 8) | data[pos + 1].to_uint()
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
  offset : UInt,
) -> DeltaSetIndexMap raise @error.FTError {
  reader.seek(offset.reinterpret_as_int())
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
fn parse_item_variation_store(
  reader : @stream.ByteReader,
  offset : UInt,
) -> (Array[Array[RegionAxisCoordinates]], Array[ItemVariationData?]) raise @error.FTError {
  reader.seek(offset.reinterpret_as_int())
  let format = reader.read_u16_be()
  if format != 1U {
    raise @error.FTError::InvalidTable
  }
  let region_list_offset = reader.read_u32_be()
  let item_data_count = reader.read_u16_be().reinterpret_as_int()
  let item_data_offsets : Array[UInt] = Array::new(capacity=item_data_count)
  for _ in 0..<item_data_count {
    item_data_offsets.push(reader.read_u32_be())
  }
  let regions = parse_variation_region_list(reader, offset + region_list_offset)
  let item_data : Array[ItemVariationData?] = Array::new(
    capacity=item_data_count,
  )
  for _, data_offset in item_data_offsets {
    if data_offset == 0U {
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
fn parse_variation_region_list(
  reader : @stream.ByteReader,
  offset : UInt,
) -> Array[Array[RegionAxisCoordinates]] raise @error.FTError {
  reader.seek(offset.reinterpret_as_int())
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
  offset : UInt,
) -> ItemVariationData raise @error.FTError {
  reader.seek(offset.reinterpret_as_int())
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
fn implicit_region_start(peak_coord : Int) -> Int {
  if peak_coord < 0 {
    peak_coord
  } else {
    0
  }
}

///|
fn implicit_region_end(peak_coord : Int) -> Int {
  if peak_coord > 0 {
    peak_coord
  } else {
    0
  }
}

///|
fn tuple_scalar(
  tuple : GvarTupleData,
  normalized_coords : Array[Int],
) -> @fixed.Fixed {
  let mut scalar = @fixed.Fixed::one()
  for i, peak_coord in tuple.peak_coords {
    let coord = if i < normalized_coords.length() {
      normalized_coords[i]
    } else {
      0
    }
    scalar = @fixed.mul_fix(
      scalar,
      point_delta_scalar(
        coord,
        tuple.start_coords[i],
        peak_coord,
        tuple.end_coords[i],
      ),
    )
    if scalar.val() == 0L {
      break
    }
  }
  scalar
}

///|
fn parse_packed_point_numbers(
  data : Bytes,
  start : Int,
  point_count : Int,
) -> (Array[Int], Bool, Int) raise @error.FTError {
  if start >= data.length() {
    raise @error.FTError::InvalidTable
  }
  let mut pos = start
  let mut count = data[pos].to_int()
  pos += 1
  if count == 0 {
    return ([], true, pos)
  }
  if (count & 0x80) != 0 {
    if pos >= data.length() {
      raise @error.FTError::InvalidTable
    }
    count = ((count & 0x7F) << 8) | data[pos].to_int()
    pos += 1
  }
  let points : Array[Int] = Array::new(capacity=count)
  let mut current = 0
  while points.length() < count {
    if pos >= data.length() {
      raise @error.FTError::InvalidTable
    }
    let control = data[pos].to_int()
    pos += 1
    let run_count = (control & 0x7F) + 1
    if (control & 0x80) != 0 {
      for _ in 0..<run_count {
        if pos + 1 >= data.length() {
          raise @error.FTError::InvalidTable
        }
        current += read_u16_be_from_bytes(data, pos).reinterpret_as_int()
        pos += 2
        if current >= point_count {
          raise @error.FTError::InvalidTable
        }
        points.push(current)
      }
    } else {
      for _ in 0..<run_count {
        if pos >= data.length() {
          raise @error.FTError::InvalidTable
        }
        current += data[pos].to_int()
        pos += 1
        if current >= point_count {
          raise @error.FTError::InvalidTable
        }
        points.push(current)
      }
    }
  }
  (points, false, pos)
}

///|
fn parse_packed_deltas(
  data : Bytes,
  start : Int,
  count : Int,
) -> (Array[Int], Int) raise @error.FTError {
  let deltas : Array[Int] = Array::new(capacity=count)
  let mut pos = start
  while deltas.length() < count {
    if pos >= data.length() {
      raise @error.FTError::InvalidTable
    }
    let control = data[pos].to_int()
    pos += 1
    let run_count = (control & 0x3F) + 1
    if (control & 0x80) != 0 {
      for _ in 0..<run_count {
        deltas.push(0)
      }
    } else if (control & 0x40) != 0 {
      for _ in 0..<run_count {
        if pos + 1 >= data.length() {
          raise @error.FTError::InvalidTable
        }
        deltas.push(read_i16(data, pos))
        pos += 2
      }
    } else {
      for _ in 0..<run_count {
        if pos >= data.length() {
          raise @error.FTError::InvalidTable
        }
        let value = data[pos].to_int()
        pos += 1
        deltas.push(if value >= 128 { value - 256 } else { value })
      }
    }
  }
  (deltas, pos)
}

///|
fn parse_gvar_glyph_tuples(
  gvar : GvarTable,
  data : Bytes,
  glyph_index : UInt,
  point_count : Int,
) -> Array[GvarTupleData] raise @error.FTError {
  let idx = glyph_index.reinterpret_as_int()
  if idx < 0 || idx >= gvar.glyph_offsets.length() - 1 {
    return []
  }
  let glyph_data_start = (gvar.table_offset +
  gvar.data_offset +
  gvar.glyph_offsets[idx]).reinterpret_as_int()
  let glyph_data_end = (gvar.table_offset +
  gvar.data_offset +
  gvar.glyph_offsets[idx + 1]).reinterpret_as_int()
  if glyph_data_start >= glyph_data_end {
    return []
  }
  let tuple_count_raw = read_u16_be_from_bytes(data, glyph_data_start)
  let tuple_count = (tuple_count_raw & 0x0FFFU).reinterpret_as_int()
  let has_shared_points = (tuple_count_raw & 0x8000U) != 0U
  let tuple_data_offset = read_u16_be_from_bytes(data, glyph_data_start + 2)
  let mut header_pos = glyph_data_start + 4
  let serialized_start = glyph_data_start +
    tuple_data_offset.reinterpret_as_int()
  let mut data_pos = serialized_start
  let (shared_points, shared_all_points, shared_end) = if has_shared_points {
    parse_packed_point_numbers(data, data_pos, point_count)
  } else {
    ([], false, data_pos)
  }
  data_pos = shared_end
  let tuple_headers : Array[(Int, Array[Int], Array[Int], Array[Int], Bool)] = []
  for _ in 0..<tuple_count {
    if header_pos + 3 >= glyph_data_end {
      raise @error.FTError::InvalidTable
    }
    let variation_data_size = read_u16_be_from_bytes(data, header_pos)
    let tuple_index = read_u16_be_from_bytes(data, header_pos + 2)
    header_pos += 4
    let has_embedded_peak = (tuple_index & 0x8000U) != 0U
    let has_intermediate = (tuple_index & 0x4000U) != 0U
    let has_private_points = (tuple_index & 0x2000U) != 0U
    let shared_tuple_index = (tuple_index & 0x0FFFU).reinterpret_as_int()
    let peak_coords : Array[Int] = Array::new(capacity=gvar.axis_count)
    if has_embedded_peak {
      for _ in 0..<gvar.axis_count {
        peak_coords.push(read_i16(data, header_pos))
        header_pos += 2
      }
    } else if shared_tuple_index < gvar.shared_tuples.length() {
      for _, coord in gvar.shared_tuples[shared_tuple_index] {
        peak_coords.push(coord)
      }
    } else {
      raise @error.FTError::InvalidTable
    }
    let start_coords : Array[Int] = Array::new(capacity=gvar.axis_count)
    let end_coords : Array[Int] = Array::new(capacity=gvar.axis_count)
    if has_intermediate {
      for _ in 0..<gvar.axis_count {
        start_coords.push(read_i16(data, header_pos))
        header_pos += 2
      }
      for _ in 0..<gvar.axis_count {
        end_coords.push(read_i16(data, header_pos))
        header_pos += 2
      }
    } else {
      for _, peak_coord in peak_coords {
        start_coords.push(implicit_region_start(peak_coord))
        end_coords.push(implicit_region_end(peak_coord))
      }
    }
    tuple_headers.push(
      (
        variation_data_size.reinterpret_as_int(),
        peak_coords,
        start_coords,
        end_coords,
        has_private_points,
      ),
    )
  }
  let tuples : Array[GvarTupleData] = Array::new(capacity=tuple_count)
  for _, tuple_header in tuple_headers {
    let (
      variation_data_size,
      peak_coords,
      start_coords,
      end_coords,
      has_private_points,
    ) = tuple_header
    let tuple_data_end = data_pos + variation_data_size
    let (point_numbers, all_points, delta_pos) = if has_private_points {
      parse_packed_point_numbers(data, data_pos, point_count)
    } else {
      (shared_points, shared_all_points, data_pos)
    }
    let delta_count = if all_points {
      point_count
    } else {
      point_numbers.length()
    }
    let (x_deltas, y_pos) = parse_packed_deltas(data, delta_pos, delta_count)
    let (y_deltas, parsed_end) = parse_packed_deltas(data, y_pos, delta_count)
    if parsed_end > tuple_data_end {
      raise @error.FTError::InvalidTable
    }
    data_pos = tuple_data_end
    tuples.push({
      peak_coords,
      start_coords,
      end_coords,
      point_numbers,
      all_points,
      x_deltas,
      y_deltas,
    })
  }
  tuples
}

///|
fn infer_delta_for_coordinate(
  target_coord : Int64,
  prev_coord : Int64,
  prev_delta : Int,
  next_coord : Int64,
  next_delta : Int,
) -> Int {
  if prev_coord == next_coord {
    if prev_delta == next_delta {
      return prev_delta
    }
    return 0
  }
  let min_coord = if prev_coord < next_coord { prev_coord } else { next_coord }
  let max_coord = if prev_coord > next_coord { prev_coord } else { next_coord }
  if target_coord <= min_coord {
    if prev_coord < next_coord {
      prev_delta
    } else {
      next_delta
    }
  } else if target_coord >= max_coord {
    if prev_coord > next_coord {
      prev_delta
    } else {
      next_delta
    }
  } else {
    let delta_span = (next_delta - prev_delta).to_int64()
    (prev_delta.to_int64() +
    @fixed.mul_div(
      target_coord - prev_coord,
      delta_span,
      next_coord - prev_coord,
    )).to_int()
  }
}

///|
fn infer_simple_tuple_deltas(
  outline : @types.Outline,
  delta_x : Array[Int],
  delta_y : Array[Int],
  referenced : FixedArray[Byte],
) -> Unit {
  let points = outline.points()
  let mut contour_start = 0
  for _, contour_end_u in outline.contours() {
    let contour_end = contour_end_u.reinterpret_as_int()
    let contour_refs : Array[Int] = []
    for i in contour_start..<=contour_end {
      if referenced[i] != b'\x00' {
        contour_refs.push(i)
      }
    }
    if contour_refs.length() > 0 &&
      contour_refs.length() < contour_end - contour_start + 1 {
      for i in contour_start..<=contour_end {
        if referenced[i] != b'\x00' {
          continue
        }
        let mut prev = contour_refs[contour_refs.length() - 1]
        let mut next = contour_refs[0]
        for _, ref_idx in contour_refs {
          if ref_idx < i {
            prev = ref_idx
          } else {
            next = ref_idx
            break
          }
        }
        delta_x[i] = infer_delta_for_coordinate(
          points[i].x(),
          points[prev].x(),
          delta_x[prev],
          points[next].x(),
          delta_x[next],
        )
        delta_y[i] = infer_delta_for_coordinate(
          points[i].y(),
          points[prev].y(),
          delta_y[prev],
          points[next].y(),
          delta_y[next],
        )
      }
    }
    contour_start = contour_end + 1
  }
}

///|
fn is_default_variation_coords(normalized_coords : Array[Int]) -> Bool {
  for _, coord in normalized_coords {
    if coord != 0 {
      return false
    }
  }
  true
}

///|
fn accumulate_tuple_deltas(
  tuple : GvarTupleData,
  scalar : @fixed.Fixed,
  point_count : Int,
  outline : @types.Outline,
  component_count : Int,
  net_x : Array[Int64],
  net_y : Array[Int64],
) -> Unit {
  let tuple_x : Array[Int] = Array::make(point_count, 0)
  let tuple_y : Array[Int] = Array::make(point_count, 0)
  let referenced = FixedArray::make(point_count, b'\x00')
  if tuple.all_points {
    for i in 0..<point_count {
      tuple_x[i] = tuple.x_deltas[i]
      tuple_y[i] = tuple.y_deltas[i]
      referenced.unsafe_set(i, b'\x01')
    }
  } else {
    for i, point_index in tuple.point_numbers {
      if point_index < 0 || point_index >= point_count {
        continue
      }
      if i < tuple.x_deltas.length() {
        tuple_x[point_index] = tuple.x_deltas[i]
      }
      if i < tuple.y_deltas.length() {
        tuple_y[point_index] = tuple.y_deltas[i]
      }
      referenced.unsafe_set(point_index, b'\x01')
    }
  }
  if component_count == 0 && outline.n_points() > 0 && !tuple.all_points {
    infer_simple_tuple_deltas(outline, tuple_x, tuple_y, referenced)
  }
  for i in 0..<point_count {
    if tuple_x[i] != 0 {
      net_x[i] += scale_delta(tuple_x[i], scalar)
    }
    if tuple_y[i] != 0 {
      net_y[i] += scale_delta(tuple_y[i], scalar)
    }
  }
}

///|
fn compute_gvar_deltas(
  gvar : GvarTable,
  data : Bytes,
  glyph_index : UInt,
  normalized_coords : Array[Int],
  point_count : Int,
  outline : @types.Outline,
  component_count : Int,
) -> (Array[Int64], Array[Int64]) raise @error.FTError {
  let net_x : Array[Int64] = Array::make(point_count, 0L)
  let net_y : Array[Int64] = Array::make(point_count, 0L)
  if point_count == 0 || is_default_variation_coords(normalized_coords) {
    return (net_x, net_y)
  }
  let tuples = parse_gvar_glyph_tuples(gvar, data, glyph_index, point_count)
  for _, tuple in tuples {
    let scalar = tuple_scalar(tuple, normalized_coords)
    if scalar.val() == 0L {
      continue
    }
    accumulate_tuple_deltas(
      tuple, scalar, point_count, outline, component_count, net_x, net_y,
    )
  }
  (net_x, net_y)
}
