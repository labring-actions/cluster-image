#!/bin/bash
source common.sh
# prepare registry storage as directory
VOLUME=${1:-/var/lib/registry}
CONFIG=${2:-/etc/registry}
systemctl stop registry
systemctl disable registry
rm -rf /etc/systemd/system/registry.service
systemctl daemon-reload
rm -f /usr/bin/registry
rm -rf $VOLUME
rm -rf $CONFIG
rm -rf /etc/registry.yml
logger "clean registry success"
