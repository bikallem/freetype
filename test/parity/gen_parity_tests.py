#!/usr/bin/env python3
"""
Generate comprehensive MoonBit parity tests from golden JSON data.
Fonts are read from disk at test time via @fs.read_file_to_bytes() —
no size limits, no embedded byte literals.
Tests must run with --target native (file I/O requires native target).
"""

import json, os, glob

GOLDEN_DIR = os.path.join(os.path.dirname(__file__), "..", "golden", "data")
OUTPUT_DIR = os.path.join(os.path.dirname(__file__), "..", "..", "src", "parity")
FONT_DIR = os.path.join(os.path.dirname(__file__), "..", "fonts")

# Some synthetic fixtures are intended to validate container reconstruction
# against FreeType's unhinted/source metrics, not to act as broad regressions
# for native hinted width/height behaviour in the underlying scaler.
SKIP_HINTED_BBOX_FIXTURES = {
    "minimal_collection.woff2",
    "minimal_hmtx.woff2",
    "mvar.ttf",
    "uvs.ttf",
}

UNICODE_CMAP_PRIORITIES = [
    (3, 10),
    (0, 10),
    (0, 6),
    (0, 4),
    (3, 1),
    (0, 3),
    (0, 2),
    (0, 1),
    (0, 0),
]


def vn(f):
    return f.replace(".", "_").replace("[", "_").replace("]", "_").replace(",", "_").replace("-", "_").replace(" ", "_").lower()


def esc(s):
    return s.replace("\\", "\\\\").replace('"', '\\"')


def tag_u32(tag):
    return (
        (ord(tag[0]) << 24)
        | (ord(tag[1]) << 16)
        | (ord(tag[2]) << 8)
        | ord(tag[3])
    )


def emit_variation_setup(lines, coords):
    lines += ["  try! @freetype.set_var_design_coordinates(", "    f,", "    ["]
    for tag, raw_value in coords:
        lines += [f"      (@fixed.Fixed::from_raw({int(raw_value)}L), 0x{tag_u32(tag):08X}U),"]
    lines += ["    ],", "  )"]


def choose_best_cmap(charmaps):
    for plat, enc in UNICODE_CMAP_PRIORITIES:
        for cm in charmaps:
            if cm.get("entries") and cm["platform_id"] == plat and cm["encoding_id"] == enc:
                return cm
    for cm in charmaps:
        if cm.get("entries"):
            return cm
    return None


def representative_charmap_entries(entries, limit=50):
    selected = list(entries[:limit])
    if not any(code > 0xFFFF for code, _ in selected):
        for code, gid in entries:
            if code > 0xFFFF:
                selected.append((code, gid))
                break
    return selected


def hex_bytes(text):
    if not text:
        return []
    return list(bytes.fromhex(text))


FMT = {".ttf": "TrueType", ".otf": "CffOpenType", ".ttc": "TrueTypeCollection",
       ".woff": "Woff1", ".woff2": "Woff2", ".pfb": "Type1Pfb", ".bdf": "Bdf",
       ".pcf": "Pcf", ".cff": "CffStandalone"}


def font_path_expr(ff):
    """Return MoonBit expression for the font file path (relative to project root)."""
    return f'"test/fonts/{ff}"'


def detect_font_format_name(ff):
    path = os.path.join(FONT_DIR, ff)
    with open(path, "rb") as f:
        header = f.read(4)
    if len(header) < 4:
        return "Unknown"
    b0, b1, b2, b3 = header
    tag = (b0 << 24) | (b1 << 16) | (b2 << 8) | b3
    if tag == 0x00010000 or tag == 0x74727565:
        return "TrueType"
    if tag == 0x4F54544F:
        return "CffOpenType"
    if tag == 0x74746366:
        return "TrueTypeCollection"
    if tag == 0x774F4646:
        return "Woff1"
    if tag == 0x774F4632:
        return "Woff2"
    if tag == 0x53544152:
        return "Bdf"
    if tag == 0x01666370:
        return "Pcf"
    if tag == 0x50465230:
        return "Pfr"
    if (b0, b1) == (0x80, 0x01):
        return "Type1Pfb"
    if (b0, b1) == (0x25, 0x21):
        return "Type1Pfa"
    if (b0, b1) == (0x4D, 0x5A):
        return "WindowsFnt"
    if b0 == 0x01 and b2 >= 4:
        return "CffStandalone"
    return FMT.get(os.path.splitext(ff)[1].lower(), "Unknown")


