///|
/// Execute a Type 2 (CFF) charstring.
/// Returns the resulting outline and advance width.
pub fn execute_type2(
  charstring : Bytes,
  default_width : Int64,
  nominal_width : Int64,
  local_subrs? : Array[Bytes] = [],
  global_subrs? : Array[Bytes] = [],
) -> (@types.Outline, Int64, Array[StemHint], Array[StemHint]) raise @error.FTError {
  let interp = PsInterp::new()
  interp.local_subrs = local_subrs
  interp.global_subrs = global_subrs
  interp.width = default_width
  interp.nominal_width = nominal_width
  exec_type2_code(interp, charstring)
  let outline = interp.finalize()
  (outline, interp.width, interp.hints_h, interp.hints_v)
}

///|
/// Pop and return the oldest operand from the Type 2 stack.
fn pop_first_arg(interp : PsInterp) -> Int64 {
  if interp.stack.length() == 0 {
    return 0L
  }
  let first = interp.stack[0]
  let rest : Array[Int64] = []
  for i in 1..<interp.stack.length() {
    rest.push(interp.stack[i])
  }
  interp.stack = rest
  first
}

///|
/// Consume the optional Type 2 width operand from the first eligible operator.
/// When present, the charstring stores `width - nominalWidthX`.
fn consume_width(interp : PsInterp, has_width : Bool) -> Unit {
  if not(interp.width_set) {
    if has_width {
      interp.width = interp.nominal_width + pop_first_arg(interp)
    }
    interp.width_set = true
  }
}

///|
fn abs_i64(v : Int64) -> Int64 {
  if v < 0L {
    -v
  } else {
    v
  }
}

///|
fn integer_sqrt(v : Int64) -> Int64 {
  if v <= 0L {
    return 0L
  }
  let mut r = v
  let mut prev = 0L
  while r != prev {
    prev = r
    r = (r + v / r) >> 1
  }
  r
}

///|
fn roll_stack(interp : PsInterp, count : Int, shift : Int) -> Unit {
  if count <= 0 || count > interp.stack.length() {
    return
  }
  let mut amount = shift % count
  if amount < 0 {
    amount += count
  }
  if amount == 0 {
    return
  }
  let base = interp.stack.length() - count
  let segment : Array[Int64] = []
  for i in 0..<count {
    segment.push(interp.stack[base + i])
  }
  for i in 0..<count {
    interp.stack[base + (i + amount) % count] = segment[i]
  }
}

///|
fn do_flex(
  interp : PsInterp,
  read_from_stack : Array[Bool],
  conditional_last : Bool,
) -> Unit {
  let vals = Array::make(14, 0L)
  vals[0] = interp.current_x
  vals[1] = interp.current_y
  let mut idx = 0
  let is_hflex = not(read_from_stack[9])
  let top = if is_hflex { 9 } else { 10 }
  for i in 0..<top {
    vals[i + 2] = vals[i]
    if read_from_stack[i] && idx < interp.stack.length() {
      vals[i + 2] = vals[i + 2] + interp.stack[idx]
      idx += 1
    }
  }
  if is_hflex {
    vals[11] = interp.current_y
  }
  if conditional_last {
    let last_val = if idx < interp.stack.length() {
      interp.stack[idx]
    } else {
      0L
    }
    let last_is_x = abs_i64(vals[10] - interp.current_x) >
      abs_i64(vals[11] - interp.current_y)
    if last_is_x {
      vals[12] = vals[10] + last_val
      vals[13] = interp.current_y
    } else {
      vals[12] = interp.current_x
      vals[13] = vals[11] + last_val
    }
  } else {
    vals[12] = if read_from_stack[10] && idx < interp.stack.length() {
      let out = vals[10] + interp.stack[idx]
      idx += 1
      out
    } else {
      interp.current_x
    }
    vals[13] = if read_from_stack[11] && idx < interp.stack.length() {
      vals[11] + interp.stack[idx]
    } else {
      interp.current_y
    }
  }
  for j in 0..<2 {
    interp.curve_to(
      vals[j * 6 + 2],
      vals[j * 6 + 3],
      vals[j * 6 + 4],
      vals[j * 6 + 5],
      vals[j * 6 + 6],
      vals[j * 6 + 7],
    )
  }
  interp.stack = []
}

