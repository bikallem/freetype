///|
fn hex_digit(unit : UInt16) -> Int {
  let code = unit.to_int()
  if code >= '0'.to_int() && code <= '9'.to_int() {
    code - '0'.to_int()
  } else if code >= 'a'.to_int() && code <= 'f'.to_int() {
    code - 'a'.to_int() + 10
  } else if code >= 'A'.to_int() && code <= 'F'.to_int() {
    code - 'A'.to_int() + 10
  } else {
    -1
  }
}

///|
fn bytes_to_hex(bytes : Bytes) -> String {
  let buf = StringBuilder::new()
  for i in 0..<bytes.length() {
    buf.write_string(bytes[i].to_hex())
  }
  buf.to_string()
}

///|
fn assert_buffer_hex(
  actual : Bytes,
  expected_hex : String,
) -> Unit raise @error.FTError {
  if actual.length() != expected_hex.length() / 2 {
    println(
      "buffer length mismatch: actual=" +
      actual.length().to_string() +
      " expected=" +
      (expected_hex.length() / 2).to_string() +
      " actual_hex=" +
      bytes_to_hex(actual) +
      " expected_hex=" +
      expected_hex,
    )
    raise @error.FTError::InvalidArgument
  }
  for i in 0..<actual.length() {
    let hi = hex_digit(expected_hex[i * 2])
    let lo = hex_digit(expected_hex[i * 2 + 1])
    let expected = (hi << 4) | lo
    let got = actual[i].to_int()
    if got != expected {
      println(
        "buffer byte mismatch at " +
        i.to_string() +
        ": actual=" +
        got.to_string() +
        " expected=" +
        expected.to_string() +
        " actual_hex=" +
        bytes_to_hex(actual) +
        " expected_hex=" +
        expected_hex,
      )
      raise @error.FTError::InvalidArgument
    }
  }
}
