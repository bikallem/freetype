///|
let png_signature : Bytes = b"\x89PNG\r\n\x1A\n"

///|
struct PngPaletteEntry {
  red : Int
  green : Int
  blue : Int
  alpha : Int
} derive(Show)

///|
struct PngTruecolorTransparent {
  red : Int
  green : Int
  blue : Int
} derive(Show)

///|
fn paeth_predictor(a : Int, b : Int, c : Int) -> Int {
  let p = a + b - c
  let pa = if p >= a { p - a } else { a - p }
  let pb = if p >= b { p - b } else { b - p }
  let pc = if p >= c { p - c } else { c - p }
  if pa <= pb && pa <= pc {
    a
  } else if pb <= pc {
    b
  } else {
    c
  }
}

///|
fn png_crc32_update(crc : UInt, byte : Byte) -> UInt {
  let mut value = crc ^ byte.to_uint()
  for _ in 0..<8 {
    value = if (value & 1U) != 0U {
      (value >> 1) ^ 0xEDB8_8320U
    } else {
      value >> 1
    }
  }
  value
}

///|
fn png_chunk_crc(tag : UInt, data : Bytes) -> UInt {
  let mut crc = 0xFFFF_FFFFU
  crc = png_crc32_update(crc, ((tag >> 24) & 0xFFU).to_byte())
  crc = png_crc32_update(crc, ((tag >> 16) & 0xFFU).to_byte())
  crc = png_crc32_update(crc, ((tag >> 8) & 0xFFU).to_byte())
  crc = png_crc32_update(crc, (tag & 0xFFU).to_byte())
  for _, byte in data {
    crc = png_crc32_update(crc, byte)
  }
  crc ^ 0xFFFF_FFFFU
}

///|
fn is_png_critical_chunk(tag : UInt) -> Bool {
  let first = ((tag >> 24) & 0xFFU).to_int()
  first >= 'A'.to_int() && first <= 'Z'.to_int()
}

///|
fn read_png_chunk(
  reader : @stream.ByteReader,
) -> (UInt, UInt, Bytes) raise @error.FTError {
  let length = reader.read_u32_be()
  let tag = reader.read_u32_be()
  let data = reader.read_bytes(length.reinterpret_as_int())
  let expected_crc = reader.read_u32_be()
  if png_chunk_crc(tag, data) != expected_crc {
    raise @error.FTError::InvalidFileFormat
  }
  (length, tag, data)
}

///|
fn png_samples_per_pixel(color_type : Int) -> Int raise @error.FTError {
  match color_type {
    0 => 1
    2 => 3
    3 => 1
    4 => 2
    6 => 4
    _ => raise @error.FTError::InvalidFileFormat
  }
}

///|
fn png_bit_depth_supported(color_type : Int, bit_depth : Int) -> Bool {
  match color_type {
    0 =>
      bit_depth == 1 ||
      bit_depth == 2 ||
      bit_depth == 4 ||
      bit_depth == 8 ||
      bit_depth == 16
    2 => bit_depth == 8 || bit_depth == 16
    3 => bit_depth == 1 || bit_depth == 2 || bit_depth == 4 || bit_depth == 8
    4 => bit_depth == 8 || bit_depth == 16
    6 => bit_depth == 8 || bit_depth == 16
    _ => false
  }
}

///|
fn png_row_bytes(width : Int, bits_per_pixel : Int) -> Int {
  if width <= 0 || bits_per_pixel <= 0 {
    0
  } else {
    (width * bits_per_pixel + 7) / 8
  }
}

///|
fn png_max_sample(bit_depth : Int) -> Int {
  if bit_depth >= 16 {
    65535
  } else {
    (1 << bit_depth) - 1
  }
}

///|
fn scale_sample_to_byte(sample : Int, bit_depth : Int) -> Int {
  if bit_depth == 8 {
    sample
  } else {
    let max_sample = png_max_sample(bit_depth)
    (sample * 255 + max_sample / 2) / max_sample
  }
}

///|
fn adam7_pass_extent(size : Int, start : Int, step : Int) -> Int {
  if size <= start {
    0
  } else {
    (size - start + step - 1) / step
  }
}

///|
fn png_pass_geometry(pass : Int) -> (Int, Int, Int, Int) {
  match pass {
    0 => (0, 0, 8, 8)
    1 => (4, 0, 8, 8)
    2 => (0, 4, 4, 8)
    3 => (2, 0, 4, 4)
    4 => (0, 2, 2, 4)
    5 => (1, 0, 2, 2)
    _ => (0, 1, 1, 2)
  }
}

