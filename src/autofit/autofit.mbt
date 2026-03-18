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
struct Segment {
  position : Int64 // position along the perpendicular axis
  min_coord : Int64 // minimum extent along the parallel axis
  max_coord : Int64 // maximum extent along the parallel axis
  direction : SegmentDir
  first_point : Int // index of first on-curve point
  last_point : Int // index of last on-curve point
  num_points : Int // number of on-curve points in this segment
} derive(Eq, Show)

///|
pub fn Segment::new(
  position~ : Int64,
  min_coord~ : Int64,
  max_coord~ : Int64,
  direction~ : SegmentDir,
  first_point~ : Int,
  last_point~ : Int,
  num_points~ : Int,
) -> Segment {
  {
    position,
    min_coord,
    max_coord,
    direction,
    first_point,
    last_point,
    num_points,
  }
}

///|
/// An edge is formed by merging nearby segments.
struct Edge {
  position : Int64 // original position in font units
  mut fitted_position : Int64 // fitted position in 26.6 pixels
  mut linked_edge : Int // index of linked edge (-1 if none)
  is_serif : Bool // true if this is a serif edge
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
struct Stem {
  edge1 : Int // index of first edge
  edge2 : Int // index of second edge
} derive(Eq, Show)

///|
/// Hints along one axis.
struct AxisHints {
  segments : Array[Segment]
  edges : Array[Edge]
  stems : Array[Stem]
} derive(Eq, Show)

///|
pub fn AxisHints::new() -> AxisHints {
  { segments: [], edges: [], stems: [] }
}

///|
/// Per-glyph hinting data.
struct GlyphHints {
  x_axis : AxisHints
  y_axis : AxisHints
} derive(Eq, Show)

///|
pub fn GlyphHints::new() -> GlyphHints {
  { x_axis: AxisHints::new(), y_axis: AxisHints::new() }
}

///|
/// Blue zone for Latin script auto-hinting.
struct BlueZone {
  ref_pos : Int64 // reference position (overshoot position)
  shoot : Int64 // overshoot position
  fitted : Int64 // fitted position in 26.6
} derive(Eq, Show)

///|
pub fn BlueZone::new(
  ref_pos : Int64,
  shoot : Int64,
  fitted : Int64,
) -> BlueZone {
  { ref_pos, shoot, fitted }
}

///|
/// Script-level metrics used during hinting.
struct ScriptMetrics {
  mut std_widths : Array[Int64] // standard stem widths
  mut blue_zones : Array[BlueZone] // blue zones (Latin script)
  mut scale : @fixed.Fixed // current scale factor
} derive(Eq, Show)

///|
pub fn ScriptMetrics::new() -> ScriptMetrics {
  { std_widths: [], blue_zones: [], scale: @fixed.Fixed::from_int(0) }
}

///|
pub fn ScriptMetrics::set_scale(self : ScriptMetrics, v : @fixed.Fixed) -> Unit {
  self.scale = v
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
  for c in 0..<n_contours {
    let contour_end = outline.contours()[c].reinterpret_as_int()
    // Scan points in this contour for segments
    let mut seg_start = -1
    let mut seg_pos : Int64 = 0
    let mut seg_min : Int64 = 0x7FFFFFFFL
    let mut seg_max : Int64 = -0x7FFFFFFFL
    for i = contour_start; i <= contour_end; i = i + 1 {
      let p = outline.points()[i]
      let tag = @types.curve_tag(outline.tags()[i])
      if tag != @types.CURVE_TAG_ON {
        continue i + 1
      }
      // Get coordinate along segment direction and perpendicular
      let (para, perp) = match direction {
        Horizontal => (p.x(), p.y())
        Vertical => (p.y(), p.x())
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
  let edges : Array[Edge] = []
  if segments.length() == 0 {
    return edges
  }
  // Sort segments by position (simple insertion sort for now)
  let sorted = segments.copy()
  let n = sorted.length()
  for i in 1..<n {
    let key = sorted[i]
    for j = i - 1; j >= 0 && sorted[j].position > key.position; {
      sorted[j + 1] = sorted[j]
      continue j - 1
    } nobreak {
      sorted[j + 1] = key
    }
  }
  // Merge nearby segments into edges.
  // Threshold: half a pixel (32 in 26.6) converted back to font units via scale.
  let edge_distance : Int64 = if scale.val() > 0L {
    @fixed.mul_div(32L, 0x10000L, scale.val())
  } else {
    32L // fallback if scale is zero
  }
  let mut current_edge = Edge::new(sorted[0].position)
  current_edge.num_segments = 1
  for i in 1..<n {
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

// ─── Stem detection ──────────────────────────────────────────────────

///|
/// Detect stems: pairs of edges with reasonable width.
pub fn detect_stems(edges : Array[Edge]) -> Array[Stem] {
  let stems : Array[Stem] = []
  let n = edges.length()
  for i = 0; i + 1 < n; {
    let width = edges[i + 1].position - edges[i].position
    // Reasonable stem width: between 10 and 500 font units
    if width > 10L && width < 500L {
      stems.push({ edge1: i, edge2: i + 1 })
      edges[i].linked_edge = i + 1
      edges[i + 1].linked_edge = i
      continue i + 2
    } else {
      continue i + 1
    }
  }
  stems
}

// ─── Blue zone fitting ───────────────────────────────────────────────

///|
/// Fit edges to blue zones. Edges near a blue zone boundary are snapped.
pub fn fit_blue_zones(
  edges : Array[Edge],
  blues : Array[BlueZone],
  scale : @fixed.Fixed,
) -> Unit {
  for _, edge in edges {
    let scaled_pos = @fixed.mul_fix(
      scale,
      @fixed.Fixed::from_raw(edge.position),
    ).val()
    for _, blue in blues {
      let ref_scaled = @fixed.mul_fix(
        scale,
        @fixed.Fixed::from_raw(blue.ref_pos),
      ).val()
      let tolerance = 32L // half pixel in 26.6
      let diff = if scaled_pos > ref_scaled {
        scaled_pos - ref_scaled
      } else {
        ref_scaled - scaled_pos
      }
      if diff <= tolerance {
        edge.fitted_position = blue.fitted
        edge.blue_edge = true
        break
      }
    }
  }
}

// ─── Edge fitting ────────────────────────────────────────────────────

///|
/// Fit all edges: snap stems to pixel grid, maintain minimum widths.
pub fn fit_edges(
  edges : Array[Edge],
  stems : Array[Stem],
  scale : @fixed.Fixed,
) -> Unit {
  // First fit blue zone edges (already done by fit_blue_zones)
  // Then fit stem edges
  for _, stem in stems {
    let e1 = edges[stem.edge1]
    let e2 = edges[stem.edge2]
    // Scale positions
    let pos1 = @fixed.mul_fix(scale, @fixed.Fixed::from_raw(e1.position)).val()
    let pos2 = @fixed.mul_fix(scale, @fixed.Fixed::from_raw(e2.position)).val()
    let width = pos2 - pos1
    // Round stem width to pixel (minimum 1 pixel = 64 in 26.6)
    let rounded_width = if width > 0L {
      let w = (width + 32L) & -64L
      if w < 64L {
        64L
      } else {
        w
      }
    } else {
      64L
    }
    // If one edge is blue-fitted, derive the other
    if e1.blue_edge {
      e2.fitted_position = e1.fitted_position + rounded_width
    } else if e2.blue_edge {
      e1.fitted_position = e2.fitted_position - rounded_width
    } else {
      // Center the stem on the pixel grid
      let center = (pos1 + pos2) / 2L
      let fitted_center = (center + 32L) & -64L
      e1.fitted_position = fitted_center - rounded_width / 2L
      e2.fitted_position = e1.fitted_position + rounded_width
    }
  }
  // Fit unlinked (non-stem) edges: round to nearest pixel
  for _, edge in edges {
    if edge.linked_edge < 0 && not(edge.blue_edge) {
      let scaled = @fixed.mul_fix(scale, @fixed.Fixed::from_raw(edge.position)).val()
      edge.fitted_position = (scaled + 32L) & -64L
    }
  }
}

// ─── Point interpolation ─────────────────────────────────────────────

///|
/// Interpolate outline points based on fitted edges.
/// Strong points (on an edge) move to the edge's fitted position.
/// Weak points (between edges) are interpolated proportionally.
pub fn interpolate_points(
  outline : @types.Outline,
  edges : Array[Edge],
  scale : @fixed.Fixed,
  is_horizontal : Bool,
) -> Unit {
  if edges.length() == 0 {
    return
  }
  for i in 0..<outline.points().length() {
    let coord = if is_horizontal {
      outline.points()[i].x()
    } else {
      outline.points()[i].y()
    }
    let scaled = @fixed.mul_fix(scale, @fixed.Fixed::from_raw(coord)).val()
    // Find bracketing edges
    let mut before_idx = -1
    let mut after_idx = -1
    for j, edge in edges {
      let edge_scaled = @fixed.mul_fix(
        scale,
        @fixed.Fixed::from_raw(edge.position),
      ).val()
      if edge_scaled <= scaled {
        before_idx = j
      }
      if edge_scaled >= scaled && after_idx < 0 {
        after_idx = j
      }
    }
    let new_coord = if before_idx >= 0 &&
      after_idx >= 0 &&
      before_idx != after_idx {
      // Interpolate between two edges
      let e1 = edges[before_idx]
      let e2 = edges[after_idx]
      let org1 = @fixed.mul_fix(scale, @fixed.Fixed::from_raw(e1.position)).val()
      let org2 = @fixed.mul_fix(scale, @fixed.Fixed::from_raw(e2.position)).val()
      let range = org2 - org1
      if range > 0L {
        let frac = (scaled - org1) * 64L / range
        e1.fitted_position +
        (e2.fitted_position - e1.fitted_position) * frac / 64L
      } else {
        e1.fitted_position
      }
    } else if before_idx >= 0 {
      // Outside right: shift by last edge's delta
      let e = edges[before_idx]
      let org = @fixed.mul_fix(scale, @fixed.Fixed::from_raw(e.position)).val()
      scaled + (e.fitted_position - org)
    } else if after_idx >= 0 {
      // Outside left: shift by first edge's delta
      let e = edges[after_idx]
      let org = @fixed.mul_fix(scale, @fixed.Fixed::from_raw(e.position)).val()
      scaled + (e.fitted_position - org)
    } else {
      scaled
    }
    if is_horizontal {
      outline.points()[i].set_x(new_coord)
    } else {
      outline.points()[i].set_y(new_coord)
    }
  }
}

// ─── Main auto-hinting entry point ──────────────────────────────────

///|
/// Apply auto-hinting to an outline.
/// Analyzes the outline for segments, edges, and stems, then fits
/// points to the pixel grid.
pub fn auto_hint_outline(
  outline : @types.Outline,
  metrics : ScriptMetrics,
) -> Unit {
  let scale = metrics.scale
  if scale.val() == 0L {
    return
  }
  // Analyze vertical segments/edges (for horizontal fitting)
  let v_segments = compute_segments(outline, SegmentDir::Vertical)
  let v_edges = compute_edges(v_segments, scale)
  let v_stems = detect_stems(v_edges)
  // Analyze horizontal segments/edges (for vertical fitting)
  let h_segments = compute_segments(outline, SegmentDir::Horizontal)
  let h_edges = compute_edges(h_segments, scale)
  let h_stems = detect_stems(h_edges)
  // Fit blue zones (vertical direction only — blue zones are horizontal lines)
  fit_blue_zones(h_edges, metrics.blue_zones, scale)
  // Fit edges
  fit_edges(v_edges, v_stems, scale)
  fit_edges(h_edges, h_stems, scale)
  // Interpolate points
  interpolate_points(outline, v_edges, scale, true)
  interpolate_points(outline, h_edges, scale, false)
}
