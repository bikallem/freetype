///|
/// Result of validating an Apple Advanced Typography (AAT/GX) table.
pub(all) struct GxValidationResult {
  table_tag : UInt
  issues : Array[String]
} derive(Eq, Show)

///|
/// Validate an Apple 'feat' (feature name) table.
/// Checks: version, featureNameCount, and that the table is long enough.
pub fn validate_feat(
  reader : @stream.ByteReader,
  offset : UInt,
  length : UInt,
) -> GxValidationResult raise @error.FTError {
  let issues : Array[String] = []
  reader.seek(offset.reinterpret_as_int())
  if length.reinterpret_as_int() < 12 {
    issues.push("feat table too short")
    return { table_tag: @types.tag_feat, issues }
  }
  let version = reader.read_u32_be()
  if version != 0x00010000U {
    issues.push("feat: unexpected version \{version}")
  }
  let feature_name_count = reader.read_u16_be()
  let _reserved1 = reader.read_u16_be()
  let _reserved2 = reader.read_u32_be()
  // Each feature name entry is 12 bytes
  let expected_min_size = 12U + feature_name_count * 12U
  if length < expected_min_size {
    issues.push(
      "feat: table length \{length} too short for \{feature_name_count} entries",
    )
  }
  { table_tag: @types.tag_feat, issues }
}

///|
/// Validate an Apple-format kern table (stub).
/// Apple kern tables have a different format than the Microsoft kern table.
pub fn validate_kern_apple(
  reader : @stream.ByteReader,
  offset : UInt,
  length : UInt,
) -> GxValidationResult {
  let issues : Array[String] = []
  ignore(reader)
  ignore(offset)
  if length.reinterpret_as_int() < 8 {
    issues.push("Apple kern table too short")
  }
  { table_tag: @types.tag_kern, issues }
}
