///|
/// Translate all points of an outline by (dx, dy).
/// Port of FT_Outline_Translate from ftoutln.c.
pub fn outline_translate(
  outline : @types.Outline,
  dx : Int64,
  dy : Int64,
) -> Unit {
  for i = 0; i < outline.points.length(); i = i + 1 {
    outline.points[i].x += dx
    outline.points[i].y += dy
  }
}

///|
/// Transform all points of an outline by a 2×2 matrix.
/// Port of FT_Outline_Transform from ftoutln.c.
pub fn outline_transform(
  outline : @types.Outline,
  matrix : @fixed.Matrix,
) -> Unit {
  for i = 0; i < outline.points.length(); i = i + 1 {
    let p = outline.points[i]
    let (rx, ry) = matrix.transform(p.x, p.y)
    outline.points[i].x = rx
    outline.points[i].y = ry
  }
}

///|
/// Reverse the direction of all contours in an outline.
/// Port of FT_Outline_Reverse from ftoutln.c.
pub fn outline_reverse(outline : @types.Outline) -> Unit {
  let n_contours = outline.n_contours()
  if n_contours == 0 {
    return
  }
  let mut first = 0
  for c = 0; c < n_contours; c = c + 1 {
    let last = outline.contours[c].reinterpret_as_int()
    // Reverse points and tags between first and last
    let mut i = first
    let mut j = last
    while i < j {
      // Swap points
      let tmp_pt = outline.points[i]
      outline.points[i] = outline.points[j]
      outline.points[j] = tmp_pt
      // Swap tags
      let tmp_tag = outline.tags[i]
      outline.tags[i] = outline.tags[j]
      outline.tags[j] = tmp_tag
      i += 1
      j -= 1
    }
    first = last + 1
  }
  // Flip fill direction flag
  outline.flags = outline.flags ^ @types.outline_reverse_fill
}

///|
/// Callback interface for outline decomposition.
/// MoonBit version of FT_Outline_Funcs.
pub(all) struct OutlineFuncs {
  move_to : (@types.Vector) -> Unit raise @error.FTError
  line_to : (@types.Vector) -> Unit raise @error.FTError
  conic_to : (@types.Vector, @types.Vector) -> Unit raise @error.FTError
  cubic_to : (@types.Vector, @types.Vector, @types.Vector) -> Unit raise @error.FTError
  shift : Int
  delta : Int64
}

///|
/// Walk an outline's contours, emitting move_to/line_to/conic_to/cubic_to callbacks.
/// Port of FT_Outline_Decompose from ftoutln.c.
pub fn outline_decompose(
  outline : @types.Outline,
  funcs : OutlineFuncs,
) -> Unit raise @error.FTError {
  let n_contours = outline.n_contours()
  if n_contours == 0 {
    return
  }
  let shift = funcs.shift
  let delta = funcs.delta
  fn apply(v : @types.Vector) -> @types.Vector {
    { x: (v.x << shift) - delta, y: (v.y << shift) - delta }
  }

  let mut first = 0
  for c = 0; c < n_contours; c = c + 1 {
    let last = outline.contours[c].reinterpret_as_int()
    // Find first on-curve point
    let mut start = first
    let mut start_tag = @types.curve_tag(outline.tags[start])
    // If first point is off-curve conic, check last point
    if start_tag == @types.curve_tag_conic {
      let last_tag = @types.curve_tag(outline.tags[last])
      if last_tag == @types.curve_tag_on {
        start = last
        start_tag = @types.curve_tag_on
      } else {
        // Both off-curve: start at virtual on-curve midpoint
        let p0 = outline.points[first]
        let p1 = outline.points[last]
        let mid : @types.Vector = {
          x: (p0.x + p1.x) / 2L,
          y: (p0.y + p1.y) / 2L,
        }
        (funcs.move_to)(apply(mid))
        // Process from first point
        let mut i = first
        while i <= last {
          let tag = @types.curve_tag(outline.tags[i])
          let pt = apply(outline.points[i])
          if tag == @types.curve_tag_on {
            (funcs.line_to)(pt)
          } else if tag == @types.curve_tag_conic {
            // Look ahead for next on-curve or another conic
            let next_i = if i < last { i + 1 } else { first }
            let next_tag = @types.curve_tag(outline.tags[next_i])
            let next_pt = apply(outline.points[next_i])
            if next_tag == @types.curve_tag_on {
              (funcs.conic_to)(pt, next_pt)
              i += 1 // skip the on-curve point we just consumed
            } else {
              // Two consecutive conics: insert virtual on-curve midpoint
              let virt : @types.Vector = {
                x: (pt.x + next_pt.x) / 2L,
                y: (pt.y + next_pt.y) / 2L,
              }
              (funcs.conic_to)(pt, virt)
            }
            // Cubic
          } else if i + 1 <= last {
            let ctrl2 = apply(outline.points[i + 1])
            let next_i = if i + 2 <= last { i + 2 } else { first }
            let to = apply(outline.points[next_i])
            (funcs.cubic_to)(pt, ctrl2, to)
            i += 2
          }
          i += 1
        }
        // Close contour
        (funcs.line_to)(apply(mid))
        first = last + 1
        continue
      }
    }
    // Normal case: start point is on-curve
    let start_pt = apply(outline.points[start])
    (funcs.move_to)(start_pt)
    let mut i = if start == last { first } else { start + 1 }
    let mut done = false
    while not(done) {
      let tag = @types.curve_tag(outline.tags[i])
      let pt = apply(outline.points[i])
      if tag == @types.curve_tag_on {
        (funcs.line_to)(pt)
      } else if tag == @types.curve_tag_conic {
        let next_i = if i < last { i + 1 } else { first }
        let next_tag = @types.curve_tag(outline.tags[next_i])
        let next_pt = apply(outline.points[next_i])
        if next_tag == @types.curve_tag_on {
          (funcs.conic_to)(pt, next_pt)
          i = next_i
        } else {
          let virt : @types.Vector = {
            x: (pt.x + next_pt.x) / 2L,
            y: (pt.y + next_pt.y) / 2L,
          }
          (funcs.conic_to)(pt, virt)
        }
      } else {
        // Cubic: expect two off-curve points + one on-curve
        let next_i = if i < last { i + 1 } else { first }
        let ctrl2 = apply(outline.points[next_i])
        let to_i = if next_i < last { next_i + 1 } else { first }
        let to = apply(outline.points[to_i])
        (funcs.cubic_to)(pt, ctrl2, to)
        i = to_i
      }
      if i == start || (start == last && i == last) {
        done = true
      } else {
        i = if i < last { i + 1 } else { first }
      }
    }
    first = last + 1
  }
}

///|
/// Compute the orientation of an outline.
/// Returns 1 for clockwise, -1 for counter-clockwise, 0 for degenerate.
/// Port of FT_Outline_Get_Orientation from ftoutln.c.
pub fn outline_get_orientation(outline : @types.Outline) -> Int {
  let n_points = outline.n_points()
  if n_points < 3 {
    return 0
  }
  // Use the shoelace formula (signed area)
  let mut area = 0L
  let mut prev = outline.points[n_points - 1]
  for i = 0; i < n_points; i = i + 1 {
    let curr = outline.points[i]
    area += (prev.x - curr.x) * (prev.y + curr.y)
    prev = curr
  }
  if area > 0L {
    1 // clockwise (TrueType convention)
  } else if area < 0L {
    -1 // counter-clockwise (Type 1 convention)
  } else {
    0
  }
}
