BEGIN { 
    inPython = 0; 
    files = ""
    for( i = 1; i < ARGC; i++ )
    	files = files " " ARGV[i]
    s = "print(\"Running the Python code extracted by awk script from" files "\")\n"
}

/begin.tabbing/ { inPython = 1; }

/end.tabbing/ { inPython = 0; }

inPython { s = s "\n" $0; }

END { 
	gsub(/\\tt/,"", s);
    gsub(/\\(>|=)/, "", s);
    gsub(/\\#/, "#", s);
    gsub(/.(begin|end).tabbing./, "", s);
    
    # The Latex code mixes its own {} with Python's {}, so the bracket edits are done more carefully:
    gsub(/\\\{/, "LEFT", s);
    gsub(/\\\}/, "RIGHT", s);
    gsub(/\{|\}/, "", s);
    gsub("LEFT", "{", s);
    gsub("RIGHT", "}", s);
    
    gsub("\Q$\\pi$\E", "", s);
    gsub(/\{.tt/, "", s);
    gsub(/\\ /, " ", s);
    gsub(/.hskip 1em/, "   ", s);
    gsub(/\\\\/, "", s);
    gsub(/.\\pi./, "pi", s);
    
    gsub(/.orderA/, "a", s);
    gsub(/.orderB/, "b", s);
    
    printf s "\n"; 
}


