///|
fn load_mvar_ttf() -> Bytes {
  try! @fs.read_file_to_bytes("test/fonts/mvar.ttf")
}

///|
test "MVAR: face metrics update with variation coordinates" {
  let f = @freetype.from_bytes(load_mvar_ttf())
  inspect(f.has_multiple_masters(), content="true")
  inspect((f.face_flags() & @base.FACE_FLAG_VARIATION) != 0L, content="false")
  inspect(f.ascender(), content="800")
  inspect(f.descender(), content="-200")
  inspect(f.height(), content="1000")
  inspect(f.underline_position(), content="-125")
  inspect(f.underline_thickness(), content="50")

  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)
  guard r1 is Ok(_) else { return }
  inspect(f.size().metrics().ascender(), content="819")
  inspect(f.size().metrics().descender(), content="-205")
  inspect(f.size().metrics().height(), content="1024")

  let wght = 0x77676874U
  let r2 = try? @freetype.set_var_design_coordinates(f, [
    (@fixed.Fixed::from_int(900), wght),
  ])
  guard r2 is Ok(_) else { return }
  inspect((f.face_flags() & @base.FACE_FLAG_VARIATION) != 0L, content="true")
  inspect(f.ascender(), content="850")
  inspect(f.descender(), content="-220")
  inspect(f.height(), content="1100")
  inspect(f.underline_position(), content="-139")
  inspect(f.underline_thickness(), content="58")
  inspect(f.size().metrics().ascender(), content="870")
  inspect(f.size().metrics().descender(), content="-225")
  inspect(f.size().metrics().height(), content="1126")

  let r3 = try? @freetype.set_var_design_coordinates(f, [
    (@fixed.Fixed::from_int(400), wght),
  ])
  guard r3 is Ok(_) else { return }
  inspect((f.face_flags() & @base.FACE_FLAG_VARIATION) != 0L, content="false")
  inspect(f.ascender(), content="800")
  inspect(f.descender(), content="-200")
  inspect(f.height(), content="1000")
  inspect(f.underline_position(), content="-125")
  inspect(f.underline_thickness(), content="50")
  inspect(f.size().metrics().ascender(), content="819")
  inspect(f.size().metrics().descender(), content="-205")
  inspect(f.size().metrics().height(), content="1024")
}
