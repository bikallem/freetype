///|
/// TrueType bytecode interpreter execution context.
struct InterpContext {
  // Operand stack
  mut stack : Array[Int64]
  mut sp : Int // stack pointer (index of next push position)
  // Code
  mut code : Bytes
  mut ip : Int // instruction pointer
  // Control Value Table
  mut cvt : Array[Int64] // 26.6 values
  mut cvt_scale : @fixed.Fixed
  // Storage area
  mut storage : Array[Int64]
  // Graphics state
  mut gs : GraphicsState
  // Function definitions
  mut func_defs : Map[Int, FuncDef]
  // Loop counter
  mut loop_count : Int
  // Points (zone 0 = twilight, zone 1 = glyph)
  mut zone0_org : FixedArray[@types.Vector] // twilight zone original points
  mut zone0_cur : FixedArray[@types.Vector] // twilight zone current points
  mut zone0_tags : FixedArray[Byte]
  mut zone0_points : FixedArray[@types.Vector] // alias for zone0_cur
  mut zone1_org : FixedArray[@types.Vector] // glyph zone original points
  mut zone1_cur : FixedArray[@types.Vector] // glyph zone current (hinted) points
  mut zone1_points : FixedArray[@types.Vector] // alias for zone1_cur
  mut zone1_tags : FixedArray[Byte]
  mut zone1_touch : FixedArray[Byte] // touch flags per point (bit 0 = x touched, bit 1 = y touched)
  mut zone1_contours : FixedArray[UInt]
  // Current pixels per em
  mut ppem : Int
  // Normalized variation coordinates (F2Dot14 values)
  mut var_coords : Array[Int]
  // Error state
  mut error : Bool
} derive(Show)

///|
/// Graphics state for the TrueType interpreter.
struct GraphicsState {
  mut rp0 : Int
  mut rp1 : Int
  mut rp2 : Int
  mut freedom_vector_x : Int64 // 2.14 as Int64
  mut freedom_vector_y : Int64
  mut projection_vector_x : Int64
  mut projection_vector_y : Int64
  mut dual_projection_x : Int64
  mut dual_projection_y : Int64
  mut round_state : Int // 0=off, 1=to_grid, 2=to_half_grid, 3=to_double_grid, 4=down_to_grid, 5=up_to_grid
  mut minimum_distance : Int64 // 26.6
  mut control_value_cut_in : Int64 // 26.6
  mut single_width_cut_in : Int64 // 26.6
  mut single_width_value : Int64 // 26.6
  mut auto_flip : Bool
  delta_base : Int
  delta_shift : Int
  instruct_control : Int
  scan_control : Bool
  scan_type : Int
  // Zone pointers
  mut zp0 : Int // 0 or 1
  mut zp1 : Int
  mut zp2 : Int
} derive(Show)

///|
pub fn GraphicsState::default() -> GraphicsState {
  {
    rp0: 0,
    rp1: 0,
    rp2: 0,
    freedom_vector_x: 0x4000L, // unit vector (1,0) in 2.14
    freedom_vector_y: 0L,
    projection_vector_x: 0x4000L,
    projection_vector_y: 0L,
    dual_projection_x: 0x4000L,
    dual_projection_y: 0L,
    round_state: 1, // round to grid
    minimum_distance: 64L, // 1 pixel in 26.6
    control_value_cut_in: 68L, // 17/16 pixel
    single_width_cut_in: 0L,
    single_width_value: 0L,
    auto_flip: true,
    delta_base: 9,
    delta_shift: 3,
    instruct_control: 0,
    scan_control: false,
    scan_type: 0,
    zp0: 1,
    zp1: 1,
    zp2: 1,
  }
}

///|
/// Function definition (from FDEF instruction).
struct FuncDef {
  start : Int // start offset in code
  end_ : Int // end offset (ENDF position)
  code : Bytes // the code array this function was defined in
} derive(Show)

///|
pub fn InterpContext::new(
  cvt? : Array[Int64] = [],
  storage_size? : Int = 32,
  max_stack? : Int = 256,
) -> InterpContext {
  {
    stack: Array::make(max_stack, 0L),
    sp: 0,
    code: b"",
    ip: 0,
    cvt,
    cvt_scale: @fixed.Fixed::one(),
    storage: Array::make(storage_size, 0L),
    gs: GraphicsState::default(),
    func_defs: {},
    loop_count: 1,
    zone0_org: FixedArray::default(),
    zone0_cur: FixedArray::default(),
    zone0_tags: FixedArray::default(),
    zone0_points: FixedArray::default(),
    zone1_org: FixedArray::default(),
    zone1_cur: FixedArray::default(),
    zone1_points: FixedArray::default(),
    zone1_tags: FixedArray::default(),
    zone1_touch: FixedArray::default(),
    zone1_contours: FixedArray::default(),
    ppem: 0,
    var_coords: [],
    error: false,
  }
}

// --- InterpContext setters (for external packages) ---

///|
pub fn InterpContext::set_ppem(self : InterpContext, v : Int) -> Unit {
  self.ppem = v
}

///|
pub fn InterpContext::set_var_coords(
  self : InterpContext,
  v : Array[Int],
) -> Unit {
  self.var_coords = v
}

///|
pub fn InterpContext::set_gs(self : InterpContext, v : GraphicsState) -> Unit {
  self.gs = v
}

///|
pub fn InterpContext::func_defs(self : InterpContext) -> Map[Int, FuncDef] {
  self.func_defs
}

///|
pub fn InterpContext::set_func_defs(
  self : InterpContext,
  v : Map[Int, FuncDef],
) -> Unit {
  self.func_defs = v
}

///|
pub fn InterpContext::set_cvt(self : InterpContext, v : Array[Int64]) -> Unit {
  self.cvt = v
}

///|
pub fn InterpContext::set_cvt_scale(
  self : InterpContext,
  v : @fixed.Fixed,
) -> Unit {
  self.cvt_scale = v
}

///|
pub fn InterpContext::reset_sp(self : InterpContext) -> Unit {
  self.sp = 0
  self.error = false
  self.loop_count = 1
}

///|
pub fn InterpContext::set_zone0_org(
  self : InterpContext,
  v : FixedArray[@types.Vector],
) -> Unit {
  self.zone0_org = v
}

///|
pub fn InterpContext::set_zone0_cur(
  self : InterpContext,
  v : FixedArray[@types.Vector],
) -> Unit {
  self.zone0_cur = v
}

///|
pub fn InterpContext::set_zone0_tags(
  self : InterpContext,
  v : FixedArray[Byte],
) -> Unit {
  self.zone0_tags = v
}

///|
pub fn InterpContext::set_zone0_points(
  self : InterpContext,
  v : FixedArray[@types.Vector],
) -> Unit {
  self.zone0_points = v
}

///|
pub fn InterpContext::set_zone1_org(
  self : InterpContext,
  v : FixedArray[@types.Vector],
) -> Unit {
  self.zone1_org = v
}

///|
pub fn InterpContext::set_zone1_cur(
  self : InterpContext,
  v : FixedArray[@types.Vector],
) -> Unit {
  self.zone1_cur = v
}

///|
pub fn InterpContext::set_zone1_tags(
  self : InterpContext,
  v : FixedArray[Byte],
) -> Unit {
  self.zone1_tags = v
}

///|
pub fn InterpContext::set_zone1_touch(
  self : InterpContext,
  v : FixedArray[Byte],
) -> Unit {
  self.zone1_touch = v
}

///|
pub fn InterpContext::set_zone1_contours(
  self : InterpContext,
  v : FixedArray[UInt],
) -> Unit {
  self.zone1_contours = v
}

///|
pub fn InterpContext::set_zone1_points(
  self : InterpContext,
  v : FixedArray[@types.Vector],
) -> Unit {
  self.zone1_points = v
}

///|
fn InterpContext::push(self : InterpContext, val : Int64) -> Unit {
  if self.sp < self.stack.length() {
    self.stack.unsafe_set(self.sp, val)
    self.sp += 1
  } else {
    self.error = true
  }
}

///|
fn InterpContext::pop(self : InterpContext) -> Int64 {
  if self.sp > 0 {
    self.sp -= 1
    self.stack.unsafe_get(self.sp)
  } else {
    self.error = true
    0L
  }
}

