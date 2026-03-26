///|
/// Bitmap strike size descriptor.
struct BitmapSize {
  height : Int // vertical pixel distance between baselines
  width : Int // average glyph width in pixels
  size : Int64 // nominal size in 26.6 fractional points
  x_ppem : Int64 // horizontal ppem in 26.6
  y_ppem : Int64 // vertical ppem in 26.6
} derive(Eq, Show)

///|
pub fn BitmapSize::new(
  height : Int,
  width : Int,
  size : Int64,
  x_ppem : Int64,
  y_ppem : Int64,
) -> BitmapSize {
  { height, width, size, x_ppem, y_ppem }
}

///|
/// Core face record containing font metadata and state.
/// Replaces C's FT_FaceRec. Mutable because glyph loading mutates state.
struct FaceRec {
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

  // --- Font variations ---
  mut var_coords : Array[Int] // normalized variation coordinates (empty = default instance)

  // --- Direct char_index function (avoids enum dispatch per call) ---
  mut char_index_fn : (UInt) -> UInt

  // --- Format-specific data ---
  // The font driver stores its own data here. In C this was TT_FaceRec,
  // CFF_FontRec, etc. We use a trait object approach.
  mut driver_data : DriverData
} derive(Show)

///|
/// Size object: holds size-specific metrics.
struct SizeRec {
  mut metrics : @types.SizeMetrics
} derive(Show)

///|
pub fn SizeRec::new() -> SizeRec {
  { metrics: @types.SizeMetrics::new() }
}

///|
pub fn SizeRec::set_metrics(self : SizeRec, v : @types.SizeMetrics) -> Unit {
  self.metrics = v
}

