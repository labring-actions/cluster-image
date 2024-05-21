#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

repo_url="https://itzg.github.io/minecraft-server-charts/"
repo_name="itzg/minecraft"
chart_name="itzg"

rm -rf charts images/shim && mkdir -p {charts,images/shim}
helm repo add ${chart_name} ${repo_url} --force-update
helm pull ${repo_name} -d charts --untar
echo "docker.io/itzg/minecraft-server:latest" > images/shim/minecraft-server-images.txt
