#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

repo_url="https://openebs.github.io/mayastor-extensions"
repo_name="mayastor/mayastor"
chart_name="mayastor"

rm -rf charts opt && mkdir -p {charts,opt}
helm repo add ${chart_name} ${repo_url} --force-update
helm pull ${repo_name} --version=${VERSION#v} -d charts --untar

wget -q https://github.com/openebs/mayastor-control-plane/releases/download/${VERSION}/kubectl-mayastor-x86_64-linux-musl.zip
unzip kubectl-mayastor-x86_64-linux-musl.zip -d opt/
chmod +x opt/kubectl-mayastor
rm -rf kubectl-mayastor-x86_64-linux-musl.zip
