#!/bin/bash

#set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

helm repo add bitnami https://charts.bitnami.com/bitnami
chart_version=`helm search repo --versions --regexp '\vbitnami/nginx\v' |grep ${VERSION} | awk '{print $2}' | sort -rn | head -n1`
app_versions=`helm search repo --versions --regexp '\vbitnami/nginx\v' | awk '{print $3}' | grep -v VERSION`

echo $app_versions |grep $VERSION
if [[ $? -ne 0 ]]; then
  echo "The version number does not exist!,support version number are: $app_versions"
  exit 1
fi

rm -rf charts
mkdir -p charts
helm pull bitnami/nginx --version=${chart_version} --untar -d charts

cat <<EOF >>"Kubefile"
FROM scratch
COPY . .
CMD ["helm upgrade -i nginx charts/nginx -n nginx --create-namespace --set service.type=NodePort"]
EOF
