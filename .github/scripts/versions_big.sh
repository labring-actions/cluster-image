#!/bin/bash
# Recursively finds all directories with a go.mod file and creates
# a GitHub Actions JSON output option. This is used by the linter action.
echo "Resolving big versions in $(pwd)"


VERSIONS={\"version\":\"1.24\"}

echo "versions is : {\"include\":[${VERSIONS%?}]}"


echo "::set-output name=matrix::{\"include\":[${VERSIONS%?}]}"
