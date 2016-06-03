
# OASIS_START
# DO NOT EDIT (digest: a3c674b4239234cbbe53afe090018954)

SETUP = ocaml setup.ml

build: setup.data
	$(SETUP) -build $(BUILDFLAGS)

doc: setup.data build
	$(SETUP) -doc $(DOCFLAGS)

test: setup.data build
	$(SETUP) -test $(TESTFLAGS)

all:
	$(SETUP) -all $(ALLFLAGS)

install: setup.data
	$(SETUP) -install $(INSTALLFLAGS)

uninstall: setup.data
	$(SETUP) -uninstall $(UNINSTALLFLAGS)

reinstall: setup.data
	$(SETUP) -reinstall $(REINSTALLFLAGS)

clean:
	$(SETUP) -clean $(CLEANFLAGS)

distclean:
	$(SETUP) -distclean $(DISTCLEANFLAGS)

setup.data:
	$(SETUP) -configure $(CONFIGUREFLAGS)

configure:
	$(SETUP) -configure $(CONFIGUREFLAGS)

.PHONY: build doc test all install uninstall reinstall clean distclean configure

# OASIS_STOP

setup:	_oasis
	oasis setup -setup-update dynamic

V    = 	0.4
NAME = 	ocaml-bisect-summary-$V
TAR  = 	$(NAME).tar.gz

tar:
	git archive --prefix $(NAME)/ --format=tar HEAD | gzip > $(TAR)
	cp $(TAR) $(HOME)/src/xen-api-base-specs/SOURCES
	cp ocaml-bisect-summary.spec $(HOME)/src/xen-api-base-specs/SPECS

TAG =	0.4
GITHUB =https://github.com/lindig/bisect-summary
ZIP =	$(GITHUB)/archive/$(TAG).zip

url:	FORCE
	echo	"archive: \"$(ZIP)\"" > url
	echo	"checksum: \"`curl -L $(ZIP)| md5 -q`\"" >> url

FORCE:;

