# Large File Investigation

This is aimed to investigate large files in currently active Bioconductor
repositories that would prevent them from easily transitioning from our custom
git server to GitHub.


The repo currently containst the following:

1. **scripts.sh**: 
   This script contains where commands were run and the command to look for
   files over 100Mb. It lists sizes and file names, and unique lists of packages
   for each type of repository (data-experiment, workflow, bioc).  

2. **packagelist.csv**: 
   This is a manually created list of the packages and package type from scripts.sh

3. **addRanks.R**: 
   This reads in packagelist.csv, retrieves downloads statistics using
   BiocPkgTools and adds overall unique downloads over the years to evaluate
   download trends.

4. **packages_filled_stats.csv**:
   Table results of addRanks.R 

5. **investigation.Rdata**: 
   RData saved image at end of addRanks.R
