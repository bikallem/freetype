///|
// Face flag constants (FT_FACE_FLAG_*)

///|
pub const FACE_FLAG_SCALABLE : Int64 = 1L

///|
pub const FACE_FLAG_FIXED_SIZES : Int64 = 2L

///|
pub const FACE_FLAG_FIXED_WIDTH : Int64 = 4L

///|
pub const FACE_FLAG_SFNT : Int64 = 8L

///|
pub const FACE_FLAG_HORIZONTAL : Int64 = 16L

///|
pub const FACE_FLAG_VERTICAL : Int64 = 32L

///|
pub const FACE_FLAG_KERNING : Int64 = 64L

///|
pub const FACE_FLAG_MULTIPLE_MASTERS : Int64 = 256L

///|
pub const FACE_FLAG_GLYPH_NAMES : Int64 = 512L

///|
pub const FACE_FLAG_HINTER : Int64 = 2048L

///|
// CID-keyed flag removed — standalone CID fonts not supported (CID-in-CFF works via CFF driver)

///|
pub const FACE_FLAG_TRICKY : Int64 = 8192L

///|
pub const FACE_FLAG_COLOR : Int64 = 16384L

///|
pub const FACE_FLAG_VARIATION : Int64 = 32768L

///|
pub const FACE_FLAG_SVG : Int64 = 65536L

///|
pub const FACE_FLAG_SBIX : Int64 = 131072L

///|
pub const FACE_FLAG_SBIX_OVERLAY : Int64 = 262144L

// Style flag constants (FT_STYLE_FLAG_*)

///|
pub const STYLE_FLAG_ITALIC : Int = 1

///|
pub const STYLE_FLAG_BOLD : Int = 2

// Load flag constants (FT_LOAD_*)

///|
pub const LOAD_DEFAULT : Int = 0

///|
pub const LOAD_NO_SCALE : Int = 1

///|
pub const LOAD_NO_HINTING : Int = 2

///|
pub const LOAD_RENDER : Int = 4

///|
pub const LOAD_NO_BITMAP : Int = 8

///|
pub const LOAD_VERTICAL_LAYOUT : Int = 16

///|
pub const LOAD_FORCE_AUTOHINT : Int = 32

///|
pub const LOAD_PEDANTIC : Int = 128

///|
pub const LOAD_ADVANCE_ONLY : Int = 256

///|
pub const LOAD_NO_RECURSE : Int = 1024

///|
pub const LOAD_IGNORE_TRANSFORM : Int = 2048

///|
pub const LOAD_MONOCHROME : Int = 4096

///|
pub const LOAD_LINEAR_DESIGN : Int = 8192

///|
pub const LOAD_SBITS_ONLY : Int = 16384

///|
pub const LOAD_NO_AUTOHINT : Int = 32768

///|
pub const LOAD_COLOR : Int = 1048576

///|
pub const LOAD_COMPUTE_METRICS : Int = 2097152

///|
pub const LOAD_BITMAP_METRICS_ONLY : Int = 4194304

///|
pub const LOAD_NO_SVG : Int = 16777216
