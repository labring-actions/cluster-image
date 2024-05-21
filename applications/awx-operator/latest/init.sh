#!/usr/bin/env bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

HELM_REPO_URL="https://ansible.github.io/awx-operator/"
HELM_REPO_NAME="awx-operator/awx-operator"

# When submitting a PR, make sure it is configured as false.
LOCAL_BUILD_ENABLED=${LOCAL_BUILD_ENABLED:-"false"}
REGISTRY_REPO=${REGISTRY_REPO:-"docker.io/labring"}

info_log() {
    local message=$1
    echo -e "\033[0;32m[INFO] ${message}\033[0m"
}

error_log() {
    local message=$1
    echo -e "\033[0;31m[ERROR] ${message}\033[0m" >&2
}


init_directory() {
    # Initialize directory structure
    info_log "Initializing directory structure"

    OPT_DIR="./opt"
    ETC_DIR="./etc"
    IMAGES_DIR="./images/shim"
    CHARTS_DIR="./charts"
    MANIFESTS_DIR="./manifests"

    CHARTS_DIR_ENABLED=true
    OPT_DIR_ENABLED=false
    ETC_DIR_ENABLED=false
    IMAGES_DIR_ENABLED=true
    MANIFESTS_DIR_ENABLED=false

    # Remove existing directories
    rm -rf "${OPT_DIR}" "${IMAGES_DIR}" "${CHARTS_DIR}" "${MANIFESTS_DIR}" "${ETC_DIR}"

    # Create necessary directories based on configuration
    if [[ "$OPT_DIR_ENABLED" == "true" ]]; then mkdir -p "${OPT_DIR}"; fi
    if [[ "$ETC_DIR_ENABLED" == "true" ]]; then mkdir -p "$ETC_DIR}"; fi
    if [[ "$IMAGES_DIR_ENABLED" == "true" ]]; then mkdir -p "${IMAGES_DIR}"; fi
    if [[ "$CHARTS_DIR_ENABLED" == "true" ]]; then mkdir -p "${CHARTS_DIR}"; fi
    if [[ "$MANIFESTS_DIR_ENABLED" == "true" ]]; then mkdir -p "${MANIFESTS_DIR}"; fi
}

command_check() {
    # Check if a command exists
    local command="$1"
    if ! command -v "$command" >/dev/null 2>&1; then
        error_log "$command is not found, exiting the script"
        exit 1
    fi
}

download_chart() {
    # Download Helm chart
    info_log "Downloading Helm chart"

    # Add Helm repository
    helm repo add "${HELM_REPO_NAME%/*}" "${HELM_REPO_URL}" --force-update 1>/dev/null

    # Get version list from Helm repository
    local app_version_list=$(helm search repo --versions --regexp "\v${HELM_REPO_NAME}\v")
    local LATEST_VERSION=$(echo "${app_version_list}" | awk '{print $3}' | grep -v VERSION | head -n1)

    # If APP VERSION in helm chart does not contain the v field, remove it
    if [[ ! $LATEST_VERSION == v* ]]; then
        APP_VERSION=${VERSION#v}
    fi

    # Search for the CHART VERSION corresponding to the APP VERSION.
    # The same APP VERSION may correspond to multiple CHART VERSIONs.
    local HELM_CHART_VERSION=$(echo "${app_version_list}" | grep "${APP_VERSION}" | awk '{print $2}' | sort -rn | head -n1)

    # Check if the Helm repository contains the version
    helm search repo "${HELM_REPO_NAME}" --version ${HELM_CHART_VERSION} --fail-on-no-result >/dev/null 2>&1

    # Pull Helm chart
    helm pull "${HELM_REPO_NAME}" --version="${HELM_CHART_VERSION}" -d charts --untar

    # Generate image list
    main_file="https://raw.githubusercontent.com/ansible/awx-operator/${APP_VERSION}/roles/installer/defaults/main.yml"
    manager_auth_proxy_patch_file="https://raw.githubusercontent.com/ansible/awx-operator/${APP_VERSION}/config/default/manager_auth_proxy_patch.yaml"

    DEFAULT_AWX_VERSION=$(docker run --entrypoint="" quay.io/ansible/awx-operator:${APP_VERSION} bash -c "env | grep DEFAULT_AWX_VERSION" | awk -F= '{print $2}')
    REDIS_VERSION=$(curl -s ${main_file} | grep 'redis_image_version' | awk '{print $2}')
    INIT_PROJECTS_CONTAINER_IMAGE=$(curl -s ${main_file} | grep 'init_projects_container_image' | awk '{print $2}')
    POSTGRES_IMAGE=$(curl -s ${main_file} | grep 'postgres_image:' | awk '{print $2}')
    POSTGRES_IMAGE_VERSION=$(curl -s ${main_file} | grep 'postgres_image_version:' | awk '{print $2}')
    KUBE_RBAC_PROXY_VERSION=$(curl -s ${manager_auth_proxy_patch_file} | grep 'image:' | awk '{print $2}')

    cat >images/shim/images.txt<<EOF
quay.io/ansible/awx:${DEFAULT_AWX_VERSION}
quay.io/ansible/awx-ee:${DEFAULT_AWX_VERSION}
docker.io/redis:${REDIS_VERSION}
${INIT_PROJECTS_CONTAINER_IMAGE}
${POSTGRES_IMAGE}:${POSTGRES_IMAGE_VERSION}
${KUBE_RBAC_PROXY_VERSION}
quay.io/ansible/awx-operator:${APP_VERSION}
EOF
}

local_build() {
    # Perform local image build for test
    info_log "Performing local build"
    command_check "sealos"

    info_log "Running: sealos build -t ${REGISTRY_REPO}/${NAME}:${VERSION} ."
    sealos build -t "${REGISTRY_REPO}/${NAME}:${VERSION}" .

    info_log "Running: sealos push ${REGISTRY_REPO}/${NAME}:${VERSION}"
    sealos push "${REGISTRY_REPO}/${NAME}:${VERSION}"

    info_log "Build success: $REGISTRY_REPO/$NAME:$VERSION"
}

print_usage() {
    echo "Usage: $0 <ARCH> <NAME> <VERSION> [-b]"
    echo "    - ARCH: The target architecture for the deployment (e.g., amd64, arm64). Default is amd64 if not provided."
    echo "    - NAME: The name of the application or service being deployed. This will be used to tag the Docker image."
    echo "    - VERSION: The version of the application. This will be used for tagging Docker images and identifying the Helm chart version."
    echo "    - [-b]: Optional flag to enable local build before deployment. If provided, the script will perform a local build using 'sealos'."
    exit 1
}

main() {
    command_check "helm"

    OPTS=$(getopt -o b -- "$@")
    if [ "$#" -lt 3 ]; then
        print_usage
    fi
    eval set -- "$OPTS"
    while true; do
        case "$1" in
            -b )
                LOCAL_BUILD_ENABLED="true"
                shift
                ;;
            -- )
                shift
                break
                ;;
            * )
                break
                ;;
        esac
    done

    init_directory
    download_chart
    info_log "Initialization successful. You can run build now"

    if [[ "$LOCAL_BUILD_ENABLED" == "true" ]]; then
        local_build
    fi
}

main "$@"