// --- Zone point helpers ---

///|
/// Get current point coordinates from the given zone.
fn InterpContext::get_zone_point(
  self : InterpContext,
  zone : Int,
  idx : Int,
) -> (Int64, Int64) {
  let points = if zone == 0 { self.zone0_cur } else { self.zone1_cur }
  if idx >= 0 && idx < points.length() {
    (points[idx].x(), points[idx].y())
  } else {
    (0L, 0L)
  }
}

///|
/// Set current point coordinates in the given zone.
fn InterpContext::set_zone_point(
  self : InterpContext,
  zone : Int,
  idx : Int,
  x : Int64,
  y : Int64,
) -> Unit {
  let points = if zone == 0 { self.zone0_cur } else { self.zone1_cur }
  if idx >= 0 && idx < points.length() {
    points[idx] = @types.Vector::new(x, y)
  }
}

///|
/// Get original point coordinates from the given zone.
fn InterpContext::get_zone_org(
  self : InterpContext,
  zone : Int,
  idx : Int,
) -> (Int64, Int64) {
  let points = if zone == 0 { self.zone0_org } else { self.zone1_org }
  if idx >= 0 && idx < points.length() {
    (points[idx].x(), points[idx].y())
  } else {
    (0L, 0L)
  }
}

// --- Projection/distance helpers ---

///|
/// Project (x,y) onto the projection vector. Result is 26.6.
fn InterpContext::project(self : InterpContext, x : Int64, y : Int64) -> Int64 {
  (x * self.gs.projection_vector_x + y * self.gs.projection_vector_y) >> 14
}

///|
/// Project (x,y) onto the dual projection vector. Result is 26.6.
fn InterpContext::dual_project(
  self : InterpContext,
  x : Int64,
  y : Int64,
) -> Int64 {
  (x * self.gs.dual_projection_x + y * self.gs.dual_projection_y) >> 14
}

///|
/// Move a point along the freedom vector by distance (26.6).
fn InterpContext::move_point(
  self : InterpContext,
  zone : Int,
  idx : Int,
  distance : Int64,
) -> Unit {
  let points = if zone == 0 { self.zone0_cur } else { self.zone1_cur }
  if idx >= 0 && idx < points.length() {
    let p = points[idx]
    points[idx] = @types.Vector::new(
      p.x() + ((distance * self.gs.freedom_vector_x) >> 14),
      p.y() + ((distance * self.gs.freedom_vector_y) >> 14),
    )
    // Mark point as touched
    let touch = if zone == 0 { self.zone0_tags } else { self.zone1_touch }
    if idx < touch.length() {
      let mut flags = touch[idx].to_int()
      // Touch in x if freedom vector has x component
      if self.gs.freedom_vector_x != 0L {
        flags = flags | 0x01
      }
      // Touch in y if freedom vector has y component
      if self.gs.freedom_vector_y != 0L {
        flags = flags | 0x02
      }
      touch[idx] = flags.to_byte()
    }
  }
}

///|
/// Round a 26.6 distance according to the current round_state.
fn InterpContext::round_value(self : InterpContext, distance : Int64) -> Int64 {
  let sign : Int64 = if distance >= 0L { 1L } else { -1L }
  let d = if distance < 0L { -distance } else { distance }
  let result = match self.gs.round_state {
    0 => d // round off
    1 => (d + 32L) & -64L // round to grid (nearest multiple of 64)
    2 => { // round to half grid
      let r = (d & -64L) + 32L
      r
    }
    3 => (d + 16L) & -32L // round to double grid (nearest multiple of 32)
    4 => d & -64L // round down to grid (floor)
    5 => (d + 63L) & -64L // round up to grid (ceiling)
    _ => (d + 32L) & -64L // default: round to grid
  }
  sign * result
}

///|
fn InterpContext::scale_font_units(
  self : InterpContext,
  value : Int64,
) -> Int64 {
  let ab = self.cvt_scale.val() * value
  (ab + 0x8000L + (ab >> 63)) >> 16
}

///|
/// Normalize a vector (dx,dy) to 2.14 unit vector.
fn normalize_vector(dx : Int64, dy : Int64) -> (Int64, Int64) {
  if dx == 0L && dy == 0L {
    return (0x4000L, 0L)
  }
  // Compute length using integer square root approximation
  let ax = if dx < 0L { -dx } else { dx }
  let ay = if dy < 0L { -dy } else { dy }
  // Use the larger component to avoid overflow
  if ax == 0L {
    return (0L, if dy > 0L { 0x4000L } else { -0x4000L })
  }
  if ay == 0L {
    return (if dx > 0L { 0x4000L } else { -0x4000L }, 0L)
  }
  // Compute length = sqrt(dx*dx + dy*dy) using shift to avoid overflow
  // Scale down if needed to prevent overflow in multiplication
  let mut sdx = dx
  let mut sdy = dy
  while (if sdx < 0L { -sdx } else { sdx }) > 0x4000L ||
        (if sdy < 0L { -sdy } else { sdy }) > 0x4000L {
    sdx = sdx >> 1
    sdy = sdy >> 1
  }
  let len_sq = sdx * sdx + sdy * sdy
  // Integer square root
  let mut r = 1L
  let mut s = len_sq
  while s > 0L {
    s = s >> 2
    r = r << 1
  }
  // Newton's method
  for _ in 0..<10 {
    if r == 0L {
      break
    }
    r = (r + len_sq / r) >> 1
  }
  let length = r
  if length == 0L {
    return (0x4000L, 0L)
  }
  // Result in 2.14: component * 0x4000 / length (using scaled values)
  let rx = sdx * 0x4000L / length
  let ry = sdy * 0x4000L / length
  (rx, ry)
}

///|
/// Execute bytecode from the given code buffer.
pub fn InterpContext::execute(
  self : InterpContext,
  code : Bytes,
) -> Unit raise @error.FTError {
  self.code = code
  self.ip = 0
  let len = code.length()
  while self.ip < len && !self.error {
    let opcode = code[self.ip].to_int()
    self.ip += 1
    self.exec_opcode(opcode)
  }
  if self.error {
    raise @error.FTError::InvalidOpcode
  }
}

