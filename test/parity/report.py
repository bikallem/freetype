#!/usr/bin/env python3
"""
Generate a parity report comparing MoonBit port against C FreeType golden data.
Reads golden JSON files + MoonBit test results and produces a summary table.
"""

import json, os, glob, subprocess, sys

GOLDEN_DIR = os.path.join(os.path.dirname(__file__), "..", "golden", "data")
FONT_DIR = os.path.join(os.path.dirname(__file__), "..", "fonts")
PROJECT_ROOT = os.path.join(os.path.dirname(__file__), "..", "..")

FMT_NAMES = {
    ".ttf": "TrueType", ".otf": "CFF/OpenType", ".ttc": "TrueType Collection",
    ".woff": "WOFF1", ".woff2": "WOFF2", ".cff": "Standalone CFF",
    ".pfb": "Type 1 PFB", ".bdf": "BDF Bitmap", ".pcf": "PCF Bitmap",
    ".fnt": "Windows FNT",
}


def main():
    # Collect golden files
    goldens = {}
    for gf in sorted(glob.glob(os.path.join(GOLDEN_DIR, "*.json"))):
        name = os.path.basename(gf)[:-5]
        with open(gf) as f:
            goldens[name] = json.load(f)

    if not goldens:
        print("No golden files found. Run: make parity")
        return 1

    # Run MoonBit parity tests and capture results
    # Parity tests use @fs.read_file_to_bytes() so must run on native target
    result = subprocess.run(
        ["moon", "test", "src/parity", "--target", "native", "-v"],
        capture_output=True, text=True, cwd=PROJECT_ROOT,
    )
    test_output = result.stdout + result.stderr

    # Parse test results
    passed_tests = set()
    failed_tests = {}
    for line in test_output.splitlines():
        if ') ok' in line:
            # Extract test name
            start = line.find('("')
            end = line.find('")', start)
            if start >= 0 and end >= 0:
                passed_tests.add(line[start+2:end])
        elif ') failed' in line:
            start = line.find('("')
            end = line.find('")', start)
            if start >= 0 and end >= 0:
                name = line[start+2:end]
                # Get failure reason
                reason = line.split("failed")[-1].strip().strip(":")
                failed_tests[name] = reason if reason else "assertion mismatch"

    total_pass = len(passed_tests)
    total_fail = len(failed_tests)
    total = total_pass + total_fail

    # Print header
    print()
    print("=" * 78)
    print("  PARITY REPORT: MoonBit FreeType Port vs C FreeType")
    print("=" * 78)
    print()

    # Font summary table
    print("  Fonts tested:")
    print("  " + "-" * 74)
    print(f"  {'Font':<35s} {'Format':<20s} {'Glyphs':>7s} {'CMap':>5s} {'Kern':>5s}")
    print("  " + "-" * 74)
    for name, golden in sorted(goldens.items()):
        m = golden["metadata"]
        ext = os.path.splitext(name)[1]
        fmt = FMT_NAMES.get(ext, ext)
        n_glyphs = m.get("num_glyphs", 0)
        n_cmap = sum(len(c["entries"]) for c in golden.get("charmaps", []))
        n_kern = len(golden.get("kerning", []))
        print(f"  {name:<35s} {fmt:<20s} {n_glyphs:>7d} {n_cmap:>5d} {n_kern:>5d}")
    print("  " + "-" * 74)
    print()

    # Per-font test results
    categories = [
        ("format", "format"),
        ("loads", "loads"),
        ("metadata", "metadata"),
        ("bbox", "bbox"),
        ("flags", "flags"),
        ("charmaps", "charmaps"),
        ("charmap entries", "charmap entries"),
        ("glyph outline", "outline NO_SCALE"),
        ("glyph metrics", "glyph metrics"),
        ("rendered bitmap", "rendered glyph"),
        ("hinted (DEFAULT)", "hinted outline DEFAULT"),
        ("unhinted (NO_HINT)", "outline NO_HINTING"),
        ("auto-hinted", "outline FORCE_AUTOHINT"),
        ("TTC multi-face", "TTC multi-face"),
        ("kerning", "kerning"),
    ]

    # Build per-font status grid
    fonts_tested = set()
    for t in list(passed_tests) + list(failed_tests.keys()):
        if t.startswith("parity/"):
            parts = t.split(": ", 1)
            font = parts[0].replace("parity/", "")
            fonts_tested.add(font)

    print("  Test results by font and category:")
    print("  " + "-" * 74)
    hdr = f"  {'Category':<28s}"
    for font in sorted(fonts_tested):
        short = font.split(".")[0][:6]
        ext = os.path.splitext(font)[1]
        hdr += f" {short+ext:>10s}"
    print(hdr)
    print("  " + "-" * 74)

    for display_name, match_key in categories:
        row = f"  {display_name:<28s}"
        for font in sorted(fonts_tested):
            font_prefix = f"parity/{font}: "
            matched_pass = any(t.startswith(font_prefix) and match_key in t for t in passed_tests)
            matched_fail = any(t.startswith(font_prefix) and match_key in t for t in failed_tests)
            if matched_fail:
                row += f" {'FAIL':>10s}"
            elif matched_pass:
                row += f" {'PASS':>10s}"
            else:
                row += f" {'--':>10s}"
        print(row)
    print("  " + "-" * 74)
    print()

    # Summary
    print(f"  Total: {total} tests, {total_pass} passed, {total_fail} failed")
    print()

    if failed_tests:
        print("  Failed tests:")
        for name, reason in sorted(failed_tests.items()):
            print(f"    FAIL: {name}")
            if reason:
                print(f"          {reason}")
        print()

    # Coverage analysis
    print("  API coverage:")
    print("  " + "-" * 74)
    apis = [
        ("from_bytes(data)", "loads", "Font loading from raw bytes"),
        ("get_char_index(face, charcode)", "charmap entries", "Charcode → glyph index mapping"),
        ("load_glyph(face, gid, flags)", "outline NO_SCALE", "Glyph outline loading"),
        ("render_glyph(face, mode)", "rendered glyph", "Bitmap rendering from loaded outlines"),
        ("set_pixel_sizes(face, w, h)", "glyph metrics", "Size-dependent glyph scaling"),
        ("get_kerning(face, l, r)", "kerning", "Kerning pair lookup"),
    ]
    for api, cat, desc in apis:
        has_any = any(any(cat in t and t.startswith(f"parity/{f}: ") for t in passed_tests) for f in fonts_tested)
        status = "TESTED" if has_any else "NOT TESTED"
        print(f"  {status:>10s}  {api:<35s} {desc}")
    print("  " + "-" * 74)
    print()

    # Format coverage
    print("  Format coverage:")
    print("  " + "-" * 74)
    all_fmts = [
        (".ttf", "TrueType"), (".otf", "CFF/OpenType"), (".ttc", "TrueType Collection"),
        (".woff", "WOFF1"), (".woff2", "WOFF2"), (".cff", "Standalone CFF"),
        (".pfb", "Type 1 PFB"), (".bdf", "BDF Bitmap"), (".pcf", "PCF Bitmap"),
    ]
    for ext, name in all_fmts:
        has_font = any(f.endswith(ext) for f in fonts_tested)
        load_ok = any(f"parity/{f}: loads" in passed_tests for f in fonts_tested if f.endswith(ext))
        glyph_ok = any(any(t.startswith(f"parity/{f}: glyph") and "outline" in t for t in passed_tests) for f in fonts_tested if f.endswith(ext))
        render_ok = any(any(t.startswith(f"parity/{f}: rendered glyph") for t in passed_tests) for f in fonts_tested if f.endswith(ext))
        if load_ok and (glyph_ok or ext in {".bdf", ".pcf"}) and (render_ok or ext in {".bdf", ".pcf"}) :
            status = "FULL"
        elif load_ok:
            status = "LOAD"
        elif has_font:
            status = "FONT"
        else:
            status = "MISSING"
        print(f"  {status:>7s}  {name:<25s} {ext}")
    print("  " + "-" * 74)
    print("  FULL = load + glyph/render parity | LOAD = loads but lacks some parity coverage | MISSING = no test font")
    print()
    print("=" * 78)

    return 1 if total_fail > 0 else 0


if __name__ == "__main__":
    sys.exit(main())
