///|
/// Execute a Type 2 (CFF) charstring.
/// Returns the resulting outline and advance width.
pub fn execute_type2(
  charstring : Bytes,
  default_width : Int64,
  nominal_width : Int64,
  local_subrs? : Array[Bytes] = [],
  global_subrs? : Array[Bytes] = [],
) -> (@types.Outline, Int64) raise @error.FTError {
  let interp = PsInterp::new()
  interp.local_subrs = local_subrs
  interp.global_subrs = global_subrs
  interp.width = default_width
  exec_type2_code(interp, charstring)
  let outline = interp.finalize()
  (outline, interp.width)
}

///|
/// Execute Type 2 charstring bytecode.
fn exec_type2_code(
  interp : PsInterp,
  code : Bytes,
) -> Unit raise @error.FTError {
  let len = code.length()
  let mut ip = 0
  while ip < len {
    let b0 = code[ip].to_int()
    ip += 1
    if b0 >= 0 && b0 <= 11 {
      // Operator
      ip = exec_type2_op(interp, code, ip, b0)
    } else if b0 == 12 {
      // Two-byte operator
      if ip >= len {
        raise @error.FTError::SyntaxError
      }
      let b1 = code[ip].to_int()
      ip += 1
      ip = exec_type2_op2(interp, code, ip, b1)
    } else if b0 >= 13 && b0 <= 18 {
      ip = exec_type2_op(interp, code, ip, b0)
    } else if b0 == 19 || b0 == 20 {
      // hintmask / cntrmask: consume (num_hints + 7) / 8 bytes
      check_width(interp)
      let num_hints = interp.hints_h.length() + interp.hints_v.length()
      // First, consume any remaining stem hints on stack
      let pairs_on_stack = interp.sp / 2
      for i = 0; i < pairs_on_stack; i = i + 1 {
        ignore(interp.pop())
        ignore(interp.pop())
      }
      let mask_bytes = (num_hints + 7) / 8
      ip += mask_bytes
    } else if b0 >= 21 && b0 <= 31 {
      ip = exec_type2_op(interp, code, ip, b0)
    } else if b0 == 28 {
      // 16-bit signed integer
      if ip + 1 >= len {
        raise @error.FTError::SyntaxError
      }
      let hi = code[ip].to_int()
      let lo = code[ip + 1].to_int()
      let val = (hi << 8) | lo
      let signed_val = if val >= 0x8000 { val - 0x10000 } else { val }
      interp.push(signed_val.to_int64())
      ip += 2
    } else if b0 >= 32 && b0 <= 246 {
      interp.push((b0 - 139).to_int64())
    } else if b0 >= 247 && b0 <= 250 {
      if ip >= len {
        raise @error.FTError::SyntaxError
      }
      let b1 = code[ip].to_int()
      ip += 1
      interp.push(((b0 - 247) * 256 + b1 + 108).to_int64())
    } else if b0 >= 251 && b0 <= 254 {
      if ip >= len {
        raise @error.FTError::SyntaxError
      }
      let b1 = code[ip].to_int()
      ip += 1
      interp.push((-((b0 - 251) * 256 + b1 + 108)).to_int64())
    } else if b0 == 255 {
      // 32-bit fixed point (16.16)
      if ip + 3 >= len {
        raise @error.FTError::SyntaxError
      }
      let val = (code[ip].to_int() << 24) |
        (code[ip + 1].to_int() << 16) |
        (code[ip + 2].to_int() << 8) |
        code[ip + 3].to_int()
      // CFF spec: this is a 16.16 fixed-point value
      // For outline coords, we convert to integer by >> 16
      interp.push(val.to_int64())
      ip += 4
    }
  }
}

