#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf opt/ *.tar.gz
mkdir -p opt/
curl -sL "https://github.com/weaveworks/weave-gitops/releases/download/v${VERSION}/gitops-linux-x86_64.tar.gz" | tar xz -C opt/ gitops
curl -sL "https://github.com/weaveworks/weave-gitops/archive/refs/tags/v${VERSION}.tar.gz" | tar -xz weave-gitops-${VERSION}/charts/ --strip=1

cat <<'EOF' >"Kubefile"
FROM scratch
COPY charts charts
COPY opt opt
COPY registry registry
CMD ["cp opt/gitops /usr/bin/","helm upgrade -i wego charts/gitops-server -n flux-system --create-namespace --set adminUser.create=true,adminUser.passwordHash='$2a$10$WhKMXC7fBFssne7e9YhzceGGBOXuRVa.oIHiy1CkBsk6vIh2iIQyC',service.type=NodePort"]
EOF