///|
/// Glyph slot: holds the result of loading a single glyph.
/// Reused across glyph loads (mutable).
struct GlyphSlot {
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
    advance: @types.Vector::new(0L, 0L),
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
struct SubGlyph {
  index : UInt // glyph index of component
  flags : UInt // composite flags
  arg1 : Int // first argument (offset or point index)
  arg2 : Int // second argument
  transform : @fixed.Matrix // 2x2 transformation matrix
} derive(Show)

///|
pub fn SubGlyph::new(
  index : UInt,
  flags : UInt,
  arg1 : Int,
  arg2 : Int,
  transform : @fixed.Matrix,
) -> SubGlyph {
  { index, flags, arg1, arg2, transform }
}

///|
/// Opaque driver-specific data. Each font format stores parsed data here.
/// The root package (lib.mbt) sets this; sub-packages read it via pattern matching.
pub(all) enum DriverData {
  Empty
  /// SFNT data stored as: (cmap_lookup_fn, glyph_load_fn, kern_fn, raw_data)
  /// Using closures to avoid circular dependency between base and sfnt/truetype/cff.
  SfntDriver(SfntOps)
  /// Bitmap-only fonts (BDF/PCF) use a dedicated glyph-loading path.
  BitmapOps(BitmapOps)
  /// Type 1 data stored with closures for charmap and glyph loading.
  Type1Ops(Type1Ops)
}

///|
pub impl Show for DriverData with output(self, logger) {
  match self {
    Empty => logger.write_string("Empty")
    SfntDriver(_) => logger.write_string("SfntDriver(...)")
    BitmapOps(_) => logger.write_string("BitmapOps(...)")
    Type1Ops(_) => logger.write_string("Type1Ops(...)")
  }
}

///|
/// SFNT driver operations — closures that capture the parsed font data.
struct SfntOps {
  char_index : (UInt) -> UInt // charcode → glyph index
  char_variant_index : (UInt, UInt) -> UInt // (charcode, selector) → glyph index
  char_variant_is_default : (UInt, UInt) -> Int // (charcode, selector) → 1,0,-1
  variant_selectors : () -> Array[UInt]
  variants_of_char : (UInt) -> Array[UInt]
  chars_of_variant : (UInt) -> Array[UInt]
  load_glyph : (UInt, Int) -> (
    GlyphSlotData,
    @types.Outline,
    Bytes,
    Array[@types.Vector],
  ) raise @error.FTError // (glyph_index, load_flags) → (slot data, outline, tt instructions, tt phantoms)
  get_kerning : (UInt, UInt) -> Int // (left, right) → kern value
  apply_hints : (@types.Outline, @fixed.Fixed) -> Bool // (outline, y_scale) → true if PS hints were applied
  tt_hint : (
    @types.Outline,
    Bytes,
    Array[@types.Vector],
    @fixed.Fixed,
    @fixed.Fixed,
    UInt,
  ) -> Bool // (outline, instructions, tt phantoms, x_scale, y_scale, ppem) → true if TT hints were applied
  num_glyphs : UInt
  raw_data : Bytes // font file bytes (for re-parsing if needed)
}

///|
pub fn SfntOps::new(
  char_index~ : (UInt) -> UInt,
  char_variant_index~ : (UInt, UInt) -> UInt,
  char_variant_is_default~ : (UInt, UInt) -> Int,
  variant_selectors~ : () -> Array[UInt],
  variants_of_char~ : (UInt) -> Array[UInt],
  chars_of_variant~ : (UInt) -> Array[UInt],
  load_glyph~ : (UInt, Int) -> (
    GlyphSlotData,
    @types.Outline,
    Bytes,
    Array[@types.Vector],
  ) raise @error.FTError,
  get_kerning~ : (UInt, UInt) -> Int,
  apply_hints~ : (@types.Outline, @fixed.Fixed) -> Bool,
  tt_hint~ : (
    @types.Outline,
    Bytes,
    Array[@types.Vector],
    @fixed.Fixed,
    @fixed.Fixed,
    UInt,
  ) -> Bool,
  num_glyphs~ : UInt,
  raw_data~ : Bytes,
) -> SfntOps {
  {
    char_index,
    char_variant_index,
    char_variant_is_default,
    variant_selectors,
    variants_of_char,
    chars_of_variant,
    load_glyph,
    get_kerning,
    apply_hints,
    tt_hint,
    num_glyphs,
    raw_data,
  }
}

///|
pub impl Show for SfntOps with output(self, logger) {
  logger.write_string("SfntOps { num_glyphs: ")
  self.num_glyphs.output(logger)
  logger.write_string(" }")
}

///|
/// Data returned from glyph loading (before being stored in GlyphSlot).
struct GlyphSlotData {
  metrics_width : Int64
  metrics_height : Int64
  metrics_hori_bearing_x : Int64
  metrics_hori_bearing_y : Int64
  metrics_hori_advance : Int64
  metrics_vert_bearing_x : Int64
  metrics_vert_bearing_y : Int64
  metrics_vert_advance : Int64
} derive(Show)

///|
pub fn GlyphSlotData::new(
  metrics_width : Int64,
  metrics_height : Int64,
  metrics_hori_bearing_x : Int64,
  metrics_hori_bearing_y : Int64,
  metrics_hori_advance : Int64,
  metrics_vert_bearing_x? : Int64 = 0L,
  metrics_vert_bearing_y? : Int64 = 0L,
  metrics_vert_advance? : Int64 = 0L,
) -> GlyphSlotData {
  {
    metrics_width,
    metrics_height,
    metrics_hori_bearing_x,
    metrics_hori_bearing_y,
    metrics_hori_advance,
    metrics_vert_bearing_x,
    metrics_vert_bearing_y,
    metrics_vert_advance,
  }
}

///|
struct BitmapGlyphData {
  slot_data : GlyphSlotData
  bitmap : @types.Bitmap
  bitmap_left : Int
  bitmap_top : Int
} derive(Show)

///|
pub fn BitmapGlyphData::new(
  slot_data : GlyphSlotData,
  bitmap : @types.Bitmap,
  bitmap_left : Int,
  bitmap_top : Int,
) -> BitmapGlyphData {
  { slot_data, bitmap, bitmap_left, bitmap_top }
}

///|
struct BitmapOps {
  load_glyph : (UInt, Int) -> BitmapGlyphData raise @error.FTError
}

///|
pub fn BitmapOps::new(
  load_glyph~ : (UInt, Int) -> BitmapGlyphData raise @error.FTError,
) -> BitmapOps {
  { load_glyph, }
}

///|
pub impl Show for BitmapOps with output(self, logger) {
  logger.write_string("BitmapOps(...)")
  ignore(self)
}

///|
/// Type 1 driver operations.
struct Type1Ops {
  char_index : (UInt) -> UInt
  load_glyph : (UInt, Int) -> (GlyphSlotData, @types.Outline) raise @error.FTError
  apply_hints : (@types.Outline, @fixed.Fixed) -> Bool
}

///|
pub fn Type1Ops::new(
  char_index~ : (UInt) -> UInt,
  load_glyph~ : (UInt, Int) -> (GlyphSlotData, @types.Outline) raise @error.FTError,
  apply_hints~ : (@types.Outline, @fixed.Fixed) -> Bool,
) -> Type1Ops {
  { char_index, load_glyph, apply_hints }
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
    var_coords: [],
    char_index_fn: fn(_c) { 0U },
    glyph: GlyphSlot::new(),
    size: SizeRec::new(),
    driver_data: DriverData::Empty,
  }
}

