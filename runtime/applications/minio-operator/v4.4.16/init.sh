#!/bin/bash
arch=${1:-amd64}
mkdir -p opt
wget https://github.com/minio/operator/releases/download/v4.4.16/kubectl-minio_4.4.16_linux_$arch -O opt/kubectl-minio
chmod a+x opt/kubectl-minio
echo "download kubectl-minio success"
