///|
/// WOFF2 known table tags (indices 0-62) per the spec.
/// See https://www.w3.org/TR/WOFF2/#table_dir_format
let woff2_known_tags : FixedArray[UInt] = [
  0x636D6170U, // 0  cmap
   0x68656164U, // 1  head
   0x68686561U, // 2  hhea
   0x686D7478U, // 3  hmtx
   0x6D617870U, // 4  maxp
   0x6E616D65U, // 5  name
   0x4F532F32U, // 6  OS/2
   0x706F7374U, // 7  post
   0x63767420U, // 8  cvt
   0x6670676DU, // 9  fpgm
   0x676C7966U, // 10 glyf
   0x6C6F6361U, // 11 loca
   0x70726570U, // 12 prep
   0x43464620U, // 13 CFF
   0x564F5247U, // 14 VORG
   0x45424454U, // 15 EBDT
   0x45424C43U, // 16 EBLC
   0x67617370U, // 17 gasp
   0x68646D78U, // 18 hdmx
   0x6B65726EU, // 19 kern
   0x4C545348U, // 20 LTSH
   0x50434C54U, // 21 PCLT
   0x56444D58U, // 22 VDMX
   0x76686561U, // 23 vhea
   0x766D7478U, // 24 vmtx
   0x42415345U, // 25 BASE
   0x47444546U, // 26 GDEF
   0x47504F53U, // 27 GPOS
   0x47535542U, // 28 GSUB
   0x45425343U, // 29 EBSC
   0x4A535446U, // 30 JSTF
   0x4D415448U, // 31 MATH
   0x43424454U, // 32 CBDT
   0x43424C43U, // 33 CBLC
   0x434F4C52U, // 34 COLR
   0x4350414CU, // 35 CPAL
   0x53564720U, // 36 SVG
   0x73626978U, // 37 sbix
   0x61636E74U, // 38 acnt
   0x61766172U, // 39 avar
   0x62646174U, // 40 bdat
   0x626C6F63U, // 41 bloc
   0x62736C6EU, // 42 bsln
   0x63766172U, // 43 cvar
   0x66647363U, // 44 fdsc
   0x66656174U, // 45 feat
   0x666D7478U, // 46 fmtx
   0x66766172U, // 47 fvar
   0x67766172U, // 48 gvar
   0x68737479U, // 49 hsty
   0x6A757374U, // 50 just
   0x6C636172U, // 51 lcar
   0x6D6F7274U, // 52 mort
   0x6D6F7278U, // 53 morx
   0x6F706264U, // 54 opbd
   0x70726F70U, // 55 prop
   0x7472616BU, // 56 trak
   0x5A617066U, // 57 Zapf
   0x53696C66U, // 58 Silf
   0x476C6174U, // 59 Glat
   0x476C6F63U, // 60 Gloc
   0x46656174U, // 61 Feat
   0x53696C6CU, // 62 Sill
]

///|
priv struct Woff2TableEntry {
  tag : UInt
  flags : UInt
  orig_length : UInt
  transform_length : UInt
  /// Offset within the uncompressed stream where this table's data starts
  src_offset : Int
}

///|
/// Read a WOFF2 UIntBase128 value.
fn read_base128(reader : @stream.ByteReader) -> UInt raise @error.FTError {
  let mut result = 0U
  for i in 0..<5 {
    let code = reader.read_byte()
    if i == 0 && code == 0x80 {
      raise @error.FTError::InvalidTable
    }
    if (result & 0xFE000000U) != 0U {
      raise @error.FTError::InvalidTable
    }
    result = (result << 7) | (code.to_uint() & 0x7FU)
    if (code.to_uint() & 0x80U) == 0U {
      return result
    }
  }
  raise @error.FTError::InvalidTable
}

///|
/// Read a WOFF2 255UShort value.
fn read_255ushort(reader : @stream.ByteReader) -> UInt raise @error.FTError {
  let code = reader.read_byte().to_uint()
  if code == 253U {
    reader.read_u16_be()
  } else if code == 255U {
    reader.read_byte().to_uint() + 253U
  } else if code == 254U {
    reader.read_byte().to_uint() + 506U
  } else {
    code
  }
}

