///|
test "InterpContext: stack push/pop" {
  let ctx = InterpContext::new()
  // PUSHB[0] 42
  ctx.execute(b"\xB0\x2A") // PUSHB[0] pushes 1 byte: 0x2A = 42
  inspect(ctx.sp, content="1")
  inspect(ctx.stack[0], content="42")
}

///|
test "InterpContext: arithmetic ADD/SUB" {
  let ctx = InterpContext::new()
  // PUSHB[1] 10 20 ADD
  ctx.execute(b"\xB1\x0A\x14\x60") // PUSHB[1] pushes 2 bytes, then ADD
  inspect(ctx.sp, content="1")
  inspect(ctx.stack[0], content="30") // 10 + 20
}

///|
test "InterpContext: arithmetic SUB" {
  let ctx = InterpContext::new()
  // PUSHB[1] 30 10 SUB → 20
  ctx.execute(b"\xB1\x1E\x0A\x61")
  inspect(ctx.stack[0], content="20")
}

///|
test "InterpContext: comparison LT" {
  let ctx = InterpContext::new()
  // PUSHB[1] 5 10 LT → 1 (5 < 10)
  ctx.execute(b"\xB1\x05\x0A\x50")
  inspect(ctx.stack[0], content="1")
}

///|
test "InterpContext: comparison GT" {
  let ctx = InterpContext::new()
  // PUSHB[1] 5 10 GT → 0 (5 > 10 is false)
  ctx.execute(b"\xB1\x05\x0A\x52")
  inspect(ctx.stack[0], content="0")
}

///|
test "InterpContext: logical AND" {
  let ctx = InterpContext::new()
  // PUSHB[1] 1 1 AND → 1
  ctx.execute(b"\xB1\x01\x01\x5A")
  inspect(ctx.stack[0], content="1")
}

///|
test "InterpContext: logical NOT" {
  let ctx = InterpContext::new()
  // PUSHB[0] 0 NOT → 1
  ctx.execute(b"\xB0\x00\x5C")
  inspect(ctx.stack[0], content="1")
}

///|
test "InterpContext: DUP" {
  let ctx = InterpContext::new()
  // PUSHB[0] 7 DUP → stack [7, 7]
  ctx.execute(b"\xB0\x07\x20")
  inspect(ctx.sp, content="2")
  inspect(ctx.stack[0], content="7")
  inspect(ctx.stack[1], content="7")
}

///|
test "InterpContext: SWAP" {
  let ctx = InterpContext::new()
  // PUSHB[1] 1 2 SWAP → stack [2, 1]
  ctx.execute(b"\xB1\x01\x02\x23")
  inspect(ctx.stack[0], content="2")
  inspect(ctx.stack[1], content="1")
}

///|
test "InterpContext: NPUSHB" {
  let ctx = InterpContext::new()
  // NPUSHB 3 10 20 30
  ctx.execute(b"\x40\x03\x0A\x14\x1E")
  inspect(ctx.sp, content="3")
  inspect(ctx.stack[0], content="10")
  inspect(ctx.stack[1], content="20")
  inspect(ctx.stack[2], content="30")
}

///|
test "InterpContext: NPUSHW" {
  let ctx = InterpContext::new()
  // NPUSHW 1 0x01 0x00 → 256
  ctx.execute(b"\x41\x01\x01\x00")
  inspect(ctx.sp, content="1")
  inspect(ctx.stack[0], content="256")
}

///|
test "InterpContext: NPUSHW negative" {
  let ctx = InterpContext::new()
  // NPUSHW 1 0xFF 0xFE → -2
  ctx.execute(b"\x41\x01\xFF\xFE")
  inspect(ctx.stack[0], content="-2")
}

///|
test "InterpContext: IF true branch" {
  let ctx = InterpContext::new()
  // PUSHB[0] 1 IF PUSHB[0] 42 EIF
  // condition=1 (true), should push 42
  ctx.execute(b"\xB0\x01\x58\xB0\x2A\x59")
  inspect(ctx.sp, content="1")
  inspect(ctx.stack[0], content="42")
}

///|
test "InterpContext: IF false branch" {
  let ctx = InterpContext::new()
  // PUSHB[0] 0 IF PUSHB[0] 42 EIF
  // condition=0 (false), should skip PUSHB[0] 42
  ctx.execute(b"\xB0\x00\x58\xB0\x2A\x59")
  inspect(ctx.sp, content="0")
}

///|
test "InterpContext: IF/ELSE" {
  let ctx = InterpContext::new()
  // PUSHB[0] 0 IF PUSHB[0] 1 ELSE PUSHB[0] 2 EIF
  // false → take ELSE branch → push 2
  ctx.execute(b"\xB0\x00\x58\xB0\x01\x1B\xB0\x02\x59")
  inspect(ctx.sp, content="1")
  inspect(ctx.stack[0], content="2")
}

///|
test "InterpContext: RS/WS (storage)" {
  let ctx = InterpContext::new()
  // PUSHB[1] 5 99 WS — write 99 to storage[5]
  // PUSHB[0] 5 RS — read storage[5]
  ctx.execute(b"\xB1\x05\x63\x42\xB0\x05\x43")
  inspect(ctx.stack[0], content="99")
}

