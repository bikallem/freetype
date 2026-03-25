///|
/// WOFF2 transformed glyf/loca table reconstruction.
/// See https://www.w3.org/TR/WOFF2/#glyf_table_format

// Glyf point flags (TrueType spec)
let glyf_on_curve : Byte = b'\x01'

let glyf_x_short : Byte = b'\x02'

let glyf_y_short : Byte = b'\x04'

let glyf_repeat : Byte = b'\x08'

let glyf_this_x_is_same : Byte = b'\x10'

let glyf_this_y_is_same : Byte = b'\x20'

let glyf_overlap_simple : Byte = b'\x40'

// Composite glyph flags
let flag_arg_1_and_2_are_words : Int = 1

let flag_we_have_a_scale : Int = 1 << 3

let flag_more_components : Int = 1 << 5

let flag_we_have_an_x_and_y_scale : Int = 1 << 6

let flag_we_have_a_two_by_two : Int = 1 << 7

let flag_we_have_instructions : Int = 1 << 8

// Substream indices
let n_contour_stream : Int = 0

let n_points_stream : Int = 1

let flag_stream : Int = 2

let glyph_stream : Int = 3

let composite_stream : Int = 4

let bbox_stream : Int = 5

let instruction_stream : Int = 6

// Offset to endPoint array in glyph buffer (after nContours + bbox = 2+8=10)
let contour_offset_end_point : Int = 10

///|
priv struct Woff2Point {
  x : Int
  y : Int
  on_curve : Bool
}

///|
priv struct Woff2Substream {
  start : Int
  mut offset : Int
  size : Int
}

///|
/// Decode triplet-encoded points.
/// See https://www.w3.org/TR/WOFF2/#triplet_decoding
fn triplet_decode(
  flags_buf : Bytes,
  flags_offset : Int,
  glyph_buf : Bytes,
  glyph_offset : Int,
  glyph_size : Int,
  n_points : Int,
) -> (Array[Woff2Point], Int) raise @error.FTError {
  let points : Array[Woff2Point] = []
  let mut x = 0
  let mut y = 0
  let mut triplet_index = 0
  for i in 0..<n_points {
    let flag = flags_buf[flags_offset + i].to_int()
    let on_curve = (flag >> 7) == 0
    let f = flag & 0x7F
    let data_bytes = if f < 84 {
      1
    } else if f < 120 {
      2
    } else if f < 124 {
      3
    } else {
      4
    }
    if triplet_index + data_bytes > glyph_size {
      raise @error.FTError::InvalidTable
    }
    let base = glyph_offset + triplet_index
    let (dx, dy) : (Int, Int) = if f < 10 {
      let val = ((f & 14) << 7) + glyph_buf[base].to_int()
      (0, if (f & 1) != 0 { val } else { -val })
    } else if f < 20 {
      let val = (((f - 10) & 14) << 7) + glyph_buf[base].to_int()
      (if (f & 1) != 0 { val } else { -val }, 0)
    } else if f < 84 {
      let b0 = f - 20
      let b1 = glyph_buf[base].to_int()
      let vx = 1 + (b0 & 0x30) + (b1 >> 4)
      let vy = 1 + ((b0 & 0x0C) << 2) + (b1 & 0x0F)
      (
        if (f & 1) != 0 { vx } else { -vx },
        if (f & 2) != 0 { vy } else { -vy },
      )
    } else if f < 120 {
      let b0 = f - 84
      let vx = 1 + ((b0 / 12) << 8) + glyph_buf[base].to_int()
      let vy = 1 + (((b0 % 12) >> 2) << 8) + glyph_buf[base + 1].to_int()
      (
        if (f & 1) != 0 { vx } else { -vx },
        if (f & 2) != 0 { vy } else { -vy },
      )
    } else if f < 124 {
      let b2 = glyph_buf[base + 1].to_int()
      let vx = (glyph_buf[base].to_int() << 4) + (b2 >> 4)
      let vy = ((b2 & 0x0F) << 8) + glyph_buf[base + 2].to_int()
      (
        if (f & 1) != 0 { vx } else { -vx },
        if (f & 2) != 0 { vy } else { -vy },
      )
    } else {
      let vx = (glyph_buf[base].to_int() << 8) + glyph_buf[base + 1].to_int()
      let vy = (glyph_buf[base + 2].to_int() << 8) +
        glyph_buf[base + 3].to_int()
      (
        if (f & 1) != 0 { vx } else { -vx },
        if (f & 2) != 0 { vy } else { -vy },
      )
    }
    triplet_index += data_bytes
    x += dx
    y += dy
    points.push({ x, y, on_curve })
  }
  (points, triplet_index)
}

