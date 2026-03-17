///|
/// Result of a validation check.
pub(all) enum ValidationLevel {
  Valid
  Warning(String)
  Error(String)
} derive(Eq, Show)

///|
/// Validate an OpenType Coverage table starting at the given offset.
/// Coverage format 1: list of glyph IDs.
/// Coverage format 2: array of ranges.
pub fn validate_coverage(
  reader : @stream.ByteReader,
  offset : UInt,
) -> Array[ValidationLevel] raise @error.FTError {
  let results : Array[ValidationLevel] = []
  reader.seek(offset.reinterpret_as_int())
  let format = reader.read_u16_be()
  match format {
    1U => {
      let count = reader.read_u16_be()
      // Validate glyph IDs are in ascending order
      let mut prev : UInt = 0U
      for i = 0U; i < count; i = i + 1U {
        let glyph_id = reader.read_u16_be()
        if i > 0U && glyph_id <= prev {
          results.push(
            Warning("Coverage format 1: glyph IDs not in ascending order"),
          )
        }
        prev = glyph_id
      }
      results.push(Valid)
    }
    2U => {
      let count = reader.read_u16_be()
      for i = 0U; i < count; i = i + 1U {
        let start_glyph = reader.read_u16_be()
        let end_glyph = reader.read_u16_be()
        let _start_coverage_index = reader.read_u16_be()
        if end_glyph < start_glyph {
          results.push(
            Error("Coverage format 2: end glyph less than start glyph"),
          )
        }
      }
      results.push(Valid)
    }
    _ => results.push(Error("Coverage table: invalid format \{format}"))
  }
  results
}

///|
/// Validate an OpenType ClassDef table starting at the given offset.
/// ClassDef format 1: class array.
/// ClassDef format 2: class ranges.
pub fn validate_class_def(
  reader : @stream.ByteReader,
  offset : UInt,
) -> Array[ValidationLevel] raise @error.FTError {
  let results : Array[ValidationLevel] = []
  reader.seek(offset.reinterpret_as_int())
  let format = reader.read_u16_be()
  match format {
    1U => {
      let _start_glyph = reader.read_u16_be()
      let count = reader.read_u16_be()
      // Just validate we can read all class values
      for i = 0U; i < count; i = i + 1U {
        ignore(reader.read_u16_be())
      }
      results.push(Valid)
    }
    2U => {
      let count = reader.read_u16_be()
      for i = 0U; i < count; i = i + 1U {
        let start_glyph = reader.read_u16_be()
        let end_glyph = reader.read_u16_be()
        let _class_value = reader.read_u16_be()
        if end_glyph < start_glyph {
          results.push(
            Error("ClassDef format 2: end glyph less than start glyph"),
          )
        }
      }
      results.push(Valid)
    }
    _ => results.push(Error("ClassDef table: invalid format \{format}"))
  }
  results
}

///|
/// Validate GDEF table structure (stub — checks version only).
pub fn validate_gdef(
  reader : @stream.ByteReader,
  offset : UInt,
) -> Array[ValidationLevel] raise @error.FTError {
  let results : Array[ValidationLevel] = []
  reader.seek(offset.reinterpret_as_int())
  let major = reader.read_u16_be()
  let minor = reader.read_u16_be()
  if major != 1U {
    results.push(Error("GDEF: unsupported major version \{major}"))
  } else if minor > 3U {
    results.push(
      Warning("GDEF: minor version \{minor} may not be fully supported"),
    )
  } else {
    results.push(Valid)
  }
  results
}

///|
/// Validate GPOS table structure (stub — checks version only).
pub fn validate_gpos(
  reader : @stream.ByteReader,
  offset : UInt,
) -> Array[ValidationLevel] raise @error.FTError {
  let results : Array[ValidationLevel] = []
  reader.seek(offset.reinterpret_as_int())
  let major = reader.read_u16_be()
  let minor = reader.read_u16_be()
  if major != 1U {
    results.push(Error("GPOS: unsupported major version \{major}"))
  } else if minor > 1U {
    results.push(
      Warning("GPOS: minor version \{minor} may not be fully supported"),
    )
  } else {
    results.push(Valid)
  }
  results
}

///|
/// Validate GSUB table structure (stub — checks version only).
pub fn validate_gsub(
  reader : @stream.ByteReader,
  offset : UInt,
) -> Array[ValidationLevel] raise @error.FTError {
  let results : Array[ValidationLevel] = []
  reader.seek(offset.reinterpret_as_int())
  let major = reader.read_u16_be()
  let minor = reader.read_u16_be()
  if major != 1U {
    results.push(Error("GSUB: unsupported major version \{major}"))
  } else if minor > 1U {
    results.push(
      Warning("GSUB: minor version \{minor} may not be fully supported"),
    )
  } else {
    results.push(Valid)
  }
  results
}
