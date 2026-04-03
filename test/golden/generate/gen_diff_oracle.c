/*
 * gen_diff_oracle.c — Emit NDJSON differential oracle data from vendored FreeType.
 *
 * Usage:
 *   ./gen_diff_oracle <font_path> <output_path> [options]
 *
 * Options:
 *   --face-index N
 *   --dimensions charmaps,glyphs,render,kerning
 *   --glyph-sizes 16,36
 *   --render-sizes 16,36
 *   --kerning-max-glyphs N
 *   --variation default|non-default
 */

#include <dirent.h>
#include <ft2build.h>
#include FT_FREETYPE_H
#include FT_GLYPH_H
#include FT_MULTIPLE_MASTERS_H
#include FT_OUTLINE_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum {
    DIM_CHARMAPS = 1 << 0,
    DIM_GLYPHS   = 1 << 1,
    DIM_RENDER   = 1 << 2,
    DIM_KERNING  = 1 << 3,
};

enum {
    VARIATION_DEFAULT = 0,
    VARIATION_NON_DEFAULT = 1,
};

typedef struct {
    int face_index;
    unsigned dimensions;
    int *glyph_sizes;
    size_t num_glyph_sizes;
    int *render_sizes;
    size_t num_render_sizes;
    int kerning_max_glyphs;
    int variation_mode;
} Options;

static int default_glyph_sizes_values[] = { 16 };
static int default_render_sizes_values[] = { 16 };

static const struct {
    const char *name;
    FT_Int32 flags;
    int requires_size;
} glyph_load_matrix[] = {
    { "NO_SCALE",       FT_LOAD_NO_SCALE,       0 },
    { "DEFAULT",        FT_LOAD_DEFAULT,        1 },
    { "NO_HINTING",     FT_LOAD_NO_HINTING,     1 },
    { "FORCE_AUTOHINT", FT_LOAD_FORCE_AUTOHINT, 1 },
};

static const struct {
    const char *load_flag_name;
    FT_Int32 flags;
    const char *render_mode_name;
    FT_Render_Mode render_mode;
} render_mode_matrix[] = {
    { "NO_HINTING", FT_LOAD_NO_HINTING, "NORMAL", FT_RENDER_MODE_NORMAL },
    { "NO_HINTING", FT_LOAD_NO_HINTING, "LIGHT",  FT_RENDER_MODE_LIGHT  },
    { "NO_HINTING", FT_LOAD_NO_HINTING, "MONO",   FT_RENDER_MODE_MONO   },
    { "NO_HINTING", FT_LOAD_NO_HINTING, "LCD",    FT_RENDER_MODE_LCD    },
    { "NO_HINTING", FT_LOAD_NO_HINTING, "LCD_V",  FT_RENDER_MODE_LCD_V  },
    { "NO_HINTING", FT_LOAD_NO_HINTING, "SDF",    FT_RENDER_MODE_SDF    },
    { "DEFAULT",    FT_LOAD_DEFAULT,    "NORMAL", FT_RENDER_MODE_NORMAL },
};

static void options_init(Options *opt) {
    opt->face_index = 0;
    opt->dimensions = DIM_CHARMAPS | DIM_GLYPHS | DIM_RENDER | DIM_KERNING;
    opt->glyph_sizes = default_glyph_sizes_values;
    opt->num_glyph_sizes = sizeof(default_glyph_sizes_values) / sizeof(default_glyph_sizes_values[0]);
    opt->render_sizes = default_render_sizes_values;
    opt->num_render_sizes = sizeof(default_render_sizes_values) / sizeof(default_render_sizes_values[0]);
    opt->kerning_max_glyphs = 128;
    opt->variation_mode = VARIATION_DEFAULT;
}

static int parse_int(const char *text, int *out) {
    char *end = NULL;
    long value = strtol(text, &end, 10);
    if (!text[0] || (end && *end)) {
        return 0;
    }
    *out = (int)value;
    return 1;
}