///|
/// Compute bbox from decoded points and write to glyph buffer at offset 2.
fn compute_bbox(
  points : Array[Woff2Point],
  dst : FixedArray[Byte],
  dst_offset : Int,
) -> Int {
  // Returns x_min as UInt16 (for hmtx reconstruction)
  let mut x_min = 0
  let mut y_min = 0
  let mut x_max = 0
  let mut y_max = 0
  if points.length() > 0 {
    x_min = points[0].x
    y_min = points[0].y
    x_max = points[0].x
    y_max = points[0].y
    for i in 1..<points.length() {
      let p = points[i]
      if p.x < x_min { x_min = p.x }
      if p.y < y_min { y_min = p.y }
      if p.x > x_max { x_max = p.x }
      if p.y > y_max { y_max = p.y }
    }
  }
  let off = dst_offset + 2 // skip nContours
  write_i16_be(dst, off, x_min)
  write_i16_be(dst, off + 2, y_min)
  write_i16_be(dst, off + 4, x_max)
  write_i16_be(dst, off + 6, y_max)
  x_min
}

///|
fn write_i16_be(buf : FixedArray[Byte], offset : Int, value : Int) -> Unit {
  buf[offset] = ((value >> 8) & 0xFF).to_byte()
  buf[offset + 1] = (value & 0xFF).to_byte()
}

///|
/// Store decoded points as TrueType glyf flags + coordinates.
fn store_points(
  points : Array[Woff2Point],
  n_contours : Int,
  instruction_len : Int,
  have_overlap : Bool,
  dst : FixedArray[Byte],
  dst_size : Int,
) -> Int raise @error.FTError {
  let mut flag_offset = 10 + (2 * n_contours) + 2 + instruction_len
  let mut last_flag : Int = 0xFF
  let mut repeat_count = 0
  let mut last_x = 0
  let mut last_y = 0
  let mut x_bytes = 0
  let mut y_bytes = 0
  // First pass: compute flags and count coordinate bytes
  for i, point in points {
    let mut flag : Int = if point.on_curve {
      glyf_on_curve.to_int()
    } else {
      0
    }
    let dx = point.x - last_x
    let dy = point.y - last_y
    if i == 0 && have_overlap {
      flag = flag | glyf_overlap_simple.to_int()
    }
    if dx == 0 {
      flag = flag | glyf_this_x_is_same.to_int()
    } else if dx > -256 && dx < 256 {
      flag = flag |
        glyf_x_short.to_int() |
        (if dx > 0 { glyf_this_x_is_same.to_int() } else { 0 })
      x_bytes += 1
    } else {
      x_bytes += 2
    }
    if dy == 0 {
      flag = flag | glyf_this_y_is_same.to_int()
    } else if dy > -256 && dy < 256 {
      flag = flag |
        glyf_y_short.to_int() |
        (if dy > 0 { glyf_this_y_is_same.to_int() } else { 0 })
      y_bytes += 1
    } else {
      y_bytes += 2
    }
    if flag == last_flag && repeat_count != 255 {
      dst[flag_offset - 1] = (dst[flag_offset - 1].to_int() |
        glyf_repeat.to_int()).to_byte()
      repeat_count += 1
    } else {
      if repeat_count != 0 {
        if flag_offset >= dst_size {
          raise @error.FTError::InvalidTable
        }
        dst[flag_offset] = repeat_count.to_byte()
        flag_offset += 1
      }
      if flag_offset >= dst_size {
        raise @error.FTError::InvalidTable
      }
      dst[flag_offset] = flag.to_byte()
      flag_offset += 1
      repeat_count = 0
    }
    last_x = point.x
    last_y = point.y
    last_flag = flag
  }
  if repeat_count != 0 {
    if flag_offset >= dst_size {
      raise @error.FTError::InvalidTable
    }
    dst[flag_offset] = repeat_count.to_byte()
    flag_offset += 1
  }
  // Second pass: write coordinate data
  let mut x_offset = flag_offset
  let mut y_offset = flag_offset + x_bytes
  if flag_offset + x_bytes + y_bytes > dst_size {
    raise @error.FTError::InvalidTable
  }
  last_x = 0
  last_y = 0
  for point in points {
    let dx = point.x - last_x
    let dy = point.y - last_y
    if dx != 0 {
      if dx > -256 && dx < 256 {
        dst[x_offset] = (if dx < 0 { -dx } else { dx }).to_byte()
        x_offset += 1
      } else {
        write_i16_be(dst, x_offset, dx)
        x_offset += 2
      }
    }
    last_x += dx
    if dy != 0 {
      if dy > -256 && dy < 256 {
        dst[y_offset] = (if dy < 0 { -dy } else { dy }).to_byte()
        y_offset += 1
      } else {
        write_i16_be(dst, y_offset, dy)
        y_offset += 2
      }
    }
    last_y += dy
  }
  y_offset // final glyph size
}

