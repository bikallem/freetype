///|
test "eexec_decrypt basic" {
  // Test eexec decryption with a known small input (8 bytes).
  // First 4 bytes are seed, remaining 4 are actual output.
  let data : Bytes = [0xD9, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
  let result = eexec_decrypt(data)
  // Result should skip first 4 bytes (random seed), giving us the remaining bytes
  inspect(result.length(), content="4")
}

///|
test "eexec_decrypt empty" {
  let data : Bytes = []
  let result = eexec_decrypt(data)
  inspect(result.length(), content="0")
}

///|
test "eexec_decrypt short input" {
  // Less than 4 bytes: should return empty since we skip 4 seed bytes
  let data : Bytes = [0x01, 0x02, 0x03]
  let result = eexec_decrypt(data)
  inspect(result.length(), content="0")
}

///|
test "charstring_decrypt basic" {
  // Test charstring decryption with key 4330
  let data : Bytes = [0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
  let result = charstring_decrypt(data)
  // Should skip first 4 bytes (lenIV=4), giving 4 bytes
  inspect(result.length(), content="4")
}

///|
test "charstring_decrypt custom lenIV" {
  let data : Bytes = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
  let result = charstring_decrypt(data, len_iv=2)
  // Skip first 2 bytes, giving 4 bytes
  inspect(result.length(), content="4")
}

///|
test "parse_type1_pfb segment parsing" {
  // Construct a minimal PFB with an ASCII segment and EOF
  // ASCII segment: marker=0x80, type=1, length=10 (LE), then 10 bytes of spaces
  // EOF segment: marker=0x80, type=3
  let pfb : Bytes = [
    0x80, 0x01, // marker + ASCII type
     0x0A, 0x00, 0x00, 0x00, // length = 10 (LE)
     0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, // 10 spaces
     0x80, 0x03, // marker + EOF type
  ]
  let font = parse_type1_pfb(pfb)
  // Font name should be empty since our ASCII data doesn't contain /FontName
  inspect(font.font_name, content="")
}

///|
test "parse_type1_pfb non-PFB routes to PFA" {
  // Data without 0x80 marker is treated as PFA (ASCII Type 1)
  let pfb : Bytes = [0x00, 0x01, 0x00, 0x00, 0x00, 0x00]
  let result = try? parse_type1_pfb(pfb)
  // PFA parser returns a font (possibly empty) rather than error
  inspect(result is Ok(_), content="true")
}

///|
test "Type1Font creation" {
  let font = Type1Font::new()
  inspect(font.font_name, content="")
  inspect(font.len_iv, content="4")
  inspect(font.paint_type, content="0")
  inspect(font.std_hw, content="0")
  inspect(font.std_vw, content="0")
  inspect(font.family_blues(), content="[]")
  inspect(font.stem_snap_h(), content="[]")
  inspect(font.blue_scale(), content="None")
  inspect(font.charstrings.length(), content="0")
  inspect(font.subrs.length(), content="0")
}

///|
fn encrypt_type1_test_eexec(plaintext : Bytes) -> Bytes {
  let mut key : UInt = 55665U
  let out : Array[Byte] = []
  for _ in 0..<4 {
    let cipher = (key >> 8).to_byte()
    out.push(cipher)
    key = ((cipher.to_uint() + key) * 52845U + 22719U) & 0xFFFFU
  }
  for byte in plaintext {
    let cipher = (byte.to_uint() ^ (key >> 8)).to_byte()
    out.push(cipher)
    key = ((cipher.to_uint() + key) * 52845U + 22719U) & 0xFFFFU
  }
  Bytes::from_array(out[:])
}

///|
fn type1_test_hex_ascii(data : Bytes) -> Bytes {
  let out : Array[Byte] = []
  let digits = b"0123456789ABCDEF"
  for byte in data {
    out.push(digits[(byte.to_int() >> 4) & 0x0F])
    out.push(digits[byte.to_int() & 0x0F])
  }
  Bytes::from_array(out[:])
}

///|
test "parse_type1_pfa captures private dict hint arrays and blue parameters" {
  let private_dict : Bytes = b"/BlueValues [-10 0 500 510] def\n" +
    b"/OtherBlues [-220 -210] def\n" +
    b"/FamilyBlues [96 106] def\n" +
    b"/FamilyOtherBlues [-240 -230] def\n" +
    b"/StdHW [18] def\n" +
    b"/StdVW [80] def\n" +
    b"/StemSnapH [18 22 28] def\n" +
    b"/StemSnapV [80 90] def\n" +
    b"/BlueScale 0.25 def\n" +
    b"/BlueShift 7 def\n" +
    b"/BlueFuzz 1 def\n"
  let encrypted = type1_test_hex_ascii(encrypt_type1_test_eexec(private_dict))
  let pfa : Bytes = b"%!PS-AdobeFont-1.0: HintData 001.000\n" +
    b"/FontName /HintData def\n" +
    b"/FamilyName (Hint Data) readonly def\n" +
    b"/FontType 1 def\n" +
    b"/Encoding StandardEncoding def\n" +
    b"currentfile eexec\n" +
    encrypted +
    b"\ncleartomark\n"
  let font = parse_type1_pfa(pfa)
  inspect(font.blue_values(), content="[-10, 0, 500, 510]")
  inspect(font.other_blues(), content="[-220, -210]")
  inspect(font.family_blues(), content="[96, 106]")
  inspect(font.family_other_blues(), content="[-240, -230]")
  inspect(font.std_hw(), content="18")
  inspect(font.std_vw(), content="80")
  inspect(font.stem_snap_h(), content="[18, 22, 28]")
  inspect(font.stem_snap_v(), content="[80, 90]")
  inspect(font.blue_scale(), content="Some(0.25)")
  inspect(font.blue_shift(), content="Some(7)")
  inspect(font.blue_fuzz(), content="Some(1)")
}

///|
test "parse_type1_pfa captures non-default FontMatrix and units_per_em" {
  let pfa : Bytes = b"%!PS-AdobeFont-1.0: MatrixTest 001.000\n" +
    b"/FontName /MatrixTest def\n" +
    b"/FamilyName (Matrix Test) readonly def\n" +
    b"/FontType 1 def\n" +
    b"/FontMatrix [0.0005 0 0 0.0005 0 0] readonly def\n" +
    b"/FontBBox {0 -200 500 800} readonly def\n" +
    b"/Encoding StandardEncoding def\n"
  let font = parse_type1_pfa(pfa)
  inspect((1.0 / font.font_matrix[0]).round().to_int(), content="2000")
  inspect((1.0 / font.font_matrix[3]).round().to_int(), content="2000")
  inspect(font.units_per_em, content="2000")
}

///|
test "parse_type1_pfa recognizes ExpertEncoding" {
  let pfa : Bytes = b"%!PS-AdobeFont-1.0: ExpertTest 001.000\n" +
    b"/FontName /ExpertTest def\n" +
    b"/FamilyName (Expert Test) readonly def\n" +
    b"/FontType 1 def\n" +
    b"/FontMatrix [0.001 0 0 0.001 0 0] readonly def\n" +
    b"/FontBBox {0 -200 500 800} readonly def\n" +
    b"/Encoding ExpertEncoding def\n"
  let font = parse_type1_pfa(pfa)
  inspect(font.custom_encoding(), content="false")
  inspect(font.expert_encoding(), content="true")
  inspect(font.encoding()[32], content="space")
}

///|
test "parse_type1_pfa recognizes ISOLatin1Encoding" {
  let pfa : Bytes = b"%!PS-AdobeFont-1.0: Latin1Test 001.000\n" +
    b"/FontName /Latin1Test def\n" +
    b"/FamilyName (Latin1 Test) readonly def\n" +
    b"/FontType 1 def\n" +
    b"/FontMatrix [0.001 0 0 0.001 0 0] readonly def\n" +
    b"/FontBBox {0 -200 500 800} readonly def\n" +
    b"/Encoding ISOLatin1Encoding def\n"
  let font = parse_type1_pfa(pfa)
  inspect(font.custom_encoding(), content="false")
  inspect(font.expert_encoding(), content="false")
  inspect(font.latin1_encoding(), content="true")
  inspect(font.encoding()[0xC1], content="Aacute")
}

///|
test "parse_type1_pfa captures Multiple Master metadata" {
  let pfa : Bytes = b"%!PS-AdobeFont-1.0: MinimalMM 001.000\n" +
    b"/FontName /MinimalMM def\n" +
    b"/Encoding StandardEncoding def\n" +
    b"/BlendAxisTypes [ /Weight ] def\n" +
    b"/BlendDesignPositions [ [400] [700] ] def\n" +
    b"/BlendDesignMap [ [ 0 400 1 700 ] ] def\n" +
    b"/WeightVector [0.5 0.5] def\n"
  let font = parse_type1_pfa(pfa)
  inspect(font.multiple_master(), content="true")
  inspect(font.mm_axis_tags().length(), content="1")
  inspect(font.mm_axis_tags()[0], content="2003265652")
  inspect(font.mm_axis_mins().length(), content="1")
  inspect(font.mm_axis_mins()[0].to_int(), content="400")
  inspect(font.mm_axis_defaults()[0].to_int(), content="550")
  inspect(font.mm_axis_maxs()[0].to_int(), content="700")
}

///|
fn encode_type1_test_int(value : Int) -> Bytes {
  let byte_of = fn(n : Int) { n.to_byte() }
  if value >= -107 && value <= 107 {
    Bytes::from_array([byte_of(value + 139)])
  } else if value >= 108 && value <= 1131 {
    let adjusted = value - 108
    Bytes::from_array([byte_of(247 + adjusted / 256), byte_of(adjusted % 256)])
  } else if value >= -1131 && value <= -108 {
    let adjusted = -value - 108
    Bytes::from_array([byte_of(251 + adjusted / 256), byte_of(adjusted % 256)])
  } else {
    Bytes::from_array([
      b'\xFF',
      byte_of((value >> 24) & 0xFF),
      byte_of((value >> 16) & 0xFF),
      byte_of((value >> 8) & 0xFF),
      byte_of(value & 0xFF),
    ])
  }
}

///|
fn concat_type1_test_bytes(chunks : Array[Bytes]) -> Bytes {
  let out : Array[Byte] = []
  for chunk in chunks {
    for byte in chunk {
      out.push(byte)
    }
  }
  Bytes::from_array(out[:])
}

///|
fn encrypt_type1_test_charstring(plaintext : Bytes, len_iv : Int) -> Bytes {
  let mut key : UInt = 4330U
  let out : Array[Byte] = []
  for _ in 0..<len_iv {
    let cipher = (key >> 8).to_byte()
    out.push(cipher)
    key = ((cipher.to_uint() + key) * 52845U + 22719U) & 0xFFFFU
  }
  for byte in plaintext {
    let cipher = (byte.to_uint() ^ (key >> 8)).to_byte()
    out.push(cipher)
    key = ((cipher.to_uint() + key) * 52845U + 22719U) & 0xFFFFU
  }
  Bytes::from_array(out[:])
}

///|
test "load_type1_glyph_full_data applies normalized MM coordinates" {
  let font = Type1Font::new()
  font.multiple_master = true
  font.mm_axis_tags = [@types.make_tag(b'w', b'g', b'h', b't')]
  font.mm_axis_mins = [@fixed.Fixed::from_int(400)]
  font.mm_axis_defaults = [@fixed.Fixed::from_int(550)]
  font.mm_axis_maxs = [@fixed.Fixed::from_int(700)]
  font.mm_design_maps = [
    {
      design_points: [400, 700],
      blend_points: [@fixed.Fixed::from_int(0), @fixed.Fixed::from_int(1)],
    },
  ]
  font.mm_default_weights = [fixed_from_double(0.5), fixed_from_double(0.5)]
  let plain = concat_type1_test_bytes([
    encode_type1_test_int(50),
    encode_type1_test_int(400),
    encode_type1_test_int(200),
    encode_type1_test_int(2),
    encode_type1_test_int(14),
    Bytes::from_array([b'\x0C', b'\x10']),
    Bytes::from_array([b'\x0C', b'\x11']),
    Bytes::from_array([b'\x0D', b'\x0E']),
  ])
  font.charstrings["A"] = encrypt_type1_test_charstring(plain, 4)
  let (_, default_width, _, _) = load_type1_glyph_full_data(font, "A")
  inspect(default_width, content="500")
  let (_, max_width, _, _) = load_type1_glyph_full_data(font, "A", normalized_coords=[
    0x4000,
  ])
  inspect(max_width, content="600")
}
