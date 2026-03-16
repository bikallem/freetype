///|
/// Auto-hinter module.
/// Implements automatic hinting for outline fonts without native hints.
/// Ported from FreeType's autofit module.

///|
/// Script classification for auto-hinting.
pub(all) enum Script {
  Latin
  Cjk
  Indic
  Default
} derive(Eq, Show)

///|
/// Direction of a segment (horizontal or vertical).
pub(all) enum SegmentDir {
  Horizontal
  Vertical
} derive(Eq, Show)

///|
/// A segment is a run of consecutive points along one direction.
pub(all) struct Segment {
  position : Int64 // position along the perpendicular axis
  min_coord : Int64 // minimum extent along the parallel axis
  max_coord : Int64 // maximum extent along the parallel axis
  direction : SegmentDir
  first_point : Int // index of first on-curve point
  last_point : Int // index of last on-curve point
  num_points : Int // number of on-curve points in this segment
} derive(Eq, Show)

///|
/// An edge is formed by merging nearby segments.
pub(all) struct Edge {
  mut position : Int64 // original position in font units
  mut fitted_position : Int64 // fitted position in 26.6 pixels
  mut linked_edge : Int // index of linked edge (-1 if none)
  mut is_serif : Bool // true if this is a serif edge
  mut blue_edge : Bool // true if aligned to a blue zone
  mut num_segments : Int // number of segments contributing to this edge
} derive(Eq, Show)

///|
pub fn Edge::new(position : Int64) -> Edge {
  {
    position,
    fitted_position: position,
    linked_edge: -1,
    is_serif: false,
    blue_edge: false,
    num_segments: 0,
  }
}

///|
/// A stem is a pair of edges forming a vertical or horizontal stem.
pub(all) struct Stem {
  edge1 : Int // index of first edge
  edge2 : Int // index of second edge
} derive(Eq, Show)

///|
/// Hints along one axis.
pub(all) struct AxisHints {
  mut segments : Array[Segment]
  mut edges : Array[Edge]
  mut stems : Array[Stem]
} derive(Eq, Show)

///|
pub fn AxisHints::new() -> AxisHints {
  { segments: [], edges: [], stems: [] }
}

///|
/// Per-glyph hinting data.
pub(all) struct GlyphHints {
  mut x_axis : AxisHints
  mut y_axis : AxisHints
} derive(Eq, Show)

///|
pub fn GlyphHints::new() -> GlyphHints {
  { x_axis: AxisHints::new(), y_axis: AxisHints::new() }
}

///|
/// Blue zone for Latin script auto-hinting.
pub(all) struct BlueZone {
  ref_pos : Int64 // reference position (overshoot position)
  shoot : Int64 // overshoot position
  fitted : Int64 // fitted position in 26.6
} derive(Eq, Show)

///|
/// Script-level metrics used during hinting.
pub(all) struct ScriptMetrics {
  mut std_widths : Array[Int64] // standard stem widths
  mut blue_zones : Array[BlueZone] // blue zones (Latin script)
  mut scale : @fixed.Fixed // current scale factor
} derive(Eq, Show)

///|
pub fn ScriptMetrics::new() -> ScriptMetrics {
  { std_widths: [], blue_zones: [], scale: @fixed.Fixed::from_int(0) }
}

///|
/// Detect the script of a character based on Unicode ranges.
pub fn detect_script(charcode : UInt) -> Script {
  let cc = charcode.reinterpret_as_int()
  // Latin: Basic Latin + Latin Extended
  if cc >= 0x0000 && cc <= 0x024F {
    return Script::Latin
  }
  // Latin Supplement & Extended
  if cc >= 0x1E00 && cc <= 0x1EFF {
    return Script::Latin
  }
  // CJK Unified Ideographs
  if cc >= 0x4E00 && cc <= 0x9FFF {
    return Script::Cjk
  }
  // CJK Extension A
  if cc >= 0x3400 && cc <= 0x4DBF {
    return Script::Cjk
  }
  // Hiragana
  if cc >= 0x3040 && cc <= 0x309F {
    return Script::Cjk
  }
  // Katakana
  if cc >= 0x30A0 && cc <= 0x30FF {
    return Script::Cjk
  }
  // Hangul Syllables
  if cc >= 0xAC00 && cc <= 0xD7AF {
    return Script::Cjk
  }
  // Devanagari
  if cc >= 0x0900 && cc <= 0x097F {
    return Script::Indic
  }
  // Bengali
  if cc >= 0x0980 && cc <= 0x09FF {
    return Script::Indic
  }
  // Tamil
  if cc >= 0x0B80 && cc <= 0x0BFF {
    return Script::Indic
  }
  // Telugu
  if cc >= 0x0C00 && cc <= 0x0C7F {
    return Script::Indic
  }
  // Kannada
  if cc >= 0x0C80 && cc <= 0x0CFF {
    return Script::Indic
  }
  // Malayalam
  if cc >= 0x0D00 && cc <= 0x0D7F {
    return Script::Indic
  }
  // Gurmukhi
  if cc >= 0x0A00 && cc <= 0x0A7F {
    return Script::Indic
  }
  // Gujarati
  if cc >= 0x0A80 && cc <= 0x0AFF {
    return Script::Indic
  }
  // Oriya
  if cc >= 0x0B00 && cc <= 0x0B7F {
    return Script::Indic
  }
  Script::Default
}

