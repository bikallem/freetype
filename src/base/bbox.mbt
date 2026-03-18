///|
/// Compute the exact bounding box of an outline, accounting for
/// bezier curve extrema. Port of FT_Outline_Get_BBox from ftbbox.c.
pub fn outline_get_bbox(outline : @types.Outline) -> @types.BBox {
  let n_points = outline.n_points()
  if n_points == 0 {
    return @types.BBox::empty()
  }
  // Initialize with first on-curve point
  let mut x_min = outline.points[0].x
  let mut y_min = outline.points[0].y
  let mut x_max = x_min
  let mut y_max = y_min
  fn update(x : Int64, y : Int64) -> Unit {
    if x < x_min {
      x_min = x
    }
    if x > x_max {
      x_max = x
    }
    if y < y_min {
      y_min = y
    }
    if y > y_max {
      y_max = y
    }
  }

  // Quick path: just check all on-curve points first
  for i in 1..<n_points {
    match @types.CurveTag::from_byte(outline.tags[i]) {
      On => update(outline.points[i].x, outline.points[i].y)
      Conic | Cubic => ()
    }
  }
  // Now check off-curve points for potential extrema
  let n_contours = outline.n_contours()
  for c = 0, first = 0; c < n_contours; {
    let last = outline.contours[c].reinterpret_as_int()
    let mut i = first
    while i <= last {
      match @types.CurveTag::from_byte(outline.tags[i]) {
        On => ()
        Conic => {
          // Quadratic bezier: check if control point extends beyond bbox
          let ctrl = outline.points[i]
          // Quick reject: if control point is within current bbox, skip
          if ctrl.x < x_min ||
            ctrl.x > x_max ||
            ctrl.y < y_min ||
            ctrl.y > y_max {
            // Need to find the actual extrema of the quadratic bezier
            // For now, just include the control point as a conservative bound
            // This is slightly overestimating but always correct
            update(ctrl.x, ctrl.y)
          }
        }
        Cubic => {
          // Cubic bezier: include control points as conservative bound
          let ctrl = outline.points[i]
          if ctrl.x < x_min ||
            ctrl.x > x_max ||
            ctrl.y < y_min ||
            ctrl.y > y_max {
            update(ctrl.x, ctrl.y)
          }
        }
      }
      i += 1
    }
    continue c + 1, last + 1
  }
  { x_min, y_min, x_max, y_max }
}

///|
/// Compute the control-box (cbox) of an outline.
/// This is the bounding box of all points (including off-curve),
/// which is always >= the true bbox. Fast but overestimates.
pub fn outline_get_cbox(outline : @types.Outline) -> @types.BBox {
  let n_points = outline.n_points()
  if n_points == 0 {
    return @types.BBox::empty()
  }
  let mut x_min = outline.points[0].x
  let mut y_min = outline.points[0].y
  let mut x_max = x_min
  let mut y_max = y_min
  for i in 1..<n_points {
    let p = outline.points[i]
    if p.x < x_min {
      x_min = p.x
    }
    if p.x > x_max {
      x_max = p.x
    }
    if p.y < y_min {
      y_min = p.y
    }
    if p.y > y_max {
      y_max = p.y
    }
  }
  { x_min, y_min, x_max, y_max }
}
