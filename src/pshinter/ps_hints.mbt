///|
/// Blue zone for PostScript hinting.
#valtype
struct BlueZone {
  bottom : Int64
  top : Int64
  flat : Int64
  is_bottom : Bool // true for bottom zones (descender, baseline)
} derive(Eq, Show)

///|
/// Global hinting data for a PostScript font.
struct PsGlobals {
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
/// A fitted stem: original and pixel-aligned positions.
#valtype
struct FittedStem {
  org_pos : Int64 // original position (font units)
  org_width : Int64 // original width (font units)
  cur_pos : Int64 // fitted position (26.6 pixels)
  cur_width : Int64 // fitted width (26.6 pixels)
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
  let pos_px = @fixed.mul_fix(scale, @fixed.Fixed::from_raw(position)).val()
  let width_px = @fixed.mul_fix(scale, @fixed.Fixed::from_raw(width)).val()
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
  let pos_scaled = @fixed.mul_fix(scale, @fixed.Fixed::from_raw(position)).val()
  for _, zone in zones {
    let zone_lo = @fixed.mul_fix(scale, @fixed.Fixed::from_raw(zone.bottom)).val()
    let zone_hi = @fixed.mul_fix(scale, @fixed.Fixed::from_raw(zone.top)).val()
    let tolerance = blue_shift << 6 // convert to 26.6
    if pos_scaled >= zone_lo - tolerance && pos_scaled <= zone_hi + tolerance {
      let flat_scaled = @fixed.mul_fix(scale, @fixed.Fixed::from_raw(zone.flat)).val()
      let aligned = (flat_scaled + 32L) & -64L
      return Some(aligned)
    }
  }
  None
}

///|
fn pix_round(value : Int64) -> Int64 {
  (value + 32L) & -64L
}

///|
fn snap_stem_side_delta(pos : Int64, len : Int64) -> Int64 {
  let delta1 = pix_round(pos) - pos
  let delta2 = pix_round(pos + len) - pos - len
  if delta1.abs() <= delta2.abs() {
    delta1
  } else {
    delta2
  }
}

///|
fn quantize_stem_length(len : Int64, std_width : Int64) -> Int64 {
  if len <= 64L {
    return 64L
  }
  let mut result = len
  if std_width > 0L {
    let mut delta = result - std_width
    if delta < 0L {
      delta = -delta
    }
    if delta < 40L {
      result = if std_width < 48L { 48L } else { std_width }
    }
  }
  if result < 192L {
    let delta = result & 63L
    result = result & -64L
    if delta < 10L {
      result += delta
    } else if delta < 32L {
      result += 10L
    } else if delta < 54L {
      result += 54L
    } else {
      result += delta
    }
    return result
  }
  pix_round(result)
}

///|
fn fit_blue_zone_edge(
  position : Int64,
  zones : Array[BlueZone],
  globals : PsGlobals,
  scale : @fixed.Fixed,
  top_edge : Bool,
) -> Int64? {
  ignore(top_edge)
  for _, zone in zones {
    if position < zone.bottom - globals.blue_fuzz() ||
      position > zone.top + globals.blue_fuzz() {
      continue
    }
    return Some(
      pix_round(@fixed.mul_fix(scale, @fixed.Fixed::from_raw(zone.top)).val()),
    )
  }
  None
}

///|
/// Build PsGlobals from raw Private dict values.
/// Blue values come in pairs: (reference, overshoot).
/// The first pair in blue_values is the baseline zone (bottom zone);
/// subsequent pairs are top zones. other_blues are all bottom zones.
pub fn build_ps_globals(
  blue_values : Array[Int],
  other_blues : Array[Int],
  std_hw : Int,
  std_vw : Int,
  blue_scale : @fixed.Fixed,
  blue_shift : Int,
  blue_fuzz : Int,
) -> PsGlobals {
  let bv : Array[BlueZone] = []
  // Match FreeType's PS blue-zone interpretation:
  // the first BlueValues pair is a bottom zone whose flat edge is the second
  // value; subsequent BlueValues pairs are top zones whose flat edge is the
  // first value. OtherBlues are always bottom zones with the second value as
  // the flat edge.
  for i = 0; i + 1 < blue_values.length(); {
    let v0 = blue_values[i].to_int64()
    let v1 = blue_values[i + 1].to_int64()
    let bottom = if v0 < v1 { v0 } else { v1 }
    let top = if v0 > v1 { v0 } else { v1 }
    let is_bottom = i == 0
    let flat = if is_bottom { v1 } else { v0 }
    bv.push({ bottom, top, flat, is_bottom })
    continue i + 2
  }
  let ob : Array[BlueZone] = []
  for i = 0; i + 1 < other_blues.length(); {
    let v0 = other_blues[i].to_int64()
    let v1 = other_blues[i + 1].to_int64()
    ob.push({
      bottom: if v0 < v1 {
        v0
      } else {
        v1
      },
      top: if v0 > v1 {
        v0
      } else {
        v1
      },
      flat: v1,
      is_bottom: true,
    })
    continue i + 2
  }
  {
    blue_values: bv,
    other_blues: ob,
    blue_scale,
    blue_shift: blue_shift.to_int64(),
    blue_fuzz: blue_fuzz.to_int64(),
    std_hw: std_hw.to_int64(),
    std_vw: std_vw.to_int64(),
    snap_widths_h: [],
    snap_widths_v: [],
  }
}

///|
/// Fit stem hints to the pixel grid.
/// For each stem, scale to pixels, round width, apply blue zones or grid-snap.
pub fn fit_stems(
  stems : Array[@psaux.StemHint],
  globals : PsGlobals,
  scale : @fixed.Fixed,
  is_horizontal : Bool,
) -> Array[FittedStem] {
  let result : Array[FittedStem] = []
  let zones = if is_horizontal {
    // Horizontal stems are affected by blue zones
    let all : Array[BlueZone] = []
    for z in globals.blue_values {
      all.push(z)
    }
    for z in globals.other_blues {
      all.push(z)
    }
    all
  } else {
    []
  }
  for _, stem in stems {
    let mut org_pos = stem.position()
    let mut org_width = stem.width()
    if org_width < 0L {
      org_pos += org_width
      org_width = -org_width
    }
    // Scale position and width to 26.6 pixels
    let pos_px = @fixed.mul_fix(scale, @fixed.Fixed::from_raw(org_pos)).val()
    let width_px = @fixed.mul_fix(scale, @fixed.Fixed::from_raw(org_width)).val()
    let std_width = if is_horizontal {
      let scaled = @fixed.mul_fix(
        scale,
        @fixed.Fixed::from_raw(globals.std_hw()),
      ).val()
      if scaled < 0L {
        -scaled
      } else {
        scaled
      }
    } else {
      let scaled = @fixed.mul_fix(
        scale,
        @fixed.Fixed::from_raw(globals.std_vw()),
      ).val()
      if scaled < 0L {
        -scaled
      } else {
        scaled
      }
    }
    let mut cur_width = quantize_stem_length(
      if width_px < 0L {
        -width_px
      } else {
        width_px
      },
      std_width,
    )
    let mut cur_pos = pos_px + snap_stem_side_delta(pos_px, cur_width)
    if is_horizontal && !zones.is_empty() {
      let bottom_aligned = fit_blue_zone_edge(
        org_pos, zones, globals, scale, false,
      )
      let top_aligned = fit_blue_zone_edge(
        org_pos + org_width,
        zones,
        globals,
        scale,
        true,
      )
      match (bottom_aligned, top_aligned) {
        (Some(bot), Some(top)) => {
          cur_pos = bot
          cur_width = top - bot
        }
        (Some(bot), None) => cur_pos = bot
        (None, Some(top)) => cur_pos = top - cur_width
        (None, None) => ()
      }
    }
    result.push({ org_pos, org_width, cur_pos, cur_width })
  }
  result
}

///|
/// Interpolate outline points based on fitted stems.
/// For each point, find bracketing stems and interpolate, or shift by
/// nearest stem delta if outside all stems.
pub fn interpolate_points(
  outline : @types.Outline,
  h_stems : Array[FittedStem],
  v_stems : Array[FittedStem],
  scale : @fixed.Fixed,
) -> Unit {
  for i in 0..<outline.n_points() {
    let p = outline.points()[i]
    let new_x = interpolate_coord(p.x(), v_stems, scale)
    let new_y = interpolate_coord(p.y(), h_stems, scale)
    outline.points()[i] = @types.Vector::new(new_x, new_y)
  }
}

///|
/// Interpolate a single coordinate value based on fitted stems.
/// The coordinate is in font units; we find bracketing stems and
/// interpolate between their original and fitted positions.
fn interpolate_coord(
  org_coord : Int64,
  fitted : Array[FittedStem],
  scale : @fixed.Fixed,
) -> Int64 {
  // Find two nearest stems bracketing this coordinate.
  // Each stem has two edges: pos and pos+width.
  // Build a list of edges sorted by original position.
  let edges : Array[(Int64, Int64)] = [] // (org, cur) pairs
  for _, s in fitted {
    edges.push((s.org_pos, s.cur_pos))
    edges.push((s.org_pos + s.org_width, s.cur_pos + s.cur_width))
  }
  // Sort edges by original position
  edges.sort_by(fn(a, b) { a.0.compare(b.0) })
  // Find bracketing edges
  let mut below_org = 0L
  let mut below_cur = 0L
  let mut above_org = 0L
  let mut above_cur = 0L
  let mut found_below = false
  let mut found_above = false
  for _, edge in edges {
    let (eorg, ecur) = edge
    if eorg <= org_coord {
      below_org = eorg
      below_cur = ecur
      found_below = true
    }
    if eorg >= org_coord && !found_above {
      above_org = eorg
      above_cur = ecur
      found_above = true
    }
  }
  if found_below && found_above {
    if above_org == below_org {
      // Point is exactly on an edge
      return below_cur
    }
    // Interpolate between the two edges
    let org_range = above_org - below_org
    let cur_range = above_cur - below_cur
    let delta = org_coord - below_org
    return below_cur + delta * cur_range / org_range
  }
  if found_below {
    // Point is above all stem edges: shift by the nearest stem's delta
    let delta = below_cur -
      @fixed.mul_fix(scale, @fixed.Fixed::from_raw(below_org)).val()
    return @fixed.mul_fix(scale, @fixed.Fixed::from_raw(org_coord)).val() +
      delta
  }
  if found_above {
    // Point is below all stem edges: shift by the nearest stem's delta
    let delta = above_cur -
      @fixed.mul_fix(scale, @fixed.Fixed::from_raw(above_org)).val()
    return @fixed.mul_fix(scale, @fixed.Fixed::from_raw(org_coord)).val() +
      delta
  }
  // No stems at all: just scale
  @fixed.mul_fix(scale, @fixed.Fixed::from_raw(org_coord)).val()
}

///|
/// Main PostScript hinting entry point.
/// Fits horizontal and vertical stems, then interpolates all outline points.
pub fn hint_outline(
  outline : @types.Outline,
  h_hints : Array[@psaux.StemHint],
  v_hints : Array[@psaux.StemHint],
  globals : PsGlobals,
  scale : @fixed.Fixed,
) -> Unit {
  // Fit horizontal stems (affected by blue zones)
  let h_fitted = fit_stems(h_hints, globals, scale, true)
  // Fit vertical stems (grid-snapped only)
  let v_fitted = fit_stems(v_hints, globals, scale, false)
  // Interpolate all outline points based on fitted stems
  interpolate_points(outline, h_fitted, v_fitted, scale)
}

///|
pub fn PsGlobals::blue_values(self : PsGlobals) -> Array[BlueZone] {
  self.blue_values
}

///|
pub fn PsGlobals::other_blues(self : PsGlobals) -> Array[BlueZone] {
  self.other_blues
}

///|
pub fn PsGlobals::blue_scale(self : PsGlobals) -> @fixed.Fixed {
  self.blue_scale
}

///|
pub fn PsGlobals::blue_shift(self : PsGlobals) -> Int64 {
  self.blue_shift
}

///|
pub fn PsGlobals::blue_fuzz(self : PsGlobals) -> Int64 {
  self.blue_fuzz
}

///|
pub fn PsGlobals::std_hw(self : PsGlobals) -> Int64 {
  self.std_hw
}

///|
pub fn PsGlobals::std_vw(self : PsGlobals) -> Int64 {
  self.std_vw
}
