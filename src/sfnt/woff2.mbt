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
  let mut src_offset = 0U
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
    // Determine if table is transformed
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
    entries.push({ tag, flags, orig_length, transform_length })
    src_offset = src_offset + transform_length
  }
  // Read and decompress the compressed data stream
  let compressed_offset = reader.position()
  let compressed_data = data[compressed_offset:compressed_offset +
    total_compressed_size.reinterpret_as_int()].to_bytes()
  let uncompressed = @brotli.decompress(compressed_data) catch {
    _ => raise @error.FTError::InvalidTable
  }
  if uncompressed.length() < src_offset.reinterpret_as_int() {
    raise @error.FTError::InvalidTable
  }
  // Build SFNT output
  let sfnt_header_size = 12 + num_tables * 16
  // Compute total SFNT size
  let mut total_size = sfnt_header_size
  for entry in entries {
    total_size = (total_size + 3) & -4 // align to 4
    total_size += entry.orig_length.reinterpret_as_int()
  }
  total_size = (total_size + 3) & -4
  let sfnt = FixedArray::make(total_size, b'\x00')
  // Write SFNT header
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
  // Copy tables from uncompressed stream to SFNT
  let mut uncompressed_pos = 0
  for i = 0, table_offset = sfnt_header_size; i < num_tables; {
    let entry = entries[i]
    let table_offset = (table_offset + 3) & -4
    let is_transformed = (entry.flags & 0x100U) != 0U
    if is_transformed {
      // Transformed glyf/loca/hmtx — not yet supported, skip source data
      // and write zeros (will produce invalid font for TT with transforms)
      raise @error.FTError::UnimplementedFeature
    }
    // Non-transformed: copy directly from uncompressed stream
    let src_len = entry.transform_length.reinterpret_as_int()
    let orig_len = entry.orig_length.reinterpret_as_int()
    let copy_len = if src_len < orig_len { src_len } else { orig_len }
    for j in 0..<copy_len {
      sfnt[table_offset + j] = uncompressed[uncompressed_pos + j]
    }
    // Compute checksum
    let mut checksum = 0U
    let aligned = copy_len & -4
    let mut k = 0
    while k < aligned {
      let c = (sfnt[table_offset + k].to_uint() << 24) |
        (sfnt[table_offset + k + 1].to_uint() << 16) |
        (sfnt[table_offset + k + 2].to_uint() << 8) |
        sfnt[table_offset + k + 3].to_uint()
      checksum = checksum + c
      k += 4
    }
    let mut shift = 24
    while k < copy_len {
      checksum = checksum + (sfnt[table_offset + k].to_uint() << shift)
      k += 1
      shift -= 8
    }
    // Write table record in SFNT directory
    let rec_offset = 12 + i * 16
    write_u32_be(sfnt, rec_offset, entry.tag)
    write_u32_be(sfnt, rec_offset + 4, checksum)
    write_u32_be(sfnt, rec_offset + 8, table_offset.reinterpret_as_uint())
    write_u32_be(sfnt, rec_offset + 12, entry.orig_length)
    uncompressed_pos += src_len
    continue i + 1, table_offset + orig_len
  }
  Bytes::from_array(sfnt[:])
}
