///|
priv type NativeFtFace

///|
fn ft_error_from_code(code : Int) -> @error.FTError {
  match code {
    0x01 => @error.FTError::CannotOpenResource
    0x02 => @error.FTError::UnknownFileFormat
    0x03 => @error.FTError::InvalidFileFormat
    0x06 => @error.FTError::InvalidArgument
    0x07 => @error.FTError::UnimplementedFeature
    0x08 => @error.FTError::InvalidTable
    0x10 => @error.FTError::InvalidGlyphIndex
    0x12 => @error.FTError::InvalidGlyphFormat
    0x13 => @error.FTError::CannotRenderGlyph
    0x14 => @error.FTError::InvalidOutline
    0x17 => @error.FTError::InvalidPixelSize
    0x18 => @error.FTError::InvalidSvgDocument
    0x23 => @error.FTError::InvalidFaceHandle
    0x40 => @error.FTError::OutOfMemory
    0x8E => @error.FTError::TableMissing
    0x92 => @error.FTError::CMapTableMissing
    0x93 => @error.FTError::HmtxTableMissing
    0x94 => @error.FTError::PostTableMissing
    0x9D => @error.FTError::MissingBitmap
    0x9E => @error.FTError::MissingSvgHooks
    0xA0 => @error.FTError::SyntaxError
    0xA1 => @error.FTError::StackUnderflow
    0xA3 => @error.FTError::NoUnicodeGlyphName
    _ => @error.FTError::InvalidArgument
  }
}

///|
fn check_ft_error(code : Int) -> Unit raise @error.FTError {
  if code != 0 {
    raise ft_error_from_code(code)
  }
}

///|
fn fixed_array_from_array(values : Array[Int]) -> FixedArray[Int] {
  let out = FixedArray::make(values.length(), 0)
  for i in 0..<values.length() {
    out[i] = values[i]
  }
  out
}

///|
fn decode_utf8_or_empty(bytes : Bytes) -> String {
  if bytes.length() == 0 {
    ""
  } else {
    @utf8.decode_lossy(bytes)
  }
}

///|
fn color_bytes_to_palette(bytes : Bytes) -> Array[@types.Color] {
  let palette : Array[@types.Color] = []
  let mut i = 0
  while i + 3 < bytes.length() {
    palette.push(@types.Color::new(bytes[i], bytes[i + 1], bytes[i + 2], bytes[i + 3]))
    i += 4
  }
  palette
}

///|
fn uint_fixed_array_to_array(values : FixedArray[UInt]) -> Array[UInt] {
  let out : Array[UInt] = []
  for i in 0..<values.length() {
    out.push(values[i])
  }
  out
}

///|
fn uint_array_from_native(values : FixedArray[UInt]) -> Array[UInt] {
  uint_fixed_array_to_array(values)
}

///|
fn slice_bytes(data : Bytes, start : Int, end : Int) -> Bytes {
  let clamped_start = start.max(0)
  let clamped_end = end.max(clamped_start).min(data.length())
  let out : Array[Byte] = Array::new(capacity=clamped_end - clamped_start)
  for i in clamped_start..<clamped_end {
    out.push(data[i])
  }
  Bytes::from_array(out[:])
}

///|
fn is_ascii_space(byte : Byte) -> Bool {
  byte == b' ' || byte == b'\t' || byte == b'\r' || byte == b'\n'
}

///|
fn skip_ascii_space(data : Bytes, start : Int, end : Int) -> Int {
  let mut pos = start
  while pos < end && is_ascii_space(data[pos]) {
    pos += 1
  }
  pos
}

///|
fn read_ascii_token(data : Bytes, start : Int, end : Int) -> (String, Int) {
  let token_start = skip_ascii_space(data, start, end)
  let mut token_end = token_start
  while token_end < end && !is_ascii_space(data[token_end]) {
    token_end += 1
  }
  (decode_utf8_or_empty(slice_bytes(data, token_start, token_end)), token_end)
}

///|
fn parse_ascii_int(data : Bytes, start : Int, end : Int) -> Int? {
  let mut pos = skip_ascii_space(data, start, end)
  if pos >= end {
    return None
  }
  let mut sign = 1
  if data[pos] == b'-' {
    sign = -1
    pos += 1
  } else if data[pos] == b'+' {
    pos += 1
  }
  let mut value = 0
  let mut saw_digit = false
  while pos < end {
    let byte = data[pos]
    if byte < b'0' || byte > b'9' {
      break
    }
    saw_digit = true
    value = value * 10 + (byte.to_int() - b'0'.to_int())
    pos += 1
  }
  if saw_digit {
    Some(value * sign)
  } else {
    None
  }
}