static int parse_csv_ints(const char *text, int **values, size_t *count) {
    char *copy = strdup(text);
    char *token = NULL;
    char *rest = copy;
    int *buffer = NULL;
    size_t used = 0;
    size_t cap = 0;
    if (!copy) {
        return 0;
    }

    while ((token = strtok(rest, ",")) != NULL) {
        int value = 0;
        rest = NULL;
        if (!parse_int(token, &value)) {
            free(buffer);
            free(copy);
            return 0;
        }
        if (used == cap) {
            size_t next = cap ? cap * 2 : 4;
            int *grown = (int *)realloc(buffer, next * sizeof(int));
            if (!grown) {
                free(buffer);
                free(copy);
                return 0;
            }
            buffer = grown;
            cap = next;
        }
        buffer[used++] = value;
    }

    free(copy);
    if (used == 0) {
        free(buffer);
        return 0;
    }
    *values = buffer;
    *count = used;
    return 1;
}

static int parse_dimensions(const char *text, unsigned *dimensions) {
    char *copy = strdup(text);
    char *token = NULL;
    char *rest = copy;
    unsigned bits = 0;
    if (!copy) {
        return 0;
    }
    while ((token = strtok(rest, ",")) != NULL) {
        rest = NULL;
        if (strcmp(token, "charmaps") == 0) {
            bits |= DIM_CHARMAPS;
        } else if (strcmp(token, "glyphs") == 0) {
            bits |= DIM_GLYPHS;
        } else if (strcmp(token, "render") == 0) {
            bits |= DIM_RENDER;
        } else if (strcmp(token, "kerning") == 0) {
            bits |= DIM_KERNING;
        } else {
            free(copy);
            return 0;
        }
    }
    free(copy);
    if (!bits) {
        return 0;
    }
    *dimensions = bits;
    return 1;
}

static int parse_args(
    int argc,
    char **argv,
    Options *opt,
    const char **font_path,
    const char **output_path
) {
    int i = 0;
    if (argc < 3) {
        return 0;
    }

    *font_path = argv[1];
    *output_path = argv[2];

    for (i = 3; i < argc; i++) {
        if (strcmp(argv[i], "--face-index") == 0 && i + 1 < argc) {
            if (!parse_int(argv[++i], &opt->face_index)) {
                return 0;
            }
        } else if (strcmp(argv[i], "--dimensions") == 0 && i + 1 < argc) {
            if (!parse_dimensions(argv[++i], &opt->dimensions)) {
                return 0;
            }
        } else if (strcmp(argv[i], "--glyph-sizes") == 0 && i + 1 < argc) {
            int *values = NULL;
            size_t count = 0;
            if (!parse_csv_ints(argv[++i], &values, &count)) {
                return 0;
            }
            opt->glyph_sizes = values;
            opt->num_glyph_sizes = count;
        } else if (strcmp(argv[i], "--render-sizes") == 0 && i + 1 < argc) {
            int *values = NULL;
            size_t count = 0;
            if (!parse_csv_ints(argv[++i], &values, &count)) {
                return 0;
            }
            opt->render_sizes = values;
            opt->num_render_sizes = count;
        } else if (strcmp(argv[i], "--kerning-max-glyphs") == 0 && i + 1 < argc) {
            if (!parse_int(argv[++i], &opt->kerning_max_glyphs)) {
                return 0;
            }
        } else if (strcmp(argv[i], "--variation") == 0 && i + 1 < argc) {
            const char *mode = argv[++i];
            if (strcmp(mode, "default") == 0) {
                opt->variation_mode = VARIATION_DEFAULT;
            } else if (strcmp(mode, "non-default") == 0) {
                opt->variation_mode = VARIATION_NON_DEFAULT;
            } else {
                return 0;
            }
        } else {
            return 0;
        }
    }

    return 1;
}

static void options_free(Options *opt) {
    if (opt->glyph_sizes != default_glyph_sizes_values) {
        free(opt->glyph_sizes);
    }
    if (opt->render_sizes != default_render_sizes_values) {
        free(opt->render_sizes);
    }
}

static void json_write_string(FILE *fp, const char *text) {
    const unsigned char *p = (const unsigned char *)text;
    fputc('"', fp);
    while (*p) {
        switch (*p) {
            case '\\': fputs("\\\\", fp); break;
            case '"': fputs("\\\"", fp); break;
            case '\n': fputs("\\n", fp); break;
            case '\r': fputs("\\r", fp); break;
            case '\t': fputs("\\t", fp); break;
            default:
                if (*p < 0x20) {
                    fprintf(fp, "\\u%04x", *p);
                } else {
                    fputc(*p, fp);
                }
        }
        p++;
    }
    fputc('"', fp);
}

