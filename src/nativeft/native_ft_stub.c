#define FT2_BUILD_LIBRARY
#define HAVE_UNISTD_H 1
#define HAVE_FCNTL_H 1
#define FT_CONFIG_MODULES_H "native_ftmodule.h"

#include <ft2build.h>
#include FT_FREETYPE_H
#include FT_TRUETYPE_TABLES_H
#include FT_COLOR_H
#include FT_GLYPH_H
#include FT_MULTIPLE_MASTERS_H
#include FT_BBOX_H

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "../../vendor/freetype-c/builds/unix/ftsystem.c"
#include "../../vendor/freetype-c/src/base/ftinit.c"
#include "../../vendor/freetype-c/src/base/ftbase.c"
#include "../../vendor/freetype-c/src/base/ftbitmap.c"
#include "../../vendor/freetype-c/src/base/ftglyph.c"
#include "../../vendor/freetype-c/src/base/ftmm.c"
#include "../../vendor/freetype-c/src/base/ftdebug.c"
#include "../../vendor/freetype-c/src/sfnt/sfnt.c"
#include "../../vendor/freetype-c/src/truetype/truetype.c"
#include "../../vendor/freetype-c/src/type1/type1.c"
#include "../../vendor/freetype-c/src/cff/cff.c"
#include "../../vendor/freetype-c/src/psaux/psaux.c"
#include "../../vendor/freetype-c/src/psnames/psnames.c"
#include "../../vendor/freetype-c/src/pshinter/pshinter.c"
#include "../../vendor/freetype-c/src/autofit/autofit.c"
#include "../../vendor/freetype-c/src/raster/raster.c"
#include "../../vendor/freetype-c/src/smooth/smooth.c"
#include "../../vendor/freetype-c/src/svg/svg.c"
#undef ONE_PIXEL
#include "../../vendor/freetype-c/src/sdf/sdf.c"
#include "../../vendor/freetype-c/src/bdf/bdf.c"
#include "../../vendor/freetype-c/src/pcf/pcf.c"
#include "../../vendor/freetype-c/src/gzip/ftgzip.c"
#include "../../vendor/freetype-c/src/lzw/ftlzw.c"

#ifdef BSWAP16
#undef BSWAP16
#endif
#ifdef BSWAP32
#undef BSWAP32
#endif
#include "moonbit.h"

typedef struct {
  FT_Library library;
  FT_Face face;
  FT_Byte* data_copy;
  FT_Long data_len;
  FT_Byte** attached_data;
  FT_Long* attached_lens;
  size_t attached_count;
  FT_Error last_error;
} NativeFtFace;

static void
bikallem_freetype_native_face_destroy(void* ptr) {
  NativeFtFace* handle = (NativeFtFace*)ptr;
  if (handle->face) {
    FT_Done_Face(handle->face);
    handle->face = NULL;
  }
  if (handle->library) {
    FT_Done_FreeType(handle->library);
    handle->library = NULL;
  }
  if (handle->data_copy) {
    libc_free(handle->data_copy);
    handle->data_copy = NULL;
  }
  if (handle->attached_data) {
    for (size_t i = 0; i < handle->attached_count; i++) {
      if (handle->attached_data[i]) {
        libc_free(handle->attached_data[i]);
      }
    }
    libc_free(handle->attached_data);
    handle->attached_data = NULL;
  }
  if (handle->attached_lens) {
    libc_free(handle->attached_lens);
    handle->attached_lens = NULL;
  }
}

static moonbit_bytes_t
make_bytes_copy(const FT_Byte* data, FT_ULong len) {
  moonbit_bytes_t out = moonbit_make_bytes((int32_t)len, 0);
  if (len > 0 && data) {
    memcpy(out, data, (size_t)len);
  }
  return out;
}

static moonbit_bytes_t
make_cstring_bytes(const char* s) {
  if (!s) {
    return moonbit_make_bytes(0, 0);
  }
  return make_bytes_copy((const FT_Byte*)s, (FT_ULong)strlen(s));
}

static int64_t*
make_int64_array(int32_t len) {
  return moonbit_make_int64_array_raw(len);
}

static int32_t*
make_int32_array(int32_t len) {
  return moonbit_make_int32_array_raw(len);
}

static moonbit_bytes_t
empty_bytes(void) {
  return moonbit_make_bytes(0, 0);
}

static FT_Error
set_active_charmap(NativeFtFace* handle, int32_t active_index) {
  if (!handle || !handle->face) {
    return FT_Err_Invalid_Face_Handle;
  }
  if (active_index < 0 || active_index >= handle->face->num_charmaps) {
    return FT_Err_Ok;
  }
  if (handle->face->charmap != handle->face->charmaps[active_index]) {
    return FT_Set_Charmap(handle->face, handle->face->charmaps[active_index]);
  }
  return FT_Err_Ok;
}

static FT_Error
set_variation_blend_coords(NativeFtFace* handle, int32_t* coords) {
  if (!handle || !handle->face) {
    return FT_Err_Invalid_Face_Handle;
  }
  if (!(handle->face->face_flags & FT_FACE_FLAG_MULTIPLE_MASTERS)) {
    return FT_Err_Ok;
  }
  int32_t len = Moonbit_array_length(coords);
  if (len == 0) {
    return FT_Set_Var_Blend_Coordinates(handle->face, 0, NULL);
  }
  FT_Fixed* fixed_coords = (FT_Fixed*)malloc((size_t)len * sizeof(FT_Fixed));
  if (!fixed_coords) {
    return FT_Err_Out_Of_Memory;
  }
  for (int32_t i = 0; i < len; i++) {
    fixed_coords[i] = ((FT_Fixed)coords[i]) << 2;
  }
  FT_Error error = FT_Set_Var_Blend_Coordinates(
      handle->face,
      (FT_UInt)len,
      fixed_coords);
  free(fixed_coords);
  return error;
}

