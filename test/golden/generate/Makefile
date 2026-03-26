FREETYPE_DIR = ../../../vendor/freetype-c
CC ?= cc
CFLAGS = -Wall -Wextra -O2 -I$(FREETYPE_DIR)/include

# Find zlib: prefer -lz, fall back to libz.so.1 on systems without zlib-dev
ZLIB := $(shell $(CC) -lz -xc /dev/null -o /dev/null 2>/dev/null && echo "-lz" || echo "")
ifeq ($(ZLIB),)
  ZLIB := $(wildcard /usr/lib/x86_64-linux-gnu/libz.so.1)
  ifeq ($(ZLIB),)
    ZLIB := $(wildcard /usr/lib/libz.so.1)
  endif
endif

LDFLAGS = -L$(FREETYPE_DIR)/objs -lfreetype $(ZLIB) -lm

FONT_DIR = ../../fonts
OUTPUT_DIR = ../data

.PHONY: all clean generate

all: gen_golden

gen_golden: gen_golden.c $(FREETYPE_DIR)/objs/libfreetype.a
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

generate: gen_golden
	@mkdir -p $(OUTPUT_DIR)
	python3 generate.py $(FONT_DIR) $(OUTPUT_DIR)

clean:
	rm -f gen_golden
