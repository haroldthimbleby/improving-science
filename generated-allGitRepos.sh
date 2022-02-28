rm -rf "git-MetricSelectionFramework"
git clone "http://github.com/ChristophKanzler/MetricSelectionFramework" "git-MetricSelectionFramework"

rm -rf "git-PENet"
git clone "http://github.com/marshuang80/PENet" "git-PENet"

rm -rf "git-PostoperativeOutcomes_RiskNet"
git clone "http://github.com/cklee219/PostoperativeOutcomes_RiskNet" "git-PostoperativeOutcomes_RiskNet"

rm -rf "git-philter-ucsf"
git clone "http://github.com/BCHSI/philter-ucsf" "git-philter-ucsf"

rm -rf "git-AI-CDSS-Cardiovascular-Silo"
git clone "http://github.com/ubiquitous-computing-lab/AI-CDSS-Cardiovascular-Silo" "git-AI-CDSS-Cardiovascular-Silo"

rm -rf "git-SiameseChange"
git clone "http://github.com/QTIM-Lab/SiameseChange" "git-SiameseChange"

rm -rf "git-lactModel"
git clone "http://github.com/SolangeD/lactModel" "git-lactModel"

rm -rf "git-LRM"
git clone "http://github.com/UT-NSG/LRM" "git-LRM"

rm -rf "git-manifold-ga"
git clone "http://github.com/ki-analysis/manifold-ga" "git-manifold-ga"

rm -rf "git-blast-ct"
git clone "http://github.com/biomedia-mira/blast-ct" "git-blast-ct"

( echo "% date generated by running generated-allGitRepos.sh downloading Git repos";
echo \\\\def\\\\clonedate {\\\\ignorespaces `date "+%e %B %Y"`}
echo \\\\def\\\\cloneyear {`date "+%Y"`}
echo \\\\def\\\\clonemonth {`date "+%m"`}
) > ../generated-clone-date.tex

(echo % shell-script calculated metavariables; echo "\\\newcount \\\JSONerrorCount";echo "\\\newcount \\\dataVariableCount") > ../generated-metadata.tex

# how many errors can data.js find?
echo "\\\JSONerrorCount =" `grep "error(" ../data.js|wc -l` >> ../generated-metadata.tex

# how many variables does data.js define?
echo "\\\dataVariableCount =" >> ../generated-metadata.tex
egrep "(newcount)|(\\\\def)" ../data.js|wc -l >> ../generated-metadata.tex
echo "\\\advance \\\dataVariableCount by -1" >> ../generated-metadata.tex
