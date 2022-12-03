#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

helm repo add chaos-mesh https://charts.chaos-mesh.org
chart_version=`echo ${VERSION} | sed 's/.//'`
rm -rf charts/ && mkdir charts 
helm pull chaos-mesh/chaos-mesh --version=${chart_version} -d charts/ --untar

cat <<'EOF' >"Kubefile"
FROM scratch
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i chaos-mesh charts/chaos-mesh -n chaos-mesh --create-namespace --set dashboard.persistentVolume.enabled=true,dashboard.persistentVolume.storageClassName=null"]
EOF
