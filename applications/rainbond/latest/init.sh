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
    CHARTS_DIR="./chart"
    MANIFESTS_DIR="./manifests"

    OPT_DIR_ENABLED=false
    ETC_DIR_ENABLED=false
    IMAGES_DIR_ENABLED=true
    CHARTS_DIR_ENABLED=true
    MANIFESTS_DIR_ENABLED=false
    rm -rf "${OPT_DIR}" "${IMAGES_DIR}" "${CHARTS_DIR}" "${MANIFESTS_DIR}" "${ETC_DIR}"

    if [[ "$OPT_DIR_ENABLED" == "true" ]]; then mkdir -p "${OPT_DIR}"; fi
    if [[ "$ETC_DIR_ENABLED" == "true" ]]; then mkdir -p "$ETC_DIR}"; fi
    if [[ "$IMAGES_DIR_ENABLED" == "true" ]]; then mkdir -p "${IMAGES_DIR}"; fi
    if [[ "$CHARTS_DIR_ENABLED" == "true" ]]; then mkdir -p "${CHARTS_DIR}"; fi
    if [[ "$MANIFESTS_DIR_ENABLED" == "true" ]]; then mkdir -p "${MANIFESTS_DIR}"; fi
}

download_chart() {
    local HELM_REPO_URL="https://openchart.goodrain.com/goodrain/rainbond"
    local HELM_REPO_NAME="rainbond"
    local HELM_CHART_NAME="rainbond-cluster"
    local APP_VERSION=${VERSION#v}

    helm repo add "${HELM_REPO_NAME}" "${HELM_REPO_URL}" --force-update 1>/dev/null

    ALL_VERSIONS=$(helm search repo --versions --regexp "\v"${HELM_REPO_NAME}/${HELM_CHART_NAME}"\v" | awk '{print $2}' | grep -v VERSION)
    if ! echo "${ALL_VERSIONS}" | grep -qw "${APP_VERSION}"; then
        echo "Error: Exit, the provided version ${VERSION} does not exist in helm repo"
        exit 1
    fi

    helm pull "${HELM_REPO_NAME}"/"${HELM_CHART_NAME}" --version="${APP_VERSION}" -d "${CHARTS_DIR}" --untar
}

download_images() {
    # https://www.rainbond.com/en/docs/installation/offline/
    RELEASE_VERSION=${VERSION}-release
    IMAGE_DOMAIN=${IMAGE_DOMAIN:-registry.cn-hangzhou.aliyuncs.com}
    IMAGE_NAMESPACE=${IMAGE_NAMESPACE:-goodrain}
    IMAGE_LIST="${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/kubernetes-dashboard:v2.6.1
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/registry:2.6.2
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/metrics-server:v0.4.1
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/etcd:v3.3.18
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/metrics-scraper:v1.0.4
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rainbond:${RELEASE_VERSION}-allinone
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-mesh-data-panel:${RELEASE_VERSION}
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-webcli:${RELEASE_VERSION}
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-eventlog:${RELEASE_VERSION}
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-init-probe:${RELEASE_VERSION}
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-chaos:${RELEASE_VERSION}
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-mq:${RELEASE_VERSION}
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/resource-proxy:v5.10.0-release
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rainbond-operator:${RELEASE_VERSION}
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-worker:${RELEASE_VERSION}
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-node:${RELEASE_VERSION}
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-monitor:${RELEASE_VERSION}
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-gateway:${RELEASE_VERSION}
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-api:${RELEASE_VERSION}
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-db:8.0.19
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/builder:${RELEASE_VERSION}
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/runner:${RELEASE_VERSION}
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/mysqld-exporter:latest
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/nfs-provisioner:latest
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/helm-env-checker:latest
    ${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/kaniko-executor:latest"

    echo -e $IMAGE_LIST | tr ' ' '\n' > images/shim/rainbond-images.txt
    sed -i "s#runner:${RELEASE_VERSION}#runner:latest#g" images/shim/rainbond-images.txt
    sed -i "s#builder:${RELEASE_VERSION}#builder:latest#g" images/shim/rainbond-images.txt
}

main() {
    if [ $# -ne 3 ]; then
        echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
        exit 1
    else
        init_dir
        download_chart
        download_images
    fi
}

main "$@"
