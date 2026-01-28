#!/bin/bash

## Example Executes:
## ./find-git-blobs.sh "/home/biocbuild/bbs-3.23-data-experiment/MEAT0/"  > ExperimentDataGitBlobsResults.txt
## ./find-git-blobs.sh "/home/biocbuild/bbs-3.23-data-annotation/MEAT0/"  > AnnotationDataGitBlobsResults.txt
## ./find-git-blobs.sh "/media/volume/bbs1/biocbuild/bbs-3.23-workflows/MEAT0/" > WorkflowsGitBlobsResults.txt
## ./find-git-blobs.sh "/media/volume/bbs1/biocbuild/bbs-3.23-bioc/MEAT0/" > SoftwareGitBlobsResults.txt
## ./find-git-blobs.sh "/media/volume/bbs1/biocbuild/bbs-3.23-books/MEAT0/" > BooksGitBlobsResults.txt

if [ -z "$1" ]; then
  echo "Usage: $0 <BASE_DIR>"
  exit 1
fi

BASE_DIR="$1"
SIZE_LIMIT=104857600   # 100 MB
repos_with_orphaned_packs=()

echo "# Scanning for repos with large Git packfiles but no working tree files >100MB..."
echo

for dir in "$BASE_DIR"/*; do
  if [ -d "$dir/.git" ]; then
    repo_name=$(basename "$dir")
    cd "$dir" || continue

    # 1. Check for large working tree files
    has_large_working_files=$(find . -type f -size +104857600 ! -path "./.git/*" | wc -l)

    if [ "$has_large_working_files" -gt 0 ]; then
      # Skip this repo — large files exist in working tree
      continue
    fi

    # 2. Check large packfiles
    for packfile in .git/objects/pack/*.pack; do
      [ ! -e "$packfile" ] && continue
      size=$(stat -c%s "$packfile")
      if [ "$size" -gt "$SIZE_LIMIT" ]; then
        echo -e "${repo_name}\t$(awk "BEGIN{printf \"%.2f\", $size/1048576}") MB\t($size bytes)\t$packfile"
        repos_with_orphaned_packs+=("$repo_name")
      fi
    done
  fi
done

# Summary
if [ ${#repos_with_orphaned_packs[@]} -gt 0 ]; then
  echo
  echo "# Repositories with orphaned large Git packfiles (no large working tree files):"
  printf '%s\n' "${repos_with_orphaned_packs[@]}" | sort -u
else
  echo "No repos with orphaned large Git packfiles found."
fi
