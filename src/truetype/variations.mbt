///|
/// Font variation support: fvar, gvar, avar tables.
/// Enables variable fonts (OpenType 1.8+).

///|
/// A variation axis definition from the fvar table.
struct VarAxis {
  tag : UInt // 4-byte tag (e.g., 'wght', 'wdth')
  min_value : @fixed.Fixed // minimum value (16.16)
  default_value : @fixed.Fixed // default value
  max_value : @fixed.Fixed // maximum value
  name_id : UInt // name table ID for axis name
} derive(Show)

///|
/// A named instance (preset axis coordinates).
struct NamedInstance {
  name_id : UInt
  coordinates : Array[@fixed.Fixed] // one value per axis
} derive(Show)

///|
/// Parsed fvar table.
struct FvarTable {
  axes : Array[VarAxis]
  instances : Array[NamedInstance]
} derive(Show)

///|
/// Parse the fvar (Font Variations) table.
pub fn parse_fvar(
  reader : @stream.ByteReader,
  offset : UInt,
  length : UInt,
) -> FvarTable raise @error.FTError {
  if length.reinterpret_as_int() < 16 {
    raise @error.FTError::InvalidTable
  }
  reader.seek(offset.reinterpret_as_int())
  reader.enter_frame(16)
  let _major = reader.get_u16_be()
  let _minor = reader.get_u16_be()
  let axes_offset = reader.get_u16_be()
  let _reserved = reader.get_u16_be()
  let axis_count = reader.get_u16_be().reinterpret_as_int()
  let axis_size = reader.get_u16_be().reinterpret_as_int()
  let instance_count = reader.get_u16_be().reinterpret_as_int()
  let instance_size = reader.get_u16_be().reinterpret_as_int()
  reader.exit_frame()
  // Parse axes
  reader.seek(offset.reinterpret_as_int() + axes_offset.reinterpret_as_int())
  let axes : Array[VarAxis] = []
  for _ in 0..<axis_count {
    let tag = reader.read_u32_be()
    let min_value = @fixed.Fixed::from_raw(reader.read_i32_be().to_int64())
    let default_value = @fixed.Fixed::from_raw(reader.read_i32_be().to_int64())
    let max_value = @fixed.Fixed::from_raw(reader.read_i32_be().to_int64())
    let _flags = reader.read_u16_be()
    let name_id = reader.read_u16_be()
    axes.push({ tag, min_value, default_value, max_value, name_id })
    // Skip any extra bytes in axis record
    let extra = axis_size - 20
    if extra > 0 {
      reader.skip(extra)
    }
  }
  // Parse named instances
  let instances : Array[NamedInstance] = []
  for _ in 0..<instance_count {
    let name_id = reader.read_u16_be()
    let _flags = reader.read_u16_be()
    let coordinates : Array[@fixed.Fixed] = []
    for _ in 0..<axis_count {
      coordinates.push(@fixed.Fixed::from_raw(reader.read_i32_be().to_int64()))
    }
    instances.push({ name_id, coordinates })
    // Skip any extra bytes
    let extra = instance_size - 4 - axis_count * 4
    if extra > 0 {
      reader.skip(extra)
    }
  }
  { axes, instances }
}

///|
/// Avar segment map entry (piecewise linear mapping).
struct AvarSegment {
  from_coord : Int // normalized input (-1..1 as F2Dot14)
  to_coord : Int // normalized output
} derive(Show)

///|
/// Parsed avar table: per-axis normalization remapping.
struct AvarTable {
  axis_maps : Array[Array[AvarSegment]] // one segment map per axis
} derive(Show)

