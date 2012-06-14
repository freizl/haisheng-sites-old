
SRC=slides.md
PD=~/.cabal/bin/pandoc

slides:
	$(PD) -t beamer -s $(SRC) -o beamer.pdf
	$(PD) -t dzslides -s $(SRC) -o dz.html
	$(PD) --self-contained -t s5  -s $(SRC) -o s5.html
	$(PD) -t slidy  -s $(SRC) -o slidy.html
