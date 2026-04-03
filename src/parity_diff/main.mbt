///|
extern "C" fn exit(code : Int) = "exit"

///|
fn main {
  let args = @env.args()
  if args.length() != 3 {
    println(
      "Usage: moon run --target native src/parity_diff -- <font_path> <oracle.ndjson>",
    )
    exit(1)
  }

  let font_path = args[1]
  let oracle_path = args[2]
  let oracle_text = load_or_abort_string(oracle_path, "oracle")
  let lines = oracle_text.split("\n").collect()
  if lines.is_empty() {
    abort("oracle is empty: \{oracle_path}")
  }

  let header = parse_header(lines[0].trim().to_string(), oracle_path)
  let font_bytes = load_or_abort_bytes(font_path, "font")
  let face = load_face_or_abort(font_bytes, header.face_index, font_path)
  apply_variation(face, header.variation_coords, oracle_path)

  let state = DiffState::new(oracle_path)
  for raw_line in lines[1:] {
    let line = raw_line.trim().to_string()
    if line.is_empty() {
      continue
    }
    diff_line(face, state, line)
    if state.limit_reached() {
      break
    }
  }

  if state.mismatches > 0 {
    println(
      "DIFF FAILED: \{state.checked} cases checked, \{state.mismatches} mismatches in \{font_path}",
    )
    exit(1)
  }
  println("DIFF OK: \{state.checked} cases checked for \{font_path}")
}

///|
struct OracleHeader {
  face_index : Int
  variation_coords : Array[(String, Int64)]
}

///|
struct DiffState {
  oracle_path : String
  mut checked : Int
  mut mismatches : Int
  mismatch_limit : Int
  mut active_charmap : Int
  mut pixel_size : Int
} derive(Show)

///|
fn DiffState::new(oracle_path : String) -> DiffState {
  {
    oracle_path,
    checked: 0,
    mismatches: 0,
    mismatch_limit: 50,
    active_charmap: -2,
    pixel_size: -1,
  }
}

///|
fn DiffState::limit_reached(self : DiffState) -> Bool {
  self.mismatches >= self.mismatch_limit
}

///|
fn load_or_abort_string(path : String, kind : String) -> String {
  try @fs.read_file_to_string(path) catch {
    @fs.IOError(err) => abort("cannot read \{kind} \{path}: \{err}")
  } noraise {
    text => text
  }
}

///|
fn load_or_abort_bytes(path : String, kind : String) -> Bytes {
  try @fs.read_file_to_bytes(path) catch {
    @fs.IOError(err) => abort("cannot read \{kind} \{path}: \{err}")
  } noraise {
    bytes => bytes
  }
}

///|
fn load_face_or_abort(
  font_bytes : Bytes,
  face_index : Int,
  font_path : String,
) -> @base.FaceRec {
  try @freetype.from_bytes(font_bytes, face_index~) catch {
    err => abort("MoonBit failed to load \{font_path}: \{err}")
  } noraise {
    face => face
  }
}

///|
fn parse_header(line : String, oracle_path : String) -> OracleHeader {
  let obj = parse_object_line(line, oracle_path)
  guard get_required_string(obj, "kind", oracle_path) == "header" else {
    abort("oracle header kind mismatch in \{oracle_path}")
  }
  {
    face_index: get_required_int(obj, "face_index", oracle_path),
    variation_coords: get_variation_coords(obj, "variation_coords", oracle_path),
  }
}

///|
fn apply_variation(
  face : @base.FaceRec,
  coords : Array[(String, Int64)],
  oracle_path : String,
) -> Unit {
  if coords.is_empty() {
    return
  }
  let mapped : Array[(@fixed.Fixed, UInt)] = []
  for coord in coords {
    let (tag, raw_value) = coord
    mapped.push((@fixed.Fixed::from_raw(raw_value), tag_to_uint(tag)))
  }
  try @freetype.set_var_design_coordinates(face, mapped) catch {
    err => abort("failed to apply variation from \{oracle_path}: \{err}")
  } noraise {
    _ => ()
  }
}

