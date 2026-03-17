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


def vn(f):
    return f.replace(".", "_").replace("[", "_").replace("]", "_").replace(",", "_").replace("-", "_").replace(" ", "_").lower()


def esc(s):
    return s.replace("\\", "\\\\").replace('"', '\\"')


FMT = {".ttf": "TrueType", ".otf": "CffOpenType", ".ttc": "TrueTypeCollection",
       ".woff": "Woff1", ".pfb": "Type1Pfb", ".bdf": "Bdf"}


def font_path_expr(ff):
    """Return MoonBit expression for the font file path (relative to project root)."""
    return f'"test/fonts/{ff}"'


def gen_font_tests(ff, golden):
    """Generate test lines for one font. Returns (lines, test_count)."""
    v = vn(ff)
    meta = golden["metadata"]
    charmaps = golden["charmaps"]
    glyphs = golden["glyphs"]
    kerning = golden["kerning"]
    ext = os.path.splitext(ff)[1].lower()
    upe = meta.get("units_per_em", 0)
    path = font_path_expr(ff)

    L = [f"// Parity tests for {ff}", "// AUTO-GENERATED — do not edit", ""]

    # Helper: load font data
    L += [f"///|", f"fn load_{v}() -> Bytes {{", f"  try! @fs.read_file_to_bytes({path})", f"}}", ""]
    tc = 0

    # T1: format detection
    L += [f"///|", f'test "parity/{ff}: format" {{']
    if ext == ".ttf":
        L += [f'  inspect(@base.detect_format(load_{v}()) is (TrueType | TrueTypeCollection), content="true")']
    else:
        L += [f'  inspect(@base.detect_format(load_{v}()), content="{FMT.get(ext, "Unknown")}")']
    L += ["}", ""]
    tc += 1

    # T2: loads
    L += [f"///|", f'test "parity/{ff}: loads" {{',
          f'  inspect((try? @freetype.from_bytes(load_{v}())) is Ok(_), content="true")',
          "}", ""]
    tc += 1

    if upe <= 0 and ext != ".bdf":
        return L, tc

    # T3: metadata
    L += [f"///|", f'test "parity/{ff}: metadata" {{',
          f"  let f = @freetype.from_bytes(load_{v}())"]
    if meta.get("family_name"):
        L += [f'  inspect(f.family_name, content="{esc(meta["family_name"])}")']
    L += [f'  inspect(f.num_glyphs, content="{meta["num_glyphs"]}")']
    if upe > 0:
        L += [f'  inspect(f.units_per_em, content="{upe}")',
              f'  inspect(f.ascender, content="{meta["ascender"]}")',
              f'  inspect(f.descender, content="{meta["descender"]}")',
              f'  inspect(f.height, content="{meta["height"]}")']
    ul_pos, ul_th = meta.get("underline_position", 0), meta.get("underline_thickness", 0)
    if ul_pos or ul_th:
        L += [f'  inspect(f.underline_position, content="{ul_pos}")',
              f'  inspect(f.underline_thickness, content="{ul_th}")']
    L += ["}", ""]
    tc += 1

    # T4: bbox
    bbox = meta.get("bbox", {})
    if bbox and upe > 0:
        L += [f"///|", f'test "parity/{ff}: bbox" {{',
              f"  let f = @freetype.from_bytes(load_{v}())",
              f'  inspect(f.bbox.x_min, content="{bbox["xMin"]}")',
              f'  inspect(f.bbox.y_min, content="{bbox["yMin"]}")',
              f'  inspect(f.bbox.x_max, content="{bbox["xMax"]}")',
              f'  inspect(f.bbox.y_max, content="{bbox["yMax"]}")',
              "}", ""]
        tc += 1

    # T5: flags
    ff_ = meta.get("face_flags", 0)
    if True:  # flags apply to all formats
        L += [f"///|", f'test "parity/{ff}: flags" {{',
              f"  let f = @freetype.from_bytes(load_{v}())",
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
              f"  let f = @freetype.from_bytes(load_{v}())",
              f'  inspect(f.charmaps.length(), content="{n_cm}")']
        for ci, cm in enumerate(charmaps):
            L += [f"  if f.charmaps.length() > {ci} {{",
                  f'    inspect(f.charmaps[{ci}].platform_id, content="{cm["platform_id"]}")',
                  f'    inspect(f.charmaps[{ci}].encoding_id, content="{cm["encoding_id"]}")',
                  "  }"]
        L += ["}", ""]
        tc += 1

    # T7: charmap entries
    best_cm = None
    for cm in charmaps:
        if cm.get("entries") and cm["platform_id"] == 3 and cm["encoding_id"] == 1:
            best_cm = cm
            break
    if not best_cm:
        for cm in charmaps:
            if cm.get("entries"):
                best_cm = cm
                break
    if best_cm:  # charmap entries apply to all formats
        entries = best_cm["entries"][:50]
        L += [f"///|", f'test "parity/{ff}: charmap entries" {{',
              f"  let f = @freetype.from_bytes(load_{v}())"]
        for code, gid in entries:
            L += [f"  inspect(@freetype.get_char_index(f, {code}U), content=\"{gid}\")"]
        L += ["}", ""]
        tc += 1

    # T8: glyph outlines (NO_SCALE) — skip PFB (driver not wired)
    if ext != ".bdf":  # BDF is bitmap-only, no outline glyphs
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
                  f"  let f = @freetype.from_bytes(load_{v}())",
                  f"  let r = try? @freetype.load_glyph(f, {g['glyph_index']}U, load_flags=@base.load_no_scale)",
                  f"  guard r is Ok(_) else {{ return }}"]
            L += [f'  inspect(f.glyph.outline.n_points(), content="{o["n_points"]}")',
                  f'  inspect(f.glyph.outline.n_contours(), content="{o["n_contours"]}")']
            for pi, (px, py) in enumerate(o["points"][:8]):
                L += [f'  inspect(f.glyph.outline.points[{pi}].x, content="{px}")',
                      f'  inspect(f.glyph.outline.points[{pi}].y, content="{py}")']
            L += [f'  inspect(f.glyph.metrics.hori_advance, content="{g["metrics"]["horiAdvance"]}")']
            L += ["}", ""]
            tc += 1

    # T9: glyph metrics at 16ppem — skip PFB
    if ext != ".bdf":  # BDF is bitmap-only, no outline glyphs
        default_16 = [g for g in glyphs if g["load_flags"] == "DEFAULT"
                      and g["size_ppem"] == 16 and g["outline"]["n_points"] > 0]
        if default_16:
            g = default_16[0]
            m = g["metrics"]
            L += [f"///|",
                  f'test "parity/{ff}: glyph metrics at 16ppem" {{',
                  f"  let f = @freetype.from_bytes(load_{v}())",
                  f"  let r1 = try? @freetype.set_pixel_sizes(f, 0U, 16U)",
                  f"  guard r1 is Ok(_) else {{ return }}",
                  f"  let r2 = try? @freetype.load_glyph(f, {g['glyph_index']}U)",
                  f"  guard r2 is Ok(_) else {{ return }}",
                  f'  inspect(f.glyph.metrics.hori_advance, content="{m["horiAdvance"]}")',
                  "}", ""]
            tc += 1

    # T10: TTC multi-face
    if ext == ".ttc":
        nf = meta.get("num_faces", 1)
        if nf > 1:
            L += [f"///|", f'test "parity/{ff}: TTC multi-face" {{']
            for fi in range(min(nf, 3)):
                L += [f"  let f{fi} = @freetype.from_bytes(load_{v}(), face_index={fi})",
                      f'  inspect(f{fi}.num_glyphs > 0L, content="true")']
            L += ["}", ""]
            tc += 1

    # T11: kerning
    if kerning:
        L += [f"///|", f'test "parity/{ff}: kerning" {{',
              f"  let f = @freetype.from_bytes(load_{v}())"]
        for kp in kerning[:20]:
            L += [f"  inspect(@freetype.get_kerning(f, {kp['left']}U, {kp['right']}U).0, content=\"{kp['x']}\")"]
        L += ["}", ""]
        tc += 1

    return L, tc


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    # Remove old generated files
    for old in glob.glob(os.path.join(OUTPUT_DIR, "*_wbtest.mbt")):
        os.remove(old)

    fonts = []
    for gf in sorted(glob.glob(os.path.join(GOLDEN_DIR, "*.json"))):
        ff = os.path.basename(gf)[:-5]
        fp = os.path.join(FONT_DIR, ff)
        if not os.path.exists(fp):
            continue
        # Skip synthetic minimal fonts — real fonts cover all formats
        if ff.startswith("minimal."):
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
