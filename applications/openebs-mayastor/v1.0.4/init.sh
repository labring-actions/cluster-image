#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

TMPDIR="$(mktemp -d)"
trap 'rm -rf -- "$TMPDIR"' EXIT

pushd "$TMPDIR"
app_version=`echo ${VERSION} | sed 's/.//'`
wget -qc https://github.com/openebs/mayastor-control-plane/archive/refs/tags/${VERSION}.tar.gz -O - | tar -xz
wget -qc https://github.com/openebs/mayastor/archive/refs/tags/${VERSION}.tar.gz -O - | tar -xz 
wget -q https://github.com/openebs/mayastor-control-plane/releases/download/${VERSION}/kubectl-mayastor-x86_64-linux-musl.zip
unzip kubectl-mayastor-x86_64-linux-musl.zip
chmod +x kubectl-mayastor
popd

rm -rf manifests/ opt/ && mkdir -p manifests/mayastor/{mayastor-control-plane/deploy,mayastor} opt/
cp -r ${TMPDIR}/mayastor-control-plane-${app_version}/deploy/*.yaml manifests/mayastor/mayastor-control-plane/deploy
cp -r ${TMPDIR}/mayastor-${app_version}/deploy manifests/mayastor/mayastor
cp ${TMPDIR}/kubectl-mayastor opt/

cat <<EOF> "manifests/mayastor/namespace.yaml"
apiVersion: v1
kind: Namespace
metadata:
  name: mayastor
EOF

cat <<EOF> "manifests/mayastor/kustomization.yaml"
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- namespace.yaml
- mayastor-control-plane/deploy/operator-rbac.yaml
- mayastor-control-plane/deploy/mayastorpoolcrd.yaml
- mayastor/deploy/nats-deployment.yaml
- mayastor/deploy/etcd/storage/localpv.yaml
- mayastor/deploy/etcd/statefulset.yaml
- mayastor/deploy/etcd/svc.yaml
- mayastor/deploy/etcd/svc-headless.yaml
- mayastor/deploy/csi-daemonset.yaml
- mayastor-control-plane/deploy/core-agents-deployment.yaml
- mayastor-control-plane/deploy/rest-deployment.yaml
- mayastor-control-plane/deploy/rest-service.yaml
- mayastor-control-plane/deploy/csi-deployment.yaml
- mayastor-control-plane/deploy/msp-deployment.yaml
- mayastor/deploy/mayastor-daemonset.yaml
EOF

cat <<EOF> "Kubefile"
FROM scratch
COPY manifests manifests
COPY registry registry
COPY opt opt
COPY mayastor.sh mayastor.sh
CMD ["bash mayastor.sh"]
EOF