///|
fn diff_line(face : @base.FaceRec, state : DiffState, line : String) -> Unit {
  let obj = parse_object_line(line, state.oracle_path)
  let kind = get_required_string(obj, "kind", state.oracle_path)
  state.checked += 1
  match kind {
    "charmap_meta" => diff_charmap_meta(face, state, obj)
    "charmap_entry" => diff_charmap_entry(face, state, obj)
    "glyph_outline" => diff_glyph_outline(face, state, obj)
    "glyph_bitmap" => diff_glyph_bitmap(face, state, obj)
    "render_bitmap" => diff_render_bitmap(face, state, obj)
    "kerning" => diff_kerning(face, state, obj)
    _ => record_mismatch(state, "unknown case kind: \{kind}")
  }
}

///|
fn diff_charmap_meta(
  face : @base.FaceRec,
  state : DiffState,
  obj : Map[String, Json],
) -> Unit {
  let index = get_required_int(obj, "charmap_index", state.oracle_path)
  let platform_id = get_required_int(obj, "platform_id", state.oracle_path)
  let encoding_id = get_required_int(obj, "encoding_id", state.oracle_path)
  let charmaps = face.charmaps()
  if index < 0 || index >= charmaps.length() {
    record_mismatch(
      state,
      "charmap_meta index=\{index}: face has \{charmaps.length()} charmaps",
    )
    return
  }
  let cm = charmaps[index]
  expect_equal_int(
    state,
    "charmap_meta index=\{index} platform_id",
    cm.platform_id().to_int(),
    platform_id,
  )
  expect_equal_int(
    state,
    "charmap_meta index=\{index} encoding_id",
    cm.encoding_id().to_int(),
    encoding_id,
  )
}

///|
fn diff_charmap_entry(
  face : @base.FaceRec,
  state : DiffState,
  obj : Map[String, Json],
) -> Unit {
  let index = get_required_int(obj, "charmap_index", state.oracle_path)
  let charcode = get_required_uint(obj, "charcode", state.oracle_path)
  let expected_gid = get_required_uint(obj, "glyph_index", state.oracle_path)
  if state.active_charmap != index {
    face.set_active_charmap(index)
    state.active_charmap = index
  }
  let actual_gid = @freetype.get_char_index(face, charcode)
  expect_equal_uint(
    state,
    "charmap_entry cmap=\{index} char=\{charcode}",
    actual_gid,
    expected_gid,
  )
}

///|
fn diff_glyph_outline(
  face : @base.FaceRec,
  state : DiffState,
  obj : Map[String, Json],
) -> Unit {
  let glyph_index = get_required_uint(obj, "glyph_index", state.oracle_path)
  let size_ppem = get_required_int(obj, "size_ppem", state.oracle_path)
  let load_flags_name = get_required_string(
    obj,
    "load_flags",
    state.oracle_path,
  )
  let context = "glyph_outline gid=\{glyph_index} flags=\{load_flags_name} size=\{size_ppem}"
  if !prepare_size(face, state, size_ppem, context) {
    return
  }
  if !load_glyph_checked(
      face,
      state,
      glyph_index,
      decode_load_flags(load_flags_name),
      context,
    ) {
    return
  }
  let slot = face.glyph()
  if slot.format() != @types.GlyphFormat::Outline {
    record_mismatch(
      state,
      "\{context}: expected Outline got \{slot.format().to_string()}",
    )
    return
  }
  compare_metrics(
    state,
    context,
    slot.metrics(),
    get_required_object(obj, "metrics", state.oracle_path),
  )
  compare_outline(
    state,
    context,
    slot.outline(),
    get_required_object(obj, "outline", state.oracle_path),
  )
}

///|
fn diff_glyph_bitmap(
  face : @base.FaceRec,
  state : DiffState,
  obj : Map[String, Json],
) -> Unit {
  let glyph_index = get_required_uint(obj, "glyph_index", state.oracle_path)
  let size_ppem = get_required_int(obj, "size_ppem", state.oracle_path)
  let load_flags_name = get_required_string(
    obj,
    "load_flags",
    state.oracle_path,
  )
  let context = "glyph_bitmap gid=\{glyph_index} flags=\{load_flags_name} size=\{size_ppem}"
  if !prepare_size(face, state, size_ppem, context) {
    return
  }
  if !load_glyph_checked(
      face,
      state,
      glyph_index,
      decode_load_flags(load_flags_name),
      context,
    ) {
    return
  }
  let slot = face.glyph()
  if slot.format() != @types.GlyphFormat::Bitmap {
    record_mismatch(
      state,
      "\{context}: expected Bitmap got \{slot.format().to_string()}",
    )
    return
  }
  compare_metrics(
    state,
    context,
    slot.metrics(),
    get_required_object(obj, "metrics", state.oracle_path),
  )
  compare_bitmap(
    state,
    context,
    slot.bitmap(),
    slot.bitmap_left(),
    slot.bitmap_top(),
    get_required_object(obj, "bitmap", state.oracle_path),
  )
}