///|
/// Execute a single opcode.
fn InterpContext::exec_opcode(self : InterpContext, opcode : Int) -> Unit {
  match opcode {
    // --- Stack manipulation ---
    0x20 => self.op_dup() // DUP
    0x21 => self.op_pop() // POP
    0x22 => self.op_clear() // CLEAR
    0x23 => self.op_swap() // SWAP
    0x24 => self.op_depth() // DEPTH
    0x25 => self.op_cindex() // CINDEX
    0x26 => self.op_mindex() // MINDEX
    // --- Arithmetic ---
    0x60 => self.op_add() // ADD
    0x61 => self.op_sub() // SUB
    0x62 => self.op_div() // DIV
    0x63 => self.op_mul() // MUL
    0x64 => self.op_abs() // ABS
    0x65 => self.op_neg() // NEG
    0x66 => self.op_floor() // FLOOR
    0x67 => self.op_ceiling() // CEILING
    0x8A => self.op_roll() // ROLL
    0x6C => self.op_nround() // NROUND[00]
    0x6D => self.op_nround() // NROUND[01]
    0x6E => self.op_nround() // NROUND[10]
    0x6F => self.op_nround() // NROUND[11]
    0x68 => self.op_round() // ROUND[00]
    0x69 => self.op_round() // ROUND[01]
    0x6A => self.op_round() // ROUND[10]
    0x6B => self.op_round() // ROUND[11]
    // --- Comparison ---
    0x50 => self.op_lt() // LT
    0x51 => self.op_lteq() // LTEQ
    0x52 => self.op_gt() // GT
    0x53 => self.op_gteq() // GTEQ
    0x54 => self.op_eq() // EQ
    0x55 => self.op_neq() // NEQ
    // --- Logical ---
    0x5A => self.op_and() // AND
    0x5B => self.op_or() // OR
    0x5C => self.op_not() // NOT
    // --- Flow control ---
    0x58 => self.op_if() // IF
    0x1B => self.op_else() // ELSE
    0x59 => () // EIF (no-op, IF handles it)
    0x1C => self.op_jmpr() // JMPR
    0x78 => self.op_jrot() // JROT
    0x79 => self.op_jrof() // JROF
    0x2C => self.op_fdef() // FDEF
    0x2D => () // ENDF (handled by FDEF/CALL)
    0x2B => self.op_call() // CALL
    0x2A => self.op_loopcall() // LOOPCALL
    // --- Push ---
    0x40 => self.op_npushb() // NPUSHB
    0x41 => self.op_npushw() // NPUSHW
    // PUSHB[0-7]
    _ if opcode >= 0xB0 && opcode <= 0xB7 => self.op_pushb(opcode - 0xB0 + 1)
    // PUSHW[0-7]
    _ if opcode >= 0xB8 && opcode <= 0xBF => self.op_pushw(opcode - 0xB8 + 1)
    // --- Reading/Writing ---
    0x43 => self.op_rs() // RS (read storage)
    0x42 => self.op_ws() // WS (write storage)
    0x44 => self.op_rcvt() // RCVT
    0x45 => self.op_wcvtp() // WCVTP
    0x70 => self.op_wcvtf() // WCVTF
    // --- Graphics state ---
    0x10 => self.gs.rp0 = self.pop().to_int() // SRP0
    0x11 => self.gs.rp1 = self.pop().to_int() // SRP1
    0x12 => self.gs.rp2 = self.pop().to_int() // SRP2
    0x13 => self.gs.zp0 = self.pop().to_int() // SZP0
    0x14 => self.gs.zp1 = self.pop().to_int() // SZP1
    0x15 => self.gs.zp2 = self.pop().to_int() // SZP2
    0x16 => { // SZPS (set all zone pointers)
      let z = self.pop().to_int()
      self.gs.zp0 = z
      self.gs.zp1 = z
      self.gs.zp2 = z
    }
    0x17 => self.loop_count = self.pop().to_int() // SLOOP
    // --- Rounding opcodes ---
    0x18 => self.gs.round_state = 1 // RTG (round to grid)
    0x19 => self.gs.round_state = 2 // RTHG (round to half grid)
    0x3D => self.gs.round_state = 3 // RTDG (round to double grid)
    0x7A => self.gs.round_state = 0 // ROFF (round off)
    0x76 => { // SROUND
      ignore(self.pop()) // consume period/phase/threshold arg
      self.gs.round_state = 1 // treat as round to grid
    }
    0x77 => { // S45ROUND
      ignore(self.pop()) // consume period/phase/threshold arg
      self.gs.round_state = 1 // treat as round to grid
    }
    0x7C => self.gs.round_state = 5 // RUTG (round up to grid)
    0x7D => self.gs.round_state = 4 // RDTG (round down to grid)
    // --- Other graphics state ---
    0x1A => self.gs.minimum_distance = self.pop() // SMD
    0x1D => self.gs.control_value_cut_in = self.pop() // SCVTCI
    0x1E => self.gs.single_width_cut_in = self.pop() // SSWCI
    0x1F => self.gs.single_width_value = self.pop() // SSW
    0x4D => self.gs.auto_flip = true // FLIPON
    0x4E => self.gs.auto_flip = false // FLIPOFF
    0x4F => () // DEBUG (no-op)
    0x85 => ignore(self.pop()) // SCANCTRL
    0x8D => ignore(self.pop()) // SCANTYPE
    0x88 => self.op_getinfo() // GETINFO
    0x91 => self.op_getvariation() // GETVARIATION
    // --- Vector opcodes ---
    0x02 => { // SPVTCA[0] - set PV to y-axis
      self.gs.projection_vector_x = 0L
      self.gs.projection_vector_y = 0x4000L
      self.gs.dual_projection_x = 0L
      self.gs.dual_projection_y = 0x4000L
    }
    0x03 => { // SPVTCA[1] - set PV to x-axis
      self.gs.projection_vector_x = 0x4000L
      self.gs.projection_vector_y = 0L
      self.gs.dual_projection_x = 0x4000L
      self.gs.dual_projection_y = 0L
    }
    0x04 => { // SFVTCA[0] - set FV to y-axis
      self.gs.freedom_vector_x = 0L
      self.gs.freedom_vector_y = 0x4000L
    }
    0x05 => { // SFVTCA[1] - set FV to x-axis
      self.gs.freedom_vector_x = 0x4000L
      self.gs.freedom_vector_y = 0L
    }
    0x06 => self.op_spvtl(0) // SPVTL[0] - set PV parallel to line
    0x07 => self.op_spvtl(1) // SPVTL[1] - set PV perpendicular to line
    0x08 => self.op_sfvtl(0) // SFVTL[0] - set FV parallel to line
    0x09 => self.op_sfvtl(1) // SFVTL[1] - set FV perpendicular to line
    0x0A => { // SPVFS - set PV from stack
      let y = self.pop()
      let x = self.pop()
      self.gs.projection_vector_x = x
      self.gs.projection_vector_y = y
      self.gs.dual_projection_x = x
      self.gs.dual_projection_y = y
    }
    0x0B => { // SFVFS - set FV from stack
      let y = self.pop()
      let x = self.pop()
      self.gs.freedom_vector_x = x
      self.gs.freedom_vector_y = y
    }
    0x0C => { // GPV - get projection vector
      self.push(self.gs.projection_vector_x)
      self.push(self.gs.projection_vector_y)
    }
    0x0D => { // GFV - get freedom vector
      self.push(self.gs.freedom_vector_x)
      self.push(self.gs.freedom_vector_y)
    }
    0x0E => { // SFVTPV - set FV to PV
      self.gs.freedom_vector_x = self.gs.projection_vector_x
      self.gs.freedom_vector_y = self.gs.projection_vector_y
    }
    // --- Measurement ---
    0x46 => self.op_gc(0) // GC[0] - get coordinate (current)
    0x47 => self.op_gc(1) // GC[1] - get coordinate (original)
    0x48 => self.op_scfs() // SCFS - set coordinate from stack
    0x49 => self.op_md(0) // MD[0] - measure distance (current)
    0x4A => self.op_md(1) // MD[1] - measure distance (original)
    0x4B => self.push(self.ppem.to_int64()) // MPPEM - measure pixels per em
    0x4C => self.push(self.ppem.to_int64()) // MPS - measure point size (same as ppem for our purposes)
    // --- Point movement opcodes ---
    0x2E => self.op_mdap(0) // MDAP[0]
    0x2F => self.op_mdap(1) // MDAP[1]
    0x3E => self.op_miap(0) // MIAP[0]
    0x3F => self.op_miap(1) // MIAP[1]
    0x30 => self.op_iup(0) // IUP[0] - interpolate untouched y
    0x31 => self.op_iup(1) // IUP[1] - interpolate untouched x
    0x32 => self.op_shp(0) // SHP[0]
    0x33 => self.op_shp(1) // SHP[1]
    0x34 => self.op_shc(0) // SHC[0]
    0x35 => self.op_shc(1) // SHC[1]
    0x36 => self.op_shz(0) // SHZ[0]
    0x37 => self.op_shz(1) // SHZ[1]
    0x38 => self.op_shpix() // SHPIX
    0x39 => self.op_ip() // IP
    0x3A => self.op_msirp(0) // MSIRP[0]
    0x3B => self.op_msirp(1) // MSIRP[1]
    0x3C => self.op_alignrp() // ALIGNRP
    0x27 => self.op_alignpts() // ALIGNPTS
    0x0F => self.op_isect() // ISECT
    // MDRP[00000] - MDRP[11111]
    _ if opcode >= 0xC0 && opcode <= 0xDF => self.op_mdrp(opcode - 0xC0)
    // MIRP[00000] - MIRP[11111]
    _ if opcode >= 0xE0 && opcode <= 0xFF => self.op_mirp(opcode - 0xE0)
    // --- Delta instructions ---
    0x5D => self.op_deltap(1) // DELTAP1
    0x71 => self.op_deltap(2) // DELTAP2
    0x72 => self.op_deltap(3) // DELTAP3
    0x73 => self.op_deltac(1) // DELTAC1
    0x74 => self.op_deltac(2) // DELTAC2
    0x75 => self.op_deltac(3) // DELTAC3
    // --- FLIP instructions ---
    0x80 => self.op_flippt() // FLIPPT
    0x81 => self.op_fliprgon() // FLIPRGON
    0x82 => self.op_fliprgoff() // FLIPRGOFF
    // --- Misc ---
    _ => self.error = true
  }
}

