#!/usr/bin/env sh

set -e

cd "$(dirname "$0")" >/dev/null 2>&1

find . -type f -perm /+x | grep -v "$(basename "$0")" | while read -r f; do
  if [ -x "$f" ]; then
    cp -auv "$f" /usr/bin
  fi
done

kubectl-minio init
kubectl --namespace minio-operator create deployment minio-client --image IMAGE_MC -- tail -F /etc/hosts || true
kubectl-minio tenant create -h
echo "
a new MinIO tenant:
kubectl-minio tenant create internal \
  --image IMAGE_MINIO \
  --namespace minio-operator \
  --storage-class local-path-retain \
  --servers 3 --volumes 6 --capacity 1Ti \
  --enable-audit-logs=false \
  --enable-prometheus=false \
  --disable-tls
"
