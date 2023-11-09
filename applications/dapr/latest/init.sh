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
    mkdir -p "${CHARTS_DIR}"
}


ensure_helm() {
  {
    helm -h >/dev/null 2>&1
  } || {
    return 1
  }
}

download_chart() {
    local HELM_REPO_URL="https://dapr.github.io/helm-charts/"
    local HELM_REPO_NAME="dapr"
    local HELM_CHART_NAME="dapr"
    local APP_VERSION=${VERSION#v}

    helm repo add "${HELM_REPO_NAME}" "${HELM_REPO_URL}" --force-update 1>/dev/null

    ALL_VERSIONS=$(helm search repo --versions --regexp "\v"${HELM_REPO_NAME}/${HELM_CHART_NAME}"\v" | awk '{print $3}' | grep -v VERSION)
    if ! echo "${ALL_VERSIONS}" | grep -qw "${APP_VERSION}"; then
        echo "Error: Exit, the provided version ${VERSION} does not exist in helm repo"
        exit 1
    fi

    # Find CHART VERSION through APP VERSION
    HELM_CHART_VERSION=$(helm search repo --versions --regexp "\v"${HELM_REPO_NAME}/${HELM_CHART_NAME}"\v" | grep "${APP_VERSION}" | awk '{print $2}' | sort -rn | head -n1)
    helm pull "${HELM_REPO_NAME}"/"${HELM_CHART_NAME}" --version="${HELM_CHART_VERSION}" -d charts --untar
}

main() {
    if [ $# -ne 3 ]; then
        echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
        exit 1
    else
        init_dir
        ensure_helm || {
          echo_fail "Helm is not available, please install it first"
          exit 1
        }
        download_chart
    fi
}

main $@
