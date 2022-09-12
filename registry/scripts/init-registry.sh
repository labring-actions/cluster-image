#!/bin/bash
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
