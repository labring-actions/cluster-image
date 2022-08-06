#!/bin/bash
# Recursively finds all directories with a go.mod file and creates
# a GitHub Actions JSON output option. This is used by the linter action.
echo "Resolving versions in $(pwd)"
mkdir -p .versions
rm -rf .versions/versions_schedule.txt
for file in $(pwd)/.github/schedule/*
do
  app=$(cat $file | cut -d ':' -f 1)
  version=$(cat $file | cut -d ':' -f 2)
  echo "{\"app\":\"$app\",\"version\":\"$version\"}," >> .versions/versions_schedule.txt
done
VERSIONS=$(cat .versions/versions_schedule.txt)
echo "versions is : {\"include\":[${VERSIONS%?}]}"
echo "::set-output name=matrix::{\"include\":[${VERSIONS%?}]}"
