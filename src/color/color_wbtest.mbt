///|
fn one_pixel_mask() -> GrayMaskSurface {
  GrayMaskSurface::new(0, 1, 1, 1, b"\xFF")
}

///|
test "BgraSurface::blend_surface: multiply uses composite mode semantics" {
  let backdrop = surface_from_mask(
    one_pixel_mask(),
    @types.Color::new(b'\x00', b'\x00', b'\xFF', b'\xFF'),
  )
  let source = surface_from_mask(
    one_pixel_mask(),
    @types.Color::new(b'\xFF', b'\xFF', b'\x00', b'\xFF'),
  )
  backdrop.blend_surface(source, composite_mode=23)
  let (bitmap, _, _) = backdrop.to_bitmap()
  inspect(bitmap.pixel_mode(), content="Bgra")
  inspect(bitmap.buffer()[0].to_int(), content="0")
  inspect(bitmap.buffer()[1].to_int(), content="0")
  inspect(bitmap.buffer()[2].to_int(), content="0")
  inspect(bitmap.buffer()[3].to_int(), content="255")
}
