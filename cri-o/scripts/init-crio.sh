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

#mkdir -p /opt/crio && tar -zxf ../cri/lib64/crio-lib.tar.gz -C /opt/crio
#echo "/opt/crio/lib" > /etc/ld.so.conf.d/containerd.conf
#ldconfig

tar -zxf ../cri/cri-o.tar.gz -C /opt/
cd /opt/cri-o && ./install && cd -
rm -rf /etc/cni/net.d/10-crio-bridge.conf
systemctl enable crio.service
cp ../etc/99-crio.conf /etc/crio/crio.conf.d/
mkdir -p /var/lib/kubelet/
cp ../etc/config.json /etc/crio/
systemctl daemon-reload
systemctl restart crio.service
check_status crio
logger "init crio success"
