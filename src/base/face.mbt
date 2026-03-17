///|
/// Bitmap strike size descriptor.
pub(all) struct BitmapSize {
  height : Int // vertical pixel distance between baselines
  width : Int // average glyph width in pixels
  size : Int64 // nominal size in 26.6 fractional points
  x_ppem : Int64 // horizontal ppem in 26.6
  y_ppem : Int64 // vertical ppem in 26.6
} derive(Eq, Show)

///|
/// Core face record containing font metadata and state.
/// Replaces C's FT_FaceRec. Mutable because glyph loading mutates state.
pub(all) struct FaceRec {
  // --- Identification ---
  num_faces : Int64 // number of faces in the font file
  face_index : Int64 // index of this face in the file

  // --- Flags ---
  mut face_flags : Int64 // FT_FACE_FLAG_* bitmask
  mut style_flags : Int // FT_STYLE_FLAG_* bitmask

  // --- Glyph count ---
  mut num_glyphs : Int64

  // --- Names ---
  mut family_name : String
  mut style_name : String

  // --- Bitmap strikes ---
  mut available_sizes : Array[BitmapSize]

  // --- Character maps ---
  mut charmaps : Array[CharMapRec]
  mut active_charmap : Int // index into charmaps, -1 if none

  // --- Scalable outline metrics (font units) ---
  mut bbox : @types.BBox
  mut units_per_em : UInt
  mut ascender : Int
  mut descender : Int
  mut height : Int
  mut max_advance_width : Int
  mut max_advance_height : Int
  mut underline_position : Int
  mut underline_thickness : Int

  // --- Current state ---
  mut glyph : GlyphSlot
  mut size : SizeRec

  // --- Format-specific data ---
  // The font driver stores its own data here. In C this was TT_FaceRec,
  // CFF_FontRec, etc. We use a trait object approach.
  mut driver_data : DriverData
} derive(Show)

///|
/// Size object: holds size-specific metrics.
pub(all) struct SizeRec {
  mut metrics : @types.SizeMetrics
} derive(Show)

///|
pub fn SizeRec::new() -> SizeRec {
  {
    metrics: {
      x_ppem: 0U,
      y_ppem: 0U,
      x_scale: @fixed.Fixed::zero(),
      y_scale: @fixed.Fixed::zero(),
      ascender: 0L,
      descender: 0L,
      height: 0L,
      max_advance: 0L,
    },
  }
}

///|
/// Glyph slot: holds the result of loading a single glyph.
/// Reused across glyph loads (mutable).
pub(all) struct GlyphSlot {
  mut glyph_index : UInt
  mut metrics : @types.GlyphMetrics
  mut linear_hori_advance : @fixed.Fixed // 16.16 unhinted
  mut linear_vert_advance : @fixed.Fixed // 16.16 unhinted
  mut advance : @types.Vector // 26.6 transformed hinted
  mut format : @types.GlyphFormat
  mut bitmap : @types.Bitmap
  mut bitmap_left : Int
  mut bitmap_top : Int
  mut outline : @types.Outline
  mut lsb_delta : Int64
  mut rsb_delta : Int64
  mut num_subglyphs : UInt
  mut subglyphs : Array[SubGlyph]
} derive(Show)

///|
pub fn GlyphSlot::new() -> GlyphSlot {
  {
    glyph_index: 0U,
    metrics: @types.GlyphMetrics::new(),
    linear_hori_advance: @fixed.Fixed::zero(),
    linear_vert_advance: @fixed.Fixed::zero(),
    advance: { x: 0L, y: 0L },
    format: @types.GlyphFormat::None,
    bitmap: @types.Bitmap::new(),
    bitmap_left: 0,
    bitmap_top: 0,
    outline: @types.Outline::new(),
    lsb_delta: 0L,
    rsb_delta: 0L,
    num_subglyphs: 0U,
    subglyphs: [],
  }
}

///|
/// Sub-glyph record for composite glyphs.
pub(all) struct SubGlyph {
  index : UInt // glyph index of component
  flags : UInt // composite flags
  arg1 : Int // first argument (offset or point index)
  arg2 : Int // second argument
  transform : @fixed.Matrix // 2x2 transformation matrix
} derive(Show)