///|
/// Check if width needs to be set from stack operand.
fn check_width(interp : PsInterp) -> Unit {
  if not(interp.width_set) {
    interp.width_set = true
    // Width is first operand if stack has odd number of args before first path op
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
      check_width(interp)
      let pairs = interp.sp / 2
      let hints = if op == 1 { interp.hints_h } else { interp.hints_v }
      let mut pos = 0L
      for i = 0; i < pairs; i = i + 1 {
        let d1 = interp.stack[i * 2]
        let d2 = interp.stack[i * 2 + 1]
        pos += d1
        hints.push({ position: pos, width: d2 })
        pos += d2
      }
      interp.sp = 0
      interp.stack = []
      ip
    }
    4 => {
      // vmoveto
      check_width(interp)
      if interp.sp > 1 && not(interp.width_set) {
        // First arg is width
      }
      let dy = interp.pop()
      interp.move_to(interp.current_x, interp.current_y + dy)
      ip
    }
    5 => {
      // rlineto
      let mut i = 0
      while i + 1 < interp.sp {
        let dx = interp.stack[i]
        let dy = interp.stack[i + 1]
        interp.line_to(interp.current_x + dx, interp.current_y + dy)
        i += 2
      }
      interp.sp = 0
      interp.stack = []
      ip
    }
    6 => {
      // hlineto: alternating horizontal/vertical lines starting with horizontal
      let mut horizontal = true
      for i = 0; i < interp.sp; i = i + 1 {
        let d = interp.stack[i]
        if horizontal {
          interp.line_to(interp.current_x + d, interp.current_y)
        } else {
          interp.line_to(interp.current_x, interp.current_y + d)
        }
        horizontal = not(horizontal)
      }
      interp.sp = 0
      interp.stack = []
      ip
    }
    7 => {
      // vlineto: alternating vertical/horizontal lines starting with vertical
      let mut horizontal = false
      for i = 0; i < interp.sp; i = i + 1 {
        let d = interp.stack[i]
        if horizontal {
          interp.line_to(interp.current_x + d, interp.current_y)
        } else {
          interp.line_to(interp.current_x, interp.current_y + d)
        }
        horizontal = not(horizontal)
      }
      interp.sp = 0
      interp.stack = []
      ip
    }
    8 => {
      // rrcurveto: dx1 dy1 dx2 dy2 dx3 dy3 {dxa dya dxb dyb dxc dyc}*
      let mut i = 0
      while i + 5 < interp.sp {
        let x1 = interp.current_x + interp.stack[i]
        let y1 = interp.current_y + interp.stack[i + 1]
        let x2 = x1 + interp.stack[i + 2]
        let y2 = y1 + interp.stack[i + 3]
        let x3 = x2 + interp.stack[i + 4]
        let y3 = y2 + interp.stack[i + 5]
        interp.curve_to(x1, y1, x2, y2, x3, y3)
        i += 6
      }
      interp.sp = 0
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
      check_width(interp)
      ip + code.length() // stop execution
    }
    18 => {
      // hstemhm (same as hstem but for hint masks)
      check_width(interp)
      let pairs = interp.sp / 2
      let mut pos = 0L
      for i = 0; i < pairs; i = i + 1 {
        let d1 = interp.stack[i * 2]
        let d2 = interp.stack[i * 2 + 1]
        pos += d1
        interp.hints_h.push({ position: pos, width: d2 })
        pos += d2
      }
      interp.sp = 0
      interp.stack = []
      ip
    }
    21 => {
      // rmoveto
      check_width(interp)
      let dy = interp.pop()
      let dx = interp.pop()
      interp.move_to(interp.current_x + dx, interp.current_y + dy)
      ip
    }
    22 => {
      // hmoveto
      check_width(interp)
      let dx = interp.pop()
      interp.move_to(interp.current_x + dx, interp.current_y)
      ip
    }
    23 => {
      // vstemhm (same as vstem but for hint masks)
      check_width(interp)
      let pairs = interp.sp / 2
      let mut pos = 0L
      for i = 0; i < pairs; i = i + 1 {
        let d1 = interp.stack[i * 2]
        let d2 = interp.stack[i * 2 + 1]
        pos += d1
        interp.hints_v.push({ position: pos, width: d2 })
        pos += d2
      }
      interp.sp = 0
      interp.stack = []
      ip
    }
    24 => {
      // rcurveline: curves then line
      let mut i = 0
      while i + 7 < interp.sp {
        let x1 = interp.current_x + interp.stack[i]
        let y1 = interp.current_y + interp.stack[i + 1]
        let x2 = x1 + interp.stack[i + 2]
        let y2 = y1 + interp.stack[i + 3]
        let x3 = x2 + interp.stack[i + 4]
        let y3 = y2 + interp.stack[i + 5]
        interp.curve_to(x1, y1, x2, y2, x3, y3)
        i += 6
      }
      if i + 1 < interp.sp {
        let dx = interp.stack[i]
        let dy = interp.stack[i + 1]
        interp.line_to(interp.current_x + dx, interp.current_y + dy)
      }
      interp.sp = 0
      interp.stack = []
      ip
    }
    25 => {
      // rlinecurve: lines then curve
      let mut i = 0
      while i + 7 < interp.sp {
        let dx = interp.stack[i]
        let dy = interp.stack[i + 1]
        interp.line_to(interp.current_x + dx, interp.current_y + dy)
        i += 2
      }
      if i + 5 < interp.sp {
        let x1 = interp.current_x + interp.stack[i]
        let y1 = interp.current_y + interp.stack[i + 1]
        let x2 = x1 + interp.stack[i + 2]
        let y2 = y1 + interp.stack[i + 3]
        let x3 = x2 + interp.stack[i + 4]
        let y3 = y2 + interp.stack[i + 5]
        interp.curve_to(x1, y1, x2, y2, x3, y3)
      }
      interp.sp = 0
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
      if interp.sp >= 7 {
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
      interp.sp = 0
      interp.stack = []
      ip
    }
    _ => {
      interp.sp = 0
      interp.stack = []
      ip
    }
  }
}