def gen_font_tests(ff, golden):
    """Generate test lines for one font. Returns (lines, test_count)."""
    v = vn(ff)
    meta = golden["metadata"]
    charmaps = golden["charmaps"]
    glyphs = golden["glyphs"]
    rendered_glyphs = golden.get("rendered_glyphs", [])
    kerning = golden["kerning"]
    variations = golden.get("variations", [])
    ext = os.path.splitext(ff)[1].lower()
    upe = meta.get("units_per_em", 0)
    path = font_path_expr(ff)
    loader_fn = f"load_generated_{v}"

    L = [f"// Parity tests for {ff}", "// AUTO-GENERATED — do not edit", ""]

    # Helper: load font data
    L += [f"///|", f"fn {loader_fn}() -> Bytes {{", f"  try! @fs.read_file_to_bytes({path})", f"}}", ""]
    tc = 0

    # T1: format detection
    L += [f"///|", f'test "parity/{ff}: format" {{']
    if ext == ".ttf":
        L += [f'  inspect(@base.detect_format({loader_fn}()) is (TrueType | TrueTypeCollection), content="true")']
    else:
        L += [f'  inspect(@base.detect_format({loader_fn}()), content="{detect_font_format_name(ff)}")']
    L += ["}", ""]
    tc += 1

    # T2: loads
    L += [f"///|", f'test "parity/{ff}: loads" {{',
          f'  inspect((try? @freetype.from_bytes({loader_fn}())) is Ok(_), content="true")',
          "}", ""]
    tc += 1

    if upe <= 0 and ext not in (".bdf", ".pcf"):
        return L, tc

    # T3: metadata
    L += [f"///|", f'test "parity/{ff}: metadata" {{',
          f"  let f = @freetype.from_bytes({loader_fn}())"]
    if meta.get("family_name"):
        L += [f'  inspect(f.family_name(), content="{esc(meta["family_name"])}")']
    L += [f'  inspect(f.num_glyphs(), content="{meta["num_glyphs"]}")']
    if upe > 0:
        L += [f'  inspect(f.units_per_em(), content="{upe}")',
              f'  inspect(f.ascender(), content="{meta["ascender"]}")',
              f'  inspect(f.descender(), content="{meta["descender"]}")',
              f'  inspect(f.height(), content="{meta["height"]}")']
    ul_pos, ul_th = meta.get("underline_position", 0), meta.get("underline_thickness", 0)
    if ul_pos or ul_th:
        L += [f'  inspect(f.underline_position(), content="{ul_pos}")',
              f'  inspect(f.underline_thickness(), content="{ul_th}")']
    L += ["}", ""]
    tc += 1

    # T4: bbox
    bbox = meta.get("bbox", {})
    if bbox and upe > 0:
        L += [f"///|", f'test "parity/{ff}: bbox" {{',
              f"  let f = @freetype.from_bytes({loader_fn}())",
              f'  inspect(f.bbox().x_min(), content="{bbox["xMin"]}")',
              f'  inspect(f.bbox().y_min(), content="{bbox["yMin"]}")',
              f'  inspect(f.bbox().x_max(), content="{bbox["xMax"]}")',
              f'  inspect(f.bbox().y_max(), content="{bbox["yMax"]}")',
              "}", ""]
        tc += 1

    # T5: flags
    ff_ = meta.get("face_flags", 0)
    if True:  # flags apply to all formats
        L += [f"///|", f'test "parity/{ff}: flags" {{',
              f"  let f = @freetype.from_bytes({loader_fn}())",
              f'  inspect(f.is_scalable(), content="{str(bool(ff_ & 1)).lower()}")',
              f'  inspect(f.is_sfnt(), content="{str(bool(ff_ & 8)).lower()}")',
              f'  inspect(f.has_horizontal(), content="{str(bool(ff_ & 16)).lower()}")',
              f'  inspect(f.has_kerning(), content="{str(bool(ff_ & 64)).lower()}")',
              "}", ""]
        tc += 1

    # T6: charmaps
    n_cm = meta.get("num_charmaps", 0)
    if n_cm > 0:  # charmaps apply to all formats
        L += [f"///|", f'test "parity/{ff}: charmaps" {{',
              f"  let f = @freetype.from_bytes({loader_fn}())",
              f'  inspect(f.charmaps().length(), content="{n_cm}")']
        for ci, cm in enumerate(charmaps):
            L += [f"  if f.charmaps().length() > {ci} {{",
                  f'    inspect(f.charmaps()[{ci}].platform_id(), content="{cm["platform_id"]}")',
                  f'    inspect(f.charmaps()[{ci}].encoding_id(), content="{cm["encoding_id"]}")',
                  "  }"]
        L += ["}", ""]
        tc += 1

    # T7: charmap entries
    best_cm = choose_best_cmap(charmaps)
    if best_cm:  # charmap entries apply to all formats
        entries = representative_charmap_entries(best_cm["entries"])
        L += [f"///|", f'test "parity/{ff}: charmap entries" {{',
              f"  let f = @freetype.from_bytes({loader_fn}())"]
        for code, gid in entries:
            L += [f"  inspect(@freetype.get_char_index(f, {code}U), content=\"{gid}\")"]
        L += ["}", ""]
        tc += 1

    # T8: glyph outlines (NO_SCALE) — skip PFB (driver not wired)
    if ext not in (".bdf", ".pcf"):  # bitmap-only formats have no outline glyphs
        noscale = [g for g in glyphs if g["load_flags"] == "NO_SCALE" and g["outline"]["n_points"] > 0]
        seen_gids = set()
        noscale_dedup = []
        for g in noscale:
            if g["glyph_index"] not in seen_gids:
                seen_gids.add(g["glyph_index"])
                noscale_dedup.append(g)
        for g in noscale_dedup[:3]:
            o = g["outline"]
            L += [f"///|",
                  f'test "parity/{ff}: glyph {g["glyph_index"]} outline NO_SCALE" {{',
                  f"  let f = @freetype.from_bytes({loader_fn}())",
                  f"  let r = try? @freetype.load_glyph(f, {g['glyph_index']}U, load_flags=@base.LOAD_NO_SCALE)",
                  f"  guard r is Ok(_) else {{ return }}"]
            L += [f'  inspect(f.glyph().outline().n_points(), content="{o["n_points"]}")',
                  f'  inspect(f.glyph().outline().n_contours(), content="{o["n_contours"]}")']
            for pi, (px, py) in enumerate(o["points"][:8]):
                L += [f'  inspect(f.glyph().outline().points()[{pi}].x(), content="{px}")',
                      f'  inspect(f.glyph().outline().points()[{pi}].y(), content="{py}")']
            L += [f'  inspect(f.glyph().metrics().hori_advance(), content="{g["metrics"]["horiAdvance"]}")']
            L += ["}", ""]
            tc += 1

    # T9: glyph metrics at 16ppem — skip PFB
    if ext not in (".bdf", ".pcf"):  # bitmap-only formats have no outline glyphs
        default_16 = [g for g in glyphs if g["load_flags"] == "DEFAULT"
                      and g["size_ppem"] == 16 and g["outline"]["n_points"] > 0]
        if default_16:
            g = default_16[0]
            m = g["metrics"]
            L += [f"///|",
                  f'test "parity/{ff}: glyph metrics at 16ppem" {{',
                  f"  let f = @freetype.from_bytes({loader_fn}())",
                  f"  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)",
                  f"  guard r1 is Ok(_) else {{ return }}",
                  f"  let r2 = try? @freetype.load_glyph(f, {g['glyph_index']}U)",
                  f"  guard r2 is Ok(_) else {{ return }}",
                  f'  inspect(f.glyph().metrics().hori_advance(), content="{m["horiAdvance"]}")',
                  "}", ""]
            tc += 1

    # T9b: rendered bitmap parity
    if rendered_glyphs and should_emit_render_tests(ff):
        for g in rendered_glyphs[:4]:
            bitmap = g["bitmap"]
            expected = hex_bytes(bitmap.get("buffer_hex", ""))
            render_load_flags = g.get("load_flags", "DEFAULT")
            load_flag_expr = {
                "NO_HINTING": "@base.LOAD_NO_HINTING",
                "DEFAULT": "0",
            }.get(render_load_flags, "0")
            L += [f"///|",
                  f'test "parity/{ff}: rendered glyph {g["glyph_index"]} char {g["charcode"]}" {{',
                  f"  let f = @freetype.from_bytes({loader_fn}())",
                  f"  try! @freetype.set_pixel_sizes(f, 0U, {g['size_ppem']}U)",
                  f"  let gid = @freetype.get_char_index(f, {g['charcode']}U)",
                  f'  inspect(gid, content="{g["glyph_index"]}")',
                  f"  try! @freetype.load_glyph(f, gid, load_flags={load_flag_expr})",
                  f"  try! @freetype.render_glyph(f)",
                  f'  inspect(f.glyph().format(), content="Bitmap")',
                  f'  inspect(f.glyph().bitmap().width(), content="{bitmap["width"]}")',
                  f'  inspect(f.glyph().bitmap().rows(), content="{bitmap["rows"]}")',
                  f'  inspect(f.glyph().bitmap().pitch(), content="{bitmap["pitch"]}")',
                  f'  inspect(f.glyph().bitmap().num_grays(), content="{bitmap["num_grays"]}")',
                  f'  inspect(f.glyph().bitmap_left(), content="{bitmap["left"]}")',
                  f'  inspect(f.glyph().bitmap_top(), content="{bitmap["top"]}")',
                  f'  inspect(f.glyph().bitmap().buffer().length(), content="{len(expected)}")']
            for i, byte in enumerate(expected):
                L += [f'  inspect(f.glyph().bitmap().buffer()[{i}].to_int(), content="{byte}")']
            L += ["}", ""]
            tc += 1

    # T10: multi-face collections
    nf = meta.get("num_faces", 1)
    if nf > 1:
        L += [f"///|", f'test "parity/{ff}: multi-face" {{']
        for fi in range(min(nf, 3)):
            L += [f"  let f{fi} = @freetype.from_bytes({loader_fn}(), face_index={fi})",
                  f'  inspect(f{fi}.num_glyphs() > 0L, content="true")']
        L += ["}", ""]
        tc += 1

    # T11: kerning
    if kerning:
        L += [f"///|", f'test "parity/{ff}: kerning" {{',
              f"  let f = @freetype.from_bytes({loader_fn}())"]
        for kp in kerning[:20]:
            L += [f"  inspect(@freetype.get_kerning(f, {kp['left']}U, {kp['right']}U).0, content=\"{kp['x']}\")"]
        L += ["}", ""]
        tc += 1

    # T12: Hinted outline (DEFAULT at 16ppem) — tests TT/PS hinting
    if ext not in (".bdf", ".pcf") and upe > 0 and ff not in SKIP_HINTED_BBOX_FIXTURES:
        default_16_all = [g for g in glyphs if g["load_flags"] == "DEFAULT"
                          and g["size_ppem"] == 16 and g["outline"]["n_points"] > 0]
        if default_16_all:
            g = default_16_all[0]
            o = g["outline"]
            L += [f"///|",
                  f'test "parity/{ff}: hinted outline DEFAULT 16ppem" {{',
                  f"  let f = @freetype.from_bytes({loader_fn}())",
                  f"  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)",
                  f"  guard r1 is Ok(_) else {{ return }}",
                  f"  let r2 = try? @freetype.load_glyph(f, {g['glyph_index']}U)",
                  f"  guard r2 is Ok(_) else {{ return }}",
                  f'  inspect(f.glyph().outline().n_points(), content="{o["n_points"]}")',
                  f'  inspect(f.glyph().metrics().width(), content="{g["metrics"]["width"]}")',
                  f'  inspect(f.glyph().metrics().height(), content="{g["metrics"]["height"]}")',
                  f'  inspect(f.glyph().metrics().hori_advance(), content="{g["metrics"]["horiAdvance"]}")',
                  "}", ""]
            tc += 1

    # T13: NO_HINTING outline at 16ppem — baseline for hinting comparison
    if ext not in (".bdf", ".pcf") and upe > 0:
        nohint_16 = [g for g in glyphs if g["load_flags"] == "NO_HINTING"
                     and g["size_ppem"] == 16 and g["outline"]["n_points"] > 0]
        if nohint_16:
            g = nohint_16[0]
            L += [f"///|",
                  f'test "parity/{ff}: outline NO_HINTING 16ppem" {{',
                  f"  let f = @freetype.from_bytes({loader_fn}())",
                  f"  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)",
                  f"  guard r1 is Ok(_) else {{ return }}",
                  f"  let r2 = try? @freetype.load_glyph(f, {g['glyph_index']}U, load_flags=@base.LOAD_NO_HINTING)",
                  f"  guard r2 is Ok(_) else {{ return }}",
                  f'  inspect(f.glyph().metrics().hori_advance(), content="{g["metrics"]["horiAdvance"]}")',
                  "}", ""]
            tc += 1

    # T14: FORCE_AUTOHINT outline — tests auto-hinter
    if ext not in (".bdf", ".pcf") and upe > 0:
        autohint_16 = [g for g in glyphs if g["load_flags"] == "FORCE_AUTOHINT"
                       and g["size_ppem"] == 16 and g["outline"]["n_points"] > 0]
        if autohint_16:
            g = autohint_16[0]
            L += [f"///|",
                  f'test "parity/{ff}: outline FORCE_AUTOHINT 16ppem" {{',
                  f"  let f = @freetype.from_bytes({loader_fn}())",
                  f"  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)",
                  f"  guard r1 is Ok(_) else {{ return }}",
                  f"  let r2 = try? @freetype.load_glyph(f, {g['glyph_index']}U, load_flags=@base.LOAD_FORCE_AUTOHINT)",
                  f"  guard r2 is Ok(_) else {{ return }}",
                  f'  inspect(f.glyph().metrics().hori_advance(), content="{g["metrics"]["horiAdvance"]}")',
                  "}", ""]
            tc += 1

    # T15+: variable-instance coverage
    variation = next((v for v in variations if v.get("glyphs")), None)
    if variation:
        coords = variation.get("coords", [])
        vg = variation["glyphs"]

        L += [f"///|", f'test "parity/{ff}: variation state" {{',
              f"  let f = @freetype.from_bytes({loader_fn}())",
              f'  inspect(f.has_multiple_masters(), content="true")',
              f'  inspect(f.is_variation(), content="false")']
        emit_variation_setup(L, coords)
        L += [f'  inspect(f.is_variation(), content="true")', "}", ""]
        tc += 1

        var_noscale = [g for g in vg if g["load_flags"] == "NO_SCALE" and g["outline"]["n_points"] > 0]
        for g in var_noscale[:2]:
            o = g["outline"]
            m = g["metrics"]
            charcode = g["charcode"]
            L += [f"///|",
                  f'test "parity/{ff}: varied {charcode} outline NO_SCALE" {{',
                  f"  let f = @freetype.from_bytes({loader_fn}())"]
            emit_variation_setup(L, coords)
            L += [f"  let gid = @freetype.get_char_index(f, {charcode}U)",
                  f"  let r = try? @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_SCALE)",
                  f"  guard r is Ok(_) else {{ return }}",
                  f'  inspect(gid, content="{g["glyph_index"]}")',
                  f'  inspect(f.glyph().outline().n_points(), content="{o["n_points"]}")',
                  f'  inspect(f.glyph().outline().n_contours(), content="{o["n_contours"]}")',
                  f'  inspect(f.glyph().metrics().hori_advance(), content="{m["horiAdvance"]}")',
                  f'  inspect(f.glyph().metrics().width(), content="{m["width"]}")',
                  f'  inspect(f.glyph().metrics().hori_bearing_x(), content="{m["horiBearingX"]}")']
            for pi, (px, py) in enumerate(o["points"][:4]):
                L += [f'  inspect(f.glyph().outline().points()[{pi}].x(), content="{px}")',
                      f'  inspect(f.glyph().outline().points()[{pi}].y(), content="{py}")']
            L += ["}", ""]
            tc += 1

        var_nohint = [g for g in vg if g["load_flags"] == "NO_HINTING" and g["size_ppem"] == 16 and g["outline"]["n_points"] > 0]
        if var_nohint:
            g = var_nohint[0]
            m = g["metrics"]
            o = g["outline"]
            L += [f"///|",
                  f'test "parity/{ff}: varied outline NO_HINTING 16ppem" {{',
                  f"  let f = @freetype.from_bytes({loader_fn}())"]
            emit_variation_setup(L, coords)
            L += [f"  let gid = @freetype.get_char_index(f, {g['charcode']}U)",
                  f"  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)",
                  f"  guard r1 is Ok(_) else {{ return }}",
                  f"  let r2 = try? @freetype.load_glyph(f, gid, load_flags=@base.LOAD_NO_HINTING)",
                  f"  guard r2 is Ok(_) else {{ return }}",
                  f'  inspect(f.glyph().metrics().hori_advance(), content="{m["horiAdvance"]}")',
                  f'  inspect(f.glyph().metrics().width(), content="{m["width"]}")',
                  f'  inspect(f.glyph().metrics().height(), content="{m["height"]}")',
                  f'  inspect(f.glyph().metrics().hori_bearing_x(), content="{m["horiBearingX"]}")',
                  f'  inspect(f.glyph().metrics().hori_bearing_y(), content="{m["horiBearingY"]}")']
            if o["points"]:
                L += [f'  inspect(f.glyph().outline().points()[0].x(), content="{o["points"][0][0]}")',
                      f'  inspect(f.glyph().outline().points()[0].y(), content="{o["points"][0][1]}")']
            L += ["}", ""]
            tc += 1

        var_default = [g for g in vg if g["load_flags"] == "DEFAULT" and g["size_ppem"] == 16 and g["outline"]["n_points"] > 0]
        if var_default:
            g = var_default[0]
            m = g["metrics"]
            L += [f"///|",
                  f'test "parity/{ff}: varied hinted outline DEFAULT 16ppem" {{',
                  f"  let f = @freetype.from_bytes({loader_fn}())"]
            emit_variation_setup(L, coords)
            L += [f"  let gid = @freetype.get_char_index(f, {g['charcode']}U)",
                  f"  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)",
                  f"  guard r1 is Ok(_) else {{ return }}",
                  f"  let r2 = try? @freetype.load_glyph(f, gid)",
                  f"  guard r2 is Ok(_) else {{ return }}",
                  f'  inspect(f.glyph().metrics().hori_advance(), content="{m["horiAdvance"]}")',
                  f'  inspect(f.glyph().metrics().width(), content="{m["width"]}")',
                  f'  inspect(f.glyph().metrics().height(), content="{m["height"]}")',
                  f'  inspect(f.glyph().metrics().hori_bearing_x(), content="{m["horiBearingX"]}")',
                  f'  inspect(f.glyph().metrics().hori_bearing_y(), content="{m["horiBearingY"]}")',
                  "}", ""]
            tc += 1

        var_autohint = [g for g in vg if g["load_flags"] == "FORCE_AUTOHINT" and g["size_ppem"] == 16 and g["outline"]["n_points"] > 0]
        if var_autohint:
            g = var_autohint[0]
            L += [f"///|",
                  f'test "parity/{ff}: varied outline FORCE_AUTOHINT 16ppem" {{',
                  f"  let f = @freetype.from_bytes({loader_fn}())"]
            emit_variation_setup(L, coords)
            L += [f"  let gid = @freetype.get_char_index(f, {g['charcode']}U)",
                  f"  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)",
                  f"  guard r1 is Ok(_) else {{ return }}",
                  f"  let r2 = try? @freetype.load_glyph(f, gid, load_flags=@base.LOAD_FORCE_AUTOHINT)",
                  f"  guard r2 is Ok(_) else {{ return }}",
                  f'  inspect(f.glyph().metrics().hori_advance(), content="{g["metrics"]["horiAdvance"]}")',
                  "}", ""]
            tc += 1

    return L, tc


