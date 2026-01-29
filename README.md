# Investigate large files in current repositorys

## First attempt in `run1_Oct_2025` directory.

Original Run

  -  Based on this run, sent emails to packages with actively large files.
  
  - Also sent emails to select repos with legacy large files in git history requiring a clean repo reset


## Second attempt in `run2_Jan_2026` directory

Run scripts to create lists of packages

  - created a file to run on machines called `find-large-files.sh` that prints
    out the actively large files. It takes a directory as argument. See below
    for details. File likely in directory `sandbox`. This will get currently
    active large files NOT the files that need to be cleaned of git history

   - created a second file to run on the machines called `find-git-blobs.sh`
     that prints the packages that have a large git pack file tracing a large
     file that was once in the history. It also takes a directory as
     argument. These packages will need to clean the git history

    	* Data Experment:  as biocbuild@nebbiolo1 (current devel builder) at
              /home/biocbuild/bbs-3.23-data-experiment/MEAT0/
	      
        * Data Annotation: as biocbuild@nebbiolo1 (current devel builder) at
          /home/biocbuild/bbs-3.23-data-annotation/MEAT0/
	  
	* Workflow: as biocbuild@bbscentral1 (current devel builder) at
          /media/volume/bbs1/biocbuild/bbs-3.23-workflows/MEAT0/

        * Software: as biocbuild@bbscentral1 (current devel builder) at
          /media/volume/bbs1/biocbuild/bbs-3.23-bioc/MEAT0/

        * Books: as biocbuild@bbscentral1 (current devel builder) at
          /media/volume/bbs1/biocbuild/bbs-3.23-books/MEAT0/

After running the following, copied results locally.  Manually created
`AllPackagesWithActiveLargeFiles.txt` and `AllPackagesWithGitBlobs.txt` of just
package lists. 

Run `mapEmails.R` that uses the Bioconductor package maintainer app to map the
package lists to maintainer emails.

Manual add any information from the first run into the saved csv files.

Added `addRevDeps.R` to get an analysis of reverse dependencies for packages
with large files to get a sense of affect of deprecation/removal.  Created
separate file with info `PackageMaintainers_LargeFiles_WithRevDeps.csv`