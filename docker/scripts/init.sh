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
# Install docker
iptables -P FORWARD ACCEPT
chmod a+x init-docker.sh
bash init-docker.sh

if [ $? != 0 ]; then
   error "====init docker failed!===="
fi

chmod a+x init-cri-dockerd.sh
bash init-cri-dockerd.sh
if [ $? != 0 ]; then
   error "====init cri dockerd failed!===="
fi

chmod a+x init-shim.sh
bash init-shim.sh

if [ $? != 0 ]; then
   error "====init image-cri-shim failed!===="
fi

chmod a+x init-kube.sh
bash init-kube.sh

logger "init docker rootfs success"
