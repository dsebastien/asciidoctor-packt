#!/bin/bash
DESTINATION_DIR=./dist
BOOK_FILE=README.adoc
FODT_BOOK_FILE=README.fodt

rm -rf $DESTINATION_DIR

# Generate HTML
asciidoctor --destination-dir $DESTINATION_DIR $BOOK_FILE

# Generate fodt & format it using xmllint
asciidoctor --destination-dir $DESTINATION_DIR --template-engine slim --template-dir slim --backend packt $BOOK_FILE && xmllint -format $DESTINATION_DIR/$FODT_BOOK_FILE