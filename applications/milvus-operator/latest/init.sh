#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}
export readonly APP_VERSION=${VERSION#v}

init_dir() {
    ETC_DIR="./etc"
    OPT_DIR="./opt"
    IMAGES_DIR="./images/shim"
    CHARTS_DIR="./charts"
    MANIFESTS_DIR="./manifest"

    rm -rf "${OPT_DIR}" "${IMAGES_DIR}" "${CHARTS_DIR}" "${MANIFESTS_DIR}" "${ETC_DIR}"
    mkdir -p "${CHARTS_DIR}" "${MANIFESTS_DIR}" "${IMAGES_DIR}"
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
    local HELM_REPO_URL="https://zilliztech.github.io/milvus-operator/"
    local HELM_REPO_NAME="milvus-operator"
    local HELM_CHART_NAME="milvus-operator"

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

download_manifests() {
    local GITHUB_USER="zilliztech"
    local GITHUB_REPO="milvus-operator"
    local GITHUB_FILE="${APP_VERSION}.tar.gz"
    local DOWNLOAD_URL="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/refs/tags/${VERSION}/${GITHUB_FILE}"
    wget -qO- "${DOWNLOAD_URL}" | tar -zx
    mv "milvus-operator-${APP_VERSION}"/config/samples/* manifest/
}


generate_images() {
    makefile="milvus-operator-${APP_VERSION}/Makefile"
    milvus_version=$(cat $makefile | grep "docker pull milvusdb/milvus:" | awk -F: '{print $2}')
    pulsar_version=$(cat $makefile | grep "docker pull -q apachepulsar/pulsar:" | awk -F: '{print $2}')
    kafka_version=$(cat $makefile | grep "docker pull -q bitnami/kafka:" | awk -F: '{print $2}')
    etcd_version=$(cat $makefile | grep "docker pull -q milvusdb/etcd:" | awk -F: '{print $2}')
    minio_version=$(cat $makefile | grep "docker pull -q minio/minio:" | awk -F: '{print $2}')
    pymilvus_version=$(cat $makefile | grep "docker pull -q haorenfsa/pymilvus:" | awk -F: '{print $2}')

    cat>images/shim/images.txt<<EOF
docker.io/milvusdb/milvus:${milvus_version}
docker.io/apachepulsar/pulsar:${pulsar_version}
docker.io/bitnami/kafka:${kafka_version}
docker.io/milvusdb/etcd:${etcd_version}
docker.io/minio/minio:${minio_version}
docker.io/haorenfsa/pymilvus:${pymilvus_version}
EOF
    rm -rf "milvus-operator-${APP_VERSION}"
}

main() {
    if [ $# -ne 3 ]; then
        echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
        exit 1
    else
        init_dir
        command_check "helm -h"
        download_chart
        download_manifests
        generate_images
    fi
}

main $@
