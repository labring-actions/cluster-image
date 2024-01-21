#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

init_dir() {
    local IMAGES_DIR="./images/shim"
    local CHARTS_DIR="./charts"

    rm -rf   "${IMAGES_DIR}" "${CHARTS_DIR}"
    mkdir -p "${CHARTS_DIR}" "${IMAGES_DIR}"
}

download_chart() {
    local HELM_REPO_URL="https://ray-project.github.io/kuberay-helm/"
    local HELM_REPO_NAME="kuberay"
    local HELM_CHART_NAME="kuberay-operator"

    helm repo add "${HELM_REPO_NAME}" "${HELM_REPO_URL}"
    # Find CHART VERSION through APP VERSION
    HELM_CHART_VERSION=$(helm search repo --versions --regexp "\v"${HELM_REPO_NAME}/${HELM_CHART_NAME}"\v" | grep "${VERSION}" | awk '{print $2}' | sort -rn | head -n1)
    helm pull "${HELM_REPO_NAME}"/"${HELM_CHART_NAME}" --version="${HELM_CHART_VERSION}" -d charts --untar
}

init_dir
download_chart

cat <<'EOF' >"images/shim/kuberayImages"
rayproject/ray:2.9.0
EOF


cat <<'EOF' >"Kubefile"
FROM scratch
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i kuberay charts/reflector -n kuberay-operator --create-namespace $(HELM_OPTS)"]
EOF
