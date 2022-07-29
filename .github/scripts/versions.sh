#!/bin/bash
# Recursively finds all directories with a go.mod file and creates
# a GitHub Actions JSON output option. This is used by the linter action.
echo "Resolving versions in $(pwd)"
mkdir -p .versions
rm -rf .versions/versions.txt
for file in $(pwd)/.github/versions/${part}/CHANGELOG*
do
  versions=$(echo $file | cut -d '-' -f 3 | cut -d '.' -f 1,2)
  cat $file| grep "\[v"| grep -v "github"  | grep -v "alpha" | grep -v "stable"| grep -v "there" | grep -v "beta"| grep -v "rc" | awk '{print $2}' | cut -d '[' -f  2 | cut -d ']' -f 1 | cut -d 'v' -f 2  |  awk '{printf "{\"'version'\":\"%s\"},",$1}' >> .versions/versions.txt
done
echo $i
VERSIONS=$(cat .versions/versions.txt)
echo "versions is : {\"include\":[${VERSIONS%?}]}"


echo "::set-output name=matrix::{\"include\":[${VERSIONS%?}]}"
