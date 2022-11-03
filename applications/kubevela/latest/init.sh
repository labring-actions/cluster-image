#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf opt/ charts/ images/shim/ manifests/
mkdir -p opt/ charts/ images/shim/ manifests/

chart_version=`echo ${VERSION} | sed 's/.//'`

helm repo add kubevela https://charts.kubevela.net/core
helm pull kubevela/vela-core --version=${chart_version} --untar -d charts/
wget -q https://github.com/kubevela/kubevela/releases/download/${VERSION}/kubectl-vela-${VERSION}-linux-${ARCH}.tar.gz
tar -zxf kubectl-vela-${VERSION}-linux-${ARCH}.tar.gz
mv linux-${ARCH}/kubectl-vela opt/vela
rm -rf kubectl-vela-${VERSION}-linux-${ARCH}.tar.gz linux-${ARCH}

git clone https://github.com/kubevela/catalog --depth=1
cp -r catalog/addons/velaux/ manifests/
rm -rf catalog

cat <<EOF >"images/shim/velaImages"
oamdev/vela-apiserver:${VERSION}
oamdev/velaux:${VERSION}
EOF

cat <<EOF >"Kubefile"
FROM scratch
COPY opt opt
COPY charts charts
COPY manifests manifests
COPY registry registry
CMD ["cp opt/vela /usr/bin/vela","helm upgrade -i kubevela charts/vela-core -n vela-system --create-namespace --wait","vela addon enable manifests/velaux serviceType=NodePort"]
EOF
