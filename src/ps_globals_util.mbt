///|
fn fixed_from_double(value : Double) -> @fixed.Fixed {
  @fixed.Fixed::from_raw((value * 65536.0).round().to_int64())
}

///|
fn build_ps_globals_from_cff_private(
  private_dict : @cff.CffPrivateDict,
) -> @pshinter.PsGlobals {
  let defaults = @pshinter.PsGlobals::new()
  @pshinter.build_ps_globals(
    private_dict.blue_values().map(fn(v) { v.to_int() }),
    private_dict.other_blues().map(fn(v) { v.to_int() }),
    private_dict.std_hw().to_int(),
    private_dict.std_vw().to_int(),
    match private_dict.blue_scale() {
      Some(value) => fixed_from_double(value)
      None => defaults.blue_scale()
    },
    private_dict.blue_shift().unwrap_or(defaults.blue_shift().to_int()),
    private_dict.blue_fuzz().unwrap_or(defaults.blue_fuzz().to_int()),
  )
}
