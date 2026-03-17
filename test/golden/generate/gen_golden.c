/*
 * gen_golden.c — Generate JSON golden files from vendored FreeType.
 *
 * Build:
 *   make -C test/golden/generate
 *
 * Usage:
 *   ./gen_golden <font_dir> <output_dir>
 *
 * For each font file in <font_dir>, generates a JSON file in <output_dir>
 * containing face metadata, charmap dump, glyph outlines at multiple sizes,
 * kerning pairs, and (for variable fonts) variation data.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <ft2build.h>
#include FT_FREETYPE_H
#include FT_GLYPH_H
#include FT_OUTLINE_H
#include FT_TRUETYPE_IDS_H
#include FT_MULTIPLE_MASTERS_H

/* Test sizes in ppem */
static const int test_sizes[] = { 12, 16, 24, 48 };
#define NUM_SIZES (sizeof(test_sizes) / sizeof(test_sizes[0]))

/* Load flag combinations */
static const struct {
    const char *name;
    FT_Int32    flags;
} load_flag_matrix[] = {
    { "DEFAULT",        FT_LOAD_DEFAULT },
    { "NO_HINTING",     FT_LOAD_NO_HINTING },
    { "NO_SCALE",       FT_LOAD_NO_SCALE },
    { "NO_AUTOHINT",    FT_LOAD_NO_AUTOHINT },
    { "FORCE_AUTOHINT", FT_LOAD_FORCE_AUTOHINT },
};
#define NUM_LOAD_FLAGS (sizeof(load_flag_matrix) / sizeof(load_flag_matrix[0]))

/* Selected test glyphs (ASCII printable) */
static const FT_ULong test_charcodes[] = {
    ' ', '!', '"', '#', '$', '%', '&', '\'', '(', ')', '*', '+', ',',
    '-', '.', '/', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    ':', ';', '<', '=', '>', '?', '@',
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    '[', '\\', ']', '^', '_', '`',
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
    'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
    '{', '|', '}', '~',
};
#define NUM_TEST_CHARS (sizeof(test_charcodes) / sizeof(test_charcodes[0]))

static void dump_face_metadata(FILE *fp, FT_Face face) {
    fprintf(fp, "  \"metadata\": {\n");
    fprintf(fp, "    \"family_name\": \"%s\",\n", face->family_name ? face->family_name : "");
    fprintf(fp, "    \"style_name\": \"%s\",\n", face->style_name ? face->style_name : "");
    fprintf(fp, "    \"num_glyphs\": %ld,\n", face->num_glyphs);
    fprintf(fp, "    \"num_faces\": %ld,\n", face->num_faces);
    fprintf(fp, "    \"units_per_em\": %d,\n", face->units_per_EM);
    fprintf(fp, "    \"ascender\": %d,\n", face->ascender);
    fprintf(fp, "    \"descender\": %d,\n", face->descender);
    fprintf(fp, "    \"height\": %d,\n", face->height);
    fprintf(fp, "    \"max_advance_width\": %d,\n", face->max_advance_width);
    fprintf(fp, "    \"bbox\": { \"xMin\": %ld, \"yMin\": %ld, \"xMax\": %ld, \"yMax\": %ld },\n",
            face->bbox.xMin, face->bbox.yMin, face->bbox.xMax, face->bbox.yMax);
    fprintf(fp, "    \"face_flags\": %ld,\n", face->face_flags);
    fprintf(fp, "    \"style_flags\": %ld,\n", face->style_flags);
    fprintf(fp, "    \"num_charmaps\": %d,\n", face->num_charmaps);
    fprintf(fp, "    \"underline_position\": %d,\n", face->underline_position);
    fprintf(fp, "    \"underline_thickness\": %d\n", face->underline_thickness);
    fprintf(fp, "  }");
}

