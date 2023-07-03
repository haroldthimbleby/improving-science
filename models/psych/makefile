all: pizza.pdf run 

run: pizza.py
	python3.9 pizza.py

pizza.py: pizza.tex pizza.awk
	date "+# (c) Harold Thimbleby, harold@thimbleby.net, %d %B %Y @ %H:%M:%S " > pizza.py
	awk -f pizza.awk pizza.tex >> pizza.py

pizza.pdf pdf: pizza.tex pizza.jpg
	pdflatex pizza.tex
	pdflatex pizza.tex # done a second time for cross-references and bibliography

tidyup:
	rm -f pizza.aux pizza.toc pizza.pdf pizza.log pizza.synctex.gz pizza.py

