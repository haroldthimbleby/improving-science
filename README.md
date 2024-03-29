# All data, code, and other files for the paper "Improving science that uses code"

## Harold Thimbleby

## [harold@thimbleby.net](mailto:harold@thimbleby.net)

### README generated on 07 June 2023

#### (README.md is generated from README.md-src by running `make readme`)

## Basics

A PDF of the typeset paper and appendix is available at [`http://www.harold.thimbleby.net/paper-seb.pdf`](http://www.harold.thimbleby.net/paper-seb.pdf). It's also available in this repository as `all.pdf` (or `expanded-all.pdf` if you ran `make expand`, as discussed below).

All data is defined and stored in human-readable JSON format in the file `programs/data.js` &mdash; though there is more in the directory `models`, which has downloaded many Git repos and analyzed them.

For convenience, a CSV file is included in this Git repository, in the directory `generated`. This may be more convenient to read than the JSON file.

Everything works using `make`.

## If this all seems too complicated...

Run `make expand`, which will generate basic LaTeX files that depend on nothing other than their `documentclass` files. (`make expand` works by recursively importing all files, so that the expanded files need nothing else to be typeset.)

## Directory structure

The top level working direction contains `README` (this file), the makefile, the two LaTeX files (`paper.tex` and `appendix.tex`) as well as all their usual stuff (`.aux`, `.pdf`, `.bib` files, and common macros, `macros.tex`, etc), two bibliographies (for each of the two LaTeX files), and several directories:

* `programs` &mdash; the key data file, `data.js` which also includes its JavaScript analysis, all of the programs to analyze and generate data.

* `generated` &mdash; where all the generated results end up.

* `models` &mdash; where all of the downloaded Git repositories end up to be analyzed (this directory is cleared up on this repository as it is large and of course can be downloaded again from the various papers' sites). This directory also includes programs to download and analyze the various Git models, and to tidy up afterwards if you decide not to keep the Git models around. 

## Overview

First, here's a quick overview of how the system works behind the scenes inside `make`:

To generate all data or typeset the paper, you will need a Unix system with: make, awk, bibtex, git, latex (or pdflatex etc, depending on how you configure make), node, sed, and zip (plus the usual echo, egrep, grep, rm, sh, test, etc). Mathematica is used, though all the files it generates are already in the Git repository (and will be copied to `generated/*`), so you can get away without being able to run Mathematica yourself &mdash; it's not open source. If you use make expand, you will also need diff-pdf.

The file `programs/data.js` includes both the JSON data and a JavaScript program that checks the data, analyses it, and generates most of the various data files &mdash; the CSV file, lots of LaTeX files used in the paper, and others.

Running `node programs/data.js` will give you

* `allData.csv` &mdash; for accessing data in Excel and many other apps.

* `flagData.nb` &mdash; for accessing data in Mathematica notebook.

* `data-check.html` &mdash; a summary of papers and DOIs with any error messages (eg missing data), for easy review in a browser some shell scripts used to run Git to download clones of the survey papers' code repositories
 ... etc, plus some tex files for including data in the Latex files.

These generated files will all be included in the directory `generated`
 
`data.js` also lists all the files generated, where they are, and their purpose. (Note that there are some other generated files, for instance, those created by `run` run in the `models` directory, which analyzes all the git repos copied from papers in the survey.)

However, it's better to use `make` than do things piecemeal ...

## Using make

Run `make` (with no parameters) to find out everything that you can do. 

Here are all the available options:


* `make all`

    Download and analyze the data, then typeset the main files (`paper.pdf`, `appendix.pdf` and `all.pdf`) that import all the data, as well as make the self-contained expanded `.tex` (and `.PDF`) files that do not depend on the separate data files in `data/*`.

* `make archive`

    Clean up all files (by doing `make really-tidyup`) that can easily be re-created, then make a compact zip archive.

* `make check-same`

    After you have done a `make data` or `make pdf`, you can check whether you have reproduced all data and generated files exactly the same (more precisely, it checks that they are the same as they were the last time `make check-update` was run).

* `make check-update`

    Update the data and generated file checksums after a successful run.

* `make check-versions`

    Check that you have the right software and software versions to run everything.

* `make data`

    Analyze the data, and generate all the data files, the Unix scripts, the CSV, and Latex files (including the Latex summary of this makefile), etc. This `make` option runs `node programs/data.js`, downloads the Git repositories used in the pilot survey, and then analyzes them. Note that downloading all the repositories in a reasonable time needs decent internet bandwidth.

* `make expand`

    Expand all Latex files (to recursively flatten `input` and `bibliography` files, etc) to meet Latex single-file processing restrictions for journals like *PLOS* and *IEEE Transactions on Software Engineering*, then make new PDFs to upload. (Note that `make expand` will do a `make pdf` first to ensure all the data and aux files are around to be expanded.)

* `make git-prep`

    Is there anything on Git that we've lost, or stuff we have got locally but probably don't want on Git, so you can delete it or move it out the way or whatever.

* `make help`

    Explain how to use `make`, and list all available options for using it.

* `make help-brief`

    Just this basic list of `make` options, with no further details.

* `make mathematica`

    Run *Mathematica* to generate or update all mathematica-generated data files and variables.

* `make mathematica-open`

    Open each of the *Mathematica* notebooks separately, so you can use and run them interactively.

* `make one-file`

    Make a single PDF file `all.pdf` (i.e., paper + supplementary material) all in one.

* `make pdf`

    Assuming you have got the data ready, make the two main PDF files, paper.pdf, and appendix.pdf. If you aren't sure you've got the data ready, say `make all` instead, or `make data` to just prepare the data before doing `make pdf`.

* `make push`

    Push any *important* changed files to Git, along with updated PDF files.

* `make readme`

    Update the `README.md` file. You only need to do this if you've edited the `makefile` and changed the `make` options available, or edited `README.md-src`. (`README.md` is written in markdown wth Git formats so you know how to do everything on the repository; the `README.md` file is easiest to read on the Git site.).

* `make really-tidyup`

    More thorough than `make tidyup` &mdash; remove *all* files that can be recreated. (This will mean next time you run Latex you will have to ignore errors as the .aux files are re-created.)

* `make tidyup`

    Tidyup typically before doing a Git commit or making a zip file. Remove all easily generated files, and the large Git repositories needed for the pilot survey. Do not remove the main PDFs, or the Latex data include files. Do not remove the .aux files, as Latex runs much more smoothly with them.

* `make zip`

    Make a zip archive of everything currently in the directory (except any zip files). You may want to run `make tidyup` first to remove generated files.

* `make zip-data`

    Just make a zip archive of the data only. This is required for, e.g., uploading to a Dryad repository &mdash; which is quirky as it won't include all the code needed to handle the data!

## The structure and use of the LaTeX files

The two main LaTeX files are `paper.tex` and `appendix.tex`

The supplementary material continues pagination, section, table, citation, and figure numbering across from the main file. In addition, the main and supplementary files cross-reference each other in the normal LaTeX ways &mdash; using \label{} and \ref{}. To make this work easily, each file explicitly reads in the other's `.aux` file (which is used by LaTeX for handling cross-references). Apart from that, nothing special has to be done for the files to communicate.

The bibliographies are a bit more complicated. `paper.tex` has a bibliography file, `paper.bib`, in the usual way; however the supplement has its own bibliography. In fact, it has two. One works in the standard BibTeX way; the other is generated by `data.js` and is the bibliography for the surveyed papers only. The survey bibliography is generated directly by `data.js` as a `.bbl` file, rather than as a BibTeX file.

Because the supplement reads the main file's `.aux` it automatically gets the bibliography details (names and numbers) used by the main file (and it does cite some stuff from it, so uses consistent numbering). A simple counter is then used to ensure the remaining new citations in the supplement carry on with the same numbering sequence.

The Mathematica notebook `programs/check-xrefs.nb` checks all the citations and cross-references, not least because BibTeX and LaTeX's errors and warnings are not up to having multiple files for cross-references and citations.
        
## Further information

For help or further information, please email [harold@thimbleby.net](mailto:harold@thimbleby.net)

Web site [harold.thimbleby.net](http://www.harold.thimbleby.net)

