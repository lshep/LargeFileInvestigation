# Investigate large files in current repositorys

First attempt in `run1_Oct_2025` directory.

  -  Based on this run, sent emails to packages with actively large files.
  
  - Also sent emails to select repos with legacy large files in git history requiring a clean repo reset


Second attempt in `run2_Jan_2026` directory

  - created a file to run on machines called `find-large-files.sh` that prints
    out the actively large files. It takes a directory as argument. See below
    for details. File likely in directory `sandbox` 

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

This will get currently active large files NOT the files that need to be
cleaned of git history

