#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts/ && mkdir -p charts/
helm repo add kubegems https://charts.kubegems.io/kubegems
helm pull kubegems/kubegems-installer --version=${VERSION#v} --untar -d charts/
helm pull kubegems/kubegems --version=${VERSION#v} --untar -d charts/

cat <<EOF >"Kubefile"
FROM scratch
COPY registry ./registry
COPY charts ./charts
CMD ["helm upgrade -i kubegems-installer charts/kubegems-installer -n kubegems-installer --create-namespace --set installer.image.tag=${VERSION}","helm upgrade -i kubegems charts/kubegems -n kubegems --create-namespace --set global.kubegemsVersion=${VERSION},ingress.enable=false,dashboard.service.type=NodePort"]
EOF
