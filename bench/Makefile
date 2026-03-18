FREETYPE_DIR = ../vendor/freetype-c
CC ?= cc
CFLAGS = -Wall -O2 -I$(FREETYPE_DIR)/include
ZLIB := $(wildcard /usr/lib/x86_64-linux-gnu/libz.so.1)
ifeq ($(ZLIB),)
  ZLIB := -lz
endif
LDFLAGS = -L$(FREETYPE_DIR)/objs -lfreetype $(ZLIB) -lm

.PHONY: all clean run

all: bench_c

bench_c: bench_c.c $(FREETYPE_DIR)/objs/libfreetype.a
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

clean:
	rm -f bench_c
