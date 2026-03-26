///|
let cff_expert_charset : FixedArray[UInt] = [
  0U, 1U, 229U, 230U, 231U, 232U, 233U, 234U, 235U, 236U, 237U, 238U, 13U, 14U, 15U,
  99U, 239U, 240U, 241U, 242U, 243U, 244U, 245U, 246U, 247U, 248U, 27U, 28U, 249U,
  250U, 251U, 252U, 253U, 254U, 255U, 256U, 257U, 258U, 259U, 260U, 261U, 262U, 263U,
  264U, 265U, 266U, 109U, 110U, 267U, 268U, 269U, 270U, 271U, 272U, 273U, 274U, 275U,
  276U, 277U, 278U, 279U, 280U, 281U, 282U, 283U, 284U, 285U, 286U, 287U, 288U, 289U,
  290U, 291U, 292U, 293U, 294U, 295U, 296U, 297U, 298U, 299U, 300U, 301U, 302U, 303U,
  304U, 305U, 306U, 307U, 308U, 309U, 310U, 311U, 312U, 313U, 314U, 315U, 316U, 317U,
  318U, 158U, 155U, 163U, 319U, 320U, 321U, 322U, 323U, 324U, 325U, 326U, 150U, 164U,
  169U, 327U, 328U, 329U, 330U, 331U, 332U, 333U, 334U, 335U, 336U, 337U, 338U, 339U,
  340U, 341U, 342U, 343U, 344U, 345U, 346U, 347U, 348U, 349U, 350U, 351U, 352U, 353U,
  354U, 355U, 356U, 357U, 358U, 359U, 360U, 361U, 362U, 363U, 364U, 365U, 366U, 367U,
  368U, 369U, 370U, 371U, 372U, 373U, 374U, 375U, 376U, 377U, 378U,
]

///|
let cff_expertsubset_charset : FixedArray[UInt] = [
  0U, 1U, 231U, 232U, 235U, 236U, 237U, 238U, 13U, 14U, 15U, 99U, 239U, 240U, 241U,
  242U, 243U, 244U, 245U, 246U, 247U, 248U, 27U, 28U, 249U, 250U, 251U, 253U, 254U,
  255U, 256U, 257U, 258U, 259U, 260U, 261U, 262U, 263U, 264U, 265U, 266U, 109U, 110U,
  267U, 268U, 269U, 270U, 272U, 300U, 301U, 302U, 305U, 314U, 315U, 158U, 155U, 163U,
  320U, 321U, 322U, 323U, 324U, 325U, 326U, 150U, 164U, 169U, 327U, 328U, 329U, 330U,
  331U, 332U, 333U, 334U, 335U, 336U, 337U, 338U, 339U, 340U, 341U, 342U, 343U, 344U,
  345U, 346U,
]

///|
fn decode_cff_string_bytes(data : Bytes) -> String {
  let buf = StringBuilder::new()
  for _, b in data {
    buf.write_char(Int::unsafe_to_char(b.to_int()))
  }
  buf.to_string()
}

///|
fn parse_cff_string_index(index : CffIndex) -> Array[String] {
  let strings : Array[String] = []
  for i in 0..<index.count.reinterpret_as_int() {
    strings.push(decode_cff_string_bytes(index.get_item(i)))
  }
  strings
}

///|
fn sid_to_string(sid : UInt, custom_strings : Array[String]) -> String {
  match @psnames.standard_string(sid) {
    Some(name) => name
    None => {
      let idx = sid.reinterpret_as_int() - 391
      if idx >= 0 && idx < custom_strings.length() {
        custom_strings[idx]
      } else {
        ""
      }
    }
  }
}

///|
fn build_sid_to_glyph_map(glyph_sids : Array[UInt]) -> Map[UInt, UInt] {
  let sid_to_glyph : Map[UInt, UInt] = {}
  for i, sid in glyph_sids {
    sid_to_glyph[sid] = i.reinterpret_as_uint()
  }
  sid_to_glyph
}