///|
pub fn FaceRec::char_index_fn(self : FaceRec) -> (UInt) -> UInt {
  self.char_index_fn
}

///|
pub fn FaceRec::set_char_index_fn(self : FaceRec, f : (UInt) -> UInt) -> Unit {
  self.char_index_fn = f
}

// --- Face flag query helpers ---

///|
pub fn FaceRec::is_scalable(self : FaceRec) -> Bool {
  (self.face_flags & FACE_FLAG_SCALABLE) != 0L
}

///|
pub fn FaceRec::has_fixed_sizes(self : FaceRec) -> Bool {
  (self.face_flags & FACE_FLAG_FIXED_SIZES) != 0L
}

///|
pub fn FaceRec::is_fixed_width(self : FaceRec) -> Bool {
  (self.face_flags & FACE_FLAG_FIXED_WIDTH) != 0L
}

///|
pub fn FaceRec::is_sfnt(self : FaceRec) -> Bool {
  (self.face_flags & FACE_FLAG_SFNT) != 0L
}

///|
pub fn FaceRec::has_horizontal(self : FaceRec) -> Bool {
  (self.face_flags & FACE_FLAG_HORIZONTAL) != 0L
}

///|
pub fn FaceRec::has_vertical(self : FaceRec) -> Bool {
  (self.face_flags & FACE_FLAG_VERTICAL) != 0L
}

///|
pub fn FaceRec::has_kerning(self : FaceRec) -> Bool {
  (self.face_flags & FACE_FLAG_KERNING) != 0L
}

///|
pub fn FaceRec::has_multiple_masters(self : FaceRec) -> Bool {
  (self.face_flags & FACE_FLAG_MULTIPLE_MASTERS) != 0L
}

///|
pub fn FaceRec::has_glyph_names(self : FaceRec) -> Bool {
  (self.face_flags & FACE_FLAG_GLYPH_NAMES) != 0L
}

///|
pub fn FaceRec::has_color(self : FaceRec) -> Bool {
  (self.face_flags & FACE_FLAG_COLOR) != 0L
}

///|
pub fn FaceRec::is_variation(self : FaceRec) -> Bool {
  (self.face_flags & FACE_FLAG_VARIATION) != 0L
}

// --- FaceRec setters (for external packages) ---

///|
pub fn FaceRec::set_face_flags(self : FaceRec, v : Int64) -> Unit {
  self.face_flags = v
}

///|
pub fn FaceRec::set_style_flags(self : FaceRec, v : Int) -> Unit {
  self.style_flags = v
}

///|
pub fn FaceRec::set_num_glyphs(self : FaceRec, v : Int64) -> Unit {
  self.num_glyphs = v
}

///|
pub fn FaceRec::set_family_name(self : FaceRec, v : String) -> Unit {
  self.family_name = v
}

///|
pub fn FaceRec::set_style_name(self : FaceRec, v : String) -> Unit {
  self.style_name = v
}

///|
pub fn FaceRec::set_available_sizes(
  self : FaceRec,
  v : Array[BitmapSize],
) -> Unit {
  self.available_sizes = v
}

///|
pub fn FaceRec::set_bbox(self : FaceRec, v : @types.BBox) -> Unit {
  self.bbox = v
}

///|
pub fn FaceRec::set_units_per_em(self : FaceRec, v : UInt) -> Unit {
  self.units_per_em = v
}

///|
pub fn FaceRec::set_ascender(self : FaceRec, v : Int) -> Unit {
  self.ascender = v
}

///|
pub fn FaceRec::set_descender(self : FaceRec, v : Int) -> Unit {
  self.descender = v
}

///|
pub fn FaceRec::set_height(self : FaceRec, v : Int) -> Unit {
  self.height = v
}

///|
pub fn FaceRec::set_max_advance_width(self : FaceRec, v : Int) -> Unit {
  self.max_advance_width = v
}

