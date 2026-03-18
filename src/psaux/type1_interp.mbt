///|
/// Mutable state specific to Type 1 charstring interpretation.
priv struct Type1State {
  mut in_flex : Bool
  flex_points : Array[(Int64, Int64)]
  othersubr_results : Array[Int64]
}

///|
fn Type1State::new() -> Type1State {
  { in_flex: false, flex_points: [], othersubr_results: [] }
}

///|
/// Execute a Type 1 charstring.
/// Returns the resulting outline and advance width.
pub fn execute_type1(
  charstring : Bytes,
  subrs : Array[Bytes],
  default_width : Int64,
) -> (@types.Outline, Int64, Array[StemHint], Array[StemHint]) raise @error.FTError {
  let interp = PsInterp::new()
  interp.width = default_width
  interp.local_subrs = subrs
  let state = Type1State::new()
  exec_type1_code(interp, charstring, state)
  let outline = interp.finalize()
  (outline, interp.width, interp.hints_h, interp.hints_v)
}

///|
/// Execute Type 1 charstring bytecode.
fn exec_type1_code(
  interp : PsInterp,
  code : Bytes,
  state : Type1State,
) -> Unit raise @error.FTError {
  let len = code.length()
  for ip = 0; ip < len; {
    let b0 = code[ip].to_int()
    let mut next_ip = ip + 1
    match b0 {
      n if n >= 0 && n <= 11 =>
        // Operator
        next_ip = exec_type1_op(interp, code, next_ip, b0, state)
      12 => {
        // Two-byte operator
        if next_ip >= len {
          raise @error.FTError::SyntaxError
        }
        let b1 = code[next_ip].to_int()
        next_ip += 1
        next_ip = exec_type1_op2(interp, code, next_ip, b1, state)
      }
      n if n >= 13 && n <= 31 =>
        // Operator
        next_ip = exec_type1_op(interp, code, next_ip, b0, state)
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
        // Type 1: 4-byte signed integer (NOT 16.16 fixed like Type 2)
        if next_ip + 3 >= len {
          raise @error.FTError::SyntaxError
        }
        let b1 = code[next_ip].to_int()
        let b2 = code[next_ip + 1].to_int()
        let b3 = code[next_ip + 2].to_int()
        let b4 = code[next_ip + 3].to_int()
        // Build as Int64 to avoid overflow
        let val = (b1.to_int64() << 24) |
          (b2.to_int64() << 16) |
          (b3.to_int64() << 8) |
          b4.to_int64()
        // Sign-extend: if high bit set, subtract 2^32
        let signed_val = if val >= 0x80000000L {
          val - 0x100000000L
        } else {
          val
        }
        interp.push(signed_val)
        next_ip += 4
      }
      _ => ()
    }
    continue next_ip
  }
}

