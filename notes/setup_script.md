

# First create a new git repo `r-knowledge` on the github remote
```Bash
mkdir -p r-knowledge && cd r-knowledge


mkdir -p notes
touch  notes/setup_script.md

# Source git repos - keep them original
mkdir -p sources/wobbrock sources/jbpost2

# My version of cloned git repos - may contains modifications
mkdir -p my-code

# Working project scripts
mkdir -p  scripts

touch README.md
touch SOURCES.md

git init
git branch -M main
git add .
git commit -m ""

```