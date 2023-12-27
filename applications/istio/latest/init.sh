#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}
export readonly APP_VERSION=${VERSION#v}

init_dir() {
    OPT_DIR="./opt"
    IMAGES_DIR="./images"
    CHARTS_DIR="./charts"
    MANIFESTS_DIR="./manifests"

    rm -rf "${OPT_DIR}" "${IMAGES_DIR}" "${CHARTS_DIR}" "${MANIFESTS_DIR}"
    mkdir -p "${OPT_DIR}" "${MANIFESTS_DIR}"
}

command_check() {
    local command="$1"
    {
      $command >/dev/null 2>&1
    } || {
      echo "$1 is failed or does not exist, exiting the script"
      exit 1
    }
}

download_file() {
    local GITHUB_USER="istio"
    local GITHUB_REPO="istio"
    local GITHUB_FILE="istioctl-${APP_VERSION}-linux-${ARCH}.tar.gz"
    local DOWNLOAD_URL="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/releases/download/${APP_VERSION}/${GITHUB_FILE}"

    wget -qO- "${DOWNLOAD_URL}" | tar -zx -C ./opt
    chmod +x opt/istioctl
}

generate_manifest() {
    docker run docker.io/istio/istioctl:${APP_VERSION} manifest generate --set profile=demo > manifests/generated-manifest.yaml
}

main() {
    if [ $# -ne 3 ]; then
        echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
        exit 1
    else
        command_check "docker info"
        init_dir
        download_file
        generate_manifest
    fi
}

main $@
