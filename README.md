
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

    Analyze the data, and generate all the data files, the Unix scripts, the CSV, and Latex files (including the Latex summary of this makefile), etc. This `make` option runs `node programs/data.js`, downloads the Git repositories used in the pilot survey, and then analyzes them. Note that downloading all the repositories in a reasonable time needs decent internet bandwidth.

* `make expand`

    Expand all Latex files (to recursively flatten `input` and `bibliography` files, etc) to meet Latex single-file processing restrictions for journals like *PLOS* and *IEEE Transactions on Software Engineering*, then make new PDFs to upload. (Note that `make expand` will do a `make pdf` first to ensure all the data and aux files are around to be expanded.)

* `make help`

    Explain how to use `make`, and list all available options for using `make`.

* `make help-brief`

    Just this basic list of `make` options, with no further details.

* `make mathematica`

    Run *Mathematica* to generate or update all mathematica-generated data files and variables.

* `make mathematica-open`

    Open each of the *Mathematica* notebooks separately, so you can use and run them interactively.

* `make one-file`

    Make a single PDF file paper-seb.pdf (i.e., paper + supplementary material) all in one.

* `make pdf`

    Assuming you have got the data ready, make the two main PDF files, paper-seb-main.pdf, and paper-seb-supplementary-material.pdf. If you aren't sure you've got the data ready, say `make all` instead, or `make data` to just prepare the data before doing `make pdf`.

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
        
## Further information

For help or further information, please email [harold@thimbleby.net](mailto:harold@thimbleby.net)

Web site [harold.thimbleby.net](http://www.harold.thimbleby.net)


