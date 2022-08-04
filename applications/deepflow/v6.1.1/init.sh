#!/bin/bash
arch=${1:-amd64}
mkdir -p opt
wget https://deepflow-ce.oss-cn-beijing.aliyuncs.com/bin/ctl/latest/linux/$arch/deepflow-ctl -O opt/deepflow-ctl
chmod a+x opt/deepflow-ctl
echo "download deepflow-ctl success"
