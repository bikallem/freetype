///|
/// WOFF1 table directory entry (used during decompression).
priv struct WoffTableEntry {
  tag : UInt
  offset : UInt
  comp_length : UInt
  orig_length : UInt
  orig_checksum : UInt
}

///|
fn woff_align_4(value : Int) -> Int {
  (value + 3) & -4
}

///|
fn validate_woff_optional_block(
  offset : UInt,
  length : UInt,
  total_length : Int,
) -> Unit raise @error.FTError {
  let block_offset = offset.reinterpret_as_int()
  let block_length = length.reinterpret_as_int()
  if block_length == 0 {
    if block_offset != 0 {
      raise @error.FTError::InvalidFileFormat
    }
    return
  }
  if block_offset <= 0 ||
    block_offset > total_length ||
    block_length < 0 ||
    block_offset + block_length > total_length {
    raise @error.FTError::InvalidFileFormat
  }
}

///|
/// Parse a WOFF1 file and return the decompressed SFNT data.
/// Uses @zlib.decompress for compressed tables.
pub fn decompress_woff(data : Bytes) -> Bytes raise @error.FTError {
  let data_length = data.length()
  if data_length < 44 {
    raise @error.FTError::InvalidFileFormat
  }
  let reader = @stream.ByteReader::new(data)
  // Parse WOFF header (44 bytes)
  let signature = reader.read_u32_be()
  if signature != @types.TAG_WOFF {
    raise @error.FTError::InvalidFileFormat
  }
  let flavor = reader.read_u32_be()
  if flavor == @types.TAG_WOFF || flavor == @types.TAG_TTCF {
    raise @error.FTError::InvalidFileFormat
  }
  let length = reader.read_u32_be()
  let num_tables = reader.read_u16_be()
  let reserved = reader.read_u16_be()
  let total_sfnt_size = reader.read_u32_be()
  let _major_version = reader.read_u16_be()
  let _minor_version = reader.read_u16_be()
  let meta_offset = reader.read_u32_be()
  let meta_length = reader.read_u32_be()
  let meta_orig_length = reader.read_u32_be()
  let priv_offset = reader.read_u32_be()
  let priv_length = reader.read_u32_be()
  if length.reinterpret_as_int() != data_length || reserved != 0U {
    raise @error.FTError::InvalidFileFormat
  }
  if num_tables == 0U {
    raise @error.FTError::InvalidFileFormat
  }
  let nt = num_tables.reinterpret_as_int()
  let header_and_dir_size = 44 + nt * 20
  if header_and_dir_size > data_length {
    raise @error.FTError::InvalidFileFormat
  }
  validate_woff_optional_block(meta_offset, meta_length, data_length)
  if meta_length == 0U && meta_orig_length != 0U {
    raise @error.FTError::InvalidFileFormat
  }
  if meta_length != 0U && meta_orig_length == 0U {
    raise @error.FTError::InvalidFileFormat
  }
  validate_woff_optional_block(priv_offset, priv_length, data_length)
  // Parse WOFF table directory entries
  let entries : Array[WoffTableEntry] = []
  let sorted_by_offset : Array[Int] = []
  let mut prev_tag = 0U
  for _ in 0..<nt {
    let tag = reader.read_u32_be()
    let offset = reader.read_u32_be()
    let comp_length = reader.read_u32_be()
    let orig_length = reader.read_u32_be()
    let orig_checksum = reader.read_u32_be()
    if entries.length() > 0 && tag.compare(prev_tag) <= 0 {
      raise @error.FTError::InvalidTable
    }
    prev_tag = tag
    if offset.reinterpret_as_int() < header_and_dir_size ||
      (offset & 3U) != 0U ||
      comp_length > orig_length {
      raise @error.FTError::InvalidTable
    }
    if comp_length == 0U && orig_length != 0U {
      raise @error.FTError::InvalidTable
    }
    let end_offset = offset.reinterpret_as_int() +
      comp_length.reinterpret_as_int()
    if end_offset > data_length {
      raise @error.FTError::InvalidTable
    }
    entries.push({ tag, offset, comp_length, orig_length, orig_checksum })
    sorted_by_offset.push(entries.length() - 1)
  }
  sorted_by_offset.sort_by(fn(a, b) {
    entries[a].offset.compare(entries[b].offset)
  })
  let mut last_end = header_and_dir_size
  for _, idx in sorted_by_offset {
    let entry = entries[idx]
    let entry_offset = entry.offset.reinterpret_as_int()
    if entry_offset < last_end {
      raise @error.FTError::InvalidTable
    }
    last_end = entry_offset + entry.comp_length.reinterpret_as_int()
  }
  let sfnt_header_size = 12 + nt * 16
  let mut expected_sfnt_size = woff_align_4(sfnt_header_size)
  for _, entry in entries {
    expected_sfnt_size += woff_align_4(entry.orig_length.reinterpret_as_int())
  }
  if total_sfnt_size.reinterpret_as_int() != expected_sfnt_size {
    raise @error.FTError::InvalidTable
  }
  // Build decompressed SFNT
  // SFNT header: 12 bytes + 16 bytes per table
  let sfnt_size = total_sfnt_size.reinterpret_as_int()
  let sfnt = FixedArray::make(sfnt_size, b'\x00')
  // Write SFNT header
  write_u32_be(sfnt, 0, flavor)
  write_u16_be(sfnt, 4, num_tables)
  // Compute searchRange, entrySelector, rangeShift
  let (sr, es) = for sr = 1, es = 0; sr * 2 <= nt; {
    continue sr * 2, es + 1
  } nobreak {
    (sr * 16, es)
  }
  write_u16_be(sfnt, 6, sr.reinterpret_as_uint())
  write_u16_be(sfnt, 8, es.reinterpret_as_uint())
  write_u16_be(sfnt, 10, (nt * 16 - sr).reinterpret_as_uint())
  // Decompress each table and write to SFNT
  for i = 0, table_offset = sfnt_header_size; i < nt; {
    let entry = entries[i]
    // Align table offset to 4 bytes
    let table_offset = (table_offset + 3) & -4
    // Write table record in SFNT directory
    let rec_offset = 12 + i * 16
    write_u32_be(sfnt, rec_offset, entry.tag)
    write_u32_be(sfnt, rec_offset + 4, entry.orig_checksum)
    write_u32_be(sfnt, rec_offset + 8, table_offset.reinterpret_as_uint())
    write_u32_be(sfnt, rec_offset + 12, entry.orig_length)
    // Decompress or copy table data
    let comp_len = entry.comp_length.reinterpret_as_int()
    let orig_len = entry.orig_length.reinterpret_as_int()
    let data_start = entry.offset.reinterpret_as_int()
    let compressed_data = data[data_start:data_start + comp_len].to_bytes()
    let table_data = if comp_len < orig_len {
      // Compressed: decompress with zlib
      @zlib.decompress(compressed_data) catch {
        _ => raise @error.FTError::InvalidTable
      }
    } else {
      compressed_data
    }
    if table_data.length() != orig_len {
      raise @error.FTError::InvalidTable
    }
    if table_offset + orig_len > sfnt_size {
      raise @error.FTError::InvalidTable
    }
    // Copy to SFNT buffer
    for j in 0..<orig_len {
      sfnt[table_offset + j] = table_data[j]
    }
    continue i + 1, table_offset + orig_len
  }
  Bytes::from_array(sfnt[:])
}

///|
fn write_u32_be(buf : FixedArray[Byte], offset : Int, value : UInt) -> Unit {
  buf[offset] = ((value >> 24) & 0xFFU).to_byte()
  buf[offset + 1] = ((value >> 16) & 0xFFU).to_byte()
  buf[offset + 2] = ((value >> 8) & 0xFFU).to_byte()
  buf[offset + 3] = (value & 0xFFU).to_byte()
}

///|
fn write_u16_be(buf : FixedArray[Byte], offset : Int, value : UInt) -> Unit {
  buf[offset] = ((value >> 8) & 0xFFU).to_byte()
  buf[offset + 1] = (value & 0xFFU).to_byte()
}
