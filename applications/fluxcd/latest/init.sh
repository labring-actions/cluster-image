#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

init_dir() {
    OPT_DIR="./opt"
    IMAGES_DIR="./images/shim"
    CHARTS_DIR="./charts"
    MANIFESTS_DIR="./manifests"

    rm -rf "${OPT_DIR}" "${IMAGES_DIR}" "${CHARTS_DIR}" "${MANIFESTS_DIR}"
    mkdir -p "${OPT_DIR}" "${IMAGES_DIR}"
}

download_file() {
    local GITHUB_USER="fluxcd"
    local GITHUB_REPO="flux2"
    local GITHUB_FILE="flux_${VERSION#v}_linux_${ARCH}.tar.gz"
    local DOWNLOAD_URL="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/releases/download/${VERSION}/${GITHUB_FILE}"

    wget -qO- "${DOWNLOAD_URL}" | tar -zx -C ./opt flux
    chmod +x opt/flux
    local COMPONENETS_EXTRA="image-reflector-controller,image-automation-controller"
    ./opt/flux install --version ${VERSION} --export --components-extra=${COMPONENETS_EXTRA} | grep ghcr.io | awk '{print $2}' > ${IMAGES_DIR}/images.txt
    sed -i "s|VERSION=.*|VERSION=$VERSION|g" entrypoint.sh
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
