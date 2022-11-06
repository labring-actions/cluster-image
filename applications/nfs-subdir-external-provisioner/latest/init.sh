#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts/
mkdir -p charts/

VERSION=`echo ${VERSION} | sed 's/.//'`
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm pull nfs-subdir-external-provisioner/nfs-subdir-external-provisioner --version=${VERSION} -d charts/ --untar

cat <<'EOF' >"Kubefile"
FROM scratch
ENV NFS_SERVER "127.0.0.1"
ENV NFS_PATH "/nfs-share"
COPY charts charts
COPY registry registry
CMD ["helm upgrade -i nfs-subdir-external-provisioner charts/nfs-subdir-external-provisioner -n nfs-provisioner --create-namespace --set nfs.server=$(NFS_SERVER),nfs.path=$(NFS_PATH)"]
EOF
