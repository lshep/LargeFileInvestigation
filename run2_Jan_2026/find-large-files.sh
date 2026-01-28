#!/bin/bash

## Example Executes:
## ./find-large-files.sh "/home/biocbuild/bbs-3.23-data-experiment/MEAT0/"  > ExperimentDataLargeFileResults.txt
## ./find-large-files.sh "/home/biocbuild/bbs-3.23-data-annotation/MEAT0/"  > AnnotationDataLargeFileResults.txt
## ./find-large-files.sh "/media/volume/bbs1/biocbuild/bbs-3.23-workflows/MEAT0/" > WorkflowsLargeFileResults.tx
## ./find-large-files.sh "/media/volume/bbs1/biocbuild/bbs-3.23-bioc/MEAT0/" > SoftwareLargeFileResults.txt
## ./find-large-files.sh "/media/volume/bbs1/biocbuild/bbs-3.23-books/MEAT0/" > BooksLargeFileResults.txt


# Exit if BASE_DIR is not provided
if [ -z "$1" ]; then
  echo "Usage: $0 <BASE_DIR>"
  exit 1
fi

BASE_DIR="$1"
#BASE_DIR=~/bbs-3.22-data-experiment/MEAT0

repos_with_large_blobs=()

# First section: print large blobs with repo name
for dir in "$BASE_DIR"/*; do
  if [ -d "$dir/.git" ]; then
    cd "$dir" || continue
    repo_name=$(basename "$dir")
    output=$(git rev-list --objects --all |
      git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
      grep '^blob' |
      awk -v repo="$repo_name" '$3 > 100000000 {printf "%s\t%.2f MB\t(%d bytes)\t%s\n", repo, $3/1000/1000, $3, $4}' |
      sort -k2 -nr)

    if [ -n "$output" ]; then
      echo "$output"
      repos_with_large_blobs+=("$repo_name")
    fi
  fi
done

# Second section: print unique repo names
if [ ${#repos_with_large_blobs[@]} -gt 0 ]; then
  echo
  echo "# Repositories with large blobs:"
  printf '%s\n' "${repos_with_large_blobs[@]}" | sort -u
fi
