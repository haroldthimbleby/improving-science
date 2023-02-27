#!/bin/sh
#
# @file runMathematicaNotebook.sh
#
# Extract code from a Mathematica notebook and run it using wolframscript
#
# Usage: runMathematicaNotebook.sh notebook.nb
#
# Based on: https://mathematica.stackexchange.com/a/31157
# from https://gist.github.com/tueda/9281f0b894eef9cad09d7e25d48d3a7a 
# Unlike the original on stackexchange, this shell script 
#     - it runs a Mathematica notebook but does not update it
#     - it runs the notebook for its side-effects, such as any Export[files,results]
#

WOLFRAMSCRIPT=wolframscript
script=tmp-mathematica-script

if [ $# != 1 ]; then
  echo "Usage: $0 file.nb" >&2
  exit 1
fi

cat <<'END' >$script
Begin["shellScriptContext`"];
outputCellPattern = Cell[_, "Output", ___];
cellEval[Cell[b_BoxData, "Input", rest___]] :=
  Cell[
    CellGroupData[{
      Cell[b, "Input", rest],
      Cell[BoxData@ToBoxes@(ToExpression @@ b), "Output"]
    }, Open]
  ];

cellEval[x : (_CellGroupData | _Cell | _Notebook)] := cellEval /@ x;
cellEval[l_List] := cellEval /@ Cases[l, Except@outputCellPattern, {1}];
cellEval[somethingElse_] := somethingElse;

evaluateNotebook[notebook_] := cellEval@Get[notebook];

nbFullFileName = FileNameJoin[{Directory[], $ScriptCommandLine[[1]]}];

End[];

shellScriptContext`evaluateNotebook[shellScriptContext`nbFullFileName];

END

echo Run Mathematica script to evaluate notebook $1 for its side-effects, like data or image Exports
$WOLFRAMSCRIPT -f $script -script $1
err=$?

#rm $script

exit $err

