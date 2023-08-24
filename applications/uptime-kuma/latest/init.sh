#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

mkdir -p "charts"
mkdir -p "manifests"
helm template xxx uptime-kuma  --set image.tag="${VERSION#v}" > manifests/uptime-kuma.yaml
cp -rf uptime-kuma charts/


cat <<EOF >"install.sh"
#!/bin/bash
HELM_OPTS="\${HELM_OPTS:-}"

helm upgrade --install uptime-kuma charts/uptime-kuma --namespace uptime-kuma --create-namespace  \
    --set image.tag="${VERSION#v}" \
    \${HELM_OPTS}
EOF



cat <<EOF >"Kubefile"
FROM scratch
COPY charts charts
COPY registry registry
COPY install.sh install.sh
CMD ["bash install.sh"]
EOF