///|
pub fn FaceRec::set_max_advance_height(self : FaceRec, v : Int) -> Unit {
  self.max_advance_height = v
}

///|
pub fn FaceRec::set_underline_position(self : FaceRec, v : Int) -> Unit {
  self.underline_position = v
}

///|
pub fn FaceRec::set_underline_thickness(self : FaceRec, v : Int) -> Unit {
  self.underline_thickness = v
}

///|
pub fn FaceRec::set_active_charmap(self : FaceRec, v : Int) -> Unit {
  self.active_charmap = v
}

///|
pub fn FaceRec::set_driver_data(self : FaceRec, v : DriverData) -> Unit {
  self.driver_data = v
}

///|
pub fn FaceRec::set_var_coords(self : FaceRec, v : Array[Int]) -> Unit {
  self.var_coords = v
}

// --- GlyphSlot setters (for external packages) ---

///|
pub fn GlyphSlot::set_glyph_index(self : GlyphSlot, v : UInt) -> Unit {
  self.glyph_index = v
}

///|
pub fn GlyphSlot::set_format(self : GlyphSlot, v : @types.GlyphFormat) -> Unit {
  self.format = v
}

///|
pub fn GlyphSlot::set_outline(self : GlyphSlot, v : @types.Outline) -> Unit {
  self.outline = v
}

///|
pub fn GlyphSlot::set_bitmap(self : GlyphSlot, v : @types.Bitmap) -> Unit {
  self.bitmap = v
}

///|
pub fn GlyphSlot::set_bitmap_left(self : GlyphSlot, v : Int) -> Unit {
  self.bitmap_left = v
}

///|
pub fn GlyphSlot::set_bitmap_top(self : GlyphSlot, v : Int) -> Unit {
  self.bitmap_top = v
}

///|
pub fn GlyphSlot::set_advance(self : GlyphSlot, v : @types.Vector) -> Unit {
  self.advance = v
}

///|
pub fn GlyphSlot::set_linear_hori_advance(
  self : GlyphSlot,
  v : @fixed.Fixed,
) -> Unit {
  self.linear_hori_advance = v
}

///|
pub fn GlyphSlot::set_linear_vert_advance(
  self : GlyphSlot,
  v : @fixed.Fixed,
) -> Unit {
  self.linear_vert_advance = v
}

///|
pub fn GlyphSlot::set_lsb_delta(self : GlyphSlot, v : Int64) -> Unit {
  self.lsb_delta = v
}

///|
pub fn GlyphSlot::set_rsb_delta(self : GlyphSlot, v : Int64) -> Unit {
  self.rsb_delta = v
}

///|
pub fn GlyphSlot::set_num_subglyphs(self : GlyphSlot, v : UInt) -> Unit {
  self.num_subglyphs = v
}

///|
pub fn GlyphSlot::set_subglyphs(self : GlyphSlot, v : Array[SubGlyph]) -> Unit {
  self.subglyphs = v
}

// --- FaceRec getters (for external packages) ---

///|
pub fn FaceRec::num_faces(self : FaceRec) -> Int64 {
  self.num_faces
}

///|
pub fn FaceRec::face_index(self : FaceRec) -> Int64 {
  self.face_index
}

///|
pub fn FaceRec::face_flags(self : FaceRec) -> Int64 {
  self.face_flags
}

///|
pub fn FaceRec::style_flags(self : FaceRec) -> Int {
  self.style_flags
}

///|
pub fn FaceRec::num_glyphs(self : FaceRec) -> Int64 {
  self.num_glyphs
}

///|
pub fn FaceRec::family_name(self : FaceRec) -> String {
  self.family_name
}

///|
pub fn FaceRec::style_name(self : FaceRec) -> String {
  self.style_name
}

///|
pub fn FaceRec::available_sizes(self : FaceRec) -> Array[BitmapSize] {
  self.available_sizes
}

///|
pub fn FaceRec::charmaps(self : FaceRec) -> Array[CharMapRec] {
  self.charmaps
}

///|
pub fn FaceRec::active_charmap(self : FaceRec) -> Int {
  self.active_charmap
}

///|
pub fn FaceRec::bbox(self : FaceRec) -> @types.BBox {
  self.bbox
}

///|
pub fn FaceRec::units_per_em(self : FaceRec) -> UInt {
  self.units_per_em
}

