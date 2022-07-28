#!/bin/bash
# Recursively finds all directories with a go.mod file and creates
# a GitHub Actions JSON output option. This is used by the linter action.
echo "Resolving big versions in $(pwd)"


VERSIONS={\"version\":\"1.24\"},{\"version\":\"1.23\"},{\"version\":\"1.22\"},{\"version\":\"1.21\"},{\"version\":\"1.20\"},{\"version\":\"1.19\"},{\"version\":\"1.18\"},{\"version\":\"1.17\"},{\"version\":\"1.16\"},{\"version\":\"1.15\"},

echo "versions is : {\"include\":[${VERSIONS%?}]}"


echo "::set-output name=matrix::{\"include\":[${VERSIONS%?}]}"
