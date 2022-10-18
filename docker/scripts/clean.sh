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
dockerStorage=${1:-/var/lib/docker}
criDockerStorage=${2:-/var/lib/cri-dockerd}
chmod a+x clean-kube.sh
chmod a+x clean-docker.sh
chmod a+x clean-shim.sh
chmod a+x clean-cri-dockerd.sh

bash clean-kube.sh
bash clean-shim.sh
bash clean-cri-dockerd.sh $criDockerStorage
bash clean-docker.sh $dockerStorage
logger "clean docker rootfs success"
