SB=.cabal-sandbox
PD=$(SB)/bin/pandoc

PROG  = $(SB)/bin/freizl

.PHONY: slides

default: build

clean:
	rm -rf dist

build:
	cabal configure
	cabal build

install:
	cabal install

run:
	$(PROG) clean
	$(PROG) build

p:
	$(PROG) preview 9911

rp: build run p

########## Mirror to github

mirror: build
	cp -r $(SITE)/* ~/github/freizl.github.com/

########## Compile slides

## just by lazy not to cut off md file ext.
slides:
	for f in `ls -1 slides/*.md`; do \
	$(PD) -t dzslides -s "$$f" -o "$$f".html; \
	done;
