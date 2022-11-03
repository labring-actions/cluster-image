#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts/ images/shim/
mkdir -p charts/ images/shim/

helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
chart_version=`echo ${VERSION} | sed 's/.//'`

helm pull rancher-stable/rancher --version=${chart_version} -d charts/ --untar
# There are 500+ images in this list, too many, not suitable for building with github action.
# wget -q https://github.com/rancher/rancher/releases/download/${VERSION}/rancher-images.txt -P images/shim/

cat <<'EOF' >"Kubefile"
FROM scratch
ENV hostname rancher.my.org
ENV ingressClassName nginx
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i rancher charts/rancher -n cattle-system --create-namespace --set hostname=$(hostname),bootstrapPassword=rancher,ingress.ingressClassName=$(ingressClassName)"]
EOF
