///|
/// Decompress a WOFF2 file to an SFNT file for golden generation.
fn main {
  let args = @env.args()
  if args.length() != 3 {
    println(
      "Usage: moon run --target native src/golden_woff2 -- <input.woff2> <output.sfnt>",
    )
    return
  }

  let input_path = args[1]
  let output_path = args[2]

  let input = @fs.read_file_to_bytes(input_path) catch {
    @fs.IOError(err) => {
      println("ERROR: cannot read \{input_path}: \{err}")
      return
    }
  }
  let output = @sfnt.decompress_woff2(input) catch {
    err => {
      println("ERROR: cannot decompress \{input_path}: \{err}")
      return
    }
  }
  @fs.write_bytes_to_file(output_path, output) catch {
    @fs.IOError(err) => {
      println("ERROR: cannot write \{output_path}: \{err}")
      return
    }
  }
}
