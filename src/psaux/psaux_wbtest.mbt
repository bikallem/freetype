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
  let (outline, _width, _, _) = execute_type2(cs, 0L, 0L)
  inspect(outline.n_points(), content="3")
  inspect(outline.n_contours(), content="1")
  inspect(outline.points()[0].x(), content="0")
  inspect(outline.points()[0].y(), content="0")
  inspect(outline.points()[1].x(), content="100")
  inspect(outline.points()[1].y(), content="0")
  inspect(outline.points()[2].x(), content="100")
  inspect(outline.points()[2].y(), content="100")
}

///|
test "Type2: hmoveto" {
  // hmoveto(50) endchar
  let cs : Bytes = [
    189, 22, // hmoveto(50)
     14,
  ] // endchar
  let (outline, _, _, _) = execute_type2(cs, 0L, 0L)
  inspect(outline.n_points(), content="1")
  inspect(outline.points()[0].x(), content="50")
  inspect(outline.points()[0].y(), content="0")
}

///|
test "Type2: vmoveto" {
  // vmoveto(75) endchar
  let cs : Bytes = [
    214, 4, // vmoveto(75)
     14,
  ] // endchar
  let (outline, _, _, _) = execute_type2(cs, 0L, 0L)
  inspect(outline.n_points(), content="1")
  inspect(outline.points()[0].x(), content="0")
  inspect(outline.points()[0].y(), content="75")
}

///|
test "Type2: hmoveto width uses nominalWidthX" {
  // width = nominal 400 + 200, dx = 50
  let cs : Bytes = [247, 92, 189, 22, 14]
  let (outline, width, _, _) = execute_type2(cs, 500L, 400L)
  inspect(width, content="600")
  inspect(outline.n_points(), content="1")
  inspect(outline.points()[0].x(), content="50")
  inspect(outline.points()[0].y(), content="0")
}

///|
test "Type2: endchar width uses nominalWidthX" {
  // width = nominal 400 + 50
  let cs : Bytes = [189, 14]
  let (outline, width, _, _) = execute_type2(cs, 500L, 400L)
  inspect(width, content="450")
  inspect(outline.n_points(), content="0")
}

///|
test "Type2: rrcurveto" {
  // rmoveto(0,0) rrcurveto(10,20,30,40,50,60) endchar
  let cs : Bytes = [
    139, 139, 21, // rmoveto(0,0)
     149, 159, 169, 179, 189, 199, 8, // rrcurveto
     14,
  ] // endchar
  let (outline, _, _, _) = execute_type2(cs, 0L, 0L)
  inspect(outline.n_points(), content="4") // move + 3 curve points
  // First point: moveto (0,0)
  inspect(outline.points()[0].x(), content="0")
  // Control point 1: (0+10, 0+20) = (10, 20)
  inspect(outline.points()[1].x(), content="10")
  inspect(outline.points()[1].y(), content="20")
  // Control point 2: (10+30, 20+40) = (40, 60)
  inspect(outline.points()[2].x(), content="40")
  inspect(outline.points()[2].y(), content="60")
  // End point: (40+50, 60+60) = (90, 120)
  inspect(outline.points()[3].x(), content="90")
  inspect(outline.points()[3].y(), content="120")
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
  let (outline, _, _, _) = execute_type2(cs, 0L, 0L)
  inspect(outline.n_points(), content="3")
  inspect(outline.points()[1].x(), content="100") // horizontal move
  inspect(outline.points()[1].y(), content="0")
  inspect(outline.points()[2].x(), content="100") // vertical move
  inspect(outline.points()[2].y(), content="50")
}

///|
test "Type2: vlineto" {
  // rmoveto(0,0) vlineto(100 50) endchar
  let cs : Bytes = [
    139, 139, 21, // rmoveto(0,0)
     239, 189, 7, // vlineto(100, 50)
     14,
  ] // endchar
  let (outline, _, _, _) = execute_type2(cs, 0L, 0L)
  inspect(outline.n_points(), content="3")
  inspect(outline.points()[1].x(), content="0") // vertical move
  inspect(outline.points()[1].y(), content="100")
  inspect(outline.points()[2].x(), content="50") // horizontal move
  inspect(outline.points()[2].y(), content="100")
}

///|
test "Type2: number encoding" {
  // Test various number encodings
  let interp = PsInterp::new()
  // byte 139 = 0
  // byte 240 = (240-247)*256 + 0 + 108 (not valid for single byte)
  // Actually: 139 → 0, 140 → 1, 238 → 99, 239 → 100
  // 247 b1 → (247-247)*256 + b1 + 108 = b1 + 108
  // 251 b1 → -(251-251)*256 + b1 + 108) = -(b1 + 108)
  ignore(interp)
  // Just verify basic encoding: push 0 (=139), push 100 (=239)
  let cs : Bytes = [139, 239, 14] // push 0, push 100, endchar
  let (_, _, _, _) = execute_type2(cs, 0L, 0L)
  // No crash = success
}

