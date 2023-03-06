#!/bin/bash
set -ez

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}


rm -rf opt/ charts/ && mkdir -p opt/ charts/
wget -qO- "https://github.com/karmada-io/karmada/releases/download/v${VERSION}/kubectl-karmada-linux-${ARCH}.tgz"
sudo tar -C opt/ -zxvf kubectl-karmada-linux-${ARCH}.tgz kubectl-karmada
chmod a+x opt/kubectl-karmada

repo_url="https://raw.githubusercontent.com/karmada-io/karmada/master/charts"
repo_name="karmada-charts/karmada"
app_name="karmada-charts"
helm repo add ${app_name} ${repo_url}
# Get all helm chart app versions
helm pull ${repo_name} --version=${VERSION} -d charts/ --untar


cat <<EOF >>"Kubefile"
FROM scratch
COPY opt opt
COPY charts charts
COPY registry registry
CMD ["cp -a opt/kubectl-karmada /usr/bin/","helm upgrade -i karmada charts/karmada -n karmada-system --create-namespace --set components={descheduler}"]
EOF


