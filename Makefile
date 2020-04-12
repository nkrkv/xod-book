
BOOK_TEX = src/book.tex
BOOK_PDF = build/book.pdf

PATCHSHOT_PNG := $(shell grep \
		--no-filename \
		--only-matching \
		--perl-regexp \
		"\\includegraphics\{\K.*.patch.png(?=\})" \
		src/*.tex \
		)

SKETCHES_SVG := $(shell find sketches -name "*.svg")
SKETCHES_PDF := $(SKETCHES_SVG:%.svg=%.pdf)

BOOK_PDF_DEPS = $(wildcard src/*.tex) \
		$(PATCHSHOT_PNG) \
		$(SKETCHES_PDF)


.PHONY: pdf
pdf: $(BOOK_PDF)

.PHONY: clean
clean:
	rm -f $(BOOK_PDF)

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
	xelatex --output-directory build --interaction nonstopmode $(BOOK_TEX)

build/patchshots:
	mkdir -p build/patchshots

patchshots:
	mkdir -p patchshots

sketches/%.pdf: sketches/%.svg
	@echo "Converting sketch SVG to PDF..."
	@mkdir -p build/sketches
	rsvg-convert \
	    --format pdf \
	    --keep-aspect-ratio \
	    --dpi-x 96 \
	    --dpi-y 96 \
	    --output $@ \
	    $<

.SECONDEXPANSION:
patchshots/%.patch.png: projects/$$(word 1,$$(subst ., ,$$*)).xodball patchshots build/patchshots
	@# Ex: screenshot-xodball projects/fm-radio.xodball 01-quickstart prefilter.fm-radio.01-quickstart.patch.png
	screenshot-xodball $< $(word 2,$(subst ., ,$@)) build/$@
	convert build/$@ \
	    -channel RGB -negate \
	    -level "0%,80%" \
	    -grayscale Rec601Luma \
	    $@
