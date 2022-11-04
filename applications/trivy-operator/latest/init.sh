#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}


helm repo add aqua --force-update https://aquasecurity.github.io/helm-charts/
chart_version=`helm search repo --versions --regexp '\vaqua/trivy-operator\v' |grep ${VERSION} | awk '{print $2}' | sort -rn | head -n1`
app_versions=`helm search repo --versions --regexp '\vaqua/trivy-operator\v' | awk '{print $3}' | grep -v VERSION`
echo "support app_versions: $app_versions"

if [ $VERSION = "latest" ]
then helm pull aqua/trivy-operator --untar -d charts/
else helm pull aqua/trivy-operator --version=${chart_version} --untar -d charts/
fi

cat <<EOF >>"Kubefile"
FROM scratch
COPY . .
CMD ["helm upgrade -i trivy-operator  charts/trivy-operator -n trivy-operator --create-namespace --set trivy.ignoreUnfixed=true --set trivy.tag=0.31.3"]
EOF
