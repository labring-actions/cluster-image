#!/bin/bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

BINARY_FILE="./opt"

rm -rf "${BINARY_FILE}" && mkdir "${BINARY_FILE}"
wget -qO ${BINARY_FILE}/skopeo https://github.com/lework/skopeo-binary/releases/download/"${VERSION}"/skopeo-linux-"${ARCH}"