static FT_Error
apply_palette(NativeFtFace* handle,
              int32_t palette_index,
              uint8_t blue,
              uint8_t green,
              uint8_t red,
              uint8_t alpha) {
  if (!handle || !handle->face) {
    return FT_Err_Invalid_Face_Handle;
  }
  if (!(handle->face->face_flags & FT_FACE_FLAG_COLOR)) {
    return FT_Err_Ok;
  }

  FT_Color fg;
  fg.blue = blue;
  fg.green = green;
  fg.red = red;
  fg.alpha = alpha;
  FT_Palette_Set_Foreground_Color(handle->face, fg);

  if (palette_index >= 0) {
    return FT_Palette_Select(handle->face, (FT_UShort)palette_index, NULL);
  }
  return FT_Err_Ok;
}

static FT_Render_Mode
render_mode_from_load_flags(int32_t load_flags) {
  int target = (load_flags >> 16) & 15;
  if (load_flags & FT_LOAD_MONOCHROME) {
    return FT_RENDER_MODE_MONO;
  }
  switch (target) {
    case 1: return FT_RENDER_MODE_LIGHT;
    case 2: return FT_RENDER_MODE_MONO;
    case 3: return FT_RENDER_MODE_LCD;
    case 4: return FT_RENDER_MODE_LCD_V;
    default: return FT_RENDER_MODE_NORMAL;
  }
}

static int32_t
local_format_from_slot(FT_GlyphSlot slot) {
  if (!slot) {
    return 0;
  }
  if (slot->format == FT_GLYPH_FORMAT_BITMAP) {
    return 2;
  }
  if (slot->format == FT_GLYPH_FORMAT_OUTLINE) {
    return 3;
  }
  if (slot->format == FT_GLYPH_FORMAT_SVG) {
    return 5;
  }
  return 0;
}

static const char*
skip_svg_space(const char* p) {
  while (*p == ' ' || *p == '\t' || *p == '\r' || *p == '\n') {
    p++;
  }
  return p;
}

static FT_Bool
extract_viewbox(const char* svg,
                double* min_x,
                double* min_y,
                double* width,
                double* height) {
  const char* attr = strstr(svg, "viewBox=");
  if (!attr) {
    attr = strstr(svg, "viewbox=");
  }
  if (!attr) {
    return 0;
  }
  attr = strchr(attr, '=');
  if (!attr) {
    return 0;
  }
  attr++;
  attr = skip_svg_space(attr);
  if (*attr != '"' && *attr != '\'') {
    return 0;
  }
  char quote = *attr++;
  char* end = NULL;
  *min_x = strtod(attr, &end);
  if (end == attr) {
    return 0;
  }
  attr = skip_svg_space(end);
  *min_y = strtod(attr, &end);
  if (end == attr) {
    return 0;
  }
  attr = skip_svg_space(end);
  *width = strtod(attr, &end);
  if (end == attr) {
    return 0;
  }
  attr = skip_svg_space(end);
  *height = strtod(attr, &end);
  if (end == attr) {
    return 0;
  }
  attr = skip_svg_space(end);
  return *attr == quote && *width > 0.0 && *height > 0.0;
}

static int32_t
round_to_i32(double value) {
  return (int32_t)(value >= 0.0 ? value + 0.5 : value - 0.5);
}

static char*
build_sized_svg(const FT_Byte* svg_document,
                FT_ULong svg_document_length,
                int32_t canvas_w,
                int32_t canvas_h) {
  const char* svg = (const char*)svg_document;
  const char* svg_open = strstr(svg, "<svg");
  if (!svg_open) {
    return NULL;
  }
  const char* tag_end = strchr(svg_open, '>');
  if (!tag_end) {
    return NULL;
  }
  size_t prefix_len = (size_t)(tag_end - svg);
  size_t suffix_len = (size_t)(svg_document_length - prefix_len);
  char inject[96];
  int inject_len = snprintf(
      inject,
      sizeof(inject),
      " width=\"%d\" height=\"%d\"",
      canvas_w,
      canvas_h);
  if (inject_len <= 0) {
    return NULL;
  }
  char* out = (char*)libc_malloc(svg_document_length + (size_t)inject_len + 1);
  if (!out) {
    return NULL;
  }
  memcpy(out, svg, prefix_len);
  memcpy(out + prefix_len, inject, (size_t)inject_len);
  memcpy(out + prefix_len + inject_len, svg + prefix_len, suffix_len);
  out[svg_document_length + (size_t)inject_len] = '\0';
  return out;
}

