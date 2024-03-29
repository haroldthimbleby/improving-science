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

# this must be consistent with programs/expand.js definitions...
EXPANDEDPREFIX = EX
# Important: EXPANDEDPREFIX *must* be defined so that patterns say like rm $(EXPANDEDPREFIX)* are not ambiguous

APPENDIX = supplemental material

osversion = Darwin Kernel Version 22.5.0: Mon Apr 24 20:51:50 PDT 2023; root:xnu-8796.121.2~5/RELEASE_X86_64
			
help: # Explain how to use \texttt{make}, and list all available options for using it.
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
	@$(call checkVersion,bibtex,BibTeX 0.99d (TeX Live 2023),)
	@$(call checkVersion,git,git version 2.39.2 (Apple Git-143),)
	@$(call checkVersion,latex,pdfTeX 3.141592653-2.6-1.40.25 (TeX Live 2023),)
	@$(call checkVersion,node,v12.13.0, node)
	@$(call checkVersion,wolframscript,WolframScript 1.5.0 for MacOSX-x86-64)
	@echo
	@echo "Originally this makefile was run on MacOS $(osversion)"
	@if [ "$(osversion)" = "`uname -v`" ]; then echo "... You are running the same OS version"; else echo "***  You are running a DIFFERENT version: `uname -v`"; fi
	@echo
	@echo For running interactive notebooks, we used Mathematica 13.3.0.0
	@echo
	
check-same: # After you have done a \texttt{make data} or \texttt{make pdf}, you can check whether you have reproduced all data and generated files exactly the same (more precisely, it checks that they are the same as they were the last time \texttt{make check-update} was run).
	@echo Warning this can be a slow process if you have downloaded "(and not deleted!)" all the git repos
	@echo You may want to run make tidyup "(to get rid of Git models and other junk)"
	@programs/checksums

check-update: # Update the data and generated file checksums after a successful run. Check files are the same by running make check-same
	@echo Warning this can be a slow process if you have downloaded "(and not deleted!)" all the git repos
	@echo You may want to run make tidyup
	@programs/checksums update
	
check: # Perform all checks (otherwise done by indid make check-...)
	make check-versions
	make check-same
	make check-git
	
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
	@(echo "\n{\\\\sf\\\\begin{tabular}{rp{4.5in}}"; make raw.table.data | awk -F: 'BEGIN { n=0; needdots=0 } { n++; if( n == 1 || n == 7 || n == 10 ) { if( needdots ) printf "   \\multicolumn{1}{l@{\\vdots}}{}&\\\\\n"; needdots = 0; printf "\n\\texttt{%s}&\n   %s\\\\\n", $$1, $$2; } else { needdots = 1; } }'; echo "\\\\end{tabular}}\n")
	
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

# unfortunately # is not ignored, so we've used
# @echo ... > /dev/null
# to generate *really* ignored comments here!

readme@md:
	@# macos awk doesn't have gensub, so we use sed as well as awk. Sigh
	@echo copy through text before %today-date% > /dev/null
	@awk "BEGIN { printing = 1 } /%today-date%/ { printing = 0 } { if( printing ) print; }" README.md-src 
	@echo see man strftime for date formats "(%B is full month name)" > /dev/null
	@date "+### README generated on %d %B %Y"
	@echo copy through text from after %today-date% to before %replace% > /dev/null
	@awk "BEGIN { printing = 0 } /%today-date%/ { printing = 1 } /%replace%/ { printing = 0 } { if( printing ) { if( printing > 1 ) print; printing++;  }}" README.md-src 
	@make raw.table.data | sed 's/.texttt{\([^}]*\)}/`\1`/g' | sed 's/.emph{\([^}]*\)}/*\1*/g' | awk -F: 'function delatex(s) { gsub("^ *", "    ", s); gsub("---", "\\&mdash;", s); gsub("\\\\LaTeX\\\\", "Latex", s); gsub("{|}", "", s); return s; } { printf "\n* `%s`\n\n%s\n", $$1, delatex($$2) }'
	@echo copy through text after %replace% > /dev/null
	@awk "BEGIN { printing = 0; preprinting = 0; } /%replace%/ { preprinting = 1; } { if( printing ) print; printing = preprinting; }" README.md-src
	
