///|
let png_signature : Bytes = b"\x89PNG\r\n\x1A\n"

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
fn read_png_chunk(
  reader : @stream.ByteReader,
) -> (UInt, UInt, Bytes) raise @error.FTError {
  let length = reader.read_u32_be()
  let tag = reader.read_u32_be()
  let data = reader.read_bytes(length.reinterpret_as_int())
  ignore(reader.read_u32_be())
  (length, tag, data)
}

///|
fn decode_rgba_scanlines(
  data : Bytes,
  width : Int,
  height : Int,
  channels : Int,
) -> Bytes raise @error.FTError {
  let stride = width * channels
  let expected = height * (1 + stride)
  if data.length() < expected {
    raise @error.FTError::InvalidFileFormat
  }
  let raw = FixedArray::make(height * stride, b'\x00')
  for row in 0..<height {
    let filter = data[row * (stride + 1)].to_int()
    let src_base = row * (stride + 1) + 1
    let dst_base = row * stride
    for i in 0..<stride {
      let x = data[src_base + i].to_int()
      let left = if i >= channels {
        raw[dst_base + i - channels].to_int()
      } else {
        0
      }
      let up = if row > 0 { raw[dst_base + i - stride].to_int() } else { 0 }
      let up_left = if row > 0 && i >= channels {
        raw[dst_base + i - stride - channels].to_int()
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
fn rgba_to_premul_bgra(
  rgba : Bytes,
  width : Int,
  height : Int,
  channels : Int,
) -> Bytes {
  let out = FixedArray::make(width * height * 4, b'\x00')
  for i in 0..<(width * height) {
    let src = i * channels
    let dst = i * 4
    let red = rgba[src].to_int()
    let green = rgba[src + 1].to_int()
    let blue = rgba[src + 2].to_int()
    let alpha = if channels == 4 { rgba[src + 3].to_int() } else { 255 }
    out[dst] = premul_channel(blue, alpha)
    out[dst + 1] = premul_channel(green, alpha)
    out[dst + 2] = premul_channel(red, alpha)
    out[dst + 3] = alpha.to_byte()
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
  let mut channels = 0
  let idat_parts : Array[Bytes] = []
  let mut saw_ihdr = false
  let mut saw_iend = false

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
        let bit_depth = chunk_reader.read_byte().to_int()
        let color_type = chunk_reader.read_byte().to_int()
        let compression = chunk_reader.read_byte().to_int()
        let filter_method = chunk_reader.read_byte().to_int()
        let interlace = chunk_reader.read_byte().to_int()
        if width <= 0 ||
          height <= 0 ||
          bit_depth != 8 ||
          compression != 0 ||
          filter_method != 0 ||
          interlace != 0 {
          raise @error.FTError::InvalidFileFormat
        }
        channels = match color_type {
          2 => 3
          6 => 4
          _ => raise @error.FTError::UnimplementedFeature
        }
        saw_ihdr = true
      }
      0x49444154U => idat_parts.push(chunk_data)
      0x49454E44U => saw_iend = true
      _ => ()
    }
  }

  if !saw_ihdr || !saw_iend || idat_parts.is_empty() {
    raise @error.FTError::InvalidFileFormat
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
  let rgba = decode_rgba_scanlines(raw, width, height, channels)
  PngImage::new(
    width,
    height,
    rgba_to_premul_bgra(rgba, width, height, channels),
  )
}
