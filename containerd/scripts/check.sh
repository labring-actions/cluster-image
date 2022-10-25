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
storage=${1:-/var/lib/registry}

check_port_inuse
if command_exists docker; then
    error "Please using docker image: labring/kubernetes-docker:v1.23.10"
fi
check_cmd_exits docker
check_file_exits /var/run/docker.sock
check_file_exits $storage
if ! command_exists apparmor_parser; then
    sed -i 's/disable_apparmor = false/disable_apparmor = true/g' ../etc/config.toml
    warn "Replace disable_apparmor = false to disable_apparmor = true"
fi
logger "check root,port,cri success"
