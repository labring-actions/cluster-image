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
STORAGE=${1:-/var/lib/docker}
REGISTRY_DOMAIN=${2:-sealos.hub}
REGISTRY_PORT=${3:-5000}
REGISTRY_USERNAME=${4:-}
REGISTRY_PASSWORD=${5:-}
# Install docker
iptables -P FORWARD ACCEPT
chmod a+x init-docker.sh
#./docker.sh  /var/docker/lib  127.0.0.1
bash init-docker.sh ${STORAGE} ${REGISTRY_DOMAIN} ${REGISTRY_PORT} ${REGISTRY_USERNAME} ${REGISTRY_PASSWORD}

if [ $? != 0 ]; then
   error "====init docker failed!===="
fi

chmod a+x init-cri-dockerd.sh
bash init-cri-dockerd.sh
if [ $? != 0 ]; then
   error "====init cri dockerd failed!===="
fi

chmod a+x init-shim.sh
bash init-shim.sh ${REGISTRY_DOMAIN} ${REGISTRY_PORT}

if [ $? != 0 ]; then
   error "====init image-cri-shim failed!===="
fi

chmod a+x init-kube.sh
bash init-kube.sh

logger "init docker rootfs success"
