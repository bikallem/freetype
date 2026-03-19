///|
/// Horizontal metrics for a single glyph.
#valtype
struct LongHorMetric {
  advance_width : UInt
  lsb : Int // left side bearing
} derive(Eq, Show)

///|
pub fn LongHorMetric::new(advance_width~ : UInt, lsb~ : Int) -> LongHorMetric {
  { advance_width, lsb }
}

///|
/// Parsed 'hmtx' (horizontal metrics) table.
struct HmtxTable {
  metrics : Array[LongHorMetric] // number_of_h_metrics entries
  left_side_bearings : Array[Int] // remaining glyphs (num_glyphs - number_of_h_metrics)
} derive(Show)

///|
pub fn HmtxTable::new(
  metrics~ : Array[LongHorMetric],
  left_side_bearings~ : Array[Int],
) -> HmtxTable {
  { metrics, left_side_bearings }
}

///|
/// Parse the 'hmtx' table.
/// `num_h_metrics` comes from hhea.number_of_h_metrics.
/// `num_glyphs` comes from maxp.num_glyphs.
pub fn parse_hmtx(
  reader : @stream.ByteReader,
  offset : UInt,
  num_h_metrics : UInt,
  num_glyphs : UInt,
) -> HmtxTable raise @error.FTError {
  reader.seek(offset.reinterpret_as_int())
  let nh = num_h_metrics.reinterpret_as_int()
  let ng = num_glyphs.reinterpret_as_int()
  // Read longHorMetric entries: advance_width (u16) + lsb (i16)
  let metrics : Array[LongHorMetric] = Array::new(capacity=nh)
  for _ in 0..<nh {
    let advance_width = reader.read_u16_be()
    let lsb = reader.read_i16_be()
    metrics.push({ advance_width, lsb })
  }
  // Remaining glyphs share the last advance width, only have lsb
  let remaining = ng - nh
  let left_side_bearings : Array[Int] = Array::new(capacity=remaining)
  for _ in 0..<remaining {
    left_side_bearings.push(reader.read_i16_be())
  }
  { metrics, left_side_bearings }
}

///|
/// Get the advance width and LSB for a glyph index.
pub fn HmtxTable::get_metrics(
  self : HmtxTable,
  glyph_index : UInt,
) -> (UInt, Int) {
  let idx = glyph_index.reinterpret_as_int()
  let nh = self.metrics.length()
  if idx < nh {
    (self.metrics[idx].advance_width, self.metrics[idx].lsb)
  } else {
    // Use last advance width, lookup separate LSB
    let last_aw = if nh > 0 { self.metrics[nh - 1].advance_width } else { 0U }
    let lsb_idx = idx - nh
    let lsb = if lsb_idx < self.left_side_bearings.length() {
      self.left_side_bearings[lsb_idx]
    } else {
      0
    }
    (last_aw, lsb)
  }
}
