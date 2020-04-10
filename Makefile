
SRC_DIR = src
OUT_DIR = build

BOOK_XML = $(OUT_DIR)/book.xml
BOOK_TEX = $(OUT_DIR)/book.tex  # For debug
BOOK_PDF = $(OUT_DIR)/book.pdf

META = metadata.yaml
BEFORE_BODY_TEX = before-body.tex
HEADER_TEX = header-includes.tex
ADOC_ENTRY = $(SRC_DIR)/book.adoc
ADOC_SRC = $(wildcard $(SRC_DIR)/*.adoc)

PANDOC_PDF_OPTS = \
	    --from docbook \
	    --pdf-engine xelatex \
	    --metadata-file $(META) \
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

$(BOOK_XML): $(ADOC_SRC) $(META)
	asciidoctor \
	    --backend docbook5 \
	    --out-file $(BOOK_XML) \
	    $(ADOC_ENTRY)

$(BOOK_PDF): $(BOOK_XML) $(BEFORE_BODY_TEX)
	pandoc $(PANDOC_PDF_OPTS) $(BOOK_XML) --output $(BOOK_PDF)

$(BOOK_TEX): $(BOOK_XML) $(BEFORE_BODY_TEX)
	pandoc $(PANDOC_PDF_OPTS) $(BOOK_XML) --standalone --output $(BOOK_TEX)
