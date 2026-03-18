///|
/// A single kerning pair.
pub struct KernPair {
  left : UInt // left glyph index
  right : UInt // right glyph index
  value : Int // kerning value in FUnits
} derive(Eq, Show)

///|
pub fn KernPair::new(left~ : UInt, right~ : UInt, value~ : Int) -> KernPair {
  { left, right, value }
}

///|
/// Parsed kern table (format 0 subtables only).
pub struct KernTable {
  pairs : Array[KernPair]
} derive(Show)

///|
pub fn KernTable::new(pairs~ : Array[KernPair]) -> KernTable {
  { pairs, }
}

///|
/// Parse the 'kern' table.
/// Supports the Microsoft kern table format with format 0 subtables.
pub fn parse_kern(
  reader : @stream.ByteReader,
  offset : UInt,
  length : UInt,
) -> KernTable raise @error.FTError {
  let len = length.reinterpret_as_int()
  if len < 4 {
    return { pairs: [] }
  }
  reader.seek(offset.reinterpret_as_int())
  let version = reader.read_u16_be()
  let pairs : Array[KernPair] = []
  match version {
    0U => {
      // Microsoft format: version(2), nTables(2)
      let n_tables = reader.read_u16_be().reinterpret_as_int()
      for _ in 0..<n_tables {
        let sub_version = reader.read_u16_be()
        let sub_length = reader.read_u16_be().reinterpret_as_int()
        let coverage = reader.read_u16_be()
        ignore(sub_version)
        // Format 0: ordered list of pairs
        let format = (coverage >> 8).reinterpret_as_int()
        let horizontal = (coverage & 1U) != 0U
        if format == 0 && horizontal {
          let n_pairs = reader.read_u16_be().reinterpret_as_int()
          let _search_range = reader.read_u16_be()
          let _entry_selector = reader.read_u16_be()
          let _range_shift = reader.read_u16_be()
          pairs.reserve_capacity(pairs.length() + n_pairs)
          for _ in 0..<n_pairs {
            let left = reader.read_u16_be()
            let right = reader.read_u16_be()
            let value = reader.read_i16_be()
            pairs.push({ left, right, value })
          }
        } else {
          // Skip unsupported subtable
          let remaining = sub_length - 6
          if remaining > 0 {
            reader.skip(remaining)
          }
        }
      }
    }
    1U => {
      // Apple format (version 1.0): version is actually u32
      let _version_lo = reader.read_u16_be()
      let n_tables = reader.read_u32_be().reinterpret_as_int()
      // Skip Apple kern subtables for now
      ignore(n_tables)
    }
    _ => ()
  }
  { pairs, }
}

///|
/// Look up kerning between two glyphs.
/// Uses binary search on the sorted pairs array.
pub fn KernTable::get_kerning(
  self : KernTable,
  left : UInt,
  right : UInt,
) -> Int {
  let key = (left.reinterpret_as_int() << 16) | right.reinterpret_as_int()
  for lo = 0, hi = self.pairs.length() - 1; lo <= hi; {
    let mid = (lo + hi) / 2
    let pair = self.pairs[mid]
    let pair_key = (pair.left.reinterpret_as_int() << 16) |
      pair.right.reinterpret_as_int()
    if key < pair_key {
      continue lo, mid - 1
    } else if key > pair_key {
      continue mid + 1, hi
    } else {
      return pair.value
    }
  } nobreak {
    0
  }
}
