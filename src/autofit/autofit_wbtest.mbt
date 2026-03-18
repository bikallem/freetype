///|
test "detect_script Latin" {
  inspect(detect_script(0x41U), content="Latin") // 'A'
  inspect(detect_script(0x7AU), content="Latin") // 'z'
  inspect(detect_script(0x00C0U), content="Latin") // 'A' with grave
}

///|
test "detect_script CJK" {
  inspect(detect_script(0x4E00U), content="Cjk") // CJK Unified start
  inspect(detect_script(0x3042U), content="Cjk") // Hiragana 'a'
  inspect(detect_script(0x30A2U), content="Cjk") // Katakana 'a'
  inspect(detect_script(0xAC00U), content="Cjk") // Hangul start
}

///|
test "detect_script Indic" {
  inspect(detect_script(0x0915U), content="Indic") // Devanagari 'ka'
  inspect(detect_script(0x09A0U), content="Indic") // Bengali
  inspect(detect_script(0x0B95U), content="Indic") // Tamil
}

///|
test "detect_script Default" {
  inspect(detect_script(0x0600U), content="Default") // Arabic
  inspect(detect_script(0xFFFDU), content="Default") // replacement char
}

///|
test "compute_segments on square" {
  // A simple square: (0,0) -> (100,0) -> (100,100) -> (0,100)
  let outline = @types.Outline::create(
    [
      @types.Vector::new(0L, 0L),
      @types.Vector::new(100L, 0L),
      @types.Vector::new(100L, 100L),
      @types.Vector::new(0L, 100L),
    ],
    [
      @types.curve_tag_on, @types.curve_tag_on, @types.curve_tag_on, @types.curve_tag_on,
    ],
    [3U],
  )
  // Horizontal segments: runs with constant y (perpendicular)
  let h_segs = compute_segments(outline, SegmentDir::Horizontal)
  // Should find segments at y=0 and y=100
  inspect(h_segs.length() > 0, content="true")
  // Vertical segments: runs with constant x (perpendicular)
  let v_segs = compute_segments(outline, SegmentDir::Vertical)
  inspect(v_segs.length() > 0, content="true")
}

///|
test "compute_edges merges nearby segments" {
  let segments : Array[Segment] = [
    Segment::new(
      position=100L,
      min_coord=0L,
      max_coord=50L,
      direction=SegmentDir::Vertical,
      first_point=0,
      last_point=1,
      num_points=2,
    ),
    Segment::new(
      position=110L,
      min_coord=0L,
      max_coord=50L,
      direction=SegmentDir::Vertical,
      first_point=2,
      last_point=3,
      num_points=2,
    ),
    Segment::new(
      position=300L,
      min_coord=0L,
      max_coord=50L,
      direction=SegmentDir::Vertical,
      first_point=4,
      last_point=5,
      num_points=2,
    ),
  ]
  let scale = @fixed.Fixed::from_int(1)
  let edges = compute_edges(segments, scale)
  // Segments at 100 and 110 should merge (diff=10 < threshold=32)
  // Segment at 300 should be separate
  inspect(edges.length(), content="2")
}

///|
test "GlyphHints creation" {
  let hints = GlyphHints::new()
  inspect(hints.x_axis.segments.length(), content="0")
  inspect(hints.y_axis.edges.length(), content="0")
}

///|
test "ScriptMetrics creation" {
  let metrics = ScriptMetrics::new()
  inspect(metrics.std_widths.length(), content="0")
  inspect(metrics.blue_zones.length(), content="0")
}
