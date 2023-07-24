#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts && mkdir -p charts
helm repo add koderover-chart https://koderover.tencentcloudcr.com/chartrepo/chart
chart_version=`helm search repo --versions --regexp '\vkoderover-chart/zadig\v' |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1`
helm pull koderover-chart/zadig --version=${chart_version} -d charts/ --untar

mkdir -p images/shim/

helm template xx charts/zadig | grep image: | awk '{print $2}' | grep -v image: |  tr -d '"' | grep -v "^$"  > images/shim/images1
helm template xx charts/zadig | grep image: | awk '{print $3}' | grep -v image: |  tr -d '"' | grep -v "^$" > images/shim/images2
helm template xx charts/zadig | grep IMAGE | awk '{print $2}' | grep -v BuildOS | grep -v IMAGE |  tr -d '"' | grep -v "^$" > images/shim/images3
echo "koderover.tencentcloudcr.com/koderover-public/build-base:focal" >  images/shim/images4

cat <<'EOF' >"Kubefile"
FROM scratch
COPY charts charts
COPY registry registry
COPY install.sh install.sh
CMD ["bash install.sh"]
EOF
