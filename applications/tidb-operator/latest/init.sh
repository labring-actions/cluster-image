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
    mkdir -p "${IMAGES_DIR}" "${CHARTS_DIR}" "${MANIFESTS_DIR}"
}

ensure_helm() {
  {
    helm -h >/dev/null 2>&1
  } || {
    return 1
  }
}

download_chart() {
    local HELM_REPO_URL="https://charts.pingcap.org/"
    local HELM_REPO_NAME="pingcap"
    local HELM_CHART_NAME="tidb-operator"
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
}

download_manifests() {
    wget -qO- https://github.com/pingcap/tidb-operator/archive/refs/tags/${VERSION}.tar.gz | tar -zx
    mv tidb-operator-${VERSION#v}/manifests/crd.yaml $MANIFESTS_DIR
    mv tidb-operator-${VERSION#v}/examples $MANIFESTS_DIR
    rm -rf tidb-operator-${VERSION#v}

    #wget -qP manifests/ https://raw.githubusercontent.com/pingcap/tidb-operator/${VERSION#v}/manifests/crd.yaml
    #wget -qP manifests/ https://raw.githubusercontent.com/pingcap/tidb-operator/${VERSION#v}/examples/basic/tidb-cluster.yaml
    #wget -qP manifests/ https://raw.githubusercontent.com/pingcap/tidb-operator/${VERSION#v}/examples/basic/tidb-dashboard.yaml
    #wget -qP manifests/ https://raw.githubusercontent.com/pingcap/tidb-operator/${VERSION#v}/examples/basic/tidb-monitor.yaml

    tidb_cluster_file="$MANIFESTS_DIR/examples/basic/tidb-cluster.yaml"
    tidb_dashboard_file="$MANIFESTS_DIR/examples/basic/tidb-dashboard.yaml"
    tidb_monitor_file="$MANIFESTS_DIR/examples/basic/tidb-monitor.yaml"

    # Change tidb-dashboard service type to nodeport
    yq -i '.spec.service.type="NodePort"' --inplace $tidb_dashboard_file
    sed -i '/^$/d' $tidb_dashboard_file

    export prometheus_version=$(yq .spec.prometheus.version $tidb_monitor_file)
    export grafana_version=$(yq .spec.grafana.version $tidb_monitor_file)
    export initializer_version=$(yq .spec.initializer.version $tidb_monitor_file)
    export reloader_version=$(yq .spec.reloader.version $tidb_monitor_file)
    export prometheusReloader_version=$(yq .spec.prometheusReloader.version $tidb_monitor_file)
    export tidb_version=$(yq .spec.version $tidb_cluster_file)
    export helper_version=$(yq .spec.helper.image $tidb_cluster_file)

    cat >images/shim/tidb-images.txt<<EOF
docker.io/prom/prometheus:${prometheus_version}
docker.io/grafana/grafana:${grafana_version}
docker.io/pingcap/tidb-monitor-initializer:${initializer_version}
docker.io/pingcap/tidb-monitor-reloader:${reloader_version}
quay.io/prometheus-operator/prometheus-config-reloader:${prometheusReloader_version}
docker.io/pingcap/pd:${tidb_version}
docker.io/pingcap/tidb-dashboard:latest
docker.io/pingcap/tidb:${tidb_version}
docker.io/pingcap/tikv:${tidb_version}
docker.io/library/${helper_version}
docker.io/pingcap/tidb-operator:${VERSION}
EOF
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
