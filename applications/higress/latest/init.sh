#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts && mkdir -p charts
helm repo add higress.io https://higress.io/helm-charts
chart_version=`helm search repo --versions --regexp '\vhigress.io/higress\v' |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1`
helm pull higress.io/higress --version=${chart_version} -d charts/ --untar

cat <<'EOF' >"Kubefile"
FROM scratch
COPY charts charts
COPY registry registry
COPY install.sh install.sh
CMD ["bash install.sh"]
EOF