// --- Stack operations ---

///|
fn InterpContext::op_dup(self : InterpContext) -> Unit {
  let a = self.pop()
  self.push(a)
  self.push(a)
}

///|
fn InterpContext::op_pop(self : InterpContext) -> Unit {
  ignore(self.pop())
}

///|
fn InterpContext::op_clear(self : InterpContext) -> Unit {
  self.sp = 0
}

///|
fn InterpContext::op_swap(self : InterpContext) -> Unit {
  let a = self.pop()
  let b = self.pop()
  self.push(a)
  self.push(b)
}

///|
fn InterpContext::op_depth(self : InterpContext) -> Unit {
  self.push(self.sp.to_int64())
}

///|
fn InterpContext::op_cindex(self : InterpContext) -> Unit {
  let k = self.pop().to_int()
  if k > 0 && k <= self.sp {
    self.push(self.stack[self.sp - k])
  } else {
    self.push(0L)
  }
}

///|
fn InterpContext::op_mindex(self : InterpContext) -> Unit {
  let k = self.pop().to_int()
  if k > 0 && k <= self.sp {
    let val = self.stack[self.sp - k]
    // Shift stack down
    for i in (self.sp - k)..<(self.sp - 1) {
      self.stack[i] = self.stack[i + 1]
    }
    self.stack[self.sp - 1] = val
  }
}

///|
fn InterpContext::op_roll(self : InterpContext) -> Unit {
  let a = self.pop()
  let b = self.pop()
  let c = self.pop()
  self.push(b)
  self.push(a)
  self.push(c)
}

// --- Arithmetic ---

///|
fn InterpContext::op_add(self : InterpContext) -> Unit {
  let b = self.pop()
  let a = self.pop()
  self.push(a + b)
}

///|
fn InterpContext::op_sub(self : InterpContext) -> Unit {
  let b = self.pop()
  let a = self.pop()
  self.push(a - b)
}

///|
fn InterpContext::op_mul(self : InterpContext) -> Unit {
  let b = self.pop()
  let a = self.pop()
  // 26.6 * 26.6 -> 26.6 (divide by 64)
  self.push((a * b + 32L) >> 6)
}

///|
fn InterpContext::op_div(self : InterpContext) -> Unit {
  let b = self.pop()
  let a = self.pop()
  if b != 0L {
    self.push((a << 6) / b)
  } else {
    self.error = true
  }
}

///|
fn InterpContext::op_abs(self : InterpContext) -> Unit {
  let a = self.pop()
  self.push(if a < 0L { -a } else { a })
}

///|
fn InterpContext::op_neg(self : InterpContext) -> Unit {
  self.push(-self.pop())
}

///|
fn InterpContext::op_floor(self : InterpContext) -> Unit {
  let a = self.pop()
  self.push(a & -64L)
}

///|
fn InterpContext::op_ceiling(self : InterpContext) -> Unit {
  let a = self.pop()
  self.push((a + 63L) & -64L)
}

///|
fn InterpContext::op_nround(self : InterpContext) -> Unit {
  ignore(self) // No rounding, just leave value
}

///|
/// ROUND opcode: pop value, round it, push result.
fn InterpContext::op_round(self : InterpContext) -> Unit {
  let val = self.pop()
  self.push(self.round_value(val))
}

// --- Comparison ---

///|
fn InterpContext::op_lt(self : InterpContext) -> Unit {
  let b = self.pop()
  let a = self.pop()
  self.push(if a < b { 1L } else { 0L })
}

///|
fn InterpContext::op_lteq(self : InterpContext) -> Unit {
  let b = self.pop()
  let a = self.pop()
  self.push(if a <= b { 1L } else { 0L })
}

///|
fn InterpContext::op_gt(self : InterpContext) -> Unit {
  let b = self.pop()
  let a = self.pop()
  self.push(if a > b { 1L } else { 0L })
}

///|
fn InterpContext::op_gteq(self : InterpContext) -> Unit {
  let b = self.pop()
  let a = self.pop()
  self.push(if a >= b { 1L } else { 0L })
}

///|
fn InterpContext::op_eq(self : InterpContext) -> Unit {
  let b = self.pop()
  let a = self.pop()
  self.push(if a == b { 1L } else { 0L })
}

///|
fn InterpContext::op_neq(self : InterpContext) -> Unit {
  let b = self.pop()
  let a = self.pop()
  self.push(if a != b { 1L } else { 0L })
}

// --- Logical ---

///|
fn InterpContext::op_and(self : InterpContext) -> Unit {
  let b = self.pop()
  let a = self.pop()
  self.push(if a != 0L && b != 0L { 1L } else { 0L })
}

///|
fn InterpContext::op_or(self : InterpContext) -> Unit {
  let b = self.pop()
  let a = self.pop()
  self.push(if a != 0L || b != 0L { 1L } else { 0L })
}

///|
fn InterpContext::op_not(self : InterpContext) -> Unit {
  let a = self.pop()
  self.push(if a == 0L { 1L } else { 0L })
}

// --- Flow control ---

///|
fn InterpContext::op_if(self : InterpContext) -> Unit {
  let cond = self.pop()
  if cond == 0L {
    // Skip to matching ELSE or EIF
    self.skip_to_else_or_eif()
  }
}

///|
fn InterpContext::op_else(self : InterpContext) -> Unit {
  // If we reach ELSE during execution, the IF branch was taken,
  // so skip to EIF
  self.skip_to_eif()
}

///|
fn InterpContext::skip_to_else_or_eif(self : InterpContext) -> Unit {
  let mut depth = 1
  while self.ip < self.code.length() && depth > 0 {
    let op = self.code[self.ip].to_int()
    self.ip += 1
    match op {
      0x58 => depth += 1 // IF
      0x59 => depth -= 1 // EIF
      0x1B => if depth == 1 { return } // ELSE at our level
      // Skip inline data for push instructions
      0x40 => { // NPUSHB
        let n = self.code[self.ip].to_int()
        self.ip += 1 + n
      }
      0x41 => { // NPUSHW
        let n = self.code[self.ip].to_int()
        self.ip += 1 + n * 2
      }
      _ if op >= 0xB0 && op <= 0xB7 => self.ip += op - 0xB0 + 1
      _ if op >= 0xB8 && op <= 0xBF => self.ip += (op - 0xB8 + 1) * 2
      _ => ()
    }
  }
}

///|
fn InterpContext::skip_to_eif(self : InterpContext) -> Unit {
  let mut depth = 1
  while self.ip < self.code.length() && depth > 0 {
    let op = self.code[self.ip].to_int()
    self.ip += 1
    match op {
      0x58 => depth += 1 // IF
      0x59 => depth -= 1 // EIF
      0x40 => {
        let n = self.code[self.ip].to_int()
        self.ip += 1 + n
      }
      0x41 => {
        let n = self.code[self.ip].to_int()
        self.ip += 1 + n * 2
      }
      _ if op >= 0xB0 && op <= 0xB7 => self.ip += op - 0xB0 + 1
      _ if op >= 0xB8 && op <= 0xBF => self.ip += (op - 0xB8 + 1) * 2
      _ => ()
    }
  }
}

///|
fn InterpContext::op_jmpr(self : InterpContext) -> Unit {
  let offset = self.pop().to_int()
  self.ip += offset - 1 // -1 because ip already advanced past opcode
}

///|
fn InterpContext::op_jrot(self : InterpContext) -> Unit {
  let cond = self.pop()
  let offset = self.pop().to_int()
  if cond != 0L {
    self.ip += offset - 1
  }
}

///|
fn InterpContext::op_jrof(self : InterpContext) -> Unit {
  let cond = self.pop()
  let offset = self.pop().to_int()
  if cond == 0L {
    self.ip += offset - 1
  }
}

