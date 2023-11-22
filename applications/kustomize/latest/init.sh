#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

init_dir() {
    OPT_DIR="./opt"
    IMAGES_DIR="./images"
    CHARTS_DIR="./charts"
    MANIFESTS_DIR="./manifests"

    rm -rf "${OPT_DIR}" "${IMAGES_DIR}" "${CHARTS_DIR}" "${MANIFESTS_DIR}"
    mkdir -p "${OPT_DIR}"
}

download_file() {
    local GITHUB_USER="kubernetes-sigs"
    local GITHUB_REPO="kustomize"
    local GITHUB_FILE="kustomize_${VERSION}_linux_${ARCH}.tar.gz"
    local DOWNLOAD_URL="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/releases/download/kustomize%2F${VERSION}/${GITHUB_FILE}"

    wget -qO- "${DOWNLOAD_URL}" | tar -zx -C ./opt
    chmod +x opt/kustomize
}

main() {
    if [ $# -ne 3 ]; then
        echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
        exit 1
    else
        init_dir
        download_file
    fi
}

main $@
