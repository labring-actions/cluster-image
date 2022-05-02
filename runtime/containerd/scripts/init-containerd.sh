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
storage=${1:-/var/lib/containerd}
registry_domain=${2:-sealos.hub}
registry_port=${3:-5000}
username=${4:-}
password=${5:-}

mkdir -p $storage
if ! [ -x /usr/bin/crictl ]; then
  mkdir -p /opt/containerd && tar -zxf ../cri/lib64/containerd-lib.tar.gz -C /opt/containerd
  echo "/opt/containerd/lib" > /etc/ld.so.conf.d/containerd.conf
  ldconfig
  [ -d  /etc/containerd/certs.d/ ] || mkdir /etc/containerd/certs.d/  -p
  cp ../etc/containerd.service /etc/systemd/system/
  chmod -R 755 ../cri
  tar -zxf ../cri/cri-containerd-linux.tar.gz -C /
  cp -f ../cri/nerdctl /usr/bin/
  chmod a+x /usr/bin/*
  systemctl enable containerd.service
  cp ../etc/config.toml /etc/containerd
  sed -i "s#__options__##g" /etc/containerd/config.toml
  sed -i "s/sealos.hub:5000/$registry_domain:$registry_port/g" /etc/containerd/config.toml
  sed -i "s#/var/lib/containerd#$storage#g" /etc/containerd/config.toml
  sed -i "s#__username__#$username#g" /etc/containerd/config.toml
  sed -i "s#__password__#$password#g" /etc/containerd/config.toml
  mkdir -p /etc/containerd/certs.d/$registry_domain:$registry_port
  cp ../etc/hosts.toml /etc/containerd/certs.d/$registry_domain:$registry_port
  sed -i "s/sealos.hub:5000/$registry_domain:$registry_port/g" /etc/containerd/certs.d/$registry_domain:$registry_port/hosts.toml
  systemctl restart containerd.service
fi
systemctl daemon-reload
systemctl restart containerd.service
check_status containerd
logger "init containerd success"