///|
fn InterpContext::op_fdef(self : InterpContext) -> Unit {
  let func_id = self.pop().to_int()
  let start = self.ip
  // Skip to ENDF
  while self.ip < self.code.length() {
    let op = self.code[self.ip].to_int()
    self.ip += 1
    if op == 0x2D {
      // ENDF
      self.func_defs[func_id] = { start, end_: self.ip - 1, code: self.code }
      return
    }
    // Skip push data
    match op {
      0x40 => {
        let n = self.code[self.ip].to_int()
        self.ip += 1 + n
      }
      0x41 => {
        let n = self.code[self.ip].to_int()
        self.ip += 1 + n * 2
      }
      _ if op >= 0xB0 && op <= 0xB7 => self.ip += op - 0xB0 + 1
      _ if op >= 0xB8 && op <= 0xBF => self.ip += (op - 0xB8 + 1) * 2
      _ => ()
    }
  }
}

///|
fn InterpContext::op_call(self : InterpContext) -> Unit {
  let func_id = self.pop().to_int()
  match self.func_defs.get(func_id) {
    Some(def) => {
      let saved_ip = self.ip
      let saved_code = self.code
      // Switch to the code array where this function was defined
      self.code = def.code
      self.ip = def.start
      while self.ip < def.end_ && !self.error {
        let op = self.code[self.ip].to_int()
        self.ip += 1
        self.exec_opcode(op)
      }
      self.ip = saved_ip
      self.code = saved_code
    }
    None => self.error = true
  }
}

///|
fn InterpContext::op_loopcall(self : InterpContext) -> Unit {
  let func_id = self.pop().to_int()
  let count = self.pop().to_int()
  for _ in 0..<count {
    self.push(func_id.to_int64())
    self.op_call()
    if self.error {
      return
    }
  }
}

// --- Push instructions ---

///|
fn InterpContext::op_npushb(self : InterpContext) -> Unit {
  let n = self.code[self.ip].to_int()
  self.ip += 1
  for _ in 0..<n {
    self.push(self.code[self.ip].to_int().to_int64())
    self.ip += 1
  }
}

///|
fn InterpContext::op_npushw(self : InterpContext) -> Unit {
  let n = self.code[self.ip].to_int()
  self.ip += 1
  for _ in 0..<n {
    let hi = self.code[self.ip].to_int()
    let lo = self.code[self.ip + 1].to_int()
    let val = (hi << 8) | lo
    let signed_val = if val >= 0x8000 { val - 0x10000 } else { val }
    self.push(signed_val.to_int64())
    self.ip += 2
  }
}

///|
fn InterpContext::op_pushb(self : InterpContext, count : Int) -> Unit {
  for _ in 0..<count {
    self.push(self.code[self.ip].to_int().to_int64())
    self.ip += 1
  }
}

///|
fn InterpContext::op_pushw(self : InterpContext, count : Int) -> Unit {
  for _ in 0..<count {
    let hi = self.code[self.ip].to_int()
    let lo = self.code[self.ip + 1].to_int()
    let val = (hi << 8) | lo
    let signed_val = if val >= 0x8000 { val - 0x10000 } else { val }
    self.push(signed_val.to_int64())
    self.ip += 2
  }
}

// --- Storage/CVT ---

///|
fn InterpContext::op_rs(self : InterpContext) -> Unit {
  let idx = self.pop().to_int()
  if idx >= 0 && idx < self.storage.length() {
    self.push(self.storage.unsafe_get(idx))
  } else {
    self.push(0L)
  }
}

///|
fn InterpContext::op_ws(self : InterpContext) -> Unit {
  let val = self.pop()
  let idx = self.pop().to_int()
  if idx >= 0 && idx < self.storage.length() {
    self.storage.unsafe_set(idx, val)
  }
}

///|
fn InterpContext::op_rcvt(self : InterpContext) -> Unit {
  let idx = self.pop().to_int()
  if idx >= 0 && idx < self.cvt.length() {
    self.push(self.cvt.unsafe_get(idx))
  } else {
    self.push(0L)
  }
}

///|
fn InterpContext::op_wcvtp(self : InterpContext) -> Unit {
  let val = self.pop()
  let idx = self.pop().to_int()
  if idx >= 0 && idx < self.cvt.length() {
    self.cvt.unsafe_set(idx, val)
  }
}

///|
fn InterpContext::op_wcvtf(self : InterpContext) -> Unit {
  let val = self.pop()
  let idx = self.pop().to_int()
  if idx >= 0 && idx < self.cvt.length() {
    self.cvt.unsafe_set(idx, self.scale_font_units(val))
  }
}

// --- Info ---

///|
fn InterpContext::op_getinfo(self : InterpContext) -> Unit {
  let selector = self.pop()
  let mut result = 0L
  // Bit 0: engine version
  if (selector & 1L) != 0L {
    result = result | 40L // version 40 (FreeType v2.x TT interpreter)
  }
  self.push(result)
}

///|
fn InterpContext::op_getvariation(self : InterpContext) -> Unit {
  let selector = self.pop()
  if selector != 0L {
    self.push(0L)
    return
  }
  for _, coord in self.var_coords {
    self.push(coord.to_int64())
  }
}

// --- Vector opcodes ---

///|
/// SPVTL[a] - Set projection vector to line between two points.
/// a=0: parallel to line, a=1: perpendicular to line.
fn InterpContext::op_spvtl(self : InterpContext, flag : Int) -> Unit {
  let p2_idx = self.pop().to_int()
  let p1_idx = self.pop().to_int()
  let (x1, y1) = self.get_zone_point(self.gs.zp2, p2_idx)
  let (x2, y2) = self.get_zone_point(self.gs.zp1, p1_idx)
  let mut dx = x1 - x2
  let mut dy = y1 - y2
  if flag == 1 {
    // Perpendicular: rotate 90 degrees
    let tmp = dx
    dx = -dy
    dy = tmp
  }
  let (nx, ny) = normalize_vector(dx, dy)
  self.gs.projection_vector_x = nx
  self.gs.projection_vector_y = ny
  self.gs.dual_projection_x = nx
  self.gs.dual_projection_y = ny
}

///|
/// SFVTL[a] - Set freedom vector to line between two points.
fn InterpContext::op_sfvtl(self : InterpContext, flag : Int) -> Unit {
  let p2_idx = self.pop().to_int()
  let p1_idx = self.pop().to_int()
  let (x1, y1) = self.get_zone_point(self.gs.zp2, p2_idx)
  let (x2, y2) = self.get_zone_point(self.gs.zp1, p1_idx)
  let mut dx = x1 - x2
  let mut dy = y1 - y2
  if flag == 1 {
    let tmp = dx
    dx = -dy
    dy = tmp
  }
  let (nx, ny) = normalize_vector(dx, dy)
  self.gs.freedom_vector_x = nx
  self.gs.freedom_vector_y = ny
}

// --- Measurement opcodes ---

///|
/// GC[a] - Get Coordinate projected along PV.
/// a=0: current position, a=1: original position.
fn InterpContext::op_gc(self : InterpContext, flag : Int) -> Unit {
  let point_idx = self.pop().to_int()
  if flag == 0 {
    let (x, y) = self.get_zone_point(self.gs.zp2, point_idx)
    self.push(self.project(x, y))
  } else {
    let (x, y) = self.get_zone_org(self.gs.zp2, point_idx)
    self.push(self.dual_project(x, y))
  }
}

///|
/// SCFS - Set Coordinate From Stack.
fn InterpContext::op_scfs(self : InterpContext) -> Unit {
  let value = self.pop()
  let point_idx = self.pop().to_int()
  let (x, y) = self.get_zone_point(self.gs.zp2, point_idx)
  let cur_proj = self.project(x, y)
  let delta = value - cur_proj
  self.move_point(self.gs.zp2, point_idx, delta)
}

