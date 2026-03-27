///|
/// Parse a CFF INDEX structure.
pub fn parse_cff_index(
  reader : @stream.ByteReader,
) -> CffIndex raise @error.FTError {
  let count = reader.read_u16_be()
  if count == 0U {
    return {
      count: 0U,
      off_size: 0,
      offsets: [],
      data_start: reader.position(),
      data: b"",
    }
  }
  let off_size = reader.read_byte().to_int()
  // Read count+1 offsets
  let offsets : Array[UInt] = []
  for _ in 0..<(count.reinterpret_as_int() + 1) {
    let off = match off_size {
      1 => reader.read_byte().to_uint()
      2 => reader.read_u16_be()
      3 => reader.read_u24_be()
      4 => reader.read_u32_be()
      _ => raise @error.FTError::InvalidTable
    }
    offsets.push(off)
  }
  // Data starts right after offsets; CFF offsets are 1-based
  let data_start = reader.position()
  // Read all data
  let last_offset = offsets[offsets.length() - 1]
  let data_size = last_offset.reinterpret_as_int() - 1 // offsets are 1-based
  let data = if data_size > 0 { reader.read_bytes(data_size) } else { b"" }
  { count, off_size, offsets, data_start, data }
}

///|
/// Parse a CFF2 INDEX structure (32-bit count).
pub fn parse_cff2_index(
  reader : @stream.ByteReader,
) -> CffIndex raise @error.FTError {
  let count = reader.read_u32_be()
  if count == 0U {
    return {
      count: 0U,
      off_size: 0,
      offsets: [],
      data_start: reader.position(),
      data: b"",
    }
  }
  let off_size = reader.read_byte().to_int()
  let offsets : Array[UInt] = []
  for _ in 0..<(count.reinterpret_as_int() + 1) {
    let off = match off_size {
      1 => reader.read_byte().to_uint()
      2 => reader.read_u16_be()
      3 => reader.read_u24_be()
      4 => reader.read_u32_be()
      _ => raise @error.FTError::InvalidTable
    }
    offsets.push(off)
  }
  let data_start = reader.position()
  let last_offset = offsets[offsets.length() - 1]
  let data_size = last_offset.reinterpret_as_int() - 1
  let data = if data_size > 0 { reader.read_bytes(data_size) } else { b"" }
  { count, off_size, offsets, data_start, data }
}

///|
/// Get data for an item in a CFF INDEX.
pub fn CffIndex::get_item(self : CffIndex, index : Int) -> Bytes {
  if index < 0 || index >= self.count.reinterpret_as_int() {
    return b""
  }
  let start = self.offsets[index].reinterpret_as_int() - 1 // 1-based
  let end_ = self.offsets[index + 1].reinterpret_as_int() - 1
  if start < 0 || end_ > self.data.length() || start >= end_ {
    return b""
  }
  self.data[start:end_].to_bytes()
}

///|
/// Parse a CFF DICT operand (number) from the byte stream.
/// Returns (value, bytes consumed).
fn parse_dict_real_operand(data : Bytes, pos : Int) -> (Double, Int) {
  let buf = StringBuilder::new()
  let mut p = pos + 1
  let mut done = false
  while p < data.length() && !done {
    let nibble_byte = data[p].to_int()
    for nibble in [nibble_byte >> 4, nibble_byte & 0x0F] {
      match nibble {
        0x0F => {
          done = true
          break
        }
        0x0A => buf.write_char('.')
        0x0B => buf.write_char('E')
        0x0C => {
          buf.write_char('E')
          buf.write_char('-')
        }
        0x0E => buf.write_char('-')
        digit if digit >= 0 && digit <= 9 =>
          buf.write_char((digit + '0'.to_int()).unsafe_to_char())
        _ => ()
      }
    }
    p += 1
  }
  let text = buf.to_string()
  let value = if text == "" ||
    text == "-" ||
    text == "." ||
    text == "E" ||
    text == "E-" {
    0.0
  } else {
    @string.parse_double(text) catch {
      _ => 0.0
    }
  }
  (value, p - pos)
}

