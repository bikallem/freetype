/*
 * bench_c.c — C FreeType benchmark for comparison with MoonBit port.
 * Build: make -C bench bench_c
 * Usage: ./bench/bench_c test/fonts/
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <dirent.h>
#include <ft2build.h>
#include FT_FREETYPE_H

static long long now_ns(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (long long)ts.tv_sec * 1000000000LL + ts.tv_nsec;
}

typedef struct {
    const char *name;
    const char *path;
    const char *format;
} FontEntry;

static FontEntry fonts[32];
static int num_fonts = 0;

static void add_font(const char *dir, const char *name, const char *format) {
    if (num_fonts >= 32) return;
    char *path = malloc(strlen(dir) + strlen(name) + 2);
    sprintf(path, "%s/%s", dir, name);
    FILE *f = fopen(path, "r");
    if (!f) { free(path); return; }
    fclose(f);
    fonts[num_fonts].name = strdup(name);
    fonts[num_fonts].path = path;
    fonts[num_fonts].format = format;
    num_fonts++;
}

static void discover_fonts(const char *dir) {
    add_font(dir, "DejaVuSans.ttf", "TrueType");
    add_font(dir, "Roboto[wdth,wght].ttf", "TrueType Variable");
    add_font(dir, "SourceCodePro-Regular.otf", "CFF/OpenType");
    add_font(dir, "NotoSansJP-Regular.otf", "CFF/OpenType CJK");
    add_font(dir, "DejaVuSans.woff", "WOFF1");
    add_font(dir, "DejaVuSans.ttc", "TrueType Collection");
    add_font(dir, "NimbusSans-Regular.pfb", "Type 1 PFB");
    add_font(dir, "unifont.bdf", "BDF Bitmap");
}

static unsigned char *read_file(const char *path, long *size) {
    FILE *f = fopen(path, "rb");
    if (!f) return NULL;
    fseek(f, 0, SEEK_END);
    *size = ftell(f);
    fseek(f, 0, SEEK_SET);
    unsigned char *buf = malloc(*size);
    fread(buf, 1, *size, f);
    fclose(f);
    return buf;
}

#define WARMUP 3
#define ITERS 100

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <font_dir>\n", argv[0]);
        return 1;
    }

    FT_Library library;
    FT_Init_FreeType(&library);

    discover_fonts(argv[1]);

    printf("{\n  \"engine\": \"C FreeType\",\n  \"results\": [\n");

    for (int fi = 0; fi < num_fonts; fi++) {
        long file_size;
        unsigned char *data = read_file(fonts[fi].path, &file_size);
        if (!data) continue;

        /* Benchmark: face_load */
        long long t0, t1;
        for (int w = 0; w < WARMUP; w++) {
            FT_Face face;
            FT_New_Memory_Face(library, data, file_size, 0, &face);
            FT_Done_Face(face);
        }
        t0 = now_ns();
        for (int i = 0; i < ITERS; i++) {
            FT_Face face;
            FT_New_Memory_Face(library, data, file_size, 0, &face);
            FT_Done_Face(face);
        }
        t1 = now_ns();
        long long face_load_ns = (t1 - t0) / ITERS;

        /* Load face for remaining benchmarks */
        FT_Face face;
        FT_New_Memory_Face(library, data, file_size, 0, &face);

        /* Benchmark: cmap_lookup (ASCII chars) */
        for (int w = 0; w < WARMUP; w++)
            for (int c = 32; c < 127; c++)
                FT_Get_Char_Index(face, c);
        t0 = now_ns();
        for (int i = 0; i < ITERS; i++)
            for (int c = 32; c < 127; c++)
                FT_Get_Char_Index(face, c);
        t1 = now_ns();
        long long cmap_ns = (t1 - t0) / ITERS;

        /* Benchmark: glyph_load NO_SCALE */
        FT_UInt gid_A = FT_Get_Char_Index(face, 'A');
        long long glyph_noscale_ns = 0;
        if (gid_A && FT_IS_SCALABLE(face)) {
            for (int w = 0; w < WARMUP; w++)
                FT_Load_Glyph(face, gid_A, FT_LOAD_NO_SCALE);
            t0 = now_ns();
            for (int i = 0; i < ITERS * 10; i++)
                FT_Load_Glyph(face, gid_A, FT_LOAD_NO_SCALE);
            t1 = now_ns();
            glyph_noscale_ns = (t1 - t0) / (ITERS * 10);
        }

        /* Benchmark: glyph_load DEFAULT (hinted) at 16ppem */
        long long glyph_hinted_ns = 0;
        if (gid_A && FT_IS_SCALABLE(face)) {
            FT_Set_Pixel_Sizes(face, 0, 16);
            for (int w = 0; w < WARMUP; w++)
                FT_Load_Glyph(face, gid_A, FT_LOAD_DEFAULT);
            t0 = now_ns();
            for (int i = 0; i < ITERS * 10; i++)
                FT_Load_Glyph(face, gid_A, FT_LOAD_DEFAULT);
            t1 = now_ns();
            glyph_hinted_ns = (t1 - t0) / (ITERS * 10);
        }

        printf("    {\"font\": \"%s\", \"format\": \"%s\", \"size_kb\": %ld, "
               "\"face_load_ns\": %lld, \"cmap_lookup_ns\": %lld, "
               "\"glyph_noscale_ns\": %lld, \"glyph_hinted_ns\": %lld}%s\n",
               fonts[fi].name, fonts[fi].format, file_size / 1024,
               face_load_ns, cmap_ns, glyph_noscale_ns, glyph_hinted_ns,
               fi < num_fonts - 1 ? "," : "");

        FT_Done_Face(face);
        free(data);
    }

    printf("  ]\n}\n");
    FT_Done_FreeType(library);
    return 0;
}
