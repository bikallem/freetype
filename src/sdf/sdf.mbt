///|
struct Edge {
  horizontal : Bool
  start : Int
  end_ : Int
  fixed : Int
} derive(Show)

///|
fn coverage_at(bitmap : @types.Bitmap, x : Int, y : Int) -> Int {
  let width = bitmap.width().reinterpret_as_int()
  let rows = bitmap.rows().reinterpret_as_int()
  if x < 0 || y < 0 || x >= width || y >= rows {
    return 0
  }
  let pitch = if bitmap.pitch() < 0 { -bitmap.pitch() } else { bitmap.pitch() }
  let offset = y * pitch
  let buffer = bitmap.buffer()
  match bitmap.pixel_mode() {
    @types.PixelMode::Gray =>
      if offset + x < buffer.length() {
        buffer[offset + x].to_int()
      } else {
        0
      }
    @types.PixelMode::Mono => {
      let byte_offset = offset + (x >> 3)
      if byte_offset >= buffer.length() {
        0
      } else if (buffer[byte_offset] & (0x80 >> (x & 7)).to_byte()) != b'\x00' {
        255
      } else {
        0
      }
    }
    @types.PixelMode::Bgra => {
      let byte_offset = offset + x * 4 + 3
      if byte_offset < buffer.length() {
        buffer[byte_offset].to_int()
      } else {
        0
      }
    }
    _ => 0
  }
}

///|
fn build_occupancy(bitmap : @types.Bitmap) -> FixedArray[Bool] {
  let width = bitmap.width().reinterpret_as_int()
  let rows = bitmap.rows().reinterpret_as_int()
  let occupancy = FixedArray::make(width * rows, false)
  for y in 0..<rows {
    for x in 0..<width {
      occupancy[y * width + x] = coverage_at(bitmap, x, y) >= 128
    }
  }
  occupancy
}

///|
fn is_filled(
  occupancy : FixedArray[Bool],
  width : Int,
  rows : Int,
  x : Int,
  y : Int,
) -> Bool {
  if x < 0 || y < 0 || x >= width || y >= rows {
    return false
  }
  occupancy[y * width + x]
}

///|
fn build_edges(
  occupancy : FixedArray[Bool],
  width : Int,
  rows : Int,
) -> Array[Edge] {
  let edges : Array[Edge] = []
  for y in 0..<rows {
    for x in 0..<width {
      if !occupancy[y * width + x] {
        continue
      }
      if !is_filled(occupancy, width, rows, x, y - 1) {
        edges.push({ horizontal: true, start: x, end_: x + 1, fixed: y })
      }
      if !is_filled(occupancy, width, rows, x, y + 1) {
        edges.push({ horizontal: true, start: x, end_: x + 1, fixed: y + 1 })
      }
      if !is_filled(occupancy, width, rows, x - 1, y) {
        edges.push({ horizontal: false, start: y, end_: y + 1, fixed: x })
      }
      if !is_filled(occupancy, width, rows, x + 1, y) {
        edges.push({ horizontal: false, start: y, end_: y + 1, fixed: x + 1 })
      }
    }
  }
  edges
}

///|
fn clamp_double(value : Double, lower : Double, upper : Double) -> Double {
  if value < lower {
    lower
  } else if value > upper {
    upper
  } else {
    value
  }
}

///|
fn point_to_edge_distance(edge : Edge, px : Double, py : Double) -> Double {
  if edge.horizontal {
    let cx = clamp_double(px, edge.start.to_double(), edge.end_.to_double())
    let dx = px - cx
    let dy = py - edge.fixed.to_double()
    (dx * dx + dy * dy).sqrt()
  } else {
    let cy = clamp_double(py, edge.start.to_double(), edge.end_.to_double())
    let dx = px - edge.fixed.to_double()
    let dy = py - cy
    (dx * dx + dy * dy).sqrt()
  }
}

///|
fn pack_sdf_value(distance : Double, spread : Int) -> Byte {
  if spread <= 0 {
    return b'\x80'
  }
  let spread_d = spread.to_double()
  let mut value = (128.0 * (distance / spread_d + 1.0)).round().to_int()
  if value < 0 {
    value = 0
  } else if value > 255 {
    value = 255
  }
  value.to_byte()
}

///|
pub fn bitmap_to_sdf(
  bitmap : @types.Bitmap,
  left : Int,
  top : Int,
  spread : Int,
) -> (@types.Bitmap, Int, Int) {
  let width = bitmap.width().reinterpret_as_int()
  let rows = bitmap.rows().reinterpret_as_int()
  if width <= 0 || rows <= 0 || spread <= 0 {
    let empty = @types.Bitmap::new()
    empty.set_width(0U)
    empty.set_rows(0U)
    empty.set_pitch(0)
    empty.set_num_grays(256U)
    empty.set_pixel_mode(@types.PixelMode::Gray)
    empty.set_buffer(b"")
    return (empty, left, top)
  }

  let occupancy = build_occupancy(bitmap)
  let edges = build_edges(occupancy, width, rows)
  if edges.is_empty() {
    let empty = @types.Bitmap::new()
    empty.set_width(0U)
    empty.set_rows(0U)
    empty.set_pitch(0)
    empty.set_num_grays(256U)
    empty.set_pixel_mode(@types.PixelMode::Gray)
    empty.set_buffer(b"")
    return (empty, left, top)
  }

  let out_width = width + spread * 2
  let out_rows = rows + spread * 2
  let out = FixedArray::make(out_width * out_rows, b'\x00')
  for y in 0..<out_rows {
    let py = y.to_double() + 0.5 - spread.to_double()
    for x in 0..<out_width {
      let px = x.to_double() + 0.5 - spread.to_double()
      let mut min_dist = spread.to_double()
      for edge in edges {
        let dist = point_to_edge_distance(edge, px, py)
        if dist < min_dist {
          min_dist = dist
        }
      }
      let sx = px.floor().to_int()
      let sy = py.floor().to_int()
      let inside = sx >= 0 &&
        sy >= 0 &&
        sx < width &&
        sy < rows &&
        occupancy[sy * width + sx]
      let signed_dist = if inside { min_dist } else { -min_dist }
      out[y * out_width + x] = pack_sdf_value(signed_dist, spread)
    }
  }

  let sdf = @types.Bitmap::new()
  sdf.set_width(out_width.reinterpret_as_uint())
  sdf.set_rows(out_rows.reinterpret_as_uint())
  sdf.set_pitch(out_width)
  sdf.set_num_grays(256U)
  sdf.set_pixel_mode(@types.PixelMode::Gray)
  sdf.set_buffer(Bytes::from_array(out[:]))
  (sdf, left - spread, top + spread)
}