///|
test "InterpContext: RCVT/WCVTP" {
  let ctx = InterpContext::new(cvt=[0L, 0L, 0L])
  // PUSHB[1] 1 128 WCVTP — write 128 to CVT[1]
  // PUSHB[0] 1 RCVT — read CVT[1]
  ctx.execute(b"\xB1\x01\x80\x45\xB0\x01\x44")
  inspect(ctx.stack[0], content="128")
}

///|
test "InterpContext: FDEF/CALL" {
  let ctx = InterpContext::new()
  // FDEF 0: PUSHB[0] 77 ENDF
  // CALL 0
  // PUSHB[0] 0 → func id
  // FDEF → defines func 0
  // PUSHB[0] 0 → func id to call
  // CALL
  ctx.execute(b"\xB0\x00\x2C\xB0\x4D\x2D\xB0\x00\x2B")
  inspect(ctx.sp, content="1")
  inspect(ctx.stack[0], content="77")
}

///|
test "InterpContext: DEPTH" {
  let ctx = InterpContext::new()
  // PUSHB[1] 1 2 DEPTH → stack [1, 2, 2]
  ctx.execute(b"\xB1\x01\x02\x24")
  inspect(ctx.sp, content="3")
  inspect(ctx.stack[2], content="2") // depth = 2 (before DEPTH pushed)
}

///|
test "InterpContext: ABS/NEG" {
  let ctx = InterpContext::new()
  // NPUSHW 1 0xFF 0xCE (-50) ABS → 50
  ctx.execute(b"\x41\x01\xFF\xCE\x64")
  inspect(ctx.stack[0], content="50")
}

///|
test "InterpContext: FLOOR/CEILING" {
  let ctx = InterpContext::new()
  // Push 100 (in 26.6 = 1.5625 pixels), FLOOR
  // 100 & ~63 = 64
  ctx.execute(b"\xB0\x64\x66")
  inspect(ctx.stack[0], content="64")
}

///|
test "loca: short format" {
  // 3 glyphs + 1 sentinel = 4 entries, short format (values ÷ 2)
  let data : Bytes = [
    0x00, 0x00, // glyph 0: offset 0
     0x00, 0x10, // glyph 1: offset 32 (16 * 2)
     0x00, 0x20, // glyph 2: offset 64 (32 * 2)
     0x00, 0x30,
  ] // sentinel: offset 96 (48 * 2)
  let reader = @stream.ByteReader::new(data)
  let offsets = parse_loca(reader, 0U, 8U, 3U, 0)
  inspect(offsets.length(), content="4")
  inspect(offsets[0], content="0")
  inspect(offsets[1], content="32")
  inspect(offsets[2], content="64")
  inspect(offsets[3], content="96")
}

///|
test "loca: long format" {
  let data : Bytes = [
    0x00, 0x00, 0x00, 0x00, // offset 0
     0x00, 0x00, 0x00, 0x50, // offset 80
     0x00, 0x00, 0x01, 0x00, // offset 256
  ]
  let reader = @stream.ByteReader::new(data)
  let offsets = parse_loca(reader, 0U, 12U, 2U, 1)
  inspect(offsets.length(), content="3")
  inspect(offsets[0], content="0")
  inspect(offsets[1], content="80")
  inspect(offsets[2], content="256")
}

///|
test "load_simple_glyph: triangle" {
  // Construct a minimal simple glyph with 3 on-curve points
  let buf = Array::new()
  // numberOfContours = 1 (already read by caller, not in buffer)
  // xMin, yMin, xMax, yMax
  buf.push(b'\x00')
  buf.push(b'\x00') // xMin = 0
  buf.push(b'\x00')
  buf.push(b'\x00') // yMin = 0
  buf.push(b'\x00')
  buf.push(b'\x64') // xMax = 100
  buf.push(b'\x00')
  buf.push(b'\x64') // yMax = 100
  // endPtsOfContours[0] = 2
  buf.push(b'\x00')
  buf.push(b'\x02')
  // instructionLength = 0
  buf.push(b'\x00')
  buf.push(b'\x00')
  // Flags: 3 points, all on-curve (0x01), x and y are 1-byte positive
  // flag = 0x01 | 0x02 (x-short) | 0x10 (x-positive) | 0x04 (y-short) | 0x20 (y-positive) = 0x37
  buf.push(b'\x37') // point 0 flags
  buf.push(b'\x37') // point 1 flags
  buf.push(b'\x37') // point 2 flags
  // X coordinates (delta-encoded, 1-byte positive):
  buf.push(b'\x00') // point 0: x = 0
  buf.push(b'\x64') // point 1: x += 100
  buf.push(b'\x32') // point 2: x += 50 (total 150)
  // Y coordinates:
  buf.push(b'\x00') // point 0: y = 0
  buf.push(b'\x00') // point 1: y += 0
  buf.push(b'\x64') // point 2: y += 100
  let data = Bytes::from_array(buf[:])
  let (outline, _instr) = load_simple_glyph(data, 0, 1)
  inspect(outline.n_points(), content="3")
  inspect(outline.n_contours(), content="1")
  inspect(outline.points()[0].x(), content="0")
  inspect(outline.points()[0].y(), content="0")
  inspect(outline.points()[1].x(), content="100")
  inspect(outline.points()[1].y(), content="0")
  inspect(outline.points()[2].x(), content="150")
  inspect(outline.points()[2].y(), content="100")
}
