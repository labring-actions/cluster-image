#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

CHARTS_DIR="./chart"

check_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "$1 is required, exiting the script"
    exit 1
  fi
}

download_chart() {
    local HELM_REPO_URL="https://charts.kubegems.io/kubegems"
    local HELM_REPO_NAME="kubegems"
    local HELM_CHART_NAME_KUBEGEMS_INSTALLER="kubegems-installer"
    local HELM_CHART_NAME_KUBEGEMS="kubegems"
    local APP_VERSION=${VERSION#v}

    helm repo add "${HELM_REPO_NAME}" "${HELM_REPO_URL}" --force-update 1>/dev/null

    ALL_VERSIONS=$(helm search repo --versions --regexp "\v"${HELM_REPO_NAME}/${HELM_CHART_NAME_KUBEGEMS}"\v" | awk '{print $3}' | grep -v VERSION)
    if ! echo "${ALL_VERSIONS}" | grep -qw "${APP_VERSION}"; then
        echo "Error: Exit, the provided version ${VERSION} does not exist in helm repo"
        exit 1
    fi

    # Find CHART VERSION through APP VERSION
    HELM_CHART_VERSION=$(helm search repo --versions --regexp "\v"${HELM_REPO_NAME}/${HELM_CHART_NAME_KUBEGEMS}"\v" | grep "${APP_VERSION}" | awk '{print $2}' | sort -rn | head -n1)
    helm pull "${HELM_REPO_NAME}"/"${HELM_CHART_NAME_KUBEGEMS_INSTALLER}" --version="${HELM_CHART_VERSION}" -d ${CHARTS_DIR} --untar
    helm pull "${HELM_REPO_NAME}"/"${HELM_CHART_NAME_KUBEGEMS}" --version="${HELM_CHART_VERSION}" -d ${CHARTS_DIR} --untar
}

main() {
    if [ $# -ne 3 ]; then
        echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
        exit 1
    else
        check_command helm
        download_chart
    fi
}

main $@
