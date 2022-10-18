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
storage=${1:-/var/lib/cri-dockerd}
systemctl stop cri-docker
systemctl disable cri-docker
rm -rf /etc/systemd/system/cri-docker.service
rm -rf /etc/systemd/system/cri-docker.socket
systemctl daemon-reload
rm -rf $storage
rm -f /usr/bin/cri-dockerd
rm -f /usr/bin/crictl
rm -f /etc/crictl.yaml
rm -f /var/run/cri-dockerd.sock
logger "clean cri-docker success"
