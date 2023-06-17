#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

helm repo add bitnami https://charts.bitnami.com/bitnami
# Get the chart version from the app version
chart_version=`helm search repo --versions --regexp '\vbitnami/mysql\v' |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1`
helm pull bitnami/mysql --version=${chart_version} -d charts/ --untar

cat <<EOF >"Kubefile"
FROM scratch
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i bitnami-mysql charts/mysql -n mysql --create-namespace --set auth.rootPassword=mysql123"]
EOF