///|
fn diff_render_bitmap(
  face : @base.FaceRec,
  state : DiffState,
  obj : Map[String, Json],
) -> Unit {
  let glyph_index = get_required_uint(obj, "glyph_index", state.oracle_path)
  let size_ppem = get_required_int(obj, "size_ppem", state.oracle_path)
  let load_flags_name = get_required_string(
    obj,
    "load_flags",
    state.oracle_path,
  )
  let render_mode_name = get_required_string(
    obj,
    "render_mode",
    state.oracle_path,
  )
  let context = "render_bitmap gid=\{glyph_index} flags=\{load_flags_name} mode=\{render_mode_name} size=\{size_ppem}"
  if !prepare_size(face, state, size_ppem, context) {
    return
  }
  if !load_glyph_checked(
      face,
      state,
      glyph_index,
      decode_load_flags(load_flags_name),
      context,
    ) {
    return
  }
  try
    @freetype.render_glyph(face, mode=decode_render_mode(render_mode_name))
  catch {
    err => {
      record_mismatch(state, "\{context}: render_glyph failed with \{err}")
      return
    }
  } noraise {
    _ => ()
  }
  let slot = face.glyph()
  if slot.format() != @types.GlyphFormat::Bitmap {
    record_mismatch(
      state,
      "\{context}: expected Bitmap got \{slot.format().to_string()}",
    )
    return
  }
  compare_bitmap(
    state,
    context,
    slot.bitmap(),
    slot.bitmap_left(),
    slot.bitmap_top(),
    get_required_object(obj, "bitmap", state.oracle_path),
  )
}

///|
fn diff_kerning(
  face : @base.FaceRec,
  state : DiffState,
  obj : Map[String, Json],
) -> Unit {
  let left = get_required_uint(obj, "left", state.oracle_path)
  let right = get_required_uint(obj, "right", state.oracle_path)
  let expected_x = get_required_int64(obj, "x", state.oracle_path)
  let expected_y = get_required_int64(obj, "y", state.oracle_path)
  let (actual_x, actual_y) = @freetype.get_kerning(face, left, right)
  expect_equal_int64(
    state,
    "kerning left=\{left} right=\{right} x",
    actual_x,
    expected_x,
  )
  expect_equal_int64(
    state,
    "kerning left=\{left} right=\{right} y",
    actual_y,
    expected_y,
  )
}

///|
fn prepare_size(
  face : @base.FaceRec,
  state : DiffState,
  size_ppem : Int,
  context : String,
) -> Bool {
  if size_ppem <= 0 {
    return true
  }
  if state.pixel_size == size_ppem {
    return true
  }
  try @freetype.set_pixel_sizes(face, 0U, size_ppem.to_uint()) catch {
    err => {
      record_mismatch(
        state,
        "\{context}: set_pixel_sizes(\{size_ppem}) failed with \{err}",
      )
      false
    }
  } noraise {
    _ => {
      state.pixel_size = size_ppem
      true
    }
  }
}

///|
fn load_glyph_checked(
  face : @base.FaceRec,
  state : DiffState,
  glyph_index : UInt,
  load_flags : Int,
  context : String,
) -> Bool {
  try @freetype.load_glyph(face, glyph_index, load_flags~) catch {
    err => {
      record_mismatch(state, "\{context}: load_glyph failed with \{err}")
      false
    }
  } noraise {
    _ => true
  }
}

