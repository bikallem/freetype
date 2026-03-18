///|
/// 16.16 fixed-point number. Wraps Int64 to avoid overflow in intermediate
/// computations (C FreeType relies on two's-complement wrapping of 32-bit
/// `signed long`; we use 64-bit and mask/truncate where needed).
pub struct Fixed {
  val : Int64
} derive(Eq, Compare, Show)

///|
/// 26.6 fixed-point number (used for pixel coordinates).
pub struct F26Dot6 {
  val : Int64
} derive(Eq, Compare, Show)

///|
/// 2.14 fixed-point number (used for unit vectors).
pub struct F2Dot14 {
  val : Int
} derive(Eq, Compare, Show)

// ---------------------------------------------------------------------------
// Fixed (16.16) constants and constructors
// ---------------------------------------------------------------------------

///|
pub fn Fixed::from_int(v : Int) -> Fixed {
  { val: v.to_int64() << 16 }
}

///|
pub fn Fixed::from_raw(v : Int64) -> Fixed {
  { val: v }
}

///|
pub fn Fixed::zero() -> Fixed {
  { val: 0L }
}

///|
pub fn Fixed::one() -> Fixed {
  { val: 0x10000L }
}

///|
/// Extract integer part (truncate toward zero).
pub fn Fixed::to_int(self : Fixed) -> Int {
  (self.val >> 16).to_int()
}

///|
/// Extract raw 16.16 value.
pub fn Fixed::to_raw(self : Fixed) -> Int64 {
  self.val
}

///|
/// Round to nearest integer (16.16 → integer).
pub fn Fixed::round(self : Fixed) -> Fixed {
  let v = self.val
  let bias = if v < 0L { 0x7FFFL } else { 0x8000L }
  { val: (v + bias) & 0xFFFF_FFFF_FFFF_0000L }
}

///|
/// Ceil (round up toward +∞).
pub fn Fixed::ceil(self : Fixed) -> Fixed {
  { val: (self.val + 0xFFFFL) & 0xFFFF_FFFF_FFFF_0000L }
}

///|
/// Floor (round down toward −∞).
pub fn Fixed::floor(self : Fixed) -> Fixed {
  { val: self.val & 0xFFFF_FFFF_FFFF_0000L }
}

// ---------------------------------------------------------------------------
// Fixed arithmetic operators (trait implementations)
// ---------------------------------------------------------------------------

///|
pub impl Add for Fixed with add(a, b) -> Fixed {
  { val: a.val + b.val }
}

///|
pub impl Sub for Fixed with sub(a, b) -> Fixed {
  { val: a.val - b.val }
}

///|
pub impl Neg for Fixed with neg(self) -> Fixed {
  { val: -self.val }
}

// ---------------------------------------------------------------------------
// F26Dot6 constants and constructors
// ---------------------------------------------------------------------------

///|
pub fn F26Dot6::from_int(v : Int) -> F26Dot6 {
  { val: v.to_int64() << 6 }
}

///|
pub fn F26Dot6::from_raw(v : Int64) -> F26Dot6 {
  { val: v }
}

///|
pub fn F26Dot6::from_pixels(pixels : Int) -> F26Dot6 {
  { val: pixels.to_int64() << 6 }
}

///|
pub fn F26Dot6::zero() -> F26Dot6 {
  { val: 0L }
}

///|
pub fn F26Dot6::to_int(self : F26Dot6) -> Int {
  (self.val >> 6).to_int()
}

///|
pub fn F26Dot6::to_raw(self : F26Dot6) -> Int64 {
  self.val
}

///|
/// Round to nearest integer (26.6 → integer).
pub fn F26Dot6::round(self : F26Dot6) -> F26Dot6 {
  let v = self.val
  let bias = if v < 0L { 31L } else { 32L }
  { val: (v + bias) & -64L }
}

///|
pub fn F26Dot6::ceil(self : F26Dot6) -> F26Dot6 {
  { val: (self.val + 63L) & -64L }
}

///|
pub fn F26Dot6::floor(self : F26Dot6) -> F26Dot6 {
  { val: self.val & -64L }
}

// ---------------------------------------------------------------------------
// F26Dot6 arithmetic operators (trait implementations)
// ---------------------------------------------------------------------------

///|
pub impl Add for F26Dot6 with add(a, b) -> F26Dot6 {
  { val: a.val + b.val }
}

///|
pub impl Sub for F26Dot6 with sub(a, b) -> F26Dot6 {
  { val: a.val - b.val }
}

///|
pub impl Neg for F26Dot6 with neg(self) -> F26Dot6 {
  { val: -self.val }
}

// ---------------------------------------------------------------------------
// F2Dot14 constants and constructors
// ---------------------------------------------------------------------------

///|
pub fn F2Dot14::from_raw(v : Int) -> F2Dot14 {
  { val: v }
}

///|
pub fn F2Dot14::zero() -> F2Dot14 {
  { val: 0 }
}

///|
pub fn F2Dot14::one() -> F2Dot14 {
  { val: 0x4000 }
}

///|
pub fn F2Dot14::to_raw(self : F2Dot14) -> Int {
  self.val
}

///|
/// Convert F2Dot14 to Fixed (16.16). Simply left-shift by 2.
pub fn F2Dot14::to_fixed(self : F2Dot14) -> Fixed {
  { val: self.val.to_int64() << 2 }
}