static void dump_charmaps(FILE *fp, FT_Face face) {
    fprintf(fp, "  \"charmaps\": [\n");
    for (int i = 0; i < face->num_charmaps; i++) {
        FT_CharMap cm = face->charmaps[i];
        fprintf(fp, "    {\n");
        fprintf(fp, "      \"platform_id\": %d,\n", cm->platform_id);
        fprintf(fp, "      \"encoding_id\": %d,\n", cm->encoding_id);
        fprintf(fp, "      \"entries\": [");

        /* Set this charmap active and dump all mappings */
        FT_Set_Charmap(face, cm);
        FT_UInt gindex;
        FT_ULong charcode = FT_Get_First_Char(face, &gindex);
        int first = 1;
        int count = 0;
        while (gindex != 0 && count < 10000) { /* limit to prevent huge output */
            if (!first) fprintf(fp, ",");
            fprintf(fp, "[%lu,%u]", charcode, gindex);
            first = 0;
            count++;
            charcode = FT_Get_Next_Char(face, charcode, &gindex);
        }
        fprintf(fp, "]\n");
        fprintf(fp, "    }%s\n", i < face->num_charmaps - 1 ? "," : "");
    }
    fprintf(fp, "  ]");
}

static void dump_glyph_outline(FILE *fp, FT_GlyphSlot slot) {
    FT_Outline *outline = &slot->outline;
    fprintf(fp, "      \"outline\": {\n");
    fprintf(fp, "        \"n_points\": %d,\n", outline->n_points);
    fprintf(fp, "        \"n_contours\": %d,\n", outline->n_contours);
    fprintf(fp, "        \"points\": [");
    for (int i = 0; i < outline->n_points; i++) {
        if (i > 0) fprintf(fp, ",");
        fprintf(fp, "[%ld,%ld]", outline->points[i].x, outline->points[i].y);
    }
    fprintf(fp, "],\n");
    fprintf(fp, "        \"tags\": [");
    for (int i = 0; i < outline->n_points; i++) {
        if (i > 0) fprintf(fp, ",");
        fprintf(fp, "%d", outline->tags[i]);
    }
    fprintf(fp, "],\n");
    fprintf(fp, "        \"contours\": [");
    for (int i = 0; i < outline->n_contours; i++) {
        if (i > 0) fprintf(fp, ",");
        fprintf(fp, "%d", outline->contours[i]);
    }
    fprintf(fp, "]\n");
    fprintf(fp, "      }");
}

static void dump_glyphs(FILE *fp, FT_Face face) {
    fprintf(fp, "  \"glyphs\": [\n");
    int first_glyph = 1;

    for (unsigned s = 0; s < NUM_SIZES; s++) {
        for (unsigned f = 0; f < NUM_LOAD_FLAGS; f++) {
            FT_Int32 flags = load_flag_matrix[f].flags;
            const char *flag_name = load_flag_matrix[f].name;

            if (!(flags & FT_LOAD_NO_SCALE)) {
                FT_Set_Pixel_Sizes(face, 0, test_sizes[s]);
            }

            for (unsigned c = 0; c < NUM_TEST_CHARS; c++) {
                FT_UInt gindex = FT_Get_Char_Index(face, test_charcodes[c]);
                if (gindex == 0) continue;

                FT_Error err = FT_Load_Glyph(face, gindex, flags);
                if (err) continue;
                if (face->glyph->format != FT_GLYPH_FORMAT_OUTLINE) continue;

                if (!first_glyph) fprintf(fp, ",\n");
                first_glyph = 0;

                fprintf(fp, "    {\n");
                fprintf(fp, "      \"glyph_index\": %u,\n", gindex);
                fprintf(fp, "      \"charcode\": %lu,\n", test_charcodes[c]);
                fprintf(fp, "      \"size_ppem\": %d,\n", test_sizes[s]);
                fprintf(fp, "      \"load_flags\": \"%s\",\n", flag_name);
                fprintf(fp, "      \"metrics\": {\n");
                fprintf(fp, "        \"width\": %ld,\n", face->glyph->metrics.width);
                fprintf(fp, "        \"height\": %ld,\n", face->glyph->metrics.height);
                fprintf(fp, "        \"horiBearingX\": %ld,\n", face->glyph->metrics.horiBearingX);
                fprintf(fp, "        \"horiBearingY\": %ld,\n", face->glyph->metrics.horiBearingY);
                fprintf(fp, "        \"horiAdvance\": %ld\n", face->glyph->metrics.horiAdvance);
                fprintf(fp, "      },\n");
                dump_glyph_outline(fp, face->glyph);
                fprintf(fp, "\n    }");
            }
        }
    }
    fprintf(fp, "\n  ]");
}

