

# First create a new git repo `r-knowledge` on the github remote
```Bash
mkdir -p r-knowledge && cd r-knowledge


mkdir -p notes
touch  notes/setup_script.md

# Source git repos - original/upstream code
mkdir -p sources/wobbrock sources/jbpost2

# My customized code
mkdir -p my-code

# Working project scripts
mkdir -p  scripts

touch README.md
touch SOURCES.md

git init
git branch -M main
git add .
git commit -m "Create personal R knowledge repository"

git config --global user.email "ezhwang@gmail.com"
git config --global user.name "zhaohuiwang"
git push -u origin main

git remote add origin git@github-personal:zhaohuiwang/r-knowledge.git

# Add the first upstream source repo
git subtree add --prefix=sources/wobbrock/Rstats https://github.com/wobbrock/Rstats.git main --squash
git push origin main    # push it before adding the next.

git subtree add --prefix=sources/jbpost2/website https://github.com/jbpost2/jbpost2.github.io.git main --squash
git push origin main

# To pull or update upstream 
git subtree pull --prefix=sources/wobbrock/Rstats https://github.com/wobbrock/Rstats.git main --squash


# To work on the my-code copy
mkdir -p my-code/statistics
cp sources/wobbrock/Rstats/R/GLM.R my-code/statistics/

# Now, independent code in my-code dir can be modified. If you want to incoporate the upstream changes or compare the difference if any 
diff sources/wobbrock/Rstats/R/GLM.R my-code/statistics/GLM.R
# or 
git diff --no-index sources/wobbrock/Rstats/R/GLM.R my-code/statistics/GLM.R
# Then manually incorporate the useful upstream changes into your version.


```