///|
/// Execute a one-byte Type 1 operator.
fn exec_type1_op(
  interp : PsInterp,
  code : Bytes,
  ip : Int,
  op : Int,
  state : Type1State,
) -> Int raise @error.FTError {
  ignore(code)
  match op {
    1 | 3 => {
      // hstem (1) / vstem (3)
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
      // vmoveto (dy) — closes previous subpath first
      if state.in_flex {
        // During flex, collect the point
        let dy = interp.pop()
        state.flex_points.push((interp.current_x, interp.current_y + dy))
        interp.current_y = interp.current_y + dy
      } else {
        let dy = interp.pop()
        interp.move_to(interp.current_x, interp.current_y + dy)
      }
      ip
    }
    5 => {
      // rlineto (dx dy)
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
      // hlineto (dx)
      let dx = interp.pop()
      interp.line_to(interp.current_x + dx, interp.current_y)
      ip
    }
    7 => {
      // vlineto (dy)
      let dy = interp.pop()
      interp.line_to(interp.current_x, interp.current_y + dy)
      ip
    }
    8 => {
      // rrcurveto (dx1 dy1 dx2 dy2 dx3 dy3)
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
    9 => {
      // closepath — explicit close (Type 1 specific)
      if interp.path_started {
        let n = interp.points.length()
        if n > 0 {
          interp.contours.push((n - 1).reinterpret_as_uint())
        }
        interp.path_started = false
      }
      ip
    }
    10 => {
      // callsubr (subr#)
      let subr_idx = interp.pop().to_int()
      // Type 1 uses direct index (no bias)
      if subr_idx >= 0 && subr_idx < interp.local_subrs.length() {
        interp.call_stack.push({ code, ip })
        exec_type1_code(interp, interp.local_subrs[subr_idx], state)
        match interp.call_stack.pop() {
          Some(_) => ()
          None => ()
        }
      }
      ip
    }
    11 =>
      // return
      ip + code.length() // stop execution of current code
    13 => {
      // hsbw (sbx wx) — set sidebearing and width (Type 1 specific)
      let wx = interp.pop()
      let sbx = interp.pop()
      interp.width = wx
      interp.width_set = true
      // Set the initial position to the sidebearing
      interp.current_x = sbx
      interp.current_y = 0L
      ip
    }
    14 =>
      // endchar
      ip + code.length() // stop execution
    21 => {
      // rmoveto (dx dy) — closes previous subpath first
      if state.in_flex {
        let dy = interp.pop()
        let dx = interp.pop()
        state.flex_points.push((interp.current_x + dx, interp.current_y + dy))
        interp.current_x = interp.current_x + dx
        interp.current_y = interp.current_y + dy
      } else {
        let dy = interp.pop()
        let dx = interp.pop()
        interp.move_to(interp.current_x + dx, interp.current_y + dy)
      }
      ip
    }
    22 => {
      // hmoveto (dx) — closes previous subpath first
      if state.in_flex {
        let dx = interp.pop()
        state.flex_points.push((interp.current_x + dx, interp.current_y))
        interp.current_x = interp.current_x + dx
      } else {
        let dx = interp.pop()
        interp.move_to(interp.current_x + dx, interp.current_y)
      }
      ip
    }
    30 => {
      // vhcurveto (dy1 dx2 dy2 dx3)
      if interp.stack.length() >= 4 {
        let dy1 = interp.stack[0]
        let dx2 = interp.stack[1]
        let dy2 = interp.stack[2]
        let dx3 = interp.stack[3]
        let x1 = interp.current_x
        let y1 = interp.current_y + dy1
        let x2 = x1 + dx2
        let y2 = y1 + dy2
        let x3 = x2 + dx3
        let y3 = y2
        interp.curve_to(x1, y1, x2, y2, x3, y3)
      }
      interp.stack = []
      ip
    }
    31 => {
      // hvcurveto (dx1 dx2 dy2 dy3)
      if interp.stack.length() >= 4 {
        let dx1 = interp.stack[0]
        let dx2 = interp.stack[1]
        let dy2 = interp.stack[2]
        let dy3 = interp.stack[3]
        let x1 = interp.current_x + dx1
        let y1 = interp.current_y
        let x2 = x1 + dx2
        let y2 = y1 + dy2
        let x3 = x2
        let y3 = y2 + dy3
        interp.curve_to(x1, y1, x2, y2, x3, y3)
      }
      interp.stack = []
      ip
    }
    _ => ip // unknown operator, skip
  }
}

///|
/// Execute a two-byte (12 xx) Type 1 operator.
fn exec_type1_op2(
  interp : PsInterp,
  code : Bytes,
  ip : Int,
  op : Int,
  state : Type1State,
) -> Int {
  ignore(code)
  match op {
    0 =>
      // dotsection — no-op
      ip
    1 => {
      // vstem3 (y0 dy0 y1 dy1 y2 dy2) — 3 vertical stems
      if interp.stack.length() >= 6 {
        for i in 0..<3 {
          let p = interp.stack[i * 2]
          let w = interp.stack[i * 2 + 1]
          interp.hints_v.push({ position: p, width: w })
        }
      }
      interp.stack = []
      ip
    }
    2 => {
      // hstem3 (x0 dx0 x1 dx1 x2 dx2) — 3 horizontal stems
      if interp.stack.length() >= 6 {
        for i in 0..<3 {
          let p = interp.stack[i * 2]
          let w = interp.stack[i * 2 + 1]
          interp.hints_h.push({ position: p, width: w })
        }
      }
      interp.stack = []
      ip
    }
    6 => {
      // seac (asb adx ady bchar achar) — accented character composite
      // For now, skip seac and return empty outline
      interp.stack = []
      ip + code.length() // stop execution
    }
    7 => {
      // sbw (sbx sby wx wy) — set sidebearing and width (2D)
      if interp.stack.length() >= 4 {
        let sbx = interp.stack[0]
        let sby = interp.stack[1]
        let wx = interp.stack[2]
        // wy = interp.stack[3] // ignored for horizontal writing
        interp.width = wx
        interp.width_set = true
        interp.current_x = sbx
        interp.current_y = sby
      }
      interp.stack = []
      ip
    }
    12 => {
      // div (num1 num2) — integer division, push result
      let num2 = interp.pop()
      let num1 = interp.pop()
      if num2 != 0L {
        interp.push(num1 / num2)
      } else {
        interp.push(0L)
      }
      ip
    }
    16 => {
      // callothersubr (arg1..argn n othersubr#)
      let othersubr_num = interp.pop().to_int()
      let n_args = interp.pop().to_int()
      // Collect args from PS stack
      let args : Array[Int64] = []
      for _i in 0..<n_args {
        args.push(interp.pop())
      }
      // Reverse args since we popped them in reverse order
      args.rev_in_place()
      match othersubr_num {
        0 => {
          // End flex
          // args[0] = final_dx, args[1] = final_dy, args[2] = join_point_type
          state.in_flex = false
          // flex_points should have 7 points: reference + 6 control points
          if state.flex_points.length() >= 7 {
            // Emit two cubic bezier curves from the flex data
            let (x1, y1) = state.flex_points[1]
            let (x2, y2) = state.flex_points[2]
            let (x3, y3) = state.flex_points[3]
            let (x4, y4) = state.flex_points[4]
            let (x5, y5) = state.flex_points[5]
            let (x6, y6) = state.flex_points[6]
            interp.curve_to(x1, y1, x2, y2, x3, y3)
            interp.curve_to(x4, y4, x5, y5, x6, y6)
          }
          state.flex_points.clear()
          // Push x and y for the final position (consumed by pop)
          state.othersubr_results.push(interp.current_x)
          state.othersubr_results.push(interp.current_y)
        }
        1 => {
          // Start flex — reset flex point collection
          state.in_flex = true
          state.flex_points.clear()
        }
        2 =>
          // Flex: add current point as flex point
          state.flex_points.push((interp.current_x, interp.current_y))
        3 =>
          // Hint replacement — push 1 to OtherSubrs results for pop
          state.othersubr_results.push(1L)
        _ =>
          // Unknown othersubr — push all args to results for pop
          for a in args {
            state.othersubr_results.push(a)
          }
      }
      ip
    }
    17 => {
      // pop — pop from OtherSubrs result stack, push to interp stack
      let val = match state.othersubr_results.pop() {
        Some(v) => v
        None => 0L
      }
      interp.push(val)
      ip
    }
    33 => {
      // setcurrentpoint (x y)
      if interp.stack.length() >= 2 {
        let x = interp.stack[0]
        let y = interp.stack[1]
        interp.current_x = x
        interp.current_y = y
      }
      interp.stack = []
      ip
    }
    _ => {
      // Unknown two-byte operator
      interp.stack = []
      ip
    }
  }
}