///|
/// Execute Type 2 charstring bytecode.
fn exec_type2_code(
  interp : PsInterp,
  code : Bytes,
) -> Unit raise @error.FTError {
  let len = code.length()
  for ip = 0; ip < len; {
    let b0 = code[ip].to_int()
    let mut next_ip = ip + 1
    match b0 {
      n if n >= 0 && n <= 11 =>
        // Operator
        next_ip = exec_type2_op(interp, code, next_ip, b0)
      12 => {
        // Two-byte operator
        if next_ip >= len {
          raise @error.FTError::SyntaxError
        }
        let b1 = code[next_ip].to_int()
        next_ip += 1
        next_ip = exec_type2_op2(interp, code, next_ip, b1)
      }
      n if n >= 13 && n <= 18 =>
        next_ip = exec_type2_op(interp, code, next_ip, b0)
      19 | 20 => {
        // hintmask / cntrmask: consume (num_hints + 7) / 8 bytes
        consume_width(interp, interp.stack.length() % 2 == 1)
        let num_hints = interp.hints_h.length() + interp.hints_v.length()
        // First, consume any remaining stem hints on stack
        let pairs_on_stack = interp.stack.length() / 2
        for _ in 0..<pairs_on_stack {
          ignore(interp.pop())
          ignore(interp.pop())
        }
        let mask_bytes = (num_hints + 7) / 8
        next_ip += mask_bytes
      }
      28 => {
        // 16-bit signed integer
        if next_ip + 1 >= len {
          raise @error.FTError::SyntaxError
        }
        let hi = code[next_ip].to_int()
        let lo = code[next_ip + 1].to_int()
        let val = (hi << 8) | lo
        let signed_val = if val >= 0x8000 { val - 0x10000 } else { val }
        interp.push(signed_val.to_int64())
        next_ip += 2
      }
      n if n >= 21 && n <= 31 =>
        next_ip = exec_type2_op(interp, code, next_ip, b0)
      n if n >= 32 && n <= 246 => interp.push((b0 - 139).to_int64())
      n if n >= 247 && n <= 250 => {
        if next_ip >= len {
          raise @error.FTError::SyntaxError
        }
        let b1 = code[next_ip].to_int()
        next_ip += 1
        interp.push(((b0 - 247) * 256 + b1 + 108).to_int64())
      }
      n if n >= 251 && n <= 254 => {
        if next_ip >= len {
          raise @error.FTError::SyntaxError
        }
        let b1 = code[next_ip].to_int()
        next_ip += 1
        interp.push((-((b0 - 251) * 256 + b1 + 108)).to_int64())
      }
      255 => {
        // 32-bit fixed point (16.16)
        if next_ip + 3 >= len {
          raise @error.FTError::SyntaxError
        }
        let val = (code[next_ip].to_int() << 24) |
          (code[next_ip + 1].to_int() << 16) |
          (code[next_ip + 2].to_int() << 8) |
          code[next_ip + 3].to_int()
        let signed_val = if val >= 0x80000000 {
          val.to_int64() - 0x100000000L
        } else {
          val.to_int64()
        }
        // CFF operands use 16.16 fixed-point here; the interpreter keeps
        // integer design units, so drop the fractional bits.
        interp.push(signed_val >> 16)
        next_ip += 4
      }
      _ => ()
    }
    continue next_ip
  }
}

