#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

init_dir() {
    local OPT_DIR="./opt"
    local IMAGES_DIR="./images"
    local CHARTS_DIR="./charts"
    local MANIFESTS_DIR="./manifests"

    rm -rf "${OPT_DIR}" "${IMAGES_DIR}" "${CHARTS_DIR}" "${MANIFESTS_DIR}"
}

check_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "$1 is required, exiting the script"
    exit 1
  fi
}

download_chart() {
    local USERNAME="harness"    # Replace with actual GitHub USERNAME
    local REPOSITORY="gitness"  # Replace with actual GitHub REPOSITORY

    case "$VERSION" in
        main)
            echo "Checking if the main branch exists..."
            branch_exists=$(curl -s "https://api.github.com/repos/$USERNAME/$REPOSITORY/branches" | jq -e --arg branch "$VERSION" '.[] | select(.name==$branch)')
            if [ ! -z "$branch_exists" ]; then
                echo "The $VERSION branch exists. Downloading the $VERSION branch..."
                wget -qO- "https://github.com/$USERNAME/$REPOSITORY/archive/$VERSION.tar.gz" | tar -zx gitness-${VERSION}/charts --strip=1
            else
                echo "Main branches not exist."
                exit 1
            fi
            ;;
        latest)
            echo "Getting the latest release VERSION..."
            LATEST_VERSION=$(curl -s "https://api.github.com/repos/$USERNAME/$REPOSITORY/releases/latest" | jq -r '.tag_name')
            if [ "$LATEST_VERSION" != "null" ]; then
                echo "Latest VERSION is $LATEST_VERSION"
                echo "Downloading the latest release..."
                wget -qO- "https://github.com/$USERNAME/$REPOSITORY/archive/$LATEST_VERSION.tar.gz" | tar -zx gitness-${VERSION}/charts --strip=1
            else
                echo "Failed to get the latest release VERSION."
                exit 1
            fi
            ;;
        *)
            echo "Checking if VERSION $VERSION exists..."
            if curl -s "https://api.github.com/repos/$USERNAME/$REPOSITORY/releases/tags/$VERSION" | jq -re '.tag_name' &> /dev/null; then
                echo "VERSION $VERSION exists. Downloading VERSION $VERSION..."
                wget -qO- "https://github.com/$USERNAME/$REPOSITORY/archive/$VERSION.tar.gz" | tar -zx gitness-${VERSION}/charts --strip=1
            else
                echo "The specified VERSION does not exist."
                exit 1
            fi
            ;;
    esac
}

main() {
    if [ $# -ne 3 ]; then
        echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
        exit 1
    else
        init_dir
        check_command helm
        download_chart
    fi
}

main $@
