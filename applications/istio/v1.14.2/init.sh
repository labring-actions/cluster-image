#!/bin/bash
arch=${1:-amd64}
mkdir -p opt
wget https://github.com/istio/istio/releases/download/1.14.2/istioctl-1.14.2-linux-$arch.tar.gz
tar -zxvf istioctl-1.14.2-linux-$arch.tar.gz -C opt/
rm -rf istioctl-1.14.2-linux-$arch.tar.gz
echo "download istioctl success"
