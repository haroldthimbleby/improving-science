# All data and files for the paper "Improving science that uses code"
### NB README.md is generated from README.md-src by running `make readme`

## Harold Thimbleby

## [harold@thimbleby.net](mailto:harold@thimbleby.net)

### 31 January 2023

## Basics

A PDF of the typeset paper and appendix is available at [`http://www.harold.thimbleby.net/reliable-models.pdf`](http://www.harold.thimbleby.net/reliable-models.pdf). It's also available in this repository.

All data is defined and stored in human-readable JSON format in the file `programs/data.js` - though there is more in the directory `models`, which has downloaded many Git repos and analyzed them.

For convenience, a CSV file is included in this Git repository, in the directory `generated`. This may be more convenient to read than the JSON file.

Everything works using `make`.

## Overview

First, here's a quick overview of how the system works behind the scenes inside `make`.

To generate all data or typeset the paper, you will need a Unix system with: awk, bibtex, latex, make, node, sed, and zip (plus the usual rm, echo, etc). 

The file `programs/data.js` includes both the JSON data and a JavaScript program that checks the data, analyses it, and generates most of the various data files &mdash; the CSV file, lots of LaTeX files used in the paper, and others.

Running `node programs/node data.js` will give you

>       allData.csv - for accessing data in Excel and many other apps
>       flagData.nb - for accessing data in Mathematica notebook
>       data-check.html - a summary of papers and DOIs with any error messages (eg missing data), for easy review in a browser
>       some shell scripts used to run Git to download clones of the survey papers' code repositories
>    ... etc etc, plus a few tex files for including data in the Latex files
>
>	These will all be included in the directory `generated`
 
`data.js` also lists all the files generated, where they are, and their purpose. (Note that there are some other generated files, for instance, those created by `run` run in the `models` directory, which analyzes all the git repos copied from papers in the survey.)

However, it's better to use `make` than do things piecemeal ...

## Using make

Run `make` (with no parameters) to find out everything that you can do. 

Here are all the available options:


* `make all`

    Analyze the data, then typeset the main PDF files (`paper-seb-main.pdf` and `paper-seb-supplementary-material.pdf`).

* `make archive`

    Clean up all files (by doing `make really-tidyup`) that can easily be re-created, then make a compact zip archive.

* `make check-same`

    After you have done a `make data` or `make pdf`, you can check whether you have reproduced all data and generated files exactly the same (more precisely, it checks that they are the same as they were the last time `make check-update` was run).

* `make check-update`

    Update the data and generated file checksums after a successful run.

* `make check-versions`

    Check that you have the right software and software versions to run everything.

* `make data`

    Analyze the data, and generate all the data files, the Unix scripts, the CSV, and Latex files (including the Latex summary of this makefile), etc. In particular, this runs `node programs/data.js`, downloads the Git repositories used in the pilot survey, and then analyzes them. Note that downloading all the repositories in a reasonable time needs decent internet bandwidth.

* `make expand`

    Expand all Latex files (to recursively flatten `input` and `bibliography` files, etc) to meet Latex single-file processing restrictions for journals like *PLOS* and *IEEE Transactions on Software Engineering*, then make new PDFs to upload. (Note that `make expand` will do a `make pdf` first to ensure all the data and aux files are around to be expanded.)

* `make help`

    Explain how to use `make`, and list all available options for using `make`.

* `make help-brief`

    Just this basic list of `make` options, with no further details.

* `make mathematica`

    Curiously, Mathematica notebooks can't be run in a shell script (so make can't help much), but this make option will open all the Mathematica notebooks, though it won't run them automatically for you. Sigh.

* `make one-file`

    Make a single PDF file paper-seb.pdf (i.e., paper + appendix) all in one.

* `make pdf`

    Assuming you have got the data ready, make the two main PDF files, paper-seb-main.pdf, and paper-seb-supplementary-material.pdf. If you aren't sure you've got the data ready, say `make all` instead, or `make data` to just prepare the data before doing `make pdf`.

* `make push`

    Push any changed files to Git, along with the PDF files.

* `make readme`

    Update the `README.md` file. You only need to do this if you've edited the makefile and changed the `make` options available, or edited `README.md-src`. (`README.md` is written in markdown wth Git formats so you know how to do everything on the repository; the `README.md` file is easiest to read on the Git site.).

* `make really-tidyup`

    More thorough than `make tidyup` &mdash; remove *all* files that can be recreated.

* `make tidyup`

    Remove all easily generated files, except the main PDFs and the large Git repositories needed for the pilot survey.

* `make zip`

    Make a zip archive of everything currently in the directory (except any zip files). You may want to run `make tidyup` first to remove generated files.

* `make zip-data`

    Just make a zip archive of the data only. This is required for, e.g., uploading to a Dryad repository &mdash; which is quirky as it won't include all the code needed to handle the data!
        
## Further information

For help or further information, please email [harold@thimbleby.net](mailto:harold@thimbleby.net)

Web site [harold.thimbleby.net](http://www.harold.thimbleby.net)


