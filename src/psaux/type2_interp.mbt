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
        // CFF spec: this is a 16.16 fixed-point value
        // For outline coords, we convert to integer by >> 16
        interp.push(val.to_int64())
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
    34 => {
      // hflex
      if interp.stack.length() >= 7 {
        let dx1 = interp.stack[0]
        let dx2 = interp.stack[1]
        let dy2 = interp.stack[2]
        let dx3 = interp.stack[3]
        let dx4 = interp.stack[4]
        let dx5 = interp.stack[5]
        let dx6 = interp.stack[6]
        let x1 = interp.current_x + dx1
        let y1 = interp.current_y
        let x2 = x1 + dx2
        let y2 = y1 + dy2
        let x3 = x2 + dx3
        let y3 = y2
        interp.curve_to(x1, y1, x2, y2, x3, y3)
        let x4 = x3 + dx4
        let y4 = y3
        let x5 = x4 + dx5
        let y5 = y4 - dy2
        let x6 = x5 + dx6
        let y6 = interp.current_y
        interp.curve_to(x4, y4, x5, y5, x6, y6)
      }
      interp.stack = []
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