static FT_Error
render_svg_slot(NativeFtFace* handle) {
  if (!handle || !handle->face || !handle->face->glyph ||
      handle->face->glyph->format != FT_GLYPH_FORMAT_SVG) {
    return FT_Err_Invalid_Glyph_Format;
  }

  FT_GlyphSlot slot = handle->face->glyph;
  FT_SVG_Document doc = (FT_SVG_Document)slot->other;
  if (!doc || !doc->svg_document || doc->svg_document_length == 0) {
    return FT_Err_Invalid_SVG_Document;
  }

  double min_x = 0.0;
  double min_y = -(double)(doc->units_per_EM ? doc->units_per_EM : 1000U);
  double viewbox_w = (double)(doc->units_per_EM ? doc->units_per_EM : 1000U);
  double viewbox_h = (double)(doc->units_per_EM ? doc->units_per_EM : 1000U);
  extract_viewbox((const char*)doc->svg_document, &min_x, &min_y, &viewbox_w, &viewbox_h);

  double units = (double)(doc->units_per_EM ? doc->units_per_EM : 1000U);
  double scale_x = doc->metrics.x_ppem ? (double)doc->metrics.x_ppem / units : 1.0;
  double scale_y = doc->metrics.y_ppem ? (double)doc->metrics.y_ppem / units : scale_x;
  int32_t canvas_w = round_to_i32(viewbox_w * scale_x);
  int32_t canvas_h = round_to_i32(viewbox_h * scale_y);
  if (canvas_w <= 0) {
    canvas_w = 1;
  }
  if (canvas_h <= 0) {
    canvas_h = 1;
  }

  char* sized_svg = build_sized_svg(doc->svg_document, doc->svg_document_length, canvas_w, canvas_h);
  if (!sized_svg) {
    return FT_Err_Invalid_SVG_Document;
  }

  char svg_path[] = "/tmp/freetype-svg-XXXXXX.svg";
  char raw_path[] = "/tmp/freetype-svg-XXXXXX.rgba";
  int svg_fd = mkstemps(svg_path, 4);
  int raw_fd = mkstemps(raw_path, 5);
  if (svg_fd < 0 || raw_fd < 0) {
    if (svg_fd >= 0) {
      close(svg_fd);
      unlink(svg_path);
    }
    if (raw_fd >= 0) {
      close(raw_fd);
      unlink(raw_path);
    }
    libc_free(sized_svg);
    return FT_Err_Cannot_Open_Resource;
  }

  FT_Error error = FT_Err_Ok;
  FT_ULong svg_len = (FT_ULong)strlen(sized_svg);
  if (write(svg_fd, sized_svg, (size_t)svg_len) != (ssize_t)svg_len) {
    error = FT_Err_Cannot_Open_Resource;
    goto SvgCleanup;
  }
  close(svg_fd);
  svg_fd = -1;
  close(raw_fd);
  raw_fd = -1;

  char command[1024];
  snprintf(
      command,
      sizeof(command),
      "convert -background none -alpha on \"%s\" \"rgba:%s\" >/dev/null 2>/dev/null",
      svg_path,
      raw_path);
  if (system(command) != 0) {
    error = FT_Err_Cannot_Render_Glyph;
    goto SvgCleanup;
  }

  FILE* raw_file = fopen(raw_path, "rb");
  if (!raw_file) {
    error = FT_Err_Cannot_Open_Resource;
    goto SvgCleanup;
  }
  size_t raw_len = (size_t)canvas_w * (size_t)canvas_h * 4U;
  FT_Byte* rgba = (FT_Byte*)libc_malloc(raw_len);
  if (!rgba) {
    fclose(raw_file);
    error = FT_Err_Out_Of_Memory;
    goto SvgCleanup;
  }
  size_t read_len = fread(rgba, 1, raw_len, raw_file);
  fclose(raw_file);
  if (read_len != raw_len) {
    libc_free(rgba);
    error = FT_Err_Invalid_SVG_Document;
    goto SvgCleanup;
  }

  int32_t min_px_x = canvas_w;
  int32_t min_px_y = canvas_h;
  int32_t max_px_x = -1;
  int32_t max_px_y = -1;
  for (int32_t y = 0; y < canvas_h; y++) {
    for (int32_t x = 0; x < canvas_w; x++) {
      FT_Byte alpha = rgba[((size_t)y * (size_t)canvas_w + (size_t)x) * 4U + 3U];
      if (alpha != 0) {
        if (x < min_px_x) min_px_x = x;
        if (y < min_px_y) min_px_y = y;
        if (x > max_px_x) max_px_x = x;
        if (y > max_px_y) max_px_y = y;
      }
    }
  }

  FT_Memory memory = handle->face->memory;
  if (slot->internal && (slot->internal->flags & FT_GLYPH_OWN_BITMAP)) {
    FT_FREE(slot->bitmap.buffer);
    slot->internal->flags &= ~FT_GLYPH_OWN_BITMAP;
  }
  slot->bitmap.buffer = NULL;
  slot->bitmap.rows = 0;
  slot->bitmap.width = 0;
  slot->bitmap.pitch = 0;
  slot->bitmap.num_grays = 256;
  slot->bitmap.pixel_mode = FT_PIXEL_MODE_BGRA;
  slot->bitmap_left = 0;
  slot->bitmap_top = 0;
  slot->format = FT_GLYPH_FORMAT_BITMAP;

  if (max_px_x >= min_px_x && max_px_y >= min_px_y) {
    int32_t width = max_px_x - min_px_x + 1;
    int32_t rows = max_px_y - min_px_y + 1;
    int32_t pitch = width * 4;
    FT_Byte* bgra = (FT_Byte*)libc_malloc((size_t)rows * (size_t)pitch);
    if (!bgra) {
      libc_free(rgba);
      error = FT_Err_Out_Of_Memory;
      goto SvgCleanup;
    }
    for (int32_t y = 0; y < rows; y++) {
      for (int32_t x = 0; x < width; x++) {
        size_t src = ((size_t)(min_px_y + y) * (size_t)canvas_w + (size_t)(min_px_x + x)) * 4U;
        size_t dst = (size_t)y * (size_t)pitch + (size_t)x * 4U;
        FT_Byte red = rgba[src + 0];
        FT_Byte green = rgba[src + 1];
        FT_Byte blue = rgba[src + 2];
        FT_Byte alpha = rgba[src + 3];
        bgra[dst + 0] = (FT_Byte)((blue * alpha + 127) / 255);
        bgra[dst + 1] = (FT_Byte)((green * alpha + 127) / 255);
        bgra[dst + 2] = (FT_Byte)((red * alpha + 127) / 255);
        bgra[dst + 3] = alpha;
      }
    }
    int32_t origin_x = round_to_i32(((-min_x) / viewbox_w) * (double)canvas_w);
    int32_t baseline_y = round_to_i32(((0.0 - min_y) / viewbox_h) * (double)canvas_h);
    slot->bitmap.buffer = bgra;
    slot->bitmap.rows = rows;
    slot->bitmap.width = width;
    slot->bitmap.pitch = pitch;
    slot->bitmap_left = min_px_x - origin_x;
    slot->bitmap_top = baseline_y - min_px_y;
    if (slot->internal) {
      slot->internal->flags |= FT_GLYPH_OWN_BITMAP;
    }
  }

  libc_free(rgba);

SvgCleanup:
  if (svg_fd >= 0) {
    close(svg_fd);
  }
  if (raw_fd >= 0) {
    close(raw_fd);
  }
  unlink(svg_path);
  unlink(raw_path);
  libc_free(sized_svg);
  return error;
}

