#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}
export readonly APP_VERSION=${VERSION#v}

init_dir() {
    OPT_DIR="./opt"
    ETC_DIR="./etc"
    IMAGES_DIR="./images/shim"
    CHARTS_DIR="./charts"
    MANIFESTS_DIR="./manifests"

    OPT_DIR_ENABLED=false
    ETC_DIR_ENABLED=false
    IMAGES_DIR_ENABLED=true
    CHARTS_DIR_ENABLED=true
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

download_chart() {
    local HELM_REPO_URL="https://victoriametrics.github.io/helm-charts/"
    local HELM_REPO_NAME="vm"
    local HELM_CHART_NAME="victoria-metrics-operator"

    helm repo add "${HELM_REPO_NAME}" "${HELM_REPO_URL}" --force-update 1>/dev/null

    ALL_VERSIONS=$(helm search repo --versions --regexp "\v"${HELM_REPO_NAME}/${HELM_CHART_NAME}"\v" | awk '{print $3}' | grep -v VERSION)
    if ! echo "${ALL_VERSIONS}" | grep -qw "${APP_VERSION}"; then
        echo "Error: Exit, the provided version ${VERSION} does not exist in helm repo"
        exit 1
    fi

    # Find CHART VERSION through APP VERSION
    HELM_CHART_VERSION=$(helm search repo --versions --regexp "\v"${HELM_REPO_NAME}/${HELM_CHART_NAME}"\v" | grep "${APP_VERSION}" | awk '{print $2}' | sort -rn | head -n1)
    helm pull "${HELM_REPO_NAME}/${HELM_CHART_NAME}" --version="${HELM_CHART_VERSION}" -d "${CHARTS_DIR}" --untar
}

download_examples() {
    local GITHUB_REPO="VictoriaMetrics/operator"
    local GITHUB_FILE="${VERSION}.tar.gz"
    local DOWNLOAD_URL="https://github.com/${GITHUB_REPO}/archive/refs/tags/${VERSION}/${GITHUB_FILE}"

    wget -qO- "${DOWNLOAD_URL}" | tar -zx
    cp -r operator-${APP_VERSION}/config/examples/ ${MANIFESTS_DIR}
}

generate_images() {
    local operator_image="docker.io/victoriametrics/operator:${VERSION}"
    victoriametrics_version=$(docker run --rm --entrypoint="" ${operator_image} /usr/local/bin/manager --printDefaults | grep VM_VMSINGLEDEFAULT_VERSION | awk '{print $3}')

    config_file="operator-${APP_VERSION}/internal/config/config.go"
    jimmidyson_configmap_reload_version=$(cat ${config_file} | grep jimmidyson/configmap-reload | cut -d '"' -f 2 | sort -u | awk -F: '{print $2}')
    alertmanager_version=$(cat ${config_file} | grep AlertManagerVersion | cut -d '"' -f 2)
    prometheus_config_reloader_verson=$(cat ${config_file} | grep quay.io/prometheus-operator/prometheus-config-reloader | cut -d '"' -f 2  | sort -u | awk -F: '{print $2}')

    cat >${IMAGES_DIR}/images.txt<<EOF
docker.io/victoriametrics/vminsert:${victoriametrics_version}-cluster
docker.io/victoriametrics/vmselect:${victoriametrics_version}-cluster
docker.io/victoriametrics/vmstorage:${victoriametrics_version}-cluster
docker.io/victoriametrics/vmagent:${victoriametrics_version}
docker.io/victoriametrics/vmalert:${victoriametrics_version}
docker.io/victoriametrics/vmauth:${victoriametrics_version}
docker.io/jimmidyson/configmap-reload:${jimmidyson_configmap_reload_version}
docker.io/prom/alertmanager:${alertmanager_version}
quay.io/prometheus-operator/prometheus-config-reloader:${prometheus_config_reloader_verson}
EOF
    rm -rf operator-${APP_VERSION}
}

main() {
    if [ $# -ne 3 ]; then
        echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
        exit 1
    else
        init_dir
        command_check "helm --help"
        download_chart
        download_examples
        generate_images
    fi
}

main "$@"
