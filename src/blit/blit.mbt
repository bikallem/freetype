///|
/// Copy `length` bytes from `src` (BytesView) at `src_offset` into `dst` (FixedArray) at `dst_offset`.
/// Note: `src_offset` is relative to the underlying Bytes, not the view's start.
pub fn blit_bytesview(
  dst : FixedArray[Byte],
  dst_offset : Int,
  src : BytesView,
  src_offset : Int,
  length : Int,
) -> Unit {
  blit_bytes(dst, dst_offset, src.bytes(), src_offset, length)
}

///|
fn BytesView::bytes(self : BytesView) -> Bytes = "%bytesview.bytes"