MOONBIT_FFI_EXPORT
NativeFtFace*
bikallem_freetype_native_face_open(moonbit_bytes_t data, int32_t face_index) {
  NativeFtFace* handle =
      (NativeFtFace*)moonbit_make_external_object(
          bikallem_freetype_native_face_destroy,
          sizeof(NativeFtFace));
  memset(handle, 0, sizeof(NativeFtFace));

  handle->data_len = (FT_Long)Moonbit_array_length(data);
  if (handle->data_len > 0) {
    handle->data_copy = (FT_Byte*)libc_malloc((size_t)handle->data_len);
    if (!handle->data_copy) {
      handle->last_error = FT_Err_Out_Of_Memory;
      return handle;
    }
    memcpy(handle->data_copy, data, (size_t)handle->data_len);
  }

  handle->last_error = FT_Init_FreeType(&handle->library);
  if (handle->last_error) {
    return handle;
  }

  handle->last_error = FT_New_Memory_Face(
      handle->library,
      handle->data_copy,
      handle->data_len,
      (FT_Long)face_index,
      &handle->face);
  return handle;
}

MOONBIT_FFI_EXPORT int32_t
bikallem_freetype_native_face_last_error(NativeFtFace* handle) {
  return handle ? (int32_t)handle->last_error : (int32_t)FT_Err_Invalid_Face_Handle;
}

MOONBIT_FFI_EXPORT int64_t
bikallem_freetype_native_face_num_faces(NativeFtFace* handle) {
  return (handle && handle->face) ? (int64_t)handle->face->num_faces : 0;
}

MOONBIT_FFI_EXPORT int64_t
bikallem_freetype_native_face_flags(NativeFtFace* handle) {
  return (handle && handle->face) ? (int64_t)handle->face->face_flags : 0;
}

MOONBIT_FFI_EXPORT int32_t
bikallem_freetype_native_face_style_flags(NativeFtFace* handle) {
  return (handle && handle->face) ? (int32_t)handle->face->style_flags : 0;
}

MOONBIT_FFI_EXPORT int64_t
bikallem_freetype_native_face_num_glyphs(NativeFtFace* handle) {
  return (handle && handle->face) ? (int64_t)handle->face->num_glyphs : 0;
}

MOONBIT_FFI_EXPORT moonbit_bytes_t
bikallem_freetype_native_face_family_name(NativeFtFace* handle) {
  return (handle && handle->face) ? make_cstring_bytes(handle->face->family_name) : empty_bytes();
}

MOONBIT_FFI_EXPORT moonbit_bytes_t
bikallem_freetype_native_face_style_name(NativeFtFace* handle) {
  return (handle && handle->face) ? make_cstring_bytes(handle->face->style_name) : empty_bytes();
}

MOONBIT_FFI_EXPORT int64_t*
bikallem_freetype_native_face_bbox(NativeFtFace* handle) {
  int64_t* out = make_int64_array(4);
  memset(out, 0, sizeof(int64_t) * 4);
  if (handle && handle->face) {
    out[0] = handle->face->bbox.xMin;
    out[1] = handle->face->bbox.yMin;
    out[2] = handle->face->bbox.xMax;
    out[3] = handle->face->bbox.yMax;
  }
  return out;
}

MOONBIT_FFI_EXPORT uint32_t
bikallem_freetype_native_face_units_per_em(NativeFtFace* handle) {
  return (handle && handle->face) ? (uint32_t)handle->face->units_per_EM : 0U;
}

MOONBIT_FFI_EXPORT int32_t
bikallem_freetype_native_face_ascender(NativeFtFace* handle) {
  return (handle && handle->face) ? (int32_t)handle->face->ascender : 0;
}

MOONBIT_FFI_EXPORT int32_t
bikallem_freetype_native_face_descender(NativeFtFace* handle) {
  return (handle && handle->face) ? (int32_t)handle->face->descender : 0;
}

MOONBIT_FFI_EXPORT int32_t
bikallem_freetype_native_face_height(NativeFtFace* handle) {
  return (handle && handle->face) ? (int32_t)handle->face->height : 0;
}

MOONBIT_FFI_EXPORT int32_t
bikallem_freetype_native_face_max_advance_width(NativeFtFace* handle) {
  return (handle && handle->face) ? (int32_t)handle->face->max_advance_width : 0;
}

MOONBIT_FFI_EXPORT int32_t
bikallem_freetype_native_face_max_advance_height(NativeFtFace* handle) {
  return (handle && handle->face) ? (int32_t)handle->face->max_advance_height : 0;
}

MOONBIT_FFI_EXPORT int32_t
bikallem_freetype_native_face_underline_position(NativeFtFace* handle) {
  return (handle && handle->face) ? (int32_t)handle->face->underline_position : 0;
}

MOONBIT_FFI_EXPORT int32_t
bikallem_freetype_native_face_underline_thickness(NativeFtFace* handle) {
  return (handle && handle->face) ? (int32_t)handle->face->underline_thickness : 0;
}

