///|
// Face flag constants (FT_FACE_FLAG_*)

///|
pub let face_flag_scalable : Int64 = 1L << 0

///|
pub let face_flag_fixed_sizes : Int64 = 1L << 1

///|
pub let face_flag_fixed_width : Int64 = 1L << 2

///|
pub let face_flag_sfnt : Int64 = 1L << 3

///|
pub let face_flag_horizontal : Int64 = 1L << 4

///|
pub let face_flag_vertical : Int64 = 1L << 5

///|
pub let face_flag_kerning : Int64 = 1L << 6

///|
pub let face_flag_multiple_masters : Int64 = 1L << 8

///|
pub let face_flag_glyph_names : Int64 = 1L << 9

///|
pub let face_flag_hinter : Int64 = 1L << 11

///|
// CID-keyed flag removed — standalone CID fonts not supported (CID-in-CFF works via CFF driver)

///|
pub let face_flag_tricky : Int64 = 1L << 13

///|
pub let face_flag_color : Int64 = 1L << 14

///|
pub let face_flag_variation : Int64 = 1L << 15

///|
pub let face_flag_svg : Int64 = 1L << 16

///|
pub let face_flag_sbix : Int64 = 1L << 17

///|
pub let face_flag_sbix_overlay : Int64 = 1L << 18

// Style flag constants (FT_STYLE_FLAG_*)

///|
pub let style_flag_italic : Int = 1 << 0

///|
pub let style_flag_bold : Int = 1 << 1

// Load flag constants (FT_LOAD_*)

///|
pub let load_default : Int = 0

///|
pub let load_no_scale : Int = 1 << 0

///|
pub let load_no_hinting : Int = 1 << 1

///|
pub let load_render : Int = 1 << 2

///|
pub let load_no_bitmap : Int = 1 << 3

///|
pub let load_vertical_layout : Int = 1 << 4

///|
pub let load_force_autohint : Int = 1 << 5

///|
pub let load_pedantic : Int = 1 << 7

///|
pub let load_advance_only : Int = 1 << 8

///|
pub let load_no_recurse : Int = 1 << 10

///|
pub let load_ignore_transform : Int = 1 << 11

///|
pub let load_monochrome : Int = 1 << 12

///|
pub let load_linear_design : Int = 1 << 13

///|
pub let load_sbits_only : Int = 1 << 14

///|
pub let load_no_autohint : Int = 1 << 15

///|
pub let load_color : Int = 1 << 20

///|
pub let load_compute_metrics : Int = 1 << 21

///|
pub let load_bitmap_metrics_only : Int = 1 << 22

///|
pub let load_no_svg : Int = 1 << 24
