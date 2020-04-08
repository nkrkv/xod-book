
BOOK_PDF := build/book.pdf
ADOC_SRC := $(wildcard src/*.adoc)

.PHONY: book
book: $(BOOK_PDF)

.PHONY: install
install:
	bundle install

$(BOOK_PDF): $(ADOC_SRC)
	bundle exec asciidoctor-pdf --out-file $@ src/book.adoc