///|
/// Compute segments from an outline along the given direction.
/// Segments are runs of points that form approximately horizontal or vertical lines.
pub fn compute_segments(
  outline : @types.Outline,
  direction : SegmentDir,
) -> Array[Segment] {
  let segments : Array[Segment] = []
  let n_contours = outline.n_contours()
  if n_contours == 0 {
    return segments
  }
  let mut contour_start = 0
  for c = 0; c < n_contours; c = c + 1 {
    let contour_end = outline.contours[c].reinterpret_as_int()
    // Scan points in this contour for segments
    let mut seg_start = -1
    let mut seg_pos : Int64 = 0
    let mut seg_min : Int64 = 0x7FFFFFFFL
    let mut seg_max : Int64 = -0x7FFFFFFFL
    for i = contour_start; i <= contour_end; i = i + 1 {
      let p = outline.points[i]
      let tag = @types.curve_tag(outline.tags[i])
      if tag != @types.curve_tag_on {
        continue i + 1
      }
      // Get coordinate along segment direction and perpendicular
      let (para, perp) = match direction {
        Horizontal => (p.x, p.y)
        Vertical => (p.y, p.x)
      }
      if seg_start < 0 {
        // Start a new segment
        seg_start = i
        seg_pos = perp
        seg_min = para
        seg_max = para
      } else {
        // Check if this point continues the segment (same perpendicular position within tolerance)
        let diff = if perp > seg_pos { perp - seg_pos } else { seg_pos - perp }
        let threshold : Int64 = 20 // tolerance in font units
        if diff <= threshold {
          // Extend segment
          if para < seg_min {
            seg_min = para
          }
          if para > seg_max {
            seg_max = para
          }
        } else {
          // Finish current segment and start new one
          if seg_start >= 0 {
            segments.push({
              position: seg_pos,
              min_coord: seg_min,
              max_coord: seg_max,
              direction,
              first_point: seg_start,
              last_point: i - 1,
              num_points: i - seg_start,
            })
          }
          seg_start = i
          seg_pos = perp
          seg_min = para
          seg_max = para
        }
      }
    }
    // Close last segment in contour
    if seg_start >= 0 {
      segments.push({
        position: seg_pos,
        min_coord: seg_min,
        max_coord: seg_max,
        direction,
        first_point: seg_start,
        last_point: contour_end,
        num_points: contour_end - seg_start + 1,
      })
    }
    contour_start = contour_end + 1
  }
  segments
}

///|
/// Merge nearby segments into edges.
/// Segments within `edge_distance_threshold` (scaled) are merged into a single edge.
pub fn compute_edges(
  segments : Array[Segment],
  scale : @fixed.Fixed,
) -> Array[Edge] {
  let _ = scale
  let edges : Array[Edge] = []
  if segments.length() == 0 {
    return edges
  }
  // Sort segments by position (simple insertion sort for now)
  let sorted = segments.copy()
  for i = 1; i < sorted.length(); i = i + 1 {
    let key = sorted[i]
    let mut j = i - 1
    while j >= 0 && sorted[j].position > key.position {
      sorted[j + 1] = sorted[j]
      j -= 1
    }
    sorted[j + 1] = key
  }
  // Merge nearby segments into edges
  let edge_distance : Int64 = 32 // threshold in font units
  let mut current_edge = Edge::new(sorted[0].position)
  current_edge.num_segments = 1
  for i = 1; i < sorted.length(); i = i + 1 {
    let seg = sorted[i]
    let diff = if seg.position > current_edge.position {
      seg.position - current_edge.position
    } else {
      current_edge.position - seg.position
    }
    if diff <= edge_distance {
      // Merge into current edge
      current_edge.num_segments += 1
    } else {
      // Finish current edge and start new one
      edges.push(current_edge)
      current_edge = Edge::new(seg.position)
      current_edge.num_segments = 1
    }
  }
  edges.push(current_edge)
  edges
}