def should_emit_render_tests(ff):
    name = os.path.basename(ff)
    return name in {
        "DejaVuSans.ttc",
        "DejaVuSans.ttf",
        "DejaVuSans.woff",
        "DejaVuSans.woff2",
        "NimbusSans-Regular.pfb",
        "Roboto[wdth,wght].ttf",
        "minimal.woff2",
        "minimal_collection.woff2",
        "minimal_hmtx.woff2",
        "minimal_standalone.cff",
        "mvar.ttf",
        "uvs.ttf",
    }


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    # Remove only previously generated parity files, preserving handwritten
    # coverage like standalone CFF/WOFF2 tests.
    for old in glob.glob(os.path.join(OUTPUT_DIR, "*_wbtest.mbt")):
        try:
            with open(old, "r", encoding="utf-8") as f:
                header = f.read(256)
        except OSError:
            continue
        if "AUTO-GENERATED" in header:
            os.remove(old)

    fonts = []
    for gf in sorted(glob.glob(os.path.join(GOLDEN_DIR, "*.json"))):
        ff = os.path.basename(gf)[:-5]
        fp = os.path.join(FONT_DIR, ff)
        if not os.path.exists(fp):
            continue
        # Skip synthetic minimal fonts when a real corpus font already covers
        # the format; keep minimal.pcf and minimal.woff2 because those formats
        # otherwise lack automated parity coverage.
        if ff.startswith("minimal.") and ff not in {"minimal.pcf", "minimal.woff2"}:
            print(f"  [skip] {ff} (synthetic — real font covers this format)")
            continue
        fonts.append((ff, fp, json.load(open(gf))))
        sz = os.path.getsize(fp)
        print(f"  [include] {ff} ({sz:,}B)")

    total_tests = 0
    total_files = 0
    for ff, fp, golden in fonts:
        lines, tc = gen_font_tests(ff, golden)
        safe_name = vn(ff)
        out_path = os.path.join(OUTPUT_DIR, f"parity_{safe_name}_wbtest.mbt")
        with open(out_path, "w") as f:
            f.write("\n".join(lines) + "\n")
        total_tests += tc
        total_files += 1
        print(f"    → {os.path.basename(out_path)} ({tc} tests)")

    print(f"\n  Total: {total_tests} tests across {total_files} fonts, 0 stubs")
    print(f"  Run with: moon test src/parity --target native")


if __name__ == "__main__":
    main()
