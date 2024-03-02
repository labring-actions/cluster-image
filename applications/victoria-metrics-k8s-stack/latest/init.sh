#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}
export readonly APP_VERSION=${VERSION}

init_dir() {
    OPT_DIR="./opt"
    IMAGES_DIR="./images/shim"
    CHARTS_DIR="./charts"
    MANIFESTS_DIR="./manifests"

    rm -rf "${OPT_DIR}" "${IMAGES_DIR}" "${CHARTS_DIR}" "${MANIFESTS_DIR}"
    mkdir -p "${CHARTS_DIR}" "${IMAGES_DIR}"
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
    local HELM_CHART_NAME="victoria-metrics-k8s-stack"

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

generate_image() {
    values_file="charts/victoria-metrics-k8s-stack/values.yaml"
    alertmanager_version=$(yq .alertmanager.spec.image.tag $values_file)
    vmagent_version=$(yq .vmagent.spec.image.tag $values_file)
    vmalert_version=$(yq .vmalert.spec.image.tag $values_file)
    victoria_metrics_version=$vmalert_version
    operator_version=$(yq .image.tag charts/victoria-metrics-k8s-stack/charts/victoria-metrics-operator/values.yaml)

    wget -qO- https://github.com/VictoriaMetrics/operator/archive/refs/tags/${operator_version}.tar.gz | tar -zx
    config_file="operator-${operator_version#v}/internal/config/config.go"
    configmap_reload_version=$(cat $config_file | grep jimmidyson/configmap-reload | head -n1 | cut -d'"' -f2  | awk -F: '{print $2}')
    prometheus_config_reloader_version=$(cat $config_file |grep quay.io/prometheus-operator/prometheus-config-reloader | head -n1 | cut -d'"' -f2  | awk -F: '{print $2}')
    rm -rf operator-${operator_version#v}

    echo "docker.io/prom/alertmanager:${alertmanager_version}" > images/shim/images.txt
    echo "docker.io/victoriametrics/vmagent:${vmagent_version}" >> images/shim/images.txt
    echo "docker.io/victoriametrics/vmalert:${vmalert_version}" >> images/shim/images.txt
    echo "docker.io/victoriametrics/victoria-metrics:${victoria_metrics_version}" >> images/shim/images.txt
    echo "docker.io/jimmidyson/configmap-reload:${configmap_reload_version}" >> images/shim/images.txt
    echo "quay.io/prometheus-operator/prometheus-config-reloader:${prometheus_config_reloader_version}" >> images/shim/images.txt
}

main() {
    if [ $# -ne 3 ]; then
        echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
        exit 1
    else
        init_dir
#        command_check "helm --help"
#        command_check "yq --help"
        download_chart
        generate_image
    fi
}

main $@