///|
/// Parse a CFF DICT operand (number) from the byte stream.
/// Returns (value, bytes consumed).
fn parse_dict_operand(data : Bytes, pos : Int) -> (Double, Int) {
  let b0 = data[pos].to_int()
  if b0 >= 32 && b0 <= 246 {
    ((b0 - 139).to_double(), 1)
  } else if b0 >= 247 && b0 <= 250 {
    let b1 = data[pos + 1].to_int()
    (((b0 - 247) * 256 + b1 + 108).to_double(), 2)
  } else if b0 >= 251 && b0 <= 254 {
    let b1 = data[pos + 1].to_int()
    ((-((b0 - 251) * 256 + b1 + 108)).to_double(), 2)
  } else if b0 == 28 {
    let hi = data[pos + 1].to_int()
    let lo = data[pos + 2].to_int()
    let val = (hi << 8) | lo
    let signed_val = if val >= 0x8000 { val - 0x10000 } else { val }
    (signed_val.to_double(), 3)
  } else if b0 == 29 {
    let val = (data[pos + 1].to_int() << 24) |
      (data[pos + 2].to_int() << 16) |
      (data[pos + 3].to_int() << 8) |
      data[pos + 4].to_int()
    (val.to_double(), 5)
  } else if b0 == 30 {
    parse_dict_real_operand(data, pos)
  } else {
    (0.0, 1)
  }
}

///|
fn is_cff2_top_dict_op(b0 : Int) -> Bool {
  (b0 >= 0 && b0 <= 21) || b0 == 24 || b0 == 25
}

///|
fn cff2_blend_vector_length(vstore : CffVarStore?, vsindex : Int) -> Int {
  match vstore {
    Some(store) =>
      if vsindex >= 0 && vsindex < store.data.length() {
        match store.data[vsindex] {
          Some(data) => data.region_indices.length() + 1
          None => 1
        }
      } else {
        1
      }
    None => 1
  }
}

///|
fn collapse_cff2_blend_stack(stack : Array[Double], len_bv : Int) -> Unit {
  if stack.length() == 0 || len_bv <= 0 {
    stack.clear()
    return
  }
  let num_blends = stack[stack.length() - 1].to_int()
  if num_blends <= 0 {
    stack.clear()
    return
  }
  let num_operands = num_blends * len_bv
  if stack.length() < num_operands + 1 {
    stack.clear()
    return
  }
  let base_count = stack.length() - 1 - num_operands
  let blended : Array[Double] = []
  for i in 0..<base_count {
    blended.push(stack[i])
  }
  for i in 0..<num_blends {
    blended.push(stack[base_count + i])
  }
  stack.clear()
  for _, value in blended {
    stack.push(value)
  }
}

///|
fn apply_cff2_blend_stack(
  stack : Array[Double],
  blend_vector : Array[Int64],
) -> Unit {
  if stack.length() == 0 || blend_vector.length() == 0 {
    stack.clear()
    return
  }
  let num_blends = stack[stack.length() - 1].to_int()
  if num_blends <= 0 {
    stack.clear()
    return
  }
  let len_bv = blend_vector.length()
  let num_operands = num_blends * len_bv
  if stack.length() < num_operands + 1 {
    stack.clear()
    return
  }
  let base_count = stack.length() - 1 - num_operands
  let blended : Array[Double] = []
  for i in 0..<base_count {
    blended.push(stack[i])
  }
  for i in 0..<num_blends {
    let mut value = stack[base_count + i]
    for j in 1..<len_bv {
      let scalar = blend_vector[j].to_double() / 65536.0
      value += stack[base_count + num_blends * j + i] * scalar
    }
    blended.push(value)
  }
  stack.clear()
  for _, value in blended {
    stack.push(value)
  }
}

///|
fn delta_operands_to_i64(values : Array[Double]) -> Array[Int64] {
  let out : Array[Int64] = []
  let mut accum = 0L
  for _, value in values {
    accum += value.to_int64()
    out.push(accum)
  }
  out
}

///|
/// Parse a CFF Top DICT from raw DICT data bytes.
pub fn parse_top_dict(data : Bytes) -> CffTopDict {
  let dict = CffTopDict::new()
  let stack : Array[Double] = []
  let mut pos = 0
  let len = data.length()
  while pos < len {
    let b0 = data[pos].to_int()
    if b0 >= 0 && b0 <= 21 {
      // Operator
      if b0 == 12 {
        // Two-byte operator
        pos += 1
        if pos < len {
          let b1 = data[pos].to_int()
          apply_top_dict_op2(dict, stack, b1)
        }
      } else {
        apply_top_dict_op(dict, stack, b0)
      }
      stack.clear()
      pos += 1
    } else {
      let (val, consumed) = parse_dict_operand(data, pos)
      stack.push(val)
      pos += consumed
    }
  }
  dict
}

