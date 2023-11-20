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
    mkdir -p "${MANIFESTS_DIR}"
}

download_file() {
    local GITHUB_USER="operator-framework"
    local GITHUB_REPO="operator-lifecycle-manager"
    local GITHUB_FILE="cmctl-linux-${ARCH}.tar.gz"

    wget -qP manifests https://github.com/${GITHUB_USER}/${GITHUB_REPO}/releases/download/${VERSION}/crds.yaml
    wget -qP manifests https://github.com/${GITHUB_USER}/${GITHUB_REPO}/releases/download/${VERSION}/olm.yaml
    sed -i "s|quay.io/operator-framework/olm.*|quay.io/operator-framework/olm:$VERSION|g" ${MANIFESTS_DIR}/olm.yaml
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