///|
/// Parse the avar (Axis Variations) table.
pub fn parse_avar(
  reader : @stream.ByteReader,
  offset : UInt,
  length : UInt,
  axis_count : Int,
) -> AvarTable raise @error.FTError {
  if length.reinterpret_as_int() < 8 {
    raise @error.FTError::InvalidTable
  }
  reader.seek(offset.reinterpret_as_int())
  let _major = reader.read_u16_be()
  let _minor = reader.read_u16_be()
  let _reserved = reader.read_u16_be()
  let map_count = reader.read_u16_be().reinterpret_as_int()
  let count = if map_count < axis_count { map_count } else { axis_count }
  let axis_maps : Array[Array[AvarSegment]] = []
  for _ in 0..<count {
    let pair_count = reader.read_u16_be().reinterpret_as_int()
    let segments : Array[AvarSegment] = []
    for _ in 0..<pair_count {
      let from_coord = reader.read_i16_be()
      let to_coord = reader.read_i16_be()
      segments.push({ from_coord, to_coord })
    }
    axis_maps.push(segments)
  }
  { axis_maps, }
}

///|
/// Normalize an axis value to [-1, 1] range (as Fixed 2.14).
pub fn normalize_axis(value : @fixed.Fixed, axis : VarAxis) -> Int {
  let v = value.val()
  let def = axis.default_value.val()
  if v == def {
    return 0
  }
  if v < def {
    let min = axis.min_value.val()
    if min >= def {
      return 0
    }
    // Map [min, default] to [-1, 0]
    let result = -((def - v) * 0x4000L / (def - min))
    // Clamp to -1.0 (= -0x4000 in 2.14)
    if result < -0x4000L {
      -0x4000
    } else {
      result.to_int()
    }
  } else {
    let max = axis.max_value.val()
    if max <= def {
      return 0
    }
    // Map [default, max] to [0, 1]
    let result = (v - def) * 0x4000L / (max - def)
    if result > 0x4000L {
      0x4000
    } else {
      result.to_int()
    }
  }
}

///|
/// Apply avar remapping to a normalized coordinate.
pub fn apply_avar(coord : Int, segments : Array[AvarSegment]) -> Int {
  if segments.length() < 2 {
    return coord
  }
  // Find bracketing segment pair
  for i in 0..<(segments.length() - 1) {
    let s1 = segments[i]
    let s2 = segments[i + 1]
    if coord >= s1.from_coord && coord <= s2.from_coord {
      let range_in = s2.from_coord - s1.from_coord
      if range_in == 0 {
        return s1.to_coord
      }
      let range_out = s2.to_coord - s1.to_coord
      return s1.to_coord + (coord - s1.from_coord) * range_out / range_in
    }
  }
  // Outside range: clamp
  if coord <= segments[0].from_coord {
    segments[0].to_coord
  } else {
    segments[segments.length() - 1].to_coord
  }
}

///|
/// Normalize design coordinates for all axes, applying avar if present.
pub fn normalize_coordinates(
  axes : Array[VarAxis],
  design_coords : Array[@fixed.Fixed],
  avar : AvarTable?,
) -> Array[Int] {
  let normalized : Array[Int] = []
  for i, axis in axes {
    let coord = if i < design_coords.length() {
      design_coords[i]
    } else {
      axis.default_value
    }
    let mut norm = normalize_axis(coord, axis)
    // Apply avar remapping if available
    if avar is Some(a) && i < a.axis_maps.length() {
      norm = apply_avar(norm, a.axis_maps[i])
    }
    normalized.push(norm)
  }
  normalized
}

///|
pub fn FvarTable::axes(self : FvarTable) -> Array[VarAxis] {
  self.axes
}

///|
pub fn FvarTable::instances(self : FvarTable) -> Array[NamedInstance] {
  self.instances
}

///|
pub fn VarAxis::tag(self : VarAxis) -> UInt {
  self.tag
}

///|
pub fn VarAxis::min_value(self : VarAxis) -> @fixed.Fixed {
  self.min_value
}

///|
pub fn VarAxis::default_value(self : VarAxis) -> @fixed.Fixed {
  self.default_value
}

///|
pub fn VarAxis::max_value(self : VarAxis) -> @fixed.Fixed {
  self.max_value
}

///|
pub fn VarAxis::name_id(self : VarAxis) -> UInt {
  self.name_id
}