///|
/// Execute a one-byte Type 2 operator.
fn exec_type2_op(
  interp : PsInterp,
  code : Bytes,
  ip : Int,
  op : Int,
) -> Int raise @error.FTError {
  ignore(code)
  match op {
    1 | 3 => {
      // hstem (1) / vstem (3)
      consume_width(interp, interp.stack.length() % 2 == 1)
      let pairs = interp.stack.length() / 2
      let hints = if op == 1 { interp.hints_h } else { interp.hints_v }
      let mut pos = 0L
      for i in 0..<pairs {
        let d1 = interp.stack[i * 2]
        let d2 = interp.stack[i * 2 + 1]
        pos += d1
        hints.push({ position: pos, width: d2 })
        pos += d2
      }
      interp.stack = []
      ip
    }
    4 => {
      // vmoveto
      consume_width(
        interp,
        interp.stack.length() > 0 && interp.stack.length() % 2 == 0,
      )
      let dy = interp.pop()
      interp.move_to(interp.current_x, interp.current_y + dy)
      ip
    }
    5 => {
      // rlineto
      for i = 0; i + 1 < interp.stack.length(); {
        let dx = interp.stack[i]
        let dy = interp.stack[i + 1]
        interp.line_to(interp.current_x + dx, interp.current_y + dy)
        continue i + 2
      }
      interp.stack = []
      ip
    }
    6 => {
      // hlineto: alternating horizontal/vertical lines starting with horizontal
      let sp = interp.stack.length()
      let mut horizontal = true
      for i in 0..<sp {
        let d = interp.stack[i]
        if horizontal {
          interp.line_to(interp.current_x + d, interp.current_y)
        } else {
          interp.line_to(interp.current_x, interp.current_y + d)
        }
        horizontal = not(horizontal)
      }
      interp.stack = []
      ip
    }
    7 => {
      // vlineto: alternating vertical/horizontal lines starting with vertical
      let sp = interp.stack.length()
      let mut horizontal = false
      for i in 0..<sp {
        let d = interp.stack[i]
        if horizontal {
          interp.line_to(interp.current_x + d, interp.current_y)
        } else {
          interp.line_to(interp.current_x, interp.current_y + d)
        }
        horizontal = not(horizontal)
      }
      interp.stack = []
      ip
    }
    8 => {
      // rrcurveto: dx1 dy1 dx2 dy2 dx3 dy3 {dxa dya dxb dyb dxc dyc}*
      for i = 0; i + 5 < interp.stack.length(); {
        let x1 = interp.current_x + interp.stack[i]
        let y1 = interp.current_y + interp.stack[i + 1]
        let x2 = x1 + interp.stack[i + 2]
        let y2 = y1 + interp.stack[i + 3]
        let x3 = x2 + interp.stack[i + 4]
        let y3 = y2 + interp.stack[i + 5]
        interp.curve_to(x1, y1, x2, y2, x3, y3)
        continue i + 6
      }
      interp.stack = []
      ip
    }
    10 => {
      // callsubr
      let subr_idx = interp.pop().to_int()
      let bias = calc_subr_bias(interp.local_subrs.length())
      let actual_idx = subr_idx + bias
      if actual_idx >= 0 && actual_idx < interp.local_subrs.length() {
        interp.call_stack.push({ code, ip })
        exec_type2_code(interp, interp.local_subrs[actual_idx])
        match interp.call_stack.pop() {
          Some(_) => ()
          None => ()
        }
      }
      ip
    }
    11 => ip // return from subroutine (handled by caller)
    14 => {
      // endchar
      consume_width(
        interp,
        interp.stack.length() == 1 || interp.stack.length() == 5,
      )
      ip + code.length() // stop execution
    }
    18 => {
      // hstemhm (same as hstem but for hint masks)
      consume_width(interp, interp.stack.length() % 2 == 1)
      let pairs = interp.stack.length() / 2
      let mut pos = 0L
      for i in 0..<pairs {
        let d1 = interp.stack[i * 2]
        let d2 = interp.stack[i * 2 + 1]
        pos += d1
        interp.hints_h.push({ position: pos, width: d2 })
        pos += d2
      }
      interp.stack = []
      ip
    }
    21 => {
      // rmoveto
      consume_width(interp, interp.stack.length() % 2 == 1)
      let dy = interp.pop()
      let dx = interp.pop()
      interp.move_to(interp.current_x + dx, interp.current_y + dy)
      ip
    }
    22 => {
      // hmoveto
      consume_width(
        interp,
        interp.stack.length() > 0 && interp.stack.length() % 2 == 0,
      )
      let dx = interp.pop()
      interp.move_to(interp.current_x + dx, interp.current_y)
      ip
    }
    23 => {
      // vstemhm (same as vstem but for hint masks)
      consume_width(interp, interp.stack.length() % 2 == 1)
      let pairs = interp.stack.length() / 2
      let mut pos = 0L
      for i in 0..<pairs {
        let d1 = interp.stack[i * 2]
        let d2 = interp.stack[i * 2 + 1]
        pos += d1
        interp.hints_v.push({ position: pos, width: d2 })
        pos += d2
      }
      interp.stack = []
      ip
    }
    24 => {
      // rcurveline: curves then line
      let sp = interp.stack.length()
      for i = 0; i + 7 < sp; {
        let x1 = interp.current_x + interp.stack[i]
        let y1 = interp.current_y + interp.stack[i + 1]
        let x2 = x1 + interp.stack[i + 2]
        let y2 = y1 + interp.stack[i + 3]
        let x3 = x2 + interp.stack[i + 4]
        let y3 = y2 + interp.stack[i + 5]
        interp.curve_to(x1, y1, x2, y2, x3, y3)
        continue i + 6
      }
      if sp >= 2 {
        let dx = interp.stack[sp - 2]
        let dy = interp.stack[sp - 1]
        interp.line_to(interp.current_x + dx, interp.current_y + dy)
      }
      interp.stack = []
      ip
    }
    25 => {
      // rlinecurve: lines then curve
      let sp = interp.stack.length()
      let curve_start = sp - 6
      for i = 0; i + 7 < sp; {
        let dx = interp.stack[i]
        let dy = interp.stack[i + 1]
        interp.line_to(interp.current_x + dx, interp.current_y + dy)
        continue i + 2
      }
      if sp >= 6 {
        let x1 = interp.current_x + interp.stack[curve_start]
        let y1 = interp.current_y + interp.stack[curve_start + 1]
        let x2 = x1 + interp.stack[curve_start + 2]
        let y2 = y1 + interp.stack[curve_start + 3]
        let x3 = x2 + interp.stack[curve_start + 4]
        let y3 = y2 + interp.stack[curve_start + 5]
        interp.curve_to(x1, y1, x2, y2, x3, y3)
      }
      interp.stack = []
      ip
    }
    29 => {
      // callgsubr
      let subr_idx = interp.pop().to_int()
      let bias = calc_subr_bias(interp.global_subrs.length())
      let actual_idx = subr_idx + bias
      if actual_idx >= 0 && actual_idx < interp.global_subrs.length() {
        interp.call_stack.push({ code, ip })
        exec_type2_code(interp, interp.global_subrs[actual_idx])
        match interp.call_stack.pop() {
          Some(_) => ()
          None => ()
        }
      }
      ip
    }
    30 => {
      // vhcurveto
      op_vhcurveto(interp)
      ip
    }
    31 => {
      // hvcurveto
      op_hvcurveto(interp)
      ip
    }
    _ => ip // unknown operator
  }
}