///|
pub fn FaceRec::ascender(self : FaceRec) -> Int {
  self.ascender
}

///|
pub fn FaceRec::descender(self : FaceRec) -> Int {
  self.descender
}

///|
pub fn FaceRec::height(self : FaceRec) -> Int {
  self.height
}

///|
pub fn FaceRec::max_advance_width(self : FaceRec) -> Int {
  self.max_advance_width
}

///|
pub fn FaceRec::max_advance_height(self : FaceRec) -> Int {
  self.max_advance_height
}

///|
pub fn FaceRec::underline_position(self : FaceRec) -> Int {
  self.underline_position
}

///|
pub fn FaceRec::underline_thickness(self : FaceRec) -> Int {
  self.underline_thickness
}

///|
pub fn FaceRec::glyph(self : FaceRec) -> GlyphSlot {
  self.glyph
}

///|
pub fn FaceRec::size(self : FaceRec) -> SizeRec {
  self.size
}

///|
pub fn FaceRec::var_coords(self : FaceRec) -> Array[Int] {
  self.var_coords
}

///|
pub fn FaceRec::driver_data(self : FaceRec) -> DriverData {
  self.driver_data
}

// --- GlyphSlot getters (for external packages) ---

///|
pub fn GlyphSlot::glyph_index(self : GlyphSlot) -> UInt {
  self.glyph_index
}

///|
pub fn GlyphSlot::metrics(self : GlyphSlot) -> @types.GlyphMetrics {
  self.metrics
}

///|
pub fn GlyphSlot::linear_hori_advance(self : GlyphSlot) -> @fixed.Fixed {
  self.linear_hori_advance
}

///|
pub fn GlyphSlot::linear_vert_advance(self : GlyphSlot) -> @fixed.Fixed {
  self.linear_vert_advance
}

///|
pub fn GlyphSlot::advance(self : GlyphSlot) -> @types.Vector {
  self.advance
}

///|
pub fn GlyphSlot::format(self : GlyphSlot) -> @types.GlyphFormat {
  self.format
}

///|
pub fn GlyphSlot::bitmap(self : GlyphSlot) -> @types.Bitmap {
  self.bitmap
}

///|
pub fn GlyphSlot::bitmap_left(self : GlyphSlot) -> Int {
  self.bitmap_left
}

///|
pub fn GlyphSlot::bitmap_top(self : GlyphSlot) -> Int {
  self.bitmap_top
}

///|
pub fn GlyphSlot::outline(self : GlyphSlot) -> @types.Outline {
  self.outline
}

///|
pub fn GlyphSlot::lsb_delta(self : GlyphSlot) -> Int64 {
  self.lsb_delta
}

///|
pub fn GlyphSlot::rsb_delta(self : GlyphSlot) -> Int64 {
  self.rsb_delta
}

///|
pub fn GlyphSlot::num_subglyphs(self : GlyphSlot) -> UInt {
  self.num_subglyphs
}

///|
pub fn GlyphSlot::subglyphs(self : GlyphSlot) -> Array[SubGlyph] {
  self.subglyphs
}

// --- SizeRec getters ---

///|
pub fn SizeRec::metrics(self : SizeRec) -> @types.SizeMetrics {
  self.metrics
}

// --- GlyphSlotData getters ---

///|
pub fn GlyphSlotData::metrics_width(self : GlyphSlotData) -> Int64 {
  self.metrics_width
}

///|
pub fn GlyphSlotData::metrics_height(self : GlyphSlotData) -> Int64 {
  self.metrics_height
}

///|
pub fn GlyphSlotData::metrics_hori_bearing_x(self : GlyphSlotData) -> Int64 {
  self.metrics_hori_bearing_x
}

///|
pub fn GlyphSlotData::metrics_hori_bearing_y(self : GlyphSlotData) -> Int64 {
  self.metrics_hori_bearing_y
}

///|
pub fn GlyphSlotData::metrics_hori_advance(self : GlyphSlotData) -> Int64 {
  self.metrics_hori_advance
}

///|
pub fn GlyphSlotData::metrics_vert_bearing_x(self : GlyphSlotData) -> Int64 {
  self.metrics_vert_bearing_x
}

///|
pub fn GlyphSlotData::metrics_vert_bearing_y(self : GlyphSlotData) -> Int64 {
  self.metrics_vert_bearing_y
}

