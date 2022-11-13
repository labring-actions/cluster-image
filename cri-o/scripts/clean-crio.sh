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
storage=${1:-/var/lib/crio}
systemctl disable --now crio
rm -rf /etc/cni/net.d/10-crio-bridge.conf
rm -rf /usr/local/lib/systemd/system/crio.service
rm -rf /etc/systemd/system/cri-o.service
systemctl daemon-reload
rm -rf $storage

rm -f /usr/local/bin/conmon
rm -f /usr/local/bin/crictl
rm -f /usr/local/bin/crio-status
rm -f /usr/local/bin/crio
rm -f /usr/local/bin/pinns
rm -f /usr/local/bin/crun
rm -f /usr/local/bin/runc

rm -f /etc/crictl.yaml
rm -f /var/lib/kubelet/config.json
rm -rf /etc/crio
rm -rf /etc/containers
rm -rf /var/lib/cni/networks/crio/
rm -rf /opt/cri-o
m -rf /run/crio
ldconfig

logger "clean crio success"
