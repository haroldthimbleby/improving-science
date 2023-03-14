# makefile 
# Harold Thimbleby, 2022. harold@thimbleby.net
#
# entries of the form:
#
#     target-name : ... # latex documentation
#
# are automatically summarized by make help, make help-brief and make (with no parameters)
#
# basically, a grep scans this makefile for these lines, then either edits the lines into 
# Latex table rows, or uses awk to remove all the Latex details so it can be presented
# to the user as simple ASCII text
#
# Common to both uses, make make raw.table.data does the basic grep to extract the lines
# then 
#     make latex.tabular.data > generated/make-help.tex saves it as Latex
#     make help-brief converts it to basic ASCII
#


# I originally used LATEX=latex but it has problems on some systems with graphics
LATEX = pdflatex

APPENDIX = supplemental material

osversion = Darwin Kernel Version 22.3.0: Thu Jan  5 20:53:49 PST 2023; root:xnu-8792.81.2~2/RELEASE_X86_64
			
help: # Explain how to use \texttt{make}, and list all available options for using \texttt{make}.
	@echo Use make with any of these options:
	@echo
	@make help-brief
	@echo To check you have the right software, run
	@echo
	@echo "	" make check-versions
	@echo
	
checkVersion = if test "`$1 --version | head -n 1`" = "$2"; then echo "   $3 $2 --- is OK"; else echo "*** WARNING: $1 scripts were previously processed using $2. Your $1 version (`$1 --version | head -n 1`) needs checking or using cautiously"; fi

check-versions: # Check that you have the right software and software versions to run everything.
	@echo Checking you have a suitable configuration ...
	@echo Different versions may well work fine - but be cautious
	@echo
	@$(call checkVersion,awk,awk version 20200816,)
	@$(call checkVersion,bibtex,BibTeX 0.99d (TeX Live 2021),)
	@$(call checkVersion,git,git version 2.37.1 (Apple Git-137.1),)
	@$(call checkVersion,latex,pdfTeX 3.141592653-2.6-1.40.22 (TeX Live 2021),)
	@$(call checkVersion,node,v12.13.0, node)
	@$(call checkVersion,wolframscript,WolframScript 1.5.0 for MacOSX-x86-64)
	@echo
	@echo "Originally this makefile was run on MacOS $(osversion)"
	@echo "You are running                           `uname -v`"
	@if [ "$(osversion)" = "`uname -v`" ]; then echo ... "(These OS versions are the same)"; else echo ... which are different "(you may just have a more recent version)"; fi
	@echo
	@echo For interactive notebooks, we ran Mathematica 12.2.0.0
	@echo
	
check-same: # After you have done a \texttt{make data} or \texttt{make pdf}, you can check whether you have reproduced all data and generated files exactly the same (more precisely, it checks that they are the same as they were the last time \texttt{make check-update} was run).
	@echo Warning this can be a slow process if you have downloaded "(and not deleted!)" all the git repos
	@programs/checksums

check-update: # Update the data and generated file checksums after a successful run.
	@echo Warning this can be a slow process if you have downloaded "(and not deleted!)" all the git repos
	@programs/checksums update
	
data: # Analyze the data, and generate all the data files, the Unix scripts, the CSV, and \LaTeX\ files (including the \LaTeX\ summary of this makefile), etc. This \texttt{make} option runs \texttt{node programs/data.js}, downloads the Git repositories used in the pilot survey, and then analyzes them. Note that downloading all the repositories in a reasonable time needs decent internet bandwidth.
	@echo Generate all files and analyses from the JSON data in programs/data.js
	-node programs/data.js
	@echo Generate all data from the published models cited in the paper
	@echo Note that we will be generating data from the paper repositories, and these may have been updated by their authors. This step takes a while, as there is a lot of data to download.
	cd models; ./run
	@echo
	@echo Generate all Mathematica data files
	make mathematica
	@echo Generate the make help summary for the $(APPENDIX)
	make latex.tabular.data > generated/make-help.tex
	# now we've generated all the data, count the variables, etc
	programs/make-metadata.sh
	
raw.table.data: # PS not included in help list, as target contains a . character
	@grep "^[-a-zA-Z]*:" makefile | sort -d | sed "s/:.*#/: #/" | awk -F"#" '{ printf "%s %s\n", "make " $$1, $$2 }'
	
latex.tabular.data: # The n==1, n==6 etc is to select interesting entries for the supplementary.tex file. Note that meanings of n are defined in this output (and in generated/make-help.tex if you ran \texttt{make} data).
	@(echo % Edit makefile to change the selected make command choices, as follows:; make raw.table.data | awk -F: 'BEGIN { n=0 } { n++; printf "%% %s - %s\n", n, $$1 }' )
	@(echo "\n{\\\\sf\\\\begin{tabular}{rp{4.5in}}"; make raw.table.data | awk -F: 'BEGIN { n=0; needdots=0 } { n++; if( n == 1 || n == 6 || n ==8 || n == 17 ) { if( needdots ) printf "   \\multicolumn{1}{l@{\\vdots}}{}&\\\\\n"; needdots = 0; printf "\n\\texttt{%s}&\n   %s\\\\\n", $$1, $$2; } else { needdots = 1; } }'; echo "\\\\end{tabular}}\n")
	
