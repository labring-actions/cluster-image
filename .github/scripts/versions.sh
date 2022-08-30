#!/bin/bash
# Recursively finds all directories with a go.mod file and creates
# a GitHub Actions JSON output option. This is used by the linter action.
echo "Resolving versions in $(pwd)"
mkdir -p .versions
rm -rf .versions/versions.txt
for file in $(pwd)/.github/versions/${part}/CHANGELOG*; do
  if ! [[ "$sealoslatest" =~ ^[0-9\.]+[0-9]$ ]]; then
    wget -qO- "https://github.com/kubernetes/kubernetes/raw/master/CHANGELOG/${file##*/}" |
      grep -E '^- \[v[0-9\.]+\]' | awk '{print $2}' | awk -F\[ '{print $2}' | awk -F\] '{print $1}' |
      cut -dv -f 2 | head -n 1 |
      awk '{printf "{\"'version'\":\"%s\"},",$1}' >>.versions/versions.txt
  else
    wget -qO- "https://github.com/kubernetes/kubernetes/raw/master/CHANGELOG/${file##*/}" |
      grep -E '^- \[v[0-9\.]+\]' | awk '{print $2}' | awk -F\[ '{print $2}' | awk -F\] '{print $1}' |
      cut -dv -f 2 |
      awk '{printf "{\"'version'\":\"%s\"},",$1}' >>.versions/versions.txt
  fi
done
VERSIONS=$(cat .versions/versions.txt)
echo "versions is : {\"include\":[${VERSIONS%?}]}"

echo "::set-output name=matrix::{\"include\":[${VERSIONS%?}]}"