///|
fn compare_metrics(
  state : DiffState,
  context : String,
  actual : @types.GlyphMetrics,
  expected : Map[String, Json],
) -> Unit {
  expect_equal_int64(
    state,
    "\{context} metrics.width",
    actual.width(),
    get_required_int64(expected, "width", state.oracle_path),
  )
  expect_equal_int64(
    state,
    "\{context} metrics.height",
    actual.height(),
    get_required_int64(expected, "height", state.oracle_path),
  )
  expect_equal_int64(
    state,
    "\{context} metrics.hori_bearing_x",
    actual.hori_bearing_x(),
    get_required_int64(expected, "hori_bearing_x", state.oracle_path),
  )
  expect_equal_int64(
    state,
    "\{context} metrics.hori_bearing_y",
    actual.hori_bearing_y(),
    get_required_int64(expected, "hori_bearing_y", state.oracle_path),
  )
  expect_equal_int64(
    state,
    "\{context} metrics.hori_advance",
    actual.hori_advance(),
    get_required_int64(expected, "hori_advance", state.oracle_path),
  )
}

///|
fn compare_outline(
  state : DiffState,
  context : String,
  actual : @types.Outline,
  expected : Map[String, Json],
) -> Unit {
  let expected_points = get_required_json_array(
    expected,
    "points",
    state.oracle_path,
  )
  let expected_tags = get_required_json_array(
    expected,
    "tags",
    state.oracle_path,
  )
  let expected_contours = get_required_json_array(
    expected,
    "contours",
    state.oracle_path,
  )
  let expected_n_points = get_required_int(
    expected,
    "n_points",
    state.oracle_path,
  )
  let expected_n_contours = get_required_int(
    expected,
    "n_contours",
    state.oracle_path,
  )
  expect_equal_int(
    state,
    "\{context} outline.n_points",
    actual.n_points(),
    expected_n_points,
  )
  expect_equal_int(
    state,
    "\{context} outline.n_contours",
    actual.n_contours(),
    expected_n_contours,
  )
  if actual.n_points() != expected_points.length() {
    record_mismatch(
      state,
      "\{context} outline.points length expected \{expected_points.length()} got \{actual.n_points()}",
    )
    return
  }
  if actual.n_points() != expected_tags.length() {
    record_mismatch(
      state,
      "\{context} outline.tags length expected \{expected_tags.length()} got \{actual.n_points()}",
    )
    return
  }
  if actual.n_contours() != expected_contours.length() {
    record_mismatch(
      state,
      "\{context} outline.contours length expected \{expected_contours.length()} got \{actual.n_contours()}",
    )
    return
  }
  for i in 0..<actual.n_points() {
    let pair = parse_point(expected_points[i], state.oracle_path)
    let point = actual.points()[i]
    expect_equal_int64(
      state,
      "\{context} outline.points[\{i}].x",
      point.x(),
      pair.0,
    )
    expect_equal_int64(
      state,
      "\{context} outline.points[\{i}].y",
      point.y(),
      pair.1,
    )
    expect_equal_int(
      state,
      "\{context} outline.tags[\{i}]",
      actual.tags()[i].to_int(),
      json_as_int(expected_tags[i], state.oracle_path),
    )
  }
  for i in 0..<actual.n_contours() {
    expect_equal_int(
      state,
      "\{context} outline.contours[\{i}]",
      actual.contours()[i].to_int(),
      json_as_int(expected_contours[i], state.oracle_path),
    )
  }
}

///|
fn compare_bitmap(
  state : DiffState,
  context : String,
  actual : @types.Bitmap,
  actual_left : Int,
  actual_top : Int,
  expected : Map[String, Json],
) -> Unit {
  expect_equal_uint(
    state,
    "\{context} bitmap.width",
    actual.width(),
    get_required_uint(expected, "width", state.oracle_path),
  )
  expect_equal_uint(
    state,
    "\{context} bitmap.rows",
    actual.rows(),
    get_required_uint(expected, "rows", state.oracle_path),
  )
  expect_equal_int(
    state,
    "\{context} bitmap.pitch",
    actual.pitch(),
    get_required_int(expected, "pitch", state.oracle_path),
  )
  expect_equal_string(
    state,
    "\{context} bitmap.pixel_mode",
    actual.pixel_mode().to_string(),
    get_required_string(expected, "pixel_mode", state.oracle_path),
  )
  expect_equal_uint(
    state,
    "\{context} bitmap.num_grays",
    actual.num_grays(),
    get_required_uint(expected, "num_grays", state.oracle_path),
  )
  expect_equal_int(
    state,
    "\{context} bitmap.left",
    actual_left,
    get_required_int(expected, "left", state.oracle_path),
  )
  expect_equal_int(
    state,
    "\{context} bitmap.top",
    actual_top,
    get_required_int(expected, "top", state.oracle_path),
  )
  expect_buffer_hex(
    state,
    "\{context} bitmap.buffer",
    actual.buffer(),
    get_required_string(expected, "buffer_hex", state.oracle_path),
  )
}

