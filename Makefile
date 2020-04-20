
export TEXINPUTS:=.:./src:./texmf:$(TEXINPUTS)

BOOK_TEX = src/book.tex
BOOK_PDF = build/book.pdf

PATCHSHOT_PNG := $(shell grep \
		--no-filename \
		--only-matching \
		--perl-regexp \
		"\\includegraphics\{\Kprojects\/.*\.png(?=\})" \
		src/*.tex \
		)

IMAGES_SVG := $(shell find images -name "*.svg")
IMAGES_PDF := $(IMAGES_SVG:%.svg=%.pdf)

SKETCHES_SVG := $(shell find sketches -name "*.svg")
SKETCHES_PDF := $(SKETCHES_SVG:%.svg=%.pdf)

EMOJI_SVG := $(shell find emoji -name "*.svg")
EMOJI_PDF := $(EMOJI_SVG:%.svg=%.pdf)

PLOTS_PY := $(shell find plots -name "*.py")
PLOTS_PDF := $(PLOTS_PY:%.py=%.pdf)

BOOK_PDF_DEPS = $(wildcard src/*.tex) \
		$(PATCHSHOT_PNG) \
		$(IMAGES_PDF) \
		$(SKETCHES_PDF) \
		$(PLOTS_PDF) \
		$(EMOJI_PDF)

.PHONY: pdf
pdf: $(BOOK_PDF)

.PHONY: clean
clean:
	rm -rf build

# Set up Python virtual environment and install required Pandoc filters
# which are written in Python.
venv: venv/bin/activate

venv/bin/activate: requirements.txt
	test -d venv || python3 -m venv venv
	. venv/bin/activate; \
	  pip install -r requirements.txt
	touch venv/bin/activate

$(BOOK_PDF): $(BOOK_PDF_DEPS)
	@# build/src is required to mimic the original structure (./src) which
	@# is necessary for `\include` to work in our case of out-of-source build
	@mkdir -p build/src
	latexmk -xelatex -output-directory=build -interaction=nonstopmode $(BOOK_TEX)

%.pdf: %.svg
	@echo "Converting sketch SVG to PDF..."
	@mkdir -p build/sketches
	rsvg-convert \
	    --format pdf \
	    --keep-aspect-ratio \
	    --dpi-x 96 \
	    --dpi-y 96 \
	    --output $@ \
	    $<

%.pdf: %.py venv
	@echo "Rendering generative matplotlib plot to PDF..."
	. venv/bin/activate; \
	  python $< $@

# The actual list of required patch screenshots is extracted with grep into
# $(PATCHSHOT_PNG). An unfortunate feature is that `screenshot-xodball`
# requires project file name *and* a patch name. Both are encoded in the
# output filename. For example: `fm-radio.01-quickstart.patch.png`
# requires a screenshot from project `fm-radio.xodball` → patch
# `01-quickstart`. Since `make` does not support multiple template options,
# the trick with .SECONDEXPANSION is used.
# See: https://stackoverflow.com/questions/39151235/gnu-make-with-multiple-in-pattern-rule
.SECONDEXPANSION:
projects/%.nofx.png: projects/$$(word 1,$$(subst --, ,$$*)).xodball
	@# Ex: screenshot-xodball projects/fm-radio.xodball 01-quickstart fm-radio--01-quickstart.nofx.png
	screenshot-xodball $< $(word 2,$(subst --, ,$*)) $@

projects/%.png: projects/%.nofx.png
	@echo "Applying grayscale filter to patch screenshot..."
	convert $< \
	    -channel RGB -negate \
	    -level "0%,80%" \
	    -grayscale Rec601Luma \
	    $@
