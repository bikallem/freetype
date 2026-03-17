///|
/// Blue zone for PostScript hinting.
pub(all) struct BlueZone {
  position : Int64 // reference position (font units)
  overshoot : Int64 // overshoot position
  is_bottom : Bool // true for bottom zones (descender, baseline)
} derive(Eq, Show)

///|
/// Global hinting data for a PostScript font.
pub(all) struct PsGlobals {
  blue_values : Array[BlueZone]
  other_blues : Array[BlueZone]
  blue_scale : @fixed.Fixed
  blue_shift : Int64
  blue_fuzz : Int64
  std_hw : Int64 // standard horizontal stem width
  std_vw : Int64 // standard vertical stem width
  snap_widths_h : Array[Int64] // additional h stem snap widths
  snap_widths_v : Array[Int64] // additional v stem snap widths
} derive(Show)

///|
pub fn PsGlobals::new() -> PsGlobals {
  {
    blue_values: [],
    other_blues: [],
    blue_scale: @fixed.Fixed::from_raw(0x29B7L), // 0.039625 default
    blue_shift: 7L,
    blue_fuzz: 1L,
    std_hw: 0L,
    std_vw: 0L,
    snap_widths_h: [],
    snap_widths_v: [],
  }
}

///|
/// Hint map entry: maps a stem edge to a fitted pixel position.
pub(all) struct HintMapEntry {
  org_pos : Int64 // original position (font units)
  cur_pos : Int64 // fitted position (26.6 pixels)
} derive(Eq, Show)

///|
/// Apply PS hinting to align stem edges to pixel grid.
/// This is a simplified version of the full hinting algorithm.
pub fn align_stem(
  position : Int64,
  width : Int64,
  scale : @fixed.Fixed,
) -> (Int64, Int64) {
  // Scale to 26.6 pixels
  let pos_px = @fixed.mul_fix(scale, @fixed.Fixed::from_raw(position)).val
  let width_px = @fixed.mul_fix(scale, @fixed.Fixed::from_raw(width)).val
  // Round stem width to nearest pixel (minimum 1 pixel = 64 in 26.6)
  let rounded_width = if width_px > 0L {
    let w = (width_px + 32L) & -64L // round to pixel
    if w < 64L {
      64L
    } else {
      w
    } // minimum 1 pixel
  } else {
    width_px
  }
  // Align stem position: round to half-pixel for better centering
  let aligned_pos = (pos_px + 32L) & -64L
  (aligned_pos, rounded_width)
}

///|
/// Apply blue zone alignment to a stem edge.
/// If the position falls within a blue zone, snap it to the zone boundary.
pub fn apply_blue_zone(
  position : Int64,
  zones : Array[BlueZone],
  scale : @fixed.Fixed,
  blue_shift : Int64,
) -> Int64? {
  let pos_scaled = @fixed.mul_fix(scale, @fixed.Fixed::from_raw(position)).val
  for _, zone in zones {
    let ref_scaled = @fixed.mul_fix(
        scale,
        @fixed.Fixed::from_raw(zone.position),
      ).val
    let over_scaled = @fixed.mul_fix(
        scale,
        @fixed.Fixed::from_raw(zone.overshoot),
      ).val
    let zone_lo = if ref_scaled < over_scaled {
      ref_scaled
    } else {
      over_scaled
    }
    let zone_hi = if ref_scaled > over_scaled {
      ref_scaled
    } else {
      over_scaled
    }
    // Check if position is within blue zone (with blue_shift tolerance)
    let tolerance = blue_shift << 6 // convert to 26.6
    if pos_scaled >= zone_lo - tolerance && pos_scaled <= zone_hi + tolerance {
      // Snap to reference position (rounded to pixel)
      let aligned = (ref_scaled + 32L) & -64L
      return Some(aligned)
    }
  }
  None
}