///|
fn expect_buffer_hex(
  state : DiffState,
  context : String,
  actual : Bytes,
  expected_hex : String,
) -> Unit {
  if actual.length() != expected_hex.length() / 2 {
    record_mismatch(
      state,
      "\{context} length expected \{expected_hex.length() / 2} got \{actual.length()}",
    )
    return
  }
  for i in 0..<actual.length() {
    let hi = hex_digit(expected_hex[i * 2])
    let lo = hex_digit(expected_hex[i * 2 + 1])
    let expected = (hi << 4) | lo
    let got = actual[i].to_int()
    if hi < 0 || lo < 0 {
      record_mismatch(state, "\{context} contains invalid hex data")
      return
    }
    if got != expected {
      record_mismatch(
        state,
        "\{context} byte[\{i}] expected \{expected} got \{got}",
      )
      return
    }
  }
}

///|
fn record_mismatch(state : DiffState, message : String) -> Unit {
  if state.mismatches < state.mismatch_limit {
    println("MISMATCH \{state.mismatches + 1}: \{message}")
  }
  state.mismatches += 1
}

///|
fn expect_equal_int(
  state : DiffState,
  context : String,
  actual : Int,
  expected : Int,
) -> Unit {
  if actual != expected {
    record_mismatch(state, "\{context} expected \{expected} got \{actual}")
  }
}

///|
fn expect_equal_int64(
  state : DiffState,
  context : String,
  actual : Int64,
  expected : Int64,
) -> Unit {
  if actual != expected {
    record_mismatch(state, "\{context} expected \{expected} got \{actual}")
  }
}

///|
fn expect_equal_uint(
  state : DiffState,
  context : String,
  actual : UInt,
  expected : UInt,
) -> Unit {
  if actual != expected {
    record_mismatch(state, "\{context} expected \{expected} got \{actual}")
  }
}

///|
fn expect_equal_string(
  state : DiffState,
  context : String,
  actual : String,
  expected : String,
) -> Unit {
  if actual != expected {
    record_mismatch(state, "\{context} expected \{expected} got \{actual}")
  }
}

///|
fn parse_object_line(line : String, oracle_path : String) -> Map[String, Json] {
  let parsed = try? @json5.parse(line)
  let json = match parsed {
    Ok(value) => value
    Err(err) => abort("failed to parse oracle line in \{oracle_path}: \{err}")
  }
  let decoded : Result[Map[String, Json], @json.JsonDecodeError] = try? @json.from_json(
    json,
  )
  match decoded {
    Ok(value) => value
    Err(err) => abort("failed to decode oracle line in \{oracle_path}: \{err}")
  }
}

///|
fn get_required_json(
  obj : Map[String, Json],
  key : String,
  oracle_path : String,
) -> Json {
  match obj.get(key) {
    Some(value) => value
    None => abort("missing key \{key} in \{oracle_path}")
  }
}

///|
fn[T : FromJson] decode_json(
  json : Json,
  what : String,
  oracle_path : String,
) -> T {
  let decoded : Result[T, @json.JsonDecodeError] = try? @json.from_json(json)
  match decoded {
    Ok(value) => value
    Err(err) => abort("invalid \{what} in \{oracle_path}: \{err}")
  }
}

///|
fn get_required_object(
  obj : Map[String, Json],
  key : String,
  oracle_path : String,
) -> Map[String, Json] {
  decode_json(
    get_required_json(obj, key, oracle_path),
    "object for key \{key}",
    oracle_path,
  )
}

///|
fn get_required_json_array(
  obj : Map[String, Json],
  key : String,
  oracle_path : String,
) -> Array[Json] {
  decode_json(
    get_required_json(obj, key, oracle_path),
    "array for key \{key}",
    oracle_path,
  )
}

///|
fn get_required_string(
  obj : Map[String, Json],
  key : String,
  oracle_path : String,
) -> String {
  decode_json(
    get_required_json(obj, key, oracle_path),
    "string for key \{key}",
    oracle_path,
  )
}

