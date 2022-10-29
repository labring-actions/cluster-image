#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf opt/ charts/
mkdir -p opt/ charts/
wget https://deepflow-ce.oss-accelerate.aliyuncs.com/bin/ctl/latest/linux/${ARCH}/deepflow-ctl -O opt/deepflow-ctl
chmod a+x opt/deepflow-ctl

helm repo add deepflow --force-update https://deepflowys.github.io/deepflow-charts
chart_version=`helm search repo --versions --regexp '\vdeepflow/deepflow\v' |grep ${VERSION} | awk '{print $2}' | sort -rn | head -n1`
app_versions=`helm search repo --versions --regexp '\vdeepflow/deepflow\v' | awk '{print $3}' | grep -v VERSION`
echo "support app_versions: $app_versions"

if [ $VERSION = "latest" ]
then helm pull deepflow/deepflow --untar -d charts/
else helm pull deepflow/deepflow --version=${chart_version} --untar -d charts/
fi

cat <<EOF >>"Kubefile"
FROM scratch
COPY . .
CMD ["mv opt/deepflow-ctl /usr/bin/","helm upgrade -i deepflow  charts/deepflow -n deepflow --create-namespace"]
EOF