///|
/// Opaque driver-specific data. Each font format stores parsed data here.
/// The root package (lib.mbt) sets this; sub-packages read it via pattern matching.
pub(all) enum DriverData {
  Empty
  /// SFNT data stored as: (cmap_lookup_fn, glyph_load_fn, kern_fn, raw_data)
  /// Using closures to avoid circular dependency between base and sfnt/truetype/cff.
  SfntDriver(SfntOps)
  /// Type 1 data stored with closures for charmap and glyph loading.
  Type1Ops(Type1Ops)
}

///|
pub impl Show for DriverData with output(self, logger) {
  match self {
    Empty => logger.write_string("Empty")
    SfntDriver(_) => logger.write_string("SfntDriver(...)")
    Type1Ops(_) => logger.write_string("Type1Ops(...)")
  }
}

///|
/// SFNT driver operations — closures that capture the parsed font data.
pub(all) struct SfntOps {
  char_index : (UInt) -> UInt // charcode → glyph index
  load_glyph : (UInt, Int) -> (GlyphSlotData, @types.Outline) raise @error.FTError // (glyph_index, load_flags) → slot data
  get_kerning : (UInt, UInt) -> Int // (left, right) → kern value
  num_glyphs : UInt
  raw_data : Bytes // font file bytes (for re-parsing if needed)
}

///|
pub impl Show for SfntOps with output(self, logger) {
  logger.write_string("SfntOps { num_glyphs: ")
  self.num_glyphs.output(logger)
  logger.write_string(" }")
}

///|
/// Data returned from glyph loading (before being stored in GlyphSlot).
pub(all) struct GlyphSlotData {
  metrics_width : Int64
  metrics_height : Int64
  metrics_hori_bearing_x : Int64
  metrics_hori_bearing_y : Int64
  metrics_hori_advance : Int64
} derive(Show)

///|
/// Type 1 driver operations.
pub(all) struct Type1Ops {
  char_index : (UInt) -> UInt
  load_glyph : (UInt, Int) -> (GlyphSlotData, @types.Outline) raise @error.FTError
}

///|
pub impl Show for Type1Ops with output(self, logger) {
  logger.write_string("Type1Ops(...)")
  ignore(self)
}

///|
/// Create a new empty face record.
pub fn FaceRec::new(
  num_faces? : Int64 = 1L,
  face_index? : Int64 = 0L,
) -> FaceRec {
  {
    num_faces,
    face_index,
    face_flags: 0L,
    style_flags: 0,
    num_glyphs: 0L,
    family_name: "",
    style_name: "",
    available_sizes: [],
    charmaps: [],
    active_charmap: -1,
    bbox: @types.BBox::empty(),
    units_per_em: 0U,
    ascender: 0,
    descender: 0,
    height: 0,
    max_advance_width: 0,
    max_advance_height: 0,
    underline_position: 0,
    underline_thickness: 0,
    glyph: GlyphSlot::new(),
    size: SizeRec::new(),
    driver_data: DriverData::Empty,
  }
}

// --- Face flag query helpers ---

///|
pub fn FaceRec::is_scalable(self : FaceRec) -> Bool {
  (self.face_flags & face_flag_scalable) != 0L
}

///|
pub fn FaceRec::has_fixed_sizes(self : FaceRec) -> Bool {
  (self.face_flags & face_flag_fixed_sizes) != 0L
}

///|
pub fn FaceRec::is_fixed_width(self : FaceRec) -> Bool {
  (self.face_flags & face_flag_fixed_width) != 0L
}

///|
pub fn FaceRec::is_sfnt(self : FaceRec) -> Bool {
  (self.face_flags & face_flag_sfnt) != 0L
}

///|
pub fn FaceRec::has_horizontal(self : FaceRec) -> Bool {
  (self.face_flags & face_flag_horizontal) != 0L
}

///|
pub fn FaceRec::has_vertical(self : FaceRec) -> Bool {
  (self.face_flags & face_flag_vertical) != 0L
}

///|
pub fn FaceRec::has_kerning(self : FaceRec) -> Bool {
  (self.face_flags & face_flag_kerning) != 0L
}

///|
pub fn FaceRec::has_multiple_masters(self : FaceRec) -> Bool {
  (self.face_flags & face_flag_multiple_masters) != 0L
}

///|
pub fn FaceRec::has_glyph_names(self : FaceRec) -> Bool {
  (self.face_flags & face_flag_glyph_names) != 0L
}

///|
pub fn FaceRec::has_color(self : FaceRec) -> Bool {
  (self.face_flags & face_flag_color) != 0L
}

///|
pub fn FaceRec::is_variation(self : FaceRec) -> Bool {
  (self.face_flags & face_flag_variation) != 0L
}
