#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}
export GITHUB_USER="tektoncd"

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
    if curl -s "https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/releases/tags/$VERSION" | jq -re '.tag_name' &> /dev/null; then
        mkdir -p manifests/pipeline
        wget -qP manifests/pipeline https://github.com/tektoncd/pipeline/releases/download/${VERSION}/release.yaml
        sed -i 's/@sha256:[a-f0-9]\{64\}//g' manifests/pipeline/release.yaml
        cat manifests/pipeline/release.yaml | grep -o 'gcr.io[^",]*' | awk '{print $1}' > images/shim/images.txt
        echo cgr.dev/chainguard/busybox >> images/shim/images.txt
    else
        echo "The specified tekton pipeline VERSION ${VERSION} does not exist."
        exit 1
    fi
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
    local GITHUB_REPO="triggers"
    local release_url="https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/releases"
    local traggers_latest_version=$(curl -s ${release_url} | grep tag_name | grep -v -- '-rc' | sort -r | head -1 | awk -F': ' '{print $2}' | sed 's/,//' | xargs)

    mkdir -p manifests/triggers
    wget -qP manifests/triggers https://github.com/${GITHUB_USER}/${GITHUB_REPO}/releases/download/${traggers_latest_version}/release.yaml
    wget -qP manifests/triggers https://github.com/${GITHUB_USER}/${GITHUB_REPO}/releases/download/${traggers_latest_version}/interceptors.yaml

    sed -i 's/@sha256:[a-f0-9]\{64\}//g' manifests/triggers/release.yaml
    sed -i 's/@sha256:[a-f0-9]\{64\}//g' manifests/triggers/interceptors.yaml
    cat manifests/triggers/release.yaml | grep -o 'gcr.io[^",]*' | awk '{print $1}' >> images/shim/images.txt
    cat manifests/triggers/interceptors.yaml | grep -o 'gcr.io[^",]*' | awk '{print $1}' >> images/shim/images.txt
}

download_chains_files() {
    local GITHUB_REPO="chains"
    local release_url="https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/releases"
    local chains_latest_version=$(curl -s ${release_url} | grep tag_name | grep -v -- '-rc' | sort -r | head -1 | awk -F': ' '{print $2}' | sed 's/,//' | xargs)

    mkdir -p manifests/chains
    wget -qP manifests/chains https://github.com/${GITHUB_USER}/${GITHUB_REPO}/releases/download/${chains_latest_version}/release.yaml

    sed -i 's/@sha256:[a-f0-9]\{64\}//g' manifests/chains/release.yaml
    cat manifests/chains/release.yaml | grep -o 'gcr.io[^",]*' | awk '{print $1}' >> images/shim/images.txt
}


download_dashboard_files() {
    local GITHUB_REPO="dashboard"
    local release_url="https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/releases"
    local dashboard_latest_version=$(curl -s ${release_url} | grep tag_name | grep -v -- '-rc' | sort -r | head -1 | awk -F': ' '{print $2}' | sed 's/,//' | xargs)

    mkdir -p manifests/dashboard
    wget -qP manifests/dashboard https://github.com/${GITHUB_USER}/${GITHUB_REPO}/releases/download/${dashboard_latest_version}/release-full.yaml

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
