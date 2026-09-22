
### Getting started with R & RStudio

```Bash
# Install R and RStudio
cat /etc/linuxmint/info
sudo apt update
sudo apt install r-base r-base-dev
R –version
# Use the official Posit RStudio download page to download Rstudio Desktop, and choose "Ubuntu 22 / 24 / 26, Debian 13" option and .deb package.
cd ~/Downloads
sudo apt install ./rstudio-2026.09.0-174-amd64.deb
rstudio –version
which R			# /usr/bin/R
rstudio
> R.version.string		# Run this at a RStudio session to verify which R version is using
> R.home()

# Upgrade the R while keep the existing version(s)
cd ~/Downloads
wget https://cdn.posit.co/r/ubuntu-2404/pkgs/r-4.6.1_1_amd64.deb
sudo apt install ./r-4.6.1_1_amd64.deb
/opt/R/4.6.1/bin/R –version

echo 'export PATH="/opt/R/4.6.1/bin:$PATH"' >> ~/.bashrc	# Put the new R into PATH as the default. To check which shell you are using echo $SHELL (both ~/.bashrc and ~/.zshrc might exist)
source ~/.bashrc		# Reload the shell

# On macOS/Windows, RStudio's Tools → Global Options → General → R version → Change… 
# On Linux, RStudio normally finds R through the system environment. To switch RStudio from one R version to another through the RSTUDIO_WHICH_R environment variable. Close RStudio completely, then open a terminal and run:
RSTUDIO_WHICH_R=/usr/bin/R rstudio      # or
RSTUDIO_WHICH_R=/opt/R/4.6.1/bin/R rstudio
# Once RStudio opens, to verify the R version run this in the R console 
R.version.string 
# RSTUDIO_WHICH_R determines which R executable RStudio starts, and that R executable determines the default library paths that .libPaths() sees.

# If you want a permanent choice, you can create convenient commands and added them into ~/.bashrc 
alias rstudio43='RSTUDIO_WHICH_R=/usr/bin/R rstudio'
alias rstudio46='RSTUDIO_WHICH_R=/opt/R/4.6.1/bin/R rstudio'
# Then reload 
source ~/.bashrc
# Now you can choose R version and start RStudio by simple run the following in the terminal
rstudio43
rstudio46
```


```Bash
# Check your current directory - In the RStudio Console:
getwd()
# You ideally should see `~/Projects/r-knowledge`. If not, you can temporarily set it with:
setwd("~/Projects/r-knowledge")

# The recommended solution: create an RStudio Project. From your terminal,
cd ~/Projects/r-knowledge
rstudio .
# Then in RStudio, select: File → New Project → Existing Directory. Choose: ~/Projects/r-knowledge. RStudio will create a file like: `r-knowledge.Rproj`. Now if you run `getwd()` in the RStudio Console, you will get "/home/zhaohuiwang/Projects/r-knowledge"


```
RStudio configuration: Tools → Global Options → General
- Restore most recently opened project at startup - Enable it.
- Restore previously open source documents at startup - If you like RStudio to pick up where you left off, enabled it so RStudio remembers which files/tabs you had open and reopens them next time you restart the RStudio session. It does not restore your R variables.
- Restore .RData into workspace at startup - .RData contains R objects/variables that were saved from a previous R session. If those objects are saved into .RData, RStudio can restore them when it starts even though you have not reun your script yet. Never is generally a good choice for project-based work. It prevents old variables from silently appearing in a new session (To avoid accidental cross-project containmation and ensure a clean R environment).
- Save workspace to .RData on exit - This controls what happens when you close RStudio. If you set it to save, RStudio can save your current R objects. Never for most project-based workflows.

```Bash
# Directory-based: you're telling RStudio "open this directory."; if it represents an RStudio Project (containing a .Rproj file), open that project."
cd ~/Projects/r-knowledge && rstudio .
# Explicit: you're telling RStudio exactly which project file to open
cd ~/Projects/r-knowledge && rstudio my-project.Rproj
```

R packages are usually installed outside your individual RStudio project directories, and therefore they are generally shared across projects. In RStudio Console `.libPaths()`

```Bash
.libPaths()
[1] "/home/zhaohuiwang/R/x86_64-pc-linux-gnu-library/4.6"
[2] "/opt/R/4.6.1/lib/R/library"
# If you have `renv` installed, `.libPath()` is being controlled by `renv` rather than showing the normal  system-wide R libraries.

```
[1] contains your personal R package library. For example, dplyr, ggplots, tidyr etc. This library is share across your RStudio projects. [2] contains packages that came with R itself or were installed into R's system library which blones to R 4.6.1 installation. You can list them with: `installed.packages(lib.loc = .libPaths()[2])[, "Package"]
`. 

Why is [1] before [2]?
R searches package libraries in the order shown by .libPaths(). This ordering also matters if the same package exists in both libraries. The one in the first applicable library takes precedence. You can inspect them directly from the terminal:
```Bash
ls ~/R/x86_64-pc-linux-gnu-library/4.6
ls /opt/R/4.6.1/lib/R/library
```

A dependency management toolkit for R - renv (short for R environment).

```Bash
# In Console
install.packages("renv")
renv::init()
renv::snapshot()    # Updates renv.lock file, saving the state of the project library.
renv::restore()     # Restores the state of R environment to replicate what is in lock file. 
renv::update()      # To get the latest versions of all dependencies
renv::history()
renv::revert()      # To roll back to an even older version 
renv::install()     # 
renv::status()

renv::cache_clean(dry.run = TRUE)
renv::cache_clean()     # Removes cached package versions that renv considers no longer needed.


```
`renv::init()` creates a folder `renv` and a file `renv.lock` in the project directory. renv also maintains a local cache of data (shared) on the file system located at `~/.cache/R/renv`. You only ever have to download and install a package once, and for each subsequent install, renv will just add a link from the project library to the global cache. `renv::init()` will detect package dependencies based on library() and require() in R scripts found in the R project. After installing the package and checking that your code works, you should call renv::snapshot() to record the latest package versions in your lockfile.


### References
- [Statistical Inference in R, by Jacob O. Wobbrock, University of Washington](https://depts.washington.edu/acelab/proj/Rstats/index.html?utm_source=chatgpt.com)
- [Machine learning in R, by Ott Toomet, University of Washington](https://faculty.washington.edu/otoomet/machinelearning-R/)
- [Choosing a Statistical Test, by Salvatore S. Mangiafico](https://rcompanion.org/handbook/D_03.html)
- [RStudio User Guide](https://docs.posit.co/ide/user/ide/guide/environments/r/renv.html)
- [github RStudio Cheatsheets](https://github.com/rstudio/cheatsheets)
- [Johns Hopkins Sheridan Libraries and University Museums Research Guides Using R and Python](https://guides.library.jhu.edu/c.php?g=903617&p=6776485)
-[Utah State University R&RStudio Reference Guide](https://artsci.usu.edu/math-stats/amlc/files/r-studio-reference-sheets-compilation.pdf)