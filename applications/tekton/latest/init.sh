#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}
export readonly GITHUB_USER="tektoncd"

init_dir() {
    ETC_DIR="./etc"
    OPT_DIR="./opt"
    IMAGES_DIR="./images/shim"
    CHARTS_DIR="./charts"
    MANIFESTS_DIR="./manifests"

    rm -rf "${OPT_DIR}" "${IMAGES_DIR}" "${CHARTS_DIR}" "${MANIFESTS_DIR}" "${ETC_DIR}"
    mkdir -p "${MANIFESTS_DIR}" "${OPT_DIR}" "${IMAGES_DIR}"
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

download_pipeline_file() {
    local GITHUB_REPO="pipeline"

    echo "Checking if tekton pipeline VERSION $VERSION exists..."
    if ! curl -s "https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/releases/tags/$VERSION" | jq -re '.tag_name' &> /dev/null; then
        echo "The specified tekton pipeline VERSION ${VERSION} does not exist."
        exit 1
    fi

    mkdir -p manifests/pipeline
    wget -qP manifests/pipeline https://github.com/tektoncd/pipeline/releases/download/${VERSION}/release.yaml
    sed -i 's/@sha256:[a-f0-9]\{64\}//g' manifests/pipeline/release.yaml
    cat manifests/pipeline/release.yaml | grep -o 'gcr.io[^",]*' | awk '{print $1}' > images/shim/images.txt
    echo cgr.dev/chainguard/busybox >> images/shim/images.txt

    # For the git clone task
    gitInitImage="gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:latest"
    echo "$gitInitImage" >> images/shim/images.txt

    # For the docker build task
    kaniko_builder_image="gcr.io/kaniko-project/executor:latest"
    echo "$kaniko_builder_image" >> images/shim/images.txt
}

download_cli_file() {
    local GITHUB_REPO="cli"
    local release_url="https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/releases"
    local tkn_latest_version=$(curl -s ${release_url} | grep tag_name | grep -v -- '-rc' | sort -r | head -1 | awk -F': ' '{print $2}' | sed 's/,//' | xargs)
    local GITHUB_FILE="tkn_${tkn_latest_version#v}_Linux_x86_64.tar.gz"
    local DOWNLOAD_URL="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/releases/download/${tkn_latest_version}/${GITHUB_FILE}"

    wget -qO- "${DOWNLOAD_URL}" | tar -zx -C ./opt tkn
    chmod +x opt/tkn
}

download_triggers_files() {
    mkdir -p manifests/triggers
    wget -qP manifests/triggers https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
    wget -qP manifests/triggers https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml

    sed -i 's/@sha256:[a-f0-9]\{64\}//g' manifests/triggers/release.yaml
    sed -i 's/@sha256:[a-f0-9]\{64\}//g' manifests/triggers/interceptors.yaml
    cat manifests/triggers/release.yaml | grep -o 'gcr.io[^",]*' | awk '{print $1}' >> images/shim/images.txt
    cat manifests/triggers/interceptors.yaml | grep -o 'gcr.io[^",]*' | awk '{print $1}' >> images/shim/images.txt
}

download_chains_files() {
    mkdir -p manifests/chains
    wget -qP manifests/chains https://storage.googleapis.com/tekton-releases/chains/latest/release.yaml

    sed -i 's/@sha256:[a-f0-9]\{64\}//g' manifests/chains/release.yaml
    cat manifests/chains/release.yaml | grep -o 'gcr.io[^",]*' | awk '{print $1}' >> images/shim/images.txt
}

download_dashboard_files() {
    mkdir -p manifests/dashboard
    wget -qP manifests/dashboard https://storage.googleapis.com/tekton-releases/dashboard/latest/release-full.yaml

    sed -i 's/@sha256:[a-f0-9]\{64\}//g' manifests/dashboard/release-full.yaml
    cat manifests/dashboard/release-full.yaml | grep -o 'gcr.io[^",]*' | awk '{print $1}' >> images/shim/images.txt
}

main() {
    if [ $# -ne 3 ]; then
        echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
        exit 1
    else
        init_dir
        command_check "jq -h"
        download_pipeline_file
        download_cli_file
        download_triggers_files
        download_chains_files
        download_dashboard_files
    fi
}

main $@
