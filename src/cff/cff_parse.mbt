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
fn parse_dict_operand(data : Bytes, pos : Int) -> (Int64, Int) {
  let b0 = data[pos].to_int()
  if b0 >= 32 && b0 <= 246 {
    ((b0 - 139).to_int64(), 1)
  } else if b0 >= 247 && b0 <= 250 {
    let b1 = data[pos + 1].to_int()
    (((b0 - 247) * 256 + b1 + 108).to_int64(), 2)
  } else if b0 >= 251 && b0 <= 254 {
    let b1 = data[pos + 1].to_int()
    ((-((b0 - 251) * 256 + b1 + 108)).to_int64(), 2)
  } else if b0 == 28 {
    let hi = data[pos + 1].to_int()
    let lo = data[pos + 2].to_int()
    let val = (hi << 8) | lo
    let signed_val = if val >= 0x8000 { val - 0x10000 } else { val }
    (signed_val.to_int64(), 3)
  } else if b0 == 29 {
    let val = (data[pos + 1].to_int() << 24) |
      (data[pos + 2].to_int() << 16) |
      (data[pos + 3].to_int() << 8) |
      data[pos + 4].to_int()
    (val.to_int64(), 5)
  } else if b0 == 30 {
    // Real number (BCD encoded) — simplified: skip it and return 0
    let mut p = pos + 1
    while p < data.length() {
      let nibble_byte = data[p].to_int()
      let hi_nib = nibble_byte >> 4
      let lo_nib = nibble_byte & 0x0F
      if hi_nib == 0x0F || lo_nib == 0x0F {
        break
      }
      p += 1
    }
    (0L, p - pos + 1)
  } else {
    (0L, 1)
  }
}

///|
/// Parse a CFF Top DICT from raw DICT data bytes.
pub fn parse_top_dict(data : Bytes) -> CffTopDict {
  let dict = CffTopDict::new()
  let stack : Array[Int64] = []
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
fn apply_top_dict_op(dict : CffTopDict, stack : Array[Int64], op : Int) -> Unit {
  match op {
    15 => dict.charset_offset = stack[0].to_int().reinterpret_as_uint() // charset
    16 => dict.encoding_offset = stack[0].to_int().reinterpret_as_uint() // Encoding
    17 => dict.charstrings_offset = stack[0].to_int().reinterpret_as_uint() // CharStrings
    18 =>
      // Private (size, offset)
      if stack.length() >= 2 {
        dict.private_size = stack[0].to_int().reinterpret_as_uint()
        dict.private_offset = stack[1].to_int().reinterpret_as_uint()
      }
    5 =>
      // FontBBox
      if stack.length() >= 4 {
        dict.font_bbox = [stack[0], stack[1], stack[2], stack[3]]
      }
    _ => () // Other operators: ignore for now
  }
}

///|
fn apply_top_dict_op2(
  dict : CffTopDict,
  stack : Array[Int64],
  op : Int,
) -> Unit {
  match op {
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
/// Parse a CFF Private DICT from raw DICT data bytes.
pub fn parse_private_dict(data : Bytes) -> CffPrivateDict {
  let dict = CffPrivateDict::new()
  let stack : Array[Int64] = []
  let mut pos = 0
  let len = data.length()
  while pos < len {
    let b0 = data[pos].to_int()
    if b0 >= 0 && b0 <= 21 {
      if b0 == 12 {
        pos += 1
        // Two-byte operator: ignore for now
      } else {
        match b0 {
          6 =>
            // BlueValues
            dict.blue_values = stack.copy()
          7 =>
            // OtherBlues
            dict.other_blues = stack.copy()
          10 =>
            // StdHW
            if stack.length() > 0 {
              dict.std_hw = stack[0]
            }
          11 =>
            // StdVW
            if stack.length() > 0 {
              dict.std_vw = stack[0]
            }
          19 =>
            // Subrs (offset relative to start of Private DICT)
            if stack.length() > 0 {
              dict.subrs_offset = stack[0].to_int().reinterpret_as_uint()
            }
          20 =>
            // defaultWidthX
            if stack.length() > 0 {
              dict.default_width_x = stack[0]
            }
          21 =>
            // nominalWidthX
            if stack.length() > 0 {
              dict.nominal_width_x = stack[0]
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
    let name_bytes = name_index.get_item(0)
    let buf = StringBuilder::new()
    for _, b in name_bytes {
      buf.write_char(Char::from_int(b.to_int()))
    }
    buf.to_string()
  } else {
    ""
  }
  // Parse Top DICT INDEX
  let top_dict_index = parse_cff_index(reader)
  let top_dict_data = top_dict_index.get_item(0)
  let top_dict = parse_top_dict(top_dict_data)
  // Parse String INDEX
  let _string_index = parse_cff_index(reader)
  // Parse Global Subr INDEX
  let global_subrs = parse_cff_index(reader)
  // Parse Charstrings INDEX
  reader.seek(offset + top_dict.charstrings_offset.reinterpret_as_int())
  let charstrings = parse_cff_index(reader)
  let num_glyphs = charstrings.count
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
  {
    header,
    name,
    top_dict,
    private_dict,
    charstrings,
    global_subrs,
    local_subrs,
    num_glyphs,
  }
}

///|
/// Load a glyph outline from a CFF font.
pub fn load_cff_glyph(
  cff : CffFont,
  glyph_index : UInt,
) -> (@types.Outline, Int64) raise @error.FTError {
  let charstring = cff.charstrings.get_item(glyph_index.reinterpret_as_int())
  if charstring.length() == 0 {
    return (@types.Outline::new(), 0L)
  }
  // Build subroutine arrays
  let local_subrs = match cff.local_subrs {
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
  let global_count = cff.global_subrs.count.reinterpret_as_int()
  let global_subrs_arr : Array[Bytes] = []
  for i in 0..<global_count {
    global_subrs_arr.push(cff.global_subrs.get_item(i))
  }
  @psaux.execute_type2(
    charstring,
    cff.private_dict.default_width_x,
    cff.private_dict.nominal_width_x,
    local_subrs~,
    global_subrs=global_subrs_arr,
  )
}
