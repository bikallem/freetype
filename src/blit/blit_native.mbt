///|
/// Fast byte-level blit using libc memmove (vectorized).
/// FixedArray[Byte] has the same memory layout as Bytes in native backend.
#borrow(dst, src)
pub extern "c" fn blit_fixed_array(
  dst : FixedArray[Byte],
  dst_offset : Int,
  src : FixedArray[Byte],
  src_offset : Int,
  length : Int,
) -> Unit = "bikallem_freetype_blit_blit_fixed_array"

///|
/// Copy `length` bytes from `src` (Bytes) at `src_offset` into `dst` (FixedArray) at `dst_offset`.
/// Uses memmove on native backend, safe for overlapping regions.
#borrow(dst, src)
pub extern "c" fn blit_bytes(
  dst : FixedArray[Byte],
  dst_offset : Int,
  src : Bytes,
  src_offset : Int,
  length : Int,
) -> Unit = "bikallem_freetype_blit_blit_fixed_array"

///|
/// Fill a byte array region with a single byte value (vectorized memset).
#borrow(dst)
pub extern "c" fn fill_bytes(
  dst : FixedArray[Byte],
  dst_offset : Int,
  value : Byte,
  length : Int,
) -> Unit = "bikallem_freetype_blit_fill_bytes"

///|
/// Allocate a FixedArray[Byte] without zeroing memory.
/// The caller MUST fully initialize the buffer before reading from it.
pub extern "c" fn make_uninit(len : Int) -> FixedArray[Byte] = "bikallem_freetype_blit_make_uninit"
