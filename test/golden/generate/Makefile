FREETYPE_DIR = ../../../vendor/freetype-c
CC ?= cc
CFLAGS = -Wall -Wextra -O2 -I$(FREETYPE_DIR)/include
LDFLAGS = -L$(FREETYPE_DIR)/objs -lfreetype -lz -lm -lbz2 -lpng

FONT_DIR = ../../fonts
OUTPUT_DIR = ../data

.PHONY: all clean generate

all: gen_golden

gen_golden: gen_golden.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS) 2>/dev/null || \
	$(CC) $(CFLAGS) -o $@ $< -L$(FREETYPE_DIR)/objs -lfreetype -lz -lm

generate: gen_golden
	@mkdir -p $(OUTPUT_DIR)
	./gen_golden $(FONT_DIR) $(OUTPUT_DIR)

clean:
	rm -f gen_golden