///|
fn apply_top_dict_op(
  dict : CffTopDict,
  stack : Array[Double],
  op : Int,
) -> Unit {
  match op {
    2 =>
      if stack.length() > 0 {
        dict.full_name_sid = stack[0].to_int().reinterpret_as_uint()
      }
    3 =>
      if stack.length() > 0 {
        dict.family_name_sid = stack[0].to_int().reinterpret_as_uint()
      }
    4 =>
      if stack.length() > 0 {
        dict.weight_sid = stack[0].to_int().reinterpret_as_uint()
      }
    15 => dict.charset_offset = stack[0].to_int().reinterpret_as_uint() // charset
    16 => dict.encoding_offset = stack[0].to_int().reinterpret_as_uint() // Encoding
    17 => dict.charstrings_offset = stack[0].to_int().reinterpret_as_uint() // CharStrings
    18 =>
      // Private (size, offset)
      if stack.length() >= 2 {
        dict.private_size = stack[0].to_int().reinterpret_as_uint()
        dict.private_offset = stack[1].to_int().reinterpret_as_uint()
      }
    24 =>
      if stack.length() > 0 {
        dict.vstore_offset = stack[0].to_int().reinterpret_as_uint()
      }
    5 =>
      // FontBBox
      if stack.length() >= 4 {
        dict.font_bbox = [
          stack[0].to_int64(),
          stack[1].to_int64(),
          stack[2].to_int64(),
          stack[3].to_int64(),
        ]
      }
    _ => () // Other operators: ignore for now
  }
}

///|
fn apply_top_dict_op2(
  dict : CffTopDict,
  stack : Array[Double],
  op : Int,
) -> Unit {
  match op {
    1 => if stack.length() > 0 { dict.is_fixed_pitch = stack[0].to_int() != 0 }
    3 => if stack.length() > 0 { dict.underline_position = stack[0].to_int() }
    4 => if stack.length() > 0 { dict.underline_thickness = stack[0].to_int() }
    30 =>
      // ROS (CID)
      if stack.length() >= 3 {
        dict.ros = (
          stack[0].to_int().reinterpret_as_uint(),
          stack[1].to_int().reinterpret_as_uint(),
          stack[2].to_int().reinterpret_as_uint(),
        )
        dict.is_cid = true
      }
    36 => dict.fd_array_offset = stack[0].to_int().reinterpret_as_uint() // FDArray
    37 => dict.fd_select_offset = stack[0].to_int().reinterpret_as_uint() // FDSelect
    7 =>
      // FontMatrix
      if stack.length() >= 6 {
        dict.font_matrix = [
          stack[0],
          stack[1],
          stack[2],
          stack[3],
          stack[4],
          stack[5],
        ]
      }
    _ => ()
  }
}

///|
pub fn parse_top_dict_cff2(data : Bytes) -> CffTopDict {
  let dict = CffTopDict::new()
  let stack : Array[Double] = []
  let mut pos = 0
  let len = data.length()
  while pos < len {
    let b0 = data[pos].to_int()
    if is_cff2_top_dict_op(b0) {
      if b0 == 12 {
        pos += 1
        if pos < len {
          apply_top_dict_op2(dict, stack, data[pos].to_int())
        }
      } else {
        apply_top_dict_op(dict, stack, b0)
      }
      stack.clear()
      pos += 1
    } else {
      let (val, consumed) = parse_dict_operand(data, pos)
      stack.push(val)
      pos += consumed
    }
  }
  dict
}

///|
/// Parse a CFF Private DICT from raw DICT data bytes.
pub fn parse_private_dict(data : Bytes) -> CffPrivateDict {
  let dict = CffPrivateDict::new()
  let stack : Array[Double] = []
  let mut pos = 0
  let len = data.length()
  while pos < len {
    let b0 = data[pos].to_int()
    if b0 >= 0 && b0 <= 21 {
      if b0 == 12 {
        pos += 1
        if pos < len {
          match data[pos].to_int() {
            9 => if stack.length() > 0 { dict.blue_scale = Some(stack[0]) }
            10 =>
              if stack.length() > 0 {
                dict.blue_shift = Some(stack[0].to_int())
              }
            11 =>
              if stack.length() > 0 {
                dict.blue_fuzz = Some(stack[0].to_int())
              }
            _ => ()
          }
        }
      } else {
        match b0 {
          6 =>
            // BlueValues
            dict.blue_values = delta_operands_to_i64(stack)
          7 =>
            // OtherBlues
            dict.other_blues = delta_operands_to_i64(stack)
          10 =>
            // StdHW
            if stack.length() > 0 {
              dict.std_hw = stack[0].to_int64()
            }
          11 =>
            // StdVW
            if stack.length() > 0 {
              dict.std_vw = stack[0].to_int64()
            }
          19 =>
            // Subrs (offset relative to start of Private DICT)
            if stack.length() > 0 {
              dict.subrs_offset = stack[0].to_int().reinterpret_as_uint()
            }
          20 =>
            // defaultWidthX
            if stack.length() > 0 {
              dict.default_width_x = stack[0].to_int64()
            }
          21 =>
            // nominalWidthX
            if stack.length() > 0 {
              dict.nominal_width_x = stack[0].to_int64()
            }
          _ => ()
        }
      }
      stack.clear()
      pos += 1
    } else {
      let (val, consumed) = parse_dict_operand(data, pos)
      stack.push(val)
      pos += consumed
    }
  }
  dict
}

