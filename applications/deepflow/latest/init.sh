#!/bin/bash
helm repo add deepflow https://deepflowys.github.io/deepflow
helm pull deepflow/deepflow --untar -d charts/
arch=${1:-amd64}
mkdir -p opt
wget https://deepflow-ce.oss-accelerate.aliyuncs.com/bin/ctl/latest/linux/$arch/deepflow-ctl -O opt/deepflow-ctl
chmod a+x opt/deepflow-ctl
echo "download deepflow-ctl success"