///|
fn afm_pair_key(left : UInt, right : UInt) -> Int64 {
  (left.to_int().to_int64() << 32) | right.to_int().to_int64()
}

///|
fn build_native_glyph_name_map(handle : NativeFtFace) -> Map[String, UInt] {
  let name_to_index : Map[String, UInt] = {}
  let num_glyphs = native_face_num_glyphs(handle).to_int()
  for i in 0..<num_glyphs {
    let name = decode_utf8_or_empty(
      native_face_glyph_name(handle, i.reinterpret_as_uint()),
    )
    if name != "" {
      name_to_index[name] = i.reinterpret_as_uint()
    }
  }
  name_to_index
}

///|
fn parse_afm_kerning_pairs(
  data : Bytes,
  name_to_index : Map[String, UInt],
) -> Map[Int64, Int] {
  let pairs : Map[Int64, Int] = {}
  let mut line_start = 0
  while line_start < data.length() {
    let mut line_end = line_start
    while line_end < data.length() &&
      data[line_end] != b'\n' &&
      data[line_end] != b'\r' {
      line_end += 1
    }
    if line_end - line_start >= 4 &&
      data[line_start] == b'K' &&
      data[line_start + 1] == b'P' &&
      data[line_start + 2] == b'X' &&
      data[line_start + 3] == b' ' {
      let (left_name, next0) = read_ascii_token(data, line_start + 4, line_end)
      let (right_name, next1) = read_ascii_token(data, next0, line_end)
      match parse_ascii_int(data, next1, line_end) {
        Some(value) =>
          match (name_to_index.get(left_name), name_to_index.get(right_name)) {
            (Some(left), Some(right)) => pairs[afm_pair_key(left, right)] = value
            _ => ()
          }
        None => ()
      }
    }
    line_start = line_end
    if line_start < data.length() && data[line_start] == b'\r' {
      line_start += 1
    }
    if line_start < data.length() && data[line_start] == b'\n' {
      line_start += 1
    }
  }
  pairs
}

///|
fn bitmap_from_native(
  meta : FixedArray[Int64],
  buffer : Bytes,
) -> @types.Bitmap {
  let bitmap = @types.Bitmap::new()
  bitmap.set_rows(meta[0].to_int().reinterpret_as_uint())
  bitmap.set_width(meta[1].to_int().reinterpret_as_uint())
  bitmap.set_pitch(meta[2].to_int())
  bitmap.set_num_grays(meta[3].to_int().reinterpret_as_uint())
  bitmap.set_pixel_mode(
    match meta[4].to_int() {
      1 => @types.PixelMode::Mono
      2 => @types.PixelMode::Gray
      3 => @types.PixelMode::Gray2
      4 => @types.PixelMode::Gray4
      5 => @types.PixelMode::Lcd
      6 => @types.PixelMode::LcdV
      7 => @types.PixelMode::Bgra
      _ => @types.PixelMode::None
    },
  )
  bitmap.set_buffer(buffer)
  bitmap
}

///|
fn outline_from_native(
  handle : NativeFtFace,
) -> @types.Outline {
  let packed_points = native_face_slot_outline_points(handle)
  let tags_bytes = native_face_slot_outline_tags(handle)
  let contour_indices = native_face_slot_outline_contours(handle)
  let n_points = packed_points.length() / 2
  let points = FixedArray::make(n_points, @types.Vector::new(0L, 0L))
  let tags = FixedArray::make(n_points, b'\x00')
  for i in 0..<n_points {
    points[i] = @types.Vector::new(packed_points[i * 2], packed_points[i * 2 + 1])
    tags[i] = tags_bytes[i]
  }
  let contours = FixedArray::make(contour_indices.length(), 0U)
  for i in 0..<contour_indices.length() {
    contours[i] = contour_indices[i]
  }
  let outline = @types.Outline::create(points, tags, contours)
  outline.set_flags(native_face_slot_outline_flags(handle))
  outline
}