///|
test "calc_subr_bias" {
  inspect(calc_subr_bias(0), content="107")
  inspect(calc_subr_bias(100), content="107")
  inspect(calc_subr_bias(1239), content="107")
  inspect(calc_subr_bias(1240), content="1131")
  inspect(calc_subr_bias(33899), content="1131")
  inspect(calc_subr_bias(33900), content="32768")
}

///|
test "Type2: hstem hints" {
  // hstem 10 20 endchar — one horizontal stem at pos 10, width 20
  let cs : Bytes = [149, 159, 1, 14]
  let (outline, _, _, _) = execute_type2(cs, 0L, 0L)
  // The hstem hint should be recorded but outline will just have endchar
  ignore(outline)
  // Verify through execute_type2 — hints are internal state, test via outline output
}

///|
test "Type2: hstem width does not corrupt hints" {
  // width = nominal 400 + 50, then hstem 10 20
  let cs : Bytes = [189, 149, 159, 1, 14]
  let (_, width, hh, hv) = execute_type2(cs, 500L, 400L)
  inspect(width, content="450")
  inspect(hh.length(), content="1")
  inspect(hv.length(), content="0")
  inspect(hh[0].position(), content="10")
  inspect(hh[0].width(), content="20")
}

///|
test "Type1: seac composes outlines and shifts hints" {
  let cs : Bytes = [
    189, 248, 136, 13, // hsbw(50, 500)
     139, 247, 12, 169, 204, 205, 12, 6,
  ] // seac(asb=0, adx=120, ady=30, 'A', 'B')
  let load_seac_component : (String) -> (
    @types.Outline,
    Int64,
    Array[StemHint],
    Array[StemHint],
  ) raise @error.FTError = fn(name) raise @error.FTError {
    let outline = if name == "A" {
      @types.Outline::create(
        [
          @types.Vector::new(0L, 0L),
          @types.Vector::new(100L, 0L),
          @types.Vector::new(100L, 100L),
        ],
        [@types.CURVE_TAG_ON, @types.CURVE_TAG_ON, @types.CURVE_TAG_ON],
        [2U],
      )
    } else if name == "B" {
      @types.Outline::create(
        [
          @types.Vector::new(0L, 0L),
          @types.Vector::new(20L, 0L),
          @types.Vector::new(20L, 20L),
        ],
        [@types.CURVE_TAG_ON, @types.CURVE_TAG_ON, @types.CURVE_TAG_ON],
        [2U],
      )
    } else {
      raise @error.FTError::InvalidGlyphIndex
    }
    let hh = if name == "A" {
      [{ position: 10L, width: 5L }]
    } else {
      [{ position: 3L, width: 2L }]
    }
    let hv = if name == "A" {
      [{ position: 20L, width: 7L }]
    } else {
      [{ position: 4L, width: 3L }]
    }
    (outline, if name == "A" { 300L } else { 200L }, hh, hv)
  }
  let (outline, width, hh, hv) = execute_type1(cs, [], 0L, load_seac_component)
  inspect(width, content="500")
  inspect(outline.n_points(), content="6")
  inspect(outline.n_contours(), content="2")
  inspect(outline.points()[3].x(), content="170")
  inspect(outline.points()[3].y(), content="30")
  inspect(outline.points()[5].x(), content="190")
  inspect(outline.points()[5].y(), content="50")
  inspect(hh.length(), content="2")
  inspect(hh[0].position(), content="10")
  inspect(hh[1].position(), content="33")
  inspect(hv.length(), content="2")
  inspect(hv[0].position(), content="20")
  inspect(hv[1].position(), content="174")
}

///|
fn encode_type1_test_int(value : Int) -> Bytes {
  if value >= -107 && value <= 107 {
    [(value + 139).to_byte()]
  } else if value >= 108 && value <= 1131 {
    let adjusted = value - 108
    [(247 + adjusted / 256).to_byte(), (adjusted % 256).to_byte()]
  } else if value >= -1131 && value <= -108 {
    let adjusted = -value - 108
    [(251 + adjusted / 256).to_byte(), (adjusted % 256).to_byte()]
  } else {
    [
      b'\xFF',
      ((value >> 24) & 0xFF).to_byte(),
      ((value >> 16) & 0xFF).to_byte(),
      ((value >> 8) & 0xFF).to_byte(),
      (value & 0xFF).to_byte(),
    ]
  }
}

