#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

init_dir() {
    OPT_DIR="./opt"
    ETC_DIR="./etc"
    IMAGES_DIR="./images/shim"
    CHARTS_DIR="./charts"
    MANIFESTS_DIR="./manifests"

    OPT_DIR_ENABLED=false
    ETC_DIR_ENABLED=false
    IMAGES_DIR_ENABLED=false
    CHARTS_DIR_ENABLED=false
    MANIFESTS_DIR_ENABLED=true
    rm -rf "${OPT_DIR}" "${IMAGES_DIR}" "${CHARTS_DIR}" "${MANIFESTS_DIR}" "${ETC_DIR}"

    if [[ "$OPT_DIR_ENABLED" == "true" ]]; then mkdir -p "${OPT_DIR}"; fi
    if [[ "$ETC_DIR_ENABLED" == "true" ]]; then mkdir -p "$ETC_DIR}"; fi
    if [[ "$IMAGES_DIR_ENABLED" == "true" ]]; then mkdir -p "${IMAGES_DIR}"; fi
    if [[ "$CHARTS_DIR_ENABLED" == "true" ]]; then mkdir -p "${CHARTS_DIR}"; fi
    if [[ "$MANIFESTS_DIR_ENABLED" == "true" ]]; then mkdir -p "${MANIFESTS_DIR}"; fi
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
    local GITHUB_USER="prometheus-operator"
    local GITHUB_REPO="prometheus-operator"
    local GITHUB_FILE="bundle.yaml"
    local DOWNLOAD_URL="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/releases/download/${VERSION}/${GITHUB_FILE}"

    wget -qP ${MANIFESTS_DIR} "${DOWNLOAD_URL}"
}

main() {
    if [ $# -ne 3 ]; then
        echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
        exit 1
    else
        init_dir
        command_check "wget -h"
        download_file
    fi
}

main $@
