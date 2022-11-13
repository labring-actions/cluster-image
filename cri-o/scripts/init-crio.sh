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

TARBALL=cri-o.tar.gz
TMPDIR="$(mktemp -d)"
trap 'rm -rf -- "$TMPDIR"' EXIT

tar xfz ../cri/cri-o.tar.gz --strip-components=1 -C "$TMPDIR"
pushd "$TMPDIR"
echo Installing CRI-O
./install
popd
# Use other network plugin, eg: calico.
rm -rf /etc/cni/net.d/10-crio-bridge.conf

cp ../etc/99-crio.conf /etc/crio/crio.conf.d/
base64pwd=$(echo -n "${registry_username}:${registry_password}" | base64)
logger "username: $registry_username, password: $registry_password, base64pwd: $base64pwd"
cat > /etc/crio/config.json << eof
{
        "auths": {
                "$registry_domain:$registry_port": {
                        "auth": "$base64pwd"
                }
        }
}
eof

systemctl enable --now crio.service
check_status crio
logger "init crio success"
