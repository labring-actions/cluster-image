#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

repo_url="https://charts.longhorn.io"
repo_name="longhorn/longhorn"
chart_name="longhorn"

helm repo add ${chart_name} ${repo_url}
helm pull ${repo_name} --version=${VERSION#v} -d charts --untar
yq e -i '.service.ui.type="NodePort"' charts/longhorn/values.yaml

mkdir -p manifests/longhorn
wget -qP manifests/longhorn https://raw.githubusercontent.com/longhorn/longhorn/${VERSION}/deploy/prerequisite/longhorn-iscsi-installation.yaml
wget -qP manifests/longhorn https://raw.githubusercontent.com/longhorn/longhorn/${VERSION}/deploy/prerequisite/longhorn-nfs-installation.yaml

mkdir scripts
wget -qP scripts https://raw.githubusercontent.com/longhorn/longhorn/${VERSION}/scripts/environment_check.sh
chmod +x scripts/environment_check.sh

mkdir opt
curl -sL -o opt/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
chmod +x opt/jq

mkdir -p images/shim
cat scripts/environment_check.sh |grep image: |awk '{print $2}' | sort -u > images/shim/longhornImages
wget -qP images/shim https://raw.githubusercontent.com/longhorn/longhorn/${VERSION}/deploy/longhorn-images.txt
