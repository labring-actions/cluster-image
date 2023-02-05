#!/bin/bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

VERSION=${VERSION#v}
wget -qO- https://github.com/elastic/cloud-on-k8s/archive/refs/tags/${VERSION}.tar.gz | tar -xz

mkdir charts
cp -r cloud-on-k8s-${VERSION}/deploy/eck-operator/ charts

cp cloud-on-k8s-${VERSION}/config/recipes/beats/filebeat_no_autodiscover.yaml manifests/filebeat_no_autodiscover_tmp.yaml
kubectl kustomize manifests/ >manifests/filebeat_no_autodiscover.yaml
rm -rf manifests/filebeat_no_autodiscover_tmp.yaml

mkdir -p images/shim
components_version=$(helm show values cloud-on-k8s-${VERSION}/deploy/eck-beats --jsonpath {.version})
cat <<EOF> images/shim/eckImages
docker.elastic.co/elasticsearch/elasticsearch:${components_version}
docker.elastic.co/beats/filebeat:${components_version}
docker.elastic.co/kibana/kibana:${components_version}
EOF