///|
fn parse_variation_region_list_cff(
  reader : @stream.ByteReader,
  offset : Int,
) -> (Int, Array[Array[CffVarRegionAxis]]) raise @error.FTError {
  reader.seek(offset)
  let axis_count = reader.read_u16_be().reinterpret_as_int()
  let region_count = reader.read_u16_be().reinterpret_as_int()
  let regions : Array[Array[CffVarRegionAxis]] = Array::new(
    capacity=region_count,
  )
  for _ in 0..<region_count {
    let axes : Array[CffVarRegionAxis] = Array::new(capacity=axis_count)
    for _ in 0..<axis_count {
      let start_coord = @fixed.F2Dot14::from_raw(reader.read_i16_be())
        .to_fixed()
        .val()
      let mut peak_coord = @fixed.F2Dot14::from_raw(reader.read_i16_be())
        .to_fixed()
        .val()
      let end_coord = @fixed.F2Dot14::from_raw(reader.read_i16_be())
        .to_fixed()
        .val()
      if (start_coord < 0L && end_coord > 0L) ||
        start_coord > peak_coord ||
        peak_coord > end_coord {
        peak_coord = 0L
      }
      axes.push({ start_coord, peak_coord, end_coord })
    }
    regions.push(axes)
  }
  (axis_count, regions)
}

///|
fn parse_cff_vstore(
  data : Bytes,
  offset : Int,
) -> CffVarStore? raise @error.FTError {
  if offset <= 0 || offset + 2 > data.length() {
    return None
  }
  let reader = @stream.ByteReader::new(data)
  reader.seek(offset)
  let length = reader.read_u16_be().reinterpret_as_int()
  if length <= 2 || offset + length > data.length() {
    raise @error.FTError::InvalidTable
  }
  let base = offset + 2
  reader.seek(base)
  let format = reader.read_u16_be()
  if format != 1U {
    raise @error.FTError::InvalidTable
  }
  let region_list_offset = reader.read_u32_be().reinterpret_as_int()
  let data_count = reader.read_u16_be().reinterpret_as_int()
  let data_offsets : Array[Int] = Array::new(capacity=data_count)
  for _ in 0..<data_count {
    data_offsets.push(reader.read_u32_be().reinterpret_as_int())
  }
  let (axis_count, regions) = parse_variation_region_list_cff(
    reader,
    base + region_list_offset,
  )
  let var_data : Array[CffVarData?] = Array::new(capacity=data_count)
  for _, data_offset in data_offsets {
    if data_offset == 0 {
      var_data.push(None)
    } else {
      reader.seek(base + data_offset)
      ignore(reader.read_u16_be()) // itemCount
      ignore(reader.read_u16_be()) // shortDeltaCount
      let region_idx_count = reader.read_u16_be().reinterpret_as_int()
      let region_indices : Array[Int] = Array::new(capacity=region_idx_count)
      for _ in 0..<region_idx_count {
        region_indices.push(reader.read_u16_be().reinterpret_as_int())
      }
      var_data.push(Some({ region_indices, }))
    }
  }
  Some({ axis_count, regions, data: var_data })
}

