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
STORAGE=${1:-/var/lib/containerd}
REGISTRY_DOMAIN=${2:-sealos.hub}
REGISTRY_PORT=${3:-5000}
REGISTRY_USERNAME=${4:-}
REGISTRY_PASSWORD=${5:-}

# Install containerd
chmod a+x init-containerd.sh
bash init-containerd.sh ${STORAGE} ${REGISTRY_DOMAIN} ${REGISTRY_PORT}  ${REGISTRY_USERNAME} ${REGISTRY_PASSWORD}

if [ $? != 0 ]; then
   error "====init containerd failed!===="
fi

chmod a+x init-shim.sh
bash init-shim.sh ${REGISTRY_DOMAIN} ${REGISTRY_PORT}

if [ $? != 0 ]; then
   error "====init image-cri-shim failed!===="
fi

chmod a+x init-kube.sh
bash init-kube.sh

logger "init rootfs success"
