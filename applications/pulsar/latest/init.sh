#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

init_dir() {
    OPT_DIR="./opt"
    IMAGES_DIR="./images/shim"
    CHARTS_DIR="./charts"
    MANIFESTS_DIR="./manifest"

    rm -rf "${OPT_DIR}" "${IMAGES_DIR}" "${CHARTS_DIR}" "${MANIFESTS_DIR}"
    mkdir -p "${CHARTS_DIR}" "${MANIFESTS_DIR}" "${IMAGES_DIR}"
}

ensure_helm() {
  {
    helm -h >/dev/null 2>&1
  } || {
    return 1
  }
}

download_chart() {
    local HELM_REPO_URL="https://pulsar.apache.org/charts"
    local HELM_REPO_NAME="apache"
    local HELM_CHART_NAME="pulsar"
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


    # Generate image list
    helm template charts/pulsar/ --set components.pulsar_manager=true | grep image: | awk '{print $2}' | cut -d '"' -f2 | sort -u > ${IMAGES_DIR}/images.txt

    kube_prometheus_stack_values_file="charts/pulsar/charts/kube-prometheus-stack/values.yaml"
    prometheusConfigReloader_image_repository=$(yq .prometheusOperator.prometheusConfigReloader.image.repository ${kube_prometheus_stack_values_file})
    prometheusConfigReloader_image_tag=$(yq .prometheusOperator.prometheusConfigReloader.image.tag ${kube_prometheus_stack_values_file})
    prometheusConfigReloader_image="${prometheusConfigReloader_image_repository}:${prometheusConfigReloader_image_tag}"
    echo "${prometheusConfigReloader_image}" >> ${IMAGES_DIR}/images.txt
}

download_manifests (){
    git clone https://github.com/apache/pulsar-helm-chart.git --depth=1
    mv pulsar-helm-chart manifest
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
        download_manifests
    fi
}

main $@