///|
fn set_slot_from_native(
  face : @base.FaceRec,
  handle : NativeFtFace,
  glyph_index : UInt,
  load_flags : Int,
) -> Bool raise @error.FTError {
  let slot = face.glyph()
  let format = native_face_slot_format(handle)
  let metrics = native_face_slot_metrics(handle)
  slot.set_glyph_index(glyph_index)
  slot.set_load_flags(load_flags)
  slot.metrics().set_width(metrics[0])
  slot.metrics().set_height(metrics[1])
  slot.metrics().set_hori_bearing_x(metrics[2])
  slot.metrics().set_hori_bearing_y(metrics[3])
  slot.metrics().set_hori_advance(metrics[4])
  slot.metrics().set_vert_bearing_x(metrics[5])
  slot.metrics().set_vert_bearing_y(metrics[6])
  slot.metrics().set_vert_advance(metrics[7])
  slot.set_linear_hori_advance(@fixed.Fixed::from_raw(metrics[8]))
  slot.set_linear_vert_advance(@fixed.Fixed::from_raw(metrics[9]))
  slot.set_advance(@types.Vector::new(metrics[10], metrics[11]))
  slot.set_lsb_delta(metrics[12])
  slot.set_rsb_delta(metrics[13])
  slot.set_outline(@types.Outline::new())
  slot.set_bitmap(@types.Bitmap::new())
  slot.set_bitmap_left(0)
  slot.set_bitmap_top(0)
  match format {
    2 => {
      let meta = native_face_slot_bitmap_meta(handle)
      slot.set_format(@types.GlyphFormat::Bitmap)
      slot.set_bitmap(bitmap_from_native(meta, native_face_slot_bitmap_buffer(handle)))
      slot.set_bitmap_left(meta[5].to_int())
      slot.set_bitmap_top(meta[6].to_int())
    }
    3 => {
      slot.set_format(@types.GlyphFormat::Outline)
      slot.set_outline(outline_from_native(handle))
    }
    5 => slot.set_format(@types.GlyphFormat::Svg)
    0 => slot.set_format(@types.GlyphFormat::None)
    _ => raise @error.FTError::InvalidGlyphFormat
  }
  true
}

///|
fn sync_native_open_result(handle : NativeFtFace) -> Unit raise @error.FTError {
  check_ft_error(native_face_last_error(handle))
}

///|
fn populate_common_face(face : @base.FaceRec, handle : NativeFtFace) -> Unit {
  face.set_face_flags(native_face_face_flags(handle))
  face.set_style_flags(native_face_style_flags(handle))
  face.set_num_glyphs(native_face_num_glyphs(handle))
  face.set_family_name(decode_utf8_or_empty(native_face_family_name(handle)))
  face.set_style_name(decode_utf8_or_empty(native_face_style_name(handle)))
  let bbox = native_face_bbox(handle)
  face.set_bbox(@types.BBox::new(bbox[0], bbox[1], bbox[2], bbox[3]))
  face.set_units_per_em(native_face_units_per_em(handle))
  face.set_ascender(native_face_ascender(handle))
  face.set_descender(native_face_descender(handle))
  face.set_height(native_face_height(handle))
  face.set_max_advance_width(native_face_max_advance_width(handle))
  face.set_max_advance_height(native_face_max_advance_height(handle))
  face.set_underline_position(native_face_underline_position(handle))
  face.set_underline_thickness(native_face_underline_thickness(handle))
  let num_sizes = native_face_num_fixed_sizes(handle)
  let sizes : Array[@base.BitmapSize] = []
  for i in 0..<num_sizes {
    let size = native_face_fixed_size(handle, i)
    sizes.push(
      @base.BitmapSize::new(
        size[0].to_int(),
        size[1].to_int(),
        size[2],
        size[3],
        size[4],
      ),
    )
  }
  face.set_available_sizes(sizes)
  let num_charmaps = native_face_num_charmaps(handle)
  for i in 0..<num_charmaps {
    face
    .charmaps()
    .push(
      @base.CharMapRec::new(
        @base.Encoding::from_tag(native_face_charmap_encoding_tag(handle, i)),
        native_face_charmap_platform_id(handle, i),
        native_face_charmap_encoding_id(handle, i),
      ),
    )
  }
  if num_charmaps > 0 {
    face.set_active_charmap(native_face_default_charmap_index(handle))
  }
  let palette_meta = native_face_palette_meta(handle)
  if palette_meta[0] > 0U && palette_meta[1] > 0U {
    face.set_palette_data(
      Some(
        @types.PaletteData::new(
          palette_meta[0],
          uint_array_from_native(native_face_palette_name_ids(handle)),
          uint_array_from_native(native_face_palette_flags(handle)),
          palette_meta[1],
          uint_array_from_native(native_face_palette_entry_name_ids(handle)),
        ),
      ),
    )
    let palette_bytes = native_face_palette_bytes(handle, 0U)
    face.set_palette(color_bytes_to_palette(palette_bytes))
    face.set_palette_index(0)
  }
}

