///|
/// PostScript charstring interpreter context.
/// Shared between Type 1 and Type 2 (CFF) charstring processing.
pub struct PsInterp {
  // Operand stack
  mut stack : Array[Int64]
  // Path state
  points : Array[@types.Vector]
  tags : Array[Byte]
  contours : Array[UInt]
  mut current_x : Int64 // current point
  mut current_y : Int64
  mut path_started : Bool
  // Hint state
  hints_h : Array[StemHint] // horizontal stem hints
  hints_v : Array[StemHint] // vertical stem hints
  // Width
  mut width : Int64 // advance width (set by first operator)
  mut width_set : Bool
  // Subroutines
  mut local_subrs : Array[Bytes]
  mut global_subrs : Array[Bytes]
  // Call stack for subroutine returns
  call_stack : Array[CallFrame]
} derive(Show)

///|
/// A stem hint (horizontal or vertical).
pub struct StemHint {
  position : Int64 // start position (font units)
  width : Int64 // stem width (font units)
} derive(Eq, Show)

///|
/// Call stack frame for subroutine returns.
pub struct CallFrame {
  code : Bytes
  ip : Int
} derive(Show)

///|
pub fn PsInterp::new() -> PsInterp {
  {
    stack: [],
    points: [],
    tags: [],
    contours: [],
    current_x: 0L,
    current_y: 0L,
    path_started: false,
    hints_h: [],
    hints_v: [],
    width: 0L,
    width_set: false,
    local_subrs: [],
    global_subrs: [],
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
fn PsInterp::move_to(self : PsInterp, x : Int64, y : Int64) -> Unit {
  if self.path_started {
    // Close previous contour
    let n = self.points.length()
    if n > 0 {
      self.contours.push((n - 1).reinterpret_as_uint())
    }
  }
  self.current_x = x
  self.current_y = y
  self.points.push(@types.Vector::new(x, y))
  self.tags.push(@types.curve_tag_on)
  self.path_started = true
}

///|
fn PsInterp::line_to(self : PsInterp, x : Int64, y : Int64) -> Unit {
  self.current_x = x
  self.current_y = y
  self.points.push(@types.Vector::new(x, y))
  self.tags.push(@types.curve_tag_on)
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
  self.tags.push(@types.curve_tag_cubic)
  self.points.push(@types.Vector::new(x2, y2))
  self.tags.push(@types.curve_tag_cubic)
  self.points.push(@types.Vector::new(x3, y3))
  self.tags.push(@types.curve_tag_on)
  self.current_x = x3
  self.current_y = y3
}

///|
/// Finalize the outline: close the last contour.
pub fn PsInterp::finalize(self : PsInterp) -> @types.Outline {
  if self.path_started && self.points.length() > 0 {
    self.contours.push((self.points.length() - 1).reinterpret_as_uint())
  }
  @types.Outline::create(
    self.points.copy(),
    self.tags.copy(),
    self.contours.copy(),
  )
}
