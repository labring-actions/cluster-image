#!/bin/bash
# Recursively finds all directories with a go.mod file and creates
# a GitHub Actions JSON output option. This is used by the linter action.
echo "Resolving versions in $(pwd)"
mkdir -p .versions
rm -rf .versions/versions_arch.txt
for file in $(pwd)/.github/versions/${part}/CHANGELOG*; do
  if [[ -n $tagsuffix ]]; then
    wget -qO- "https://github.com/kubernetes/kubernetes/raw/master/CHANGELOG/${file##*/}" |
      grep -E '^- \[v[0-9\.]+\]' | awk '{print $2}' | awk -F\[ '{print $2}' | awk -F\] '{print $1}' |
      cut -dv -f 2 | head -n 1 |
      awk '{printf "{\"'version'\":\"%s\",\"'arch'\":\"amd64\"},{\"'version'\":\"%s\",\"'arch'\":\"arm64\"},",$1,$1}' >>.versions/versions_arch.txt
  else
    wget -qO- "https://github.com/kubernetes/kubernetes/raw/master/CHANGELOG/${file##*/}" |
      grep -E '^- \[v[0-9\.]+\]' | awk '{print $2}' | awk -F\[ '{print $2}' | awk -F\] '{print $1}' |
      cut -dv -f 2 |
      awk '{printf "{\"'version'\":\"%s\",\"'arch'\":\"amd64\"},{\"'version'\":\"%s\",\"'arch'\":\"arm64\"},",$1,$1}' >>.versions/versions_arch.txt
  fi
done
VERSIONS_ARCH=$(cat .versions/versions_arch.txt)
echo "versions arch is : {\"include\":[${VERSIONS_ARCH%?}]}"
echo "::set-output name=matrix::{\"include\":[${VERSIONS_ARCH%?}]}"
