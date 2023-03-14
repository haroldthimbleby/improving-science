# All data and files for the paper "Improving science that uses code"
### NB README.md is generated from README.md-src by running `make readme`

## Harold Thimbleby

## [harold@thimbleby.net](mailto:harold@thimbleby.net)

### %today-date%

## Basics

A PDF of the typeset paper and appendix is available at [`http://www.harold.thimbleby.net/paper-seb.pdf`](http://www.harold.thimbleby.net/paper-seb.pdf). It's also available in this repository.

All data is defined and stored in human-readable JSON format in the file `programs/data.js` - though there is more in the directory `models`, which has downloaded many Git repos and analyzed them.

For convenience, a CSV file is included in this Git repository, in the directory `generated`. This may be more convenient to read than the JSON file.

Everything works using `make`.

## Overview

First, here's a quick overview of how the system works behind the scenes inside `make`.

To generate all data or typeset the paper, you will need a Unix system with: awk, bibtex, git, latex (or pdflatex etc, depending on how you configure make), make, node, sed, and zip (plus the usual echo, egrep, grep, rm, sh, test, etc). Mathematica is also used, though all the files it generates are already in the Git repository, so you can get away without being able to run Mathematica yourself - it's not open source.

The file `programs/data.js` includes both the JSON data and a JavaScript program that checks the data, analyses it, and generates most of the various data files &mdash; the CSV file, lots of LaTeX files used in the paper, and others.

Running `node programs/data.js` will give you

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


* `# All data and files for the paper "Improving science that uses code"`

    

* `### NB README.md is generated from README.md-src by running `make readme``

    

* ``

    

* `## Harold Thimbleby`

    

* ``

    

* `## [harold@thimbleby.net](mailto`

    harold@thimbleby.net)

* ``

    

* `### %today-date%`

    

* ``

    

* `## Basics`

    

* ``

    

* `A PDF of the typeset paper and appendix is available at [`http`

    //www.harold.thimbleby.net/paper-seb.pdf`](http

* ``

    

* `All data is defined and stored in human-readable JSON format in the file `programs/data.js` - though there is more in the directory `models`, which has downloaded many Git repos and analyzed them.`

    

* ``

    

* `For convenience, a CSV file is included in this Git repository, in the directory `generated`. This may be more convenient to read than the JSON file.`

    

* ``

    

* `Everything works using `make`.`

    

* ``

    

* `## Overview`

    

* ``

    

* `First, here's a quick overview of how the system works behind the scenes inside `make`.`

    

* ``

    

* `To generate all data or typeset the paper, you will need a Unix system with`

    awk, bibtex, git, latex (or pdflatex etc, depending on how you configure make), make, node, sed, and zip (plus the usual echo, egrep, grep, rm, sh, test, etc). Mathematica is also used, though all the files it generates are already in the Git repository, so you can get away without being able to run Mathematica yourself - it's not open source.

* ``

    

* `The file `programs/data.js` includes both the JSON data and a JavaScript program that checks the data, analyses it, and generates most of the various data files &mdash; the CSV file, lots of LaTeX files used in the paper, and others.`

    

* ``

    

* `Running `node programs/data.js` will give you`

    

* ``

    

* `>       allData.csv - for accessing data in Excel and many other apps`

    

* `>       flagData.nb - for accessing data in Mathematica notebook`

    

* `>       data-check.html - a summary of papers and DOIs with any error messages (eg missing data), for easy review in a browser`

    

* `>       some shell scripts used to run Git to download clones of the survey papers' code repositories`

    

* `>    ... etc etc, plus a few tex files for including data in the Latex files`

    

* `>`

    

* `>	These will all be included in the directory `generated``

    

* ` `

    

* ``data.js` also lists all the files generated, where they are, and their purpose. (Note that there are some other generated files, for instance, those created by `run` run in the `models` directory, which analyzes all the git repos copied from papers in the survey.)`

    

* ``

    

* `However, it's better to use `make` than do things piecemeal ...`

    

* ``

    

* `## Using make`

    

* ``

    

* `Run `make` (with no parameters) to find out everything that you can do. `

    

* ``

    

* `Here are all the available options`

    

* ``

    

* `%replace%`

    

* `        `

    

* `## Further information`

    

* ``

    

* `For help or further information, please email [harold@thimbleby.net](mailto`

    harold@thimbleby.net)

* ``

    

* `Web site [harold.thimbleby.net](http`

    //www.harold.thimbleby.net)

* ``

    

* ``

    
        
## Further information

For help or further information, please email [harold@thimbleby.net](mailto:harold@thimbleby.net)

Web site [harold.thimbleby.net](http://www.harold.thimbleby.net)


echo done
done
