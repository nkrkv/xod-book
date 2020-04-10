
SRC_DIR = src
OUT_DIR = build

BOOK_XML = $(OUT_DIR)/book.xml
BOOK_TEX = $(OUT_DIR)/book.tex  # For debug
BOOK_PDF = $(OUT_DIR)/book.pdf

META_YAML = latex/metadata.yaml
BEFORE_BODY_TEX = latex/before-body.tex
HEADER_TEX = latex/header.tex
BOOK_ADOC = $(SRC_DIR)/book.adoc

BOOK_XML_DEPS = $(wildcard $(SRC_DIR)/*.adoc)
BOOK_TEX_DEPS = \
		$(BOOK_XML) \
		$(META_YAML) \
		$(wildcard latex/*.tex)

PANDOC_PDF_OPTS = \
	    --from docbook \
	    --pdf-engine xelatex \
	    --metadata-file $(META_YAML) \
	    --include-in-header $(HEADER_TEX) \
	    --include-before-body $(BEFORE_BODY_TEX) \
	    --filter pandoc-latex-environment \
	    --resource-path ".:$(SRC_DIR)"

.PHONY: pdf
pdf: $(BOOK_PDF)

.PHONY: tex
tex: $(BOOK_TEX)

.PHONY: clean
clean:
	rm -rf $(OUT_DIR)

# Set up Python virtual environment and install required Pandoc filters
# which are written in Python.
venv: venv/bin/activate

venv/bin/activate: requirements.txt
	test -d venv || python3 -m venv venv
	. venv/bin/activate; \
	  pip install -r requirements.txt
	touch venv/bin/activate

$(BOOK_XML): $(BOOK_XML_DEPS)
	asciidoctor \
	    --backend docbook5 \
	    --out-file $(BOOK_XML) \
	    $(BOOK_ADOC)

$(BOOK_PDF): venv $(BOOK_TEX_DEPS)
	. venv/bin/activate; \
	  pandoc $(PANDOC_PDF_OPTS) $(BOOK_XML) --output $(BOOK_PDF)

$(BOOK_TEX): venv $(BOOK_TEX_DEPS)
	. venv/bin/activate; \
	  pandoc $(PANDOC_PDF_OPTS) $(BOOK_XML) --standalone --output $(BOOK_TEX)
