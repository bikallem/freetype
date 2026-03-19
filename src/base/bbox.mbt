///|
/// Compute the bounding box of an outline including off-curve control points.
/// This is the control box (cbox), which is a superset of the true bbox.
/// For glyph metrics this is sufficient and matches C FreeType's fast path.
pub fn outline_get_bbox(outline : @types.Outline) -> @types.BBox {
  let n_points = outline.n_points()
  if n_points == 0 {
    return @types.BBox::empty()
  }
  let pts = outline.points()
  let mut x_min = pts.unsafe_get(0).x()
  let mut y_min = pts.unsafe_get(0).y()
  let mut x_max = x_min
  let mut y_max = y_min
  for i in 1..<n_points {
    let p = pts.unsafe_get(i)
    let px = p.x()
    let py = p.y()
    if px < x_min {
      x_min = px
    } else if px > x_max {
      x_max = px
    }
    if py < y_min {
      y_min = py
    } else if py > y_max {
      y_max = py
    }
  }
  @types.BBox::new(x_min, y_min, x_max, y_max)
}

///|
/// Compute the control-box (cbox) of an outline.
/// This is the bounding box of all points (including off-curve),
/// which is always >= the true bbox. Fast but overestimates.
pub fn outline_get_cbox(outline : @types.Outline) -> @types.BBox {
  outline_get_bbox(outline)
}