///|
pub fn parse_private_dict_cff2(
  data : Bytes,
  vstore? : CffVarStore? = None,
  normalized_coords? : Array[Int] = [],
) -> CffPrivateDict {
  let dict = CffPrivateDict::new()
  let stack : Array[Double] = []
  let mut current_vsindex = 0
  let mut pos = 0
  let len = data.length()
  while pos < len {
    let b0 = data[pos].to_int()
    if b0 == 12 {
      pos += 1
      if pos < len {
        match data[pos].to_int() {
          9 => if stack.length() > 0 { dict.blue_scale = Some(stack[0]) }
          10 =>
            if stack.length() > 0 {
              dict.blue_shift = Some(stack[0].to_int())
            }
          11 =>
            if stack.length() > 0 {
              dict.blue_fuzz = Some(stack[0].to_int())
            }
          _ => ()
        }
      }
      stack.clear()
      pos += 1
    } else if b0 == 22 {
      if stack.length() > 0 {
        current_vsindex = stack[0].to_int()
        dict.default_vsindex = current_vsindex
      }
      stack.clear()
      pos += 1
    } else if b0 == 23 {
      let blend_vector = match vstore {
        Some(store) => store.blend_vector(current_vsindex, normalized_coords)
        None =>
          Array::make(cff2_blend_vector_length(vstore, current_vsindex), 0L)
      }
      if blend_vector.length() > 0 {
        apply_cff2_blend_stack(stack, blend_vector)
      } else {
        collapse_cff2_blend_stack(
          stack,
          cff2_blend_vector_length(vstore, current_vsindex),
        )
      }
      pos += 1
    } else if b0 >= 0 && b0 <= 21 {
      match b0 {
        6 => dict.blue_values = delta_operands_to_i64(stack)
        7 => dict.other_blues = delta_operands_to_i64(stack)
        10 => if stack.length() > 0 { dict.std_hw = stack[0].to_int64() }
        11 => if stack.length() > 0 { dict.std_vw = stack[0].to_int64() }
        19 =>
          if stack.length() > 0 {
            dict.subrs_offset = stack[0].to_int().reinterpret_as_uint()
          }
        _ => ()
      }
      stack.clear()
      pos += 1
    } else {
      let (val, consumed) = parse_dict_operand(data, pos)
      stack.push(val)
      pos += consumed
    }
  }
  dict
}

///|
fn resolve_units_per_em(top_dict : CffTopDict) -> UInt {
  let matrix = top_dict.font_matrix
  if matrix.length() < 4 {
    return 1000U
  }
  let scale = if matrix[3] != 0.0 { matrix[3] } else { matrix[1] }
  let abs_scale = if scale < 0.0 { -scale } else { scale }
  if abs_scale <= 0.0 {
    return 1000U
  }
  let upm = (1.0 / abs_scale).round().to_int()
  if upm <= 0 {
    1000U
  } else {
    upm.reinterpret_as_uint()
  }
}

