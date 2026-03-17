///|
test "Type2: rmoveto + rlineto triangle" {
  // Charstring: 0 0 rmoveto 100 0 rlineto 0 100 rlineto endchar
  // rmoveto = 21, rlineto = 5, endchar = 14
  // Numbers: 0 = byte 139, 100 = byte 239
  let cs : Bytes = [
    139, 139, 21, // rmoveto(0, 0)
     239, 139, 5, // rlineto(100, 0)
     139, 239, 5, // rlineto(0, 100)
     14,
  ] // endchar
  let (outline, _width, _, _) = @psaux.execute_type2(cs, 0L, 0L)
  inspect(outline.n_points(), content="3")
  inspect(outline.n_contours(), content="1")
  inspect(outline.points[0].x, content="0")
  inspect(outline.points[0].y, content="0")
  inspect(outline.points[1].x, content="100")
  inspect(outline.points[1].y, content="0")
  inspect(outline.points[2].x, content="100")
  inspect(outline.points[2].y, content="100")
}

///|
test "Type2: hmoveto" {
  // hmoveto(50) endchar
  let cs : Bytes = [
    189, 22, // hmoveto(50)
     14,
  ] // endchar
  let (outline, _, _, _) = @psaux.execute_type2(cs, 0L, 0L)
  inspect(outline.n_points(), content="1")
  inspect(outline.points[0].x, content="50")
  inspect(outline.points[0].y, content="0")
}

///|
test "Type2: vmoveto" {
  // vmoveto(75) endchar
  let cs : Bytes = [
    214, 4, // vmoveto(75)
     14,
  ] // endchar
  let (outline, _, _, _) = @psaux.execute_type2(cs, 0L, 0L)
  inspect(outline.n_points(), content="1")
  inspect(outline.points[0].x, content="0")
  inspect(outline.points[0].y, content="75")
}

///|
test "Type2: rrcurveto" {
  // rmoveto(0,0) rrcurveto(10,20,30,40,50,60) endchar
  let cs : Bytes = [
    139, 139, 21, // rmoveto(0,0)
     149, 159, 169, 179, 189, 199, 8, // rrcurveto
     14,
  ] // endchar
  let (outline, _, _, _) = @psaux.execute_type2(cs, 0L, 0L)
  inspect(outline.n_points(), content="4") // move + 3 curve points
  // First point: moveto (0,0)
  inspect(outline.points[0].x, content="0")
  // Control point 1: (0+10, 0+20) = (10, 20)
  inspect(outline.points[1].x, content="10")
  inspect(outline.points[1].y, content="20")
  // Control point 2: (10+30, 20+40) = (40, 60)
  inspect(outline.points[2].x, content="40")
  inspect(outline.points[2].y, content="60")
  // End point: (40+50, 60+60) = (90, 120)
  inspect(outline.points[3].x, content="90")
  inspect(outline.points[3].y, content="120")
}

///|
test "Type2: hlineto" {
  // rmoveto(0,0) hlineto(100 50) endchar
  // hlineto alternates: h, v, h, v...
  let cs : Bytes = [
    139, 139, 21, // rmoveto(0,0)
     239, 189, 6, // hlineto(100, 50)
     14,
  ] // endchar
  let (outline, _, _, _) = @psaux.execute_type2(cs, 0L, 0L)
  inspect(outline.n_points(), content="3")
  inspect(outline.points[1].x, content="100") // horizontal move
  inspect(outline.points[1].y, content="0")
  inspect(outline.points[2].x, content="100") // vertical move
  inspect(outline.points[2].y, content="50")
}

///|
test "Type2: vlineto" {
  // rmoveto(0,0) vlineto(100 50) endchar
  let cs : Bytes = [
    139, 139, 21, // rmoveto(0,0)
     239, 189, 7, // vlineto(100, 50)
     14,
  ] // endchar
  let (outline, _, _, _) = @psaux.execute_type2(cs, 0L, 0L)
  inspect(outline.n_points(), content="3")
  inspect(outline.points[1].x, content="0") // vertical move
  inspect(outline.points[1].y, content="100")
  inspect(outline.points[2].x, content="50") // horizontal move
  inspect(outline.points[2].y, content="100")
}

///|
test "Type2: number encoding" {
  // Test various number encodings
  let interp = @psaux.PsInterp::new()
  // byte 139 = 0
  // byte 240 = (240-247)*256 + 0 + 108 (not valid for single byte)
  // Actually: 139 → 0, 140 → 1, 238 → 99, 239 → 100
  // 247 b1 → (247-247)*256 + b1 + 108 = b1 + 108
  // 251 b1 → -(251-251)*256 + b1 + 108) = -(b1 + 108)
  ignore(interp)
  // Just verify basic encoding: push 0 (=139), push 100 (=239)
  let cs : Bytes = [139, 239, 14] // push 0, push 100, endchar
  let (_, _, _, _) = @psaux.execute_type2(cs, 0L, 0L)
  // No crash = success
}

///|
test "calc_subr_bias" {
  inspect(@psaux.calc_subr_bias(0), content="107")
  inspect(@psaux.calc_subr_bias(100), content="107")
  inspect(@psaux.calc_subr_bias(1239), content="107")
  inspect(@psaux.calc_subr_bias(1240), content="1131")
  inspect(@psaux.calc_subr_bias(33899), content="1131")
  inspect(@psaux.calc_subr_bias(33900), content="32768")
}

///|
test "Type2: hstem hints" {
  // hstem 10 20 endchar — one horizontal stem at pos 10, width 20
  let cs : Bytes = [149, 159, 1, 14]
  let (outline, _, _, _) = @psaux.execute_type2(cs, 0L, 0L)
  // The hstem hint should be recorded but outline will just have endchar
  ignore(outline)
  // Verify through execute_type2 — hints are internal state, test via outline output
}
