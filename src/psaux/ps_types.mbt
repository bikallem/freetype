///|
/// PostScript charstring interpreter context.
/// Shared between Type 1 and Type 2 (CFF) charstring processing.
struct PsInterp {
  // Operand stack
  mut stack : Array[Int64]
  transient : Array[Int64]
  // Path state
  points : Array[@types.Vector]
  tags : Array[Byte]
  contours : Array[UInt]
  mut current_x : Int64 // current point
  mut current_y : Int64
  mut left_bearing_x : Int64
  mut left_bearing_y : Int64
  mut path_started : Bool
  // Hint state
  hints_h : Array[StemHint] // horizontal stem hints
  hints_v : Array[StemHint] // vertical stem hints
  // Width
  mut width : Int64 // advance width (set by first operator)
  mut nominal_width : Int64 // nominalWidthX for Type 2 width deltas
  mut width_set : Bool
  // Subroutines
  mut local_subrs : Array[Bytes]
  mut global_subrs : Array[Bytes]
  mut random_state : Int64
  // Call stack for subroutine returns
  call_stack : Array[CallFrame]
} derive(Show)

///|
/// A stem hint (horizontal or vertical).
#valtype
struct StemHint {
  position : Int64 // start position (font units)
  width : Int64 // stem width (font units)
} derive(Eq, Show)

///|
pub fn StemHint::position(self : StemHint) -> Int64 {
  self.position
}

///|
pub fn StemHint::width(self : StemHint) -> Int64 {
  self.width
}

///|
/// Call stack frame for subroutine returns.
struct CallFrame {
  code : Bytes
  ip : Int
} derive(Show)

///|
pub fn PsInterp::new() -> PsInterp {
  {
    stack: [],
    transient: Array::make(32, 0L),
    points: [],
    tags: [],
    contours: [],
    current_x: 0L,
    current_y: 0L,
    left_bearing_x: 0L,
    left_bearing_y: 0L,
    path_started: false,
    hints_h: [],
    hints_v: [],
    width: 0L,
    nominal_width: 0L,
    width_set: false,
    local_subrs: [],
    global_subrs: [],
    random_state: 0x7384L,
    call_stack: [],
  }
}

///|
fn PsInterp::push(self : PsInterp, val : Int64) -> Unit {
  self.stack.push(val)
}

///|
fn PsInterp::pop(self : PsInterp) -> Int64 {
  self.stack.pop().unwrap_or(0L)
}

///|
fn PsInterp::close_current_contour(self : PsInterp) -> Unit {
  let n = self.points.length()
  if n == 0 {
    return
  }
  let contour_start = if self.contours.length() == 0 {
    0
  } else {
    self.contours[self.contours.length() - 1].reinterpret_as_int() + 1
  }
  if n - contour_start >= 4 {
    let end = n - 1
    let start_pt = self.points[contour_start]
    let end_pt = self.points[end]
    if start_pt.x() == end_pt.x() &&
      start_pt.y() == end_pt.y() &&
      self.tags[end] == @types.CURVE_TAG_ON &&
      self.tags[end - 1] == @types.CURVE_TAG_CUBIC &&
      self.tags[end - 2] == @types.CURVE_TAG_CUBIC {
      ignore(self.points.pop())
      ignore(self.tags.pop())
    }
  }
  self.contours.push((self.points.length() - 1).reinterpret_as_uint())
}

///|
fn PsInterp::move_to(self : PsInterp, x : Int64, y : Int64) -> Unit {
  if self.path_started {
    // Close previous contour
    self.close_current_contour()
  }
  self.current_x = x
  self.current_y = y
  self.points.push(@types.Vector::new(x, y))
  self.tags.push(@types.CURVE_TAG_ON)
  self.path_started = true
}

///|
fn PsInterp::line_to(self : PsInterp, x : Int64, y : Int64) -> Unit {
  self.current_x = x
  self.current_y = y
  self.points.push(@types.Vector::new(x, y))
  self.tags.push(@types.CURVE_TAG_ON)
}

///|
fn PsInterp::curve_to(
  self : PsInterp,
  x1 : Int64,
  y1 : Int64,
  x2 : Int64,
  y2 : Int64,
  x3 : Int64,
  y3 : Int64,
) -> Unit {
  self.points.push(@types.Vector::new(x1, y1))
  self.tags.push(@types.CURVE_TAG_CUBIC)
  self.points.push(@types.Vector::new(x2, y2))
  self.tags.push(@types.CURVE_TAG_CUBIC)
  self.points.push(@types.Vector::new(x3, y3))
  self.tags.push(@types.CURVE_TAG_ON)
  self.current_x = x3
  self.current_y = y3
}

///|
fn PsInterp::append_outline(
  self : PsInterp,
  outline : @types.Outline,
  dx? : Int64 = 0L,
  dy? : Int64 = 0L,
) -> Unit {
  if self.path_started {
    self.close_current_contour()
    self.path_started = false
  }
  let point_offset = self.points.length()
  for i in 0..<outline.n_points() {
    let p = outline.points()[i]
    self.points.push(@types.Vector::new(p.x() + dx, p.y() + dy))
    self.tags.push(outline.tags()[i])
  }
  for i in 0..<outline.n_contours() {
    self.contours.push(
      (outline.contours()[i].reinterpret_as_int() + point_offset).reinterpret_as_uint(),
    )
  }
  if outline.n_points() > 0 {
    let last = outline.points()[outline.n_points() - 1]
    self.current_x = last.x() + dx
    self.current_y = last.y() + dy
  }
}

///|
/// Finalize the outline: close the last contour.
pub fn PsInterp::finalize(self : PsInterp) -> @types.Outline {
  if self.path_started && self.points.length() > 0 {
    self.close_current_contour()
  }
  let n_points = self.points.length()
  let fa_points = FixedArray::make(n_points, @types.Vector::new(0L, 0L))
  let fa_tags = FixedArray::make(n_points, b'\x00')
  for i in 0..<n_points {
    fa_points[i] = self.points[i]
    fa_tags[i] = self.tags[i]
  }
  let n_contours = self.contours.length()
  let fa_contours = FixedArray::make(n_contours, 0U)
  for i in 0..<n_contours {
    fa_contours[i] = self.contours[i]
  }
  @types.Outline::create(fa_points, fa_tags, fa_contours)
}
