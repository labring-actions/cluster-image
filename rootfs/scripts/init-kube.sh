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
# Open ipvs
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
# 1.20 need open br_netfilter
modprobe -- br_netfilter
modprobe -- bridge

kernel_version=$(uname -r | cut -d- -f1)
if version_ge "${kernel_version}" 4.19; then
  modprobe -- nf_conntrack
else
  modprobe -- nf_conntrack_ipv4
fi

# localhost for hosts
grep 127.0.0.1 <(grep localhost /etc/hosts) || echo "127.0.0.1 localhost" >>/etc/hosts
grep ::1 <(grep localhost /etc/hosts) || echo "::1 localhost" >>/etc/hosts

cat <<EOF >/etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.conf.all.rp_filter=0
EOF
sysctl --system
sysctl -w net.ipv4.ip_forward=1
disable_firewalld
swapoff -a || true
disable_selinux

chmod -R 755 ../bin/*
chmod 644 ../bin
cp -a ../bin/* /usr/bin
cp -a ../scripts/kubelet-pre-start.sh /usr/bin
cp -a ../scripts/kubelet-post-stop.sh /usr/bin
mkdir -p /etc/systemd/system
cp ../etc/kubelet.service /etc/systemd/system/
[ -d /etc/systemd/system/kubelet.service.d ] || mkdir /etc/systemd/system/kubelet.service.d
cp ../etc/10-kubeadm.conf /etc/systemd/system/kubelet.service.d/
[ -d /var/lib/kubelet ] || mkdir /var/lib/kubelet
cp ../etc/kubelet-flags.env /var/lib/kubelet
systemctl enable kubelet
logger "init kubelet success"
