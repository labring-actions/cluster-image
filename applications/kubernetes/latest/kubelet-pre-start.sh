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

# First modprobe
cat <<EOF | xargs modprobe
bridge
ip_vs
EOF
# Open ipvs
cat <<EOF | xargs modprobe
ip_vs_rr
ip_vs_wrr
ip_vs_sh
EOF
# 1.20 need open br_netfilter
cat <<EOF | xargs modprobe
br_netfilter
EOF
# Kernel 4.19 has rebranded nf_conntrack_ipv4 to nf_conntrack
if ! modprobe -- nf_conntrack >/dev/null 2>&1; then
  modprobe -- nf_conntrack_ipv4
fi

sysctl --system
swapoff --all || true

if grep SELINUX=enforcing /etc/selinux/config >/dev/null 2>&1; then
  sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
  setenforce 0
fi

kubelet_config_file="/var/lib/kubelet/config.yaml"
echo "Updating kubelet config ${kubelet_config_file}"
if [ -f ${kubelet_config_file} ]; then
    sed -i 's/  imagefs.available:.*/  imagefs.available: 0%/g' ${kubelet_config_file}
    sed -i 's/  nodefs.available:.*/  nodefs.available: 0%/g' ${kubelet_config_file}
    echo "Update kubelet config ${kubelet_config_file} success"
else
    echo "Waiting for kubelet config ${kubelet_config_file} to be generated"
fi
