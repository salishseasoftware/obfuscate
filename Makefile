SHELL = /bin/bash

prefix ?= /usr/local
BINDIR = $(prefix)/bin
REPODIR = $(shell pwd)
BUILDDIR = $(REPODIR)/.build
BINNAME = obfuscate

build:
	swift build -c release --disable-sandbox --build-path "$(BUILDDIR)"

install: build
	install "$(BUILDDIR)/release/$(BINNAME)" "$(BINDIR)"

uninstall:
	rm -rf "$(BINDIR)/$(BINNAME)"

clean:
	rm -rf "$(BUILDDIR)"

test:
	swift test

.PHONY: build install uninstall clean test