help-brief: # Just this basic list of \texttt{make} options, with no further details.
	@make raw.table.data | awk -F: 'function wrap(s) { leng = 0; t = ""; for( i = 1; i <= length(s); i++ ) { if( ++leng > 65 && substr(s, i, 1) == " " ) { leng = 0; t = t "\n                            "; } else t = t substr(s, i, 1); } return t "\n"; } function delatex(s) { gsub("---", "-", s); gsub("\\\\LaTeX\\\\", "Latex", s); gsub("\\\\texttt", "", s); gsub("\\\\emph", "", s); gsub("{|}", "", s); return s; }; { printf "%25s%s\n", $$1, wrap(delatex($$2)) }' 
	
mathematica-open: # Open each of the \emph{Mathematica} notebooks separately, so you can use and run them interactively.
	open programs/RAP-diagrams.nb
	open programs/over-fitting-section.nb
	
mathematica: generated/mathematicaplot.jpg generated/over-fitting-code-section.tex generated/basic.jpg generated/excel.jpg generated/import.jpg generated/notebook.jpg # Run \emph{Mathematica} to generate or update all mathematica-generated data files and variables.
	
generated/basic.jpg generated/excel.jpg generated/import.jpg generated/notebook.jpg: programs/RAP-diagrams.nb
	cd programs; runMathematicaNotebook.sh RAP-diagrams.nb 
	
generated/mathematicaplot.jpg generated/over-fitting-code-section.tex: programs/over-fitting-section.nb
	cd programs; runMathematicaNotebook.sh over-fitting-section.nb
	
readme@md:
	@# macos awk doesn't have gensub, so we use sed as well as awk. Sigh
	@awk "BEGIN { printing = 1} /%replace%/ { printing = 0 } { if( printing ) print; }" README.md-src 
	@make raw.table.data | sed 's/.texttt{\([^}]*\)}/`\1`/g' | sed 's/.emph{\([^}]*\)}/*\1*/g'  README.md-src| awk -F: 'function delatex(s) { gsub("^ *", "    ", s); gsub("---", "\\&mdash;", s); gsub("\\\\LaTeX\\\\", "Latex", s); gsub("{|}", "", s); return s; } { printf "\n* `%s`\n\n%s\n", $$1, delatex($$2) }'
	@awk "BEGIN { printing = 0; preprinting = 0; } /%replace%/ { preprinting = 1; } { if( printing ) print; printing = preprinting; }" README.md-src
	echo done
	
readme: # Update the \texttt{README.md} file. You only need to do this if you've edited the \texttt{makefile} and changed the \texttt{make} options available, or edited \texttt{README.md-src}. (\texttt{README.md} is written in markdown wth Git formats so you know how to do everything on the repository; the \texttt{README.md} file is easiest to read on the Git site.).
	make readme@md > README.md

tidyup: # Tidyup typically before doing a Git commit or making a zip file. Remove all easily generated files, and the large Git repositories needed for the pilot survey. Do not remove the main PDFs, or the \LaTeX\ data include files. Do not remove the .aux files, as \LaTeX\ runs much more smoothly with them.
	@echo Remove all basic files that can easily be regenerated, except the main PDFs and the generated files that are included in Latex files
	rm -f paper-seb-*.blg data-check.html 
	# Don't delete generated/* as it's helpful to keep all the generated files around so Latex can be used directly...
	@# rm generated/* 
	rm -rf *.log *.out *.dvi log
	@echo This has left these generated PDFs you can either keep or delete manually
	-@ls paper*.pdf
	@echo Remove all the recoverable stuff in the models directory
	cd models; tidyup
 
really-tidyup: # More thorough than \texttt{make tidyup} --- remove \emph{all} files that can be recreated. (This will mean next time you run \LaTeX\ you will have to ignore errors as the .aux files are re-created.)
	@echo Remove all files that can be recreated, including PDFs and files made by processing the JSON data 
	make tidyup 
	rm -f paper-seb-*.pdf
	rm -f expanded*
		
all: # Analyze the data, then typeset the main PDF files (\texttt{paper-seb-main.pdf} and \texttt{paper-seb-supplementary-material.pdf}).
	make data
	make pdf