///|
/// Execute a two-byte (12 xx) Type 2 operator.
fn exec_type2_op2(interp : PsInterp, code : Bytes, ip : Int, op : Int) -> Int {
  ignore(code)
  match op {
    0 => ip // dotsection (deprecated, no-op)
    3 => {
      let b = interp.pop()
      let a = interp.pop()
      interp.push(if a != 0L && b != 0L { 1L } else { 0L })
      ip
    }
    4 => {
      let b = interp.pop()
      let a = interp.pop()
      interp.push(if a != 0L || b != 0L { 1L } else { 0L })
      ip
    }
    5 => {
      let a = interp.pop()
      interp.push(if a == 0L { 1L } else { 0L })
      ip
    }
    9 => {
      interp.push(abs_i64(interp.pop()))
      ip
    }
    10 => {
      let b = interp.pop()
      let a = interp.pop()
      interp.push(a + b)
      ip
    }
    11 => {
      let b = interp.pop()
      let a = interp.pop()
      interp.push(a - b)
      ip
    }
    12 => {
      let b = interp.pop()
      let a = interp.pop()
      interp.push(if b != 0L { a / b } else { 0L })
      ip
    }
    14 => {
      interp.push(-interp.pop())
      ip
    }
    15 => {
      let b = interp.pop()
      let a = interp.pop()
      interp.push(if a == b { 1L } else { 0L })
      ip
    }
    18 => {
      ignore(interp.pop())
      ip
    }
    20 => {
      let idx = interp.pop().to_int()
      let val = interp.pop()
      if idx >= 0 && idx < interp.transient.length() {
        interp.transient[idx] = val
      }
      ip
    }
    21 => {
      let idx = interp.pop().to_int()
      if idx >= 0 && idx < interp.transient.length() {
        interp.push(interp.transient[idx])
      }
      ip
    }
    22 => {
      let cond2 = interp.pop()
      let cond1 = interp.pop()
      let arg2 = interp.pop()
      let arg1 = interp.pop()
      interp.push(if cond1 <= cond2 { arg1 } else { arg2 })
      ip
    }
    23 => {
      // The interpreter stores integer design units instead of full 16.16
      // reals, so use a deterministic non-zero placeholder for `random`.
      interp.push(1L)
      ip
    }
    24 => {
      let b = interp.pop()
      let a = interp.pop()
      interp.push(a * b)
      ip
    }
    26 => {
      interp.push(integer_sqrt(interp.pop()))
      ip
    }
    27 => {
      let a = interp.pop()
      interp.push(a)
      interp.push(a)
      ip
    }
    28 => {
      let b = interp.pop()
      let a = interp.pop()
      interp.push(b)
      interp.push(a)
      ip
    }
    29 => {
      let idx = interp.pop().to_int()
      let size = interp.stack.length()
      if size > 0 {
        let actual_idx = if idx < 0 {
          size - 1
        } else if idx >= size {
          0
        } else {
          size - 1 - idx
        }
        interp.push(interp.stack[actual_idx])
      }
      ip
    }
    30 => {
      let shift = interp.pop().to_int()
      let count = interp.pop().to_int()
      roll_stack(interp, count, shift)
      ip
    }
    34 => {
      // hflex
      do_flex(
        interp,
        [
          true, false, true, true, true, false, true, false, true, false, true, false,
        ],
        false,
      )
      ip
    }
    35 => {
      do_flex(interp, Array::make(12, true), false)
      ip
    }
    36 => {
      do_flex(
        interp,
        [
          true, true, true, true, true, false, true, false, true, true, true, false,
        ],
        false,
      )
      ip
    }
    37 => {
      do_flex(
        interp,
        [
          true, true, true, true, true, true, true, true, true, true, false, false,
        ],
        true,
      )
      ip
    }
    _ => {
      interp.stack = []
      ip
    }
  }
}

