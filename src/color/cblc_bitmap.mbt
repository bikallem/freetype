///|
fn cblc_row_pitch(width : Int, bit_depth : Int) -> Int {
  if width <= 0 || bit_depth <= 0 {
    0
  } else if bit_depth == 8 {
    width
  } else {
    (width * bit_depth + 7) >> 3
  }
}

///|
fn cblc_pixel_mode(bit_depth : Int) -> @types.PixelMode raise @error.FTError {
  match bit_depth {
    1 => @types.PixelMode::Mono
    2 => @types.PixelMode::Gray2
    4 => @types.PixelMode::Gray4
    8 => @types.PixelMode::Gray
    _ => raise @error.FTError::UnimplementedFeature
  }
}

///|
fn cblc_num_grays(bit_depth : Int) -> UInt raise @error.FTError {
  match bit_depth {
    1 => 2U
    2 => 4U
    4 => 16U
    8 => 256U
    _ => raise @error.FTError::UnimplementedFeature
  }
}

///|
fn decode_packed_sbit_pixels(
  data : Bytes,
  width : Int,
  height : Int,
  bit_depth : Int,
  byte_aligned : Bool,
) -> FixedArray[Byte] raise @error.FTError {
  let pixels = FixedArray::make(width * height, b'\x00')
  if width <= 0 || height <= 0 {
    return pixels
  }
  let mask = if bit_depth >= 8 { 0xFF } else { (1 << bit_depth) - 1 }
  if byte_aligned {
    let row_pitch = cblc_row_pitch(width, bit_depth)
    if data.length() < row_pitch * height {
      raise @error.FTError::InvalidTable
    }
    for row in 0..<height {
      let row_offset = row * row_pitch
      if bit_depth == 8 {
        for x in 0..<width {
          pixels[row * width + x] = data[row_offset + x]
        }
      } else {
        for x in 0..<width {
          let bit_offset = x * bit_depth
          let byte_index = row_offset + (bit_offset >> 3)
          let shift = 8 - bit_depth - (bit_offset & 7)
          pixels[row * width + x] = ((data[byte_index].to_int() >> shift) & mask).to_byte()
        }
      }
    }
    return pixels
  }

  let total_bits = width * height * bit_depth
  if data.length() * 8 < total_bits {
    raise @error.FTError::InvalidTable
  }
  let mut bit_index = 0
  for row in 0..<height {
    for x in 0..<width {
      let byte_index = bit_index >> 3
      let bit_shift = 8 - bit_depth - (bit_index & 7)
      let sample = if bit_shift >= 0 {
        (data[byte_index].to_int() >> bit_shift) & mask
      } else {
        let hi_bits = 8 - (bit_index & 7)
        let lo_bits = bit_depth - hi_bits
        let hi = (data[byte_index].to_int() & ((1 << hi_bits) - 1)) << lo_bits
        let lo = data[byte_index + 1].to_int() >> (8 - lo_bits)
        (hi | lo) & mask
      }
      pixels[row * width + x] = sample.to_byte()
      bit_index += bit_depth
    }
  }
  pixels
}

///|
fn pack_sbit_pixels(
  width : Int,
  height : Int,
  bit_depth : Int,
  pixels : FixedArray[Byte],
) -> Bytes {
  let pitch = cblc_row_pitch(width, bit_depth)
  let out = FixedArray::make(pitch * height, b'\x00')
  if bit_depth == 8 {
    for row in 0..<height {
      for x in 0..<width {
        out[row * pitch + x] = pixels[row * width + x]
      }
    }
    return Bytes::from_array(out[:])
  }
  let mask = (1 << bit_depth) - 1
  for row in 0..<height {
    for x in 0..<width {
      let sample = pixels[row * width + x].to_int() & mask
      let bit_offset = x * bit_depth
      let byte_index = row * pitch + (bit_offset >> 3)
      let shift = 8 - bit_depth - (bit_offset & 7)
      if shift >= 0 {
        out[byte_index] = (out[byte_index].to_int() | (sample << shift)).to_byte()
      } else {
        let hi_bits = 8 - (bit_offset & 7)
        let lo_bits = bit_depth - hi_bits
        out[byte_index] = (out[byte_index].to_int() | (sample >> lo_bits)).to_byte()
        out[byte_index + 1] = (out[byte_index + 1].to_int() |
        ((sample & ((1 << lo_bits) - 1)) << (8 - lo_bits))).to_byte()
      }
    }
  }
  Bytes::from_array(out[:])
}

///|
fn make_sbit_bitmap(
  width : Int,
  height : Int,
  bit_depth : Int,
  pixels : FixedArray[Byte],
) -> @types.Bitmap raise @error.FTError {
  let bitmap = @types.Bitmap::new()
  bitmap.set_width(if width > 0 { width.reinterpret_as_uint() } else { 0U })
  bitmap.set_rows(if height > 0 { height.reinterpret_as_uint() } else { 0U })
  bitmap.set_pitch(cblc_row_pitch(width, bit_depth))
  bitmap.set_num_grays(cblc_num_grays(bit_depth))
  bitmap.set_pixel_mode(cblc_pixel_mode(bit_depth))
  bitmap.set_buffer(pack_sbit_pixels(width, height, bit_depth, pixels))
  bitmap
}