///|
/// Load a CFF font from raw CFF data (not SFNT-wrapped).
pub fn load_cff(data : Bytes, offset : Int) -> CffFont raise @error.FTError {
  let reader = @stream.ByteReader::new(data)
  reader.seek(offset)
  // Parse header
  let major = reader.read_byte().to_int()
  let minor = reader.read_byte().to_int()
  let hdr_size = reader.read_byte().to_int()
  let off_size = reader.read_byte().to_int()
  let header = { major, minor, hdr_size, off_size }
  // Skip to end of header
  reader.seek(offset + hdr_size)
  // Parse Name INDEX
  let name_index = parse_cff_index(reader)
  let name = if name_index.count > 0U {
    decode_cff_string_bytes(name_index.get_item(0))
  } else {
    ""
  }
  // Parse Top DICT INDEX
  let top_dict_index = parse_cff_index(reader)
  let top_dict_data = top_dict_index.get_item(0)
  let top_dict = parse_top_dict(top_dict_data)
  // Parse String INDEX
  let string_index = parse_cff_index(reader)
  let custom_strings = parse_cff_string_index(string_index)
  let family_name = if top_dict.family_name_sid == 0U {
    ""
  } else {
    sid_to_string(top_dict.family_name_sid, custom_strings)
  }
  let weight = if top_dict.weight_sid == 0U {
    ""
  } else {
    sid_to_string(top_dict.weight_sid, custom_strings)
  }
  let style_name = style_name_from_ps_name(name, weight)
  let units_per_em = resolve_units_per_em(top_dict)
  // Parse Global Subr INDEX
  let global_subrs = parse_cff_index(reader)
  // Parse Charstrings INDEX
  reader.seek(offset + top_dict.charstrings_offset.reinterpret_as_int())
  let charstrings = parse_cff_index(reader)
  let num_glyphs = charstrings.count
  let glyph_sids = if top_dict.is_cid {
    []
  } else {
    parse_cff_charset(reader, offset, top_dict.charset_offset, num_glyphs)
  }
  let glyph_names = if glyph_sids.length() > 0 {
    glyph_sids.map(fn(sid) { sid_to_string(sid, custom_strings) })
  } else {
    []
  }
  let encoding_glyphs = if glyph_sids.length() > 0 {
    parse_cff_encoding(reader, offset, top_dict.encoding_offset, glyph_sids)
  } else {
    Array::make(256, 0U)
  }
  // Parse Private DICT
  let private_dict = if top_dict.private_size > 0U {
    let priv_start = offset + top_dict.private_offset.reinterpret_as_int()
    let priv_size = top_dict.private_size.reinterpret_as_int()
    reader.seek(priv_start)
    let priv_data = reader.read_bytes(priv_size)
    parse_private_dict(priv_data)
  } else {
    CffPrivateDict::new()
  }
  // Parse Local Subrs if present
  let local_subrs = if private_dict.subrs_offset > 0U {
    let subrs_abs = offset +
      top_dict.private_offset.reinterpret_as_int() +
      private_dict.subrs_offset.reinterpret_as_int()
    reader.seek(subrs_abs)
    Some(parse_cff_index(reader))
  } else {
    None
  }
  // Build cached subroutine arrays once at load time
  let cached_local_subrs : Array[Bytes] = match local_subrs {
    Some(idx) => {
      let count = idx.count.reinterpret_as_int()
      let subrs : Array[Bytes] = []
      for i in 0..<count {
        subrs.push(idx.get_item(i))
      }
      subrs
    }
    None => []
  }
  let global_count = global_subrs.count.reinterpret_as_int()
  let cached_global_subrs : Array[Bytes] = []
  for i in 0..<global_count {
    cached_global_subrs.push(global_subrs.get_item(i))
  }
  let fd_private_dicts : Array[CffPrivateDict] = []
  let fd_local_subrs : Array[Array[Bytes]] = []
  if top_dict.is_cid && top_dict.fd_array_offset > 0U {
    reader.seek(offset + top_dict.fd_array_offset.reinterpret_as_int())
    let fd_array = parse_cff_index(reader)
    let fd_count = fd_array.count.reinterpret_as_int()
    for i in 0..<fd_count {
      let fd_dict = parse_top_dict(fd_array.get_item(i))
      let fd_private_dict = if fd_dict.private_size > 0U {
        let priv_start = offset + fd_dict.private_offset.reinterpret_as_int()
        let priv_size = fd_dict.private_size.reinterpret_as_int()
        reader.seek(priv_start)
        let priv_data = reader.read_bytes(priv_size)
        parse_private_dict(priv_data)
      } else {
        CffPrivateDict::new()
      }
      let cached_fd_local_subrs : Array[Bytes] = if fd_private_dict.subrs_offset >
        0U {
        let subrs_abs = offset +
          fd_dict.private_offset.reinterpret_as_int() +
          fd_private_dict.subrs_offset.reinterpret_as_int()
        reader.seek(subrs_abs)
        let idx = parse_cff_index(reader)
        let count = idx.count.reinterpret_as_int()
        let subrs : Array[Bytes] = []
        for j in 0..<count {
          subrs.push(idx.get_item(j))
        }
        subrs
      } else {
        []
      }
      fd_private_dicts.push(fd_private_dict)
      fd_local_subrs.push(cached_fd_local_subrs)
    }
  }
  let fd_select : Array[Int] = Array::make(num_glyphs.reinterpret_as_int(), 0)
  if top_dict.is_cid && top_dict.fd_select_offset > 0U {
    reader.seek(offset + top_dict.fd_select_offset.reinterpret_as_int())
    let format = reader.read_byte().to_int()
    match format {
      0 =>
        for i in 0..<num_glyphs.reinterpret_as_int() {
          fd_select[i] = reader.read_byte().to_int()
        }
      3 => {
        let n_ranges = reader.read_u16_be().reinterpret_as_int()
        let first_glyphs : Array[Int] = []
        let fds : Array[Int] = []
        for _ in 0..<n_ranges {
          first_glyphs.push(reader.read_u16_be().reinterpret_as_int())
          fds.push(reader.read_byte().to_int())
        }
        let sentinel = reader.read_u16_be().reinterpret_as_int()
        for i in 0..<n_ranges {
          let start = first_glyphs[i]
          let end_ = if i + 1 < n_ranges {
            first_glyphs[i + 1]
          } else {
            sentinel
          }
          let clamped_start = if start < 0 { 0 } else { start }
          let clamped_end = if end_ > num_glyphs.reinterpret_as_int() {
            num_glyphs.reinterpret_as_int()
          } else {
            end_
          }
          for glyph in clamped_start..<clamped_end {
            fd_select[glyph] = fds[i]
          }
        }
      }
      _ => ()
    }
  }
  {
    header,
    name,
    family_name: if family_name != "" {
      family_name
    } else {
      name
    },
    style_name,
    units_per_em,
    is_fixed_pitch: top_dict.is_fixed_pitch,
    top_dict,
    private_dict,
    private_data: None,
    charstrings,
    global_subrs,
    local_subrs,
    num_glyphs,
    custom_strings,
    glyph_names,
    encoding_glyphs,
    cached_local_subrs,
    fd_private_dicts,
    fd_private_data: [],
    fd_local_subrs,
    fd_select,
    cached_global_subrs,
    is_cff2: false,
    vstore: None,
  }
}