///|
fn unfilter_scanlines(
  data : Bytes,
  row_bytes : Int,
  rows : Int,
  bytes_per_pixel : Int,
) -> Bytes raise @error.FTError {
  let expected = rows * (row_bytes + 1)
  if data.length() < expected {
    raise @error.FTError::InvalidFileFormat
  }
  let raw = FixedArray::make(rows * row_bytes, b'\x00')
  for row in 0..<rows {
    let filter = data[row * (row_bytes + 1)].to_int()
    let src_base = row * (row_bytes + 1) + 1
    let dst_base = row * row_bytes
    for i in 0..<row_bytes {
      let x = data[src_base + i].to_int()
      let left = if i >= bytes_per_pixel {
        raw[dst_base + i - bytes_per_pixel].to_int()
      } else {
        0
      }
      let up = if row > 0 { raw[dst_base + i - row_bytes].to_int() } else { 0 }
      let up_left = if row > 0 && i >= bytes_per_pixel {
        raw[dst_base + i - row_bytes - bytes_per_pixel].to_int()
      } else {
        0
      }
      raw[dst_base + i] = match filter {
        0 => x.to_byte()
        1 => ((x + left) & 0xFF).to_byte()
        2 => ((x + up) & 0xFF).to_byte()
        3 => ((x + ((left + up) >> 1)) & 0xFF).to_byte()
        4 => ((x + paeth_predictor(left, up, up_left)) & 0xFF).to_byte()
        _ => raise @error.FTError::InvalidFileFormat
      }
    }
  }
  Bytes::from_array(raw[:])
}

///|
fn read_sample(
  row : Bytes,
  sample_index : Int,
  bit_depth : Int,
) -> Int raise @error.FTError {
  match bit_depth {
    1 | 2 | 4 => {
      let bit_offset = sample_index * bit_depth
      let byte_index = bit_offset >> 3
      if byte_index >= row.length() {
        raise @error.FTError::InvalidFileFormat
      }
      let shift = 8 - bit_depth - (bit_offset & 7)
      (row[byte_index].to_int() >> shift) & ((1 << bit_depth) - 1)
    }
    8 => {
      if sample_index >= row.length() {
        raise @error.FTError::InvalidFileFormat
      }
      row[sample_index].to_int()
    }
    16 => {
      let offset = sample_index * 2
      if offset + 1 >= row.length() {
        raise @error.FTError::InvalidFileFormat
      }
      (row[offset].to_int() << 8) | row[offset + 1].to_int()
    }
    _ => raise @error.FTError::InvalidFileFormat
  }
}

///|
fn write_premul_bgra(
  out : FixedArray[Byte],
  pixel_index : Int,
  red : Int,
  green : Int,
  blue : Int,
  alpha : Int,
) -> Unit {
  let dst = pixel_index * 4
  out[dst] = premul_channel(blue, alpha)
  out[dst + 1] = premul_channel(green, alpha)
  out[dst + 2] = premul_channel(red, alpha)
  out[dst + 3] = alpha.to_byte()
}

///|
fn build_palette_entries(
  palette_bytes : Bytes?,
  transparency_bytes : Bytes?,
) -> Array[PngPaletteEntry] raise @error.FTError {
  let entries : Array[PngPaletteEntry] = []
  match palette_bytes {
    Some(plte) => {
      if plte.length() == 0 || plte.length() % 3 != 0 {
        raise @error.FTError::InvalidFileFormat
      }
      let trns = match transparency_bytes {
        Some(v) => v
        None => b""
      }
      for i in 0..<(plte.length() / 3) {
        let alpha = if i < trns.length() { trns[i].to_int() } else { 255 }
        entries.push({
          red: plte[i * 3].to_int(),
          green: plte[i * 3 + 1].to_int(),
          blue: plte[i * 3 + 2].to_int(),
          alpha,
        })
      }
    }
    None => ()
  }
  entries
}

