///|
/// Parse the 'loca' (Index to Location) table.
/// Maps glyph indices to byte offsets in the 'glyf' table.
/// `index_format` comes from head.index_to_loc_format:
///   0 = short format (offsets divided by 2, stored as UInt16)
///   1 = long format (offsets stored as UInt32)
pub fn parse_loca(
  reader : @stream.ByteReader,
  offset : UInt,
  length : UInt,
  num_glyphs : UInt,
  index_format : Int,
) -> Array[UInt] raise @error.FTError {
  reader.seek(offset.reinterpret_as_int())
  let ng = num_glyphs.reinterpret_as_int()
  // loca has numGlyphs + 1 entries (the extra one gives the end of the last glyph)
  let count = ng + 1
  let offsets : Array[UInt] = Array::new(capacity=count)
  ignore(length)
  if index_format == 0 {
    // Short format: each entry is UInt16, actual offset = value * 2
    for _ in 0..<count {
      let raw = reader.read_u16_be()
      offsets.push(raw * 2U)
    }
  } else {
    // Long format: each entry is UInt32
    for _ in 0..<count {
      offsets.push(reader.read_u32_be())
    }
  }
  offsets
}