MOONBIT_FFI_EXPORT int32_t
bikallem_freetype_native_face_num_fixed_sizes(NativeFtFace* handle) {
  return (handle && handle->face) ? (int32_t)handle->face->num_fixed_sizes : 0;
}

MOONBIT_FFI_EXPORT int64_t*
bikallem_freetype_native_face_fixed_size(NativeFtFace* handle, int32_t index) {
  int64_t* out = make_int64_array(5);
  memset(out, 0, sizeof(int64_t) * 5);
  if (!handle || !handle->face || index < 0 || index >= handle->face->num_fixed_sizes) {
    return out;
  }
  FT_Bitmap_Size* size = &handle->face->available_sizes[index];
  out[0] = size->height;
  out[1] = size->width;
  out[2] = size->size;
  out[3] = size->x_ppem;
  out[4] = size->y_ppem;
  return out;
}

MOONBIT_FFI_EXPORT int32_t
bikallem_freetype_native_face_num_charmaps(NativeFtFace* handle) {
  return (handle && handle->face) ? (int32_t)handle->face->num_charmaps : 0;
}

MOONBIT_FFI_EXPORT int32_t
bikallem_freetype_native_face_default_charmap_index(NativeFtFace* handle) {
  if (!handle || !handle->face || handle->face->num_charmaps <= 0) {
    return -1;
  }
  int32_t unicode_index = -1;
  for (int i = 0; i < handle->face->num_charmaps; i++) {
    FT_CharMap cmap = handle->face->charmaps[i];
    if (cmap->encoding == FT_ENCODING_UNICODE) {
      unicode_index = i;
      break;
    }
  }
  return unicode_index >= 0 ? unicode_index : 0;
}

MOONBIT_FFI_EXPORT uint32_t
bikallem_freetype_native_face_charmap_encoding_tag(NativeFtFace* handle, int32_t index) {
  if (!handle || !handle->face || index < 0 || index >= handle->face->num_charmaps) {
    return 0U;
  }
  return (uint32_t)handle->face->charmaps[index]->encoding;
}

MOONBIT_FFI_EXPORT uint32_t
bikallem_freetype_native_face_charmap_platform_id(NativeFtFace* handle, int32_t index) {
  if (!handle || !handle->face || index < 0 || index >= handle->face->num_charmaps) {
    return 0U;
  }
  return (uint32_t)handle->face->charmaps[index]->platform_id;
}

MOONBIT_FFI_EXPORT uint32_t
bikallem_freetype_native_face_charmap_encoding_id(NativeFtFace* handle, int32_t index) {
  if (!handle || !handle->face || index < 0 || index >= handle->face->num_charmaps) {
    return 0U;
  }
  return (uint32_t)handle->face->charmaps[index]->encoding_id;
}

MOONBIT_FFI_EXPORT uint32_t*
bikallem_freetype_native_face_palette_meta(NativeFtFace* handle) {
  int32_t* out = make_int32_array(2);
  out[0] = 0;
  out[1] = 0;
  if (!handle || !handle->face) {
    return (uint32_t*)out;
  }
  FT_Palette_Data data;
  if (FT_Palette_Data_Get(handle->face, &data) == FT_Err_Ok) {
    out[0] = (int32_t)data.num_palettes;
    out[1] = (int32_t)data.num_palette_entries;
  }
  return (uint32_t*)out;
}

MOONBIT_FFI_EXPORT uint32_t*
bikallem_freetype_native_face_palette_name_ids(NativeFtFace* handle) {
  FT_Palette_Data data;
  if (!handle || !handle->face || FT_Palette_Data_Get(handle->face, &data) != FT_Err_Ok || data.num_palettes == 0) {
    return (uint32_t*)make_int32_array(0);
  }
  int32_t* out = make_int32_array((int32_t)data.num_palettes);
  if (!data.palette_name_ids) {
    for (FT_UInt i = 0; i < data.num_palettes; i++) {
      out[i] = 0xFFFF;
    }
    return (uint32_t*)out;
  }
  for (FT_UInt i = 0; i < data.num_palettes; i++) {
    out[i] = (int32_t)data.palette_name_ids[i];
  }
  return (uint32_t*)out;
}

MOONBIT_FFI_EXPORT uint32_t*
bikallem_freetype_native_face_palette_flags(NativeFtFace* handle) {
  FT_Palette_Data data;
  if (!handle || !handle->face || FT_Palette_Data_Get(handle->face, &data) != FT_Err_Ok || data.num_palettes == 0) {
    return (uint32_t*)make_int32_array(0);
  }
  int32_t* out = make_int32_array((int32_t)data.num_palettes);
  if (!data.palette_flags) {
    memset(out, 0, sizeof(int32_t) * (size_t)data.num_palettes);
    return (uint32_t*)out;
  }
  for (FT_UInt i = 0; i < data.num_palettes; i++) {
    out[i] = (int32_t)data.palette_flags[i];
  }
  return (uint32_t*)out;
}

MOONBIT_FFI_EXPORT uint32_t*
bikallem_freetype_native_face_palette_entry_name_ids(NativeFtFace* handle) {
  FT_Palette_Data data;
  if (!handle || !handle->face || FT_Palette_Data_Get(handle->face, &data) != FT_Err_Ok || data.num_palette_entries == 0) {
    return (uint32_t*)make_int32_array(0);
  }
  int32_t* out = make_int32_array((int32_t)data.num_palette_entries);
  if (!data.palette_entry_name_ids) {
    for (FT_UInt i = 0; i < data.num_palette_entries; i++) {
      out[i] = 0xFFFF;
    }
    return (uint32_t*)out;
  }
  for (FT_UInt i = 0; i < data.num_palette_entries; i++) {
    out[i] = (int32_t)data.palette_entry_name_ids[i];
  }
  return (uint32_t*)out;
}

