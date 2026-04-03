# Compatibility Target

This document defines what "FreeType-compatible" means in this repository.

## Oracle

- The normative oracle is the vendored C library in `vendor/freetype-c`.
- The pinned upstream target is the vendored FreeType 2.14.2 release snapshot.
  The in-tree version macros are `FREETYPE_MAJOR 2`, `FREETYPE_MINOR 14`,
  and `FREETYPE_PATCH 2` in
  `vendor/freetype-c/include/freetype/freetype.h`.
- If the vendored copy is updated, compatibility claims in this repository
  move only when this document is updated in the same change.

## Required Behavior

Unless an exclusion below says otherwise, the MoonBit runtime is expected to
match the vendored FreeType behavior for the supported surface in these areas:

- Face metadata and observable flags.
- Charmap enumeration and character-to-glyph mapping.
- Glyph loading for supported formats and load-flag combinations.
- Glyph metrics, outlines, and bitmap rendering for the curated parity corpus.
- TrueType and PostScript hinting outcomes for the supported drivers.
- Variation-coordinate behavior for supported variable fonts.
- Kerning behavior where the driver advertises kerning support.
- Color-glyph loading and rendering for `sbix`, `CBDT`/`CBLC`, and
  `COLR`/`CPAL`.

The standard is behavioral equivalence against the vendored oracle on the
documented corpus and differential harnesses, not source-level or
implementation-level similarity.

## Approved Exclusions

The following differences are intentional and must remain documented and
contract-tested instead of being counted as parity failures:

- No file-path I/O API. The runtime accepts in-memory `Bytes`.
- No `FT_Library` global-state API.
- No allocator-plumbing API (`FT_Memory`, `FT_Alloc`, `FT_Free`).
- No `FT_Generic` user-data hook surface.
- No OT-SVG glyph-document load/render path. The runtime may expose SVG table
  metadata and `FACE_FLAG_SVG`, but it does not load SVG glyph documents under
  `LOAD_COLOR` and does not ship an SVG rasterizer.

These exclusions narrow the compatibility claim. They do not lower the
expected parity for the remaining supported surface.

## Compatibility Language

Repository documentation and comments should use the following wording:

- Allowed: "FreeType-compatible for the supported surface against the vendored
  FreeType 2.14.2 snapshot."
- Allowed: "Behavior matches the vendored FreeType oracle except for the
  documented exclusions in `docs/compatibility.md`."
- Not allowed: "Fully equivalent to FreeType" unless the exclusion list is
  empty and the differential harness explicitly proves that claim at the same
  pinned target.

## Testing Policy

- Differential parity tests compare supported behavior against the vendored
  oracle.
- Contract tests run intentional exclusions separately from parity. In this
  repository the dedicated entry point is `make contracts`.
- Intentional exclusions use explicit contract tests and must not silently
  inflate parity counts.
- When a new incompatibility is accepted, it must be added here and covered by
  a contract test in the same change.