///|
fn type1_set_var_design_coordinates_impl(
  face : @base.FaceRec,
  handle : NativeFtFace,
  coordinates : Array[(@fixed.Fixed, UInt)],
) -> Unit raise @error.FTError {
  let axis_tags = native_face_var_axis_tags(handle)
  if axis_tags.length() == 0 {
    raise @error.FTError::InvalidArgument
  }
  let defaults = native_face_var_axis_defaults(handle)
  let resolved = FixedArray::make(axis_tags.length(), 0L)
  for i in 0..<axis_tags.length() {
    let mut value = defaults[i]
    for _, coordinate in coordinates {
      let (coord_value, tag) = coordinate
      if tag == axis_tags[i] {
        value = coord_value.val()
        break
      }
    }
    resolved[i] = value
  }
  check_ft_error(native_face_set_var_design_coordinates(handle, resolved))
  let blend = native_face_var_blend_coords(handle)
  let normalized : Array[Int] = []
  let mut has_non_default = false
  for i in 0..<blend.length() {
    let coord = blend[i].to_int()
    normalized.push(coord)
    if coord != 0 {
      has_non_default = true
    }
  }
  face.set_var_coords(normalized)
  let base_flags = if (face.face_flags() & @base.FACE_FLAG_VARIATION) != 0L {
    face.face_flags() - @base.FACE_FLAG_VARIATION
  } else {
    face.face_flags()
  }
  face.set_face_flags(
    if has_non_default {
      base_flags | @base.FACE_FLAG_VARIATION
    } else {
      base_flags
    },
  )
}

///|
fn load_slot_native_impl(
  face : @base.FaceRec,
  handle : NativeFtFace,
  glyph_index : UInt,
  load_flags : Int,
) -> Bool raise @error.FTError {
  let coords = fixed_array_from_array(face.var_coords())
  let color = face.foreground_color()
  check_ft_error(
    native_face_load_slot(
      handle,
      glyph_index,
      load_flags,
      face.size().metrics().x_ppem(),
      face.size().metrics().y_ppem(),
      face.active_charmap(),
      coords,
      face.palette_index(),
      color.blue(),
      color.green(),
      color.red(),
      color.alpha(),
    ),
  )
  set_slot_from_native(face, handle, glyph_index, load_flags)
}

///|
pub fn native_available() -> Bool {
  true
}

///|
pub fn load_type1_face_native(
  data : Bytes,
  face_index : Int,
) -> @base.FaceRec raise @error.FTError {
  let handle = native_face_open(data, face_index)
  sync_native_open_result(handle)
  let glyph_name_map = build_native_glyph_name_map(handle)
  let attached_kerning : Ref[Map[Int64, Int]] = Ref::new({})
  let face = @base.FaceRec::new(
    num_faces=native_face_num_faces(handle),
    face_index=face_index.to_int64(),
  )
  populate_common_face(face, handle)
  face.set_char_index_fn(fn(charcode) { native_face_char_index(handle, face.active_charmap(), charcode) })
  face.set_driver_data(
    @base.DriverData::Type1Ops(
      @base.Type1Ops::new(
        char_index=fn(charcode) { native_face_char_index(handle, face.active_charmap(), charcode) },
        load_glyph=(_glyph_index, _load_flags) => {
          raise @error.FTError::UnimplementedFeature
        },
        apply_hints=fn(_outline, _scale) { false },
        load_native_slot=(face, glyph_index, load_flags) => {
          load_slot_native_impl(face, handle, glyph_index, load_flags)
        },
        get_kerning=fn(left, right) {
          match attached_kerning.val.get(afm_pair_key(left, right)) {
            Some(value) => value
            None => native_face_get_kerning(handle, left, right)
          }
        },
        set_var_design_coordinates=(coordinates) => {
          type1_set_var_design_coordinates_impl(face, handle, coordinates)
        },
        attach_metrics=(metrics_data) => {
          let parsed_pairs = parse_afm_kerning_pairs(metrics_data, glyph_name_map)
          if !parsed_pairs.is_empty() {
            let merged = attached_kerning.val
            for pair, value in parsed_pairs {
              merged[pair] = value
            }
            attached_kerning.val = merged
            face.set_face_flags(face.face_flags() | @base.FACE_FLAG_KERNING)
          }
          let native_error = native_face_attach_metrics(handle, metrics_data)
          if native_error == 0 {
            face.set_face_flags(face.face_flags() | @base.FACE_FLAG_KERNING)
          } else if parsed_pairs.is_empty() {
            check_ft_error(native_error)
          }
        },
      ),
    ),
  )
  face
}

