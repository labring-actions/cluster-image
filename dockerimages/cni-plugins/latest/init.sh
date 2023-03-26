#!/bin/bash

set -e

readonly ARCH=${1:-amd64}
readonly NAME=${2:-cni-plugins}
readonly VERSION=${3:-v1.1.1}

wget -qO cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/$VERSION/$NAME-linux-$ARCH-$VERSION.tgz"
