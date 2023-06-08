Github repository (all data, code, and papers) is at 

https://github.com/haroldthimbleby/improving-science

-------

Paper Latex file is: paper.tex (and paper.pdf)

Supplementary material is: appendix.tex (and appendix.pdf)

all.pdf the paper and appendix in a single file.

The paper uses comjnl.cls as usual

The file macros.tex defines some auxiliary material. Aa few simple macros are also defined as needed in the files, in particular for the yellow highlighting of the data access statement in the main paper.

The Bibtex file CompJ.bst has been carefully debugged, resulting in the file that is used: revisedCompJ.bst

Note that revisedCompJ.bst performs some new things to format URLs well, etc, and it would not be suitable for wider use (though I'd be happy to prepare an update of CompJ.bst if it'd be helpful)

Some Latex files are input into the paper. These are all in the directory generated/

Please do not edit these generated files; instead refer to the README file, or use make to update the directory files as required.

If you run make expand, then files expanded-*.tex and expanded-*.pdf are generated. These are standard LaTeX and PDF files, but with no \input commands - all the data files, .bbl, and .aux files, etc, have been pre-included.

README.md provides a lot of additional details, including how to use make to generate the paper and appendix.

To do more, run make (with no arguments) and it'll summarize your options.




Any queries, please email me at harold@thimbleby.net