///|
/// Load a CFF2 font from SFNT table bytes.
pub fn load_cff2(
  data : Bytes,
  offset : Int,
  units_per_em : UInt,
) -> CffFont raise @error.FTError {
  let reader = @stream.ByteReader::new(data)
  reader.seek(offset)
  let major = reader.read_byte().to_int()
  let minor = reader.read_byte().to_int()
  let hdr_size = reader.read_byte().to_int()
  let top_dict_length = reader.read_u16_be().reinterpret_as_int()
  if major != 2 || hdr_size < 5 || top_dict_length <= 0 {
    raise @error.FTError::InvalidTable
  }
  let header = { major, minor, hdr_size, off_size: 0 }
  let top_dict_start = offset + hdr_size
  reader.seek(top_dict_start)
  let top_dict_data = reader.read_bytes(top_dict_length)
  let top_dict = parse_top_dict_cff2(top_dict_data)
  reader.seek(top_dict_start + top_dict_length)
  let global_subrs = parse_cff2_index(reader)
  let vstore = if top_dict.vstore_offset > 0U {
    parse_cff_vstore(data, offset + top_dict.vstore_offset.reinterpret_as_int())
  } else {
    None
  }
  reader.seek(offset + top_dict.charstrings_offset.reinterpret_as_int())
  let charstrings = parse_cff2_index(reader)
  let num_glyphs = charstrings.count
  let global_count = global_subrs.count.reinterpret_as_int()
  let cached_global_subrs : Array[Bytes] = []
  for i in 0..<global_count {
    cached_global_subrs.push(global_subrs.get_item(i))
  }
  let (private_dict, private_data, local_subrs, cached_local_subrs) = if top_dict.private_size >
    0U {
    let priv_start = offset + top_dict.private_offset.reinterpret_as_int()
    let priv_size = top_dict.private_size.reinterpret_as_int()
    reader.seek(priv_start)
    let priv_data = reader.read_bytes(priv_size)
    let parsed_private = parse_private_dict_cff2(priv_data, vstore~)
    let maybe_local_subrs = if parsed_private.subrs_offset > 0U {
      let subrs_abs = offset +
        top_dict.private_offset.reinterpret_as_int() +
        parsed_private.subrs_offset.reinterpret_as_int()
      reader.seek(subrs_abs)
      Some(parse_cff2_index(reader))
    } else {
      None
    }
    let cached_subrs : Array[Bytes] = match maybe_local_subrs {
      Some(idx) => {
        let count = idx.count.reinterpret_as_int()
        let subrs : Array[Bytes] = []
        for i in 0..<count {
          subrs.push(idx.get_item(i))
        }
        subrs
      }
      None => []
    }
    (parsed_private, Some(priv_data), maybe_local_subrs, cached_subrs)
  } else {
    (CffPrivateDict::new(), None, None, [])
  }
  let fd_private_dicts : Array[CffPrivateDict] = []
  let fd_private_data : Array[Bytes] = []
  let fd_local_subrs : Array[Array[Bytes]] = []
  let fd_select : Array[Int] = Array::make(num_glyphs.reinterpret_as_int(), 0)
  if top_dict.fd_array_offset > 0U {
    reader.seek(offset + top_dict.fd_array_offset.reinterpret_as_int())
    let fd_array = parse_cff2_index(reader)
    let fd_count = fd_array.count.reinterpret_as_int()
    for i in 0..<fd_count {
      let fd_dict = parse_top_dict_cff2(fd_array.get_item(i))
      let fd_private_dict = if fd_dict.private_size > 0U {
        let priv_start = offset + fd_dict.private_offset.reinterpret_as_int()
        let priv_size = fd_dict.private_size.reinterpret_as_int()
        reader.seek(priv_start)
        let priv_data = reader.read_bytes(priv_size)
        fd_private_data.push(priv_data)
        parse_private_dict_cff2(priv_data, vstore~)
      } else {
        fd_private_data.push(b"")
        CffPrivateDict::new()
      }
      let cached_fd_local_subrs : Array[Bytes] = if fd_private_dict.subrs_offset >
        0U {
        let subrs_abs = offset +
          fd_dict.private_offset.reinterpret_as_int() +
          fd_private_dict.subrs_offset.reinterpret_as_int()
        reader.seek(subrs_abs)
        let idx = parse_cff2_index(reader)
        let count = idx.count.reinterpret_as_int()
        let subrs : Array[Bytes] = []
        for j in 0..<count {
          subrs.push(idx.get_item(j))
        }
        subrs
      } else {
        []
      }
      fd_private_dicts.push(fd_private_dict)
      fd_local_subrs.push(cached_fd_local_subrs)
    }
  }
  if top_dict.fd_select_offset > 0U {
    reader.seek(offset + top_dict.fd_select_offset.reinterpret_as_int())
    let format = reader.read_byte().to_int()
    match format {
      0 =>
        for i in 0..<num_glyphs.reinterpret_as_int() {
          fd_select[i] = reader.read_byte().to_int()
        }
      3 => {
        let n_ranges = reader.read_u16_be().reinterpret_as_int()
        let first_glyphs : Array[Int] = []
        let fds : Array[Int] = []
        for _ in 0..<n_ranges {
          first_glyphs.push(reader.read_u16_be().reinterpret_as_int())
          fds.push(reader.read_byte().to_int())
        }
        let sentinel = reader.read_u16_be().reinterpret_as_int()
        for i in 0..<n_ranges {
          let start = first_glyphs[i].max(0)
          let raw_end = if i + 1 < n_ranges {
            first_glyphs[i + 1]
          } else {
            sentinel
          }
          let end_ = raw_end.min(num_glyphs.reinterpret_as_int())
          for glyph in start..<end_ {
            fd_select[glyph] = fds[i]
          }
        }
      }
      _ => raise @error.FTError::InvalidTable
    }
  }
  {
    header,
    name: "",
    family_name: "",
    style_name: "",
    units_per_em,
    is_fixed_pitch: false,
    top_dict,
    private_dict,
    private_data,
    charstrings,
    global_subrs,
    local_subrs,
    num_glyphs,
    custom_strings: [],
    glyph_names: [],
    encoding_glyphs: Array::make(256, 0U),
    cached_local_subrs,
    fd_private_dicts,
    fd_private_data,
    fd_local_subrs,
    fd_select,
    cached_global_subrs,
    is_cff2: true,
    vstore,
  }
}

