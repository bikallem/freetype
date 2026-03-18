///|
/// Convert bytes (ASCII/Latin-1) to String by treating each byte as a char.
pub fn bytes_to_ascii(data : Bytes) -> String {
  let buf = StringBuilder::new()
  for _, b in data {
    buf.write_char(Int::unsafe_to_char(b.to_int()))
  }
  buf.to_string()
}

///|
/// Parse an integer from a string, returning 0 on failure.
/// Handles optional leading '-' or '+' sign and stops at the first non-digit.
pub fn parse_int_from_string(s : String) -> Int {
  let mut result = 0
  let mut negative = false
  let len = s.length()
  let mut i = 0
  if len > 0 && s[0] == '-' {
    negative = true
    i = 1
  } else if len > 0 && s[0] == '+' {
    i = 1
  }
  while i < len {
    let c = s[i]
    if c >= '0' && c <= '9' {
      result = result * 10 + (c.to_int() - 0x30)
    } else {
      break
    }
    i += 1
  }
  if negative {
    -result
  } else {
    result
  }
}

///|
/// Return the numeric value of a hex digit (0-15), or -1 if not a valid hex digit.
/// Accepts the integer code point of the character.
pub fn hex_digit_value(code : Int) -> Int {
  if code >= 0x30 && code <= 0x39 {
    code - 0x30
  } else if code >= 0x41 && code <= 0x46 {
    code - 0x41 + 10
  } else if code >= 0x61 && code <= 0x66 {
    code - 0x61 + 10
  } else {
    -1
  }
}
