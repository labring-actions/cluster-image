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
# prepare registry storage as directory
cd $(dirname $0)

VOLUME=${1:-/var/lib/registry}
CONFIG=${2:-/etc/registry}
container=sealos-registry
htpasswd="$CONFIG/registry_htpasswd"
config="$CONFIG/registry_config.yml"

[ -d $VOLUME ] || mkdir $VOLUME
[ -d $CONFIG ] || mkdir $CONFIG

cp ../etc/registry_config.yml $config
[ -f ../etc/registry_htpasswd  ] && cp  ../etc/registry_htpasswd $htpasswd

cp -rf ../etc/registry.service /etc/systemd/system/
chmod -R 755 ../cri
cp -rf ../cri/registry /usr/bin
chmod a+x /usr/bin/*
systemctl enable registry.service
systemctl daemon-reload
systemctl restart registry.service
check_status registry
logger "init registry success"
