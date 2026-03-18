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
/// Parse a WOFF1 file and return the decompressed SFNT data.
/// Uses @zlib.decompress for compressed tables.
pub fn decompress_woff(data : Bytes) -> Bytes raise @error.FTError {
  let reader = @stream.ByteReader::new(data)
  // Parse WOFF header (44 bytes)
  let signature = reader.read_u32_be()
  if signature != @types.tag_wOFF {
    raise @error.FTError::InvalidFileFormat
  }
  let flavor = reader.read_u32_be()
  let _length = reader.read_u32_be()
  let num_tables = reader.read_u16_be()
  let _reserved = reader.read_u16_be()
  let total_sfnt_size = reader.read_u32_be()
  let _major_version = reader.read_u16_be()
  let _minor_version = reader.read_u16_be()
  let _meta_offset = reader.read_u32_be()
  let _meta_length = reader.read_u32_be()
  let _meta_orig_length = reader.read_u32_be()
  let _priv_offset = reader.read_u32_be()
  let _priv_length = reader.read_u32_be()
  // Parse WOFF table directory entries
  let entries : Array[WoffTableEntry] = []
  let nt = num_tables.reinterpret_as_int()
  for _ in 0..<nt {
    let tag = reader.read_u32_be()
    let offset = reader.read_u32_be()
    let comp_length = reader.read_u32_be()
    let orig_length = reader.read_u32_be()
    let orig_checksum = reader.read_u32_be()
    entries.push({ tag, offset, comp_length, orig_length, orig_checksum })
  }
  // Build decompressed SFNT
  // SFNT header: 12 bytes + 16 bytes per table
  let sfnt_header_size = 12 + nt * 16
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
    let woff_reader = @stream.ByteReader::new(data)
    woff_reader.seek(entry.offset.reinterpret_as_int())
    let compressed_data = woff_reader.read_bytes(comp_len)
    let table_data = if comp_len < orig_len {
      // Compressed: decompress with zlib
      @zlib.decompress(compressed_data) catch {
        _ => raise @error.FTError::InvalidTable
      }
    } else {
      compressed_data
    }
    // Copy to SFNT buffer
    let copy_len = if table_data.length() < orig_len {
      table_data.length()
    } else {
      orig_len
    }
    for j in 0..<copy_len {
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
