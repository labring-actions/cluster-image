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
storage=${1:-/var/lib/docker}
registry_domain=${2:-sealos.hub}
registry_port=${3:-5000}
username=${4:-}
password=${5:-}
mkdir -p $storage
if ! command_exists docker; then
  lsb_dist=$( get_distribution )
  lsb_dist="$(echo "$lsb_dist" | tr '[:upper:]' '[:lower:]')"
  echo "current system is $lsb_dist"
  case "$lsb_dist" in
    alios)
      ip link add name docker0 type bridge
      ip addr add dev docker0 172.17.0.1/16
    ;;
  esac

  [ -d  /etc/docker/ ] || mkdir /etc/docker/  -p
  cp ../etc/docker.service /etc/systemd/system/
  chmod -R 755 ../cri
  tar -zxvf ../cri/docker.tar.gz -C /usr/bin
  chmod a+x /usr/bin/*
  systemctl enable docker.service
  systemctl restart docker.service
  cp ../etc/daemon.json /etc/docker
  sed -i "s/sealos.hub:5000/$registry_domain:$registry_port/g" /etc/docker/daemon.json
  sed -i "s#/var/lib/docker#$1#g" /etc/docker/daemon.json
fi
disable_selinux
systemctl daemon-reload
systemctl restart docker.service
check_status docker
logger "init docker success"

