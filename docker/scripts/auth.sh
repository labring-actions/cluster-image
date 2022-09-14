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
REGISTRY_DOMAIN=${1:-sealos.hub}
REGISTRY_PORT=${2:-5000}
REGISTRY_USERNAME=${3:-}
REGISTRY_PASSWORD=${4:-}

docker login --username  ${REGISTRY_USERNAME}  --password ${REGISTRY_PASSWORD} ${REGISTRY_DOMAIN}:${REGISTRY_PORT}
crictl pull __pause__