///|
fn decode_png_row_to_bgra(
  row : Bytes,
  row_width : Int,
  color_type : Int,
  bit_depth : Int,
  palette : Array[PngPaletteEntry],
  transparent_gray : Int?,
  transparent_rgb : PngTruecolorTransparent?,
  out : FixedArray[Byte],
  full_width : Int,
  row_index : Int,
  start_x : Int,
  start_y : Int,
  step_x : Int,
  step_y : Int,
) -> Unit raise @error.FTError {
  let samples_per_pixel = png_samples_per_pixel(color_type)
  for x in 0..<row_width {
    let (red, green, blue, alpha) = match color_type {
      0 => {
        let gray = read_sample(row, x, bit_depth)
        let alpha = match transparent_gray {
          Some(v) => if gray == v { 0 } else { 255 }
          None => 255
        }
        let scaled = scale_sample_to_byte(gray, bit_depth)
        (scaled, scaled, scaled, alpha)
      }
      2 => {
        let base = x * samples_per_pixel
        let red = read_sample(row, base, bit_depth)
        let green = read_sample(row, base + 1, bit_depth)
        let blue = read_sample(row, base + 2, bit_depth)
        let alpha = match transparent_rgb {
          Some(v) =>
            if red == v.red && green == v.green && blue == v.blue {
              0
            } else {
              255
            }
          None => 255
        }
        (
          scale_sample_to_byte(red, bit_depth),
          scale_sample_to_byte(green, bit_depth),
          scale_sample_to_byte(blue, bit_depth),
          alpha,
        )
      }
      3 => {
        let index = read_sample(row, x, bit_depth)
        if index < 0 || index >= palette.length() {
          raise @error.FTError::InvalidFileFormat
        }
        let entry = palette[index]
        (entry.red, entry.green, entry.blue, entry.alpha)
      }
      4 => {
        let base = x * samples_per_pixel
        let gray = scale_sample_to_byte(
          read_sample(row, base, bit_depth),
          bit_depth,
        )
        let alpha = scale_sample_to_byte(
          read_sample(row, base + 1, bit_depth),
          bit_depth,
        )
        (gray, gray, gray, alpha)
      }
      6 => {
        let base = x * samples_per_pixel
        (
          scale_sample_to_byte(read_sample(row, base, bit_depth), bit_depth),
          scale_sample_to_byte(read_sample(row, base + 1, bit_depth), bit_depth),
          scale_sample_to_byte(read_sample(row, base + 2, bit_depth), bit_depth),
          scale_sample_to_byte(read_sample(row, base + 3, bit_depth), bit_depth),
        )
      }
      _ => raise @error.FTError::InvalidFileFormat
    }
    let full_x = start_x + x * step_x
    let full_y = start_y + row_index * step_y
    if full_x < 0 || full_x >= full_width {
      continue
    }
    let pixel_index = full_y * full_width + full_x
    write_premul_bgra(out, pixel_index, red, green, blue, alpha)
  }
}

///|
fn decode_png_image_data(
  raw : Bytes,
  width : Int,
  height : Int,
  color_type : Int,
  bit_depth : Int,
  interlace : Int,
  palette : Array[PngPaletteEntry],
  transparent_gray : Int?,
  transparent_rgb : PngTruecolorTransparent?,
) -> Bytes raise @error.FTError {
  let out = FixedArray::make(width * height * 4, b'\x00')
  let samples_per_pixel = png_samples_per_pixel(color_type)
  let bits_per_pixel = samples_per_pixel * bit_depth
  let bytes_per_pixel = if bit_depth >= 8 {
    (bits_per_pixel + 7) / 8
  } else {
    1
  }
  let mut raw_offset = 0
  let pass_count = if interlace == 0 { 1 } else { 7 }
  for pass in 0..<pass_count {
    let (start_x, start_y, step_x, step_y) = if interlace == 0 {
      (0, 0, 1, 1)
    } else {
      png_pass_geometry(pass)
    }
    let pass_width = adam7_pass_extent(width, start_x, step_x)
    let pass_height = adam7_pass_extent(height, start_y, step_y)
    if pass_width <= 0 || pass_height <= 0 {
      continue
    }
    let row_bytes = png_row_bytes(pass_width, bits_per_pixel)
    let expected = pass_height * (row_bytes + 1)
    if raw_offset + expected > raw.length() {
      raise @error.FTError::InvalidFileFormat
    }
    let filtered = unfilter_scanlines(
      raw[raw_offset:raw_offset + expected].to_bytes(),
      row_bytes,
      pass_height,
      bytes_per_pixel,
    )
    raw_offset += expected
    for row in 0..<pass_height {
      let row_start = row * row_bytes
      let row_bytes_data = filtered[row_start:row_start + row_bytes].to_bytes()
      decode_png_row_to_bgra(
        row_bytes_data, pass_width, color_type, bit_depth, palette, transparent_gray,
        transparent_rgb, out, width, row, start_x, start_y, step_x, step_y,
      )
    }
  }
  Bytes::from_array(out[:])
}

