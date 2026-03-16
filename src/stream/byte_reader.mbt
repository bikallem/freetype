///|
/// ByteReader: position-tracked reader over immutable `Bytes`.
/// Replaces C's FT_Stream for in-memory font data.
///
/// Supports two modes:
/// 1. Direct reads: read_byte(), read_u16_be(), etc. — validate bounds per read.
/// 2. Frame reads: enter_frame(size) pre-validates a region, then get_byte(),
///    get_u16_be(), etc. read from the frame cursor without per-read bounds checks.
pub(all) struct ByteReader {
  data : Bytes
  size : Int
  mut pos : Int
  // Frame state: when inside a frame, cursor/limit are set.
  mut frame_start : Int
  mut frame_size : Int
  mut cursor : Int
} derive(Show)

///|
pub fn ByteReader::new(data : Bytes) -> ByteReader {
  let size = data.length()
  {
    data,
    size,
    pos: 0,
    frame_start: 0,
    frame_size: 0,
    cursor: -1, // -1 means not in a frame
  }
}

///|
/// Current position in the stream.
pub fn ByteReader::position(self : ByteReader) -> Int {
  self.pos
}

///|
/// Total size of the underlying data.
pub fn ByteReader::length(self : ByteReader) -> Int {
  self.size
}

///|
/// Remaining bytes from current position.
pub fn ByteReader::remaining(self : ByteReader) -> Int {
  self.size - self.pos
}

///|
/// Whether we're currently inside a frame.
pub fn ByteReader::in_frame(self : ByteReader) -> Bool {
  self.cursor >= 0
}

// ---------------------------------------------------------------------------
// Navigation
// ---------------------------------------------------------------------------

///|
/// Seek to an absolute position.
pub fn ByteReader::seek(
  self : ByteReader,
  pos : Int,
) -> Unit raise @error.FTError {
  if pos < 0 || pos > self.size {
    raise @error.FTError::InvalidStreamSeek
  }
  self.pos = pos
}

///|
/// Skip forward by `distance` bytes.
pub fn ByteReader::skip(
  self : ByteReader,
  distance : Int,
) -> Unit raise @error.FTError {
  if distance < 0 {
    raise @error.FTError::InvalidStreamSkip
  }
  let new_pos = self.pos + distance
  if new_pos > self.size {
    raise @error.FTError::InvalidStreamSkip
  }
  self.pos = new_pos
}

// ---------------------------------------------------------------------------
// Direct reads (position-based, with bounds checking)
// ---------------------------------------------------------------------------

///|
pub fn ByteReader::read_byte(self : ByteReader) -> Byte raise @error.FTError {
  if self.pos >= self.size {
    raise @error.FTError::InvalidStreamRead
  }
  let v = self.data[self.pos]
  self.pos += 1
  v
}

///|
/// Read 2 bytes big-endian as UInt.
pub fn ByteReader::read_u16_be(self : ByteReader) -> UInt raise @error.FTError {
  if self.pos + 2 > self.size {
    raise @error.FTError::InvalidStreamRead
  }
  let b0 = self.data[self.pos]
  let b1 = self.data[self.pos + 1]
  self.pos += 2
  (b0.to_uint() << 8) | b1.to_uint()
}

///|
/// Read 2 bytes little-endian as UInt.
pub fn ByteReader::read_u16_le(self : ByteReader) -> UInt raise @error.FTError {
  if self.pos + 2 > self.size {
    raise @error.FTError::InvalidStreamRead
  }
  let b0 = self.data[self.pos]
  let b1 = self.data[self.pos + 1]
  self.pos += 2
  b0.to_uint() | (b1.to_uint() << 8)
}

///|
/// Read 2 bytes big-endian as signed Int (sign-extended from 16 bits).
pub fn ByteReader::read_i16_be(self : ByteReader) -> Int raise @error.FTError {
  let v = self.read_u16_be()
  let raw = v.reinterpret_as_int()
  if raw >= 0x8000 {
    raw - 0x10000
  } else {
    raw
  }
}

///|
/// Read 3 bytes big-endian as UInt.
pub fn ByteReader::read_u24_be(self : ByteReader) -> UInt raise @error.FTError {
  if self.pos + 3 > self.size {
    raise @error.FTError::InvalidStreamRead
  }
  let b0 = self.data[self.pos]
  let b1 = self.data[self.pos + 1]
  let b2 = self.data[self.pos + 2]
  self.pos += 3
  (b0.to_uint() << 16) | (b1.to_uint() << 8) | b2.to_uint()
}

///|
/// Read 4 bytes big-endian as UInt.
pub fn ByteReader::read_u32_be(self : ByteReader) -> UInt raise @error.FTError {
  if self.pos + 4 > self.size {
    raise @error.FTError::InvalidStreamRead
  }
  let b0 = self.data[self.pos]
  let b1 = self.data[self.pos + 1]
  let b2 = self.data[self.pos + 2]
  let b3 = self.data[self.pos + 3]
  self.pos += 4
  (b0.to_uint() << 24) |
  (b1.to_uint() << 16) |
  (b2.to_uint() << 8) |
  b3.to_uint()
}

///|
/// Read 4 bytes little-endian as UInt.
pub fn ByteReader::read_u32_le(self : ByteReader) -> UInt raise @error.FTError {
  if self.pos + 4 > self.size {
    raise @error.FTError::InvalidStreamRead
  }
  let b0 = self.data[self.pos]
  let b1 = self.data[self.pos + 1]
  let b2 = self.data[self.pos + 2]
  let b3 = self.data[self.pos + 3]
  self.pos += 4
  b0.to_uint() |
  (b1.to_uint() << 8) |
  (b2.to_uint() << 16) |
  (b3.to_uint() << 24)
}