///|
fn get_required_int(
  obj : Map[String, Json],
  key : String,
  oracle_path : String,
) -> Int {
  json_as_int(get_required_json(obj, key, oracle_path), oracle_path)
}

///|
fn get_required_int64(
  obj : Map[String, Json],
  key : String,
  oracle_path : String,
) -> Int64 {
  json_as_int64(get_required_json(obj, key, oracle_path), oracle_path)
}

///|
fn get_required_uint(
  obj : Map[String, Json],
  key : String,
  oracle_path : String,
) -> UInt {
  json_as_uint(get_required_json(obj, key, oracle_path), oracle_path)
}

///|
fn get_variation_coords(
  obj : Map[String, Json],
  key : String,
  oracle_path : String,
) -> Array[(String, Int64)] {
  let entries = get_required_json_array(obj, key, oracle_path)
  let coords : Array[(String, Int64)] = []
  for entry in entries {
    match entry {
      Json::Array(values) => {
        if values.length() != 2 {
          abort("invalid variation coord in \{oracle_path}")
        }
        let tag = json_as_string(values[0], oracle_path)
        coords.push((tag, json_as_int64(values[1], oracle_path)))
      }
      _ => abort("invalid variation coords for key \{key} in \{oracle_path}")
    }
  }
  coords
}

///|
fn json_as_int(json : Json, oracle_path : String) -> Int {
  match json {
    Json::Number(value, ..) => value.to_int()
    _ => abort("invalid int in \{oracle_path}")
  }
}

///|
fn json_as_int64(json : Json, oracle_path : String) -> Int64 {
  match json {
    Json::Number(value, ..) => value.to_int64()
    _ => abort("invalid int64 in \{oracle_path}")
  }
}

///|
fn json_as_uint(json : Json, oracle_path : String) -> UInt {
  match json {
    Json::Number(value, ..) => value.to_uint()
    _ => abort("invalid uint in \{oracle_path}")
  }
}

///|
fn json_as_string(json : Json, oracle_path : String) -> String {
  match json {
    Json::String(value) => value
    _ => abort("invalid string in \{oracle_path}")
  }
}

///|
fn parse_point(json : Json, oracle_path : String) -> (Int64, Int64) {
  match json {
    Json::Array(values) => {
      if values.length() != 2 {
        abort("invalid point in \{oracle_path}")
      }
      (
        json_as_int64(values[0], oracle_path),
        json_as_int64(values[1], oracle_path),
      )
    }
    _ => abort("invalid point in \{oracle_path}")
  }
}

///|
fn tag_to_uint(tag : String) -> UInt {
  if tag.length() != 4 {
    abort("invalid variation tag: \{tag}")
  }
  (tag[0].to_uint() << 24) |
  (tag[1].to_uint() << 16) |
  (tag[2].to_uint() << 8) |
  tag[3].to_uint()
}

///|
fn decode_load_flags(name : String) -> Int {
  match name {
    "NO_SCALE" => @base.LOAD_NO_SCALE
    "DEFAULT" => @base.LOAD_DEFAULT
    "NO_HINTING" => @base.LOAD_NO_HINTING
    "FORCE_AUTOHINT" => @base.LOAD_FORCE_AUTOHINT
    "COLOR_NO_HINTING" => @base.LOAD_COLOR | @base.LOAD_NO_HINTING
    _ => abort("unsupported oracle load flag \{name}")
  }
}

///|
fn decode_render_mode(name : String) -> @freetype.RenderMode {
  match name {
    "NORMAL" => Normal
    "LIGHT" => Light
    "MONO" => Mono
    "LCD" => Lcd
    "LCD_V" => LcdV
    "SDF" => Sdf
    _ => abort("unsupported oracle render mode \{name}")
  }
}

///|
fn hex_digit(unit : UInt16) -> Int {
  let code = unit.to_int()
  if code >= '0'.to_int() && code <= '9'.to_int() {
    code - '0'.to_int()
  } else if code >= 'a'.to_int() && code <= 'f'.to_int() {
    code - 'a'.to_int() + 10
  } else if code >= 'A'.to_int() && code <= 'F'.to_int() {
    code - 'A'.to_int() + 10
  } else {
    -1
  }
}