static void dump_hex_bytes(FILE *fp, const unsigned char *data, size_t length) {
    size_t i = 0;
    fputc('"', fp);
    for (i = 0; i < length; i++) {
        fprintf(fp, "%02x", data[i]);
    }
    fputc('"', fp);
}

static const char *pixel_mode_name(unsigned mode) {
    switch (mode) {
        case FT_PIXEL_MODE_MONO: return "Mono";
        case FT_PIXEL_MODE_GRAY: return "Gray";
        case FT_PIXEL_MODE_GRAY2: return "Gray2";
        case FT_PIXEL_MODE_GRAY4: return "Gray4";
        case FT_PIXEL_MODE_LCD: return "Lcd";
        case FT_PIXEL_MODE_LCD_V: return "LcdV";
        case FT_PIXEL_MODE_BGRA: return "Bgra";
        default: return "None";
    }
}

static void emit_metrics(FILE *fp, FT_Glyph_Metrics *metrics) {
    fprintf(
        fp,
        "\"metrics\":{\"width\":%ld,\"height\":%ld,\"hori_bearing_x\":%ld,"
        "\"hori_bearing_y\":%ld,\"hori_advance\":%ld}",
        metrics->width,
        metrics->height,
        metrics->horiBearingX,
        metrics->horiBearingY,
        metrics->horiAdvance
    );
}

static void emit_outline(FILE *fp, FT_Outline *outline) {
    int i = 0;
    fprintf(fp, "\"outline\":{\"n_points\":%d,\"n_contours\":%d,", outline->n_points, outline->n_contours);

    fputs("\"points\":[", fp);
    for (i = 0; i < outline->n_points; i++) {
        if (i) fputc(',', fp);
        fprintf(fp, "[%ld,%ld]", outline->points[i].x, outline->points[i].y);
    }
    fputs("],", fp);

    fputs("\"tags\":[", fp);
    for (i = 0; i < outline->n_points; i++) {
        if (i) fputc(',', fp);
        fprintf(fp, "%u", (unsigned)outline->tags[i]);
    }
    fputs("],", fp);

    fputs("\"contours\":[", fp);
    for (i = 0; i < outline->n_contours; i++) {
        if (i) fputc(',', fp);
        fprintf(fp, "%d", outline->contours[i]);
    }
    fputs("]}", fp);
}

static void emit_bitmap(FILE *fp, FT_GlyphSlot slot) {
    FT_Bitmap *bitmap = &slot->bitmap;
    size_t pitch = (size_t)(bitmap->pitch < 0 ? -bitmap->pitch : bitmap->pitch);
    size_t length = (size_t)bitmap->rows * pitch;
    fprintf(
        fp,
        "\"bitmap\":{\"width\":%u,\"rows\":%u,\"pitch\":%d,\"pixel_mode\":",
        bitmap->width,
        bitmap->rows,
        bitmap->pitch
    );
    json_write_string(fp, pixel_mode_name(bitmap->pixel_mode));
    fprintf(fp, ",\"num_grays\":%u,\"left\":%d,\"top\":%d,\"buffer_hex\":", bitmap->num_grays, slot->bitmap_left, slot->bitmap_top);
    dump_hex_bytes(fp, bitmap->buffer, length);
    fputs("}", fp);
}

static void emit_variation_coords(
    FILE *fp,
    FT_MM_Var *mmvar,
    FT_Fixed *coords
) {
    FT_UInt i = 0;
    fputs("[", fp);
    if (mmvar && coords) {
        for (i = 0; i < mmvar->num_axis; i++) {
            FT_Tag tag = mmvar->axis[i].tag;
            if (i) fputc(',', fp);
            fprintf(
                fp,
                "[\"%c%c%c%c\",%ld]",
                (char)((tag >> 24) & 0xFF),
                (char)((tag >> 16) & 0xFF),
                (char)((tag >> 8) & 0xFF),
                (char)(tag & 0xFF),
                (long)coords[i]
            );
        }
    }
    fputs("]", fp);
}

