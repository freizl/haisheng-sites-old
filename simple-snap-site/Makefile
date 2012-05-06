
PROG  = simple-site
PROG_PREV = ./dist/build/simple-site/simple-site

HC=ghc

DIST=dist

default: build

clean:
	rm -rf $(DIST)

bp: build preview

conf:
	cabal configure

build: conf
	cabal build

rebuild: clean build

preview:
	$(PROG_PREV) -p 8888


