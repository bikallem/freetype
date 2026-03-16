///|
test "FTError variants" {
  // Verify a few error codes exist and are distinct
  let e1 : @error.FTError = @error.FTError::InvalidArgument
  let e2 : @error.FTError = @error.FTError::UnknownFileFormat
  inspect(e1 == e2, content="false")
  inspect(e1 == @error.FTError::InvalidArgument, content="true")
}

///|
test "FTError as error type" {
  fn failing() -> Unit raise @error.FTError {
    raise @error.FTError::InvalidStreamRead
  }

  let result = try? failing()
  inspect(result, content="Err(InvalidStreamRead)")
}
