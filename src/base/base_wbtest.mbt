///|
test "Encoding roundtrip" {
  inspect(Encoding::from_tag(0x756E6963U), content="Unicode")
  inspect(Encoding::from_tag(Encoding::Unicode.to_tag()), content="Unicode")
  inspect(Encoding::from_tag(0xDEADBEEFU), content="None")
}

///|
test "FaceRec::new defaults" {
  let face = FaceRec::new()
  inspect(face.num_faces, content="1")
  inspect(face.face_index, content="0")
  inspect(face.num_glyphs, content="0")
  inspect(face.family_name, content="")
  inspect(face.active_charmap, content="-1")
}

///|
test "FaceRec flag helpers" {
  let face = FaceRec::new()
  face.set_face_flags(face_flag_scalable | face_flag_kerning)
  inspect(face.is_scalable(), content="true")
  inspect(face.has_kerning(), content="true")
  inspect(face.is_fixed_width(), content="false")
  inspect(face.has_color(), content="false")
}

///|
test "GlyphSlot::new" {
  let slot = GlyphSlot::new()
  inspect(slot.glyph_index, content="0")
  inspect(slot.format, content="None")
}

///|
test "detect_format: TrueType" {
  let data : Bytes = [0x00, 0x01, 0x00, 0x00]
  inspect(detect_format(data), content="TrueType")
}

///|
test "detect_format: OTTO" {
  let data : Bytes = [b'O', b'T', b'T', b'O']
  inspect(detect_format(data), content="CffOpenType")
}

///|
test "detect_format: ttcf" {
  let data : Bytes = [b't', b't', b'c', b'f']
  inspect(detect_format(data), content="TrueTypeCollection")
}

///|
test "detect_format: wOFF" {
  let data : Bytes = [b'w', b'O', b'F', b'F']
  inspect(detect_format(data), content="Woff1")
}

///|
test "detect_format: PFB" {
  let data : Bytes = [0x80, 0x01, 0x00, 0x00]
  inspect(detect_format(data), content="Type1Pfb")
}

///|
test "detect_format: BDF" {
  let data : Bytes = [b'S', b'T', b'A', b'R']
  inspect(detect_format(data), content="Bdf")
}

///|
test "detect_format: PCF" {
  let data : Bytes = [0x01, 0x66, 0x63, 0x70]
  inspect(detect_format(data), content="Pcf")
}

///|
test "detect_format: MZ (Windows FNT)" {
  let data : Bytes = [b'M', b'Z', 0x00, 0x00]
  inspect(detect_format(data), content="WindowsFnt")
}

///|
test "detect_format: unknown" {
  let data : Bytes = [0xFF, 0xFF, 0xFF, 0xFF]
  inspect(detect_format(data), content="Unknown")
}

///|
test "detect_format: too short" {
  let data : Bytes = [0x00, 0x01]
  inspect(detect_format(data), content="Unknown")
}

///|
test "GlyphLoader: add_point and end_contour" {
  let loader = GlyphLoader::new()
  loader.add_point(100L, 200L, @types.curve_tag_on)
  loader.add_point(300L, 400L, @types.curve_tag_on)
  loader.add_point(500L, 100L, @types.curve_tag_on)
  loader.end_contour()
  inspect(loader.current_points.length(), content="3")
  inspect(loader.current_contours.length(), content="1")
}

///|
test "GlyphLoader: add merges current into base" {
  let loader = GlyphLoader::new()
  // First sub-glyph
  loader.add_point(10L, 20L, @types.curve_tag_on)
  loader.add_point(30L, 40L, @types.curve_tag_on)
  loader.end_contour()
  loader.add()
  inspect(loader.base_n_points(), content="2")
  inspect(loader.base_n_contours(), content="1")
  //
  // Second sub-glyph
  loader.add_point(50L, 60L, @types.curve_tag_on)
  loader.add_point(70L, 80L, @types.curve_tag_on)
  loader.add_point(90L, 100L, @types.curve_tag_on)
  loader.end_contour()
  loader.add()
  inspect(loader.base_n_points(), content="5")
  inspect(loader.base_n_contours(), content="2")
  //
  // Verify contour indices are adjusted
  let outline = loader.to_outline()
  inspect(outline.contours()[0].reinterpret_as_int(), content="1")
  // second contour end = 2 (original) + 2 (base offset) = 4
  inspect(outline.contours()[1].reinterpret_as_int(), content="4")
}

///|
test "GlyphLoader: reset" {
  let loader = GlyphLoader::new()
  loader.add_point(10L, 20L, @types.curve_tag_on)
  loader.end_contour()
  loader.add()
  loader.reset()
  inspect(loader.base_n_points(), content="0")
  inspect(loader.base_n_contours(), content="0")
}