///|
/// MD[a] - Measure Distance between two points.
/// a=0: measure in grid-fitted (current) outline, a=1: measure in original.
fn InterpContext::op_md(self : InterpContext, flag : Int) -> Unit {
  let p2_idx = self.pop().to_int()
  let p1_idx = self.pop().to_int()
  if flag == 0 {
    // Current outline
    let (x1, y1) = self.get_zone_point(self.gs.zp1, p1_idx)
    let (x2, y2) = self.get_zone_point(self.gs.zp0, p2_idx)
    let d = self.project(x1, y1) - self.project(x2, y2)
    self.push(d)
  } else {
    // Original outline
    let (x1, y1) = self.get_zone_org(self.gs.zp1, p1_idx)
    let (x2, y2) = self.get_zone_org(self.gs.zp0, p2_idx)
    let d = self.dual_project(x1, y1) - self.dual_project(x2, y2)
    self.push(d)
  }
}

// --- Point movement opcodes ---

///|
/// MDAP[a] - Move Direct Absolute Point.
/// Pop point number, optionally round, set rp0=rp1=point.
fn InterpContext::op_mdap(self : InterpContext, flag : Int) -> Unit {
  let point_idx = self.pop().to_int()
  if flag == 1 {
    // Round the point's coordinate
    let (x, y) = self.get_zone_point(self.gs.zp0, point_idx)
    let cur_dist = self.project(x, y)
    let rounded = self.round_value(cur_dist)
    let delta = rounded - cur_dist
    self.move_point(self.gs.zp0, point_idx, delta)
  } else {
    // Just mark as touched
    let touch = if self.gs.zp0 == 0 {
      self.zone0_tags
    } else {
      self.zone1_touch
    }
    if point_idx >= 0 && point_idx < touch.length() {
      let mut flags = touch[point_idx].to_int()
      if self.gs.freedom_vector_x != 0L {
        flags = flags | 0x01
      }
      if self.gs.freedom_vector_y != 0L {
        flags = flags | 0x02
      }
      touch[point_idx] = flags.to_byte()
    }
  }
  self.gs.rp0 = point_idx
  self.gs.rp1 = point_idx
}

///|
/// MIAP[a] - Move Indirect Absolute Point.
/// Pop CVT index + point, move point to CVT value.
fn InterpContext::op_miap(self : InterpContext, flag : Int) -> Unit {
  let cvt_idx = self.pop().to_int()
  let point_idx = self.pop().to_int()
  let cvt_dist = if cvt_idx >= 0 && cvt_idx < self.cvt.length() {
    self.cvt.unsafe_get(cvt_idx)
  } else {
    0L
  }
  let (x, y) = self.get_zone_point(self.gs.zp0, point_idx)
  let cur_dist = self.project(x, y)
  let new_dist = if flag == 1 {
    // Round the CVT value
    let (ox, oy) = self.get_zone_org(self.gs.zp0, point_idx)
    let org_dist = self.dual_project(ox, oy)
    // Apply cut-in test
    let diff = if cvt_dist - org_dist >= 0L {
      cvt_dist - org_dist
    } else {
      org_dist - cvt_dist
    }
    if diff > self.gs.control_value_cut_in {
      self.round_value(org_dist)
    } else {
      self.round_value(cvt_dist)
    }
  } else {
    cvt_dist
  }
  let delta = new_dist - cur_dist
  self.move_point(self.gs.zp0, point_idx, delta)
  self.gs.rp0 = point_idx
  self.gs.rp1 = point_idx
}

///|
/// IUP[a] - Interpolate Untouched Points.
/// a=0: interpolate y coordinates, a=1: interpolate x coordinates.
fn InterpContext::op_iup(self : InterpContext, flag : Int) -> Unit {
  let n_points = self.zone1_cur.length()
  if n_points == 0 {
    return
  }
  let touch_mask : Int = if flag == 1 { 0x01 } else { 0x02 } // x or y
  // Process each contour
  // For simplicity, treat all points as one contour if contour info not available
  // Find touched points and interpolate between them
  let start = 0
  // Find contour boundaries from zone1_tags (on-curve/off-curve flags)
  // For now, process all points as a single run
  let end = n_points
  // Collect indices of touched points in this contour
  let touched : Array[Int] = []
  for i in start..<end {
    if i < self.zone1_touch.length() {
      if (self.zone1_touch[i].to_int() & touch_mask) != 0 {
        touched.push(i)
      }
    }
  }
  if touched.length() == 0 {
    return
  }
  // Interpolate untouched points between consecutive touched points
  for ti = 0; ti < touched.length(); ti = ti + 1 {
    let t1 = touched[ti]
    let t2 = touched[(ti + 1) % touched.length()]
    // Interpolate points between t1 and t2
    let range_start = t1 + 1
    let range_end = if t2 > t1 { t2 } else { end }
    if flag == 1 {
      // Interpolate x
      let org1_x = if t1 < self.zone1_org.length() {
        self.zone1_org[t1].x()
      } else {
        0L
      }
      let cur1_x = self.zone1_cur[t1].x()
      let org2_x = if t2 < self.zone1_org.length() {
        self.zone1_org[t2].x()
      } else {
        0L
      }
      let cur2_x = self.zone1_cur[t2].x()
      for i in range_start..<range_end {
        if i < self.zone1_touch.length() &&
          (self.zone1_touch[i].to_int() & touch_mask) == 0 {
          let org_x = if i < self.zone1_org.length() {
            self.zone1_org[i].x()
          } else {
            0L
          }
          let new_x = interp_value(org_x, org1_x, org2_x, cur1_x, cur2_x)
          self.zone1_cur[i] = @types.Vector::new(new_x, self.zone1_cur[i].y())
        }
      }
    } else {
      // Interpolate y
      let org1_y = if t1 < self.zone1_org.length() {
        self.zone1_org[t1].y()
      } else {
        0L
      }
      let cur1_y = self.zone1_cur[t1].y()
      let org2_y = if t2 < self.zone1_org.length() {
        self.zone1_org[t2].y()
      } else {
        0L
      }
      let cur2_y = self.zone1_cur[t2].y()
      for i in range_start..<range_end {
        if i < self.zone1_touch.length() &&
          (self.zone1_touch[i].to_int() & touch_mask) == 0 {
          let org_y = if i < self.zone1_org.length() {
            self.zone1_org[i].y()
          } else {
            0L
          }
          let new_y = interp_value(org_y, org1_y, org2_y, cur1_y, cur2_y)
          self.zone1_cur[i] = @types.Vector::new(self.zone1_cur[i].x(), new_y)
        }
      }
    }
  }
  ignore(start)
}

///|
/// Interpolate a value between two reference points.
fn interp_value(
  org : Int64,
  org1 : Int64,
  org2 : Int64,
  cur1 : Int64,
  cur2 : Int64,
) -> Int64 {
  if org1 == org2 {
    // Reference points are at same position; shift by same delta
    return cur1 + (org - org1)
  }
  // Clamp to range
  let (lo_org, lo_cur, hi_org, hi_cur) = if org1 < org2 {
    (org1, cur1, org2, cur2)
  } else {
    (org2, cur2, org1, cur1)
  }
  if org <= lo_org {
    // Before first reference: shift
    lo_cur + (org - lo_org)
  } else if org >= hi_org {
    // After second reference: shift
    hi_cur + (org - hi_org)
  } else {
    // Between references: linear interpolation
    let range = hi_org - lo_org
    let offset = org - lo_org
    lo_cur + (hi_cur - lo_cur) * offset / range
  }
}

///|
/// SHP[a] - Shift Point using reference point.
/// a=0: use rp2 in zp1, a=1: use rp1 in zp0.
fn InterpContext::op_shp(self : InterpContext, flag : Int) -> Unit {
  // Get reference point delta
  let (rp_zone, rp_idx) = if flag == 0 {
    (self.gs.zp1, self.gs.rp2)
  } else {
    (self.gs.zp0, self.gs.rp1)
  }
  let (rx, ry) = self.get_zone_point(rp_zone, rp_idx)
  let (rox, roy) = self.get_zone_org(rp_zone, rp_idx)
  let delta = self.project(rx, ry) - self.project(rox, roy)
  let count = self.loop_count
  self.loop_count = 1
  for _ in 0..<count {
    let point_idx = self.pop().to_int()
    self.move_point(self.gs.zp2, point_idx, delta)
  }
}

