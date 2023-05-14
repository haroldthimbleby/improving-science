(ls `sed "s/#.*//" .gitignore`; git ls-tree -r master --name-only) | sort > git-files
(echo .gitignore; find . -not -path '*/.*' -type f -print ) | sed "s/^\.\///" | sort > git2-files
diff git-files git2-files
