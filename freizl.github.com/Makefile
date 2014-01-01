
PROG  = ./site
SOURCES = site.hs
HC=ghc -package-conf=./cabal-dev/packages-7.4.1.conf
PD=./cabal-dev/bin/pandoc

SITE=_site
CACHE=_cache

.PHONY: slides

default: build

$(PROG) : $(SOURCES)
	$(HC) --make $< -o $@

clean:
	rm -f $(SOURCES:.hs=.hi) $(SOURCES:.hs=.o) $(PROG)
	rm -rf $(SITE) $(CACHE)
	rm -rf $(GAE)/$(SITE)

build: $(PROG) slides
	$(PROG) build

rebuild: $(PROG) slides
	$(PROG) rebuild

preview:
	$(PROG) preview 9911

deploy: build
	$(PROG) deploy

p: preview

bp: build preview

rp: rebuild preview

########## Mirror to github

mirror: build
	cp -r $(SITE)/* ~/github/freizl.github.com/

########## Compile slides

## just by lazy not to cut off md file ext.
slides:
	for f in `ls -1 slides/*.md`; do \
	$(PD) -t dzslides -s "$$f" -o "$$f".html; \
	done;