///|
pub fn load_sfnt_face_native(
  data : Bytes,
  face_index : Int,
) -> @base.FaceRec raise @error.FTError {
  let handle = native_face_open(data, face_index)
  sync_native_open_result(handle)
  let face = @base.FaceRec::new(
    num_faces=native_face_num_faces(handle),
    face_index=face_index.to_int64(),
  )
  populate_common_face(face, handle)
  face.set_char_index_fn(fn(charcode) { native_face_char_index(handle, face.active_charmap(), charcode) })
  face.set_driver_data(
    @base.DriverData::SfntDriver(
      @base.SfntOps::new(
        char_index=fn(charcode) { native_face_char_index(handle, face.active_charmap(), charcode) },
        char_variant_index=fn(charcode, selector) {
          native_face_char_variant_index(handle, charcode, selector)
        },
        char_variant_is_default=fn(charcode, selector) {
          native_face_char_variant_is_default(handle, charcode, selector)
        },
        variant_selectors=fn() {
          uint_array_from_native(native_face_variant_selectors(handle))
        },
        variants_of_char=fn(charcode) {
          uint_array_from_native(native_face_variants_of_char(handle, charcode))
        },
        chars_of_variant=fn(selector) {
          uint_array_from_native(native_face_chars_of_variant(handle, selector))
        },
        load_glyph=(_glyph_index, _load_flags) => {
          raise @error.FTError::UnimplementedFeature
        },
        get_kerning=fn(left, right) { native_face_get_kerning(handle, left, right) },
        apply_hints=fn(_outline, _scale) { false },
        tt_hint=fn(_outline, _instructions, _phantoms, _x_scale, _y_scale, _ppem) { false },
        load_native_slot=(face, glyph_index, load_flags) => {
          load_slot_native_impl(face, handle, glyph_index, load_flags)
        },
        palette_data=fn() { face.palette_data() },
        select_palette=fn(index) {
          let palette = color_bytes_to_palette(native_face_palette_bytes(handle, index))
          face.set_palette(palette)
          face.set_palette_index(index.reinterpret_as_int())
          Some(palette)
        },
        load_color_glyph=fn(_glyph_index, _load_flags, _x_ppem, _y_ppem, _palette, _foreground) { None },
        num_glyphs=native_face_num_glyphs(handle).to_int().reinterpret_as_uint(),
        raw_data=data,
      ),
    ),
  )
  face
}

// --- externs ---

///|
#borrow(data)
extern "c" fn native_face_open(data : Bytes, face_index : Int) -> NativeFtFace = "bikallem_freetype_native_face_open"

///|
#borrow(handle)
extern "c" fn native_face_last_error(handle : NativeFtFace) -> Int = "bikallem_freetype_native_face_last_error"

///|
#borrow(handle)
extern "c" fn native_face_num_faces(handle : NativeFtFace) -> Int64 = "bikallem_freetype_native_face_num_faces"

///|
#borrow(handle)
extern "c" fn native_face_face_flags(handle : NativeFtFace) -> Int64 = "bikallem_freetype_native_face_flags"

///|
#borrow(handle)
extern "c" fn native_face_style_flags(handle : NativeFtFace) -> Int = "bikallem_freetype_native_face_style_flags"

///|
#borrow(handle)
extern "c" fn native_face_num_glyphs(handle : NativeFtFace) -> Int64 = "bikallem_freetype_native_face_num_glyphs"

///|
#borrow(handle)
extern "c" fn native_face_family_name(handle : NativeFtFace) -> Bytes = "bikallem_freetype_native_face_family_name"

