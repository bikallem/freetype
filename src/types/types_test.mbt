///|
test "make_tag" {
  // 'head' = 0x68656164
  let t = @types.make_tag(b'h', b'e', b'a', b'd')
  inspect(t == @types.tag_head, content="true")
}

///|
test "tag constants" {
  // Verify a few key tags
  inspect(@types.tag_cmap, content="1668112752") // 0x636D6170
  inspect(@types.tag_glyf, content="1735162214") // 0x676C7966
  inspect(@types.tag_wOFF, content="2001684038") // 0x774F4646
}

///|
test "BBox::empty" {
  let bb = @types.BBox::empty()
  inspect(bb, content="{x_min: 0, y_min: 0, x_max: 0, y_max: 0}")
}

///|
test "GlyphMetrics::new" {
  let gm = @types.GlyphMetrics::new()
  inspect(gm.width, content="0")
  inspect(gm.hori_advance, content="0")
}

///|
test "Outline::new" {
  let o = @types.Outline::new()
  inspect(o.n_points(), content="0")
  inspect(o.n_contours(), content="0")
}

///|
test "curve_tag extraction" {
  inspect(@types.curve_tag(@types.curve_tag_on), content="b'\\x01'")
  inspect(@types.curve_tag(@types.curve_tag_cubic), content="b'\\x02'")
  inspect(
    @types.curve_tag(@types.curve_tag_on | @types.curve_tag_touch_x),
    content="b'\\x01'",
  )
}
