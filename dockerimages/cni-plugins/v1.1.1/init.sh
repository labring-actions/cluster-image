#!/bin/bash
arch=${1:-amd64}
wget https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-${arch}-v1.1.1.tgz
mv cni-plugins-linux-${arch}-v1.1.1.tgz cni-plugins.tgz
echo "download helm success"