///|
fn parse_cff_charset(
  reader : @stream.ByteReader,
  base_offset : Int,
  charset_offset : UInt,
  num_glyphs : UInt,
) -> Array[UInt] raise @error.FTError {
  let glyph_count = num_glyphs.reinterpret_as_int()
  let glyph_sids : Array[UInt] = Array::make(glyph_count, 0U)
  if glyph_count == 0 {
    return glyph_sids
  }
  match charset_offset {
    0U => {
      if glyph_count > 229 {
        raise @error.FTError::InvalidTable
      }
      for i in 0..<glyph_count {
        glyph_sids[i] = i.reinterpret_as_uint()
      }
      glyph_sids
    }
    1U => {
      if glyph_count > cff_expert_charset.length() {
        raise @error.FTError::InvalidTable
      }
      for i in 0..<glyph_count {
        glyph_sids[i] = cff_expert_charset[i]
      }
      glyph_sids
    }
    2U => {
      if glyph_count > cff_expertsubset_charset.length() {
        raise @error.FTError::InvalidTable
      }
      for i in 0..<glyph_count {
        glyph_sids[i] = cff_expertsubset_charset[i]
      }
      glyph_sids
    }
    _ => {
      reader.seek(base_offset + charset_offset.reinterpret_as_int())
      let format = reader.read_byte().to_int()
      glyph_sids[0] = 0U
      match format {
        0 =>
          for j in 1..<glyph_count {
            glyph_sids[j] = reader.read_u16_be()
          }
        1 | 2 => {
          let mut j = 1
          while j < glyph_count {
            let mut glyph_sid = reader.read_u16_be().reinterpret_as_int()
            let n_left = if format == 2 {
              reader.read_u16_be().reinterpret_as_int()
            } else {
              reader.read_byte().to_int()
            }
            for i in 0..<=n_left {
              if j >= glyph_count {
                break
              }
              glyph_sids[j] = glyph_sid.reinterpret_as_uint()
              j += 1
              glyph_sid += 1
              if i == n_left {
                break
              }
            }
          }
        }
        _ => raise @error.FTError::InvalidTable
      }
      glyph_sids
    }
  }
}

///|
fn parse_cff_encoding(
  reader : @stream.ByteReader,
  base_offset : Int,
  encoding_offset : UInt,
  glyph_sids : Array[UInt],
) -> Array[UInt] raise @error.FTError {
  let encoding_glyphs : Array[UInt] = Array::make(256, 0U)
  if glyph_sids.length() == 0 {
    return encoding_glyphs
  }
  let sid_to_glyph = build_sid_to_glyph_map(glyph_sids)
  match encoding_offset {
    0U => {
      for code in 0..<256 {
        let sid = @psnames.standard_encoding_sid(code.reinterpret_as_uint())
        if sid > 0 {
          match sid_to_glyph.get(sid.reinterpret_as_uint()) {
            Some(glyph) => encoding_glyphs[code] = glyph
            None => ()
          }
        }
      }
      encoding_glyphs
    }
    1U => {
      for code in 0..<256 {
        let sid = @psnames.expert_encoding_sid(code.reinterpret_as_uint())
        if sid > 0 {
          match sid_to_glyph.get(sid.reinterpret_as_uint()) {
            Some(glyph) => encoding_glyphs[code] = glyph
            None => ()
          }
        }
      }
      encoding_glyphs
    }
    _ => {
      reader.seek(base_offset + encoding_offset.reinterpret_as_int())
      let format = reader.read_byte().to_int()
      let base_format = format & 0x7F
      let has_supplements = (format & 0x80) != 0
      match base_format {
        0 => {
          let n_codes = reader.read_byte().to_int()
          for i in 0..<n_codes {
            let code = reader.read_byte().to_int()
            let glyph_index = i + 1
            if code >= 0 && code < 256 && glyph_index < glyph_sids.length() {
              encoding_glyphs[code] = glyph_index.reinterpret_as_uint()
            }
          }
        }
        1 => {
          let n_ranges = reader.read_byte().to_int()
          let mut glyph_index = 1
          for _ in 0..<n_ranges {
            let first = reader.read_byte().to_int()
            let n_left = reader.read_byte().to_int()
            for i in 0..<=n_left {
              let code = first + i
              if code >= 0 &&
                code < 256 &&
                glyph_index >= 0 &&
                glyph_index < glyph_sids.length() {
                encoding_glyphs[code] = glyph_index.reinterpret_as_uint()
              }
              glyph_index += 1
              if i == n_left {
                break
              }
            }
          }
        }
        _ => raise @error.FTError::InvalidTable
      }
      if has_supplements {
        let n_supplements = reader.read_byte().to_int()
        for _ in 0..<n_supplements {
          let code = reader.read_byte().to_int()
          let sid = reader.read_u16_be()
          if code >= 0 && code < 256 {
            match sid_to_glyph.get(sid) {
              Some(glyph) => encoding_glyphs[code] = glyph
              None => ()
            }
          }
        }
      }
      encoding_glyphs
    }
  }
}
