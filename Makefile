.PHONY: all build test contracts fmt clean parity parity-tests parity-exhaustive parity-exhaustive-ci parity-fuzz parity-fuzz-smoke bench check

# Default: build, format, and test (no bench — it's slow)
all: build fmt test parity info

# ── Build ──────────────────────────────────────────────────────────
build:
	moon build

check:
	moon check

# ── Format ─────────────────────────────────────────────────────────
fmt:
	moon fmt
	moon info

# ── Test ───────────────────────────────────────────────────────────
test:
	moon test

contracts:
	moon test src --target native --filter 'contract/*'

# ── Info ───────────────────────────────────────────────────────────
info: 
	moon info

# ── Clean ──────────────────────────────────────────────────────────
clean:
	moon clean
	rm -f test/golden/generate/gen_golden
	rm -f test/golden/data/*.json test/golden/data/.stamp
	rm -f test/fonts/.downloaded

# ── Parity (golden file tests) ─────────────────────────────────────
#
# Workflow:
#   1. Download test fonts (if not present).
#   2. Build the C golden-file generator (requires vendored FreeType
#      to be compiled first: make -C vendor/freetype-c).
#   3. Generate golden JSON files from C FreeType.
#
# If the vendored FreeType is not compiled, parity prints a message
# and succeeds — this allows `make all` to work on fresh checkouts.
#
GOLDEN_GEN  := test/golden/generate/gen_golden
GOLDEN_DATA := test/golden/data
FONT_DIR    := test/fonts

parity: parity-golden parity-tests parity-report

parity-golden: | $(FONT_DIR)/.downloaded
	@mkdir -p $(GOLDEN_DATA)
	@if [ ! -x $(GOLDEN_GEN) ]; then \
		$(MAKE) -C test/golden/generate gen_golden 2>/dev/null || true; \
	fi
	@if [ -x $(GOLDEN_GEN) ]; then \
		python3 test/golden/generate/generate.py $(FONT_DIR) $(GOLDEN_DATA) >/dev/null; \
	fi

parity-tests: parity-golden
	@python3 test/parity/gen_parity_tests.py >/dev/null

parity-report: parity-golden
	@python3 test/parity/report.py

parity-exhaustive:
	@python3 test/parity/exhaustive.py --config test/parity/exhaustive_ci.json

parity-exhaustive-ci:
	@python3 test/parity/exhaustive.py --config test/parity/exhaustive_ci.json

parity-fuzz:
	@python3 test/parity/fuzz_diff.py

parity-fuzz-smoke:
	@python3 test/parity/fuzz_diff.py --cases 4 --max-ops 2

$(FONT_DIR)/.downloaded:
	@mkdir -p $(FONT_DIR)
	@if [ -z "$$(find $(FONT_DIR) -maxdepth 1 \( -name '*.ttf' -o -name '*.otf' \) 2>/dev/null)" ]; then \
		echo "parity: downloading test fonts..."; \
		bash $(FONT_DIR)/download.sh || true; \
	fi
	@touch $@

# ── Bench ──────────────────────────────────────────────────────────
bench:
	@python3 bench/report.py
