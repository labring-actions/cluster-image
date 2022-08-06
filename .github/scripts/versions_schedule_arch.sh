#!/bin/bash
# Recursively finds all directories with a go.mod file and creates
# a GitHub Actions JSON output option. This is used by the linter action.
echo "Resolving versions in $(pwd)"
mkdir -p .versions
rm -rf .versions/versions_schedule_arch.txt
for file in $(pwd)/.github/schedule/*
do
  versions=$(echo $file | cut -d '-' -f 3 | cut -d '.' -f 1,2)
  cat $file| grep "\[v"| grep -v "github"  | grep -v "alpha" | grep -v "stable"| grep -v "there" | grep -v "beta"| grep -v "rc" | awk '{print $2}' | cut -d '[' -f  2 | cut -d ']' -f 1 | cut -d 'v' -f 2  |  awk '{printf "{\"'version'\":\"%s\",\"'arch'\":\"amd64\"},{\"'version'\":\"%s\",\"'arch'\":\"arm64\"},",$1,$1}' >> .versions/versions_arch.txt
  app=$(cat $file | cut -d ':' -f 1)
  version=$(cat $file | cut -d ':' -f 2)
  echo "{\"app\":\"$app\",\"version\":\"$version\",\"arch\":\"amd64\"},{\"app\":\"$app\",\"version\":\"$version\",\"arch\":\"arm64\"}," >> .versions/versions_schedule_arch.txt
done
VERSIONS_ARCH=$(cat .versions/versions_schedule_arch.txt)
echo "versions arch is : {\"include\":[${VERSIONS_ARCH%?}]}"
echo "::set-output name=matrix::{\"include\":[${VERSIONS_ARCH%?}]}"
