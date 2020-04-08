
BOOK_PDF=build/book.pdf

.PHONY: book
book: $(BOOK_PDF)

.PHONY: install
install:
	bundle install

$(BOOK_PDF):
	bundle exec asciidoctor-pdf --out-file $@ src/book.adoc
