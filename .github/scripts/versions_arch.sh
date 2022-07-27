#!/bin/bash
# Recursively finds all directories with a go.mod file and creates
# a GitHub Actions JSON output option. This is used by the linter action.
echo "Resolving versions in $(pwd)"

filePath=$(pwd)/.github/versions/CHANGELOG-${versionGroup}.md

VERSIONS_ARCH=$(cat $filePath| grep "\[v${versionGroup}" | grep -v "alpha" | grep -v "beta"| grep -v "rc" | awk '{print $2}' | cut -d '[' -f  2 | cut -d ']' -f 1 | cut -d 'v' -f 2  | awk '{printf "{\"'version'\":\"%s\",\"'arch'\":\"amd64\"},{\"'version'\":\"%s\",\"'arch'\":\"arm64\"},",$1,$1}')

echo "versions arch is : {\"include\":[${VERSIONS_ARCH%?}]}"


echo "::set-output name=matrix::{\"include\":[${VERSIONS_ARCH%?}]}"
