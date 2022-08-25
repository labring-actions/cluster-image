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
storage=${1:-/var/lib/docker}
registry_domain=${2:-sealos.hub}
registry_port=${3:-5000}
username=${4:-}
password=${5:-}
mkdir -p $storage
if ! command_exists cri-docker; then
  cp ../etc/cri-docker.service /etc/systemd/system/
  tar -zxvf ../cri/cri-dockerd.tgz -C /usr/bin
  chmod a+x /usr/bin/cri-dockerd
  systemctl enable cri-docker.service
  systemctl restart cri-docker.service
fi
systemctl daemon-reload
systemctl restart cri-docker.service
check_status cri-docker
logger "init docker success"

