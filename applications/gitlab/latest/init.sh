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

download_chart() {
    local HELM_REPO_URL="https://charts.gitlab.io/"
    local HELM_REPO_NAME="gitlab"
    local HELM_CHART_NAME="gitlab"
    local APP_VERSION=${VERSION}

    helm repo add "${HELM_REPO_NAME}" "${HELM_REPO_URL}" --force-update 1>/dev/null

    ALL_VERSIONS=$(helm search repo --versions --regexp "\v"${HELM_REPO_NAME}/${HELM_CHART_NAME}"\v" | awk '{print $3}' | grep -v VERSION)
    if ! echo "${ALL_VERSIONS}" | grep -qw "${APP_VERSION}"; then
        echo "Error: Exit, the provided version ${VERSION} does not exist in helm repo"
        exit 1
    fi

    # Find CHART VERSION through APP VERSION
    HELM_CHART_VERSION=$(helm search repo --versions --regexp "\v"${HELM_REPO_NAME}/${HELM_CHART_NAME}"\v" | grep "${APP_VERSION}" | awk '{print $2}' | sort -rn | head -n1)
    helm pull "${HELM_REPO_NAME}"/"${HELM_CHART_NAME}" --version="${HELM_CHART_VERSION}" -d charts --untar

    values_file_path="charts/gitlab/values.yaml"
    yq e -i '.global.edition="ce"' ${values_file_path}
    yq e -i '.gitlab-runner.install=false' ${values_file_path}
    yq eval '. += {"certmanager-issuer": {"email": "email@example.com"}}' -i ${values_file_path}

    match_line="\[runners.kubernetes\]"
    insert_line="helper_image = \"registry.gitlab.com/gitlab-org/gitlab-runner/gitlab-runner-helper:x86_64-latest\""
    sed -i "/$match_line/a \\
            $insert_line" "${values_file_path}"

    mkdir -p images/shim
    echo "registry.gitlab.com/gitlab-org/gitlab-runner/gitlab-runner-helper:x86_64-latest" > images/shim/gitlab-images.txt

    ubuntu_image=$(cat ${values_file_path} | grep "image = .*ubuntu:" | cut -d'"' -f2)
    echo "docker.io/library/$ubuntu_image" >> images/shim/gitlab-images.txt
}

main() {
    if [ $# -ne 3 ]; then
        echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
        exit 1
    else
        init_dir
        command_check "helm -h"
        download_chart
    fi
}

main $@
