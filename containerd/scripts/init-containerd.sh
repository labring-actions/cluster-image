#!/bin/bash
# Copyright © 2022 sealos.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

source common.sh
registry_domain=${1:-sealos.hub}
registry_port=${2:-5000}

mkdir -p /opt/containerd && tar -zxf ../cri/libseccomp.tar.gz -C /opt/containerd
echo "/opt/containerd/lib" >/etc/ld.so.conf.d/containerd.conf
ldconfig
[ -d /etc/containerd/certs.d/ ] || mkdir /etc/containerd/certs.d/ -p
cp ../etc/containerd.service /etc/systemd/system/
tar -zxf ../cri/cri-containerd.tar.gz -C /
# shellcheck disable=SC2046
chmod a+x $(tar -tf ../cri/cri-containerd.tar.gz | while read -r binary; do echo "/usr/bin/${binary##*/}"; done | xargs)
systemctl enable containerd.service
cp ../etc/config.toml /etc/containerd
mkdir -p /etc/containerd/certs.d/$registry_domain:$registry_port
cp ../etc/hosts.toml /etc/containerd/certs.d/$registry_domain:$registry_port
systemctl daemon-reload
systemctl restart containerd.service
check_status containerd
logger "init containerd success"