///|
/// SHC[a] - Shift Contour.
fn InterpContext::op_shc(self : InterpContext, flag : Int) -> Unit {
  let contour = self.pop().to_int()
  // Get reference point delta
  let (rp_zone, rp_idx) = if flag == 0 {
    (self.gs.zp1, self.gs.rp2)
  } else {
    (self.gs.zp0, self.gs.rp1)
  }
  let (rx, ry) = self.get_zone_point(rp_zone, rp_idx)
  let (rox, roy) = self.get_zone_org(rp_zone, rp_idx)
  let delta = self.project(rx, ry) - self.project(rox, roy)
  if self.gs.zp2 == 1 && contour >= 0 && contour < self.zone1_contours.length() {
    let start = if contour == 0 {
      0
    } else {
      self.zone1_contours[contour - 1].reinterpret_as_int() + 1
    }
    let end_ = self.zone1_contours[contour].reinterpret_as_int()
    for i in start..<=end_ {
      self.move_point(self.gs.zp2, i, delta)
    }
  } else {
    let n = if self.gs.zp2 == 0 {
      self.zone0_cur.length()
    } else {
      self.zone1_cur.length()
    }
    for i in 0..<n {
      self.move_point(self.gs.zp2, i, delta)
    }
  }
}

///|
/// SHZ[a] - Shift Zone.
fn InterpContext::op_shz(self : InterpContext, flag : Int) -> Unit {
  let _zone = self.pop().to_int()
  let (rp_zone, rp_idx) = if flag == 0 {
    (self.gs.zp1, self.gs.rp2)
  } else {
    (self.gs.zp0, self.gs.rp1)
  }
  let (rx, ry) = self.get_zone_point(rp_zone, rp_idx)
  let (rox, roy) = self.get_zone_org(rp_zone, rp_idx)
  let delta = self.project(rx, ry) - self.project(rox, roy)
  let n = if self.gs.zp2 == 0 {
    self.zone0_cur.length()
  } else {
    self.zone1_cur.length()
  }
  for i in 0..<n {
    self.move_point(self.gs.zp2, i, delta)
  }
}

///|
/// SHPIX - Shift point by pixel amount.
fn InterpContext::op_shpix(self : InterpContext) -> Unit {
  let distance = self.pop()
  let count = self.loop_count
  self.loop_count = 1
  for _ in 0..<count {
    let point_idx = self.pop().to_int()
    self.move_point(self.gs.zp2, point_idx, distance)
  }
}

///|
/// IP - Interpolate Point.
fn InterpContext::op_ip(self : InterpContext) -> Unit {
  let count = self.loop_count
  self.loop_count = 1
  // Get rp1 and rp2 positions
  let (r1x, r1y) = self.get_zone_point(self.gs.zp0, self.gs.rp1)
  let (r2x, r2y) = self.get_zone_point(self.gs.zp1, self.gs.rp2)
  let (r1ox, r1oy) = self.get_zone_org(self.gs.zp0, self.gs.rp1)
  let (r2ox, r2oy) = self.get_zone_org(self.gs.zp1, self.gs.rp2)
  let cur_dist = self.project(r2x, r2y) - self.project(r1x, r1y)
  let org_dist = self.dual_project(r2ox, r2oy) - self.dual_project(r1ox, r1oy)
  for _ in 0..<count {
    let point_idx = self.pop().to_int()
    let (ox, oy) = self.get_zone_org(self.gs.zp2, point_idx)
    let org_offset = self.dual_project(ox, oy) - self.dual_project(r1ox, r1oy)
    let new_offset = if org_dist != 0L {
      org_offset * cur_dist / org_dist
    } else {
      0L
    }
    let (px, py) = self.get_zone_point(self.gs.zp2, point_idx)
    let cur_offset = self.project(px, py) - self.project(r1x, r1y)
    let delta = new_offset - cur_offset
    self.move_point(self.gs.zp2, point_idx, delta)
  }
}

///|
/// MSIRP[a] - Move Stack Indirect Relative Point.
fn InterpContext::op_msirp(self : InterpContext, flag : Int) -> Unit {
  let distance = self.pop()
  let point_idx = self.pop().to_int()
  let (rx, ry) = self.get_zone_point(self.gs.zp0, self.gs.rp0)
  let rp_proj = self.project(rx, ry)
  let (px, py) = self.get_zone_point(self.gs.zp1, point_idx)
  let p_proj = self.project(px, py)
  let target = rp_proj + distance
  let delta = target - p_proj
  self.move_point(self.gs.zp1, point_idx, delta)
  self.gs.rp1 = self.gs.rp0
  self.gs.rp2 = point_idx
  if flag == 1 {
    self.gs.rp0 = point_idx
  }
}

///|
/// ALIGNRP - Align to Reference Point.
fn InterpContext::op_alignrp(self : InterpContext) -> Unit {
  let count = self.loop_count
  self.loop_count = 1
  let (rx, ry) = self.get_zone_point(self.gs.zp0, self.gs.rp0)
  let rp_proj = self.project(rx, ry)
  for _ in 0..<count {
    let point_idx = self.pop().to_int()
    let (px, py) = self.get_zone_point(self.gs.zp1, point_idx)
    let p_proj = self.project(px, py)
    let delta = rp_proj - p_proj
    self.move_point(self.gs.zp1, point_idx, delta)
  }
}

///|
/// ALIGNPTS - Align Points.
fn InterpContext::op_alignpts(self : InterpContext) -> Unit {
  let p2_idx = self.pop().to_int()
  let p1_idx = self.pop().to_int()
  let (x1, y1) = self.get_zone_point(self.gs.zp0, p1_idx)
  let (x2, y2) = self.get_zone_point(self.gs.zp1, p2_idx)
  let d1 = self.project(x1, y1)
  let d2 = self.project(x2, y2)
  let mid = (d1 + d2) / 2L
  self.move_point(self.gs.zp0, p1_idx, mid - d1)
  self.move_point(self.gs.zp1, p2_idx, mid - d2)
}

///|
/// ISECT - Move point to intersection of two lines.
fn InterpContext::op_isect(self : InterpContext) -> Unit {
  let b1 = self.pop().to_int()
  let b0 = self.pop().to_int()
  let a1 = self.pop().to_int()
  let a0 = self.pop().to_int()
  let point_idx = self.pop().to_int()
  // Get line A endpoints
  let (ax0, ay0) = self.get_zone_point(self.gs.zp1, a0)
  let (ax1, ay1) = self.get_zone_point(self.gs.zp1, a1)
  // Get line B endpoints
  let (bx0, by0) = self.get_zone_point(self.gs.zp0, b0)
  let (bx1, by1) = self.get_zone_point(self.gs.zp0, b1)
  // Compute intersection
  let dax = ax1 - ax0
  let day = ay1 - ay0
  let dbx = bx1 - bx0
  let dby = by1 - by0
  let denom = dax * dby - day * dbx
  if denom == 0L {
    // Lines are parallel; move to midpoint of a0 and b0
    let mx = (ax0 + bx0) / 2L
    let my = (ay0 + by0) / 2L
    self.set_zone_point(self.gs.zp2, point_idx, mx, my)
  } else {
    let t_num = (bx0 - ax0) * dby - (by0 - ay0) * dbx
    let ix = ax0 + dax * t_num / denom
    let iy = ay0 + day * t_num / denom
    self.set_zone_point(self.gs.zp2, point_idx, ix, iy)
  }
  // Mark point as touched in both x and y
  let touch = if self.gs.zp2 == 0 { self.zone0_tags } else { self.zone1_touch }
  if point_idx >= 0 && point_idx < touch.length() {
    touch[point_idx] = (touch[point_idx].to_int() | 0x03).to_byte()
  }
}