///|
#borrow(handle)
extern "c" fn native_face_style_name(handle : NativeFtFace) -> Bytes = "bikallem_freetype_native_face_style_name"

///|
#borrow(handle)
extern "c" fn native_face_bbox(handle : NativeFtFace) -> FixedArray[Int64] = "bikallem_freetype_native_face_bbox"

///|
#borrow(handle)
extern "c" fn native_face_units_per_em(handle : NativeFtFace) -> UInt = "bikallem_freetype_native_face_units_per_em"

///|
#borrow(handle)
extern "c" fn native_face_ascender(handle : NativeFtFace) -> Int = "bikallem_freetype_native_face_ascender"

///|
#borrow(handle)
extern "c" fn native_face_descender(handle : NativeFtFace) -> Int = "bikallem_freetype_native_face_descender"

///|
#borrow(handle)
extern "c" fn native_face_height(handle : NativeFtFace) -> Int = "bikallem_freetype_native_face_height"

///|
#borrow(handle)
extern "c" fn native_face_max_advance_width(handle : NativeFtFace) -> Int = "bikallem_freetype_native_face_max_advance_width"

///|
#borrow(handle)
extern "c" fn native_face_max_advance_height(handle : NativeFtFace) -> Int = "bikallem_freetype_native_face_max_advance_height"

///|
#borrow(handle)
extern "c" fn native_face_underline_position(handle : NativeFtFace) -> Int = "bikallem_freetype_native_face_underline_position"

///|
#borrow(handle)
extern "c" fn native_face_underline_thickness(handle : NativeFtFace) -> Int = "bikallem_freetype_native_face_underline_thickness"

///|
#borrow(handle)
extern "c" fn native_face_num_fixed_sizes(handle : NativeFtFace) -> Int = "bikallem_freetype_native_face_num_fixed_sizes"

///|
#borrow(handle)
extern "c" fn native_face_fixed_size(handle : NativeFtFace, index : Int) -> FixedArray[Int64] = "bikallem_freetype_native_face_fixed_size"

///|
#borrow(handle)
extern "c" fn native_face_num_charmaps(handle : NativeFtFace) -> Int = "bikallem_freetype_native_face_num_charmaps"

///|
#borrow(handle)
extern "c" fn native_face_default_charmap_index(handle : NativeFtFace) -> Int = "bikallem_freetype_native_face_default_charmap_index"

///|
#borrow(handle)
extern "c" fn native_face_charmap_encoding_tag(handle : NativeFtFace, index : Int) -> UInt = "bikallem_freetype_native_face_charmap_encoding_tag"

///|
#borrow(handle)
extern "c" fn native_face_charmap_platform_id(handle : NativeFtFace, index : Int) -> UInt = "bikallem_freetype_native_face_charmap_platform_id"

///|
#borrow(handle)
extern "c" fn native_face_charmap_encoding_id(handle : NativeFtFace, index : Int) -> UInt = "bikallem_freetype_native_face_charmap_encoding_id"

///|
#borrow(handle)
extern "c" fn native_face_palette_meta(handle : NativeFtFace) -> FixedArray[UInt] = "bikallem_freetype_native_face_palette_meta"

///|
#borrow(handle)
extern "c" fn native_face_palette_name_ids(handle : NativeFtFace) -> FixedArray[UInt] = "bikallem_freetype_native_face_palette_name_ids"

///|
#borrow(handle)
extern "c" fn native_face_palette_flags(handle : NativeFtFace) -> FixedArray[UInt] = "bikallem_freetype_native_face_palette_flags"

///|
#borrow(handle)
extern "c" fn native_face_palette_entry_name_ids(handle : NativeFtFace) -> FixedArray[UInt] = "bikallem_freetype_native_face_palette_entry_name_ids"

///|
#borrow(handle)
extern "c" fn native_face_palette_bytes(handle : NativeFtFace, palette_index : UInt) -> Bytes = "bikallem_freetype_native_face_palette_bytes"

///|
#borrow(handle)
extern "c" fn native_face_char_index(handle : NativeFtFace, active_charmap : Int, charcode : UInt) -> UInt = "bikallem_freetype_native_face_char_index"

///|
#borrow(handle)
extern "c" fn native_face_char_variant_index(handle : NativeFtFace, charcode : UInt, selector : UInt) -> UInt = "bikallem_freetype_native_face_char_variant_index"

