#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

init_dir() {
    ETC_DIR="./etc"
    OPT_DIR="./opt"
    IMAGES_DIR="./images/shim"
    CHARTS_DIR="./charts"
    MANIFESTS_DIR="./manifests"

    rm -rf "${OPT_DIR}" "${IMAGES_DIR}" "${CHARTS_DIR}" "${MANIFESTS_DIR}" "${ETC_DIR}"
    mkdir -p "${CHARTS_DIR}" "${OPT_DIR}"
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

download_chart() {
    local HELM_REPO_URL="ghcr.io/akuity/kargo-charts/kargo"
    local APP_VERSION=${VERSION#v}

    ALL_VERSIONS=$(docker run --rm quay.io/skopeo/stable:latest list-tags docker://${HELM_REPO_URL} | yq .Tags[])
    if ! echo "${ALL_VERSIONS}" | grep -qw "${APP_VERSION}"; then
        echo "Error: Exit, the provided version ${VERSION} does not exist in helm repo"
        exit 1
    fi

    helm pull "oci://${HELM_REPO_URL}" --version="${APP_VERSION}" -d charts --untar

    cat >charts/kargo.values.yaml<<EOF
api:
  adminAccount:
    password: admin
    tokenSigningKey: iwishtowashmyirishwristwatch
EOF
}

download_file() {
    local GITHUB_USER="akuity"
    local GITHUB_REPO="kargo"
    local GITHUB_FILE="kargo-linux-${ARCH}"
    local DOWNLOAD_URL="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/releases/download/${VERSION}/${GITHUB_FILE}"
    echo "${DOWNLOAD_URL}"
    wget -qO opt/kargo "${DOWNLOAD_URL}" && chmod +x opt/kargo
}


main() {
    if [ $# -ne 3 ]; then
        echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
        exit 1
    else
        init_dir
        command_check "helm -h"
        command_check "yq -h"
        command_check "docker info"
        download_chart
        download_file
    fi
}

main $@