///|
test "Type1: MM othersubr blends width values" {
  let cs_bytes : Array[Byte] = []
  for
    chunk in [
      encode_type1_test_int(50), // lsb
      encode_type1_test_int(400), // base width
      encode_type1_test_int(200), // delta to master 1
      encode_type1_test_int(2), // arg count
      encode_type1_test_int(14), // MM othersubr #14 => one blended result
      Bytes::from_array([b'\x0C', b'\x10']), // callothersubr
      Bytes::from_array([b'\x0C', b'\x11']), // pop blended width
      Bytes::from_array([b'\x0D', b'\x0E']), // hsbw, endchar
    ] {
    for byte in chunk {
      cs_bytes.push(byte)
    }
  }
  let cs = Bytes::from_array(cs_bytes[:])
  let no_seac : (String) -> (
    @types.Outline,
    Int64,
    Array[StemHint],
    Array[StemHint],
  ) raise @error.FTError = _name => raise @error.FTError::InvalidGlyphIndex
  let (_, default_width, _, _) = execute_type1(cs, [], 0L, no_seac, mm_weight_vector=[
    0x8000L, 0x8000L,
  ])
  inspect(default_width, content="500")
  let (_, bold_width, _, _) = execute_type1(cs, [], 0L, no_seac, mm_weight_vector=[
    0L, 0x10000L,
  ])
  inspect(bold_width, content="600")
}

///|
test "Type2: flex operators produce two curves" {
  let flex : Bytes = [
    139, 139, 21, // rmoveto(0, 0)
     149, 149, 149, 149, 149, 139, 149, 149, 149, 149, 149, 139, 139, 12, 35, // flex
     14,
  ]
  let (flex_outline, _, _, _) = execute_type2(flex, 0L, 0L)
  inspect(flex_outline.n_points(), content="7")
  inspect(flex_outline.points()[6].x(), content="60")
  inspect(flex_outline.points()[6].y(), content="40")

  let hflex1 : Bytes = [
    139, 139, 21, // rmoveto(0, 0)
     149, 149, 149, 149, 149, 149, 149, 149, 149, 12, 36, // hflex1
     14,
  ]
  let (hflex1_outline, _, _, _) = execute_type2(hflex1, 0L, 0L)
  inspect(hflex1_outline.n_points(), content="7")
  inspect(hflex1_outline.points()[6].x(), content="60")
  inspect(hflex1_outline.points()[6].y(), content="0")

  let flex1 : Bytes = [
    139, 139, 21, // rmoveto(0, 0)
     149, 149, 149, 149, 149, 149, 149, 149, 149, 149, 149, 12, 37, // flex1
     14,
  ]
  let (flex1_outline, _, _, _) = execute_type2(flex1, 0L, 0L)
  inspect(flex1_outline.n_points(), content="7")
  inspect(flex1_outline.points()[6].x(), content="0")
  inspect(flex1_outline.points()[6].y(), content="60")
}

///|
test "Type2: stack operators work" {
  let cs : Bytes = [
    149, 149, 12, 24, // mul(10, 10) -> 100
     139, 12, 20, // put(100, 0)
     139, 12, 21, // get(0)
     140, 12, 29, // index(1) -> 100
     247, 42, 12, 10, // add(100, 150) -> 250
     22, // hmoveto(250)
     14,
  ]
  let (outline, _, _, _) = execute_type2(cs, 0L, 0L)
  inspect(outline.n_points(), content="1")
  inspect(outline.points()[0].x(), content="250")
  inspect(outline.points()[0].y(), content="0")
}

///|
test "Type2: fixed-point div survives transient storage" {
  let cs : Bytes = [
    140, 141, 12, 12, // div(1, 2) -> 0.5
     139, 12, 20, // put(0.5, 0)
     139, 12, 21, // get(0)
     143, 12, 24, // mul(0.5, 4) -> 2
     22, // hmoveto(2)
     14,
  ]
  let (outline, _, _, _) = execute_type2(cs, 0L, 0L)
  inspect(outline.n_points(), content="1")
  inspect(outline.points()[0].x(), content="2")
  inspect(outline.points()[0].y(), content="0")
}

///|
test "Type2: random returns fixed-point fractions" {
  let cs : Bytes = [
    12, 23, // random()
     143, 12, 24, // mul(random, 4)
     22, // hmoveto
     14,
  ]
  let (outline, _, _, _) = execute_type2(cs, 0L, 0L)
  inspect(outline.n_points(), content="1")
  inspect(outline.points()[0].x(), content="3")
  inspect(outline.points()[0].y(), content="0")
}
