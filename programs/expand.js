// Harold Thimbleby, 2020-2023
// Javascript code to recursively expand TeX \input commands in files TeXFiles[] (see below for value)
// run as node generated/expand.js
'use strict';

var TeXFiles = ["paper.tex", "appendix.tex"];

function makenote(vector) { 
    var files = "", expandedfiles = "";
    for( var i = 0; i < vector.length; i++ )
    {	files += i == 0? "": i < vector-1? ", ": ", and "; 
        files += vector[i];
        expandedfiles += i == 0? "": i < vector-1? ", ": ", and "; 
        expandedfiles += "expanded-"+vector[i];
    }
	var plural = vector.length > 1;
	return ("LaTeX file-noun ("+files+")\n  to make "+(plural?"":"this ")+"straight forward LaTeX file-noun ("+expandedfiles+")\n    that depend-verb on nothing ("+(plural?"they":"it")+" input-verb no files apart from the document class files).\n      Each required file's text was input in situ - search for % expand\n\n(Otherwise the file-noun "+files+" would use BibTeX, a macro file, tables of contents, "+(plural?"their":"its")+" own and the other files's .aux files, and include-verb various files in generated/*, etc.)\n").replace(/-noun/mg, plural?"s":"").replace(/-verb/mg, plural?"":"s");
}

console.log("This app expands complex "+makenote(TeXFiles));
// console.log("This app expands the complex "+makenote([TeXFiles[0]]));

var fs = require('fs');

function saveFile(fileName, string) {
    fs.open(fileName, 'w', function (err, fd) {
        if (err) {
            if (err.code === 'EEXIST') {
                console.error(fileName + " can't be over-written");
                return;
            }
            console.error("** Some error trying to write " + fileName);
            throw err;
        }
        fs.writeFileSync(fd, string, function (err) {
            if (err) {
                return console.log("** Saving " + fileName + " got error: " + err);
            }
        })
    });
}

function getFile(file) {
	file = file.trim();
    try {
        return fs.readFileSync(file, {encoding:'utf8', flag:'r'});
    } catch (err) {
        console.log("** Can't read file " + file + " - " + err);
        return "\\error couldn't read " + file + "\n";
    }
}

var re = RegExp("\\\\input (.*)\n", "g"), rebib=RegExp("\\\\bibliography{(.*).bib}"), recontents=RegExp("\\\\tableofcontents");

var contentsStuff = "\\makeatletter\n  \\section*{\\contentsname\n    \\@mkboth{\\MakeUppercase\\contentsname}{\\MakeUppercase\\contentsname}}\n\\makeatother";

var bufferExpand, bufferInsert, auxfile, rootfile, insertTableOfContents;

insertTableOfContents = false;
for (var i = 0; i < TeXFiles.length; i++) {
    console.log("Recursively expand all \\input, \\tableofcontents, and \\bibliography macro calls in " + TeXFiles[i]);
    rootfile = TeXFiles[i].replace(/.tex/, "");
    auxfile = rootfile+".aux";
    console.log("        \\input " + auxfile + " => automatically pre-inserted between \\makeatletter and \\makeatother");
    
    bufferExpand = ("\nThis file has been expanded from "+makenote([TeXFiles[i]])).replace(/^/gm, "% ")+"\n\n";
	bufferExpand = bufferExpand + "\\makeatletter\n"+getFile(auxfile) + "\n\\makeatother\n";
    bufferExpand = bufferExpand + getFile(TeXFiles[i]); // puts in buffer
    var replaced;
    do {
        replaced = false;
        bufferExpand = bufferExpand.replace(re, function (match, filename) {
            replaced = true;
            console.log("        \\input " + filename);
            bufferInsert = getFile(filename);
            return "% expand " + filename + "\n" + bufferInsert + "% end expanding " + filename + "\n";
        });
        bufferExpand = bufferExpand.replace(rebib, function (match, filename) {
        	replaced = true;
            console.log("      * \\bibliography{"+filename+".bib} => replaced with " + filename+".bbl");
            bufferInsert = getFile(filename+".bbl");
            return "% expand bibliography " + filename + ".bbl\n" + bufferInsert + "\n% end expanding bibliography " + filename + ".bbl\n";
        });
        bufferExpand = bufferExpand.replace(recontents, function (match, filename) {
        	replaced = true;
			insertTableOfContents = true;
            console.log("      * \\tableofcontents => replaced with "+ rootfile+".toc, after standard expansion of \\tableofcontents macro");
            bufferInsert = contentsStuff+getFile(rootfile+".toc");
            return "% expand table of contents " + rootfile + ".toc\n" + bufferInsert + "\n% end expanding table of contents " + rootfile + ".toc\n";
        });
    }
    while (replaced);
    saveFile("expanded-" + TeXFiles[i], bufferExpand);
    console.log("  ->  Saved as: " + "expanded-" + TeXFiles[i] + "\n");  
}

if( insertTableOfContents )
	console.log("\nThe table of contents prefix (in the definition of \\tableofcontents, inserted before *.toc) used was:\n"+contentsStuff.replace(/^/mg, ">    ")+"\n");
