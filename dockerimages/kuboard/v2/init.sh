#!/bin/bash

set -e

readonly ARCH=${1:-amd64}

if [ "$ARCH" = "amd64" ]; then
cat <<EOF > Dockerfile
FROM eipwork/kuboard:latest
EOF
fi

if [ "$ARCH" = "arm64" ]; then
cat <<EOF > Dockerfile
FROM eipwork/kuboard:arm
EOF
fi

