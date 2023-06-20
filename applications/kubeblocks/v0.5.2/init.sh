#!/bin/bash
arch=${1:-amd64}
mkdir -p opt
wget https://github.com/apecloud/kubeblocks/releases/download/v0.5.2/kbcli-linux-"${arch}"-v0.5.2.tar.gz -O kbcli.tar.gz
tar -zxvf kbcli.tar.gz linux-"$arch"/kbcli
mv linux-"$arch"/kbcli opt/kbcli
chmod a+x opt/kbcli
rm -rf linux-"$arch" kbcli.tar.gz
echo "download kubectl-minio success"
