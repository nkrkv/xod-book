
SRC_DIR = src
OUT_DIR = build

BOOK_XML = $(OUT_DIR)/book.xml
BOOK_PDF = $(OUT_DIR)/book.pdf

ADOC_ENTRY = $(SRC_DIR)/book.adoc
ADOC_SRC = $(wildcard $(SRC_DIR)/*.adoc)

.PHONY: book
book: $(BOOK_PDF)

.PHONY: clean
clean:
	rm -r $(OUT_DIR)

$(BOOK_XML): $(ADOC_SRC)
	asciidoctor \
	    --backend docbook5 \
	    --out-file $(BOOK_XML) \
	    $(ADOC_ENTRY)

$(BOOK_PDF): $(BOOK_XML)
	pandoc \
	    --from docbook $(BOOK_XML) \
	    --to pdf \
	    --pdf-engine xelatex \
	    --output $(BOOK_PDF) \
	    --variable mainfont="DejaVu Serif" \
	    --variable sansfont=Arial \
	    --resource-path $(SRC_DIR)
