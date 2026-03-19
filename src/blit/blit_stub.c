#include <string.h>
#include "moonbit.h"

// Fast byte array blit using memmove (vectorized by libc).
// FixedArray[Byte] has the same layout as Bytes (moonbit_bytes_t).
MOONBIT_FFI_EXPORT void bikallem_freetype_blit_blit_fixed_array(
    moonbit_bytes_t dst, int32_t dst_off,
    moonbit_bytes_t src, int32_t src_off,
    int32_t len) {
  memmove(dst + dst_off, src + src_off, (size_t)len);
}

// Fill a byte array region with a single byte value (vectorized memset).
MOONBIT_FFI_EXPORT void bikallem_freetype_blit_fill_bytes(
    moonbit_bytes_t dst, int32_t dst_off,
    uint8_t val, int32_t len) {
  memset(dst + dst_off, val, (size_t)len);
}

// Allocate a FixedArray[Byte] without zeroing.
// Uses moonbit_make_bytes_raw which skips memset.
MOONBIT_EXPORT moonbit_bytes_t moonbit_make_bytes_raw(int32_t len);

MOONBIT_FFI_EXPORT moonbit_bytes_t bikallem_freetype_blit_make_uninit(
    int32_t len) {
  return moonbit_make_bytes_raw(len);
}
