#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

function check_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "$1 is required, exiting the script"
    exit 1
  fi
}

function prepare(){
  rm -rf charts plugins && mkdir -p charts plugins
}

function init_gateway(){
  local gateway_api_version="v1.0.0"
  wget -q -P plugins/ https://github.com/kubernetes-sigs/gateway-api/releases/download/${gateway_api_version}/standard-install.yaml
}

function init_istio(){
  local repo_url="https://istio-release.storage.googleapis.com/charts"
  local chart_name="istio"
  local repo_name="istio/base" # just add istio crd

  helm repo add ${chart_name} ${repo_url} --force-update 1>/dev/null

  # Get latest version, as just for crd usage
  local chart_latest_version=$(helm search repo --versions --regexp "\v"${repo_name}"\v" | awk '{print $2}' | grep -v VERSION | sort -rn | head -n1)

  helm pull ${repo_name} --version=${chart_latest_version} -d charts/ --untar
}

function init_higress(){
  local repo_url="https://higress.io/helm-charts"
  local chart_name="higress.io"
  local repo_name="higress.io/higress"

  helm repo add ${chart_name} ${repo_url} --force-update 1>/dev/null

  # Check version number exists
  all_versions=$(helm search repo --versions --regexp "\v"${repo_name}"\v" | awk '{print $3}' | grep -v VERSION)
  if ! echo "$all_versions" | grep -qw "${VERSION}"; then
    echo "Error: Exit, the provided version "${VERSION}" does not exist in helm repo, get available version with: helm search repo "${repo_name}" --versions"
    exit 1
  fi

  # Find the chart version through the app version
  local chart_version=$(helm search repo --versions --regexp "\v"${repo_name}"\v" | grep ${VERSION} | awk '{print $2}' | sort -rn | head -n1)

  helm pull ${repo_name} --version=${chart_version} -d charts/ --untar
}

function init_crd(){
  cat <<'EOF' >"plugins/crd.yaml"
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name:  hcm-options
  namespace: higress-system
spec:
  configPatches:
  - applyTo: NETWORK_FILTER
    match:
      context: GATEWAY
      listener:
        filterChain:
          filter:
            name: envoy.filters.network.http_connection_manager
    patch:
      operation: MERGE
      value:
        name: envoy.filters.network.http_connection_manager
        typed_config:
          '@type': type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
          max_request_headers_kb: 8192
---

apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: global-route-config
  namespace: higress-system
spec:
  configPatches:
  - applyTo: ROUTE_CONFIGURATION
    match:
      context: GATEWAY
    patch:
      operation: MERGE
      value:
        request_headers_to_add:
        - append: false
          header:
            key: x-real-ip
            value: '%REQ(X-ENVOY-EXTERNAL-ADDRESS)%'
EOF
}

function init(){
  cat <<'EOF' >"Kubefile"
FROM scratch
COPY charts charts
COPY plugins plugins
COPY registry registry
COPY install.sh install.sh
CMD ["bash install.sh"]
EOF
}

function main() {
  if [ $# -ne 3 ]; then
    echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
    exit 1
  else
    check_command helm
    prepare
    init_gateway
    init_istio
    init_higress
    init_crd
    init
  fi
}

main $@