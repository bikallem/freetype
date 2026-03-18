///|
/// Parsed 'maxp' (maximum profile) table.
pub struct MaxpTable {
  version : UInt // 0x00005000 for CFF, 0x00010000 for TrueType
  num_glyphs : UInt
  // TrueType-specific fields (version 1.0):
  max_points : UInt
  max_contours : UInt
  max_composite_points : UInt
  max_composite_contours : UInt
  max_zones : UInt
  max_twilight_points : UInt
  max_storage : UInt
  max_function_defs : UInt
  max_instruction_defs : UInt
  max_stack_elements : UInt
  max_size_of_instructions : UInt
  max_component_elements : UInt
  max_component_depth : UInt
} derive(Show)

///|
/// Parse the 'maxp' table.
pub fn parse_maxp(
  reader : @stream.ByteReader,
  offset : UInt,
  length : UInt,
) -> MaxpTable raise @error.FTError {
  let len = length.reinterpret_as_int()
  if len < 6 {
    raise @error.FTError::InvalidTable
  }
  reader.seek(offset.reinterpret_as_int())
  let version = reader.read_u32_be()
  let num_glyphs = reader.read_u16_be()
  // CFF fonts (version 0.5) only have version + numGlyphs
  if version == 0x00005000U || len < 32 {
    return {
      version,
      num_glyphs,
      max_points: 0U,
      max_contours: 0U,
      max_composite_points: 0U,
      max_composite_contours: 0U,
      max_zones: 0U,
      max_twilight_points: 0U,
      max_storage: 0U,
      max_function_defs: 0U,
      max_instruction_defs: 0U,
      max_stack_elements: 0U,
      max_size_of_instructions: 0U,
      max_component_elements: 0U,
      max_component_depth: 0U,
    }
  }
  // TrueType version 1.0: 32 bytes total
  let max_points = reader.read_u16_be()
  let max_contours = reader.read_u16_be()
  let max_composite_points = reader.read_u16_be()
  let max_composite_contours = reader.read_u16_be()
  let max_zones = reader.read_u16_be()
  let max_twilight_points = reader.read_u16_be()
  let max_storage = reader.read_u16_be()
  let max_function_defs = reader.read_u16_be()
  let max_instruction_defs = reader.read_u16_be()
  let max_stack_elements = reader.read_u16_be()
  let max_size_of_instructions = reader.read_u16_be()
  let max_component_elements = reader.read_u16_be()
  let max_component_depth = reader.read_u16_be()
  {
    version,
    num_glyphs,
    max_points,
    max_contours,
    max_composite_points,
    max_composite_contours,
    max_zones,
    max_twilight_points,
    max_storage,
    max_function_defs,
    max_instruction_defs,
    max_stack_elements,
    max_size_of_instructions,
    max_component_elements,
    max_component_depth,
  }
}