static void emit_header(
    FILE *fp,
    FT_Face face,
    const char *font_path,
    const Options *opt,
    FT_MM_Var *mmvar,
    FT_Fixed *coords
) {
    const char *basename = strrchr(font_path, '/');
    basename = basename ? basename + 1 : font_path;
    fputs("{\"kind\":\"header\",\"font\":", fp);
    json_write_string(fp, basename);
    fprintf(fp, ",\"face_index\":%d,\"num_glyphs\":%ld,\"variation_coords\":", opt->face_index, face->num_glyphs);
    emit_variation_coords(fp, mmvar, coords);
    fputs("}\n", fp);
}

static int choose_variation_coords(
    FT_Library library,
    FT_Face face,
    FT_MM_Var **mmvar_out,
    FT_Fixed **coords_out,
    FT_Fixed **defaults_out
) {
    FT_MM_Var *mmvar = NULL;
    FT_Fixed *coords = NULL;
    FT_Fixed *defaults = NULL;
    FT_UInt i = 0;
    int has_non_default = 0;

    if (FT_Get_MM_Var(face, &mmvar) || !mmvar || mmvar->num_axis == 0) {
        if (mmvar) {
            FT_Done_MM_Var(library, mmvar);
        }
        *mmvar_out = NULL;
        *coords_out = NULL;
        *defaults_out = NULL;
        return 0;
    }

    coords = (FT_Fixed *)calloc(mmvar->num_axis, sizeof(FT_Fixed));
    defaults = (FT_Fixed *)calloc(mmvar->num_axis, sizeof(FT_Fixed));
    if (!coords || !defaults) {
        free(coords);
        free(defaults);
        FT_Done_MM_Var(library, mmvar);
        *mmvar_out = NULL;
        *coords_out = NULL;
        *defaults_out = NULL;
        return 0;
    }

    for (i = 0; i < mmvar->num_axis; i++) {
        FT_Var_Axis axis = mmvar->axis[i];
        FT_Fixed min_dist = axis.def - axis.minimum;
        FT_Fixed max_dist = axis.maximum - axis.def;
        if (min_dist < 0) min_dist = -min_dist;
        if (max_dist < 0) max_dist = -max_dist;
        defaults[i] = axis.def;
        coords[i] = (max_dist > min_dist) ? axis.maximum : axis.minimum;
        if (coords[i] != defaults[i]) {
            has_non_default = 1;
        }
    }

    if (!has_non_default) {
        FT_Done_MM_Var(library, mmvar);
        free(coords);
        free(defaults);
        *mmvar_out = NULL;
        *coords_out = NULL;
        *defaults_out = NULL;
        return 0;
    }

    *mmvar_out = mmvar;
    *coords_out = coords;
    *defaults_out = defaults;
    return 1;
}

static void emit_charmap_cases(FILE *fp, FT_Face face) {
    int i = 0;
    for (i = 0; i < face->num_charmaps; i++) {
        FT_CharMap cm = face->charmaps[i];
        FT_UInt gindex = 0;
        FT_ULong charcode = 0;
        fprintf(
            fp,
            "{\"kind\":\"charmap_meta\",\"charmap_index\":%d,\"platform_id\":%u,\"encoding_id\":%u}\n",
            i,
            cm->platform_id,
            cm->encoding_id
        );
        FT_Set_Charmap(face, cm);
        charcode = FT_Get_First_Char(face, &gindex);
        while (gindex != 0) {
            fprintf(
                fp,
                "{\"kind\":\"charmap_entry\",\"charmap_index\":%d,\"charcode\":%lu,\"glyph_index\":%u}\n",
                i,
                charcode,
                gindex
            );
            charcode = FT_Get_Next_Char(face, charcode, &gindex);
        }
    }
}

static void emit_loaded_glyph_case(
    FILE *fp,
    FT_Face face,
    FT_UInt glyph_index,
    const char *flag_name,
    int size_ppem
) {
    FT_GlyphSlot slot = face->glyph;
    if (slot->format == FT_GLYPH_FORMAT_SVG) {
        return;
    }

    if (slot->format == FT_GLYPH_FORMAT_OUTLINE) {
        fprintf(
            fp,
            "{\"kind\":\"glyph_outline\",\"glyph_index\":%u,\"size_ppem\":%d,\"load_flags\":",
            glyph_index,
            size_ppem
        );
        json_write_string(fp, flag_name);
        fputc(',', fp);
        emit_metrics(fp, &slot->metrics);
        fputc(',', fp);
        emit_outline(fp, &slot->outline);
        fputs("}\n", fp);
    } else if (slot->format == FT_GLYPH_FORMAT_BITMAP) {
        fprintf(
            fp,
            "{\"kind\":\"glyph_bitmap\",\"glyph_index\":%u,\"size_ppem\":%d,\"load_flags\":",
            glyph_index,
            size_ppem
        );
        json_write_string(fp, flag_name);
        fputc(',', fp);
        emit_metrics(fp, &slot->metrics);
        fputc(',', fp);
        emit_bitmap(fp, slot);
        fputs("}\n", fp);
    }
}

