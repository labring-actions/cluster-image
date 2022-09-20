#!/bin/bash
arch=${1:-amd64}
mkdir -p opt
wget https://github.com/vmware-tanzu/velero/releases/download/v1.9.1/velero-v1.9.1-linux-$arch.tar.gz
tar -zxvf velero-v1.9.1-linux-$arch.tar.gz
cp velero-v1.9.1-linux-amd64/velero opt/
rm -rf velero-v1.9.1-linux-amd64*
echo "download velero success"
