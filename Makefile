
SRC_DIR = src
OUT_DIR = build

BOOK_XML = $(OUT_DIR)/book.xml
BOOK_TEX = $(OUT_DIR)/book.tex  # For debug
BOOK_PDF = $(OUT_DIR)/book.pdf

ADOC_ENTRY = $(SRC_DIR)/book.adoc
ADOC_SRC = $(wildcard $(SRC_DIR)/*.adoc)

PANDOC_PDF_OPTS = \
	    --from docbook \
	    --pdf-engine xelatex \
	    --variable documentclass=book \
	    --variable lang="ru-RU" \
	    --variable geometry="margin=2cm" \
	    --variable mainfont="DejaVu Serif" \
	    --variable sansfont="DejaVu Sans" \
	    --variable monofont="DejaVu Sans Mono" \
	    --resource-path $(SRC_DIR)

.PHONY: pdf
pdf: $(BOOK_PDF)

.PHONY: tex
tex: $(BOOK_TEX)

.PHONY: clean
clean:
	rm -r $(OUT_DIR)


$(BOOK_XML): $(ADOC_SRC)
	asciidoctor \
	    --backend docbook5 \
	    --out-file $(BOOK_XML) \
	    $(ADOC_ENTRY)

$(BOOK_PDF): $(BOOK_XML)
	pandoc $(PANDOC_PDF_OPTS) $(BOOK_XML) --output $(BOOK_PDF)

$(BOOK_TEX): $(BOOK_XML)
	pandoc $(PANDOC_PDF_OPTS) $(BOOK_XML) --standalone --output $(BOOK_TEX)
