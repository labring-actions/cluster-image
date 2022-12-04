#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts/ opt/ && mkdir -p charts/ opt/
wget -q https://github.com/argoproj/argo-cd/releases/download/${VERSION}/argocd-linux-${ARCH}
mv argocd-linux-${ARCH} opt/argocd
chmod +x opt/argocd

helm repo add argo https://argoproj.github.io/argo-helm
chart_version=`helm search repo --versions --regexp '\vargo/argo-cd\v' |grep ${VERSION} | awk '{print $2}' | sort -rn | head -n1`
helm pull argo/argo-cd --version=${chart_version} -d charts/ --untar

cat <<EOF >"Kubefile"
FROM scratch
COPY charts charts
COPY registry registry
COPY opt opt
CMD ["cp opt/argocd /usr/local/bin","helm upgrade -i argocd charts/argo-cd -n argocd --create-namespace --set server.service.type=NodePort"]
EOF
