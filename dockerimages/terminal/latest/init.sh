#!/bin/bash

set -e

readonly ARCH=${1:-amd64}

sed -i "s#defaultArch#$ARCH#g" Dockerfile
