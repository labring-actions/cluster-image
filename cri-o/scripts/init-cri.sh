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
registry_domain=${1:-sealos.hub}
registry_port=${2:-5000}
registry_username=${3:-}
registry_password=${4:-}
# Install cri-o
chmod a+x init-crio.sh
bash init-crio.sh ${registry_domain} ${registry_port} ${registry_username} ${registry_password}

if [ $? != 0 ]; then
   error "====init crio failed!===="
fi

logger "init crio success"