///|
/// Load a glyph outline from a CFF font.
pub fn load_cff_glyph(
  cff : CffFont,
  glyph_index : UInt,
  normalized_coords? : Array[Int] = [],
) -> (@types.Outline, Int64, Array[@psaux.StemHint], Array[@psaux.StemHint]) raise @error.FTError {
  let charstring = cff.charstrings.get_item(glyph_index.reinterpret_as_int())
  if charstring.length() == 0 {
    return (@types.Outline::new(), 0L, [], [])
  }
  let private_dict = if cff.is_cff2() {
    let fd_idx = cff.fd_index_for_glyph(glyph_index)
    let maybe_private_data = if fd_idx >= 0 &&
      fd_idx < cff.fd_private_data().length() &&
      cff.fd_private_data()[fd_idx].length() > 0 {
      Some(cff.fd_private_data()[fd_idx])
    } else {
      cff.private_data()
    }
    match maybe_private_data {
      Some(priv_data) if priv_data.length() > 0 =>
        parse_private_dict_cff2(
          priv_data,
          vstore=cff.vstore(),
          normalized_coords~,
        )
      _ => cff.private_dict_for_glyph(glyph_index)
    }
  } else {
    cff.private_dict_for_glyph(glyph_index)
  }
  let blend_vectors : Array[Array[Int64]?] = match cff.vstore {
    Some(vstore) => {
      let vectors : Array[Array[Int64]?] = Array::new(
        capacity=vstore.data.length(),
      )
      for i in 0..<vstore.data.length() {
        vectors.push(Some(vstore.blend_vector(i, normalized_coords)))
      }
      vectors
    }
    None => []
  }
  @psaux.execute_type2(
    charstring,
    private_dict.default_width_x(),
    private_dict.nominal_width_x(),
    local_subrs=cff.cached_local_subrs_for_glyph(glyph_index),
    global_subrs=cff.cached_global_subrs,
    is_cff2=cff.is_cff2,
    default_vsindex=private_dict.default_vsindex(),
    blend_vectors~,
  )
}
