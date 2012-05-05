
PROG  = simple-site
PROG_PREV = ./dist/build/simple-site/simple-site

HC=ghc

DIST=dist

default: build

clean:
	rm -rf $(DIST)

## Enable Development mode
conf-dev:
	cabal --flags="development" configure

build-dev: conf-dev
	cabal build

bp: build-dev preview


conf:
	cabal configure

build: conf
	cabal build

rebuild: clean build

preview:
	$(PROG_PREV) -p 8800