static void emit_glyph_cases(FILE *fp, FT_Face face, const Options *opt) {
    FT_UInt gid = 0;
    size_t i = 0;
    size_t s = 0;
    int scalable = (face->face_flags & FT_FACE_FLAG_SCALABLE) != 0;

    for (i = 0; i < sizeof(glyph_load_matrix) / sizeof(glyph_load_matrix[0]); i++) {
        const char *flag_name = glyph_load_matrix[i].name;
        FT_Int32 flags = glyph_load_matrix[i].flags;

        if (!scalable && flags != FT_LOAD_DEFAULT) {
            continue;
        }

        if (glyph_load_matrix[i].requires_size && scalable) {
            for (s = 0; s < opt->num_glyph_sizes; s++) {
                int size_ppem = opt->glyph_sizes[s];
                if (FT_Set_Pixel_Sizes(face, 0, size_ppem) != 0) {
                    continue;
                }
                for (gid = 0; gid < (FT_UInt)face->num_glyphs; gid++) {
                    if (FT_Load_Glyph(face, gid, flags) == 0) {
                        emit_loaded_glyph_case(fp, face, gid, flag_name, size_ppem);
                    }
                }
            }
        } else {
            for (gid = 0; gid < (FT_UInt)face->num_glyphs; gid++) {
                if (FT_Load_Glyph(face, gid, flags) == 0) {
                    emit_loaded_glyph_case(fp, face, gid, flag_name, 0);
                }
            }
        }
    }
}

static void emit_render_case(
    FILE *fp,
    FT_Face face,
    FT_UInt glyph_index,
    const char *load_flag_name,
    const char *render_mode_name,
    int size_ppem
) {
    FT_GlyphSlot slot = face->glyph;
    if (slot->format != FT_GLYPH_FORMAT_BITMAP) {
        return;
    }
    fprintf(
        fp,
        "{\"kind\":\"render_bitmap\",\"glyph_index\":%u,\"size_ppem\":%d,\"load_flags\":",
        glyph_index,
        size_ppem
    );
    json_write_string(fp, load_flag_name);
    fputs(",\"render_mode\":", fp);
    json_write_string(fp, render_mode_name);
    fputc(',', fp);
    emit_bitmap(fp, slot);
    fputs("}\n", fp);
}

static void emit_render_cases(FILE *fp, FT_Face face, const Options *opt) {
    size_t s = 0;
    size_t m = 0;
    FT_UInt gid = 0;
    int scalable = (face->face_flags & FT_FACE_FLAG_SCALABLE) != 0;

    if (!scalable) {
        return;
    }

    for (s = 0; s < opt->num_render_sizes; s++) {
        int size_ppem = opt->render_sizes[s];
        if (FT_Set_Pixel_Sizes(face, 0, size_ppem) != 0) {
            continue;
        }
        for (gid = 0; gid < (FT_UInt)face->num_glyphs; gid++) {
            for (m = 0; m < sizeof(render_mode_matrix) / sizeof(render_mode_matrix[0]); m++) {
                FT_Error err = FT_Load_Glyph(face, gid, render_mode_matrix[m].flags);
                if (err) {
                    continue;
                }
                if (face->glyph->format == FT_GLYPH_FORMAT_SVG) {
                    continue;
                }
                if (face->glyph->format == FT_GLYPH_FORMAT_OUTLINE ||
                    render_mode_matrix[m].render_mode == FT_RENDER_MODE_SDF) {
                    err = FT_Render_Glyph(face->glyph, render_mode_matrix[m].render_mode);
                    if (err) {
                        continue;
                    }
                }
                emit_render_case(
                    fp,
                    face,
                    gid,
                    render_mode_matrix[m].load_flag_name,
                    render_mode_matrix[m].render_mode_name,
                    size_ppem
                );
            }
            if (face->face_flags & FT_FACE_FLAG_COLOR) {
                FT_Error err = FT_Load_Glyph(face, gid, FT_LOAD_COLOR | FT_LOAD_NO_HINTING);
                if (err) {
                    continue;
                }
                if (face->glyph->format == FT_GLYPH_FORMAT_BITMAP) {
                    emit_render_case(fp, face, gid, "COLOR_NO_HINTING", "NORMAL", size_ppem);
                }
            }
        }
    }
}