///|
/// MDRP[flags] - Move Direct Relative Point.
/// Flags: bit0=round, bit1=min_distance, bits2-3=color, bit4=set_rp0.
fn InterpContext::op_mdrp(self : InterpContext, flags : Int) -> Unit {
  let point_idx = self.pop().to_int()
  // Measure original distance
  let (ox, oy) = self.get_zone_org(self.gs.zp1, point_idx)
  let (rox, roy) = self.get_zone_org(self.gs.zp0, self.gs.rp0)
  let mut dist = self.dual_project(ox, oy) - self.dual_project(rox, roy)
  // Round if flag bit 0
  if (flags & 0x04) != 0 {
    dist = self.round_value(dist)
  }
  // Enforce minimum distance if flag bit 1
  if (flags & 0x08) != 0 {
    let min_dist = self.gs.minimum_distance
    if dist >= 0L {
      if dist < min_dist {
        dist = min_dist
      }
    } else if dist > -min_dist {
      dist = -min_dist
    }
  }
  // Get current rp0 position
  let (rx, ry) = self.get_zone_point(self.gs.zp0, self.gs.rp0)
  let rp_proj = self.project(rx, ry)
  // Move point to rp0 + dist
  let (px, py) = self.get_zone_point(self.gs.zp1, point_idx)
  let p_proj = self.project(px, py)
  let target = rp_proj + dist
  let delta = target - p_proj
  self.move_point(self.gs.zp1, point_idx, delta)
  self.gs.rp1 = self.gs.rp0
  self.gs.rp2 = point_idx
  if (flags & 0x10) != 0 {
    self.gs.rp0 = point_idx
  }
}

///|
/// MIRP[flags] - Move Indirect Relative Point.
/// Like MDRP but uses CVT entry for distance.
fn InterpContext::op_mirp(self : InterpContext, flags : Int) -> Unit {
  let cvt_idx = self.pop().to_int()
  let point_idx = self.pop().to_int()
  let cvt_dist = if cvt_idx >= 0 && cvt_idx < self.cvt.length() {
    self.cvt.unsafe_get(cvt_idx)
  } else {
    0L
  }
  // Get original distance for auto-flip
  let (ox, oy) = self.get_zone_org(self.gs.zp1, point_idx)
  let (rox, roy) = self.get_zone_org(self.gs.zp0, self.gs.rp0)
  let org_dist = self.dual_project(ox, oy) - self.dual_project(rox, roy)
  let mut dist = cvt_dist
  // Auto-flip: if original distance is negative but CVT positive (or vice versa), flip
  if self.gs.auto_flip {
    if (org_dist >= 0L && dist < 0L) || (org_dist < 0L && dist >= 0L) {
      dist = -dist
    }
  }
  // Apply cut-in test
  let diff = if dist - org_dist >= 0L {
    dist - org_dist
  } else {
    org_dist - dist
  }
  if diff > self.gs.control_value_cut_in {
    dist = org_dist
  }
  // Round if flag bit 2 (distance color encoding offset)
  if (flags & 0x04) != 0 {
    dist = self.round_value(dist)
  }
  // Enforce minimum distance if flag bit 3
  if (flags & 0x08) != 0 {
    let min_dist = self.gs.minimum_distance
    if dist >= 0L {
      if dist < min_dist {
        dist = min_dist
      }
    } else if dist > -min_dist {
      dist = -min_dist
    }
  }
  // Get current rp0 position
  let (rx, ry) = self.get_zone_point(self.gs.zp0, self.gs.rp0)
  let rp_proj = self.project(rx, ry)
  // Move point
  let (px, py) = self.get_zone_point(self.gs.zp1, point_idx)
  let p_proj = self.project(px, py)
  let target = rp_proj + dist
  let delta = target - p_proj
  self.move_point(self.gs.zp1, point_idx, delta)
  self.gs.rp1 = self.gs.rp0
  self.gs.rp2 = point_idx
  if (flags & 0x10) != 0 {
    self.gs.rp0 = point_idx
  }
}

// --- Delta instructions ---

///|
/// DELTAP[n] - Delta exception for points.
fn InterpContext::op_deltap(self : InterpContext, selector : Int) -> Unit {
  let n = self.pop().to_int()
  let ppem_base = self.gs.delta_base + (selector - 1) * 16
  for _ in 0..<n {
    let arg = self.pop().to_int()
    let point_idx = self.pop().to_int()
    let ppem_offset = (arg >> 4) & 0x0F
    let ppem = ppem_base + ppem_offset
    // Check if current ppem matches
    if ppem == self.ppem {
      let magnitude = arg & 0x0F
      // magnitude 0-7: -(8-magnitude) steps, 8-15: +(magnitude-7) steps
      let step = if magnitude < 8 { -(8 - magnitude) } else { magnitude - 7 }
      let delta = step.to_int64() << 6 >> self.gs.delta_shift
      self.move_point(self.gs.zp0, point_idx, delta)
    }
  }
}

///|
/// DELTAC[n] - Delta exception for CVT values.
fn InterpContext::op_deltac(self : InterpContext, selector : Int) -> Unit {
  let n = self.pop().to_int()
  let ppem_base = self.gs.delta_base + (selector - 1) * 16
  for _ in 0..<n {
    let arg = self.pop().to_int()
    let cvt_idx = self.pop().to_int()
    let ppem_offset = (arg >> 4) & 0x0F
    let ppem = ppem_base + ppem_offset
    if ppem == self.ppem {
      let magnitude = arg & 0x0F
      let step = if magnitude < 8 { -(8 - magnitude) } else { magnitude - 7 }
      let delta = step.to_int64() << 6 >> self.gs.delta_shift
      if cvt_idx >= 0 && cvt_idx < self.cvt.length() {
        self.cvt.unsafe_set(cvt_idx, self.cvt.unsafe_get(cvt_idx) + delta)
      }
    }
  }
}

// --- FLIP instructions ---

///|
/// FLIPPT - Flip on-curve/off-curve flag for points.
fn InterpContext::op_flippt(self : InterpContext) -> Unit {
  let count = self.loop_count
  self.loop_count = 1
  for _ in 0..<count {
    let point_idx = self.pop().to_int()
    if point_idx >= 0 && point_idx < self.zone1_tags.length() {
      // Toggle bit 0 (on-curve flag)
      self.zone1_tags[point_idx] = (self.zone1_tags[point_idx].to_int() ^ 0x01).to_byte()
    }
  }
}

///|
/// FLIPRGON - Flip range of points to on-curve.
fn InterpContext::op_fliprgon(self : InterpContext) -> Unit {
  let high = self.pop().to_int()
  let low = self.pop().to_int()
  for i in low..<=high {
    if i >= 0 && i < self.zone1_tags.length() {
      self.zone1_tags[i] = (self.zone1_tags[i].to_int() | 0x01).to_byte()
    }
  }
}

///|
/// FLIPRGOFF - Flip range of points to off-curve.
fn InterpContext::op_fliprgoff(self : InterpContext) -> Unit {
  let high = self.pop().to_int()
  let low = self.pop().to_int()
  for i in low..<=high {
    if i >= 0 && i < self.zone1_tags.length() {
      self.zone1_tags[i] = (self.zone1_tags[i].to_int() & 0xFE).to_byte()
    }
  }
}

///|
pub fn InterpContext::cvt(self : InterpContext) -> Array[Int64] {
  self.cvt
}

///|
pub fn InterpContext::zone0_org(
  self : InterpContext,
) -> FixedArray[@types.Vector] {
  self.zone0_org
}

///|
pub fn InterpContext::zone0_cur(
  self : InterpContext,
) -> FixedArray[@types.Vector] {
  self.zone0_cur
}

///|
pub fn InterpContext::zone0_tags(self : InterpContext) -> FixedArray[Byte] {
  self.zone0_tags
}

///|
pub fn InterpContext::zone0_points(
  self : InterpContext,
) -> FixedArray[@types.Vector] {
  self.zone0_points
}

///|
pub fn InterpContext::zone1_org(
  self : InterpContext,
) -> FixedArray[@types.Vector] {
  self.zone1_org
}

///|
pub fn InterpContext::zone1_cur(
  self : InterpContext,
) -> FixedArray[@types.Vector] {
  self.zone1_cur
}

///|
pub fn InterpContext::zone1_points(
  self : InterpContext,
) -> FixedArray[@types.Vector] {
  self.zone1_points
}

///|
pub fn InterpContext::zone1_tags(self : InterpContext) -> FixedArray[Byte] {
  self.zone1_tags
}

///|
pub fn InterpContext::zone1_touch(self : InterpContext) -> FixedArray[Byte] {
  self.zone1_touch
}

///|
pub fn InterpContext::zone1_contours(self : InterpContext) -> FixedArray[UInt] {
  self.zone1_contours
}
