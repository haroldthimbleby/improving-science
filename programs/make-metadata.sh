echo % shell script "(make-metadata.sh)" generated LaTeX variable values counting errors detected by data.js > generated/metadata.tex

# how many errors can data.js find?
echo \\\\newcount \\\\JSONerrorCount >> generated/metadata.tex
echo \\\\JSONerrorCount = `grep "error(" programs/data.js|wc -l` >> generated/metadata.tex

# put count of variables (number registers plus macro definitions) to \JSONvariableCount
echo \\\\newcount \\\\dataVariableCount >> generated/metadata.tex
echo \\\\dataVariableCount = `egrep "(newcount)|(\\\\\\\\def)" generated/*|wc -l` >> generated/metadata.tex


