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

    [ "$OPT_DIR_ENABLED" = true ] && mkdir -p $OPT_DIR
    [ "$ETC_DIR_ENABLED" = true ] && mkdir -p $ETC_DIR
    [ "$IMAGES_DIR_ENABLED" = true ] && mkdir -p $IMAGES_DIR
    [ "$CHARTS_DIR_ENABLED" = true ] && mkdir -p $CHARTS_DIR
    [ "$MANIFESTS_DIR_ENABLED" = true ] && mkdir -p $MANIFESTS_DIR
}

download_manifests() {
    local GITHUB_USER="zilliztech"
    local GITHUB_REPO="attu"
    local GITHUB_FILE="attu-k8s-deploy.yaml"
    local DOWNLOAD_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${VERSION}/${GITHUB_FILE}"
    wget -qP "${MANIFESTS_DIR}" "${DOWNLOAD_URL}"
    sed -i "s#type: ClusterIP#type: NodePort#g" "${MANIFESTS_DIR}"/"$GITHUB_FILE"
}

main() {
    if [ $# -ne 3 ]; then
        echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
        exit 1
    else
        init_dir
        download_manifests
    fi
}

main $@