///|
#borrow(handle)
extern "c" fn native_face_char_variant_is_default(handle : NativeFtFace, charcode : UInt, selector : UInt) -> Int = "bikallem_freetype_native_face_char_variant_is_default"

///|
#borrow(handle)
extern "c" fn native_face_variant_selectors(handle : NativeFtFace) -> FixedArray[UInt] = "bikallem_freetype_native_face_variant_selectors"

///|
#borrow(handle)
extern "c" fn native_face_variants_of_char(handle : NativeFtFace, charcode : UInt) -> FixedArray[UInt] = "bikallem_freetype_native_face_variants_of_char"

///|
#borrow(handle)
extern "c" fn native_face_chars_of_variant(handle : NativeFtFace, selector : UInt) -> FixedArray[UInt] = "bikallem_freetype_native_face_chars_of_variant"

///|
#borrow(handle, coords)
extern "c" fn native_face_load_slot(
  handle : NativeFtFace,
  glyph_index : UInt,
  load_flags : Int,
  x_ppem : UInt,
  y_ppem : UInt,
  active_charmap : Int,
  coords : FixedArray[Int],
  palette_index : Int,
  fg_blue : Byte,
  fg_green : Byte,
  fg_red : Byte,
  fg_alpha : Byte,
) -> Int = "bikallem_freetype_native_face_load_slot"

///|
#borrow(handle)
extern "c" fn native_face_slot_format(handle : NativeFtFace) -> Int = "bikallem_freetype_native_face_slot_format"

///|
#borrow(handle)
extern "c" fn native_face_slot_metrics(handle : NativeFtFace) -> FixedArray[Int64] = "bikallem_freetype_native_face_slot_metrics"

///|
#borrow(handle)
extern "c" fn native_face_slot_outline_points(handle : NativeFtFace) -> FixedArray[Int64] = "bikallem_freetype_native_face_slot_outline_points"

///|
#borrow(handle)
extern "c" fn native_face_slot_outline_tags(handle : NativeFtFace) -> Bytes = "bikallem_freetype_native_face_slot_outline_tags"

///|
#borrow(handle)
extern "c" fn native_face_slot_outline_contours(handle : NativeFtFace) -> FixedArray[UInt] = "bikallem_freetype_native_face_slot_outline_contours"

///|
#borrow(handle)
extern "c" fn native_face_slot_outline_flags(handle : NativeFtFace) -> Int = "bikallem_freetype_native_face_slot_outline_flags"

///|
#borrow(handle)
extern "c" fn native_face_slot_bitmap_meta(handle : NativeFtFace) -> FixedArray[Int64] = "bikallem_freetype_native_face_slot_bitmap_meta"

///|
#borrow(handle)
extern "c" fn native_face_slot_bitmap_buffer(handle : NativeFtFace) -> Bytes = "bikallem_freetype_native_face_slot_bitmap_buffer"

///|
#borrow(handle)
extern "c" fn native_face_get_kerning(handle : NativeFtFace, left : UInt, right : UInt) -> Int = "bikallem_freetype_native_face_get_kerning"

///|
#borrow(handle)
extern "c" fn native_face_glyph_name(handle : NativeFtFace, glyph_index : UInt) -> Bytes = "bikallem_freetype_native_face_glyph_name"

///|
#borrow(handle, data)
extern "c" fn native_face_attach_metrics(handle : NativeFtFace, data : Bytes) -> Int = "bikallem_freetype_native_face_attach_metrics"

///|
#borrow(handle)
extern "c" fn native_face_var_axis_tags(handle : NativeFtFace) -> FixedArray[UInt] = "bikallem_freetype_native_face_var_axis_tags"

///|
#borrow(handle)
extern "c" fn native_face_var_axis_defaults(handle : NativeFtFace) -> FixedArray[Int64] = "bikallem_freetype_native_face_var_axis_defaults"

///|
#borrow(handle, coords)
extern "c" fn native_face_set_var_design_coordinates(handle : NativeFtFace, coords : FixedArray[Int64]) -> Int = "bikallem_freetype_native_face_set_var_design_coordinates"

///|
#borrow(handle)
extern "c" fn native_face_var_blend_coords(handle : NativeFtFace) -> FixedArray[Int64] = "bikallem_freetype_native_face_var_blend_coords"
