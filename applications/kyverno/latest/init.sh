#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

init_dir() {
    local OPT_DIR="./opt"
    local IMAGES_DIR="./images"
    local CHARTS_DIR="./charts"
    local MANIFESTS_DIR="./manifests"

    rm -rf "${OPT_DIR}" "${IMAGES_DIR}" "${CHARTS_DIR}" "${MANIFESTS_DIR}"
    mkdir -p "${CHARTS_DIR}" "${OPT_DIR}"
}

download_chart() {
    local HELM_REPO_URL="https://kyverno.github.io/kyverno/"
    local HELM_REPO_NAME="kyverno"
    local HELM_CHART_NAME="kyverno"

    helm repo add "${HELM_REPO_NAME}" "${HELM_REPO_URL}"
    # Find CHART VERSION through APP VERSION
    HELM_CHART_VERSION=$(helm search repo --versions --regexp "\v"${HELM_REPO_NAME}/${HELM_CHART_NAME}"\v" | grep "${VERSION}" | awk '{print $2}' | sort -rn | head -n1)
    helm pull "${HELM_REPO_NAME}"/"${HELM_CHART_NAME}" --version="${HELM_CHART_VERSION}" -d charts --untar
}

download_file() {
    local GITHUB_USER="kyverno"
    local GITHUB_REPO="kyverno"
    local GITHUB_FILE="kyverno-cli_${VERSION}_linux_x86_64.tar.gz"
    local DOWNLOAD_URL="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/releases/download/${VERSION}/${GITHUB_FILE}"

    wget -qO- "${DOWNLOAD_URL}" | tar -zx -C ./opt kyverno
    chmod +x opt/kyverno
}

init_dir
download_chart
download_file