MOONBIT_FFI_EXPORT moonbit_bytes_t
bikallem_freetype_native_face_palette_bytes(NativeFtFace* handle, uint32_t palette_index) {
  if (!handle || !handle->face) {
    return empty_bytes();
  }
  FT_Palette_Data data;
  if (FT_Palette_Data_Get(handle->face, &data) != FT_Err_Ok || data.num_palette_entries == 0) {
    return empty_bytes();
  }
  FT_Color* palette = NULL;
  if (FT_Palette_Select(handle->face, (FT_UShort)palette_index, &palette) != FT_Err_Ok || !palette) {
    return empty_bytes();
  }
  moonbit_bytes_t out = moonbit_make_bytes((int32_t)(data.num_palette_entries * 4), 0);
  for (FT_UInt i = 0; i < data.num_palette_entries; i++) {
    out[i * 4 + 0] = palette[i].blue;
    out[i * 4 + 1] = palette[i].green;
    out[i * 4 + 2] = palette[i].red;
    out[i * 4 + 3] = palette[i].alpha;
  }
  return out;
}

MOONBIT_FFI_EXPORT uint32_t
bikallem_freetype_native_face_char_index(NativeFtFace* handle,
                                         int32_t active_charmap,
                                         uint32_t charcode) {
  if (!handle || !handle->face) {
    return 0U;
  }
  if (set_active_charmap(handle, active_charmap) != FT_Err_Ok) {
    return 0U;
  }
  return FT_Get_Char_Index(handle->face, (FT_ULong)charcode);
}

MOONBIT_FFI_EXPORT uint32_t
bikallem_freetype_native_face_char_variant_index(NativeFtFace* handle,
                                                 uint32_t charcode,
                                                 uint32_t selector) {
  if (!handle || !handle->face) {
    return 0U;
  }
  return FT_Face_GetCharVariantIndex(handle->face, charcode, selector);
}

MOONBIT_FFI_EXPORT int32_t
bikallem_freetype_native_face_char_variant_is_default(NativeFtFace* handle,
                                                      uint32_t charcode,
                                                      uint32_t selector) {
  if (!handle || !handle->face) {
    return -1;
  }
  return FT_Face_GetCharVariantIsDefault(handle->face, charcode, selector);
}

static uint32_t*
copy_null_terminated_u32(const FT_UInt32* values) {
  if (!values) {
    return (uint32_t*)make_int32_array(0);
  }
  int32_t len = 0;
  while (values[len] != 0) {
    len++;
  }
  int32_t* out = make_int32_array(len);
  for (int32_t i = 0; i < len; i++) {
    out[i] = (int32_t)values[i];
  }
  return (uint32_t*)out;
}

MOONBIT_FFI_EXPORT uint32_t*
bikallem_freetype_native_face_variant_selectors(NativeFtFace* handle) {
  if (!handle || !handle->face) {
    return (uint32_t*)make_int32_array(0);
  }
  return copy_null_terminated_u32(FT_Face_GetVariantSelectors(handle->face));
}

MOONBIT_FFI_EXPORT uint32_t*
bikallem_freetype_native_face_variants_of_char(NativeFtFace* handle, uint32_t charcode) {
  if (!handle || !handle->face) {
    return (uint32_t*)make_int32_array(0);
  }
  return copy_null_terminated_u32(FT_Face_GetVariantsOfChar(handle->face, charcode));
}

MOONBIT_FFI_EXPORT uint32_t*
bikallem_freetype_native_face_chars_of_variant(NativeFtFace* handle, uint32_t selector) {
  if (!handle || !handle->face) {
    return (uint32_t*)make_int32_array(0);
  }
  return copy_null_terminated_u32(FT_Face_GetCharsOfVariant(handle->face, selector));
}

MOONBIT_FFI_EXPORT int32_t
bikallem_freetype_native_face_load_slot(NativeFtFace* handle,
                                        uint32_t glyph_index,
                                        int32_t load_flags,
                                        uint32_t x_ppem,
                                        uint32_t y_ppem,
                                        int32_t active_charmap,
                                        int32_t* coords,
                                        int32_t palette_index,
                                        uint8_t fg_blue,
                                        uint8_t fg_green,
                                        uint8_t fg_red,
                                        uint8_t fg_alpha) {
  if (!handle || !handle->face) {
    return (int32_t)FT_Err_Invalid_Face_Handle;
  }

  FT_Error error = set_active_charmap(handle, active_charmap);
  if (error) {
    return (int32_t)error;
  }
  error = set_variation_blend_coords(handle, coords);
  if (error) {
    return (int32_t)error;
  }
  error = apply_palette(handle, palette_index, fg_blue, fg_green, fg_red, fg_alpha);
  if (error) {
    return (int32_t)error;
  }
  if (x_ppem != 0 || y_ppem != 0) {
    error = FT_Set_Pixel_Sizes(handle->face, x_ppem, y_ppem);
    if (error) {
      return (int32_t)error;
    }
  }

  FT_Int32 ft_load_flags = (FT_Int32)(load_flags & ~FT_LOAD_RENDER);
  error = FT_Load_Glyph(handle->face, (FT_UInt)glyph_index, ft_load_flags);
  if (error) {
    return (int32_t)error;
  }

  if ((load_flags & FT_LOAD_RENDER) != 0) {
    if (handle->face->glyph->format == FT_GLYPH_FORMAT_SVG) {
      error = render_svg_slot(handle);
      if (error) {
        return (int32_t)error;
      }
    } else if (handle->face->glyph->format == FT_GLYPH_FORMAT_OUTLINE) {
      error = FT_Render_Glyph(handle->face->glyph, render_mode_from_load_flags(load_flags));
      if (error) {
        return (int32_t)error;
      }
    }
  }
  return 0;
}

