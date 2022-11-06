#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts/
mkdir -p charts/

# Remove `v` from image tag `vx.x.x`
VERSION=`echo ${VERSION} | sed 's/.//'`
chart_version=`helm search repo --versions --regexp '\vgitea-charts/gitea\v' |grep ${VERSION} | awk '{print $2}' | sort -rn | head -n1`
app_versions=`helm search repo --versions --regexp '\vgitea-charts/gitea\v' | awk '{print $3}' | grep -v VERSION`
echo "support app_versions: $app_versions"

helm repo add gitea https://dl.gitea.io/charts
helm pull gitea-charts/gitea --version=${chart_version} -d charts/ --untar

cat <<'EOF' >"Kubefile"
FROM scratch
ENV NODE_IP "git.example.com"
ENV HTTP_NODE_PORT 30033
ENV SSH_NODE_PORT 30022
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i gitea charts/gitea -n gitea --create-namespace --set gitea.admin.password=gitea_admin,service.http.type=NodePort,service.ssh.type=NodePort,service.http.nodePort=$(HTTP_NODE_PORT),service.ssh.nodePort=$(SSH_NODE_PORT),gitea.config.server.ROOT_URL=http://$(NODE_IP):$(HTTP_NODE_PORT),gitea.config.server.SSH_DOMAIN=${NODE_IP}:${SSH_NODE_PORT}"]
EOF
