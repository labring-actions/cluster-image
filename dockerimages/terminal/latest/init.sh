#!/bin/bash

set -e

readonly ARCH=${1:-amd64}


if [ "$ARCH" = "amd64" ]; then
sed -i "s#shaImageId#sha256:d9946ebbeb3ca08ccaa24a8220d7da1f9e9fd749d489913faeed89e02f70a202#g" Dockerfile
fi

if [ "$ARCH" = "arm64" ]; then
sed -i "s#shaImageId#sha256:4672913f7ad129a34409e7d040621df203218b1cfa91fa0fee3377b065fa0feb#g" Dockerfile
fi


