///|
fn extract_bdf_family_name(font_name : String) -> String {
  let len = font_name.length()
  if len == 0 || font_name[0] != '-' {
    return font_name
  }
  let mut field_start = 1
  let mut field_index = 0
  for i in 1..<len {
    if font_name[i] == '-' {
      if field_index == 1 && i > field_start {
        return font_name[field_start:i].to_string()
      }
      field_index += 1
      field_start = i + 1
    }
  }
  font_name
}

///|
fn make_bdf_bitmap(glyph : @bdf.BdfGlyph) -> @types.Bitmap {
  let bitmap = @types.Bitmap::new()
  let width = glyph.bbx_width()
  let height = glyph.bbx_height()
  let pitch = if width <= 0 { 0 } else { (width + 7) / 8 }
  bitmap.set_rows(height.reinterpret_as_uint())
  bitmap.set_width(width.reinterpret_as_uint())
  bitmap.set_pitch(pitch)
  bitmap.set_buffer(glyph.bitmap())
  bitmap.set_num_grays(2U)
  bitmap.set_pixel_mode(@types.PixelMode::Mono)
  bitmap
}

///|
fn glyph_advance_width(glyph : @bdf.BdfGlyph) -> Int {
  let dwidth = glyph.dwidth_x()
  if dwidth != 0 {
    dwidth
  } else {
    glyph.bbx_width()
  }
}

///|
fn load_bdf(data : Bytes) -> @base.FaceRec raise @error.FTError {
  let font = @bdf.parse_bdf_header(data)
  let face = @base.FaceRec::new()
  let glyphs = font.glyphs()
  let num_chars = font.num_chars()
  let family_name = extract_bdf_family_name(font.font_name())
  let mut max_advance_width = font.bbx_width()
  for _, glyph in glyphs {
    max_advance_width = max_advance_width.max(glyph_advance_width(glyph))
  }
  face.set_family_name(family_name)
  face.set_face_flags(@base.FACE_FLAG_FIXED_SIZES | @base.FACE_FLAG_HORIZONTAL)
  face.set_num_glyphs((num_chars + 1).to_int64())
  face.set_ascender(font.bbx_height() + font.bbx_y_offset())
  face.set_descender(font.bbx_y_offset())
  face.set_height(font.bbx_height())
  face.set_max_advance_width(max_advance_width)
  face.set_max_advance_height(font.bbx_height())
  let strike_ppem = font.point_size().to_int64() << 6
  face.set_available_sizes([
    @base.BitmapSize::new(
      font.bbx_height(),
      font.bbx_width(),
      strike_ppem,
      strike_ppem,
      strike_ppem,
    ),
  ])
  face.charmaps().push(@base.CharMapRec::new(@base.Encoding::Unicode, 3U, 1U))
  face.set_active_charmap(0)

  let cmap : Map[UInt, UInt] = {}
  let use_dense_unicode_map = glyphs.length() != num_chars
  if !use_dense_unicode_map {
    for i, glyph in glyphs {
      let encoding = glyph.encoding()
      if encoding >= 0 {
        cmap[encoding.reinterpret_as_uint()] = (i + 1).reinterpret_as_uint()
      }
    }
  }
  let char_index_fn : (UInt) -> UInt = fn(charcode) {
    if use_dense_unicode_map {
      if charcode.reinterpret_as_int() < num_chars {
        charcode + 1U
      } else {
        0U
      }
    } else {
      match cmap.get(charcode) {
        Some(gid) => gid
        None => 0U
      }
    }
  }
  let load_glyph_fn : (UInt, Int) -> @base.BitmapGlyphData raise @error.FTError = fn(
    glyph_index,
    load_flags,
  ) raise @error.FTError {
    ignore(load_flags)
    if glyph_index == 0U {
      return @base.BitmapGlyphData::new(
        @base.GlyphSlotData::new(0L, 0L, 0L, 0L, 0L),
        @types.Bitmap::new(),
        0,
        0,
      )
    }
    let index = glyph_index.reinterpret_as_int() - 1
    if index < 0 || index >= num_chars {
      raise @error.FTError::InvalidGlyphIndex
    }
    let maybe_glyph = if index < glyphs.length() {
      Some(glyphs[index])
    } else {
      font.get_glyph(index)
    }
    match maybe_glyph {
      Some(glyph) => {
        let top = glyph.bbx_height() + glyph.bbx_y_offset()
        let advance = glyph_advance_width(glyph)
        let slot_data = @base.GlyphSlotData::new(
          glyph.bbx_width().to_int64(),
          glyph.bbx_height().to_int64(),
          glyph.bbx_x_offset().to_int64(),
          top.to_int64(),
          advance.to_int64(),
        )
        @base.BitmapGlyphData::new(
          slot_data,
          make_bdf_bitmap(glyph),
          glyph.bbx_x_offset(),
          top,
        )
      }
      None =>
        @base.BitmapGlyphData::new(
          @base.GlyphSlotData::new(0L, 0L, 0L, 0L, 0L),
          @types.Bitmap::new(),
          0,
          0,
        )
    }
  }
  face.set_char_index_fn(char_index_fn)
  face.set_driver_data(
    @base.DriverData::BitmapOps(@base.BitmapOps::new(load_glyph=load_glyph_fn)),
  )
  face
}