static void emit_kerning_cases(FILE *fp, FT_Face face, const Options *opt) {
    FT_UInt left = 0;
    FT_UInt right = 0;
    if (!FT_HAS_KERNING(face)) {
        return;
    }
    if (face->num_glyphs > opt->kerning_max_glyphs) {
        return;
    }
    for (left = 0; left < (FT_UInt)face->num_glyphs; left++) {
        for (right = 0; right < (FT_UInt)face->num_glyphs; right++) {
            FT_Vector delta;
            if (FT_Get_Kerning(face, left, right, FT_KERNING_UNSCALED, &delta) != 0) {
                continue;
            }
            fprintf(
                fp,
                "{\"kind\":\"kerning\",\"left\":%u,\"right\":%u,\"x\":%ld,\"y\":%ld}\n",
                left,
                right,
                delta.x,
                delta.y
            );
        }
    }
}

int main(int argc, char *argv[]) {
    FT_Library library;
    FT_Face face;
    FT_MM_Var *mmvar = NULL;
    FT_Fixed *coords = NULL;
    FT_Fixed *defaults = NULL;
    FILE *fp = NULL;
    Options opt;
    const char *font_path = NULL;
    const char *output_path = NULL;
    int has_non_default_variation = 0;

    options_init(&opt);
    if (!parse_args(argc, argv, &opt, &font_path, &output_path)) {
        fprintf(
            stderr,
            "Usage: %s <font_path> <output_path> [--face-index N] "
            "[--dimensions charmaps,glyphs,render,kerning] [--glyph-sizes 16,36] "
            "[--render-sizes 16,36] [--kerning-max-glyphs N] "
            "[--variation default|non-default]\n",
            argv[0]
        );
        options_free(&opt);
        return 1;
    }

    if (FT_Init_FreeType(&library) != 0) {
        fprintf(stderr, "FT_Init_FreeType failed\n");
        options_free(&opt);
        return 1;
    }
    if (FT_New_Face(library, font_path, opt.face_index, &face) != 0) {
        fprintf(stderr, "Cannot open %s\n", font_path);
        FT_Done_FreeType(library);
        options_free(&opt);
        return 1;
    }

    if (opt.variation_mode == VARIATION_NON_DEFAULT) {
        has_non_default_variation = choose_variation_coords(library, face, &mmvar, &coords, &defaults);
        if (has_non_default_variation) {
            FT_Set_Var_Design_Coordinates(face, mmvar->num_axis, coords);
        }
    }

    fp = fopen(output_path, "w");
    if (!fp) {
        fprintf(stderr, "Cannot create %s\n", output_path);
        if (mmvar) FT_Done_MM_Var(library, mmvar);
        free(coords);
        free(defaults);
        FT_Done_Face(face);
        FT_Done_FreeType(library);
        options_free(&opt);
        return 1;
    }

    emit_header(fp, face, font_path, &opt, mmvar, coords);
    if (opt.dimensions & DIM_CHARMAPS) {
        emit_charmap_cases(fp, face);
    }
    if (opt.dimensions & DIM_GLYPHS) {
        emit_glyph_cases(fp, face, &opt);
    }
    if (opt.dimensions & DIM_RENDER) {
        emit_render_cases(fp, face, &opt);
    }
    if (opt.dimensions & DIM_KERNING) {
        emit_kerning_cases(fp, face, &opt);
    }

    fclose(fp);
    if (mmvar) {
        FT_Set_Var_Design_Coordinates(face, mmvar->num_axis, defaults);
        FT_Done_MM_Var(library, mmvar);
    }
    free(coords);
    free(defaults);
    FT_Done_Face(face);
    FT_Done_FreeType(library);
    options_free(&opt);
    return 0;
}
