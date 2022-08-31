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
systemctl stop image-cri-shim
systemctl disable image-cri-shim
rm -rf /etc/systemd/system/image-cri-shim.service
systemctl daemon-reload
rm -f /usr/bin/image-cri-shim
rm -f /etc/image-cri-shim.yaml
rm -f /var/lib/image-cri-shim
logger "clean shim success"