pdf: # Assuming you have got the data ready, make the two main PDF files, paper-seb-main.pdf, and paper-seb-supplementary-material.pdf. If you aren't sure you've got the data ready, say \texttt{make all} instead, or \texttt{make data} to just prepare the data before doing \texttt{make pdf}.
    # LOTS of latex runs to make sure the bibtex and .aux files are all correctly synced
    # eg inserting the table of contents changes page numbering, so it needs formatting again, etc
	$(LATEX) paper-seb-supplementary-material.tex > log
	bibtex paper-seb-supplementary-material >> log
	@echo Do not worry bibtex cannot find database entries for "ref-16" etc as they are in another file
	$(LATEX) paper-seb-supplementary-material.tex >> log
	$(LATEX) paper-seb-main.tex >> log
	bibtex paper-seb-main >> log
	$(LATEX) paper-seb-main.tex >> log
	$(LATEX) paper-seb-main.tex >> log
	@echo Unfortunately, paper-seb-main.tex has items in its bibiography that cross-refer to more bibliography items, so we need another run of bibtex etc
	bibtex paper-seb-main >> log
	$(LATEX) paper-seb-main.tex >> log
	$(LATEX) paper-seb-main.tex >> log
	@echo and then the references in paper-seb-supplementary-material.tex are renumbered to follow on paper-seb-main.tex
	$(LATEX) paper-seb-supplementary-material.tex >> log
	@echo and the paper-seb-main.tex refers to those numbers... so it needs updating again
	$(LATEX) paper-seb-main.tex >> log
	@echo "----------------------------------------------------------------"
	@echo You have now got these PDFs:
	@ls -C *paper*pdf
	@echo "-- That should say (at least):" paper-seb-main.pdf paper-seb-supplementary-material.pdf
	@echo
	@echo Plus some .aux/.out/.blg/etc files you can delete by running make tidyup if you wish
	@echo "----------------------------------------------------------------"
	
zip: # Make a zip archive of everything currently in the directory (except any zip files). You may want to run \texttt{make tidyup} first to remove generated files.
	@echo This zips everything in the current directory (except zip files). Use make archive to delete junk before zipping
	# to make sure the zip file has no junk in it, just remove it
	rm -f everything.zip dryad-data.zip
	zip everything *
	
archive: # Clean up all files (by doing \texttt{make really-tidyup}) that can easily be re-created, then make a compact zip archive.
	make really-tidyup
	rm -f generated/*
	make zip
	
push: # Push any *important* changed files to Git, along with updated PDF files.
	rm -rf models/git-* # remove models pulled from papers repositories (they are big)
	rm -f *.out *.log *.dvi
	# rm -f paper-seb-main.pdf paper-seb-supplementary-material.pdf
	git push -u origin master
	
# This, next, creates (and preserves) a single PDF, paper-seb.pdf, separately maintained at http://www.harold.thimbleby.net as reliable-models.pdf (which it links to)

# PS I'd rather say $APPENDIX than supplementary material (if that's what $APPENDIX is), but it 
# needs make to expand the definition, whereas in the comment, we're using grep to grab the text
# so APPENDIX won't get expanded

one-file: # Make a single PDF file paper-seb.pdf (i.e., paper + supplementary material) all in one.
	@make one.file

# this rule has a . in the target name (one.file), so make help doesn't find it (see the grep command in make help)
one.file: paper-seb-main.pdf paper-seb-supplementary-material.pdf # concatenate files
	@echo make single PDF file paper-seb.pdf
	pdfunite paper-seb-main.pdf paper-seb-supplementary-material.pdf paper-seb.pdf

zip-data: # Just make a zip archive of the data only. This is required for, e.g., uploading to a Dryad repository --- which is quirky as it won't include all the code needed to handle the data!
	make data
	@echo NB You will get some undefined reference warnings, as the data is not typeset in the papers which it cross-references
	rm -f dryad-data.zip everything.zip
	zip dryad-data README.md programs/data.js

expand: # Expand all \LaTeX\ files (to recursively flatten \texttt{input} and \texttt{bibliography} files, etc) to meet \LaTeX\ single-file processing restrictions for journals like \emph{PLOS} and \emph{IEEE Transactions on Software Engineering}, then make new PDFs to upload. (Note that \texttt{make expand} will do a \texttt{make pdf} first to ensure all the data and aux files are around to be expanded.)
	make pdf
	make one-file
	node programs/expand.js
	$(LATEX) expanded-paper-seb-supplementary-material.tex > log
	$(LATEX) expanded-paper-seb-main.tex >> log
	cp paper-seb.pdf tmp
	pdfunite expanded-paper-seb-main.pdf expanded-paper-seb-supplementary-material.pdf paper-seb.pdf >> log
	if cmp paper-seb.pdf tmp; then echo SAME; else echo DIFFERENT; fi
	rm tmp
	echo You now have expanded*pdf as well as the expanded source files expanded*tex and paper-seb.pdf which combines them as a single file
    