///|
pub fn GlyphSlotData::metrics_vert_advance(self : GlyphSlotData) -> Int64 {
  self.metrics_vert_advance
}

// --- BitmapGlyphData getters ---

///|
pub fn BitmapGlyphData::slot_data(self : BitmapGlyphData) -> GlyphSlotData {
  self.slot_data
}

///|
pub fn BitmapGlyphData::bitmap(self : BitmapGlyphData) -> @types.Bitmap {
  self.bitmap
}

///|
pub fn BitmapGlyphData::bitmap_left(self : BitmapGlyphData) -> Int {
  self.bitmap_left
}

///|
pub fn BitmapGlyphData::bitmap_top(self : BitmapGlyphData) -> Int {
  self.bitmap_top
}

// --- SfntOps getters ---

///|
pub fn SfntOps::char_index(self : SfntOps) -> (UInt) -> UInt {
  self.char_index
}

///|
pub fn SfntOps::load_glyph(
  self : SfntOps,
) -> (UInt, Int) -> (GlyphSlotData, @types.Outline, Bytes, Array[@types.Vector]) raise @error.FTError {
  self.load_glyph
}

///|
pub fn SfntOps::char_variant_index(self : SfntOps) -> (UInt, UInt) -> UInt {
  self.char_variant_index
}

///|
pub fn SfntOps::char_variant_is_default(self : SfntOps) -> (UInt, UInt) -> Int {
  self.char_variant_is_default
}

///|
pub fn SfntOps::variant_selectors(self : SfntOps) -> () -> Array[UInt] {
  self.variant_selectors
}

///|
pub fn SfntOps::variants_of_char(self : SfntOps) -> (UInt) -> Array[UInt] {
  self.variants_of_char
}

///|
pub fn SfntOps::chars_of_variant(self : SfntOps) -> (UInt) -> Array[UInt] {
  self.chars_of_variant
}

///|
pub fn SfntOps::get_kerning(self : SfntOps) -> (UInt, UInt) -> Int {
  self.get_kerning
}

///|
pub fn SfntOps::apply_hints(
  self : SfntOps,
) -> (@types.Outline, @fixed.Fixed) -> Bool {
  self.apply_hints
}

///|
pub fn SfntOps::tt_hint(
  self : SfntOps,
) -> (
  @types.Outline,
  Bytes,
  Array[@types.Vector],
  @fixed.Fixed,
  @fixed.Fixed,
  UInt,
) -> Bool {
  self.tt_hint
}

///|
pub fn SfntOps::num_glyphs(self : SfntOps) -> UInt {
  self.num_glyphs
}

///|
pub fn SfntOps::raw_data(self : SfntOps) -> Bytes {
  self.raw_data
}

// --- BitmapOps getters ---

///|
pub fn BitmapOps::load_glyph(
  self : BitmapOps,
) -> (UInt, Int) -> BitmapGlyphData raise @error.FTError {
  self.load_glyph
}

// --- Type1Ops getters ---

///|
pub fn Type1Ops::char_index(self : Type1Ops) -> (UInt) -> UInt {
  self.char_index
}

///|
pub fn Type1Ops::load_glyph(
  self : Type1Ops,
) -> (UInt, Int) -> (GlyphSlotData, @types.Outline) raise @error.FTError {
  self.load_glyph
}

///|
pub fn Type1Ops::apply_hints(
  self : Type1Ops,
) -> (@types.Outline, @fixed.Fixed) -> Bool {
  self.apply_hints
}

// --- SubGlyph getters ---

///|
pub fn SubGlyph::index(self : SubGlyph) -> UInt {
  self.index
}

///|
pub fn SubGlyph::flags(self : SubGlyph) -> UInt {
  self.flags
}

///|
pub fn SubGlyph::arg1(self : SubGlyph) -> Int {
  self.arg1
}

///|
pub fn SubGlyph::arg2(self : SubGlyph) -> Int {
  self.arg2
}

///|
pub fn SubGlyph::transform(self : SubGlyph) -> @fixed.Matrix {
  self.transform
}

// --- CharMapRec getters ---

///|
pub fn CharMapRec::encoding(self : CharMapRec) -> Encoding {
  self.encoding
}

///|
pub fn CharMapRec::platform_id(self : CharMapRec) -> UInt {
  self.platform_id
}

///|
pub fn CharMapRec::encoding_id(self : CharMapRec) -> UInt {
  self.encoding_id
}