///|
/// Calculate composite glyph size by scanning component flags.
fn composite_glyph_size(
  data : Bytes,
  offset : Int,
) -> (Int, Bool) {
  let mut pos = offset
  let mut have_instructions = false
  let mut flags = flag_more_components
  while (flags & flag_more_components) != 0 {
    flags = (data[pos].to_int() << 8) | data[pos + 1].to_int()
    have_instructions = have_instructions ||
      (flags & flag_we_have_instructions) != 0
    pos += 2
    // glyph index
    let mut arg_size = 2
    if (flags & flag_arg_1_and_2_are_words) != 0 {
      arg_size += 4
    } else {
      arg_size += 2
    }
    if (flags & flag_we_have_a_scale) != 0 {
      arg_size += 2
    } else if (flags & flag_we_have_an_x_and_y_scale) != 0 {
      arg_size += 4
    } else if (flags & flag_we_have_a_two_by_two) != 0 {
      arg_size += 8
    }
    pos += arg_size
  }
  (pos - offset, have_instructions)
}

///|
/// Reconstruct transformed glyf and loca tables from WOFF2 substreams.
/// Returns (glyf_data, loca_data, x_mins).
pub fn reconstruct_glyf(
  data : Bytes,
  glyf_offset : Int,
  glyf_transform_length : Int,
  loca_dst_length : Int,
) -> (Bytes, Bytes, Array[Int]) raise @error.FTError {
  let reader = @stream.ByteReader::new(data)
  reader.seek(glyf_offset)
  // Read transformed glyf header
  let _reserved = reader.read_u16_be()
  let option_flags = reader.read_u16_be()
  let num_glyphs = reader.read_u16_be().reinterpret_as_int()
  let index_format = reader.read_u16_be().reinterpret_as_int()
  // Validate loca length
  let expected_loca_length = (if index_format != 0 { 4 } else { 2 }) *
    (num_glyphs + 1)
  if loca_dst_length != expected_loca_length {
    raise @error.FTError::InvalidTable
  }
  // Read 7 substream sizes
  let num_substreams = 7
  let substreams : Array[Woff2Substream] = []
  let header_size = 2 + 2 + 2 + 2 + (num_substreams * 4)
  let mut offset = header_size
  for _ in 0..<num_substreams {
    let size = reader.read_u32_be().reinterpret_as_int()
    if size > glyf_transform_length - offset {
      raise @error.FTError::InvalidTable
    }
    substreams.push({ start: glyf_offset + offset, offset: glyf_offset + offset, size })
    offset += size
  }
  // Handle overlap bitmap
  let have_overlap_bitmap = (option_flags & 0x1U) != 0U
  let overlap_bitmap_offset = if have_overlap_bitmap {
    let obo = glyf_offset + offset
    let overlap_len = (num_glyphs + 7) >> 3
    offset += overlap_len
    obo
  } else {
    0
  }
  // bbox bitmap
  let bbox_bitmap_offset = substreams[bbox_stream].offset
  let bbox_bitmap_length = ((num_glyphs + 31) >> 5) << 2
  substreams[bbox_stream].offset += bbox_bitmap_length
  // Output buffers
  let loca_values : Array[Int] = Array::new(capacity=num_glyphs + 1)
  let x_mins : Array[Int] = Array::new(capacity=num_glyphs)
  let glyf_buf = @blit.Buffer::new()
  for i in 0..<num_glyphs {
    // Check bbox bitmap
    let have_bbox = {
      let byte_off = bbox_bitmap_offset + (i >> 3)
      let bitmap_byte = data[byte_off].to_int()
      (bitmap_byte & (0x80 >> (i & 7))) != 0
    }
    // Read nContours from N_CONTOUR_STREAM
    let n_contours_pos = substreams[n_contour_stream].offset
    let n_contours = (data[n_contours_pos].to_int() << 8) |
      data[n_contours_pos + 1].to_int()
    substreams[n_contour_stream].offset += 2
    if n_contours == 0xFFFF {
      // Composite glyph
      if !have_bbox {
        raise @error.FTError::InvalidTable
      }
      let (comp_size, have_instructions) = composite_glyph_size(
        data,
        substreams[composite_stream].offset,
      )
      let mut instruction_size = 0
      if have_instructions {
        let gs = substreams[glyph_stream].offset
        instruction_size = read_255ushort(
          @stream.ByteReader::new(data[gs:gs + 3].to_bytes()),
        ).reinterpret_as_int()
        // Advance glyph_stream past the 255UShort
        let tmp_reader = @stream.ByteReader::new(data)
        tmp_reader.seek(gs)
        let _ = read_255ushort(tmp_reader)
        substreams[glyph_stream].offset = tmp_reader.position()
      }
      // Build glyph
      let glyph_size = 10 + comp_size + (if have_instructions { 2 + instruction_size } else { 0 })
      let glyph = FixedArray::make(glyph_size, b'\x00')
      // nContours = -1 (0xFFFF)
      write_i16_be(glyph, 0, -1)
      // bbox from stream
      let bbox_off = substreams[bbox_stream].offset
      for j in 0..<8 {
        glyph[2 + j] = data[bbox_off + j]
      }
      substreams[bbox_stream].offset += 8
      let x_min = (data[bbox_off].to_int() << 8) | data[bbox_off + 1].to_int()
      let x_min_signed = if x_min >= 0x8000 { x_min - 0x10000 } else { x_min }
      x_mins.push(x_min_signed)
      // composite data
      let cs = substreams[composite_stream].offset
      for j in 0..<comp_size {
        glyph[10 + j] = data[cs + j]
      }
      substreams[composite_stream].offset += comp_size
      // instructions
      if have_instructions {
        let inst_off = 10 + comp_size
        write_i16_be(glyph, inst_off, instruction_size)
        let is_off = substreams[instruction_stream].offset
        for j in 0..<instruction_size {
          glyph[inst_off + 2 + j] = data[is_off + j]
        }
        substreams[instruction_stream].offset += instruction_size
      }
      loca_values.push(glyf_buf.length())
      glyf_buf.write_fixed(glyph, 0, glyph_size)
      // Pad to 4 bytes
      let pad = (4 - (glyph_size & 3)) & 3
      for _ in 0..<pad {
        glyf_buf.write_byte(b'\x00')
      }
    } else if n_contours > 0 {
      // Simple glyph
      let have_overlap = if overlap_bitmap_offset != 0 {
        let ob = data[overlap_bitmap_offset + (i >> 3)].to_int()
        (ob & (0x80 >> (i & 7))) != 0
      } else {
        false
      }
      // Read nPoints per contour from N_POINTS_STREAM
      let n_points_arr : Array[Int] = []
      let mut total_n_points = 0
      let tmp_reader = @stream.ByteReader::new(data)
      tmp_reader.seek(substreams[n_points_stream].offset)
      for _ in 0..<n_contours {
        let np = read_255ushort(tmp_reader).reinterpret_as_int()
        n_points_arr.push(np)
        total_n_points += np
      }
      substreams[n_points_stream].offset = tmp_reader.position()
      // Decode triplets
      let (points, triplet_bytes_used) = triplet_decode(
        data,
        substreams[flag_stream].offset,
        data,
        substreams[glyph_stream].offset,
        substreams[glyph_stream].size -
          (substreams[glyph_stream].offset - substreams[glyph_stream].start),
        total_n_points,
      )
      substreams[flag_stream].offset += total_n_points
      substreams[glyph_stream].offset += triplet_bytes_used
      // Read instruction_size
      let gs_reader = @stream.ByteReader::new(data)
      gs_reader.seek(substreams[glyph_stream].offset)
      let instruction_size = read_255ushort(gs_reader).reinterpret_as_int()
      substreams[glyph_stream].offset = gs_reader.position()
      // Allocate glyph buffer (generous upper bound)
      let size_needed = 12 + (2 * n_contours) + (5 * total_n_points) +
        instruction_size
      let glyph = FixedArray::make(size_needed, b'\x00')
      // nContours
      write_i16_be(glyph, 0, n_contours)
      // bbox
      let x_min = if have_bbox {
        let bbox_off = substreams[bbox_stream].offset
        for j in 0..<8 {
          glyph[2 + j] = data[bbox_off + j]
        }
        substreams[bbox_stream].offset += 8
        let xm = (data[bbox_off].to_int() << 8) | data[bbox_off + 1].to_int()
        if xm >= 0x8000 { xm - 0x10000 } else { xm }
      } else {
        compute_bbox(points, glyph, 0)
      }
      x_mins.push(x_min)
      // endPoints
      let mut glyph_size = contour_offset_end_point
      let mut end_point = -1
      for j in 0..<n_contours {
        end_point += n_points_arr[j]
        write_i16_be(glyph, glyph_size, end_point)
        glyph_size += 2
      }
      // instruction length + instructions
      write_i16_be(glyph, glyph_size, instruction_size)
      glyph_size += 2
      let is_off = substreams[instruction_stream].offset
      for j in 0..<instruction_size {
        glyph[glyph_size + j] = data[is_off + j]
      }
      substreams[instruction_stream].offset += instruction_size
      glyph_size += instruction_size
      // Store flags + coordinates
      glyph_size = store_points(
        points,
        n_contours,
        instruction_size,
        have_overlap,
        glyph,
        size_needed,
      )
      loca_values.push(glyf_buf.length())
      glyf_buf.write_fixed(glyph, 0, glyph_size)
      // Pad to 4 bytes
      let pad = (4 - (glyph_size & 3)) & 3
      for _ in 0..<pad {
        glyf_buf.write_byte(b'\x00')
      }
    } else {
      // Empty glyph (n_contours == 0)
      if have_bbox {
        raise @error.FTError::InvalidTable
      }
      x_mins.push(0)
      loca_values.push(glyf_buf.length())
    }
  }
  // Final loca entry = total glyf length
  loca_values.push(glyf_buf.length())
  // Build loca table
  let loca_size = (if index_format != 0 { 4 } else { 2 }) * (num_glyphs + 1)
  let loca = FixedArray::make(loca_size, b'\x00')
  for i in 0..=num_glyphs {
    let value = loca_values[i]
    if index_format != 0 {
      write_u32_be(loca, i * 4, value.reinterpret_as_uint())
    } else {
      write_u16_be(loca, i * 2, (value >> 1).reinterpret_as_uint())
    }
  }
  let glyf_bytes = glyf_buf.to_bytes()
  let loca_bytes = Bytes::from_array(loca[:])
  (glyf_bytes, loca_bytes, x_mins)
}
