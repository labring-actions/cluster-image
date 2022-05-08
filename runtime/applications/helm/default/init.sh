#!/bin/bash
arch=${1:-amd64}
mkdir -p opt
wget https://get.helm.sh/helm-v3.8.2-linux-$arch.tar.gz
tar -zxvf helm-v3.8.2-linux-$arch.tar.gz
chmod a+x linux-$arch/helm
mv linux-$arch/helm opt/
echo "download helm success"
sleep 60