readme: # Update the \texttt{README.md} file. You only need to do this if you've edited the \texttt{makefile} and changed the \texttt{make} options available, or edited \texttt{README.md-src}. (\texttt{README.md} is written in markdown wth Git formats so you know how to do everything on the repository; the \texttt{README.md} file is easiest to read on the Git site.).
	make readme@md > README.md

tidyup: # Tidyup typically before doing a Git commit or making a zip file. Remove all easily generated files, and the large Git repositories needed for the pilot survey. Do not remove the main PDFs, or the \LaTeX\ data include files. Do not remove the .aux files, as \LaTeX\ runs much more smoothly with them.
	@echo Remove all basic files that can easily be regenerated, except the main PDFs and the generated files that are included in Latex files
	# Don't delete generated/* as it's helpful to keep all the generated files around so Latex can be used directly...
	rm -rf *.log *.out *.dvi *.blg log *.aux *.bbl *.toc log
	@echo This has left these generated PDFs you can either keep or delete manually
	-@ls paper*.pdf
	@echo Remove all the recoverable stuff in the models directory
	cd models; tidyup
	@echo Finally, remove all $(EXPANDEDPREFIX) files
	ls expanded/$(EXPANDEDPREFIX)*
	rm -f expanded/$(EXPANDEDPREFIX)*
 