///|
/// vhcurveto: alternating vertical/horizontal tangent curves.
fn op_vhcurveto(interp : PsInterp) -> Unit {
  let sp = interp.stack.length()
  for i = 0, phase = 0; i + 3 < sp; {
    if phase == 0 {
      // Vertical start: dy1 dx2 dy2 dx3 [dy3]
      let dy1 = interp.stack[i]
      let dx2 = interp.stack[i + 1]
      let dy2 = interp.stack[i + 2]
      let dx3 = interp.stack[i + 3]
      let x1 = interp.current_x
      let y1 = interp.current_y + dy1
      let x2 = x1 + dx2
      let y2 = y1 + dy2
      let x3 = x2 + dx3
      let dy3 = if i + 4 == sp - 1 { interp.stack[i + 4] } else { 0L }
      let y3 = y2 + dy3
      interp.curve_to(x1, y1, x2, y2, x3, y3)
      let step = if dy3 != 0L { 5 } else { 4 }
      continue i + step, 1 - phase
    } else {
      // Horizontal start: dx1 dx2 dy2 dy3 [dx3]
      let dx1 = interp.stack[i]
      let dx2 = interp.stack[i + 1]
      let dy2 = interp.stack[i + 2]
      let dy3 = interp.stack[i + 3]
      let x1 = interp.current_x + dx1
      let y1 = interp.current_y
      let x2 = x1 + dx2
      let y2 = y1 + dy2
      let dx3 = if i + 4 == sp - 1 { interp.stack[i + 4] } else { 0L }
      let x3 = x2 + dx3
      let y3 = y2 + dy3
      interp.curve_to(x1, y1, x2, y2, x3, y3)
      let step = if dx3 != 0L { 5 } else { 4 }
      continue i + step, 1 - phase
    }
  }
  interp.stack = []
}

///|
/// hvcurveto: alternating horizontal/vertical tangent curves.
fn op_hvcurveto(interp : PsInterp) -> Unit {
  let sp = interp.stack.length()
  for i = 0, phase = 1; i + 3 < sp; {
    if phase == 1 {
      let dx1 = interp.stack[i]
      let dx2 = interp.stack[i + 1]
      let dy2 = interp.stack[i + 2]
      let dy3 = interp.stack[i + 3]
      let x1 = interp.current_x + dx1
      let y1 = interp.current_y
      let x2 = x1 + dx2
      let y2 = y1 + dy2
      let dx3 = if i + 4 == sp - 1 { interp.stack[i + 4] } else { 0L }
      let x3 = x2 + dx3
      let y3 = y2 + dy3
      interp.curve_to(x1, y1, x2, y2, x3, y3)
      let step = if dx3 != 0L { 5 } else { 4 }
      continue i + step, 1 - phase
    } else {
      let dy1 = interp.stack[i]
      let dx2 = interp.stack[i + 1]
      let dy2 = interp.stack[i + 2]
      let dx3 = interp.stack[i + 3]
      let x1 = interp.current_x
      let y1 = interp.current_y + dy1
      let x2 = x1 + dx2
      let y2 = y1 + dy2
      let x3 = x2 + dx3
      let dy3 = if i + 4 == sp - 1 { interp.stack[i + 4] } else { 0L }
      let y3 = y2 + dy3
      interp.curve_to(x1, y1, x2, y2, x3, y3)
      let step = if dy3 != 0L { 5 } else { 4 }
      continue i + step, 1 - phase
    }
  }
  interp.stack = []
}

///|
/// Calculate subroutine bias based on the number of subroutines.
/// CFF spec: bias = 107 if count < 1240, 1131 if count < 33900, else 32768.
pub fn calc_subr_bias(count : Int) -> Int {
  if count < 1240 {
    107
  } else if count < 33900 {
    1131
  } else {
    32768
  }
}
