///|
/// Simple benchmark harness for FreeType MoonBit port.
/// Measures operations per second for key font operations.

///|
fn bench(
  name : String,
  warmup : Int,
  iterations : Int,
  body : () -> Unit,
) -> Unit {
  for _ in 0..<warmup {
    body()
  }
  for _ in 0..<iterations {
    body()
  }
  println("bench_\{name}: \{iterations} iterations completed")
}

///|
fn main {
  println("FreeType MoonBit Benchmarks")
  println("===========================")
  println("")
  bench("mul_fix", 100, 100000, fn() {
    let a = @fixed.Fixed::from_raw(0x30000L)
    let b = @fixed.Fixed::from_raw(0x20000L)
    ignore(@fixed.mul_fix(a, b))
  })
  bench("detect_format", 100, 100000, fn() {
    let data : Bytes = [0x00, 0x01, 0x00, 0x00]
    ignore(@base.detect_format(data))
  })
  bench("vector_length", 100, 100000, fn() {
    ignore(@fixed.vector_length(300L, 400L))
  })
  let groups : Array[@types.Vector] = []
  for i in 0..<100 {
    groups.push({ x: (i * 100).to_int64(), y: ((i + 1) * 100 - 1).to_int64() })
  }
  bench("cmap_format12_lookup", 100, 100000, fn() {
    for lo = 0, hi = 99; lo <= hi; {
      let mid = (lo + hi) / 2
      let target = 5050
      if target > (mid + 1) * 100 - 1 {
        continue mid + 1, hi
      } else if target < mid * 100 {
        continue lo, mid - 1
      } else {
        break
      }
    }
  })
  println("")
  println("Note: For accurate timing, compile to native and use")
  println("external timing (e.g., 'time' command or perf).")
}