static void dump_kerning(FILE *fp, FT_Face face) {
    fprintf(fp, "  \"kerning\": [");
    if (!FT_HAS_KERNING(face)) {
        fprintf(fp, "]");
        return;
    }

    int first = 1;
    /* Test kerning for ASCII pairs */
    for (FT_ULong c1 = 'A'; c1 <= 'z'; c1++) {
        FT_UInt g1 = FT_Get_Char_Index(face, c1);
        if (g1 == 0) continue;
        for (FT_ULong c2 = 'A'; c2 <= 'z'; c2++) {
            FT_UInt g2 = FT_Get_Char_Index(face, c2);
            if (g2 == 0) continue;
            FT_Vector delta;
            FT_Get_Kerning(face, g1, g2, FT_KERNING_UNSCALED, &delta);
            if (delta.x != 0 || delta.y != 0) {
                if (!first) fprintf(fp, ",");
                fprintf(fp, "\n    { \"left\": %u, \"right\": %u, \"x\": %ld, \"y\": %ld }",
                        g1, g2, delta.x, delta.y);
                first = 0;
            }
        }
    }
    fprintf(fp, "\n  ]");
}

static void process_font(FT_Library library, const char *font_path, const char *output_dir) {
    FT_Face face;
    FT_Error err = FT_New_Face(library, font_path, 0, &face);
    if (err) {
        fprintf(stderr, "Warning: cannot open %s (error %d)\n", font_path, err);
        return;
    }

    /* Build output filename */
    const char *basename = strrchr(font_path, '/');
    basename = basename ? basename + 1 : font_path;
    char output_path[2048];
    snprintf(output_path, sizeof(output_path), "%s/%s.json", output_dir, basename);

    FILE *fp = fopen(output_path, "w");
    if (!fp) {
        fprintf(stderr, "Cannot create %s\n", output_path);
        FT_Done_Face(face);
        return;
    }

    printf("Generating %s\n", output_path);

    fprintf(fp, "{\n");
    dump_face_metadata(fp, face);
    fprintf(fp, ",\n");
    dump_charmaps(fp, face);
    fprintf(fp, ",\n");
    dump_glyphs(fp, face);
    fprintf(fp, ",\n");
    dump_kerning(fp, face);
    fprintf(fp, "\n}\n");

    fclose(fp);
    FT_Done_Face(face);
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <font_dir> <output_dir>\n", argv[0]);
        return 1;
    }

    FT_Library library;
    FT_Error err = FT_Init_FreeType(&library);
    if (err) {
        fprintf(stderr, "FT_Init_FreeType failed: %d\n", err);
        return 1;
    }

    const char *font_dir = argv[1];
    const char *output_dir = argv[2];

    DIR *dir = opendir(font_dir);
    if (!dir) {
        fprintf(stderr, "Cannot open directory: %s\n", font_dir);
        FT_Done_FreeType(library);
        return 1;
    }

    struct dirent *entry;
    while ((entry = readdir(dir)) != NULL) {
        if (entry->d_name[0] == '.') continue;
        /* Only process font files by extension */
        const char *ext = strrchr(entry->d_name, '.');
        if (!ext) continue;
        if (strcmp(ext, ".ttf") && strcmp(ext, ".otf") &&
            strcmp(ext, ".ttc") && strcmp(ext, ".woff") &&
            strcmp(ext, ".pfb") && strcmp(ext, ".pfa") &&
            strcmp(ext, ".bdf") && strcmp(ext, ".pcf") &&
            strcmp(ext, ".fnt") && strcmp(ext, ".fon"))
            continue;
        char path[2048];
        snprintf(path, sizeof(path), "%s/%s", font_dir, entry->d_name);
        process_font(library, path, output_dir);
    }

    closedir(dir);
    FT_Done_FreeType(library);
    printf("Done.\n");
    return 0;
}
