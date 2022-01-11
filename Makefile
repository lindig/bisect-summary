#
# This Makefile is not called from Opam but only used for
# convenience during development
#

DUNE 	= dune

.PHONY: all install test clean uninstall format

all:
	$(DUNE) build

install: all
	$(DUNE) install hello

uninstall:
	$(DUNE) uninstall

test:
	$(DUNE) runtest

clean:
	$(DUNE) clean

utop:
	$(DUNE) utop

format:
	$(DUNE) build --auto-promote @fmt
	opam lint --normalise bisect-summary.opam > bisect-summary.tmp && mv bisect-summary.tmp bisect-summary.opam
	git ls-files '**/*.[ch]' | xargs -n1 indent -nut -i8