really-tidyup: # More thorough than \texttt{make tidyup} --- remove \emph{all} files that can be recreated. (This will mean next time you run \LaTeX\ you will have to ignore errors as the .aux files are re-created.)
	@echo Remove all files that can be recreated, including PDFs and files made by processing the JSON data 
	make tidyup 
	rm -f *.pdf
	rm -f generated/* 
	rm -f expanded/$(EXPANDEDPREFIX)*
		
all: # Download and analyze the data, then typeset the main files (\texttt{paper.pdf}, \texttt{appendix.pdf} and \texttt{all.pdf}) that import all the data, as well as make the self-contained expanded \texttt{.tex} (and \texttt{.PDF}) files that do not depend on the separate data files in \texttt{data/*}.
	make data
	make pdf
	make expand

pdf: # Assuming you have got the data ready, make the two main PDF files, paper.pdf, and appendix.pdf. If you aren't sure you've got the data ready, say \texttt{make all} instead, or \texttt{make data} to just prepare the data before doing \texttt{make pdf}.
    # LOTS of latex runs to make sure the bibtex .bbl and .aux files are all correctly synced
    # eg inserting the table of contents changes page numbering, so it needs formatting again, etc
	$(LATEX) appendix.tex > log
	bibtex appendix >> log
	@echo Do not worry bibtex cannot find database entries for "ref-16" etc as they are in another file
	$(LATEX) appendix.tex >> log
	$(LATEX) paper.tex >> log
	bibtex paper >> log
	$(LATEX) paper.tex >> log
	$(LATEX) paper.tex >> log
	@echo Unfortunately, paper.tex has items in its bibliography that cross-refer to more bibliography items, so we need another run of bibtex etc
	bibtex paper >> log
	$(LATEX) paper.tex >> log
	$(LATEX) paper.tex >> log
	@echo and then the references in appendix.tex are renumbered to follow on paper.tex
	$(LATEX) appendix.tex >> log
	@echo and the paper.tex refers to those numbers... so it needs updating again
	$(LATEX) paper.tex >> log
	@echo "----------------------------------------------------------------"
	@echo You have now got these PDFs:
	@ls -C *pdf
	@echo "-- That should say (at least):" paper.pdf appendix.pdf
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
	# rm -f paper.pdf appendix.pdf
	git push -u origin master
	
# This, next, creates (and preserves) a single PDF, all.pdf, separately maintained at http://www.harold.thimbleby.net as reliable-models.pdf (which it links to)

# PS I'd rather say $APPENDIX than supplementary material (if that's what $APPENDIX is), but it 
# needs make to expand the definition, whereas in the comment, we're using grep to grab the text
# so APPENDIX won't get expanded

one-file: # Make a single PDF file \texttt{all.pdf} (i.e., paper + supplementary material) all in one.
	@make one.file

# this rule has a . in the target name (one.file), so make help doesn't find it (see the grep command in make help)
one.file: paper.pdf appendix.pdf # concatenate files
	@echo make single PDF file all.pdf
	@echo NB use make expand instead to make $(EXPANDEDPREFIX)all.pdf etc
	pdfunite paper.pdf appendix.pdf all.pdf

zip-data: # Just make a zip archive of the data only. This is required for, e.g., uploading to a Dryad repository --- which is quirky as it won't include all the code needed to handle the data!
	make data
	@echo NB You will get some undefined reference warnings, as the data is not typeset in the papers which it cross-references
	rm -f dryad-data.zip everything.zip
	zip dryad-data README.md programs/data.js

expand: # Expand all \LaTeX\ files (to recursively flatten \texttt{input} and \texttt{bibliography} files, etc) to meet \LaTeX\ single-file processing restrictions for journals like \emph{PLOS} and \emph{IEEE Transactions on Software Engineering}, then make new PDFs to upload. (Note that \texttt{make expand} will do a \texttt{make pdf} first to ensure all the data and aux files are around to be expanded.)
	@echo First make normal unexpanded pdf files so we can compare them with the expanded version to check expansion works correctly
	make pdf
	make one-file
	node programs/expand.js
	sh $(EXPANDEDPREFIX)copyfiles.sh
	$(LATEX) $(EXPANDEDPREFIX)appendix.tex > log
	$(LATEX) $(EXPANDEDPREFIX)paper.tex >> log
	@echo The expanded table of contents still defines new labels, so process the new .aux files so there are no errors
	$(LATEX) $(EXPANDEDPREFIX)appendix.tex > log
	$(LATEX) $(EXPANDEDPREFIX)paper.tex >> log
	@echo We kept the logs if you are interested, but thanks to the way expanded files work, every label may seem to be multiply defined
	pdfunite $(EXPANDEDPREFIX)paper.pdf $(EXPANDEDPREFIX)appendix.pdf $(EXPANDEDPREFIX)all.pdf >> log
	if diff-pdf all.pdf $(EXPANDEDPREFIX)all.pdf; then echo SAME -- SUCCESS; else echo DIFFERENT -- FIX SOMETHING AND TRY AGAIN; fi
	rm -f $(EXPANDEDPREFIX)*.out $(EXPANDEDPREFIX)*.log $(EXPANDEDPREFIX)*.aux $(EXPANDEDPREFIX)*.toc $(EXPANDEDPREFIX)*.dvi *.blg
	@echo NB the PDFs still depend on comjnl.cls
	@echo FINALLY - move all expanded stuff to the directory expanded/
	mv EX* expanded
	ls expanded
	@echo You now have these expanded PDF files
	@echo; ls expanded/$(EXPANDEDPREFIX)*pdf; echo 
	@echo as well as the corresponding expanded source files 
	@echo; ls expanded/$(EXPANDEDPREFIX)*tex; echo
	
check-git: # Is there anything on Git that we've lost, or stuff we have got locally but probably don't want on Git, so you can delete it or move it out the way or whatever.
	@echo "We probably don't want some random stuff added to the Git repo..."
	@rm -f /tmp/-on-git /tmp/-on-local
	@(echo .gitignore; find . -not -path '*/.*' -type f -print ) | sed "s/^\.\///" | sort > /tmp/-on-local
	@(ls `sed "s/#.*//" .gitignore`; git ls-tree -r master --name-only) | sort > /tmp/-on-git
	@echo
	@echo `comm -1 -3 /tmp/-on-git /tmp/-on-local | wc -l` "additional local files not on Git - maybe remove or put in .gitignore"
	@comm -1 -3 /tmp/-on-git /tmp/-on-local | sed "s/^/ +  /"
	@echo
	@echo `comm -2 -3 /tmp/-on-git /tmp/-on-local | wc -l` "files not local but are on Git - maybe copy from Git"
	@comm -2 -3 /tmp/-on-git /tmp/-on-local | sed "s/^/ -  /"
	@rm -f /tmp/-on-git /tmp/-on-local
	@echo
	@echo You may want to run make tidyup
    