///|
/// vhcurveto: alternating vertical/horizontal tangent curves.
fn op_vhcurveto(interp : PsInterp) -> Unit {
  let mut i = 0
  let mut phase = 0 // 0=v start, 1=h start
  while i + 3 < interp.sp {
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
      let dy3 = if i + 4 == interp.sp - 1 { interp.stack[i + 4] } else { 0L }
      let y3 = y2 + dy3
      interp.curve_to(x1, y1, x2, y2, x3, y3)
      i += 4
      if dy3 != 0L {
        i += 1
      }
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
      let dx3 = if i + 4 == interp.sp - 1 { interp.stack[i + 4] } else { 0L }
      let x3 = x2 + dx3
      let y3 = y2 + dy3
      interp.curve_to(x1, y1, x2, y2, x3, y3)
      i += 4
      if dx3 != 0L {
        i += 1
      }
    }
    phase = 1 - phase
  }
  interp.sp = 0
  interp.stack = []
}

///|
/// hvcurveto: alternating horizontal/vertical tangent curves.
fn op_hvcurveto(interp : PsInterp) -> Unit {
  let mut i = 0
  let mut phase = 1 // 1=h start, 0=v start
  while i + 3 < interp.sp {
    if phase == 1 {
      let dx1 = interp.stack[i]
      let dx2 = interp.stack[i + 1]
      let dy2 = interp.stack[i + 2]
      let dy3 = interp.stack[i + 3]
      let x1 = interp.current_x + dx1
      let y1 = interp.current_y
      let x2 = x1 + dx2
      let y2 = y1 + dy2
      let dx3 = if i + 4 == interp.sp - 1 { interp.stack[i + 4] } else { 0L }
      let x3 = x2 + dx3
      let y3 = y2 + dy3
      interp.curve_to(x1, y1, x2, y2, x3, y3)
      i += 4
      if dx3 != 0L {
        i += 1
      }
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
      let dy3 = if i + 4 == interp.sp - 1 { interp.stack[i + 4] } else { 0L }
      let y3 = y2 + dy3
      interp.curve_to(x1, y1, x2, y2, x3, y3)
      i += 4
      if dy3 != 0L {
        i += 1
      }
    }
    phase = 1 - phase
  }
  interp.sp = 0
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
