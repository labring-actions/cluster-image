#!/bin/bash
# Copyright © 2022 sealyun.
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
storage=${1:-/var/lib/containerd}
systemctl stop containerd
systemctl disable containerd
rm -rf /etc/containerd
rm -rf /etc/systemd/system/containerd.service
systemctl daemon-reload
rm -rf $storage
rm -rf /var/lib/nerdctl

rm -f /usr/bin/containerd
rm -f /usr/bin/containerd-stress
rm -f /usr/bin/containerd-shim
rm -f /usr/bin/containerd-shim-runc-v1
rm -f /usr/bin/containerd-shim-runc-v2
rm -f /usr/bin/crictl
rm -f /etc/crictl.yaml
rm -f /usr/bin/ctr
rm -f /usr/bin/ctd-decoder
rm -f /usr/bin/runc
rm -f /usr/bin/nerdctl

rm -rf /opt/containerd
rm -rf /etc/ld.so.conf.d/containerd.conf
ldconfig

logger "clean containerd success"