///|
pub fn decode_png_to_bgra(data : Bytes) -> PngImage raise @error.FTError {
  if data.length() < png_signature.length() {
    raise @error.FTError::InvalidFileFormat
  }
  for i in 0..<png_signature.length() {
    if data[i] != png_signature[i] {
      raise @error.FTError::InvalidFileFormat
    }
  }
  let reader = @stream.ByteReader::new(data)
  reader.skip(png_signature.length())

  let mut width = 0
  let mut height = 0
  let mut bit_depth = 0
  let mut color_type = 0
  let mut interlace = 0
  let mut saw_ihdr = false
  let mut saw_iend = false
  let mut palette_bytes : Bytes? = None
  let mut transparency_bytes : Bytes? = None
  let mut transparent_gray : Int? = None
  let mut transparent_rgb : PngTruecolorTransparent? = None
  let idat_parts : Array[Bytes] = []

  while reader.remaining() > 0 && !saw_iend {
    let (_length, tag, chunk_data) = read_png_chunk(reader)
    match tag {
      0x49484452U => {
        if chunk_data.length() != 13 {
          raise @error.FTError::InvalidFileFormat
        }
        let chunk_reader = @stream.ByteReader::new(chunk_data)
        width = chunk_reader.read_u32_be().reinterpret_as_int()
        height = chunk_reader.read_u32_be().reinterpret_as_int()
        bit_depth = chunk_reader.read_byte().to_int()
        color_type = chunk_reader.read_byte().to_int()
        let compression = chunk_reader.read_byte().to_int()
        let filter_method = chunk_reader.read_byte().to_int()
        interlace = chunk_reader.read_byte().to_int()
        if width <= 0 ||
          height <= 0 ||
          compression != 0 ||
          filter_method != 0 ||
          (interlace != 0 && interlace != 1) ||
          !png_bit_depth_supported(color_type, bit_depth) {
          raise @error.FTError::InvalidFileFormat
        }
        saw_ihdr = true
      }
      0x504C5445U => palette_bytes = Some(chunk_data)
      0x74524E53U => transparency_bytes = Some(chunk_data)
      0x49444154U => idat_parts.push(chunk_data)
      0x49454E44U => saw_iend = true
      _ =>
        if is_png_critical_chunk(tag) {
          raise @error.FTError::InvalidFileFormat
        }
    }
  }

  if !saw_ihdr || !saw_iend || idat_parts.is_empty() {
    raise @error.FTError::InvalidFileFormat
  }

  let palette = build_palette_entries(palette_bytes, transparency_bytes)
  if color_type == 3 && palette.is_empty() {
    raise @error.FTError::InvalidFileFormat
  }
  if color_type == 0 {
    match transparency_bytes {
      Some(v) =>
        if v.length() >= 2 {
          transparent_gray = Some((v[0].to_int() << 8) | v[1].to_int())
        }
      None => ()
    }
  } else if color_type == 2 {
    match transparency_bytes {
      Some(v) =>
        if v.length() >= 6 {
          transparent_rgb = Some({
            red: (v[0].to_int() << 8) | v[1].to_int(),
            green: (v[2].to_int() << 8) | v[3].to_int(),
            blue: (v[4].to_int() << 8) | v[5].to_int(),
          })
        }
      None => ()
    }
  }

  let mut total_idat_len = 0
  for part in idat_parts {
    total_idat_len += part.length()
  }
  let compressed = FixedArray::make(total_idat_len, b'\x00')
  let mut pos = 0
  for part in idat_parts {
    for i in 0..<part.length() {
      compressed[pos + i] = part[i]
    }
    pos += part.length()
  }
  let raw = @zlib.decompress(Bytes::from_array(compressed[:])) catch {
    _ => raise @error.FTError::InvalidFileFormat
  }
  PngImage::new(
    width,
    height,
    decode_png_image_data(
      raw, width, height, color_type, bit_depth, interlace, palette, transparent_gray,
      transparent_rgb,
    ),
  )
}