MOONBIT_FFI_EXPORT int32_t
bikallem_freetype_native_face_slot_format(NativeFtFace* handle) {
  if (!handle || !handle->face) {
    return 0;
  }
  return local_format_from_slot(handle->face->glyph);
}

MOONBIT_FFI_EXPORT int64_t*
bikallem_freetype_native_face_slot_metrics(NativeFtFace* handle) {
  int64_t* out = make_int64_array(14);
  memset(out, 0, sizeof(int64_t) * 14);
  if (!handle || !handle->face) {
    return out;
  }
  FT_GlyphSlot slot = handle->face->glyph;
  out[0] = slot->metrics.width;
  out[1] = slot->metrics.height;
  out[2] = slot->metrics.horiBearingX;
  out[3] = slot->metrics.horiBearingY;
  out[4] = slot->metrics.horiAdvance;
  out[5] = slot->metrics.vertBearingX;
  out[6] = slot->metrics.vertBearingY;
  out[7] = slot->metrics.vertAdvance;
  out[8] = slot->linearHoriAdvance;
  out[9] = slot->linearVertAdvance;
  out[10] = slot->advance.x;
  out[11] = slot->advance.y;
  out[12] = slot->lsb_delta;
  out[13] = slot->rsb_delta;
  return out;
}

MOONBIT_FFI_EXPORT int64_t*
bikallem_freetype_native_face_slot_outline_points(NativeFtFace* handle) {
  if (!handle || !handle->face || handle->face->glyph->format != FT_GLYPH_FORMAT_OUTLINE) {
    return make_int64_array(0);
  }
  FT_Outline* outline = &handle->face->glyph->outline;
  int64_t* out = make_int64_array(outline->n_points * 2);
  for (int i = 0; i < outline->n_points; i++) {
    out[i * 2] = outline->points[i].x;
    out[i * 2 + 1] = outline->points[i].y;
  }
  return out;
}

MOONBIT_FFI_EXPORT moonbit_bytes_t
bikallem_freetype_native_face_slot_outline_tags(NativeFtFace* handle) {
  if (!handle || !handle->face || handle->face->glyph->format != FT_GLYPH_FORMAT_OUTLINE) {
    return empty_bytes();
  }
  FT_Outline* outline = &handle->face->glyph->outline;
  return make_bytes_copy(outline->tags, (FT_ULong)outline->n_points);
}

MOONBIT_FFI_EXPORT uint32_t*
bikallem_freetype_native_face_slot_outline_contours(NativeFtFace* handle) {
  if (!handle || !handle->face || handle->face->glyph->format != FT_GLYPH_FORMAT_OUTLINE) {
    return (uint32_t*)make_int32_array(0);
  }
  FT_Outline* outline = &handle->face->glyph->outline;
  int32_t* out = make_int32_array(outline->n_contours);
  for (int i = 0; i < outline->n_contours; i++) {
    out[i] = outline->contours[i];
  }
  return (uint32_t*)out;
}

MOONBIT_FFI_EXPORT int32_t
bikallem_freetype_native_face_slot_outline_flags(NativeFtFace* handle) {
  if (!handle || !handle->face || handle->face->glyph->format != FT_GLYPH_FORMAT_OUTLINE) {
    return 0;
  }
  return handle->face->glyph->outline.flags;
}

MOONBIT_FFI_EXPORT int64_t*
bikallem_freetype_native_face_slot_bitmap_meta(NativeFtFace* handle) {
  int64_t* out = make_int64_array(7);
  memset(out, 0, sizeof(int64_t) * 7);
  if (!handle || !handle->face || handle->face->glyph->format != FT_GLYPH_FORMAT_BITMAP) {
    return out;
  }
  FT_GlyphSlot slot = handle->face->glyph;
  out[0] = slot->bitmap.rows;
  out[1] = slot->bitmap.width;
  out[2] = slot->bitmap.pitch;
  out[3] = slot->bitmap.num_grays;
  out[4] = slot->bitmap.pixel_mode;
  out[5] = slot->bitmap_left;
  out[6] = slot->bitmap_top;
  return out;
}

MOONBIT_FFI_EXPORT moonbit_bytes_t
bikallem_freetype_native_face_slot_bitmap_buffer(NativeFtFace* handle) {
  if (!handle || !handle->face || handle->face->glyph->format != FT_GLYPH_FORMAT_BITMAP) {
    return empty_bytes();
  }
  FT_GlyphSlot slot = handle->face->glyph;
  FT_ULong pitch = (FT_ULong)(slot->bitmap.pitch < 0 ? -slot->bitmap.pitch : slot->bitmap.pitch);
  FT_ULong len = (FT_ULong)slot->bitmap.rows * pitch;
  return make_bytes_copy(slot->bitmap.buffer, len);
}

MOONBIT_FFI_EXPORT int32_t
bikallem_freetype_native_face_get_kerning(NativeFtFace* handle,
                                          uint32_t left,
                                          uint32_t right) {
  if (!handle || !handle->face) {
    return 0;
  }
  FT_Vector delta;
  if (FT_Get_Kerning(handle->face, left, right, FT_KERNING_UNFITTED, &delta) != FT_Err_Ok) {
    return 0;
  }
  return (int32_t)delta.x;
}

