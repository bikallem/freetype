///|
/// Copy `length` bytes between FixedArray[Byte] buffers.
/// Safe for overlapping regions within the same array.
pub fn blit_fixed_array(
  dst : FixedArray[Byte],
  dst_offset : Int,
  src : FixedArray[Byte],
  src_offset : Int,
  length : Int,
) -> Unit {
  FixedArray::unsafe_blit(dst, dst_offset, src, src_offset, length)
}

///|
/// Copy `length` bytes from `src` (Bytes) at `src_offset` into `dst` (FixedArray) at `dst_offset`.
pub fn blit_bytes(
  dst : FixedArray[Byte],
  dst_offset : Int,
  src : Bytes,
  src_offset : Int,
  length : Int,
) -> Unit {
  dst.blit_from_bytes(dst_offset, src, src_offset, length)
}

///|
/// Fill `length` bytes in `dst` starting at `dst_offset` with `value`.
pub fn fill_bytes(
  dst : FixedArray[Byte],
  dst_offset : Int,
  value : Byte,
  length : Int,
) -> Unit {
  for i in 0..<length {
    dst[dst_offset + i] = value
  }
}

///|
/// Allocate a FixedArray[Byte] without zeroing memory.
/// The caller MUST fully initialize the buffer before reading from it.
pub fn make_uninit(len : Int) -> FixedArray[Byte] {
  FixedArray::make(len, b'\x00')
}