///|
/// Compute checksum of a byte range.
fn compute_checksum(data : Bytes, offset : Int, length : Int) -> UInt {
  let mut checksum = 0U
  let aligned = length & -4
  let mut k = 0
  while k < aligned {
    let c = (data[offset + k].to_uint() << 24) |
      (data[offset + k + 1].to_uint() << 16) |
      (data[offset + k + 2].to_uint() << 8) |
      data[offset + k + 3].to_uint()
    checksum = checksum + c
    k += 4
  }
  let mut shift = 24
  while k < length {
    checksum = checksum + (data[offset + k].to_uint() << shift)
    k += 1
    shift -= 8
  }
  checksum
}

///|
/// Parse a WOFF2 file and return the decompressed SFNT data.
/// Uses @brotli.decompress for the compressed data stream.
pub fn decompress_woff2(data : Bytes) -> Bytes raise @error.FTError {
  let reader = @stream.ByteReader::new(data)
  // Parse WOFF2 header (48 bytes)
  let signature = reader.read_u32_be()
  if signature != @types.TAG_WOF2 {
    raise @error.FTError::InvalidFileFormat
  }
  let flavor = reader.read_u32_be()
  let _length = reader.read_u32_be()
  let num_tables = reader.read_u16_be().reinterpret_as_int()
  let _reserved = reader.read_u16_be()
  let _total_sfnt_size = reader.read_u32_be()
  let total_compressed_size = reader.read_u32_be()
  let _major_version = reader.read_u16_be()
  let _minor_version = reader.read_u16_be()
  let _meta_offset = reader.read_u32_be()
  let _meta_length = reader.read_u32_be()
  let _meta_orig_length = reader.read_u32_be()
  let _priv_offset = reader.read_u32_be()
  let _priv_length = reader.read_u32_be()
  // Parse table directory
  let entries : Array[Woff2TableEntry] = []
  let mut stream_offset = 0
  for _ in 0..<num_tables {
    let flag_byte = reader.read_byte().to_uint()
    let tag_index = flag_byte & 0x3FU
    let tag = if tag_index == 0x3FU {
      reader.read_u32_be()
    } else {
      if tag_index.reinterpret_as_int() >= woff2_known_tags.length() {
        raise @error.FTError::InvalidTable
      }
      woff2_known_tags[tag_index.reinterpret_as_int()]
    }
    let xform_version = (flag_byte >> 6) & 0x03U
    let is_glyf_or_loca = tag == @types.TAG_GLYF || tag == @types.TAG_LOCA
    let transformed = if is_glyf_or_loca {
      xform_version == 0U
    } else {
      xform_version != 0U
    }
    let orig_length = read_base128(reader)
    let transform_length = if transformed {
      read_base128(reader)
    } else {
      orig_length
    }
    let flags = (if transformed { 0x100U } else { 0U }) | xform_version
    let src_offset = stream_offset
    entries.push({ tag, flags, orig_length, transform_length, src_offset })
    stream_offset += transform_length.reinterpret_as_int()
  }
  // Read and decompress the compressed data stream
  let compressed_offset = reader.position()
  let compressed_data = data[compressed_offset:compressed_offset +
  total_compressed_size.reinterpret_as_int()].to_bytes()
  let uncompressed = @brotli.decompress(compressed_data) catch {
    _ => raise @error.FTError::InvalidTable
  }
  if uncompressed.length() < stream_offset {
    raise @error.FTError::InvalidTable
  }
  // Check for transformed glyf/loca
  let mut glyf_index = -1
  let mut loca_index = -1
  for i, entry in entries {
    if entry.tag == @types.TAG_GLYF {
      glyf_index = i
    }
    if entry.tag == @types.TAG_LOCA {
      loca_index = i
    }
  }
  let glyf_is_transformed = glyf_index >= 0 &&
    (entries[glyf_index].flags & 0x100U) != 0U
  // Pre-reconstruct transformed glyf/loca if needed
  let glyf_loca_data : (Bytes, Bytes)? = if glyf_is_transformed &&
    glyf_index >= 0 &&
    loca_index >= 0 {
    let glyf_entry = entries[glyf_index]
    let loca_entry = entries[loca_index]
    let (glyf_data, loca_data, _x_mins) = reconstruct_glyf(
      uncompressed,
      glyf_entry.src_offset,
      glyf_entry.transform_length.reinterpret_as_int(),
      loca_entry.orig_length.reinterpret_as_int(),
    )
    Some((glyf_data, loca_data))
  } else {
    None
  }
  // Build SFNT: use a two-pass approach
  // Pass 1: compute table sizes and offsets
  let sfnt_header_size = 12 + num_tables * 16
  let table_offsets : Array[Int] = []
  let table_lengths : Array[Int] = []
  let mut dest_offset = sfnt_header_size
  for i, entry in entries {
    dest_offset = (dest_offset + 3) & -4
    table_offsets.push(dest_offset)
    let actual_length = if glyf_is_transformed && entry.tag == @types.TAG_GLYF {
      match glyf_loca_data {
        Some((glyf_data, _)) => glyf_data.length()
        None => entry.orig_length.reinterpret_as_int()
      }
    } else if glyf_is_transformed && entry.tag == @types.TAG_LOCA {
      match glyf_loca_data {
        Some((_, loca_data)) => loca_data.length()
        None => entry.orig_length.reinterpret_as_int()
      }
    } else {
      entry.orig_length.reinterpret_as_int()
    }
    table_lengths.push(actual_length)
    ignore(i)
    dest_offset += actual_length
  }
  let total_size = (dest_offset + 3) & -4
  // Pass 2: build SFNT
  let sfnt = FixedArray::make(total_size, b'\x00')
  // SFNT header
  write_u32_be(sfnt, 0, flavor)
  write_u16_be(sfnt, 4, num_tables.reinterpret_as_uint())
  let (sr, es) = for sr = 1, es = 0; sr * 2 <= num_tables; {
    continue sr * 2, es + 1
  } nobreak {
    (sr * 16, es)
  }
  write_u16_be(sfnt, 6, sr.reinterpret_as_uint())
  write_u16_be(sfnt, 8, es.reinterpret_as_uint())
  write_u16_be(sfnt, 10, (num_tables * 16 - sr).reinterpret_as_uint())
  // Copy/reconstruct tables
  for i, entry in entries {
    let table_offset = table_offsets[i]
    let actual_length = table_lengths[i]
    let is_transformed = (entry.flags & 0x100U) != 0U
    if is_transformed && entry.tag == @types.TAG_GLYF {
      // Copy reconstructed glyf
      match glyf_loca_data {
        Some((glyf_data, _)) =>
          for j in 0..<actual_length {
            sfnt[table_offset + j] = glyf_data[j]
          }
        None => ()
      }
    } else if is_transformed && entry.tag == @types.TAG_LOCA {
      // Copy reconstructed loca
      match glyf_loca_data {
        Some((_, loca_data)) =>
          for j in 0..<actual_length {
            sfnt[table_offset + j] = loca_data[j]
          }
        None => ()
      }
    } else if is_transformed {
      // Other transformed tables (hmtx) — not yet supported
      raise @error.FTError::UnimplementedFeature
    } else {
      // Non-transformed: copy from uncompressed stream
      let src = entry.src_offset
      let copy_len = if entry.transform_length.reinterpret_as_int() <
        actual_length {
        entry.transform_length.reinterpret_as_int()
      } else {
        actual_length
      }
      for j in 0..<copy_len {
        sfnt[table_offset + j] = uncompressed[src + j]
      }
    }
    // Compute checksum from the final data
    let result = Bytes::from_array(sfnt[:])
    let checksum = compute_checksum(result, table_offset, actual_length)
    // Write table record
    let rec_offset = 12 + i * 16
    write_u32_be(sfnt, rec_offset, entry.tag)
    write_u32_be(sfnt, rec_offset + 4, checksum)
    write_u32_be(sfnt, rec_offset + 8, table_offset.reinterpret_as_uint())
    write_u32_be(sfnt, rec_offset + 12, actual_length.reinterpret_as_uint())
  }
  Bytes::from_array(sfnt[:])
}