///|
test "outline_translate" {
  let outline = @types.Outline::new()
  outline.points().push(@types.Vector::new(10L, 20L))
  outline.points().push(@types.Vector::new(30L, 40L))
  outline.tags().push(@types.curve_tag_on)
  outline.tags().push(@types.curve_tag_on)
  outline.contours().push(1U)
  outline_translate(outline, 100L, -10L)
  inspect(outline.points()[0].x(), content="110")
  inspect(outline.points()[0].y(), content="10")
  inspect(outline.points()[1].x(), content="130")
  inspect(outline.points()[1].y(), content="30")
}

///|
test "outline_transform with identity" {
  let outline = @types.Outline::new()
  outline.points().push(@types.Vector::new(100L, 200L))
  outline.tags().push(@types.curve_tag_on)
  outline.contours().push(0U)
  outline_transform(outline, @fixed.Matrix::identity())
  // Should be unchanged (within fixed-point precision)
  inspect(outline.points()[0].x(), content="100")
  inspect(outline.points()[0].y(), content="200")
}

///|
test "outline_reverse: triangle" {
  let outline = @types.Outline::new()
  outline.points().push(@types.Vector::new(0L, 0L))
  outline.points().push(@types.Vector::new(100L, 0L))
  outline.points().push(@types.Vector::new(50L, 100L))
  outline.tags().push(@types.curve_tag_on)
  outline.tags().push(@types.curve_tag_on)
  outline.tags().push(@types.curve_tag_on)
  outline.contours().push(2U)
  outline_reverse(outline)
  // Points should be reversed: (50,100), (100,0), (0,0)
  inspect(outline.points()[0].x(), content="50")
  inspect(outline.points()[0].y(), content="100")
  inspect(outline.points()[2].x(), content="0")
  inspect(outline.points()[2].y(), content="0")
}

///|
test "outline_get_orientation: clockwise triangle" {
  let outline = @types.Outline::new()
  // Clockwise triangle (positive signed area)
  outline.points().push(@types.Vector::new(0L, 0L))
  outline.points().push(@types.Vector::new(100L, 0L))
  outline.points().push(@types.Vector::new(50L, 100L))
  outline.tags().push(@types.curve_tag_on)
  outline.tags().push(@types.curve_tag_on)
  outline.tags().push(@types.curve_tag_on)
  outline.contours().push(2U)
  let orient = outline_get_orientation(outline)
  // Orientation depends on coordinate system convention
  inspect(orient != 0, content="true")
}

///|
test "outline_get_bbox: simple" {
  let outline = @types.Outline::new()
  outline.points().push(@types.Vector::new(-10L, 5L))
  outline.points().push(@types.Vector::new(100L, -20L))
  outline.points().push(@types.Vector::new(50L, 200L))
  outline.tags().push(@types.curve_tag_on)
  outline.tags().push(@types.curve_tag_on)
  outline.tags().push(@types.curve_tag_on)
  outline.contours().push(2U)
  let bb = outline_get_bbox(outline)
  inspect(bb.x_min(), content="-10")
  inspect(bb.y_min(), content="-20")
  inspect(bb.x_max(), content="100")
  inspect(bb.y_max(), content="200")
}

///|
test "outline_get_cbox: includes off-curve" {
  let outline = @types.Outline::new()
  outline.points().push(@types.Vector::new(0L, 0L))
  outline.points().push(@types.Vector::new(500L, 500L)) // off-curve control
  outline.points().push(@types.Vector::new(100L, 0L))
  outline.tags().push(@types.curve_tag_on)
  outline.tags().push(@types.curve_tag_conic)
  outline.tags().push(@types.curve_tag_on)
  outline.contours().push(2U)
  let cb = outline_get_cbox(outline)
  inspect(cb.x_max(), content="500")
  inspect(cb.y_max(), content="500")
}

///|
test "outline_decompose: simple triangle" {
  let outline = @types.Outline::new()
  outline.points().push(@types.Vector::new(0L, 0L))
  outline.points().push(@types.Vector::new(100L, 0L))
  outline.points().push(@types.Vector::new(50L, 100L))
  outline.tags().push(@types.curve_tag_on)
  outline.tags().push(@types.curve_tag_on)
  outline.tags().push(@types.curve_tag_on)
  outline.contours().push(2U)
  let log : Array[String] = []
  let funcs = OutlineFuncs::new(
    move_to=fn(p) { log.push("M(\{p.x()},\{p.y()})") },
    line_to=fn(p) { log.push("L(\{p.x()},\{p.y()})") },
    conic_to=fn(c, p) { log.push("Q(\{c.x()},\{c.y()},\{p.x()},\{p.y()})") },
    cubic_to=fn(c1, c2, p) {
      log.push("C(\{c1.x()},\{c1.y()},\{c2.x()},\{c2.y()},\{p.x()},\{p.y()})")
    },
  )
  outline_decompose(outline, funcs)
  inspect(log[0], content="M(0,0)")
  inspect(log[1], content="L(100,0)")
  inspect(log[2], content="L(50,100)")
}
