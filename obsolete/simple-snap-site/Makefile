
PROG  = simple-site
PROG_PREV = ./dist/build/simple-site/simple-site

DIST=dist
SITE=_site

default: build

clean:
	rm -rf $(DIST)

bp: build-dev preview

conf-dev:
	cabal configure

build-dev: conf-dev
	cabal build

preview:
	$(PROG_PREV) -p 8888

### Production Build

conf:
	cabal --flags="-development" configure

build: conf
	cabal build

rebuild: clean build

prod: 
	rm -rf $(SITE)
	mkdir -p $(SITE)/log
	cp -r static snaplets $(SITE)
	for x in `find $(SITE)/ -name '*.tpl' ` ; do \
		perl -i -p -e  's/[\r\n]+|[ ]{2}|<!--(.|\s)*?--.*>//gs' $$x ; \
		perl -i -p -e  's/<!--(.|\s)*?-->//gs' $$x ; \
	done

	cp $(PROG_PREV) $(SITE)

