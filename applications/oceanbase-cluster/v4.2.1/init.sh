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
    mkdir -p "${CHARTS_DIR}"
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

download_charts() {
    local GITHUB_REPO="oceanbase/ob-operator"
    local APP_VERSION="4.2.1-sp.6-106000012024042515"
    local DOWNLOAD_URL="https://github.com/${GITHUB_REPO}/releases/download/oceanbase-cluster-${APP_VERSION}/oceanbase-cluster-${APP_VERSION}.tgz"

    wget -q "${DOWNLOAD_URL}"
    tar -zxf oceanbase-cluster-${APP_VERSION}.tgz -C ./charts
    rm -rf ./oceanbase-cluster-${APP_VERSION}.tgz
}

main() {
    if [ $# -ne 3 ]; then
        echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
        exit 1
    else
        init_dir
        command_check "helm --help"
        download_charts
    fi
}

main $@
