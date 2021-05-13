# code-qa: An example data analysis repository

## Table of Contents

* Description
* Installation Instructions
* Setup 
* Dependencies
* Directions for running the code and examples
* Authors
* License(s)

## Description

This repository was built to represent an example code repository for data analysis in R. This repository is utilized as reference in Best Practices in Statistical Computing (Sanchez et al., Under Review). Following the format of this repository for your analyses will lead to painless QA. 

## Installation/Setup Instructions

The following directions will give you the information you need to setup a similar repository. If you don't already have R and R studio on your machine, you will need to install them both if you want to clone this repository and run the example. Install [**R**](https://www.r-project.org/) and [**RStudio**](https://www.rstudio.com/products/rstudio/download/). If you utilize other programming languages/software, make sure those are installed on your machine.

## Setup

This is not an R package so you don't need to install anything additional until we get to package dependencies. However, whether(recommended) you create your repository mimicking the setup in this repository or you clone this repository to your local machine and start your new project from there, the setup of your repository is critical.

Notice that within this repository there are only a few files/folders on the landing page:

**Files:**<br>

(1) [**.gitignore**](https://github.com/jpane24/code-qa/blob/main/.gitignore)<br>
(2) [**LICENSE**](https://github.com/jpane24/code-qa/blob/main/LICENSE)<br>
(3) [**README.md**](https://github.com/jpane24/code-qa/blob/main/README.md)<br>
(4) [**code-qa-case-study.Rproj**](https://github.com/jpane24/code-qa/blob/main/code-qa-case-study.Rproj)<br>

**Folders:**<br>

(1) [**code**](https://github.com/jpane24/code-qa/tree/main/code)<br>
(2) [**output**](https://github.com/jpane24/code-qa/tree/main/output)<br>

Files one through three are not super important when setting up the repository. The .gitignore file specifies what files will be ignored when a user pushes their respository to github. This package utilizes the default .gitignore file for packages and repositories. The LICENSE file is referenced at the bottom of this README but it can be generated automatically when a user creates their repository. The README.md file is the raw format of this compiled markdown file.

The fourth and final file of the landing page is the R project file. This file will only be here if you utilize R as your language of choice. The .Rproj file can be created through RStudio and it always should be in the main directory of your project along with the two folders in this repository (code and output). This is a critical step because when you load any data or write output, the home directory will refer to where you open your .Rproj file. For example, as opposed to using something like this:

```
source("~/Desktop/my-project/code/helper.R")
```

you can use a more robust file referral line of code that will work on anyone's computer that follows this setup:

```
source("code/helper.R")
```

The code folder contains all code files that are used in the repository.

The file names are setup in a way where it is easy to understand what files should be run first. The analysis files all start with RXX and XX are numbers to show which order they should be run in. R00 comes first and R02 comes last. The other files are helper files that don't necessarily need to be run independently. The helper.R file is a file that contains all of the helper functions used throughout the RXX series. This file is loaded at the top of the R00 analysis file. The synth-creation.R file is a bonus file that shows how one may create synthetic data. Finally, the run_full.R will run the entire analysis RXX series at once. Running this file should produce no warnings or errors and is a good way to check and make sure your code is working correctly.

If a user wishes to run the files interactively they will need to run the RXX series in order for everything to run properly.

## Dependencies

The dependencies to successfully run the code in your repository may be different. For this repository there are two sets of dependencies. The first set of dependencies are a series of R packages that must be installed on your machine. If a package is not installed in your version of R, you can install them using the following R function and replacing my_package_name with the R package you wish to install.

```
install.packages("my_package_name")
```

For this repository, the following packages should be installed and loaded into your R session. The RXX files contain library calls in the following order:

```
library(tidyverse)
library(OVtool) 
library(descriptr)
library(twang)
library(survey)
```

The second "set" of dependencies is to ensure that a user runs the programs in the correct order. If a user wishes to work through R02-Analysis.R, the user must have already run the R00 and R01 files in order.

## Directions for running the code and examples

There are two ways to run this code. First, you can simply run the contents in run_full.R and it will run the entire analysis file. You can do this one of two ways, the first is through R and the second is through the command prompt:

**R:** 

```
source("code/run_full.R")
```

**Command line:**

```
cd code
R CMD BATCH run_full.R run_full_output.Rout
```

Alternatively you can interactively run through the analysis file line-by-line. Start with R00-Data-Cleaning.R and follow the RXX series in order. 

## Authors

* **Joseph Pane** - *Creation of repository*

* **Ricardo Sanchez** - *Co-author*

* **Beth Ann Griffin** - *Co-author*

* **Daniel McCaffrey** - *Co-author*

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](https://github.com/jpane24/code-qa/blob/main/LICENSE) file for details

