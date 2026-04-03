.PHONY: all build test contracts fmt clean parity bench check

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
PARITY_MODE ?= sampled

parity: | $(FONT_DIR)/.downloaded
	@set -e; \
	run_sampled() { \
		mkdir -p $(GOLDEN_DATA); \
		if [ ! -x $(GOLDEN_GEN) ]; then \
			$(MAKE) -C test/golden/generate gen_golden 2>/dev/null || true; \
		fi; \
		if [ -x $(GOLDEN_GEN) ]; then \
			python3 test/golden/generate/generate.py $(FONT_DIR) $(GOLDEN_DATA) >/dev/null; \
		fi; \
		python3 test/parity/gen_parity_tests.py >/dev/null; \
		python3 test/parity/report.py; \
	}; \
	case "$(PARITY_MODE)" in \
		sampled) \
			run_sampled; \
			;; \
		exhaustive) \
			python3 test/parity/exhaustive.py --config test/parity/exhaustive_ci.json; \
			;; \
		fuzz) \
			python3 test/parity/fuzz_diff.py; \
			;; \
		fuzz-smoke) \
			python3 test/parity/fuzz_diff.py --cases 4 --max-ops 2; \
			;; \
		all) \
			run_sampled; \
			python3 test/parity/exhaustive.py --config test/parity/exhaustive_ci.json; \
			python3 test/parity/fuzz_diff.py --cases 4 --max-ops 2; \
			;; \
		*) \
			echo "Unknown PARITY_MODE=$(PARITY_MODE)"; \
			echo "Use one of: sampled, exhaustive, fuzz, fuzz-smoke, all"; \
			exit 2; \
			;; \
	esac

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