///|
/// Read 4 bytes big-endian as signed Int.
pub fn ByteReader::read_i32_be(self : ByteReader) -> Int raise @error.FTError {
  self.read_u32_be().reinterpret_as_int()
}

///|
/// Read `count` bytes into a new Bytes.
pub fn ByteReader::read_bytes(
  self : ByteReader,
  count : Int,
) -> Bytes raise @error.FTError {
  if count < 0 || self.pos + count > self.size {
    raise @error.FTError::InvalidStreamRead
  }
  let result = self.data[self.pos:self.pos + count].to_bytes()
  self.pos += count
  result
}

// ---------------------------------------------------------------------------
// Frame API (pre-validated region, unchecked inner reads)
// ---------------------------------------------------------------------------

///|
/// Enter a frame of `count` bytes at the current position.
/// Pre-validates that the region is within bounds.
pub fn ByteReader::enter_frame(
  self : ByteReader,
  count : Int,
) -> Unit raise @error.FTError {
  if self.cursor >= 0 {
    raise @error.FTError::NestedFrameAccess
  }
  if count < 0 || self.pos + count > self.size {
    raise @error.FTError::InvalidFrameOperation
  }
  self.frame_start = self.pos
  self.frame_size = count
  self.cursor = self.pos
  self.pos += count
}

///|
/// Exit the current frame.
pub fn ByteReader::exit_frame(self : ByteReader) -> Unit {
  self.cursor = -1
  self.frame_size = 0
}

///|
/// Bytes remaining in current frame.
pub fn ByteReader::frame_remaining(self : ByteReader) -> Int {
  if self.cursor < 0 {
    return 0
  }
  self.frame_start + self.frame_size - self.cursor
}

///|
/// Read a byte from the frame cursor (no bounds check).
pub fn ByteReader::get_byte(self : ByteReader) -> Byte {
  let v = self.data[self.cursor]
  self.cursor += 1
  v
}

///|
/// Read 2 bytes big-endian from frame cursor.
pub fn ByteReader::get_u16_be(self : ByteReader) -> UInt {
  let b0 = self.data[self.cursor]
  let b1 = self.data[self.cursor + 1]
  self.cursor += 2
  (b0.to_uint() << 8) | b1.to_uint()
}

///|
/// Read 2 bytes little-endian from frame cursor.
pub fn ByteReader::get_u16_le(self : ByteReader) -> UInt {
  let b0 = self.data[self.cursor]
  let b1 = self.data[self.cursor + 1]
  self.cursor += 2
  b0.to_uint() | (b1.to_uint() << 8)
}

///|
/// Read 2 bytes big-endian signed from frame cursor.
pub fn ByteReader::get_i16_be(self : ByteReader) -> Int {
  let v = self.get_u16_be().reinterpret_as_int()
  if v >= 0x8000 {
    v - 0x10000
  } else {
    v
  }
}

///|
/// Read 3 bytes big-endian from frame cursor.
pub fn ByteReader::get_u24_be(self : ByteReader) -> UInt {
  let b0 = self.data[self.cursor]
  let b1 = self.data[self.cursor + 1]
  let b2 = self.data[self.cursor + 2]
  self.cursor += 3
  (b0.to_uint() << 16) | (b1.to_uint() << 8) | b2.to_uint()
}

///|
/// Read 4 bytes big-endian from frame cursor.
pub fn ByteReader::get_u32_be(self : ByteReader) -> UInt {
  let b0 = self.data[self.cursor]
  let b1 = self.data[self.cursor + 1]
  let b2 = self.data[self.cursor + 2]
  let b3 = self.data[self.cursor + 3]
  self.cursor += 4
  (b0.to_uint() << 24) |
  (b1.to_uint() << 16) |
  (b2.to_uint() << 8) |
  b3.to_uint()
}

///|
/// Read 4 bytes little-endian from frame cursor.
pub fn ByteReader::get_u32_le(self : ByteReader) -> UInt {
  let b0 = self.data[self.cursor]
  let b1 = self.data[self.cursor + 1]
  let b2 = self.data[self.cursor + 2]
  let b3 = self.data[self.cursor + 3]
  self.cursor += 4
  b0.to_uint() |
  (b1.to_uint() << 8) |
  (b2.to_uint() << 16) |
  (b3.to_uint() << 24)
}

///|
/// Read 4 bytes big-endian signed from frame cursor.
pub fn ByteReader::get_i32_be(self : ByteReader) -> Int {
  self.get_u32_be().reinterpret_as_int()
}

///|
/// Read 8 bytes big-endian as Int64 from frame cursor.
pub fn ByteReader::get_i64_be(self : ByteReader) -> Int64 {
  let hi = self.get_u32_be().to_int64()
  let lo = self.get_u32_be().to_int64()
  (hi << 32) | (lo & 0xFFFFFFFFL)
}

///|
/// Skip `count` bytes within the current frame.
pub fn ByteReader::frame_skip(self : ByteReader, count : Int) -> Unit {
  self.cursor += count
}

///|
/// Extract `count` bytes from the current frame as Bytes.
pub fn ByteReader::get_bytes(self : ByteReader, count : Int) -> Bytes {
  let result = self.data[self.cursor:self.cursor + count].to_bytes()
  self.cursor += count
  result
}