MOONBIT_FFI_EXPORT moonbit_bytes_t
bikallem_freetype_native_face_glyph_name(NativeFtFace* handle,
                                         uint32_t glyph_index) {
  char buffer[256];
  if (!handle || !handle->face || !FT_HAS_GLYPH_NAMES(handle->face)) {
    return empty_bytes();
  }
  memset(buffer, 0, sizeof(buffer));
  if (FT_Get_Glyph_Name(handle->face,
                        (FT_UInt)glyph_index,
                        buffer,
                        (FT_UInt)sizeof(buffer)) != FT_Err_Ok) {
    return empty_bytes();
  }
  buffer[sizeof(buffer) - 1] = '\0';
  return make_cstring_bytes(buffer);
}

MOONBIT_FFI_EXPORT int32_t
bikallem_freetype_native_face_attach_metrics(NativeFtFace* handle,
                                             moonbit_bytes_t data) {
  if (!handle || !handle->face) {
    return (int32_t)FT_Err_Invalid_Face_Handle;
  }
  FT_Long len = (FT_Long)Moonbit_array_length(data);
  FT_Byte* copy = NULL;
  if (len > 0) {
    copy = (FT_Byte*)libc_malloc((size_t)len);
    if (!copy) {
      return (int32_t)FT_Err_Out_Of_Memory;
    }
    memcpy(copy, data, (size_t)len);
  }
  FT_Open_Args args;
  memset(&args, 0, sizeof(args));
  args.flags = FT_OPEN_MEMORY;
  args.memory_base = copy;
  args.memory_size = len;
  FT_Error error = FT_Attach_Stream(handle->face, &args);
  if (error) {
    if (copy) {
      libc_free(copy);
    }
    return (int32_t)error;
  }
  FT_Byte** next_data =
      (FT_Byte**)libc_malloc(sizeof(FT_Byte*) * (handle->attached_count + 1));
  FT_Long* next_lens =
      (FT_Long*)libc_malloc(sizeof(FT_Long) * (handle->attached_count + 1));
  if (!next_data || !next_lens) {
    if (next_data) {
      libc_free(next_data);
    }
    if (next_lens) {
      libc_free(next_lens);
    }
    if (copy) {
      libc_free(copy);
    }
    return (int32_t)FT_Err_Out_Of_Memory;
  }
  for (size_t i = 0; i < handle->attached_count; i++) {
    next_data[i] = handle->attached_data[i];
    next_lens[i] = handle->attached_lens[i];
  }
  if (handle->attached_data) {
    libc_free(handle->attached_data);
  }
  if (handle->attached_lens) {
    libc_free(handle->attached_lens);
  }
  handle->attached_data = next_data;
  handle->attached_lens = next_lens;
  handle->attached_data[handle->attached_count] = copy;
  handle->attached_lens[handle->attached_count] = len;
  handle->attached_count += 1;
  return 0;
}

MOONBIT_FFI_EXPORT uint32_t*
bikallem_freetype_native_face_var_axis_tags(NativeFtFace* handle) {
  if (!handle || !handle->face) {
    return (uint32_t*)make_int32_array(0);
  }
  FT_MM_Var* mmvar = NULL;
  if (FT_Get_MM_Var(handle->face, &mmvar) != FT_Err_Ok || !mmvar) {
    return (uint32_t*)make_int32_array(0);
  }
  int32_t* out = make_int32_array((int32_t)mmvar->num_axis);
  for (FT_UInt i = 0; i < mmvar->num_axis; i++) {
    out[i] = (int32_t)mmvar->axis[i].tag;
  }
  FT_Done_MM_Var(handle->library, mmvar);
  return (uint32_t*)out;
}

MOONBIT_FFI_EXPORT int64_t*
bikallem_freetype_native_face_var_axis_defaults(NativeFtFace* handle) {
  if (!handle || !handle->face) {
    return make_int64_array(0);
  }
  FT_MM_Var* mmvar = NULL;
  if (FT_Get_MM_Var(handle->face, &mmvar) != FT_Err_Ok || !mmvar) {
    return make_int64_array(0);
  }
  int64_t* out = make_int64_array((int32_t)mmvar->num_axis);
  for (FT_UInt i = 0; i < mmvar->num_axis; i++) {
    out[i] = (int64_t)mmvar->axis[i].def;
  }
  FT_Done_MM_Var(handle->library, mmvar);
  return out;
}

MOONBIT_FFI_EXPORT int32_t
bikallem_freetype_native_face_set_var_design_coordinates(NativeFtFace* handle,
                                                         int64_t* coords) {
  if (!handle || !handle->face) {
    return (int32_t)FT_Err_Invalid_Face_Handle;
  }
  int32_t len = Moonbit_array_length(coords);
  return (int32_t)FT_Set_Var_Design_Coordinates(handle->face, (FT_UInt)len, (FT_Fixed*)coords);
}

MOONBIT_FFI_EXPORT int64_t*
bikallem_freetype_native_face_var_blend_coords(NativeFtFace* handle) {
  if (!handle || !handle->face) {
    return make_int64_array(0);
  }
  FT_MM_Var* mmvar = NULL;
  if (FT_Get_MM_Var(handle->face, &mmvar) != FT_Err_Ok || !mmvar) {
    return make_int64_array(0);
  }
  FT_Fixed* coords = (FT_Fixed*)malloc(sizeof(FT_Fixed) * mmvar->num_axis);
  if (!coords) {
    FT_Done_MM_Var(handle->library, mmvar);
    return make_int64_array(0);
  }
  if (FT_Get_Var_Blend_Coordinates(handle->face, mmvar->num_axis, coords) != FT_Err_Ok) {
    free(coords);
    FT_Done_MM_Var(handle->library, mmvar);
    return make_int64_array(0);
  }
  int64_t* out = make_int64_array((int32_t)mmvar->num_axis);
  for (FT_UInt i = 0; i < mmvar->num_axis; i++) {
    out[i] = (int64_t)coords[i];
  }
  free(coords);
  FT_Done_MM_Var(handle->library, mmvar);
  return out;
}
