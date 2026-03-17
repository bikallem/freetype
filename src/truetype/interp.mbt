///|
/// TrueType bytecode interpreter execution context.
pub(all) struct InterpContext {
  // Operand stack
  mut stack : Array[Int64]
  mut sp : Int // stack pointer (index of next push position)
  // Code
  mut code : Bytes
  mut ip : Int // instruction pointer
  // Control Value Table
  mut cvt : Array[Int64] // 26.6 values
  // Storage area
  mut storage : Array[Int64]
  // Graphics state
  mut gs : GraphicsState
  // Function definitions
  mut func_defs : Map[Int, FuncDef]
  // Loop counter
  mut loop_count : Int
  // Points (zone 1 = glyph, zone 0 = twilight)
  mut zone0_points : Array[@types.Vector]
  mut zone1_points : Array[@types.Vector]
  mut zone1_tags : Array[Byte]
  // Error state
  mut error : Bool
} derive(Show)

///|
/// Graphics state for the TrueType interpreter.
pub(all) struct GraphicsState {
  mut rp0 : Int
  mut rp1 : Int
  mut rp2 : Int
  mut freedom_vector_x : Int64 // 2.14 as Int64
  mut freedom_vector_y : Int64
  mut projection_vector_x : Int64
  mut projection_vector_y : Int64
  mut dual_projection_x : Int64
  mut dual_projection_y : Int64
  mut round_state : Int // 0=off, 1=to_grid, etc.
  mut minimum_distance : Int64 // 26.6
  mut control_value_cut_in : Int64 // 26.6
  mut single_width_cut_in : Int64 // 26.6
  mut single_width_value : Int64 // 26.6
  mut auto_flip : Bool
  mut delta_base : Int
  mut delta_shift : Int
  mut instruct_control : Int
  mut scan_control : Bool
  mut scan_type : Int
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
pub(all) struct FuncDef {
  start : Int // start offset in code
  end_ : Int // end offset (ENDF position)
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
    storage: Array::make(storage_size, 0L),
    gs: GraphicsState::default(),
    func_defs: {},
    loop_count: 1,
    zone0_points: [],
    zone1_points: [],
    zone1_tags: [],
    error: false,
  }
}

///|
fn InterpContext::push(self : InterpContext, val : Int64) -> Unit {
  if self.sp < self.stack.length() {
    self.stack[self.sp] = val
    self.sp += 1
  } else {
    self.error = true
  }
}

///|
fn InterpContext::pop(self : InterpContext) -> Int64 {
  if self.sp > 0 {
    self.sp -= 1
    self.stack[self.sp]
  } else {
    self.error = true
    0L
  }
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
  while self.ip < len && not(self.error) {
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
    0x18 => () // RTG (round to grid - default)
    0x19 => self.gs.round_state = 0 // RTHG (round to half grid)
    0x1A => self.gs.minimum_distance = self.pop() // SMD
    0x4D => () // FLIPON
    0x4E => () // FLIPOFF
    0x76 => self.gs.round_state = 1 // SROUND
    0x7C => self.gs.round_state = 0 // RUTG
    0x7D => self.gs.round_state = 1 // RDTG
    0x4F => () // DEBUG (no-op)
    0x88 => self.op_getinfo() // GETINFO
    0x91 => self.op_getvariation() // GETVARIATION
    0x22 => () // Already handled: CLEAR
    // --- Measurement ---
    0x4B => self.push(64L) // MPPEM (stub: return 64 = 1 pixel ppem)
    0x4C => self.push(64L) // MPS (stub)
    // --- Misc ---
    _ => () // Unimplemented opcodes are no-ops for now
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
  // 26.6 × 26.6 → 26.6 (divide by 64)
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
  () // No rounding, just leave value
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
      self.func_defs[func_id] = { start, end_: self.ip - 1 }
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
      self.ip = def.start
      while self.ip < def.end_ && not(self.error) {
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
    self.push(self.storage[idx])
  } else {
    self.push(0L)
  }
}

///|
fn InterpContext::op_ws(self : InterpContext) -> Unit {
  let val = self.pop()
  let idx = self.pop().to_int()
  if idx >= 0 && idx < self.storage.length() {
    self.storage[idx] = val
  }
}

///|
fn InterpContext::op_rcvt(self : InterpContext) -> Unit {
  let idx = self.pop().to_int()
  if idx >= 0 && idx < self.cvt.length() {
    self.push(self.cvt[idx])
  } else {
    self.push(0L)
  }
}

///|
fn InterpContext::op_wcvtp(self : InterpContext) -> Unit {
  let val = self.pop()
  let idx = self.pop().to_int()
  if idx >= 0 && idx < self.cvt.length() {
    self.cvt[idx] = val
  }
}

///|
fn InterpContext::op_wcvtf(self : InterpContext) -> Unit {
  let val = self.pop()
  let idx = self.pop().to_int()
  if idx >= 0 && idx < self.cvt.length() {
    // Convert from font units to 26.6 (simplified: assume 1:1 for now)
    self.cvt[idx] = val
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
  // Stub: push 0 (no variation)
  self.push(0L)
}
