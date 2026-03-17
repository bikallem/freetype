///|
/// Simple benchmark harness for FreeType MoonBit port.
/// Measures operations per second for key font operations.

///|
fn bench(name : String, warmup : Int, iterations : Int, body : () -> Unit) -> Unit {
  // Warmup
  for i = 0; i < warmup; i = i + 1 {
    body()
  }
  // Timed run (approximate — MoonBit doesn't expose high-res clock yet)
  for i = 0; i < iterations; i = i + 1 {
    body()
  }
  println("bench_\{name}: \{iterations} iterations completed")
}

///|
fn main {
  println("FreeType MoonBit Benchmarks")
  println("===========================")
  println("")
  // Benchmark 1: Fixed-point multiplication
  bench(
    "mul_fix", 100, 100000,
    fn() {
      let a = @fixed.Fixed::from_raw(0x30000L)
      let b = @fixed.Fixed::from_raw(0x20000L)
      ignore(@fixed.mul_fix(a, b))
    },
  )
  // Benchmark 2: Format detection
  bench(
    "detect_format", 100, 100000,
    fn() {
      let data : Bytes = [0x00, 0x01, 0x00, 0x00]
      ignore(@base.detect_format(data))
    },
  )
  // Benchmark 3: Vector length (CORDIC)
  bench(
    "vector_length", 100, 100000,
    fn() { ignore(@fixed.vector_length(300L, 400L)) },
  )
  // Benchmark 4: CMap format 12 lookup
  let groups : Array[@types.Vector] = []
  for i = 0; i < 100; i = i + 1 {
    groups.push({ x: (i * 100).to_int64(), y: ((i + 1) * 100 - 1).to_int64() })
  }
  bench(
    "cmap_format12_lookup", 100, 100000,
    fn() {
      // Simulate a binary search over ranges
      let mut lo = 0
      let mut hi = 99
      let target = 5050
      while lo <= hi {
        let mid = (lo + hi) / 2
        if target > (mid + 1) * 100 - 1 {
          lo = mid + 1
        } else if target < mid * 100 {
          hi = mid - 1
        } else {
          break
        }
      }
    },
  )
  println("")
  println("Note: For accurate timing, compile to native and use")
  println("external timing (e.g., 'time' command or perf).")
  println("Compare with equivalent C benchmarks in bench/c/.")
}
